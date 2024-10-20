<?php
if(!defined('INITIALIZED'))
	exit;

// Variables
$number_of_rows = 0;

if(count($config['site']['worlds']) > 1)
{
	foreach($config['site']['worlds'] as $idd => $world_n)
	{
		if($idd == (int) $_REQUEST['world'])
		{
			$world_id = $idd;
			$world_name = $world_n;
		}
	}
}
if(!isset($world_id))
{
	$world_id = 0;
	$world_name = $config['server']['serverName'];
}
if(count($config['site']['worlds']) > 1)
{
	$main_content .= '<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH=100%><TR><TD></TD><TD>
	<FORM ACTION="" METHOD=get><INPUT TYPE="hidden" NAME="subtopic" VALUE="houses"><TABLE WIDTH=100% BORDER=0 CELLSPACING=1 CELLPADDING=4><TR><TD BGCOLOR="'.$config['site']['vdarkborder'].'" CLASS=white><B>World Selection</B></TD></TR><TR><TD BGCOLOR="'.$config['site']['darkborder'].'">
	<TABLE BORDER=0 CELLPADDING=1><TR><TD>Houses on world:</TD><TD><SELECT SIZE="1" NAME="world">';
	foreach($config['site']['worlds'] as $id => $world_n)
	{
		if($id == $world_id)
			$main_content .= '<OPTION VALUE="'.htmlspecialchars($id).'" selected="selected">'.htmlspecialchars($world_n).'</OPTION>';
		else
			$main_content .= '<OPTION VALUE="'.htmlspecialchars($id).'">'.htmlspecialchars($world_n).'</OPTION>';
	}
	$main_content .= '</SELECT> </TD><TD><INPUT TYPE="image" NAME="Submit" ALT="Submit" SRC="'.$layout_name.'/images/buttons/sbutton_submit.gif">
		</TD></TR></TABLE></TABLE></FORM></TABLE>';
}
$main_content .= '<center><h2>Houses</h2></center>';

$main_content .= '<form action="" method="GET"><input type="hidden" name="subtopic" value="houses" /><table width="100%"><tr style="background-color:' . $config['site']['vdarkborder'] . ';font-weight:bold"><td style="color:white">Town</td><td style="color:white">Owner</td><td style="color:white">Sort by</td></tr>';
$main_content .= '<tr><td style="vertical-align:top">';

$selected_town = 1;
if(isset($_REQUEST['town']))
	$selected_town = $_REQUEST['town'];
foreach($towns_list[$world_id] as $town_id => $town_name)
{
	$main_content .= '<input type="radio" name="town" value="' . $town_id . '" id="radio_t' . $town_id . '" ' . (($selected_town == $town_id) ? 'checked="checked"' : '') . '/><label for="radio_t' . $town_id . '">' . htmlspecialchars($town_name) . '</label><br />';
}
$main_content .= '</td>';


$selected_owner = 2;
if(isset($_REQUEST['owner']))
	$selected_owner = $_REQUEST['owner'];
$main_content .= '<td style="vertical-align:top">';
$main_content .= '<input type="radio" name="owner" value="2" id="radio_o2" ' . (($selected_owner == 2) ? 'checked="checked"' : '') . '/><label for="radio_o2">All</label><br />';
$main_content .= '<input type="radio" name="owner" value="0" id="radio_o0" ' . (($selected_owner == 0) ? 'checked="checked"' : '') . '/><label for="radio_o0">Empty</label><br />';
$main_content .= '<input type="radio" name="owner" value="1" id="radio_o1" ' . (($selected_owner == 1) ? 'checked="checked"' : '') . '/><label for="radio_o1">Rented</label>';
$main_content .= '</td>';


$selected_order = 'name';
if(isset($_REQUEST['order']))
	$selected_order = $_REQUEST['order'];
$main_content .= '<td style="vertical-align:top">';
$main_content .= '<input type="radio" name="order" value="name" id="radio_s0" ' . (($selected_order == 'name') ? 'checked="checked"' : '') . '/><label for="radio_s0">Name</label><br />';
$main_content .= '<input type="radio" name="order" value="size" id="radio_s1" ' . (($selected_order == 'size') ? 'checked="checked"' : '') . '/><label for="radio_s1">Size</label>';


