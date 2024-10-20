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

#ifndef __NETWORK_MESSAGE__
#define __NETWORK_MESSAGE__


#include "definitions.h"
#include "otsystem.h"
#include "const.h"

class Item;
class Creature;
class Player;
class Position;

class NetworkMessage
{
	public:
		NetworkMessage() {reset();}
		virtual ~NetworkMessage() {}

		// resets the internal buffer to an empty message
		void reset()
		{
			m_size = 0;
			m_position = NETWORK_CRYPTOHEADER_SIZE;
		}

	public:
		// simply read functions for incoming message
		template<typename T>
		T get(bool peek = false)
		{
			T value = *(T*)(m_buffer + m_position);
			if(peek)
				return value;

			m_position += sizeof(T);
			return value;
		}

		std::string getString(bool peek = false, uint16_t size = 0);
		std::string getRaw(bool peek = false) {return getString(peek, m_size - m_position);}

		// read for complex types
		Position getPosition();
	
		// skips count unknown/unused bytes in an incoming message
		void skip(int32_t count) {m_position += count;}
	
		// simply write functions for outgoing message
		template<typename T>
		void put(T value)
		{
			if(!hasSpace(sizeof(T)))
				return;

			*(T*)(m_buffer + m_position) = value;
			m_position += sizeof(T);
			m_size += sizeof(T);
		}

		void putString(const std::string& value, bool addSize = true) {putString(value.c_str(), addSize);}
		void putString(const char* value, bool addSize = true);

		void putPadding(uint32_t amount);

		// write functions for complex types
		void putPosition(const Position& pos);
		void AddItem(uint16_t id, uint8_t count);
		void AddItem(const Item* item);
		void putItemId(const Item* item);
		void putItemId(uint16_t itemId);
	
		// message propeties functions
	  	uint16_t size() const {return m_size;}
		void setSize(uint16_t size) {m_size = size;}

		uint16_t position() const {return m_position;}
		void setPosition(uint16_t position) {m_position = position;}

		char* buffer() {return (char*)&m_buffer[0];}
		char* bodyBuffer()
		{
			m_position = NETWORK_HEADER_SIZE;
			return (char*)&m_buffer[NETWORK_HEADER_SIZE];
		}

		int32_t decodeHeader();

	protected:
		// used to check available space while writing
		inline bool hasSpace(int32_t size) {return (size + m_position < NETWORK_MAX_SIZE - 16);}

		int32_t m_size;
		int32_t m_position;

		uint8_t m_buffer[NETWORK_MAX_SIZE];
};

#endif // #ifndef __NETWORK_MESSAGE_H__
