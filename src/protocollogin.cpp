////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////
#include "otpch.h"
#include <iomanip>

#include "protocollogin.h"
#include "tools.h"

#include "iologindata.h"
#include "ioban.h"

#include "outputmessage.h"
#include "connection.h"
#ifdef __LOGIN_SERVER__
#include "gameservers.h"
#endif

#include "configmanager.h"
#include "game.h"

extern ConfigManager g_config;
extern Game g_game;
extern IpList serverIps;

#ifdef __ENABLE_SERVER_DIAGNOSTIC__
uint32_t ProtocolLogin::protocolLoginCount = 0;
#endif

void ProtocolLogin::deleteProtocolTask()
{
#ifdef __DEBUG_NET_DETAIL__
	std::clog << "Deleting ProtocolLogin" << std::endl;
#endif
	Protocol::deleteProtocolTask();
}

void ProtocolLogin::disconnectClient(uint8_t error, const char* message)
{
	OutputMessage_ptr output = OutputMessagePool::getInstance()->getOutputMessage(this, false);
	if(output)
	{
		TRACK_MESSAGE(output);
		output->put<char>(error);
		output->putString(message);
		OutputMessagePool::getInstance()->send(output);
	}

	getConnection()->close();
}

bool ProtocolLogin::parseFirstPacket(NetworkMessage& msg)
{
	if(g_game.getGameState() == GAMESTATE_SHUTDOWN)
	{
		getConnection()->close();
		return false;
	}

	uint32_t clientIp = getConnection()->getIP();
	/*uint16_t operatingSystem =*/ msg.get<uint16_t>();
	uint16_t version = msg.get<uint16_t>();

	msg.skip(12);

	if(version <= 760)
		disconnectClient(0x0A, CLIENT_VERSION_STRING);

	if(!RSA_decrypt(msg))
	{
		getConnection()->close();
		return false;
	}

	uint32_t key[4] = {msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>(), msg.get<uint32_t>()};
	enableXTEAEncryption();
	setXTEAKey(key);

	uint32_t accnumber = msg.get<uint32_t>();
	std::string password = msg.getString();
	if(!accnumber)
	{
		if(!g_config.getBool(ConfigManager::ACCOUNT_MANAGER))
		{
			disconnectClient(0x0A, "Invalid account number.");
			return false;
		}

		accnumber = 1;
		password = "1";
	}

	if(version < CLIENT_VERSION_MIN || version > CLIENT_VERSION_MAX)
	{
		disconnectClient(0x0A, CLIENT_VERSION_STRING);
		return false;
	}

	if(g_game.getGameState() < GAMESTATE_NORMAL)
	{
		disconnectClient(0x0A, "Server is just starting up, please wait.");
		return false;
	}

	if(g_game.getGameState() == GAMESTATE_MAINTAIN)
	{
		disconnectClient(0x0A, "Server is under maintenance, please re-connect in a while.");
		return false;
	}

	if(ConnectionManager::getInstance()->isDisabled(clientIp))
	{
		disconnectClient(0x0A, "Too many connections attempts from your IP address, please try again later.");
		return false;
	}

	if(IOBan::getInstance()->isIpBanished(clientIp))
	{
		disconnectClient(0x0A, "Your IP is banished!");
		return false;
	}

	uint32_t serverIp = serverIps[0].first;
	for(IpList::iterator it = serverIps.begin(); it != serverIps.end(); ++it)
	{
		if((it->first & it->second) != (clientIp & it->second))
			continue;

		serverIp = it->first;
		break;
	}


	Account account = IOLoginData::getInstance()->loadAccount(accnumber);
	//if(!encryptTest(password, account.password))
	if(!(accnumber != 0 && account.number == accnumber &&
		encryptTest(password, account.password)))
	{
		ConnectionManager::getInstance()->addLoginAttempt(clientIp, false);
		disconnectClient(0x0A, "Account number or password is not correct.");
		return false;
	}

	Ban ban;
	ban.value = account.number;

	ban.type = BAN_ACCOUNT;
	if(IOBan::getInstance()->getData(ban) && !IOLoginData::getInstance()->hasFlag(account.number, PlayerFlag_CannotBeBanned))
	{
		bool deletion = ban.expires < 0;
		std::string name_ = "Automatic ";
		if(!ban.adminId)
			name_ += (deletion ? "deletion" : "banishment");
		else
			IOLoginData::getInstance()->getNameByGuid(ban.adminId, name_, true);

		std::stringstream ss;
		ss << "Your account has been " << (deletion ? "deleted" : "banished") << " at:\n" << formatDateEx(ban.added, "%d %b %Y").c_str()
			<< " by: " << name_.c_str() << ".\nThe comment given was:\n" << ban.comment.c_str() << ".\nYour " << (deletion ?
			"account won't be undeleted" : "banishment will be lifted at:\n") << (deletion ? "" : formatDateEx(ban.expires).c_str()) << ".";

		disconnectClient(0x0A, ss.str().c_str());
		return false;
	}

	//Remove premium days
	#ifndef __LOGIN_SERVER__
	IOLoginData::getInstance()->removePremium(account);
	if(!g_config.getBool(ConfigManager::ACCOUNT_MANAGER) && !account.charList.size())
	{
		disconnectClient(0x0A, std::string("This account does not contain any character yet.\nCreate a new character on the "
			+ g_config.getString(ConfigManager::SERVER_NAME) + " website at " + g_config.getString(ConfigManager::URL) + ".").c_str());
		return false;
	}
	#else
	Characters charList;
	for(Characters::iterator it = account.charList.begin(); it != account.charList.end(); ++it)
	{
		if(version >= it->second.server->getVersionMin() && version <= it->second.server->getVersionMax())
			charList[it->first] = it->second;
	}

	IOLoginData::getInstance()->removePremium(account);
	if(!g_config.getBool(ConfigManager::ACCOUNT_MANAGER) && !charList.size())
	{
		disconnectClient(0x0A, std::string("This account does not contain any character on this client yet.\nCreate a new character on the "
			+ g_config.getString(ConfigManager::SERVER_NAME) + " website at " + g_config.getString(ConfigManager::URL) + ".").c_str());
		return false;
	}
	#endif

	ConnectionManager::getInstance()->addLoginAttempt(clientIp, true);
	if(OutputMessage_ptr output = OutputMessagePool::getInstance()->getOutputMessage(this, false))
	{
		TRACK_MESSAGE(output);
		output->put<char>(0x14);

		char motd[750];
		sprintf(motd, "%d\n%s", g_game.getMotdId(), g_config.getString(ConfigManager::MOTD).c_str());
		output->putString(motd);

		//Add char list
		output->put<char>(0x64);
		if(g_config.getBool(ConfigManager::ACCOUNT_MANAGER) && accnumber != 1)
		{
			output->put<char>(account.charList.size() + 1);
			output->putString("Account Manager");
			output->putString(g_config.getString(ConfigManager::SERVER_NAME));
			output->put<uint32_t>(serverIp);
			output->put<uint16_t>(g_config.getNumber(ConfigManager::LOGIN_PORT));
		}
		else
			output->put<char>((uint8_t)account.charList.size());

		#ifndef __LOGIN_SERVER__
		for(Characters::iterator it = account.charList.begin(); it != account.charList.end(); it++)
		{
			output->putString((*it));
			if(g_config.getBool(ConfigManager::ON_OR_OFF_CHARLIST))
			{
				if(g_game.getPlayerByName((*it)))
					output->putString("Online");
				else
					output->putString("Offline");
			}
			else
				output->putString(g_config.getString(ConfigManager::SERVER_NAME));

			output->put<uint32_t>(serverIp);
			output->put<uint16_t>(g_config.getNumber(ConfigManager::LOGIN_PORT));
		}
		#else
		for(Characters::iterator it = charList.begin(); it != charList.end(); ++it)
		{
			output->putString(it->second.name);
			if(!g_config.getBool(ConfigManager::ON_OR_OFF_CHARLIST) || it->second.status < 0)
				output->putString(it->second.server->getName());
			else if(it->second.status)
				output->putString("Online");
			else
				output->putString("Offline");

			output->put<uint32_t>(it->second.server->getAddress());
			IntegerVec games = it->second.server->getPorts();
			output->put<uint16_t>(games[random_range(0, games.size() - 1)]);
		}
		#endif

		//Add premium days
		if(g_config.getBool(ConfigManager::FREE_PREMIUM))
			output->put<uint16_t>(65535); //client displays free premium
		else
			output->put<uint16_t>(account.premiumDays);

		OutputMessagePool::getInstance()->send(output);
	}

	getConnection()->close();
	return true;
}