$main_content .= '</td></tr>';
$main_content .= '<tr><td colspan="3" style="text-align:right"><input type="image" name="Submit" alt="Submit" src="'.$layout_name.'/images/buttons/sbutton_submit.gif"></td></tr></table></form>';

if(isset($_REQUEST['town']) && isset($_REQUEST['owner']) && isset($_REQUEST['order']))
{
	$houses = new DatabaseList('House');
	$filterTown = new SQL_Filter(new SQL_Field('town'), SQL_Filter::EQUAL, $_REQUEST['town']);

	if($_REQUEST['owner'] == 0)
	{
		$filterOwner = new SQL_Filter(new SQL_Field('owner'), SQL_Filter::EQUAL, 0);
		$filter = new SQL_Filter($filterTown, SQL_Filter::CRITERIUM_AND, $filterOwner);
	}
	elseif($_REQUEST['owner'] == 1)
	{
		$filterOwner = new SQL_Filter(new SQL_Field('owner'), SQL_Filter::NOT_EQUAL, 0);
		$filter = new SQL_Filter($filterTown, SQL_Filter::CRITERIUM_AND, $filterOwner);
	}
	else
	{
		$filter = $filterTown;
	}

	$houses->setFilter(new SQL_Filter(new SQL_Filter(new SQL_Field('world_id'), SQL_Filter::EQUAL, $world_id), SQL_Filter::CRITERIUM_AND, $filter));

	if($_REQUEST['order'] == 'size')
		$houses->addOrder(new SQL_Order(new SQL_Field('size', 'houses'), SQL_Order::DESC));
	else
		$houses->addOrder(new SQL_Order(new SQL_Field('name', 'houses')));

	$housesText = '';

	if(count($houses) > 0)
	{
		// let's load house owners, all by 1 query
		$ownersIds = array();

		foreach($houses as $house)
		{
			if($house->getOwner() != 0)
				$ownersIds[] = $house->getOwner();
		}

		$owners = array();

		if(count($ownersIds) > 0)
		{
			$ownersList = new DatabaseList('Player');
			$ownersList->data = $SQL->query('SELECT * FROM ' . $SQL->tableName('players') . ' WHERE ' . $SQL->fieldName('id') . ' IN (' . implode(',', $ownersIds) . ');')->fetchAll();
			foreach($ownersList as $owner)
			{
				$owners[$owner->getID()] = $owner;
			}
		}

		foreach($houses as $i => $house)
		{
			$bgcolor = (($number_of_rows++ % 2 == 1) ?  $config['site']['darkborder'] : $config['site']['lightborder']);
			$housesText .= '<tr bgcolor="' . $bgcolor . '"><td>' . htmlspecialchars($house->getName()) . '</td>';
			if($house->getOwner() != 0)
			{
				if(is_object($owners[$house->getOwner()]))
					$housesText .= '<td><a href="?subtopic=characters&name=' . urlencode($owners[$house->getOwner()]->getName()) . '">' . htmlspecialchars($owners[$house->getOwner()]->getName()) . '</a></td>';
				else
					$housesText .= '<td>Bugged house owner</td>';
			}
			else
				$housesText .= '<td>Empty (' . ($house->getSize() * $config['server']['housePriceEachSquare']) . ' gp)</td>';
			$housesText .= '<td>' . $house->getSize() . ' sqm</td></tr>';
		}
	}
	else
	{
		$bgcolor = (($number_of_rows++ % 2 == 1) ?  $config['site']['darkborder'] : $config['site']['lightborder']);
		$housesText .= '<tr bgcolor="' . $bgcolor . '"><td colspan="3">No houses with selected parameters.</td></tr>';
	}

	// now we can show houses list
	$main_content .= '<table width="100%"><tr style="background-color:' . $config['site']['vdarkborder'] . ';font-weight:bold"><td style="color:white">Name</td><td style="color:white">Owner</td><td style="color:white">Size</td></tr>' . $housesText . '</table>';
}