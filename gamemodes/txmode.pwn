//============================================================================//
//                           Trinity-Xtreme                                   //
//                                 Freeroam Sunucusu                          //
//                                                                            //
//                       Trinity-Xtreme version RC1.3 gamemode by MR.ImmortaL //
//============================================================================//
// Trinity-Xtreme Credits:                                                    //
//     Developer Team: ImmortaL [PAWN+MAP+WEB+ART] | Crosscuk [MAP+ART]       //
//============================================================================//

// (( #Kütüphaneler ))========================================================//
#include <a_samp>         //SA-MP 0.3x orjinal kütüphanesi.
#include <dini>           //Dini dosya kayýt kütüphanesi.
#include <progress>       //Progressbar kütüphanesi.
#include <IsPlayerLAdmin> //LAdmin kütüphanesi.

// (( #Pragmalar ))===========================================================//
#pragma unused ret_memcpy

// (( #Defineler ))===========================================================//

// - Sunucu yazýlarý defineleri
#define SendError(%0,%1) SendClientMessage(%0,0xF63845AA,"» Hata: {FFFFFF}" %1)
#define SendInfo(%0,%1) SendClientMessage(%0,0x00A2F6AA,"» Bilgi: {FFFFFF}" %1)

// - Ev sistemi defineleri
#define DIALOG 8000 // Baþlangýç dialog id
#define MAX_HOUSE 100 // Toplam yaratýlan ev sayýsý.
#define BASLIK "{FFFFFF}Trinity-Xtreme / {009BFF}Ev Sistemi" // Dialog,mesaj baþlýklarý

#define ACIKLAMA "Satýlýk Ev! (/satinal & /ev)" // Default yeni yaratýlan evin açýklamasý
#define FIYAT 20000 // Default yeni yaratýlan evin fiyatý
#define KILIT 1 // Default yeni yaratýlan evin kilidi ( 0: Açýk - 1: Kilitli )
#define KASA 0 // Default yeni yaratýlan evin kasasýndaki para

#define MENU DIALOG+15 // Deðiþtirmeye gerek yok
#define SATINAL MENU+15 // Deðiþtirmeye gerek yok

#define BLUEH 1272 // Ellemeyin.
#define GREENH 1273 // Ellemeyin.
#define REDMAP 32 // Ellemeyin.
#define GREENMAP 31 // Ellemeyin.
#define ARROW 1318 // Ellemeyin.

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

// (( #Tanýtýmlar ))==========================================================//

// - Textdraw tanýtýmlarý
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

// Exp sistemi tanýtýmlarý
new Text:expbox;
new Text:expmeter;
new Bar:expbar;

// - Saat sistemi tanýtýmlarý
new Hour,
    Minute,
    Timer,
    Text:TimeText;

// - Araç yönetim tanýtýmlarý
new motor,isiklar,alarm,kapilar,kaput,bagaj,objective;
new Kilit[MAX_PLAYERS] = 0;
new Arac[MAX_PLAYERS];

// - DM sistemi tanýtýmlarý
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

// - Yardým menüsü tanýtýmlarý
new dIp[][] =
{
	"{ACDA00}/firstperson\t\t{FFFFFF}FPS moduna giriþ yaparsýnýz.",
	"{ACDA00}/exitfirstperson\t{FFFFFF}FPS modundan çýkarsýnýz.",
	"{ACDA00}/myversion\t\t{FFFFFF}SA-MP versiyonunuzu gösterir.",
	"{ACDA00}/kurallar\t\t{FFFFFF}Sunucu kural menüsünü açar.",
	"{ACDA00}/surus\t\t\t{FFFFFF}Araç içi FPS modunu açar/kapatýr.",
	"{ACDA00}/teles\t\t\t{FFFFFF}Teleport menüsünü açar.",
	"{ACDA00}/m1-/m12\t\t{FFFFFF}Modifiyeli araba spawn eder.",
	"{ACDA00}/v1-/v18\t\t{FFFFFF}Normal araba spawn eder.",
	"{ACDA00}/changelog\t\t{FFFFFF}Güncelleme listesini gösterir.",
	"{ACDA00}/cevir\t\t\t{FFFFFF}Ters çevrilen arabayý düzeltir.",
	"{ACDA00}/31\t\t\t{FFFFFF}31 çekme sistemini açar/kapatýr.",
	"{ACDA00}/dmler\t\t\t{FFFFFF}Deathmatch alaný listesini gösterir.",
	"{ACDA00}/stuntlar\t\t{FFFFFF}Stunt alanlarýný gösterir.",
	"{ACDA00}/can\t\t\t{FFFFFF}Can paketi satýn alýrsýnýz.",
	"{ACDA00}/yelek\t\t\t{FFFFFF}Zýrh paketi satýn alýrsýnýz.",
    "{ACDA00}/ev\t\t\t{FFFFFF}Ev düzenleme menüsünü açar.",
	"{ACDA00}/yardim\t\t{FFFFFF}Oyun modu hakkýnda yardým verir.",
	"\n\nBu mod {009BFF}MR.ImmortaL {FFFFFF}tarafýndan kodlanmýþtýr."
};

// - 31 sistemi tanýtýmlarý
new asilantimer;
new cekiyor[MAX_PLAYERS] = 0;

// - FPS sistemi tanýtýmlarý
new Surus[MAX_PLAYERS];
new firstperson[MAX_PLAYERS];

// - Araç spawn sistemi tanýtýmlarý
#define DIALOG_OFFSET_ID (1024)

new
        g_VehNames[][] =
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
        }
;

// - Modifiyeli araç spawn sistemi tanýtýmlarý
enum Player
{
pMAraba,
pMArabaID
};
new PlayerInfo[MAX_PLAYERS][Player];

// - Hýzlandýrýcý pickup tanýtýmlarý
new hizlandirici[14];
#define HIZ_VER 5

// - Ev sistemi tanýtýmlarý
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
	Text3D:TextLabel[MAX_HOUSE],
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
forward EvKaydetInt(evid,bilgii[],deger);
forward EvKaydetStr(evid,bilgii[],deger[]);
forward EvKaydetFloat(evid,bilgii[],Float:deger);
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
    new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);
	printf("Yüklendi: \"Sunucu modu.\"");
	printf("");
	printf("\"--------------------------------------------------\"");
	printf("\"             #Trinity-Xtreme Freeroam             \"");
	printf("\"         #SA-MP Oyun Modu [vBeta][RC-1.3]         \"");
	printf("\"          #Created by baZingo & ImmortaL          \"");
	printf("\"            #since 27/01/2013 - 01:52             \"");
	printf("\"                                                  \"");
	printf("\"                 [Developer Mode]                 \"");
	printf("\"                                                  \"");
	printf("\"         Saat: %d:%d:%d ~ Tarih: %d/%d/%d         \"",hour,minute,second,day,month,year);
	printf("\"--------------------------------------------------\"");
}

