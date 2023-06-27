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

// Global variables
new Text:textdraw;

// Main
main()
{
	printf("Gamemode initialized.");
}

// Callbacks
public OnGameModeInit()
{
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