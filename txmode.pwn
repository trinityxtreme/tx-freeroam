
/*

// Library include
#include <sscanf2>		// SSCANF kütüphanesi
//#include <progress2>	// Progressbar kütüphanesi

// Player settings:
new playerTimer[MAX_PLAYERS];
new hungryTimer[MAX_PLAYERS];

// Account script:
#define dialog_register (1)
#define dialog_regapply (2)
#define dialog_login	(3)

enum pAccount
{
	pA_Pass[16],
	pA_AdminLevel,
	
	pA_Killed,
	pA_Death,
	pA_Score,
	pA_Money,
	
	 pA_Radiation,
	pA_Hungry,
	pA_Comfort,

	Float:pA_X,
	Float:pA_Y,
	Float:pA_Z,
	pA_Interior,

	pA_IP,
	pA_Online,
	pA_LastOnline,
	
	bool:pA_Spawned
};
new PlayerAccount[MAX_PLAYERS][pAccount];

// Campfire script:
new bool:campFire[MAX_PLAYERS] = false;
new fireObject[MAX_PLAYERS], fireWoods[MAX_PLAYERS];

// Guitar script:
new bool:guitarSong[MAX_PLAYERS] = false;

// Player colors:
new PlayerColors[200] = {
	0xFF8C13FF, 0xC715FFFF, 0x20B2AAFF, 0xDC143CFF, 0x6495EDFF, 0xf0e68cFF, 0x778899FF, 0xFF1493FF, 0xF4A460FF,
	0xEE82EEFF, 0xFFD720FF, 0x8b4513FF, 0x4949A0FF, 0x148b8bFF, 0x14ff7fFF, 0x556b2fFF, 0x0FD9FAFF, 0x10DC29FF,
	0x534081FF, 0x0495CDFF, 0xEF6CE8FF, 0xBD34DAFF, 0x247C1BFF, 0x0C8E5DFF, 0x635B03FF, 0xCB7ED3FF, 0x65ADEBFF,
	0x5C1ACCFF, 0xF2F853FF, 0x11F891FF, 0x7B39AAFF, 0x53EB10FF, 0x54137DFF, 0x275222FF, 0xF09F5BFF, 0x3D0A4FFF,
	0x22F767FF, 0xD63034FF, 0x9A6980FF, 0xDFB935FF, 0x3793FAFF, 0x90239DFF, 0xE9AB2FFF, 0xAF2FF3FF, 0x057F94FF,
	0xB98519FF, 0x388EEAFF, 0x028151FF, 0xA55043FF, 0x0DE018FF, 0x93AB1CFF, 0x95BAF0FF, 0x369976FF, 0x18F71FFF,
	0x4B8987FF, 0x491B9EFF, 0x829DC7FF, 0xBCE635FF, 0xCEA6DFFF, 0x20D4ADFF, 0x2D74FDFF, 0x3C1C0DFF, 0x12D6D4FF,
	0x48C000FF, 0x2A51E2FF, 0xE3AC12FF, 0xFC42A8FF, 0x2FC827FF, 0x1A30BFFF, 0xB740C2FF, 0x42ACF5FF, 0x2FD9DEFF,
	0xFAFB71FF, 0x05D1CDFF, 0xC471BDFF, 0x94436EFF, 0xC1F7ECFF, 0xCE79EEFF, 0xBD1EF2FF, 0x93B7E4FF, 0x3214AAFF,
	0x184D3BFF, 0xAE4B99FF, 0x7E49D7FF, 0x4C436EFF, 0xFA24CCFF, 0xCE76BEFF, 0xA04E0AFF, 0x9F945CFF, 0xDCDE3DFF,
	0x10C9C5FF, 0x70524DFF, 0x0BE472FF, 0x8A2CD7FF, 0x6152C2FF, 0xCF72A9FF, 0xE59338FF, 0xEEDC2DFF, 0xD8C762FF,
	0xD8C762FF, 0xFF8C13FF, 0xC715FFFF, 0x20B2AAFF, 0xDC143CFF, 0x6495EDFF, 0xf0e68cFF, 0x778899FF, 0xFF1493FF,
	0xF4A460FF, 0xEE82EEFF, 0xFFD720FF, 0x8b4513FF, 0x4949A0FF, 0x148b8bFF, 0x14ff7fFF, 0x556b2fFF, 0x0FD9FAFF,
	0x10DC29FF, 0x534081FF, 0x0495CDFF, 0xEF6CE8FF, 0xBD34DAFF, 0x247C1BFF, 0x0C8E5DFF, 0x635B03FF, 0xCB7ED3FF,
	0x65ADEBFF, 0x5C1ACCFF, 0xF2F853FF, 0x11F891FF, 0x7B39AAFF, 0x53EB10FF, 0x54137DFF, 0x275222FF, 0xF09F5BFF,
	0x3D0A4FFF, 0x22F767FF, 0xD63034FF, 0x9A6980FF, 0xDFB935FF, 0x3793FAFF, 0x90239DFF, 0xE9AB2FFF, 0xAF2FF3FF,
	0x057F94FF, 0xB98519FF, 0x388EEAFF, 0x028151FF, 0xA55043FF, 0x0DE018FF, 0x93AB1CFF, 0x95BAF0FF, 0x369976FF,
	0x18F71FFF, 0x4B8987FF, 0x491B9EFF, 0x829DC7FF, 0xBCE635FF, 0xCEA6DFFF, 0x20D4ADFF, 0x2D74FDFF, 0x3C1C0DFF,
	0x12D6D4FF, 0x48C000FF, 0x2A51E2FF, 0xE3AC12FF, 0xFC42A8FF, 0x2FC827FF, 0x1A30BFFF, 0xB740C2FF, 0x42ACF5FF,
	0x2FD9DEFF, 0xFAFB71FF, 0x05D1CDFF, 0xC471BDFF, 0x94436EFF, 0xC1F7ECFF, 0xCE79EEFF, 0xBD1EF2FF, 0x93B7E4FF,
	0x3214AAFF, 0x184D3BFF, 0xAE4B99FF, 0x7E49D7FF, 0x4C436EFF, 0xFA24CCFF, 0xCE76BEFF, 0xA04E0AFF, 0x9F945CFF,
	0xDCDE3DFF, 0x10C9C5FF, 0x70524DFF, 0x0BE472FF, 0x8A2CD7FF, 0x6152C2FF, 0xCF72A9FF, 0xE59338FF, 0xEEDC2DFF,
	0xD8C762FF, 0xD8C762FF
};

// DCMD defineleri
#define dcmd(%1, %2, %3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

// PM sistemi tanıtımları
enum PlayerInfo
{
	Last,
	NoPM,
}

new pInfo[MAX_PLAYERS][PlayerInfo];

// Exp sistemi tanıtımları
new exp[MAX_PLAYERS], seviye[MAX_PLAYERS], expguncelle[MAX_PLAYERS];
new Text:expbox;
new Text:expmeter[MAX_PLAYERS];

// new Bar:expbar[MAX_PLAYERS];

// Saat sistemi tanıtımları
new Hour, Minute, Timer, Text:TimeText;

// Araç yönetim tanıtımları
new motor, isiklar, alarm, kapilar, kaput, bagaj, objective;
new Kilit[MAX_PLAYERS] = 0;
new Arac[MAX_PLAYERS];

// DM sistemi tanıtımları
new DM[MAX_PLAYERS];

// Desert Eagle Deathmatch - 1
new Float:deagledm1pos[7][3] = {
	{2441.3003, 1809.5614, 16.3222},
	{2434.2029, 1793.4486, 16.3222},
	{2421.7632, 1791.1007, 16.3222},
	{2431.6787, 1790.4875, 16.3222},
	{2423.8142, 1820.0522, 16.3222},
	{2423.8674, 1832.9325, 16.3222},
	{2407.1179, 1812.8815, 16.3222}
};

// Fist Deathmatch - 1
new Float:fistdm1pos[4][3] = {
	{2192.8518, 2516.2422, 585.7723},
	{2193.9260, 2562.2336, 585.7723},
	{2147.8921, 2563.0903, 585.7723},
	{2146.9512, 2517.0962, 585.7723}
};

// Yardım menüsü tanıtımları
new dIp[][] =
{
	"{ACDA00}/firstperson\t\t{FFFFFF}FPS moduna giriş yaparsınız.",
	"{ACDA00}/exitfirstperson\t{FFFFFF}FPS modundan çıkarsınız.",
	"{ACDA00}/myversion\t\t{FFFFFF}SA-MP versiyonunuzu gösterir.",
	"{ACDA00}/kurallar\t\t{FFFFFF}Sunucu kurallarını gösterir.",
	"{ACDA00}/surus\t\t\t{FFFFFF}Araç içi FPS modunu açar/kapatır.",
	"{ACDA00}/teles\t\t\t{FFFFFF}Teleport menüsünü açar.",
	"{ACDA00}/m1-/m12\t\t{FFFFFF}Modifiyeli araba spawn eder.",
	"{ACDA00}/v1-/v18\t\t{FFFFFF}Normal araba spawn eder.",
	"{ACDA00}/changelog\t\t{FFFFFF}Güncelleme listesini gösterir.",
	"{ACDA00}/cevir\t\t\t{FFFFFF}Ters çevrilen arabayı düzeltir.",
	"{ACDA00}/31\t\t\t{FFFFFF}31 çekme sistemini açar/kapatır.",
	"{ACDA00}/dmler\t\t\t{FFFFFF}Deathmatch alanı listesini gösterir.",
	"{ACDA00}/stuntlar\t\t{FFFFFF}Stunt alanlarını gösterir.",
	"{ACDA00}/can\t\t\t{FFFFFF}Can paketi satın alırsınız.",
	"{ACDA00}/yelek\t\t\t{FFFFFF}zırh paketi satın alırsınız.",
	"{ACDA00}/ev\t\t\t{FFFFFF}Ev düzenleme menüsünü açar.",
	"{ACDA00}/yardim\t\t{FFFFFF}Oyun modu hakkında yardım verir.",
	"\n\nBu mod {009BFF}MR.ImmortaL {FFFFFF}tarafından kodlanmıştır."
};

// 31 sistemi tanıtımları
new asilantimer;
new cekiyor[MAX_PLAYERS] = 0;

// FPS sistemi tanıtımları
new Surus[MAX_PLAYERS];
new firstperson[MAX_PLAYERS];

// Araç spawn sistemi tanıtımları
#define DIALOG_OFFSET_ID (1024)

new g_VehNames[][] =
{
	!"Landstalker", !"Bravura", !"Buffalo", !"Linerunner", !"Pereniel", !"Sentinel", !"Dumper", !"Firetruck", !"Trashmaster", !"Stretch", !"Manana", !"Infernus",
	!"Voodoo", !"Pony", !"Mule", !"Cheetah", !"Ambulance", !"Leviathan", !"Moonbeam", !"Esperanto", !"Taxi", !"Washington", !"Bobcat", !"Mr Whoopee", !"BF Injection",
	!"Hunter [YASAK]", !"Premier", !"Enforcer", !"Securicar", !"Banshee", !"Predator", !"Bus", !"Rhino [YASAK]", !"Barracks", !"Hotknife", !"Trailer", !"Previon", !"Coach", !"Cabbie",
	!"Stallion", !"Rumpo", !"RC Bandit", !"Romero", !"Packer", !"Monster", !"Admiral", !"Squalo", !"Seasparrow", !"Pizzaboy", !"Tram", !"Trailer", !"Turismo", !"Speeder",
	!"Reefer", !"Tropic", !"Flatbed", !"Yankee", !"Caddy", !"Solair", !"Berkley's RC Van", !"Skimmer", !"PCJ-600", !"Faggio", !"Freeway", !"RC Baron", !"RC Raider",
	!"Glendale", !"Oceanic", !"Sanchez", !"Sparrow", !"Patriot", !"Quad", !"Coastguard", !"Dinghy", !"Hermes", !"Sabre", !"Rustler", !"ZR3 50", !"Walton", !"Regina",
	!"Comet", !"BMX", !"Burrito", !"Camper", !"Marquis", !"Baggage", !"Dozer", !"Maverick", !"News Chopper", !"Rancher", !"FBI Rancher", !"Virgo", !"Greenwood",
	!"Jetmax", !"Hotring", !"Sandking", !"Blista Compact", !"Police Maverick", !"Boxville", !"Benson", !"Mesa", !"RC Goblin", !"Hotring Racer A", !"Hotring Racer B",
	!"Bloodring Banger", !"Rancher", !"Super GT", !"Elegant", !"Journey", !"Bike", !"Mountain Bike", !"Beagle", !"Cropdust", !"Stunt", !"Tanker", !"RoadTrain",
	!"Nebula", !"Majestic", !"Buccaneer", !"Shamal", !"Hydra [YASAK]", !"FCR-900", !"NRG-500", !"HPV1000", !"Cement Truck", !"Tow Truck", !"Fortune", !"Cadrona", !"FBI Truck",
	!"Willard", !"Forklift", !"Tractor", !"Combine", !"Feltzer", !"Remington", !"Slamvan", !"Blade", !"Freight", !"Streak", !"Vortex", !"Vincent", !"Bullet", !"Clover",
	!"Sadler", !"Firetruck", !"Hustler", !"Intruder", !"Primo", !"Cargobob", !"Tampa", !"Sunrise", !"Merit", !"Utility", !"Nevada", !"Yosemite", !"Windsor", !"Monster A",
	!"Monster B", !"Uranus", !"Jester", !"Sultan", !"Stratum", !"Elegy", !"Raindance", !"RC Tiger", !"Flash", !"Tahoma", !"Savanna", !"Bandito", !"Freight", !"Trailer",
	!"Kart", !"Mower", !"Duneride", !"Sweeper", !"Broadway", !"Tornado", !"AT-400", !"DFT-30", !"Huntley", !"Stafford", !"BF-400", !"Newsvan", !"Tug", !"Trailer A", !"Emperor",
	!"Wayfarer", !"Euros", !"Hotdog", !"Club", !"Trailer B", !"Trailer C", !"Andromada", !"Dodo", !"RC Cam", !"Launch", !"Police Car (LSPD)", !"Police Car (SFPD)",
	!"Police Car (LVPD)", !"Police Ranger", !"Picador", !"S.W.A.T. Van", !"Alpha", !"Phoenix", !"Glendale", !"Sadler", !"Luggage Trailer A", !"Luggage Trailer B",
	!"Stair Trailer", !"Boxville", !"Farm Plow", !"Utility Trailer"
};

// Hızlandırıcı Pickup
#define HIZLANDIRICI_COUNT 13
#define HIZ_VER 5

new hizlandirici[HIZLANDIRICI_COUNT];
new Float:speedLocation[HIZLANDIRICI_COUNT][3] = {
	{ 2048.6716, 1015.3157, 10.6719 },
	{ 2066.5132, 1019.7257, 10.6719 },
	{ 2066.5918, 1254.1406, 10.6719 },
	{ 2048.8401, 1284.9427, 10.6719 },
	{ 2121.1084, 1847.6072, 10.6719 },
	{ 2146.4421, 1874.5963, 10.6719 },
	{ 2128.2676, 2219.6204, 10.6719 },
	{ 2229.9316, 2555.6431, 10.8203 },
	{ 1964.1276, 2593.7170, 10.8126 },
	{ -2084.9065, -1967.6328, 378.5436 },
	{ 2048.4058, 815.1559, 8.4697 },
	{ 2364.7070, 433.8943, 17.6082 },
	{ 1294.1956, 2598.3647, 11.9492 }
};

// Random spawn
new Float:RandomPlayerSpawns[23][3] = {
	{ 1958.3783, 1343.1572, 15.3746 },
	{ 2199.6531, 1393.3678, 10.8203 },
	{ 2483.5977, 1222.0825, 10.8203 },
	{ 2637.2712, 1129.2743, 11.1797 },
	{ 2000.0106, 1521.1111, 17.0625 },
	{ 2024.8190, 1917.9425, 12.3386 },
	{ 2261.9048, 2035.9547, 10.8203 },
	{ 2262.0986, 2398.6572, 10.8203 },
	{ 2244.2566, 2523.7280, 10.8203 },
	{ 2335.3228, 2786.4478, 10.8203 },
	{ 2150.0186, 2734.2297, 11.1763 },
	{ 2158.0811, 2797.5488, 10.8203 },
	{ 1969.8301, 2722.8564, 10.8203 },
	{ 1652.0555, 2709.4072, 10.8265 },
	{ 1564.0052, 2756.9463, 10.8203 },
	{ 1271.5452, 2554.0227, 10.8203 },
	{ 1441.5894, 2567.9099, 10.8203 },
	{ 1480.6473, 2213.5718, 11.0234 },
	{ 1400.5906, 2225.6960, 11.0234 },
	{ 1598.8419, 2221.5676, 11.0625 },
	{ 1318.7759, 1251.3580, 10.8203 },
	{ 1558.0731, 1007.8292, 10.8125 },
	{ 1705.2347, 1025.6808, 10.8203 }
};

main()
{
	new year, month, day, hour, minute, second;
	getdate(year, month, day);
	gettime(hour, minute, second);

	printf("Yüklendi: \"Sunucu modu.\"");
	printf("");
	printf("\"--------------------------------------------------\"");
	printf("\"                   Trinity-Xtreme                 \"");
	printf("\"           Created by Crosscuk & ImmortaL         \"");
	printf("\"             Since 2013-01-27 01:52				\"");
	printf("\"                                                  \"");
	printf("\" ** %d-%d-%d %d:%d								\"", year, month, day, hour, minute);
	printf("\"--------------------------------------------------\"");

	SkyAntiDeAMX();
}

public OnGameModeInit()
{
	printf(" ** %s initializing.", server_modname);

	// General settings
	SetWeather(18); // 15 for dark survival sky
	UsePlayerPedAnims();
	AllowInteriorWeapons(1);
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(2);
	ShowNameTags(1);
	SetNameTagDrawDistance(25.0);

	
	
	printf("  ** LOADED: general settings.");

	// Textdraws
	textdraw_server = TextDrawCreate(5.000000, 435.000000, "Supervivencia Server ~b~~h~~h~v1.0.0");
	TextDrawBackgroundColor(textdraw_server, 255);
	TextDrawFont(textdraw_server, 2);
	TextDrawLetterSize(textdraw_server, 0.300000, 1.000000);
	TextDrawColor(textdraw_server, 1717987071);
	TextDrawSetOutline(textdraw_server, 1);
	TextDrawSetProportional(textdraw_server, 1);

	printf("Yüklendi: \"Sunucu textdrawları.\"");

	// Exp sistemi ayarları
	expbox = TextDrawCreate(460.000000, 410.000000, "~n~");
	TextDrawBackgroundColor(expbox, 255);
	TextDrawFont(expbox, 1);
	TextDrawLetterSize(expbox, 0.219999, 1.299999);
	TextDrawColor(expbox, -1);
	TextDrawSetOutline(expbox, 0);
	TextDrawSetProportional(expbox, 1);
	TextDrawSetShadow(expbox, 1);
	TextDrawUseBox(expbox, 1);
	TextDrawBoxColor(expbox, 255);
	TextDrawTextSize(expbox, 174.000000, 0.000000);

	for (new i; i<MAX_PLAYERS; i++) {
		/*expmeter[i] = TextDrawCreate(177.000000, 398.000000, " ");
		TextDrawBackgroundColor(expmeter[i], 255);
		TextDrawFont(expmeter[i], 1);
		TextDrawLetterSize(expmeter[i], 0.320000, 0.899999);
		TextDrawColor(expmeter[i], -1);
		TextDrawSetOutline(expmeter[i], 0);
		TextDrawSetProportional(expmeter[i], 1);
		TextDrawSetShadow(expmeter[i], 1);*/
