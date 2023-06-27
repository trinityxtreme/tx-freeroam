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

	// Teleport commands
	if (strcmp(cmdtext, "/4dragon", true) == 0 || strcmp(cmdtext, "/dragon", true) == 0 || strcmp(cmdtext, "/4d", true) == 0) {
		Teleport(playerid, 2027.8171, 1008.1444, 10.8203, 0, 0, "Four Dragon Casino", "/4d", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/mountain", true) == 0 || strcmp(cmdtext, "/chilliad", true) == 0) {
		Teleport(playerid, -2353.0940, -1633.6820, 483.6954, 0, 0, "Chilliad Mountain", "/mountain", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/beach", true) == 0) {
		Teleport(playerid, 369.8283, -1787.7871, 5.3585, 0, 0, "Santa Maria Beach", "/beach", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/area51", true) == 0) {
		Teleport(playerid, 231.5036, 1914.3851, 17.6406, 0, 0, "Area 51", "/area51", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/china", true) == 0) {
		Teleport(playerid, -2276.2874, 718.5117, 49.4453, 0, 0, "China Town", "/china", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/flores", true) == 0) {
		Teleport(playerid, 2786.9534, -1319.9723, 34.7975, 0, 0, "Los Flores", "/flores", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/mod1", true) == 0) {
		Teleport(playerid, -1917.2754, 287.0215, 41.0469, 0, 0, "Modification 1", "/mod1", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/mod2", true) == 0) {
		Teleport(playerid, -2705.5503, 206.1621, 4.1797, 0, 0, "Modification 2", "/mod2", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/mod3", true) == 0) {
		Teleport(playerid, 2387.4126, 1022.6620, 10.8203, 0, 0, "Modification 3", "/mod3", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/mod4", true) == 0) {
		Teleport(playerid, 2644.7686, -2019.1096, 13.5507, 0, 0, "Modification 4", "/mod4", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/mod5", true) == 0) {
		Teleport(playerid, 1042.0564, -1045.5176, 31.8108, 0, 0, "Modification 5", "/mod5", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/ap1", true) == 0) {
		Teleport(playerid, 1686.7, -2450.2, 13.6, 0, 0, "Airport 1", "/ap1", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/ap2", true) == 0) {
		Teleport(playerid, -1345.0, -229.8, 14.1, 0, 0, "Airport 2", "/ap2", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/ap3", true) == 0) {
		Teleport(playerid, 1435.5, 1463.2, 10.8, 0, 0, "Airport 3", "/ap3", true, false);
		return 1;
	}

	if (strcmp(cmdtext, "/ap4", true) == 0) {
		Teleport(playerid, 350.7, 2539.2, 16.8, 0, 0, "Airport 4", "/ap4", true, false);
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

// General use functions
stock PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	return name;
}

// Teleport functions
stock Teleport(playerid, Float:tX, Float:tY, Float:tZ, Int, World, const name[], const command[], car, loading)
{
	if (loading) LoadObjects(playerid);

	if (car && IsPlayerInAnyVehicle(playerid)) {
		SetVehiclePos(GetPlayerVehicleID(playerid), tX, tY, tZ);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), Int);
	} else {
		SetPlayerPos(playerid, tX, tY, tZ);
	}

	SetPlayerInterior(playerid, Int);
	SetPlayerVirtualWorld(playerid, World);

	new tmp[512];
	format(tmp, sizeof(tmp), "{FFFFFF}Player {ACDA00}%s {FFFFFF}teleported to {ACDA00}%s {FFFFFF}area. {ACDA00}(%s)", PlayerName(playerid), name, command);
	SendClientMessageToAll(1, tmp);

	format(tmp, sizeof(tmp), "{FFFFFF}You teleported to {ACDA00}%s{FFFFFF}.", name);
	SendClientMessage(playerid, 1, tmp);
}

forward LoadObjects(playerid);
public LoadObjects(playerid)
{
	TogglePlayerControllable(playerid, 0);
	GameTextForPlayer(playerid, "~b~Loading objects...", 3000, 5);
	SetTimerEx("LoadObjectsDone", 4000, false, "i", playerid);
}

forward LoadObjectsDone(playerid);
public LoadObjectsDone(playerid)
{
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "~y~] ~b~Objects loaded! ~y~]", 5000, 5);
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