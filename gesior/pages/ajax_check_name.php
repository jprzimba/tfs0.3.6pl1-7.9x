<?php
if(!defined('INITIALIZED'))
    exit;

echo '<?xml version="1.0" encoding="utf-8" standalone="yes"?>';
$name = strtolower(trim($_REQUEST['name']));
if(empty($name))
{
    echo '<font color="red">Please enter new character name.</font>';
    exit;
}

// Check minimum length for the name
if(strlen($name) < 2) {
    echo '<font color="red">Name is too short. Minimum 2 characters required.</font>';
    exit;
}

// Blocked words at the beginning of the name
$first_words_blocked = array('gm ','cm ', 'god ','tutor ', "'", '-');

// Blocked exact names
$names_blocked = array('gm','cm', 'god', 'tutor');

// Blocked words that the name cannot contain
$words_blocked = array('gamemaster', 'game master', 'game-master', "game'master", '  ', '--', "''","' ", " '", '- ', ' -', "-'", "'-", 'fuck', 'sux', 'suck', 'noob', 'tutor');

// Validate that the name only contains allowed characters
$temp = strspn("$name", "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM- '");
if($temp != strlen($name))
{
    echo '<font color="red">Name contains illegal letters. Use only: <b>qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM- \'</b></font>';
    exit;
}

// Check if the name is too long (more than 25 characters)
if(strlen($name) > 25)
{
    echo '<font color="red">Too long name. Max. length <b>25</b> letters.</font>';
    exit;
}

// Block exact names
foreach($names_blocked as $word)
    if($word == $name)
    {
        echo '<font color="red">Blocked names:<b> '.$names_blocked[0];
        if(count($names_blocked) > 1)
            foreach($names_blocked as $word)
                if($word != $names_blocked[0])
                    echo ','.$word;
        echo '</b></font>';
        exit;
    }

// Block names that start with certain words
foreach($first_words_blocked as $word)
    if($word == substr($name, 0, strlen($word)))
    {
        echo '<font color="red">First letters in name can\'t be:<b> '.$first_words_blocked[0];
        if(count($first_words_blocked) > 1)
            foreach($first_words_blocked as $word)
                if($word != $first_words_blocked[0])
                    echo ','.$word;
        echo '</b></font>';
        exit;
    }

// Check if the last character is an apostrophe or hyphen
if(substr($name, -1) == "'" || substr($name, -1) == "-")
{
    echo '<font color="red">Last letter can\'t be <b>\'</b> or <b>-</b></font>';
    exit;
}

// Block names that contain certain words
foreach($words_blocked as $word)
    if (strpos($name, $word) !== false)
    {
        echo '<font color="red">Name can\'t contain words:<b> '.$words_blocked[0];
        if(count($words_blocked) > 1)
            foreach($words_blocked as $word)
                if($word != $words_blocked[0])
                    echo ','.$word;
        echo '</b></font>';
        exit;
    }

// Check if the name contains three consecutive identical letters
for($i = 0; $i < strlen($name); $i++) {
    if ($i + 2 < strlen($name) && $name[$i] == $name[($i+1)] && $name[$i] == $name[($i+2)]) {
        echo '<font color="red">Name can\'t contain 3 same letters one by one.</font><br /><font color="green"><u>Good:</u> M<b>oo</b>nster</font><font color="red"><br />Wrong: M<b>ooo</b>nster</font>';
        exit;
    }

    // Check if there are double spaces in the name
    if ($i > 0 && $i + 1 < strlen($name) && $name[$i-1] == ' ' && $name[$i+1] == ' ') {
        echo '<font color="red">Use normal name format.</font><br /><font color="green"><u>Good:</u> <b>Gesior</b></font><font color="red"><br />Wrong: <b>G e s ior</b></font>';
        exit;
    }
}

// Check if the second character is a space
if(strlen($name) > 1 && substr($name, 1, 1) == ' ')
{
    echo '<font color="red">Use normal name format.</font><br /><font color="green"><u>Good:</u> <b>Gesior</b></font><font color="red"><br />Wrong: <b>G esior</b></font>';
    exit;
}

// Check if the second-to-last character is a space
if(strlen($name) > 2 && substr($name, -2, 1) == " ")
{
    echo '<font color="red">Use normal name format.</font><br /><font color="green"><u>Good:</u> <b>Gesior</b></font><font color="red"><br />Wrong: <b>Gesio r</b></font>';
    exit;
}

// Check if the name already exists in the database
$name_db = new Player();
$name_db->find($name);
if($name_db->isLoaded())
    echo '<font color="red"><b>Player with this name already exists.</b></font>';
else
    echo '<font color="green">Good. Your name will be:<br />"<b>'.htmlspecialchars(ucwords($name)).'</b>"</font>';
exit;