public OnGameModeInit()
{
	SetGameModeText("GameMode[vBeta 1.3]");
	
	UsePlayerPedAnims();
	AllowInteriorWeapons(1);
	SetWeather(18);
	EnableStuntBonusForAll(0);
	for(new i=0;i<299;i++)
    {
    AddPlayerClass(i,1958.2111,1343.5758,15.3746,274.2440,24,100,27,80,32,500);
    }
    
    printf("Yüklendi: \"Sunucu genel ayarlarý.\"");
    
    // - Textdrawlar
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
    
    printf("Yüklendi: \"Sunucu textdrawlarý.\"");
    // - Exp sistemi ayarlarý
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

    expmeter = TextDrawCreate(177.000000, 398.000000, "EXP:50% - Level:31'ci");
    TextDrawBackgroundColor(expmeter, 255);
    TextDrawFont(expmeter, 1);
    TextDrawLetterSize(expmeter, 0.320000, 0.899999);
    TextDrawColor(expmeter, -1);
    TextDrawSetOutline(expmeter, 0);
    TextDrawSetProportional(expmeter, 1);
    TextDrawSetShadow(expmeter, 1);
    
    expbar = CreateProgressBar(181.00, 412.00, 273.50, 8.19, 10223615, 100.0);
    
    printf("Yüklendi: \"Exp-Level sistemi.\"");
    // - Saat sistemi ayarlarý
    
   	Hour = 12;
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

    printf("Yüklendi: \"Saat sistemi.\"");
    // - Sunucu Harita Objeleri
    
    // Genel Objeler
    CreateObject(18761,2046.10,869.12,9.94,0.00,0.00,0.00);
    CreateObject(18768,2003.50,1007.70,37.50,0.00,0.00,0.00);
    CreateObject(18720,2620.90,1827.60,17.82,0.00,0.00,0.00);
    CreateObject(18769,2003.52,1007.75,37.49,0.00,0.00,0.00);
    CreateObject(18720,2620.87,1821.17,17.72,0.00,0.00,0.00);
    
	//4 Mayýs 2013 - Crosscuk Petrol Damýtma Sahasý Edit
	CreateObject(18763,410.99,1432.73,6.45,0.00,0.00,135.00);
	CreateObject(18763,407.29,1428.01,6.57,0.00,0.00,0.00);
	CreateObject(18741,286.16,1373.64,7.98,0.00,0.00,0.00);
	CreateObject(18741,286.18,1373.64,7.98,0.00,0.00,0.00);
	CreateObject(7662,147.96,1363.10,10.28,0.00,0.00,0.00);
	CreateObject(7611,218.79,1357.26,11.98,0.00,0.00,180.00);
	CreateObject(6522,236.90,1451.05,17.88,0.00,0.00,270.00);
	CreateObject(7597,236.38,1420.27,22.75,0.00,0.00,0.00);
	CreateObject(19486,250.19,1347.60,12.18,0.00,0.00,0.00);
	CreateObject(1419,286.69,1358.56,10.28,0.00,0.00,180.00);
	CreateObject(1419,282.63,1358.48,10.28,0.00,0.00,180.00);
	CreateObject(1419,278.58,1358.53,10.28,0.00,0.00,180.00);
	CreateObject(1419,274.58,1358.56,10.28,0.00,0.00,180.00);
	CreateObject(1419,270.52,1358.49,10.28,0.00,0.00,180.00);
	CreateObject(1419,266.43,1358.45,10.28,0.00,0.00,180.00);
	CreateObject(1419,262.36,1358.49,10.28,0.00,0.00,180.00);
	CreateObject(1419,258.26,1358.50,10.27,0.00,0.00,180.00);
	CreateObject(1419,254.15,1358.55,10.28,0.00,0.00,180.00);
	CreateObject(1419,250.07,1358.50,10.27,0.00,0.00,180.00);
	CreateObject(1419,244.46,1358.46,10.28,0.00,0.00,360.00);
	CreateObject(1419,246.15,1358.50,10.28,0.00,0.00,540.00);
	CreateObject(1419,232.98,1358.53,10.28,0.00,0.00,180.00);
	CreateObject(1419,228.90,1358.49,10.28,0.00,0.00,180.00);
	CreateObject(1419,224.78,1358.51,10.28,0.00,0.00,180.00);
	CreateObject(1419,220.67,1358.47,10.28,0.00,0.00,180.00);
	CreateObject(1419,216.56,1358.48,10.28,0.00,0.00,180.00);
	CreateObject(1419,212.49,1358.44,10.28,0.00,0.00,180.00);
	CreateObject(1419,208.41,1358.45,10.28,0.00,0.00,180.00);
	CreateObject(1419,204.34,1358.47,10.28,0.00,0.00,180.00);
	CreateObject(1419,200.27,1358.50,10.28,0.00,0.00,180.00);
	CreateObject(1419,196.21,1358.47,10.28,0.00,0.00,180.00);
	CreateObject(1419,192.18,1358.44,10.28,0.00,0.00,180.00);
	CreateObject(1419,188.05,1358.45,10.28,0.00,0.00,180.00);
	CreateObject(1419,183.97,1358.51,10.28,0.00,0.00,180.00);
	CreateObject(1419,179.94,1358.55,10.28,0.00,0.00,180.00);
	CreateObject(1419,175.85,1358.49,10.28,0.00,0.00,180.00);
	CreateObject(1419,171.79,1358.51,10.28,0.00,0.00,180.00);
	CreateObject(1419,167.71,1358.54,10.28,0.00,0.00,180.00);
	CreateObject(1419,163.60,1358.47,10.28,0.00,0.00,180.00);
	CreateObject(1419,159.49,1358.43,10.28,0.00,0.00,180.00);
	CreateObject(1419,151.35,1358.50,10.28,0.00,0.00,540.00);
	CreateObject(1419,155.41,1358.51,10.28,0.00,0.00,180.00);
	CreateObject(1419,149.28,1358.50,10.28,0.00,0.00,180.00);
	CreateObject(19499,134.35,1379.38,13.08,0.00,0.00,450.00);
	CreateObject(7662,147.98,1406.06,10.28,0.00,0.00,0.00);
	CreateObject(11490,138.82,1422.60,9.49,0.00,0.00,270.00);
	CreateObject(11491,127.75,1422.59,10.99,0.00,0.00,270.00);
	CreateObject(1492,137.51,1375.16,9.65,0.00,0.00,990.00);


    // RequestClass Alaný
    CreateObject(18783,2625.20,1824.18,7.62,0.00,0.00,0.00);
    CreateObject(18783,2634.38,1824.18,10.12,810.00,270.00,360.00);
    
    // Deagle DM
    CreateObject(19456,2428.54,1806.78,16.32,0.00,0.00,0.00);
    CreateObject(19456,2423.61,1811.56,16.32,0.00,0.00,90.00);
    CreateObject(19456,2432.81,1792.28,16.32,0.00,0.00,0.00);
    CreateObject(19456,2433.33,1801.98,16.32,0.00,0.00,90.00);
    CreateObject(19456,2437.56,1806.99,16.32,0.00,0.00,90.00);
    CreateObject(19456,2442.38,1807.15,16.32,0.00,0.00,0.00);
    CreateObject(19456,2447.07,1802.34,16.32,0.00,0.00,90.00);
    CreateObject(19456,2437.50,1797.09,16.32,0.00,0.00,270.00);
    CreateObject(19456,2427.99,1797.06,16.32,0.00,0.00,90.00);
    CreateObject(19456,2423.28,1801.97,16.32,0.00,0.00,0.00);
    CreateObject(19456,2418.85,1806.87,16.32,0.00,0.00,0.00);
    CreateObject(19456,2425.07,1793.39,16.32,0.00,0.00,90.00);
    CreateObject(19456,2420.34,1788.58,16.32,0.00,0.00,0.00);
    CreateObject(19456,2417.91,1793.35,16.32,0.00,0.00,90.00);
    CreateObject(19456,2421.23,1829.95,16.32,0.00,0.00,0.00);
    CreateObject(19456,2425.81,1818.59,16.32,0.00,0.00,90.00);
    CreateObject(19456,2416.07,1811.48,16.32,0.00,0.00,90.00);
    CreateObject(19456,2414.02,1798.44,16.32,0.00,0.00,0.00);
    CreateObject(19456,2409.31,1803.31,16.32,0.00,0.00,90.00);
    CreateObject(19456,2413.99,1797.41,16.32,0.00,0.00,0.00);
    CreateObject(19456,2409.51,1818.50,16.32,0.00,0.00,90.00);
    CreateObject(19456,2416.53,1825.18,16.32,0.00,0.00,90.00);
    CreateObject(19456,2412.11,1825.18,16.32,0.00,0.00,90.00);
    CreateObject(18666,2425.52,1818.72,16.72,0.00,0.00,270.00);
    CreateObject(18667,2417.45,1811.64,16.72,0.00,0.00,270.00);
    CreateObject(18648,2424.95,1825.24,13.32,0.00,0.00,0.00);
    CreateObject(18649,2440.09,1794.81,14.42,0.00,0.00,0.00);
    CreateObject(18661,2428.66,1809.11,16.82,0.00,0.00,180.00);
    CreateObject(1226,2428.16,1815.07,17.32,0.00,0.00,0.00);
    CreateObject(1225,2423.87,1797.63,15.72,0.00,0.00,0.00);
    CreateObject(1227,2427.15,1810.65,16.12,0.00,0.00,0.00);
    CreateObject(1230,2425.61,1811.07,15.72,0.00,0.00,0.00);
    CreateObject(1225,2427.78,1812.30,15.72,0.00,0.00,0.00);
    CreateObject(1685,2408.06,1819.52,15.82,0.00,0.00,0.00);
    CreateObject(3111,2423.38,1803.06,16.72,90.00,450.00,360.00);
    
    // Fist DM
    CreateObject(18759,2170.38,2539.66,584.77,0.00,0.00,0.00);

	// Bikepark Stunt - 1
	CreateObject(18800,1128.10,1265.82,20.82,0.00,0.00,180.00);
	CreateObject(18800,1181.26,1266.05,44.37,0.00,0.00,0.00);
	CreateObject(18786,1141.64,1243.53,59.24,0.00,0.00,0.00);
	CreateObject(18780,1165.49,1236.86,21.42,0.00,0.00,270.00);
	CreateObject(18772,1164.82,1067.94,68.35,0.00,0.00,0.00);
	CreateObject(18772,1164.82,817.94,68.34,0.00,0.00,0.00);
	CreateObject(18781,1165.13,672.58,76.65,0.00,0.00,180.00);
	CreateObject(18779,1118.13,1338.01,19.72,0.00,0.00,0.00);
    CreateObject(18790,1052.97,1343.98,57.75,0.00,60.00,0.00);
    
    // Ebenin amý
    CreateObject(19494,2105.84,1292.90,798.96,0.00,0.00,0.00);
    CreateObject(19325,2111.45,1293.34,798.31,0.00,0.00,0.00);
    CreateObject(19325,2103.86,1296.18,797.21,0.00,0.00,0.00);
    
    // OrmanEvi
    AddStaticVehicleEx(453,-1472.5999800,-2122.8999000,0.0000000,310.0000000,29,59,15); //Reefer
   	AddStaticVehicleEx(542,-1636.0000000,-2251.3000500,31.3000000,92.0000000,95,39,15); //Clover
   	CreateObject(1232,-1645.1999500,-2260.1001000,34.1000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (1)
   	CreateObject(1232,-1645.5000000,-2226.1999500,32.2000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (2)
   	CreateObject(1232,-1641.5000000,-2201.1999500,34.3000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (3)
   	CreateObject(1232,-1621.0000000,-2190.6999500,28.8000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (4)
   	CreateObject(1232,-1601.9000200,-2185.1999500,23.8000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (5)
   	CreateObject(1232,-1575.5999800,-2179.3000500,16.7000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (6)
   	CreateObject(1232,-1551.5999800,-2175.5000000,10.7000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (7)
   	CreateObject(1232,-1527.8000500,-2169.6001000,5.0000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (8)
   	CreateObject(1232,-1511.6999500,-2164.3000500,2.9000000,0.0000000,0.0000000,0.0000000); //object(streetlamp1) (9)
   	CreateObject(1799,-1629.8000500,-2244.3000500,30.6000000,0.0000000,0.0000000,184.0000000); //object(med_bed_4) (1)
   	CreateObject(13758,-1609.1999500,-2247.3000500,45.1000000,0.0000000,0.0000000,0.0000000); //object(radarmast1_lawn01) (1)
   	CreateObject(2296,-1634.5000000,-2232.3999000,30.5000000,0.0000000,0.0000000,0.0000000); //object(tv_unit_1) (1)
   	CreateObject(1432,-1635.5999800,-2242.5000000,30.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_table_2) (1)
   	CreateObject(1768,-1632.1999500,-2235.5000000,30.5000000,0.0000000,0.0000000,182.0000000); //object(low_couch_3) (1)
   	CreateObject(15036,-1635.4000200,-2246.6001000,31.6000000,0.0000000,0.0000000,2.0000000); //object(kit_cab_washin_sv) (1)
   	CreateObject(2261,-1637.4000200,-2232.8000500,31.9000000,0.0000000,0.0000000,0.0000000); //object(frame_slim_2) (1)
   	CreateObject(2282,-1628.9000200,-2242.6999500,32.1000000,0.0000000,0.0000000,270.0000000); //object(frame_thick_4) (1)
   	CreateObject(2108,-1630.1999500,-2232.5000000,30.5000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (1)
   	CreateObject(2080,-1634.0000000,-2234.1001000,30.5000000,0.0000000,0.0000000,0.0000000); //object(swank_dinning_2) (1)
   	CreateObject(2108,-1636.5000000,-2232.8999000,30.5000000,0.0000000,0.0000000,0.0000000); //object(cj_mlight13) (2)
   	CreateObject(1502,-1638.0999800,-2238.5000000,30.5000000,0.0000000,0.0000000,271.0000000); //object(gen_doorint04) (1)
   	CreateObject(11631,-1629.1999500,-2238.6001000,31.7000000,0.0000000,0.0000000,271.0000000); //object(ranch_desk) (1)
   	CreateObject(1811,-1630.1999500,-2238.8000500,31.1000000,0.0000000,0.0000000,210.0000000); //object(med_din_chair_5) (1)
   	CreateObject(1738,-1631.9000200,-2247.8000500,31.1000000,0.0000000,0.0000000,0.0000000); //object(cj_radiator_old) (1)
   	CreateObject(1551,-1633.3000500,-2234.3000500,31.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_big) (1)
   	CreateObject(1551,-1633.5999800,-2234.1999500,31.5000000,0.0000000,0.0000000,0.0000000); //object(dyn_wine_big) (2)
   	CreateObject(1736,-1637.5000000,-2241.6001000,32.6000000,0.0000000,0.0000000,92.5000000); //object(cj_stags_head) (1)
   	CreateObject(2099,-1628.4000200,-2242.5000000,30.5000000,0.0000000,0.0000000,272.0000000); //object(med_hi_fi_1) (1)
   	CreateObject(2819,-1629.5000000,-2245.1999500,30.5000000,0.0000000,0.0000000,0.0000000); //object(gb_bedclothes01) (1)
    
    // Köy Çete Mekaný - 11/04/2013
    AddStaticVehicleEx(518,1566.0999800,30.9000000,24.0000000,95.0000000,-1,-1,15); //Buccaneer
    AddStaticVehicleEx(463,1562.8000500,25.3000000,23.8000000,0.0000000,159,157,15); //Freeway
    AddStaticVehicleEx(463,1563.0000000,22.4000000,23.8000000,0.0000000,159,157,15); //Freeway
    AddStaticVehicleEx(463,1563.0000000,19.4000000,23.8000000,0.0000000,37,37,15); //Freeway
    AddStaticVehicleEx(463,1562.0000000,23.9000000,23.8000000,0.0000000,22,34,15); //Freeway
    AddStaticVehicleEx(463,1562.0000000,20.5000000,23.8000000,0.0000000,22,34,15); //Freeway
    CreateObject(1649,1549.5999800,19.7000000,24.8000000,0.0000000,90.0000000,100.0000000); //object(wglasssmash) (1)
    CreateObject(1649,1550.4000200,15.0000000,24.8000000,0.0000000,90.0000000,100.0000000); //object(wglasssmash) (2)
    CreateObject(1494,1549.9000200,18.1000000,23.1000000,0.0000000,0.0000000,280.0000000); //object(gen_doorint03) (1)
    CreateObject(1649,1550.4000200,15.0000000,24.8000000,0.0000000,90.0000000,279.9970000); //object(wglasssmash) (3)
    CreateObject(1649,1549.5999800,19.7000000,24.8000000,0.0000000,90.0000000,279.9920000); //object(wglasssmash) (5)
    CreateObject(1649,1550.0000000,17.5000000,27.8100000,0.0000000,90.0000000,99.9970000); //object(wglasssmash) (6)
    CreateObject(1649,1550.0000000,17.5000000,27.8100000,0.0000000,90.0000000,279.9980000); //object(wglasssmash) (7)
    CreateObject(1494,1537.8000500,18.1000000,23.1000000,0.0000000,0.0000000,279.9980000); //object(gen_doorint03) (2)
    CreateObject(1494,1545.4000200,22.4000000,23.1000000,0.0000000,0.0000000,189.9980000); //object(gen_doorint03) (3)
    CreateObject(1494,1543.1999500,10.8000000,23.1000000,0.0000000,0.0000000,189.9980000); //object(gen_doorint03) (4)
    CreateObject(2315,1545.5999800,12.1000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(cj_tv_table4) (1)
    CreateObject(2595,1546.0000000,12.2000000,24.0000000,0.0000000,0.0000000,130.0000000); //object(cj_shop_tv_video) (1)
    CreateObject(2827,1546.9000200,12.3000000,23.6000000,0.0000000,0.0000000,0.0000000); //object(gb_novels05) (1)
    CreateObject(1768,1544.5000000,14.0000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(low_couch_3) (1)
    CreateObject(1594,1551.3000500,21.9000000,23.6000000,0.0000000,0.0000000,322.0000000); //object(chairsntable) (1)
    CreateObject(1801,1538.6999500,17.3000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(swank_bed_4) (1)
    CreateObject(1801,1541.0999800,17.8000000,23.1000000,0.0000000,0.0000000,10.0000000); //object(swank_bed_4) (2)
    CreateObject(2101,1544.6999500,12.0000000,23.1000000,0.0000000,0.0000000,180.0000000); //object(med_hi_fi_3) (1)
    CreateObject(2101,1544.0000000,12.0000000,23.1000000,0.0000000,0.0000000,129.9950000); //object(med_hi_fi_3) (2)
    CreateObject(1829,1539.5999800,13.2000000,23.6000000,0.0000000,0.0000000,100.0000000); //object(man_safenew) (1)
    CreateObject(876,1519.9000200,46.9000000,26.4000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (2)
    CreateObject(876,1529.1999500,64.2000000,27.9000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (4)
    CreateObject(876,1521.5999800,82.4000000,29.7000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (6)
    CreateObject(876,1555.9000200,77.0000000,28.5000000,0.0000000,0.0000000,0.0000000); //object(veg_pflowers03) (8)
    CreateObject(1362,1566.4000200,17.5000000,23.8000000,0.0000000,0.0000000,0.0000000); //object(cj_firebin) (1)
    CreateObject(3461,1566.4000200,17.5000000,22.6000000,0.0000000,0.0000000,0.0000000); //object(tikitorch01_lvs) (1)

   	// - LVDM arabalarý
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
	
    printf("Yüklendi: \"Sunucu haritasý.\"");
	printf("Yüklendi: \"Sunucu araçlarý.\"");
	// - Hýzlandýrma pickuplarý
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
	
	printf("Yüklendi: \"Hýz pickuplarý.\"");
	// - Ev sistemi ayarlarý
	SetTimer("SahipKontrol",3000,1);

	AddStaticPickup(ARROW,1,235.1575,1187.2721,1080.2578,-1);
	AddStaticPickup(ARROW,1,225.756989,1240.000000,1082.149902,-1);
	AddStaticPickup(ARROW,1,222.9848,1287.5624,1082.1406,-1);
	AddStaticPickup(ARROW,1,225.630997,1022.479980,1084.069946,-1);
	AddStaticPickup(ARROW,1,295.2057,1472.9973,1080.2578,-1);
	AddStaticPickup(ARROW,1,327.9004,1478.2839,1084.4375,-1);
	AddStaticPickup(ARROW,1,2255.0129,-1139.9670,1050.6328,-1);
	AddStaticPickup(ARROW,1,2269.3037,-1210.4395,1047.5625,-1);
	AddStaticPickup(ARROW,1,2496.0330,-1692.9246,1014.7422,-1);
	AddStaticPickup(ARROW,1,1299.14,-794.77,1084.00,-1);
	AddStaticPickup(ARROW,1,2259.8408,-1135.7609,1050.6328,-1);
	AddStaticPickup(ARROW,1,2365.2190,-1135.1531,1050.8750,-1);
	AddStaticPickup(ARROW,1,385.803986,1471.769897,1080.209961,-1);
	AddStaticPickup(ARROW,1,2324.3735,-1148.8219,1050.7101,-1);
	
	printf("Yüklendi: \"Ev sistemi.\"");
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
	TextDrawDestroy(expbox);
	TextDrawDestroy(expmeter);
    KillTimer(Timer);
    
    new year,month,day;	getdate(year, month, day);
	new hour,minute,second; gettime(hour,minute,second);
    printf("Sunucu modu kapandý.");
    printf("Saat: %d:%d:%d ~ Tarih: %d/%d/%d",hour,minute,second,day,month,year);
    printf("Trinity-Xtreme / since 27/01/2013 - 01:52");
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerFacingAngle(playerid, 90.0);
    PlayerPlaySound(playerid,1185, 0, 0, 0);
	SetPlayerPos(playerid, 2621.1831,1824.3500,11.0234);
	SetPlayerCameraPos(playerid, 2616.2153,1824.3500,12.8204);
	SetPlayerCameraLookAt(playerid, 2621.1831,1824.3500,12.0234);
	return 1;
}

public OnPlayerConnect(playerid)
{
    GameTextForPlayer(playerid,"~b~~h~Trinity-~w~Xtreme~n~~r~~h~F~g~~h~r~b~~h~e~y~e~r~r~w~o~p~a~g~m",5000,1);
    // - Ev sistemi ayarý
    OyuncuMapIconKontrol(playerid);
    // - Araç kilit ayarý
   	Kilit[playerid] = 0;
   	
   	// - Petrol damýtma alaný objeleri
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
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	// - Araç spawn ayarlarý
    new iVehID = GetPVarInt(playerid, "iVehID");
    if(iVehID)
    DestroyVehicle(iVehID);
                
	// - Ev sistemi ayarlarý
    OyuncuEv[playerid] = -1;
	EvEditleniyor[GetHouseID(playerid)] = false;
	OyuncuKontrolEv[playerid]=-255;
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerInterior(playerid,0);
    SetPlayerVirtualWorld(playerid,0);
	SetPlayerRandomSpawn(playerid);
    PlayerPlaySound(playerid,1186, 0, 0, 0);
    
    TextDrawShowForPlayer(playerid,Textdraw0);
    TextDrawShowForPlayer(playerid,Textdraw1);
    TextDrawShowForPlayer(playerid,Textdraw2);
    TextDrawShowForPlayer(playerid,Textdraw3);
    TextDrawShowForPlayer(playerid,Textdraw4);
    TextDrawShowForPlayer(playerid,Textdraw5);
    TextDrawShowForPlayer(playerid,Textdraw6);
    TextDrawShowForPlayer(playerid,Textdraw7);
    TextDrawShowForPlayer(playerid,Textdraw8);
    TextDrawShowForPlayer(playerid,Textdraw9);
    TextDrawShowForPlayer(playerid,TimeText);
    // Exp Sistemi ##
    TextDrawShowForPlayer(playerid,expbox);
    TextDrawShowForPlayer(playerid,expmeter);
    ShowProgressBarForPlayer(playerid,Bar:expbar);
    // Exp Sistemi Bitiþi ##
    
    switch(DM[playerid])
	{
	    case 1:
	    {
        new State = GetPlayerState(playerid);
        if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	    {
        GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
        }
        DM[playerid]=1;
        SetPlayerArmour(playerid,100);
        SetPlayerHealth(playerid,100);
        SetPlayerInterior(playerid,0);
        ResetPlayerWeapons(playerid);
        new rand = random(sizeof(deagledm1pos));
        SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
        GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
        GivePlayerWeapon(playerid,24,99999);
        SetPlayerTeam(playerid, NO_TEAM);
	    }
	    
	    case 2:
	    {
        new State = GetPlayerState(playerid);
        if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	    {
        GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
        }
        DM[playerid]=2;
        SetPlayerArmour(playerid,100);
        SetPlayerHealth(playerid,100);
        SetPlayerSkin(playerid, 80);
        SetPlayerInterior(playerid,1);
        ResetPlayerWeapons(playerid);
        new rand = random(sizeof(fistdm1pos));
        SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
        GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
        SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
        SetPlayerTeam(playerid, NO_TEAM);
	    }
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SendDeathMessage(killerid, playerid, reason);
    SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
	if(GetPlayerScore(playerid) > 0) return SetPlayerScore(playerid,GetPlayerScore(playerid)-1);
    PlayerPlaySound(playerid,5206, 0, 0, 0);
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
	new chatmessage[1024];
	if(IsPlayerAdmin(playerid))
	{
	format(chatmessage,1024,"{C30000}[{FFFFFF}RGM{C30000}]{ACDA00}%s{C30000}({FFFFFF}%i{C30000}){FFFFFF}:%s",PlayerName(playerid),playerid,text);
	SendClientMessageToAll(1,chatmessage);
	}
	else
	{
	if(IsPlayerLAdmin(playerid) && !IsPlayerAdmin(playerid))
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
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256],idx,tmp[256];
	cmd=strtok(cmdtext,idx);
	
	if(!strcmp("/dmcik",cmdtext,true))
	{
		if(DM[playerid] == 0) return SendError(playerid,"Zaten deathmatch alanýnda deðilsin!");
		DM[playerid]=0;
		SetPlayerArmour(playerid,0.0);
		SetPlayerHealth(playerid,100.0);
		ResetPlayerWeapons(playerid);
		SpawnPlayer(playerid);
		SendInfo(playerid,"Deathmatch alanýndan çýktýnýz.");
		return 1;
	}

   	if(DM[playerid] > 0) return SendError(playerid,"Deathmatch alanýnda komut kullanmak yasaktýr. Çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
	// - Genel komutlar && dialog komutlarý
	if(!strcmp(cmdtext, "/kurallar", true))
	{
	ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX,"{FFFFFF}Trinity-Xtreme / {009BFF}Kurallar","{00FF00}~ Hile kesinlikle yasaktýr.\n~ Argo yasaktýr.\n~ Ýnanç & görüþe karþý hakaret yasaktýr.\n~ Yönetimi rahatsýz etmek yasaktýr.","Kapat","");
    return 1;
	}

	if(!strcmp(cmdtext, "/changelog", true))
	{
	ShowPlayerDialog(playerid,1911,DIALOG_STYLE_MSGBOX,"Changelog / [BETA-TEST RC1.0]","{ACDA00}~ Sunucu dosyalarý oluþturuldu.\n~ LAdmin 4.0 eklendi.\n~ Changelog eklendi.\n~ Textdrawlar eklendi.\n~ Teles menüsü eklendi.\n~ Yardým menüsü eklendi.\n~ Kurallar menüsü eklendi.\n~ Ýlk haritalar ve araçlar eklendi.\n~ aLypSe Ev Sistemi moda eklendi.\n~ /v1-/v18 araç spawn sistemi eklendi.\n~ /m1-/m12 araç spawn sistemi eklendi.\n~ /paraver-/can-/yelek-/surus-/cevir komutlarý eklendi.","RC1.1","Kapat");
    return 1;
	}

	if(!strcmp(cmdtext, "/teles", true))
	{
	ShowPlayerDialog(playerid,1000,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Teleport","{FFFFFF}Four Dragon Casino (/4dragon)\n{FFFFFF}Chilliad Mountain (/dag)\n{FFFFFF}Santa Maria Beach (/sahil)\n{FFFFFF}Area51 Zone (/area51)\n{FFFFFF}San Fierro ChinaTown (/china)\n{FFFFFF}Los Santos Los Flores (/flores)","Seç","Kapat");
	return 1;
	}
	
	if(!strcmp(cmdtext, "/dmler", true))
	{
	ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Deathmatch","{FFFFFF}Desert Eagle Deathmatch - 1 (/deagledm1)\n{FFFFFF}Fight Club Deathmatch -1 (/fistdm1)\nChangelog renkleri azaltýldý.\nYeni maplar eklendi.","Seç","Kapat");
	return 1;
	}
	
	if(!strcmp(cmdtext, "/stuntlar", true))
	{
	ShowPlayerDialog(playerid,2001,DIALOG_STYLE_LIST,"{FFFFFF}Trinity-Xtreme / {009BFF}Stunt Zones","{FFFFFF}Bikepark Stunt - 1 (/bikestunt1)","Seç","Kapat");
	return 1;
	}
	
	if (strcmp("/yardim", cmdtext, true, 10) == 0)
	{
	    new string[2048];
	    format(string,2048,"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",dIp[0],dIp[1],dIp[2],dIp[3],dIp[4],dIp[5],dIp[6],dIp[7],dIp[8],dIp[9],dIp[10],dIp[11],dIp[12],dIp[13],dIp[14],dIp[15],dIp[16],dIp[17]);
	    ShowPlayerDialog(playerid,0,DIALOG_STYLE_MSGBOX, "{FFFFFF}Trinity-Xtreme / {009BFF}Yardým",string,"Kapat","");
		return 1;
	}

 	if (strcmp("/myversion", cmdtext, true, 10) == 0)
	{
	    new string[40];
    	GetPlayerVersion(playerid, string, sizeof(string));
    	format(string, sizeof(string), "#Bilgi: {FFFFFF}SA-MP versiyonunuz: {00FF00}%s", string);
        SendClientMessage(playerid, 0x00A2F6AA,string);
		return 1;
	}
	
	// - Araç yönetim komutlarý
    if(strcmp(cmd, "/motorac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,VEHICLE_PARAMS_ON,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Motor açýldý, kapatmak için {00FF00}/motorkapat");
    }
    return 1;
    }

    if(strcmp(cmd, "/motorkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,VEHICLE_PARAMS_OFF,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Motor kapatýldý, tekrar açmak için {00FF00}/motorac");
    }
    return 1;
    }

    if(strcmp(cmd, "/farac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,VEHICLE_PARAMS_ON,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Far açýldý, kapatmak için {00FF00}/farkapat");
    }
    return 1;
    }

    if(strcmp(cmd, "/farkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,VEHICLE_PARAMS_OFF,alarm,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Far kapatýldý, tekrar açmak için {00FF00}/farac");
    }
    return 1;
    }

    if(strcmp(cmd, "/alarmac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,VEHICLE_PARAMS_ON,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Alarm açýldý, kapatmak için {00FF00}/alarmkapat");
    }
	return 1;
	}
	
    if(strcmp(cmd, "/alarmkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,VEHICLE_PARAMS_OFF,kapilar,kaput,bagaj,objective);
    SendInfo(playerid,"Alarm kapatýldý, tekrar açmak için {00FF00}/alarmac");
    }
    return 1;
    }

    if(strcmp(cmd, "/kaputac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,VEHICLE_PARAMS_ON,bagaj,objective);
    SendInfo(playerid,"Kaput açýldý, kapatmak için {00FF00}/kaputkapat");
    }
	return 1;
	}

    if(strcmp(cmd, "/kaputkapat",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,VEHICLE_PARAMS_OFF,bagaj,objective);
    SendInfo(playerid,"Kaput kapatýldý, tekrar açmak için {00FF00}/kaputac");
    }
    return 1;
    }

    if(strcmp(cmd, "/bagajac",true) == 0) {
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,VEHICLE_PARAMS_ON,objective);
    SendInfo(playerid,"Bagaj açýldý, kapatmak için {00FF00}/bagajkapat");
    }
    return 1;
    }
        
    if(strcmp(cmd, "/bagajkapat",true) == 0) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    new vid = GetPlayerVehicleID(playerid);
    if(vid != INVALID_VEHICLE_ID)
	{
    GetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,bagaj,objective);
    SetVehicleParamsEx(vid,motor,isiklar,alarm,kapilar,kaput,VEHICLE_PARAMS_OFF,objective);
    SendInfo(playerid,"Bagaj kapatýldý, tekrar açmak için {00FF00}/bagajac");
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
	    SendInfo(playerid,"Araç kilitlendi, kilidi açmak için {00FF00}/kilitac");
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

		    SendInfo(playerid,"Kilit açýldý, aracý kilitlemek için {00FF00}/kilit");
		}
	    return 1;
	}
	
	// - Araç renk deðiþtirme komutu
    if(!strcmp(cmd, "/renk", true))
    {
    new xTemp[256],xString[128],xColor[2];
    xTemp = strtok(cmdtext, idx);
    if(!strlen(xTemp)) return SendInfo(playerid,"/renk [{00FF00}renk1 (0-255){FFFFFF}] [{00FF00}renk2 (0-255){FFFFFF}]");
    xColor[0] = strval(xTemp);
    xTemp = strtok(cmdtext, idx);
    if(!strlen(xTemp)) return SendInfo(playerid,"/renk [{00FF00}renk1 (0-255){FFFFFF}] [{00FF00}renk2 (0-255){FFFFFF}]");
    xColor[1] = strval(xTemp);
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0) return SendError(playerid,"Þöför koltuðunda deðilsiniz!");
    if((xColor[0] < 0 || xColor[0] > 255) || (xColor[1] < 0 || xColor[1] > 255)) return SendError(playerid,"Girilen deðerler geçersiz!");
    ChangeVehicleColor(GetPlayerVehicleID(playerid), xColor[0], xColor[1]);
    format(xString, sizeof(xString), "#Bilgi: {FFFFFF}Araç rengi deðiþtirildi. [{00FF00}Renk1:%d/Renk2:%d{FFFFFF}]", xColor[0], xColor[1]);
    SendClientMessage(playerid,-1, xString);
    return 1;
    }
    
    // - Skin deðiþtirme komutu
    if(strcmp(cmdtext, "/myskin", true) == 7 || strcmp(cmdtext, "/skin", true) == 7)
    {
	if(cmdtext[7] != ' ' || cmdtext[8] == EOS)
	return SendInfo(playerid,"/myskin [id]");
	if ((cmdtext[0] < 0) || (cmdtext[0] > 299)) return SendError(playerid,"Girilen deðer geçersiz!");
	if(IsValidSkin((cmdtext[0] = strval(cmdtext[8]))))
	SetPlayerSkin(playerid, cmdtext[0]);
	else
	SendError(playerid,"Girilen deðer geçersiz!");
	return 1;
    }

	// - DM alaný komutlarý
	if(!strcmp(cmdtext, "/deagledm1",true))
	{
	new State = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
	{
    GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
    }
    DM[playerid]=1;
    SetPlayerArmour(playerid,100);
    SetPlayerHealth(playerid,100);
    SetPlayerSkin(playerid, 285);
    SetPlayerInterior(playerid,0);
    ResetPlayerWeapons(playerid);
    new rand = random(sizeof(deagledm1pos));
    SetPlayerPos(playerid, deagledm1pos[rand][0], deagledm1pos[rand][1], deagledm1pos[rand][2]);
    GameTextForPlayer(playerid, "~b~~h~Desert Eagle~n~~w~~h~Deathmatch", 2000, 1);
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
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
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
    }
    DM[playerid]=2;
    SetPlayerArmour(playerid,100);
    SetPlayerHealth(playerid,100);
    SetPlayerSkin(playerid, 80);
    SetPlayerInterior(playerid,1);
    ResetPlayerWeapons(playerid);
    new rand = random(sizeof(fistdm1pos));
    SetPlayerPos(playerid, fistdm1pos[rand][0], fistdm1pos[rand][1], fistdm1pos[rand][2]);
    GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 2000, 1);
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
    SetPlayerTeam(playerid, NO_TEAM);
    return 1;
    }
        
	// - 31 sistemi komutlarý
    if(!strcmp("/31",cmd,true))
    {
    tmp=strtok(cmdtext,idx);
    
    if(!strlen(tmp)) return SendInfo(playerid,"/31 [cek/birak]");

    if(!strcmp("cek",tmp,true))
    {
    if(cekiyor[playerid] == 1) return SendError(playerid,"Zaten 31 çekmektesiniz.");
   	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
   	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0);
    asilantimer = SetTimerEx("asilanadamtimer", 19000,false,"i",playerid);
   	cekiyor[playerid] = 1;
   	return 1;
   	}

	if(!strcmp("birak",tmp,true))
	{
   	if(cekiyor[playerid] == 0) return SendError(playerid,"Zaten 31 çekmiyorsunuz.");
    SendInfo(playerid,"Artýk 31 çekmiyorsunuz.");
    ClearAnimations(playerid);
   	KillTimer(asilantimer);
    cekiyor[playerid] = 0;
    return 1;
   	}
    return 1;
    }
	// - Para gönderme komutu
	if(!strcmp("/paraver",cmd,true))
	{
	    tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendInfo(playerid,"/paraver {00FF00}[id][miktar]");
		new id=strval(tmp);
		if(!IsPlayerConnected(id)) return SendError(playerid,"Oyuncu oyunda {FF0000}bulunmuyor!");
		tmp=strtok(cmdtext,idx);
		if(!strlen(tmp)) return SendInfo(playerid,"/paraver {00FF00}[id][miktar]");
		new miktar=strval(tmp);

		if(miktar < 0) return SendError(playerid,"Girilen miktar {FF0000}geçersiz!");
		if(GetPlayerMoney(playerid) < miktar) return SendError(playerid,"Paranýz {FF0000}yetersiz!");

		GivePlayerMoney(playerid,-miktar);
		GivePlayerMoney(id,miktar);
		return 1;
	}

	// - Sürüþ kamerasý komutu
    if (strcmp("/surus", cmdtext, true, 10) == 0)
    {
    if(!IsPlayerInAnyVehicle(playerid)) return SendError(playerid,"Arabada olmalýsýnýz!");
    if(GetPVarInt(playerid,"used") == 0)
    {
    new p = GetPlayerVehicleID(playerid);
    Surus[playerid] = CreatePlayerObject(playerid,19300, 0.0000, -1282.9984, 10.1493, 0.0000, -1, -1, 100);
    AttachPlayerObjectToVehicle(playerid,Surus[playerid],p,-0.314999, -0.195000, 0.510000, 0.000000, 0.000000, 0.000000);
    AttachCameraToPlayerObject(playerid,Surus[playerid]);
    SetPVarInt(playerid,"used",1);
    SendInfo(playerid,"Kamerayý eski haline döndürmek için {00FF00}/surus {FFFFFF}yazýnýz.");
    }
    else if(GetPVarInt(playerid,"used") == 1)
    {
    SetCameraBehindPlayer(playerid);
    DestroyPlayerObject(playerid,Surus[playerid]);
    SetPVarInt(playerid,"used",0);
    SendInfo(playerid,"Kamera eski haline döndürüldü."); }
    return 1;
    }

	// - Iþýnlanma komutlarý
	if(strcmp(cmdtext, "/4dragon", true) == 0 || strcmp(cmdtext, "/dragon", true) == 0 || strcmp(cmdtext, "/4d", true) == 0)
	{
    SetPlayerPos(playerid,2027.8171,1008.1444,10.8203);
    SendInfo(playerid,"Four Dragon Casino alanýna ýþýnlanýldý.");
	return 1;
	}
	
	if(strcmp(cmdtext, "/dag", true) == 0 || strcmp(cmdtext, "/chilliad", true) == 0)
	{
    SetPlayerPos(playerid,-2353.0940,-1633.6820,483.6954);
	SendInfo(playerid,"Chilliad Mountain alanýna ýþýnlanýldý.");
	return 1;
	}
	
	if(strcmp(cmdtext, "/sahil", true) == 0)
	{
    SetPlayerPos(playerid,369.8283,-1787.7871,5.3585);
	SendInfo(playerid,"Santa Maria Beach alanýna ýþýnlanýldý.");
	return 1;
	}
	
	if(strcmp(cmdtext, "/area51", true) == 0)
	{
    SetPlayerPos(playerid,231.5036,1914.3851,17.6406);
	SendInfo(playerid,"Area51 alanýna ýþýnlanýldý.");
	return 1;
	}
	
	if(strcmp(cmdtext, "/china", true) == 0)
	{
    SetPlayerPos(playerid,-2276.2874,718.5117,49.4453);
	SendInfo(playerid,"China Town alanýna ýþýnlanýldý.");
	return 1;
	}

    if(strcmp(cmdtext, "/flores", true) == 0)
	{
    SetPlayerPos(playerid,2786.9534,-1319.9723,34.7975);
	SendInfo(playerid,"Los Flores alanýna ýþýnlanýldý.");
	return 1;
	}
	// - Can & Zýrh komutlarý
	if(strcmp(cmdtext, "/can", true) == 0 || strcmp(cmdtext, "/health", true) == 0)
    {
    if(GetPVarInt(playerid, "SpamKoruma") > GetTickCount()) return SendInfo(playerid,"Komutu tekrar kullanmak için 30 saniye bekleyiniz.");
    SetPVarInt(playerid, "SpamKoruma", GetTickCount() + 30000);
    if(GetPlayerMoney(playerid) < 750)
    return SendError(playerid,"Paranýz {FF0000}yetersiz!");
    SetPlayerHealth(playerid,100);
    GivePlayerMoney(playerid,-750);
    SendInfo(playerid,"Can paketi {00FF00}baþarýyla {FFFFFF}alýndý. [750$]");
    return 1;
    }

    if (strcmp(cmdtext, "/yelek", true)==0 || strcmp(cmdtext, "/zirh", true)==0)
    {
    if(GetPVarInt(playerid, "SpamKoruma1") > GetTickCount()) return SendInfo(playerid,"Komutu tekrar kullanmak için 30 saniye bekleyiniz.");
    SetPVarInt(playerid, "SpamKoruma1", GetTickCount() + 30000);
    if(GetPlayerMoney(playerid) < 1000)
    return SendError(playerid,"Paranýz {FF0000}yetersiz!");
    SetPlayerArmour(playerid,100);
    GivePlayerMoney(playerid,-1000);
    SendInfo(playerid,"Zýrh paketi {00FF00}baþarýyla {FFFFFF}alýndý. [1000$]");
    return 1;
    }
	
	// - FPS komutlarý
	if (strcmp("/firstperson", cmdtext, true, 10) == 0)
	{
	    firstperson[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
     	AttachObjectToPlayer(firstperson[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
	    AttachCameraToObject(playerid, firstperson[playerid]);
	    SendInfo(playerid,"Kamerayý eski hale döndürmek için {00FF00}/exitfirstperson {FFFFFF}yazýnýz.");
		return 1;
	}
	if (strcmp("/exitfirstperson", cmdtext, true, 10) == 0)
	{
	    SetCameraBehindPlayer(playerid);
        DestroyObject(firstperson[playerid]);
		return 1;
	}
	
	// - Araç çevirme komutu
	if(strcmp(cmdtext,"/cevir",true)==0)
	{
	if(IsPlayerInAnyVehicle(playerid))
	{
	new VehicleID,Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	VehicleID = GetPlayerVehicleID(playerid);
	SetVehiclePos(VehicleID,X,Y,Z);
	SetVehicleZAngle(VehicleID,0);
	SendInfo(playerid,"Arabanýz {00FF00}baþarýyla {FFFFFF}çevrildi.");
	} else {
	SendError(playerid,"Arabada {FF0000}deðilsiniz!");
	}
	return 1;
	}
	
	// - Araç spawn komutu
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
        
	// - Modifiyeli araç spawn komutlarý
	if(strcmp(cmdtext, "/m1", true)==0) // Sultan
	{
        new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=LVehicleIDt;
        PlayerInfo[playerid][pMAraba]=1;
        AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
	    AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,1);
	   	SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m2", true)==0)	{ //Sultan
		new Float:X,Float:Y,Float:Z,Float:Angle,LVehicleIDt;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        LVehicleIDt = CreateVehicle(560,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,LVehicleIDt,0); AddVehicleComponent(LVehicleIDt, 1028);	AddVehicleComponent(LVehicleIDt, 1030);	AddVehicleComponent(LVehicleIDt, 1031);	AddVehicleComponent(LVehicleIDt, 1138);	AddVehicleComponent(LVehicleIDt, 1140);  AddVehicleComponent(LVehicleIDt, 1170);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=LVehicleIDt;
        PlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(LVehicleIDt, 1080);	AddVehicleComponent(LVehicleIDt, 1086); AddVehicleComponent(LVehicleIDt, 1087); AddVehicleComponent(LVehicleIDt, 1010);	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);	ChangeVehiclePaintjob(LVehicleIDt,2);
        SetVehicleVirtualWorld(LVehicleIDt, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(LVehicleIDt, GetPlayerInterior(playerid));
    	return 1;	}
	if(strcmp(cmdtext, "/m3", true)==0)	{ // Jester
        new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(559,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(carid,1065);    AddVehicleComponent(carid,1067);    AddVehicleComponent(carid,1162); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073);	ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m4", true)==0)	{ // Flash
     	new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(565,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(carid,1046); AddVehicleComponent(carid,1049); AddVehicleComponent(carid,1053); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m5", true)==0)	{ // Uranus
	    new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
        AddVehicleComponent(carid,1088); AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1139); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
 	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
    if(strcmp(cmdtext, "/m6", true)==0)	{ // Stratum
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(561,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
    	AddVehicleComponent(carid,1055); AddVehicleComponent(carid,1058); AddVehicleComponent(carid,1064); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
    if(strcmp(cmdtext, "/m7", true)==0)	{ // Elegy
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
	    AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,1);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m8", true)==0)	{ // Savanna
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(567,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
	    AddVehicleComponent(carid,1102); AddVehicleComponent(carid,1129); AddVehicleComponent(carid,1133); AddVehicleComponent(carid,1186); AddVehicleComponent(carid,1188); ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1085); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1086);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
		return 1;	}
	if(strcmp(cmdtext, "/m9", true)==0)	{ // Uranus
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(558,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
   		AddVehicleComponent(carid,1092); AddVehicleComponent(carid,1166); AddVehicleComponent(carid,1165); AddVehicleComponent(carid,1090);
	    AddVehicleComponent(carid,1094); AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1163);
	    AddVehicleComponent(carid,1091); ChangeVehiclePaintjob(carid,2);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
	if(strcmp(cmdtext, "/m10", true)==0)	{ // Monster
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(557,X,Y,Z,Angle,1,1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1081);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
	if(strcmp(cmdtext, "/m11", true)==0)	{ // Slamvan
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(535,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
		ChangeVehiclePaintjob(carid,1); AddVehicleComponent(carid,1109); AddVehicleComponent(carid,1115); AddVehicleComponent(carid,1117); AddVehicleComponent(carid,1073); AddVehicleComponent(carid,1010);
	    AddVehicleComponent(carid,1087); AddVehicleComponent(carid,1114); AddVehicleComponent(carid,1081); AddVehicleComponent(carid,1119); AddVehicleComponent(carid,1121);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;	}
	if(strcmp(cmdtext, "/m12", true)==0)	{ // Elegy
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(562,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
  		AddVehicleComponent(carid,1034); AddVehicleComponent(carid,1038); AddVehicleComponent(carid,1147);
		AddVehicleComponent(carid,1010); AddVehicleComponent(carid,1073); ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;   }
	if(strcmp(cmdtext, "/nrg", true)==0)	{ // NRG
		new Float:X,Float:Y,Float:Z,Float:Angle,carid;	GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,Angle);
        carid = CreateVehicle(522,X,Y,Z,Angle,1,-1,-1);	PutPlayerInVehicle(playerid,carid,0);
        if(PlayerInfo[playerid][pMAraba]!=0) DestroyVehicle(PlayerInfo[playerid][pMArabaID]);
        PlayerInfo[playerid][pMArabaID]=carid;
        PlayerInfo[playerid][pMAraba]=1;
  		ChangeVehiclePaintjob(carid,0);
	   	SetVehicleVirtualWorld(carid, GetPlayerVirtualWorld(playerid)); LinkVehicleToInterior(carid, GetPlayerInterior(playerid));
	    return 1;   }
	    
	// - Ev sistemi komutlarý
	if (strcmp("/evmenu", cmdtext, true, 10) == 0)
	{
		if(!IsPlayerAdmin(playerid)) return Mesaj(playerid,"Bu komutu kullanmak için gerekli izniniz yok!");
		if(GetPlayerInterior(playerid) != 0) return Mesaj(playerid,"Ev yaratmak için interior dýþýnda olmalýsýnýz!");
		if(Kontrol(playerid))
		{
		    if(EvEditleniyor[GetHouseID(playerid)] == true) return Mesaj(playerid,"Þu anda bu evi baþka bir kiþi düzenliyor...");
		    EvEditleniyor[GetHouseID(playerid)] = true;
		    ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
		}
		else
		{
		    ShowPlayerDialog(playerid,DIALOG+1,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Yeni Ev Yarat","Seç","Ýptal");
		}
		return 1;
	}

	if (strcmp("/ev", cmdtext, true, 10) == 0)
	{
	    new dosya[64];
	    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",OyuncuEv[playerid]);
		if(OyuncuEv[playerid] == -1) return Mesaj(playerid,"Þuanda evde deðilsin!");
	    else if(EvEditleniyor[OyuncuEv[playerid]] == true) return Mesaj(playerid,"Þu anda bu evi baþka bir kiþi düzenliyor...");
		else if(IsPlayerAdmin(playerid)) Mesaj(playerid,"Rcon admin bypass aktif!");
		else if(EvSahipID[OyuncuEv[playerid]] != playerid) return Mesaj(playerid,"Bu ev size ait deðil!");
		EvEditleniyor[OyuncuEv[playerid]] = true;
		ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
		return 1;
	}

	if (strcmp("/satinal", cmdtext, true, 10) == 0)
	{
		if(Kontrol(playerid))
		{
	        new evid = GetHouseID(playerid);
		    if(EvSahipID[evid] != -1) return Mesaj(playerid,"Bu evin zaten bir sahibi var, lütfen satýlýk ev seçiniz!");
	        new str[256];
		    format(str,sizeof(str),"{00FF7F}Ev Açýklamasý: {c0c0c0}%s\n{00FF7F}Ev Fiyatý: {c0c0c0}%i$\n\n{CD5C5C}Bu evi satýn almak istiyor musunuz ?",EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat]);
			ShowPlayerDialog(playerid,SATINAL,DIALOG_STYLE_MSGBOX,BASLIK,str,"Satýn Al","Ýptal");
		} else Mesaj(playerid,"Herhangi bir evin üstünde deðilsiniz!");
		return 1;
	}
	return SendError(playerid,"Böyle bir komut yok!");
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
	// - 2 tuþu fonksiyonu
	if(newkeys & KEY_LOOK_BEHIND && IsPlayerInAnyVehicle(playerid))
	{
    	if(!IsNosVehicle(GetPlayerVehicleID(playerid))) return RepairVehicle(GetPlayerVehicleID(playerid)),PlayerPlaySound(playerid, 1133 ,0, 0, 0),GameTextForPlayer(playerid,"~b~~h~Full Tamir",500,1);
    	AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		PlayerPlaySound(playerid, 1133 ,0, 0, 0);
		RepairVehicle(GetPlayerVehicleID(playerid));
		GameTextForPlayer(playerid,"~g~10x Nitro ~w~~h~& ~b~~h~Tamir",500,1);
	}

	
	// - Ev sistemi ayarlarý
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
				else if(EvSahipID[evid] == playerid) Mesaj(playerid,"Evinize hoþgeldiniz!"),Mesaj(playerid,"Evinizi düzenlemek veya ayarlarýna girmek için '{008080}/ev{FFFFFF}' komutunu kullanýnýz.");
		        else if(EvBilgi[evid][evkilit] == 1) return Mesaj(playerid,"Bu ev kilitli, kilitli evlere giremezsiniz.");
		        if(EvBilgi[evid][evint] == 0) PlayerPos(playerid,235.1575,1187.2721,1080.2578,3,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 1) PlayerPos(playerid,225.756989 ,1240.000000 ,1082.149902 ,2,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 2) PlayerPos(playerid,222.9848,1287.5624,1082.1406 ,1,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 3) PlayerPos(playerid,225.630997,1022.479980,1084.069946,7,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 4) PlayerPos(playerid,295.2057,1472.9973,1080.2578,15,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 5) PlayerPos(playerid,327.9004,1478.2839,1084.4375,15,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 6) PlayerPos(playerid,385.803986,1471.769897,1080.209961,15,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 7) PlayerPos(playerid,2255.0129,-1139.9670,1050.6328,9,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 8) PlayerPos(playerid,2269.3037,-1210.4395,1047.5625,10,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 9) PlayerPos(playerid,2496.0330,-1692.9246,1014.7422,3,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 10) PlayerPos(playerid, 1299.14 , -794.77 , 1084.00 ,5,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 11) PlayerPos(playerid,2259.8408,-1135.7609,1050.6328,10,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 12) PlayerPos(playerid,2365.2190,-1135.1531,1050.8750,8,EvBilgi[evid][evworld]);
		        else if(EvBilgi[evid][evint] == 13) PlayerPos(playerid,2324.3735,-1148.8219,1050.7101,12,EvBilgi[evid][evworld]);
		        OyuncuEv[playerid] = evid;
		    }
		    else if(IsPlayerInRangeOfPoint(playerid,2,2324.3735,-1148.8219,1050.7101) ||
			IsPlayerInRangeOfPoint(playerid,2,235.1575,1187.2721,1080.2578) ||
			IsPlayerInRangeOfPoint(playerid,2,225.756989,1240.000000,1082.149902) ||
			IsPlayerInRangeOfPoint(playerid,2,222.9848,1287.5624,1082.1406) ||
			IsPlayerInRangeOfPoint(playerid,2,225.630997,1022.479980,1084.069946) ||
			IsPlayerInRangeOfPoint(playerid,2,295.2057,1472.9973,1080.2578) ||
			IsPlayerInRangeOfPoint(playerid,2,327.9004,1478.2839,1084.4375) ||
			IsPlayerInRangeOfPoint(playerid,2,385.803986,1471.769897,1080.209961) ||
			IsPlayerInRangeOfPoint(playerid,2,2255.0129,-1139.9670,1050.6328) ||
			IsPlayerInRangeOfPoint(playerid,2,2269.3037,-1210.4395,1047.5625) ||
			IsPlayerInRangeOfPoint(playerid,2,2496.0330,-1692.9246,1014.7422) ||
			IsPlayerInRangeOfPoint(playerid,2,1299.14,-794.77,1084.00) ||
			IsPlayerInRangeOfPoint(playerid,2,2259.8408,-1135.7609,1050.6328) ||
			IsPlayerInRangeOfPoint(playerid,2,2365.2190,-1135.1531,1050.8750))
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
	// - Ev sistemi ayarlarý
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
	// - Teles alanlarý dialoglarý
	if(dialogid == 1000)
	{
	if(response)
	{
	if(listitem == 0)
	{
    SetPlayerPos(playerid,2027.8171,1008.1444,10.8203);
    SendInfo(playerid,"Four Dragon Casino alanýna ýþýnlanýldý.");
	}
	if(listitem == 1)
	{
    SetPlayerPos(playerid,-2353.0940,-1633.6820,483.6954);
	SendInfo(playerid,"Chilliad Mountain alanýna ýþýnlanýldý.");
	}
	if(listitem == 2)
	{
    SetPlayerPos(playerid,369.8283,-1787.7871,5.3585);
	SendInfo(playerid,"Santa Maria Beach alanýna ýþýnlanýldý.");
	}
	if(listitem == 3)
	{
    SetPlayerPos(playerid,231.5036,1914.3851,17.6406);
	SendInfo(playerid,"Area51 alanýna ýþýnlanýldý.");
	}
	if(listitem == 4)
	{
    SetPlayerPos(playerid,-2276.2874,718.5117,49.4453);
	SendInfo(playerid,"China Town alanýna ýþýnlanýldý.");
	}
	if(listitem == 5)
	{
    SetPlayerPos(playerid,2786.9534,-1319.9723,34.7975);
	SendInfo(playerid,"Los Flores alanýna ýþýnlanýldý.");
	}
	}
	}
	
	// - Changelog dialoglarý
	if(dialogid == 1911)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1912,DIALOG_STYLE_MSGBOX,"Changelog / [BETA-TEST RC1.1]","{ACDA00}~ Textdrawlar düzenlendi.\n~ Teles menüsü güncellendi. {FFFFFF}(4 yeni teleport alaný){ACDA00}\n~ Admin sistemi düzenlendi.\n~ Yardým menüsü düzenlendi.\n~ \"Desert Eagle Deathmatch\" alaný eklendi.\n~ Ölüm-öldürme göstergesi eklendi.\n~ /skin komutu eklendi.\n~ /renk komutu eklendi.\n~ Ufak buglar giderildi.\n~ DM sistemi eklendi.","RC1.2","Kapat");
	}
	}
	
	if(dialogid == 1912)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1913,DIALOG_STYLE_MSGBOX,"Changelog / [BETA-TEST RC1.2]","{ACDA00}~ Ufak buglar giderildi.\n~ \"Fight Club Deathmatch\" alaný eklendi.\n~ Eksik haritalar güncellendi.\n~ \"Bikepark Stunt 1\" alaný eklendi.\n~ /nrg komutu eklendi.\n~ Araç yönetim komutlarý eklendi.\n~ Website eklendi. {FFFFFF}(trinity.immortal-official.tk){ACDA00}\n~ Textdraw kaymalarý düzeltildi.\n~ Gametext süreleri düþürüldü.\n~ Giriþ düzenlendi.","RC1.3","Kapat");
	}
	}
	
	if(dialogid == 1913)
	{
	if(response)
	{
	ShowPlayerDialog(playerid,1914,DIALOG_STYLE_MSGBOX,"Changelog / [BETA-TEST RC1.3]","{ACDA00}~ BETA hesaplarý silindi.\n~ Kick-Ban mesajlarý ve Giriþ-Çýkýþ mesajlarý güncellendi.\n~ Araç Kilit Sistemi eklendi. {FFFFFF}(/kilit - /kilitac){ACDA00}\n~ 31 sistemi bugu giderildi.\n~ Ufak buglar giderildi.\n~ Changelog düzenlendi.\n~ Yeni haritalar eklendi.\n~ Geliþmiþ saat sistemi eklendi.\n~ RGM-GM sistemi buglarý giderildi.\n~ Sohbet baloncuðu eklendi.\n~ Driveby engeli kaldýrýldý.","Kapat","");
	}
	}
	// - DM alaný dialoglarý
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
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
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
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
    GivePlayerWeapon(playerid,24,99999);
    SetPlayerTeam(playerid, NO_TEAM);
	}
	if(listitem == 1)
	{
    new State = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
    {
    GameTextForPlayer(playerid, "~b~~h~Fight Club~n~~w~~h~Deathmatch", 5000, 1);
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
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
    SendInfo(playerid,"Deathmatch alanýndan çýkmak için {00FF00}/dmcik {FFFFFF}yazýnýz.");
    SetPlayerTeam(playerid, NO_TEAM);
	}
	}
	}
	
	// - Stunt dialoglarý
	if(dialogid == 2001)
	{
	if(response)
	{
	if(listitem == 0)
	{
	SendInfo(playerid,"{00FF00}Bikepark Stunt - 1 {FFFFFF}alanýna ýþýnlanýldý.");
	SetPlayerPos(playerid,1165.3389,1344.6733,10.8125);
	}
	}
	}
	// Araç spawn ayarlarý
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

    // - Yasak araç ayarlarý
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
	        if(!Kontrol(playerid)) return Mesaj(playerid,"Evi satýn almak için herhangi bir evin üstünde olmalýsýnýz!");
		    else if(EvSahipID[evid] != -1) return Mesaj(playerid,"Bu evin zaten bir sahibi var, lütfen satýlýk ev seçiniz!");
			else if(EvBilgi[evid][evfiyat] > GetPlayerMoney(playerid)) return Mesaj(playerid,"Evi almak için yeterli paranýz bulunmamakta!");
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
			    format(str,sizeof(str),"{00FF7F}Ev Açýklamasý: {c0c0c0}%s\n\n{CD5C5C}Açýklamayý deðiþtirmek için yenisini aþaðýya yazýnýz.",EvBilgi[evid][evaciklama]);
				ShowPlayerDialog(playerid,MENU+1,DIALOG_STYLE_INPUT,BASLIK,str,"Deðiþtir","Ýptal");
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid,MENU+2,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Kilidi Aç\n{FF4500}Kilitle","Ayarla","Ýptal");
			}
			if(listitem == 2)
			{
			    format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut Paranýz: {c0c0c0}%i$\n\n{CD5C5C}Lütfen gerçekleþtirilcek iþlemi seçiniz.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+3,DIALOG_STYLE_MSGBOX,BASLIK,str,"Yatýr/Çek","Ýptal");
			}
			if(listitem == 3)
			{
				format(str,sizeof(str),"{FF4500}Depodan Silah Al\n{FF4500}Depoya Elindeki Silahý Koy");
				ShowPlayerDialog(playerid,MENU+8,DIALOG_STYLE_LIST,BASLIK,str,"Seç","Ýptal");
			}
		}
	}

	if(dialogid == MENU+1)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
			if(!strlen(inputtext)) return Mesaj(playerid,"Lütfen geçerli bir yazý giriniz.");
	        new evid = OyuncuEv[playerid];
			EvKaydetStr(evid,"evaciklama",inputtext);
			EvYenile(evid);
			Mesaj(playerid,"Ev açýklamasý deðiþtirildi.");
		    ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
		}
	}

	if(dialogid == MENU+2)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
			if(listitem == 0)
			{
			    EvKaydetInt(evid,"evkilit",0);
			    Mesaj(playerid,"Evin kilidini açtýnýz!");
			    EvYenile(evid);
			    ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
			}
			if(listitem == 1)
			{
			    EvKaydetInt(evid,"evkilit",1);
			    Mesaj(playerid,"Evi kilitlediniz!");
			    EvYenile(evid);
			    ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
			}
		}
	}

	if(dialogid == MENU+3)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
		    ShowPlayerDialog(playerid,MENU+4,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Para Yatýr\n{FF4500}Para Çek","Seç","Ýptal");
		}
	}

	if(dialogid == MENU+4)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
	        new str[256];
	        new evid = OyuncuEv[playerid];
			if(listitem == 0)
			{
			    format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut Paranýz: {c0c0c0}%i$\n\n{CD5C5C}Lütfen kasaya yatýrýlcak miktarý yazýnýz.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+5,DIALOG_STYLE_INPUT,BASLIK,str,"Yatýr","Ýptal");
			}
			if(listitem == 1)
			{
			    format(str,sizeof(str),"{00FF7F}Kasadaki Para: {c0c0c0}%i$\n{00FF7F}Mevcut Paranýz: {c0c0c0}%i$\n\n{CD5C5C}Lütfen kasadan çekilecek miktarý yazýnýz.",EvBilgi[evid][evbanka],GetPlayerMoney(playerid));
				ShowPlayerDialog(playerid,MENU+6,DIALOG_STYLE_INPUT,BASLIK,str,"Çek","Ýptal");
			}

		}
	}

	if(dialogid == MENU+5)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
			if(!strlen(inputtext)) return Mesaj(playerid,"Lütfen geçerli bir rakam giriniz.");
			if(!strval(inputtext)) return Mesaj(playerid,"Lütfen geçerli bir rakam giriniz.");
			if(strval(inputtext) > GetPlayerMoney(playerid)) return Mesaj(playerid,"Yazýlan miktar sizde yeteri kadar bulunmuyor.");
			EvKaydetInt(evid,"evbanka",EvBilgi[evid][evbanka]+strval(inputtext));
			GivePlayerMoney(playerid,-strval(inputtext));
			EvYenile(evid);
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
		}
	}

	if(dialogid == MENU+6)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
	        new evid = OyuncuEv[playerid];
			if(!strlen(inputtext)) return Mesaj(playerid,"Lütfen geçerli bir rakam giriniz.");
			if(!strval(inputtext)) return Mesaj(playerid,"Lütfen geçerli bir rakam giriniz.");
			if(strval(inputtext) > EvBilgi[evid][evbanka]) return Mesaj(playerid,"Yazýlan miktar kasanýzda yeteri kadar bulunmuyor.");
			EvKaydetInt(evid,"evbanka",EvBilgi[evid][evbanka]-strval(inputtext));
			GivePlayerMoney(playerid,strval(inputtext));
			EvYenile(evid);
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
		}
	}

	if(dialogid == MENU+7)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
	    if(response)
	    {
		}
	}

	if(dialogid == MENU+8)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
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
				ShowPlayerDialog(playerid,MENU+9,DIALOG_STYLE_LIST,BASLIK,str,"Seç","Ýptal");
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
				ShowPlayerDialog(playerid,MENU+10,DIALOG_STYLE_LIST,BASLIK,str,"Seç","Ýptal");
			}
		}
	}

	if(dialogid == MENU+9)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
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
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
		}
	}

	if(dialogid == MENU+10)
	{
	    if(!response) ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
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
			ShowPlayerDialog(playerid,MENU,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Kilidi\n{FF4500}Ev Kasasý\n{FF4500}Ev Silah Deposu","Seç","Ýptal");
		}
	}

	if(dialogid == DIALOG)
	{
	    if(!response) EvEditleniyor[GetHouseID(playerid)] = false;
	    if(response)
	    {
	        if(!Kontrol(playerid)) return Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
	        new str[256];
	        new evid = GetHouseID(playerid);
			if(listitem == 0) //Ev Açýklamasý
			{
			    format(str,sizeof(str),"{00FF7F}Ev Açýklamasý: {c0c0c0}%s\n\n{CD5C5C}Açýklamayý deðiþtirmek için yenisini aþaðýya yazýnýz.",EvBilgi[evid][evaciklama]);
				ShowPlayerDialog(playerid,DIALOG+2,DIALOG_STYLE_INPUT,BASLIK,str,"Deðiþtir","Ýptal");
			}
			if(listitem == 1) //Ev Sahibi
			{
			    new sahip[255];
			    new dosya[64];
			    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
			    if(!strlen(EvBilgi[evid][evsahip])) sahip = "Yok";
			    else sahip = dini_Get(dosya,"evsahip");
			    format(str,sizeof(str),"{00FF7F}Ev Sahibi: {c0c0c0}%s\n\n{CD5C5C}Ev sahibini deðiþtirirseniz tüm ev belirlenen kiþiye devredilir.\nEðer boþ býrakýrsanýz ev satýlýk olarak deðiþtirilir.",sahip);
				ShowPlayerDialog(playerid,DIALOG+3,DIALOG_STYLE_INPUT,BASLIK,str,"Deðiþtir","Ýptal");
			}
			if(listitem == 2) //Ev Fiyatý
			{
			    format(str,sizeof(str),"{00FF7F}Ev Fiyatý: {c0c0c0}%i$\n\n{CD5C5C}Yeni ev fiyatýný deðiþtirmek için yeni miktarý giriniz.",EvBilgi[evid][evfiyat]);
				ShowPlayerDialog(playerid,DIALOG+4,DIALOG_STYLE_INPUT,BASLIK,str,"Deðiþtir","Ýptal");
			}
			if(listitem == 3) //Ev Interior
			{
			    new menu[450];
			    strcat(menu,"{FF4500}Ev 1\n");
			    strcat(menu,"{FF4500}Ev 2\n");
			    strcat(menu,"{FF4500}Ev 3\n");
			    strcat(menu,"{FF4500}Ev 4\n");
			    strcat(menu,"{FF4500}Ev 5\n");
			    strcat(menu,"{FF4500}Ev 6\n");
			    strcat(menu,"{FF4500}Ev 7\n");
			    strcat(menu,"{FF4500}Otel Odasý\n");
			    strcat(menu,"{FF4500}Hashbury Evi\n");
			    strcat(menu,"{FF4500}Johnsons Evi\n");
			    strcat(menu,"{FF4500}Madd Doggs Pansiyonu\n");
			    strcat(menu,"{FF4500}Otel Odasý 2\n");
			    strcat(menu,"{FF4500}Verdant Bluffs Villasý\n");
			    strcat(menu,"{FF4500}Unused Villasý");
				ShowPlayerDialog(playerid,DIALOG+5,DIALOG_STYLE_LIST,BASLIK,menu,"Ayarla","Ýptal");
			}
			if(listitem == 4) //Ev Kilidi
			{
				ShowPlayerDialog(playerid,DIALOG+7,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Kilidi Aç\n{FF4500}Kilitle","Ayarla","Ýptal");
			}
			if(listitem == 5) //Ev Sil
			{
				ShowPlayerDialog(playerid,DIALOG+8,DIALOG_STYLE_MSGBOX,BASLIK,"{B22222}Bunu yaparsanýz ev kaydý tamamen silinecektir ve geri dönüþü olmayacaktýr.\n{C0C0C0}Silmeyi onaylýyor musunuz ?","Onayla","Ýptal");
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
				Mesaj(playerid,"Baþarýyla ev yarattýnýz, düzenlemek için pickup üzerinde '{008080}/alhouse{FFFFFF}' komutunu kullanýnýz.");
			}
	    }
	}
	if(dialogid == DIALOG+2)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
			if(!strlen(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Lütfen geçerli bir yazý giriniz.") ;
			new evid = OyuncuKontrolEv[playerid];
			EvKaydetStr(evid,"evaciklama",inputtext);
			EvYenile(evid);
			Mesaj(playerid,"Ev açýklamasý deðiþtirildi.");
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    }
	}
	if(dialogid == DIALOG+3)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    if(response)
	    {
	        new evid = OyuncuKontrolEv[playerid];
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
			if(!strlen(inputtext)) EvKaydetInt(evid,"evsatilik",1),EvKaydetStr(evid,"evsahip",""),Mesaj(playerid,"Ev satýlýk olarak deðiþtirildi!");
			else EvKaydetInt(evid,"evsatilik",0),EvKaydetStr(evid,"evsahip",inputtext),Mesaj(playerid,"Ev sahibi deðiþtirildi!");
			EvYenile(evid);
			SahipKontrol();
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    }
	}
	if(dialogid == DIALOG+4)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
			if(!strlen(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Lütfen geçerli bir rakam giriniz.");
			if(!strval(inputtext)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Lütfen geçerli bir rakam giriniz.");
			new evid = OyuncuKontrolEv[playerid];
			EvKaydetInt(evid,"evfiyat",strval(inputtext));
			Mesaj(playerid,"Ev fiyatý deðiþtirildi!");
			EvYenile(evid);
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    }
	}
	if(dialogid == DIALOG+5)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
			new evid = OyuncuKontrolEv[playerid];
			if(listitem == 0) EvKaydetInt(evid,"evint",0);
			if(listitem == 1) EvKaydetInt(evid,"evint",1);
			if(listitem == 2) EvKaydetInt(evid,"evint",2);
			if(listitem == 3) EvKaydetInt(evid,"evint",3);
			if(listitem == 4) EvKaydetInt(evid,"evint",4);
			if(listitem == 5) EvKaydetInt(evid,"evint",5);
			if(listitem == 6) EvKaydetInt(evid,"evint",6);
			if(listitem == 7) EvKaydetInt(evid,"evint",7);
			if(listitem == 8) EvKaydetInt(evid,"evint",8);
			if(listitem == 9) EvKaydetInt(evid,"evint",9);
			if(listitem == 10) EvKaydetInt(evid,"evint",10);
			if(listitem == 11) EvKaydetInt(evid,"evint",11);
			if(listitem == 12) EvKaydetInt(evid,"evint",12);
			if(listitem == 13) EvKaydetInt(evid,"evint",13);

			EvYenile(evid);
			Mesaj(playerid,"Ev interioru deðiþtirildi!");
            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    }
	}
	if(dialogid == DIALOG+7)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    if(response)
	    {
			if(!Kontrol(playerid)) return EvEditleniyor[GetHouseID(playerid)] = false, Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
			new evid = OyuncuKontrolEv[playerid];
			if(listitem == 0)
			{
			    EvKaydetInt(evid,"evkilit",0);
			    Mesaj(playerid,"Evin kilidini açtýnýz!");
			    EvYenile(evid);
	            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
			}
			if(listitem == 1)
			{
			    EvKaydetInt(evid,"evkilit",1);
			    Mesaj(playerid,"Evi kilitlediniz!");
			    EvYenile(evid);
	            ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
			}
	    }
	}
	if(dialogid == DIALOG+8)
	{
	    if(!response) ShowPlayerDialog(playerid,DIALOG,DIALOG_STYLE_LIST,BASLIK,"{FF4500}Ev Açýklamasý\n{FF4500}Ev Sahibi\n{FF4500}Ev Fiyatý\n{FF4500}Ev Interior\n{FF4500}Ev Kilidi\n{DC143C}Evi Sil","Seç","Ýptal");
	    if(response)
	    {
			if(Kontrol(playerid)) EvSil(GetHouseID(playerid)),EvEditleniyor[GetHouseID(playerid)] = false;
			else Mesaj(playerid,"Ev düzenlemek için herhangi bir evin üstünde olmalýsýnýz!");
	    }
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//(( #Diðer ))================================================================//

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

// - 31 çekme sistemi
forward asilanadamtimer(playerid);
public asilanadamtimer(playerid)
{
	if(cekiyor[playerid] == 1)
	{
    GivePlayerMoney(playerid,31);
    SendInfo(playerid,"31'den para aldýnýz! {FF0000}(31$)");
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

// - Nos alabilecek araçlar
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

// - Ev sistemi public & fonksiyonlarý
public OyuncuMapIconKontrol(playerid)
{
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
	return 1;
}

public EvYukle(evid)
{
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

		if(EvBilgi[evid][evkilit] == 0) durum = "Açýk";
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
		    format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}Satýlýk\n{00FF7F}Ev Fiyatý: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
			Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);

		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // Yüklendi.",evid,EvBilgi[evid][evfiyat],durum);
        ToplamEv++;
    }
	return 1;
}

