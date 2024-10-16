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

#include "cylinder.h"
VirtualCylinder* VirtualCylinder::virtualCylinder = new VirtualCylinder;

int32_t Cylinder::__getIndexOfThing(const Thing* thing) const
{
	return -1;
}

int32_t Cylinder::__getFirstIndex() const
{
	return -1;
}

int32_t Cylinder::__getLastIndex() const
{
	return -1;
}

Thing* Cylinder::__getThing(uint32_t index) const
{
	return NULL;
}

uint32_t Cylinder::__getItemTypeCount(uint16_t itemId, int32_t subType /*= -1*/, bool itemCount /*= true*/) const
{
	return 0;
}

void Cylinder::__internalAddThing(Thing* thing)
{
	//
}

void Cylinder::__internalAddThing(uint32_t index, Thing* thing)
{
	//
}
