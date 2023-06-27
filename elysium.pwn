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
new Text:bottomTextdraw;
new Text:bgTextdraw;
new Text:logo2Textdraw;
new Text:logo1Textdraw;
new Text:logo3Textdraw;
new Text:logo4Textdraw;

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

	// Create textdraws
	// Textdraws
	bottomTextdraw = TextDrawCreate(310.000000, 435.000000, "~r~~h~~h~ /help ~w~~h~~h~/tp /gun /stunt /dm /shop /anim /v1..18 /m1..12 ~r~~h~~h~/rules");
	TextDrawAlignment(bottomTextdraw, 2);
	TextDrawBackgroundColor(bottomTextdraw, 255);
	TextDrawFont(bottomTextdraw, 1);
	TextDrawLetterSize(bottomTextdraw, 0.369998, 1.000000);
	TextDrawColor(bottomTextdraw, -1);
	TextDrawSetOutline(bottomTextdraw, 1);
	TextDrawSetProportional(bottomTextdraw, 1);

	bgTextdraw = TextDrawCreate(650.000000, 435.000000, " ~n~ ~n~");
	TextDrawBackgroundColor(bgTextdraw, 255);
	TextDrawFont(bgTextdraw, 1);
	TextDrawLetterSize(bgTextdraw, 0.500000, 1.000000);
	TextDrawColor(bgTextdraw, -1);
	TextDrawSetOutline(bgTextdraw, 0);
	TextDrawSetProportional(bgTextdraw, 1);
	TextDrawSetShadow(bgTextdraw, 1);
	TextDrawUseBox(bgTextdraw, 1);
	TextDrawBoxColor(bgTextdraw, 70);
	TextDrawTextSize(bgTextdraw, -10.000000, 0.000000);

	logo2Textdraw = TextDrawCreate(638.000000, 405.000000, "xtreme");
	TextDrawAlignment(logo2Textdraw, 3);
	TextDrawBackgroundColor(logo2Textdraw, 255);
	TextDrawFont(logo2Textdraw, 3);
	TextDrawLetterSize(logo2Textdraw, 0.639998, 2.599998);
	TextDrawColor(logo2Textdraw, 0x006AFFAA);
	TextDrawSetOutline(logo2Textdraw, 1);
	TextDrawSetProportional(logo2Textdraw, 1);

	logo1Textdraw = TextDrawCreate(610.000000, 387.000000, "trinity");
	TextDrawAlignment(logo1Textdraw, 3);
	TextDrawBackgroundColor(logo1Textdraw, 255);
	TextDrawFont(logo1Textdraw, 3);
	TextDrawLetterSize(logo1Textdraw, 0.639998, 2.599998);
	TextDrawColor(logo1Textdraw, -6749953);
	TextDrawSetOutline(logo1Textdraw, 1);
	TextDrawSetProportional(logo1Textdraw, 1);

	logo3Textdraw = TextDrawCreate(656.000000, 390.000000, "[]-");
	TextDrawBackgroundColor(logo3Textdraw, 255);
	TextDrawFont(logo3Textdraw, 2);
	TextDrawLetterSize(logo3Textdraw, -0.610000, 2.000000);
	TextDrawColor(logo3Textdraw, -2096897);
	TextDrawSetOutline(logo3Textdraw, 0);
	TextDrawSetProportional(logo3Textdraw, 1);
	TextDrawSetShadow(logo3Textdraw, 1);

	logo4Textdraw = TextDrawCreate(507.000000, 408.000000, "[]-");
	TextDrawBackgroundColor(logo4Textdraw, 255);
	TextDrawFont(logo4Textdraw, 2);
	TextDrawLetterSize(logo4Textdraw, 0.600000, 2.000000);
	TextDrawColor(logo4Textdraw, -2096897);
	TextDrawSetOutline(logo4Textdraw, 0);
	TextDrawSetProportional(logo4Textdraw, 1);
	TextDrawSetShadow(logo4Textdraw, 1);
	return 1;
}

public OnGameModeExit()
{
	// Destroy the bottom textdraw
	TextDrawDestroy(bottomTextdraw);
	TextDrawDestroy(bgTextdraw);
	TextDrawDestroy(logo1Textdraw);
	TextDrawDestroy(logo2Textdraw);
	TextDrawDestroy(logo3Textdraw);
	TextDrawDestroy(logo4Textdraw);
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

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	// Set player position, interior etc.
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerPos(playerid, -18.9876, -197.5336, 1.6676);
	SetPlayerFacingAngle(playerid, 255.9960);

	// Show textdraws
	TextDrawShowForPlayer(playerid, bottomTextdraw);
	TextDrawShowForPlayer(playerid, bgTextdraw);
	TextDrawShowForPlayer(playerid, logo1Textdraw);
	TextDrawShowForPlayer(playerid, logo2Textdraw);
	TextDrawShowForPlayer(playerid, logo3Textdraw);
	TextDrawShowForPlayer(playerid, logo4Textdraw);
}

public OnPlayerDeath(playerid, killerid, reason)
{
	// Hide textdraws
	TextDrawHideForPlayer(playerid, bottomTextdraw);
	TextDrawHideForPlayer(playerid, bgTextdraw);
	TextDrawHideForPlayer(playerid, logo1Textdraw);
	TextDrawHideForPlayer(playerid, logo2Textdraw);
	TextDrawHideForPlayer(playerid, logo3Textdraw);
	TextDrawHideForPlayer(playerid, logo4Textdraw);
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