/*
		expmeter[i] = TextDrawCreate(322.000000, 411.000000, " ");
		TextDrawAlignment(expmeter[i], 2);
		TextDrawBackgroundColor(expmeter[i], 255);
		TextDrawFont(expmeter[i], 3);
		TextDrawLetterSize(expmeter[i], 0.340000, 1.000000);
		TextDrawColor(expmeter[i], -641287425);
		TextDrawSetOutline(expmeter[i], 1);
		TextDrawSetProportional(expmeter[i], 1);

		//expbar[i] = CreateProgressBar(181.00, 412.00, 273.50, 8.19, 10223615, 100.0);
	}
	printf("Yüklendi: \"Exp-Level sistemi.\"");

	// Saat sistemi
	Hour = 06;
	Minute = 0;
	SetWorldTime(Hour);

	TimeText = TextDrawCreate (547.000000, 23.000000, "00:00");
	TextDrawBackgroundColor (TimeText, 255);
	TextDrawFont (TimeText, 3);
	TextDrawLetterSize (TimeText, 0.599999, 2.100000);
	TextDrawColor (TimeText, -1);
	TextDrawSetOutline (TimeText, 1);
	TextDrawSetProportional (TimeText, 1);

	KillTimer(Timer);
	Timer = SetTimer("UpdateServerTime", 1000, true);

	printf("Yüklendi: \"Saat sistemi.\"");


	// Hızlandırma pickupları
	for (new i = 0; i < HIZLANDIRICI_COUNT; i++) {
		hizlandirici[i] = CreatePickup(1313, 14, speedLocation[i][0], speedLocation[i][1], speedLocation[i][2], 0);
	}

	printf("Yüklendi: \"Hız pickupları.\"");

	// MySQL settings:
	//mysql_connect(mysql_hostname, mysql_username, mysql_database, mysql_password);
	//mysql_query("CREATE TABLE IF NOT EXISTS players(SQLID INT(11), Nickname VARCHAR(24), Password VARCHAR(16), AdminLevel INT(1), Killed INT(11), Death INT(11), Score INT(11), Money INT(11), Radiation INT(3), Hungry INT(3), Comfort INT(3), Last_X FLOAT, Last_Y FLOAT, Last_Z, FLOAT, Last_INT INT(3), LastIP VARCHAR(16), Online TINYINT(1), LastOnline DATE");
	//mysql_query("CREATE TABLE IF NOT EXISTS iplog(playername VARCHAR(24), ip VARCHAR(16), connected TINYINT(1))");
	
	 //if (mysql_ping() > 0)
	//    printf("  ** MySQL connection successful! [Host: %s / Database: %s]", mysql_hostname, mysql_database);
	//else
	printf("  ** MySQL connection failed!");

	SkyAntiDeAMX();
	printf("  ** AntiDeAMX started!");

	return 1;
}

public OnGameModeExit()
{
	TextDrawDestroy(TimeText);
	TextDrawDestroy(Textdraw0);
	TextDrawDestroy(Textdraw1);
	TextDrawDestroy(Textdraw2);
	TextDrawDestroy(Textdraw3);
	TextDrawDestroy(Textdraw4);
	TextDrawDestroy(Textdraw5);
	TextDrawDestroy(Textdraw6);
	TextDrawDestroy(Textdraw7);
	TextDrawDestroy(Textdraw8);
	TextDrawDestroy(Textdraw9);
	TextDrawDestroy(textdraw_server);
	/*TextDrawDestroy(expbox);
	TextDrawDestroy(expmeter);*/
	/*
	KillTimer(Timer);

	new year, month, day;
	new hour, minute, second;

	gettime(hour, minute, second);
	getdate(year, month, day);

	printf("Sunucu modu kapandı.");
	printf("Saat: %d:%d:%d ~ Tarih: %d/%d/%d", hour, minute, second, day, month, year);
	printf("Trinity-Xtreme / since 27/01/2013 - 01:52");

	//mysql_close();
	printf("  ** MySQL connection closed!");

	printf("ç %s gamemode closed.", server_modname);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new connectMessage[64 + MAX_PLAYER_NAME];
	format(connectMessage, sizeof(connectMessage), "{00B3FF}%s {BBBBBB}connected server.", pName(playerid));
	SendInfoToAll(connectMessage);

	SetPlayerColor(playerid, PlayerColors[playerid]);
	SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);
	SetPlayerTime(playerid, 06, 00);

	LoadTextDraws(playerid);    // Textdraws loaded.
	PlayerAccount[playerid][pA_Hungry] = 0; // Hungry level reseted.
	PlayerAccount[playerid][pA_Radiation] = 0;  // Radiation level reseted.
	playerTimer[playerid] = SetTimerEx("playerGameTimer", 2000, true, "i", playerid);   // Player General Timer started.

	// Account script:
	AccountReset(playerid);
	
	
	//new query[256];
	//format(query, sizeof(query), "SELECT FROM `players` WHERE user = '%s' LIMIT 1", pName(playerid)); //Formats the query, view above the code for a explanation
	//mysql_query(query);
	//mysql_store_result();
	//new rows = mysql_num_rows();
	
	//if (true)
	ShowPlayerDialog(playerid, dialog_register, DIALOG_STYLE_INPUT, "{BBBBBB}** {00B3FF}Character Register:", "{BBBBBB}Welcome to the {00B3FF}"server_modname"!\n{333333}Enter your password and play the game.", "Register", "Cancel");
	//else
	SendClientMessage(playerid, -1, "not rows");
	//return 1;

	GameTextForPlayer(playerid, "~b~~h~Trinity-~w~Xtreme~n~~r~~h~F~g~~h~r~b~~h~e~y~e~r~r~w~o~p~a~g~m", 5000, 1);
	// PM sistemi
	pInfo[playerid][Last] = -1;
	pInfo[playerid][NoPM] = 0;

	// EXP sistemi
	new dosya[50], isim[24];
	GetPlayerName(playerid, isim, sizeof(isim));
	format(dosya, sizeof(dosya), "Hesaplar/Level/%s.txt", isim);
	
	//if (!dini_Exists(dosya)) seviye[playerid] = 1, dini_Create(dosya);
	//else BilgiYukle(playerid);
	expguncelle[playerid] = SetTimerEx("BilgiYenile", 1000, true, "d", playerid);

	// Araç kilit ayarı
	Kilit[playerid] = 0;

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	// PM sistemi
	pInfo[playerid][Last] = -1;
	pInfo[playerid][NoPM] = 0;

	// EXP sistemi
	BilgiYenile(playerid);
	KillTimer(expguncelle[playerid]);

	// Araç spawn ayarları
	new iVehID = GetPVarInt(playerid, "iVehID");
	if (iVehID)
	DestroyVehicle(iVehID);

	new exitMessage[65 + MAX_PLAYER_NAME];
	switch (reason)
	{
		case 0:format(exitMessage, sizeof(exitMessage), "{BBBBBB}** {00B3FF}%s {BBBBBB}is disconnected. [timeout]", pName(playerid));  // Error.
		case 1:format(exitMessage, sizeof(exitMessage), "{BBBBBB}** {00B3FF}%s {BBBBBB}is leaved server.", pName(playerid));      // Player choice.
		case 2:format(exitMessage, sizeof(exitMessage), "{BBBBBB}** {00B3FF}%s {BBBBBB}is kicked or banned.", pName(playerid));     // Kicked.
	}
	SendClientMessageToAll(-1, exitMessage);
	SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);
	KillTimer(playerTimer[playerid]);   // Player General Timer stopped.
	KillTimer(hungryTimer[playerid]);   // Hunry Timer stopped.
	UnloadTextDraws(playerid);  // Textdraws unloaded.

	if (campFire[playerid] == true) {
		DestroyDynamicObject(fireWoods[playerid]);
		DestroyDynamicObject(fireObject[playerid]);
	}

	if (guitarSong[playerid] == true) {
		StopAudioStreamForPlayer(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	

	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	TextDrawShowForPlayer(playerid, Textdraw3);
	TextDrawShowForPlayer(playerid, Textdraw4);
	TextDrawShowForPlayer(playerid, Textdraw5);
	TextDrawShowForPlayer(playerid, Textdraw6);
	TextDrawShowForPlayer(playerid, Textdraw7);
	TextDrawShowForPlayer(playerid, Textdraw8);
	TextDrawShowForPlayer(playerid, Textdraw9);
	TextDrawShowForPlayer(playerid, textdraw_server);
	TextDrawShowForPlayer(playerid, TimeText);

	// Exp sistemi
	TextDrawShowForPlayer(playerid, expbox);
	TextDrawShowForPlayer(playerid, expmeter[playerid]);
	//ShowProgressBarForPlayer(playerid, Bar:expbar[playerid]);

	// Deathmatch
	switch (DM[playerid])
	{
		case 1:
		{
			DM[playerid] = 1;

			SetPlayerArmour(playerid, 100);
			SetPlayerHealth(playerid, 100);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 99999);

			new rand = random(sizeof(deagledm1pos));
			SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
			GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
			SendInfo(playerid, "Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			SetPlayerTeam(playerid, NO_TEAM);
		}

		case 2:
		{
			DM[playerid] = 2;

			SetPlayerArmour(playerid, 100);
			SetPlayerHealth(playerid, 100);
			SetPlayerSkin(playerid, 80);
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, 0);
			ResetPlayerWeapons(playerid);

			new rand = random(sizeof(fistdm1pos));
			SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
			GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
			SendInfo(playerid, "Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			SetPlayerTeam(playerid, NO_TEAM);
		}
	}

	SetPlayerPos(playerid, -2020.6033, 613.6348, 36.6419);
	showMessage(playerid, "Spawned successful!");
	TextDrawShowForPlayer(playerid, textdraw_hungry[playerid]);
	TextDrawShowForPlayer(playerid, textdraw_radiation[playerid]);
	TextDrawShowForPlayer(playerid, textdraw_ping[playerid]);

	SetPlayerHealth(playerid, 100.0);
	hungryTimer[playerid] = SetTimerEx("addHungry", 15 * 1000, true, "i", playerid);

	TogglePlayerControllable(playerid, 1);
	TogglePlayerSpectating(playerid, 0);
	ClearAnimations(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	GivePlayerWeapon(playerid, 4, 1);
	SetPlayerDrunkLevel(playerid, 0);
	
	// Account script:
	PlayerAccount[playerid][pA_Spawned] = false;

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if (GetPlayerScore(playerid) > 0) return SetPlayerScore(playerid, GetPlayerScore(playerid) - 1);
	SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);

	SendDeathMessage(killerid, playerid, reason);

	ExpVer(killerid);
	SetPlayerScore(killerid, GetPlayerScore(killerid)+1);
	PlayerPlaySound(playerid, 5206, 0, 0, 0);

	PlayerAccount[playerid][pA_Hungry] = 0;
	PlayerAccount[playerid][pA_Radiation] = 0;

	TextDrawHideForPlayer(playerid, textdraw_hungry[playerid]);
	TextDrawHideForPlayer(playerid, textdraw_radiation[playerid]);
	TextDrawHideForPlayer(playerid, textdraw_ping[playerid]);

	if (campFire[playerid] == true) {
		DestroyDynamicObject(fireWoods[playerid]);
		DestroyDynamicObject(fireObject[playerid]);
	}

	if (guitarSong[playerid] == true) {
		StopAudioStreamForPlayer(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid);
	}

	return 1;
}

public OnPlayerText(playerid, text[])
{
	new pText[256 + MAX_PLAYER_NAME];
	format(pText, sizeof(pText), "%s {BBBBBB}[%d]: %s", pName(playerid), playerid, text);
	SendClientMessageToAll(GetPlayerColor(playerid), pText);
	/*
	new chatmessage[1024];
	if (IsPlayerAdmin(playerid))
	{
	format(chatmessage, 1024, "{C30000}[{FFFFFF}RGM{C30000}]{ACDA00}%s{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s", PlayerName(playerid), playerid, text);
	SendClientMessageToAll(1, chatmessage);
	}
	else
	{
	if (IsPlayeraLAdmin(playerid))
	{
	format(chatmessage, 1024, "{C30000}[{FFFFFF}GM{C30000}]{ACDA00}%s{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s", PlayerName(playerid), playerid, text);
	SendClientMessageToAll(1, chatmessage);
	}
	else
	{
	format(chatmessage, 1024, "{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s", playerid, text);
	SendPlayerMessageToAll(playerid, chatmessage);
	}
	}
	SetPlayerChatBubble(playerid, text, 0xACDA00AA, 100.0, 5000);
	return 0;
	*/
	/*
}

// DCMD komutları:
dcmd_pmkapat(playerid, const params[])
{
	if (pInfo[playerid][NoPM] == 1) return SendError(playerid, "Özel mesaj hattınız zaten kapalı.");

	pInfo[playerid][NoPM] = 1;
	SendInfo(playerid, "Özel mesaj hattınızı kapattınız.");
}

dcmd_pmac(playerid, const params[])
{
	if (pInfo[playerid][NoPM] == 0) return SendInfo(playerid, "Özel mesaj hattınız zaten açık.");

	pInfo[playerid][NoPM] = 0;
	SendInfo(playerid, "Özel mesaj hattınızı açtınız.");
}

dcmd_pm(playerid, const params[])
{
	new pID, text[128], string[128];
	if (sscanf(params, "us", pID, text)) return SendUse(playerid, "/pm (nick/id) (mesaj)");
	if (!IsPlayerConnected(pID)) return SendError(playerid, "Oyuncu bulunamadı.");
	if (pID == playerid) return SendError(playerid, "Kendinize çzel mesaj gönderemezsiniz.");
	format(string, sizeof(string), "** HATA: {FFFFFF}%s(%d) rumuzlu oyuncunun özel mesaj hattı kapalı.", PlayerName(pID), pID);
	if (pInfo[pID][NoPM] == 1) return SendClientMessage(playerid, 0xF63845AA, string);
	format(string, sizeof(string), "** [PM] %s: %s", PlayerName(pID), text);
	SendClientMessage(playerid, -1, string);
	format(string, sizeof(string), "** [PM] %s: %s", PlayerName(playerid), text);
	SendClientMessage(pID, -1, string);
	pInfo[pID][Last] = playerid;
	return 1;
}

dcmd_reply(playerid, const params[])
{
	new text[128], string[128];
	if (sscanf(params, "s", text)) return SendUse(playerid, "/reply (mesaj)");
	new pID = pInfo[playerid][Last];
	if (!IsPlayerConnected(pID)) return SendError(playerid, "Oyuncu bulunamadı.");
	if (pID == playerid) return SendError(playerid, "Kendinize özel mesaj gönderemezsiniz.");
	format(string, sizeof(string), "** HATA: {FFFFFF}%s(%d) rumuzlu oyuncunun özel mesaj hattı kapalı.", PlayerName(pID), pID);
	if (pInfo[pID][NoPM] == 1) return SendClientMessage(playerid, 0xF63845AA, string);
	format(string, sizeof(string), "** [PM] %s: %s", PlayerName(pID), text);
	SendClientMessage(playerid, -1, string);
	format(string, sizeof(string), "** [PM] %s: %s", PlayerName(playerid), text);
	SendClientMessage(pID, -1, string);
	pInfo[pID][Last] = playerid;
	return 1;
}

dcmd_ms(playerid, const params[]) return dcmd_pm(playerid, params);
dcmd_m(playerid, const params[]) return dcmd_pm(playerid, params);
dcmd_r(playerid, const params[]) return dcmd_reply(playerid, params);

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256], idx, tmp[256];
	cmd = strtok(cmdtext, idx);

	printf("[command] %s entered \"%s\" command.", pName(playerid), cmdtext);

	// Roleplay commands:
	if (!strcmp(cmdtext, "/me", true, 3))
	{
		if (!cmdtext[3]) return showMessage(playerid, "USAGE: /me [action]");

		new text[128];
		format(text, sizeof(text), "* %s %s", pName(playerid), cmdtext[4]);
		SendClientMessageToAll(0xFFFF00AA, text);
		return 1;
	}

	// Campfire script:
	if (!strcmp(cmdtext, "/campfire", true))
	{
		if (campFire[playerid] == true) return showMessage(playerid, "You need quench your last campfire. (/firedown)");
		if (IsPlayerInAnyVehicle(playerid)) return showMessage(playerid, "Arabadayken ateş yakamazsınız!");
		campFire[playerid] = true;

		new Float:fireX, Float:fireY, Float:fireZ;
		GetPlayerPos(playerid, fireX, fireY, fireZ);
		fireWoods[playerid]	 = CreateDynamicObject(1463, fireX, fireY - 3.5, fireZ - 0.8, 0.000000, 0.000000, 0.000000);
		fireObject[playerid] = CreateDynamicObject(18689, fireX, fireY - 3.5, fireZ - 2.5, 0.000000, 0.000000, 0.000000);
		showMessage(playerid, "You setted a campfire. (Quench: /firedown)");
		return 1;
	}

	if (!strcmp(cmdtext, "/firedown", true))
	{
		if (campFire[playerid] == false) return showMessage(playerid, "Once you need setting a campfire. (/campfire)");
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken ateşi söndüremezsiniz!");

		new Float:fireX, Float:fireY, Float:fireZ;
		GetDynamicObjectPos(fireWoods[playerid], fireX, fireY, fireZ);
		if (!IsPlayerInRangeOfPoint(playerid, 7.0, fireX, fireY, fireZ)) return showMessage(playerid, "Kamp ateşinin yakınında değilsiniz! [7 metre]");

		campFire[playerid] = false;
		 DestroyDynamicObject(fireWoods[playerid]);
		  DestroyDynamicObject(fireObject[playerid]);
		showMessage(playerid, "Kamp ateşini söndürdünüz!");
		return 1;
	}

	// Guitar script:
	if (!strcmp(cmdtext, "/guitar", true))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken gitar çalamazsınız!");
		guitarSong[playerid] = true;

		new randomSongs[2][0] =
		{
			{"http://k007.kiwi6.com/hotlink/x3bp0yv6hg/Guitar1.mp3"},
			{"http://k007.kiwi6.com/hotlink/okyiex9pxh/Guitar2.mp3"}
		};
		new music = random(sizeof(randomSongs));
		new Float:pX, Float:pY, Float:pZ;
		GetPlayerPos(playerid, pX, pY, pZ);

		TogglePlayerControllable(playerid, 0);
		PlayAudioStreamForPlayer(playerid, randomSongs[music][0], pX, pY, pZ, 20.0, 1);
		SetPlayerAttachedObject(playerid, 0, 19317, 6, -0.434999, -0.387000, 0.180000, -58.100009, -96.599891, 24.100002, 1.000000, 1.000000, 1.000000);
		ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
		showMessage(playerid, "Gitar çalmaya başladınız, durmak için: /guitardown");
		return 1;
	}

	if (!strcmp(cmdtext, "/guitardown", true))
	{
		if (guitarSong[playerid] == false) return showMessage(playerid, "Zaten gitar çalmıyorsunuz! (/guitar)");
		
		guitarSong[playerid] = false;

		TogglePlayerControllable(playerid, 1);
		StopAudioStreamForPlayer(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid);
		showMessage(playerid, "Gitar çalmayı bıraktınız!");
		return 1;
	}


	if (!strcmp("/dmcik", cmdtext, true))
	{
		if (DM[playerid] == 0) return SendError(playerid, "Zaten deathmatch alanında değilsin!");
		DM[playerid] = 0;
		SetPlayerArmour(playerid, 0.0);
		SetPlayerHealth(playerid, 100.0);
		ResetPlayerWeapons(playerid);
		SpawnPlayer(playerid);
		SendInfo(playerid, "Deathmatch alanından çıktınız.");
		return 1;
	}

	if (DM[playerid] > 0) return SendError(playerid, "Deathmatch alanında komut kullanmak yasaktır. çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	// DCMD komutları
	dcmd(pm, 2, cmdtext);
	dcmd(ms, 2, cmdtext);
	dcmd(m, 1, cmdtext);
	dcmd(r, 1, cmdtext);
	dcmd(reply, 5, cmdtext);
	dcmd(pmac, 4, cmdtext);
	dcmd(pmkapat, 7, cmdtext);

	// Genel komutlar && dialog komutları
	if (!strcmp(cmdtext, "/kurallar", true))
	{
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Trinity-Xtreme / {009BFF}Kurallar", "{00FF00}~~ Hile kesinlikle yasaktır.\n~~ Argo yasaktır.\n~~ İnanç ve görüşe karşı hakaret yasaktır.\n~~ Yönetimi rahatsız etmek yasaktır.", "Kapat", "");
	return 1;
	}

	if (!strcmp(cmdtext, "/changelog", true))
	{
	ShowPlayerDialog(playerid, 1911, DIALOG_STYLE_MSGBOX, "Changelog / [ALPHA RC1.0]", "{ACDA00}~ Sunucu dosyaları oluçturuldu.\n~ LAdmin 4.0 eklendi.\n~ Changelog eklendi.\n~ Textdrawlar eklendi.\n~ Teles menüsü eklendi.\n~ Yardım menüsü eklendi.\n~ Kurallar menüsü eklendi.\n~ İlk haritalar ve araçlar eklendi.\n~ aLypSe Ev Sistemi moda eklendi.\n~ /v1-/v18 Araç spawn sistemi eklendi.\n~ /m1-/m12 Araç spawn sistemi eklendi.\n~ /paraver-/can-/yelek-/surus-/cevir komutları eklendi.", "RC1.1", "Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/teles", true))
	{
	ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme / {009BFF}Teleport", "{FFFFFF}Four Dragon Casino (/4dragon)\nChilliad Mountain (/dag)\nSanta Maria Beach (/sahil)\nArea51 Zone (/area51)\nSan Fierro ChinaTown (/china)\nLos Santos Los Flores (/flores)\nModifiye Yeri 1 (/mod1)\nModifiye Yeri 2 (/mod2)\nModifiye Yeri 3 (/mod3)\nModifiye Yeri 4 (/mod4)\nModifiye Yeri 5 (/mod5)\nAirport 1 (/ap1)\nAirport 2 (/ap2)\nAirport 3 (/ap3)\nAirport 4 (/ap4)\n~ Diçer Sayfa.", "Seç", "Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/dmler", true))
	{
	ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme / {009BFF}Deathmatch", "{FFFFFF}Desert Eagle Deathmatch - 1 (/deagledm1)\n{FFFFFF}Fight Club Deathmatch -1 (/fistdm1)", "Seç", "Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/stuntlar", true))
	{
	ShowPlayerDialog(playerid, 2001, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme / {009BFF}Stunt Zones", "{FFFFFF}Bikepark Stunt - 1 (/bikestunt1)", "Seç", "Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/silahlar", true))
	{
	ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
	return 1;
	}

	if (strcmp("/yardim", cmdtext, true, 10) == 0)
	{
		new string[2048];
		format(string, 2048, "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s", dIp[0], dIp[1], dIp[2], dIp[3], dIp[4], dIp[5], dIp[6], dIp[7], dIp[8], dIp[9], dIp[10], dIp[11], dIp[12], dIp[13], dIp[14], dIp[15], dIp[16], dIp[17]);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Trinity-Xtreme / {009BFF}Yardçm", string, "Kapat", "");
		return 1;
	}

	 if (strcmp("/myversion", cmdtext, true, 10) == 0)
	{
		new string[64];
		GetPlayerVersion(playerid, string, sizeof(string));
		format(string, sizeof(string), "** BİLGİ: {FFFFFF}SA-MP versiyonunuz: {00FF00}%s", string);
		SendClientMessage(playerid, 0x00A2F6AA, string);
		return 1;
	}

	// Araç yönetim komutları
	if (strcmp(cmd, "/motorac", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, VEHICLE_PARAMS_ON, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SendInfo(playerid, "Motor açıldı, kapatmak için {00FF00}/motorkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/motorkapat", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, VEHICLE_PARAMS_OFF, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SendInfo(playerid, "Motor kapatıldı, tekrar açmak için {00FF00}/motorac");
	}
	return 1;
	}

	if (strcmp(cmd, "/farac", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, VEHICLE_PARAMS_ON, alarm, kapilar, kaput, bagaj, objective);
	SendInfo(playerid, "Far açıldı, kapatmak için {00FF00}/farkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/farkapat", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, VEHICLE_PARAMS_OFF, alarm, kapilar, kaput, bagaj, objective);
	SendInfo(playerid, "Far kapatıldı, tekrar açmak için {00FF00}/farac");
	}
	return 1;
	}

	if (strcmp(cmd, "/alarmac", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, isiklar, VEHICLE_PARAMS_ON, kapilar, kaput, bagaj, objective);
	SendInfo(playerid, "Alarm açıldı, kapatmak için {00FF00}/alarmkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/alarmkapat", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, isiklar, VEHICLE_PARAMS_OFF, kapilar, kaput, bagaj, objective);
	SendInfo(playerid, "Alarm kapatıldı, tekrar açmak için {00FF00}/alarmac");
	}
	return 1;
	}

	if (strcmp(cmd, "/kaputac", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, VEHICLE_PARAMS_ON, bagaj, objective);
	SendInfo(playerid, "Kaput açıldı, kapatmak için {00FF00}/kaputkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/kaputkapat", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, VEHICLE_PARAMS_OFF, bagaj, objective);
	SendInfo(playerid, "Kaput kapatıldı, tekrar açmak için {00FF00}/kaputac");
	}
	return 1;
	}

	if (strcmp(cmd, "/bagajac", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, VEHICLE_PARAMS_ON, objective);
	SendInfo(playerid, "Bagaj açıldı, kapatmak için {00FF00}/bagajkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/bagajkapat", true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid, "Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, bagaj, objective);
	SetVehicleParamsEx(vid, motor, isiklar, alarm, kapilar, kaput, VEHICLE_PARAMS_OFF, objective);
	SendInfo(playerid, "Bagaj kapatıldı, tekrar açmak için {00FF00}/bagajac");
	}
	return 1;
	}

	if (!strcmp(cmdtext, "/kilit", true))
	{
		if (!IsPlayerInAnyVehicle(playerid)) return 1;
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
		if (Kilit[playerid] != 0) return 1;
		Kilit[playerid] = 1;
		Arac[playerid] = GetPlayerVehicleID(playerid);
		SendInfo(playerid, "Araç kilitlendi, kilidi açmak için {00FF00}/kilitac");
		return 1;
	}

	if (!strcmp(cmdtext, "/kilitac", true))
	{
		if (Kilit[playerid] != 1) return 1;
		new Float:X, Float:Y, Float:Z;
		GetVehiclePos(Arac[playerid], X, Y, Z);
		if (IsPlayerInRangeOfPoint(playerid, 5, X, Y, Z))
		{
			Kilit[playerid] = 0;

			SendInfo(playerid, "Kilit açıldı, aracı kilitlemek için {00FF00}/kilit");
		}
		return 1;
	}

	// Araç renk değiştirme
	if (strcmp(cmd, "/renk", true) == 0) {
		if (IsPlayerInAnyVehicle(playerid)) return SendError(playerid, "Araçta değilsiniz.");

		new color1, color2, string[128];
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp) || !IsNumeric(tmp)) return SendUse(playerid, "/renk {00FF00}[0-255] [0-255]");

		color1 = strval(tmp);
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp) || !IsNumeric(tmp))color2 = color1;
		else color2 = strval(tmp);
		if (color1<0 || color1>255 || color2<0 || color2>255)
		if (!strlen(tmp) || !IsNumeric(tmp)) return SendUse(playerid, "/renk {00FF00}[0-255] [0-255]");

		ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
		format(string, sizeof(string), "{FFFFFF}Araç rengi değiştirildi. [{009BFF}%d/%d{FFFFFF}]", color1, color2);
		SendInfo(playerid, string);

		return 1;
	}

	// Skin değiştirme komutu
	if (strcmp(cmdtext, "/myskin", true) == 7 || strcmp(cmdtext, "/skin", true) == 7) {
		if (cmdtext[7] != ' ' || cmdtext[8] == EOS) return SendUse(playerid, "/myskin [id]");
		if ((cmdtext[0] < 0) || (cmdtext[0] > 299)) return SendError(playerid, "Girilen de*er geçersiz!");
		
		if (IsValidSkin((cmdtext[0] = strval(cmdtext[8]))))
			SetPlayerSkin(playerid, cmdtext[0]);
		else
			SendError(playerid, "Girilen değer geçersiz!");
		
		return 1;
	}

	// DM alanı komutları
	if (!strcmp(cmdtext, "/deagledm1", true)) {
		DM[playerid] = 1;
		SetPlayerArmour(playerid, 100);
		SetPlayerHealth(playerid, 100);
		SetPlayerSkin(playerid, 285);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		ResetPlayerWeapons(playerid);
		new rand = random(sizeof(deagledm1pos));
		SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
		GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
		SendInfo(playerid, "Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
		GivePlayerWeapon(playerid, 24, 99999);
		SetPlayerTeam(playerid, NO_TEAM);
		return 1;
	}

	if (!strcmp(cmdtext, "/fistdm1", true)) {
		DM[playerid] = 2;
		SetPlayerArmour(playerid, 100);
		SetPlayerHealth(playerid, 100);
		SetPlayerSkin(playerid, 80);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 0);
		ResetPlayerWeapons(playerid);
		new rand = random(sizeof(fistdm1pos));
		SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
		GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
		SendInfo(playerid, "Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
		SetPlayerTeam(playerid, NO_TEAM);
		return 1;
	}

	// 31 sistemi komutları
	if (!strcmp("/31", cmd, true))
	{
		tmp = strtok(cmdtext, idx);

		if (!strlen(tmp)) return SendUse(playerid, "/31 [cek/birak]");

		if (!strcmp("cek", tmp, true)) {
			if (cekiyor[playerid] == 1) return SendError(playerid, "Zaten 31 çekmektesiniz.");
			ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
			ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
			asilantimer = SetTimerEx("asilanadamtimer", 19000, false, "i", playerid);
			cekiyor[playerid] = 1;
			return 1;
		}
		else if (!strcmp("birak", tmp, true)) {
			if (cekiyor[playerid] == 0) return SendError(playerid, "Zaten 31 çekmiyorsunuz.");
			SendInfo(playerid, "Artık 31 çekmiyorsunuz.");
			ClearAnimations(playerid);
			KillTimer(asilantimer);
			cekiyor[playerid] = 0;
			return 1;
		}
	return 1;
	}
	// Para gönderme komutu
	if (!strcmp("/paraver", cmd, true))
	{
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp)) return SendUse(playerid, "/paraver {00FF00}[id][miktar]");
		new id = strval(tmp);
		if (!IsPlayerConnected(id)) return SendError(playerid, "Oyuncu oyunda {FF0000}bulunmuyor!");
		tmp = strtok(cmdtext, idx);
		if (!strlen(tmp)) return SendUse(playerid, "/paraver {00FF00}[id][miktar]");
		new miktar = strval(tmp);

		if (miktar < 0) return SendError(playerid, "Girilen miktar {FF0000}geçersiz!");
		if (GetPlayerMoney(playerid) < miktar) return SendError(playerid, "Paranız {FF0000}yetersiz!");

		GivePlayerMoney(playerid, -miktar);
		GivePlayerMoney(id, miktar);
		return 1;
	}

	// Sürüş kamerası komutu
	if (strcmp("/surus", cmdtext, true, 10) == 0) {
		if (!IsPlayerInAnyVehicle(playerid)) return SendError(playerid, "Arabada olmalısınız!");
		
		if (GetPVarInt(playerid, "used") == 0) {
			new p = GetPlayerVehicleID(playerid);
			Surus[playerid] = CreatePlayerObject(playerid, 19300, 0.0000, -1282.9984, 10.1493, 0.0000, -1, -1, 100);
			AttachPlayerObjectToVehicle(playerid, Surus[playerid], p, -0.314999, -0.195000, 0.510000, 0.000000, 0.000000, 0.000000);
			AttachCameraToPlayerObject(playerid, Surus[playerid]);
			SetPVarInt(playerid, "used", 1);
			SendInfo(playerid, "Kamerayı eski haline döndürmek için {00FF00}/surus {FFFFFF}yazınız.");
		} else {
			SetCameraBehindPlayer(playerid);
			DestroyPlayerObject(playerid, Surus[playerid]);
			SetPVarInt(playerid, "used", 0);
			SendInfo(playerid, "Kamera eski haline döndürüldü.");
		}

		return 1;
	}

	// Can & zırh komutları
	if (strcmp(cmdtext, "/can", true) == 0 || strcmp(cmdtext, "/health", true) == 0) {
		if (GetPVarInt(playerid, "SpamKorumaCan") > GetTickCount()) return SendInfo(playerid, "Komutu tekrar kullanmak için 30 saniye bekleyiniz.");
		if (GetPlayerMoney(playerid) < 750) return SendError(playerid, "Paranız {FF0000}yetersiz!");
		
		SetPVarInt(playerid, "SpamKorumaCan", GetTickCount() + 30 * 1000);
		SetPlayerHealth(playerid, 100);
		GivePlayerMoney(playerid, -750);
		SendInfo(playerid, "Can paketi {00FF00}başarıyla {FFFFFF}alındı. [750$]");
		return 1;
	}

	if (strcmp(cmdtext, "/yelek", true) = = 0 || strcmp(cmdtext, "/zirh", true) == 0) {
		if (GetPVarInt(playerid, "SpamKorumaZırh") > GetTickCount()) return SendInfo(playerid, "Komutu tekrar kullanmak için 30 saniye bekleyiniz.");
		if (GetPlayerMoney(playerid) < 1000) return SendError(playerid, "Paranız {FF0000}yetersiz!");

		SetPVarInt(playerid, "SpamKorumaZırh", GetTickCount() + 30 * 1000);
		SetPlayerArmour(playerid, 100);
		GivePlayerMoney(playerid, -1000);
		SendInfo(playerid, "Zırh paketi {00FF00}başarıyla {FFFFFF}alındı. [1000$]");
		return 1;
	}

	// /v komutu
	if (!strcmp(cmdtext, "/v", true, 2)) {
		if (cmdtext[2] == EOS) return 0;

		new iList = strval(cmdtext[2]) - 1;
		if (!(0 <= iList <= 17)) return SendError(playerid, "Hatalı komut!");

		static s_szName[24], s_szVehDialog[256];
		
		s_szVehDialog = "";

		for (new i = (iList * 12), j = ((iList + 1) * 12); i < j; ++i) {
			if (i >= sizeof(g_VehNames)) break;

			strunpack(s_szName, g_VehNames[i]);
			strcat(s_szVehDialog, s_szName);
			strcat(s_szVehDialog, "\n");
		}
		
		ShowPlayerDialog(playerid, (DIALOG_OFFSET_ID + iList), DIALOG_STYLE_LIST, "Arac Listesi", s_szVehDialog, "Spawn", "Kapat");
		SetPVarInt(playerid, "iList", iList);
		return 0;
	}

	return SendError(playerid, "Komut bulunamadı!");
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (vehicleid == Arac[playerid] && Kilit[playerid] == 1)
	{
		ClearAnimations(playerid);
		return 0;
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	for (new i; i < HIZLANDIRICI_COUNT; i++) {
		if (pickupid == hizlandirici[i]) {
			if (!IsPlayerInAnyVehicle(playerid)) return;

			DestroyPickup(hizlandirici[i]);
			hizlandirici[i] = CreatePickup(1313, 14, speedLocation[i][0], speedLocation[i][1], speedLocation[i][2], 0);

			new Float:vx, Float:vy, Float:vz;
			GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);

			if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER) {
				SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
			}
		}
	}

	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// 2 tuşu fonksiyonu
	if (newkeys & KEY_LOOK_BEHIND && IsPlayerInAnyVehicle(playerid))
	{
		if (!IsNosVehicle(GetPlayerVehicleID(playerid))) return RepairVehicle(GetPlayerVehicleID(playerid)), PlayerPlaySound(playerid, 1133 , 0, 0, 0), GameTextForPlayer(playerid, "~b~~h~Full Tamir", 500, 5);
		
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		PlayerPlaySound(playerid, 1133 , 0, 0, 0);
		RepairVehicle(GetPlayerVehicleID(playerid));
		GameTextForPlayer(playerid, "~g~10x Nitro ~w~~h~& ~b~~h~Tamir", 500, 5);
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	// EXP sistemi
	new str[64];
	format(str, sizeof(str), "EXP:%d/1000 - Level:%d/50", exp[playerid], seviye[playerid]);
	TextDrawSetString(expmeter[playerid], str);
	//SetProgressBarValue(Bar:expbar[playerid], exp[playerid]);


	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	// Silah menüsü
	if (dialogid == 9500 && response) {
		if (listitem == 0) return ShowPlayerDialog(playerid, 9501, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		else if (listitem == 1) return ShowPlayerDialog(playerid, 9502, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		else if (listitem == 2) return ShowPlayerDialog(playerid, 9503, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Pompalılar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		else if (listitem == 3) return ShowPlayerDialog(playerid, 9504, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Mak. Tüfekler", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		else if (listitem == 4) return ShowPlayerDialog(playerid, 9505, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Yivli Tüfekler", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		else if (listitem == 5) return ShowPlayerDialog(playerid, 9506, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Patlayıcılar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		else if (listitem == 6) return ShowPlayerDialog(playerid, 9507, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
	}

	// Tabancalar
	if (dialogid == 9501 && response) {
		if (listitem == 1) SilahSat(playerid, 22, 200, "Colt .45", 500);
		else if (listitem == 2) SilahSat(playerid, 23, 200, "Susturuculu Colt .45", 700);
		else if (listitem == 3) SilahSat(playerid, 24, 200, "Desert Eagle", 1200);

		if (listitem == 4) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9501, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Otomatik tabancalar
	if (dialogid == 9502 && response) {
	{
		if (listitem == 1) SilahSat(playerid, 28, 200, "Micro Uzi", 1250);
		else if (listitem == 2) SilahSat(playerid, 32, 200, "TEC-9", 1700);
		else if (listitem == 3) SilahSat(playerid, 29, 200, "MP-5", 2300);

		if (listitem == 4) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9502, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Pompalı tüfekler
	if (dialogid == 9503 && response) {
		if (listitem == 1) SilahSat(playerid, 25, 200, "Pump-Action Shotgun", 3000);
		else if (listitem == 2) SilahSat(playerid, 26, 200, "Double-Barrel Shotgun", 4600);
		else if (listitem == 3) SilahSat(playerid, 27, 200, "Combat Shotgun", 6500);

		if (listitem == 4) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9503, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Pompalılar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Makineli tüfekler
	if (dialogid == 9504 && response)
	{
		if (listitem == 1) SilahSat(playerid, 31, 200, "M4A1 Carbine", 9500);
		else if (listitem == 2) SilahSat(playerid, 30, 200, "Avtomat Kalashnikova 47", 7500);

		if (listitem == 3) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9504, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Mak. Tçfekler", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Yivli tüfekler
	if (dialogid == 9505 && response) {
		if (listitem == 1) SilahSat(playerid, 33, 200, "Country Rifle .22", 6700);
		else if (listitem == 2) SilahSat(playerid, 34, 200, "Sniper Rifle", 9750);

		if (listitem == 3) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9505, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Yivli Tüfekler", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Patlayıcılar
	if (dialogid == 9506 && response) {
		if (listitem == 1) SilahSat(playerid, 16, 1, "Grenade", 600);
		else if (listitem == 2) SilahSat(playerid, 17, 1, "Gas Grenade", 250);
		else if (listitem == 3) SilahSat(playerid, 18, 1, "Molotov", 700);

		if (listitem == 4) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9506, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Patlayıcılar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Ateşsiz silahlar
	if (dialogid == 9507 && response) {
		if (listitem == 1) SilahSat(playerid, 1, 1, "Brass Knuckles", 50);
		else if (listitem == 2) SilahSat(playerid, 5, 1, "Baseball Bat", 100);
		else if (listitem == 3) SilahSat(playerid, 2, 1, "Golf Club", 120);
		else if (listitem == 4) SilahSat(playerid, 4, 1, "Knife", 250);
		else if (listitem == 5) SilahSat(playerid, 41, 1200, "Spray", 300);
		else if (listitem == 6) SilahSat(playerid, 42, 5500, "Fire Extinguisher", 450);

		if (listitem == 7) {
			ShowPlayerDialog(playerid, 9500, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü", "{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalı tüfekler\n{FFFFFF}~ {ACDA00}Makinalı tüfekler\n{FFFFFF}~ {ACDA00}Yivli tüfekler\n{FFFFFF}~ {ACDA00}Patlayıcılar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar", "Seç", "Kapat");
		} else {
			ShowPlayerDialog(playerid, 9507, DIALOG_STYLE_LIST, "{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar", "{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.", "Seç", "Kapat");
		}
	}

	// Teles alanları diyalogları
	if (dialogid == 1000 && response) {
		if (listitem == 0) return Teleport(playerid, 2027.8171, 1008.1444, 10.8203, 0, 0, "Four Dragon Casino", "/4d", 1, 0);
		else if (listitem == 1) return Teleport(playerid, -2353.0940, -1633.6820, 483.6954, 0, 0, "Chilliad Mountain", "/dag", 1, 0);
		else if (listitem == 2) return Teleport(playerid, 369.8283, -1787.7871, 5.3585, 0, 0, "Santa Maria Beach", "/sahil", 1, 0);
		else if (listitem == 3) return Teleport(playerid, 231.5036, 1914.3851, 17.6406, 0, 0, "Area51", "/area51", 1, 0);
		else if (listitem == 4) return Teleport(playerid, -2276.2874, 718.5117, 49.4453, 0, 0, "China Town", "/china", 1, 0);
		else if (listitem == 5) return Teleport(playerid, 2786.9534, -1319.9723, 34.7975, 0, 0, "Los Flores", "/flores", 1, 0);
		else if (listitem == 6) return Teleport(playerid, -1917.2754, 287.0215, 41.0469, 0, 0, "Modifiye Yeri 1", "/mod1", 1, 0);
		else if (listitem == 7) return Teleport(playerid, -2705.5503, 206.1621, 4.1797, 0, 0, "Modifiye Yeri 2", "/mod2", 1, 0);
		else if (listitem == 8) return Teleport(playerid, 2387.4126, 1022.6620, 10.8203, 0, 0, "Modifiye Yeri 3", "/mod3", 1, 0);
		else if (listitem == 9) return Teleport(playerid, 2644.7686, -2019.1096, 13.5507, 0, 0, "Modifiye Yeri 4", "/mod4", 1, 0);
		else if (listitem == 10) return Teleport(playerid, 1042.0564, -1045.5176, 31.8108, 0, 0, "Modifiye Yeri 5", "/mod5", 1, 0);
		else if (listitem == 11) return Teleport(playerid, 1686.7, -2450.2, 13.6, 0, 0, "Airport 1", "/ap1", 1, 0);
		else if (listitem == 12) return Teleport(playerid, -1345.0, -229.8, 14.1, 0, 0, "Airport 2", "/ap2", 1, 0);
		else if (listitem == 13) return Teleport(playerid, 1435.5, 1463.2, 10.8, 0, 0, "Airport 3", "/ap3", 1, 0);
		else if (listitem == 14) return Teleport(playerid, 350.7, 2539.2, 16.8, 0, 0, "Airport 4", "/ap4", 1, 0);
	}

	// Changelog dialogları
	if (dialogid == 1911 && response) ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "Changelog / [ALPHA RC1.1]", "{ACDA00}~ Textdrawlar düzenlendi.\n~ Teles menüsü güncellendi. {FFFFFF}(4 yeni teleport alanı){ACDA00}\n~ Admin sistemi düzenlendi.\n~ Yardım menüsü düzenlendi.\n~ \"Desert Eagle Deathmatch\" alanı eklendi.\n~ çlçm-çldçrme gçstergesi eklendi.\n~ /skin komutu eklendi.\n~ /renk komutu eklendi.\n~ Ufak buglar giderildi.\n~ DM sistemi eklendi.", "RC1.2", "Kapat");
	if (dialogid == 1912 && response) ShowPlayerDialog(playerid, 1913, DIALOG_STYLE_MSGBOX, "Changelog / [ALPHA RC1.2]", "{ACDA00}~ Ufak buglar giderildi.\n~ \"Fight Club Deathmatch\" alanç eklendi.\n~ Eksik haritalar güncellendi.\n~ \"Bikepark Stunt 1\" alanı eklendi.\n~ /nrg komutu eklendi.\n~ Araç yönetim komutları eklendi.\n~ Website eklendi. {FFFFFF}(trinity.immortal-official.tk){ACDA00}\n~ Textdraw kaymaları düzeltildi.\n~ Gametext süreleri düşürüldü.\n~ Giriş düzenlendi.", "RC1.3", "Kapat");
	if (dialogid == 1913 && response) ShowPlayerDialog(playerid, 1914, DIALOG_STYLE_MSGBOX, "Changelog / [ALPHA RC1.3]", "{ACDA00}~ ALPHA hesapları silindi.\n~ Kick-Ban mesajları ve Giriş-çıkış mesajları güncellendi.\n~ Araç Kilit Sistemi eklendi. {FFFFFF}(/kilit - /kilitac){ACDA00}\n~ 31 sistemi bugu giderildi.\n~ Ufak buglar giderildi.\n~ Changelog düzenlendi.\n~ Yeni haritalar eklendi.\n~ Gelişmiş saat sistemi eklendi.\n~ RGM-GM sistemi bugları giderildi.\n~ Sohbet baloncuğu eklendi.\n~ Driveby engeli kaldırıldı.", "RC1.4", "Kapat");
	if (dialogid == 1914 && response) ShowPlayerDialog(playerid, 1915, DIALOG_STYLE_MSGBOX, "Changelog / [ALPHA RC1.4]", "{ACDA00}~ EXP-LEVEL sistemi eklendi.\n~ Ev sistemi güncellendi.\n~ Ufak buglar giderildi.\n~ LAdmin güncellendi. (4.4)\n~ Teleport komutları düzenlendi.\n~ EXP-LEVEL textdrawı yenilendi.\n~ Object Streamer eklendi.\n~ Modifiye alanları ve Airport'lar için teleport eklendi. {FFFFFF}(/teles)\n{ACDA00}~ Silahlar menüsü eklendi. {FFFFFF}(/silahlar)\n{ACDA00}~ aLAdmin sistemi eklendi.\n~ Girişe dans eklendi.", "RC1.5", "Kapat");
	if (dialogid == 1915 && response) ShowPlayerDialog(playerid, 1916, DIALOG_STYLE_MSGBOX, "Changelog / [ALPHA RC1.5]", "{ACDA00}~ ", "Kapat", "");

	// DM alanı dialogları
	if (dialogid == 2000 && response) {
		if (listitem == 0) {
			DM[playerid] = 1;
			SetPlayerArmour(playerid, 100);
			SetPlayerHealth(playerid, 100);
			SetPlayerSkin(playerid, 285);
			SetPlayerInterior(playerid, 0);
			ResetPlayerWeapons(playerid);
			new rand = random(sizeof(deagledm1pos));
			SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
			GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 5000, 1);
			SendInfo(playerid, "Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			GivePlayerWeapon(playerid, 24, 99999);
			SetPlayerTeam(playerid, NO_TEAM);
		}

		if (listitem == 1) {
			DM[playerid] = 2;
			SetPlayerArmour(playerid, 100);
			SetPlayerHealth(playerid, 100);
			SetPlayerSkin(playerid, 80);
			SetPlayerInterior(playerid, 1);
			ResetPlayerWeapons(playerid);
			new rand = random(sizeof(fistdm1pos));
			SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
			GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 5000, 1);
			SendInfo(playerid, "Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			SetPlayerTeam(playerid, NO_TEAM);
		}
	}

	// Stunt dialogları
	if (dialogid == 2001 && response) {
		if (listitem == 0) {
			SendInfo(playerid, "{00FF00}Bikepark Stunt - 1 {FFFFFF}alanına ışınlanıldı.");
			SetPlayerPos(playerid, 1165.3389, 1344.6733, 10.8125);
		}
	}

	// Araç spawn ayarları
	if (response) {
		new iList = GetPVarInt(playerid, "iList");

		if (dialogid == (DIALOG_OFFSET_ID + iList)) {

			if (0 <= listitem <= 12) {
				new Float: fPos[3];

				if (GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2])) {
					new iVehID = GetPVarInt(playerid, "iVehID"), Float: fAngle;

					if (IsPlayerInAnyVehicle(playerid))
					GetVehicleZAngle(GetPlayerVehicleID(playerid), fAngle);
					else
					GetPlayerFacingAngle(playerid, fAngle);

					if (iVehID)
					DestroyVehicle(iVehID);

					iVehID = (listitem + (iList * 12) + 400);

					// Yasak Araç ayarları
					switch (iVehID)
					{
						case 425, 432, 520:
						return 1;
					}


					iVehID = CreateVehicle(iVehID, fPos[0], fPos[1], fPos[2], fAngle, -1, -1, 1 << 16);
					PutPlayerInVehicle(playerid, iVehID, 0);

					SetPVarInt(playerid, "iVehID", iVehID);
				}
			}
		}
	}
	return 1;
}

// strtok
strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' ')) {
		index++;
	}

	new offset = index;
	new result[20];

	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1))) {
		result[index - offset] = string[index];
		index++;
	}

	result[index - offset] = EOS;
	return result;
}

// Silah sistemi
stock SilahSat(playerid, silahid, silahammo, const silahisim[], ucret)
{
	if (GetPlayerMoney(playerid) < ucret) return SendError(playerid, "Para yetersiz!");
	GivePlayerWeapon(playerid, silahid, silahammo);
	GivePlayerMoney(playerid, -ucret);
	new string[512];
	format(string, sizeof(string), "{ACDA00}%d$ {FFFFFF}ödeyerek {ACDA00}%s {FFFFFF}aldınız.", ucret, silahisim);
	SendInfoToAll(string);
	return 1;
}

// EXP sistemi
stock BilgiYenile(playerid)
{
	printf("%i", playerid);
	// do nothing
}

stock BilgiYukle(playerid)
{
	printf("%i", playerid);
	// do nothing
}

stock ExpVer(playerid)
{
	printf("%i", playerid);
	// do nothing
}

/*
stock BilgiYenile(playerid)
{
new SPL[256], is[24];
GetPlayerName(playerid, is, sizeof(is));
format(SPL, sizeof(SPL), "Hesaplar/Level/%s.txt", is);

//dini_IntSet(SPL, "Exp", exp[playerid]);
//dini_IntSet(SPL, "Level", seviye[playerid]);
//dini_IntSet(SPL, "Skor", GetPlayerScore(playerid));

new str[64];
format(str, sizeof(str), "EXP:%d/1000 - Level:%d/50", exp[playerid], seviye[playerid]);
TextDrawSetString(expmeter[playerid], str);
//SetProgressBarValue(Bar:expbar[playerid], exp[playerid]);
return 1;}

stock BilgiYukle(playerid)
{
new SPL[256], is[24];
GetPlayerName(playerid, is, sizeof(is));
format(SPL, sizeof(SPL), "Hesaplar/Level/%s.txt", is);

exp[playerid] = dini_Int(SPL, "Exp");
seviye[playerid] = dini_Int(SPL, "Level");
SetPlayerScore(playerid, dini_Int(SPL, "Skor"));
//SetProgressBarValue(Bar:expbar[playerid], exp[playerid]);
return 1;}

stock ExpVer(playerid){
	if (seviye[playerid] == 1)
	{
	exp[playerid] = exp[playerid]+20;
	}
	else if (seviye[playerid] == 2)
	{
	exp[playerid] = exp[playerid]+18;
	}
	else if (seviye[playerid] == 3)
	{
	exp[playerid] = exp[playerid]+18;
	}
	else if (seviye[playerid] == 4)
	{
	exp[playerid] = exp[playerid]+16;
	}
	else if (seviye[playerid] == 5)
	{
	exp[playerid] = exp[playerid]+14;
	}
	else if (seviye[playerid] == 6)
	{
	exp[playerid] = exp[playerid]+12;
	}
	else if (seviye[playerid] == 7)
	{
	exp[playerid] = exp[playerid]+10;
	}
	else if (seviye[playerid] == 8)
	{
	exp[playerid] = exp[playerid]+8;
	}
	else if (seviye[playerid] == 9)
	{
	exp[playerid] = exp[playerid]+6;
	}
	else if (seviye[playerid] == 10)
	{
	exp[playerid] = exp[playerid]+4;
	}
	else if (seviye[playerid] == 11)
	{
	exp[playerid] = exp[playerid]+4;
	}
	else if (seviye[playerid] == 12)
	{
	exp[playerid] = exp[playerid]+3;
	}
	else if (seviye[playerid] == 13)
	{
	exp[playerid] = exp[playerid]+3;
	}
	else if (seviye[playerid] == 14)
	{
	exp[playerid] = exp[playerid]+2;
	}
	else if (seviye[playerid] == 15)
	{
	exp[playerid] = exp[playerid]+2;
	}
	else if (seviye[playerid] == 16)
	{
	exp[playerid] = exp[playerid]+2;
	}
	else if (seviye[playerid] == 17)
	{
	exp[playerid] = exp[playerid]+1;
	}
	else if (seviye[playerid] == 18)
	{
	exp[playerid] = exp[playerid]+1;
	}
	else if (seviye[playerid] == 19)
	{
	exp[playerid] = exp[playerid]+1;
	}
	else if (seviye[playerid] > 19)
	{
	exp[playerid] = exp[playerid]+1;
	}

	if (exp[playerid] >= 1000){
	if (seviye[playerid] < 50){
	seviye[playerid]++;
	exp[playerid] = 0;
	}}
	return 1;
}
*/
/*
// Saat sistemi
forward UpdateServerTime();
public UpdateServerTime()
{
	Minute + = 1;

	if (Minute == 60 && Hour < 23) {
		Hour + = 1;
		Minute = 0;
		SetWorldTime(Hour);
	}

	if (Hour > 23) {
		Hour = 0;
		Minute = 0;
		SetWorldTime(Hour);
	}

	new string[6];
	format(string, sizeof(string), "%02d:%02d", Hour, Minute);
	TextDrawSetString(TimeText, string);

	for (new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
		if (!IsPlayerConnected(playerid)) continue;
		SetPlayerTime(playerid, Hour, Minute);
	}
	return 1;
}

// 31 çekme sistemi
forward asilanadamtimer(playerid);
public asilanadamtimer(playerid)
{
	if (cekiyor[playerid] == 1)
	{
	GivePlayerMoney(playerid, 31);
	SendInfo(playerid, "31'den para aldınız! {FF0000}(31$)");
	}
	return 1;
}

// Random spawn publici
forward SetPlayerRandomSpawn(playerid);
public SetPlayerRandomSpawn(playerid)
{
	new rand = random(sizeof(RandomPlayerSpawns));
	SetPlayerPos(playerid, RandomPlayerSpawns[rand][0], RandomPlayerSpawns[rand][1], RandomPlayerSpawns[rand][2]);
	return 1;
}

// IsNumeric
stock IsNumeric(const string[])
{
   for (new i, j = strlen(string); i < j; ++i) {
	  if (!('0' <= string[i] <= '9')) {
		 return 0;
	  }
   }
   return 1;
}

// Nos alabilecek Araçlar
IsNosVehicle(vehicleid)
{
	#define NO_NOS_VEHICLES 29

	new InvalidNosVehicles[NO_NOS_VEHICLES] = {
		581, 523, 462, 521, 463, 522, 461, 448, 468, 586,
		509, 481, 510, 472, 473, 493, 595, 484, 430, 453,
		452, 446, 454, 590, 569, 537, 538, 570, 449
	};

	for (new i = 0; i < NO_NOS_VEHICLES; i++) {
		if (GetVehicleModel(vehicleid) == InvalidNosVehicles[i]) {
			return false;
		}
	}
	return true;
}

public PlayerPos(playerid, Float:X, Float:Y, Float:Z, interior, world)
{
	SetPlayerPos(playerid, X, Y, Z);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, world);
	return 1;
}

// Oyuncu idi fonksiyonu
/*
GetPlayerID(const PlayerName[])
{
	 new pName[MAX_PLAYER_NAME];

	for (new i = 0; i < GetMaxPlayers(); i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, pName, MAX_PLAYER_NAME);
			if (strfind(pName, PlayerName, true) != -1)
			{
				return i;
			}
		}
	}
	return -1;
}
*//*

// Silah adları
stock WeaponName(weaponid)
{
	new wname[32];
	GetWeaponName(weaponid, wname, sizeof(wname));
	return wname;
}

// Yasak skinler
stock IsValidSkin(iSkin)
{
	switch (iSkin)
	{
		case 3, 4, 5, 6, 8, 42, 53, 65, 74, 86, 91, 119, 149, 208, 273, 289:
			return 0;
	}
	return 1;
}

// DeletePlayerWeapon Fonksiyonu
stock DeletePlayerWeapon(playerid, weaponid)
{
	new gWeaponData[13][2];

	for (new i; i != sizeof(gWeaponData); ++i)
	{
		GetPlayerWeaponData(playerid, i, gWeaponData[i][0], gWeaponData[i][1]);

		gWeaponData[i][1] = gWeaponData[i][1] < 0 ? -gWeaponData[i][1] : gWeaponData[i][1];
	}
	ResetPlayerWeapons(playerid);

	for (new i; i != sizeof(gWeaponData); ++i)
	{
		if (gWeaponData[i][0] != weaponid)
		{
			GivePlayerWeapon(playerid, gWeaponData[i][0], gWeaponData[i][1]);
		}
	}
	return 1;
}

// General player timer:
forward playerGameTimer(playerid);
public playerGameTimer(playerid)
{
	 if (PlayerAccount[playerid][pA_Hungry] >= 0 && PlayerAccount[playerid][pA_Hungry] < 50)
	 {
		new Float: playerHealth;
		GetPlayerHealth(playerid, playerHealth);
		TextDrawSetString(textdraw_hungry[playerid], "HUNGRY: ~g~~h~LOW");

		if (playerHealth < 100)
			SetPlayerHealth(playerid, playerHealth + 3.0);
	}
	else if (PlayerAccount[playerid][pA_Hungry] > 50 && PlayerAccount[playerid][pA_Hungry] < 100)
		TextDrawSetString(textdraw_hungry[playerid], "HUNGRY: ~y~MEDIUM");
	else if (PlayerAccount[playerid][pA_Hungry] > 100)
	{
		new Float: playerHealth;
		GetPlayerHealth(playerid, playerHealth);
		TextDrawSetString(textdraw_hungry[playerid], "HUNGRY: ~r~~h~HIGH!");

		if (playerHealth < 25)
			SetPlayerHealth(playerid, playerHealth - 3.0);
	}

	if (PlayerAccount[playerid][pA_Radiation] == 0)
	{
		TextDrawSetString(textdraw_radiation[playerid], "RADIATION: ~w~NONE");
	}
	else
	{
		new radiationText[64];
		 if (PlayerAccount[playerid][pA_Radiation] < 40) format(radiationText, sizeof(radiationText), "RADIATION: ~g~~h~%d", PlayerAccount[playerid][pA_Radiation]);
		 else if (PlayerAccount[playerid][pA_Radiation] < 90) format(radiationText, sizeof(radiationText), "RADIATION: ~y~%d", PlayerAccount[playerid][pA_Radiation]);
		 else format(radiationText, sizeof(radiationText), "RADIATION: ~r~~h~%d", PlayerAccount[playerid][pA_Radiation]);
		 
		TextDrawSetString(textdraw_radiation[playerid], radiationText);
	}

	new pingText[64];
	if (GetPlayerPing(playerid) < 80) format(pingText, sizeof(pingText), "PING: ~g~~h~%d", GetPlayerPing(playerid));
	else if (GetPlayerPing(playerid) < 200) format(pingText, sizeof(pingText), "PING: ~y~%d", GetPlayerPing(playerid));
	else format(pingText, sizeof(pingText), "PING: ~r~~h~%d", GetPlayerPing(playerid));

	TextDrawSetString(textdraw_ping[playerid], pingText);
}

// Player hungry timer:
forward addHungry(playerid);
public addHungry(playerid)
{
	PlayerAccount[playerid][pA_Hungry]++;
}

// Kick/Ban timer:
forward PlayerKick(playerid);
public PlayerKick(playerid)
{
	Kick(playerid);
}

forward PlayerBan(playerid, ex[]);
public PlayerBan(playerid, ex[])
{
	BanEx(playerid, ex);
}

stock pIP(playerid)
{
	new ip[16];
	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

// Account script:
stock AccountReset(playerid)
{
	PlayerAccount[playerid][pA_Pass] 		 = -1;
	PlayerAccount[playerid][pA_AdminLevel] = -1;
	PlayerAccount[playerid][pA_Killed]     = -1;
	PlayerAccount[playerid][pA_Death]      = -1;
	PlayerAccount[playerid][pA_Score]      = -1;
	PlayerAccount[playerid][pA_Money]      = -1;
	PlayerAccount[playerid][pA_Radiation]  = -1;
	PlayerAccount[playerid][pA_Hungry]     = -1;
	PlayerAccount[playerid][pA_Comfort]    = -1;
	PlayerAccount[playerid][pA_X]          = -1;
	PlayerAccount[playerid][pA_Y]          = -1;
	PlayerAccount[playerid][pA_Z]          = -1;
	PlayerAccount[playerid][pA_Interior]   = -1;
	PlayerAccount[playerid][pA_IP]         = -1;
	PlayerAccount[playerid][pA_Online]     = -1;
	PlayerAccount[playerid][pA_LastOnline] = -1;
}
*/