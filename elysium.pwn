//																			//
//							Trinity-Xtreme									//
//											Freeroam Project				//
//																			//
//									Started at 2013-01-27 - 01:52 UTC+2		//
//									Gamemode by naphteine (aka. ImmortaL)	//
// 									Map & art by Crosscuk					//
//																			//

// Library include
#include <a_samp>

// Server settings
#undef MAX_PLAYERS

#define server_name		"Trinity-Xtreme Freeroam"
#define server_version	"1.0.0"
#define server_modname	"Elysium"
#define server_mapname	"San Andreas"
#define server_lang		"English"
#define MAX_PLAYERS		(50)

// Global variables
new Text:textdraw;

// Main
main()
{
	SkyAntiDeAMX();
	printf("Sky Anti-DeAMX (2) initialized.");

	printf("Gamemode initialized.");
}

// Callbacks
public OnGameModeInit()
{
	// AntiDeAMX
	SkyAntiDeAMX();
	printf("Sky Anti-DeAMX (1) initialized.");

	// Server settings
	new tmp[64];

	SendRconCommand("rcon 0");

	SetGameModeText(server_modname " " server_version);

	format(tmp, sizeof(tmp), "hostname %s", server_name);
	SendRconCommand(tmp);

	format(tmp, sizeof(tmp), "mapname %s", server_mapname);
	SendRconCommand(tmp);

	format(tmp, sizeof(tmp), "language %s", server_lang);
	SendRconCommand(tmp);

	printf("Server settings initialized.");

	// Create the bottom textdraw
	textdraw = TextDrawCreate(320.0, 400.0, "Elysium");
	TextDrawFont(textdraw, 3);
	TextDrawLetterSize(textdraw, 0.3, 1.0);
	TextDrawAlignment(textdraw, 2);
	TextDrawColor(textdraw, 0xFF0000FF);
	TextDrawSetOutline(textdraw, 1);
	TextDrawSetShadow(textdraw, 1);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new playerVehicle;
	if (strcmp(cmdtext, "/teleport", true) == 0)
	{
		// Teleport the player to a predefined location
		SetPlayerPos(playerid, 100.0, 200.0, 10.0);
		SendClientMessage(playerid, -1, "You have been teleported to a predefined location.");
		return 1;
	}
	else if (strcmp(cmdtext, "/getcar", true) == 0)
	{
		// Create a vehicle for the player
		playerVehicle = CreateVehicle(411, 100.0, 200.0, 10.0, 0.0, -1, -1, 30);
		PutPlayerInVehicle(playerid, playerVehicle, 0);
		SendClientMessage(playerid, -1, "You have been given a car.");
		return 1;
	}
	return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
	// Destroy the bottom textdraw when a player disconnects
	TextDrawDestroy(textdraw);
	return 1;
}

// Sky Anti-DeAMX
SkyAntiDeAMX()
{
	new AMX;
	#emit load.pri AMX
	#emit stor.pri AMX

	new AMXX;
	#emit load.pri AMXX
	#emit stor.pri AMXX

	new AMXXX;
	#emit LOAD.S.alt AMXXX
	#emit STOR.S.alt AMXXX

	new AMXXXX[][] =
	{
		"Unarmed (Fist)",
		"Brass K"
	};

	#pragma unused AMXXXX
}