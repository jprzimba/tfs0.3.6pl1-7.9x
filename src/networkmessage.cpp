//////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
//////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software Foundation,
// Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//////////////////////////////////////////////////////////////////////
#include "otpch.h"

#include <string>
#include <iostream>

#include "networkmessage.h"

#include "container.h"
#include "creature.h"
#include "player.h"

#include "position.h"
#include "rsa.h"

/******************************************************************************/
std::string NetworkMessage::getString(bool peek/* = false*/, uint16_t size/* = 0*/)
{
	if(!size)
		size = get<uint16_t>(peek);

	uint16_t position = m_position;
	if(peek)
		position += 2;

	if(size >= (16384 - position))
		return std :: string();

	char* v = (char*)(m_buffer + position);
	if(peek)
		return std::string(v, size);

	m_position += size;
	return std::string(v, size);
}

Position NetworkMessage::getPosition()
{
	Position pos;
	pos.x = get<uint16_t>();
	pos.y = get<uint16_t>();
	pos.z = get<char>();
	return pos;
}

/******************************************************************************/
void NetworkMessage::putString(const char* value, bool addSize/* = true*/)
{
	uint32_t size = (uint32_t)strlen(value);
	if(!hasSpace(size + (addSize ? 2 : 0)) || size > 8192)
		return;

	if(addSize)
		put<uint16_t>(size);

	strcpy((char*)(m_buffer + m_position), value);
	m_position += size;
	m_size += size;
}

void NetworkMessage::putPadding(uint32_t amount)
{
	if(!hasSpace(amount))
		return;

	memset((void*)&m_buffer[m_position], 0x33, amount);
	m_size += amount;
}

void NetworkMessage::putPosition(const Position& pos)
{
	put<uint16_t>(pos.x);
	put<uint16_t>(pos.y);
	put<char>(pos.z);
}

void NetworkMessage::AddItem(uint16_t id, uint8_t count)
{
	const ItemType &it = Item::items[id];
	put<uint16_t>(it.clientId);
	if(it.stackable || it.isRune())
		put<char>(count);
	else if(it.isSplash() || it.isFluidContainer())
	{
		uint32_t fluidIndex = count % 8;
		put<char>(fluidMap[fluidIndex]);
	}
}

void NetworkMessage::AddItem(const Item* item)
{
	const ItemType &it = Item::items[item->getID()];
	put<uint16_t>(it.clientId);
	if(it.stackable || it.isRune())
		put<char>(item->getSubType());
	else if(it.isSplash() || it.isFluidContainer())
	{
		uint32_t fluidIndex = item->getSubType() % 8;
		put<char>(fluidMap[fluidIndex]);
	}
}

void NetworkMessage::putItemId(const Item* item)
{
	const ItemType &it = Item::items[item->getID()];
	put<uint16_t>(it.clientId);
}

void NetworkMessage::putItemId(uint16_t itemId)
{
	const ItemType &it = Item::items[itemId];
	put<uint16_t>(it.clientId);
}

int32_t NetworkMessage::decodeHeader()
{
 	int32_t size = (int32_t)(m_buffer[0] | m_buffer[1] << 8);
	m_size = size;
	return size;
}
