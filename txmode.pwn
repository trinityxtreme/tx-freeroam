//============================================================================//
//                           Trinity-Xtreme                                   //
//                                Survival Freeroam Project                   //
//                                                                            //
//										Gamemode by naphteine (aka. ImmortaL) //
// 														Map & art by Crosscuk //
// Development started at 2013-01-27 - 01:52 UTC+2							  //
//============================================================================//

// ** Library include
#include <a_samp>		// SA-MP 0.3x kütüphanesi
#include <sscanf2>		// SSCANF kütüphanesi
#include <streamer>		// Obje streamer kütüphanesi
//#include <progress2>	// Progressbar kütüphanesi

// ** Server settings
#define server_name     "Trinity-Xtreme Freeroam"
#define server_version  "1.0.0"
#define server_modname  "Xtreme"
#define server_mapname  "San Andreas"

#define mysql_hostname  "localhost"
#define mysql_username  "root"
#define mysql_password  ""
#define mysql_database  "supervivencia"

#undef MAX_PLAYERS
#define MAX_PLAYERS     (50)

// ** Standart message formats
#define showMessage(%0,%1) SendClientMessage(%0, -1, "{BBBBBB}** {00B3FF}" %1)
#define showDialog(%0,%1)  ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{BBBBBB}** {00B3FF}" %0 " {BBBBBB}**","{BBBBBB}" %1, "Tamam", "")
#define SendError(%0,%1) SendClientMessage(%0,0xF63845AA, "[!] HATA: {FFFFFF}" %1)
#define SendInfo(%0,%1) SendClientMessage(%0,0x00A2F6AA, "[*] BİLGİ: {FFFFFF}" %1)
#define SendUse(%0,%1) SendClientMessage(%0,0x8C50FFAA, "[?] KULLANIM: {FFFFFF}" %1)

// ** Textdraws
new Text:textdraw_server;
new Text:textdraw_hungry[MAX_PLAYERS];
new Text:textdraw_radiation[MAX_PLAYERS];
new Text:textdraw_ping[MAX_PLAYERS];
new Text:textdraw_key1[MAX_PLAYERS];
new Text:textdraw_key2[MAX_PLAYERS];
new Text:textdraw_key3[MAX_PLAYERS];
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw9;

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

// - DCMD defineleri
#define dcmd(%1,%2,%3) if (!strcmp((%3)[1], #%1, true, (%2)) && ((((%3)[(%2) + 1] == '\0') && (dcmd_%1(playerid, ""))) || (((%3)[(%2) + 1] == ' ') && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

// - Ev sistemi defineleri
#define DIALOG 8000 // Başlangıç dialog id
#define MAX_HOUSE 100 // Toplam yaratılan ev sayısı.
#define BASLIK "{FFFFFF}Trinity-Xtreme / {009BFF}Ev Sistemi" // Dialog, mesaj başlıkları

#define ACIKLAMA "Satılık Ev! (/satinal & /ev)" // Default yeni yaratılan evin açıklaması
#define FIYAT 20000 // Default yeni yaratılan evin fiyatı
#define KILIT 1 // Default yeni yaratılan evin kilidi ( 0: Açık - 1: Kilitli )
#define KASA 0 // Default yeni yaratılan evin kasasındaki para

#define MENU DIALOG+15 // Değiştirmeye gerek yok
#define SATINAL MENU+15 // Değiştirmeye gerek yok

#define BLUEH 1272 // Ellemeyin.
#define GREENH 1273 // Ellemeyin.
#define REDMAP 32 // Ellemeyin.
#define GREENMAP 31 // Ellemeyin.
#define ARROW 1318 // Ellemeyin.

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

// - Girişte dans tanıtımları
new RandAnims[6][] = {
	"DAN_LOOP_A",
	"DNCE_M_A",
	"DNCE_M_B",
	"DNCE_M_C",
	"DNCE_M_D",
	"DNCE_M_E"
};

// - PM sistemi tanıtımları
enum PlayerInfo
{
	Last,
	NoPM,
}

new pInfo[MAX_PLAYERS][PlayerInfo];

// - Exp sistemi tanıtımları
new exp[MAX_PLAYERS], seviye[MAX_PLAYERS], expguncelle[MAX_PLAYERS];
new Text:expbox;
new Text:expmeter[MAX_PLAYERS]; 

// new Bar:expbar[MAX_PLAYERS];

// - Saat sistemi tanıtımları
new Hour,
	Minute,
	Timer,
	Text:TimeText;

// - Araç yönetim tanıtımları
new motor,isiklar,alarm,kapilar,kaput,bagaj,objective;
new Kilit[MAX_PLAYERS] = 0;
new Arac[MAX_PLAYERS];

// - DM sistemi tanıtımları
new DM[MAX_PLAYERS];

// - Desert Eagle Deathmatch - 1
new Float:deagledm1pos[7][6] = {
	{2441.3003,1809.5614,16.3222},
	{2434.2029,1793.4486,16.3222},
	{2421.7632,1791.1007,16.3222},
	{2431.6787,1790.4875,16.3222},
	{2423.8142,1820.0522,16.3222},
	{2423.8674,1832.9325,16.3222},
	{2407.1179,1812.8815,16.3222}
};

// - Fist Deathmatch - 1
new Float:fistdm1pos[4][6] = {
	{2192.8518,2516.2422,585.7723},
	{2193.9260,2562.2336,585.7723},
	{2147.8921,2563.0903,585.7723},
	{2146.9512,2517.0962,585.7723}
};

// - Yardım menüsü tanıtımları
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
	"\n\nBu mod {009BFF}MR.ImmortaL {FFFFFF}tarafçndan kodlanmıştır."
};

// - 31 sistemi tanıtımları
new asilantimer;
new cekiyor[MAX_PLAYERS] = 0;

// - FPS sistemi tanıtımları
new Surus[MAX_PLAYERS];
new firstperson[MAX_PLAYERS];

// - Araç spawn sistemi tanıtımları
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

// - Modifiyeli Araç spawn sistemi tanıtımları
enum ModArac
{
	pMAraba,
	pMArabaID
};

new MCarPlayerInfo[MAX_PLAYERS][ModArac];

// - Hızlandırıcı Pickup
#define HIZLANDIRICI_COUNT 14
new hizlandirici[HIZLANDIRICI_COUNT];
#define HIZ_VER 5

// - Ev sistemi tanıtımları
enum bilgi
{
	evaciklama[255],
	evsahip[255],
	evsatilik,
	evfiyat,
	evkilit,
	evbanka,
	evint,
	evworld,
	Float:ev_X,
	Float:ev_Y,
	Float:ev_Z,
	evvid,
	silahslot1,
	silahslot2,
	silahslot3,
	silahslot4,
	silahslot5,
	silahslot6,
	silahslot1x,
	silahslot2x,
	silahslot3x,
	silahslot4x,
	silahslot5x,
	silahslot6x
};

new EvBilgi[MAX_HOUSE][bilgi],
	//Text3D:TextLabel[MAX_HOUSE],
	Pickup[MAX_HOUSE]=0,
	bool:EvEditleniyor[MAX_HOUSE],
	OyuncuEv[MAX_PLAYERS] = -1,
	OyuncuKontrolEv[MAX_PLAYERS]=-255,
	ToplamEv=0,
	EvSahipID[MAX_HOUSE]=-1;

forward EvYukle(evid);
forward EvYenile(evid);
forward EvSil(evid);
forward EvYarat(evid, Float:X, Float:Y, Float:Z);
forward EvKaydetInt(evid, const bilgii[],deger);
forward EvKaydetStr(evid, const bilgii[], const deger[]);
forward EvKaydetFloat(evid, const bilgii[], Float:deger);
forward EvPickupYenile(evid);
forward Kontrol(playerid);
forward OyuncuMapIconKontrol(playerid);
forward PlayerPos(playerid, Float:X, Float:Y, Float:Z,interior,world);
forward SahipKontrol();
forward EvYakininda(playerid);

