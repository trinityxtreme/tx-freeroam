//============================================================================//
//                           Trinity-Xtreme                                   //
//                                Survival Freeroam Project                   //
//                                                                            //
//                                   			Gamemode by gguilt (ImmortaL) //
// 														Map & art by Crosscuk //
//============================================================================//
/*      a town beside the sea,
				    we can wander through the forest,
									    and do so as we please,
									    		      living so merily.		  */
/*      for a old memories, my friends, some places, the sun, and my life.    */
/* Trinity-Xtreme: 2013-05 | Supervivencia: 2014-02-08 | SFP: 2022-12-01      */
//============================================================================//

// ** Library include
#include <a_samp>         //SA-MP 0.3x orjinal kÄ±tÃ¼phanesi.
#include <sscanf2>         //SSCANF kÃ¼tÃ¼phanesi.
#include <streamer>       //Obje streamer kÃ¼tÃ¼phanesi.
//#include <progress2>       //Progressbar kÃ¼tÃ¼phanesi.


// ** Server settings
#define server_name     "Trinity-Xtreme Survival Freeroam"
#define server_version  "1.0.0"
#define server_modname  "Supervivencia"
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
#define SendError(%0,%1) SendClientMessage(%0,0xF63845AA,"[!] HATA: {FFFFFF}" %1)
#define SendInfo(%0,%1) SendClientMessage(%0,0x00A2F6AA,"[*] BÄ°LGÄ°: {FFFFFF}" %1)
#define SendUse(%0,%1) SendClientMessage(%0,0x8C50FFAA,"[?] KULLANIM: {FFFFFF}" %1)

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
#define DIALOG 8000 // BaÄ±langÄ±Ä± dialog id
#define MAX_HOUSE 100 // Toplam yaratÄ±lan ev sayÄ±sÄ±.
#define BASLIK "{FFFFFF}Trinity-Xtreme / {009BFF}Ev Sistemi" // Dialog,mesaj baÄ±lÄ±klarÄ±

#define ACIKLAMA "SatÄ±lÄ±k Ev! (/satinal & /ev)" // Default yeni yaratÄ±lan evin aÄ±Ä±klamasÄ±
#define FIYAT 20000 // Default yeni yaratÄ±lan evin fiyatÄ±
#define KILIT 1 // Default yeni yaratÄ±lan evin kilidi ( 0: AÄ±Ä±k - 1: Kilitli )
#define KASA 0 // Default yeni yaratÄ±lan evin kasasÄ±ndaki para

#define MENU DIALOG+15 // DeÄ±iÄ±tirmeye gerek yok
#define SATINAL MENU+15 // DeÄ±iÄ±tirmeye gerek yok

#define BLUEH 1272 // Ellemeyin.
#define GREENH 1273 // Ellemeyin.
#define REDMAP 32 // Ellemeyin.
#define GREENMAP 31 // Ellemeyin.
#define ARROW 1318 // Ellemeyin.

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

// - GiriÄ±te dans tanÄ±tÄ±mlarÄ±
new RandAnims[6][0] = {
{"DAN_LOOP_A"},
{"DNCE_M_A"},
{"DNCE_M_B"},
{"DNCE_M_C"},
{"DNCE_M_D"},
{"DNCE_M_E"}
};

// - PM sistemi tanÄ±tÄ±mlarÄ±
enum PlayerInfo
{
	Last,
	NoPM,
}

new pInfo[MAX_PLAYERS][PlayerInfo];

// - Exp sistemi tanÄ±tÄ±mlarÄ±
new exp[MAX_PLAYERS], seviye[MAX_PLAYERS], expguncelle[MAX_PLAYERS];
new Text:expbox;
new Text:expmeter[MAX_PLAYERS]; 

// new Bar:expbar[MAX_PLAYERS];

// - Saat sistemi tanÄ±tÄ±mlarÄ±
new Hour,
    Minute,
    Timer,
    Text:TimeText;

// - AraÃ§ yÄ±netim tanÄ±tÄ±mlarÄ±
new motor,isiklar,alarm,kapilar,kaput,bagaj,objective;
new Kilit[MAX_PLAYERS] = 0;
new Arac[MAX_PLAYERS];

// - DM sistemi tanÄ±tÄ±mlarÄ±
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

// - YardÄ±m menÄ±sÄ± tanÄ±tÄ±mlarÄ±
new dIp[][] =
{
	"{ACDA00}/firstperson\t\t{FFFFFF}FPS moduna giriÅŸ yaparsÄ±nÄ±z.",
	"{ACDA00}/exitfirstperson\t{FFFFFF}FPS modundan Ã§Ä±karsÄ±nÄ±z.",
	"{ACDA00}/myversion\t\t{FFFFFF}SA-MP versiyonunuzu gÃ¶sterir.",
	"{ACDA00}/kurallar\t\t{FFFFFF}Sunucu kural menÃ¼sÃ¼nÃ¼ aÃ§ar.",
	"{ACDA00}/surus\t\t\t{FFFFFF}AraÃ§ iÄ±i FPS modunu aÄ±ar/kapatÄ±r.",
	"{ACDA00}/teles\t\t\t{FFFFFF}Teleport menÄ±sÄ±nÄ± aÄ±ar.",
	"{ACDA00}/m1-/m12\t\t{FFFFFF}Modifiyeli araba spawn eder.",
	"{ACDA00}/v1-/v18\t\t{FFFFFF}Normal araba spawn eder.",
	"{ACDA00}/changelog\t\t{FFFFFF}GÄ±ncelleme listesini gÄ±sterir.",
	"{ACDA00}/cevir\t\t\t{FFFFFF}Ters Ä±evrilen arabayÄ± dÄ±zeltir.",
	"{ACDA00}/31\t\t\t{FFFFFF}31 Ä±ekme sistemini aÄ±ar/kapatÄ±r.",
	"{ACDA00}/dmler\t\t\t{FFFFFF}Deathmatch alanÄ± listesini gÄ±sterir.",
	"{ACDA00}/stuntlar\t\t{FFFFFF}Stunt alanlarÄ±nÄ± gÄ±sterir.",
	"{ACDA00}/can\t\t\t{FFFFFF}Can paketi satÄ±n alÄ±rsÄ±nÄ±z.",
	"{ACDA00}/yelek\t\t\t{FFFFFF}ZÄ±rh paketi satÄ±n alÄ±rsÄ±nÄ±z.",
    "{ACDA00}/ev\t\t\t{FFFFFF}Ev dÄ±zenleme menÄ±sÄ±nÄ± aÄ±ar.",
	"{ACDA00}/yardim\t\t{FFFFFF}Oyun modu hakkÄ±nda yardÄ±m verir.",
	"\n\nBu mod {009BFF}MR.ImmortaL {FFFFFF}tarafÄ±ndan kodlanmÄ±Ä±tÄ±r."
};

// - 31 sistemi tanÄ±tÄ±mlarÄ±
new asilantimer;
new cekiyor[MAX_PLAYERS] = 0;

// - FPS sistemi tanÄ±tÄ±mlarÄ±
new Surus[MAX_PLAYERS];
new firstperson[MAX_PLAYERS];

// - AraÃ§ spawn sistemi tanÄ±tÄ±mlarÄ±
#define DIALOG_OFFSET_ID (1024)

new g_VehNames[][] =
{
	!"{FFFFFF}Landstalker", !"{FFFFFF}Bravura", !"{FFFFFF}Buffalo", !"{FFFFFF}Linerunner", !"{FFFFFF}Pereniel", !"{FFFFFF}Sentinel", !"{FFFFFF}Dumper", !"{FFFFFF}Firetruck", !"{FFFFFF}Trashmaster", !"{FFFFFF}Stretch", !"{FFFFFF}Manana", !"{FFFFFF}Infernus",
	!"{FFFFFF}Voodoo", !"{FFFFFF}Pony", !"{FFFFFF}Mule", !"{FFFFFF}Cheetah", !"{FFFFFF}Ambulance", !"{FFFFFF}Leviathan", !"{FFFFFF}Moonbeam", !"{FFFFFF}Esperanto", !"{FFFFFF}Taxi", !"{FFFFFF}Washington", !"{FFFFFF}Bobcat", !"{FFFFFF}Mr Whoopee", !"{FFFFFF}BF Injection",
	!"{FFFFFF}Hunter [YASAK]", !"{FFFFFF}Premier", !"{FFFFFF}Enforcer", !"{FFFFFF}Securicar", !"{FFFFFF}Banshee", !"{FFFFFF}Predator", !"{FFFFFF}Bus", !"{FFFFFF}Rhino [YASAK]", !"{FFFFFF}Barracks", !"{FFFFFF}Hotknife", !"{FFFFFF}Trailer", !"{FFFFFF}Previon", !"{FFFFFF}Coach", !"{FFFFFF}Cabbie",
	!"{FFFFFF}Stallion", !"{FFFFFF}Rumpo", !"{FFFFFF}RC Bandit", !"{FFFFFF}Romero", !"{FFFFFF}Packer", !"{FFFFFF}Monster", !"{FFFFFF}Admiral", !"{FFFFFF}Squalo", !"{FFFFFF}Seasparrow", !"{FFFFFF}Pizzaboy", !"{FFFFFF}Tram", !"{FFFFFF}Trailer", !"{FFFFFF}Turismo", !"{FFFFFF}Speeder",
	!"{FFFFFF}Reefer", !"{FFFFFF}Tropic", !"{FFFFFF}Flatbed", !"{FFFFFF}Yankee", !"{FFFFFF}Caddy", !"{FFFFFF}Solair", !"{FFFFFF}Berkley's RC Van", !"{FFFFFF}Skimmer", !"{FFFFFF}PCJ-600", !"{FFFFFF}Faggio", !"{FFFFFF}Freeway", !"{FFFFFF}RC Baron", !"{FFFFFF}RC Raider",
	!"{FFFFFF}Glendale", !"{FFFFFF}Oceanic", !"{FFFFFF}Sanchez", !"{FFFFFF}Sparrow", !"{FFFFFF}Patriot", !"{FFFFFF}Quad", !"{FFFFFF}Coastguard", !"{FFFFFF}Dinghy", !"{FFFFFF}Hermes", !"{FFFFFF}Sabre", !"{FFFFFF}Rustler", !"{FFFFFF}ZR3 50", !"{FFFFFF}Walton", !"{FFFFFF}Regina",
	!"{FFFFFF}Comet", !"{FFFFFF}BMX", !"{FFFFFF}Burrito", !"{FFFFFF}Camper", !"{FFFFFF}Marquis", !"{FFFFFF}Baggage", !"{FFFFFF}Dozer", !"{FFFFFF}Maverick", !"{FFFFFF}News Chopper", !"{FFFFFF}Rancher", !"{FFFFFF}FBI Rancher", !"{FFFFFF}Virgo", !"{FFFFFF}Greenwood",
	!"{FFFFFF}Jetmax", !"{FFFFFF}Hotring", !"{FFFFFF}Sandking", !"{FFFFFF}Blista Compact", !"{FFFFFF}Police Maverick", !"{FFFFFF}Boxville", !"{FFFFFF}Benson", !"{FFFFFF}Mesa", !"{FFFFFF}RC Goblin", !"{FFFFFF}Hotring Racer A", !"{FFFFFF}Hotring Racer B",
	!"{FFFFFF}Bloodring Banger", !"{FFFFFF}Rancher", !"{FFFFFF}Super GT", !"{FFFFFF}Elegant", !"{FFFFFF}Journey", !"{FFFFFF}Bike", !"{FFFFFF}Mountain Bike", !"{FFFFFF}Beagle", !"{FFFFFF}Cropdust", !"{FFFFFF}Stunt", !"{FFFFFF}Tanker", !"{FFFFFF}RoadTrain",
	!"{FFFFFF}Nebula", !"{FFFFFF}Majestic", !"{FFFFFF}Buccaneer", !"{FFFFFF}Shamal", !"{FFFFFF}Hydra [YASAK]", !"{FFFFFF}FCR-900", !"{FFFFFF}NRG-500", !"{FFFFFF}HPV1000", !"{FFFFFF}Cement Truck", !"{FFFFFF}Tow Truck", !"{FFFFFF}Fortune", !"{FFFFFF}Cadrona", !"{FFFFFF}FBI Truck",
	!"{FFFFFF}Willard", !"{FFFFFF}Forklift", !"{FFFFFF}Tractor", !"{FFFFFF}Combine", !"{FFFFFF}Feltzer", !"{FFFFFF}Remington", !"{FFFFFF}Slamvan", !"{FFFFFF}Blade", !"{FFFFFF}Freight", !"{FFFFFF}Streak", !"{FFFFFF}Vortex", !"{FFFFFF}Vincent", !"{FFFFFF}Bullet", !"{FFFFFF}Clover",
	!"{FFFFFF}Sadler", !"{FFFFFF}Firetruck", !"{FFFFFF}Hustler", !"{FFFFFF}Intruder", !"{FFFFFF}Primo", !"{FFFFFF}Cargobob", !"{FFFFFF}Tampa", !"{FFFFFF}Sunrise", !"{FFFFFF}Merit", !"{FFFFFF}Utility", !"{FFFFFF}Nevada", !"{FFFFFF}Yosemite", !"{FFFFFF}Windsor", !"{FFFFFF}Monster A",
	!"{FFFFFF}Monster B", !"{FFFFFF}Uranus", !"{FFFFFF}Jester", !"{FFFFFF}Sultan", !"{FFFFFF}Stratum", !"{FFFFFF}Elegy", !"{FFFFFF}Raindance", !"{FFFFFF}RC Tiger", !"{FFFFFF}Flash", !"{FFFFFF}Tahoma", !"{FFFFFF}Savanna", !"{FFFFFF}Bandito", !"{FFFFFF}Freight", !"{FFFFFF}Trailer",
	!"{FFFFFF}Kart", !"{FFFFFF}Mower", !"{FFFFFF}Duneride", !"{FFFFFF}Sweeper", !"{FFFFFF}Broadway", !"{FFFFFF}Tornado", !"{FFFFFF}AT-400", !"{FFFFFF}DFT-30", !"{FFFFFF}Huntley", !"{FFFFFF}Stafford", !"{FFFFFF}BF-400", !"{FFFFFF}Newsvan", !"{FFFFFF}Tug", !"{FFFFFF}Trailer A", !"{FFFFFF}Emperor",
	!"{FFFFFF}Wayfarer", !"{FFFFFF}Euros", !"{FFFFFF}Hotdog", !"{FFFFFF}Club", !"{FFFFFF}Trailer B", !"{FFFFFF}Trailer C", !"{FFFFFF}Andromada", !"{FFFFFF}Dodo", !"{FFFFFF}RC Cam", !"{FFFFFF}Launch", !"{FFFFFF}Police Car (LSPD)", !"{FFFFFF}Police Car (SFPD)",
	!"{FFFFFF}Police Car (LVPD)", !"{FFFFFF}Police Ranger", !"{FFFFFF}Picador", !"{FFFFFF}S.W.A.T. Van", !"{FFFFFF}Alpha", !"{FFFFFF}Phoenix", !"{FFFFFF}Glendale", !"{FFFFFF}Sadler", !"{FFFFFF}Luggage Trailer A", !"{FFFFFF}Luggage Trailer B",
	!"{FFFFFF}Stair Trailer", !"{FFFFFF}Boxville", !"{FFFFFF}Farm Plow", !"{FFFFFF}Utility Trailer"
};

// - Modifiyeli AraÃ§ spawn sistemi tanÄ±tÄ±mlarÄ±
enum ModArac
{
pMAraba,
pMArabaID
};

new MCarPlayerInfo[MAX_PLAYERS][ModArac];
// - HÄ±zlandÄ±rÄ±cÄ± pickup tanÄ±tÄ±mlarÄ±
new hizlandirici[14];
#define HIZ_VER 5

// - Ev sistemi tanÄ±tÄ±mlarÄ±
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
forward EvYarat(evid,Float:X,Float:Y,Float:Z);
forward EvKaydetInt(evid, const bilgii[],deger);
forward EvKaydetStr(evid, const bilgii[], const deger[]);
forward EvKaydetFloat(evid, const bilgii[],Float:deger);
forward EvPickupYenile(evid);
forward Kontrol(playerid);
forward OyuncuMapIconKontrol(playerid);
forward PlayerPos(playerid,Float:X,Float:Y,Float:Z,interior,world);
forward SahipKontrol();
forward EvYakininda(playerid);

// - Random spawn
new Float:RandomPlayerSpawns[23][3] = {
	{1958.3783,1343.1572,15.3746},
	{2199.6531,1393.3678,10.8203},
	{2483.5977,1222.0825,10.8203},
	{2637.2712,1129.2743,11.1797},
	{2000.0106,1521.1111,17.0625},
	{2024.8190,1917.9425,12.3386},
	{2261.9048,2035.9547,10.8203},
	{2262.0986,2398.6572,10.8203},
	{2244.2566,2523.7280,10.8203},
	{2335.3228,2786.4478,10.8203},
	{2150.0186,2734.2297,11.1763},
	{2158.0811,2797.5488,10.8203},
	{1969.8301,2722.8564,10.8203},
	{1652.0555,2709.4072,10.8265},
	{1564.0052,2756.9463,10.8203},
	{1271.5452,2554.0227,10.8203},
	{1441.5894,2567.9099,10.8203},
	{1480.6473,2213.5718,11.0234},
	{1400.5906,2225.6960,11.0234},
	{1598.8419,2221.5676,11.0625},
	{1318.7759,1251.3580,10.8203},
	{1558.0731,1007.8292,10.8125},
	{1705.2347,1025.6808,10.8203}
};

main()
{
    new year, month, day, hour, minute, second;
	getdate(year, month, day);
	gettime(hour, minute, second);

	printf("YÄ±klendi: \"Sunucu modu.\"");
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

    printf("YÄ±klendi: \"Sunucu textdrawlarÄ±.\"");
    // - Exp sistemi ayarlarÄ±
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

    for(new i; i<MAX_PLAYERS; i++)
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
    printf("YÄ±klendi: \"Exp-Level sistemi.\"");
    // - Saat sistemi ayarlarÄ±

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
   	Timer = SetTimer("UpdateServerTime",1000,true);

    printf("YÄ±klendi: \"Saat sistemi.\"");
    // - Sunucu Harita Objeleri

    

    printf("YÄ±klendi: \"Sunucu haritasÄ±.\"");
	printf("YÄ±klendi: \"Sunucu AraÃ§larÄ±.\"");
	// - HÄ±zlandÄ±rma pickuplarÄ±
	hizlandirici[1]=CreatePickup(1313,14,2048.6716,1015.3157,10.6719,0);
	hizlandirici[2]=CreatePickup(1313,14,2066.5132,1019.7257,10.6719,0);
	hizlandirici[3]=CreatePickup(1313,14,2066.5918,1254.1406,10.6719,0);
	hizlandirici[4]=CreatePickup(1313,14,2048.8401,1284.9427,10.6719,0);
	hizlandirici[5]=CreatePickup(1313,14,2121.1084,1847.6072,10.6719,0);
	hizlandirici[6]=CreatePickup(1313,14,2146.4421,1874.5963,10.6719,0);
	hizlandirici[7]=CreatePickup(1313,14,2128.2676,2219.6204,10.6719,0);
	hizlandirici[8]=CreatePickup(1313,14,2229.9316,2555.6431,10.8203,0);
	hizlandirici[9]=CreatePickup(1313,14,1964.1276,2593.7170,10.8126,0);
	hizlandirici[10]=CreatePickup(1313,14,-2084.9065,-1967.6328,378.5436,0);
	hizlandirici[11]=CreatePickup(1313,14,2048.4058,815.1559,8.4697,0);
	hizlandirici[12]=CreatePickup(1313,14,2364.7070,433.8943,17.6082,0);
	hizlandirici[13]=CreatePickup(1313,14,1294.1956,2598.3647,11.9492,0);

	printf("YÄ±klendi: \"HÄ±z pickuplarÄ±.\"");
	// - Ev sistemi ayarlarÄ±
	SetTimer("SahipKontrol",3000,1);

	AddStaticPickup(ARROW,1,235.1575,1187.2721,1080.2578,-1);
	AddStaticPickup(ARROW,1,225.756989,1240.000000,1082.149902,-1);
	AddStaticPickup(ARROW,1,225.630997,1022.479980,1084.069946,-1);
	AddStaticPickup(ARROW,1,295.2057,1472.9973,1080.2578,-1);
	AddStaticPickup(ARROW,1,327.9004,1478.2839,1084.4375,-1);
	AddStaticPickup(ARROW,1,2324.3735,-1148.8219,1050.7101,-1);

	printf("YÄ±klendi: \"Ev sistemi.\"");
	for(new i;i<MAX_HOUSE;i++)
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
	for(new i = 0; i <= 299; i++)
	{
		skinValue++;
 		AddPlayerClass(i, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	}

	printf("  ** %d player class loaded.", skinValue);

	// MySQL settings:
	
	//mysql_connect(mysql_hostname, mysql_username, mysql_database, mysql_password);
	//mysql_query("CREATE TABLE IF NOT EXISTS players(SQLID INT(11), Nickname VARCHAR(24), Password VARCHAR(16), AdminLevel INT(1), Killed INT(11), Death INT(11), Score INT(11), Money INT(11), Radiation INT(3), Hungry INT(3), Comfort INT(3), Last_X FLOAT, Last_Y FLOAT, Last_Z, FLOAT, Last_INT INT(3), LastIP VARCHAR(16), Online TINYINT(1), LastOnline DATE");
	//mysql_query("CREATE TABLE IF NOT EXISTS iplog(playername VARCHAR(24), ip VARCHAR(16), connected TINYINT(1))");
	
 	//if(mysql_ping() > 0)
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
    printf("Sunucu modu kapandÄ±.");
    printf("Saat: %d:%d:%d ~ Tarih: %d/%d/%d",hour,minute,second,day,month,year);
    printf("Trinity-Xtreme / since 27/01/2013 - 01:52");

	//mysql_close();
	printf("  ** MySQL connection closed!");

    printf("Ä± %s gamemode closed.", server_modname);
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
    
    //if(true)
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

	
	//if(!dini_Exists(dosya)) seviye[playerid]=1, dini_Create(dosya);
	//else BilgiYukle(playerid);
	expguncelle[playerid] = SetTimerEx("BilgiYenile", 1000, true, "d", playerid);

    // - Ev sistemi ayarÄ±
    OyuncuMapIconKontrol(playerid);

    // - AraÃ§ kilit ayarÄ±
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

	// - AraÃ§ spawn ayarlarÄ±
    new iVehID = GetPVarInt(playerid, "iVehID");
    if(iVehID)
    DestroyVehicle(iVehID);

	// - Ev sistemi ayarlarÄ±
    OyuncuEv[playerid] = -1;
	EvEditleniyor[GetHouseID(playerid)] = false;
	OyuncuKontrolEv[playerid]=-255;

	new exitMessage[65 + MAX_PLAYER_NAME];
	switch(reason)
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

	if(campFire[playerid] == true)
	{
		DestroyDynamicObject(fireWoods[playerid]);
		DestroyDynamicObject(fireObject[playerid]);
	}

	if(guitarSong[playerid] == true)
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

    // Exp sistemi bitiÄ±i

    switch(DM[playerid])
	{
	    case 1:
	    {
        new State = GetPlayerState(playerid);
        if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	    {
        GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
        }
        DM[playerid]=1;
        SetPlayerArmour(playerid,100);
        SetPlayerHealth(playerid,100);
        SetPlayerInterior(playerid,0);
        SetPlayerVirtualWorld(playerid,0);
        ResetPlayerWeapons(playerid);
        new rand = random(sizeof(deagledm1pos));
        SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
        GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
        GivePlayerWeapon(playerid,24,99999);
        SetPlayerTeam(playerid, NO_TEAM);
	    }

	    case 2:
	    {
        new State = GetPlayerState(playerid);
        if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	    {
        GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
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
        SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
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
    ExpVer(killerid);
    SendDeathMessage(killerid, playerid, reason);
    SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
	if(GetPlayerScore(playerid) > 0) return SetPlayerScore(playerid,GetPlayerScore(playerid)-1);
    PlayerPlaySound(playerid,5206, 0, 0, 0);

	if(!(GetPlayerScore(playerid) <= 0))
		SetPlayerScore(playerid, GetPlayerScore(playerid) - 1);

	SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
	SendDeathMessage(killerid, playerid, reason);

	PlayerAccount[playerid][pA_Hungry] = 0;
	PlayerAccount[playerid][pA_Radiation] = 0;

	TextDrawHideForPlayer(playerid, textdraw_hungry[playerid]);
    TextDrawHideForPlayer(playerid, textdraw_radiation[playerid]);
	TextDrawHideForPlayer(playerid, textdraw_ping[playerid]);

	if(campFire[playerid] == true)
	{
		DestroyDynamicObject(fireWoods[playerid]);
		DestroyDynamicObject(fireObject[playerid]);
	}

	if(guitarSong[playerid] == true)
	{
	    StopAudioStreamForPlayer(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid);
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new pText[256 + MAX_PLAYER_NAME];
	format(pText, sizeof(pText), "%s {BBBBBB}[%d]: %s", pName(playerid), playerid, text);
	SendClientMessageToAll(GetPlayerColor(playerid), pText);
	/*
	new chatmessage[1024];
	if(IsPlayerAdmin(playerid))
	{
	format(chatmessage,1024,"{C30000}[{FFFFFF}RGM{C30000}]{ACDA00}%s{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s",PlayerName(playerid),playerid,text);
	SendClientMessageToAll(1,chatmessage);
	}
	else
	{
	if(IsPlayeraLAdmin(playerid))
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

// - DCMD komutlarÄ±:
dcmd_pmkapat(playerid, const params[])
{
	#pragma unused params
	if(pInfo[playerid][NoPM] == 0)
	{
	    pInfo[playerid][NoPM] = 1;
	    SendInfo(playerid,"Ä±zel mesaj hattÄ±nÄ±zÄ± kapattÄ±nÄ±z.");
	}
	else
	{
	    SendError(playerid,"Ä±zel mesaj hattÄ±nÄ±z zaten kapalÄ±.");
	}
}

dcmd_pmac(playerid, const params[])
{
	#pragma unused params
	if(pInfo[playerid][NoPM] == 0)
	{
	    SendInfo(playerid,"Ä±zel mesaj hattÄ±nÄ±z zaten aÄ±Ä±k.");
	}
	else
	{
	    pInfo[playerid][NoPM] = 0;
	    SendInfo(playerid,"Ä±zel mesaj hattÄ±nÄ±zÄ± aÄ±tÄ±nÄ±z.");
	}
}

dcmd_pm(playerid, const params[])
{
	new pID, text[128], string[128];
	if(sscanf(params, "us", pID, text)) return SendUse(playerid,"/pm (nick/id) (mesaj)");
	if(!IsPlayerConnected(pID)) return SendError(playerid,"Oyuncu bulunamadÄ±.");
	if(pID == playerid) return SendError(playerid,"Kendinize Ä±zel mesaj gÄ±nderemezsiniz.");
	format(string, sizeof(string), "Ä± HATA: {FFFFFF}%s(%d) rumuzlu oyuncunun Ä±zel mesaj hattÄ± kapalÄ±.", PlayerName(pID), pID);
	if(pInfo[pID][NoPM] == 1) return SendClientMessage(playerid,0xF63845AA,string);
	format(string, sizeof(string), "Ä±Ä± [PM] %s: %s", PlayerName(pID), text);
	SendClientMessage(playerid, -1, string);
	format(string, sizeof(string), "Ä±Ä± [PM] %s: %s", PlayerName(playerid), text);
	SendClientMessage(pID, -1, string);
	pInfo[pID][Last] = playerid;
	return 1;
}

dcmd_reply(playerid, const params[])
{
	new text[128], string[128];
	if(sscanf(params, "s", text)) return SendUse(playerid,"/reply (mesaj)");
	new pID = pInfo[playerid][Last];
	if(!IsPlayerConnected(pID)) return SendError(playerid,"Oyuncu bulunamadÄ±.");
	if(pID == playerid) return SendError(playerid,"Kendinize Ä±zel mesaj gÄ±nderemezsiniz.");
	format(string, sizeof(string), "Ä± HATA: {FFFFFF}%s(%d) rumuzlu oyuncunun Ä±zel mesaj hattÄ± kapalÄ±.", PlayerName(pID), pID);
	if(pInfo[pID][NoPM] == 1) return SendClientMessage(playerid,0xF63845AA,string);
	format(string, sizeof(string), "Ä±Ä± [PM] %s: %s", PlayerName(pID), text);
	SendClientMessage(playerid, -1, string);
	format(string, sizeof(string), "Ä±Ä± [PM] %s: %s", PlayerName(playerid), text);
	SendClientMessage(pID, -1, string);
	pInfo[pID][Last] = playerid;
	return 1;
}

dcmd_ms(playerid, const params[]) return dcmd_pm(playerid, params);
dcmd_m(playerid, const params[]) return dcmd_pm(playerid, params);
dcmd_r(playerid, const params[]) return dcmd_reply(playerid, params);
// - DCMD komutlarÄ± bitiÄ±i.

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256],idx,tmp[256];
	cmd=strtok(cmdtext,idx);

	printf("[command] %s entered \"%s\" command.", pName(playerid), cmdtext);

	// Roleplay commands:
	if(!strcmp(cmdtext, "/me", true, 3))
    {
        if(!cmdtext[3]) return showMessage(playerid, "USAGE: /me [action]");

        new text[128];
        format(text, sizeof(text), "* %s %s", pName(playerid), cmdtext[4]);
        SendClientMessageToAll(0xFFFF00AA, text);
        return 1;
    }

   	// Debug commands:
  	if(!strcmp(cmdtext, "/eat", true))
    {
        showMessage(playerid, "You're eated a {006699}burger.");
        PlayerAccount[playerid][pA_Hungry] = 0;
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
        return 1;
	}

	if(!strcmp(cmdtext, "/addrad", true))
    {
        showMessage(playerid, "Radiation coming!");
        PlayerAccount[playerid][pA_Radiation] += 15;
        return 1;
	}

	if(!strcmp(cmdtext, "/radpills", true))
    {
        showMessage(playerid, "You're used a {006699}radiation pill.");
        PlayerAccount[playerid][pA_Radiation] = 0;
        ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
        return 1;
	}

// ========================================================================== //

	// Campfire script:
	if(!strcmp(cmdtext, "/campfire", true))
	{
	    if(campFire[playerid] == true) return showMessage(playerid, "You need quench your last campfire. (/firedown)");
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken ateÄ± yakamazsÄ±nÄ±z!");
	    campFire[playerid] = true;

	    new Float:fireX, Float:fireY, Float:fireZ;
		GetPlayerPos(playerid, fireX, fireY, fireZ);
	    fireWoods[playerid]	 = CreateDynamicObject(1463, fireX, fireY - 3.5, fireZ - 0.8, 0.000000, 0.000000, 0.000000);
		fireObject[playerid] = CreateDynamicObject(18689, fireX, fireY - 3.5, fireZ - 2.5, 0.000000, 0.000000, 0.000000);
		showMessage(playerid, "You setted a campfire. (Quench: /firedown)");
		return 1;
	}

	if(!strcmp(cmdtext, "/firedown", true))
	{
	    if(campFire[playerid] == false) return showMessage(playerid, "Once you need setting a campfire. (/campfire)");
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken ateÄ±i sÄ±ndÄ±remezsiniz!");

	    new Float:fireX, Float:fireY, Float:fireZ;
	    GetDynamicObjectPos(fireWoods[playerid], fireX, fireY, fireZ);
	    if(!IsPlayerInRangeOfPoint(playerid, 7.0, fireX, fireY, fireZ)) return showMessage(playerid, "Kamp ateÄ±inin yakÄ±nÄ±nda deÄ±ilsiniz! [7 metre]");

		campFire[playerid] = false;
     	DestroyDynamicObject(fireWoods[playerid]);
      	DestroyDynamicObject(fireObject[playerid]);
		showMessage(playerid, "Kamp ateÄ±ini sÄ±ndÄ±rdÄ±nÄ±z!");
	    return 1;
	}

	// Guitar script:
	if(!strcmp(cmdtext, "/guitar", true))
	{
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return showMessage(playerid, "Arabadayken gitar Ä±alamazsÄ±nÄ±z!");
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
	    showMessage(playerid, "Gitar Ã§almaya baÅŸladÄ±nÄ±z, durmak iÃ§in: /guitardown");
		return 1;
	}

	if(!strcmp(cmdtext, "/guitardown", true))
	{
	    if(guitarSong[playerid] == false) return showMessage(playerid, "Gitar Ã§almÄ±yorsunuz! (/guitar)");
		guitarSong[playerid] = false;

		TogglePlayerControllable(playerid, 1);
		StopAudioStreamForPlayer(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ClearAnimations(playerid);
		showMessage(playerid, "Gitar Ã§almayÄ± bÄ±raktÄ±nÄ±z!");
		return 1;
	}


	if(!strcmp("/dmcik",cmdtext,true))
	{
		if(DM[playerid] == 0) return SendError(playerid,"Zaten deathmatch alanÄ±nda deÄ±ilsin!");
		DM[playerid]=0;
		SetPlayerArmour(playerid,0.0);
		SetPlayerHealth(playerid,100.0);
		ResetPlayerWeapons(playerid);
		SpawnPlayer(playerid);
		SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±ktÄ±nÄ±z.");
		return 1;
	}

   	if(DM[playerid] > 0) return SendError(playerid,"Deathmatch alanÄ±nda komut kullanmak yasaktÄ±r. Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
	// - DCMD komutlarÄ±
	dcmd(pm, 2, cmdtext);
	dcmd(ms, 2, cmdtext);
	dcmd(m, 1, cmdtext);
	dcmd(r, 1, cmdtext);
	dcmd(reply, 5, cmdtext);
	dcmd(pmac, 4, cmdtext);
	dcmd(pmkapat, 7, cmdtext);

	// - Genel komutlar && dialog komutlarÄ±
	if(!strcmp(cmdtext, "/kurallar", true))
	{
	ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFFFF}Trinity-Xtreme / {009BFF}Kurallar","{00FF00}~~ Hile kesinlikle yasaktÄ±r.\n~~ Argo yasaktÄ±r.\n~~ Ä±nanÄ± & gÄ±rÄ±Ä±e karÄ±Ä± hakaret yasaktÄ±r.\n~~ YÄ±netimi rahatsÄ±z etmek yasaktÄ±r.","Kapat","");
    return 1;
	}

	if(!strcmp(cmdtext, "/changelog", true))
	{
	ShowPlayerDialog(playerid,1911,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.0]","{ACDA00}~ Sunucu dosyalarÄ± oluÄ±turuldu.\n~ LAdmin 4.0 eklendi.\n~ Changelog eklendi.\n~ Textdrawlar eklendi.\n~ Teles menÄ±sÄ± eklendi.\n~ YardÄ±m menÄ±sÄ± eklendi.\n~ Kurallar menÄ±sÄ± eklendi.\n~ Ä±lk haritalar ve AraÃ§lar eklendi.\n~ aLypSe Ev Sistemi moda eklendi.\n~ /v1-/v18 AraÃ§ spawn sistemi eklendi.\n~ /m1-/m12 AraÃ§ spawn sistemi eklendi.\n~ /paraver-/can-/yelek-/surus-/cevir komutlarÄ± eklendi.","RC1.1","Kapat");
    return 1;
	}

	if(!strcmp(cmdtext, "/teles", true))
	{
	ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Teleport","{FFFFFF}Four Dragon Casino (/4dragon)\nChilliad Mountain (/dag)\nSanta Maria Beach (/sahil)\nArea51 Zone (/area51)\nSan Fierro ChinaTown (/china)\nLos Santos Los Flores (/flores)\nModifiye Yeri 1 (/mod1)\nModifiye Yeri 2 (/mod2)\nModifiye Yeri 3 (/mod3)\nModifiye Yeri 4 (/mod4)\nModifiye Yeri 5 (/mod5)\nAirport 1 (/ap1)\nAirport 2 (/ap2)\nAirport 3 (/ap3)\nAirport 4 (/ap4)\n~ DiÄ±er Sayfa.","SeÄ±","Kapat");
	return 1;
	}

	if(!strcmp(cmdtext, "/dmler", true))
	{
	ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Deathmatch","{FFFFFF}Desert Eagle Deathmatch - 1 (/deagledm1)\n{FFFFFF}Fight Club Deathmatch -1 (/fistdm1)","SeÄ±","Kapat");
	return 1;
	}

	if(!strcmp(cmdtext, "/stuntlar", true))
	{
	ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Stunt Zones","{FFFFFF}Bikepark Stunt - 1 (/bikestunt1)","SeÄ±","Kapat");
	return 1;
	}

	if(!strcmp(cmdtext, "/silahlar", true))
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
    return 1;
	}

	if (strcmp("/yardim", cmdtext, true, 10) == 0)
	{
	    new string[2048];
	    format(string,2048,"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",dIp[0],dIp[1],dIp[2],dIp[3],dIp[4],dIp[5],dIp[6],dIp[7],dIp[8],dIp[9],dIp[10],dIp[11],dIp[12],dIp[13],dIp[14],dIp[15],dIp[16],dIp[17]);
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX, "{FFFFFF}Trinity-Xtreme / {009BFF}YardÄ±m",string,"Kapat","");
		return 1;
	}

 	if (strcmp("/myversion", cmdtext, true, 10) == 0)
	{
	    new string[64];
    	GetPlayerVersion(playerid, string, sizeof(string));
    	format(string, sizeof(string), "Ä± BÄ±LGÄ±: {FFFFFF}SA-MP versiyonunuz: {00FF00}%s", string);
        SendClientMessage(playerid, 0x00A2F6AA,string);
		return 1;
	}

	// - AraÃ§ yÄ±netim komutlarÄ±
    if(strcmp(cmd, "/motorac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,VEHICLE_PARAMS_ON,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Motor aÃ§Ä±ldÄ±, kapatmak iÃ§in {00FF00}/motorkapat");
    }
    return 1;
    }

    if(strcmp(cmd, "/motorkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,VEHICLE_PARAMS_OFF,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Motor kapatÄ±ldÄ±, tekrar aÄ±mak iÃ§in {00FF00}/motorac");
    }
    return 1;
    }

    if(strcmp(cmd, "/farac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,VEHICLE_PARAMS_ON,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Far aÃ§Ä±ldÄ±, kapatmak iÃ§in {00FF00}/farkapat");
    }
    return 1;
    }

    if(strcmp(cmd, "/farkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,VEHICLE_PARAMS_OFF,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Far kapatÄ±ldÄ±, tekrar aÄ±mak iÃ§in {00FF00}/farac");
    }
    return 1;
    }

    if(strcmp(cmd, "/alarmac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,VEHICLE_PARAMS_ON,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Alarm aÃ§Ä±ldÄ±, kapatmak iÃ§in {00FF00}/alarmkapat");
    }
	return 1;
	}

    if(strcmp(cmd, "/alarmkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,VEHICLE_PARAMS_OFF,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Alarm kapatÄ±ldÄ±, tekrar almak iÃ§in {00FF00}/alarmac");
    }
    return 1;
    }

    if(strcmp(cmd, "/kaputac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,VEHICLE_PARAMS_ON,bagaj,objective);
    SendInfo(playerid,"Kaput aÃ§Ä±ldÄ±, kapatmak iÃ§in {00FF00}/kaputkapat");
    }
	return 1;
	}

    if(strcmp(cmd, "/kaputkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,VEHICLE_PARAMS_OFF,bagaj,objective);
    SendInfo(playerid,"Kaput kapatÄ±ldÄ±, tekrar almak iÃ§in {00FF00}/kaputac");
    }
    return 1;
    }

    if(strcmp(cmd, "/bagajac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,VEHICLE_PARAMS_ON,objective);
    SendInfo(playerid,"Bagaj aÃ§Ä±ldÄ±, kapatmak iÃ§in {00FF00}/bagajkapat");
    }
    return 1;
    }

    if(strcmp(cmd, "/bagajkapat",true) == 0) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Ä±Ä±fÄ±r koltuÄ±unda deÄ±ilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,VEHICLE_PARAMS_OFF,objective);
    SendInfo(playerid,"Bagaj kapatÄ±ldÄ±, tekrar almak iÃ§in {00FF00}/bagajac");
    }
    return 1;
    }

    if(!strcmp(cmdtext,"/kilit",true))
	{
	    if(!IsPlayerInAnyVehicle(playerid)) return 1;
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
	    if(Kilit[playerid] != 0) return 1;
	    Kilit[playerid] = 1;
	    Arac[playerid] = GetPlayerVehicleID(playerid);
	    SendInfo(playerid,"AraÃ§ kilitlendi, kilidi aÃ§mak iÃ§in {00FF00}/kilitac");
	    return 1;
	}

	if(!strcmp(cmdtext,"/kilitac",true))
	{
	    if(Kilit[playerid] != 1) return 1;
	    new Float:X, Float:Y, Float:Z;
	    GetVehiclePos(Arac[playerid],X,Y,Z);
	    if(IsPlayerInRangeOfPoint(playerid,5,X,Y,Z))
	    {
	        Kilit[playerid] = 0;

		    SendInfo(playerid,"Kilit aÃ§Ä±ldÄ±, aracÄ± kilitlemek iÃ§in {00FF00}/kilit");
		}
	    return 1;
	}

	// - AraÃ§ renk deÄ±iÄ±tirme komutu
	if(strcmp(cmd, "/renk", true) == 0)
	{
    if(IsPlayerInAnyVehicle(playerid))
    {
    new color1,color2,string[128];
    tmp=strtok(cmdtext,idx);
    if(!strlen(tmp) || !IsNumeric(tmp))
    {
    SendUse(playerid,"/renk {00FF00}[0-255] [0-255]");
    return 1;
	}
	color1=strval(tmp);
    tmp=strtok(cmdtext,idx);
    if(!strlen(tmp) || !IsNumeric(tmp))color2=color1;
	else color2=strval(tmp);
	if(color1<0 || color1>255 || color2<0 || color2>255)
	if(!strlen(tmp) || !IsNumeric(tmp))
    {
    SendUse(playerid,"/renk {00FF00}[0-255] [0-255]");
	return 1;
	}
 	ChangeVehicleColor(GetPlayerVehicleID(playerid),color1,color2);
    format(string,sizeof(string),"Ä± BÄ±LGÄ±: {FFFFFF}AraÃ§ rengi deÄŸiÅŸtirildi. [{009BFF}%d/%d{FFFFFF}]",color1,color2);
    SendClientMessage(playerid, 0x00A2F6AA,string);
    }
    else SendError(playerid,"AraÃ§ta deÄ±ilsiniz.");
    return 1;
	}

    // - Skin deÄ±iÄ±tirme komutu
    if(strcmp(cmdtext, "/myskin", true) == 7 || strcmp(cmdtext, "/skin", true) == 7)
    {
	if(cmdtext[7] != ' ' || cmdtext[8] == EOS)
	return SendUse(playerid,"/myskin [id]");
	if ((cmdtext[0] < 0) || (cmdtext[0] > 299)) return SendError(playerid,"Girilen deÄ±er geÄ±ersiz!");
	if(IsValidSkin((cmdtext[0] = strval(cmdtext[8]))))
	SetPlayerSkin(playerid, cmdtext[0]);
	else
	SendError(playerid,"Girilen deÄ±er geÄ±ersiz!");
	return 1;
    }

	// - DM alanÄ± komutlarÄ±
	if(!strcmp(cmdtext, "/deagledm1",true))
	{
	new State = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
    GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
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
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
    GivePlayerWeapon(playerid,24,99999);
    SetPlayerTeam(playerid, NO_TEAM);
    return 1;
    }

    if(!strcmp(cmdtext, "/fistdm1",true))
    {
    new State = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
    {
    GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
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
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
    SetPlayerTeam(playerid, NO_TEAM);
    return 1;
    }

	// - 31 sistemi komutlarÄ±
    if(!strcmp("/31",cmd,true))
    {
    tmp=strtok(cmdtext,idx);

    if(!strlen(tmp)) return SendUse(playerid,"/31 [cek/birak]");

    if(!strcmp("cek",tmp,true))
    {
    if(cekiyor[playerid] == 1) return SendError(playerid,"Zaten 31 Ä±ekmektesiniz.");
   	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
   	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
    asilantimer = SetTimerEx("asilanadamtimer", 19000,false,"i",playerid);
   	cekiyor[playerid] = 1;
   	return 1;
   	}

	if(!strcmp("birak",tmp,true))
	{
   	if(cekiyor[playerid] == 0) return SendError(playerid,"Zaten 31 Ä±ekmiyorsunuz.");
    SendInfo(playerid,"ArtÄ±k 31 Ä±ekmiyorsunuz.");
    ClearAnimations(playerid);
   	KillTimer(asilantimer);
    cekiyor[playerid] = 0;
    return 1;
   	}
    return 1;
    }
	// - Para gÄ±nderme komutu
	if(!strcmp("/paraver",cmd,true))
	{
	    tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendUse(playerid,"/paraver {00FF00}[id][miktar]");
		new id=strval(tmp);
		if(!IsPlayerConnected(id)) return SendError(playerid,"Oyuncu oyunda {FF0000}bulunmuyor!");
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendUse(playerid,"/paraver {00FF00}[id][miktar]");
		new miktar=strval(tmp);

		if(miktar < 0) return SendError(playerid,"Girilen miktar {FF0000}geÄ±ersiz!");
		if(GetPlayerMoney(playerid) < miktar) return SendError(playerid,"ParanÄ±z {FF0000}yetersiz!");

		GivePlayerMoney(playerid,-miktar);
		GivePlayerMoney(id,miktar);
		return 1;
	}

	// - SÄ±rÄ±Ä± kamerasÄ± komutu
    if (strcmp("/surus", cmdtext, true, 10) == 0)
    {
    if(!IsPlayerInAnyVehicle(playerid)) return SendError(playerid,"Arabada olmalÄ±sÄ±nÄ±z!");
    if(GetPVarInt(playerid,"used") == 0)
    {
    new p = GetPlayerVehicleID(playerid);
    Surus[playerid] = CreatePlayerObject(playerid,19300, 0.0000, -1282.9984, 10.1493, 0.0000, -1, -1, 100);
    AttachPlayerObjectToVehicle(playerid,Surus[playerid],p,-0.314999, -0.195000, 0.510000, 0.000000, 0.000000, 0.000000);
    AttachCameraToPlayerObject(playerid,Surus[playerid]);
    SetPVarInt(playerid,"used",1);
    SendInfo(playerid,"KamerayÄ± eski haline dÄ±ndÄ±rmek iÃ§in {00FF00}/surus {FFFFFF}yazÄ±nÄ±z.");
    }
    else if(GetPVarInt(playerid,"used") == 1)
    {
    SetCameraBehindPlayer(playerid);
    DestroyPlayerObject(playerid,Surus[playerid]);
    SetPVarInt(playerid,"used",0);
    SendInfo(playerid,"Kamera eski haline dÄ±ndÄ±rÄ±ldÄ±."); }
    return 1;
    }

	// - IÄ±Ä±nlanma komutlarÄ±
	if(strcmp(cmdtext, "/4dragon", true) == 0 || strcmp(cmdtext, "/dragon", true) == 0 || strcmp(cmdtext, "/4d", true) == 0)
	{
    Teleport(playerid,2027.8171,1008.1444,10.8203,0,0,"Four Dragon Casino","/4d",1,0);
    SendInfo(playerid,"{ACDA00}Four Dragon Casino {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext, "/dag", true) == 0 || strcmp(cmdtext, "/chilliad", true) == 0)
	{
	Teleport(playerid,-2353.0940,-1633.6820,483.6954,0,0,"Chilliad Mountain","/dag",1,0);
	SendInfo(playerid,"{ACDA00}Chilliad Mountain {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext, "/sahil", true) == 0)
	{
    Teleport(playerid,369.8283,-1787.7871,5.3585,0,0,"Santa Maria Beach","/sahil",1,0);
	SendInfo(playerid,"{ACDA00}Santa Maria Beach {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext, "/area51", true) == 0)
	{
	Teleport(playerid,231.5036,1914.3851,17.6406,0,0,"Area51","/area51",1,0);
	SendInfo(playerid,"{ACDA00}Area51 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext, "/china", true) == 0)
	{
	Teleport(playerid,-2276.2874,718.5117,49.4453,0,0,"China Town","/china",1,0);
	SendInfo(playerid,"{ACDA00}China Town {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

    if(strcmp(cmdtext, "/flores", true) == 0)
	{
	Teleport(playerid,2786.9534,-1319.9723,34.7975,0,0,"Los Flores","/flores",1,0);
	SendInfo(playerid,"{ACDA00}Los Flores {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext, "/mod1", true) == 0)
	{
	Teleport(playerid,-1917.2754,287.0215,41.0469,0,0,"Modifiye Yeri 1","/mod1",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 1 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext,"/mod2", true) == 0)
	{
	Teleport(playerid,-2705.5503, 206.1621,4.1797,0,0,"Modifiye Yeri 2","/mod2",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 2 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext,"/mod3", true) == 0)
	{
	Teleport(playerid,2387.4126,1022.6620,10.8203,0,0,"Modifiye Yeri 3","/mod3",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 3 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	return 1;
	}

	if(strcmp(cmdtext,"/mod4", true) == 0)
	{
	Teleport(playerid,2644.7686,-2019.1096,13.5507,0,0,"Modifiye Yeri 4","/mod4",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 4 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
 	return 1;
	}

	if(strcmp(cmdtext,"/mod5", true) == 0)
	{
	Teleport(playerid,1042.0564,-1045.5176,31.8108,0,0,"Modifiye Yeri 5","/mod5",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 5 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
 	return 1;
	}

	if(strcmp(cmdtext,"/ap1", true) == 0)
	{
	Teleport(playerid,1686.7,-2450.2,13.6,0,0,"Airport 1","/ap1",1,0);
	SendInfo(playerid,"{ACDA00}Airport 1 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
 	return 1;
	}

	if(strcmp(cmdtext,"/ap2", true) == 0)
	{
	Teleport(playerid,-1345.0, -229.8,14.1,0,0,"Airport 2","/ap2",1,0);
	SendInfo(playerid,"{ACDA00}Airport 2 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
 	return 1;
	}

	if(strcmp(cmdtext,"/ap3", true) == 0)
	{
	Teleport(playerid,1435.5, 1463.2,10.8,0,0,"Airport 3","/ap3",1,0);
	SendInfo(playerid,"{ACDA00}Airport 3 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
 	return 1;
	}

	if(strcmp(cmdtext,"/ap4", true) == 0)
	{
	Teleport(playerid,350.7, 2539.2,16.8,0,0,"Airport 4","/ap4",1,0);
	SendInfo(playerid,"{ACDA00}Airport 4 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
 	return 1;
	}

	// - Can & ZÄ±rh komutlarÄ±
	if(strcmp(cmdtext, "/can", true) == 0 || strcmp(cmdtext, "/health", true) == 0)
    {
    if(GetPVarInt(playerid, "SpamKoruma") > GetTickCount()) return SendInfo(playerid,"Komutu tekrar kullanmak iÃ§in 30 saniye bekleyiniz.");
    SetPVarInt(playerid, "SpamKoruma", GetTickCount() + 30000);
    if(GetPlayerMoney(playerid) < 750)
    return SendError(playerid,"ParanÄ±z {FF0000}yetersiz!");
    SetPlayerHealth(playerid,100);
    GivePlayerMoney(playerid,-750);
    SendInfo(playerid,"Can paketi {00FF00}baÄ±arÄ±yla {FFFFFF}alÄ±ndÄ±. [750$]");
    return 1;
    }

    if (strcmp(cmdtext, "/yelek", true)==0 || strcmp(cmdtext, "/zirh", true)==0)
    {
    if(GetPVarInt(playerid, "SpamKoruma1") > GetTickCount()) return SendInfo(playerid,"Komutu tekrar kullanmak iÃ§in 30 saniye bekleyiniz.");
    SetPVarInt(playerid, "SpamKoruma1", GetTickCount() + 30000);
    if(GetPlayerMoney(playerid) < 1000)
    return SendError(playerid,"ParanÄ±z {FF0000}yetersiz!");
    SetPlayerArmour(playerid,100);
    GivePlayerMoney(playerid,-1000);
    SendInfo(playerid,"ZÄ±rh paketi {00FF00}baÄ±arÄ±yla {FFFFFF}alÄ±ndÄ±. [1000$]");
    return 1;
    }

	// - FPS komutlarÄ±
	if (strcmp("/firstperson", cmdtext, true, 10) == 0)
	{
	    firstperson[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
     	AttachObjectToPlayer(firstperson[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
	    AttachCameraToObject(playerid, firstperson[playerid]);
	    SendInfo(playerid,"KamerayÄ± eski hale dÄ±ndÄ±rmek iÃ§in {00FF00}/exitfirstperson {FFFFFF}yazÄ±nÄ±z.");
		return 1;
	}
	if (strcmp("/exitfirstperson", cmdtext, true, 10) == 0)
	{
	    SetCameraBehindPlayer(playerid);
        DestroyObject(firstperson[playerid]);
		return 1;
	}

	// - AraÃ§ Ä±evirme komutu
	if(strcmp(cmdtext,"/cevir",true)==0)
	{
	if(IsPlayerInAnyVehicle(playerid))
	{
	new VehicleID,Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	VehicleID = GetPlayerVehicleID(playerid);
	SetVehiclePos(VehicleID,X,Y,Z);
	SetVehicleZAngle(VehicleID,0);
	SendInfo(playerid,"ArabanÄ±z {00FF00}baÄ±arÄ±yla {FFFFFF}Ä±evrildi.");
	} else {
	SendError(playerid,"Arabada {FF0000}deÄ±ilsiniz!");
	}
	return 1;
	}

	// - AraÃ§ spawn komutu
    if(!strcmp(cmdtext, "/v", true, 2))
        {
                if(cmdtext[2] == EOS)
                        return 0;

                new
                        iList = strval(cmdtext[2]) - 1
                ;
                if(0 <= iList <= 17)
                {
                        static
                                s_szName[24],
                                s_szVehDialog[256]
                        ;
                        s_szVehDialog = "";

                        for(new i = (iList * 12), j = ((iList + 1) * 12); i < j; ++i)
                        {
                                if(i >= sizeof(g_VehNames))
                                        break;

                                strunpack(s_szName, g_VehNames[i]);
                                strcat(s_szVehDialog, s_szName);
                                strcat(s_szVehDialog, "\n");
                        }
                        ShowPlayerDialog(playerid, (DIALOG_OFFSET_ID + iList), DIALOG_STYLE_LIST, "Arac Listesi", s_szVehDialog, "Spawn", "Kapat");
                        SetPVarInt(playerid, "iList", iList);

                        return 1;
                }
                return 0;
        }

	// - Modifiyeli AraÃ§ spawn komutlarÄ±
	if(strcmp(cmdtext, "/m1", true)==0) // Sultan
	{
        new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=LVehicleIDt;
        MCarPlayerInfo[playerid][pMAraba]=1;
        AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,1);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m2", true)==0)	{ //Sultan
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=LVehicleIDt;
        MCarPlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,2);
        SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
    	return 1;	}
	if(strcmp(cmdtext, "/m3", true)==0)	{ // Jester
        new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(559,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(carid,1065);    AddVehicleComponent(carid,1067);    AddVehicleComponent(carid,1162); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);	ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m4", true)==0)	{ // Flash
     	new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(565,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(carid,1046); AddVehicleComponent(carid,1049); AddVehicleComponent(carid,1053); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m5", true)==0)	{ // Uranus
	    new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
        AddVehicleComponent(carid,1088); AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1139); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
 	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
    if(strcmp(cmdtext, "/m6", true)==0)	{ // Stratum
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(561,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
    	AddVehicleComponent(carid,1055); AddVehicleComponent(carid,1058); AddVehicleComponent(carid,1064); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
    if(strcmp(cmdtext, "/m7", true)==0)	{ // Elegy
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
	    AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m8", true)==0)	{ // Savanna
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(567,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
	    AddVehicleComponent(carid,1102); AddVehicleComponent(carid,1129); AddVehicleComponent(carid,1133); AddVehicleComponent(carid,1186); AddVehicleComponent(carid,1188); ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1085); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1086);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m9", true)==0)	{ // Uranus
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
   		AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1166); AddVehicleComponent(carid,1165); AddVehicleComponent(carid,1090);
	    AddVehicleComponent(carid,1094); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1163);
	    AddVehicleComponent(carid,1091); ChangeVehiclePaintjob(carid,2);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
	if(strcmp(cmdtext, "/m10", true)==0)	{ // Monster
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(557,X,Y,Z,Angle,1,1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1081);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
	if(strcmp(cmdtext, "/m11", true)==0)	{ // Slamvan
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(535,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
		ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1109); AddVehicleComponent(carid,1115); AddVehicleComponent(carid,1117); AddVehicleComponent(carid,1073); AddVehicleComponent(carid,1010);
	    AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1114); AddVehicleComponent(carid,1081); AddVehicleComponent(carid,1119); AddVehicleComponent(carid,1121);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
	if(strcmp(cmdtext, "/m12", true)==0)	{ // Elegy
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
  		AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;   }
	if(strcmp(cmdtext, "/nrg", true)==0)	{ // NRG
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(522,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(MCarPlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(MCarPlayerInfo[playerid][pMArabaID]);
        MCarPlayerInfo[playerid][pMArabaID]=carid;
        MCarPlayerInfo[playerid][pMAraba]=1;
  		ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;   }

	// - Ev sistemi komutlarÄ±
	if (strcmp("/evmenu", cmdtext, true, 10) == 0)
	{
		if(!IsPlayerAdmin(playerid)) return Mesaj(playerid,"Bu komutu kullanmak iÃ§in gerekli izniniz yok!");
		if(GetPlayerInterior(playerid) != 0) return Mesaj(playerid,"Ev yaratmak iÃ§in interior dÄ±Ä±Ä±nda olmalÄ±sÄ±nÄ±z!");
		if(Kontrol(playerid))
		{
		    if(EvEditleniyor[GetHouseID(playerid)] == true) return Mesaj(playerid,"Ä±u anda bu evi baÄ±ka bir kiÄ±i dÄ±zenliyor...");
		    EvEditleniyor[GetHouseID(playerid)] = true;
		    ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
		}
		else
		{
		    ShowPlayerDialog(playerid,DIALOG+1,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Yeni Ev Yarat","SeÄ±","Ä±ptal");
		}
		return 1;
	}

	if (strcmp("/ev", cmdtext, true, 10) == 0)
	{
	    new dosya[64];
	    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",OyuncuEv[playerid]);
		if(OyuncuEv[playerid] == -1) return Mesaj(playerid,"Ä±uanda evde deÄ±ilsin!");
	    else if(EvEditleniyor[OyuncuEv[playerid]] == true) return Mesaj(playerid,"Ä±u anda bu evi baÄ±ka bir kiÄ±i dÄ±zenliyor...");
		else if(IsPlayerAdmin(playerid)) Mesaj(playerid,"Rcon admin bypass aktif!");
		else if(EvSahipID[OyuncuEv[playerid]] != playerid) return Mesaj(playerid,"Bu ev size ait deÄ±il!");
		EvEditleniyor[OyuncuEv[playerid]] = true;
		ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
		return 1;
	}

	if (strcmp("/satinal", cmdtext, true, 10) == 0)
	{
		if(Kontrol(playerid))
		{
	        new evid = GetHouseID(playerid);
		    if(EvSahipID[evid] != -1) return Mesaj(playerid,"Bu evin zaten bir sahibi var, lÄ±tfen satÄ±lÄ±k ev seÄ±iniz!");
	        new str[256];
		    format(str,sizeof(str),"{00FF7F}Ev AÄ±Ä±klamasÄ±: {c0c0c0}%s\n{00FF7F}Ev FiyatÄ±: {c0c0c0}%i$\n\n{CD5C5C}Bu evi satÄ±n almak istiyor musunuz ?",EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat]);
			ShowPlayerDialog(playerid,SATINAL,DIALOG_STYLE_MSGBOX,BASLIK,str,"SatÄ±n Al","Ä±ptal");
		} else Mesaj(playerid,"Herhangi bir evin Ä±stÄ±nde deÄ±ilsiniz!");
		return 1;
	}
	return SendError(playerid,"Komut bulunamadÄ±!");
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(vehicleid == Arac[playerid] && Kilit[playerid] == 1)
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
	if(pickupid==hizlandirici[1]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[1]);
	hizlandirici[1]=CreatePickup(1313,14,2048.6716,1015.3157,10.6719,0);
	}
	if(pickupid==hizlandirici[2]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[2]);
	hizlandirici[2]=CreatePickup(1313,14,2066.5132,1019.7257,10.6719,0);
	}
	if(pickupid==hizlandirici[3]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[3]);
	hizlandirici[3]=CreatePickup(1313,14,2066.5918,1254.1406,10.6719,0);
	}
	if(pickupid==hizlandirici[4]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[4]);
	hizlandirici[4]=CreatePickup(1313,14,2048.8401,1284.9427,10.6719,0);
	}
	if(pickupid==hizlandirici[5]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[5]);
	hizlandirici[5]=CreatePickup(1313,14,2121.1084,1847.6072,10.6719,0);
	}
	if(pickupid==hizlandirici[6]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[6]);
	hizlandirici[6]=CreatePickup(1313,14,2146.4421,1874.5963,10.6719,0);
	}
	if(pickupid==hizlandirici[7]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[7]);
	hizlandirici[7]=CreatePickup(1313,14,2128.2676,2219.6204,10.6719,0);
	}
	if(pickupid==hizlandirici[8]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[8]);
	hizlandirici[8]=CreatePickup(1313,14,2229.9316,2555.6431,10.8203,0);
	}
	if(pickupid==hizlandirici[9]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[9]);
	hizlandirici[9]=CreatePickup(1313,14,1964.1276,2593.7170,10.8126,0);
	}
	if(pickupid==hizlandirici[10]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[10]);
	hizlandirici[10]=CreatePickup(1313,14,-2084.9065,-1967.6328,378.5436,0); //
	}
	if(pickupid==hizlandirici[11]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[11]);
	hizlandirici[11]=CreatePickup(1313,14,2048.4058,815.1559,8.4697,0); //
	}
	if(pickupid==hizlandirici[12]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[12]);
	hizlandirici[12]=CreatePickup(1313,14,2364.7070,433.8943,17.6082,0);
	}
	if(pickupid==hizlandirici[13]){
	if(IsPlayerInAnyVehicle(playerid)){
	new Float:vx, Float:vy, Float:vz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
	if (floatabs(vx) < HIZ_VER && floatabs(vy) < HIZ_VER && floatabs(vz) < HIZ_VER)
	{
	SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * HIZ_VER, vy * HIZ_VER, vz * HIZ_VER);
	}
	}
	DestroyPickup(hizlandirici[13]);
	hizlandirici[13]=CreatePickup(1313,14,1294.1956,2598.3647,11.9492,0);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// - 2 tuÄ±u fonksiyonu
	if(newkeys & KEY_LOOK_BEHIND && IsPlayerInAnyVehicle(playerid))
	{
    	if(!IsNosVehicle(GetPlayerVehicleID(playerid))) return RepairVehicle(GetPlayerVehicleID(playerid)),PlayerPlaySound(playerid, 1133 ,0, 0, 0),GameTextForPlayer(playerid,"~b~~h~Full Tamir",500,5);
    	AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		PlayerPlaySound(playerid, 1133 ,0, 0, 0);
		RepairVehicle(GetPlayerVehicleID(playerid));
		GameTextForPlayer(playerid,"~g~10x Nitro ~w~~h~& ~b~~h~Tamir",500,5);
	}


	// - Ev sistemi ayarlarÄ±
    if(PRESSED(16))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			new evid = GetHouseID(playerid);
		    if(Kontrol(playerid))
		    {
			    new dosya[64];
			    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",OyuncuEv[playerid]);
		        if(IsPlayerAdmin(playerid)) Mesaj(playerid,"Rcon admin bypass aktif!");
				else if(EvSahipID[evid] == playerid) Mesaj(playerid,"Evinize hoÄ±geldiniz!"),Mesaj(playerid,"Evinizi dÄ±zenlemek veya ayarlarÄ±na girmek iÃ§in '{008080}/ev{FFFFFF}' komutunu kullanÄ±nÄ±z.");
		        else if(EvBilgi[evid][evkilit] == 1) return Mesaj(playerid,"Bu ev kilitli, kilitli evlere giremezsiniz.");
		        if(EvBilgi[evid][evint] == 0) PlayerPos(playerid,235.1575,1187.2721,1080.2578,3,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 1) PlayerPos(playerid,225.756989 ,1240.000000 ,1082.149902 ,2,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 2) PlayerPos(playerid,225.630997,1022.479980,1084.069946,7,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 3) PlayerPos(playerid,295.2057,1472.9973,1080.2578,15,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 4) PlayerPos(playerid,327.9004,1478.2839,1084.4375,15,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 5) PlayerPos(playerid,2324.3735,-1148.8219,1050.7101,12,EvBilgi[evid][evworld]);
		        OyuncuEv[playerid] = evid;
		    }
		    else if(IsPlayerInRangeOfPoint(playerid,2,235.1575,1187.2721,1080.2578) ||
			IsPlayerInRangeOfPoint(playerid,2,225.756989,1240.000000,1082.149902) ||
			IsPlayerInRangeOfPoint(playerid,2,225.630997,1022.479980,1084.069946) ||
			IsPlayerInRangeOfPoint(playerid,2,295.2057,1472.9973,1080.2578) ||
			IsPlayerInRangeOfPoint(playerid,2,327.9004,1478.2839,1084.4375) ||
			IsPlayerInRangeOfPoint(playerid,2,2324.3735,-1148.8219,1050.7101))


						{ PlayerPos(playerid,EvBilgi[OyuncuEv[playerid]][ev_X],EvBilgi[OyuncuEv[playerid]][ev_Y],EvBilgi[OyuncuEv[playerid]][ev_Z],0,0),OyuncuEv[playerid] = -1; }
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	// - EXP sistemi
	new str[64];
	format(str, sizeof(str), "EXP:%d/1000 - Level:%d/50", exp[playerid], seviye[playerid]);
	TextDrawSetString(expmeter[playerid], str);
	//SetProgressBarValue(Bar:expbar[playerid],exp[playerid]);
	// - Ev sistemi ayarlarÄ±
    if(Kontrol(playerid))
	{
		OyuncuKontrolEv[playerid]=GetHouseID(playerid);
	}

	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	// - Silahlar menÄ±sÄ± dialoglarÄ±
	if(dialogid == 9500)
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PompalÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 4)
	{
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 5)
	{
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PatlayÄ±cÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 6)
	{
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9501) // Tabancalar.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,22,200,"Colt .45",500);
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,23,200,"Susturuculu Colt .45",700);
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	SilahSat(playerid,24,200,"Desert Eagle",1200);
	ShowPlayerDialog(playerid,9501,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Colt .45\t\t\t{FFFFFF}500$\n{FFFFFF}~ {ACDA00}Colt .45 & susturucu\t\t{FFFFFF}800$\n{FFFFFF}~ {ACDA00}Desert Eagle .50\t\t{FFFFFF}1200$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9502) // Otomatik tabancalar.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,28,200,"Micro Uzi",1250);
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,32,200,"TEC-9",1700);
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	SilahSat(playerid,29,200,"MP-5",2300);
	ShowPlayerDialog(playerid,9502,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Oto. tabancalar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Micro Uzi\t\t\t{FFFFFF}1250$\n{FFFFFF}~ {ACDA00}TEC-9\t\t\t{FFFFFF}1700$\n{FFFFFF}~ {ACDA00}MP-5\t\t\t\t{FFFFFF}2300$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9503) // PompalÄ± tÄ±fekler.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PompalÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,25,200,"Pump-Action Shotgun",3000);
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PompalÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,26,200,"Double-Barrel Shotgun",4600);
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PompalÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	SilahSat(playerid,27,200,"Combat Shotgun",6500);
	ShowPlayerDialog(playerid,9503,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PompalÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Pump-Action Shotgun\t\t{FFFFFF}3000$\n{FFFFFF}~ {ACDA00}Double-Barrel Shotgun\t{FFFFFF}4600$\n{FFFFFF}~ {ACDA00}Combat Shotgun\t\t{FFFFFF}6500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9504) // Makineli tÄ±fekler.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,31,200,"M4A1 Carbine",9500);
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,30,200,"Avtomat Kalashnikova 47",7500);
	ShowPlayerDialog(playerid,9504,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Mak. TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}M4A1 Carbine\t\t\t{FFFFFF}9500$\n{FFFFFF}~ {ACDA00}Avtomat Kalashnikova 47\t{FFFFFF}7500$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9505) // Yivli tÄ±fekler.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,33,200,"Country Rifle .22",6700);
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,34,200,"Sniper Rifle",9750);
	ShowPlayerDialog(playerid,9505,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Yivli TÄ±fekler","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Country Rifle .22\t\t{FFFFFF}6700$\n{FFFFFF}~ {ACDA00}Sniper Rifle\t\t\t{FFFFFF}9750$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9506) // PatlayÄ±cÄ±lar.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PatlayÄ±cÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,16,1,"Grenade",600);
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PatlayÄ±cÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,17,1,"Gas Grenade",250);
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PatlayÄ±cÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	SilahSat(playerid,18,1,"Molotov",700);
	ShowPlayerDialog(playerid,9506,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} PatlayÄ±cÄ±lar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{FFFFFF}~ {ACDA00}Grenade [1x]\t\t\t{FFFFFF}600$\n{FFFFFF}~ {ACDA00}Gas Grenade [1x]\t\t{FFFFFF}250$\n{FFFFFF}~ {ACDA00}Molotov [1x]\t\t\t{FFFFFF}700$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 4)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}

	if(dialogid == 9507) // AteÄ±siz silahlar.
	{
	if(response)
	{
	if(listitem == 0)
	{
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 1)
	{
	SilahSat(playerid,1,1,"Brass Knuckles",50);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 2)
	{
	SilahSat(playerid,5,1,"Baseball Bat",100);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 3)
	{
	SilahSat(playerid,2,1,"Golf Club",120);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 4)
	{
	SilahSat(playerid,4,1,"Knife",250);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 5)
	{
	SilahSat(playerid,41,1200,"Spray",300);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 6)
	{
	SilahSat(playerid,42,5500,"Fire Extinguisher",450);
	ShowPlayerDialog(playerid,9507,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} AteÄ±siz Silahlar","{009BFF}SÄ±LAH ADI\t\t\tSÄ±LAH FÄ±YATI\n{ACDA00}~ Brass Knuckles\t\t{FFFFFF}50$\n{ACDA00}~ Baseball Bat\t\t\t{FFFFFF}100$\n{ACDA00}~ Golf Club\t\t\t{FFFFFF}1200$\n{ACDA00}~ Knife\t\t\t\t{FFFFFF}250$\n{ACDA00}~ Spray\t\t\t{FFFFFF}300$\n{ACDA00}~ Fire Extinguisher\t\t{FFFFFF}450$\n{009BFF}~ Geri dÄ±n.","SeÄ±","Kapat");
	}
	if(listitem == 7)
	{
	ShowPlayerDialog(playerid,9500,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme /{009BFF} Silah MenÄ±sÄ±","{FFFFFF}~ {ACDA00}Tabancalar\n{FFFFFF}~ {ACDA00}Otomatik tabancalar\n{FFFFFF}~ {ACDA00}PompalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}MakinalÄ± tÄ±fekler\n{FFFFFF}~ {ACDA00}Yivli tÄ±fekler\n{FFFFFF}~ {ACDA00}PatlayÄ±cÄ±lar\n{FFFFFF}~ {ACDA00}AteÄ±siz silahlar","SeÄ±","Kapat");
	}
	}
	}
	// - Teles alanlarÄ± dialoglarÄ±
	if(dialogid == 1000)
	{
	if(response)
	{
	if(listitem == 0)
	{
    Teleport(playerid,2027.8171,1008.1444,10.8203,0,0,"Four Dragon Casino","/4d",1,0);
    SendInfo(playerid,"{ACDA00}Four Dragon Casino {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 1)
	{
    Teleport(playerid,-2353.0940,-1633.6820,483.6954,0,0,"Chilliad Mountain","/dag",1,0);
	SendInfo(playerid,"{ACDA00}Chilliad Mountain {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 2)
	{
    Teleport(playerid,369.8283,-1787.7871,5.3585,0,0,"Santa Maria Beach","/sahil",1,0);
	SendInfo(playerid,"{ACDA00}Santa Maria Beach {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 3)
	{
    Teleport(playerid,231.5036,1914.3851,17.6406,0,0,"Area51","/area51",1,0);
	SendInfo(playerid,"{ACDA00}Area51 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 4)
	{
    Teleport(playerid,-2276.2874,718.5117,49.4453,0,0,"China Town","/china",1,0);
	SendInfo(playerid,"{ACDA00}China Town {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 5)
	{
    Teleport(playerid,2786.9534,-1319.9723,34.7975,0,0,"Los Flores","/flores",1,0);
	SendInfo(playerid,"{ACDA00}Los Flores {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 6)
	{
	Teleport(playerid,-1917.2754,287.0215,41.0469,0,0,"Modifiye Yeri 1","/mod1",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 1 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 7)
	{
	Teleport(playerid,-2705.5503, 206.1621,4.1797,0,0,"Modifiye Yeri 2","/mod2",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 2 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 8)
	{
	Teleport(playerid,2387.4126,1022.6620,10.8203,0,0,"Modifiye Yeri 3","/mod3",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 3 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 9)
	{
	Teleport(playerid,2644.7686,-2019.1096,13.5507,0,0,"Modifiye Yeri 4","/mod4",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 4 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 10)
	{
	Teleport(playerid,1042.0564,-1045.5176,31.8108,0,0,"Modifiye Yeri 5","/mod5",1,0);
	SendInfo(playerid,"{ACDA00}Modifiye Yeri 5 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 11)
	{
	Teleport(playerid,1686.7,-2450.2,13.6,0,0,"Airport 1","/ap1",1,0);
	SendInfo(playerid,"{ACDA00}Airport 1 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 12)
	{
	Teleport(playerid,-1345.0, -229.8,14.1,0,0,"Airport 2","/ap2",1,0);
	SendInfo(playerid,"{ACDA00}Airport 2 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 13)
	{
	Teleport(playerid,1435.5, 1463.2,10.8,0,0,"Airport 3","/ap3",1,0);
	SendInfo(playerid,"{ACDA00}Airport 3 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	if(listitem == 14)
 {
	Teleport(playerid,350.7, 2539.2,16.8,0,0,"Airport 4","/ap4",1,0);
	SendInfo(playerid,"{ACDA00}Airport 4 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	}
	}
	}

	// - Changelog dialoglarÄ±
	if(dialogid == 1911)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1912,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.1]","{ACDA00}~ Textdrawlar dÄ±zenlendi.\n~ Teles menÄ±sÄ± gÄ±ncellendi. {FFFFFF}(4 yeni teleport alanÄ±){ACDA00}\n~ Admin sistemi dÄ±zenlendi.\n~ YardÄ±m menÄ±sÄ± dÄ±zenlendi.\n~ \"Desert Eagle Deathmatch\" alanÄ± eklendi.\n~ Ä±lÄ±m-Ä±ldÄ±rme gÄ±stergesi eklendi.\n~ /skin komutu eklendi.\n~ /renk komutu eklendi.\n~ Ufak buglar giderildi.\n~ DM sistemi eklendi.","RC1.2","Kapat");
	}
	}

	if(dialogid == 1912)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1913,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.2]","{ACDA00}~ Ufak buglar giderildi.\n~ \"Fight Club Deathmatch\" alanÄ± eklendi.\n~ Eksik haritalar gÄ±ncellendi.\n~ \"Bikepark Stunt 1\" alanÄ± eklendi.\n~ /nrg komutu eklendi.\n~ AraÃ§ yÄ±netim komutlarÄ± eklendi.\n~ Website eklendi. {FFFFFF}(trinity.immortal-official.tk){ACDA00}\n~ Textdraw kaymalarÄ± dÄ±zeltildi.\n~ Gametext sÄ±releri dÄ±Ä±Ä±rÄ±ldÄ±.\n~ GiriÄ± dÄ±zenlendi.","RC1.3","Kapat");
	}
	}

	if(dialogid == 1913)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1914,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.3]","{ACDA00}~ ALPHA hesaplarÄ± silindi.\n~ Kick-Ban mesajlarÄ± ve GiriÄ±-Ä±Ä±kÄ±Ä± mesajlarÄ± gÄ±ncellendi.\n~ AraÃ§ Kilit Sistemi eklendi. {FFFFFF}(/kilit - /kilitac){ACDA00}\n~ 31 sistemi bugu giderildi.\n~ Ufak buglar giderildi.\n~ Changelog dÄ±zenlendi.\n~ Yeni haritalar eklendi.\n~ GeliÄ±miÄ± saat sistemi eklendi.\n~ RGM-GM sistemi buglarÄ± giderildi.\n~ Sohbet baloncuÄ±u eklendi.\n~ Driveby engeli kaldÄ±rÄ±ldÄ±.","RC1.4","Kapat");
	}
	}

	if(dialogid == 1914)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1915,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.4]","{ACDA00}~ EXP-LEVEL sistemi eklendi.\n~ Ev sistemi gÄ±ncellendi.\n~ Ufak buglar giderildi.\n~ LAdmin gÄ±ncellendi. (4.4)\n~ Teleport komutlarÄ± dÄ±zenlendi.\n~ EXP-LEVEL textdrawÄ± yenilendi.\n~ Object Streamer eklendi.\n~ Modifiye alanlarÄ± ve Airport'lar iÃ§in teleport eklendi. {FFFFFF}(/teles)\n{ACDA00}~ Silahlar menÄ±sÄ± eklendi. {FFFFFF}(/silahlar)\n{ACDA00}~ aLAdmin sistemi eklendi.\n~ GiriÄ±e dans eklendi.","RC1.5","Kapat");
	}
	}
	
	if(dialogid == 1915)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1916,DIALOG_STYLE_MSGBOX,"Changelog / [ALPHA RC1.5]","{ACDA00}~ ","Kapat","");
	}
	}
	// - DM alanÄ± dialoglarÄ±
	if(dialogid == 2000)
	{
	if(response)
	{
	if(listitem == 0)
	{
    new State = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
    GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 5000, 1);
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
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
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
    GivePlayerWeapon(playerid,24,99999);
    SetPlayerTeam(playerid, NO_TEAM);
	}
	if(listitem == 1)
	{
    new State = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
    {
    GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 5000, 1);
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
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
    SendInfo(playerid,"Deathmatch alanÄ±ndan Ä±Ä±kmak iÃ§in {00FF00}/dmcik {FFFFFF}yazÄ±nÄ±z.");
    SetPlayerTeam(playerid, NO_TEAM);
	}
	}
	}

	// - Stunt dialoglarÄ±
	if(dialogid == 2001)
	{
	if(response)
	{
	if(listitem == 0)
	{
	SendInfo(playerid,"{00FF00}Bikepark Stunt - 1 {FFFFFF}alanÄ±na Ä±Ä±Ä±nlanÄ±ldÄ±.");
	SetPlayerPos(playerid,1165.3389,1344.6733,10.8125);
	}
	}
	}
	// AraÃ§ spawn ayarlarÄ±
    if(response)
    {
    new iList = GetPVarInt(playerid, "iList");

    if(dialogid == (DIALOG_OFFSET_ID + iList))
    {
    if(0 <= listitem <= 12)
    {
    new Float: fPos[3];

    if(GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]))
    {
    new iVehID = GetPVarInt(playerid, "iVehID"), Float: fAngle;

    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleZAngle(GetPlayerVehicleID(playerid), fAngle);
    else
    GetPlayerFacingAngle(playerid, fAngle);

    if(iVehID)
    DestroyVehicle(iVehID);

    iVehID = (listitem + (iList * 12) + 400);

    // - Yasak AraÃ§ ayarlarÄ±
    switch(iVehID)
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
	if(dialogid == SATINAL)
	{
	    if(!response) return 1;
	    if(response)
	    {
	        new evid = GetHouseID(playerid);
	        if(!Kontrol(playerid)) return Mesaj(playerid,"Evi satÄ±n almak iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
		    else if(EvSahipID[evid] != -1) return Mesaj(playerid,"Bu evin zaten bir sahibi var, lÄ±tfen satÄ±lÄ±k ev seÄ±iniz!");
			else if(EvBilgi[evid][evfiyat] > GetPlayerMoney(playerid)) return Mesaj(playerid,"Evi almak iÃ§in yeterli paranÄ±z bulunmamakta!");
			EvKaydetInt(evid,"evsatilik",0);
			EvKaydetStr(evid,"evsahip",PlayerName(playerid));
			EvYenile(evid);
			GivePlayerMoney(playerid,-EvBilgi[evid][evfiyat]);
			GameTextForPlayer(playerid,"~w~Ev basariyla~g~ satin alindi!",5000,5);
			PlayerPlaySound(playerid,1058, 0, 0, 0);
		}
	}

	if(dialogid == MENU)
	{
	    if(!response) EvEditleniyor[OyuncuEv[playerid]] = false;
	    if(response)
	    {
	        new str[256];
	        new evid = OyuncuEv[playerid];
			if(listitem == 0)
			{
			    format(str,sizeof(str),"{00FF7F}Ev AÄ±Ä±klamasÄ±: {c0c0c0}%s\n\n{CD5C5C}AÄ±Ä±klamayÄ± deÄ±iÄ±tirmek iÃ§in yenisini aÄ±aÄ±Ä±ya yazÄ±nÄ±z.",EvBilgi[evid][evaciklama]);
				ShowPlayerDialog(playerid,MENU+1,DIALOG_STYLE_INPUT,BASLIK,str,"DeÄ±iÄ±tir","Ä±ptal");
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid,MENU+2,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Kilidi AÄ±\n{FF4500}Kilitle","Ayarla","Ä±ptal");
			}
			if(listitem == 2)
			{
			    format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut ParanÄ±z: {c0c0c0}%i$\n\n{CD5C5C}LÄ±tfen gerÄ±ekleÄ±tirilcek iÄ±lemi seÄ±iniz.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+3,DIALOG_STYLE_MSGBOX,BASLIK,str,"YatÄ±r/Ä±ek","Ä±ptal");
			}
			if(listitem == 3)
			{
				format(str,sizeof(str),"{FF4500}Depodan Silah Al\n{FF4500}Depoya Elindeki SilahÄ± Koy");
				ShowPlayerDialog(playerid,MENU+8,DIALOG_STYLE_LIST,BASLIK,str,"SeÄ±","Ä±ptal");
			}
		}
	}

	if(dialogid == MENU+1)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
			if(!strlen(inputtext)) return Mesaj(playerid,"LÄ±tfen geÄ±erli bir yazÄ± giriniz.");
	        new evid = OyuncuEv[playerid];
			EvKaydetStr(evid,"evaciklama",inputtext);
			EvYenile(evid);
			Mesaj(playerid,"Ev aÄ±Ä±klamasÄ± deÄ±iÄ±tirildi.");
		    ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
		}
	}

	if(dialogid == MENU+2)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
			if(listitem == 0)
			{
			    EvKaydetInt(evid,"evkilit",0);
			    Mesaj(playerid,"Evin kilidini aÄ±tÄ±nÄ±z!");
			    EvYenile(evid);
			    ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
			}
			if(listitem == 1)
			{
			    EvKaydetInt(evid,"evkilit",1);
			    Mesaj(playerid,"Evi kilitlediniz!");
			    EvYenile(evid);
			    ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
			}
		}
	}

	if(dialogid == MENU+3)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
		    ShowPlayerDialog(playerid,MENU+4,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Para YatÄ±r\n{FF4500}Para Ä±ek","SeÄ±","Ä±ptal");
		}
	}

	if(dialogid == MENU+4)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new str[256];
	        new evid = OyuncuEv[playerid];
			if(listitem == 0)
			{
			    format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut ParanÄ±z: {c0c0c0}%i$\n\n{CD5C5C}LÄ±tfen kasaya yatÄ±rÄ±lcak miktarÄ± yazÄ±nÄ±z.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+5,DIALOG_STYLE_INPUT,BASLIK,str,"YatÄ±r","Ä±ptal");
			}
			if(listitem == 1)
			{
			    format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut ParanÄ±z: {c0c0c0}%i$\n\n{CD5C5C}LÄ±tfen kasadan Ä±ekilecek miktarÄ± yazÄ±nÄ±z.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+6,DIALOG_STYLE_INPUT,BASLIK,str,"Ä±ek","Ä±ptal");
			}

		}
	}

	if(dialogid == MENU+5)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
			if(!strlen(inputtext)) return Mesaj(playerid,"LÄ±tfen geÄ±erli bir rakam giriniz.");
			if(!strval(inputtext)) return Mesaj(playerid,"LÄ±tfen geÄ±erli bir rakam giriniz.");
			if(strval(inputtext) > GetPlayerMoney(playerid)) return Mesaj(playerid,"YazÄ±lan miktar sizde yeteri kadar bulunmuyor.");
			EvKaydetInt(evid,"evbanka",EvBilgi[evid][evbanka]+strval(inputtext));
			GivePlayerMoney(playerid,-strval(inputtext));
			EvYenile(evid);
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
		}
	}

	if(dialogid == MENU+6)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
			if(!strlen(inputtext)) return Mesaj(playerid,"LÄ±tfen geÄ±erli bir rakam giriniz.");
			if(!strval(inputtext)) return Mesaj(playerid,"LÄ±tfen geÄ±erli bir rakam giriniz.");
			if(strval(inputtext) > EvBilgi[evid][evbanka]) return Mesaj(playerid,"YazÄ±lan miktar kasanÄ±zda yeteri kadar bulunmuyor.");
			EvKaydetInt(evid,"evbanka",EvBilgi[evid][evbanka]-strval(inputtext));
			GivePlayerMoney(playerid,strval(inputtext));
			EvYenile(evid);
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
		}
	}

	if(dialogid == MENU+7)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
		}
	}

	if(dialogid == MENU+8)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
	        if(listitem == 0)
	        {
		        new s1 = EvBilgi[evid][silahslot1];
		        new s2 = EvBilgi[evid][silahslot2];
		        new s3 = EvBilgi[evid][silahslot3];
		        new s4 = EvBilgi[evid][silahslot4];
		        new s5 = EvBilgi[evid][silahslot5];
		        new s6 = EvBilgi[evid][silahslot6];
				new str[512],slot1[32],slot2[32],slot3[32],slot4[32],slot5[32],slot6[32];
				if(s1 == -1) slot1 = "Yok"; else slot1 = WeaponName(s1);
				if(s2 == -1) slot2 = "Yok"; else slot2 = WeaponName(s2);
				if(s3 == -1) slot3 = "Yok"; else slot3 = WeaponName(s3);
				if(s4 == -1) slot4 = "Yok"; else slot4 = WeaponName(s4);
				if(s5 == -1) slot5 = "Yok"; else slot5 = WeaponName(s5);
				if(s6 == -1) slot6 = "Yok"; else slot6 = WeaponName(s6);
				format(str,sizeof(str),
				"{FF4500}Slot 1: {FFFFFF}%s\n{FF4500}Slot 2: {FFFFFF}%s\n{FF4500}Slot 3: {FFFFFF}%s\n{FF4500}Slot 4: {FFFFFF}%s\n{FF4500}Slot 5: {FFFFFF}%s\n{FF4500}Slot 6: {FFFFFF}%s",slot1,slot2,slot3,slot4,slot5,slot6);
				ShowPlayerDialog(playerid,MENU+9,DIALOG_STYLE_LIST,BASLIK,str,"SeÄ±","Ä±ptal");
			}
	        if(listitem == 1)
	        {
		        new s1 = EvBilgi[evid][silahslot1];
		        new s2 = EvBilgi[evid][silahslot2];
		        new s3 = EvBilgi[evid][silahslot3];
		        new s4 = EvBilgi[evid][silahslot4];
		        new s5 = EvBilgi[evid][silahslot5];
		        new s6 = EvBilgi[evid][silahslot6];
				new str[512],slot1[32],slot2[32],slot3[32],slot4[32],slot5[32],slot6[32];
				if(s1 == -1) slot1 = "Yok"; else slot1 = WeaponName(s1);
				if(s2 == -1) slot2 = "Yok"; else slot2 = WeaponName(s2);
				if(s3 == -1) slot3 = "Yok"; else slot3 = WeaponName(s3);
				if(s4 == -1) slot4 = "Yok"; else slot4 = WeaponName(s4);
				if(s5 == -1) slot5 = "Yok"; else slot5 = WeaponName(s5);
				if(s6 == -1) slot6 = "Yok"; else slot6 = WeaponName(s6);
				format(str,sizeof(str),
				"{FF4500}Slot 1: {FFFFFF}%s\n{FF4500}Slot 2: {FFFFFF}%s\n{FF4500}Slot 3: {FFFFFF}%s\n{FF4500}Slot 4: {FFFFFF}%s\n{FF4500}Slot 5: {FFFFFF}%s\n{FF4500}Slot 6: {FFFFFF}%s",slot1,slot2,slot3,slot4,slot5,slot6);
				ShowPlayerDialog(playerid,MENU+10,DIALOG_STYLE_LIST,BASLIK,str,"SeÄ±","Ä±ptal");
			}
		}
	}

	if(dialogid == MENU+9)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
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

			switch(listitem)
	        {
				case 0:
				{
					if(s1 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s1,s1x);
					EvKaydetInt(evid,"silahslot1",-1);
					EvKaydetInt(evid,"silahslot1x",-1);
					EvYenile(evid);
				}
				case 1:
				{
					if(s2 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s2,s2x);
					EvKaydetInt(evid,"silahslot2",-1);
					EvKaydetInt(evid,"silahslot2x",-1);
					EvYenile(evid);
				}
				case 2:
				{
					if(s3 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s3,s3x);
					EvKaydetInt(evid,"silahslot3",-1);
					EvKaydetInt(evid,"silahslot3x",-1);
					EvYenile(evid);
				}
				case 3:
				{
					if(s4 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s4,s4x);
					EvKaydetInt(evid,"silahslot4",-1);
					EvKaydetInt(evid,"silahslot4x",-1);
					EvYenile(evid);
				}
				case 4:
				{
					if(s5 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s5,s5x);
					EvKaydetInt(evid,"silahslot5",-1);
					EvKaydetInt(evid,"silahslot5x",-1);
					EvYenile(evid);
				}
				case 5:
				{
					if(s6 == -1) return Mesaj(playerid,"Bu slotta silah yok."),EvEditleniyor[OyuncuEv[playerid]] = false;
					GivePlayerWeapon(playerid,s6,s6x);
					EvKaydetInt(evid,"silahslot6",-1);
					EvKaydetInt(evid,"silahslot6x",-1);
					EvYenile(evid);
				}
			}
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
		}
	}

	if(dialogid == MENU+10)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
	        new s1 = EvBilgi[evid][silahslot1];
	        new s2 = EvBilgi[evid][silahslot2];
	        new s3 = EvBilgi[evid][silahslot3];
	        new s4 = EvBilgi[evid][silahslot4];
	        new s5 = EvBilgi[evid][silahslot5];
	        new s6 = EvBilgi[evid][silahslot6];
			if(GetPlayerWeapon(playerid) == 0) return Mesaj(playerid,"Elinizde silah yok.");

			switch(listitem)
	        {
				case 0:
				{
					if(s1 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot1",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot1x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 1:
				{
					if(s2 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot2",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot2x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 2:
				{
					if(s3 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot3",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot3x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 3:
				{
					if(s4 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot4",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot4x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 4:
				{
					if(s5 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot5",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot5x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
				case 5:
				{
					if(s6 != -1) return Mesaj(playerid,"Bu slotta zaten bir silah var."),EvEditleniyor[OyuncuEv[playerid]] = false;
					EvKaydetInt(evid,"silahslot6",GetPlayerWeapon(playerid));
					EvKaydetInt(evid,"silahslot6x",GetPlayerAmmo(playerid));
					DeletePlayerWeapon(playerid,GetPlayerWeapon(playerid));
					EvYenile(evid);
				}
			}
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Kilidi\n{FF4500}Ev KasasÄ±\n{FF4500}Ev Silah Deposu","SeÄ±","Ä±ptal");
		}
	}

	if(dialogid == DIALOG)
	{
	    if(!response) EvEditleniyor[GetHouseID(playerid)] = false;
	    if(response)
	    {
	        if(!Kontrol(playerid)) return Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
	        new str[256];
	        new evid = GetHouseID(playerid);
			if(listitem == 0) //Ev AÄ±Ä±klamasÄ±
			{
			    format(str,sizeof(str),"{00FF7F}Ev AÄ±Ä±klamasÄ±: {c0c0c0}%s\n\n{CD5C5C}AÄ±Ä±klamayÄ± deÄ±iÄ±tirmek iÃ§in yenisini aÄ±aÄ±Ä±ya yazÄ±nÄ±z.",EvBilgi[evid][evaciklama]);
				ShowPlayerDialog(playerid,DIALOG+2,DIALOG_STYLE_INPUT,BASLIK,str,"DeÄ±iÄ±tir","Ä±ptal");
			}
			if(listitem == 1) //Ev Sahibi
			{
			    new sahip[255];
			    new dosya[64];
			    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
			    if(!strlen(EvBilgi[evid][evsahip])) sahip = "Yok";
			    //else sahip = dini_Get(dosya,"evsahip");
			    format(str,sizeof(str),"{00FF7F}Ev Sahibi: {c0c0c0}%s\n\n{CD5C5C}Ev sahibini deÄ±iÄ±tirirseniz tÄ±m ev belirlenen kiÄ±iye devredilir.\nEÄ±er boÄ± bÄ±rakÄ±rsanÄ±z ev satÄ±lÄ±k olarak deÄ±iÄ±tirilir.",sahip);
				ShowPlayerDialog(playerid,DIALOG+3,DIALOG_STYLE_INPUT,BASLIK,str,"DeÄ±iÄ±tir","Ä±ptal");
			}
			if(listitem == 2) //Ev FiyatÄ±
			{
			    format(str,sizeof(str),"{00FF7F}Ev FiyatÄ±: {c0c0c0}%i$\n\n{CD5C5C}Yeni ev fiyatÄ±nÄ± deÄ±iÄ±tirmek iÃ§in yeni miktarÄ± giriniz.",EvBilgi[evid][evfiyat]);
				ShowPlayerDialog(playerid,DIALOG+4,DIALOG_STYLE_INPUT,BASLIK,str,"DeÄ±iÄ±tir","Ä±ptal");
			}
			if(listitem == 3) //Ev Interior
			{
			    new menu[450];
			    strcat(menu,"{FF4500}Ev 1\n");
			    strcat(menu,"{FF4500}Ev 2\n");
			    strcat(menu,"{FF4500}Ev 3\n");
			    strcat(menu,"{FF4500}Ev 4\n");
			    strcat(menu,"{FF4500}Ev 5\n");
			    strcat(menu,"{FF4500}Unused VillasÄ±");
				ShowPlayerDialog(playerid,DIALOG+5,DIALOG_STYLE_LIST,BASLIK,menu,"Ayarla","Ä±ptal");
			}
			if(listitem == 4) //Ev Kilidi
			{
				ShowPlayerDialog(playerid,DIALOG+7,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Kilidi AÄ±\n{FF4500}Kilitle","Ayarla","Ä±ptal");
			}
			if(listitem == 5) //Ev Sil
			{
				ShowPlayerDialog(playerid,DIALOG+8,DIALOG_STYLE_MSGBOX,BASLIK,"{B22222}Bunu yaparsanÄ±z ev kaydÄ± tamamen silinecektir ve geri dÄ±nÄ±Ä±Ä± olmayacaktÄ±r.\n{C0C0C0}Silmeyi onaylÄ±yor musunuz ?","Onayla","Ä±ptal");
			}
	    }
	}
	if(dialogid == DIALOG+1)
	{
	    if(!response) return 1;
	    if(response)
	    {
			if(listitem == 0)
			{
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(playerid,X,Y,Z);
				for(new i;i<MAX_HOUSE;i++)
				{
					if(EvBilgi[i][evvid] == -1)
					{
						EvYarat(i,X,Y,Z);
						break;
					}
				}
				Mesaj(playerid,"BaÄ±arÄ±yla ev yarattÄ±nÄ±z, dÄ±zenlemek iÃ§in pickup Ä±zerinde '{008080}/evmenu{FFFFFF}' komutunu kullanÄ±nÄ±z.");
			}
	    }
	}
	if(dialogid == DIALOG+2)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
			if(!strlen(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"LÄ±tfen geÄ±erli bir yazÄ± giriniz.") ;
			new evid = OyuncuKontrolEv[playerid];
			EvKaydetStr(evid,"evaciklama",inputtext);
			EvYenile(evid);
			Mesaj(playerid,"Ev aÄ±Ä±klamasÄ± deÄ±iÄ±tirildi.");
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    }
	}
	if(dialogid == DIALOG+3)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    if(response)
	    {
	        new evid = OyuncuKontrolEv[playerid];
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
			if(!strlen(inputtext)) EvKaydetInt(evid,"evsatilik",1),EvKaydetStr(evid,"evsahip",""),Mesaj(playerid,"Ev satÄ±lÄ±k olarak deÄ±iÄ±tirildi!");
			else EvKaydetInt(evid,"evsatilik",0),EvKaydetStr(evid,"evsahip",inputtext),Mesaj(playerid,"Ev sahibi deÄ±iÄ±tirildi!");
			EvYenile(evid);
			SahipKontrol();
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    }
	}
	if(dialogid == DIALOG+4)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
			if(!strlen(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"LÄ±tfen geÄ±erli bir rakam giriniz.");
			if(!strval(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"LÄ±tfen geÄ±erli bir rakam giriniz.");
			new evid = OyuncuKontrolEv[playerid];
			EvKaydetInt(evid,"evfiyat",strval(inputtext));
			Mesaj(playerid,"Ev fiyatÄ± deÄ±iÄ±tirildi!");
			EvYenile(evid);
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    }
	}
	if(dialogid == DIALOG+5)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
			new evid = OyuncuKontrolEv[playerid];
			if(listitem == 0) EvKaydetInt(evid,"evint",0);
			if(listitem == 1) EvKaydetInt(evid,"evint",1);
			if(listitem == 2) EvKaydetInt(evid,"evint",2);
			if(listitem == 3) EvKaydetInt(evid,"evint",3);
			if(listitem == 4) EvKaydetInt(evid,"evint",4);
			if(listitem == 5) EvKaydetInt(evid,"evint",5);

			EvYenile(evid);
			Mesaj(playerid,"Ev interioru deÄ±iÄ±tirildi!");
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    }
	}
	if(dialogid == DIALOG+7)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
			new evid = OyuncuKontrolEv[playerid];
			if(listitem == 0)
			{
			    EvKaydetInt(evid,"evkilit",0);
			    Mesaj(playerid,"Evin kilidini aÄ±tÄ±nÄ±z!");
			    EvYenile(evid);
	            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
			}
			if(listitem == 1)
			{
			    EvKaydetInt(evid, "evkilit", 1);
			    Mesaj(playerid,"Evi kilitlediniz!");
			    EvYenile(evid);
	            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
			}
	    }
	}
	if(dialogid == DIALOG+8)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev AÄ±Ä±klamasÄ±\n{FF4500}Ev Sahibi\n{FF4500}Ev FiyatÄ±\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","SeÄ±","Ä±ptal");
	    if(response)
	    {
			if(Kontrol(playerid)) EvSil(GetHouseID(playerid)),EvEditleniyor[GetHouseID(playerid)] = false;
			else Mesaj(playerid,"Ev dÄ±zenlemek iÃ§in herhangi bir evin Ä±stÄ±nde olmalÄ±sÄ±nÄ±z!");
	    }
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//(( #DiÄ±er ))================================================================//
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
    if(GetPlayerMoney(playerid) < ucret) return SendError(playerid,"Para yetersiz!");
    GivePlayerWeapon(playerid,silahid,silahammo);
    GivePlayerMoney(playerid,-ucret);
    new string[512];
    format(string,512,"Ä± BÄ±LGÄ±: {ACDA00}%s {FFFFFF}isimli silahÄ± {ACDA00}%d$ {FFFFFF}Ä±deyerek aldÄ±nÄ±z.",silahisim,ucret);
    SendClientMessageToAll(0x00A2F6AA,string);
    return 1;
}

// - Teleport sistemi
stock Teleport(playerid,Float:tX,Float:tY,Float:tZ,Int,World, const isim[], const command[],arabali,objeyukle)
{
    if(objeyukle == 1)
 	{
		ObjeYukle(playerid);
 	}
	if(arabali == 1)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        SetVehiclePos(GetPlayerVehicleID(playerid),tX,tY,tZ);
	        LinkVehicleToInterior(GetPlayerVehicleID(playerid),Int);
	        SetPlayerInterior(playerid,Int);
	        SetPlayerVirtualWorld(playerid,World);
	    }else{
	        SetPlayerPos(playerid,tX,tY,tZ);
	        SetPlayerInterior(playerid,Int);
	        SetPlayerVirtualWorld(playerid,World);
	    }
 	}else{
  		SetPlayerPos(playerid,tX,tY,tZ);
  		SetPlayerInterior(playerid,Int);
  		SetPlayerVirtualWorld(playerid,World);
 	}

	new string[512];
	format(string,512,"Ä± BÄ±LGÄ±: {FFFFFF}%s rumuzlu oyuncu {ACDA00}%s {FFFFFF}bÄ±lgesine Ä±Ä±Ä±nlandÄ±. {ACDA00}(%s)",PlayerName(playerid),isim,command);
	SendClientMessageToAll(0x00A2F6AA,string);
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
	if(seviye[playerid] == 1)
	{
	exp[playerid]=exp[playerid]+20;
	}
	else if(seviye[playerid] == 2)
	{
	exp[playerid]=exp[playerid]+18;
	}
	else if(seviye[playerid] == 3)
	{
	exp[playerid]=exp[playerid]+18;
	}
	else if(seviye[playerid] == 4)
	{
	exp[playerid]=exp[playerid]+16;
	}
	else if(seviye[playerid] == 5)
	{
	exp[playerid]=exp[playerid]+14;
	}
	else if(seviye[playerid] == 6)
	{
	exp[playerid]=exp[playerid]+12;
	}
	else if(seviye[playerid] == 7)
	{
	exp[playerid]=exp[playerid]+10;
    }
	else if(seviye[playerid] == 8)
	{
	exp[playerid]=exp[playerid]+8;
	}
	else if(seviye[playerid] == 9)
	{
	exp[playerid]=exp[playerid]+6;
	}
	else if(seviye[playerid] == 10)
	{
	exp[playerid]=exp[playerid]+4;
	}
	else if(seviye[playerid] == 11)
	{
	exp[playerid]=exp[playerid]+4;
	}
	else if(seviye[playerid] == 12)
	{
	exp[playerid]=exp[playerid]+3;
	}
	else if(seviye[playerid] == 13)
	{
	exp[playerid]=exp[playerid]+3;
	}
	else if(seviye[playerid] == 14)
	{
	exp[playerid]=exp[playerid]+2;
	}
	else if(seviye[playerid] == 15)
	{
	exp[playerid]=exp[playerid]+2;
	}
	else if(seviye[playerid] == 16)
	{
	exp[playerid]=exp[playerid]+2;
	}
	else if(seviye[playerid] == 17)
	{
	exp[playerid]=exp[playerid]+1;
	}
	else if(seviye[playerid] == 18)
	{
	exp[playerid]=exp[playerid]+1;
	}
	else if(seviye[playerid] == 19)
	{
	exp[playerid]=exp[playerid]+1;
	}
	else if(seviye[playerid] > 19)
	{
	exp[playerid]=exp[playerid]+1;
	}

	if(exp[playerid] >= 1000){
	if(seviye[playerid] < 50){
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
	if(Minute == 60 && Hour < 24)
	{
	Hour += 1, Minute = 0;
	SetWorldTime(Hour);
	}
	if(Hour == 24 && Minute == 0)
	{
	Hour = 0, Minute = 0;
	SetWorldTime(Hour);
	}

	new string[6];
	format(string, sizeof(string), "%02d:%02d", Hour, Minute);
	TextDrawSetString(TimeText, string);

    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
	{
	if(!IsPlayerConnected(playerid)) continue;
	SetPlayerTime(playerid, Hour, Minute);
	}
	return 1;
}

// - 31 Ä±ekme sistemi
forward asilanadamtimer(playerid);
public asilanadamtimer(playerid)
{
	if(cekiyor[playerid] == 1)
	{
    GivePlayerMoney(playerid,31);
    SendInfo(playerid,"31'den para aldÄ±nÄ±z! {FF0000}(31$)");
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

// - IsNumeric Ä±eysi
stock IsNumeric(const string[])
{
   for(new i, j = strlen(string); i < j; ++i)
   {
      if(!('0' <= string[i] <= '9'))
      {
         return 0;
      }
   }
   return 1;
}

// - Nos alabilecek AraÃ§lar
IsNosVehicle(vehicleid)
{
    #define NO_NOS_VEHICLES 29

    new InvalidNosVehicles[NO_NOS_VEHICLES] =
    {
   		581,523,462,521,463,522,461,448,468,586,
   		509,481,510,472,473,493,595,484,430,453,
   		452,446,454,590,569,537,538,570,449
    };

	for(new i = 0; i < NO_NOS_VEHICLES; i++)
	{
	    if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
	    {
	        return false;
	    }
	}
	return true;
}

// - Ev sistemi public & fonksiyonlarÄ±
public OyuncuMapIconKontrol(playerid)
{
	/*
	for(new i=0;i<ToplamEv;i++)
	{
	    new dosya[64];
	    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",i);
	    if(dini_Exists(dosya))
	    {
			if(EvBilgi[i][evsatilik] == 0)
			{
		 		SetPlayerMapIcon(playerid,i,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z],REDMAP,0);
			}
			else if(EvBilgi[i][evsatilik] == 1)
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
    if(dini_Exists(dosya))
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

		if(EvBilgi[evid][evkilit] == 0) durum = "AÄ±Ä±k";
		else if(EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		TextLabel[evid] = Create3DTextLabel("...",0xFFFFFFFF,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],30,0);

		if(EvBilgi[evid][evsatilik] == 0)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
			Pickup[evid] = CreatePickup(BLUEH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		}
		else if(EvBilgi[evid][evsatilik] == 1)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}SatÄ±lÄ±k\n{00FF7F}Ev FiyatÄ±: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
			Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);

		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // YÄ±klendi.",evid,EvBilgi[evid][evfiyat],durum);
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
    if(dini_Exists(dosya))
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

		if(EvBilgi[evid][evkilit] == 0) durum = "AÄ±Ä±k";
		else if(EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		if(EvBilgi[evid][evsatilik] == 0)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
		}
		else if(EvBilgi[evid][evsatilik] == 1)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}SatÄ±lÄ±k\n{00FF7F}Ev FiyatÄ±: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
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

public EvYarat(evid,Float:X,Float:Y,Float:Z)
{
	/*
    new dosya[64];
    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
    if(!dini_Exists(dosya))
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

		if(EvBilgi[evid][evkilit] == 0) durum = "AÄ±Ä±k";
		else if(EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		TextLabel[evid] = Create3DTextLabel("...",0xFFFFFFFF,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],30,0);

		if(EvBilgi[evid][evsatilik] == 0)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
			Pickup[evid] = CreatePickup(BLUEH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
			for(new a;a<MAX_PLAYERS;a++) if(IsPlayerConnected(a)) SetPlayerMapIcon(a,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],REDMAP,0);
		}
		else if(EvBilgi[evid][evsatilik] == 1)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}SatÄ±lÄ±k\n{00FF7F}Ev FiyatÄ±: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
			Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
			for(new a;a<MAX_PLAYERS;a++) if(IsPlayerConnected(a)) SetPlayerMapIcon(a,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],GREENMAP,0);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);

		printf("");
		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // OluÄ±turuldu.",evid,EvBilgi[evid][evfiyat],durum);

        ToplamEv++;
	}
	*/
	return 1;
}

public EvPickupYenile(evid)
{
	if(EvBilgi[evid][evsatilik] == 0)
	{
		DestroyPickup(Pickup[evid]);
		Pickup[evid] = CreatePickup(BLUEH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) RemovePlayerMapIcon(i,evid),SetPlayerMapIcon(i,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],REDMAP,0);
	}
	else if(EvBilgi[evid][evsatilik] == 1)
	{
		DestroyPickup(Pickup[evid]);
		Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i)) RemovePlayerMapIcon(i,evid),SetPlayerMapIcon(i,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],GREENMAP,0);
	}
	return 1;
}

public EvSil(evid)
{
	/*
    new dosya[64];
    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
    if(dini_Exists(dosya))
    {
		printf("");
		printf("Ev ID: %i // Silindi.",evid);
	    DestroyPickup(Pickup[evid]);
	    Delete3DTextLabel(TextLabel[evid]);
	    for(new b;b<MAX_PLAYERS;b++) if(IsPlayerConnected(b)) RemovePlayerMapIcon(b,evid);
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
	for(new i;i<MAX_HOUSE;i++)
	{
	    EvSahipID[i] = -1;
	    new dosya[64];
	    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",i);
	    if(dini_Exists(dosya))
	    {
   	        if(IsPlayerConnected(GetPlayerID(dini_Get(dosya,"evsahip"))))
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
	for(new i=0;i<MAX_HOUSE;i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,1,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z])) return i;
	}
	return -255;
}

public Kontrol(playerid)
{
	for(new i=0;i<MAX_HOUSE;i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,1,EvBilgi[i][ev_X],EvBilgi[i][ev_Y],EvBilgi[i][ev_Z]))
		{
			return 1;
		}
	}
	return 0;
}

public PlayerPos(playerid,Float:X,Float:Y,Float:Z,interior,world)
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
    while(--iArgs) {
		format(str,sizeof(str),"{FF4500}Ä± EV: {FFFFFF}%s",yazi,iArgs);
		SendClientMessage(playerid,-1,str);
    }
	return -1;
}

// - Oyuncu idi fonksiyonu
/*
GetPlayerID(const PlayerName[])
{
 	new pName[MAX_PLAYER_NAME];

	for(new i = 0; i < GetMaxPlayers(); i++)
	{
	    if(IsPlayerConnected(i))
	    {
			GetPlayerName(i, pName, MAX_PLAYER_NAME);
			if(strfind(pName, PlayerName, true) != -1)
			{
				return i;
			}
		}
	}
	return -1;
}
*/

// - Oyuncu adÄ± fonksiyonu
stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	return pname;
}

// - Silah adlarÄ±
stock WeaponName(weaponid)
{
	new wname[32];
	GetWeaponName(weaponid, wname, sizeof(wname));
	return wname;
}

// - Yasak skinler
stock IsValidSkin(iSkin)
{
    switch(iSkin)
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

    for(new i; i != sizeof(gWeaponData); ++i)
    {
        GetPlayerWeaponData(playerid, i, gWeaponData[i][0], gWeaponData[i][1]);

        gWeaponData[i][1] = gWeaponData[i][1] < 0 ? -gWeaponData[i][1] : gWeaponData[i][1];
    }
    ResetPlayerWeapons(playerid);

    for(new i; i != sizeof(gWeaponData); ++i)
    {
        if(gWeaponData[i][0] != weaponid)
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
 	if(PlayerAccount[playerid][pA_Hungry] >= 0 && PlayerAccount[playerid][pA_Hungry] < 50)
 	{
		new Float: playerHealth;
		GetPlayerHealth(playerid, playerHealth);
		TextDrawSetString(textdraw_hungry[playerid], "HUNGRY: ~g~~h~LOW");

		if(playerHealth < 100)
			SetPlayerHealth(playerid, playerHealth + 3.0);
	}
	else if(PlayerAccount[playerid][pA_Hungry] > 50 && PlayerAccount[playerid][pA_Hungry] < 100)
	    TextDrawSetString(textdraw_hungry[playerid], "HUNGRY: ~y~MEDIUM");
	else if(PlayerAccount[playerid][pA_Hungry] > 100)
	{
	    new Float: playerHealth;
	    GetPlayerHealth(playerid, playerHealth);
        TextDrawSetString(textdraw_hungry[playerid], "HUNGRY: ~r~~h~HIGH!");

		if(playerHealth < 25)
			SetPlayerHealth(playerid, playerHealth - 3.0);
	}

	if(PlayerAccount[playerid][pA_Radiation] == 0)
	{
	    TextDrawSetString(textdraw_radiation[playerid], "RADIATION: ~w~NONE");
	}
	else
	{
	    new radiationText[64];
 		if(PlayerAccount[playerid][pA_Radiation] > 0 && PlayerAccount[playerid][pA_Radiation] < 40)
	    	format(radiationText, sizeof(radiationText), "RADIATION: ~g~~h~%d", PlayerAccount[playerid][pA_Radiation]);
 		else if(PlayerAccount[playerid][pA_Radiation] >= 40 && PlayerAccount[playerid][pA_Radiation] < 90)
	    	format(radiationText, sizeof(radiationText), "RADIATION: ~y~%d", PlayerAccount[playerid][pA_Radiation]);
 		else if(PlayerAccount[playerid][pA_Radiation] >= 90)
	    	format(radiationText, sizeof(radiationText), "RADIATION: ~r~~h~%d", PlayerAccount[playerid][pA_Radiation]);
		TextDrawSetString(textdraw_radiation[playerid], radiationText);
	}

	new pingText[64];
	if(GetPlayerPing(playerid) >= 0 && GetPlayerPing(playerid) < 80)
		format(pingText, sizeof(pingText), "PING: ~g~~h~%d", GetPlayerPing(playerid));
    else if(GetPlayerPing(playerid) >= 80 && GetPlayerPing(playerid) < 200)
		format(pingText, sizeof(pingText), "PING: ~y~%d", GetPlayerPing(playerid));
    else if(GetPlayerPing(playerid) >= 200)
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

// == (( Stock & Other Unit )) ============================================== //
stock pName(playerid)
{
	new p[MAX_PLAYER_NAME];
	GetPlayerName(playerid, p, sizeof(p));
	return p;
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

// ========================================================================== //

stock LoadObjects()
{
	// Genel Objeler
    CreateObject(18761,2046.10,869.12,9.94,0.00,0.00,0.00);
    CreateObject(18768,2003.50,1007.70,37.50,0.00,0.00,0.00);
    CreateObject(18720,2620.90,1827.60,17.82,0.00,0.00,0.00);
    CreateObject(18769,2003.52,1007.75,37.49,0.00,0.00,0.00);
    CreateObject(18720,2620.87,1821.17,17.72,0.00,0.00,0.00);

	//4 MayÄ±s 2013 - Crosscuk Petrol DamÄ±tma SahasÄ± Edit
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


    // RequestClass AlanÄ±
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

    // Ebenin amÄ±
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

    // KÄ±y Ä±ete MekanÄ± - 11/04/2013
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

   	// - LVDM arabalarÄ±
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

    // SF Apocalypse:
    CreateDynamicObject(9907, -1722.04297, 791.97504, 70.29858,   -2.64001, 44.46001, 1.50000);
	CreateDynamicObject(10984, -1757.99902, 764.64038, 24.74970,   0.00000, 0.00000, -76.08001);
	CreateDynamicObject(10984, -1746.08191, 767.79108, 24.74970,   0.00000, 0.00000, -17.70002);
	CreateDynamicObject(10984, -1733.97327, 775.28864, 24.74970,   0.00000, 0.00000, -9.78002);
	CreateDynamicObject(10984, -1730.10620, 791.30292, 24.74970,   0.00000, 0.00000, 21.71998);
	CreateDynamicObject(10984, -1733.06323, 806.88684, 24.74970,   0.00000, 0.00000, 21.71998);
	CreateDynamicObject(10984, -1744.60840, 812.08624, 24.74970,   0.00000, 0.00000, 74.76000);
	CreateDynamicObject(10984, -1760.57141, 814.76276, 24.74970,   0.00000, 0.00000, 80.52000);
	CreateDynamicObject(10984, -1775.30713, 812.40985, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1787.88708, 814.03998, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1798.49402, 810.83569, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1789.77393, 806.83582, 25.61967,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1798.89990, 797.28729, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1797.22913, 785.07916, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1798.45129, 775.11011, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1795.88196, 766.15253, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(10984, -1780.12122, 765.95337, 24.74970,   0.00000, 0.00000, -197.34003);
	CreateDynamicObject(10984, -1769.46680, 765.72998, 24.74970,   0.00000, 0.00000, -99.53996);
	CreateDynamicObject(10984, -1714.19873, 763.53223, 24.43258,   0.00000, 0.00000, -58.38002);
	CreateDynamicObject(10984, -1713.04077, 792.21582, 24.43258,   0.00000, 0.00000, 32.16000);
	CreateDynamicObject(10984, -1716.58069, 782.02161, 24.44144,   0.00000, 0.00000, 60.65999);
	CreateDynamicObject(3594, -1719.60547, 805.42932, 24.07667,   0.00000, 0.00000, -59.16000);
	CreateDynamicObject(3594, -1710.72290, 807.78467, 24.07667,   0.00000, 0.00000, 38.16000);
	CreateDynamicObject(3594, -1716.07349, 815.54242, 24.07667,   0.00000, 0.00000, 6.84000);
	CreateDynamicObject(3594, -1709.18933, 818.68744, 24.07667,   0.00000, 0.00000, 45.06000);
	CreateDynamicObject(3594, -1717.34924, 823.39081, 24.07667,   0.00000, 0.00000, 119.58000);
	CreateDynamicObject(3594, -1709.18933, 818.68744, 24.07667,   0.00000, 0.00000, 45.06000);
	CreateDynamicObject(3594, -1720.49561, 832.73657, 24.07667,   0.00000, 0.00000, 174.42001);
	CreateDynamicObject(3594, -1724.85913, 843.05463, 24.07667,   0.00000, 0.00000, 152.52003);
	CreateDynamicObject(3594, -1731.58130, 848.81805, 24.07667,   0.00000, 0.00000, 203.04002);
	CreateDynamicObject(3594, -1732.26184, 838.46594, 24.07667,   0.00000, 0.00000, 203.04002);
	CreateDynamicObject(3594, -1739.38123, 845.30115, 24.07667,   0.00000, 0.00000, 268.97998);
	CreateDynamicObject(3594, -1715.52991, 859.74023, 24.07667,   0.00000, 0.00000, 308.75992);
	CreateDynamicObject(3594, -1707.53394, 855.06104, 24.07667,   0.00000, 0.00000, 235.91992);
	CreateDynamicObject(3594, -1708.07080, 837.49921, 24.07667,   0.00000, 0.00000, 281.33990);
	CreateDynamicObject(10984, -1713.69604, 848.02313, 24.10627,   0.00000, 0.00000, 38.51999);
	CreateDynamicObject(3594, -1716.33289, 846.33850, 25.22975,   -33.54000, -9.71999, 308.75992);
	CreateDynamicObject(10984, -1721.25122, 792.36200, 24.43258,   0.00000, 0.00000, 32.16000);
	CreateDynamicObject(3594, -1715.46362, 793.41162, 24.07667,   37.38000, 18.54000, 16.32000);
	CreateDynamicObject(3594, -1704.52637, 760.81152, 24.31097,   0.00000, 0.00000, -14.34000);
	CreateDynamicObject(3594, -1718.63245, 751.80640, 24.31097,   0.00000, 0.00000, 39.06000);
	CreateDynamicObject(3594, -1709.22888, 748.22284, 24.14381,   0.00000, 0.00000, -11.40000);
	CreateDynamicObject(3594, -1710.29248, 753.65607, 24.14381,   0.00000, 0.00000, 95.16000);
	CreateDynamicObject(3594, -1721.84644, 741.58636, 24.31097,   0.00000, 0.00000, -56.22000);
	CreateDynamicObject(3594, -1710.88318, 736.11212, 24.31097,   0.00000, 0.00000, -97.20000);
	CreateDynamicObject(3594, -1720.41357, 731.54254, 24.31097,   0.00000, 0.00000, -5.82000);
	CreateDynamicObject(3594, -1712.86377, 724.58704, 24.31097,   0.00000, 0.00000, -38.52000);
	CreateDynamicObject(3594, -1711.23572, 698.68066, 24.31097,   0.00000, 0.00000, -109.50002);
	CreateDynamicObject(10984, -1688.68896, 729.93231, 21.82001,   -7.14000, 5.52000, -57.66000);
	CreateDynamicObject(874, -1713.43433, 745.81195, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1708.10852, 757.85089, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1706.78589, 743.72711, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1705.54565, 731.94562, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1705.52759, 718.93506, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1716.01257, 732.49884, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1722.22095, 734.72900, 25.03898,   0.00000, 0.00000, 115.01999);
	CreateDynamicObject(874, -1719.93018, 725.34717, 25.03898,   0.00000, 0.00000, 27.71999);
	CreateDynamicObject(874, -1715.30811, 717.31390, 25.03898,   0.00000, 0.00000, 27.71999);
	CreateDynamicObject(874, -1721.20935, 761.67047, 25.03898,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1721.02869, 774.06818, 25.03898,   0.00000, 0.00000, 60.00000);
	CreateDynamicObject(874, -1722.00098, 790.18060, 25.03898,   0.00000, 0.00000, 60.00000);
	CreateDynamicObject(874, -1713.04919, 788.35339, 25.03898,   0.00000, 0.00000, 121.02000);
	CreateDynamicObject(874, -1712.13440, 804.60803, 24.92671,   0.00000, 0.00000, 105.42000);
	CreateDynamicObject(874, -1707.33826, 798.12054, 24.92671,   0.00000, 0.00000, 165.71999);
	CreateDynamicObject(874, -1721.39832, 811.51587, 24.92671,   0.00000, 0.00000, 152.88002);
	CreateDynamicObject(874, -1707.87219, 817.24597, 24.92671,   0.00000, 0.00000, 365.75998);
	CreateDynamicObject(874, -1714.02075, 822.95642, 24.92671,   0.00000, 0.00000, 316.14001);
	CreateDynamicObject(874, -1725.77429, 822.43756, 24.92671,   0.00000, 0.00000, 184.08002);
	CreateDynamicObject(874, -1727.11816, 835.06549, 24.92671,   0.00000, 0.00000, -3.96000);
	CreateDynamicObject(874, -1715.97363, 835.57886, 24.92671,   0.00000, 0.00000, -39.72000);
	CreateDynamicObject(874, -1720.27527, 842.93146, 24.92671,   0.00000, 0.00000, -21.29999);
	CreateDynamicObject(874, -1718.54248, 856.89160, 24.92671,   0.00000, 0.00000, -80.58000);
	CreateDynamicObject(874, -1710.76782, 847.97498, 24.92671,   0.00000, 0.00000, -123.89998);
	CreateDynamicObject(874, -1707.31787, 833.10522, 24.92671,   0.00000, 0.00000, -84.06000);
	CreateDynamicObject(3594, -1706.01306, 775.74335, 24.31097,   0.00000, 0.00000, -42.29999);
	CreateDynamicObject(874, -1705.95020, 777.56915, 25.03898,   0.00000, 0.00000, 147.96004);
	CreateDynamicObject(855, -1716.67139, 745.44287, 25.27317,   0.00000, 0.00000, -28.02000);
	CreateDynamicObject(855, -1708.91992, 739.72760, 25.27317,   0.00000, 0.00000, -28.02000);
	CreateDynamicObject(855, -1706.99976, 728.08704, 25.27317,   0.00000, 0.00000, 0.72000);
	CreateDynamicObject(855, -1726.79358, 741.48529, 25.27317,   0.00000, 0.00000, -18.24000);
	CreateDynamicObject(855, -1713.69897, 719.02020, 25.27317,   0.00000, 0.00000, -36.59999);
	CreateDynamicObject(855, -1705.17761, 739.61218, 25.27317,   0.00000, 0.00000, -14.21999);
	CreateDynamicObject(855, -1704.44275, 747.85376, 25.27317,   0.00000, 0.00000, -14.21999);
	CreateDynamicObject(855, -1703.23145, 767.45721, 25.27317,   0.00000, 0.00000, -14.21999);
	CreateDynamicObject(855, -1713.50610, 764.54205, 25.27317,   0.00000, 0.00000, 2.76001);
	CreateDynamicObject(855, -1707.59253, 780.50482, 25.27317,   0.00000, 0.00000, 2.76001);
	CreateDynamicObject(855, -1725.61499, 797.75244, 25.27317,   0.00000, 0.00000, 27.00001);
	CreateDynamicObject(855, -1720.98291, 810.97430, 25.27317,   0.00000, 0.00000, 27.00001);
	CreateDynamicObject(855, -1710.98230, 821.82544, 25.27317,   0.00000, 0.00000, -2.45999);
	CreateDynamicObject(3594, -1710.70923, 865.09204, 24.07667,   0.00000, 0.00000, 399.23981);
	CreateDynamicObject(874, -1716.74915, 863.83398, 24.92671,   0.00000, 0.00000, -122.46001);
	CreateDynamicObject(874, -1694.62744, 842.56305, 24.92671,   0.00000, 0.00000, -23.15999);
	CreateDynamicObject(3594, -1700.92175, 840.87579, 24.07667,   0.00000, 0.00000, 163.91991);
	CreateDynamicObject(4526, -1741.38220, 837.73608, 25.45850,   0.00000, 0.00000, -130.68005);
	CreateDynamicObject(874, -1736.92517, 835.48822, 24.92671,   0.00000, 0.00000, 9.60000);
	CreateDynamicObject(874, -1732.55627, 850.43091, 24.92671,   0.00000, 0.00000, 147.66000);
	CreateDynamicObject(3594, -1742.36450, 855.21179, 24.21451,   0.00000, 0.00000, 244.85992);
	CreateDynamicObject(16370, -1736.78723, 760.15369, 25.41468,   0.00000, 0.00000, -88.31997);
	CreateDynamicObject(874, -1755.18921, 753.14813, 25.03898,   0.00000, 0.00000, -86.40000);
	CreateDynamicObject(874, -1766.46362, 755.37958, 25.03898,   0.00000, 0.00000, -104.27999);
	CreateDynamicObject(874, -1771.10840, 750.25665, 25.03898,   0.00000, 0.00000, -125.70001);
	CreateDynamicObject(874, -1781.06482, 753.05829, 25.03898,   0.00000, 0.00000, -69.00003);
	CreateDynamicObject(874, -1740.58777, 763.80878, 25.03898,   0.00000, 0.00000, -75.36001);
	CreateDynamicObject(874, -1732.94592, 752.74213, 25.03898,   0.00000, 0.00000, -98.28001);
	CreateDynamicObject(3594, -1746.12817, 754.19476, 24.31097,   0.00000, 0.00000, 38.46001);
	CreateDynamicObject(3594, -1742.95117, 754.88867, 24.35072,   19.26000, -18.90000, 101.69999);
	CreateDynamicObject(10984, -1754.45117, 755.82349, 24.74970,   0.00000, 0.00000, -76.08001);
	CreateDynamicObject(4526, -1713.95300, 715.10791, 25.43290,   0.00000, 0.00000, -26.04000);
	CreateDynamicObject(874, -1724.60486, 717.08032, 25.03898,   0.00000, 0.00000, 26.27999);
	CreateDynamicObject(7933, -1688.72595, 697.04749, 30.09712,   0.00000, 0.00000, -43.37997);
	CreateDynamicObject(7933, -1688.73621, 714.93414, 30.13768,   0.00000, 0.00000, -134.27998);
	CreateDynamicObject(7933, -1671.39246, 714.99652, 30.02717,   0.00000, 0.00000, 132.17999);
	CreateDynamicObject(874, -1678.57373, 710.53101, 29.97301,   0.00000, 0.00000, -115.67996);
	CreateDynamicObject(874, -1683.27905, 702.20825, 30.25974,   0.00000, 0.00000, -37.01995);
	CreateDynamicObject(874, -1674.05090, 702.70612, 30.12347,   0.00000, 0.00000, 1.08004);
	CreateDynamicObject(855, -1688.99609, 707.75665, 29.59123,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1677.74219, 707.99176, 29.59123,   0.00000, 0.00000, 30.60000);
	CreateDynamicObject(855, -1680.03992, 701.26410, 30.22540,   0.00000, 0.00000, 4.14000);
	CreateDynamicObject(3877, -1691.29956, 694.82593, 31.18371,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, -1691.36072, 717.21509, 31.18371,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, -1668.92505, 717.22089, 31.18371,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3877, -1668.90088, 694.82489, 31.18371,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -1694.73230, 706.97656, 24.29650,   0.00000, 0.00000, 12.35998);
	CreateDynamicObject(874, -1702.53833, 702.60425, 25.03898,   0.00000, 0.00000, -233.15999);
	CreateDynamicObject(874, -1709.34875, 704.45526, 25.03898,   0.00000, 0.00000, -182.04001);
	CreateDynamicObject(874, -1718.34961, 700.62659, 25.03898,   0.00000, 0.00000, -201.77998);
	CreateDynamicObject(874, -1725.55835, 694.41827, 25.03898,   0.00000, 0.00000, -180.77995);
	CreateDynamicObject(874, -1716.28882, 691.40710, 25.03898,   0.00000, 0.00000, -347.69995);
	CreateDynamicObject(874, -1708.39880, 690.55121, 25.03898,   0.00000, 0.00000, -348.42004);
	CreateDynamicObject(874, -1710.38989, 683.11420, 25.03898,   0.06000, 0.78000, -319.02014);
	CreateDynamicObject(10984, -1728.61780, 698.22473, 24.29650,   0.00000, 0.00000, 4.07998);
	CreateDynamicObject(3594, -1721.06042, 690.44843, 24.31097,   0.00000, 0.00000, -208.14003);
	CreateDynamicObject(3594, -1702.06812, 693.58679, 24.31097,   0.00000, 0.00000, -149.58006);
	CreateDynamicObject(3594, -1710.88354, 682.89819, 24.31097,   0.00000, 0.00000, -226.92003);
	CreateDynamicObject(3594, -1724.76379, 700.40125, 24.31097,   0.00000, 0.00000, -253.68002);
	CreateDynamicObject(3594, -1714.94727, 683.02612, 24.31097,   -10.67999, 3.96001, -285.60004);
	CreateDynamicObject(874, -1689.25342, 738.76733, 23.16101,   12.00000, 4.02000, 63.78001);
	CreateDynamicObject(874, -1690.66785, 731.60468, 23.16101,   12.00000, 4.02000, 33.36002);
	CreateDynamicObject(874, -1689.79370, 723.18250, 23.16101,   12.00000, 4.02000, 70.86002);
	CreateDynamicObject(874, -1674.76880, 725.77435, 19.76101,   12.00000, 4.02000, 70.86002);
	CreateDynamicObject(874, -1675.03625, 732.77478, 19.76101,   12.00000, 4.02000, 119.58002);
	CreateDynamicObject(3594, -1697.11621, 728.63507, 23.54159,   -2.22000, 11.70000, -12.78000);
	CreateDynamicObject(874, -1737.27698, 731.99658, 25.70692,   8.87999, 3.00000, 105.23999);
	CreateDynamicObject(874, -1735.61267, 724.87415, 25.70692,   8.87999, 3.00000, 46.68002);
	CreateDynamicObject(3594, -1731.21509, 731.65930, 24.63367,   -0.72000, 8.93999, -5.82000);
	CreateDynamicObject(3594, -1745.04138, 733.09924, 27.11199,   -6.00000, 10.92000, -36.66001);
	CreateDynamicObject(874, -1745.92188, 729.14819, 27.83629,   8.87999, 3.00000, 46.50003);
	CreateDynamicObject(3920, -1696.22144, 743.06812, 32.81583,   0.00000, 0.00000, 180.17990);
	CreateDynamicObject(3920, -1683.57117, 743.08081, 32.81583,   0.00000, 0.00000, 180.17990);
	CreateDynamicObject(3920, -1670.95813, 743.08972, 32.81583,   0.00000, 0.00000, 180.17990);
	CreateDynamicObject(3920, -1702.41040, 749.22827, 32.81583,   0.00000, 0.00000, 90.47993);
	CreateDynamicObject(3920, -1702.39954, 761.87933, 32.81583,   0.00000, 0.00000, 90.05994);
	CreateDynamicObject(3920, -1702.36499, 774.59973, 32.81583,   0.00000, 0.00000, 90.05994);
	CreateDynamicObject(3920, -1702.36829, 796.16901, 32.81583,   0.00000, 0.00000, 90.05994);
	CreateDynamicObject(3920, -1702.31738, 808.70056, 32.81583,   0.00000, 0.00000, 90.05994);
	CreateDynamicObject(3920, -1702.35889, 821.10931, 32.81583,   0.00000, 0.00000, 90.05994);
	CreateDynamicObject(8210, -1801.47571, 1013.99384, 26.70121,   0.00000, 0.00000, 0.66000);
	CreateDynamicObject(3095, -1783.92297, 1014.55469, 27.89191,   89.82009, -1.08001, 1.68000);
	CreateDynamicObject(8210, -1801.47571, 1013.99384, 33.70606,   0.00000, 0.00000, 0.66000);
	CreateDynamicObject(3095, -1792.70667, 1014.43561, 27.89191,   89.82009, -1.08001, 1.68000);
	CreateDynamicObject(3095, -1801.76660, 1014.31458, 27.89191,   89.82009, -1.08001, 1.68000);
	CreateDynamicObject(3095, -1783.92297, 1014.55469, 34.95129,   89.82009, -1.08001, 1.68000);
	CreateDynamicObject(3095, -1792.70667, 1014.43561, 34.93289,   89.82009, -1.08001, 1.68000);
	CreateDynamicObject(3095, -1801.76758, 1014.35461, 34.92772,   89.82009, -1.08001, 1.68000);
	CreateDynamicObject(874, -1803.50488, 1007.08850, 24.46184,   0.00000, 0.00000, -186.47993);
	CreateDynamicObject(874, -1795.62402, 1009.08942, 24.46184,   0.00000, 0.00000, -195.41991);
	CreateDynamicObject(874, -1787.46228, 1009.41302, 24.46184,   0.00000, 0.00000, -206.33992);
	CreateDynamicObject(874, -1801.89539, 997.69995, 24.46184,   0.00000, 0.00000, -35.75993);
	CreateDynamicObject(874, -1793.86487, 996.65674, 24.46184,   0.00000, 0.00000, -25.55993);
	CreateDynamicObject(874, -1786.32776, 996.76154, 24.46184,   0.00000, 0.00000, -7.31994);
	CreateDynamicObject(874, -1799.78845, 983.90381, 24.46184,   0.00000, 0.00000, -72.17994);
	CreateDynamicObject(874, -1790.90955, 978.30383, 24.46184,   0.00000, 0.00000, -3.89994);
	CreateDynamicObject(874, -1789.59509, 986.80841, 24.14858,   0.00000, 0.00000, 34.62006);
	CreateDynamicObject(874, -1801.28809, 974.55841, 24.46184,   0.00000, 0.00000, 129.00005);
	CreateDynamicObject(874, -1789.52087, 962.77631, 24.46184,   0.00000, 0.00000, 112.56003);
	CreateDynamicObject(874, -1799.98804, 962.62683, 24.46184,   0.00000, 0.00000, 215.88000);
	CreateDynamicObject(874, -1788.51953, 953.40338, 24.46184,   0.00000, 0.00000, 65.46000);
	CreateDynamicObject(874, -1798.39587, 951.49823, 24.46184,   0.00000, 0.00000, 218.40002);
	CreateDynamicObject(10984, -1795.55969, 967.86047, 24.21292,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -1802.62402, 996.20953, 24.21292,   0.00000, 0.00000, 21.42000);
	CreateDynamicObject(10236, -1790.20154, 971.10730, 24.73429,   297.75958, -38.76001, 10.88160);
	CreateDynamicObject(10984, -1786.15161, 965.55682, 24.21292,   0.00000, 0.00000, 76.02001);
	CreateDynamicObject(3594, -1800.52185, 942.00330, 24.18340,   0.00000, 0.00000, -28.14000);
	CreateDynamicObject(3594, -1790.46631, 951.79279, 24.18340,   0.00000, 0.00000, 40.67999);
	CreateDynamicObject(3594, -1767.98108, 958.00488, 24.18340,   0.00000, 0.00000, -73.01999);
	CreateDynamicObject(3594, -1785.06897, 957.82635, 24.18340,   0.00000, 0.00000, -4.50000);
	CreateDynamicObject(3594, -1792.40771, 990.26752, 24.19839,   0.00000, -0.48000, -44.52000);
	CreateDynamicObject(3594, -1788.50159, 980.31018, 24.10317,   0.00000, 0.00000, -120.48004);
	CreateDynamicObject(3594, -1796.13171, 1002.84900, 24.10317,   0.00000, 0.00000, -160.74007);
	CreateDynamicObject(3594, -1786.27832, 1002.98767, 24.10317,   0.00000, 0.00000, -227.40005);
	CreateDynamicObject(874, -1765.40991, 952.36230, 24.46184,   0.00000, 0.00000, 79.38001);
	CreateDynamicObject(874, -1779.40430, 956.49707, 24.46184,   0.00000, 0.00000, 137.28000);
	CreateDynamicObject(10193, -1753.37585, 974.77222, 52.76557,   370.59796, 0.84000, 0.86159);
	CreateDynamicObject(10984, -1778.42822, 962.58087, 24.21292,   0.00000, 0.00000, 152.64001);
	CreateDynamicObject(10984, -1766.76428, 962.64948, 24.21292,   0.00000, 0.00000, 118.98000);
	CreateDynamicObject(10984, -1753.10645, 961.96393, 24.21292,   0.00000, 0.00000, 160.85995);
	CreateDynamicObject(10984, -1741.42944, 962.86743, 24.63066,   0.00000, 0.00000, 160.67996);
	CreateDynamicObject(10984, -1729.18066, 964.45038, 24.63066,   0.00000, 0.00000, 123.89993);
	CreateDynamicObject(10984, -1752.57544, 984.48431, 16.74240,   3.84000, 2.28000, -92.57996);
	CreateDynamicObject(10984, -1758.26514, 991.85437, 16.62017,   76.44005, 41.16000, -64.02006);
	CreateDynamicObject(10984, -1757.89063, 986.13507, 23.23226,   -27.65999, -166.68005, -92.57996);
	CreateDynamicObject(10984, -1771.25220, 987.66937, 21.34210,   16.14001, -9.78000, -258.30020);
	CreateDynamicObject(10984, -1757.87244, 986.28510, 15.52658,   31.68006, 11.52000, -323.52029);
	CreateDynamicObject(10984, -1756.20996, 981.55176, 19.28775,   2.58000, -87.48000, -94.85999);
	CreateDynamicObject(10984, -1764.31836, 980.72528, 19.28775,   2.58000, -87.48000, -94.85999);
	CreateDynamicObject(10984, -1765.71252, 981.17517, 19.28775,   2.58000, -87.48000, -107.21999);
	CreateDynamicObject(10984, -1777.31653, 972.65417, 19.28775,   8.39999, -63.59997, -1.13998);
	CreateDynamicObject(10984, -1750.29724, 981.34503, 27.48047,   353.75922, -75.24007, -191.15982);
	CreateDynamicObject(874, -1743.41760, 979.72296, 17.35158,   0.00000, 0.00000, -126.41999);
	CreateDynamicObject(874, -1739.89075, 987.11133, 17.35158,   0.00000, 0.00000, -143.75998);
	CreateDynamicObject(874, -1732.46814, 982.40851, 17.35158,   0.00000, 0.00000, -40.37998);
	CreateDynamicObject(874, -1723.72485, 980.29974, 17.35158,   0.00000, 0.00000, -95.99997);
	CreateDynamicObject(874, -1726.61707, 989.08258, 17.35158,   0.00000, 0.00000, 1.68003);
	CreateDynamicObject(874, -1733.67737, 992.67896, 17.35158,   0.00000, 0.00000, 7.56003);
	CreateDynamicObject(3594, -1735.82935, 1012.17181, 16.97647,   0.00000, 0.00000, -96.65997);
	CreateDynamicObject(3594, -1735.42346, 1021.05225, 16.97647,   8.81999, 32.70000, -65.21997);
	CreateDynamicObject(3594, -1736.09277, 1028.77234, 16.97647,   0.00000, 0.00000, 80.76003);
	CreateDynamicObject(3594, -1736.04163, 1024.49341, 16.97647,   0.00000, 0.00000, 66.72001);
	CreateDynamicObject(819, -1722.46094, 1024.93372, 16.63959,   0.00000, 0.00000, -7.80000);
	CreateDynamicObject(819, -1729.31885, 1017.53290, 16.63959,   0.00000, 0.00000, 26.70000);
	CreateDynamicObject(819, -1726.56592, 1024.27966, 16.63959,   0.00000, 0.00000, 68.64001);
	CreateDynamicObject(819, -1728.18994, 1031.54810, 16.63959,   0.00000, 0.00000, 16.86001);
	CreateDynamicObject(819, -1725.88098, 1030.25952, 16.63959,   0.00000, 0.00000, 16.86001);
	CreateDynamicObject(819, -1718.48279, 1036.84619, 16.63959,   0.00000, 0.00000, 45.54002);
	CreateDynamicObject(3594, -1721.16418, 1030.42944, 16.97647,   0.00000, 0.00000, 42.54004);
	CreateDynamicObject(819, -1733.52734, 1034.50439, 16.63959,   0.00000, 0.00000, -33.90000);
	CreateDynamicObject(819, -1722.22607, 1012.34839, 16.63959,   0.00000, 0.00000, -58.14000);
	CreateDynamicObject(819, -1719.64539, 1006.44965, 16.63959,   0.00000, 0.00000, -18.83999);
	CreateDynamicObject(819, -1715.58936, 1000.63702, 16.63959,   0.00000, 0.00000, -29.10000);
	CreateDynamicObject(874, -1723.95703, 1007.21161, 17.35158,   0.00000, 0.00000, 1.68003);
	CreateDynamicObject(874, -1723.52917, 1019.72937, 17.35158,   0.00000, 0.00000, 139.92003);
	CreateDynamicObject(874, -1729.78979, 1027.52759, 17.35158,   0.00000, 0.00000, 139.92003);
	CreateDynamicObject(874, -1735.75806, 1053.50452, 17.35158,   0.00000, 0.00000, 178.92001);
	CreateDynamicObject(874, -1735.90503, 1040.49280, 17.35158,   0.00000, 0.00000, 228.72003);
	CreateDynamicObject(874, -1722.56506, 1048.51160, 17.35158,   0.00000, 0.00000, 105.78006);
	CreateDynamicObject(874, -1728.01794, 1057.75012, 17.35158,   0.00000, 0.00000, 49.32005);
	CreateDynamicObject(819, -1724.99927, 1041.90222, 16.63959,   0.00000, 0.00000, 95.52003);
	CreateDynamicObject(819, -1713.65710, 1036.46313, 16.63959,   0.00000, 0.00000, 76.56001);
	CreateDynamicObject(874, -1722.23743, 1028.47229, 17.35158,   0.00000, 0.00000, 139.92003);
	CreateDynamicObject(874, -1713.86365, 994.49774, 17.35158,   0.00000, 0.00000, -25.91997);
	CreateDynamicObject(3594, -1730.14417, 1005.54266, 17.31808,   0.00000, 0.00000, -182.51994);
	CreateDynamicObject(3594, -1723.21558, 1005.22913, 17.31808,   0.00000, 0.00000, -169.79994);
	CreateDynamicObject(3594, -1730.14417, 1005.54266, 18.22889,   -1.98000, 3.48000, -193.97990);
	CreateDynamicObject(10984, -1729.27832, 1004.82727, 16.51520,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10985, -1718.71985, 1018.09259, 17.37384,   0.00000, 0.00000, -111.48002);
	CreateDynamicObject(874, -1709.50464, 981.57361, 17.35158,   0.00000, 0.00000, -98.93997);
	CreateDynamicObject(874, -1696.37415, 997.42310, 17.35158,   0.00000, 0.00000, -209.15999);
	CreateDynamicObject(874, -1699.61914, 1009.62781, 17.35158,   0.00000, 0.00000, -402.41989);
	CreateDynamicObject(874, -1689.73315, 1014.67767, 17.35158,   0.00000, 0.00000, -370.19992);
	CreateDynamicObject(874, -1698.03271, 1023.47943, 17.35158,   0.00000, 0.00000, -416.81989);
	CreateDynamicObject(874, -1689.04187, 1030.20825, 17.35158,   0.00000, 0.00000, -379.01984);
	CreateDynamicObject(874, -1699.73853, 1033.35632, 17.35158,   0.00000, 0.00000, -437.39990);
	CreateDynamicObject(874, -1694.01721, 1044.50366, 17.35158,   0.00000, 0.00000, -463.43985);
	CreateDynamicObject(874, -1708.07446, 1051.48230, 17.35158,   0.00000, 0.00000, -475.73987);
	CreateDynamicObject(874, -1709.16882, 1043.06543, 17.35158,   0.00000, 0.00000, -460.25989);
	CreateDynamicObject(874, -1697.57996, 1057.85913, 17.35158,   0.00000, 0.00000, -528.17981);
	CreateDynamicObject(874, -1686.34192, 1052.10852, 17.35158,   0.00000, 0.00000, -596.81982);
	CreateDynamicObject(855, -1686.51538, 1038.60278, 16.56707,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1698.04065, 1026.96777, 16.56707,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1688.95190, 1021.94769, 16.56707,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1693.43103, 1040.57764, 16.56707,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(819, -1692.63696, 980.05493, 16.63959,   0.00000, 0.00000, -63.66000);
	CreateDynamicObject(819, -1687.11377, 990.13654, 16.63959,   0.00000, 0.00000, -47.70000);
	CreateDynamicObject(855, -1694.46497, 986.36133, 16.57470,   0.00000, 0.00000, -11.82000);
	CreateDynamicObject(855, -1707.94092, 995.19818, 16.57470,   0.00000, 0.00000, -13.38000);
	CreateDynamicObject(855, -1694.46497, 986.36133, 16.57470,   0.00000, 0.00000, -11.82000);
	CreateDynamicObject(855, -1711.15674, 984.61224, 16.57470,   0.00000, 0.00000, -13.38000);
	CreateDynamicObject(874, -1687.35889, 976.06439, 17.35158,   0.00000, 0.00000, -15.89997);
	CreateDynamicObject(874, -1687.88684, 989.18604, 17.35158,   0.00000, 0.00000, 3.00003);
	CreateDynamicObject(874, -1704.02246, 982.23944, 17.35158,   0.00000, 0.00000, 46.98003);
	CreateDynamicObject(819, -1701.29773, 1001.23712, 16.63959,   0.00000, 0.00000, -16.02000);
	CreateDynamicObject(819, -1685.73157, 1006.10004, 16.63959,   0.00000, 0.00000, -16.02000);
	CreateDynamicObject(819, -1687.71472, 997.03876, 16.63959,   0.00000, 0.00000, -49.62000);
	CreateDynamicObject(10194, -1752.59680, 1006.24689, 60.52551,   378.15790, -4.80000, 0.98159);
	CreateDynamicObject(10984, -1780.91748, 1011.75317, 24.21292,   0.00000, 0.00000, 21.42000);
	CreateDynamicObject(10984, -1782.24048, 984.75006, 23.69161,   0.00000, 0.00000, 17.34001);
	CreateDynamicObject(8210, -1711.73914, 965.73389, 26.70121,   0.00000, 0.00000, 0.24000);
	CreateDynamicObject(8210, -1711.73914, 965.73389, 33.81216,   0.00000, 0.00000, 0.24000);
	CreateDynamicObject(3095, -1721.95313, 966.01495, 34.93289,   89.82009, -1.08001, 1.20000);
	CreateDynamicObject(3095, -1713.06201, 966.03613, 34.93289,   89.82009, -1.08001, 1.32000);
	CreateDynamicObject(3095, -1704.99536, 966.06531, 34.93289,   89.82009, -1.08001, 1.20000);
	CreateDynamicObject(3095, -1721.95313, 966.01495, 27.63032,   89.82009, -1.08001, 1.20000);
	CreateDynamicObject(3095, -1713.06201, 966.03613, 27.71191,   89.82009, -1.08001, 1.32000);
	CreateDynamicObject(3095, -1704.99536, 966.06531, 27.83984,   89.82009, -1.08001, 1.20000);
	CreateDynamicObject(874, -1772.02185, 945.58453, 24.46184,   0.00000, 0.00000, -3.53998);
	CreateDynamicObject(874, -1752.22192, 951.11194, 24.46184,   0.00000, 0.00000, 57.00003);
	CreateDynamicObject(874, -1738.06299, 949.20789, 24.46184,   0.00000, 0.00000, 21.00003);
	CreateDynamicObject(874, -1731.19653, 955.66797, 24.46184,   0.00000, 0.00000, 246.78006);
	CreateDynamicObject(874, -1731.19653, 955.66797, 24.46184,   0.00000, 0.00000, 246.78006);
	CreateDynamicObject(874, -1765.03723, 944.78839, 24.46184,   0.00000, 0.00000, 57.00003);
	CreateDynamicObject(874, -1752.52429, 944.25995, 24.46184,   0.00000, 0.00000, 81.96004);
	CreateDynamicObject(874, -1776.86719, 926.06598, 24.46184,   0.00000, 0.00000, 24.78002);
	CreateDynamicObject(874, -1749.68848, 930.57886, 24.46184,   0.00000, 0.00000, -56.57998);
	CreateDynamicObject(874, -1744.25085, 915.50549, 24.46184,   0.00000, 0.00000, -11.33998);
	CreateDynamicObject(874, -1737.64624, 928.32916, 24.46184,   0.00000, 0.00000, 41.04002);
	CreateDynamicObject(874, -1756.31909, 925.27728, 24.46184,   0.00000, 0.00000, 91.74002);
	CreateDynamicObject(10984, -1735.98083, 938.10400, 23.89033,   0.00000, 0.00000, 75.23994);
	CreateDynamicObject(10984, -1762.71582, 920.99646, 24.36271,   0.00000, 0.00000, 159.53995);
	CreateDynamicObject(10984, -1774.39014, 935.10309, 23.94794,   -0.18000, -2.82000, 159.53995);
	CreateDynamicObject(3594, -1725.77441, 929.36584, 23.98367,   0.00000, 0.00000, -17.10000);
	CreateDynamicObject(3594, -1719.85059, 933.51416, 23.98367,   0.00000, 0.00000, 42.48001);
	CreateDynamicObject(3594, -1732.47668, 922.19220, 23.98367,   0.00000, 0.00000, 68.64002);
	CreateDynamicObject(3594, -1787.58167, 929.32635, 24.18340,   0.00000, 0.00000, 3.78000);
	CreateDynamicObject(3594, -1767.54529, 933.53052, 24.18340,   0.00000, 0.00000, -65.52001);
	CreateDynamicObject(3594, -1758.99133, 948.83472, 24.18340,   0.00000, 0.00000, 43.43998);
	CreateDynamicObject(3594, -1748.43628, 939.53033, 24.18340,   0.00000, 0.00000, -48.96002);
	CreateDynamicObject(874, -1758.69910, 935.97015, 24.46184,   0.00000, 0.00000, 42.66003);
	CreateDynamicObject(3920, -1760.35815, 959.78137, 40.33858,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1746.57776, 960.02051, 40.33858,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1731.98474, 960.27594, 40.04185,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1773.11230, 959.68195, 40.38064,   0.00000, 0.00000, 1.02000);
	CreateDynamicObject(874, -1736.07593, 918.14032, 24.46184,   0.00000, 0.00000, -141.95998);
	CreateDynamicObject(874, -1751.53320, 916.25311, 24.46184,   0.00000, 0.00000, -265.79999);
	CreateDynamicObject(874, -1736.04419, 939.51440, 24.46184,   0.00000, 0.00000, 21.00003);
	CreateDynamicObject(874, -1712.31763, 959.30487, 24.46184,   0.00000, 0.00000, 27.48003);
	CreateDynamicObject(874, -1723.10828, 953.65741, 24.46184,   0.00000, 0.00000, -48.65997);
	CreateDynamicObject(874, -1714.67212, 950.33069, 24.46184,   0.00000, 0.00000, -48.65997);
	CreateDynamicObject(874, -1707.16553, 947.07886, 24.46184,   0.00000, 0.00000, -6.47997);
	CreateDynamicObject(874, -1716.33667, 941.76215, 24.46184,   0.00000, 0.00000, 16.38003);
	CreateDynamicObject(874, -1725.96826, 941.87677, 24.46184,   0.00000, 0.00000, 16.38003);
	CreateDynamicObject(3594, -1707.89099, 958.39197, 23.98367,   0.00000, 0.00000, 4.68001);
	CreateDynamicObject(3594, -1768.10046, 916.51953, 24.18340,   -28.38001, -1.08000, -65.52001);
	CreateDynamicObject(3594, -1793.76233, 930.94617, 24.18340,   0.00000, 0.00000, -38.34000);
	CreateDynamicObject(3594, -1793.84326, 920.83881, 24.18340,   0.00000, 0.00000, -95.58000);
	CreateDynamicObject(3594, -1781.97888, 917.23096, 24.18340,   0.00000, 0.00000, -79.80000);
	CreateDynamicObject(874, -1790.51013, 926.02710, 24.46184,   0.00000, 0.00000, 55.98002);
	CreateDynamicObject(874, -1796.20276, 943.92468, 24.46184,   0.00000, 0.00000, 132.12003);
	CreateDynamicObject(874, -1789.46033, 939.48145, 24.46184,   0.00000, 0.00000, 98.94000);
	CreateDynamicObject(3594, -1779.60938, 941.96179, 24.18340,   0.00000, 0.00000, -80.46000);
	CreateDynamicObject(3920, -1781.38867, 966.23779, 41.87877,   -0.06000, 10.68000, -88.85996);
	CreateDynamicObject(3920, -1781.62891, 978.54425, 44.17601,   -0.06000, 10.68000, -88.85996);
	CreateDynamicObject(874, -1802.83057, 930.00970, 24.46184,   0.00000, 0.00000, 173.64003);
	CreateDynamicObject(874, -1792.58081, 915.47009, 24.46184,   0.00000, 0.00000, 276.12006);
	CreateDynamicObject(3594, -1744.81006, 923.34558, 24.18340,   0.00000, 0.00000, -165.00003);
	CreateDynamicObject(8210, -1689.03528, 928.20398, 26.70121,   0.00000, 0.00000, -90.30001);
	CreateDynamicObject(8210, -1689.03528, 928.20398, 33.59119,   0.00000, 0.00000, -90.30001);
	CreateDynamicObject(3095, -1688.60669, 939.41107, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.61389, 930.54089, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.63110, 921.61676, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.66028, 912.68115, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.72668, 903.67902, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.72668, 903.67902, 27.72009,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.66028, 912.68115, 26.99294,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.63110, 921.61676, 27.52445,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.61389, 930.54089, 27.47063,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1688.60669, 939.41107, 27.46451,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3920, -1701.40234, 959.69592, 32.06879,   0.00000, 0.00000, -268.44006);
	CreateDynamicObject(3920, -1701.39709, 950.29620, 32.06879,   0.00000, 0.00000, -268.44006);
	CreateDynamicObject(3920, -1695.06104, 944.10065, 32.06879,   0.00000, 0.00000, -180.72006);
	CreateDynamicObject(819, -1702.81714, 949.95007, 24.47157,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(819, -1708.79187, 941.26508, 24.47157,   0.00000, 0.00000, -28.62000);
	CreateDynamicObject(874, -1697.79370, 950.53528, 24.46184,   0.00000, 0.00000, 16.38003);
	CreateDynamicObject(874, -1694.25330, 940.36896, 24.46184,   0.00000, 0.00000, -4.85997);
	CreateDynamicObject(874, -1700.72668, 940.31079, 24.46184,   0.00000, 0.00000, -100.55997);
	CreateDynamicObject(874, -1702.63611, 929.54059, 24.46184,   0.00000, 0.00000, -133.19997);
	CreateDynamicObject(874, -1710.34949, 927.67957, 24.46184,   0.00000, 0.00000, -149.09995);
	CreateDynamicObject(874, -1694.92822, 923.14288, 24.46184,   0.00000, 0.00000, -196.97992);
	CreateDynamicObject(874, -1701.79590, 917.54742, 24.46184,   0.00000, 0.00000, -247.73988);
	CreateDynamicObject(874, -1711.01074, 919.98645, 24.46184,   0.00000, 0.00000, -319.91992);
	CreateDynamicObject(874, -1719.09216, 924.58435, 24.46184,   0.00000, 0.00000, -360.47989);
	CreateDynamicObject(3594, -1726.24023, 913.52032, 23.98367,   0.00000, 0.00000, 54.66002);
	CreateDynamicObject(3594, -1712.45386, 915.03448, 23.98367,   0.00000, 0.00000, 121.86001);
	CreateDynamicObject(3594, -1701.73560, 926.37543, 23.98367,   0.00000, 0.00000, 67.86002);
	CreateDynamicObject(3594, -1708.07703, 899.26770, 23.98367,   0.00000, 0.00000, 162.71997);
	CreateDynamicObject(3594, -1715.23669, 887.57703, 23.98367,   0.00000, 0.00000, 183.11998);
	CreateDynamicObject(3594, -1709.89526, 879.94641, 23.98367,   0.00000, 0.00000, 62.34003);
	CreateDynamicObject(3594, -1717.03748, 899.56744, 23.98367,   0.00000, 0.00000, 30.72002);
	CreateDynamicObject(10984, -1728.51721, 903.99170, 24.10627,   0.00000, 0.00000, 38.51999);
	CreateDynamicObject(874, -1738.19751, 910.91504, 24.46184,   0.00000, 0.00000, -454.43988);
	CreateDynamicObject(874, -1715.71973, 911.88275, 24.46184,   0.00000, 0.00000, -502.85986);
	CreateDynamicObject(874, -1715.80640, 902.65045, 24.46184,   0.00000, 0.00000, -502.85986);
	CreateDynamicObject(874, -1702.36902, 899.68719, 24.46184,   0.00000, 0.00000, -578.33978);
	CreateDynamicObject(874, -1698.21484, 907.97394, 24.46184,   0.00000, 0.00000, -578.33978);
	CreateDynamicObject(874, -1722.36914, 890.80219, 24.46184,   0.00000, 0.00000, -542.27979);
	CreateDynamicObject(874, -1714.54102, 891.36292, 24.46184,   0.00000, 0.00000, -542.27979);
	CreateDynamicObject(874, -1706.45422, 888.51440, 24.46184,   0.00000, 0.00000, -582.41974);
	CreateDynamicObject(874, -1726.33545, 884.58600, 24.46184,   0.00000, 0.00000, -538.13971);
	CreateDynamicObject(874, -1726.33545, 884.58600, 24.46184,   0.00000, 0.00000, -538.13971);
	CreateDynamicObject(874, -1716.69910, 878.87207, 24.46184,   0.00000, 0.00000, -542.27979);
	CreateDynamicObject(874, -1702.87769, 877.22473, 24.46184,   0.00000, 0.00000, -570.53973);
	CreateDynamicObject(874, -1712.64441, 871.49152, 24.46184,   0.00000, 0.00000, -547.79974);
	CreateDynamicObject(874, -1704.83459, 865.39166, 24.46184,   0.00000, 0.00000, -563.81970);
	CreateDynamicObject(874, -1724.17627, 871.40613, 24.46184,   0.00000, 0.00000, -565.43970);
	CreateDynamicObject(874, -1697.82971, 857.04498, 24.46184,   0.00000, 0.00000, -548.33984);
	CreateDynamicObject(874, -1729.28479, 863.13074, 24.92671,   0.00000, 0.00000, -123.89998);
	CreateDynamicObject(10984, -1696.10132, 865.59894, 24.10627,   0.00000, 0.00000, 38.51999);
	CreateDynamicObject(3920, -1702.54199, 879.71936, 28.30989,   0.00000, 0.00000, -270.00018);
	CreateDynamicObject(3920, -1702.45837, 887.55267, 28.30989,   0.00000, 0.00000, -270.12000);
	CreateDynamicObject(8210, -1693.03577, 849.33447, 26.70121,   0.00000, 0.00000, -90.41998);
	CreateDynamicObject(3095, -1692.60083, 860.43634, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(8210, -1693.03577, 849.33447, 33.75329,   0.00000, 0.00000, -90.41998);
	CreateDynamicObject(3095, -1692.57605, 851.73602, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1692.59119, 842.74628, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1692.63965, 833.82678, 34.93289,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1692.58044, 827.98901, 34.93289,   89.82009, -1.08001, -87.78002);
	CreateDynamicObject(3095, -1692.58044, 827.98901, 26.80515,   89.82009, -1.08001, -87.78002);
	CreateDynamicObject(3095, -1692.63965, 833.82678, 26.66569,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1692.59119, 842.74628, 27.78126,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1692.57605, 851.73602, 27.85315,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(3095, -1692.60083, 860.43634, 27.60464,   89.82009, -1.08001, -89.16002);
	CreateDynamicObject(9812, -1692.11377, 842.73633, 33.24737,   0.00000, 0.00000, -91.08003);
	CreateDynamicObject(9812, -1689.03796, 914.91498, 33.16307,   0.00000, 0.00000, -91.74002);
	CreateDynamicObject(9812, -1717.44019, 966.37598, 33.28702,   0.00000, 0.00000, -0.84000);
	CreateDynamicObject(9812, -1807.45911, 1014.79858, 33.21254,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -1643.95691, 736.67914, 16.31888,   0.00000, 0.00000, -88.44003);
	CreateDynamicObject(8210, -1643.95691, 736.67914, 23.00101,   0.00000, 0.00000, -88.44003);
	CreateDynamicObject(3095, -1643.71692, 740.95874, 17.82593,   -0.90001, -89.22001, 1.56000);
	CreateDynamicObject(3095, -1643.48352, 732.37708, 17.82593,   -0.90001, -89.22001, 1.56000);
	CreateDynamicObject(3095, -1643.23511, 723.37433, 17.82593,   -0.90001, -89.22001, 1.56000);
	CreateDynamicObject(3095, -1643.71692, 740.95874, 24.22889,   -0.90001, -89.22001, 1.56000);
	CreateDynamicObject(3095, -1643.48352, 732.37708, 24.34818,   -0.90001, -89.22001, 1.56000);
	CreateDynamicObject(3095, -1643.23511, 723.37433, 24.45314,   -0.90001, -89.22001, 1.56000);
	CreateDynamicObject(9812, -1643.16870, 748.03119, 22.70429,   0.00000, 0.00000, -89.40000);
	CreateDynamicObject(874, -1660.74841, 725.67834, 17.03098,   12.00000, 4.02000, 70.86002);
	CreateDynamicObject(874, -1661.05786, 736.66095, 17.16335,   12.00000, 4.02000, 103.86003);
	CreateDynamicObject(874, -1652.40369, 725.86395, 14.62163,   7.62000, 8.10000, -19.43997);
	CreateDynamicObject(10984, -1665.39539, 732.89447, 17.41245,   -10.79999, -6.12000, -124.86000);
	CreateDynamicObject(874, -1725.90247, 917.31189, 24.46184,   0.00000, 0.00000, -537.05975);
	CreateDynamicObject(3920, -1804.97705, 957.27057, 39.95979,   0.00000, 0.00000, 270.05984);
	CreateDynamicObject(8210, -1818.48096, 929.12189, 26.73694,   0.00000, 0.00000, 88.74004);
	CreateDynamicObject(8210, -1818.48096, 929.12189, 33.81302,   0.00000, 0.00000, 88.74004);
	CreateDynamicObject(3095, -1818.67346, 939.24249, 34.93289,   89.82009, -1.08001, 89.03999);
	CreateDynamicObject(3095, -1818.96399, 930.38269, 34.93289,   89.82009, -1.08001, 89.03999);
	CreateDynamicObject(3095, -1819.19727, 921.58533, 34.93289,   89.82009, -1.08001, 89.70000);
	CreateDynamicObject(3095, -1819.39526, 912.67993, 34.93289,   89.82009, -1.08001, 89.63999);
	CreateDynamicObject(3095, -1819.64014, 903.70294, 34.93289,   89.82009, -1.08001, 90.11999);
	CreateDynamicObject(3095, -1818.67346, 939.24249, 27.65704,   89.82009, -1.08001, 89.03999);
	CreateDynamicObject(3095, -1818.96399, 930.38269, 27.36047,   89.82009, -1.08001, 89.03999);
	CreateDynamicObject(3095, -1819.19727, 921.58533, 27.49887,   89.82009, -1.08001, 89.70000);
	CreateDynamicObject(3095, -1819.39526, 912.67993, 27.80305,   89.82009, -1.08001, 89.63999);
	CreateDynamicObject(3095, -1819.64014, 903.70294, 27.75742,   89.82009, -1.08001, 90.11999);
	CreateDynamicObject(9812, -1819.48096, 925.94678, 33.43397,   0.00000, 0.00000, 88.55998);
	CreateDynamicObject(3920, -1805.51465, 890.79401, 42.83132,   0.00000, 0.00000, -89.46000);
	CreateDynamicObject(3920, -1805.35071, 878.12195, 42.83132,   0.00000, 0.00000, -89.46000);
	CreateDynamicObject(3920, -1805.49194, 867.34308, 42.83132,   0.00000, 0.00000, -89.46000);
	CreateDynamicObject(3920, -1811.59570, 861.19562, 42.83132,   0.00000, 0.00000, -180.11990);
	CreateDynamicObject(3920, -1824.29419, 861.20972, 42.83132,   0.00000, 0.00000, -180.11990);
	CreateDynamicObject(3920, -1836.92896, 861.18854, 42.83132,   0.00000, 0.00000, -180.11990);
	CreateDynamicObject(8210, -1849.05249, 842.96582, 36.89933,   0.00000, 0.00000, 90.54004);
	CreateDynamicObject(8210, -1849.05249, 842.96582, 43.71912,   0.00000, 0.00000, 90.54004);
	CreateDynamicObject(3095, -1849.60083, 858.65540, 37.79362,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.60291, 849.99030, 37.79362,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.44519, 841.17426, 37.79362,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.45081, 832.48187, 37.79362,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.45715, 828.99695, 37.79362,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.45715, 828.99695, 45.08310,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.45081, 832.48187, 44.94332,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.44519, 841.17426, 44.84346,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(3095, -1849.60291, 849.99030, 44.61982,   -0.18000, 90.53994, 0.00000);
	CreateDynamicObject(3095, -1849.60083, 858.65540, 44.57439,   -1.50000, 89.27997, 0.00000);
	CreateDynamicObject(9812, -1850.09106, 849.98627, 43.17020,   0.00000, 0.00000, 90.60001);
	CreateDynamicObject(874, -1812.11438, 934.59442, 24.46184,   0.00000, 0.00000, 173.64003);
	CreateDynamicObject(874, -1813.74658, 917.59741, 24.46184,   0.00000, 0.00000, 316.20001);
	CreateDynamicObject(874, -1807.26233, 911.87109, 24.46184,   0.00000, 0.00000, 360.95999);
	CreateDynamicObject(874, -1810.47876, 926.24976, 24.46184,   0.00000, 0.00000, 204.78008);
	CreateDynamicObject(3594, -1801.68298, 918.78137, 24.18340,   0.00000, 0.00000, -132.48000);
	CreateDynamicObject(874, -1774.62219, 915.34949, 24.46184,   0.00000, 0.00000, 76.56001);
	CreateDynamicObject(874, -1801.15076, 901.31726, 24.46184,   0.00000, 0.00000, 276.12006);
	CreateDynamicObject(874, -1787.48804, 903.08820, 24.46184,   0.00000, 0.00000, 254.64005);
	CreateDynamicObject(874, -1797.88049, 892.26941, 24.46184,   0.00000, 0.00000, 225.96005);
	CreateDynamicObject(874, -1787.14783, 892.79706, 24.46184,   0.00000, 0.00000, 141.00002);
	CreateDynamicObject(874, -1801.39355, 883.03705, 24.46184,   0.00000, 0.00000, 171.84001);
	CreateDynamicObject(874, -1795.41052, 881.53491, 24.46184,   0.00000, 0.00000, 137.70003);
	CreateDynamicObject(874, -1791.61511, 874.45520, 24.46184,   0.00000, 0.00000, 137.70003);
	CreateDynamicObject(874, -1798.85608, 873.26709, 24.46184,   0.00000, 0.00000, 175.98003);
	CreateDynamicObject(874, -1800.88660, 860.37769, 24.46184,   0.00000, 0.00000, 150.72002);
	CreateDynamicObject(874, -1791.04932, 860.27002, 24.46184,   0.12000, -0.42000, 192.30005);
	CreateDynamicObject(874, -1787.65845, 853.54309, 24.46184,   0.00000, 0.00000, 251.34004);
	CreateDynamicObject(874, -1767.74622, 855.30017, 24.46184,   0.00000, 0.00000, 251.34004);
	CreateDynamicObject(874, -1756.39880, 854.25195, 24.46184,   0.00000, 0.00000, 214.62004);
	CreateDynamicObject(874, -1767.45215, 843.60999, 24.18924,   0.00000, 0.00000, 172.14005);
	CreateDynamicObject(874, -1774.32581, 846.80237, 24.46184,   0.00000, 0.00000, 120.42007);
	CreateDynamicObject(874, -1784.12207, 847.90479, 24.46184,   0.00000, 0.00000, 85.08006);
	CreateDynamicObject(874, -1798.25049, 851.74432, 24.46184,   0.00000, 0.00000, 85.08006);
	CreateDynamicObject(874, -1753.06665, 846.57239, 24.46184,   0.00000, 0.00000, 120.18007);
	CreateDynamicObject(874, -1743.16174, 854.24939, 24.46184,   0.00000, 0.00000, 45.30006);
	CreateDynamicObject(874, -1751.82629, 831.77521, 24.46184,   0.00000, 0.00000, 36.54007);
	CreateDynamicObject(874, -1777.94641, 833.14178, 24.46184,   0.00000, 0.00000, 58.26005);
	CreateDynamicObject(874, -1765.43445, 834.22852, 24.46184,   0.00000, 0.00000, 58.26005);
	CreateDynamicObject(874, -1787.45605, 842.02594, 24.46184,   0.00000, 0.00000, 27.24006);
	CreateDynamicObject(874, -1795.85559, 840.10431, 24.46184,   0.00000, 0.00000, 27.18007);
	CreateDynamicObject(874, -1796.33887, 828.31866, 24.46184,   0.00000, 0.00000, -2.93993);
	CreateDynamicObject(874, -1785.81116, 827.14526, 24.46184,   0.00000, 0.00000, -47.39993);
	CreateDynamicObject(874, -1775.35376, 821.59698, 24.46184,   0.00000, 0.00000, -73.31993);
	CreateDynamicObject(3594, -1796.62048, 896.43060, 24.18340,   0.00000, 0.00000, -112.31999);
	CreateDynamicObject(3594, -1789.58362, 882.75659, 24.18340,   0.00000, 0.00000, -170.16002);
	CreateDynamicObject(3594, -1798.22778, 872.78192, 24.18340,   0.00000, 0.00000, -218.03999);
	CreateDynamicObject(3594, -1788.80200, 869.86517, 24.18340,   0.00000, 0.00000, -244.31998);
	CreateDynamicObject(3594, -1776.74292, 843.73438, 24.18340,   0.00000, 0.00000, -227.88000);
	CreateDynamicObject(3594, -1760.79749, 838.37384, 24.18340,   0.00000, 0.00000, -275.51999);
	CreateDynamicObject(3594, -1763.05334, 853.95007, 24.18340,   0.00000, 0.00000, -233.33995);
	CreateDynamicObject(3594, -1777.00781, 854.14893, 24.18340,   0.00000, 0.00000, -289.19995);
	CreateDynamicObject(3594, -1761.64819, 851.44049, 24.67970,   15.42000, -5.10000, -314.64001);
	CreateDynamicObject(3594, -1792.43652, 833.28546, 24.18340,   0.00000, 0.00000, -253.44002);
	CreateDynamicObject(3502, -1783.32446, 864.91968, 23.88040,   -30.42001, 14.88000, -64.31999);
	CreateDynamicObject(10984, -1777.40540, 865.72754, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(4206, -1788.35938, 861.39990, 23.81584,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -1809.27185, 826.37512, 24.74970,   0.00000, 0.00000, 101.15999);
	CreateDynamicObject(3594, -1803.78589, 845.23120, 24.18340,   0.00000, 0.00000, -333.59998);
	CreateDynamicObject(3594, -1794.33057, 847.10938, 24.18340,   0.00000, 0.00000, -388.43991);
	CreateDynamicObject(3594, -1783.62012, 835.23462, 24.18340,   0.00000, 0.00000, -441.17993);
	CreateDynamicObject(3920, -1773.39636, 860.46942, 28.03484,   0.00000, 0.00000, 180.23984);
	CreateDynamicObject(3920, -1760.68286, 860.51477, 28.03484,   0.00000, 0.00000, 180.23984);
	CreateDynamicObject(3920, -1747.93188, 860.48108, 28.03484,   0.00000, 0.00000, 180.23984);
	CreateDynamicObject(3920, -1735.24207, 860.48328, 28.03484,   0.00000, 0.00000, 180.23984);
	CreateDynamicObject(3920, -1726.98022, 867.49066, 28.03484,   0.00000, 0.00000, 269.39975);
	CreateDynamicObject(3920, -1726.92529, 879.97552, 28.03484,   0.00000, 0.00000, 269.39975);
	CreateDynamicObject(3920, -1726.97766, 892.44269, 28.03484,   0.00000, 0.00000, 269.39975);
	CreateDynamicObject(3920, -1727.18396, 901.62750, 28.03484,   0.00000, 0.00000, 269.39975);
	CreateDynamicObject(3920, -1734.08838, 908.37994, 28.01644,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1746.73950, 908.29840, 28.01644,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1759.32349, 908.35077, 28.01644,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1771.94946, 908.28674, 28.01644,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1780.48218, 901.44257, 28.01644,   0.00000, 0.00000, 89.70000);
	CreateDynamicObject(3920, -1780.45300, 888.79272, 28.01644,   0.00000, 0.00000, 89.70000);
	CreateDynamicObject(3920, -1780.41064, 876.23969, 28.01644,   0.00000, 0.00000, 89.70000);
	CreateDynamicObject(3920, -1780.31055, 867.30402, 28.01644,   0.00000, 0.00000, 89.70000);
	CreateDynamicObject(672, -1799.50537, 848.90527, 24.31113,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(672, -1771.22119, 850.81122, 24.31113,   0.00000, 0.00000, -44.88000);
	CreateDynamicObject(672, -1738.72205, 841.36127, 24.31113,   0.00000, 0.00000, 6.54000);
	CreateDynamicObject(672, -1705.00305, 842.01709, 24.31113,   0.00000, 0.00000, -35.52000);
	CreateDynamicObject(672, -1719.68616, 812.12994, 24.31113,   0.00000, 0.00000, -47.27999);
	CreateDynamicObject(672, -1720.17651, 856.02057, 24.31113,   0.00000, 0.00000, -101.70001);
	CreateDynamicObject(672, -1719.48828, 917.59485, 24.31113,   0.00000, 0.00000, -47.27999);
	CreateDynamicObject(672, -1751.64941, 943.83820, 24.31113,   0.00000, 0.00000, -34.14000);
	CreateDynamicObject(672, -1806.17993, 915.94781, 24.31113,   0.00000, 0.00000, -34.14000);
	CreateDynamicObject(672, -1783.96753, 950.35345, 24.31113,   0.00000, 0.00000, -34.14000);
	CreateDynamicObject(672, -1776.16882, 919.63715, 24.31113,   0.00000, 0.00000, -34.14000);
	CreateDynamicObject(672, -1794.54150, 888.53223, 24.31113,   0.00000, 0.00000, -7.92000);
	CreateDynamicObject(874, -1785.48315, 909.61420, 24.46184,   0.00000, 0.00000, 37.32002);
	CreateDynamicObject(672, -1704.97827, 702.43347, 24.51245,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(672, -1719.65405, 721.49341, 24.51245,   0.00000, 0.00000, -25.80000);
	CreateDynamicObject(672, -1706.92371, 739.61292, 24.51245,   0.00000, 0.00000, -45.60000);
	CreateDynamicObject(3502, -1811.65588, 740.66992, 34.00231,   27.78000, 26.82000, -48.66000);
	CreateDynamicObject(9831, -1808.46094, 775.95538, 28.44046,   -0.18000, -0.06000, 0.84000);
	CreateDynamicObject(9831, -1808.31897, 743.46600, 34.29788,   26.40000, -5.22000, -45.65999);
	CreateDynamicObject(9831, -1808.68115, 799.32416, 25.50643,   -0.18000, -0.06000, 0.84000);
	CreateDynamicObject(9831, -1808.35461, 819.92963, 22.80558,   -0.18000, -0.06000, 0.84000);
	CreateDynamicObject(9831, -1808.83142, 833.70343, 21.00602,   -0.18000, -0.06000, 0.84000);
	CreateDynamicObject(874, -1807.07690, 827.45599, 24.46184,   0.00000, 0.00000, 27.18007);
	CreateDynamicObject(874, -1807.83838, 809.68323, 26.55365,   0.00000, 0.00000, -15.05993);
	CreateDynamicObject(874, -1807.76929, 797.05627, 27.57864,   0.00000, 0.00000, -15.05993);
	CreateDynamicObject(874, -1807.49890, 786.33081, 28.93568,   0.00000, 0.00000, -15.05993);
	CreateDynamicObject(874, -1808.00391, 775.47778, 30.72285,   0.00000, 0.00000, -15.05993);
	CreateDynamicObject(874, -1808.03723, 764.17957, 31.55236,   0.00000, 0.00000, -15.05993);
	CreateDynamicObject(874, -1807.79700, 752.55310, 33.53281,   0.00000, 0.00000, -15.05993);
	CreateDynamicObject(672, -1799.33264, 727.57715, 34.78245,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1794.63208, 752.89294, 25.03898,   0.00000, 0.00000, -89.58004);
	CreateDynamicObject(874, -1799.68298, 734.92126, 34.99782,   0.00000, 0.00000, -89.58004);
	CreateDynamicObject(874, -1793.88318, 729.09027, 34.99782,   0.00000, 0.00000, -54.30003);
	CreateDynamicObject(874, -1804.17639, 738.77319, 34.99782,   0.00000, 0.00000, -126.36004);
	CreateDynamicObject(874, -1804.64038, 727.27661, 34.99782,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1791.88293, 737.34033, 34.99782,   0.00000, 0.00000, -102.84004);
	CreateDynamicObject(874, -1788.59399, 720.56543, 34.99782,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(3920, -1803.32361, 750.94086, 34.09526,   0.00000, 0.00000, -90.83998);
	CreateDynamicObject(3920, -1797.17627, 748.21539, 34.09526,   0.00000, 0.00000, 0.42003);
	CreateDynamicObject(3920, -1785.53271, 748.15094, 34.09526,   0.00000, 0.00000, 0.42003);
	CreateDynamicObject(3920, -1772.71204, 748.22052, 32.28286,   0.00000, 0.00000, 0.42003);
	CreateDynamicObject(3920, -1766.61401, 748.33502, 32.28286,   0.00000, 0.00000, -1.01997);
	CreateDynamicObject(3920, -1753.99390, 748.19586, 29.04552,   0.00000, 0.00000, 0.42003);
	CreateDynamicObject(3920, -1766.63928, 744.06042, 32.27319,   0.00000, 0.00000, -180.17993);
	CreateDynamicObject(874, -1756.31470, 724.93658, 29.56551,   8.87999, 3.00000, 46.50003);
	CreateDynamicObject(874, -1756.67151, 733.44904, 29.56551,   8.87999, 3.00000, 77.58003);
	CreateDynamicObject(874, -1749.63538, 739.14258, 27.74345,   8.87999, 3.00000, 77.58003);
	CreateDynamicObject(874, -1741.95447, 737.98022, 26.14679,   8.87999, 3.00000, 75.42001);
	CreateDynamicObject(874, -1775.40771, 733.85010, 32.36473,   8.87999, 3.00000, 77.58003);
	CreateDynamicObject(874, -1774.07166, 723.47565, 32.36473,   8.87999, 3.00000, 44.58003);
	CreateDynamicObject(874, -1765.48962, 722.59344, 30.76518,   8.87999, 3.00000, 44.58003);
	CreateDynamicObject(874, -1767.08508, 733.01416, 30.76518,   8.87999, 3.00000, 123.48003);
	CreateDynamicObject(874, -1772.03918, 740.16595, 31.39137,   8.87999, 3.00000, 98.16003);
	CreateDynamicObject(874, -1762.94910, 739.45221, 30.12812,   8.87999, 3.00000, 98.16003);
	CreateDynamicObject(874, -1782.20313, 740.43225, 33.43729,   8.87999, 3.00000, 77.58003);
	CreateDynamicObject(874, -1782.69397, 723.97882, 33.43729,   8.87999, 3.00000, 69.12003);
	CreateDynamicObject(874, -1784.73962, 729.51697, 34.32615,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(672, -1790.18140, 734.99634, 34.78245,   0.00000, 0.00000, -28.98000);
	CreateDynamicObject(3594, -1758.80371, 727.98920, 29.69975,   12.05999, -2.10000, 73.19999);
	CreateDynamicObject(3594, -1788.37830, 726.92859, 34.34801,   0.00000, 0.00000, -17.28000);
	CreateDynamicObject(3594, -1795.76196, 731.31323, 34.34801,   0.00000, 0.00000, -101.28001);
	CreateDynamicObject(3594, -1805.25525, 729.45538, 34.34801,   0.00000, 0.00000, -163.32004);
	CreateDynamicObject(3920, -1773.84558, 718.54205, 47.12226,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1817.81677, 743.23309, 43.43458,   0.00000, 0.00000, 179.88002);
	CreateDynamicObject(3920, -1830.50085, 743.16760, 43.43458,   0.00000, 0.00000, 179.88002);
	CreateDynamicObject(3920, -1843.19116, 743.20007, 43.43458,   0.00000, 0.00000, 179.88002);
	CreateDynamicObject(8210, -1899.83411, 752.64209, 47.30683,   0.00000, 0.00000, 0.42000);
	CreateDynamicObject(745, -1807.86292, 778.57611, 29.32449,   -8.93999, -12.12000, 23.58002);
	CreateDynamicObject(744, -1810.20813, 764.98889, 30.77515,   0.00000, 0.00000, -18.84001);
	CreateDynamicObject(747, -1809.04004, 797.49902, 27.04679,   -5.10000, -7.68000, -48.78001);
	CreateDynamicObject(3594, -1809.13293, 775.33398, 31.64839,   14.94000, 4.26000, -21.00000);
	CreateDynamicObject(672, -1760.11487, 738.82141, 30.01981,   0.00000, 0.00000, -64.25999);
	CreateDynamicObject(8210, -1572.45605, 698.60608, 8.84253,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -1572.45605, 698.60608, 15.95128,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3095, -1549.72180, 699.03772, 10.33048,   90.83997, 3.83999, -3.96000);
	CreateDynamicObject(3095, -1558.61841, 699.09534, 10.33048,   90.83997, 3.83999, -3.96000);
	CreateDynamicObject(3095, -1567.61169, 699.12500, 10.33048,   90.83997, 3.83999, -3.96000);
	CreateDynamicObject(3095, -1567.61169, 699.12500, 17.22409,   90.83997, 3.83999, -3.96000);
	CreateDynamicObject(3095, -1558.61841, 699.09534, 17.26874,   90.83997, 3.83999, -3.96000);
	CreateDynamicObject(3095, -1549.72180, 699.03772, 17.29183,   90.83997, 3.83999, -3.96000);
	CreateDynamicObject(9812, -1575.53931, 699.06396, 15.48662,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -1527.89075, 721.09094, 8.84253,   0.00000, 0.00000, 54.23997);
	CreateDynamicObject(8210, -1502.26660, 699.04663, 8.84253,   0.00000, 0.00000, -126.78004);
	CreateDynamicObject(8210, -1527.89075, 721.09094, 16.02450,   0.00000, 0.00000, 54.23997);
	CreateDynamicObject(8210, -1502.26660, 699.04663, 15.85553,   0.00000, 0.00000, -126.78004);
	CreateDynamicObject(8210, -1506.39502, 739.69025, 8.84253,   0.00000, 0.00000, -41.58004);
	CreateDynamicObject(8210, -1506.39502, 739.69025, 16.25211,   0.00000, 0.00000, -41.58004);
	CreateDynamicObject(3095, -1540.41821, 704.35791, 10.33048,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1540.41821, 704.35791, 17.29659,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1535.18762, 711.57666, 10.33048,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1529.91418, 718.88031, 10.33048,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1524.68921, 726.14508, 10.33048,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1519.60962, 733.21478, 10.33048,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1514.34424, 740.54083, 10.33048,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1535.18762, 711.57666, 17.33125,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1529.91418, 718.88031, 17.31233,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1524.68921, 726.14508, 17.30178,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1519.45837, 733.34918, 17.30178,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1514.23096, 740.54077, 17.30178,   90.83997, 3.83999, 50.22000);
	CreateDynamicObject(3095, -1507.43311, 741.17462, 17.30178,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1500.71143, 735.20813, 17.30178,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1494.03601, 729.28851, 17.30178,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1488.25452, 724.16565, 17.30178,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1488.25452, 724.16565, 9.17557,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1494.03601, 729.28851, 9.75959,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1500.71143, 735.20813, 9.83517,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1507.43311, 741.17462, 9.93057,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1487.94043, 717.24408, 9.17557,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1493.21887, 710.35352, 9.17557,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1498.59009, 703.27985, 9.17557,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1503.88867, 696.28510, 9.17557,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1509.04895, 689.50024, 9.17557,   90.83997, 3.83999, -130.50003);
	CreateDynamicObject(3095, -1514.30432, 682.50201, 9.17557,   90.83997, 3.83999, -130.50003);
	CreateDynamicObject(3095, -1515.58008, 680.73395, 9.17557,   90.83997, 3.83999, -130.50003);
	CreateDynamicObject(3095, -1515.58008, 680.73395, 16.93967,   90.83997, 3.83999, -130.50003);
	CreateDynamicObject(3095, -1514.30432, 682.50201, 16.93966,   90.83997, 3.83999, -130.50003);
	CreateDynamicObject(3095, -1509.04895, 689.50024, 16.93966,   90.83997, 3.83999, -130.50003);
	CreateDynamicObject(3095, -1503.88867, 696.28510, 16.81508,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1498.59009, 703.27985, 16.72973,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1493.21887, 710.35352, 16.77033,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(3095, -1487.94043, 717.24408, 16.79215,   90.83997, 3.83999, -131.75998);
	CreateDynamicObject(2934, -1537.12708, 692.91174, 13.21949,   0.00000, 0.00000, 48.42002);
	CreateDynamicObject(2934, -1525.64038, 682.66217, 13.21949,   0.00000, 0.00000, 48.42002);
	CreateDynamicObject(971, -1531.51685, 687.32825, 9.66536,   0.00000, 0.00000, -41.40001);
	CreateDynamicObject(2932, -1535.56140, 691.49158, 8.30722,   -90.12000, -11.34001, -142.07980);
	CreateDynamicObject(2932, -1527.26196, 684.03955, 8.30722,   -90.12000, -11.34001, 36.24001);
	CreateDynamicObject(2934, -1531.76184, 688.19202, 13.21949,   0.00000, 0.00000, 48.42002);
	CreateDynamicObject(2934, -1527.55701, 684.42365, 13.21949,   0.00000, 0.00000, 48.42002);
	CreateDynamicObject(2932, -1540.83826, 696.30994, 15.10077,   -90.12000, -11.34001, -142.07980);
	CreateDynamicObject(2932, -1521.91028, 679.40717, 15.10077,   -90.12000, -11.34001, -142.07980);
	CreateDynamicObject(2934, -1523.55518, 684.98993, 7.56768,   0.00000, 0.00000, 48.42002);
	CreateDynamicObject(2934, -1535.08899, 695.29376, 7.56768,   0.00000, 0.00000, 48.42002);
	CreateDynamicObject(2932, -1533.53430, 693.77783, 8.30722,   -90.12000, -11.34001, -142.07980);
	CreateDynamicObject(2932, -1525.21582, 686.41736, 8.30722,   -90.12000, -11.34001, 36.24001);
	CreateDynamicObject(16644, -1530.71704, 690.25372, 11.86434,   0.00000, 0.00000, -41.27999);
	CreateDynamicObject(19313, -1523.55640, 679.35760, 9.44964,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1540.39905, 695.39551, 9.44964,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1538.29004, 695.84473, 21.94452,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1528.01099, 686.40875, 21.94452,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1523.56750, 682.43018, 21.94452,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1538.29004, 695.84473, 28.38525,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1538.29004, 695.84473, 35.01769,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1538.29004, 695.84473, 40.47204,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1528.01099, 686.40875, 28.40021,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1528.01099, 686.40875, 34.97952,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1528.01099, 686.40875, 38.46407,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1523.56750, 682.43018, 28.31959,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1523.56750, 682.43018, 34.69310,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(19313, -1523.56750, 682.43018, 38.45177,   0.00000, 0.00000, 137.46005);
	CreateDynamicObject(16644, -1537.82312, 690.45575, 18.60887,   0.00000, 0.00000, -41.88000);
	CreateDynamicObject(16644, -1529.79102, 683.19055, 18.60887,   0.00000, 0.00000, -41.88000);
	CreateDynamicObject(3268, -1505.10291, 723.58759, 6.17669,   0.00000, 0.00000, 52.02003);
	CreateDynamicObject(19364, -1523.97522, 723.61603, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1525.93994, 721.07336, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1527.88843, 718.54480, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1529.82288, 716.01392, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1529.45459, 713.76270, 7.85346,   0.00000, 0.00000, 50.99998);
	CreateDynamicObject(19364, -1526.94946, 711.73871, 7.85346,   0.00000, 0.00000, 50.99998);
	CreateDynamicObject(19364, -1524.48279, 709.75958, 7.85346,   0.00000, 0.00000, 50.99998);
	CreateDynamicObject(19364, -1522.30859, 710.13782, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1519.53064, 720.19592, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1521.50818, 717.66119, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1523.47241, 715.16937, 7.85346,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19393, -1522.71045, 712.38672, 7.85488,   0.00000, 0.00000, 51.66000);
	CreateDynamicObject(19364, -1525.18921, 714.38397, 7.85346,   0.00000, 0.00000, 50.99998);
	CreateDynamicObject(19393, -1527.55200, 716.25507, 7.85488,   0.00000, 0.00000, 51.66000);
	CreateDynamicObject(19364, -1523.97522, 723.61603, 11.32521,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1525.93994, 721.07336, 11.33962,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1527.88843, 718.54480, 11.34862,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1527.55200, 716.22803, 11.33704,   0.00000, 0.00000, 50.99998);
	CreateDynamicObject(19364, -1519.53064, 720.19592, 11.30493,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1521.50818, 717.66119, 11.32796,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1523.47241, 715.16937, 11.33093,   0.00000, 0.00000, -37.67999);
	CreateDynamicObject(19364, -1525.72974, 714.79620, 11.34970,   0.00000, 0.00000, 50.99998);
	CreateDynamicObject(19364, -1521.74158, 723.84790, 7.85346,   0.00000, 0.00000, 52.20000);
	CreateDynamicObject(19364, -1519.89636, 722.44519, 7.85346,   0.00000, 0.00000, 52.20000);
	CreateDynamicObject(19364, -1521.72375, 723.85730, 11.29711,   0.00000, 0.00000, 52.20000);
	CreateDynamicObject(19364, -1519.89636, 722.44519, 11.33099,   0.00000, 0.00000, 52.20000);
	CreateDynamicObject(19355, -1523.70337, 711.17249, 9.53344,   -0.24000, 89.58020, -38.04000);
	CreateDynamicObject(19355, -1524.91492, 716.10938, 12.98514,   -0.90000, 89.34021, -38.04000);
	CreateDynamicObject(19355, -1526.42883, 717.45868, 12.98514,   -0.90000, 89.34021, -38.04000);
	CreateDynamicObject(19355, -1524.50146, 720.00677, 12.98514,   -0.90000, 89.34021, -38.04000);
	CreateDynamicObject(19355, -1523.00537, 718.70038, 12.98514,   -0.90000, 89.34021, -38.04000);
	CreateDynamicObject(19355, -1522.51697, 722.38757, 12.98514,   -0.90000, 89.34021, -38.04000);
	CreateDynamicObject(19355, -1521.02039, 721.18195, 12.98514,   -0.90000, 89.34021, -38.04000);
	CreateDynamicObject(1499, -1522.13306, 711.89685, 6.18512,   0.00000, 0.00000, 140.39990);
	CreateDynamicObject(1499, -1526.96960, 715.80713, 6.18512,   0.00000, 0.00000, 141.11987);
	CreateDynamicObject(19360, -1522.53430, 722.57990, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1520.96069, 721.29260, 6.12535,   -0.30000, -89.64005, -36.29999);
	CreateDynamicObject(19360, -1524.52136, 720.10645, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1522.85608, 718.86975, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1524.85083, 716.35693, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1526.41821, 717.54620, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1528.32288, 714.98163, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1525.72632, 712.77710, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19360, -1523.75500, 711.28174, 6.12535,   -0.30000, -89.64005, -37.92000);
	CreateDynamicObject(19355, -1526.42017, 713.29742, 9.53344,   -0.24000, 89.58020, -38.04000);
	CreateDynamicObject(19355, -1528.43274, 714.97198, 9.53344,   -0.24000, 89.58020, -38.04000);
	CreateDynamicObject(16782, -1520.81311, 722.86902, 9.07886,   0.00000, 0.00000, -127.80002);
	CreateDynamicObject(3397, -1521.04480, 722.25861, 6.21412,   0.00000, 0.00000, 51.42002);
	CreateDynamicObject(3388, -1522.90991, 723.93719, 6.21240,   0.00000, 0.00000, 243.17992);
	CreateDynamicObject(3387, -1520.41675, 720.18146, 6.20651,   0.00000, 0.00000, -35.69999);
	CreateDynamicObject(3391, -1522.01440, 718.22491, 6.20888,   0.00000, 0.00000, -38.45999);
	CreateDynamicObject(3383, -1525.36780, 720.22565, 6.20308,   0.00000, 0.00000, -128.27998);
	CreateDynamicObject(3388, -1523.98755, 722.47949, 6.21240,   0.00000, 0.00000, 145.73991);
	CreateDynamicObject(2907, -1524.82507, 721.06305, 7.25732,   0.00000, 0.00000, -227.09995);
	CreateDynamicObject(2907, -1525.45471, 720.35406, 7.25732,   0.00000, 0.00000, -135.41992);
	CreateDynamicObject(2001, -1530.01038, 714.79395, 6.15119,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2001, -1523.32019, 709.39606, 6.15119,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16096, -1533.78784, 701.07520, 7.88946,   0.00000, 0.00000, 141.48012);
	CreateDynamicObject(3576, -1518.38452, 718.52618, 7.59657,   0.00000, 0.00000, 51.59997);
	CreateDynamicObject(3928, -1512.07886, 730.14850, 13.49806,   -9.30000, -0.18000, 50.76003);
	CreateDynamicObject(3399, -1532.67834, 710.30469, 7.39675,   0.00000, 0.00000, 52.85999);
	CreateDynamicObject(2932, -1525.15369, 712.26947, 11.01354,   0.00000, 0.00000, 52.14000);
	CreateDynamicObject(3279, -1528.21667, 707.27911, 6.18152,   0.00000, 0.00000, -37.50000);
	CreateDynamicObject(3578, -1503.00464, 710.19824, 6.92356,   0.00000, 0.00000, -37.74001);
	CreateDynamicObject(3578, -1518.51099, 722.31238, 6.92356,   0.00000, 0.00000, -37.74001);
	CreateDynamicObject(3578, -1515.22559, 718.52533, 6.92356,   0.00000, 0.00000, -127.56002);
	CreateDynamicObject(3578, -1507.97668, 712.49371, 6.92356,   0.00000, 0.00000, -127.62002);
	CreateDynamicObject(973, -1507.83191, 712.64276, 8.36519,   0.00000, 0.00000, 52.73998);
	CreateDynamicObject(973, -1514.97302, 718.68060, 8.36519,   0.00000, 0.00000, 232.86003);
	CreateDynamicObject(3928, -1499.17078, 718.91925, 13.81910,   9.11999, 0.12000, 50.70001);
	CreateDynamicObject(2932, -1540.83826, 696.30994, 9.67133,   -90.12000, -11.34001, -142.07980);
	CreateDynamicObject(2932, -1521.91028, 679.40717, 9.12032,   -90.12000, -11.34001, -142.07980);
	CreateDynamicObject(874, -1559.69653, 684.59564, 6.65484,   0.00000, 0.00000, -43.14000);
	CreateDynamicObject(874, -1552.87402, 682.15576, 6.65484,   0.00000, 0.00000, -12.00000);
	CreateDynamicObject(874, -1546.01428, 683.88641, 6.65484,   0.00000, 0.00000, 10.02000);
	CreateDynamicObject(874, -1540.40967, 677.51086, 6.65484,   0.00000, 0.00000, -72.60001);
	CreateDynamicObject(874, -1538.71985, 671.42236, 6.65484,   0.00000, 0.00000, -47.94000);
	CreateDynamicObject(874, -1551.98804, 670.66589, 6.65484,   0.00000, 0.00000, -47.94000);
	CreateDynamicObject(874, -1547.52124, 668.87524, 6.65484,   0.00000, 0.00000, -204.60001);
	CreateDynamicObject(874, -1531.84314, 672.50482, 6.65484,   0.00000, 0.00000, -252.36003);
	CreateDynamicObject(874, -1544.20728, 683.67151, 6.65484,   0.00000, 0.00000, -167.87996);
	CreateDynamicObject(874, -1523.94958, 668.69623, 6.65484,   0.00000, 0.00000, -287.87997);
	CreateDynamicObject(874, -1538.47083, 660.95062, 6.65484,   0.00000, 0.00000, -375.18002);
	CreateDynamicObject(874, -1532.72400, 666.06256, 6.65484,   0.00000, 0.00000, -446.39993);
	CreateDynamicObject(874, -1547.44275, 658.56750, 6.65484,   0.00000, 0.00000, -529.13989);
	CreateDynamicObject(874, -1555.04346, 656.69598, 6.65484,   0.00000, 0.00000, -529.13989);
	CreateDynamicObject(874, -1563.82434, 669.57117, 6.65484,   0.00000, 0.00000, -553.85980);
	CreateDynamicObject(874, -1567.40039, 691.30933, 6.65484,   0.00000, 0.00000, -590.63953);
	CreateDynamicObject(874, -1553.56628, 693.33240, 6.65484,   0.00000, 0.00000, -626.51929);
	CreateDynamicObject(874, -1564.73987, 661.21179, 6.59401,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1542.03809, 652.22742, 6.65484,   0.00000, 0.00000, -791.09918);
	CreateDynamicObject(874, -1536.85376, 648.20410, 6.65484,   0.00000, 0.00000, -717.23920);
	CreateDynamicObject(874, -1542.19080, 641.17847, 6.65484,   0.00000, 0.00000, -742.31915);
	CreateDynamicObject(874, -1536.51440, 635.24109, 6.65484,   0.00000, 0.00000, -731.15942);
	CreateDynamicObject(874, -1541.45117, 626.13647, 6.65484,   0.00000, 0.00000, -755.75940);
	CreateDynamicObject(874, -1535.17798, 621.24353, 6.65484,   0.00000, 0.00000, -740.09937);
	CreateDynamicObject(874, -1541.32544, 612.59277, 6.65484,   0.00000, 0.00000, -735.71954);
	CreateDynamicObject(874, -1535.34924, 608.68396, 6.65484,   0.00000, 0.00000, -745.55933);
	CreateDynamicObject(874, -1543.09180, 598.55316, 6.65484,   0.00000, 0.00000, -710.15930);
	CreateDynamicObject(874, -1537.08057, 593.92627, 6.65484,   0.00000, 0.00000, -915.53943);
	CreateDynamicObject(874, -1512.92407, 668.02307, 6.65484,   0.00000, 0.00000, -287.87997);
	CreateDynamicObject(874, -1502.07410, 667.84424, 6.65484,   0.00000, 0.00000, -287.87997);
	CreateDynamicObject(874, -1492.29248, 667.71277, 6.65484,   0.00000, 0.00000, -287.87997);
	CreateDynamicObject(874, -1487.80713, 678.38440, 6.65484,   0.00000, 0.00000, -375.41992);
	CreateDynamicObject(874, -1497.16992, 677.77979, 6.65484,   0.00000, 0.00000, -375.41992);
	CreateDynamicObject(874, -1505.71936, 678.02625, 6.65484,   0.00000, 0.00000, -391.55994);
	CreateDynamicObject(874, -1511.10413, 677.61475, 6.65484,   0.00000, 0.00000, -408.29993);
	CreateDynamicObject(874, -1501.65515, 688.54865, 6.65484,   0.00000, 0.00000, -408.29993);
	CreateDynamicObject(874, -1494.77393, 697.05579, 6.65484,   0.00000, 0.00000, -408.29993);
	CreateDynamicObject(874, -1488.91797, 706.77179, 6.65484,   0.00000, 0.00000, -408.29993);
	CreateDynamicObject(874, -1492.90076, 687.59961, 6.65484,   0.00000, 0.00000, -408.29993);
	CreateDynamicObject(874, -1487.69482, 693.05688, 6.65484,   0.00000, 0.00000, -375.95978);
	CreateDynamicObject(874, -1570.21863, 651.57050, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1556.46021, 650.53912, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1550.54932, 643.00458, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1564.55261, 643.04144, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1556.69873, 639.64441, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1550.03333, 640.45734, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1564.07068, 633.10797, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1556.59338, 629.82684, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1550.11890, 621.83423, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1564.31921, 623.81250, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1557.05835, 620.46863, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1549.81226, 610.70673, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1565.10034, 615.04382, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1556.21143, 608.83862, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1551.90393, 599.55042, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1546.60046, 593.55945, 6.65484,   0.00000, 0.00000, -702.23926);
	CreateDynamicObject(874, -1556.17725, 593.34247, 6.65484,   0.00000, 0.00000, -666.59924);
	CreateDynamicObject(874, -1563.05396, 601.88263, 6.65484,   0.00000, 0.00000, -666.59924);
	CreateDynamicObject(874, -1566.62329, 595.52802, 6.65484,   0.00000, 0.00000, -698.57916);
	CreateDynamicObject(874, -1568.70081, 673.11395, 6.65484,   0.00000, 0.00000, -553.85980);
	CreateDynamicObject(855, -1552.22424, 629.34045, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1542.21912, 651.49359, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1558.58972, 669.33722, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1563.64880, 618.95050, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1535.13745, 653.29022, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1538.75562, 628.86121, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1542.22095, 601.89349, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(855, -1556.34973, 597.22632, 7.36265,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -1548.29272, 624.49841, 6.77539,   0.00000, 0.00000, -16.26000);
	CreateDynamicObject(3594, -1560.70569, 634.28888, 6.77539,   0.00000, 0.00000, 33.90000);
	CreateDynamicObject(3594, -1540.87634, 647.10162, 6.77539,   0.00000, 0.00000, -30.60001);
	CreateDynamicObject(3594, -1556.08423, 658.39502, 6.77539,   0.00000, 0.00000, -20.82002);
	CreateDynamicObject(3594, -1562.05383, 647.59088, 6.77539,   0.00000, 0.00000, 40.49998);
	CreateDynamicObject(3594, -1560.89417, 650.18353, 6.77539,   -24.48002, 25.13999, -22.62002);
	CreateDynamicObject(10984, -1548.87891, 631.80365, 6.76845,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -1559.22363, 651.58746, 6.18902,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -1564.67871, 665.54712, 6.77539,   0.00000, 0.00000, 25.97999);
	CreateDynamicObject(3594, -1554.85791, 682.23407, 6.77539,   0.00000, 0.00000, -52.86001);
	CreateDynamicObject(3594, -1554.67236, 594.95947, 6.30605,   0.00000, 0.00000, -28.08000);
	CreateDynamicObject(3594, -1562.76379, 593.51337, 6.30605,   0.00000, 0.00000, 45.23999);
	CreateDynamicObject(3594, -1563.80371, 612.74640, 6.30605,   0.00000, 0.00000, 139.79999);
	CreateDynamicObject(3594, -1542.45752, 602.85510, 6.53724,   0.00000, 0.00000, 63.42001);
	CreateDynamicObject(3594, -1552.93799, 608.44562, 6.53724,   0.00000, 0.00000, 31.20001);
	CreateDynamicObject(672, -1499.45129, 682.58374, 6.68487,   0.00000, 0.00000, -86.99999);
	CreateDynamicObject(672, -1496.06104, 667.93774, 6.68487,   0.00000, 0.00000, -11.16000);
	CreateDynamicObject(672, -1511.54688, 666.63885, 6.68487,   0.00000, 0.00000, -23.22000);
	CreateDynamicObject(672, -1545.49939, 648.71692, 6.68487,   0.00000, 0.00000, -23.22000);
	CreateDynamicObject(672, -1536.82971, 617.98956, 6.68487,   0.00000, 0.00000, -62.88000);
	CreateDynamicObject(672, -1559.57043, 621.65918, 6.68487,   0.00000, 0.00000, -47.28000);
	CreateDynamicObject(672, -1562.16260, 686.83960, 6.68487,   0.00000, 0.00000, -75.95999);
	CreateDynamicObject(3877, -1540.09229, 694.18085, 14.12761,   0.00000, 0.00000, 54.23999);
	CreateDynamicObject(3877, -1524.08044, 679.86713, 14.12761,   0.00000, 0.00000, 54.23999);
	CreateDynamicObject(3877, -1531.70764, 686.97205, 14.12761,   0.00000, 0.00000, 54.23999);
	CreateDynamicObject(19313, -1517.84448, 706.39545, 9.33822,   -89.46031, -86.28021, -33.83998);
	CreateDynamicObject(19313, -1525.86707, 696.12262, 5.85674,   -60.24029, -88.38023, -36.83999);
	CreateDynamicObject(19313, -1509.95898, 716.68256, 5.73260,   -57.72025, -90.18021, 142.86006);
	CreateDynamicObject(970, -1518.22131, 700.53522, 9.85601,   0.00000, 0.00000, 52.62000);
	CreateDynamicObject(970, -1515.18726, 704.45911, 9.85601,   0.00000, 0.00000, 52.62000);
	CreateDynamicObject(970, -1512.26013, 708.26990, 9.85601,   0.00000, 0.00000, 52.68000);
	CreateDynamicObject(970, -1517.39343, 712.25031, 9.85601,   0.00000, 0.00000, 52.68000);
	CreateDynamicObject(970, -1523.38843, 704.50806, 9.85601,   0.00000, 0.00000, 52.68000);
	CreateDynamicObject(970, -1520.31262, 708.48431, 9.85601,   0.00000, 0.00000, 52.80000);
	CreateDynamicObject(16096, -1506.29749, 707.45728, 7.88946,   0.00000, 0.00000, 141.48012);
	CreateDynamicObject(3279, -1513.20288, 692.55847, 6.18152,   0.00000, 0.00000, -218.87996);
	CreateDynamicObject(672, -1545.28174, 683.25793, 6.68487,   0.00000, 0.00000, -60.90000);
	CreateDynamicObject(3095, -1485.70300, 721.85315, 9.17557,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1485.78760, 721.77673, 17.29036,   90.83997, 3.83999, -45.29999);
	CreateDynamicObject(3095, -1483.17896, 723.15588, 9.17557,   90.83997, 3.83999, 87.42001);
	CreateDynamicObject(3095, -1483.05872, 723.15997, 17.33561,   90.05997, 2.87999, 87.42001);
	CreateDynamicObject(672, -1485.60205, 712.66278, 6.68487,   0.00000, 0.00000, 33.12000);
	CreateDynamicObject(9812, -1601.97241, 688.57745, 19.31762,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1576.16296, 682.34088, 6.59401,   0.00000, 0.00000, -750.77917);
	CreateDynamicObject(874, -1576.81250, 653.95917, 6.59401,   0.00000, 0.00000, -750.77917);
	CreateDynamicObject(874, -1580.19800, 667.89221, 6.59401,   0.00000, 0.00000, -960.29919);
	CreateDynamicObject(874, -1577.80652, 662.01495, 6.59401,   0.00000, 0.00000, -1005.53925);
	CreateDynamicObject(874, -1585.70386, 674.59375, 6.59401,   0.00000, 0.00000, -980.33923);
	CreateDynamicObject(874, -1587.17249, 655.46466, 6.59401,   0.00000, 0.00000, -988.91931);
	CreateDynamicObject(874, -1587.06262, 661.77032, 6.59401,   0.00000, 0.00000, -936.89935);
	CreateDynamicObject(874, -1595.31421, 663.23395, 6.59401,   0.00000, 0.00000, -908.39941);
	CreateDynamicObject(874, -1595.41821, 652.06348, 6.59401,   0.00000, 0.00000, -847.01935);
	CreateDynamicObject(672, -1594.78162, 666.13538, 6.68487,   0.00000, 0.00000, -75.95999);
	CreateDynamicObject(703, -1548.21155, 599.05780, 5.29136,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -1751.35205, 929.46814, 22.86509,   0.00000, 0.00000, 13.74000);
	CreateDynamicObject(874, -1812.07690, 838.82349, 25.16991,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1810.18555, 845.39087, 25.16991,   12.41998, 10.80001, 27.06007);
	CreateDynamicObject(874, -1808.16675, 854.85315, 25.16991,   12.41998, 10.80001, 27.06007);
	CreateDynamicObject(874, -1818.83289, 834.16687, 27.50187,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1819.25952, 844.79559, 27.50187,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1816.31848, 854.15723, 27.50187,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1826.80103, 854.35858, 29.86948,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1828.32776, 844.18768, 29.86948,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1828.50793, 834.32806, 29.86948,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1838.02368, 835.19672, 32.30801,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1837.36316, 842.73810, 32.30801,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1836.98022, 853.83112, 31.49579,   12.41998, 10.80001, 27.18007);
	CreateDynamicObject(874, -1800.33789, 836.81873, 23.63275,   9.47998, 10.44001, 46.32011);
	CreateDynamicObject(703, -1826.26062, 836.32739, 26.29287,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -1833.09827, 851.09601, 30.85905,   13.62000, 10.62000, -333.59998);
	CreateDynamicObject(874, -1735.09949, 822.83514, 24.92671,   0.00000, 0.00000, 30.84000);
	CreateDynamicObject(9812, -1727.96948, 677.06348, 31.29383,   0.00000, 0.00000, 90.05999);
	CreateDynamicObject(874, -1718.96362, 682.42456, 25.03898,   0.06000, 0.78000, -319.02014);
	CreateDynamicObject(874, -1723.51013, 673.18274, 25.03898,   0.06000, 0.78000, -397.32010);
	CreateDynamicObject(3594, -1541.01685, 615.16095, 6.77539,   0.00000, 0.00000, 39.54000);
	CreateDynamicObject(3920, -1612.35681, 679.58087, 15.91605,   0.00000, 0.00000, 179.87979);
	CreateDynamicObject(3920, -1599.75757, 679.60474, 15.91605,   0.00000, 0.00000, 179.87979);
	CreateDynamicObject(3920, -1588.07751, 679.60614, 15.91605,   0.00000, 0.00000, 179.87979);
	CreateDynamicObject(3920, -1618.59155, 685.73834, 15.91605,   0.00000, 0.00000, 90.29979);
	CreateDynamicObject(3920, -1581.96582, 685.80182, 15.91605,   0.00000, 0.00000, 270.29962);
	CreateDynamicObject(855, -1612.14612, 684.47736, 16.14916,   0.00000, 0.00000, -23.88000);
	CreateDynamicObject(855, -1600.55811, 684.91895, 16.14916,   0.00000, 0.00000, -3.96000);
	CreateDynamicObject(855, -1594.80554, 683.43958, 16.14916,   0.00000, 0.00000, -24.54000);
	CreateDynamicObject(874, -1591.31604, 687.54492, 16.15053,   0.00000, 0.00000, 63.72000);
	CreateDynamicObject(874, -1599.93689, 687.40979, 15.65749,   0.00000, 0.00000, 63.72000);
	CreateDynamicObject(874, -1609.80261, 685.37952, 17.13662,   0.00000, 0.00000, -96.36001);
	CreateDynamicObject(874, -1588.46179, 650.15222, 6.59401,   0.00000, 0.00000, -834.17938);
	CreateDynamicObject(3594, -1611.69373, 673.87830, 6.68268,   0.00000, 0.00000, -16.20000);
	CreateDynamicObject(3594, -1604.71191, 670.22595, 6.68268,   0.00000, 0.00000, 21.60000);
	CreateDynamicObject(3594, -1606.35071, 657.76819, 6.68268,   0.00000, 0.00000, -52.62000);
	CreateDynamicObject(3594, -1589.66296, 661.89435, 6.68268,   0.00000, 0.00000, -26.76001);
	CreateDynamicObject(3594, -1592.15015, 675.44482, 6.68268,   0.00000, 0.00000, -74.64000);
	CreateDynamicObject(3594, -1608.69934, 659.46729, 7.12460,   26.10000, 5.28000, -113.34000);
	CreateDynamicObject(10984, -1607.10486, 658.34802, 5.84485,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -1613.13647, 664.18433, 6.88777,   0.00000, 0.00000, -41.46000);
	CreateDynamicObject(3594, -1614.87146, 650.38464, 6.68268,   0.00000, 0.00000, 58.97999);
	CreateDynamicObject(874, -1605.34241, 649.84796, 6.59401,   0.00000, 0.00000, -842.87952);
	CreateDynamicObject(874, -1615.26050, 656.78400, 6.59401,   0.00000, 0.00000, -865.19946);
	CreateDynamicObject(874, -1619.89050, 649.99261, 6.59401,   0.00000, 0.00000, -852.11951);
	CreateDynamicObject(874, -1602.11865, 662.91278, 6.59401,   0.00000, 0.00000, -864.35931);
	CreateDynamicObject(874, -1598.93164, 672.19672, 6.59401,   0.00000, 0.00000, -828.05933);
	CreateDynamicObject(874, -1610.92725, 673.84064, 6.59401,   0.00000, 0.00000, -828.05933);
	CreateDynamicObject(874, -1620.77222, 667.70215, 6.59401,   0.00000, 0.00000, -786.71936);
	CreateDynamicObject(874, -1624.65125, 657.52881, 6.59401,   0.00000, 0.00000, -765.29938);
	CreateDynamicObject(874, -1614.16943, 662.92865, 6.59401,   0.00000, 0.00000, -852.11951);
	CreateDynamicObject(874, -1631.78638, 653.61987, 6.59401,   0.00000, 0.00000, -694.55945);
	CreateDynamicObject(874, -1635.68958, 653.62054, 6.59401,   0.00000, 0.00000, -745.43939);
	CreateDynamicObject(874, -1635.87781, 665.25549, 6.59401,   0.00000, 0.00000, -745.43939);
	CreateDynamicObject(874, -1628.90930, 665.38690, 6.59401,   0.00000, 0.00000, -745.43939);
	CreateDynamicObject(874, -1635.90405, 676.55371, 6.59401,   0.00000, 0.00000, -745.43939);
	CreateDynamicObject(874, -1628.00317, 678.15576, 6.59401,   0.00000, 0.00000, -745.43939);
	CreateDynamicObject(874, -1620.59998, 677.57379, 6.59401,   0.00000, 0.00000, -745.43939);
	CreateDynamicObject(703, -1629.04126, 673.11304, 5.41182,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -1579.58008, 654.16138, 6.68268,   0.00000, 0.00000, -83.75999);
	CreateDynamicObject(3920, -1572.00977, 694.43542, 15.91605,   0.00000, 0.00000, 270.23962);
	CreateDynamicObject(3920, -1571.09058, 693.69507, 24.51834,   0.00000, 0.00000, 270.23962);
	CreateDynamicObject(3920, -1571.11108, 706.35156, 24.51834,   0.00000, 0.00000, 270.23962);
	CreateDynamicObject(647, -1541.03845, 636.31366, 7.46806,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(647, -1551.90356, 645.00299, 7.46806,   0.00000, 0.00000, -54.84000);
	CreateDynamicObject(647, -1544.15405, 649.69971, 7.46806,   0.00000, 0.00000, -54.84000);
	CreateDynamicObject(647, -1536.23877, 661.88995, 7.46806,   0.00000, 0.00000, -17.52000);
	CreateDynamicObject(647, -1550.76111, 672.53931, 7.46806,   0.00000, 0.00000, -75.30000);
	CreateDynamicObject(647, -1550.03394, 670.70990, 7.46806,   0.00000, 0.00000, -252.96002);
	CreateDynamicObject(9812, -1610.24902, 688.41547, 42.53446,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(822, -1561.13489, 624.42340, 7.04869,   0.00000, 0.00000, 46.86000);
	CreateDynamicObject(822, -1562.91516, 641.94812, 7.04869,   0.00000, 0.00000, -41.15999);
	CreateDynamicObject(822, -1543.72546, 638.57471, 7.04869,   0.00000, 0.00000, -73.01999);
	CreateDynamicObject(822, -1538.13599, 659.51294, 7.04869,   0.00000, 0.00000, -123.06001);
	CreateDynamicObject(822, -1560.09192, 663.89917, 7.04869,   0.00000, 0.00000, -188.03999);
	CreateDynamicObject(822, -1586.48730, 652.70245, 7.04869,   0.00000, 0.00000, -209.81998);
	CreateDynamicObject(822, -1594.44275, 666.06189, 7.04869,   0.00000, 0.00000, -209.81998);
	CreateDynamicObject(9812, -1841.20190, 742.61438, 57.35181,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -1899.83411, 752.64209, 54.27126,   0.00000, 0.00000, 0.42000);
	CreateDynamicObject(3095, -1907.27734, 752.95569, 48.22750,   88.98000, -0.30000, 0.00000);
	CreateDynamicObject(3095, -1898.33777, 752.99115, 48.22750,   88.98000, -0.30000, 0.00000);
	CreateDynamicObject(3095, -1889.47375, 753.01886, 48.22750,   88.98000, -0.30000, 0.00000);
	CreateDynamicObject(3095, -1889.47925, 753.01862, 55.52169,   88.98000, -0.30000, 0.66000);
	CreateDynamicObject(3095, -1898.34216, 752.99091, 55.52454,   88.98000, -0.30000, 0.00000);
	CreateDynamicObject(3095, -1907.27734, 752.95569, 55.51839,   88.98000, -0.30000, 0.00000);
	CreateDynamicObject(9812, -1883.38733, 753.78955, 53.92239,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1891.03186, 746.93378, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1900.06250, 750.24127, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1908.29724, 747.15765, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1902.59875, 738.68555, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1892.84607, 736.29095, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1896.77246, 728.11243, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1904.47266, 729.40594, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1905.52747, 719.47089, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1899.67053, 714.62225, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1891.67114, 716.35016, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1889.95129, 724.95898, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1886.12549, 734.84503, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1880.46216, 724.85193, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1878.96301, 736.65594, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1872.87207, 725.74536, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1873.19690, 737.49091, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1895.38745, 707.49829, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1903.10547, 706.59900, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1910.49634, 736.82239, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1912.27820, 726.35803, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1916.72522, 739.90228, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1920.13354, 729.87915, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1921.68872, 721.38080, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1925.28723, 742.42694, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1927.39893, 733.78778, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1928.95703, 723.76343, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1862.54980, 737.24530, 43.89038,   -4.20000, 3.36000, -47.82005);
	CreateDynamicObject(874, -1863.17676, 728.76825, 43.89038,   -4.20000, 3.36000, -47.82005);
	CreateDynamicObject(874, -1857.89404, 724.93658, 43.89038,   -4.20000, 3.36000, -48.12005);
	CreateDynamicObject(874, -1852.55823, 736.29553, 42.22791,   -4.20000, 3.36000, -92.76005);
	CreateDynamicObject(874, -1847.50793, 727.81030, 42.09987,   -15.24000, 2.22000, -92.76005);
	CreateDynamicObject(874, -1839.08423, 724.17163, 40.46981,   -15.24000, 2.22000, -92.76005);
	CreateDynamicObject(874, -1837.27466, 736.20709, 38.68475,   -20.52000, -9.60000, -120.72007);
	CreateDynamicObject(874, -1832.61658, 729.30127, 39.27182,   -15.24000, 2.22000, -120.72007);
	CreateDynamicObject(874, -1825.07031, 733.32153, 36.97994,   -4.56000, 0.78000, -120.72007);
	CreateDynamicObject(874, -1815.67175, 728.14801, 35.91100,   -4.56000, 0.78000, -120.72007);
	CreateDynamicObject(874, -1814.08130, 733.85980, 35.47548,   -4.56000, 0.78000, -98.34007);
	CreateDynamicObject(874, -1828.74500, 722.13568, 37.59078,   -15.24000, 2.22000, -120.36007);
	CreateDynamicObject(874, -1817.68005, 720.97583, 35.91100,   -4.56000, 0.78000, -120.72007);
	CreateDynamicObject(874, -1825.87280, 738.41962, 36.97994,   -4.56000, 0.78000, -109.98006);
	CreateDynamicObject(672, -1822.64404, 733.59399, 36.96497,   -2.82000, 6.90000, 0.00000);
	CreateDynamicObject(672, -1868.34827, 727.07574, 44.68140,   0.00000, 0.00000, -24.54000);
	CreateDynamicObject(672, -1908.42957, 731.18903, 45.86992,   0.00000, 0.00000, 14.22000);
	CreateDynamicObject(703, -1892.08167, 732.92511, 43.92551,   0.00000, 0.00000, -41.64000);
	CreateDynamicObject(3594, -1891.48364, 703.87061, 44.77892,   0.00000, 0.00000, -47.40000);
	CreateDynamicObject(3594, -1901.68323, 708.87225, 44.77892,   0.00000, 0.00000, 3.24000);
	CreateDynamicObject(3594, -1901.55249, 701.08795, 44.77892,   0.00000, 0.00000, -121.44001);
	CreateDynamicObject(3594, -1894.84814, 721.71918, 44.77892,   0.00000, 0.00000, -164.52002);
	CreateDynamicObject(3594, -1888.11426, 721.44159, 44.77892,   0.00000, 0.00000, -98.22000);
	CreateDynamicObject(3594, -1904.11047, 728.33234, 44.77892,   0.00000, 0.00000, -27.06001);
	CreateDynamicObject(3594, -1878.53503, 722.58630, 44.77892,   0.00000, 0.00000, -47.40000);
	CreateDynamicObject(3594, -1936.93494, 736.54980, 44.86832,   0.00000, 0.00000, -121.50004);
	CreateDynamicObject(3594, -1925.26465, 740.98291, 44.86832,   0.00000, 0.00000, -30.48000);
	CreateDynamicObject(3594, -1928.29419, 730.17981, 44.86832,   0.00000, 0.00000, 35.52000);
	CreateDynamicObject(3594, -1935.73120, 728.09821, 44.86832,   0.00000, 0.00000, -80.70000);
	CreateDynamicObject(3594, -1910.92627, 736.41620, 44.86832,   0.00000, 0.00000, -54.84000);
	CreateDynamicObject(3594, -1909.10266, 722.42712, 44.86832,   0.00000, 0.00000, 89.16001);
	CreateDynamicObject(3594, -1902.66675, 746.65161, 44.86832,   0.00000, 0.00000, -37.43999);
	CreateDynamicObject(9812, -1887.10193, 680.74438, 49.65860,   0.18000, 0.00000, -89.75996);
	CreateDynamicObject(874, -1940.15320, 723.76410, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1938.18481, 731.95642, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1939.76111, 740.41907, 45.50702,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1950.32092, 741.10901, 45.40716,   0.00000, 0.00000, -109.86004);
	CreateDynamicObject(874, -1950.15186, 723.57690, 45.40716,   0.00000, 0.00000, -142.38007);
	CreateDynamicObject(874, -1949.77271, 730.10498, 45.40716,   0.00000, 0.00000, -154.56004);
	CreateDynamicObject(822, -1923.12854, 734.21973, 44.20926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(822, -1952.89136, 740.56207, 44.20926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(822, -1941.14832, 724.44946, 44.20926,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9812, -1942.20410, 744.76367, 53.44670,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -1968.88220, 728.54236, 44.75862,   0.00000, 0.00000, -41.70000);
	CreateDynamicObject(3594, -1971.17151, 730.12018, 44.89860,   -18.48001, -3.84000, 34.14000);
	CreateDynamicObject(3594, -1975.96936, 737.49268, 44.75862,   0.00000, 0.00000, -98.22000);
	CreateDynamicObject(3594, -1979.95020, 731.65875, 44.75862,   0.00000, 0.00000, -117.06000);
	CreateDynamicObject(3594, -1967.47046, 740.82568, 44.90895,   0.00000, 0.00000, -59.03999);
	CreateDynamicObject(10985, -1989.17090, 719.01550, 44.92377,   0.00000, 0.00000, -206.39989);
	CreateDynamicObject(3594, -1991.29785, 723.42242, 44.75862,   -38.04000, 26.03999, -168.06001);
	CreateDynamicObject(3594, -1986.39856, 738.69940, 44.75862,   0.00000, 0.00000, -54.54001);
	CreateDynamicObject(3594, -1989.45654, 730.52893, 44.75862,   0.00000, 0.00000, 41.99999);
	CreateDynamicObject(874, -1950.15186, 723.57690, 45.40716,   0.00000, 0.00000, -142.38007);
	CreateDynamicObject(874, -1980.60474, 730.86603, 45.40716,   0.00000, 0.00000, -112.56004);
	CreateDynamicObject(3920, -1978.66528, 719.31061, 62.93744,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(3920, -1966.02527, 719.23431, 62.93744,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(3920, -1985.34985, 719.20007, 62.93744,   0.00000, 0.00000, -0.42000);
	CreateDynamicObject(3920, -1937.37891, 719.24353, 62.64416,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(3920, -1924.76453, 719.33502, 62.64416,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(3920, -1918.09338, 719.26349, 62.64416,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(3920, -1911.27393, 712.44336, 62.64416,   0.00000, 0.00000, -89.87998);
	CreateDynamicObject(3920, -1911.22253, 703.77850, 62.64416,   0.00000, 0.00000, -89.87998);
	CreateDynamicObject(672, -1897.15918, 711.18030, 45.86992,   0.00000, 0.00000, 39.24000);
	CreateDynamicObject(874, -1891.45679, 708.69910, 45.50702,   0.00000, 0.00000, -47.82005);
	CreateDynamicObject(874, -1905.33325, 693.14215, 44.15728,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1893.40527, 690.62457, 44.15728,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1899.37964, 692.48370, 44.15728,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1888.20679, 685.37726, 43.29965,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1897.22034, 683.66071, 43.29965,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1905.28369, 683.22327, 43.29965,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(3920, -1862.90430, 719.87030, 54.98072,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3920, -1839.40454, 719.87988, 54.98072,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9812, -1885.87952, 662.95776, 74.27052,   0.18000, 0.00000, -89.75996);
	CreateDynamicObject(874, -1783.52832, 709.15546, 35.31584,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(874, -1783.16492, 694.86005, 35.31584,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(874, -1783.33191, 680.95441, 35.31584,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(874, -1783.72351, 667.09015, 35.31584,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(874, -1784.06384, 655.65900, 35.31584,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(874, -1784.12964, 640.09021, 33.18607,   0.00000, 0.00000, -30.78004);
	CreateDynamicObject(874, -1782.52661, 627.90118, 31.68812,   0.96000, 6.18000, -30.78004);
	CreateDynamicObject(3594, -1783.59509, 720.13403, 34.34801,   0.00000, 0.00000, -76.13999);
	CreateDynamicObject(3594, -1783.91467, 701.56396, 34.34801,   0.00000, 0.00000, -11.64000);
	CreateDynamicObject(3594, -1783.40002, 677.32562, 34.34801,   0.00000, 0.00000, 17.52001);
	CreateDynamicObject(874, -1711.50793, 670.93268, 25.03898,   0.06000, 0.78000, -319.02014);
	CreateDynamicObject(874, -1720.44446, 667.87195, 25.03898,   0.06000, 0.78000, -319.02014);
	CreateDynamicObject(3594, -1707.60095, 657.63324, 24.31097,   0.00000, 0.00000, -211.62007);
	CreateDynamicObject(3594, -1716.97351, 653.34894, 24.31097,   0.00000, 0.00000, -134.52008);
	CreateDynamicObject(3594, -1724.01257, 646.15094, 24.31097,   0.00000, 0.00000, -197.70007);
	CreateDynamicObject(3594, -1713.60510, 652.10266, 24.34853,   -16.92000, 4.56000, -99.60007);
	CreateDynamicObject(10984, -1719.62476, 653.25153, 23.92054,   0.00000, 0.00000, 12.35998);
	CreateDynamicObject(8210, -1659.43018, 744.96777, 17.64517,   0.00000, 0.00000, -1.02004);
	CreateDynamicObject(8210, -1659.40234, 745.01721, 24.21566,   0.00000, 0.00000, -1.02004);
	CreateDynamicObject(3095, -1654.25049, 745.28442, 25.37550,   -0.90001, -89.22001, 88.85995);
	CreateDynamicObject(3095, -1663.17163, 745.46381, 25.25497,   -0.90001, -89.22001, 88.85995);
	CreateDynamicObject(3095, -1663.17163, 745.46381, 20.76155,   -0.90001, -89.22001, 88.85995);
	CreateDynamicObject(3095, -1654.25049, 745.28442, 18.93569,   -0.90001, -89.22001, 88.85995);
	CreateDynamicObject(9812, -1833.26343, 651.42670, 49.34625,   0.18000, 0.00000, 88.86005);
	CreateDynamicObject(9812, -1834.19751, 690.19977, 49.65860,   0.18000, 0.00000, 89.58007);
	CreateDynamicObject(874, -1828.27942, 712.89453, 36.50672,   -15.24000, 2.22000, -120.36007);
	CreateDynamicObject(874, -1828.94348, 704.75226, 35.10014,   -15.24000, 2.22000, -120.36007);
	CreateDynamicObject(874, -1828.43713, 697.70679, 34.16622,   -15.24000, 2.22000, -120.36007);
	CreateDynamicObject(874, -1831.23462, 689.91656, 33.60206,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.39844, 677.84357, 30.32093,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.45972, 669.06110, 30.16682,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.59033, 661.24127, 30.10453,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.61609, 654.21893, 30.10453,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.86902, 645.86249, 30.10453,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.33777, 639.60333, 30.10453,   -15.24000, 2.22000, -207.12006);
	CreateDynamicObject(874, -1832.86902, 645.86249, 30.10453,   -15.24000, 2.22000, -207.48006);
	CreateDynamicObject(874, -1832.39075, 633.22229, 30.10453,   -15.24000, 2.22000, -207.12006);
	CreateDynamicObject(874, -1832.04858, 625.15643, 31.23798,   9.24000, 0.90000, -207.12006);
	CreateDynamicObject(874, -1839.31152, 617.54651, 34.14009,   -15.24000, 2.22000, -297.24011);
	CreateDynamicObject(874, -1833.71631, 607.41193, 34.14009,   -15.24000, 2.22000, -212.70012);
	CreateDynamicObject(874, -1822.41296, 609.42896, 34.14009,   -15.24000, 2.22000, -143.34012);
	CreateDynamicObject(874, -1824.63074, 601.99854, 34.14009,   -15.24000, 2.22000, -143.34012);
	CreateDynamicObject(874, -1813.69800, 601.33868, 34.14009,   -15.24000, 2.22000, -143.34012);
	CreateDynamicObject(874, -1813.66516, 609.43280, 34.14009,   -15.24000, 2.22000, -128.58012);
	CreateDynamicObject(874, -1837.91541, 603.70392, 34.14009,   -15.24000, 2.22000, -212.70012);
	CreateDynamicObject(874, -1843.95447, 604.94409, 34.14009,   -15.24000, 2.22000, -212.70012);
	CreateDynamicObject(8210, -2003.66138, 750.46191, 47.08722,   0.00000, 0.00000, 1.02000);
	CreateDynamicObject(8210, -2003.66138, 750.46191, 54.09756,   0.00000, 0.00000, 1.02000);
	CreateDynamicObject(3095, -1995.69336, 751.08112, 48.62295,   90.05997, 2.40000, -1.80000);
	CreateDynamicObject(3095, -2004.63367, 750.86700, 48.62295,   90.05997, 2.40000, -1.80000);
	CreateDynamicObject(3095, -2013.51636, 750.73151, 48.62295,   90.05997, 2.40000, -1.80000);
	CreateDynamicObject(3095, -2013.51636, 750.73151, 55.35975,   90.05997, 2.40000, -1.80000);
	CreateDynamicObject(3095, -2004.63367, 750.86700, 55.35894,   90.05997, 2.40000, -1.80000);
	CreateDynamicObject(3095, -1995.69336, 751.08112, 55.35966,   90.05997, 2.40000, -1.80000);
	CreateDynamicObject(9812, -2003.74707, 750.94836, 53.59106,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9897, -1748.75256, 996.30249, 42.23981,   7.62000, 8.82000, -44.64000);
	CreateDynamicObject(19341, -1753.63672, 885.36548, 295.83820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1993.73401, 741.12933, 45.40716,   0.00000, 0.00000, -152.22003);
	CreateDynamicObject(874, -2005.38000, 742.94916, 45.40716,   0.00000, 0.00000, -106.68004);
	CreateDynamicObject(874, -2014.09375, 742.07635, 45.40716,   0.00000, 0.00000, -79.44004);
	CreateDynamicObject(874, -2015.14197, 730.94458, 45.40716,   0.00000, 0.00000, -29.22004);
	CreateDynamicObject(874, -2007.04211, 733.68799, 45.40716,   0.00000, 0.00000, -29.22004);
	CreateDynamicObject(874, -1999.58643, 734.94556, 45.40716,   0.00000, 0.00000, -29.22004);
	CreateDynamicObject(874, -1991.78821, 734.46710, 45.40716,   0.00000, 0.00000, -29.22004);
	CreateDynamicObject(874, -1993.96558, 729.52789, 45.40716,   0.00000, 0.00000, -76.44003);
	CreateDynamicObject(874, -2007.15479, 723.44177, 45.40716,   0.00000, 0.00000, -147.66002);
	CreateDynamicObject(874, -1978.88831, 723.16595, 45.40716,   0.00000, 0.00000, -76.44003);
	CreateDynamicObject(874, -1976.15039, 738.59735, 45.40716,   0.00000, 0.00000, -127.86003);
	CreateDynamicObject(874, -1967.26758, 722.52948, 45.40716,   0.00000, 0.00000, -76.44003);
	CreateDynamicObject(3594, -1999.32434, 722.64032, 44.75862,   0.00000, 0.00000, -93.24001);
	CreateDynamicObject(3594, -2009.45239, 718.50244, 44.75862,   0.00000, 0.00000, -143.94002);
	CreateDynamicObject(3594, -2005.27368, 736.07654, 44.75862,   0.00000, 0.00000, -224.94003);
	CreateDynamicObject(3594, -2016.71021, 730.43774, 44.75862,   0.00000, 0.00000, 17.69996);
	CreateDynamicObject(3594, -1998.86841, 737.60736, 44.75862,   0.00000, 0.00000, -170.34006);
	CreateDynamicObject(672, -2002.75330, 730.83612, 45.29972,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1997.06702, 710.25366, 45.40716,   0.00000, 0.00000, -173.69998);
	CreateDynamicObject(874, -2010.78076, 712.14954, 45.40716,   0.00000, 0.00000, -199.98003);
	CreateDynamicObject(874, -2004.79980, 709.72119, 45.40716,   0.00000, 0.00000, -199.98003);
	CreateDynamicObject(874, -1997.77209, 698.96014, 45.40716,   0.00000, 0.00000, -203.45999);
	CreateDynamicObject(874, -2011.29651, 698.58948, 45.40716,   0.00000, 0.00000, -203.45999);
	CreateDynamicObject(874, -2004.15967, 692.55920, 45.40716,   0.00000, 0.00000, -203.45999);
	CreateDynamicObject(874, -1997.77893, 688.52814, 45.40716,   0.00000, 0.00000, -203.45999);
	CreateDynamicObject(3502, -1997.43079, 674.91229, 44.05984,   -19.20000, 19.80000, -37.50000);
	CreateDynamicObject(4206, -2005.07471, 618.07654, 34.03244,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9831, -2003.49634, 609.43768, 30.62350,   -2.82001, -0.78000, 179.45998);
	CreateDynamicObject(9831, -2002.73401, 629.11761, 34.06235,   -2.82001, -0.78000, 179.45998);
	CreateDynamicObject(9831, -2002.10986, 643.89166, 36.64479,   -2.82001, -0.78000, 179.45998);
	CreateDynamicObject(9831, -2000.55127, 672.17090, 43.73015,   29.34000, -2.40000, 163.07999);
	CreateDynamicObject(874, -2010.34741, 689.00494, 45.40716,   0.00000, 0.00000, -110.51998);
	CreateDynamicObject(874, -2002.81763, 677.56042, 44.27797,   -10.92000, 1.26000, -193.79999);
	CreateDynamicObject(874, -2011.69165, 677.90033, 44.27797,   -10.92000, 1.26000, -193.79999);
	CreateDynamicObject(10985, -1990.47290, 692.43256, 44.92377,   0.00000, 0.00000, -206.39989);
	CreateDynamicObject(10985, -1998.20752, 681.03827, 44.92377,   0.00000, 0.00000, -191.45993);
	CreateDynamicObject(874, -2011.26367, 666.81903, 42.94170,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -2005.39111, 665.92242, 42.94170,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -1997.88013, 665.77240, 42.94170,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -1997.13049, 673.98248, 42.94170,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -1997.99072, 654.94775, 41.04419,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -2003.31177, 653.36090, 41.04419,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -2011.82703, 654.77417, 41.04419,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -2012.75171, 645.07684, 39.20164,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -2007.18323, 643.69507, 39.20164,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(874, -1998.92578, 640.27612, 38.44529,   -10.73999, 3.72000, -193.79999);
	CreateDynamicObject(672, -2008.50366, 641.27295, 38.44637,   7.50000, -2.04000, 0.00000);
	CreateDynamicObject(3594, -1992.53308, 616.58856, 34.49472,   0.00000, 0.00000, 59.40000);
	CreateDynamicObject(3594, -2006.95911, 612.44897, 34.36533,   0.00000, 0.00000, -1.26000);
	CreateDynamicObject(3594, -1995.15674, 612.45258, 34.36533,   0.00000, 0.00000, 72.66000);
	CreateDynamicObject(3594, -1994.77332, 614.70062, 35.27290,   0.00000, 0.00000, -16.32000);
	CreateDynamicObject(3594, -2005.13574, 601.66962, 34.36533,   0.00000, 0.00000, -67.07999);
	CreateDynamicObject(3594, -1989.32397, 607.62830, 34.36533,   0.00000, 0.00000, -29.87998);
	CreateDynamicObject(874, -1999.29102, 629.14642, 35.90195,   -10.73999, 3.72000, -202.01997);
	CreateDynamicObject(874, -2010.01147, 628.91321, 35.90195,   -10.73999, 3.72000, -172.07996);
	CreateDynamicObject(10985, -1994.33411, 614.17072, 33.81789,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1995.33765, 599.74976, 34.43876,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1992.02551, 605.66888, 34.43876,   0.00000, 0.00000, -54.72000);
	CreateDynamicObject(874, -2008.11389, 615.23871, 34.43876,   0.00000, 0.00000, -54.72000);
	CreateDynamicObject(874, -2003.09912, 607.51074, 34.43876,   0.00000, 0.00000, -83.69999);
	CreateDynamicObject(874, -1996.48633, 619.59833, 34.43876,   0.00000, 0.00000, -83.69999);
	CreateDynamicObject(874, -1987.30798, 612.23657, 34.43876,   0.00000, 0.00000, -83.69999);
	CreateDynamicObject(874, -2004.54492, 599.23346, 34.43876,   0.00000, 0.00000, -17.46000);
	CreateDynamicObject(874, -2011.13293, 603.91327, 34.43876,   0.00000, 0.00000, -17.46000);
	CreateDynamicObject(703, -1978.89648, 611.99036, 33.54572,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(703, -2012.51855, 598.14716, 33.30812,   0.00000, 0.00000, -4.20000);
	CreateDynamicObject(672, -1999.13794, 607.24969, 34.69419,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -2013.05579, 625.52667, 35.10560,   -10.73999, 3.72000, -172.07996);
	CreateDynamicObject(3594, -2001.43701, 707.45386, 44.75862,   0.00000, 0.00000, -79.86003);
	CreateDynamicObject(3594, -2011.35120, 703.96039, 44.75862,   0.00000, 0.00000, -159.84001);
	CreateDynamicObject(3594, -1998.56555, 698.90204, 44.75862,   0.00000, 0.00000, -213.66000);
	CreateDynamicObject(4514, -1957.38354, 731.97150, 46.16459,   0.00000, 0.00000, 90.42003);
	CreateDynamicObject(4514, -1899.07703, 673.96674, 42.31775,   -9.84000, -0.60000, 180.71997);
	CreateDynamicObject(4514, -1715.49316, 670.09070, 25.39911,   0.00000, 0.00000, 176.99997);
	CreateDynamicObject(3594, -1979.97229, 602.61627, 34.36533,   0.00000, 0.00000, 49.02002);
	CreateDynamicObject(3594, -1967.48193, 606.28735, 34.36533,   0.00000, 0.00000, 120.54002);
	CreateDynamicObject(3594, -1960.13940, 605.44739, 34.36533,   0.00000, 0.00000, 179.46001);
	CreateDynamicObject(3594, -1946.68127, 602.10724, 34.36533,   0.00000, 0.00000, 141.53998);
	CreateDynamicObject(3594, -1929.76868, 613.82404, 34.36533,   0.00000, 0.00000, 281.21997);
	CreateDynamicObject(3594, -1919.43347, 604.58850, 34.36533,   0.00000, 0.00000, 408.17993);
	CreateDynamicObject(3594, -1912.99353, 599.93085, 34.36533,   0.00000, 0.00000, 304.07996);
	CreateDynamicObject(3594, -1902.20032, 611.12860, 34.36533,   0.00000, 0.00000, 398.57993);
	CreateDynamicObject(3594, -1896.92273, 614.58209, 34.36533,   0.00000, 0.00000, 349.13998);
	CreateDynamicObject(3594, -1841.14441, 606.13403, 34.36533,   0.00000, 0.00000, 330.96002);
	CreateDynamicObject(3594, -1882.44958, 604.45294, 34.36533,   0.00000, 0.00000, 462.48004);
	CreateDynamicObject(3594, -1869.78198, 610.39044, 34.36533,   0.00000, 0.00000, 429.78012);
	CreateDynamicObject(3594, -1860.83020, 601.65369, 34.36533,   0.00000, 0.00000, 477.54004);
	CreateDynamicObject(3594, -1894.21643, 589.92340, 34.36533,   0.00000, 0.00000, 510.71985);
	CreateDynamicObject(3594, -1837.98767, 612.94031, 34.36533,   0.00000, 0.00000, 426.47998);
	CreateDynamicObject(3594, -1986.81580, 588.31372, 34.69928,   0.00000, 0.00000, -21.53998);
	CreateDynamicObject(3594, -1973.21985, 584.51282, 34.69928,   0.00000, 0.00000, 16.32002);
	CreateDynamicObject(3594, -1981.67981, 585.39368, 34.69928,   0.00000, 0.00000, 137.76004);
	CreateDynamicObject(874, -1988.09485, 601.65509, 34.43876,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3594, -1905.33350, 591.98474, 34.36533,   0.00000, 0.00000, 625.43994);
	CreateDynamicObject(3920, -1992.07678, 712.21625, 62.26653,   0.00000, 0.00000, 91.26003);
	CreateDynamicObject(3594, -1936.66980, 582.66724, 34.62073,   0.00000, 0.00000, 100.62000);
	CreateDynamicObject(3594, -1948.26782, 575.26294, 34.62073,   0.00000, 0.00000, 60.24000);
	CreateDynamicObject(3594, -1956.82739, 586.51819, 34.62073,   0.00000, 0.00000, 141.05998);
	CreateDynamicObject(3594, -1915.20374, 577.84149, 34.62073,   0.00000, 0.00000, 138.84001);
	CreateDynamicObject(672, -1833.58887, 597.75763, 33.91323,   0.00000, 0.00000, 71.21999);
	CreateDynamicObject(672, -1843.59961, 609.26404, 33.91323,   0.00000, 0.00000, 35.87999);
	CreateDynamicObject(3594, -1833.33765, 603.50397, 34.36533,   0.00000, 0.00000, 308.40002);
	CreateDynamicObject(874, -1988.16687, 590.35413, 34.43876,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1978.43567, 586.91083, 34.43876,   0.00000, 0.00000, 24.30000);
	CreateDynamicObject(874, -1979.12317, 592.79077, 34.43876,   0.00000, 0.00000, 24.30000);
	CreateDynamicObject(874, -1967.79565, 588.21027, 34.43876,   0.00000, 0.00000, 56.52000);
	CreateDynamicObject(874, -1961.55310, 587.14471, 34.43876,   0.00000, 0.00000, 46.56000);
	CreateDynamicObject(874, -1954.10510, 581.02454, 34.43876,   0.00000, 0.00000, 34.32000);
	CreateDynamicObject(874, -1939.85657, 576.17926, 34.43876,   0.00000, 0.00000, 93.12000);
	CreateDynamicObject(874, -1926.49280, 576.04419, 34.43876,   0.00000, 0.00000, 75.24000);
	CreateDynamicObject(874, -1915.89856, 577.54547, 34.43876,   0.00000, 0.00000, 69.41998);
	CreateDynamicObject(874, -1904.36353, 580.83435, 34.43876,   0.00000, 0.00000, 81.89999);
	CreateDynamicObject(874, -1892.03479, 582.90515, 34.43876,   0.00000, 0.00000, 81.89999);
	CreateDynamicObject(874, -1884.03906, 583.53418, 34.43876,   0.00000, 0.00000, 78.71999);
	CreateDynamicObject(874, -1864.01135, 590.41119, 34.43876,   0.00000, 0.00000, 78.71999);
	CreateDynamicObject(874, -1850.38330, 596.32373, 34.43876,   0.00000, 0.00000, 106.98001);
	CreateDynamicObject(874, -1836.46948, 597.85571, 34.43876,   0.00000, 0.00000, 85.74001);
	CreateDynamicObject(874, -1859.08459, 596.47949, 34.43876,   0.00000, 0.00000, 78.71999);
	CreateDynamicObject(874, -1869.82458, 597.65137, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1880.76624, 596.97632, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1891.57190, 591.56720, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1892.86670, 596.87885, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1899.95410, 588.16388, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1912.60645, 585.03528, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1924.66504, 584.25446, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1933.86523, 581.96832, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1943.93872, 582.91193, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1952.92859, 586.67523, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1963.51538, 593.57269, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1972.75354, 596.71954, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1971.01514, 602.82037, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1974.98828, 610.71619, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1969.72290, 615.61719, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1958.16272, 616.73297, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1955.77563, 608.27411, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1945.88635, 614.72003, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1932.13306, 615.93939, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1921.32910, 617.39630, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1908.20618, 617.38995, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1914.81567, 611.52728, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1926.08032, 609.76581, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1937.51135, 606.63812, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1947.16345, 604.19562, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1959.33667, 600.83661, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1950.53711, 596.57574, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1955.58740, 592.16089, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1964.89868, 580.86194, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1955.58740, 592.16089, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1941.84497, 598.00769, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1943.94971, 589.16595, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1928.83557, 586.83612, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1915.76343, 591.07166, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1929.43262, 593.25665, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1930.33728, 600.91565, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1922.22510, 598.21576, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1920.98218, 604.66071, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1905.26794, 599.04724, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1904.90771, 605.80408, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1893.95105, 612.35242, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1894.40906, 604.80157, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1883.83984, 602.55756, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1880.92334, 611.06909, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1873.67590, 605.51569, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1859.30554, 605.36908, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1847.98047, 603.27484, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1849.32410, 615.68658, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1856.86377, 612.05829, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1866.09680, 614.49780, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(874, -1877.61169, 617.53540, 34.43876,   0.00000, 0.00000, 72.35998);
	CreateDynamicObject(703, -1919.19983, 610.81085, 33.54572,   0.00000, 0.00000, -38.22000);
	CreateDynamicObject(672, -1957.58826, 580.71985, 34.78844,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(672, -1935.28723, 600.43475, 34.78626,   0.00000, 0.00000, 57.12000);
	CreateDynamicObject(672, -1931.61108, 587.67145, 34.63194,   0.00000, 0.00000, 57.12000);
	CreateDynamicObject(874, -1981.75439, 609.51782, 34.43876,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(672, -1972.98792, 594.43854, 34.78844,   0.00000, 0.00000, 42.48000);
	CreateDynamicObject(672, -1951.99719, 604.67596, 34.78626,   0.00000, 0.00000, -46.80001);
	CreateDynamicObject(3594, -1945.12012, 580.42932, 34.62073,   0.00000, 0.00000, 128.16002);
	CreateDynamicObject(3594, -1954.01477, 595.78424, 34.62073,   0.00000, 0.00000, 32.10001);
	CreateDynamicObject(672, -1956.13184, 592.21606, 34.78626,   0.00000, 0.00000, 98.57999);
	CreateDynamicObject(703, -1874.18225, 605.63049, 33.54572,   0.00000, 0.00000, -38.22000);
	CreateDynamicObject(672, -1903.03320, 602.54242, 34.63194,   0.00000, 0.00000, 97.86001);
	CreateDynamicObject(10945, -1897.03992, 503.81137, 79.63382,   -17.93999, 13.68000, 0.00000);
	CreateDynamicObject(10985, -1962.39673, 516.77240, 35.24437,   0.00000, 0.00000, -118.86006);
	CreateDynamicObject(10985, -1963.17139, 533.71771, 35.24437,   0.00000, 0.00000, -143.46001);
	CreateDynamicObject(10985, -1963.20959, 546.70789, 35.24437,   0.00000, 0.00000, -133.44002);
	CreateDynamicObject(10984, -1962.68701, 563.46588, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10984, -1952.59851, 561.47546, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10984, -1941.24902, 561.96680, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10984, -1932.30078, 562.41309, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10984, -1921.20862, 562.41632, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10984, -1911.69177, 561.44812, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10984, -1912.19849, 549.49084, 34.66981,   0.00000, 0.00000, -23.94000);
	CreateDynamicObject(10985, -1910.72058, 541.60150, 34.75387,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10985, -1914.48743, 532.91644, 34.75387,   0.00000, 0.00000, 14.40000);
	CreateDynamicObject(10985, -1912.30713, 520.14380, 35.15134,   0.00000, 0.00000, 14.40000);
	CreateDynamicObject(10985, -1922.54834, 514.35168, 34.99537,   0.00000, 0.00000, -43.31999);
	CreateDynamicObject(10985, -1951.58838, 518.79999, 35.24437,   0.00000, 0.00000, -118.86006);
	CreateDynamicObject(10985, -1939.76563, 520.06372, 35.24437,   0.00000, 0.00000, -74.76007);
	CreateDynamicObject(10985, -1968.15356, 459.34717, 34.44397,   0.00000, 0.00000, -118.86006);
	CreateDynamicObject(10985, -1969.61304, 435.79535, 35.11542,   0.00000, 0.00000, -254.28011);
	CreateDynamicObject(10984, -1966.71753, 447.76172, 35.04966,   0.00000, 0.00000, 73.85999);
	CreateDynamicObject(10984, -1970.70276, 414.37082, 34.98843,   0.00000, 0.00000, 73.85999);
	CreateDynamicObject(10984, -1960.97314, 412.91312, 34.98843,   0.00000, 0.00000, 73.85999);
	CreateDynamicObject(10984, -1950.04407, 415.21390, 34.98843,   0.00000, 0.00000, 184.67998);
	CreateDynamicObject(10984, -1938.89819, 413.73849, 34.98843,   0.00000, 0.00000, 184.67998);
	CreateDynamicObject(10984, -1928.67090, 415.26105, 34.98843,   0.00000, 0.00000, 184.67998);
	CreateDynamicObject(10984, -1924.35779, 417.58600, 34.98843,   0.00000, 0.00000, 184.67998);
	CreateDynamicObject(10984, -1924.92517, 432.60202, 34.98843,   0.00000, 0.00000, 184.67998);
	CreateDynamicObject(10984, -1924.12219, 447.47751, 34.98843,   0.00000, 0.00000, 184.67998);
	CreateDynamicObject(10984, -1924.91943, 458.87436, 34.98843,   0.00000, 0.00000, 245.46002);
	CreateDynamicObject(10984, -1936.43835, 459.45374, 34.98843,   0.00000, 0.00000, 277.31985);
	CreateDynamicObject(10984, -1952.17212, 459.82291, 34.98843,   0.00000, 0.00000, 292.97986);
	CreateDynamicObject(10984, -1960.43896, 459.99774, 34.98843,   0.00000, 0.00000, 292.97986);
	CreateDynamicObject(10985, -1970.51819, 426.85843, 35.11542,   0.00000, 0.00000, -302.04010);
	CreateDynamicObject(10984, -1916.17358, 461.25485, 34.98843,   0.00000, 0.00000, 208.26006);
	CreateDynamicObject(10984, -1909.66626, 466.18048, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1899.07849, 465.68726, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1886.75623, 465.48819, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1876.31787, 466.13873, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1867.73035, 466.05054, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1855.71704, 466.53333, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1855.43970, 476.09985, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1853.60535, 488.72751, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1853.45105, 499.38873, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(10984, -1852.02075, 512.44659, 32.92894,   0.00000, 0.00000, 398.69998);
	CreateDynamicObject(10984, -1848.79663, 501.97092, 35.12839,   0.00000, 0.00000, 398.69998);
	CreateDynamicObject(10984, -1858.31812, 518.59558, 32.92894,   0.00000, 0.00000, 398.69998);
	CreateDynamicObject(10984, -1857.58350, 507.90137, 35.12839,   0.00000, 0.00000, 398.69998);
	CreateDynamicObject(10984, -1869.25854, 511.12949, 35.12839,   0.00000, 0.00000, 280.31998);
	CreateDynamicObject(10984, -1883.48389, 511.10440, 35.12839,   0.00000, 0.00000, 280.31998);
	CreateDynamicObject(10984, -1894.93970, 509.25513, 35.12839,   0.00000, 0.00000, 280.31998);
	CreateDynamicObject(10985, -1904.28796, 515.67279, 35.15134,   0.00000, 0.00000, -61.25999);
	CreateDynamicObject(10985, -1895.90759, 516.86987, 35.15134,   0.00000, 0.00000, -19.80000);
	CreateDynamicObject(10984, -1894.85413, 498.06024, 35.12839,   0.00000, 0.00000, 242.09998);
	CreateDynamicObject(10984, -1900.70691, 487.66608, 34.98843,   0.00000, 0.00000, 212.04008);
	CreateDynamicObject(10984, -1902.29285, 476.78357, 34.98843,   0.00000, 0.00000, 212.04008);
	CreateDynamicObject(10984, -1908.45349, 504.96387, 34.98843,   0.00000, 0.00000, 266.34006);
	CreateDynamicObject(874, -1970.74634, 575.83392, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1973.69031, 569.66345, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1975.16418, 562.20514, 34.43876,   0.00000, 0.00000, 49.79998);
	CreateDynamicObject(874, -1974.81812, 557.62518, 34.43876,   0.00000, 0.00000, 95.63999);
	CreateDynamicObject(874, -1978.59595, 548.30981, 34.43876,   0.00000, 0.00000, -50.94001);
	CreateDynamicObject(874, -1971.59363, 541.38568, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1966.77148, 528.85382, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1966.41211, 516.89081, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1966.37451, 507.62280, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1965.67053, 498.27850, 35.64419,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1966.62964, 489.06921, 35.71626,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1966.20422, 480.40115, 35.69410,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1965.66736, 473.21057, 35.63950,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1958.10889, 470.02283, 34.43876,   0.00000, 0.00000, 62.09998);
	CreateDynamicObject(874, -1965.66736, 473.21057, 35.78507,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1959.48779, 506.20697, 34.43876,   0.00000, 0.00000, 67.49998);
	CreateDynamicObject(874, -1944.61646, 509.02109, 34.43876,   0.00000, 0.00000, 67.49998);
	CreateDynamicObject(874, -1934.65088, 508.65735, 34.43876,   0.00000, 0.00000, 56.69999);
	CreateDynamicObject(874, -1923.99036, 504.14584, 34.43876,   0.00000, 0.00000, 47.81998);
	CreateDynamicObject(874, -1913.09338, 497.19885, 34.43876,   0.00000, 0.00000, 46.13998);
	CreateDynamicObject(874, -1919.78320, 490.89023, 34.43876,   0.00000, 0.00000, 179.03996);
	CreateDynamicObject(874, -1912.40344, 484.19620, 34.43876,   0.00000, 0.00000, 158.03996);
	CreateDynamicObject(874, -1912.77185, 475.40607, 34.43876,   0.00000, 0.00000, 130.37994);
	CreateDynamicObject(874, -1920.80444, 480.89816, 34.43876,   0.00000, 0.00000, 130.37994);
	CreateDynamicObject(874, -1923.68091, 473.23416, 34.43876,   0.00000, 0.00000, 123.53995);
	CreateDynamicObject(874, -1926.05566, 486.59659, 34.43876,   0.00000, 0.00000, 144.89992);
	CreateDynamicObject(874, -1943.31384, 470.03729, 34.43876,   0.00000, 0.00000, 72.95995);
	CreateDynamicObject(874, -1943.57495, 483.84119, 31.35930,   0.00000, 0.00000, 57.71996);
	CreateDynamicObject(874, -1940.59570, 492.03781, 31.35930,   0.00000, 0.00000, 87.83995);
	CreateDynamicObject(874, -1975.35522, 477.97729, 35.65623,   0.00000, 0.00000, -54.54002);
	CreateDynamicObject(874, -1974.34277, 466.64551, 35.49122,   0.00000, 0.00000, 25.01999);
	CreateDynamicObject(874, -1951.46875, 489.24783, 31.35930,   0.00000, 0.00000, -53.70005);
	CreateDynamicObject(874, -1941.50378, 489.78116, 31.35930,   0.00000, 0.00000, -53.70005);
	CreateDynamicObject(703, -1940.42151, 487.37778, 30.41738,   0.00000, 0.00000, -34.50000);
	CreateDynamicObject(672, -1980.03345, 552.33960, 34.69419,   0.00000, 0.00000, -16.44000);
	CreateDynamicObject(672, -1958.00586, 503.63391, 34.69419,   0.00000, 0.00000, 14.52000);
	CreateDynamicObject(672, -1970.23022, 476.57376, 34.69419,   0.00000, 0.00000, 67.50000);
	CreateDynamicObject(672, -1915.95325, 477.01611, 34.69419,   0.00000, 0.00000, 86.76000);
	CreateDynamicObject(3594, -1978.41162, 494.05466, 34.69928,   0.00000, 0.00000, 137.76004);
	CreateDynamicObject(3594, -1964.81299, 500.02234, 34.69928,   0.00000, 0.00000, 43.56005);
	CreateDynamicObject(3594, -1974.36511, 486.61282, 34.69928,   0.00000, 0.00000, 19.80007);
	CreateDynamicObject(3594, -1968.29187, 493.85498, 34.69928,   0.00000, 0.00000, 111.00005);
	CreateDynamicObject(3594, -1979.48083, 482.21582, 34.69928,   0.00000, 0.00000, 209.52000);
	CreateDynamicObject(3594, -1973.70007, 467.61890, 34.69928,   0.00000, 0.00000, 314.40002);
	CreateDynamicObject(3594, -1943.21887, 470.85199, 34.69928,   0.00000, 0.00000, 281.70001);
	CreateDynamicObject(3594, -1917.35706, 487.20584, 34.69928,   0.00000, 0.00000, 240.18002);
	CreateDynamicObject(703, -1982.72546, 467.59683, 34.06375,   0.00000, 0.00000, -8.21999);
	CreateDynamicObject(10984, -1918.13867, 446.30206, 34.98843,   0.00000, 0.00000, 208.26006);
	CreateDynamicObject(10984, -1908.98315, 456.19955, 34.98843,   0.00000, 0.00000, 186.06006);
	CreateDynamicObject(10984, -1896.72400, 461.77512, 34.98843,   0.00000, 0.00000, 186.06006);
	CreateDynamicObject(874, -1904.71631, 555.90009, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1904.57556, 531.22296, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1900.80566, 540.47314, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1900.86499, 549.02423, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1894.67603, 530.45825, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1890.65723, 538.03778, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1894.87988, 546.44049, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1892.37170, 555.36566, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1894.98511, 564.96887, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1896.24268, 575.99908, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1885.43604, 570.73029, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1884.73999, 558.38696, 34.43876,   0.00000, 0.00000, 27.23999);
	CreateDynamicObject(874, -1886.61768, 547.88293, 34.43876,   0.00000, 0.00000, -35.10000);
	CreateDynamicObject(672, -1892.17627, 529.55627, 34.63194,   0.00000, 0.00000, 37.20001);
	CreateDynamicObject(672, -1886.62878, 554.51532, 34.63194,   0.00000, 0.00000, 68.16001);
	CreateDynamicObject(672, -1900.24951, 548.80841, 34.63194,   0.00000, 0.00000, 35.52000);
	CreateDynamicObject(3594, -1887.38513, 567.70679, 34.36533,   0.00000, 0.00000, 625.43994);
	CreateDynamicObject(3594, -1883.46570, 546.75165, 33.84963,   0.00000, 0.00000, 625.43994);
	CreateDynamicObject(3594, -1892.75366, 540.55664, 34.36533,   0.00000, 0.00000, 564.89990);
	CreateDynamicObject(3594, -1877.08447, 552.45697, 33.84964,   0.00000, 0.00000, 548.45990);
	CreateDynamicObject(9812, -1952.79297, 619.73676, 56.30696,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(9812, -1990.31775, 665.66864, 56.30696,   0.00000, 0.00000, -90.17996);
	CreateDynamicObject(10984, -1937.56860, 591.72345, 34.66981,   0.00000, 0.00000, -31.08000);
	CreateDynamicObject(10984, -1899.33569, 576.71063, 34.66981,   0.00000, 0.00000, -124.49998);
	CreateDynamicObject(3502, -1828.54028, 513.97107, 30.02019,   -23.75999, 41.45999, 36.54001);
	CreateDynamicObject(10984, -1831.42969, 517.66785, 31.17794,   7.02000, -0.36000, 398.69998);
	CreateDynamicObject(9831, -1825.87329, 509.90863, 29.82847,   31.02001, -1.56000, 218.15994);
	CreateDynamicObject(9831, -1817.11719, 482.57343, 21.66825,   -4.98000, -1.26000, 198.71994);
	CreateDynamicObject(9831, -1822.40662, 463.55191, 17.66409,   -5.46000, -1.43999, 176.75993);
	CreateDynamicObject(9831, -1833.87537, 443.43610, 14.18274,   -2.70000, -2.99999, 157.97995);
	CreateDynamicObject(9831, -1847.07239, 424.85678, 13.88877,   3.77999, -2.33999, 149.52005);
	CreateDynamicObject(9831, -1842.51501, 403.58191, 14.62328,   7.73999, -2.33999, 181.31981);
	CreateDynamicObject(9831, -1827.98633, 389.14838, 14.55479,   7.61999, 1.26001, 211.86005);
	CreateDynamicObject(9831, -1813.63025, 373.82190, 14.55479,   7.61999, 1.26001, 220.44003);
	CreateDynamicObject(9831, -1800.33325, 356.99924, 14.55479,   7.61999, 1.26001, 220.44003);
	CreateDynamicObject(9831, -1792.55273, 346.58121, 14.13564,   6.53998, -0.96000, 220.44003);
	CreateDynamicObject(9831, -1772.41333, 327.18353, 6.03147,   -8.04000, -2.88001, 225.24002);
	CreateDynamicObject(9831, -1758.42566, 310.90674, 1.23763,   -6.18000, -2.88001, 224.04005);
	CreateDynamicObject(9831, -1749.74890, 301.40869, 4.11247,   4.79999, -2.52001, 224.04005);
	CreateDynamicObject(9831, -1758.31116, 275.86542, 4.47153,   7.07999, -0.78001, 174.53999);
	CreateDynamicObject(9831, -1757.11060, 269.77740, 6.25933,   10.62001, -2.28001, 180.05994);
	CreateDynamicObject(874, -1908.15747, 625.85986, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1899.93091, 620.77972, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1890.65613, 623.44879, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1899.47217, 630.33783, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1890.90015, 633.77875, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1909.00305, 635.58441, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1901.73364, 640.33795, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1892.60278, 642.65027, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1909.74219, 643.89258, 34.43876,   0.00000, 0.00000, 53.75998);
	CreateDynamicObject(874, -1905.90247, 670.76813, 41.29671,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1899.56030, 669.83514, 41.29671,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1891.14697, 670.51306, 41.29671,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1890.52869, 658.70703, 38.79622,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1899.22925, 658.12885, 38.79622,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1905.55078, 657.35883, 38.79622,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1905.24976, 649.74054, 36.84998,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1898.23938, 648.99561, 36.84998,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(874, -1890.04602, 649.65808, 36.84998,   9.36000, 4.20000, -47.82005);
	CreateDynamicObject(672, -1899.86829, 645.27478, 36.03202,   1.97999, -5.34000, 39.24000);
	CreateDynamicObject(874, -1713.57581, 661.35858, 25.03898,   0.06000, 0.78000, -318.48013);
	CreateDynamicObject(874, -1713.57520, 653.68921, 25.03898,   0.06000, 0.78000, -318.48013);
	CreateDynamicObject(874, -1713.91931, 648.92609, 25.03898,   0.06000, 0.78000, -318.48013);
	CreateDynamicObject(874, -1714.05396, 641.15002, 25.03898,   0.06000, 0.78000, -318.48013);
	CreateDynamicObject(874, -1715.34448, 632.85571, 25.03898,   0.06000, 0.78000, -318.48013);
	CreateDynamicObject(874, -1723.90942, 644.84552, 25.03898,   0.06000, 0.78000, -220.62013);
	CreateDynamicObject(874, -1727.38660, 660.03204, 25.03898,   0.06000, 0.78000, -220.62013);
	CreateDynamicObject(874, -1729.46143, 632.45508, 25.03898,   0.06000, 0.78000, -220.62013);
	CreateDynamicObject(874, -1723.32715, 626.67181, 25.03898,   0.06000, 0.78000, -220.62013);
	CreateDynamicObject(874, -1718.96021, 622.60315, 25.03898,   0.06000, 0.78000, -220.62013);
	CreateDynamicObject(874, -1712.61523, 622.25726, 25.03898,   0.06000, 0.78000, -220.62013);
	CreateDynamicObject(874, -1736.58557, 625.17401, 25.03898,   0.06000, 0.78000, -254.28012);
	CreateDynamicObject(874, -1734.16321, 618.24207, 25.03898,   0.06000, 0.78000, -254.28012);
	CreateDynamicObject(874, -1732.11499, 613.18939, 25.03898,   0.06000, 0.78000, -254.28012);
	CreateDynamicObject(874, -1725.49988, 609.95508, 25.03898,   0.06000, 0.78000, -254.28012);
	CreateDynamicObject(874, -1724.93469, 620.27484, 25.03898,   0.06000, 0.78000, -303.30002);
	CreateDynamicObject(874, -1741.65930, 617.59747, 25.03898,   0.06000, 0.78000, -222.84012);
	CreateDynamicObject(874, -1739.63171, 606.67938, 25.03898,   0.06000, 0.78000, -299.88019);
	CreateDynamicObject(874, -1751.55493, 613.45929, 25.88688,   7.14000, 6.60000, -299.76025);
	CreateDynamicObject(874, -1753.16785, 605.03058, 25.88688,   7.14000, 6.60000, -312.00024);
	CreateDynamicObject(874, -1763.47644, 603.54443, 27.49516,   7.14000, 6.60000, -312.00024);
	CreateDynamicObject(874, -1766.37524, 613.46899, 27.49516,   7.14000, 6.60000, -261.36017);
	CreateDynamicObject(874, -1773.31738, 605.52319, 28.86607,   10.19999, 0.36000, -311.64014);
	CreateDynamicObject(874, -1772.10608, 613.97980, 28.86607,   10.19999, 0.36000, -274.92010);
	CreateDynamicObject(874, -1784.69861, 614.65863, 31.37940,   10.19999, 0.36000, -274.92010);
	CreateDynamicObject(874, -1784.19836, 607.08856, 31.37940,   10.19999, 0.36000, -302.70010);
	CreateDynamicObject(874, -1784.49634, 601.15240, 31.37940,   10.19999, 0.36000, -302.70010);
	CreateDynamicObject(874, -1803.98096, 596.01031, 33.19194,   -15.24000, 2.22000, -113.76013);
	CreateDynamicObject(874, -1802.89478, 612.40533, 33.19194,   -15.24000, 2.22000, -137.22011);
	CreateDynamicObject(874, -1792.25012, 600.72217, 32.20584,   -10.07998, -10.74001, -112.80011);
	CreateDynamicObject(874, -1803.16541, 604.66205, 34.14009,   -15.24000, 2.22000, -128.58012);
	CreateDynamicObject(3594, -1817.86499, 611.15320, 34.49276,   0.00000, 0.00000, -38.58000);
	CreateDynamicObject(3594, -1810.05542, 609.13379, 34.49276,   0.00000, 0.00000, -17.88000);
	CreateDynamicObject(3594, -1794.21216, 608.33258, 32.19592,   14.69999, 1.08000, 107.03997);
	CreateDynamicObject(3594, -1818.73169, 588.40283, 34.49276,   0.00000, 0.00000, 82.73999);
	CreateDynamicObject(3594, -1743.18701, 602.80737, 24.33913,   0.00000, 0.00000, -38.21999);
	CreateDynamicObject(3594, -1732.12292, 610.73334, 24.33913,   0.00000, 0.00000, -116.87998);
	CreateDynamicObject(3594, -1728.55054, 605.70142, 24.33913,   0.00000, 0.00000, -67.08000);
	CreateDynamicObject(3594, -1717.52539, 626.88025, 24.33913,   0.00000, 0.00000, -142.25998);
	CreateDynamicObject(3594, -1731.37671, 625.50201, 24.33913,   0.00000, 0.00000, -325.20004);
	CreateDynamicObject(672, -1772.70581, 602.43085, 28.66991,   0.00000, 0.00000, 71.21999);
	CreateDynamicObject(672, -1763.43970, 610.90027, 26.95519,   0.00000, 0.00000, 127.20001);
	CreateDynamicObject(3920, -1774.17554, 618.03699, 33.17384,   0.00000, 0.00000, -180.00008);
	CreateDynamicObject(3920, -1781.19031, 625.10529, 33.17384,   0.00000, 0.00000, -269.64001);
	CreateDynamicObject(874, -1860.06677, 582.31232, 34.43876,   0.00000, 0.00000, 21.84000);
	CreateDynamicObject(874, -1852.69214, 587.11548, 34.43876,   0.00000, 0.00000, 21.84000);
	CreateDynamicObject(874, -1852.72925, 575.30170, 34.43876,   0.00000, 0.00000, 21.84000);
	CreateDynamicObject(874, -1846.79688, 574.42621, 34.43876,   0.00000, 0.00000, 21.84000);
	CreateDynamicObject(874, -1848.81335, 568.96094, 34.43876,   0.00000, 0.00000, 21.84000);
	CreateDynamicObject(874, -1842.63892, 565.56195, 34.43876,   0.00000, 0.00000, 21.84000);
	CreateDynamicObject(874, -1847.46912, 559.44708, 34.43876,   0.00000, 0.00000, -46.68000);
	CreateDynamicObject(874, -1840.85071, 555.35516, 34.43876,   0.00000, 0.00000, -46.68000);
	CreateDynamicObject(874, -1850.87244, 551.85724, 34.40219,   0.00000, 0.00000, -72.89999);
	CreateDynamicObject(874, -1862.30615, 552.52686, 34.40219,   0.00000, 0.00000, -141.47997);
	CreateDynamicObject(874, -1870.29297, 557.36121, 34.40219,   0.00000, 0.00000, -145.55994);
	CreateDynamicObject(874, -1847.07568, 545.48883, 34.40219,   0.00000, 0.00000, -84.11996);
	CreateDynamicObject(874, -1840.32959, 543.89264, 34.40219,   0.00000, 0.00000, -84.11996);
	CreateDynamicObject(874, -1857.19507, 560.01245, 34.40219,   0.00000, 0.00000, -84.11996);
	CreateDynamicObject(874, -1862.15283, 564.22754, 34.40219,   0.00000, 0.00000, -84.11996);
	CreateDynamicObject(874, -1865.83447, 568.78442, 34.40219,   0.00000, 0.00000, -84.11996);
	CreateDynamicObject(874, -1877.73792, 573.06110, 34.43876,   0.00000, 0.00000, 30.72000);
	CreateDynamicObject(874, -1872.73511, 580.09271, 34.43876,   0.00000, 0.00000, 30.72000);
	CreateDynamicObject(703, -1870.78235, 574.87836, 33.14527,   0.00000, 0.00000, -38.22000);
	CreateDynamicObject(672, -1846.00549, 553.98615, 34.63194,   0.00000, 0.00000, 50.16001);
	CreateDynamicObject(874, -1852.96106, 536.04938, 33.98547,   0.00000, 0.00000, -113.21996);
	CreateDynamicObject(874, -1862.96338, 542.91858, 33.98547,   0.00000, 0.00000, -113.21996);
	CreateDynamicObject(874, -1871.71387, 547.90613, 33.98547,   0.00000, 0.00000, -122.75998);
	CreateDynamicObject(874, -1875.23572, 541.59357, 33.98547,   0.00000, 0.00000, -132.71997);
	CreateDynamicObject(874, -1865.91956, 536.12152, 33.98547,   0.00000, 0.00000, -113.21996);
	CreateDynamicObject(874, -1879.33691, 535.50909, 33.98547,   0.00000, 0.00000, -113.21996);
	CreateDynamicObject(874, -1883.78076, 529.41339, 33.98547,   0.00000, 0.00000, -113.21996);
	CreateDynamicObject(874, -1880.65540, 522.02692, 33.98547,   0.00000, 0.00000, -113.21996);
	CreateDynamicObject(874, -1877.23987, 525.11066, 33.98547,   0.00000, 0.00000, -143.87997);
	CreateDynamicObject(874, -1869.05042, 519.99127, 33.98547,   0.00000, 0.00000, -134.93999);
	CreateDynamicObject(874, -1868.19385, 527.74078, 33.98547,   0.00000, 0.00000, -124.79997);
	CreateDynamicObject(874, -1860.45776, 530.17889, 33.98547,   0.00000, 0.00000, -124.79997);
	CreateDynamicObject(3594, -1863.92847, 540.66272, 33.84963,   0.00000, 0.00000, 571.07990);
	CreateDynamicObject(10985, -1836.24377, 564.72937, 34.49976,   0.00000, 0.00000, 110.69996);
	CreateDynamicObject(874, -1833.63843, 554.30243, 33.98547,   0.00000, 0.00000, -241.25993);
	CreateDynamicObject(703, -1886.46045, 537.75061, 33.14527,   0.00000, 0.00000, -25.74000);
	CreateDynamicObject(874, -1913.88684, 436.04904, 34.43876,   0.00000, 0.00000, 130.37994);
	CreateDynamicObject(874, -1907.20068, 444.19699, 34.43876,   0.00000, 0.00000, 118.79993);
	CreateDynamicObject(874, -1897.61475, 448.77231, 34.43876,   0.00000, 0.00000, 87.83993);
	CreateDynamicObject(874, -1889.00610, 454.84882, 34.43876,   0.00000, 0.00000, 118.85994);
	CreateDynamicObject(874, -1878.51501, 457.19107, 34.43876,   0.00000, 0.00000, 73.91995);
	CreateDynamicObject(874, -1867.73950, 458.17761, 34.43876,   0.00000, 0.00000, 73.91995);
	CreateDynamicObject(874, -1859.88525, 457.98218, 34.43876,   0.00000, 0.00000, 73.91995);
	CreateDynamicObject(874, -1851.34412, 457.99673, 34.43876,   0.00000, 0.00000, 73.91995);
	CreateDynamicObject(874, -1854.14795, 452.11978, 34.43876,   0.00000, 0.00000, 113.21995);
	CreateDynamicObject(874, -1861.07764, 443.93982, 34.43876,   0.00000, 0.00000, 113.21995);
	CreateDynamicObject(874, -1868.48193, 436.50766, 34.43876,   0.00000, 0.00000, 113.21995);
	CreateDynamicObject(874, -1876.63232, 428.29956, 34.43876,   0.00000, 0.00000, 113.21995);
	CreateDynamicObject(874, -1883.33252, 420.85831, 34.43876,   0.00000, 0.00000, 113.21995);
	CreateDynamicObject(874, -1890.19189, 412.90027, 34.43876,   0.00000, 0.00000, 113.21995);
	CreateDynamicObject(874, -1898.55176, 407.35757, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1908.36548, 405.45810, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1920.04309, 406.26920, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1914.52563, 414.40387, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1914.18176, 425.66974, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1908.07886, 413.89328, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1898.94153, 414.13513, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1892.98389, 421.01498, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1885.91687, 426.76328, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1879.10413, 433.68103, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1872.67688, 439.25873, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1864.97546, 448.01016, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1906.78857, 428.74298, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1902.16919, 424.16278, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1894.48975, 430.86246, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1900.19897, 437.71399, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1890.45337, 442.48840, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1886.00525, 438.08240, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1883.34180, 447.97772, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(874, -1877.23523, 445.77576, 34.43876,   0.00000, 0.00000, -38.16003);
	CreateDynamicObject(672, -1908.18933, 434.37662, 34.69419,   0.00000, 0.00000, 80.75999);
	CreateDynamicObject(672, -1875.19238, 439.24731, 34.69419,   0.00000, 0.00000, 101.52000);
	CreateDynamicObject(672, -1893.19202, 420.97461, 34.69419,   0.00000, 0.00000, 52.32000);
	CreateDynamicObject(672, -1891.30017, 438.90979, 34.69419,   0.00000, 0.00000, 68.16000);
	CreateDynamicObject(874, -1931.83362, 405.55893, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1943.70483, 406.34958, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1955.09766, 406.71606, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1966.18188, 406.04486, 34.43876,   0.00000, 0.00000, 68.15997);
	CreateDynamicObject(874, -1974.65576, 409.63986, 34.43876,   0.00000, 0.00000, 26.75997);
	CreateDynamicObject(874, -1982.64099, 417.51709, 34.43876,   0.00000, 0.00000, 26.75997);
	CreateDynamicObject(874, -1982.62122, 425.75421, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1981.04492, 434.86301, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1979.28699, 442.75104, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1977.60596, 450.30762, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1976.98169, 459.02542, 35.22087,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1982.38318, 459.03961, 35.19829,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1984.95251, 449.94821, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1985.79102, 440.01093, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1986.13257, 430.06512, 34.43876,   0.00000, 0.00000, -15.72003);
	CreateDynamicObject(874, -1983.38147, 420.68466, 34.43876,   0.00000, 0.00000, -4.56003);
	CreateDynamicObject(672, -1946.64258, 404.61234, 34.69419,   0.00000, 0.00000, 29.40001);
	CreateDynamicObject(672, -1983.42139, 433.48209, 34.69419,   0.00000, 0.00000, 80.40001);
	CreateDynamicObject(874, -1971.07312, 488.77722, 35.69253,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1983.80859, 487.64706, 35.73410,   0.00000, 0.00000, -58.50000);
	CreateDynamicObject(874, -1984.02441, 476.84763, 35.71975,   0.00000, 0.00000, -58.50000);
	CreateDynamicObject(874, -1983.01257, 491.11142, 35.75282,   0.00000, 0.00000, -143.69998);
	CreateDynamicObject(874, -1983.90332, 579.57098, 34.43876,   0.00000, 0.00000, 16.86000);
	CreateDynamicObject(874, -1830.32837, 549.08234, 35.23047,   0.00000, 0.00000, -292.55991);
	CreateDynamicObject(874, -1831.46912, 542.29785, 35.23047,   0.00000, 0.00000, -328.19992);
	CreateDynamicObject(874, -1822.26270, 544.14978, 35.23047,   0.00000, 0.00000, -365.15997);
	CreateDynamicObject(8210, -1801.16016, 582.76227, 36.75878,   0.00000, 0.00000, 179.75999);
	CreateDynamicObject(8210, -1786.37744, 546.92535, 36.75878,   0.00000, 0.00000, 60.23995);
	CreateDynamicObject(9812, -1789.21704, 543.89069, 36.16560,   0.00000, 0.00000, 59.81999);
	CreateDynamicObject(9812, -1801.71912, 581.51227, 36.21063,   0.00000, 0.00000, 179.69997);
	CreateDynamicObject(3095, -1790.38269, 578.16052, 35.90617,   -0.06000, -89.33999, -52.86003);
	CreateDynamicObject(3095, -1790.32849, 578.07654, 44.59844,   -0.06000, -89.33999, -52.86003);
	CreateDynamicObject(3095, -1791.26636, 572.55078, 38.36963,   0.00000, -89.81995, 36.29996);
	CreateDynamicObject(3095, -1791.26636, 572.55078, 46.90138,   0.00000, -89.81995, 36.29996);
	CreateDynamicObject(3095, -1779.30981, 562.74707, 38.36963,   0.00000, -89.81995, 130.73996);
	CreateDynamicObject(3095, -1784.57544, 563.35272, 38.36963,   0.00000, -89.81995, 34.97996);
	CreateDynamicObject(3095, -1779.30981, 562.74707, 45.07905,   0.00000, -89.81995, 130.73996);
	CreateDynamicObject(3095, -1784.57544, 563.35272, 43.36823,   0.00000, -89.81995, 35.09995);
	CreateDynamicObject(3095, -1788.04407, 568.19055, 43.06171,   0.00000, -89.81995, 36.29996);
	CreateDynamicObject(19313, -1796.70862, 575.90741, 37.24998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, -1810.66748, 575.91394, 37.24998,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, -1786.81519, 553.91125, 37.24998,   0.00000, 0.00000, 51.35999);
	CreateDynamicObject(19313, -1795.52832, 542.98822, 37.24998,   0.00000, 0.00000, 51.35999);
	CreateDynamicObject(3578, -1824.35669, 557.97705, 34.93032,   0.00000, 0.00000, -60.90000);
	CreateDynamicObject(19313, -1829.38904, 566.81366, 37.24998,   0.00000, 0.00000, -60.23999);
	CreateDynamicObject(19313, -1819.04333, 548.67902, 37.24998,   0.00000, 0.00000, -60.23999);
	CreateDynamicObject(3578, -1813.75696, 539.71985, 34.93032,   0.00000, 0.00000, -60.90000);
	CreateDynamicObject(19313, -1808.61511, 530.38855, 37.24998,   0.00000, 0.00000, -60.23999);
	CreateDynamicObject(971, -1786.42786, 565.05182, 37.76915,   0.00000, 0.00000, 305.45987);
	CreateDynamicObject(3050, -1791.88831, 572.32983, 36.31269,   0.00000, 0.00000, 126.54007);
	CreateDynamicObject(3050, -1794.42871, 575.84021, 36.31269,   0.00000, 0.00000, 126.54007);
	CreateDynamicObject(3050, -1787.65637, 566.65173, 36.31269,   0.00000, 0.00000, 125.64010);
	CreateDynamicObject(3050, -1785.15332, 563.10107, 36.31269,   0.00000, 0.00000, 125.46011);
	CreateDynamicObject(3876, -1806.08838, 559.05829, 33.93787,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(16096, -1803.98889, 572.37164, 35.82851,   0.00000, 0.00000, 89.82003);
	CreateDynamicObject(16096, -1811.02014, 572.35211, 35.82851,   0.00000, 0.00000, 89.82003);
	CreateDynamicObject(1596, -1803.73413, 558.08734, 36.64878,   0.00000, 0.00000, 55.14000);
	CreateDynamicObject(3630, -1791.07825, 551.23511, 35.53209,   0.00000, 0.00000, 51.18002);
	CreateDynamicObject(3502, -1798.20178, 548.65173, 34.95802,   -12.60000, 2.88000, -136.62000);
	CreateDynamicObject(874, -1803.15784, 535.90485, 34.54508,   0.00000, 0.00000, -309.18002);
	CreateDynamicObject(874, -1796.13928, 544.30768, 34.54508,   0.00000, 0.00000, -400.86008);
	CreateDynamicObject(874, -1809.83508, 545.28754, 34.54508,   0.00000, 0.00000, -353.46002);
	CreateDynamicObject(874, -1818.08777, 555.52783, 34.54508,   0.00000, 0.00000, -353.46002);
	CreateDynamicObject(874, -1821.71045, 567.45074, 34.54508,   0.00000, 0.00000, -379.02005);
	CreateDynamicObject(3594, -1830.45728, 540.00189, 34.47789,   0.00000, 0.00000, 566.93982);
	CreateDynamicObject(3594, -1819.48840, 537.77930, 34.47789,   0.00000, 0.00000, 618.41992);
	CreateDynamicObject(3920, -1818.75134, 548.55151, 39.52310,   0.00000, 0.00000, -240.47995);
	CreateDynamicObject(3920, -1828.80896, 566.35150, 39.52310,   0.00000, 0.00000, -240.47995);
	CreateDynamicObject(3920, -1808.69055, 530.88867, 39.52310,   0.00000, 0.00000, -240.47995);
	CreateDynamicObject(9812, -1598.03345, 644.19659, 34.56656,   1.62000, 2.04000, -133.50018);
	CreateDynamicObject(8210, -1799.80530, -308.39664, 13.27777,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1799.80530, -308.39664, 20.39062,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1799.80530, -308.39664, 27.56811,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1799.80530, -308.39664, 34.73240,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1854.56287, -307.36026, 27.56811,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1854.56287, -307.36026, 34.69045,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1854.56287, -307.36026, 41.48245,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1907.22668, -306.34726, 40.13480,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1854.56287, -307.36026, 48.51316,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1907.22668, -306.34726, 47.19799,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1907.22668, -306.34726, 54.38388,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1907.22668, -306.34726, 32.83973,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1961.78491, -305.20993, 27.52182,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1961.78491, -305.20993, 34.49003,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -1961.78491, -305.20993, 41.41700,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2016.93823, -304.06232, 27.52182,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2016.93823, -304.06232, 34.61006,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2016.93823, -304.06232, 41.70257,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2072.50049, -303.05435, 37.41035,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2072.50049, -303.05435, 44.43278,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2127.84937, -302.00406, 37.41035,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2127.84937, -302.00406, 44.43866,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2183.30493, -300.96625, 37.41035,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2183.30493, -300.96625, 44.40875,   0.00000, 0.00000, 178.97992);
	CreateDynamicObject(8210, -2213.96436, -272.60590, 37.41035,   0.00000, 0.00000, 94.91994);
	CreateDynamicObject(8210, -2213.96436, -272.60590, 44.54176,   0.00000, 0.00000, 94.91994);
	CreateDynamicObject(8210, -2218.62598, -217.50130, 37.41035,   0.00000, 0.00000, 94.91994);
	CreateDynamicObject(8210, -2218.62598, -217.50130, 44.41703,   -0.30000, 0.06000, 94.91994);
	CreateDynamicObject(8210, -2222.19385, -175.40804, 37.41035,   0.00000, 0.00000, 94.91994);
	CreateDynamicObject(8210, -2222.20654, -175.41039, 42.89818,   0.00000, 0.00000, 94.91994);
	CreateDynamicObject(8210, -2234.13208, -79.07339, 37.03132,   0.00000, 0.00000, 89.52008);
	CreateDynamicObject(8210, -2234.13208, -79.07339, 44.00749,   0.00000, 0.00000, 89.52008);
	CreateDynamicObject(8210, -2225.97241, 19.69275, 37.04184,   0.00000, 0.00000, 89.63999);
	CreateDynamicObject(8210, -2225.97241, 19.69275, 44.05975,   0.00000, 0.00000, 89.63999);
	CreateDynamicObject(8210, -2225.45801, 92.04555, 37.18055,   0.00000, 0.00000, 89.63999);
	CreateDynamicObject(8210, -2225.45801, 92.04555, 43.78011,   0.00000, 0.00000, 89.63999);
	CreateDynamicObject(8210, -2236.73608, 165.41167, 37.06402,   0.00000, 0.00000, 90.36001);
	CreateDynamicObject(8210, -2236.73608, 165.41167, 43.97536,   0.00000, 0.00000, 90.36001);
	CreateDynamicObject(8210, -2236.86597, 209.14230, 37.00551,   0.00000, 0.00000, 90.65997);
	CreateDynamicObject(8210, -2236.86597, 209.14230, 43.93175,   0.00000, 0.00000, 90.65997);
	CreateDynamicObject(8210, -2238.18457, 312.29593, 36.72047,   0.00000, 0.00000, 90.00005);
	CreateDynamicObject(8210, -2238.18457, 312.29593, 43.39991,   0.00000, 0.00000, 90.00005);
	CreateDynamicObject(8210, -2226.34595, 479.78104, 37.03067,   0.00000, 0.00000, 178.67978);
	CreateDynamicObject(8210, -2226.34595, 479.78104, 44.09379,   0.00000, 0.00000, 178.67978);
	CreateDynamicObject(8210, -2347.84668, 469.39288, 32.93499,   0.00000, 0.00000, -146.75996);
	CreateDynamicObject(8210, -2347.84668, 469.39288, 40.00441,   0.00000, 0.00000, -146.75996);
	CreateDynamicObject(8210, -2475.69531, 462.33719, 26.00304,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2475.69531, 462.33719, 33.24072,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2475.69531, 462.33719, 40.14618,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2507.39893, 502.81097, 24.04731,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2507.39893, 502.81097, 30.90578,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2507.39893, 502.81097, 37.91971,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2507.39893, 502.81097, 16.29174,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2528.18481, 529.63617, 16.29174,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2528.18481, 529.63617, 23.18992,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2528.18481, 529.63617, 29.99158,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2528.18481, 529.63617, 37.32582,   0.00000, 0.00000, -231.83992);
	CreateDynamicObject(8210, -2606.77148, 540.66376, 15.83438,   0.00000, 0.00000, -179.51999);
	CreateDynamicObject(8210, -2606.77148, 540.66376, 22.73406,   0.00000, 0.00000, -179.51999);
	CreateDynamicObject(8210, -2714.20752, 565.88916, 16.25483,   0.00000, 0.00000, -268.85995);
	CreateDynamicObject(8210, -2714.20752, 565.88916, 23.15434,   0.00000, 0.00000, -268.85995);
	CreateDynamicObject(8210, -2608.76660, 697.76312, 29.61084,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2608.76660, 697.76312, 36.65783,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2553.90601, 698.18176, 29.61084,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2553.90601, 698.18176, 36.70212,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2498.62134, 698.54657, 29.61084,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2498.62134, 698.54657, 36.70358,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2443.71484, 698.84106, 36.70358,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2443.71484, 698.84106, 43.76585,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2498.62134, 698.54657, 43.70761,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2388.20972, 699.09894, 36.70358,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2388.20972, 699.09894, 43.78714,   0.00000, 0.00000, 0.30000);
	CreateDynamicObject(8210, -2271.94531, 755.19049, 50.61034,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -2271.94531, 755.19049, 57.60729,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -2284.74561, 723.07697, 50.61034,   0.00000, 0.00000, 87.53997);
	CreateDynamicObject(8210, -2284.74561, 723.07697, 57.48590,   0.00000, 0.00000, 87.53997);
	CreateDynamicObject(8210, -2147.02734, 758.08252, 70.94513,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -2147.02734, 758.08252, 77.98724,   -3.36000, -0.30000, 0.00000);
	CreateDynamicObject(874, -1610.43909, 693.06000, 47.89026,   0.00000, 0.00000, -96.60001);
	CreateDynamicObject(874, -1600.23547, 693.23987, 47.89026,   0.00000, 0.00000, -96.60001);
	CreateDynamicObject(874, -1590.19336, 693.35175, 47.89026,   0.00000, 0.00000, -96.60001);
	CreateDynamicObject(874, -1581.86902, 692.69928, 47.89026,   0.00000, 0.00000, -96.60001);
	CreateDynamicObject(874, -1576.05701, 697.69342, 47.89026,   0.00000, 0.00000, -34.49998);
	CreateDynamicObject(874, -1576.81897, 708.99988, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1584.16333, 706.17017, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1591.73499, 704.44293, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1599.94080, 703.74719, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1611.03076, 703.82611, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1620.78259, 703.20905, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1621.53479, 696.62756, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(874, -1630.79443, 696.39746, 47.89026,   0.00000, 0.00000, -10.49999);
	CreateDynamicObject(2934, -1561.67395, 685.56409, 45.57502,   19.80000, 7.14000, 62.15999);
	CreateDynamicObject(2932, -1571.14807, 689.33514, 50.11094,   10.56000, 3.18000, 53.87999);
	CreateDynamicObject(2932, -1575.51746, 691.69269, 48.27321,   -3.36000, 7.92000, 61.07999);
	CreateDynamicObject(10984, -1582.99475, 698.44177, 47.81353,   0.00000, 0.00000, -179.03993);
	CreateDynamicObject(874, -1655.26013, 697.93231, 38.45968,   0.00000, 0.00000, -17.63996);
	CreateDynamicObject(874, -1645.17346, 698.23456, 38.45968,   0.00000, 0.00000, -17.63996);
	CreateDynamicObject(874, -1649.54248, 706.46313, 38.45968,   0.00000, 0.00000, -96.41997);
	CreateDynamicObject(2934, -1645.65271, 697.05988, 43.17651,   0.00000, 0.00000, -6.66000);
	CreateDynamicObject(2934, -1645.91528, 703.41205, 40.52507,   38.45999, 6.96000, 195.96002);
	CreateDynamicObject(2932, -1643.26221, 697.09418, 45.89640,   0.00000, 0.00000, -89.45998);
	CreateDynamicObject(19364, -1642.91638, 711.10773, 38.84920,   0.00000, 0.00000, 87.53999);
	CreateDynamicObject(19364, -1643.02551, 714.11493, 38.78687,   0.00000, 0.00000, 89.94007);
	CreateDynamicObject(19364, -1641.60071, 712.56055, 38.84845,   0.00000, 0.00000, -0.17997);
	CreateDynamicObject(19393, -1644.53113, 712.62891, 38.76128,   0.00000, 0.00000, 1.25999);
	CreateDynamicObject(1499, -1644.58850, 713.38977, 37.23812,   0.00000, 0.00000, -88.68004);
	CreateDynamicObject(19343, -1642.70776, 712.54871, 37.96181,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -1629.22864, 706.16888, 47.89026,   0.00000, 0.00000, -77.33997);
	CreateDynamicObject(11235, -1650.07837, 694.71283, 40.16229,   0.00000, 0.00000, 178.98001);
	CreateDynamicObject(19355, -1642.84973, 712.63293, 40.51414,   -0.24000, 90.84008, 0.72000);
	CreateDynamicObject(3928, -1616.88062, 711.17719, 47.92865,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, -1614.07898, 719.05383, 51.42759,   0.00000, 0.00000, -0.00004);
	CreateDynamicObject(8210, -1599.13489, 718.99377, 51.42759,   0.00000, 0.00000, -0.00004);
	CreateDynamicObject(8210, -1634.41357, 719.07086, 40.65163,   -0.60000, 0.24000, 0.11996);
	CreateDynamicObject(8210, -1634.41357, 719.07086, 47.75827,   -0.60000, 0.24000, 0.11996);
	CreateDynamicObject(8210, -1634.41357, 719.07086, 51.38710,   -0.60000, 0.24000, 0.11996);
	CreateDynamicObject(987, -1571.93555, 718.68341, 48.50873,   0.00000, 0.00000, -89.70000);
	CreateDynamicObject(987, -1571.85266, 706.73499, 48.50873,   0.00000, 0.00000, -89.70000);
	CreateDynamicObject(987, -1546.65662, 700.45697, 43.84192,   0.00000, 0.00000, -40.25999);
	CreateDynamicObject(987, -1537.62000, 692.67474, 43.84192,   0.00000, 0.00000, -44.10000);
	CreateDynamicObject(987, -1529.04932, 684.30499, 43.84192,   0.00000, 0.00000, -44.10000);
	CreateDynamicObject(987, -1526.19507, 681.47369, 43.84192,   0.00000, 0.00000, -44.10000);
	CreateDynamicObject(987, -1526.19507, 681.47369, 48.69104,   0.00000, 0.00000, -44.10000);
	CreateDynamicObject(987, -1529.04932, 684.30499, 48.83120,   0.00000, 0.00000, -44.10000);
	CreateDynamicObject(987, -1537.62000, 692.67474, 48.76115,   0.00000, 0.00000, -44.10000);
	CreateDynamicObject(987, -1546.65662, 700.45697, 48.73309,   0.00000, 0.00000, -40.25999);
	CreateDynamicObject(11255, -1559.96240, 546.14435, 7.38586,   3.54000, -9.54000, 0.00000);
	CreateDynamicObject(11261, -1563.11279, 542.01477, 6.58290,   -9.41999, -0.66000, 0.00000);
	CreateDynamicObject(10984, -1531.97266, 558.85486, 6.76845,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -1536.38464, 564.63544, 6.76845,   0.00000, 0.00000, -13.02000);
	CreateDynamicObject(10984, -1538.97278, 561.05853, 6.76845,   0.00000, 0.00000, -4.26000);
	CreateDynamicObject(987, -1507.50635, 591.24249, 37.67830,   0.00000, 0.00000, -52.02000);
	CreateDynamicObject(9812, -1560.40955, 629.37701, 35.27880,   1.86000, -1.68000, 45.77982);
	CreateDynamicObject(9812, -1601.25903, 585.65558, 33.19226,   1.86000, -1.68000, 47.39982);
	CreateDynamicObject(3865, -2045.42236, 119.90556, 27.80155,   28.92001, -14.46000, 25.92003);
	CreateDynamicObject(10984, -2043.85706, 118.74588, 28.03874,   0.00000, 0.00000, -147.48010);
	CreateDynamicObject(874, -1979.96179, 188.19733, 27.07328,   0.00000, 0.00000, -0.90000);
	CreateDynamicObject(874, -1985.01392, 187.35919, 27.07328,   0.00000, 0.00000, -14.58000);
	CreateDynamicObject(874, -1989.15198, 189.81581, 27.07328,   0.00000, 0.00000, -39.48000);
	CreateDynamicObject(874, -1992.94189, 181.11829, 27.07328,   0.00000, 0.00000, -175.97998);
	CreateDynamicObject(874, -1985.04016, 175.64772, 27.07328,   0.00000, 0.00000, -175.97998);
	CreateDynamicObject(874, -1978.96887, 174.68077, 27.07328,   0.00000, 0.00000, -175.97998);
	CreateDynamicObject(874, -1986.89612, 167.83609, 27.07328,   0.00000, 0.00000, -154.20001);
	CreateDynamicObject(874, -1996.66223, 172.72826, 27.07328,   0.00000, 0.00000, -154.20001);
	CreateDynamicObject(874, -1998.46362, 188.63420, 27.07328,   0.00000, 0.00000, -230.16005);
	CreateDynamicObject(874, -2004.04492, 178.18864, 27.07328,   0.00000, 0.00000, -230.16005);
	CreateDynamicObject(874, -2001.20288, 168.43579, 27.07328,   0.00000, 0.00000, -266.34003);
	CreateDynamicObject(874, -1991.18958, 161.31606, 27.07328,   0.00000, 0.00000, -319.43991);
	CreateDynamicObject(874, -2003.59485, 189.56757, 27.07328,   0.00000, 0.00000, -54.42000);
	CreateDynamicObject(874, -1994.10864, 197.37387, 27.07328,   0.00000, 0.00000, 45.18000);
	CreateDynamicObject(874, -2010.96716, 191.71976, 27.07328,   0.00000, 0.00000, -50.81999);
	CreateDynamicObject(874, -2010.79309, 183.58298, 27.07328,   0.00000, 0.00000, 6.96001);
	CreateDynamicObject(874, -2008.31470, 171.26312, 27.07328,   0.00000, 0.00000, 6.96001);
	CreateDynamicObject(981, -2006.02209, 197.06813, 27.20633,   0.00000, 0.00000, 180.83986);
	CreateDynamicObject(19313, -1984.76099, 198.28966, 29.95638,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, -1977.74683, 191.37448, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(19313, -1977.71326, 177.37192, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(19313, -1977.69360, 172.75685, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(3279, -1983.28308, 192.79390, 26.48530,   0.00000, 0.00000, 181.07994);
	CreateDynamicObject(874, -2032.44519, 177.71838, 27.07328,   0.00000, 0.00000, -108.12000);
	CreateDynamicObject(874, -2032.02222, 170.72302, 27.07328,   0.00000, 0.00000, -108.12000);
	CreateDynamicObject(874, -2026.37817, 171.23915, 27.07328,   0.00000, 0.00000, -196.74002);
	CreateDynamicObject(874, -2026.01111, 177.91689, 27.07328,   0.00000, 0.00000, -196.74002);
	CreateDynamicObject(874, -2032.08655, 161.88951, 27.07328,   0.00000, 0.00000, -196.74002);
	CreateDynamicObject(874, -2026.60229, 161.68309, 27.07328,   0.00000, 0.00000, -196.74002);
	CreateDynamicObject(874, -2029.63000, 152.60208, 27.07328,   0.00000, 0.00000, -196.74002);
	CreateDynamicObject(3594, -2007.95483, 202.84845, 26.98549,   0.00000, 0.00000, 70.43999);
	CreateDynamicObject(3594, -1996.82458, 209.54929, 26.98549,   0.00000, 0.00000, -2.16001);
	CreateDynamicObject(3594, -2006.32971, 208.94151, 26.98549,   0.00000, 0.00000, -165.53996);
	CreateDynamicObject(3594, -2004.89551, 215.82780, 26.98549,   0.00000, 0.00000, -68.16002);
	CreateDynamicObject(3594, -1999.44714, 209.75705, 27.10084,   -15.36001, -1.08000, 58.97999);
	CreateDynamicObject(10984, -1993.50867, 210.47775, 26.86458,   0.00000, 0.00000, -123.59999);
	CreateDynamicObject(672, -1990.55164, 181.85680, 27.21094,   3.14159, 0.00000, 0.94248);
	CreateDynamicObject(672, -2028.12671, 176.42412, 28.38667,   3.14159, 0.00000, -48.73751);
	CreateDynamicObject(3594, -2008.80005, 180.07076, 26.98549,   0.00000, 0.00000, 34.37999);
	CreateDynamicObject(3594, -2002.42163, 160.57025, 26.98549,   0.00000, 0.00000, 160.19997);
	CreateDynamicObject(3594, -2007.92200, 140.90939, 26.98549,   0.00000, 0.00000, 119.57998);
	CreateDynamicObject(3594, -2002.25623, 130.65399, 26.98549,   0.00000, 0.00000, 224.09999);
	CreateDynamicObject(3594, -1993.82556, 113.74032, 26.98549,   0.00000, 0.00000, 114.59995);
	CreateDynamicObject(3594, -2007.24976, 121.67292, 26.98549,   0.00000, 0.00000, 168.83997);
	CreateDynamicObject(3594, -2005.89124, 109.31304, 26.98549,   0.00000, 0.00000, 33.17996);
	CreateDynamicObject(3594, -1991.17419, 188.48395, 26.98549,   0.00000, 0.00000, -47.10004);
	CreateDynamicObject(874, -1988.96118, 120.34001, 27.07328,   0.00000, 0.00000, -230.16005);
	CreateDynamicObject(874, -1989.96912, 108.14622, 27.07328,   0.00000, 0.00000, -295.32010);
	CreateDynamicObject(874, -1987.97742, 114.15737, 27.07328,   0.00000, 0.00000, -295.32010);
	CreateDynamicObject(874, -1995.51746, 124.53645, 27.07328,   0.00000, 0.00000, -395.16013);
	CreateDynamicObject(874, -2005.43213, 127.98215, 27.07328,   0.00000, 0.00000, -424.44009);
	CreateDynamicObject(874, -2000.39587, 108.67364, 27.07328,   0.00000, 0.00000, -485.46014);
	CreateDynamicObject(874, -2000.39587, 108.67364, 27.07328,   0.00000, 0.00000, -485.46014);
	CreateDynamicObject(874, -2005.87366, 135.64714, 27.07328,   0.00000, 0.00000, -424.44009);
	CreateDynamicObject(874, -2005.59033, 116.25303, 27.07328,   0.00000, 0.00000, -424.44009);
	CreateDynamicObject(874, -2002.49951, 106.51003, 27.07328,   0.00000, 0.00000, -481.01996);
	CreateDynamicObject(672, -1994.88062, 105.29527, 27.21094,   3.14159, 0.00000, 0.94248);
	CreateDynamicObject(19313, -2016.70728, 125.45833, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(19313, -2023.64673, 118.47717, 29.95638,   0.00000, 0.00000, -180.35999);
	CreateDynamicObject(19313, -2016.72498, 139.40060, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(19313, -2016.64990, 161.94670, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(19313, -2016.71521, 175.99232, 29.95638,   0.00000, 0.00000, -89.88000);
	CreateDynamicObject(19313, -2023.75085, 183.02493, 29.91596,   0.00000, 0.00000, -180.35999);
	CreateDynamicObject(19313, -2037.67188, 182.99518, 29.88564,   0.00000, 0.00000, -179.46002);
	CreateDynamicObject(19313, -2050.98120, 118.75397, 29.95638,   0.00000, 0.00000, -182.33990);
	CreateDynamicObject(19313, -2059.40991, 125.80643, 29.95638,   0.00000, 0.00000, -77.88000);
	CreateDynamicObject(19313, -2060.79297, 159.08176, 29.95638,   0.00000, 0.00000, -90.72002);
	CreateDynamicObject(19313, -2060.97144, 145.07478, 29.95638,   0.00000, 0.00000, -90.72002);
	CreateDynamicObject(874, -2003.79712, 157.68336, 27.07328,   0.00000, 0.00000, -230.16005);
	CreateDynamicObject(874, -1999.81470, 151.75273, 27.07328,   0.00000, 0.00000, -230.16005);
	CreateDynamicObject(874, -2010.90112, 151.55544, 27.07328,   0.00000, 0.00000, -183.96004);
	CreateDynamicObject(874, -2025.56482, 143.04454, 27.07328,   0.00000, 0.00000, -183.96004);
	CreateDynamicObject(874, -2031.58093, 136.15625, 27.07328,   0.00000, 0.00000, -126.30006);
	CreateDynamicObject(874, -2023.92419, 134.45728, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2029.53491, 129.06746, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2046.98169, 145.56796, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2051.95996, 146.93536, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2053.53979, 139.00296, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2044.66833, 137.64627, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2039.98364, 137.85422, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2049.89282, 122.68029, 27.07328,   0.00000, 0.00000, -86.52005);
	CreateDynamicObject(874, -2050.91431, 129.66612, 27.07328,   0.00000, 0.00000, -100.38006);
	CreateDynamicObject(874, -2040.43176, 129.82922, 27.07328,   0.00000, 0.00000, -100.38006);
	CreateDynamicObject(874, -2040.43176, 129.82922, 27.07328,   0.00000, 0.00000, -100.38006);
	CreateDynamicObject(672, -2049.19531, 144.78821, 28.38667,   3.14159, 0.00000, -89.71751);
	CreateDynamicObject(981, -2003.81018, 102.08710, 27.20633,   0.00000, 0.00000, 351.71994);
	CreateDynamicObject(874, -1986.71655, 132.18156, 27.07328,   0.00000, 0.00000, -378.24014);
	CreateDynamicObject(874, -1993.07739, 140.91713, 27.07328,   0.00000, 0.00000, -378.24014);
	CreateDynamicObject(874, -1988.22205, 152.38731, 27.07328,   0.00000, 0.00000, -389.28009);
	CreateDynamicObject(3279, -1986.08508, 113.38358, 26.48530,   0.00000, 0.00000, 90.84012);
	CreateDynamicObject(19313, -1984.54004, 104.07738, 29.95638,   0.00000, 0.00000, -135.17998);
	CreateDynamicObject(9812, -1979.26379, 138.54886, 32.87057,   0.00000, 0.00000, -90.36006);
	CreateDynamicObject(8210, -2228.11865, 379.77661, 36.72047,   0.00000, 0.00000, 90.00005);
	CreateDynamicObject(8210, -2201.76392, 434.84100, 36.72047,   0.00000, 0.00000, 90.00005);
	CreateDynamicObject(10984, -2059.44336, 471.18518, 35.29119,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2054.74219, 459.05026, 34.73294,   0.00000, 0.00000, 37.38000);
	CreateDynamicObject(10984, -2040.24622, 452.34860, 38.62479,   11.46001, 33.90001, 90.36006);
	CreateDynamicObject(10984, -2050.51050, 454.67102, 38.62479,   11.46001, 33.90001, 48.90002);
	CreateDynamicObject(10984, -2057.15186, 463.93106, 38.62479,   11.46001, 33.90001, 29.16001);
	CreateDynamicObject(987, -2016.90674, 453.19547, 33.28281,   0.00000, 0.00000, -269.63983);
	CreateDynamicObject(987, -2016.99451, 462.13794, 33.30556,   0.00000, 0.00000, -270.11981);
	CreateDynamicObject(987, -2016.90771, 473.96680, 33.32142,   0.00000, 0.00000, -180.05968);
	CreateDynamicObject(987, -2024.76147, 473.96170, 33.33118,   0.00000, 0.00000, -179.99968);
	CreateDynamicObject(987, -2036.46521, 494.14322, 33.38196,   0.00000, 0.00000, -0.05971);
	CreateDynamicObject(987, -2036.72729, 494.12393, 33.35425,   0.00000, 0.00000, 180.06032);
	CreateDynamicObject(974, -2019.96582, 494.17908, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2026.59253, 494.15967, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2033.25439, 494.16476, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2039.94617, 494.16299, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2046.61572, 494.15054, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2053.25684, 494.16803, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2020.25317, 473.97870, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2026.87598, 473.95383, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2033.36047, 473.95422, 36.74533,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(974, -2016.95288, 470.63773, 36.74533,   0.00000, 0.00000, -90.36001);
	CreateDynamicObject(974, -2016.97083, 464.00177, 36.74533,   0.00000, 0.00000, -90.36001);
	CreateDynamicObject(974, -2017.00366, 457.37643, 36.74533,   0.00000, 0.00000, -90.36001);
	CreateDynamicObject(974, -2036.63269, 490.83521, 36.74533,   0.00000, 0.00000, -90.05996);
	CreateDynamicObject(974, -2036.64319, 477.31891, 36.74533,   0.00000, 0.00000, -90.05996);
	CreateDynamicObject(3578, -2031.47314, 480.06451, 34.87545,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, -2031.45386, 488.07413, 34.87545,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, -2022.13110, 490.69382, 34.87545,   0.00000, 0.00000, 32.04002);
	CreateDynamicObject(978, -2022.01282, 477.40976, 36.42249,   0.00000, 0.00000, -29.09999);
	CreateDynamicObject(978, -2031.33069, 480.03775, 36.42249,   0.00000, 0.00000, 0.06000);
	CreateDynamicObject(979, -2031.41821, 488.18796, 36.39029,   0.00000, 0.00000, -180.23994);
	CreateDynamicObject(979, -2021.99768, 490.87100, 36.39029,   0.00000, 0.00000, -148.26003);
	CreateDynamicObject(1434, -2018.40320, 483.38663, 34.22305,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1434, -2018.42676, 485.00745, 34.22305,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1434, -2019.42334, 484.16180, 34.22305,   0.00000, 0.00000, 90.06004);
	CreateDynamicObject(1237, -2018.41089, 484.19147, 34.16608,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3265, -2018.38220, 484.18808, 34.49902,   0.00000, 0.00000, 90.83997);
	CreateDynamicObject(1434, -2017.35425, 484.18756, 34.22305,   0.00000, 0.00000, 90.06004);
	CreateDynamicObject(987, -2028.66785, 494.11664, 33.38196,   0.00000, 0.00000, 0.36029);
	CreateDynamicObject(987, -2044.48096, 494.18954, 33.35425,   0.00000, 0.00000, 180.06032);
	CreateDynamicObject(3865, -2058.07593, 472.49832, 37.07297,   0.00000, 0.00000, 13.02000);
	CreateDynamicObject(3865, -2055.84351, 463.81750, 37.07297,   0.00000, 0.00000, 13.02000);
	CreateDynamicObject(3865, -2051.28101, 457.70694, 37.07297,   0.00000, 0.00000, 54.23997);
	CreateDynamicObject(3865, -2044.65002, 452.16837, 37.07297,   0.00000, 0.00000, 43.49996);
	CreateDynamicObject(2973, -2035.60059, 460.63934, 34.09781,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2973, -2038.85986, 460.45175, 34.09781,   0.00000, 0.00000, -14.16000);
	CreateDynamicObject(2973, -2038.05237, 460.93967, 37.84079,   -90.06000, -22.02001, -69.66000);
	CreateDynamicObject(1681, -2035.34692, 455.44913, 56.98642,   -19.32000, -5.28000, -178.43997);
	CreateDynamicObject(10984, -2035.76624, 454.55420, 55.67601,   16.80002, 87.18001, 90.36006);
	CreateDynamicObject(2973, -2037.27612, 462.10959, 35.27607,   -88.62006, -26.45997, 3.54000);
	CreateDynamicObject(10984, -1676.16846, 705.64642, 30.44966,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3399, -1668.19067, 701.28729, 35.77237,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3399, -1679.89258, 701.20746, 31.12645,   0.00000, 0.00000, 0.84000);
	CreateDynamicObject(3920, -1661.54968, 712.55341, 32.81583,   0.00000, 0.00000, 89.27996);
	CreateDynamicObject(3920, -1661.66687, 700.10107, 32.81583,   0.00000, 0.00000, 89.27996);
	CreateDynamicObject(3920, -1661.41846, 694.36682, 32.81583,   0.00000, 0.00000, 89.27996);
	CreateDynamicObject(3920, -1662.07935, 693.84265, 37.03304,   0.00000, 0.00000, 90.05995);
	CreateDynamicObject(3920, -1662.06323, 708.81329, 36.97309,   0.00000, 0.00000, 90.05995);
	CreateDynamicObject(3920, -1655.86755, 687.64081, 37.03304,   0.00000, 0.00000, 180.11986);
	CreateDynamicObject(3920, -1643.91248, 687.59906, 33.15649,   0.00000, 0.00000, 180.11986);
	CreateDynamicObject(3578, -1607.20667, 712.10931, 48.61739,   0.00000, 0.00000, -92.16009);
	CreateDynamicObject(3578, -1617.57178, 703.35150, 48.61739,   0.00000, 0.00000, -183.36006);
	CreateDynamicObject(3578, -1626.60876, 712.09070, 48.61739,   0.00000, 0.00000, -271.26007);
	CreateDynamicObject(3796, -2044.36462, 463.36285, 34.09163,   0.00000, 0.00000, -125.75999);
	CreateDynamicObject(3798, -2044.37317, 463.35800, 34.16316,   0.00000, 0.00000, -23.88000);
	CreateDynamicObject(1306, -2016.63647, 464.91983, 40.00312,   -32.45999, -1.44000, -90.42001);
	CreateDynamicObject(3279, -2024.77881, 458.71625, 34.16093,   0.00000, 0.00000, -269.34012);
	CreateDynamicObject(3798, -2026.06494, 459.42004, 50.19035,   0.00000, 0.00000, -11.52000);
	CreateDynamicObject(2973, -2023.96936, 458.09528, 50.20747,   0.00000, 0.00000, -32.58000);
	CreateDynamicObject(3798, -2024.46716, 457.99756, 52.66771,   0.00000, 0.00000, -63.00000);
	CreateDynamicObject(2977, -2037.73425, 489.87677, 35.35967,   0.00000, 0.00000, -90.65999);
	CreateDynamicObject(19313, -2043.65320, 487.58557, 37.37076,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19313, -2043.61694, 490.88223, 40.51374,   -89.88000, 9.36000, 9.24000);
	CreateDynamicObject(19313, -2043.64099, 494.03104, 37.20573,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2977, -2044.39014, 488.49576, 35.46980,   0.00000, 0.00000, -93.29996);
	CreateDynamicObject(3576, -2039.08691, 489.18115, 35.51838,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3577, -2043.63965, 489.41458, 34.91356,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3796, -2047.35767, 489.76938, 34.16607,   0.00000, 0.00000, -90.48000);
	CreateDynamicObject(3578, -2050.14282, 482.40613, 34.88467,   0.00000, 0.00000, 89.04000);
	CreateDynamicObject(979, -2050.18604, 482.56033, 36.36643,   0.00000, 0.00000, -91.20000);
	CreateDynamicObject(2973, -2047.95618, 485.95309, 34.06534,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(925, -2048.09595, 483.39890, 35.38150,   -51.18003, 2.58000, -0.78000);
	CreateDynamicObject(3091, -2045.89233, 485.05917, 34.66359,   -38.46000, 1.26000, 87.06000);
	CreateDynamicObject(1441, -2048.29468, 480.15482, 34.70393,   -13.26000, -2.70000, 69.90001);
	CreateDynamicObject(10984, -2047.81860, 480.89520, 33.58034,   0.00000, 0.00000, 28.98000);
	CreateDynamicObject(3867, -2050.04858, 461.14032, 48.68749,   -0.33840, 0.18000, -49.43998);
	CreateDynamicObject(3867, -2014.96521, 443.93784, 49.15625,   0.32159, 0.24000, 89.93999);
	CreateDynamicObject(18849, -2053.87622, 467.60641, 60.81741,   -11.09999, 3.41998, 0.00000);
	CreateDynamicObject(3867, -2050.04858, 461.14032, 76.25669,   -0.33840, 0.18000, -49.43998);
	CreateDynamicObject(3578, -2021.97766, 477.49448, 34.87545,   0.00000, 0.00000, -29.51998);
	CreateDynamicObject(874, -2026.14880, 468.61560, 34.43876,   0.00000, 0.00000, 80.63997);
	CreateDynamicObject(874, -2035.20874, 468.80463, 34.43876,   0.00000, 0.00000, 59.27996);
	CreateDynamicObject(874, -2043.55981, 471.98846, 34.43876,   0.00000, 0.00000, 42.11996);
	CreateDynamicObject(874, -2043.94592, 482.36102, 34.43876,   0.00000, 0.00000, 97.37996);
	CreateDynamicObject(874, -2055.87402, 482.53723, 34.43876,   0.00000, 0.00000, 132.59996);
	CreateDynamicObject(874, -2051.14063, 467.65158, 34.43876,   0.00000, 0.00000, 180.05997);
	CreateDynamicObject(874, -2041.23962, 458.16159, 34.43876,   0.00000, 0.00000, 203.93996);
	CreateDynamicObject(874, -2029.43665, 456.29953, 34.43876,   0.00000, 0.00000, 203.93996);
	CreateDynamicObject(874, -2021.80322, 456.26318, 34.43876,   0.00000, 0.00000, 170.87999);
	CreateDynamicObject(672, -2048.23804, 471.56369, 34.69419,   0.00000, 0.00000, 129.84003);
	CreateDynamicObject(874, -2032.73230, 478.22079, 34.43876,   0.00000, 0.00000, 61.31995);
	CreateDynamicObject(874, -2032.14148, 491.40805, 34.43876,   0.00000, 0.00000, 61.31995);
	CreateDynamicObject(874, -2022.76111, 482.63275, 34.21891,   0.00000, 0.00000, 37.19996);
	CreateDynamicObject(874, -2031.41541, 484.01587, 34.21891,   0.00000, 0.00000, 37.19996);
	CreateDynamicObject(874, -2024.45178, 489.38052, 34.21891,   0.00000, 0.00000, 89.51995);
	CreateDynamicObject(874, -2011.80103, 453.18469, 34.21891,   0.00000, 0.00000, 0.71996);
	CreateDynamicObject(874, -2011.02881, 460.83090, 34.21891,   0.00000, 0.00000, 49.13996);
	CreateDynamicObject(874, -2009.98474, 471.82593, 34.21891,   0.00000, 0.00000, 83.93996);
	CreateDynamicObject(874, -2014.09204, 479.82855, 34.21891,   0.00000, 0.00000, 83.93996);
	CreateDynamicObject(874, -2016.05896, 468.94461, 34.21891,   0.00000, 0.00000, 8.51997);
	CreateDynamicObject(874, -2013.22156, 493.77127, 34.21891,   0.00000, 0.00000, 8.51997);
	CreateDynamicObject(874, -2005.92773, 487.81326, 34.21891,   0.00000, 0.00000, 41.99997);
	CreateDynamicObject(672, -2022.48828, 470.19751, 34.69419,   0.00000, 0.00000, 129.84003);
	CreateDynamicObject(874, -2015.23242, 484.21896, 34.21891,   0.00000, 0.00000, 109.02000);
	CreateDynamicObject(874, -1994.54248, 486.82095, 34.21891,   0.00000, 0.00000, 41.99997);
	CreateDynamicObject(874, -2000.21045, 479.36630, 34.21891,   0.00000, 0.00000, 41.99997);
	CreateDynamicObject(874, -1995.31763, 494.38696, 34.21891,   0.00000, 0.00000, 55.97997);
	CreateDynamicObject(703, -2002.93555, 482.49231, 34.06375,   0.00000, 0.00000, 47.76001);
	CreateDynamicObject(3594, -1998.06018, 490.87308, 34.69928,   0.00000, 0.00000, 182.46002);
	CreateDynamicObject(3594, -2002.91638, 471.47974, 34.69928,   0.00000, 0.00000, 135.60005);
	CreateDynamicObject(3594, -2011.83582, 455.45172, 34.69928,   0.00000, 0.00000, 216.66003);
	CreateDynamicObject(3594, -1999.16406, 458.14029, 34.69928,   0.00000, 0.00000, 43.02003);
	CreateDynamicObject(3594, -2001.95129, 453.87964, 34.69928,   0.00000, 0.00000, 76.01998);
	CreateDynamicObject(874, -2010.52856, 521.18097, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -2002.61816, 521.34021, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1995.18970, 520.12128, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1989.33704, 512.78046, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1998.62622, 509.33844, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -2008.88525, 510.18338, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1992.05872, 502.63315, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -1999.77429, 498.48907, 34.43876,   0.00000, 0.00000, -26.94001);
	CreateDynamicObject(874, -2005.51025, 498.55450, 34.43876,   0.00000, 0.00000, -35.46001);
	CreateDynamicObject(3594, -1995.09912, 491.71637, 35.28719,   -12.36000, 5.28000, 243.35994);
	CreateDynamicObject(981, -2001.38843, 527.13251, 34.73787,   0.00000, 0.00000, 174.66005);
	CreateDynamicObject(11004, -2028.75769, -10.61207, 40.83038,   360.03827, 5.58000, -0.69841);
	CreateDynamicObject(10984, -2023.82593, -38.67281, 35.06058,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2019.88879, -28.82849, 35.04060,   0.00000, 0.00000, -0.30000);
	CreateDynamicObject(10984, -2018.19409, -38.68257, 35.06058,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2019.31299, -13.53848, 34.69256,   0.00000, 0.00000, 33.24001);
	CreateDynamicObject(10984, -2019.25342, 1.25166, 33.77964,   0.00000, 0.00000, 65.76000);
	CreateDynamicObject(10984, -2018.90234, 12.19788, 33.19967,   0.00000, 0.00000, 75.06001);
	CreateDynamicObject(10984, -2029.26709, 18.92292, 33.19967,   0.00000, 0.00000, 75.06001);
	CreateDynamicObject(10984, -2037.16406, 19.25907, 34.56672,   2.64000, -0.24000, 75.06001);
	CreateDynamicObject(10984, -2041.31702, 13.83805, 34.56672,   2.64000, -0.24000, 182.70000);
	CreateDynamicObject(10984, -2047.61658, 8.76505, 34.87643,   2.64000, -0.24000, 182.70000);
	CreateDynamicObject(10984, -2016.84131, -6.36569, 34.26186,   0.00000, 0.00000, 65.76000);
	CreateDynamicObject(10984, -2033.64868, -42.79264, 35.06058,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2039.84827, -36.01980, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(10984, -2041.02039, -24.96005, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(10984, -2042.07312, -15.96474, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(10984, -2042.52307, -6.22703, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(10982, -2054.74780, -52.67387, 37.80120,   353.37854, -1.56000, 0.80159);
	CreateDynamicObject(10984, -2033.67249, -52.67066, 35.06058,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2043.81714, -54.90476, 35.06058,   0.00000, 0.00000, -111.06000);
	CreateDynamicObject(10984, -2076.31030, -55.85150, 35.11819,   0.00000, 0.00000, -134.87999);
	CreateDynamicObject(10984, -2064.95044, -56.28944, 35.11819,   0.00000, 0.00000, -50.57999);
	CreateDynamicObject(10984, -2047.56250, -40.95163, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(10984, -2058.88525, -40.46265, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(10984, -2072.56421, -41.52249, 35.06058,   0.00000, 0.00000, 30.05999);
	CreateDynamicObject(11002, -2060.92554, -15.96697, 38.04276,   360.69830, 6.42000, 3.14159);
	CreateDynamicObject(10984, -2074.52246, 5.35425, 34.87643,   2.64000, -0.24000, 182.70000);
	CreateDynamicObject(10984, -2058.75464, 7.69608, 34.87643,   2.64000, -0.24000, 92.16003);
	CreateDynamicObject(11002, -2060.92554, -15.96697, 38.04276,   360.69830, 6.42000, 3.14159);
	CreateDynamicObject(10984, -2073.27100, -29.54082, 34.87643,   2.64000, -0.24000, 323.09995);
	CreateDynamicObject(10984, -2074.32202, -14.69209, 34.87643,   2.64000, -0.24000, 190.20000);
	CreateDynamicObject(874, -2026.25635, -52.46198, 34.53310,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -2018.86462, -47.18437, 34.53310,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -2017.67932, -57.67345, 34.53310,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(672, -2021.35083, -55.65747, 35.01731,   0.00000, 0.00000, 49.86000);
	CreateDynamicObject(874, -2026.87122, -63.46699, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2038.22986, -63.41549, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2048.80176, -62.68600, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2057.86987, -62.99043, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2052.60986, -70.12596, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2041.01880, -70.78807, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2029.01221, -70.68456, 34.53310,   0.00000, 0.00000, 54.12000);
	CreateDynamicObject(874, -2018.50220, -66.85600, 34.53310,   0.00000, 0.00000, 116.82000);
	CreateDynamicObject(874, -2012.11279, -55.01543, 34.53310,   0.00000, 0.00000, 177.96001);
	CreateDynamicObject(874, -2009.99792, -66.49872, 34.53310,   0.00000, 0.00000, 89.40002);
	CreateDynamicObject(874, -2005.58435, -56.94333, 34.53310,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2009.30884, -45.87549, 34.53310,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2002.21594, -49.26989, 34.53310,   0.00000, 0.00000, -5.45999);
	CreateDynamicObject(672, -2043.07458, -72.58889, 35.01731,   0.00000, 0.00000, -47.64000);
	CreateDynamicObject(874, -2007.60742, -38.64967, 34.53310,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2006.99255, -32.17464, 34.53310,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2007.01086, -24.91422, 34.53310,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2005.63123, -16.35362, 34.53310,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2005.58826, -8.27600, 34.13869,   0.00000, 0.00000, 24.42001);
	CreateDynamicObject(874, -2005.55981, 2.60661, 33.25884,   0.00000, 0.00000, 38.28001);
	CreateDynamicObject(9812, -2015.81995, -11.51127, 44.86961,   0.00000, 0.00000, 89.81997);
	CreateDynamicObject(9812, -2040.08923, -10.74500, 47.40739,   0.00000, 0.00000, 269.52005);
	CreateDynamicObject(874, -2011.98975, -74.49358, 34.53310,   0.00000, 0.00000, 70.74002);
	CreateDynamicObject(874, -2016.43213, -79.00322, 34.53310,   0.00000, 0.00000, 53.64001);
	CreateDynamicObject(874, -2022.64343, -79.50058, 34.53310,   0.00000, 0.00000, 44.10001);
	CreateDynamicObject(874, -1999.28455, -67.86679, 34.53310,   0.00000, 0.00000, -28.73999);
	CreateDynamicObject(11008, -2037.15186, 77.09155, 30.16196,   359.43814, -12.66000, 3.14159);
	CreateDynamicObject(10984, -2025.99463, 63.23867, 27.78181,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2027.09436, 72.86670, 27.78181,   0.00000, 0.00000, 18.66000);
	CreateDynamicObject(10984, -2027.79126, 84.48429, 27.78181,   0.00000, 0.00000, 18.66000);
	CreateDynamicObject(10984, -2029.56116, 95.02460, 27.78181,   0.00000, 0.00000, 58.14000);
	CreateDynamicObject(10984, -2040.82654, 95.91385, 27.78181,   0.00000, 0.00000, 107.34002);
	CreateDynamicObject(10984, -2047.87708, 91.11617, 27.78181,   0.00000, 0.00000, 107.34002);
	CreateDynamicObject(10984, -2047.52197, 83.06969, 27.78181,   0.00000, 0.00000, 47.88000);
	CreateDynamicObject(10984, -2048.98340, 72.38094, 27.78181,   0.00000, 0.00000, 69.36002);
	CreateDynamicObject(10984, -2046.00696, 63.68789, 27.78181,   0.00000, 0.00000, 115.92003);
	CreateDynamicObject(10984, -2037.24121, 59.82973, 28.08765,   0.00000, 0.00000, 168.36002);
	CreateDynamicObject(874, -2019.43640, 74.37825, 27.07328,   0.00000, 0.00000, -560.03992);
	CreateDynamicObject(874, -2020.39673, 66.41407, 28.44846,   0.00000, 0.00000, -597.65979);
	CreateDynamicObject(874, -2021.39331, 56.74368, 28.86667,   0.00000, 0.00000, -625.25983);
	CreateDynamicObject(874, -2018.79834, 84.98585, 28.03025,   0.00000, 0.00000, -551.75952);
	CreateDynamicObject(874, -2016.92163, 94.57372, 28.03025,   0.00000, 0.00000, -619.91949);
	CreateDynamicObject(874, -2018.50745, 104.62314, 28.03025,   0.00000, 0.00000, -685.25958);
	CreateDynamicObject(874, -2018.80945, 113.09712, 28.03025,   0.00000, 0.00000, -628.07959);
	CreateDynamicObject(672, -2018.03430, 69.69579, 28.61393,   356.85840, 0.09254, 0.94248);
	CreateDynamicObject(4563, -2073.94385, 213.95085, 96.40570,   -2.82000, 7.02001, -5.34000);
	CreateDynamicObject(10984, -2114.80908, 210.24928, 35.18161,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2115.13525, 194.30270, 34.75315,   0.00000, 0.00000, 9.36000);
	CreateDynamicObject(10984, -2108.91357, 181.70901, 35.06229,   0.00000, 0.00000, 60.47998);
	CreateDynamicObject(10984, -2096.52222, 177.05353, 34.96436,   0.00000, 0.00000, 90.29998);
	CreateDynamicObject(10984, -2087.27563, 176.17155, 35.00887,   0.00000, 0.00000, -98.28004);
	CreateDynamicObject(10984, -2068.82446, 175.33667, 31.62981,   -17.82001, -3.18001, 265.67993);
	CreateDynamicObject(10984, -2043.75232, 211.09348, 34.62209,   -2.16000, 7.68000, 0.00000);
	CreateDynamicObject(10984, -2042.73816, 220.53568, 35.56889,   -0.06000, 4.20000, 0.00000);
	CreateDynamicObject(10984, -2044.17114, 233.42459, 35.56889,   -0.06000, 4.20000, 37.80001);
	CreateDynamicObject(10984, -2016.52832, 214.68590, 27.23944,   0.00000, 0.00000, -186.47997);
	CreateDynamicObject(10984, -2028.39209, 210.60876, 32.10779,   5.63999, 17.04000, -340.31995);
	CreateDynamicObject(3578, -2017.24341, 189.26396, 27.36735,   0.00000, 0.00000, 90.24000);
	CreateDynamicObject(10984, -2104.43091, 237.55795, 35.12186,   356.85840, 0.00000, 14.84159);
	CreateDynamicObject(10984, -2095.26465, 242.97678, 35.12186,   356.85840, 0.00000, 43.88160);
	CreateDynamicObject(10984, -2082.87354, 242.08472, 35.72885,   356.85840, 0.00000, 43.88160);
	CreateDynamicObject(10984, -2070.16089, 240.96397, 35.72885,   356.85840, 0.00000, 43.88160);
	CreateDynamicObject(10984, -2055.12646, 237.83476, 35.72885,   356.85840, 0.00000, 43.88160);
	CreateDynamicObject(3867, -2077.22095, 248.78267, 46.56466,   20.78160, 6.96000, -6.76923);
	CreateDynamicObject(10984, -2025.30701, 235.93460, 31.45162,   4.79999, 15.06000, -359.45990);
	CreateDynamicObject(1383, -2083.67163, 274.03326, 66.58123,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1384, -2083.61963, 273.91791, 98.71073,   0.00000, 0.00000, -108.90003);
	CreateDynamicObject(1383, -2108.54565, 154.61845, 66.58123,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1384, -2108.45386, 154.61028, 98.71073,   0.00000, 0.00000, -70.98001);
	CreateDynamicObject(1383, -2024.99487, 274.04681, 63.77794,   0.00000, 0.00000, -85.50002);
	CreateDynamicObject(1384, -2025.05896, 274.23856, 95.99514,   0.00000, 0.00000, -194.52003);
	CreateDynamicObject(3594, -1987.60352, 271.96561, 34.62114,   0.00000, 0.00000, -79.80003);
	CreateDynamicObject(3594, -1987.42480, 265.43176, 34.62114,   0.00000, 0.00000, -92.04003);
	CreateDynamicObject(3594, -1988.65210, 258.24478, 34.62114,   0.00000, 0.00000, 67.31998);
	CreateDynamicObject(3594, -1980.93701, 263.88232, 34.62114,   0.00000, 0.00000, 142.97992);
	CreateDynamicObject(3594, -1986.80823, 269.04504, 35.65437,   0.00000, 0.00000, -172.31987);
	CreateDynamicObject(3594, -1946.01843, 260.32974, 34.92618,   0.00000, 0.00000, 245.15993);
	CreateDynamicObject(3594, -1945.14551, 265.20493, 34.92618,   0.00000, 0.00000, 277.31995);
	CreateDynamicObject(3594, -1945.24951, 269.91068, 34.92618,   0.00000, 0.00000, 261.77994);
	CreateDynamicObject(3594, -1946.16528, 273.43448, 40.53390,   0.00000, 0.00000, 319.55978);
	CreateDynamicObject(3594, -1947.27100, 257.53564, 40.53390,   0.00000, 0.00000, 234.77974);
	CreateDynamicObject(3594, -1961.55200, 246.12511, 35.68827,   -17.45999, -4.38000, 74.33999);
	CreateDynamicObject(10828, -2583.92773, 618.85297, 19.20292,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(10828, -2541.35767, 618.90356, 19.20292,   0.00000, 0.00000, 0.18000);
	CreateDynamicObject(2934, -2557.59692, 619.30640, 16.03231,   -90.42001, 24.23999, 24.06000);
	CreateDynamicObject(2934, -2567.84741, 619.35602, 16.03231,   -90.42001, 24.23999, 24.06000);
	CreateDynamicObject(2934, -2557.59692, 619.30640, 18.98847,   -90.42001, 24.23999, 24.06000);
	CreateDynamicObject(2934, -2567.84741, 619.35602, 20.18153,   -90.42001, 24.23999, 24.06000);
	CreateDynamicObject(16000, -2545.37402, 617.94244, 13.40585,   0.00000, 0.00000, 179.76006);
	CreateDynamicObject(16000, -2584.82129, 618.02673, 13.40585,   0.00000, 0.00000, 179.76006);
	CreateDynamicObject(16000, -2580.34766, 618.02686, 13.40585,   0.00000, 0.00000, 179.76006);
	CreateDynamicObject(3594, -2543.67749, 606.51721, 13.71038,   0.00000, 0.00000, -24.18000);
	CreateDynamicObject(3594, -2549.23560, 606.34296, 13.71038,   0.00000, 0.00000, 25.20000);
	CreateDynamicObject(3594, -2566.56152, 592.42761, 13.71038,   0.00000, 0.00000, -117.54001);
	CreateDynamicObject(3594, -2560.76880, 595.36670, 13.71038,   0.00000, 0.00000, -346.80014);
	CreateDynamicObject(3594, -2559.82300, 596.28253, 14.32208,   -26.28000, 3.12000, -422.82013);
	CreateDynamicObject(3594, -2580.02393, 599.43982, 13.71038,   0.00000, 0.00000, -224.69998);
	CreateDynamicObject(3594, -2579.75269, 590.93127, 13.71038,   0.00000, 0.00000, -107.69996);
	CreateDynamicObject(3594, -2574.61377, 595.40820, 13.71038,   0.00000, 0.00000, -189.17992);
	CreateDynamicObject(3594, -2571.64478, 604.74194, 13.71038,   0.00000, 0.00000, 23.10015);
	CreateDynamicObject(3578, -2576.83813, 581.86798, 14.13368,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, -2556.55322, 581.82178, 14.13368,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3265, -2572.09448, 581.85809, 14.77859,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3265, -2561.29126, 581.85773, 14.77859,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(874, -2564.44775, 594.51984, 13.43969,   0.00000, 0.00000, 7.50000);
	CreateDynamicObject(874, -2582.95288, 589.04150, 13.43969,   0.00000, 0.00000, -101.28001);
	CreateDynamicObject(874, -2569.26611, 599.86194, 13.43969,   0.00000, 0.00000, 20.27999);
	CreateDynamicObject(874, -2573.05688, 595.29883, 13.43969,   0.00000, 0.00000, 20.27999);
	CreateDynamicObject(874, -2559.42041, 600.65259, 13.43969,   0.00000, 0.00000, -33.24000);
	CreateDynamicObject(874, -2551.98096, 597.33649, 13.43969,   0.00000, 0.00000, -71.82001);
	CreateDynamicObject(874, -2547.71118, 606.61450, 13.43969,   0.00000, 0.00000, 24.35999);
	CreateDynamicObject(874, -2547.39136, 593.90521, 13.43969,   0.00000, 0.00000, 9.42000);
	CreateDynamicObject(874, -2556.04517, 608.32135, 13.43969,   0.00000, 0.00000, 9.42000);
	CreateDynamicObject(874, -2584.35107, 597.45374, 13.43969,   0.00000, 0.00000, -21.12000);
	CreateDynamicObject(10984, -2578.17163, 595.33844, 13.43178,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(10984, -2545.98315, 603.81671, 13.64528,   0.00000, 0.00000, -36.59999);
	CreateDynamicObject(981, -2593.86328, 596.65887, 14.12848,   0.00000, 0.00000, -85.80003);
	CreateDynamicObject(874, -2577.86938, 605.03699, 13.43969,   0.00000, 0.00000, -94.26000);
	CreateDynamicObject(874, -2586.02686, 605.96753, 13.43969,   0.00000, 0.00000, -149.10004);
	CreateDynamicObject(874, -2566.17896, 604.83289, 13.43969,   0.00000, 0.00000, -149.10004);
	CreateDynamicObject(3594, -2576.21631, 612.13574, 13.71038,   0.00000, 0.00000, 102.96014);
	CreateDynamicObject(3594, -2590.67114, 602.79224, 13.71038,   0.00000, 0.00000, 167.10017);
	CreateDynamicObject(672, -2556.16455, 602.88464, 14.00535,   0.00000, 0.00000, -41.22000);
	CreateDynamicObject(672, -2585.87744, 589.23413, 14.00535,   0.00000, 0.00000, -75.30000);
	CreateDynamicObject(874, -2565.41455, 586.73431, 13.43969,   0.00000, 0.00000, -121.98004);
	CreateDynamicObject(874, -2553.08521, 589.87323, 13.43969,   0.00000, 0.00000, -84.35999);
}

stock DeleteObjects(playerid)
{
	// SF Apocalypse
	RemoveBuildingForPlayer(playerid, 17835, 2431.0391, -1603.4922, 20.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 17657, 2431.0391, -1603.4922, 20.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 17898, 2431.0391, -1603.4922, 20.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 729, -1806.6797, 558.9141, 34.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 728, -1815.7500, 564.3281, 34.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 728, -1799.2109, 563.5625, 34.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 728, -1806.5703, 549.9141, 34.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 728, -1812.7344, 556.2422, 34.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 728, -1799.6484, 556.3516, 34.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 728, -1807.6719, 565.8438, 34.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 10945, -1910.2734, 487.1406, 121.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 11016, -1910.2734, 487.1406, 121.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 11039, -2055.3594, -54.0078, 40.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 11040, -2029.0625, -10.1094, 43.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 11164, -2061.5547, -16.2422, 40.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 11245, -2023.7109, 83.9688, 37.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 11255, -1558.5469, 546.3203, 14.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 11261, -1563.1797, 541.9297, 26.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 11262, -1558.5469, 546.3203, 14.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 11272, -2037.5391, 79.9297, 34.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 11410, -1910.2734, 487.1406, 121.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2051.3828, 492.5078, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2051.6797, 483.4375, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2051.8438, 473.8984, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2018.5547, 460.2031, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2027.0234, 460.3438, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2036.4844, 460.5078, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 792, -2012.7109, 478.8203, 34.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 11002, -2061.5547, -16.2422, 40.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3872, -2107.0313, 226.0391, 40.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 10982, -2055.3594, -54.0078, 40.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 11004, -2029.0625, -10.1094, 43.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1505, -2028.5859, -40.1953, 37.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 11008, -2037.5391, 79.9297, 34.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 9907, -1758.9609, 789.8047, 113.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 9934, -1753.9219, 789.7422, 111.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 9935, -1758.9609, 789.8047, 113.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 10237, -1754.2188, 980.0391, 58.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 3876, -1740.2891, 774.3203, 166.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3876, -1744.3750, 972.8906, 94.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, -1807.8359, 745.7578, 41.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, -1807.8359, 793.0234, 35.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 1690, -1771.1641, 769.8906, 167.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 3877, -1772.2891, 766.4531, 168.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 1695, -1771.4141, 778.9453, 167.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1688, -1771.6094, 783.4922, 167.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1690, -1771.1641, 788.9922, 167.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1693, -1768.5156, 795.2344, 153.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1688, -1771.6094, 794.2656, 167.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1695, -1771.4141, 800.6250, 167.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1696, -1761.1250, 805.9766, 167.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1696, -1768.6016, 805.9766, 167.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3877, -1772.2891, 813.1016, 168.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 717, -1727.4375, 758.3359, 24.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 717, -1727.4375, 767.4609, 24.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1687, -1756.8594, 767.6719, 167.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1694, -1747.4453, 772.5391, 175.2891, 0.25);
	RemoveBuildingForPlayer(playerid, 3877, -1735.2422, 776.4922, 168.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 717, -1727.4375, 778.1250, 24.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1695, -1737.5313, 778.9453, 167.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 717, -1727.4375, 788.7891, 24.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1687, -1739.9063, 795.7500, 167.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 717, -1727.4375, 799.4531, 24.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1692, -1753.2188, 799.6484, 153.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 1695, -1737.5313, 800.6250, 167.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 3877, -1735.2422, 803.1406, 168.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 1696, -1746.1797, 805.9766, 167.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1696, -1753.6563, 805.9766, 167.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, -1807.8359, 827.5469, 31.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 10236, -1784.4609, 965.9063, 40.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3877, -1768.2266, 964.5703, 96.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 3877, -1740.1875, 964.5703, 96.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 10193, -1754.2188, 980.0391, 58.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 9682, -2554.7031, 616.3203, 13.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 4523, -1592.7813, 622.7813, 42.9688, 0.25);

	// - Petrol damÄ±tma alanÄ± objeleri
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