public EvYenile(evid)
{
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

		if(EvBilgi[evid][evkilit] == 0) durum = "Açýk";
		else if(EvBilgi[evid][evkilit] == 1) durum = "Kilitli";

		if(EvBilgi[evid][evsatilik] == 0)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{CD5C5C}Ev Sahibi: {FFFFFF}%s\n{CD5C5C}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evsahip],durum);
		}
		else if(EvBilgi[evid][evsatilik] == 1)
		{
		    format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}Satýlýk\n{00FF7F}Ev Fiyatý: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);
		EvPickupYenile(evid);

		printf("");
		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // Yenilendi.",evid,EvBilgi[evid][evfiyat],durum);
	}
	return 1;
}

public EvYarat(evid,Float:X,Float:Y,Float:Z)
{
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

		if(EvBilgi[evid][evkilit] == 0) durum = "Açýk";
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
		    format(str,sizeof(str),"{FFFFFF}%s\n{00FF7F}Ev Durumu: {FFFFFF}Satýlýk\n{00FF7F}Ev Fiyatý: {FFFFFF}%i$\n{00FF7F}Kilit Durumu: {FFFFFF}%s",
			EvBilgi[evid][evaciklama],EvBilgi[evid][evfiyat],durum);
			Pickup[evid] = CreatePickup(GREENH,1,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z]);
			for(new a;a<MAX_PLAYERS;a++) if(IsPlayerConnected(a)) SetPlayerMapIcon(a,evid,EvBilgi[evid][ev_X],EvBilgi[evid][ev_Y],EvBilgi[evid][ev_Z],GREENMAP,0);
		}
		Update3DTextLabelText(TextLabel[evid],0xFFFFFFFF,str);

		printf("");
		printf("Ev ID: %i - Fiyat: %i - Kilit: %s // Oluþturuldu.",evid,EvBilgi[evid][evfiyat],durum);

        ToplamEv++;
	}
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
	return 1;
}