// - Random spawn
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

	// - General settings
	SendRconCommand("rcon 0");

	SetGameModeText(server_modname " " server_version);
	new serverSettings[64];

	format(serverSettings, sizeof(serverSettings), "hostname %s", server_name);
	SendRconCommand(serverSettings);

	format(serverSettings, sizeof(serverSettings), "mapname %s", server_mapname);
	SendRconCommand(serverSettings);

	SetWeather(18); // 15 for dark survival sky
	UsePlayerPedAnims();
	AllowInteriorWeapons(1);
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(2);
	ShowNameTags(1);
	SetNameTagDrawDistance(25.0);

	for (new i=0; i<299; i++) {
		AddPlayerClass(i,1958.2111,1343.5758,15.3746,274.2440,24,100,27,80,32,500);
	}
	
	printf("  ** LOADED: general settings.");

	// - Textdraws
	Textdraw0 = TextDrawCreate(310.000000, 435.000000, "~r~~h~~h~ /yardim ~w~~h~~h~/teles /silahlar /stuntlar /dmler /shop /animlist /v1..18 /m1..12 ~r~~h~~h~/kurallar");
	TextDrawAlignment(Textdraw0, 2);
	TextDrawBackgroundColor(Textdraw0, 255);
	TextDrawFont(Textdraw0, 1);
	TextDrawLetterSize(Textdraw0, 0.369998, 1.000000);
	TextDrawColor(Textdraw0, -1);
	TextDrawSetOutline(Textdraw0, 1);
	TextDrawSetProportional(Textdraw0, 1);

	Textdraw1 = TextDrawCreate(650.000000, 435.000000, " ~n~ ~n~");
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 1);
	TextDrawLetterSize(Textdraw1, 0.500000, 1.000000);
	TextDrawColor(Textdraw1, -1);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawSetProportional(Textdraw1, 1);
	TextDrawSetShadow(Textdraw1, 1);
	TextDrawUseBox(Textdraw1, 1);
	TextDrawBoxColor(Textdraw1, 70);
	TextDrawTextSize(Textdraw1, -10.000000, 0.000000);

	Textdraw2 = TextDrawCreate(638.000000, 405.000000, "xtreme");
	TextDrawAlignment(Textdraw2, 3);
	TextDrawBackgroundColor(Textdraw2, 255);
	TextDrawFont(Textdraw2, 3);
	TextDrawLetterSize(Textdraw2, 0.639998, 2.599998);
	TextDrawColor(Textdraw2, 0x006AFFAA);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);

	Textdraw3 = TextDrawCreate(610.000000, 387.000000, "trinity");
	TextDrawAlignment(Textdraw3, 3);
	TextDrawBackgroundColor(Textdraw3, 255);
	TextDrawFont(Textdraw3, 3);
	TextDrawLetterSize(Textdraw3, 0.639998, 2.599998);
	TextDrawColor(Textdraw3, -6749953);
	TextDrawSetOutline(Textdraw3, 1);
	TextDrawSetProportional(Textdraw3, 1);

	Textdraw4 = TextDrawCreate(656.000000, 390.000000, "[]-");
	TextDrawBackgroundColor(Textdraw4, 255);
	TextDrawFont(Textdraw4, 2);
	TextDrawLetterSize(Textdraw4, -0.610000, 2.000000);
	TextDrawColor(Textdraw4, -2096897);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawSetProportional(Textdraw4, 1);
	TextDrawSetShadow(Textdraw4, 1);

	Textdraw5 = TextDrawCreate(507.000000, 408.000000, "[]-");
	TextDrawBackgroundColor(Textdraw5, 255);
	TextDrawFont(Textdraw5, 2);
	TextDrawLetterSize(Textdraw5, 0.600000, 2.000000);
	TextDrawColor(Textdraw5, -2096897);
	TextDrawSetOutline(Textdraw5, 0);
	TextDrawSetProportional(Textdraw5, 1);
	TextDrawSetShadow(Textdraw5, 1);

	Textdraw6 = TextDrawCreate(84.000000, 286.000000, "-");
	TextDrawBackgroundColor(Textdraw6, 255);
	TextDrawFont(Textdraw6, 1);
	TextDrawLetterSize(Textdraw6, 0.499999, 9.799999);
	TextDrawColor(Textdraw6, 255);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawSetProportional(Textdraw6, 1);
	TextDrawSetShadow(Textdraw6, 1);

	Textdraw7 = TextDrawCreate(83.000000, 362.000000, "-");
	TextDrawBackgroundColor(Textdraw7, 255);
	TextDrawFont(Textdraw7, 1);
	TextDrawLetterSize(Textdraw7, 0.499999, 9.799999);
	TextDrawColor(Textdraw7, 255);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawSetProportional(Textdraw7, 1);
	TextDrawSetShadow(Textdraw7, 1);

	Textdraw8 = TextDrawCreate(28.000000, 362.000000, "-");
	TextDrawBackgroundColor(Textdraw8, 255);
	TextDrawFont(Textdraw8, 1);
	TextDrawLetterSize(Textdraw8, 1.329999, 3.299993);
	TextDrawColor(Textdraw8, 255);
	TextDrawSetOutline(Textdraw8, 0);
	TextDrawSetProportional(Textdraw8, 1);
	TextDrawSetShadow(Textdraw8, 1);

	Textdraw9 = TextDrawCreate(126.000000, 362.000000, "-");
	TextDrawBackgroundColor(Textdraw9, 255);
	TextDrawFont(Textdraw9, 1);
	TextDrawLetterSize(Textdraw9, 1.329999, 3.299993);
	TextDrawColor(Textdraw9, 255);
	TextDrawSetOutline(Textdraw9, 0);
	TextDrawSetProportional(Textdraw9, 1);
	TextDrawSetShadow(Textdraw9, 1);

	textdraw_server = TextDrawCreate(5.000000, 435.000000, "Supervivencia Server ~b~~h~~h~v1.0.0");
	TextDrawBackgroundColor(textdraw_server, 255);
	TextDrawFont(textdraw_server, 2);
	TextDrawLetterSize(textdraw_server, 0.300000, 1.000000);
	TextDrawColor(textdraw_server, 1717987071);
	TextDrawSetOutline(textdraw_server, 1);
	TextDrawSetProportional(textdraw_server, 1);

	printf("Yüklendi: \"Sunucu textdrawlarç.\"");

	// - Exp sistemi ayarları
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

	for (new i; i<MAX_PLAYERS; i++)
	{
/*   expmeter[i] = TextDrawCreate(177.000000, 398.000000, " ");
	TextDrawBackgroundColor(expmeter[i], 255);
	TextDrawFont(expmeter[i], 1);
	TextDrawLetterSize(expmeter[i], 0.320000, 0.899999);
	TextDrawColor(expmeter[i], -1);
	TextDrawSetOutline(expmeter[i], 0);
	TextDrawSetProportional(expmeter[i], 1);
	TextDrawSetShadow(expmeter[i], 1);*/

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

	// - Saat sistemi
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
	// - Sunucu Harita Objeleri

	

	printf("Yüklendi: \"Sunucu haritası.\"");
	printf("Yüklendi: \"Sunucu araçları.\"");

	// - Hızlandırma pickupları
	hizlandirici[1] = CreatePickup(1313,14,2048.6716,1015.3157,10.6719,0);
	hizlandirici[2] = CreatePickup(1313,14,2066.5132,1019.7257,10.6719,0);
	hizlandirici[3] = CreatePickup(1313,14,2066.5918,1254.1406,10.6719,0);
	hizlandirici[4] = CreatePickup(1313,14,2048.8401,1284.9427,10.6719,0);
	hizlandirici[5] = CreatePickup(1313,14,2121.1084,1847.6072,10.6719,0);
	hizlandirici[6] = CreatePickup(1313,14,2146.4421,1874.5963,10.6719,0);
	hizlandirici[7] = CreatePickup(1313,14,2128.2676,2219.6204,10.6719,0);
	hizlandirici[8] = CreatePickup(1313,14,2229.9316,2555.6431,10.8203,0);
	hizlandirici[9] = CreatePickup(1313,14,1964.1276,2593.7170,10.8126,0);
	hizlandirici[10] = CreatePickup(1313,14,-2084.9065,-1967.6328,378.5436,0);
	hizlandirici[11] = CreatePickup(1313,14,2048.4058,815.1559,8.4697,0);
	hizlandirici[12] = CreatePickup(1313,14,2364.7070,433.8943,17.6082,0);
	hizlandirici[13] = CreatePickup(1313,14,1294.1956,2598.3647,11.9492,0);

	printf("Yüklendi: \"Hız pickupları.\"");
	// - Ev sistemi ayarları
	SetTimer("SahipKontrol",3000,1);

	AddStaticPickup(ARROW,1,235.1575,1187.2721,1080.2578,-1);
	AddStaticPickup(ARROW,1,225.756989,1240.000000,1082.149902,-1);
	AddStaticPickup(ARROW,1,225.630997,1022.479980,1084.069946,-1);
	AddStaticPickup(ARROW,1,295.2057,1472.9973,1080.2578,-1);
	AddStaticPickup(ARROW,1,327.9004,1478.2839,1084.4375,-1);
	AddStaticPickup(ARROW,1,2324.3735,-1148.8219,1050.7101,-1);

	printf("Yüklendi: \"Ev sistemi.\"");
	for (new i;i<MAX_HOUSE;i++)
	{
		EvBilgi[i][evsatilik] = -1;
		EvBilgi[i][evsahip] = -1;
		EvBilgi[i][evaciklama] = -1;
		EvBilgi[i][evfiyat] = -1;
		EvBilgi[i][evbanka] = -1;
		EvBilgi[i][evkilit] = -1;
		EvBilgi[i][evint] = -1;
		EvBilgi[i][evworld] = -1;
		EvBilgi[i][ev_X] = -1;
		EvBilgi[i][ev_Y] = -1;
		EvBilgi[i][ev_Z] = -1;
		EvBilgi[i][evvid] = -1;
		EvBilgi[i][silahslot1] = -1;
		EvBilgi[i][silahslot2] = -1;
		EvBilgi[i][silahslot3] = -1;
		EvBilgi[i][silahslot4] = -1;
		EvBilgi[i][silahslot5] = -1;
		EvBilgi[i][silahslot6] = -1;
		EvBilgi[i][silahslot1x] = -1;
		EvBilgi[i][silahslot2x] = -1;
		EvBilgi[i][silahslot3x] = -1;
		EvBilgi[i][silahslot4x] = -1;
		EvBilgi[i][silahslot5x] = -1;
		EvBilgi[i][silahslot6x] = -1;
		EvYukle(i);
	}
	printf("Toplam \"%i\" ev bulunmakta.",ToplamEv);

	// General:
	

	// Class settings:
	new skinValue = 1;
	for (new i = 0; i <= 299; i++)
	{
		skinValue++;
		 AddPlayerClass(i, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	}

	printf("  ** %d player class loaded.", skinValue);

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

	LoadObjects();
	printf("  ** Objects loaded!");

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
	KillTimer(Timer);

	new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);
	printf("Sunucu modu kapandı.");
	printf("Saat: %d:%d:%d ~ Tarih: %d/%d/%d",hour,minute,second,day,month,year);
	printf("Trinity-Xtreme / since 27/01/2013 - 01:52");

	//mysql_close();
	printf("  ** MySQL connection closed!");

	printf("ç %s gamemode closed.", server_modname);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	/*
	SetPlayerFacingAngle(playerid, 90.0);
	PlayerPlaySound(playerid,1185, 0, 0, 0);
	SetPlayerPos(playerid, 2621.1831,1824.3500,11.0234);
	SetPlayerCameraPos(playerid, 2616.2153,1824.3500,12.8204);
	SetPlayerCameraLookAt(playerid, 2621.1831,1824.3500,12.0234);
	
	
	*/
	CreateExplosion(1544.7887,-1675.4630,13.5591, 12, 20.0);
	SetPlayerPos(playerid, 1544.7887,-1675.4630,13.5591);
	SetPlayerFacingAngle(playerid,90.0);
	SetPlayerCameraPos(playerid, 1541.5293,-1675.4012,13.5527);
	SetPlayerCameraLookAt(playerid, 1544.7887,-1675.4630,13.5591);
	new rand = random(sizeof(RandAnims));
	ApplyAnimation(playerid,"DANCING",RandAnims[rand][0],4.0,1,1,1,1,1);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new connectMessage[64 + MAX_PLAYER_NAME];
	format(connectMessage, sizeof(connectMessage), "{BBBBBB}** {00B3FF}%s {BBBBBB}connected server.", pName(playerid));
	SendClientMessageToAll(-1, connectMessage);
	SetPlayerColor(playerid, PlayerColors[playerid]);
	SendDeathMessage(INVALID_PLAYER_ID, playerid, 200);
	SetPlayerTime(playerid, 06, 00);
	DeleteObjects(playerid);

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

	GameTextForPlayer(playerid,"~b~~h~Trinity-~w~Xtreme~n~~r~~h~F~g~~h~r~b~~h~e~y~e~r~r~w~o~p~a~g~m",5000,1);
	// - PM sistemi
	pInfo[playerid][Last] = -1;
	pInfo[playerid][NoPM] = 0;

	// - EXP sistemi
	   new dosya[50], isim[24];
	GetPlayerName(playerid, isim, sizeof(isim));
	format(dosya, sizeof(dosya), "Hesaplar/Level/%s.txt", isim);

	
	//if (!dini_Exists(dosya)) seviye[playerid]=1, dini_Create(dosya);
	//else BilgiYukle(playerid);
	expguncelle[playerid] = SetTimerEx("BilgiYenile", 1000, true, "d", playerid);

	// - Ev sistemi ayarç
	OyuncuMapIconKontrol(playerid);

	// - Araç kilit ayarç
	   Kilit[playerid] = 0;

	   
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	// - PM sistemi
	pInfo[playerid][Last] = -1;
	pInfo[playerid][NoPM] = 0;

	// - EXP sistemi
	BilgiYenile(playerid);
	KillTimer(expguncelle[playerid]);

	// - Araç spawn ayarlarç
	new iVehID = GetPVarInt(playerid, "iVehID");
	if (iVehID)
	DestroyVehicle(iVehID);

	// - Ev sistemi ayarlarç
	OyuncuEv[playerid] = -1;
	EvEditleniyor[GetHouseID(playerid)] = false;
	OyuncuKontrolEv[playerid]=-255;

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

	if (campFire[playerid] == true)
	{
		DestroyDynamicObject(fireWoods[playerid]);
		DestroyDynamicObject(fireObject[playerid]);
	}

	if (guitarSong[playerid] == true)
	{
		StopAudioStreamForPlayer(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,0);
	SetPlayerRandomSpawn(playerid);
	PlayerPlaySound(playerid,1186, 0, 0, 0);

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
	TextDrawShowForPlayer(playerid,expbox);
	TextDrawShowForPlayer(playerid,expmeter[playerid]);
	//ShowProgressBarForPlayer(playerid,Bar:expbar[playerid]);

	// Deathmatch
	switch (DM[playerid])
	{
		case 1:
		{
			new State = GetPlayerState(playerid);
			if (IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER) {
				GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
				SendInfo(playerid,"Deathmatch alanından çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			}

			DM[playerid]=1;

			SetPlayerArmour(playerid,100);
			SetPlayerHealth(playerid,100);
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,0);
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid,24,99999);

			new rand = random(sizeof(deagledm1pos));
			SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
			GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
			SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			SetPlayerTeam(playerid, NO_TEAM);
		}

		case 2:
		{
			new State = GetPlayerState(playerid);
			if (IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER) {
				GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
				SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			}

			DM[playerid]=2;

			SetPlayerArmour(playerid,100);
			SetPlayerHealth(playerid,100);
			SetPlayerSkin(playerid, 80);
			SetPlayerInterior(playerid,1);
			SetPlayerVirtualWorld(playerid,0);
			ResetPlayerWeapons(playerid);

			new rand = random(sizeof(fistdm1pos));
			SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
			GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
			SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
			SetPlayerTeam(playerid, NO_TEAM);
		}
	}

	SetPlayerPos(playerid, -2020.6033,613.6348,36.6419);
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
	SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
	PlayerPlaySound(playerid,5206, 0, 0, 0);

	PlayerAccount[playerid][pA_Hungry] = 0;
	PlayerAccount[playerid][pA_Radiation] = 0;

	TextDrawHideForPlayer(playerid, textdraw_hungry[playerid]);
	TextDrawHideForPlayer(playerid, textdraw_radiation[playerid]);
	TextDrawHideForPlayer(playerid, textdraw_ping[playerid]);

	if (campFire[playerid] == true)
	{
		DestroyDynamicObject(fireWoods[playerid]);
		DestroyDynamicObject(fireObject[playerid]);
	}

	if (guitarSong[playerid] == true)
	{
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
	format(chatmessage,1024,"{C30000}[{FFFFFF}RGM{C30000}]{ACDA00}%s{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s",PlayerName(playerid),playerid,text);
	SendClientMessageToAll(1,chatmessage);
	}
	else
	{
	if (IsPlayeraLAdmin(playerid))
	{
	format(chatmessage,1024,"{C30000}[{FFFFFF}GM{C30000}]{ACDA00}%s{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s",PlayerName(playerid),playerid,text);
	SendClientMessageToAll(1,chatmessage);
	}
	else
	{
	format(chatmessage,1024,"{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s",playerid,text);
	SendPlayerMessageToAll(playerid,chatmessage);
	}
	}
	SetPlayerChatBubble(playerid,text,0xACDA00AA,100.0,5000);
	return 0;
	*/
}

// - DCMD komutları:
dcmd_pmkapat(playerid, const params[])
{
	if (pInfo[playerid][NoPM] == 1) return SendError(playerid,"Özel mesaj hattınız zaten kapalı.");

	pInfo[playerid][NoPM] = 1;
	SendInfo(playerid,"Özel mesaj hattınızı kapattınız.");
}

dcmd_pmac(playerid, const params[])
{
	if (pInfo[playerid][NoPM] == 0) return SendInfo(playerid,"Özel mesaj hattınız zaten açık.");

	pInfo[playerid][NoPM] = 0;
	SendInfo(playerid, "Özel mesaj hattınızı açtınız.");
}

dcmd_pm(playerid, const params[])
{
	new pID, text[128], string[128];
	if (sscanf(params, "us", pID, text)) return SendUse(playerid,"/pm (nick/id) (mesaj)");
	if (!IsPlayerConnected(pID)) return SendError(playerid,"Oyuncu bulunamadı.");
	if (pID == playerid) return SendError(playerid,"Kendinize çzel mesaj gönderemezsiniz.");
	format(string, sizeof(string), "** HATA: {FFFFFF}%s(%d) rumuzlu oyuncunun özel mesaj hattı kapalı.", PlayerName(pID), pID);
	if (pInfo[pID][NoPM] == 1) return SendClientMessage(playerid,0xF63845AA,string);
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
	if (sscanf(params, "s", text)) return SendUse(playerid,"/reply (mesaj)");
	new pID = pInfo[playerid][Last];
	if (!IsPlayerConnected(pID)) return SendError(playerid,"Oyuncu bulunamadı.");
	if (pID == playerid) return SendError(playerid,"Kendinize özel mesaj gönderemezsiniz.");
	format(string, sizeof(string), "** HATA: {FFFFFF}%s(%d) rumuzlu oyuncunun özel mesaj hattı kapalı.", PlayerName(pID), pID);
	if (pInfo[pID][NoPM] == 1) return SendClientMessage(playerid,0xF63845AA,string);
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

	   // Debug commands:
	  if (!strcmp(cmdtext, "/eat", true))
	{
		showMessage(playerid, "You're eated a {006699}burger.");
		PlayerAccount[playerid][pA_Hungry] = 0;
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
		return 1;
	}

	if (!strcmp(cmdtext, "/addrad", true))
	{
		showMessage(playerid, "Radiation coming!");
		PlayerAccount[playerid][pA_Radiation] += 15;
		return 1;
	}

	if (!strcmp(cmdtext, "/radpills", true))
	{
		showMessage(playerid, "You're used a {006699}radiation pill.");
		PlayerAccount[playerid][pA_Radiation] = 0;
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
		return 1;
	}

// ========================================================================== //

	// Campfire script:
	if (!strcmp(cmdtext, "/campfire", true))
	{
		if (campFire[playerid] == true) return showMessage(playerid, "You need quench your last campfire. (/firedown)");
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken ateç yakamazsınız!");
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
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken ateçi sındçremezsiniz!");

		new Float:fireX, Float:fireY, Float:fireZ;
		GetDynamicObjectPos(fireWoods[playerid], fireX, fireY, fireZ);
		if (!IsPlayerInRangeOfPoint(playerid, 7.0, fireX, fireY, fireZ)) return showMessage(playerid, "Kamp ateçinin yakçnçnda deçilsiniz! [7 metre]");

		campFire[playerid] = false;
		 DestroyDynamicObject(fireWoods[playerid]);
		  DestroyDynamicObject(fireObject[playerid]);
		showMessage(playerid, "Kamp ateçini sındçrdçnız!");
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
		ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
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


	if (!strcmp("/dmcik",cmdtext,true))
	{
		if (DM[playerid] == 0) return SendError(playerid,"Zaten deathmatch alanında değilsin!");
		DM[playerid]=0;
		SetPlayerArmour(playerid,0.0);
		SetPlayerHealth(playerid,100.0);
		ResetPlayerWeapons(playerid);
		SpawnPlayer(playerid);
		SendInfo(playerid,"Deathmatch alanından çıktınız.");
		return 1;
	}

	   if (DM[playerid] > 0) return SendError(playerid,"Deathmatch alanında komut kullanmak yasaktır. çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	// - DCMD komutlarç
	dcmd(pm, 2, cmdtext);
	dcmd(ms, 2, cmdtext);
	dcmd(m, 1, cmdtext);
	dcmd(r, 1, cmdtext);
	dcmd(reply, 5, cmdtext);
	dcmd(pmac, 4, cmdtext);
	dcmd(pmkapat, 7, cmdtext);

	// - Genel komutlar && dialog komutlarç
	if (!strcmp(cmdtext, "/kurallar", true))
	{
	ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFFFF}Trinity-Xtreme / {009BFF}Kurallar","{00FF00}~~ Hile kesinlikle yasaktır.\n~~ Argo yasaktır.\n~~ İnanç ve görüşe karşı hakaret yasaktır.\n~~ Yönetimi rahatsız etmek yasaktır.","Kapat","");
	return 1;
	}

	if (!strcmp(cmdtext, "/changelog", true))
	{
	ShowPlayerDialog(playerid,1911,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.0]","{ACDA00}~ Sunucu dosyalarç oluçturuldu.\n~ LAdmin 4.0 eklendi.\n~ Changelog eklendi.\n~ Textdrawlar eklendi.\n~ Teles menüsü eklendi.\n~ Yardım menüsü eklendi.\n~ Kurallar menüsü eklendi.\n~ İlk haritalar ve araçlar eklendi.\n~ aLypSe Ev Sistemi moda eklendi.\n~ /v1-/v18 Araç spawn sistemi eklendi.\n~ /m1-/m12 Araç spawn sistemi eklendi.\n~ /paraver-/can-/yelek-/surus-/cevir komutlarç eklendi.","RC1.1","Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/teles", true))
	{
	ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Teleport","{FFFFFF}Four Dragon Casino (/4dragon)\nChilliad Mountain (/dag)\nSanta Maria Beach (/sahil)\nArea51 Zone (/area51)\nSan Fierro ChinaTown (/china)\nLos Santos Los Flores (/flores)\nModifiye Yeri 1 (/mod1)\nModifiye Yeri 2 (/mod2)\nModifiye Yeri 3 (/mod3)\nModifiye Yeri 4 (/mod4)\nModifiye Yeri 5 (/mod5)\nAirport 1 (/ap1)\nAirport 2 (/ap2)\nAirport 3 (/ap3)\nAirport 4 (/ap4)\n~ Diçer Sayfa.","Seç","Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/dmler", true))
	{
	ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Deathmatch","{FFFFFF}Desert Eagle Deathmatch - 1 (/deagledm1)\n{FFFFFF}Fight Club Deathmatch -1 (/fistdm1)","Seç","Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/stuntlar", true))
	{
	ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Stunt Zones","{FFFFFF}Bikepark Stunt - 1 (/bikestunt1)","Seç","Kapat");
	return 1;
	}

	if (!strcmp(cmdtext, "/silahlar", true))
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	return 1;
	}

	if (strcmp("/yardim", cmdtext, true, 10) == 0)
	{
		new string[2048];
		format(string,2048,"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",dIp[0],dIp[1],dIp[2],dIp[3],dIp[4],dIp[5],dIp[6],dIp[7],dIp[8],dIp[9],dIp[10],dIp[11],dIp[12],dIp[13],dIp[14],dIp[15],dIp[16],dIp[17]);
		ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX, "{FFFFFF}Trinity-Xtreme / {009BFF}Yardçm",string,"Kapat","");
		return 1;
	}

	 if (strcmp("/myversion", cmdtext, true, 10) == 0)
	{
		new string[64];
		GetPlayerVersion(playerid, string, sizeof(string));
		format(string, sizeof(string), "ç BçLGç: {FFFFFF}SA-MP versiyonunuz: {00FF00}%s", string);
		SendClientMessage(playerid, 0x00A2F6AA,string);
		return 1;
	}

	// - Araç yçnetim komutlarç
	if (strcmp(cmd, "/motorac",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,VEHICLE_PARAMS_ON,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SendInfo(playerid,"Motor aççldç, kapatmak için {00FF00}/motorkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/motorkapat",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,VEHICLE_PARAMS_OFF,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SendInfo(playerid,"Motor kapatçldç, tekrar açmak için {00FF00}/motorac");
	}
	return 1;
	}

	if (strcmp(cmd, "/farac",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,VEHICLE_PARAMS_ON,alarm,kapilar,kaput,bagaj,objective);
	SendInfo(playerid,"Far aççldç, kapatmak için {00FF00}/farkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/farkapat",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,VEHICLE_PARAMS_OFF,alarm,kapilar,kaput,bagaj,objective);
	SendInfo(playerid,"Far kapatçldç, tekrar açmak için {00FF00}/farac");
	}
	return 1;
	}

	if (strcmp(cmd, "/alarmac",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,isiklar,VEHICLE_PARAMS_ON,kapilar,kaput,bagaj,objective);
	SendInfo(playerid,"Alarm aççldç, kapatmak için {00FF00}/alarmkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/alarmkapat",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,isiklar,VEHICLE_PARAMS_OFF,kapilar,kaput,bagaj,objective);
	SendInfo(playerid,"Alarm kapatçldç, tekrar almak için {00FF00}/alarmac");
	}
	return 1;
	}

	if (strcmp(cmd, "/kaputac",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,VEHICLE_PARAMS_ON,bagaj,objective);
	SendInfo(playerid,"Kaput aççldç, kapatmak için {00FF00}/kaputkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/kaputkapat",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,VEHICLE_PARAMS_OFF,bagaj,objective);
	SendInfo(playerid,"Kaput kapatçldç, tekrar almak için {00FF00}/kaputac");
	}
	return 1;
	}

	if (strcmp(cmd, "/bagajac",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,VEHICLE_PARAMS_ON,objective);
	SendInfo(playerid,"Bagaj aççldç, kapatmak için {00FF00}/bagajkapat");
	}
	return 1;
	}

	if (strcmp(cmd, "/bagajkapat",true) == 0) {
	if (!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Şöför koltuçunda deçilsiniz!");
	new vid = GetPlayerVehicleID(playerid);
	if (vid != INVALID_VEHICLE_ID)
	{
	GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
	SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,VEHICLE_PARAMS_OFF,objective);
	SendInfo(playerid,"Bagaj kapatçldç, tekrar almak için {00FF00}/bagajac");
	}
	return 1;
	}

	if (!strcmp(cmdtext,"/kilit",true))
	{
		if (!IsPlayerInAnyVehicle(playerid)) return 1;
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
		if (Kilit[playerid] != 0) return 1;
		Kilit[playerid] = 1;
		Arac[playerid] = GetPlayerVehicleID(playerid);
		SendInfo(playerid,"Araç kilitlendi, kilidi açmak için {00FF00}/kilitac");
		return 1;
	}

	if (!strcmp(cmdtext,"/kilitac",true))
	{
		if (Kilit[playerid] != 1) return 1;
		new Float:X, Float:Y, Float:Z;
		GetVehiclePos(Arac[playerid],X,Y,Z);
		if (IsPlayerInRangeOfPoint(playerid,5,X,Y,Z))
		{
			Kilit[playerid] = 0;

			SendInfo(playerid,"Kilit açıldı, aracı kilitlemek için {00FF00}/kilit");
		}
		return 1;
	}

	// - Araç renk değiştirme
	if (strcmp(cmd, "/renk", true) == 0) {
		if (IsPlayerInAnyVehicle(playerid)) return SendError(playerid,"Araçta değilsiniz.");

		new color1,color2,string[128];
		tmp=strtok(cmdtext,idx);
		if (!strlen(tmp) || !IsNumeric(tmp)) return SendUse(playerid,"/renk {00FF00}[0-255] [0-255]");

		color1=strval(tmp);
		tmp=strtok(cmdtext,idx);
		if (!strlen(tmp) || !IsNumeric(tmp))color2=color1;
		else color2=strval(tmp);
		if (color1<0 || color1>255 || color2<0 || color2>255)
		if (!strlen(tmp) || !IsNumeric(tmp)) return SendUse(playerid,"/renk {00FF00}[0-255] [0-255]");

		ChangeVehicleColor(GetPlayerVehicleID(playerid),color1,color2);
		format(string,sizeof(string),"** BİLGİ: {FFFFFF}Araç rengi değiştirildi. [{009BFF}%d/%d{FFFFFF}]",color1,color2);
		SendClientMessage(playerid, 0x00A2F6AA, string);

		return 1;
	}

	// - Skin deçiçtirme komutu
	if (strcmp(cmdtext, "/myskin", true) == 7 || strcmp(cmdtext, "/skin", true) == 7)
	{
	if (cmdtext[7] != ' ' || cmdtext[8] == EOS)
	return SendUse(playerid,"/myskin [id]");
	if ((cmdtext[0] < 0) || (cmdtext[0] > 299)) return SendError(playerid,"Girilen de*er geçersiz!");
	if (IsValidSkin((cmdtext[0] = strval(cmdtext[8]))))
	SetPlayerSkin(playerid, cmdtext[0]);
	else
	SendError(playerid,"Girilen de*er geçersiz!");
	return 1;
	}

	// - DM alanç komutlarç
	if (!strcmp(cmdtext, "/deagledm1",true))
	{
	new State = GetPlayerState(playerid);
	if (IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
	GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	}
	DM[playerid]=1;
	SetPlayerArmour(playerid,100);
	SetPlayerHealth(playerid,100);
	SetPlayerSkin(playerid, 285);
	SetPlayerInterior(playerid,0);
	SetPlayerVirtualWorld(playerid,0);
	ResetPlayerWeapons(playerid);
	new rand = random(sizeof(deagledm1pos));
	SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
	GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	GivePlayerWeapon(playerid,24,99999);
	SetPlayerTeam(playerid, NO_TEAM);
	return 1;
	}

	if (!strcmp(cmdtext, "/fistdm1",true))
	{
	new State = GetPlayerState(playerid);
	if (IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
	GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	}
	DM[playerid]=2;
	SetPlayerArmour(playerid,100);
	SetPlayerHealth(playerid,100);
	SetPlayerSkin(playerid, 80);
	SetPlayerInterior(playerid,1);
	SetPlayerVirtualWorld(playerid,0);
	ResetPlayerWeapons(playerid);
	new rand = random(sizeof(fistdm1pos));
	SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
	GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	SetPlayerTeam(playerid, NO_TEAM);
	return 1;
	}

	// - 31 sistemi komutlarç
	if (!strcmp("/31",cmd,true))
	{
	tmp=strtok(cmdtext,idx);

	if (!strlen(tmp)) return SendUse(playerid,"/31 [cek/birak]");

	if (!strcmp("cek",tmp,true))
	{
	if (cekiyor[playerid] == 1) return SendError(playerid,"Zaten 31 çekmektesiniz.");
	   ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
	   ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
	asilantimer = SetTimerEx("asilanadamtimer", 19000,false,"i",playerid);
	   cekiyor[playerid] = 1;
	   return 1;
	   }

	if (!strcmp("birak",tmp,true))
	{
	   if (cekiyor[playerid] == 0) return SendError(playerid,"Zaten 31 çekmiyorsunuz.");
	SendInfo(playerid,"Artçk 31 çekmiyorsunuz.");
	ClearAnimations(playerid);
	   KillTimer(asilantimer);
	cekiyor[playerid] = 0;
	return 1;
	   }
	return 1;
	}
	// - Para gçnderme komutu
	if (!strcmp("/paraver",cmd,true))
	{
		tmp=strtok(cmdtext,idx);
		if (!strlen(tmp)) return SendUse(playerid,"/paraver {00FF00}[id][miktar]");
		new id=strval(tmp);
		if (!IsPlayerConnected(id)) return SendError(playerid,"Oyuncu oyunda {FF0000}bulunmuyor!");
		tmp=strtok(cmdtext,idx);
		if (!strlen(tmp)) return SendUse(playerid,"/paraver {00FF00}[id][miktar]");
		new miktar=strval(tmp);

		if (miktar < 0) return SendError(playerid,"Girilen miktar {FF0000}geçersiz!");
		if (GetPlayerMoney(playerid) < miktar) return SendError(playerid,"Paranız {FF0000}yetersiz!");

		GivePlayerMoney(playerid,-miktar);
		GivePlayerMoney(id,miktar);
		return 1;
	}

	// - sırçç kamerası komutu
	if (strcmp("/surus", cmdtext, true, 10) == 0)
	{
	if (!IsPlayerInAnyVehicle(playerid)) return SendError(playerid,"Arabada olmalısınız!");
	if (GetPVarInt(playerid,"used") == 0)
	{
	new p = GetPlayerVehicleID(playerid);
	Surus[playerid] = CreatePlayerObject(playerid,19300, 0.0000, -1282.9984, 10.1493, 0.0000, -1, -1, 100);
	AttachPlayerObjectToVehicle(playerid,Surus[playerid],p,-0.314999, -0.195000, 0.510000, 0.000000, 0.000000, 0.000000);
	AttachCameraToPlayerObject(playerid,Surus[playerid]);
	SetPVarInt(playerid,"used",1);
	SendInfo(playerid,"Kamerayı eski haline döndürmek için {00FF00}/surus {FFFFFF}yazınız.");
	}
	else
	{
	SetCameraBehindPlayer(playerid);
	DestroyPlayerObject(playerid,Surus[playerid]);
	SetPVarInt(playerid,"used",0);
	SendInfo(playerid,"Kamera eski haline döndürüldü."); }
	return 1;
	}

	// - Işınlanma komutları
	if (strcmp(cmdtext, "/4dragon", true) == 0 || strcmp(cmdtext, "/dragon", true) == 0 || strcmp(cmdtext, "/4d", true) == 0) {
		Teleport(playerid,2027.8171,1008.1444,10.8203,0,0,"Four Dragon Casino","/4d",1,0);
		return 1;
	}

	if (strcmp(cmdtext, "/dag", true) == 0 || strcmp(cmdtext, "/chilliad", true) == 0) {
		Teleport(playerid,-2353.0940,-1633.6820,483.6954,0,0,"Chilliad Mountain","/dag",1,0);
		return 1;
	}

	if (strcmp(cmdtext, "/sahil", true) == 0) {
		Teleport(playerid,369.8283,-1787.7871,5.3585,0,0,"Santa Maria Beach","/sahil",1,0);
		return 1;
	}

	if (strcmp(cmdtext, "/area51", true) == 0) {
		Teleport(playerid,231.5036,1914.3851,17.6406,0,0,"Area51","/area51",1,0);
		return 1;
	}

	if (strcmp(cmdtext, "/china", true) == 0) {
		Teleport(playerid,-2276.2874,718.5117,49.4453,0,0,"China Town","/china",1,0);
		return 1;
	}

	if (strcmp(cmdtext, "/flores", true) == 0) {
		Teleport(playerid,2786.9534,-1319.9723,34.7975,0,0,"Los Flores","/flores",1,0);
		return 1;
	}

	if (strcmp(cmdtext, "/mod1", true) == 0) {
		Teleport(playerid,-1917.2754,287.0215,41.0469,0,0,"Modifiye Yeri 1","/mod1",1,0);
		return 1;
	}

	if (strcmp(cmdtext,"/mod2", true) == 0) {
		Teleport(playerid,-2705.5503, 206.1621,4.1797,0,0,"Modifiye Yeri 2","/mod2",1,0);
		return 1;
	}

	if (strcmp(cmdtext,"/mod3", true) == 0) {
		Teleport(playerid,2387.4126,1022.6620,10.8203,0,0,"Modifiye Yeri 3","/mod3",1,0);
		return 1;
	}

	if (strcmp(cmdtext,"/mod4", true) == 0) {
		Teleport(playerid,2644.7686,-2019.1096,13.5507,0,0,"Modifiye Yeri 4","/mod4",1,0);
		return 1;
	}

	if (strcmp(cmdtext,"/mod5", true) == 0) {
		Teleport(playerid,1042.0564,-1045.5176,31.8108,0,0,"Modifiye Yeri 5","/mod5",1,0);
		return 1;
	}

	if (strcmp(cmdtext,"/ap1", true) == 0) {
		Teleport(playerid,1686.7,-2450.2,13.6,0,0,"Airport 1","/ap1",1,0);
		return 1;
	}

	if (strcmp(cmdtext,"/ap2", true) == 0) {
		Teleport(playerid,-1345.0, -229.8, 14.1, 0, 0, "Airport 2","/ap2", true, false);
		return 1;
	}

	if (strcmp(cmdtext,"/ap3", true) == 0) {
		Teleport(playerid,1435.5, 1463.2, 10.8, 0, 0, "Airport 3", "/ap3", true, false);
		return 1;
	}

	if (strcmp(cmdtext,"/ap4", true) == 0) {
		Teleport(playerid, 350.7, 2539.2, 16.8, 0, 0, "Airport 4","/ap4", true, false);
		return 1;
	}

	// - Can & zırh komutlarç
	if (strcmp(cmdtext, "/can", true) == 0 || strcmp(cmdtext, "/health", true) == 0) {
		if (GetPVarInt(playerid, "SpamKorumaCan") > GetTickCount()) return SendInfo(playerid,"Komutu tekrar kullanmak için 30 saniye bekleyiniz.");
		if (GetPlayerMoney(playerid) < 750) return SendError(playerid,"Paranız {FF0000}yetersiz!");
		
		SetPVarInt(playerid, "SpamKorumaCan", GetTickCount() + 30 * 1000);
		SetPlayerHealth(playerid, 100);
		GivePlayerMoney(playerid, -750);
		SendInfo(playerid,"Can paketi {00FF00}başarıyla {FFFFFF}alındı. [750$]");
		return 1;
	}

	if (strcmp(cmdtext, "/yelek", true)==0 || strcmp(cmdtext, "/zirh", true) == 0) {
		if (GetPVarInt(playerid, "SpamKorumaZırh") > GetTickCount()) return SendInfo(playerid,"Komutu tekrar kullanmak için 30 saniye bekleyiniz.");
		if (GetPlayerMoney(playerid) < 1000) return SendError(playerid,"Paranız {FF0000}yetersiz!");

		SetPVarInt(playerid, "SpamKorumaZırh", GetTickCount() + 30 * 1000);
		SetPlayerArmour(playerid,100);
		GivePlayerMoney(playerid,-1000);
		SendInfo(playerid,"Zırh paketi {00FF00}başarıyla {FFFFFF}alındı. [1000$]");
		return 1;
	}

	// - FPS komutlarç
	if (strcmp("/firstperson", cmdtext, true, 10) == 0)
	{
		firstperson[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		 AttachObjectToPlayer(firstperson[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
		AttachCameraToObject(playerid, firstperson[playerid]);
		SendInfo(playerid,"Kamerayı eski hale döndürmek için {00FF00}/exitfirstperson {FFFFFF}yazınız.");
		return 1;
	}
	if (strcmp("/exitfirstperson", cmdtext, true, 10) == 0)
	{
		SetCameraBehindPlayer(playerid);
		DestroyObject(firstperson[playerid]);
		return 1;
	}

	// - Araç çevirme komutu
	if (strcmp(cmdtext,"/cevir",true) == 0) {
		if (!IsPlayerInAnyVehicle(playerid)) return SendError(playerid,"Arabada {FF0000}değilsiniz!");

		new VehicleID, Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid,X, Y, Z);
		VehicleID = GetPlayerVehicleID(playerid);
		SetVehiclePos(VehicleID, X, Y, Z);
		SetVehicleZAngle(VehicleID, 0);
		SendInfo(playerid, "Arabanız {00FF00}başarıyla {FFFFFF}çevrildi.");
		return 1;
	}

	// - /v komutu
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

	// - /m1-/m12 /nrg komutları
	if (strcmp(cmdtext, "/m1", true) == 0) {
		// Sultan

		new Float:x, Float:y, Float:z, Float:angle, CarID;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		carID = CreateVehicle(560, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);

		if (MCarPlayerInfo[playerid][pMAraba] != 0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1028);
		AddVehicleComponent(carID, 1030);
		AddVehicleComponent(carID, 1031);
		AddVehicleComponent(carID, 1138);
		AddVehicleComponent(carID, 1140);
		AddVehicleComponent(carID, 1170);
		AddVehicleComponent(carID, 1080);
		AddVehicleComponent(carID, 1086);
		AddVehicleComponent(carID, 1087);
		ChangeVehiclePaintjob(carID, 1);
		
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		return 1;
	}

	if (strcmp(cmdtext, "/m2", true) == 0)	{ 
		//Sultan

		new Float:x, Float:y, Float:z, Float:angle, carID;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		carID = CreateVehicle(560, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);

		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;

		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1028);
		AddVehicleComponent(carID, 1030);
		AddVehicleComponent(carID, 1031);
		AddVehicleComponent(carID, 1138);
		AddVehicleComponent(carID, 1140);
		AddVehicleComponent(carID, 1170);
		AddVehicleComponent(carID, 1080);
		AddVehicleComponent(carID, 1086);
		AddVehicleComponent(carID, 1087);
		ChangeVehiclePaintjob(carID, 2);
		
		PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		return 1;
	}

	if (strcmp(cmdtext, "/m3", true) == 0) {
		// Jester

		new Float:x, Float:y, Float:z, Float:angle, carID;
		
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		carID = CreateVehicle(559, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);

		if (MCarPlayerInfo[playerid][pMAraba] != 0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);

		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;

		AddVehicleComponent(carID, 1065);
		AddVehicleComponent(carID, 1067);
		AddVehicleComponent(carID, 1162);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1073);
		ChangeVehiclePaintjob(carID, 1);
		
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		return 1;
	}

	if (strcmp(cmdtext, "/m4", true) == 0) {
		// Flash

		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		carID = CreateVehicle(565, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);

		if (MCarPlayerInfo[playerid][pMAraba] != 0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;

		AddVehicleComponent(carID, 1046);
		AddVehicleComponent(carID, 1049);
		AddVehicleComponent(carID, 1053);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1073);
		ChangeVehiclePaintjob(carID, 1);

		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		return 1;
	}

	if (strcmp(cmdtext, "/m5", true) == 0) {
		// Uranus

		new Float:x, Float:y, Float:z, Float:angle, carID;
		
		GetPlayerPos(playerid,x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		carID = CreateVehicle(558, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);

		if (MCarPlayerInfo[playerid][pMAraba] != 0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);

		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;

		AddVehicleComponent(carID, 1088);
		AddVehicleComponent(carID, 1092);
		AddVehicleComponent(carID, 1139);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1073);
		ChangeVehiclePaintjob(carID, 1);
		
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		return 1;
	}

	if (strcmp(cmdtext, "/m6", true) == 0) {
		// Stratum

		new Float:x, Float:y, Float:z, Float:angle, carID;
		
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		carID = CreateVehicle(561, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1055);
		AddVehicleComponent(carID, 1058);
		AddVehicleComponent(carID, 1064);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1073);
		ChangeVehiclePaintjob(carID, 1);

		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		return 1;
	}

	if (strcmp(cmdtext, "/m7", true) == 0) {
		// Elegy
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(562, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1034);
		AddVehicleComponent(carID, 1038);
		AddVehicleComponent(carID, 1147);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1073);
		ChangeVehiclePaintjob(carID, 1);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	if (strcmp(cmdtext, "/m8", true) == 0) {
		// Savanna
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(567, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1102);
		AddVehicleComponent(carID, 1129);
		AddVehicleComponent(carID, 1133);
		AddVehicleComponent(carID, 1186);
		AddVehicleComponent(carID, 1188);
		ChangeVehiclePaintjob(carID, 1);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1085);
		AddVehicleComponent(carID, 1087);
		AddVehicleComponent(carID, 1086);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	if (strcmp(cmdtext, "/m9", true) == 0) {
		// Uranus
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(558, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1092);
		AddVehicleComponent(carID, 1166);
		AddVehicleComponent(carID, 1165);
		AddVehicleComponent(carID, 1090);
		AddVehicleComponent(carID, 1094);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1087);
		AddVehicleComponent(carID, 1163);
		AddVehicleComponent(carID, 1091);
		ChangeVehiclePaintjob(carID, 2);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	if (strcmp(cmdtext, "/m10", true) == 0) {
		// Monster
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(557, x, y, z, angle, 1, 1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1081);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	if (strcmp(cmdtext, "/m11", true) == 0) {
		// Slamvan
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(535, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		ChangeVehiclePaintjob(carID, 1);
		AddVehicleComponent(carID, 1109);
		AddVehicleComponent(carID, 1115);
		AddVehicleComponent(carID, 1117);
		AddVehicleComponent(carID, 1073);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1087);
		AddVehicleComponent(carID, 1114);
		AddVehicleComponent(carID, 1081);
		AddVehicleComponent(carID, 1119);
		AddVehicleComponent(carID, 1121);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	if (strcmp(cmdtext, "/m12", true) == 0) {
		// Elegy
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(562, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		AddVehicleComponent(carID, 1034);
		AddVehicleComponent(carID, 1038);
		AddVehicleComponent(carID, 1147);
		AddVehicleComponent(carID, 1010);
		AddVehicleComponent(carID, 1073);
		ChangeVehiclePaintjob(carID, 0);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	if (strcmp(cmdtext, "/nrg", true) == 0) {
		// NRG
		new Float:x, Float:y, Float:z, Float:angle, carID;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
		carID = CreateVehicle(522, x, y, z, angle, 1, -1, -1);
		PutPlayerInVehicle(playerid, carID, 0);
		
		if (MCarPlayerInfo[playerid][pMAraba] != 0) {
			DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
		}
		
		MCarPlayerInfo[playerid][pMArabaID] = carID;
		MCarPlayerInfo[playerid][pMAraba] = 1;
		
		ChangeVehiclePaintjob(carID, 0);
		SetVehicleVirtualWorld(carID, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(carID, GetPlayerInterior(playerid));
		
		return 1;
	}

	// - Ev sistemi
	if (strcmp("/evmenu", cmdtext, true, 10) == 0)
	{
		if (!IsPlayerAdmin(playerid)) return Mesaj(playerid,"Bu komutu kullanmak için gerekli izniniz yok!");
		if (GetPlayerInterior(playerid) != 0) return Mesaj(playerid,"Ev yaratmak için interior dçççnda olmalısınız!");
		if (!Kontrol(playerid)) return ShowPlayerDialog(playerid,DIALOG+1,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Yeni Ev Yarat","Seç","İptal");
		if (EvEditleniyor[GetHouseID(playerid)] == true) return Mesaj(playerid,"çu anda bu evi baçka bir kiçi dçzenliyor...");
		
		EvEditleniyor[GetHouseID(playerid)] = true;
		ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		return 1;
	}

	if (strcmp("/ev", cmdtext, true, 10) == 0)
	{
		new dosya[64];
		format(dosya,sizeof(dosya),"/Evler/ev%i.ini",OyuncuEv[playerid]);
		if (OyuncuEv[playerid] == -1) return Mesaj(playerid,"Şu anda evde değilsin!");
		else if (EvEditleniyor[OyuncuEv[playerid]] == true) return Mesaj(playerid,"Şu anda bu evi başka bir oyuncu düzenliyor...");
		else if (IsPlayerAdmin(playerid)) Mesaj(playerid,"Rcon admin bypass aktif!");
		else if (EvSahipID[OyuncuEv[playerid]] != playerid) return Mesaj(playerid,"Bu ev size ait değil!");

		EvEditleniyor[OyuncuEv[playerid]] = true;
		ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		return 1;
	}

	if (strcmp("/satinal", cmdtext, true, 10) == 0)
	{
		if (!Kontrol(playerid)) return Mesaj(playerid,"Herhangi bir evin üstünde değilsiniz!");

		new evid = GetHouseID(playerid);
		if (EvSahipID[evid] != -1) return Mesaj(playerid,"Bu evin zaten bir sahibi var, lütfen satılık bir ev seçiniz!");
		new str[256];
		format(str,sizeof(str),"{00FF7F}Ev Açıklaması: {c0c0c0}%s\n{00FF7F}Ev Fiyatı: {c0c0c0}%i$\n\n{CD5C5C}Bu evi satçn almak istiyor musunuz ?",EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat]);
		ShowPlayerDialog(playerid,SATINAL,DIALOG_STYLE_MSGBOX,BASLIK,str,"Satçn Al","İptal");

		return 1;
	}

	return SendError(playerid,"Komut bulunamadı!");
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

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	for (new i; i < HIZLANDIRICI_COUNT; i++) {
		if (pickupid == hizlandirici[i]) {
			if (!IsPlayerInAnyVehicle(playerid)) return;

			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			DestroyPickup(hizlandirici[i]);
			hizlandirici[i] = CreatePickup(1313, 14, x, y, z, 0);

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
	// - 2 tuşu fonksiyonu
	if (newkeys & KEY_LOOK_BEHIND && IsPlayerInAnyVehicle(playerid))
	{
		if (!IsNosVehicle(GetPlayerVehicleID(playerid))) return RepairVehicle(GetPlayerVehicleID(playerid)),PlayerPlaySound(playerid, 1133 ,0, 0, 0),GameTextForPlayer(playerid,"~b~~h~Full Tamir",500,5);
		
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		PlayerPlaySound(playerid, 1133 ,0, 0, 0);
		RepairVehicle(GetPlayerVehicleID(playerid));
		GameTextForPlayer(playerid,"~g~10x Nitro ~w~~h~& ~b~~h~Tamir",500,5);
	}


	// - Ev sistemi
	if (PRESSED(16))
	{
		if (IsPlayerInAnyVehicle(playerid)) return;

		new evid = GetHouseID(playerid);
		if (Kontrol(playerid))
		{
			new dosya[64];
			format(dosya,sizeof(dosya),"/Evler/ev%i.ini",OyuncuEv[playerid]);
			if (IsPlayerAdmin(playerid)) Mesaj(playerid,"Rcon admin bypass aktif!");
			else if (EvSahipID[evid] == playerid) Mesaj(playerid,"Evinize hoşgeldiniz!"),Mesaj(playerid,"Evinizi düzenlemek veya ayarlarına girmek için '{008080}/ev{FFFFFF}' komutunu kullanınız.");
			else if (EvBilgi[evid][evkilit] == 1) return Mesaj(playerid,"Bu ev kilitli, kilitli evlere giremezsiniz.");
			if (EvBilgi[evid][evint] == 0) PlayerPos(playerid,235.1575,1187.2721,1080.2578,3,EvBilgi[evid][evworld]);
			else if (EvBilgi[evid][evint] == 1) PlayerPos(playerid,225.756989 ,1240.000000 ,1082.149902 ,2,EvBilgi[evid][evworld]);
			else if (EvBilgi[evid][evint] == 2) PlayerPos(playerid,225.630997,1022.479980,1084.069946,7,EvBilgi[evid][evworld]);
			else if (EvBilgi[evid][evint] == 3) PlayerPos(playerid,295.2057,1472.9973,1080.2578,15,EvBilgi[evid][evworld]);
			else if (EvBilgi[evid][evint] == 4) PlayerPos(playerid,327.9004,1478.2839,1084.4375,15,EvBilgi[evid][evworld]);
			else if (EvBilgi[evid][evint] == 5) PlayerPos(playerid,2324.3735,-1148.8219,1050.7101,12,EvBilgi[evid][evworld]);
			OyuncuEv[playerid] = evid;
		}
		else if (IsPlayerInRangeOfPoint(playerid,2,235.1575,1187.2721,1080.2578) ||
		IsPlayerInRangeOfPoint(playerid,2,225.756989,1240.000000,1082.149902) ||
		IsPlayerInRangeOfPoint(playerid,2,225.630997,1022.479980,1084.069946) ||
		IsPlayerInRangeOfPoint(playerid,2,295.2057,1472.9973,1080.2578) ||
		IsPlayerInRangeOfPoint(playerid,2,327.9004,1478.2839,1084.4375) ||
		IsPlayerInRangeOfPoint(playerid,2,2324.3735,-1148.8219,1050.7101)) {
			PlayerPos(playerid,EvBilgi[OyuncuEv[playerid]][ev_X],EvBilgi[OyuncuEv[playerid]][ev_Y],EvBilgi[OyuncuEv[playerid]][ev_Z],0,0),OyuncuEv[playerid] = -1;
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	// - EXP sistemi
	new str[64];
	format(str, sizeof(str), "EXP:%d/1000 - Level:%d/50", exp[playerid], seviye[playerid]);
	TextDrawSetString(expmeter[playerid], str);
	//SetProgressBarValue(Bar:expbar[playerid],exp[playerid]);

	// - Ev sistemi ayarları
	if (Kontrol(playerid)) {
		OyuncuKontrolEv[playerid] = GetHouseID(playerid);
	}

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	// - Silah menüsü
	if (dialogid == 9500 && response) {
		if (listitem == 0) return ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.","Seç","Kapat");
		if (listitem == 1) return ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.","Seç","Kapat");
		if (listitem == 2) return ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Pompalılar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.","Seç","Kapat");
		if (listitem == 3) return ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. Tüfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dön.","Seç","Kapat");
		if (listitem == 4) return ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli Tüfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dön.","Seç","Kapat");
		if (listitem == 5) return ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Patlayçcçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.","Seç","Kapat");
		if (listitem == 6) return ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}

	if (dialogid == 9501) // Tabancalar.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,22,200,"Colt .45",500);
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,23,200,"Susturuculu Colt .45",700);
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	SilahSat(playerid,24,200,"Desert Eagle",1200);
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	if (dialogid == 9502) // Otomatik tabancalar.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,28,200,"Micro Uzi",1250);
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,32,200,"TEC-9",1700);
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	SilahSat(playerid,29,200,"MP-5",2300);
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Menüsü","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	if (dialogid == 9503) // Pompalç tçfekler.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Pompalçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,25,200,"Pump-Action Shotgun",3000);
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Pompalçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,26,200,"Double-Barrel Shotgun",4600);
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Pompalçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	SilahSat(playerid,27,200,"Combat Shotgun",6500);
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Pompalçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	if (dialogid == 9504) // Makineli tçfekler.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. Tçfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,31,200,"M4A1 Carbine",9500);
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. Tçfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,30,200,"Avtomat Kalashnikova 47",7500);
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. Tçfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	if (dialogid == 9505) // Yivli tçfekler.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli Tçfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,33,200,"Country Rifle .22",6700);
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli Tçfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,34,200,"Sniper Rifle",9750);
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli Tçfekler","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	if (dialogid == 9506) // Patlayçcçlar.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Patlayçcçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,16,1,"Grenade",600);
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Patlayçcçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,17,1,"Gas Grenade",250);
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Patlayçcçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	SilahSat(playerid,18,1,"Molotov",700);
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Patlayçcçlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	if (dialogid == 9507) // Ateşsiz silahlar.
	{
	if (response)
	{
	if (listitem == 0)
	{
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 1)
	{
	SilahSat(playerid,1,1,"Brass Knuckles",50);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 2)
	{
	SilahSat(playerid,5,1,"Baseball Bat",100);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 3)
	{
	SilahSat(playerid,2,1,"Golf Club",120);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 4)
	{
	SilahSat(playerid,4,1,"Knife",250);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 5)
	{
	SilahSat(playerid,41,1200,"Spray",300);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 6)
	{
	SilahSat(playerid,42,5500,"Fire Extinguisher",450);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Ateşsiz Silahlar","{009BFF}SİLAH ADI\t\t\tSİLAH FİYATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dön.","Seç","Kapat");
	}
	if (listitem == 7)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah Mençsı","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}Pompalç tçfekler\n{FFFFFF}~ {ACDA00}Makinalç tçfekler\n{FFFFFF}~ {ACDA00}Yivli tçfekler\n{FFFFFF}~ {ACDA00}Patlayçcçlar\n{FFFFFF}~ {ACDA00}Ateşsiz silahlar","Seç","Kapat");
	}
	}
	}

	// - Teles alanları diyalogları
	if (dialogid == 1000 && response) {
		if (listitem == 0) return Teleport(playerid,2027.8171,1008.1444,10.8203,0,0,"Four Dragon Casino","/4d",1,0);
		if (listitem == 1) return Teleport(playerid,-2353.0940,-1633.6820,483.6954,0,0,"Chilliad Mountain","/dag",1,0);
		if (listitem == 2) return Teleport(playerid,369.8283,-1787.7871,5.3585,0,0,"Santa Maria Beach","/sahil",1,0);
		if (listitem == 3) return Teleport(playerid,231.5036,1914.3851,17.6406,0,0,"Area51","/area51",1,0);
		if (listitem == 4) return Teleport(playerid,-2276.2874,718.5117,49.4453,0,0,"China Town","/china",1,0);
		if (listitem == 5) return Teleport(playerid,2786.9534,-1319.9723,34.7975,0,0,"Los Flores","/flores",1,0);
		if (listitem == 6) return Teleport(playerid,-1917.2754,287.0215,41.0469,0,0,"Modifiye Yeri 1","/mod1",1,0);
		if (listitem == 7) return Teleport(playerid,-2705.5503, 206.1621,4.1797,0,0,"Modifiye Yeri 2","/mod2",1,0);
		if (listitem == 8) return Teleport(playerid,2387.4126,1022.6620,10.8203,0,0,"Modifiye Yeri 3","/mod3",1,0);
		if (listitem == 9) return Teleport(playerid,2644.7686,-2019.1096,13.5507,0,0,"Modifiye Yeri 4","/mod4",1,0);
		if (listitem == 10) return Teleport(playerid,1042.0564,-1045.5176,31.8108,0,0,"Modifiye Yeri 5","/mod5",1,0);
		if (listitem == 11) return Teleport(playerid,1686.7,-2450.2,13.6,0,0,"Airport 1","/ap1",1,0);
		if (listitem == 12) return Teleport(playerid,-1345.0, -229.8,14.1,0,0,"Airport 2","/ap2",1,0);
		if (listitem == 13) return Teleport(playerid,1435.5, 1463.2,10.8,0,0,"Airport 3","/ap3",1,0);
		if (listitem == 14) return Teleport(playerid,350.7, 2539.2,16.8,0,0,"Airport 4","/ap4",1,0);
	}

	// - Changelog dialoglarç
	if (dialogid == 1911)
	{
	if (response)
	{
	ShowPlayerDialog(playerid,1912,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.1]","{ACDA00}~ Textdrawlar dçzenlendi.\n~ Teles mençsı gçncellendi. {FFFFFF}(4 yeni teleport alanç){ACDA00}\n~ Admin sistemi dçzenlendi.\n~ Yardçm mençsı dçzenlendi.\n~ \"Desert Eagle Deathmatch\" alanç eklendi.\n~ çlçm-çldçrme gçstergesi eklendi.\n~ /skin komutu eklendi.\n~ /renk komutu eklendi.\n~ Ufak buglar giderildi.\n~ DM sistemi eklendi.","RC1.2","Kapat");
	}
	}

	if (dialogid == 1912)
	{
	if (response)
	{
	ShowPlayerDialog(playerid,1913,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.2]","{ACDA00}~ Ufak buglar giderildi.\n~ \"Fight Club Deathmatch\" alanç eklendi.\n~ Eksik haritalar gçncellendi.\n~ \"Bikepark Stunt 1\" alanç eklendi.\n~ /nrg komutu eklendi.\n~ Araç yçnetim komutlarç eklendi.\n~ Website eklendi. {FFFFFF}(trinity.immortal-official.tk){ACDA00}\n~ Textdraw kaymalarç dçzeltildi.\n~ Gametext sıreleri dçççrçldç.\n~ Giriç dçzenlendi.","RC1.3","Kapat");
	}
	}

	if (dialogid == 1913)
	{
	if (response)
	{
	ShowPlayerDialog(playerid,1914,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.3]","{ACDA00}~ ALPHA hesaplarç silindi.\n~ Kick-Ban mesajlarç ve Giriç-çıkçç mesajlarç gçncellendi.\n~ Araç Kilit Sistemi eklendi. {FFFFFF}(/kilit - /kilitac){ACDA00}\n~ 31 sistemi bugu giderildi.\n~ Ufak buglar giderildi.\n~ Changelog dçzenlendi.\n~ Yeni haritalar eklendi.\n~ Geliçmiç saat sistemi eklendi.\n~ RGM-GM sistemi buglarç giderildi.\n~ Sohbet baloncuçu eklendi.\n~ Driveby engeli kaldçrçldç.","RC1.4","Kapat");
	}
	}

	if (dialogid == 1914)
	{
	if (response)
	{
	ShowPlayerDialog(playerid,1915,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.4]","{ACDA00}~ EXP-LEVEL sistemi eklendi.\n~ Ev sistemi gçncellendi.\n~ Ufak buglar giderildi.\n~ LAdmin gçncellendi. (4.4)\n~ Teleport komutlarç dçzenlendi.\n~ EXP-LEVEL textdrawç yenilendi.\n~ Object Streamer eklendi.\n~ Modifiye alanlarç ve Airport'lar için teleport eklendi. {FFFFFF}(/teles)\n{ACDA00}~ Silahlar mençsı eklendi. {FFFFFF}(/silahlar)\n{ACDA00}~ aLAdmin sistemi eklendi.\n~ Giriçe dans eklendi.","RC1.5","Kapat");
	}
	}
	
	if (dialogid == 1915)
	{
	if (response)
	{
	ShowPlayerDialog(playerid,1916,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.5]","{ACDA00}~ ","Kapat","");
	}
	}
	// - DM alanç dialoglarç
	if (dialogid == 2000)
	{
	if (response)
	{
	if (listitem == 0)
	{
	new State = GetPlayerState(playerid);
	if (IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
	GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 5000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	}
	DM[playerid]=1;
	SetPlayerArmour(playerid,100);
	SetPlayerHealth(playerid,100);
	SetPlayerSkin(playerid, 285);
	SetPlayerInterior(playerid,0);
	ResetPlayerWeapons(playerid);
	new rand = random(sizeof(deagledm1pos));
	SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
	GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 5000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	GivePlayerWeapon(playerid,24,99999);
	SetPlayerTeam(playerid, NO_TEAM);
	}
	if (listitem == 1)
	{
	new State = GetPlayerState(playerid);
	if (IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
	GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 5000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	}
	DM[playerid]=2;
	SetPlayerArmour(playerid,100);
	SetPlayerHealth(playerid,100);
	SetPlayerSkin(playerid, 80);
	SetPlayerInterior(playerid,1);
	ResetPlayerWeapons(playerid);
	new rand = random(sizeof(fistdm1pos));
	SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
	GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 5000, 1);
	SendInfo(playerid,"Deathmatch alançndan çıkmak için {00FF00}/dmcik {FFFFFF}yazınız.");
	SetPlayerTeam(playerid, NO_TEAM);
	}
	}
	}

	// - Stunt dialoglarç
	if (dialogid == 2001)
	{
	if (response)
	{
	if (listitem == 0)
	{
	SendInfo(playerid,"{00FF00}Bikepark Stunt - 1 {FFFFFF}alanına ışınlanıldı.");
	SetPlayerPos(playerid,1165.3389,1344.6733,10.8125);
	}
	}
	}
	// Araç spawn ayarlarç
	if (response)
	{
	new iList = GetPVarInt(playerid, "iList");

	if (dialogid == (DIALOG_OFFSET_ID + iList))
	{
	if (0 <= listitem <= 12)
	{
	new Float: fPos[3];

	if (GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]))
	{
	new iVehID = GetPVarInt(playerid, "iVehID"), Float: fAngle;

	if (IsPlayerInAnyVehicle(playerid))
	GetVehicleZAngle(GetPlayerVehicleID(playerid), fAngle);
	else
	GetPlayerFacingAngle(playerid, fAngle);

	if (iVehID)
	DestroyVehicle(iVehID);

	iVehID = (listitem + (iList * 12) + 400);

	// - Yasak Araç ayarlarç
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

	// - Ev sistemi
	if (dialogid == SATINAL)
	{
		if (!response) return 1;
		if (response)
		{
			new evid = GetHouseID(playerid);
			if (!Kontrol(playerid)) return Mesaj(playerid,"Evi satın almak için herhangi bir evin üstünde olmalısınız!");
			else if (EvSahipID[evid] != -1) return Mesaj(playerid,"Bu evin zaten bir sahibi var, lütfen satılık ev seçiniz!");
			else if (EvBilgi[evid][evfiyat] > GetPlayerMoney(playerid)) return Mesaj(playerid,"Evi almak için yeterli paranız bulunmamakta!");
			EvKaydetInt(evid,"evsatilik",0);
			EvKaydetStr(evid,"evsahip",PlayerName(playerid));
			EvYenile(evid);
			GivePlayerMoney(playerid,-EvBilgi[evid][evfiyat]);
			GameTextForPlayer(playerid,"~w~Ev basariyla~g~ satin alindi!",5000,5);
			PlayerPlaySound(playerid,1058, 0, 0, 0);
		}
	}

	if (dialogid == MENU)
	{
		if (!response) EvEditleniyor[OyuncuEv[playerid]] = false;
		if (response)
		{
			new str[256];
			new evid = OyuncuEv[playerid];
			if (listitem == 0)
			{
				format(str,sizeof(str),"{00FF7F}Ev Açıklaması: {c0c0c0}%s\n\n{CD5C5C}Açıklamayı değiştirmek için yenisini aşağıya yazınız.",EvBilgi[evid][evaciklama]);
				ShowPlayerDialog(playerid,MENU+1,DIALOG_STYLE_INPUT,BASLIK,str,"Değiştir","İptal");
			}
			if (listitem == 1)
			{
				ShowPlayerDialog(playerid,MENU+2,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Kilidi Aç\n{FF4500}Kilitle","Ayarla","İptal");
			}
			if (listitem == 2)
			{
				format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut Paranız: {c0c0c0}%i$\n\n{CD5C5C}Lütfen gerçekleştirilecek işlemi seçiniz.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+3,DIALOG_STYLE_MSGBOX,BASLIK,str,"Yatır/çek","İptal");
			}
			if (listitem == 3)
			{
				format(str,sizeof(str),"{FF4500}Depodan Silah Al\n{FF4500}Depoya Elindeki Silahı Koy");
				ShowPlayerDialog(playerid,MENU+8,DIALOG_STYLE_LIST,BASLIK,str,"Seç","İptal");
			}
		}
	}

	if (dialogid == MENU+1)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			if (!strlen(inputtext)) return Mesaj(playerid,"Lütfen geçerli bir yazı giriniz.");
			new evid = OyuncuEv[playerid];
			EvKaydetStr(evid,"evaciklama",inputtext);
			EvYenile(evid);
			Mesaj(playerid,"Ev açıklaması değiştirildi.");
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		}
	}

	if (dialogid == MENU+2)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new evid = OyuncuEv[playerid];
			if (listitem == 0)
			{
				EvKaydetInt(evid,"evkilit",0);
				Mesaj(playerid,"Evin kilidini açtçnız!");
				EvYenile(evid);
				ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
			}
			if (listitem == 1)
			{
				EvKaydetInt(evid,"evkilit",1);
				Mesaj(playerid,"Evi kilitlediniz!");
				EvYenile(evid);
				ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
			}
		}
	}

	if (dialogid == MENU+3)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			ShowPlayerDialog(playerid,MENU+4,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Para Yatçr\n{FF4500}Para çek","Seç","İptal");
		}
	}

	if (dialogid == MENU+4)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new str[256];
			new evid = OyuncuEv[playerid];
			if (listitem == 0)
			{
				format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut Paranız: {c0c0c0}%i$\n\n{CD5C5C}Lçtfen kasaya yatçrçlcak miktarç yazınız.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+5,DIALOG_STYLE_INPUT,BASLIK,str,"Yatçr","İptal");
			}
			if (listitem == 1)
			{
				format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut Paranız: {c0c0c0}%i$\n\n{CD5C5C}Lçtfen kasadan çekilecek miktarç yazınız.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+6,DIALOG_STYLE_INPUT,BASLIK,str,"çek","İptal");
			}

		}
	}

	if (dialogid == MENU+5)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new evid = OyuncuEv[playerid];
			if (!strlen(inputtext)) return Mesaj(playerid,"Lçtfen geçerli bir rakam giriniz.");
			if (!strval(inputtext)) return Mesaj(playerid,"Lçtfen geçerli bir rakam giriniz.");
			if (strval(inputtext) > GetPlayerMoney(playerid)) return Mesaj(playerid,"Yazılan miktar sizde yeteri kadar bulunmuyor.");
			EvKaydetInt(evid,"evbanka",EvBilgi[evid][evbanka]+strval(inputtext));
			GivePlayerMoney(playerid,-strval(inputtext));
			EvYenile(evid);
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		}
	}

	if (dialogid == MENU+6)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new evid = OyuncuEv[playerid];
			if (!strlen(inputtext)) return Mesaj(playerid,"Lçtfen geçerli bir rakam giriniz.");
			if (!strval(inputtext)) return Mesaj(playerid,"Lçtfen geçerli bir rakam giriniz.");
			if (strval(inputtext) > EvBilgi[evid][evbanka]) return Mesaj(playerid,"Yazılan miktar kasanızda yeteri kadar bulunmuyor.");
			EvKaydetInt(evid,"evbanka",EvBilgi[evid][evbanka]-strval(inputtext));
			GivePlayerMoney(playerid,strval(inputtext));
			EvYenile(evid);
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		}
	}

	if (dialogid == MENU+7)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
		}
	}

	if (dialogid == MENU+8)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new evid = OyuncuEv[playerid];
			if (listitem == 0)
			{
				new s1 = EvBilgi[evid][silahslot1];
				new s2 = EvBilgi[evid][silahslot2];
				new s3 = EvBilgi[evid][silahslot3];
				new s4 = EvBilgi[evid][silahslot4];
				new s5 = EvBilgi[evid][silahslot5];
				new s6 = EvBilgi[evid][silahslot6];
				new str[512],slot1[32],slot2[32],slot3[32],slot4[32],slot5[32],slot6[32];
				if (s1 == -1) slot1 = "Yok"; else slot1 = WeaponName(s1);
				if (s2 == -1) slot2 = "Yok"; else slot2 = WeaponName(s2);
				if (s3 == -1) slot3 = "Yok"; else slot3 = WeaponName(s3);
				if (s4 == -1) slot4 = "Yok"; else slot4 = WeaponName(s4);
				if (s5 == -1) slot5 = "Yok"; else slot5 = WeaponName(s5);
				if (s6 == -1) slot6 = "Yok"; else slot6 = WeaponName(s6);
				format(str,sizeof(str),
				"{FF4500}Slot 1: {FFFFFF}%s\n{FF4500}Slot 2: {FFFFFF}%s\n{FF4500}Slot 3: {FFFFFF}%s\n{FF4500}Slot 4: {FFFFFF}%s\n{FF4500}Slot 5: {FFFFFF}%s\n{FF4500}Slot 6: {FFFFFF}%s",slot1,slot2,slot3,slot4,slot5,slot6);
				ShowPlayerDialog(playerid,MENU+9,DIALOG_STYLE_LIST,BASLIK,str,"Seç","İptal");
			}
			if (listitem == 1)
			{
				new s1 = EvBilgi[evid][silahslot1];
				new s2 = EvBilgi[evid][silahslot2];
				new s3 = EvBilgi[evid][silahslot3];
				new s4 = EvBilgi[evid][silahslot4];
				new s5 = EvBilgi[evid][silahslot5];
				new s6 = EvBilgi[evid][silahslot6];
				new str[512],slot1[32],slot2[32],slot3[32],slot4[32],slot5[32],slot6[32];
				if (s1 == -1) slot1 = "Yok"; else slot1 = WeaponName(s1);
				if (s2 == -1) slot2 = "Yok"; else slot2 = WeaponName(s2);
				if (s3 == -1) slot3 = "Yok"; else slot3 = WeaponName(s3);
				if (s4 == -1) slot4 = "Yok"; else slot4 = WeaponName(s4);
				if (s5 == -1) slot5 = "Yok"; else slot5 = WeaponName(s5);
				if (s6 == -1) slot6 = "Yok"; else slot6 = WeaponName(s6);
				format(str,sizeof(str),
				"{FF4500}Slot 1: {FFFFFF}%s\n{FF4500}Slot 2: {FFFFFF}%s\n{FF4500}Slot 3: {FFFFFF}%s\n{FF4500}Slot 4: {FFFFFF}%s\n{FF4500}Slot 5: {FFFFFF}%s\n{FF4500}Slot 6: {FFFFFF}%s",slot1,slot2,slot3,slot4,slot5,slot6);
				ShowPlayerDialog(playerid,MENU+10,DIALOG_STYLE_LIST,BASLIK,str,"Seç","İptal");
			}
		}
	}

	if (dialogid == MENU+9)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new evid = OyuncuEv[playerid];
			new s1 = EvBilgi[evid][silahslot1];
			new s2 = EvBilgi[evid][silahslot2];
			new s3 = EvBilgi[evid][silahslot3];
			new s4 = EvBilgi[evid][silahslot4];
			new s5 = EvBilgi[evid][silahslot5];
			new s6 = EvBilgi[evid][silahslot6];
			new s1x = EvBilgi[evid][silahslot1x];
			new s2x = EvBilgi[evid][silahslot2x];
			new s3x = EvBilgi[evid][silahslot3x];
			new s4x = EvBilgi[evid][silahslot4x];
			new s5x = EvBilgi[evid][silahslot5x];
			new s6x = EvBilgi[evid][silahslot6x];

			switch (listitem)
			{
				case 0:
				{
					if (s1 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s1,s1x);
					EvKaydetInt(evid,"silahslot1",-1);
					EvKaydetInt(evid,"silahslot1x",-1);
					EvYenile(evid);
				}
				case 1:
				{
					if (s2 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s2,s2x);
					EvKaydetInt(evid,"silahslot2",-1);
					EvKaydetInt(evid,"silahslot2x",-1);
					EvYenile(evid);
				}
				case 2:
				{
					if (s3 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s3,s3x);
					EvKaydetInt(evid,"silahslot3",-1);
					EvKaydetInt(evid,"silahslot3x",-1);
					EvYenile(evid);
				}
				case 3:
				{
					if (s4 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s4,s4x);
					EvKaydetInt(evid,"silahslot4",-1);
					EvKaydetInt(evid,"silahslot4x",-1);
					EvYenile(evid);
				}
				case 4:
				{
					if (s5 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s5,s5x);
					EvKaydetInt(evid,"silahslot5",-1);
					EvKaydetInt(evid,"silahslot5x",-1);
					EvYenile(evid);
				}
				case 5:
				{
					if (s6 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s6,s6x);
					EvKaydetInt(evid,"silahslot6",-1);
					EvKaydetInt(evid,"silahslot6x",-1);
					EvYenile(evid);
				}
			}
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		}
	}

	if (dialogid == MENU+10)
	{
		if (!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		if (response)
		{
			new evid = OyuncuEv[playerid];
			new s1 = EvBilgi[evid][silahslot1];
			new s2 = EvBilgi[evid][silahslot2];
			new s3 = EvBilgi[evid][silahslot3];
			new s4 = EvBilgi[evid][silahslot4];
			new s5 = EvBilgi[evid][silahslot5];
			new s6 = EvBilgi[evid][silahslot6];
			if (GetPlayerWeapon(playerid) == 0) return Mesaj(playerid,"Elinizde silah yok.");

			switch (listitem)
			{
				case 0:
				{
					if (s1 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot1",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot1x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 1:
				{
					if (s2 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot2",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot2x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 2:
				{
					if (s3 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot3",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot3x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 3:
				{
					if (s4 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot4",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot4x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 4:
				{
					if (s5 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot5",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot5x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 5:
				{
					if (s6 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot6",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot6x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
			}
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasası\n{FF4500}Ev Silah Deposu","Seç","İptal");
		}
	}

	if (dialogid == DIALOG)
	{
		if (!response) EvEditleniyor[GetHouseID(playerid)] = false;
		if (response)
		{
			if (!Kontrol(playerid)) return Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
			new str[256];
			new evid = GetHouseID(playerid);
			if (listitem == 0) //Ev Açıklaması
			{
				format(str,sizeof(str),"{00FF7F}Ev Açıklaması: {c0c0c0}%s\n\n{CD5C5C}Açıklamayı değiştirmek için yenisini açaççya yazınız.",EvBilgi[evid][evaciklama]);
				ShowPlayerDialog(playerid,DIALOG+2,DIALOG_STYLE_INPUT,BASLIK,str,"Değiştir","İptal");
			}
			if (listitem == 1) //Ev Sahibi
			{
				new sahip[255];
				new dosya[64];
				format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
				if (!strlen(EvBilgi[evid][evsahip])) sahip = "Yok";
				//else sahip = dini_Get(dosya,"evsahip");
				format(str,sizeof(str),"{00FF7F}Ev Sahibi: {c0c0c0}%s\n\n{CD5C5C}Ev sahibini deçiçtirirseniz tçm ev belirlenen kiçiye devredilir.\nEçer boç bçrakçrsanız ev satçlçk olarak deçiçtirilir.",sahip);
				ShowPlayerDialog(playerid,DIALOG+3,DIALOG_STYLE_INPUT,BASLIK,str,"Değiştir","İptal");
			}
			if (listitem == 2) //Ev Fiyatç
			{
				format(str,sizeof(str),"{00FF7F}Ev Fiyatç: {c0c0c0}%i$\n\n{CD5C5C}Yeni ev fiyatçnç deçiçtirmek için yeni miktarç giriniz.",EvBilgi[evid][evfiyat]);
				ShowPlayerDialog(playerid,DIALOG+4,DIALOG_STYLE_INPUT,BASLIK,str,"Değiştir","İptal");
			}
			if (listitem == 3) //Ev Interior
			{
				new menu[450];
				strcat(menu,"{FF4500}Ev 1\n");
				strcat(menu,"{FF4500}Ev 2\n");
				strcat(menu,"{FF4500}Ev 3\n");
				strcat(menu,"{FF4500}Ev 4\n");
				strcat(menu,"{FF4500}Ev 5\n");
				strcat(menu,"{FF4500}Unused Villası");
				ShowPlayerDialog(playerid,DIALOG+5,DIALOG_STYLE_LIST,BASLIK,menu,"Ayarla","İptal");
			}
			if (listitem == 4) //Ev Kilidi
			{
				ShowPlayerDialog(playerid,DIALOG+7,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Kilidi Aç\n{FF4500}Kilitle","Ayarla","İptal");
			}
			if (listitem == 5) //Ev Sil
			{
				ShowPlayerDialog(playerid,DIALOG+8,DIALOG_STYLE_MSGBOX,BASLIK,"{B22222}Bunu yaparsanız ev kaydç tamamen silinecektir ve Geri dönççç olmayacaktçr.\n{C0C0C0}Silmeyi onaylçyor musunuz ?","Onayla","İptal");
			}
		}
	}
	if (dialogid == DIALOG+1 && response)
	{
		if (listitem == 0)
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			for (new i;i<MAX_HOUSE;i++)
			{
				if (EvBilgi[i][evvid] == -1)
				{
					EvYarat(i, x, y, z);
					break;
				}
			}
			Mesaj(playerid,"başarıyla ev yarattınız, düzenlemek için pickup üzerinde '{008080}/evmenu{FFFFFF}' komutunu kullanınız.");
		}
	}
	if (dialogid == DIALOG+2)
	{
		if (!response) return ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");

		if (!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
		if (!strlen(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Lütfen geçerli bir yazı giriniz.") ;
		new evid = OyuncuKontrolEv[playerid];
		EvKaydetStr(evid,"evaciklama",inputtext);
		EvYenile(evid);
		Mesaj(playerid,"Ev açıklaması deçiçtirildi.");
		ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
	}
	if (dialogid == DIALOG+3)
	{
		if (!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		if (response)
		{
			new evid = OyuncuKontrolEv[playerid];
			if (!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
			if (!strlen(inputtext)) EvKaydetInt(evid,"evsatilik",1),EvKaydetStr(evid,"evsahip",""),Mesaj(playerid,"Ev satçlçk olarak deçiçtirildi!");
			else EvKaydetInt(evid,"evsatilik",0),EvKaydetStr(evid,"evsahip",inputtext),Mesaj(playerid,"Ev sahibi deçiçtirildi!");
			EvYenile(evid);
			SahipKontrol();
			ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		}
	}
	if (dialogid == DIALOG+4)
	{
		if (!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		if (response)
		{
			if (!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
			if (!strlen(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Lçtfen geçerli bir rakam giriniz.");
			if (!strval(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Lçtfen geçerli bir rakam giriniz.");
			new evid = OyuncuKontrolEv[playerid];
			EvKaydetInt(evid,"evfiyat",strval(inputtext));
			Mesaj(playerid,"Ev fiyatç deçiçtirildi!");
			EvYenile(evid);
			ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		}
	}
	if (dialogid == DIALOG+5)
	{
		if (!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		if (response)
		{
			if (!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
			new evid = OyuncuKontrolEv[playerid];
			if (listitem == 0) EvKaydetInt(evid,"evint",0);
			if (listitem == 1) EvKaydetInt(evid,"evint",1);
			if (listitem == 2) EvKaydetInt(evid,"evint",2);
			if (listitem == 3) EvKaydetInt(evid,"evint",3);
			if (listitem == 4) EvKaydetInt(evid,"evint",4);
			if (listitem == 5) EvKaydetInt(evid,"evint",5);

			EvYenile(evid);
			Mesaj(playerid,"Ev interioru deçiçtirildi!");
			ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		}
	}
	if (dialogid == DIALOG+7)
	{
		if (!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		if (response)
		{
			if (!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
			new evid = OyuncuKontrolEv[playerid];
			if (listitem == 0)
			{
				EvKaydetInt(evid,"evkilit",0);
				Mesaj(playerid,"Evin kilidini açtçnız!");
				EvYenile(evid);
				ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
			}
			if (listitem == 1)
			{
				EvKaydetInt(evid, "evkilit", 1);
				Mesaj(playerid,"Evi kilitlediniz!");
				EvYenile(evid);
				ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
			}
		}
	}
	if (dialogid == DIALOG+8)
	{
		if (!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açıklaması\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatç\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","İptal");
		if (response)
		{
			if (Kontrol(playerid)) EvSil(GetHouseID(playerid)),EvEditleniyor[GetHouseID(playerid)] = false;
			else Mesaj(playerid,"Ev dçzenlemek için herhangi bir evin çstçnde olmalısınız!");
		}
	}
	return 1;
}

// - strtok
strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// - Silah sistemi
stock SilahSat(playerid,silahid,silahammo,const silahisim[],ucret)
{
	if (GetPlayerMoney(playerid) < ucret) return SendError(playerid,"Para yetersiz!");
	GivePlayerWeapon(playerid,silahid,silahammo);
	GivePlayerMoney(playerid,-ucret);
	new string[512];
	format(string,512,"ç BçLGç: {ACDA00}%s {FFFFFF}isimli silahı {ACDA00}%d$ {FFFFFF}çdeyerek aldçnız.",silahisim,ucret);
	SendClientMessageToAll(0x00A2F6AA,string);
	return 1;
}

// - Teleport sistemi
stock Teleport(playerid, Float:tX, Float:tY, Float:tZ, Int, World, const isim[], const command[], arabali, objeyukle)
{
	if (objeyukle == 1) ObjeYukle(playerid);

	if (arabali == 1 && IsPlayerInAnyVehicle(playerid)) {
		SetVehiclePos(GetPlayerVehicleID(playerid),tX,tY,tZ);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),Int);
	} else {
		SetPlayerPos(playerid, tX, tY, tZ);
	}

	SetPlayerInterior(playerid, Int);
	SetPlayerVirtualWorld(playerid, World);

	new string[512];
	format(string,512,"** BİLGİ: {ACDA00}%s {FFFFFF}rumuzlu oyuncu {ACDA00}%s {FFFFFF}bölgesine ışınlandı. {ACDA00}(%s)",PlayerName(playerid),isim,command);
	SendClientMessageToAll(0x00A2F6AA, string);

	format(string, 512, "{ACDA00}%s {FFFFFF}alanına ışınlandınız.", isim);
	SendInfo(playerid, string);
}

forward ObjeYukle(playerid);
public ObjeYukle(playerid)
{
	TogglePlayerControllable(playerid,0);
	GameTextForPlayer(playerid,"~b~Objeler Yukleniyor...",3000,5);
	SetTimerEx("ObjeYukleTamam",4000,false,"i",playerid);
}

forward ObjeYukleTamam(playerid);
public ObjeYukleTamam(playerid)
{
	TogglePlayerControllable(playerid,1);
	GameTextForPlayer(playerid,"~y~] ~b~Objeler Yuklendi. ~y~]",5000,5);
}

// - EXP sistemi
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
GetPlayerName(playerid,is,sizeof(is));
format(SPL,sizeof(SPL),"Hesaplar/Level/%s.txt", is);

//dini_IntSet(SPL, "Exp", exp[playerid]);
//dini_IntSet(SPL, "Level", seviye[playerid]);
//dini_IntSet(SPL, "Skor", GetPlayerScore(playerid));

new str[64];
format(str, sizeof(str), "EXP:%d/1000 - Level:%d/50", exp[playerid], seviye[playerid]);
TextDrawSetString(expmeter[playerid], str);
//SetProgressBarValue(Bar:expbar[playerid],exp[playerid]);
return 1;}

stock BilgiYukle(playerid)
{
new SPL[256], is[24];
GetPlayerName(playerid,is,sizeof(is));
format(SPL,sizeof(SPL),"Hesaplar/Level/%s.txt", is);

exp[playerid] = dini_Int(SPL, "Exp");
seviye[playerid] = dini_Int(SPL, "Level");
SetPlayerScore(playerid, dini_Int(SPL, "Skor"));
//SetProgressBarValue(Bar:expbar[playerid],exp[playerid]);
return 1;}

stock ExpVer(playerid){
	if (seviye[playerid] == 1)
	{
	exp[playerid]=exp[playerid]+20;
	}
	else if (seviye[playerid] == 2)
	{
	exp[playerid]=exp[playerid]+18;
	}
	else if (seviye[playerid] == 3)
	{
	exp[playerid]=exp[playerid]+18;
	}
	else if (seviye[playerid] == 4)
	{
	exp[playerid]=exp[playerid]+16;
	}
	else if (seviye[playerid] == 5)
	{
	exp[playerid]=exp[playerid]+14;
	}
	else if (seviye[playerid] == 6)
	{
	exp[playerid]=exp[playerid]+12;
	}
	else if (seviye[playerid] == 7)
	{
	exp[playerid]=exp[playerid]+10;
	}
	else if (seviye[playerid] == 8)
	{
	exp[playerid]=exp[playerid]+8;
	}
	else if (seviye[playerid] == 9)
	{
	exp[playerid]=exp[playerid]+6;
	}
	else if (seviye[playerid] == 10)
	{
	exp[playerid]=exp[playerid]+4;
	}
	else if (seviye[playerid] == 11)
	{
	exp[playerid]=exp[playerid]+4;
	}
	else if (seviye[playerid] == 12)
	{
	exp[playerid]=exp[playerid]+3;
	}
	else if (seviye[playerid] == 13)
	{
	exp[playerid]=exp[playerid]+3;
	}
	else if (seviye[playerid] == 14)
	{
	exp[playerid]=exp[playerid]+2;
	}
	else if (seviye[playerid] == 15)
	{
	exp[playerid]=exp[playerid]+2;
	}
	else if (seviye[playerid] == 16)
	{
	exp[playerid]=exp[playerid]+2;
	}
	else if (seviye[playerid] == 17)
	{
	exp[playerid]=exp[playerid]+1;
	}
	else if (seviye[playerid] == 18)
	{
	exp[playerid]=exp[playerid]+1;
	}
	else if (seviye[playerid] == 19)
	{
	exp[playerid]=exp[playerid]+1;
	}
	else if (seviye[playerid] > 19)
	{
	exp[playerid]=exp[playerid]+1;
	}

	if (exp[playerid] >= 1000){
	if (seviye[playerid] < 50){
	seviye[playerid]++;
	exp[playerid]=0;
	}}
	return 1;
}
*/

// - Saat sistemi
forward UpdateServerTime();
public UpdateServerTime()
{
	Minute += 1;
	if (Minute == 60 && Hour < 24)
	{
	Hour += 1, Minute = 0;
	SetWorldTime(Hour);
	}
	if (Hour == 24 && Minute == 0)
	{
	Hour = 0, Minute = 0;
	SetWorldTime(Hour);
	}

	new string[6];
	format(string, sizeof(string), "%02d:%02d", Hour, Minute);
	TextDrawSetString(TimeText, string);

	for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
	if (!IsPlayerConnected(playerid)) continue;
	SetPlayerTime(playerid, Hour, Minute);
	}
	return 1;
}

// - 31 çekme sistemi
forward asilanadamtimer(playerid);
public asilanadamtimer(playerid)
{
	if (cekiyor[playerid] == 1)
	{
	GivePlayerMoney(playerid,31);
	SendInfo(playerid,"31'den para aldçnız! {FF0000}(31$)");
	}
	return 1;
}

// - Random spawn publici
forward SetPlayerRandomSpawn(playerid);
public SetPlayerRandomSpawn(playerid)
{
	new rand = random(sizeof(RandomPlayerSpawns));
	SetPlayerPos(playerid, RandomPlayerSpawns[rand][0], RandomPlayerSpawns[rand][1], RandomPlayerSpawns[rand][2]);
	return 1;
}

// - IsNumeric çeysi
stock IsNumeric(const string[])
{
   for (new i, j = strlen(string); i < j; ++i)
   {
	  if (!('0' <= string[i] <= '9'))
	  {
		 return 0;
	  }
   }
   return 1;
}

// - Nos alabilecek Araçlar
IsNosVehicle(vehicleid)
{
	#define NO_NOS_VEHICLES 29

	new InvalidNosVehicles[NO_NOS_VEHICLES] =
	{
		   581,523,462,521,463,522,461,448,468,586,
		   509,481,510,472,473,493,595,484,430,453,
		   452,446,454,590,569,537,538,570,449
	};

	for (new i = 0; i < NO_NOS_VEHICLES; i++)
	{
		if (GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
		{
			return false;
		}
	}
	return true;
}

// - Ev sistemi public & fonksiyonlarç
public OyuncuMapIconKontrol(playerid)
{
	/*
	for (new i=0;i<ToplamEv;i++)
	{
		new dosya[64];
		format(dosya,sizeof(dosya),"/Evler/ev%i.ini",i);
		if (dini_Exists(dosya))
		{
			if (EvBilgi[i][evsatilik] == 0)
			{
				 SetPlayerMapIcon(playerid,i,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z],REDMAP,0);
			}
			else if (EvBilgi[i][evsatilik] == 1)
			{
				SetPlayerMapIcon(playerid,i,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z],GREENMAP,0);
			}
		}
	}
	*/
	return 1;
}

public EvYukle(evid)
{
	/*
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	if (dini_Exists(dosya))
	{
		new str[256],durum[16];
		EvBilgi[evid][evsatilik] = dini_Int(dosya,"evsatilik");
		EvBilgi[evid][evsahip] = dini_Get(dosya,"evsahip");
		EvBilgi[evid][evaciklama] = dini_Get(dosya,"evaciklama");
		EvBilgi[evid][evfiyat] = dini_Int(dosya,"evfiyat");
		EvBilgi[evid][evbanka] = dini_Int(dosya,"evbanka");
		EvBilgi[evid][evkilit] = dini_Int(dosya,"evkilit");
		EvBilgi[evid][evint] = dini_Int(dosya,"evint");
		EvBilgi[evid][evworld] = dini_Int(dosya,"evworld");
		EvBilgi[evid][ev_X] = dini_Float(dosya,"ev_X");
		EvBilgi[evid][ev_Y] = dini_Float(dosya,"ev_Y");
		EvBilgi[evid][ev_Z] = dini_Float(dosya,"ev_Z");
		EvBilgi[evid][evvid] = dini_Int(dosya,"evvid");
		EvBilgi[evid][silahslot1] = dini_Int(dosya,"silahslot1");
		EvBilgi[evid][silahslot2] = dini_Int(dosya,"silahslot2");
		EvBilgi[evid][silahslot3] = dini_Int(dosya,"silahslot3");
		EvBilgi[evid][silahslot4] = dini_Int(dosya,"silahslot4");
		EvBilgi[evid][silahslot5] = dini_Int(dosya,"silahslot5");
		EvBilgi[evid][silahslot6] = dini_Int(dosya,"silahslot6");
		EvBilgi[evid][silahslot1x] = dini_Int(dosya,"silahslot1x");
		EvBilgi[evid][silahslot2x] = dini_Int(dosya,"silahslot2x");
		EvBilgi[evid][silahslot3x] = dini_Int(dosya,"silahslot3x");
		EvBilgi[evid][silahslot4x] = dini_Int(dosya,"silahslot4x");
		EvBilgi[evid][silahslot5x] = dini_Int(dosya,"silahslot5x");
		EvBilgi[evid][silahslot6x] = dini_Int(dosya,"silahslot6x");

		if (EvBilgi[evid][evkilit] == 0) durum = "Açık";
		else if (EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		TextLabel[evid] = Create3DTextLabel("...",0xFFFFFFFF,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],30,0);

		if (EvBilgi[evid][evsatilik] == 0)
		{
			format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
			Pickup[evid] = CreatePickup(BLUEH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		}
		else if (EvBilgi[evid][evsatilik] == 1)
		{
			format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}Satçlçk\n{00FF7F}Ev Fiyatç: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
			Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);

		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // Yüklendi.",evid,EvBilgi[evid][evfiyat],durum);
		ToplamEv++;
	}
	*/
	return 1;
}

public EvYenile(evid)
{
	/*
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	if (dini_Exists(dosya))
	{
		new str[256],durum[16];
		EvBilgi[evid][evsatilik] = dini_Int(dosya,"evsatilik");
		EvBilgi[evid][evsahip] = dini_Get(dosya,"evsahip");
		EvBilgi[evid][evaciklama] = dini_Get(dosya,"evaciklama");
		EvBilgi[evid][evfiyat] = dini_Int(dosya,"evfiyat");
		EvBilgi[evid][evbanka] = dini_Int(dosya,"evbanka");
		EvBilgi[evid][evkilit] = dini_Int(dosya,"evkilit");
		EvBilgi[evid][evint] = dini_Int(dosya,"evint");
		EvBilgi[evid][evworld] = dini_Int(dosya,"evworld");
		EvBilgi[evid][ev_X] = dini_Float(dosya,"ev_X");
		EvBilgi[evid][ev_Y] = dini_Float(dosya,"ev_Y");
		EvBilgi[evid][ev_Z] = dini_Float(dosya,"ev_Z");
		EvBilgi[evid][silahslot1] = dini_Int(dosya,"silahslot1");
		EvBilgi[evid][silahslot2] = dini_Int(dosya,"silahslot2");
		EvBilgi[evid][silahslot3] = dini_Int(dosya,"silahslot3");
		EvBilgi[evid][silahslot4] = dini_Int(dosya,"silahslot4");
		EvBilgi[evid][silahslot5] = dini_Int(dosya,"silahslot5");
		EvBilgi[evid][silahslot6] = dini_Int(dosya,"silahslot6");
		EvBilgi[evid][silahslot1x] = dini_Int(dosya,"silahslot1x");
		EvBilgi[evid][silahslot2x] = dini_Int(dosya,"silahslot2x");
		EvBilgi[evid][silahslot3x] = dini_Int(dosya,"silahslot3x");
		EvBilgi[evid][silahslot4x] = dini_Int(dosya,"silahslot4x");
		EvBilgi[evid][silahslot5x] = dini_Int(dosya,"silahslot5x");
		EvBilgi[evid][silahslot6x] = dini_Int(dosya,"silahslot6x");

		if (EvBilgi[evid][evkilit] == 0) durum = "Açık";
		else if (EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		if (EvBilgi[evid][evsatilik] == 0)
		{
			format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
		}
		else if (EvBilgi[evid][evsatilik] == 1)
		{
			format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}Satçlçk\n{00FF7F}Ev Fiyatç: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);
		EvPickupYenile(evid);

		printf("");
		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // Yenilendi.",evid,EvBilgi[evid][evfiyat],durum);
	}
	*/
	return 1;
}

public EvYarat(evid, Float:X, Float:Y, Float:Z)
{
	/*
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	if (!dini_Exists(dosya))
	{
		new str[256],durum[16];

		dini_Create(dosya);
		dini_Set(dosya,"evaciklama",ACIKLAMA);
		dini_Set(dosya,"evsahip","");
		dini_IntSet(dosya,"evsatilik",1);
		dini_IntSet(dosya,"evfiyat",FIYAT);
		dini_IntSet(dosya,"evbanka",KASA);
		dini_IntSet(dosya,"evkilit",KILIT);
		dini_IntSet(dosya,"evint",random(14));
		dini_IntSet(dosya,"evworld",random(999999));
		dini_FloatSet(dosya,"ev_X",X);
		dini_FloatSet(dosya,"ev_Y",Y);
		dini_FloatSet(dosya,"ev_Z",Z);
		dini_IntSet(dosya,"evvid",evid);
		dini_IntSet(dosya,"silahslot1",-1);
		dini_IntSet(dosya,"silahslot2",-1);
		dini_IntSet(dosya,"silahslot3",-1);
		dini_IntSet(dosya,"silahslot4",-1);
		dini_IntSet(dosya,"silahslot5",-1);
		dini_IntSet(dosya,"silahslot6",-1);
		dini_IntSet(dosya,"silahslot1x",-1);
		dini_IntSet(dosya,"silahslot2x",-1);
		dini_IntSet(dosya,"silahslot3x",-1);
		dini_IntSet(dosya,"silahslot4x",-1);
		dini_IntSet(dosya,"silahslot5x",-1);
		dini_IntSet(dosya,"silahslot6x",-1);

		EvBilgi[evid][evsatilik] = dini_Int(dosya,"evsatilik");
		EvBilgi[evid][evsahip] = dini_Get(dosya,"evsahip");
		EvBilgi[evid][evaciklama] = dini_Get(dosya,"evaciklama");
		EvBilgi[evid][evfiyat] = dini_Int(dosya,"evfiyat");
		EvBilgi[evid][evbanka] = dini_Int(dosya,"evbanka");
		EvBilgi[evid][evkilit] = dini_Int(dosya,"evkilit");
		EvBilgi[evid][evint] = dini_Int(dosya,"evint");
		EvBilgi[evid][evworld] = dini_Int(dosya,"evworld");
		EvBilgi[evid][ev_X] = dini_Float(dosya,"ev_X");
		EvBilgi[evid][ev_Y] = dini_Float(dosya,"ev_Y");
		EvBilgi[evid][ev_Z] = dini_Float(dosya,"ev_Z");
		EvBilgi[evid][evvid] = dini_Int(dosya,"evvid");
		EvBilgi[evid][silahslot1] = dini_Int(dosya,"silahslot1");
		EvBilgi[evid][silahslot2] = dini_Int(dosya,"silahslot2");
		EvBilgi[evid][silahslot3] = dini_Int(dosya,"silahslot3");
		EvBilgi[evid][silahslot4] = dini_Int(dosya,"silahslot4");
		EvBilgi[evid][silahslot5] = dini_Int(dosya,"silahslot5");
		EvBilgi[evid][silahslot6] = dini_Int(dosya,"silahslot6");
		EvBilgi[evid][silahslot1x] = dini_Int(dosya,"silahslot1x");
		EvBilgi[evid][silahslot2x] = dini_Int(dosya,"silahslot2x");
		EvBilgi[evid][silahslot3x] = dini_Int(dosya,"silahslot3x");
		EvBilgi[evid][silahslot4x] = dini_Int(dosya,"silahslot4x");
		EvBilgi[evid][silahslot5x] = dini_Int(dosya,"silahslot5x");
		EvBilgi[evid][silahslot6x] = dini_Int(dosya,"silahslot6x");

		if (EvBilgi[evid][evkilit] == 0) durum = "Açık";
		else if (EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		TextLabel[evid] = Create3DTextLabel("...",0xFFFFFFFF,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],30,0);

		if (EvBilgi[evid][evsatilik] == 0)
		{
			format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
			Pickup[evid] = CreatePickup(BLUEH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
			for (new a;a<MAX_PLAYERS;a++) if (IsPlayerConnected(a)) SetPlayerMapIcon(a,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],REDMAP,0);
		}
		else if (EvBilgi[evid][evsatilik] == 1)
		{
			format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}Satçlçk\n{00FF7F}Ev Fiyatç: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
			Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
			for (new a;a<MAX_PLAYERS;a++) if (IsPlayerConnected(a)) SetPlayerMapIcon(a,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],GREENMAP,0);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);

		printf("");
		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // Oluçturuldu.",evid,EvBilgi[evid][evfiyat],durum);

		ToplamEv++;
	}
	*/
	return 1;
}

public EvPickupYenile(evid)
{
	if (EvBilgi[evid][evsatilik] == 0)
	{
		DestroyPickup(Pickup[evid]);
		Pickup[evid] = CreatePickup(BLUEH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i)) RemovePlayerMapIcon(i,evid),SetPlayerMapIcon(i,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],REDMAP,0);
	}
	else if (EvBilgi[evid][evsatilik] == 1)
	{
		DestroyPickup(Pickup[evid]);
		Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i)) RemovePlayerMapIcon(i,evid),SetPlayerMapIcon(i,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],GREENMAP,0);
	}
	return 1;
}

public EvSil(evid)
{
	/*
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	if (dini_Exists(dosya))
	{
		printf("");
		printf("Ev ID: %i // Silindi.",evid);
		DestroyPickup(Pickup[evid]);
		Delete3DTextLabel(TextLabel[evid]);
		for (new b;b<MAX_PLAYERS;b++) if (IsPlayerConnected(b)) RemovePlayerMapIcon(b,evid);
		EvBilgi[evid][evsatilik] = -1;
		EvBilgi[evid][evsahip] = -1;
		EvBilgi[evid][evaciklama] = -1;
		EvBilgi[evid][evfiyat] = -1;
		EvBilgi[evid][evbanka] = -1;
		EvBilgi[evid][evkilit] = -1;
		EvBilgi[evid][evint] = -1;
		EvBilgi[evid][evworld] = -1;
		EvBilgi[evid][ev_X] = -1;
		EvBilgi[evid][ev_Y] = -1;
		EvBilgi[evid][ev_Z] = -1;
		EvBilgi[evid][evvid] = -1;
		EvBilgi[evid][silahslot1] = -1;
		EvBilgi[evid][silahslot2] = -1;
		EvBilgi[evid][silahslot3] = -1;
		EvBilgi[evid][silahslot4] = -1;
		EvBilgi[evid][silahslot5] = -1;
		EvBilgi[evid][silahslot6] = -1;
		EvBilgi[evid][silahslot1x] = -1;
		EvBilgi[evid][silahslot2x] = -1;
		EvBilgi[evid][silahslot3x] = -1;
		EvBilgi[evid][silahslot4x] = -1;
		EvBilgi[evid][silahslot5x] = -1;
		EvBilgi[evid][silahslot6x] = -1;
		EvEditleniyor[evid] = false;
		dini_Remove(dosya);
		ToplamEv--;
	}
	*/
	return 1;
}

public EvKaydetInt(evid, const bilgii[], deger)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	//dini_IntSet(dosya,bilgii,deger);
	return 1;
}

public EvKaydetStr(evid, const bilgii[], const deger[])
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	//dini_Set(dosya,bilgii,deger);
	return 1;
}

public EvKaydetFloat(evid, const bilgii[], Float:deger)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
	//dini_FloatSet(dosya,bilgii,deger);
	return 1;
}

public SahipKontrol()
{
	/*
	for (new i;i<MAX_HOUSE;i++)
	{
		EvSahipID[i] = -1;
		new dosya[64];
		format(dosya,sizeof(dosya),"/Evler/ev%i.ini",i);
		if (dini_Exists(dosya))
		{
			   if (IsPlayerConnected(GetPlayerID(dini_Get(dosya,"evsahip"))))
			{
				EvSahipID[i] = GetPlayerID(dini_Get(dosya,"evsahip"));
			}
		}
	}
	*/
	return 1;
}

stock GetHouseID(playerid)
{
	for (new i=0;i<MAX_HOUSE;i++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z])) return i;
	}
	return -255;
}

public Kontrol(playerid)
{
	for (new i=0;i<MAX_HOUSE;i++)
	{
		if (IsPlayerInRangeOfPoint(playerid,1,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z]))
		{
			return 1;
		}
	}
	return 0;
}

public PlayerPos(playerid, Float:X, Float:Y, Float:Z,interior,world)
{
	SetPlayerPos(playerid,X,Y,Z);
	SetPlayerInterior(playerid,interior);
	SetPlayerVirtualWorld(playerid,world);
	return 1;
}

stock Mesaj(playerid, const yazi[],{Float,_}:...)
{
	new str[256];
	new
		iArgs = numargs()
	;
	while (--iArgs) {
		format(str,sizeof(str),"{FF4500}ç EV: {FFFFFF}%s",yazi,iArgs);
		SendClientMessage(playerid,-1,str);
	}
	return -1;
}

// - Oyuncu idi fonksiyonu
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
*/

// - Oyuncu adç fonksiyonu
stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	return pname;
}

// - Silah adlarç
stock WeaponName(weaponid)
{
	new wname[32];
	GetWeaponName(weaponid, wname, sizeof(wname));
	return wname;
}

// - Yasak skinler
stock IsValidSkin(iSkin)
{
	switch (iSkin)
	{
		case 3, 4, 5, 6, 8, 42, 53, 65, 74, 86, 91, 119, 149, 208, 273, 289:
			return 0;
	}
	return 1;
}

// - DeletePlayerWeapon Fonksiyonu
stock DeletePlayerWeapon(playerid, weaponid)
{
	new
		gWeaponData[13][2]
	;

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


// == (( Extra Public Unit )) =============================================== //
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
		 if (PlayerAccount[playerid][pA_Radiation] > 0 && PlayerAccount[playerid][pA_Radiation] < 40)
			format(radiationText, sizeof(radiationText), "RADIATION: ~g~~h~%d", PlayerAccount[playerid][pA_Radiation]);
		 else if (PlayerAccount[playerid][pA_Radiation] >= 40 && PlayerAccount[playerid][pA_Radiation] < 90)
			format(radiationText, sizeof(radiationText), "RADIATION: ~y~%d", PlayerAccount[playerid][pA_Radiation]);
		 else if (PlayerAccount[playerid][pA_Radiation] >= 90)
			format(radiationText, sizeof(radiationText), "RADIATION: ~r~~h~%d", PlayerAccount[playerid][pA_Radiation]);
		TextDrawSetString(textdraw_radiation[playerid], radiationText);
	}

	new pingText[64];
	if (GetPlayerPing(playerid) >= 0 && GetPlayerPing(playerid) < 80)
		format(pingText, sizeof(pingText), "PING: ~g~~h~%d", GetPlayerPing(playerid));
	else if (GetPlayerPing(playerid) >= 80 && GetPlayerPing(playerid) < 200)
		format(pingText, sizeof(pingText), "PING: ~y~%d", GetPlayerPing(playerid));
	else if (GetPlayerPing(playerid) >= 200)
		format(pingText, sizeof(pingText), "PING: ~r~~h~%d", GetPlayerPing(playerid));

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

stock pName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
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
	PlayerAccount[playerid][pA_Pass] 		= -1;
	PlayerAccount[playerid][pA_AdminLevel]  = -1;
	PlayerAccount[playerid][pA_Killed]      = -1;
	PlayerAccount[playerid][pA_Death]       = -1;
	PlayerAccount[playerid][pA_Score]       = -1;
	PlayerAccount[playerid][pA_Money]       = -1;
	 PlayerAccount[playerid][pA_Radiation]   = -1;
	PlayerAccount[playerid][pA_Hungry]      = -1;
	PlayerAccount[playerid][pA_Comfort]     = -1;
	PlayerAccount[playerid][pA_X]           = -1;
	PlayerAccount[playerid][pA_Y]           = -1;
	PlayerAccount[playerid][pA_Z]           = -1;
	PlayerAccount[playerid][pA_Interior]    = -1;
	PlayerAccount[playerid][pA_IP]          = -1;
	PlayerAccount[playerid][pA_Online]      = -1;
	PlayerAccount[playerid][pA_LastOnline]  = -1;
}

// ========================================================================== //

stock LoadTextDraws(playerid)
{
	textdraw_hungry[playerid] = TextDrawCreate(635.000000, 425.000000, "HUNGER: ~g~~h~LOW");
	TextDrawAlignment(textdraw_hungry[playerid], 3);
	TextDrawBackgroundColor(textdraw_hungry[playerid], 255);
	TextDrawFont(textdraw_hungry[playerid], 2);
	TextDrawLetterSize(textdraw_hungry[playerid], 0.300000, 1.000000);
	TextDrawColor(textdraw_hungry[playerid], 1717987071);
	TextDrawSetOutline(textdraw_hungry[playerid], 1);
	TextDrawSetProportional(textdraw_hungry[playerid], 1);

	textdraw_radiation[playerid] = TextDrawCreate(635.000000, 435.000000, "RADIATION: ~w~~h~NONE");
	TextDrawAlignment(textdraw_radiation[playerid], 3);
	TextDrawBackgroundColor(textdraw_radiation[playerid], 255);
	TextDrawFont(textdraw_radiation[playerid], 2);
	TextDrawLetterSize(textdraw_radiation[playerid], 0.300000, 1.000000);
	TextDrawColor(textdraw_radiation[playerid], 1717987071);
	TextDrawSetOutline(textdraw_radiation[playerid], 1);
	TextDrawSetProportional(textdraw_radiation[playerid], 1);

	textdraw_ping[playerid] = TextDrawCreate(635.000000, 415.000000, "PING: ~g~~h~0");
	TextDrawAlignment(textdraw_ping[playerid], 3);
	TextDrawBackgroundColor(textdraw_ping[playerid], 255);
	TextDrawFont(textdraw_ping[playerid], 2);
	TextDrawLetterSize(textdraw_ping[playerid], 0.300000, 1.000000);
	TextDrawColor(textdraw_ping[playerid], 1717987071);
	TextDrawSetOutline(textdraw_ping[playerid], 1);
	TextDrawSetProportional(textdraw_ping[playerid], 1);

	textdraw_key1[playerid] = TextDrawCreate(635.000000, 285.000000, "Y = ~p~PICK GUN");
	TextDrawAlignment(textdraw_key1[playerid], 3);
	TextDrawBackgroundColor(textdraw_key1[playerid], 255);
	TextDrawFont(textdraw_key1[playerid], 2);
	TextDrawLetterSize(textdraw_key1[playerid], 0.300000, 1.000000);
	TextDrawColor(textdraw_key1[playerid], 1717987071);
	TextDrawSetOutline(textdraw_key1[playerid], 1);
	TextDrawSetProportional(textdraw_key1[playerid], 1);

	textdraw_key2[playerid] = TextDrawCreate(635.000000, 295.000000, "N = ~p~DROP GUN");
	TextDrawAlignment(textdraw_key2[playerid], 3);
	TextDrawBackgroundColor(textdraw_key2[playerid], 255);
	TextDrawFont(textdraw_key2[playerid], 2);
	TextDrawLetterSize(textdraw_key2[playerid], 0.300000, 1.000000);
	TextDrawColor(textdraw_key2[playerid], 1717987071);
	TextDrawSetOutline(textdraw_key2[playerid], 1);
	TextDrawSetProportional(textdraw_key2[playerid], 1);

	textdraw_key3[playerid] = TextDrawCreate(635.000000, 305.000000, "H = ~p~OPEN INVENTORY");
	TextDrawAlignment(textdraw_key3[playerid], 3);
	TextDrawBackgroundColor(textdraw_key3[playerid], 255);
	TextDrawFont(textdraw_key3[playerid], 2);
	TextDrawLetterSize(textdraw_key3[playerid], 0.300000, 1.000000);
	TextDrawColor(textdraw_key3[playerid], 1717987071);
	TextDrawSetOutline(textdraw_key3[playerid], 1);
	TextDrawSetProportional(textdraw_key3[playerid], 1);
}

stock UnloadTextDraws(playerid)
{
	TextDrawDestroy(textdraw_hungry[playerid]);
	TextDrawDestroy(textdraw_radiation[playerid]);
	TextDrawDestroy(textdraw_ping[playerid]);
	TextDrawDestroy(textdraw_key1[playerid]);
	TextDrawDestroy(textdraw_key2[playerid]);
	TextDrawDestroy(textdraw_key3[playerid]);
}

stock LoadObjects()
{
	// Genel Objeler
	CreateObject(18761,2046.10,869.12,9.94,0.00,0.00,0.00);
	CreateObject(18768,2003.50,1007.70,37.50,0.00,0.00,0.00);
	CreateObject(18720,2620.90,1827.60,17.82,0.00,0.00,0.00);
	CreateObject(18769,2003.52,1007.75,37.49,0.00,0.00,0.00);
	CreateObject(18720,2620.87,1821.17,17.72,0.00,0.00,0.00);

	//4 Mayıs 2013 - Crosscuk Petrol Damıtma Sahası Edit
	CreateDynamicObject(18763,410.99,1432.73,6.45,0.00,0.00,135.00);
	CreateDynamicObject(18763,407.29,1428.01,6.57,0.00,0.00,0.00);
	CreateDynamicObject(18741,286.16,1373.64,7.98,0.00,0.00,0.00);
	CreateDynamicObject(18741,286.18,1373.64,7.98,0.00,0.00,0.00);
	CreateDynamicObject(7662,147.96,1363.10,10.28,0.00,0.00,0.00);
	CreateDynamicObject(7611,218.79,1357.26,11.98,0.00,0.00,180.00);
	CreateDynamicObject(6522,236.90,1451.05,17.88,0.00,0.00,270.00);
	CreateDynamicObject(7597,236.38,1420.27,22.75,0.00,0.00,0.00);
	CreateDynamicObject(19486,250.19,1347.60,12.18,0.00,0.00,0.00);
	CreateDynamicObject(1419,286.69,1358.56,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,282.63,1358.48,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,278.58,1358.53,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,274.58,1358.56,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,270.52,1358.49,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,266.43,1358.45,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,262.36,1358.49,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,258.26,1358.50,10.27,0.00,0.00,180.00);
	CreateDynamicObject(1419,254.15,1358.55,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,250.07,1358.50,10.27,0.00,0.00,180.00);
	CreateDynamicObject(1419,244.46,1358.46,10.28,0.00,0.00,360.00);
	CreateDynamicObject(1419,246.15,1358.50,10.28,0.00,0.00,540.00);
	CreateDynamicObject(1419,232.98,1358.53,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,228.90,1358.49,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,224.78,1358.51,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,220.67,1358.47,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,216.56,1358.48,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,212.49,1358.44,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,208.41,1358.45,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,204.34,1358.47,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,200.27,1358.50,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,196.21,1358.47,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,192.18,1358.44,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,188.05,1358.45,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,183.97,1358.51,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,179.94,1358.55,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,175.85,1358.49,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,171.79,1358.51,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,167.71,1358.54,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,163.60,1358.47,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,159.49,1358.43,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,151.35,1358.50,10.28,0.00,0.00,540.00);
	CreateDynamicObject(1419,155.41,1358.51,10.28,0.00,0.00,180.00);
	CreateDynamicObject(1419,149.28,1358.50,10.28,0.00,0.00,180.00);
	CreateDynamicObject(19499,134.35,1379.38,13.08,0.00,0.00,450.00);
	CreateDynamicObject(7662,147.98,1406.06,10.28,0.00,0.00,0.00);
	CreateDynamicObject(11490,138.82,1422.60,9.49,0.00,0.00,270.00);
	CreateDynamicObject(11491,127.75,1422.59,10.99,0.00,0.00,270.00);
	CreateDynamicObject(1492,137.51,1375.16,9.65,0.00,0.00,990.00);


	// RequestClass Alanı
	CreateObject(18783,2625.20,1824.18,7.62,0.00,0.00,0.00);
	CreateObject(18783,2634.38,1824.18,10.12,810.00,270.00,360.00);

	// Deagle DM
	CreateDynamicObject(19456,2428.54,1806.78,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2423.61,1811.56,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2432.81,1792.28,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2433.33,1801.98,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2437.56,1806.99,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2442.38,1807.15,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2447.07,1802.34,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2437.50,1797.09,16.32,0.00,0.00,270.00);
	CreateDynamicObject(19456,2427.99,1797.06,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2423.28,1801.97,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2418.85,1806.87,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2425.07,1793.39,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2420.34,1788.58,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2417.91,1793.35,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2421.23,1829.95,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2425.81,1818.59,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2416.07,1811.48,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2414.02,1798.44,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2409.31,1803.31,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2413.99,1797.41,16.32,0.00,0.00,0.00);
	CreateDynamicObject(19456,2409.51,1818.50,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2416.53,1825.18,16.32,0.00,0.00,90.00);
	CreateDynamicObject(19456,2412.11,1825.18,16.32,0.00,0.00,90.00);
	CreateDynamicObject(18666,2425.52,1818.72,16.72,0.00,0.00,270.00);
	CreateDynamicObject(18667,2417.45,1811.64,16.72,0.00,0.00,270.00);
	CreateDynamicObject(18648,2424.95,1825.24,13.32,0.00,0.00,0.00);
	CreateDynamicObject(18649,2440.09,1794.81,14.42,0.00,0.00,0.00);
	CreateDynamicObject(18661,2428.66,1809.11,16.82,0.00,0.00,180.00);
	CreateDynamicObject(1226,2428.16,1815.07,17.32,0.00,0.00,0.00);
	CreateDynamicObject(1225,2423.87,1797.63,15.72,0.00,0.00,0.00);
	CreateDynamicObject(1227,2427.15,1810.65,16.12,0.00,0.00,0.00);
	CreateDynamicObject(1230,2425.61,1811.07,15.72,0.00,0.00,0.00);
	CreateDynamicObject(1225,2427.78,1812.30,15.72,0.00,0.00,0.00);
	CreateDynamicObject(1685,2408.06,1819.52,15.82,0.00,0.00,0.00);
	CreateDynamicObject(3111,2423.38,1803.06,16.72,90.00,450.00,360.00);

	// Fist DM
	CreateDynamicObject(18759,2170.38,2539.66,584.77,0.00,0.00,0.00);

	// Bikepark Stunt - 1
	CreateDynamicObject(18800,1128.10,1265.82,20.82,0.00,0.00,180.00);
	CreateDynamicObject(18800,1181.26,1266.05,44.37,0.00,0.00,0.00);
	CreateDynamicObject(18786,1141.64,1243.53,59.24,0.00,0.00,0.00);
	CreateDynamicObject(18780,1165.49,1236.86,21.42,0.00,0.00,270.00);
	CreateDynamicObject(18772,1164.82,1067.94,68.35,0.00,0.00,0.00);
	CreateDynamicObject(18772,1164.82,817.94,68.34,0.00,0.00,0.00);
	CreateDynamicObject(18781,1165.13,672.58,76.65,0.00,0.00,180.00);
	CreateDynamicObject(18779,1118.13,1338.01,19.72,0.00,0.00,0.00);
	CreateDynamicObject(18790,1052.97,1343.98,57.75,0.00,60.00,0.00);

	// Ebenin amı
	CreateDynamicObject(19494,2105.84,1292.90,798.96,0.00,0.00,0.00);
	CreateDynamicObject(19325,2111.45,1293.34,798.31,0.00,0.00,0.00);
	CreateDynamicObject(19325,2103.86,1296.18,797.21,0.00,0.00,0.00);

	// OrmanEvi
	AddStaticVehicleEx(453,-1472.5999800,-2122.8999000,0.0000000,310.0000000,29,59,15); //Reefer
	AddStaticVehicleEx(542,-1636.0000000,-2251.3000500,31.3000000,92.0000000,95,39,15); //Clover
	CreateDynamicObject(1232,-1645.1999500,-2260.1001000,34.1000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (1)
	CreateDynamicObject(1232,-1645.5000000,-2226.1999500,32.2000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (2)
	CreateDynamicObject(1232,-1641.5000000,-2201.1999500,34.3000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (3)
	CreateDynamicObject(1232,-1621.0000000,-2190.6999500,28.8000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (4)
	CreateDynamicObject(1232,-1601.9000200,-2185.1999500,23.8000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (5)
	CreateDynamicObject(1232,-1575.5999800,-2179.3000500,16.7000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (6)
	CreateDynamicObject(1232,-1551.5999800,-2175.5000000,10.7000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (7)
	CreateDynamicObject(1232,-1527.8000500,-2169.6001000,5.0000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (8)
	CreateDynamicObject(1232,-1511.6999500,-2164.3000500,2.9000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (9)
	CreateDynamicObject(1799,-1629.8000500,-2244.3000500,30.6000000,0.0000000,0.0000000,184.0000000); //object(med_bed_4) (1)
	CreateDynamicObject(13758,-1609.1999500,-2247.3000500,45.1000000,0.0000000,0.0000000,0.0000000); //object(radarmast1_lawn01) (1)
	CreateDynamicObject(2296,-1634.5000000,-2232.3999000,30.5000000,0.0000000,0.0000000,0.0000000); //object(tv_unit_1) (1)
	CreateDynamicObject(1432,-1635.5999800,-2242.5000000,30.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_table_2) (1)
	CreateDynamicObject(1768,-1632.1999500,-2235.5000000,30.5000000,0.0000000,0.0000000,182.0000000); //object(low_couch_3) (1)
	CreateDynamicObject(15036,-1635.4000200,-2246.6001000,31.6000000,0.0000000,0.0000000,2.0000000); //object(kit_cab_washin_sv) (1)
	CreateDynamicObject(2261,-1637.4000200,-2232.8000500,31.9000000,0.0000000,0.0000000,0.0000000); //object(frame_slim_2) (1)
	CreateDynamicObject(2282,-1628.9000200,-2242.6999500,32.1000000,0.0000000,0.0000000,270.0000000); //object(frame_thick_4) (1)
	CreateDynamicObject(2108,-1630.1999500,-2232.5000000,30.5000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (1)
	CreateDynamicObject(2080,-1634.0000000,-2234.1001000,30.5000000,0.0000000,0.0000000,0.0000000); //object(swank_dinning_2) (1)
	CreateDynamicObject(2108,-1636.5000000,-2232.8999000,30.5000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (2)
	CreateDynamicObject(1502,-1638.0999800,-2238.5000000,30.5000000,0.0000000,0.0000000,271.0000000); //object(gen_doorint04) (1)
	CreateDynamicObject(11631,-1629.1999500,-2238.6001000,31.7000000,0.0000000,0.0000000,271.0000000); //object(ranch_desk) (1)
	CreateDynamicObject(1811,-1630.1999500,-2238.8000500,31.1000000,0.0000000,0.0000000,210.0000000); //object(med_din_chair_5) (1)
	CreateDynamicObject(1738,-1631.9000200,-2247.8000500,31.1000000,0.0000000,0.0000000,0.0000000); //object(cj_radiator_old) (1)
	CreateDynamicObject(1551,-1633.3000500,-2234.3000500,31.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_big) (1)
	CreateDynamicObject(1551,-1633.5999800,-2234.1999500,31.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_big) (2)
	CreateDynamicObject(1736,-1637.5000000,-2241.6001000,32.6000000,0.0000000,0.0000000,92.5000000); //object(cj_stags_head) (1)
	CreateDynamicObject(2099,-1628.4000200,-2242.5000000,30.5000000,0.0000000,0.0000000,272.0000000); //object(med_hi_fi_1) (1)
	CreateDynamicObject(2819,-1629.5000000,-2245.1999500,30.5000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes01) (1)

	// Köy Çete Mekanı - 11/04/2013
	AddStaticVehicleEx(518,1566.0999800,30.9000000,24.0000000,95.0000000,-1,-1,15); //Buccaneer
	AddStaticVehicleEx(463,1562.8000500,25.3000000,23.8000000,0.0000000,159,157,15); //Freeway
	AddStaticVehicleEx(463,1563.0000000,22.4000000,23.8000000,0.0000000,159,157,15); //Freeway
	AddStaticVehicleEx(463,1563.0000000,19.4000000,23.8000000,0.0000000,37,37,15); //Freeway
	AddStaticVehicleEx(463,1562.0000000,23.9000000,23.8000000,0.0000000,22,34,15); //Freeway
	AddStaticVehicleEx(463,1562.0000000,20.5000000,23.8000000,0.0000000,22,34,15); //Freeway
	CreateDynamicObject(1649,1549.5999800,19.7000000,24.8000000,0.0000000,90.0000000,100.0000000); //object(wglasssmash) (1)
	CreateDynamicObject(1649,1550.4000200,15.0000000,24.8000000,0.0000000,90.0000000,100.0000000); //object(wglasssmash) (2)
	CreateDynamicObject(1494,1549.9000200,18.1000000,23.1000000,0.0000000,0.0000000,280.0000000); //object(gen_doorint03) (1)
	CreateDynamicObject(1649,1550.4000200,15.0000000,24.8000000,0.0000000,90.0000000,279.9970000); //object(wglasssmash) (3)
	CreateDynamicObject(1649,1549.5999800,19.7000000,24.8000000,0.0000000,90.0000000,279.9920000); //object(wglasssmash) (5)
	CreateDynamicObject(1649,1550.0000000,17.5000000,27.8100000,0.0000000,90.0000000,99.9970000); //object(wglasssmash) (6)
	CreateDynamicObject(1649,1550.0000000,17.5000000,27.8100000,0.0000000,90.0000000,279.9980000); //object(wglasssmash) (7)
	CreateDynamicObject(1494,1537.8000500,18.1000000,23.1000000,0.0000000,0.0000000,279.9980000); //object(gen_doorint03) (2)
	CreateDynamicObject(1494,1545.4000200,22.4000000,23.1000000,0.0000000,0.0000000,189.9980000); //object(gen_doorint03) (3)
	CreateDynamicObject(1494,1543.1999500,10.8000000,23.1000000,0.0000000,0.0000000,189.9980000); //object(gen_doorint03) (4)
	CreateDynamicObject(2315,1545.5999800,12.1000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(cj_tv_table4) (1)
	CreateDynamicObject(2595,1546.0000000,12.2000000,24.0000000,0.0000000,0.0000000,130.0000000); //object(cj_shop_tv_video) (1)
	CreateDynamicObject(2827,1546.9000200,12.3000000,23.6000000,0.0000000,0.0000000,0.0000000); //object(gb_novels05) (1)
	CreateDynamicObject(1768,1544.5000000,14.0000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(low_couch_3) (1)
	CreateDynamicObject(1594,1551.3000500,21.9000000,23.6000000,0.0000000,0.0000000,322.0000000); //object(chairsntable) (1)
	CreateDynamicObject(1801,1538.6999500,17.3000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(swank_bed_4) (1)
	CreateDynamicObject(1801,1541.0999800,17.8000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(swank_bed_4) (2)
	CreateDynamicObject(2101,1544.6999500,12.0000000,23.1000000,0.0000000,0.0000000,180.0000000); //object(med_hi_fi_3) (1)
	CreateDynamicObject(2101,1544.0000000,12.0000000,23.1000000,0.0000000,0.0000000,129.9950000); //object(med_hi_fi_3) (2)
	CreateDynamicObject(1829,1539.5999800,13.2000000,23.6000000,0.0000000,0.0000000,100.0000000); //object(man_safenew) (1)
	CreateDynamicObject(876,1519.9000200,46.9000000,26.4000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (2)
	CreateDynamicObject(876,1529.1999500,64.2000000,27.9000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (4)
	CreateDynamicObject(876,1521.5999800,82.4000000,29.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (6)
	CreateDynamicObject(876,1555.9000200,77.0000000,28.5000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (8)
	CreateDynamicObject(1362,1566.4000200,17.5000000,23.8000000,0.0000000,0.0000000,0.0000000); //object(cj_firebin) (1)
	CreateDynamicObject(3461,1566.4000200,17.5000000,22.6000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (1)

	   // - LVDM arabaları
	AddStaticVehicle(451,2040.0520,1319.2799,10.3779,183.2439,16,16);
	AddStaticVehicle(429,2040.5247,1359.2783,10.3516,177.1306,13,13);
	AddStaticVehicle(421,2110.4102,1398.3672,10.7552,359.5964,13,13);
	AddStaticVehicle(411,2074.9624,1479.2120,10.3990,359.6861,64,64);
	AddStaticVehicle(477,2075.6038,1666.9750,10.4252,359.7507,94,94);
	AddStaticVehicle(541,2119.5845,1938.5969,10.2967,181.9064,22,22);
	AddStaticVehicle(541,1843.7881,1216.0122,10.4556,270.8793,60,1);
	AddStaticVehicle(402,1944.1003,1344.7717,8.9411,0.8168,30,30);
	AddStaticVehicle(402,1679.2278,1316.6287,10.6520,180.4150,90,90);
	AddStaticVehicle(415,1685.4872,1751.9667,10.5990,268.1183,25,1);
	AddStaticVehicle(411,2034.5016,1912.5874,11.9048,0.2909,123,1);
	AddStaticVehicle(411,2172.1682,1988.8643,10.5474,89.9151,116,1);
	AddStaticVehicle(429,2245.5759,2042.4166,10.5000,270.7350,14,14);
	AddStaticVehicle(477,2361.1538,1993.9761,10.4260,178.3929,101,1);
	AddStaticVehicle(550,2221.9946,1998.7787,9.6815,92.6188,53,53);
	AddStaticVehicle(558,2243.3833,1952.4221,14.9761,359.4796,116,1);
	AddStaticVehicle(587,2276.7085,1938.7263,31.5046,359.2321,40,1);
	AddStaticVehicle(587,2602.7769,1853.0667,10.5468,91.4813,43,1);
	AddStaticVehicle(603,2610.7600,1694.2588,10.6585,89.3303,69,1);
	AddStaticVehicle(587,2635.2419,1075.7726,10.5472,89.9571,53,1);
	AddStaticVehicle(437,2577.2354,1038.8063,10.4777,181.7069,35,1);
	AddStaticVehicle(535,2039.1257,1545.0879,10.3481,359.6690,123,1);
	AddStaticVehicle(535,2009.8782,2411.7524,10.5828,178.9618,66,1);
	AddStaticVehicle(429,2010.0841,2489.5510,10.5003,268.7720,1,2);
	AddStaticVehicle(415,2076.4033,2468.7947,10.5923,359.9186,36,1);
	AddStaticVehicle(487,2093.2754,2414.9421,74.7556,89.0247,26,57);
	AddStaticVehicle(506,2352.9026,2577.9768,10.5201,0.4091,7,7);
	AddStaticVehicle(506,2166.6963,2741.0413,10.5245,89.7816,52,52);
	AddStaticVehicle(411,1960.9989,2754.9072,10.5473,200.4316,112,1);
	AddStaticVehicle(429,1919.5863,2760.7595,10.5079,100.0753,2,1);
	AddStaticVehicle(415,1673.8038,2693.8044,10.5912,359.7903,40,1);
	AddStaticVehicle(402,1591.0482,2746.3982,10.6519,172.5125,30,30);
	AddStaticVehicle(603,1580.4537,2838.2886,10.6614,181.4573,75,77);
	AddStaticVehicle(550,1555.2734,2750.5261,10.6388,91.7773,62,62);
	AddStaticVehicle(535,1455.9305,2878.5288,10.5837,181.0987,118,1);
	AddStaticVehicle(477,1537.8425,2578.0525,10.5662,0.0650,121,1);
	AddStaticVehicle(451,1433.1594,2607.3762,10.3781,88.0013,16,16);
	AddStaticVehicle(603,2223.5898,1288.1464,10.5104,182.0297,18,1);
	AddStaticVehicle(558,2451.6707,1207.1179,10.4510,179.8960,24,1);
	AddStaticVehicle(550,2461.7253,1357.9705,10.6389,180.2927,62,62);
	AddStaticVehicle(558,2461.8162,1629.2268,10.4496,181.4625,117,1);
	AddStaticVehicle(477,2395.7554,1658.9591,10.5740,359.7374,0,1);
	AddStaticVehicle(404,1553.3696,1020.2884,10.5532,270.6825,119,50);
	AddStaticVehicle(400,1380.8304,1159.1782,10.9128,355.7117,123,1);
	AddStaticVehicle(418,1383.4630,1035.0420,10.9131,91.2515,117,227);
	AddStaticVehicle(404,1445.4526,974.2831,10.5534,1.6213,109,100);
	AddStaticVehicle(400,1704.2365,940.1490,10.9127,91.9048,113,1);
	AddStaticVehicle(404,1658.5463,1028.5432,10.5533,359.8419,101,101);
	AddStaticVehicle(581,1677.6628,1040.1930,10.4136,178.7038,58,1);
	AddStaticVehicle(581,1383.6959,1042.2114,10.4121,85.7269,66,1);
	AddStaticVehicle(581,1064.2332,1215.4158,10.4157,177.2942,72,1);
	AddStaticVehicle(581,1111.4536,1788.3893,10.4158,92.4627,72,1);
	AddStaticVehicle(522,953.2818,1806.1392,8.2188,235.0706,3,8);
	AddStaticVehicle(522,995.5328,1886.6055,10.5359,90.1048,3,8);
	AddStaticVehicle(521,993.7083,2267.4133,11.0315,1.5610,75,13);
	AddStaticVehicle(535,1439.5662,1999.9822,10.5843,0.4194,66,1);
	AddStaticVehicle(522,1430.2354,1999.0144,10.3896,352.0951,6,25);
	AddStaticVehicle(522,2156.3540,2188.6572,10.2414,22.6504,6,25);
	AddStaticVehicle(598,2277.6846,2477.1096,10.5652,180.1090,0,1);
	AddStaticVehicle(598,2268.9888,2443.1697,10.5662,181.8062,0,1);
	AddStaticVehicle(598,2256.2891,2458.5110,10.5680,358.7335,0,1);
	AddStaticVehicle(598,2251.6921,2477.0205,10.5671,179.5244,0,1);
	AddStaticVehicle(523,2294.7305,2441.2651,10.3860,9.3764,0,0);
	AddStaticVehicle(523,2290.7268,2441.3323,10.3944,16.4594,0,0);
	AddStaticVehicle(523,2295.5503,2455.9656,2.8444,272.6913,0,0);
	AddStaticVehicle(522,2476.7900,2532.2222,21.4416,0.5081,8,82);
	AddStaticVehicle(522,2580.5320,2267.9595,10.3917,271.2372,8,82);
	AddStaticVehicle(522,2814.4331,2364.6641,10.3907,89.6752,36,105);
	AddStaticVehicle(535,2827.4143,2345.6953,10.5768,270.0668,97,1);
	AddStaticVehicle(521,1670.1089,1297.8322,10.3864,359.4936,87,118);
	AddStaticVehicle(487,1614.7153,1548.7513,11.2749,347.1516,58,8);
	AddStaticVehicle(487,1647.7902,1538.9934,11.2433,51.8071,0,8);
	AddStaticVehicle(487,1608.3851,1630.7268,11.2840,174.5517,58,8);
	AddStaticVehicle(476,1283.0006,1324.8849,9.5332,275.0468,7,6);
	AddStaticVehicle(476,1283.5107,1361.3171,9.5382,271.1684,1,6);
	AddStaticVehicle(476,1283.6847,1386.5137,11.5300,272.1003,89,91);
	AddStaticVehicle(476,1288.0499,1403.6605,11.5295,243.5028,119,117);
	AddStaticVehicle(415,1319.1038,1279.1791,10.5931,0.9661,62,1);
	AddStaticVehicle(521,1710.5763,1805.9275,10.3911,176.5028,92,3);
	AddStaticVehicle(521,2805.1650,2027.0028,10.3920,357.5978,92,3);
	AddStaticVehicle(535,2822.3628,2240.3594,10.5812,89.7540,123,1);
	AddStaticVehicle(521,2876.8013,2326.8418,10.3914,267.8946,115,118);
	AddStaticVehicle(429,2842.0554,2637.0105,10.5000,182.2949,1,3);
	AddStaticVehicle(549,2494.4214,2813.9348,10.5172,316.9462,72,39);
	AddStaticVehicle(549,2327.6484,2787.7327,10.5174,179.5639,75,39);
	AddStaticVehicle(549,2142.6970,2806.6758,10.5176,89.8970,79,39);
	AddStaticVehicle(521,2139.7012,2799.2114,10.3917,229.6327,25,118);
	AddStaticVehicle(521,2104.9446,2658.1331,10.3834,82.2700,36,0);
	AddStaticVehicle(521,1914.2322,2148.2590,10.3906,267.7297,36,0);
	AddStaticVehicle(549,1904.7527,2157.4312,10.5175,183.7728,83,36);
	AddStaticVehicle(549,1532.6139,2258.0173,10.5176,359.1516,84,36);
	AddStaticVehicle(521,1534.3204,2202.8970,10.3644,4.9108,118,118);
	AddStaticVehicle(549,1613.1553,2200.2664,10.5176,89.6204,89,35);
	AddStaticVehicle(400,1552.1292,2341.7854,10.9126,274.0815,101,1);
	AddStaticVehicle(404,1637.6285,2329.8774,10.5538,89.6408,101,101);
	AddStaticVehicle(400,1357.4165,2259.7158,10.9126,269.5567,62,1);
	AddStaticVehicle(411,1281.7458,2571.6719,10.5472,270.6128,106,1);
	AddStaticVehicle(522,1305.5295,2528.3076,10.3955,88.7249,3,8);
	AddStaticVehicle(521,993.9020,2159.4194,10.3905,88.8805,74,74);
	AddStaticVehicle(415,1512.7134,787.6931,10.5921,359.5796,75,1);
	AddStaticVehicle(522,2299.5872,1469.7910,10.3815,258.4984,3,8);
	AddStaticVehicle(522,2133.6428,1012.8537,10.3789,87.1290,3,8);

	AddStaticVehicle(415,2266.7336,648.4756,11.0053,177.8517,0,1); //
	AddStaticVehicle(461,2404.6636,647.9255,10.7919,183.7688,53,1); //
	AddStaticVehicle(506,2628.1047,746.8704,10.5246,352.7574,3,3); //
	AddStaticVehicle(549,2817.6445,928.3469,10.4470,359.5235,72,39); //
	AddStaticVehicle(562,1919.8829,947.1886,10.4715,359.4453,11,1); //
	AddStaticVehicle(562,1881.6346,1006.7653,10.4783,86.9967,11,1); //
	AddStaticVehicle(562,2038.1044,1006.4022,10.4040,179.2641,11,1); //
	AddStaticVehicle(562,2038.1614,1014.8566,10.4057,179.8665,11,1); //
	AddStaticVehicle(562,2038.0966,1026.7987,10.4040,180.6107,11,1); //

	AddStaticVehicle(422,9.1065,1165.5066,19.5855,2.1281,101,25); //
	AddStaticVehicle(463,19.8059,1163.7103,19.1504,346.3326,11,11); //
	AddStaticVehicle(463,12.5740,1232.2848,18.8822,121.8670,22,22); //
	AddStaticVehicle(586,69.4633,1217.0189,18.3304,158.9345,10,1); //
	AddStaticVehicle(586,-199.4185,1223.0405,19.2624,176.7001,25,1); //
	AddStaticVehicle(476,325.4121,2538.5999,17.5184,181.2964,71,77); //
	AddStaticVehicle(476,291.0975,2540.0410,17.5276,182.7206,7,6); //
	AddStaticVehicle(576,384.2365,2602.1763,16.0926,192.4858,72,1); //
	AddStaticVehicle(586,423.8012,2541.6870,15.9708,338.2426,10,1); //
	AddStaticVehicle(586,-244.0047,2724.5439,62.2077,51.5825,10,1); //
	AddStaticVehicle(586,-311.1414,2659.4329,62.4513,310.9601,27,1); //

	AddStaticVehicle(543,596.8064,866.2578,-43.2617,186.8359,67,8); //
	AddStaticVehicle(543,835.0838,836.8370,11.8739,14.8920,8,90); //
	AddStaticVehicle(549,843.1893,838.8093,12.5177,18.2348,79,39); //
	AddStaticVehicle(400,-235.9767,1045.8623,19.8158,180.0806,75,1); //
	AddStaticVehicle(599,-211.5940,998.9857,19.8437,265.4935,0,1); //
	AddStaticVehicle(422,-304.0620,1024.1111,19.5714,94.1812,96,25); //
	AddStaticVehicle(588,-290.2229,1317.0276,54.1871,81.7529,1,1); //
	AddStaticVehicle(451,-290.3145,1567.1534,75.0654,133.1694,61,61); //
	AddStaticVehicle(470,280.4914,1945.6143,17.6317,310.3278,43,0); //
	AddStaticVehicle(470,272.2862,1949.4713,17.6367,285.9714,43,0); //
	AddStaticVehicle(470,271.6122,1961.2386,17.6373,251.9081,43,0); //
	AddStaticVehicle(470,279.8705,1966.2362,17.6436,228.4709,43,0); //
	AddStaticVehicle(433,277.6437,1985.7559,18.0772,270.4079,43,0); //
	AddStaticVehicle(433,277.4477,1994.8329,18.0773,267.7378,43,0); //
	AddStaticVehicle(568,-441.3438,2215.7026,42.2489,191.7953,41,29); //
	AddStaticVehicle(568,-422.2956,2225.2612,42.2465,0.0616,41,29); //
	AddStaticVehicle(568,-371.7973,2234.5527,42.3497,285.9481,41,29); //
	AddStaticVehicle(568,-360.1159,2203.4272,42.3039,113.6446,41,29); //
	AddStaticVehicle(468,-660.7385,2315.2642,138.3866,358.7643,6,6); //
	AddStaticVehicle(460,-1029.2648,2237.2217,42.2679,260.5732,1,3); //

	AddStaticVehicle(419,95.0568,1056.5530,13.4068,192.1461,13,76); //
	AddStaticVehicle(429,114.7416,1048.3517,13.2890,174.9752,1,2); //
	AddStaticVehicle(411,-290.0065,1759.4958,42.4154,89.7571,116,1); //
	AddStaticVehicle(522,-302.5649,1777.7349,42.2514,238.5039,6,25); //
	AddStaticVehicle(522,-302.9650,1776.1152,42.2588,239.9874,8,82); //
	AddStaticVehicle(533,-301.0404,1750.8517,42.3966,268.7585,75,1); //
	AddStaticVehicle(535,-866.1774,1557.2700,23.8319,269.3263,31,1); //
	AddStaticVehicle(550,-799.3062,1518.1556,26.7488,88.5295,53,53); //
	AddStaticVehicle(521,-749.9730,1589.8435,26.5311,125.6508,92,3); //
	AddStaticVehicle(522,-867.8612,1544.5282,22.5419,296.0923,3,3); //
	AddStaticVehicle(554,-904.2978,1553.8269,25.9229,266.6985,34,30); //
	AddStaticVehicle(521,-944.2642,1424.1603,29.6783,148.5582,92,3); //

	AddStaticVehicle(429,-237.7157,2594.8804,62.3828,178.6802,1,2); //
	AddStaticVehicle(463,-196.3012,2774.4395,61.4775,303.8402,22,22); //
	AddStaticVehicle(519,-1341.1079,-254.3787,15.0701,321.6338,1,1); //
	AddStaticVehicle(519,-1371.1775,-232.3967,15.0676,315.6091,1,1); //
	AddStaticVehicle(519,1642.9850,-2425.2063,14.4744,159.8745,1,1); //
	AddStaticVehicle(519,1734.1311,-2426.7563,14.4734,172.2036,1,1); //

	AddStaticVehicle(415,-680.9882,955.4495,11.9032,84.2754,36,1); //
	AddStaticVehicle(460,-816.3951,2222.7375,43.0045,268.1861,1,3); //
	AddStaticVehicle(460,-94.6885,455.4018,1.5719,250.5473,1,3); //
	AddStaticVehicle(460,1624.5901,565.8568,1.7817,200.5292,1,3); //
	AddStaticVehicle(460,1639.3567,572.2720,1.5311,206.6160,1,3); //
	AddStaticVehicle(460,2293.4219,517.5514,1.7537,270.7889,1,3); //
	AddStaticVehicle(460,2354.4690,518.5284,1.7450,270.2214,1,3); //
	AddStaticVehicle(460,772.4293,2912.5579,1.0753,69.6706,1,3); //

	AddStaticVehicle(560,2133.0769,1019.2366,10.5259,90.5265,9,39); //
	AddStaticVehicle(560,2142.4023,1408.5675,10.5258,0.3660,17,1); //
	AddStaticVehicle(560,2196.3340,1856.8469,10.5257,179.8070,21,1); //
	AddStaticVehicle(560,2103.4146,2069.1514,10.5249,270.1451,33,0); //
	AddStaticVehicle(560,2361.8042,2210.9951,10.3848,178.7366,37,0); //
	AddStaticVehicle(560,-1993.2465,241.5329,34.8774,310.0117,41,29); //
	AddStaticVehicle(559,-1989.3235,270.1447,34.8321,88.6822,58,8); //
	AddStaticVehicle(559,-1946.2416,273.2482,35.1302,126.4200,60,1); //
	AddStaticVehicle(558,-1956.8257,271.4941,35.0984,71.7499,24,1); //
	AddStaticVehicle(562,-1952.8894,258.8604,40.7082,51.7172,17,1); //
	AddStaticVehicle(411,-1949.8689,266.5759,40.7776,216.4882,112,1); //
	AddStaticVehicle(429,-1988.0347,305.4242,34.8553,87.0725,2,1); //
	AddStaticVehicle(559,-1657.6660,1213.6195,6.9062,282.6953,13,8); //
	AddStaticVehicle(560,-1658.3722,1213.2236,13.3806,37.9052,52,39); //
	AddStaticVehicle(558,-1660.8994,1210.7589,20.7875,317.6098,36,1); //
	AddStaticVehicle(550,-1645.2401,1303.9883,6.8482,133.6013,7,7); //
	AddStaticVehicle(460,-1333.1960,903.7660,1.5568,0.5095,46,32); //

	AddStaticVehicle(411,113.8611,1068.6182,13.3395,177.1330,116,1); //
	AddStaticVehicle(429,159.5199,1185.1160,14.7324,85.5769,1,2); //
	AddStaticVehicle(411,612.4678,1694.4126,6.7192,302.5539,75,1); //
	AddStaticVehicle(522,661.7609,1720.9894,6.5641,19.1231,6,25); //
	AddStaticVehicle(522,660.0554,1719.1187,6.5642,12.7699,8,82); //
	AddStaticVehicle(567,711.4207,1947.5208,5.4056,179.3810,90,96); //
	AddStaticVehicle(567,1031.8435,1920.3726,11.3369,89.4978,97,96); //
	AddStaticVehicle(567,1112.3754,1747.8737,10.6923,270.9278,102,114); //
	AddStaticVehicle(567,1641.6802,1299.2113,10.6869,271.4891,97,96); //
	AddStaticVehicle(567,2135.8757,1408.4512,10.6867,180.4562,90,96); //
	AddStaticVehicle(567,2262.2639,1469.2202,14.9177,91.1919,99,81); //
	AddStaticVehicle(567,2461.7380,1345.5385,10.6975,0.9317,114,1); //
	AddStaticVehicle(567,2804.4365,1332.5348,10.6283,271.7682,88,64); //
	AddStaticVehicle(560,2805.1685,1361.4004,10.4548,270.2340,17,1); //
	AddStaticVehicle(506,2853.5378,1361.4677,10.5149,269.6648,7,7); //
	AddStaticVehicle(567,2633.9832,2205.7061,10.6868,180.0076,93,64); //
	AddStaticVehicle(567,2119.9751,2049.3127,10.5423,180.1963,93,64); //
	AddStaticVehicle(567,2785.0261,-1835.0374,9.6874,226.9852,93,64); //
	AddStaticVehicle(567,2787.8975,-1876.2583,9.6966,0.5804,99,81); //
	AddStaticVehicle(411,2771.2993,-1841.5620,9.4870,20.7678,116,1); //
	AddStaticVehicle(420,1713.9319,1467.8354,10.5219,342.8006,6,1); // taxi

	// Los Santos House
	CreateDynamicObject(5706, 399.70001220703, -996.79998779297, 87.5, 0, 0, 0);
	CreateDynamicObject(19442, 406.29998779297, -989, 93, 0, 0, 90);
	CreateDynamicObject(19447, 388.60000610352, -986.90002441406, 92.699996948242, 0, 0, 270);
	CreateDynamicObject(19447, 393.29998779297, -991.70001220703, 92.699996948242, 0, 0, 0);
	CreateDynamicObject(19447, 383.69921875, -991.69921875, 92.699996948242, 0, 0, 0);
	CreateDynamicObject(19449, 388.5, -994.79998779297, 94.5, 0, 90, 270);
	CreateDynamicObject(19449, 388.5, -991.29998779297, 94.5, 0, 90, 270);
	CreateDynamicObject(19449, 388.5, -987.79998779297, 94.5, 0, 90, 270);
	CreateDynamicObject(19397, 407, -992.09997558594, 93, 0, 0, 0);
	CreateDynamicObject(19415, 399.39999389648, -996.90002441406, 93, 0, 0, 0);
	CreateDynamicObject(970, 385.29998779297, -983.70001220703, 91.900001525879, 0, 0, 0);
	CreateDynamicObject(970, 389.39999389648, -983.70001220703, 91.900001525879, 0, 0, 0);
	CreateDynamicObject(970, 393.5, -983.70001220703, 91.900001525879, 0, 0, 0);
	CreateDynamicObject(970, 397.60000610352, -983.70001220703, 91.900001525879, 0, 0, 0);
	CreateDynamicObject(970, 416.20001220703, -1003, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(970, 383.29998779297, -985.70001220703, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(970, 383.29998779297, -989.79998779297, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(970, 383.29998779297, -993.90002441406, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(970, 383.29998779297, -998, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(970, 383.29998779297, -1002.0999755859, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(700, 383.29998779297, -1006.299987793, 91, 0, 0, 0);
	CreateDynamicObject(3499, 384.70001220703, -985.40002441406, 77, 0, 0, 0);
	CreateDynamicObject(3499, 392, -985.09997558594, 77, 0, 0, 0);
	CreateDynamicObject(3499, 400.70001220703, -985.20001220703, 77, 0, 0, 0);
	CreateDynamicObject(762, 386.89999389648, -990.29998779297, 78.400001525879, 0, 0, 0);
	CreateDynamicObject(762, 394.5, -989.79998779297, 78.400001525879, 0, 0, 0);
	CreateDynamicObject(762, 402.79998779297, -987.59997558594, 78.400001525879, 0, 0, 0);
	CreateDynamicObject(19369, 411.89999389648, -1003.4000244141, 93, 0, 0, 90);
	CreateDynamicObject(970, 414.29998779297, -1005.299987793, 91.900001525879, 0, 0, 182);
	CreateDynamicObject(970, 416.20001220703, -998.90002441406, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(970, 416.20001220703, -994.79998779297, 91.900001525879, 0, 0, 270);
	CreateDynamicObject(19369, 402.5, -1003.4000244141, 93, 0, 0, 90);
	CreateDynamicObject(1649, 405.10000610352, -1003.4000244141, 93, 0, 0, 0);
	CreateDynamicObject(19369, 408.70001220703, -1003.4000244141, 93, 0, 0, 90);
	CreateDynamicObject(19462, 411.60000610352, -998.59997558594, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19462, 408.10000610352, -998.599609375, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19462, 404.60000610352, -998.599609375, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19462, 401.10000610352, -998.599609375, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19442, 407.45999145508, -999.5, 93, 0, 0, 0);
	CreateDynamicObject(1649, 399.39999389648, -997, 93, 0, 0, 90);
	CreateDynamicObject(19369, 407, -988.90002441406, 93, 0, 0, 0);
	CreateDynamicObject(1502, 399.39999389648, -1000.8499755859, 91.230003356934, 0, 0, 90);
	CreateDynamicObject(700, 416.20001220703, -1005, 91, 0, 0, 0);
	CreateDynamicObject(1742, 402.29998779297, -987.40002441406, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(1744, 411.39999389648, -993.79998779297, 93.5, 0, 0, 180);
	CreateDynamicObject(2134, 406.39999389648, -985.79998779297, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(2133, 404.39999389648, -984.79998779297, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2341, 406.39999389648, -984.79998779297, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(14535, 410.39999389648, -999.09997558594, 93.400001525879, 0, 0, 0);
	CreateDynamicObject(19369, 407.45999145508, -1001.9000244141, 93, 0, 0, 0);
	CreateDynamicObject(19442, 399.3994140625, -1002.5, 93, 0, 0, 0);
	CreateDynamicObject(19462, 411.599609375, -988.97998046875, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19462, 408.099609375, -988.97998046875, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19462, 404.599609375, -988.97998046875, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(19462, 401.099609375, -988.97998046875, 91.300003051758, 0, 90, 0);
	CreateDynamicObject(2842, 410.79998779297, -1001.9000244141, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2842, 409, -1001.9000244141, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2099, 409, -993.79998779297, 91.400001525879, 0, 0, 180);
	CreateDynamicObject(19369, 411.70001220703, -993.79998779297, 93, 0, 0, 90);
	CreateDynamicObject(19369, 408.5, -993.79998779297, 93, 0, 0, 90);
	CreateDynamicObject(19397, 399.3994140625, -1000.099609375, 93, 0, 0, 0);
	CreateDynamicObject(19369, 401.10000610352, -998.40002441406, 93, 0, 0, 270);
	CreateDynamicObject(19369, 407, -985.70001220703, 93, 0, 0, 0);
	CreateDynamicObject(19461, 413.3994140625, -998.5, 93, 0, 0, 0);
	CreateDynamicObject(19369, 413.39999389648, -988.70001220703, 93, 0, 0, 0);
	CreateDynamicObject(1649, 413.3994140625, -991.7998046875, 93, 0, 0, 90);
	CreateDynamicObject(1649, 404.79998779297, -984.20001220703, 93, 0, 0, 0);
	CreateDynamicObject(3499, 408, -985, 77, 0, 0, 0);
	CreateDynamicObject(3499, 414.70001220703, -985.5, 77, 0, 0, 0);
	CreateDynamicObject(691, 385, -983.70001220703, 72.300003051758, 0, 0, 0);
	CreateDynamicObject(691, 419, -983.79998779297, 72.300003051758, 0, 0, 0);
	CreateDynamicObject(691, 412.5, -978.59997558594, 72.300003051758, 0, 0, 0);
	CreateDynamicObject(19369, 411.89999389648, -984.20001220703, 93, 0, 0, 90);
	CreateDynamicObject(1649, 413.39999389648, -986.40002441406, 93, 0, 0, 90);
	CreateDynamicObject(1745, 409.5, -986, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(2190, 411.5, -993.59997558594, 92.199996948242, 0, 0, 190);
	CreateDynamicObject(2630, 412.89999389648, -989.90002441406, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2173, 411.60000610352, -993.09997558594, 91.400001525879, 0, 0, 180);
	CreateDynamicObject(1671, 411.10000610352, -992.5, 91.800003051758, 0, 0, 0);
	CreateDynamicObject(2593, 412.39999389648, -993.29998779297, 92.199996948242, 0, 0, 0);
	CreateDynamicObject(2652, 413, -993, 91.900001525879, 0, 0, 0);
	CreateDynamicObject(19424, 410.29998779297, -993.20001220703, 92.199996948242, 0, 0, 0);
	CreateDynamicObject(1502, 403.10998535156, -989.02001953125, 91.230003356934, 0, 0, 0);
	CreateDynamicObject(2576, 402.89999389648, -1002.799987793, 91.400001525879, 0, 0, 180);
	CreateDynamicObject(1429, 407.39999389648, -986.5, 92.800003051758, 0, 0, 90);
	CreateDynamicObject(948, 407.60000610352, -989.20001220703, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2010, 407.5, -993.29998779297, 91.300003051758, 0, 0, 0);
	CreateDynamicObject(2240, 407.70001220703, -984.79998779297, 92, 0, 0, 0);
	CreateDynamicObject(2254, 411.89999389648, -984.29998779297, 93.300003051758, 0, 0, 0);
	CreateDynamicObject(2287, 412.79998779297, -988.59997558594, 93.5, 0, 0, 270);
	CreateDynamicObject(2282, 410.60000610352, -993.20001220703, 92.800003051758, 0, 0, 180);
	CreateDynamicObject(2276, 407.58999633789, -990.5, 93, 0, 0, 90);
	CreateDynamicObject(2817, 410.29998779297, -989.5, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2817, 410.29998779297, -990.5, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2817, 410.29998779297, -991.5, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(1649, 409.19921875, -984.19921875, 93, 0, 0, 0);
	CreateDynamicObject(19369, 402.5, -984.20001220703, 93, 0, 0, 90);
	CreateDynamicObject(2515, 405.29998779297, -984.70001220703, 92.559997558594, 0, 0, 0);
	CreateDynamicObject(2517, 405.5, -988, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(2519, 403.20001220703, -984.79998779297, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(2525, 406.39999389648, -987.09997558594, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(2133, 405.3994140625, -984.7998046875, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(19369, 402.20001220703, -985.90002441406, 93, 0, 0, 0);
	CreateDynamicObject(19397, 403.89999389648, -989, 93, 0, 0, 90);
	CreateDynamicObject(19442, 400.099609375, -1003.3994140625, 93, 0, 0, 90);
	CreateDynamicObject(19442, 402.20001220703, -988.29998779297, 93, 0, 0, 0);
	CreateDynamicObject(1502, 407, -992.849609375, 91.230003356934, 0, 0, 90);
	CreateDynamicObject(2847, 404.5, -986.20001220703, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2010, 402.60000610352, -988.59997558594, 91.300003051758, 0, 0, 0);
	CreateDynamicObject(2274, 403.29998779297, -984.79998779297, 93, 0, 0, 0);
	CreateDynamicObject(2269, 402.79998779297, -987.20001220703, 93, 0, 0, 90);
	CreateDynamicObject(2265, 406.39999389648, -986.09002685547, 93.400001525879, 0, 0, 270);
	CreateDynamicObject(19442, 399.39999389648, -991.29998779297, 93, 0, 0, 180);
	CreateDynamicObject(1649, 399.39999389648, -989.59997558594, 93, 0, 0, 90);
	CreateDynamicObject(19369, 399.39999389648, -985.90002441406, 93, 0, 0, 0);
	CreateDynamicObject(1723, 400, -993.09997558594, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(19415, 405.69921875, -984.19921875, 93, 0, 0, 270);
	CreateDynamicObject(19442, 400.099609375, -984.19921875, 93, 0, 0, 90);
	CreateDynamicObject(19369, 399.3994140625, -993.69921875, 93, 0, 0, 0);
	CreateDynamicObject(1724, 403.20001220703, -993.5, 91.400001525879, 0, 0, 320);
	CreateDynamicObject(2100, 405.60000610352, -989.20001220703, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(1790, 401.70001220703, -997.90002441406, 92, 0, 0, 18);
	CreateDynamicObject(1791, 400.60000610352, -998, 91.900001525879, 0, 0, 180);
	CreateDynamicObject(2313, 401.79998779297, -997.79998779297, 91.400001525879, 0, 0, 180);
	CreateDynamicObject(2350, 409.10000610352, -998.70001220703, 91.800003051758, 0, 0, 0);
	CreateDynamicObject(2350, 411.5, -998.70001220703, 91.800003051758, 0, 0, 0);
	CreateDynamicObject(2964, 405.60000610352, -1000.9000244141, 91.370002746582, 0, 0, 90);
	CreateDynamicObject(2996, 405.79998779297, -1000.700012207, 92.300003051758, 0, 0, 0);
	CreateDynamicObject(2997, 405.70001220703, -1000.9000244141, 92.300003051758, 0, 0, 0);
	CreateDynamicObject(2998, 405.20001220703, -1000.200012207, 92.300003051758, 0, 0, 0);
	CreateDynamicObject(2999, 405.20001220703, -1000.299987793, 92.300003051758, 0, 0, 0);
	CreateDynamicObject(3002, 405.5, -1001.0999755859, 92.300003051758, 0, 0, 0);
	CreateDynamicObject(3101, 405.20001220703, -1001.700012207, 92.300003051758, 0, 0, 0);
	CreateDynamicObject(1669, 410.10000610352, -998.40002441406, 92.599998474121, 0, 0, 0);
	CreateDynamicObject(1667, 410, -998.40002441406, 92.5, 0, 0, 0);
	CreateDynamicObject(1665, 410.39999389648, -996, 92.199996948242, 0, 0, 0);
	CreateDynamicObject(1512, 407.89999389648, -1000.4000244141, 92.5, 0, 0, 0);
	CreateDynamicObject(1455, 407.89999389648, -1000.200012207, 92.400001525879, 0, 0, 0);
	CreateDynamicObject(947, 384.10000610352, -1000.700012207, 93.5, 0, 0, 270);
	CreateDynamicObject(2286, 405.60000610352, -989.20001220703, 93.599998474121, 0, 0, 0);
	CreateDynamicObject(2239, 402.5, -997.70001220703, 91.400001525879, 0, 0, 210);
	CreateDynamicObject(2114, 383.70001220703, -1000.0999755859, 91.5, 0, 0, 0);
	CreateDynamicObject(2164, 407.39999389648, -993.90002441406, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(1742, 402.2998046875, -985.59997558594, 91.400001525879, 0, 0, 270);
	CreateDynamicObject(2292, 400, -984.70001220703, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2295, 406.89999389648, -1002.9000244141, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2291, 400.5, -984.70001220703, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2291, 400, -986.20001220703, 91.400001525879, 0, 0, 90);
	CreateDynamicObject(2291, 400, -987.20001220703, 91.400001525879, 0, 0, 90);
	CreateDynamicObject(2273, 400.70001220703, -984.79998779297, 93, 0, 0, 0);
	CreateDynamicObject(2270, 400, -994.90002441406, 93, 0, 0, 90);
	CreateDynamicObject(2269, 400, -993.59997558594, 93, 0, 0, 90);
	CreateDynamicObject(2265, 406.79998779297, -1000, 93, 0, 0, 270);
	CreateDynamicObject(2263, 403, -1002.799987793, 93.599998474121, 0, 0, 178);
	CreateDynamicObject(2576, 407.599609375, -988.7998046875, 91.400001525879, 0, 0, 90);
	CreateDynamicObject(2238, 400.20001220703, -1002.9000244141, 92.900001525879, 0, 0, 0);
	CreateDynamicObject(2818, 400.70001220703, -996.59997558594, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2818, 400.70001220703, -995.5, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2818, 400.89999389648, -1002.4000244141, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(2195, 399.79998779297, -998.90002441406, 92, 0, 0, 0);
	CreateDynamicObject(2243, 407, -999, 91.699996948242, 0, 0, 0);
	CreateDynamicObject(2246, 413, -999.5, 91.800003051758, 0, 0, 0);
	CreateDynamicObject(2251, 400.79998779297, -1002.9000244141, 93.400001525879, 0, 0, 0);
	CreateDynamicObject(2253, 407.70001220703, -998.79998779297, 91.699996948242, 0, 0, 0);
	CreateDynamicObject(2811, 412.89999389648, -994.20001220703, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(3802, 412.79998779297, -998.90002441406, 93.900001525879, 0, 0, 180);
	CreateDynamicObject(19449, 411.60000610352, -998.59997558594, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19449, 408.10000610352, -998.599609375, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19449, 401.10000610352, -998.599609375, 94.699996948242, 0, 90, 0);
	CreateDynamicObject(19449, 404.60000610352, -998.599609375, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19449, 411.599609375, -988.97998046875, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19449, 401.099609375, -988.9794921875, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19449, 404.599609375, -988.9794921875, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19449, 408.099609375, -988.9794921875, 94.669998168945, 0, 90, 0);
	CreateDynamicObject(19125, 383.39999389648, -1005, 91.900001525879, 0, 0, 0);
	CreateDynamicObject(1734, 401, -995.29998779297, 94.5, 0, 0, 0);
	CreateDynamicObject(957, 410.10000610352, -989.90002441406, 94.550003051758, 0, 0, 0);
	CreateDynamicObject(957, 409.60000610352, -998.90002441406, 94.599998474121, 0, 0, 0);
	CreateDynamicObject(957, 402.5, -1001.5, 94.599998474121, 0, 0, 0);
	CreateDynamicObject(957, 404.20001220703, -987.59997558594, 94.599998474121, 0, 0, 0);
	CreateDynamicObject(957, 399.70001220703, -987.40002441406, 94.599998474121, 0, 0, 0);
	CreateDynamicObject(1697, 410.5, -987.20001220703, 96.400001525879, 0, 0, 180);
	CreateDynamicObject(970, 410.20001220703, -1005.5, 91.900001525879, 0, 0, 181.99951171875);
	CreateDynamicObject(970, 406.10000610352, -1005.5999755859, 91.900001525879, 0, 0, 181.99951171875);
	CreateDynamicObject(970, 402, -1005.700012207, 91.900001525879, 0, 0, 181.99951171875);
	CreateDynamicObject(970, 397.89999389648, -1005.9000244141, 91.900001525879, 0, 0, 181.99951171875);
	CreateDynamicObject(713, 430.39999389648, -1005.4000244141, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(673, 398.70001220703, -1006.5999755859, 91.400001525879, 0, 0, 0);
	CreateDynamicObject(673, 406.70001220703, -1006.5, 91.5, 0, 0, 0);
	CreateDynamicObject(792, 392.10000610352, -985.20001220703, 91.5, 0, 0, 0);
	CreateDynamicObject(792, 388.29998779297, -985.20001220703, 91.5, 0, 0, 0);
	CreateDynamicObject(792, 384.5, -984.90002441406, 91.5, 0, 0, 0);
	CreateDynamicObject(1690, 385.70001220703, -988.5, 95.300003051758, 0, 0, 310);
	CreateDynamicObject(2652, 392.89999389648, -988, 91.800003051758, 0, 0, 0);
	CreateDynamicObject(2652, 392, -987.5, 91.800003051758, 0, 0, 90);
	CreateDynamicObject(1985, 384.79998779297, -989.79998779297, 94.5, 0, 0, 0);
}

stock DeleteObjects(playerid)
{
	// - Petrol damıtma alanı objeleri
	RemoveBuildingForPlayer(playerid, 3682, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1392.1563, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1390.5703, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1387.8516, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 203.9531, 1409.9141, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 199.3828, 1407.1172, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 204.6406, 1409.8516, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1404.2344, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1400.6563, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1409.0000, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 16086, 232.2891, 1434.4844, 13.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 183.0391, 1455.7500, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 198.0000, 1462.0156, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.2422, 1460.3203, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.3047, 1461.0078, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 199.5859, 1463.7266, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 181.1563, 1463.7266, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 185.9219, 1462.8750, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 202.3047, 1462.8750, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 189.5000, 1462.8750, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1451.8281, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1454.5469, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1456.1328, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1468.2109, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1464.6328, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 247.5547, 1471.0938, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1472.9766, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.8125, 1473.8281, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.1250, 1473.8906, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 16089, 342.1250, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16090, 315.7734, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16091, 289.7422, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16087, 358.6797, 1430.4531, 11.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 16088, 368.4297, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16092, 394.1563, 1431.0938, 5.2734, 0.25);
}

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