public EvKaydetInt(evid,bilgii[],deger)
{
    new dosya[64];
    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
    dini_IntSet(dosya,bilgii,deger);
	return 1;
}

public EvKaydetStr(evid,bilgii[],deger[])
{
    new dosya[64];
    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
    dini_Set(dosya,bilgii,deger);
	return 1;
}

public EvKaydetFloat(evid,bilgii[],Float:deger)
{
    new dosya[64];
    format(dosya,sizeof(dosya),"/Evler/ev%i.ini",evid);
    dini_FloatSet(dosya,bilgii,deger);
	return 1;
}

public SahipKontrol()
{
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

stock Mesaj(playerid,yazi[],{Float,_}:...)
{
	new str[256];
	new
        iArgs = numargs()
    ;
    while(--iArgs) {
		format(str,sizeof(str),"{FF4500}#Ev: {FFFFFF}%s",yazi,iArgs);
		SendClientMessage(playerid,-1,str);
    }
	return -1;
}

// - Oyuncu idi fonksiyonu
GetPlayerID(const PlayerName[])
{
 	new
   	        pName[MAX_PLAYER_NAME];
	for(new i = 0, j = GetMaxPlayers(); i != j; ++i)
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

// - Oyuncu adý fonksiyonu
stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
	return pname;
}

// - Silah adlarý
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
