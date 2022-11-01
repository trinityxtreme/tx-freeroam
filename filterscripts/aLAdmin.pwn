////////////////////////////////////////////////////////////////////////////////
// aLAdmin Yönetici Sistemi v1.2 ( +70 CMDs )                                 //
// aLypSe.                                                                    //
////////////////////////////////////////////////////////////////////////////////
// *Admins komutundaki buglar giderildi.
// *Adminlere 'Lv.5 Game Master' þeklinde textlabel eklendi.
// *Kendi GM Yazý formatý olan kiþiler için sistemdeki formatý kaldýran define
// özelliði eklendi.
////////////////////////////////////////////////////////////////////////////////
#include <a_samp>
#include <dini>

#pragma tabsize 0
#pragma dynamic 14900
////////////////////////////////////////////////////////////////////////////////
// Ayarlar
#define ANTI_FLOOD 		true	// Anti-Flood Açýk/Kapalý
#define ANTI_CAPS 		false	// Anti-Caps, Büyük Harf Engelleme Açýk/Kapalý
#define ANTI_PING 		true	// Anti-Ping, Yüksek Ping Engelleme Açýk/Kapalý
#define ANTI_BOT        true    // Anti-Bot, Botlara karþý koruma Açýk/Kapalý
#define ADMIN_CHAT      true	// Admin Chat Açýk/Kapalý
#define LD_MESSAGES     true	// Oyuncu Giriþ-Çýkýþ Yaptý Yazýsý Açýk/Kapalý
#define AUTO_LOGIN      false	// Otomatik Giriþ, eðer ayný IP ise.
#define HIGHLEVEL       true    // Eðer Açýksa Komutu Kendisinden Üst Levellere Kullanamaz.
#define LOAD_WEAPONS    true    // Oyuncu Spawn Olurken Kayýtlý Silahlarý Yükler.
#define ADMIN_MESSAGES  true    // Her Komut Ýçin Adminlere Giden Bilgi Mesajý
#define PID_PID         false	// Oyuncu Bazý Komutlarý Kendi Kendine Kullanabilir ( Örn: /mute [Kendi ID],/ban [Kendi ID],/jail [Kendi ID].. )

#define MAX_FLOOD 		5		// Max. Flood Sayýsý
#define MAX_WARN 		3		// Max. Uyarý Sayýsý
#define MAX_PING 		500		// Max. Ping Miktarý
#define MAX_FAIL 		3		// Max. Yanlýþ Þifre Girme
#define MAX_ADMINLEVEL  5		// Max. Admin Level
#define MAX_CONNECTIP   1       // Max. Bir IP Üzerinden Baðlantý Sýnýrý ( Anti-Bot açýkken çalýþýr )
#define SLAP_DAMAGE     3		// Slap Damage
#define ADMINCHAT       '!'     // Admin Chat Konuþmasý Ýçin En Baþa Yazýlmasý Gereken Karakter

#define FORMAT          false    // Chat Formatlama Açýk/Kapalý ( Eðer kendi GM Yazýsý sisteminizi kullanýyorsanýz kapatýn )
#define ADMINCHATFORMAT "{FF0000}[{FFFFFF}GM{FF0000}] %s ({FFFFFF}%d{FF0000}): {FFFFFF}%s" // Oyuncu Ýsmi,Oyuncu ID,Oyuncu Yazýsý ( Eðer formatlama açýksa )
#define CHATFORMAT 		"%s (%d): {FFFFFF}%s" // Oyuncu Ýsmi,Oyuncu ID,Oyuncu Yazýsý ( Eðer formatlama açýksa )

#define Jail_CordX 		223.431976  	// Jail Pos X
#define Jail_CordY 		1872.400268     // Jail Pos Y
#define Jail_CordZ 		13.734375       // Jail Pos Z
#define Jail_CordInt 	0       		// Jail Pos Interior
// Komut Level Ayarlarý ( +70 Komut )
#define k_stats         0
#define k_admins        0
#define k_back          0
#define k_report        0
#define k_saveskin      0
#define k_ayardim       1
#define k_kick	  		1
#define k_ban   		1
#define k_jail  		1
#define k_unjail  		1
#define k_warn          1
#define k_spec  		1
#define k_specoff  		1
#define k_awork 		1
#define k_eject 		1
#define k_burn      	1
#define k_ip        	1
#define k_asay      	1
#define k_announce  	1
#define k_goto      	1
#define k_get       	1
#define k_mute      	1
#define k_unmute    	1
#define k_freeze    	1
#define k_unfreeze  	1
#define k_slap      	1
#define k_clearchat 	1
#define k_setskin       1
#define k_setint        1
#define k_setworld      1
#define k_healall   	2
#define k_armourall 	2
#define k_setalltime    2
#define k_setallweather 2
#define k_reswarn       2
#define k_givemoney     2
#define k_giveallmoney  2
#define k_setmoney      2
#define k_setallmoney   2
#define k_setscore      2
#define k_givescore     2
#define k_givecar       2
#define k_car           2
#define k_showstats     2
#define k_setwanted     2
#define k_setallwanted  2
#define k_setallskin    2
#define k_gotols        2
#define k_gotosf        2
#define k_gotolv        2
#define k_sethealth     3
#define k_setarmour     3
#define k_akill         3
#define k_killall       3
#define k_kickall       3
#define k_disarm        3
#define k_disarmall     3
#define k_ejectall      3
#define k_spawn         3
#define k_spawnall      3
#define k_cmdmute       3
#define k_cmdunmute     3
#define k_giveweapon    4
#define k_giveallweapon 4
#define k_move          4
#define k_god           4
#define k_godcar        4
#define k_agod          4
#define k_inv           4
#define k_jetpack       4
#define k_makeadmin     5
#define k_restart       5
////////////////////////////////////////////////////////////////////////////////
#define DIALOG 			6234    					// Dialog Baþlangýç ID'si
#define DIALOG_BASLIK   "{FFFFFF}Trinity-Xtreme / {009BFF}Yönetici Sistemi" 	// Dialog Baþlýðý
#define VMENU 			DIALOG+100 					// Dialog Baþlangýç ID'si
#define d_input 		DIALOG_STYLE_INPUT
#define d_list 			DIALOG_STYLE_LIST
#define d_password 		DIALOG_STYLE_PASSWORD
#define d_msgbox 		DIALOG_STYLE_MSGBOX

#define PlayGoodSound(%1); PlayerPlaySound(%1,1057,0.0,0.0,0.0);
#define PlayBadSound(%1); PlayerPlaySound(%1,1058,0.0,0.0,0.0);
#define PlaySlapSound(%1); PlayerPlaySound(%1,1190,0.0,0.0,0.0);
////////////////////////////////////////////////////////////////////////////////
// Tanýtýmlar
new Text3D:AdminTextLabel[MAX_PLAYERS];
new bool:OyuncuSpawnOldu[MAX_PLAYERS];
new bool:OyuncuAdmin[MAX_PLAYERS];
new bool:OyuncuMute[MAX_PLAYERS];
new bool:OyuncuCMDMute[MAX_PLAYERS];
new bool:OyuncuFreeze[MAX_PLAYERS];
new bool:OyuncuSpec[MAX_PLAYERS];
new bool:aWork[MAX_PLAYERS];
new bool:OyuncuInvisible[MAX_PLAYERS];
new bool:OyuncuInv[MAX_PLAYERS];
new bool:OyuncuGod[MAX_PLAYERS];
new bool:OyuncuGodCar[MAX_PLAYERS];
new bool:OyuncuOldu[MAX_PLAYERS];
new	Float:BackX[MAX_PLAYERS];
new	Float:BackY[MAX_PLAYERS];
new	Float:BackZ[MAX_PLAYERS];
new	Float:BackA[MAX_PLAYERS];
new	BackInt[MAX_PLAYERS];
new OyuncuWarn[MAX_PLAYERS];
new OyuncuFlood[MAX_PLAYERS];
new OyuncuFailLogin[MAX_PLAYERS];
new OyuncuSpecID[MAX_PLAYERS];
new OyuncuCikisSebep[MAX_PLAYERS];
new OyuncuGiveCar[MAX_PLAYERS]=-1;
new OyuncuKickSebep[MAX_PLAYERS][128];
new OyuncuBanSebep[MAX_PLAYERS][128];
new SunucuRestartZaman=-1;
new RestartTimer;
////////////////////////////////////////////////////////////////////////////////
// Forwards
forward OyuncuBilgiYukle(playerid);
forward OyuncuBilgiKaydet(playerid);
forward OyuncuBilgiAl(playerid);
forward OyuncuSilahKaydet(playerid);
forward OyuncuSilahYukle(playerid);
forward OyuncuBackPos(playerid);
forward OyuncuBilgiSifirla(playerid);
forward AutoLogin(playerid);
forward StatsGoster(showid,playerid);
forward SureKontrol();
forward OyuncuGuncelle();
forward GodKontrol();
forward OyuncuKayitli(playerid);
forward IsAdmin(playerid,alevel);
forward SpecKontrol();
forward SunucuRestart();
forward aYardimSayfa1(playerid);
forward aYardimSayfa2(playerid);
forward HapisKontrol(playerid);
////////////////////////////////////////////////////////////////////////////////
// KayýtBilgi
enum KayitBilgi
{
	p_password,
	p_logged,
	p_money,
	p_skin,
	p_skinkaydet,
	p_adminlevel,
	p_score,
	p_fightstyle,
	p_kills,
	p_deaths,
	p_s0,
	p_s0ammo,
	p_s1,
	p_s1ammo,
	p_s2,
	p_s2ammo,
	p_s3,
	p_s3ammo,
	p_s4,
	p_s4ammo,
	p_s5,
	p_s5ammo,
	p_s6,
	p_s6ammo,
	p_s7,
	p_s7ammo,
	p_s8,
	p_s8ammo,
	p_s9,
	p_s9ammo,
	p_s10,
	p_s10ammo,
	p_s11,
	p_s11ammo,
	p_s12,
	p_s12ammo,
	a_jail,
	a_jailsure,
	a_ip[255]
};
new Oyuncu[MAX_PLAYERS][KayitBilgi];

new // Ryder Vehicle Spawner'dan alýntýdýr...
		g_VehNames[][] =
        {
                !"Landstalker", !"Bravura", !"Buffalo", !"Linerunner", !"Pereniel", !"Sentinel", !"Dumper", !"Firetruck", !"Trashmaster", !"Stretch", !"Manana", !"Infernus",
                !"Voodoo", !"Pony", !"Mule", !"Cheetah", !"Ambulance", !"Leviathan", !"Moonbeam", !"Esperanto", !"Taxi", !"Washington", !"Bobcat", !"Mr Whoopee", !"BF Injection",
                !"Hunter", !"Premier", !"Enforcer", !"Securicar", !"Banshee", !"Predator", !"Bus", !"Rhino", !"Barracks", !"Hotknife", !"Trailer", !"Previon", !"Coach", !"Cabbie",
                !"Stallion", !"Rumpo", !"RC Bandit", !"Romero", !"Packer", !"Monster", !"Admiral", !"Squalo", !"Seasparrow", !"Pizzaboy", !"Tram", !"Trailer", !"Turismo", !"Speeder",
                !"Reefer", !"Tropic", !"Flatbed", !"Yankee", !"Caddy", !"Solair", !"Berkley's RC Van", !"Skimmer", !"PCJ-600", !"Faggio", !"Freeway", !"RC Baron", !"RC Raider",
                !"Glendale", !"Oceanic", !"Sanchez", !"Sparrow", !"Patriot", !"Quad", !"Coastguard", !"Dinghy", !"Hermes", !"Sabre", !"Rustler", !"ZR3 50", !"Walton", !"Regina",
                !"Comet", !"BMX", !"Burrito", !"Camper", !"Marquis", !"Baggage", !"Dozer", !"Maverick", !"News Chopper", !"Rancher", !"FBI Rancher", !"Virgo", !"Greenwood",
                !"Jetmax", !"Hotring", !"Sandking", !"Blista Compact", !"Police Maverick", !"Boxville", !"Benson", !"Mesa", !"RC Goblin", !"Hotring Racer A", !"Hotring Racer B",
                !"Bloodring Banger", !"Rancher", !"Super GT", !"Elegant", !"Journey", !"Bike", !"Mountain Bike", !"Beagle", !"Cropdust", !"Stunt", !"Tanker", !"RoadTrain",
                !"Nebula", !"Majestic", !"Buccaneer", !"Shamal", !"Hydra", !"FCR-900", !"NRG-500", !"HPV1000", !"Cement Truck", !"Tow Truck", !"Fortune", !"Cadrona", !"FBI Truck",
                !"Willard", !"Forklift", !"Tractor", !"Combine", !"Feltzer", !"Remington", !"Slamvan", !"Blade", !"Freight", !"Streak", !"Vortex", !"Vincent", !"Bullet", !"Clover",
                !"Sadler", !"Firetruck", !"Hustler", !"Intruder", !"Primo", !"Cargobob", !"Tampa", !"Sunrise", !"Merit", !"Utility", !"Nevada", !"Yosemite", !"Windsor", !"Monster A",
                !"Monster B", !"Uranus", !"Jester", !"Sultan", !"Stratum", !"Elegy", !"Raindance", !"RC Tiger", !"Flash", !"Tahoma", !"Savanna", !"Bandito", !"Freight", !"Trailer",
                !"Kart", !"Mower", !"Duneride", !"Sweeper", !"Broadway", !"Tornado", !"AT-400", !"DFT-30", !"Huntley", !"Stafford", !"BF-400", !"Newsvan", !"Tug", !"Trailer A", !"Emperor",
                !"Wayfarer", !"Euros", !"Hotdog", !"Club", !"Trailer B", !"Trailer C", !"Andromada", !"Dodo", !"RC Cam", !"Launch", !"Police Car (LSPD)", !"Police Car (SFPD)",
                !"Police Car (LVPD)", !"Police Ranger", !"Picador", !"S.W.A.T. Van", !"Alpha", !"Phoenix", !"Glendale", !"Sadler", !"Luggage Trailer A", !"Luggage Trailer B",
                !"Stair Trailer", !"Boxville", !"Farm Plow", !"Utility Trailer"
        }
;

new PlayerColors[200] = {
0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,0xF4A460FF,
0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,
0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,
0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,
0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,
0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,
0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,
0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,
0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,0x3214AAFF,
0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,
0xD8C762FF,0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,
0xF4A460FF,0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,
0x10DC29FF,0x534081FF,0x0495CDFF,0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,
0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,
0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,
0x18F71FFF,0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,
0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,
0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,
0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,
0xDCDE3DFF,0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,
0xD8C762FF,0xD8C762FF
};
////////////////////////////////////////////////////////////////////////////////
#define BilgiID; \
		if(!strlen(tmp)) { new str[128]; format(str,sizeof(str),"%s [Player ID]",cmd); BilgiMesaj(playerid,str); return 1; }

#define BilgiDEGER; \
		if(!strlen(tmp)) { new str[128]; format(str,sizeof(str),"%s [Deðer]",cmd); BilgiMesaj(playerid,str); return 1; }

#define BilgiID_STR; \
		if(!strlen(tmp)) { new str[128]; format(str,sizeof(str),"%s [Player ID] [Yazý]",cmd); BilgiMesaj(playerid,str); return 1; }

#define BilgiID_INT; \
		if(!strlen(tmp)) { new str[128]; format(str,sizeof(str),"%s [Player ID] [Deðer]",cmd); BilgiMesaj(playerid,str); return 1; }

#define PlayerCommand(%1,%2) \
		if(strcmp(cmd, %1, true) == 0) { if(IsAdmin(playerid,%2))

#define EndCommand; \
        } else { HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1; } return 1;

#define PlayerCommand_ID(%1,%2) \
        if(strcmp(cmd, %1, true) == 0) { if(IsAdmin(playerid,%2)) { tmp = strtok(cmdtext,idx); BilgiID; new otherid = strval(tmp); if(IsPlayerConnected(otherid)) { if(otherid != INVALID_PLAYER_ID)

#define EndCommand_ID; \
		} } else HataMesaj(playerid,"Oyuncu çevrimiçi deðil..."); return 1; } else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;

#define PlayerCommand_DEGER(%1,%2) \
        if(strcmp(cmd, %1, true) == 0) { if(IsAdmin(playerid,%2)) { tmp = strtok(cmdtext,idx); BilgiDEGER; new deger = strval(tmp);

#define EndCommand_DEGER; \
		} } else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;

#define PlayerCommand_ID_STR(%1,%2) \
        if(strcmp(cmd, %1, true) == 0) { if(IsAdmin(playerid,%2)){tmp=strtok(cmdtext,idx);new otherid=strval(tmp);BilgiID_STR;new result[128];result=strrest(cmdtext,idx); if(!strlen(result)) { new str[128]; format(str,sizeof(str),"%s [Player ID] [Yazý]",cmd); BilgiMesaj(playerid,str); return 1; } if(IsPlayerConnected(otherid)) { if(otherid != INVALID_PLAYER_ID)

#define EndCommand_ID_STR; \
		} } else HataMesaj(playerid,"Oyuncu çevrimiçi deðil..."); return 1; } else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;

#define PlayerCommand_STR(%1,%2) \
        if(strcmp(cmd, %1, true) == 0) { if(IsAdmin(playerid,%2)) { new result[128]; result = strrest(cmdtext,idx); if(!strlen(result)) { new str[128]; format(str,sizeof(str),"%s [Yazý]",cmd); BilgiMesaj(playerid,str); return 1; }

#define EndCommand_STR; \
		} } else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;

#define PlayerCommand_ID_DEGER(%1,%2) \
        if(strcmp(cmd, %1, true) == 0) { if(IsAdmin(playerid,%2)) { tmp = strtok(cmdtext,idx); BilgiID_INT; new otherid = strval(tmp); tmp = strtok(cmdtext,idx); BilgiID_INT; new deger = strval(tmp); if(IsPlayerConnected(otherid)) { if(otherid != INVALID_PLAYER_ID)

#define EndCommand_ID_DEGER; \
		} } else HataMesaj(playerid,"Oyuncu çevrimiçi deðil..."); return 1; } else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;

#define TarihAl(); \
		new yil,ayy,gun,saat,dakika,saniye,ay[24]; getdate(yil,ayy,gun); gettime(saat,dakika,saniye); \
		if(ayy == 1) ay="Ocak"; else if(ayy == 2) ay="Þubat"; else if(ayy == 3) ay="Mart"; else if(ayy == 4) ay="Nisan"; else if(ayy == 5) ay="Mayýs"; \
		else if(ayy == 6) ay="Haziran"; else if(ayy == 7) ay="Temmuz"; else if(ayy == 8) ay="Aðustos"; else if(ayy == 9) ay="Eylül"; else if(ayy == 10) ay="Ekim"; \
		else if(ayy == 11) ay="Kasým"; else if(ayy == 12) ay="Aralýk";

#define AdminMesaj(%1); \
		OyuncuAdmin[playerid] = false; AdminMesajj(%1); OyuncuAdmin[playerid] = true;
////////////////////////////////////////////////////////////////////////////////
public OnFilterScriptInit()
{
	print("\n--------------------------------------------");
	print(" aLAdmin Yönetici Sistemi v1.2 ( +70 CMDs )");
	print(" Kodlayan: aLypSe.");
	print("--------------------------------------------\n");
	SetTimer("SpecKontrol",5000,1);
	SetTimer("OyuncuGuncelle",1000,1);
	SetTimer("GodKontrol",100,1);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	new dosya[64],str[256];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	EkranTemizle(playerid);
	if(Oyuncu[playerid][p_logged] != 1)
	{
		if(!OyuncuKayitli(playerid))
		{
		    format(str,sizeof(str),"{FFFFFF}Servera hoþgeldiniz, {0080FF}%s\n\n{FFFFFF}Sunucuda kayýtlý görünmüyorsunuz,\nLütfen aþaðýya yeni þifrenizi yazarak kaydýnýzý oluþturunuz.",PlayerName(playerid));
		    Dialog(playerid,DIALOG,d_password,str,"Kayýt","Ýptal");
		}
		else
		{
		    #if AUTO_LOGIN == true
			if(!strcmp(PlayerIP(playerid),dini_Get(dosya,"p_ip"))) return AutoLogin(playerid);
			#endif
		    format(str,sizeof(str),"{FFFFFF}Servera hoþgeldiniz, {0080FF}%s\n\n{FFFFFF}Sunucuda kayýtlý görünüyorsunuz,\nLütfen aþaðýya þifrenizi yazarak giriþ yapýnýz.",PlayerName(playerid));
		    Dialog(playerid,DIALOG+1,d_password,str,"Giriþ","Ýptal");
		}
	    return 0;
	}
    return 1;
}

public OnPlayerConnect(playerid)
{
	#if ANTI_BOT == true
	new connect_ip[32+1];
	GetPlayerIp(playerid,connect_ip,32);
	new adet_ip = GetMaxIP(connect_ip);
	if(adet_ip > MAX_CONNECTIP) {
		printf("\nAnti-Bot: (%s) bot tespit edildi ve ip ban atýldý.\n", connect_ip);
	    BanEx(playerid,"Anti-Bot Sistemi Tarafýndan Banlandý!");
	    return 1;
	}
	#endif
	SetPlayerColor(playerid,PlayerColors[random(201)]);
	#if LD_MESSAGES == true
	new str[128];
	format(str,sizeof(str),"*** %s(%d) isimli oyuncu sunucuya giriþ yaptý.",PlayerName(playerid),playerid);
	SendClientMessageToAll(0x00FF00FF,str);
	#endif
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	#if LD_MESSAGES == true
	if(reason==0) OyuncuCikisSebep[playerid] = 0;
	if(reason==1) OyuncuCikisSebep[playerid] = 1;

	new str[256];
	switch(OyuncuCikisSebep[playerid])
	{
	    case 0: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Zaman Aþýmý/Crash )"		,PlayerName(playerid));
	    case 1: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Kendi Ýsteðiyle )"		,PlayerName(playerid));
	    case 2: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Kicked: %s )"				,PlayerName(playerid),OyuncuKickSebep[playerid]);
	    case 3: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Banned: %s )"				,PlayerName(playerid),OyuncuBanSebep[playerid]);
	    case 4: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Fail Login )"				,PlayerName(playerid));
	    case 5: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Kayýtsýz Giriþ )"			,PlayerName(playerid));
	    case 6: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( Sunucu Restart )"			,PlayerName(playerid));
	    case 7: format(str,sizeof(str),"*** %s isimli oyuncu sunucudan çýkýþ yaptý. ( %d/Max.%d Yüksek Ping )"	,PlayerName(playerid),GetPlayerPing(playerid),MAX_PING);
	}
	SendClientMessageToAll(0xFF0000FF,str);
	OyuncuCikisSebep[playerid] = -1;
	#endif

	new iVehID = GetPVarInt(playerid, "iVehID");
	if(iVehID) DestroyVehicle(iVehID);
	if(OyuncuAdmin[playerid] == true) Delete3DTextLabel(AdminTextLabel[playerid]);

	OyuncuSpawnOldu[playerid]   = false;
	OyuncuAdmin[playerid]       = false;
	OyuncuMute[playerid]	 	= false;
	OyuncuCMDMute[playerid]     = false;
	OyuncuFreeze[playerid]	 	= false;
	aWork[playerid]			 	= false;
	OyuncuInvisible[playerid]   = false;
	OyuncuGod[playerid]         = false;
	OyuncuGodCar[playerid]      = false;
	OyuncuOldu[playerid]        = false;
	OyuncuSpec[playerid] 		= false;
	OyuncuWarn[playerid]	 	= 0;
	OyuncuFlood[playerid]	 	= 0;
	OyuncuFailLogin[playerid]	= 0;
	OyuncuGiveCar[playerid]     = -1;
	OyuncuSpecID[playerid] 		= -1;
	OyuncuKickSebep[playerid]   = "";
	OyuncuBanSebep[playerid]	= "";
	OyuncuBilgiSifirla(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Oyuncu[playerid][p_logged] == 1)
	{
		if(OyuncuOldu[playerid] == true)
		{
		    BilgiMesaj(playerid,"Öldüðünüz yere dönmek için '/back' komutunu kullanabilirsiniz...");
		}
		if(OyuncuGod[playerid] == true)
		{
			new str[128];
			format(str,sizeof(str),"%s isimli oyuncu god mod'u deaktif etti!");
		    AdminMesaj(str);
		    HataMesaj(playerid,"Öldüðünüz için god mod deaktif edildi!");
		    OyuncuGod[playerid] = false;
		}
	   	if(OyuncuGodCar[playerid] == true)
		{
			new str[128];
			format(str,sizeof(str),"%s isimli admin god-car'ý deaktif etti!");
		    AdminMesaj(str);
		    HataMesaj(playerid,"Öldüðünüz için god-car deaktif edildi!");
		    OyuncuGodCar[playerid] = false;
		}
		OyuncuBilgiYukle(playerid);
		#if LOAD_WEAPONS == true
		OyuncuSilahYukle(playerid);
		#endif
		OyuncuSpawnOldu[playerid]=true;
		if(OyuncuAdmin[playerid] == true) {
		    new str[64];
		    format(str,sizeof(str),"{FF0000}Lv.%d Game Master",Oyuncu[playerid][p_adminlevel]);
		    Delete3DTextLabel(AdminTextLabel[playerid]);
		    AdminTextLabel[playerid] = Create3DTextLabel(str,-1,0,0,0,30,0);
		}
		SetTimerEx("HapisKontrol",1000,0,"i",playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new Float:X,Float:Y,Float:Z,Float:A;
	GetPlayerPos(playerid,X,Y,Z);
	GetPlayerFacingAngle(playerid,A);
	BackX[playerid] = X;
	BackY[playerid] = Y;
	BackZ[playerid] = Z;
	BackA[playerid] = A;
	BackInt[playerid] = GetPlayerInterior(playerid);
	OyuncuOldu[playerid] = true;
	
	KaydetINT(playerid,"p_deaths",Oyuncu[playerid][p_deaths]+1);
	KaydetINT(killerid,"p_kills",Oyuncu[playerid][p_kills]+1);
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
	if(OyuncuMute[playerid]==true)
	{
		SendClientMessage(playerid,0xFF0000FF,"HATA: {FFFFFF}Mute olduðunuz için konuþma hakkýnýz yok!");
		return 0;
	}
	#if ADMIN_CHAT == true
	if(text[0] == ADMINCHAT)
	{
	    if(IsAdmin(playerid,1))
	    {
	    	for(new i;i<MAX_PLAYERS;i++)
	    	{
		    	if(OyuncuAdmin[i] == true)
		    	{
					new str[512];
					format(str,sizeof(str),"{FF0000}[Lv.{c0c0c0}%d {FF0000}AdminChat] %s: {c0c0c0}%s",Oyuncu[playerid][p_adminlevel],PlayerName(playerid),text[1]);
					SendClientMessage(i,-1,str);
					PlayGoodSound(i);
					return 0;
				}
			}
	    }
	}
	#endif
	#if ANTI_FLOOD == true
	if(OyuncuFlood[playerid] < MAX_FLOOD && !IsAdmin(playerid,1)) OyuncuFlood[playerid]++;
	if(OyuncuFlood[playerid] == MAX_FLOOD) { HataMesaj(playerid,"Lütfen flood yapmayýnýz..."); return 0; }
	#endif
	#if FORMAT == true
		#if ANTI_CAPS == true
		if(IsAdmin(playerid,1)) {
			new str[256];
			format(str,sizeof(str),ADMINCHATFORMAT,PlayerName(playerid),playerid,text);
			SendClientMessageToAll(GetPlayerColor(playerid),str);
		} else {
			new str[256];
			format(str,sizeof(str),CHATFORMAT,PlayerName(playerid),playerid,Lower(text));
			SendClientMessageToAll(GetPlayerColor(playerid),str);
		}
		#else
		if(IsAdmin(playerid,1)) {
			new str[256];
			format(str,sizeof(str),ADMINCHATFORMAT,PlayerName(playerid),playerid,text);
			SendClientMessageToAll(GetPlayerColor(playerid),str);
		} else {
			new str[256];
			format(str,sizeof(str),CHATFORMAT,PlayerName(playerid),playerid,text);
			SendClientMessageToAll(GetPlayerColor(playerid),str);
		}
		#endif
	return 0;
	#else
	return 1;
	#endif
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256];
	new tmp[228];
	new adminmsg[256];
	new idx;
	cmd = strtok(cmdtext, idx);

	if(OyuncuMute[playerid]==true && !IsAdmin(playerid,1)) { SendClientMessage(playerid,0xFF0000FF,"HATA: {FFFFFF}Mute olduðunuz için komut kullanma hakkýnýz yok!"); return -1; }
	if(OyuncuCMDMute[playerid]==true && !IsAdmin(playerid,1)) { SendClientMessage(playerid,0xFF0000FF,"HATA: {FFFFFF}Mute olduðunuz için komut kullanma hakkýnýz yok!"); return -1; }

	if(!strcmp(cmdtext, "/v", true, 2))
	{
		if(cmdtext[2] == EOS) return 0;
		new iList = strval(cmdtext[2]) - 1;
		if(0 <= iList <= 17)
		{
			static s_szName[24],s_szVehDialog[256];
			s_szVehDialog = "";
			for(new i = (iList * 12), j = ((iList + 1) * 12); i < j; ++i)
			{
				if(i >= sizeof(g_VehNames))
				break;
				strunpack(s_szName, g_VehNames[i]);
				strcat(s_szVehDialog, s_szName);
				strcat(s_szVehDialog, "\n");
			}
			ShowPlayerDialog(playerid, (VMENU + iList), DIALOG_STYLE_LIST, "Arac Listesi", s_szVehDialog, "Sec", "Kapat");
			SetPVarInt(playerid, "iList", iList);
			return 1;
		}
		return 0;
	}
	PlayerCommand("/stats",k_stats)
	{
	    StatsGoster(playerid,playerid);
	    PlayGoodSound(playerid);
		EndCommand;
	}
	PlayerCommand("/back",k_back)
	{
	    if(OyuncuOldu[playerid] == true)
	    {
		    OyuncuBackPos(playerid);
		    PlayGoodSound(playerid);
		    OyuncuOldu[playerid] = false;
		} else HataMesaj(playerid,"Ölmeden bu komutu kullanamazsýnýz!");
		EndCommand;
	}
	PlayerCommand("/admins",k_admins)
	{
        new str[1024],admin[256],durum[32],toplamadmin;
		strcat(str,"{CD5C5C}-------------------------------------------------------------------\n");
		strcat(str,"Online Adminler:\n");
		strcat(str,"-------------------------------------------------------------------\n");
		strcat(str,"{CD5C5C}ID\tNick\t\tLevel\t\tDurum\n");
		for(new i;i<MAX_PLAYERS;i++)
		{
		    if(IsAdmin(i,1))
		    {
				if(aWork[i] == false) durum = "{FF0000}Meþgul";
				else if(aWork[i] == true) durum = "{00FF00}Müsait";
				if(strlen(PlayerName(i)) > 8)
			        format(admin,sizeof(admin),"{C0C0C0}%i\t%s\t%d\t\t%s\n",i,PlayerName(i),Oyuncu[i][p_adminlevel],durum);
				else
			        format(admin,sizeof(admin),"{C0C0C0}%i\t%s\t\t%d\t\t%s\n",i,PlayerName(i),Oyuncu[i][p_adminlevel],durum);
				strcat(str,admin);
				toplamadmin++;
		    }
		}
		if(toplamadmin==0) strcat(str,"{C0C0C0}Online admin yok!\n");
		strcat(str,"{CD5C5C}-------------------------------------------------------------------");
        Dialog(playerid,DIALOG+3,d_msgbox,str,"Tamam","");
	    PlayGoodSound(playerid);
		EndCommand;
	}
	PlayerCommand_ID_STR("/report",k_report)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    new str[1024];
	    format(str,sizeof(str),"{F0E68C}RAPOR: {FF0000}%s(%d) {FFFFFF}isimli oyuncu {FF0000}%s(%d) {FFFFFF}isimli oyuncuyu rapor etti. (Sebep: {FF0000}%s {FFFFFF})",PlayerName(playerid),playerid,PlayerName(otherid),otherid,result);
		for(new i;i<MAX_PLAYERS;i++) if(IsAdmin(i,1)) SendClientMessage(i,-1,str);
		BilgiMesaj(playerid,"Raporunuz yetkili yöneticilere gönderildi!");
		EndCommand_ID_STR;
	}
	PlayerCommand("/saveskin",k_saveskin)
	{
	    if(Oyuncu[playerid][p_skinkaydet] == 0) Dialog(playerid,DIALOG+4,d_msgbox,"{FFFFFF}Geçerli skini kaydedip, her giriþinizde hatýrlamasýný istiyor musunuz ?","Evet","Ýptal");
	    else Dialog(playerid,DIALOG+5,d_msgbox,"{FFFFFF}Kaydedilen skini silip, her giriþte baþka skin seçmek istiyor musunuz ?","Evet","Ýptal");
	    EndCommand;
	}
	PlayerCommand("/ayardim",k_ayardim)
	{
		aYardimSayfa1(playerid);
		EndCommand;
	}
	PlayerCommand_ID_STR("/kick",k_kick)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu oyundan attý. ( Sebep: %s )",PlayerName(playerid),playerid,PlayerName(otherid),otherid,result);
		AdminMesaj(adminmsg);
		BilgiMesaj(playerid,"Oyuncuyu sunucudan attýnýz.");
		OyuncuKickSebep[otherid] = result;
		KickPlayer(playerid,otherid,result);
		EndCommand_ID_STR;
	}
	PlayerCommand_ID_STR("/ban",k_ban)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu oyundan yasakladý. ( Sebep: %s )",PlayerName(playerid),playerid,PlayerName(otherid),otherid,result);
		AdminMesaj(adminmsg);
		BilgiMesaj(playerid,"Oyuncuyu sunucudan yasakladýnýz.");
		OyuncuBanSebep[otherid] = result;
		BanPlayer(playerid,otherid,result);
		EndCommand_ID_STR;
	}
	PlayerCommand("/awork",k_awork)
	{
	    if(aWork[playerid] == false)
		{
			aWork[playerid] = true;
			BilgiMesaj(playerid,"Durumunuzu müsait olarak deðiþtirdiniz!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin durumunu müsait olarak deðiþtirdi!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
		else if(aWork[playerid] == true)
		{
			aWork[playerid] = false;
			BilgiMesaj(playerid,"Durumunuzu meþgul olarak deðiþtirdiniz!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin durumunu meþgul olarak deðiþtirdi!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
	    EndCommand;
	}
	PlayerCommand_ID("/eject",k_eject)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(IsPlayerInAnyVehicle(otherid))
	    {
			new Float:X,Float:Y,Float:Z,Float:A;
			GetPlayerPos(otherid,X,Y,Z);
			GetPlayerFacingAngle(otherid,A);
			SetPlayerPos(otherid,X,Y,Z+2);
			UyariMesaj(otherid,"Admin tarafýndan araçtan atýldýnýz!");
			BilgiMesaj(playerid,"Oyuncuyu araçtan attýnýz!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu araçtan attý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
			AdminMesaj(adminmsg);
	    } else HataMesaj(playerid,"Oyuncu araçta deðil!");
	    EndCommand_ID;
	}
	PlayerCommand_ID("/burn",k_burn)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(otherid,X,Y,Z);
		CreateExplosion(X,Y,Z,0,1);
		UyariMesaj(otherid,"Admin tarafýndan yakýldýnýz!");
		BilgiMesaj(playerid,"Oyuncuyu yaktýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu yaktý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/ip",k_ip)
	{
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli oyuncunun IP'si: %s",PlayerName(otherid),otherid,PlayerIP(otherid));
		BilgiMesaj(playerid,adminmsg);
		PlayGoodSound(playerid);
	    EndCommand_ID;
	}
	PlayerCommand_STR("/asay",k_asay)
	{
		format(adminmsg,sizeof(adminmsg),"{6698FF}* Lv.%d Admin %s(%d): %s",Oyuncu[playerid][p_adminlevel],PlayerName(playerid),playerid,result);
		SendClientMessageToAll(-1,adminmsg);
		PlayGoodSound(playerid);
	    EndCommand_STR;
	}
	PlayerCommand_STR("/announce",k_announce)
	{
		GameTextForAll(result,6000,3);
		PlayGoodSound(playerid);
	    EndCommand_STR;
	}
	PlayerCommand_ID("/goto",k_goto)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(otherid,X,Y,Z);
		SetPlayerPos(playerid,X+3,Y,Z+0.5);
		SetPlayerInterior(playerid,GetPlayerInterior(otherid));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(otherid));
		BilgiMesaj(playerid,"Oyuncuya ýþýnlandýnýz!");
		UyariMesaj(otherid,"Admin yanýnýza ýþýnlandý!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun yanýna ýþýnlandý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/get",k_get)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(playerid,X,Y,Z);
		SetPlayerPos(otherid,X+3,Y,Z+0.5);
		SetPlayerInterior(otherid,GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(otherid,GetPlayerVirtualWorld(playerid));
		BilgiMesaj(playerid,"Oyuncuyu yanýnýza çektiniz!");
		UyariMesaj(otherid,"Admin sizi yanýnýza çekti!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu yanýna çekti!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/mute",k_mute)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuMute[otherid] == true) return HataMesaj(playerid,"Oyuncu zaten susturulmuþ!");
		OyuncuMute[otherid] = true;
		BilgiMesaj(playerid,"Oyuncuyu susturdunuz!");
		UyariMesaj(otherid,"Admin tarafýndan susturuldunuz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun konuþmasýný engelledi/susturdu!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/unmute",k_unmute)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuMute[otherid] == false) return HataMesaj(playerid,"Bu oyuncu susturulmamýþ!");
		OyuncuMute[otherid] = false;
		BilgiMesaj(playerid,"Oyuncunun konuþma engelini kaldýrdýnýz!");
		UyariMesaj(otherid,"Admin tarafýndan susturulmanýz kaldýrýldý!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun konuþmasýný açtý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/freeze",k_freeze)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuFreeze[otherid] == true) return HataMesaj(playerid,"Oyuncu zaten donmuþ!");
		OyuncuFreeze[otherid] = true;
		TogglePlayerControllable(otherid,false);
		BilgiMesaj(playerid,"Oyuncuyu dondurdunuz!");
		UyariMesaj(otherid,"Admin tarafýndan donduruldunuz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu dondurdu!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/unfreeze",k_unfreeze)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuFreeze[otherid] == false) return HataMesaj(playerid,"Oyuncu zaten çözülmüþ!");
		OyuncuFreeze[otherid] = false;
		TogglePlayerControllable(otherid,true);
		BilgiMesaj(playerid,"Oyuncuyu çözdünüz!");
		UyariMesaj(otherid,"Admin tarafýndan çözüldünüz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu çözdü!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand("/clearchat",k_clearchat)
	{
	    for(new i;i<MAX_PLAYERS;i++) EkranTemizle(i), UyariMesaj(i,"Admin tarafýndan chat ekraný temizlendi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin chat ekranýný temizledi!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand_ID_DEGER("/setskin",k_setskin)
	{
	    if(deger < 0 || deger > 299) return HataMesaj(playerid,"Lütfen geçerli bir skin id giriniz!");
		SetPlayerSkin(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun skinini deðiþtirdiniz!");
		UyariMesaj(otherid,"Admin tarafýndan skininiz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun skinini %d olarak ayarladý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID_DEGER("/setint",k_setint)
	{
		SetPlayerInterior(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun interiorunu deðiþtirdiniz!");
		UyariMesaj(otherid,"Admin tarafýndan interior id'niz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun interior id'sini %d olarak ayarladý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID_DEGER("/setworld",k_setworld)
	{
		SetPlayerInterior(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun virtual world'unu deðiþtirdiniz!");
		UyariMesaj(otherid,"Admin tarafýndan virtual world'unuz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun virtual world'unu %d olarak ayarladý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand("/healall",k_healall)
	{
	    for(new i;i<MAX_PLAYERS;i++) SetPlayerHealth(i,100), UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn saðlýðý dolduruldu!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn saðlýðýný doldurdu!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand("/armourall",k_armourall)
	{
	    for(new i;i<MAX_PLAYERS;i++) SetPlayerArmour(i,100), UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn zýrhý dolduruldu!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn zýrhý doldurdu!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand_DEGER("/setalltime",k_setalltime)
	{
	    if(deger < 0 || deger > 24) return HataMesaj(playerid,"Lütfen geçerli bir saat giriniz!");
	    for(new i;i<MAX_PLAYERS;i++) SetPlayerTime(i,deger,00), UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn saati deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn saatini %d olarak deðiþtirildi!",PlayerName(playerid),playerid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_DEGER;
	}
	PlayerCommand_DEGER("/setallweather",k_setallweather)
	{
	    for(new i;i<MAX_PLAYERS;i++) SetPlayerWeather(i,deger), UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn hava durumu deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn hava durumunu %d olarak deðiþtirildi!",PlayerName(playerid),playerid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_DEGER;
	}
	PlayerCommand_ID_DEGER("/givemoney",k_givemoney)
	{
		GivePlayerMoney(otherid,deger);
		BilgiMesaj(playerid,"Oyuncuya para gönderildi!");
		UyariMesaj(otherid,"Admin tarafýndan size para gönderildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuya %i$ gönderdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_DEGER("/giveallmoney",k_giveallmoney)
	{
		for(new i;i<MAX_PLAYERS;i++) GivePlayerMoney(i,deger), UyariMesaj(i,"Admin tarafýndan bütün Hesaplara para gönderildi!");
		BilgiMesaj(playerid,"Bütün Hesaplara para gönderildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplara %i$ gönderdi!",PlayerName(playerid),playerid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_DEGER;
	}
	PlayerCommand_ID_DEGER("/setmoney",k_setmoney)
	{
	    ResetPlayerMoney(otherid);
		GivePlayerMoney(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun parasý deðiþtirildi!");
		UyariMesaj(otherid,"Admin tarafýndan paranýz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun parasýný %i$ olarak deðiþtirdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_DEGER("/setallmoney",k_setallmoney)
	{
		for(new i;i<MAX_PLAYERS;i++) ResetPlayerMoney(i), GivePlayerMoney(i,deger), UyariMesaj(i,"Admin tarafýndan bütün Hesaplara para gönderildi!");
		BilgiMesaj(playerid,"Bütün Hesaplarýn parasý deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn parasýný %i$ olarak deðiþtirdi!",PlayerName(playerid),playerid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_DEGER;
	}
	PlayerCommand_ID_DEGER("/setscore",k_setscore)
	{
		SetPlayerScore(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun skoru deðiþtirildi!");
		UyariMesaj(otherid,"Admin tarafýndan skorunuz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun skorunu %d olarak deðiþtirdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID_DEGER("/givescore",k_givescore)
	{
	    new pscore = GetPlayerScore(otherid);
		SetPlayerScore(otherid,pscore+deger);
		BilgiMesaj(playerid,"Oyuncuya skor verildi!");
		UyariMesaj(otherid,"Admin tarafýndan skor aldýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuya %d skor gönderdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID_DEGER("/givecar",k_givecar)
	{
		if(IsPlayerInAnyVehicle(otherid)) return HataMesaj(playerid,"Oyuncu zaten bir araçta!");
		if(deger < 400 || deger > 611) return HataMesaj(playerid,"Lütfen geçerli bir araç id giriniz!");
		new Float:X,Float:Y,Float:Z,Float:A;
		GetPlayerPos(otherid,X,Y,Z);
		GetPlayerFacingAngle(otherid,A);
		OyuncuGiveCar[otherid] = CreateVehicle(deger,X,Y,Z+1,A,0,1,1000000);
		PutPlayerInVehicle(otherid,OyuncuGiveCar[otherid],0);
		BilgiMesaj(playerid,"Oyuncuya araç verildi!");
		UyariMesaj(otherid,"Admin tarafýndan size araç verildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuya %d ID araç verdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_DEGER("/car",k_car)
	{
		if(IsPlayerInAnyVehicle(playerid)) return HataMesaj(playerid,"Zaten bir araçtasýn!");
		if(deger < 400 || deger > 611) return HataMesaj(playerid,"Lütfen geçerli bir araç id giriniz!");
		new Float:X,Float:Y,Float:Z,Float:A;
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid,A);
		OyuncuGiveCar[playerid] = CreateVehicle(deger,X,Y,Z+1,A,0,1,1000000);
		PutPlayerInVehicle(playerid,OyuncuGiveCar[playerid],0);
		BilgiMesaj(playerid,"Araç spawn edildi!");
	    EndCommand_DEGER;
	}
	PlayerCommand_ID_DEGER("/setwanted",k_setwanted)
	{
	    if(deger < 0 || deger > 6) return HataMesaj(playerid,"Lütfen geçerli bir level giriniz!");
		SetPlayerWantedLevel(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun wanted levelini deðiþtirildi!");
		UyariMesaj(otherid,"Admin tarafýndan wanted leveliniz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun wanted levelini %d olarak deðiþtirdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_DEGER("/setallwanted",k_setallwanted)
	{
	    if(deger < 0 || deger > 6) return HataMesaj(playerid,"Lütfen geçerli bir level giriniz!");
		for(new i;i<MAX_PLAYERS;i++) SetPlayerWantedLevel(i,deger), UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn wanted leveli deðiþtirildi!");
		BilgiMesaj(playerid,"Bütün Hesaplarýn wanted leveli deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn wanted levelini %d olarak deðiþtirdi!",PlayerName(playerid),playerid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_DEGER;
	}
	PlayerCommand_DEGER("/setallskin",k_setallskin)
	{
	    if(deger < 0 || deger > 299) return HataMesaj(playerid,"Lütfen geçerli bir skin id giriniz!");
		for(new i;i<MAX_PLAYERS;i++) SetPlayerSkin(i,deger), UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn skini deðiþtirildi!");
		BilgiMesaj(playerid,"Bütün Hesaplarýn skini deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn skinini %d olarak deðiþtirdi!",PlayerName(playerid),playerid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_DEGER;
	}
	PlayerCommand_ID_DEGER("/sethealth",k_sethealth)
	{
	    if(deger < 0 || deger > 500) return HataMesaj(playerid,"Saðlýðý daha fazla veremezsiniz!");
		SetPlayerHealth(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun saðlýðý deðiþtirildi!");
		UyariMesaj(otherid,"Admin tarafýndan saðlýðýnýz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun saðlýðýný %d olarak deðiþtirdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID_DEGER("/setarmour",k_setarmour)
	{
	    if(deger < 0 || deger > 500) return HataMesaj(playerid,"Zýrhý daha fazla veremezsiniz!");
		SetPlayerArmour(otherid,deger);
		BilgiMesaj(playerid,"Oyuncunun zýrhý deðiþtirildi!");
		UyariMesaj(otherid,"Admin tarafýndan zýrhýnýz deðiþtirildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun zýrhýný %d olarak deðiþtirdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
		AdminMesaj(adminmsg);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID("/akill",k_akill)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		SetPlayerHealth(otherid,0);
		UyariMesaj(otherid,"Admin tarafýndan kill çekildi!");
		BilgiMesaj(playerid,"Oyuncuya kill çekildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuya kill çekti!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand("/killall",k_killall)
	{
		for(new i;i<MAX_PLAYERS;i++) SetPlayerHealth(i,0),UyariMesaj(i,"Admin tarafýndan bütün Hesaplara kill çekildi!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplara kill çekti!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand_STR("/kickall",k_kickall)
	{
		for(new i;i<MAX_PLAYERS;i++) if(!IsAdmin(i,1)) KickPlayer(playerid,i,result);
		BilgiMesaj(playerid,"Yönetici olmayan bütün Hesaplar sunucudan atýldý!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarý sunucudan attý!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand_STR;
	}
	PlayerCommand_ID("/disarm",k_disarm)
	{
		ResetPlayerWeapons(otherid);
		UyariMesaj(otherid,"Admin tarafýndan silahlarýnýz kaldýrýldý!");
		BilgiMesaj(playerid,"Oyuncunun silahlarýný kaldýrdýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun silahlarýný kaldýrdý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand("/disarmall",k_disarmall)
	{
		for(new i;i<MAX_PLAYERS;i++) ResetPlayerWeapons(i),UyariMesaj(i,"Admin tarafýndan bütün Hesaplarýn silahlarý kaldýrýldý!");
		BilgiMesaj(playerid,"Bütün Hesaplarýn silahlarýný kaldýrdýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarýn silahlarýný kaldýrdý!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand("/ejectall",k_ejectall)
	{
	    for(new i;i<MAX_PLAYERS;i++)
	    {
	   	    if(IsPlayerInAnyVehicle(i))
		    {
				new Float:X,Float:Y,Float:Z,Float:A;
				GetPlayerPos(i,X,Y,Z);
				GetPlayerFacingAngle(i,A);
				SetPlayerPos(i,X,Y,Z+2);
		    }
	    }
		BilgiMesaj(playerid,"Bütün Hesaplarý araçtan attýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarý araçtan attý!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand_ID("/spawn",k_spawn)
	{
		SpawnPlayer(otherid);
		UyariMesaj(otherid,"Admin tarafýndan spawn oldunuz!");
		BilgiMesaj(playerid,"Oyuncuyu spawn ettiniz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu spawn etti!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand("/spawnall",k_spawnall)
	{
	    for(new i;i<MAX_PLAYERS;i++) SpawnPlayer(i);
		BilgiMesaj(playerid,"Bütün Hesaplarý spawnladýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplarý spawnladý!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
	    EndCommand;
	}
	PlayerCommand_ID("/cmdmute",k_cmdmute)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuCMDMute[playerid] == true) return HataMesaj(playerid,"Oyuncu zaten cmd susturulmuþ!");
		OyuncuCMDMute[playerid] = true;
		UyariMesaj(otherid,"Admin tarafýndan komut kullanýmýnýz engellendi!");
		BilgiMesaj(playerid,"Oyuncunun komut kullanýmýný engellediniz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun komut kullanýmýný engelledi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand_ID("/cmdunmute",k_cmdunmute)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuCMDMute[playerid] == false) return HataMesaj(playerid,"Oyuncu cmd mute deðil!");
		OyuncuCMDMute[playerid] = false;
		UyariMesaj(otherid,"Admin tarafýndan komut kullanýmýnýz açýldý!");
		BilgiMesaj(playerid,"Oyuncunun komut kullanýmýný açtýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun komut kullanýmýný açtý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
	    EndCommand_ID;
	}
	PlayerCommand("/god",k_god)
	{
		if(OyuncuGod[playerid] == false)
		{
		    OyuncuGod[playerid] = true;
		    SetPlayerHealth(playerid,9999999);
		    BilgiMesaj(playerid,"God-Mode aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin god modu aktif etti!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
		else
		{
		    OyuncuGod[playerid] = false;
		    SetPlayerHealth(playerid,100);
		    BilgiMesaj(playerid,"God-Mode de-aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin god modu de-aktif etti!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
	    EndCommand;
	}
	PlayerCommand("/godcar",k_godcar)
	{
		if(OyuncuGodCar[playerid] == false)
		{
		    OyuncuGodCar[playerid] = true;
		    BilgiMesaj(playerid,"GodCar-Mode aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin god-car modu aktif etti!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
		else
		{
		    OyuncuGodCar[playerid] = false;
		    BilgiMesaj(playerid,"GodCar-Mode de-aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin god-car modu de-aktif etti!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
	    EndCommand;
	}
	PlayerCommand_ID("/agod",k_agod)
	{
		if(OyuncuGod[otherid] == false)
		{
		    OyuncuGod[otherid] = true;
		    SetPlayerHealth(otherid,9999999);
		    UyariMesaj(otherid,"God-Mode aktif!");
		    BilgiMesaj(playerid,"Oyuncunun God-Mode aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun god mod'unu aktif etti!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
			AdminMesaj(adminmsg);
		}
		else
		{
		    OyuncuGod[otherid] = false;
		    SetPlayerHealth(otherid,100);
		    UyariMesaj(otherid,"God-Mode de-aktif!");
		    BilgiMesaj(playerid,"Oyuncunun God-Mode de-aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun god mod'unu de-aktif etti!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
			AdminMesaj(adminmsg);
		}
	    EndCommand_ID;
	}
	PlayerCommand("/inv",k_inv)
	{
		if(OyuncuInv[playerid] == false)
		{
		    OyuncuInv[playerid] = true;
		    SetPlayerColor(playerid,0xFFFFFF00);
		    BilgiMesaj(playerid,"Görünmezlik aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin görünmezliði aktif etti!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
		else
		{
		    OyuncuInv[playerid] = false;
		    SetPlayerColor(playerid,PlayerColors[random(201)]);
		    BilgiMesaj(playerid,"Görünmezlik de-aktif!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin görünmezliði de-aktif etti!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		}
	    EndCommand;
	}
    if(strcmp(cmd, "/jail", true) == 0)
	{
		if(IsAdmin(playerid,k_jail))
		{
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Player ID] [Dakika] [Sebep]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new otherid = strval(tmp);
			
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Player ID] [Dakika] [Sebep]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new deger = strval(tmp);
			
			new result[128];
			result = strrest(cmdtext,idx);
			if(!strlen(result))
			{
				new str[128];
				format(str,sizeof(str),"%s [Player ID] [Dakika] [Sebep]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			if(IsPlayerConnected(otherid))
			{
				if(otherid != INVALID_PLAYER_ID)
				{
					#if HIGHLEVEL == true
					if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
					#endif
					#if PID_PID == false
					if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
					#endif
					if(deger < 0) return HataMesaj(playerid,"Lütfen geçerli bir sayý giriniz!");
					if(Oyuncu[otherid][a_jail] == 1) return HataMesaj(playerid,"Oyuncu zaten hapiste!");
					KaydetINT(otherid,"a_jail",1);
					KaydetINT(otherid,"a_jailsure",deger*60);
					OyuncuBilgiAl(otherid);
					SetPlayerPos(otherid,Jail_CordX,Jail_CordY,Jail_CordZ);
					SetPlayerInterior(otherid,Jail_CordInt);
					SetPlayerVirtualWorld(otherid,9999);
					GameTextForPlayer(otherid,"~w~admin tarafindan~n~~r~hapse atildiniz!",5000,3);
					
					new str[256];
					format(str,sizeof(str),"*** %s isimli oyuncu %s isimli admin tarafýndan %d dakikalýðýna hapse atýldý. ( Sebep: %s )",PlayerName(otherid),PlayerName(playerid),deger,result);
					SendClientMessageToAll(0xFFBF00FF,str);
				    UyariMesaj(otherid,"Admin tarafýndan jaile atýldýnýz, jail sürenizi öðrenmek için '/stats' yazýnýz!");
				    BilgiMesaj(otherid,"Oyuncuyu jaile attýnýz!");
					format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu %d dakikalýðýna hapse attý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
					AdminMesaj(adminmsg);
				}
			} else HataMesaj(playerid,"Oyuncu çevrimiçi deðil..."); return 1;
		} else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;
	}
	PlayerCommand_ID_STR("/warn",k_warn)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
	    if(OyuncuWarn[otherid] == MAX_WARN)
	    {
			OyuncuKickSebep[otherid] = "Uyarý Limitini Aþma";
			OyuncuCikisSebep[otherid] = 3;
			Kick(otherid);
	    }
	    else
	    {
	        OyuncuWarn[otherid]++;
	    }
		new str[256];
		format(str,sizeof(str),"*** %s isimli oyuncu %s isimli admin tarafýndan uyarý aldý. ( Sebep: %s ) ( Uyarý: %d/%d )",PlayerName(otherid),PlayerName(playerid),result,OyuncuWarn[otherid],MAX_WARN);
		SendClientMessageToAll(0xFFBF00FF,str);
	    EndCommand_ID_STR;
	}
	PlayerCommand("/gotols",k_gotols)
	{
	    if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid),1566.2130,-2286.5369,13.3828);
		else SetPlayerPos(playerid,1566.2130,-2286.5369,13.3828);
	    EndCommand;
	}
	PlayerCommand("/gotosf",k_gotosf)
	{
	    if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid),-1735.9763,-579.5942,16.3359);
		else SetPlayerPos(playerid,-1735.9763,-579.5942,16.3359);
	    EndCommand;
	}
	PlayerCommand("/gotolv",k_gotolv)
	{
	    if(IsPlayerInAnyVehicle(playerid)) SetVehiclePos(GetPlayerVehicleID(playerid),1720.7291,1453.2158,10.8000);
		else SetPlayerPos(playerid,1720.7291,1453.2158,10.8000);
	    EndCommand;
	}
	PlayerCommand_ID("/reswarn",k_reswarn)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		OyuncuWarn[otherid]=0;
	    UyariMesaj(otherid,"Admin tarafýndan uyarýlarýnýz silindi!");
	    BilgiMesaj(playerid,"Oyuncunun uyarýlarýný sildiniz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun uyarýlarýný sildi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
		EndCommand_ID;
	}
	PlayerCommand_ID("/unjail",k_unjail)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		if(Oyuncu[otherid][a_jail] != 1) return HataMesaj(playerid,"Oyuncu hapiste deðil!");
		KaydetINT(otherid,"a_jail",0);
		KaydetINT(otherid,"a_jailsure",-1);
		OyuncuBilgiAl(otherid);
		SpawnPlayer(otherid);
	    UyariMesaj(otherid,"Admin tarafýndan jailden çýkarýldýnýz!");
	    BilgiMesaj(playerid,"Oyuncuyu jailden çýkardýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu jailden çýkardý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
		EndCommand_ID;
	}
	PlayerCommand_ID("/showstats",k_showstats)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		StatsGoster(playerid,otherid);
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun istatistiklerini kontrol ediyor!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
		EndCommand_ID;
	}
	PlayerCommand_ID("/spec",k_spec)
	{
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		if(OyuncuSpec[otherid] == true) return HataMesaj(playerid,"Ýzlemeye çalýþtýðýnýz oyuncu þu anda baþka birini izliyor!");
		OyuncuSpec[playerid] = true;
		OyuncuSpecID[playerid] = otherid;
		TogglePlayerSpectating(playerid,true);
		if(IsPlayerInAnyVehicle(otherid)) PlayerSpectateVehicle(playerid,GetPlayerVehicleID(otherid));
		else PlayerSpectatePlayer(playerid,otherid);

	    BilgiMesaj(otherid,"Oyuncuyu izliyorsunuz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu izliyor!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
		EndCommand_ID;
	}
	PlayerCommand("/specoff",k_specoff)
	{
		if(OyuncuSpec[playerid] == false) return HataMesaj(playerid,"Þuanda zaten birini izlemiyorsunuz!");
		OyuncuSpec[playerid] = false;
		OyuncuSpecID[playerid] = -1;
		TogglePlayerSpectating(playerid,false);

	    BilgiMesaj(playerid,"Oyuncu izlemeyi kapattýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin oyuncu izlemeyi kapattý!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
		EndCommand;
	}
	PlayerCommand_ID_DEGER("/makeadmin",k_makeadmin)
	{
	    if(deger < 0 || deger > MAX_ADMINLEVEL) return HataMesaj(playerid,"Lütfen geçerli bir level giriniz!");
		if(deger == Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Oyuncu zaten o levelde!");
	    if(deger == 0)
	    {
			OyuncuAdmin[otherid] = false;
	        GameTextForPlayer(otherid,"~w~admin tarafindan yonetimden~n~~r~atildiniz!",6000,3);
		    BilgiMesaj(playerid,"Oyuncuyu yönetimden çýkardýnýz!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu yönetimden çýkardý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
			AdminMesaj(adminmsg);
	    }
	    if(deger < Oyuncu[otherid][p_adminlevel])
	    {
			OyuncuAdmin[otherid] = true;
	        GameTextForPlayer(otherid,"~w~admin tarafindan leveliniz~n~~b~dusuruldu!",6000,3);
		    BilgiMesaj(playerid,"Oyuncunun levelini düþürdünüz!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun admin levelini %d olarak ayarladý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
			AdminMesaj(adminmsg);
	    }
	    if(deger > Oyuncu[otherid][p_adminlevel])
	    {
			OyuncuAdmin[otherid] = true;
	        GameTextForPlayer(otherid,"~w~admin tarafindan leveliniz~n~~g~yukseltildi!",6000,3);
		    BilgiMesaj(playerid,"Oyuncunun levelini yükselttiniz!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncunun admin levelini %d olarak ayarladý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,deger);
			AdminMesaj(adminmsg);
	    }
		KaydetINT(otherid,"p_adminlevel",deger);
	    EndCommand_ID_DEGER;
	}
	PlayerCommand_ID("/slap",k_slap)
	{
		#if HIGHLEVEL == true
		if(Oyuncu[playerid][p_adminlevel] < Oyuncu[otherid][p_adminlevel]) return HataMesaj(playerid,"Kendinden yüksek level yöneticilere bu komutu kullanamazsýn!");
		#endif
		#if PID_PID == false
		if(otherid == playerid) return HataMesaj(playerid,"Bu komutu kendinize kullanamazsýnýz!");
		#endif
		new Float:X,Float:Y,Float:Z,Float:H;
		GetPlayerPos(otherid,X,Y,Z);
		GetPlayerHealth(otherid,H);
		SetPlayerPos(otherid,X+random(3),Y+random(3),Z+3);
		SetPlayerHealth(otherid,H-SLAP_DAMAGE);

		PlaySlapSound(otherid);
	    BilgiMesaj(playerid,"Oyuncuyu slapladýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuyu slapladý!",PlayerName(playerid),playerid,PlayerName(otherid),otherid);
		AdminMesaj(adminmsg);
		EndCommand_ID;
	}
    if(strcmp(cmd, "/giveweapon", true) == 0)
	{
		if(IsAdmin(playerid,k_giveweapon))
		{
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Player ID] [Weap ID] [Ammo]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new otherid = strval(tmp);

			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Player ID] [Weap ID] [Ammo]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new weapon = strval(tmp);

			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Player ID] [Weap ID] [Ammo]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new ammo = strval(tmp);

			if(IsPlayerConnected(otherid))
			{
				if(otherid != INVALID_PLAYER_ID)
				{
				    if(weapon < 1 || weapon > 46) return HataMesaj(playerid,"Lütfen geçerli bir silah id giriniz!");
					GivePlayerWeapon(otherid,weapon,ammo);
				    UyariMesaj(otherid,"Admin tarafýndan size silah verildi!");
				    BilgiMesaj(playerid,"Oyuncuya silah verdiniz!");
					format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin %s(%d) isimli oyuncuya %s(%d Ammo) verdi!",PlayerName(playerid),playerid,PlayerName(otherid),otherid,WeaponName(weapon),ammo);
					AdminMesaj(adminmsg);
				}
			} else HataMesaj(playerid,"Oyuncu çevrimiçi deðil..."); return 1;
		} else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;
	}
    if(strcmp(cmd, "/giveallweapon", true) == 0)
	{
		if(IsAdmin(playerid,k_giveallweapon))
		{
			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Weap ID] [Ammo]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new weapon = strval(tmp);

			tmp = strtok(cmdtext,idx);
			if(!strlen(tmp))
			{
				new str[128];
				format(str,sizeof(str),"%s [Weap ID] [Ammo]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new ammo = strval(tmp);

		    if(weapon < 1 || weapon > 46) return HataMesaj(playerid,"Lütfen geçerli bir silah id giriniz!");
			for(new i;i<MAX_PLAYERS;i++) GivePlayerWeapon(i,weapon,ammo),UyariMesaj(i,"Admin tarafýndan bütün Hesaplara silah verildi!");
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin bütün Hesaplara %s(%d Ammo) verdi!",PlayerName(playerid),playerid,WeaponName(weapon),ammo);
			AdminMesaj(adminmsg);

		} else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;
	}
	PlayerCommand("/jetpack",k_jetpack)
	{
	    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	    BilgiMesaj(playerid,"Jetpack aldýnýz!");
		format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin kendisine jetpack verdi!",PlayerName(playerid),playerid);
		AdminMesaj(adminmsg);
		EndCommand;
	}
    if(strcmp(cmd, "/move", true) == 0)
	{
		if(IsAdmin(playerid,k_move))
		{
			new result[128];
			result = strrest(cmdtext,idx);
			if(!strlen(result))
			{
				new str[128];
				format(str,sizeof(str),"%s [+x,+y,+z,-x,-y,-z]",cmd);
				BilgiMesaj(playerid,str);
				return 1;
			}
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid,X,Y,Z);
			if(!strcmp(result,"+x",true)) 		SetPlayerPos(playerid,X+5,Y,Z);
			else if(!strcmp(result,"+y",true)) 	SetPlayerPos(playerid,X,Y+5,Z);
			else if(!strcmp(result,"+z",true)) 	SetPlayerPos(playerid,X,Y,Z+5);
			else if(!strcmp(result,"-x",true)) 	SetPlayerPos(playerid,X-5,Y,Z);
			else if(!strcmp(result,"-y",true)) 	SetPlayerPos(playerid,X,Y-5,Z);
			else if(!strcmp(result,"-z",true)) 	SetPlayerPos(playerid,X,Y,Z-5);
			else return HataMesaj(playerid,"Lütfen hareket edeceðiniz pozisyonu giriniz, (+x,+y,+z,-x,-y,-z).");
		} else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;
	}
	if(strcmp(cmd, "/restart", true) == 0)
	{
	    if(IsAdmin(playerid,k_restart))
	    {
	        tmp = strtok(cmdtext,idx);
	        if(!strlen(tmp))
	        {
			    BilgiMesaj(playerid,"/restart [Saniye]");
			    return 1;
			}
			new id = strval(tmp);
			if(id<0) return HataMesaj(playerid,"Lütfen geçerli bir sayý giriniz!");
			if(SunucuRestartZaman>0) return HataMesaj(playerid,"Sunucuya zaten restart atýlýyor!");
		    new str[128];
			format(str,sizeof(str),"~g~%d ~w~SANIYE SONRA SUNUCUYA~n~RESTART ATILCAKTIR",id);
			GameTextForAll(str,1000,3);
			format(adminmsg,sizeof(adminmsg),"%s(%d) isimli admin sunucuya restart atýyor!",PlayerName(playerid),playerid);
			AdminMesaj(adminmsg);
		    RestartTimer = SetTimer("SunucuRestart",1000,1);
		    SunucuRestartZaman = id;
		} else HataMesaj(playerid,"Bu komutu kullanmak için gerekli yetkiye sahip deðilsiniz..."); return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(OyuncuGiveCar[playerid] != -1) DestroyVehicle(OyuncuGiveCar[playerid]);
	if(OyuncuGodCar[playerid] == true) {
		new str[128];
		format(str,sizeof(str),"%s isimli admin god-car'ý deaktif etti!");
	    AdminMesaj(str);
	    HataMesaj(playerid,"Araçtan çýktýðýnýz için god-car deaktif edildi!");
	    OyuncuGodCar[playerid] = false;
	}
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
	if(Oyuncu[playerid][p_logged] != 1)
	{
		return 0;
	}
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
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
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
	if(dialogid==DIALOG)
	{
	    if(!response)
	    {
			HataMesaj(playerid,"Sunucuya girebilmek için kayýt yapmanýz gerekmektedir, oyundan atýldýnýz.");
			OyuncuCikisSebep[playerid] = 5;
			Kick(playerid);
	    }
	    if(response)
	    {
			new dosya[64];
			format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
			if(!strlen(inputtext) || strlen(inputtext)>16)
			{
			    new str[256];
			    format(str,sizeof(str),"{FFFFFF}Servera hoþgeldiniz, {0080FF}%s\n\n{FFFFFF}Sunucuda kayýtlý görünmüyorsunuz,\nLütfen aþaðýya yeni þifrenizi yazarak kaydýnýzý oluþturunuz.",PlayerName(playerid));
			    Dialog(playerid,DIALOG,d_password,str,"Kayýt","Ýptal");
			    return 1;
			}
			dini_Create(dosya);
			dini_IntSet(dosya,"p_password",udb_hash(inputtext));
			dini_IntSet(dosya,"p_logged",1);
			dini_IntSet(dosya,"p_money",0);
			dini_IntSet(dosya,"p_skin",0);
			dini_IntSet(dosya,"p_skinkaydet",0);
			dini_IntSet(dosya,"p_adminlevel",0);
			dini_IntSet(dosya,"p_score",0);
			dini_IntSet(dosya,"p_fightstyle",0);
			dini_IntSet(dosya,"p_kills",0);
			dini_IntSet(dosya,"p_deaths",0);
			dini_IntSet(dosya,"p_s0",-1);
			dini_IntSet(dosya,"p_s0ammo",-1);
			dini_IntSet(dosya,"p_s1",-1);
			dini_IntSet(dosya,"p_s1ammo",-1);
			dini_IntSet(dosya,"p_s2",-1);
			dini_IntSet(dosya,"p_s2ammo",-1);
			dini_IntSet(dosya,"p_s3",-1);
			dini_IntSet(dosya,"p_s3ammo",-1);
			dini_IntSet(dosya,"p_s4",-1);
			dini_IntSet(dosya,"p_s4ammo",-1);
			dini_IntSet(dosya,"p_s5",-1);
			dini_IntSet(dosya,"p_s5ammo",-1);
			dini_IntSet(dosya,"p_s6",-1);
			dini_IntSet(dosya,"p_s6ammo",-1);
			dini_IntSet(dosya,"p_s7",-1);
			dini_IntSet(dosya,"p_s7ammo",-1);
			dini_IntSet(dosya,"p_s8",-1);
			dini_IntSet(dosya,"p_s8ammo",-1);
			dini_IntSet(dosya,"p_s9",-1);
			dini_IntSet(dosya,"p_s9ammo",-1);
			dini_IntSet(dosya,"p_s10",-1);
			dini_IntSet(dosya,"p_s10ammo",-1);
			dini_IntSet(dosya,"p_s11",-1);
			dini_IntSet(dosya,"p_s11ammo",-1);
			dini_IntSet(dosya,"p_s12",-1);
			dini_IntSet(dosya,"p_s12ammo",-1);
			dini_IntSet(dosya,"a_jail",0);
			dini_IntSet(dosya,"a_jailsure",-1);
			dini_Set(dosya,"a_ip",PlayerIP(playerid));

			BilgiMesaj(playerid,"Baþarýyla kayýt oldunuz, iyi oyunlar...");
			OyuncuBilgiAl(playerid);
	    }
	}

	if(dialogid==DIALOG+1)
	{
	    if(!response)
	    {
			HataMesaj(playerid,"Sunucuya girebilmek için giriþ yapmanýz gerekmektedir, oyundan atýldýnýz.");
			OyuncuCikisSebep[playerid] = 5;
			Kick(playerid);
	    }
	    if(response)
	    {
			new dosya[64];
			format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
			if(!strlen(inputtext) || strlen(inputtext)>16)
			{
			    if(OyuncuFailLogin[playerid] != 0)
			    {
				    new str[256];
				    format(str,sizeof(str),"{FF0000}Uyarý: %d/%d\n\n{FFFFFF}Sunucuda kayýtlý görünüyorsunuz,\nLütfen aþaðýya þifrenizi yazarak giriþ yapýnýz.",OyuncuFailLogin[playerid],MAX_FAIL);
				    Dialog(playerid,DIALOG+1,d_password,str,"Giriþ","Ýptal");
			    }
			    else
			    {
				    new str[256];
				    format(str,sizeof(str),"{FFFFFF}Servera hoþgeldiniz, {0080FF}%s\n\n{FFFFFF}Sunucuda kayýtlý görünüyorsunuz,\nLütfen aþaðýya þifrenizi yazarak giriþ yapýnýz.",PlayerName(playerid));
				    Dialog(playerid,DIALOG+1,d_password,str,"Giriþ","Ýptal");
				}
			    return 1;
			}
			if(OyuncuFailLogin[playerid] == MAX_FAIL)
			{
				HataMesaj(playerid,"Çok fazla yanlýþ þifre girdiðinizden oyundan atýldýnýz!");
				OyuncuCikisSebep[playerid] = 4;
				Kick(playerid);
			}
			if(udb_hash(inputtext) == dini_Int(dosya,"p_password"))
			{
			    new str[256];
				if(IsAdmin(playerid,1)) format(str,sizeof(str),"%d Level olarak giriþ yaptýnýz, iyi oyunlar.",dini_Int(dosya,"adminlevel"));
				else format(str,sizeof(str),"Baþarýyla giriþ yaptýnýz, iyi oyunlar...");
				BilgiMesaj(playerid,str);
				
				dini_Set(dosya,"a_ip",PlayerIP(playerid));
				dini_IntSet(dosya,"p_logged",1);
				Oyuncu[playerid][p_logged] = 1;
				OyuncuBilgiAl(playerid);
			}
			else
			{
			    new str[256];
			    OyuncuFailLogin[playerid]++;
			    format(str,sizeof(str),"{FF0000}Yanlýþ þifre girdiniz, Uyarý: %d/%d\n\n{FFFFFF}Sunucuda kayýtlý görünüyorsunuz,\nLütfen aþaðýya þifrenizi yazarak giriþ yapýnýz.",OyuncuFailLogin[playerid],MAX_FAIL);
			    Dialog(playerid,DIALOG+1,d_password,str,"Giriþ","Ýptal");
			}
	    }
	}
	
	if(dialogid==DIALOG+4)
	{
	    if(!response) return 1;
	    if(response)
	    {
			KaydetINT(playerid,"p_skinkaydet",1);
			KaydetINT(playerid,"p_skin",GetPlayerSkin(playerid));
			BilgiMesaj(playerid,"Artýk her giriþinizde kaydettiðiniz skin ile baþlýcaksýnýz, iptal etmek için tekrar '/saveskin' yazýnýz!");
	    }
	}

	if(dialogid==DIALOG+5)
	{
	    if(!response) return 1;
	    if(response)
	    {
			KaydetINT(playerid,"p_skinkaydet",0);
			KaydetINT(playerid,"p_skin",-1);
			BilgiMesaj(playerid,"Kaydedilen skin silindi, tekrar kaydetmek için '/saveskin' yazýnýz!");
	    }
	}

	if(dialogid==DIALOG+6)
	{
	    if(!response) return 1;
	    if(response)
	    {
			aYardimSayfa2(playerid);
	    }
	}
	
	if(dialogid==DIALOG+7)
	{
	    if(!response) return 1;
	    if(response)
	    {
			aYardimSayfa1(playerid);
	    }
	}
	
	if(response)
	{
		new
			iList = GetPVarInt(playerid, "iList")
		;
		if(dialogid == (VMENU + iList))
		{
			if(0 <= listitem <= 12)
			{
				new
					Float: fPos[3]
				;
				if(GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]))
				{
					new
						iVehID = GetPVarInt(playerid, "iVehID"),
						Float: fAngle
					;

					if(IsPlayerInAnyVehicle(playerid))
						GetVehicleZAngle(GetPlayerVehicleID(playerid), fAngle);
					else
						GetPlayerFacingAngle(playerid, fAngle);

					if(iVehID)
						DestroyVehicle(iVehID);

					iVehID = (listitem + (iList * 12) + 400);

					// Hunter, Rhino, Hydra yasaklar
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
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OyuncuBilgiAl(playerid)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	Oyuncu[playerid][p_logged] = dini_Int(dosya,"p_logged");
	Oyuncu[playerid][p_money] = dini_Int(dosya,"p_money");
	Oyuncu[playerid][p_skin] = dini_Int(dosya,"p_skin");
	Oyuncu[playerid][p_skinkaydet] = dini_Int(dosya,"p_skinkaydet");
	Oyuncu[playerid][p_adminlevel] = dini_Int(dosya,"p_adminlevel");
	Oyuncu[playerid][p_score] = dini_Int(dosya,"p_score");
	Oyuncu[playerid][p_fightstyle] = dini_Int(dosya,"p_fightstyle");
	Oyuncu[playerid][p_kills] = dini_Int(dosya,"p_kills");
	Oyuncu[playerid][p_deaths] = dini_Int(dosya,"p_deaths");
	Oyuncu[playerid][p_s0] = dini_Int(dosya,"p_s0");
	Oyuncu[playerid][p_s0ammo] = dini_Int(dosya,"p_s0ammo");
	Oyuncu[playerid][p_s1] = dini_Int(dosya,"p_s1");
	Oyuncu[playerid][p_s1ammo] = dini_Int(dosya,"p_s1ammo");
	Oyuncu[playerid][p_s2] = dini_Int(dosya,"p_s2");
	Oyuncu[playerid][p_s2ammo] = dini_Int(dosya,"p_s2ammo");
	Oyuncu[playerid][p_s3] = dini_Int(dosya,"p_s3");
	Oyuncu[playerid][p_s3ammo] = dini_Int(dosya,"p_s3ammo");
	Oyuncu[playerid][p_s4] = dini_Int(dosya,"p_s4");
	Oyuncu[playerid][p_s4ammo] = dini_Int(dosya,"p_s4ammo");
	Oyuncu[playerid][p_s5] = dini_Int(dosya,"p_s5");
	Oyuncu[playerid][p_s5ammo] = dini_Int(dosya,"p_s5ammo");
	Oyuncu[playerid][p_s6] = dini_Int(dosya,"p_s6");
	Oyuncu[playerid][p_s6ammo] = dini_Int(dosya,"p_s6ammo");
	Oyuncu[playerid][p_s7] = dini_Int(dosya,"p_s7");
	Oyuncu[playerid][p_s7ammo] = dini_Int(dosya,"p_s7ammo");
	Oyuncu[playerid][p_s8] = dini_Int(dosya,"p_s8");
	Oyuncu[playerid][p_s8ammo] = dini_Int(dosya,"p_s8ammo");
	Oyuncu[playerid][p_s9] = dini_Int(dosya,"p_s9");
	Oyuncu[playerid][p_s9ammo] = dini_Int(dosya,"p_s9ammo");
	Oyuncu[playerid][p_s10] = dini_Int(dosya,"p_s10");
	Oyuncu[playerid][p_s10ammo] = dini_Int(dosya,"p_s10ammo");
	Oyuncu[playerid][p_s11] = dini_Int(dosya,"p_s11");
	Oyuncu[playerid][p_s11ammo] = dini_Int(dosya,"p_s11ammo");
	Oyuncu[playerid][p_s12] = dini_Int(dosya,"p_s12");
	Oyuncu[playerid][p_s12ammo] = dini_Int(dosya,"p_s12ammo");
	Oyuncu[playerid][a_jail] = dini_Int(dosya,"a_jail");
	Oyuncu[playerid][a_jailsure] = dini_Int(dosya,"a_jailsure");
	Oyuncu[playerid][a_ip] = dini_Get(dosya,"a_ip");
	
	if(Oyuncu[playerid][p_adminlevel] > 0) OyuncuAdmin[playerid] = true;
	else OyuncuAdmin[playerid] = false;
	return 1;
}

public OyuncuBilgiKaydet(playerid)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));

	dini_IntSet(dosya,"p_money",GetPlayerMoney(playerid));
	dini_IntSet(dosya,"p_score",GetPlayerScore(playerid));
	dini_IntSet(dosya,"p_fightstyle",GetPlayerFightingStyle(playerid));
	
	if(dini_Int(dosya,"p_adminlevel") > MAX_ADMINLEVEL) dini_IntSet(dosya,"p_adminlevel",MAX_ADMINLEVEL);
	return 1;
}

public OyuncuBilgiYukle(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,Oyuncu[playerid][p_money]);
	SetPlayerScore(playerid,Oyuncu[playerid][p_score]);
	SetPlayerFightingStyle(playerid,Oyuncu[playerid][p_fightstyle]);
	if(Oyuncu[playerid][p_skinkaydet] == 1) SetPlayerSkin(playerid,Oyuncu[playerid][p_skin]);
	return 1;
}

public OyuncuSilahYukle(playerid)
{
	ResetPlayerWeapons(playerid);
	if(Oyuncu[playerid][p_s0] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s0],Oyuncu[playerid][p_s0ammo]);
	if(Oyuncu[playerid][p_s1] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s1],Oyuncu[playerid][p_s1ammo]);
	if(Oyuncu[playerid][p_s2] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s2],Oyuncu[playerid][p_s2ammo]);
	if(Oyuncu[playerid][p_s3] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s3],Oyuncu[playerid][p_s3ammo]);
	if(Oyuncu[playerid][p_s4] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s4],Oyuncu[playerid][p_s4ammo]);
	if(Oyuncu[playerid][p_s5] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s5],Oyuncu[playerid][p_s5ammo]);
	if(Oyuncu[playerid][p_s6] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s6],Oyuncu[playerid][p_s6ammo]);
	if(Oyuncu[playerid][p_s7] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s7],Oyuncu[playerid][p_s7ammo]);
	if(Oyuncu[playerid][p_s8] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s8],Oyuncu[playerid][p_s8ammo]);
	if(Oyuncu[playerid][p_s9] != -1)	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s9],Oyuncu[playerid][p_s9ammo]);
	if(Oyuncu[playerid][p_s10] != -1) 	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s10],Oyuncu[playerid][p_s10ammo]);
	if(Oyuncu[playerid][p_s11] != -1) 	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s11],Oyuncu[playerid][p_s11ammo]);
	if(Oyuncu[playerid][p_s12] != -1) 	GivePlayerWeapon(playerid,Oyuncu[playerid][p_s12],Oyuncu[playerid][p_s12ammo]);
	return 1;
}

public OyuncuSilahKaydet(playerid)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
    GetPlayerWeaponData(playerid, 0, Oyuncu[playerid][p_s0], Oyuncu[playerid][p_s0ammo]);
    GetPlayerWeaponData(playerid, 1, Oyuncu[playerid][p_s1], Oyuncu[playerid][p_s1ammo]);
    GetPlayerWeaponData(playerid, 2, Oyuncu[playerid][p_s2], Oyuncu[playerid][p_s2ammo]);
    GetPlayerWeaponData(playerid, 3, Oyuncu[playerid][p_s3], Oyuncu[playerid][p_s3ammo]);
    GetPlayerWeaponData(playerid, 4, Oyuncu[playerid][p_s4], Oyuncu[playerid][p_s4ammo]);
    GetPlayerWeaponData(playerid, 5, Oyuncu[playerid][p_s5], Oyuncu[playerid][p_s5ammo]);
    GetPlayerWeaponData(playerid, 6, Oyuncu[playerid][p_s6], Oyuncu[playerid][p_s6ammo]);
    GetPlayerWeaponData(playerid, 7, Oyuncu[playerid][p_s7], Oyuncu[playerid][p_s7ammo]);
    GetPlayerWeaponData(playerid, 8, Oyuncu[playerid][p_s8], Oyuncu[playerid][p_s8ammo]);
    GetPlayerWeaponData(playerid, 9, Oyuncu[playerid][p_s9], Oyuncu[playerid][p_s9ammo]);
    GetPlayerWeaponData(playerid, 10, Oyuncu[playerid][p_s10], Oyuncu[playerid][p_s10ammo]);
    GetPlayerWeaponData(playerid, 11, Oyuncu[playerid][p_s11], Oyuncu[playerid][p_s11ammo]);
    GetPlayerWeaponData(playerid, 12, Oyuncu[playerid][p_s12], Oyuncu[playerid][p_s12ammo]);
	dini_IntSet(dosya,"p_s0",		Oyuncu[playerid][p_s0]);
	dini_IntSet(dosya,"p_s0ammo",	Oyuncu[playerid][p_s0ammo]);
	dini_IntSet(dosya,"p_s1",		Oyuncu[playerid][p_s1]);
	dini_IntSet(dosya,"p_s1ammo",	Oyuncu[playerid][p_s1ammo]);
	dini_IntSet(dosya,"p_s2",		Oyuncu[playerid][p_s2]);
	dini_IntSet(dosya,"p_s2ammo",	Oyuncu[playerid][p_s2ammo]);
	dini_IntSet(dosya,"p_s3",		Oyuncu[playerid][p_s3]);
	dini_IntSet(dosya,"p_s3ammo",	Oyuncu[playerid][p_s3ammo]);
	dini_IntSet(dosya,"p_s4",		Oyuncu[playerid][p_s4]);
	dini_IntSet(dosya,"p_s4ammo",	Oyuncu[playerid][p_s4ammo]);
	dini_IntSet(dosya,"p_s5",		Oyuncu[playerid][p_s5]);
	dini_IntSet(dosya,"p_s5ammo",	Oyuncu[playerid][p_s5ammo]);
	dini_IntSet(dosya,"p_s6",		Oyuncu[playerid][p_s6]);
	dini_IntSet(dosya,"p_s6ammo",	Oyuncu[playerid][p_s6ammo]);
	dini_IntSet(dosya,"p_s7",		Oyuncu[playerid][p_s7]);
	dini_IntSet(dosya,"p_s7ammo",	Oyuncu[playerid][p_s7ammo]);
	dini_IntSet(dosya,"p_s8",		Oyuncu[playerid][p_s8]);
	dini_IntSet(dosya,"p_s8ammo",	Oyuncu[playerid][p_s8ammo]);
	dini_IntSet(dosya,"p_s9",		Oyuncu[playerid][p_s9]);
	dini_IntSet(dosya,"p_s9ammo",	Oyuncu[playerid][p_s9ammo]);
	dini_IntSet(dosya,"p_s10",		Oyuncu[playerid][p_s10]);
	dini_IntSet(dosya,"p_s10ammo",	Oyuncu[playerid][p_s10ammo]);
	dini_IntSet(dosya,"p_s11",		Oyuncu[playerid][p_s11]);
	dini_IntSet(dosya,"p_s11ammo",	Oyuncu[playerid][p_s11ammo]);
	dini_IntSet(dosya,"p_s12",		Oyuncu[playerid][p_s12]);
	dini_IntSet(dosya,"p_s12ammo",	Oyuncu[playerid][p_s12ammo]);
	return 1;
}

public OyuncuBackPos(playerid)
{
	SetPlayerPos(playerid,BackX[playerid],BackY[playerid],BackZ[playerid]+0.5);
	SetPlayerFacingAngle(playerid,BackA[playerid]);
	SetPlayerInterior(playerid,BackInt[playerid]);
	return 1;
}

public OyuncuBilgiSifirla(playerid)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	dini_IntSet(dosya,"p_logged",0);
	Oyuncu[playerid][p_logged] = 0;
	Oyuncu[playerid][p_money] = -1;
	Oyuncu[playerid][p_skin] = -1;
	Oyuncu[playerid][p_skinkaydet] = -1;
	Oyuncu[playerid][p_adminlevel] = -1;
	Oyuncu[playerid][p_score] = -1;
	Oyuncu[playerid][p_fightstyle] = -1;
	Oyuncu[playerid][p_kills] = -1;
	Oyuncu[playerid][p_deaths] = -1;
	Oyuncu[playerid][p_s0] = -1;
	Oyuncu[playerid][p_s0ammo] = -1;
	Oyuncu[playerid][p_s1] = -1;
	Oyuncu[playerid][p_s1ammo] = -1;
	Oyuncu[playerid][p_s2] = -1;
	Oyuncu[playerid][p_s2ammo] = -1;
	Oyuncu[playerid][p_s3] = -1;
	Oyuncu[playerid][p_s3ammo] = -1;
	Oyuncu[playerid][p_s4] = -1;
	Oyuncu[playerid][p_s4ammo] = -1;
	Oyuncu[playerid][p_s5] = -1;
	Oyuncu[playerid][p_s5ammo] = -1;
	Oyuncu[playerid][p_s6] = -1;
	Oyuncu[playerid][p_s6ammo] = -1;
	Oyuncu[playerid][p_s7] = -1;
	Oyuncu[playerid][p_s7ammo] = -1;
	Oyuncu[playerid][p_s8] = -1;
	Oyuncu[playerid][p_s8ammo] = -1;
	Oyuncu[playerid][p_s9] = -1;
	Oyuncu[playerid][p_s9ammo] = -1;
	Oyuncu[playerid][p_s10] = -1;
	Oyuncu[playerid][p_s10ammo] = -1;
	Oyuncu[playerid][p_s11] = -1;
	Oyuncu[playerid][p_s11ammo] = -1;
	Oyuncu[playerid][p_s12] = -1;
	Oyuncu[playerid][p_s12ammo] = -1;
	Oyuncu[playerid][a_jail] = -1;
	Oyuncu[playerid][a_jailsure] = -1;
	Oyuncu[playerid][a_ip] = -1;
	return 1;
}

public AutoLogin(playerid)
{
	new dosya[64],str[256];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	if(IsAdmin(playerid,1)) format(str,sizeof(str),"%d Level otomatik olarak giriþ yaptýnýz, iyi oyunlar.",dini_Int(dosya,"adminlevel"));
	else format(str,sizeof(str),"Otomatik olarak giriþ yaptýnýz, iyi oyunlar...");
	BilgiMesaj(playerid,str);
	OyuncuBilgiAl(playerid);
	return 1;
}

public StatsGoster(showid,playerid)
{
	new str[1024],yjail[32],yjailsure;
	new jailsure = Oyuncu[playerid][a_jailsure];
	new money = Oyuncu[playerid][p_money];
	new skin = Oyuncu[playerid][p_skin];
	new skor = Oyuncu[playerid][p_score];
	new oldurme = Oyuncu[playerid][p_kills];
	new olum = Oyuncu[playerid][p_deaths];
	new adminlevel = Oyuncu[playerid][p_adminlevel];

	if(Oyuncu[playerid][a_jail] == 1) yjail = "Evet", yjailsure = jailsure;
	else if(Oyuncu[playerid][a_jail] == 0) yjail = "Hayýr", yjailsure = 0;
	
	format(str,sizeof(str),"{FF0000}=======================================\nNick: {FFFFFF}%s\n{FF0000}Admin Level: {FFFFFF}%d\n{FF0000}Para: {FFFFFF}%i$\n{FF0000}Skin: {FFFFFF}%d\n{FF0000}Skor: {FFFFFF}%d\n{FF0000}Öldürme: {FFFFFF}%d\n{FF0000}Ölüm: {FFFFFF}%d\n\n{FF0000}Jail: {FFFFFF}%s\n{FF0000}Kalan Süre: {FFFFFF}%d Saniye\n\n{FF0000}IP: {FFFFFF}%s\n{FF0000}=======================================",
	PlayerName(playerid),adminlevel,money,skin,skor,oldurme,olum,yjail,yjailsure,Oyuncu[playerid][a_ip]);
	
	Dialog(showid,DIALOG+2,d_msgbox,str,"Tamam","");
	return 1;
}

public OyuncuGuncelle()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(IsPlayerConnected(i) && OyuncuSpawnOldu[i] == true)
	    {
	        #if ANTI_PING == true
	        if(GetPlayerPing(i) > MAX_PING) OyuncuCikisSebep[i]=7, Kick(i);
	        #endif
	        #if ANTI_FLOOD == true
	        if(OyuncuFlood[i] != 0 && OyuncuFlood[i] < MAX_FLOOD+3) OyuncuFlood[i]--;
	        #endif
	        if(Oyuncu[i][a_jail] == 1 && Oyuncu[i][a_jailsure] != 0)
	        {
				KaydetINT(i,"a_jailsure",Oyuncu[i][a_jailsure]-1);
	        } else KaydetINT(i,"a_jail",0),KaydetINT(i,"a_jailsure",-1);
	        if(Oyuncu[i][a_jailsure] == 0) GameTextForPlayer(i,"~w~jail suren bitmistir~n~~g~artik serbestsin",6000,3), SpawnPlayer(i);
	        OyuncuSilahKaydet(i);
	        OyuncuBilgiKaydet(i);
	        OyuncuBilgiAl(i);
	    }
	}
	return 1;
}

public GodKontrol()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(OyuncuGodCar[i] == true)
	    {
			if(IsPlayerInAnyVehicle(i)) RepairVehicle(GetPlayerVehicleID(i));
	    }
	}
	return 1;
}

public SpecKontrol()
{
	for(new i;i<MAX_PLAYERS;i++)
	{
	    if(OyuncuSpec[i] == true)
	    {
			if(OyuncuSpec[OyuncuSpecID[i]] == true)
			{
				HataMesaj(i,"Ýzlemeye çalýþtýðýnýz oyuncu þu anda baþka birini izliyor!");
				OyuncuSpec[i] = false;
				OyuncuSpecID[i] = -1;
				TogglePlayerSpectating(i,false);
				break;
			}
			if(IsPlayerInAnyVehicle(OyuncuSpecID[i])) PlayerSpectateVehicle(i,GetPlayerVehicleID(OyuncuSpecID[i]));
			else PlayerSpectatePlayer(i,OyuncuSpecID[i]);
	    }
	}
	return 1;
}

public SunucuRestart()
{
	if(SunucuRestartZaman == 0)
	{
		GameTextForAll("~w~SUNUCUYA RESTART ATILIYOR~n~~g~LUTFEN BEKLEYINIZ...",11000,3);
		SunucuRestartZaman=-1;
		KillTimer(RestartTimer);
		SendRconCommand("gmx");
	}
	else
	{
		SunucuRestartZaman--;
	    new str[128];
		format(str,sizeof(str),"~g~%d ~w~SANIYE SONRA SUNUCUYA~n~RESTART ATILCAKTIR",SunucuRestartZaman);
		GameTextForAll(str,1000,3);
	}
	return 1;
}

public OyuncuKayitli(playerid)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	if(dini_Exists(dosya)) return 1;
	return 0;
}

public IsAdmin(playerid,alevel)
{
	if(Oyuncu[playerid][p_adminlevel]>=alevel) return 1;
	return 0;
}

public aYardimSayfa1(playerid)
{
    new str[5000];
    strcat(str,"{c0c0c0}Leveline Ýzin Verilen Komutlar\n");
    strcat(str,"{c0c0c0}=========================================================================\n");
	if(IsAdmin(playerid,k_kick)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/kick (Player ID) (Sebep) : {FFFFFF}Belirtilen oyuncuyu oyundan atar.\n");
	if(IsAdmin(playerid,k_ban)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/ban (Player ID) (Sebep) : {FFFFFF}Belirtilen oyuncuyu sunucudan yasaklar.\n");
	if(IsAdmin(playerid,k_jail)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/jail (Player ID) (Süre) (Sebep) : {FFFFFF}Belirtilen oyuncuyu hapse atar.\n");
	if(IsAdmin(playerid,k_unjail)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/unjail (Player ID) : {FFFFFF}Hapiste olan oyuncuyu çýkarýr.\n");
	if(IsAdmin(playerid,k_warn)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/warn (Player ID) (Sebep) : {FFFFFF}Oyuncuya uyarý verir.\n");
	if(IsAdmin(playerid,k_spec)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/spec (Player ID) : {FFFFFF}Belirtilen oyuncuyu izler.\n");
	if(IsAdmin(playerid,k_specoff)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/specoff : {FFFFFF}Mevcut izlemeden çýkarýr.\n");
	if(IsAdmin(playerid,k_awork)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/awork : {FFFFFF}Durumunuzu meþgul/müsait olarak deðiþtirir.\n");
	if(IsAdmin(playerid,k_eject)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/eject (Player ID) : {FFFFFF}Oyuncuyu araçtan atar.\n");
	if(IsAdmin(playerid,k_burn)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/burn (Player ID) : {FFFFFF}Oyuncuyu yakar.\n");
	if(IsAdmin(playerid,k_ip)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/ip (Player ID) : {FFFFFF}Belirtilen oyuncunun IP'sini gösterir.\n");
	if(IsAdmin(playerid,k_asay)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/asay (Yazý) : {FFFFFF}Herkese admin mesajý yollar.\n");
	if(IsAdmin(playerid,k_announce)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/announce (Yazý) : {FFFFFF}Herkese anons yapar.\n");
	if(IsAdmin(playerid,k_goto)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/goto (Player ID) : {FFFFFF}Belirtilen oyuncuya ýþýnlanýr.\n");
	if(IsAdmin(playerid,k_get)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/get (Player ID) : {FFFFFF}Belirtilen oyuncuyu yanýnýza çeker.\n");
	if(IsAdmin(playerid,k_mute)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/mute (Player ID) : {FFFFFF}Oyuncunun konuþmasýný engeller.\n");
	if(IsAdmin(playerid,k_unmute)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/unmute (Player ID) : {FFFFFF}Oyuncunun konuþma engelini kaldýrýr.\n");
	if(IsAdmin(playerid,k_freeze)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/freeze (Player ID) : {FFFFFF}Oyuncuyu dondurur.\n");
	if(IsAdmin(playerid,k_unfreeze)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/unfreeze (Player ID) : {FFFFFF}Oyuncunun donmasýný kaldýrýr.\n");
	if(IsAdmin(playerid,k_slap)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/slap (Player ID) : {FFFFFF}Oyuncuya tokat atar.\n");
	if(IsAdmin(playerid,k_clearchat)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/clearchat : {FFFFFF}Chat ekranýný temizler.\n");
	if(IsAdmin(playerid,k_setskin)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setskin (Player ID) (Skin ID) : {FFFFFF}Belirtilen oyuncunun skinini deðiþtirir.\n");
	if(IsAdmin(playerid,k_setint)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setint (Player ID) (Interior ID) : {FFFFFF}Belirtilen oyuncunun interior id'sini deðiþtirir.\n");
	if(IsAdmin(playerid,k_setworld)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setworld (Player ID) (World ID) : {FFFFFF}Belirtilen oyuncunun virtual world'unu deðiþtirir.\n");
	if(IsAdmin(playerid,k_healall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/healall : {FFFFFF}Bütün Hesaplarýn canýný doldurur.\n");
	if(IsAdmin(playerid,k_armourall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/armourall : {FFFFFF}Bütün Hesaplarýn zýrhýný doldurur.\n");
	if(IsAdmin(playerid,k_gotols)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/gotols : {FFFFFF}Los Santos'a ýþýnlar.\n");
	if(IsAdmin(playerid,k_gotosf)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/gotosf : {FFFFFF}San Fierro'ya ýþýnlar.\n");
	if(IsAdmin(playerid,k_gotolv)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/gotolv : {FFFFFF}Las Venturas'a ýþýnlar.\n");
	if(IsAdmin(playerid,k_setalltime)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setalltime (Saat) : {FFFFFF}Bütün Hesaplarýn saatini deðiþtirir.\n");
	if(IsAdmin(playerid,k_setallweather)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setallweather (Weather ID) : {FFFFFF}Bütün Hesaplarýn hava durumunu deðiþtirir.\n");
	if(IsAdmin(playerid,k_reswarn)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/reswarn (Player ID) : {FFFFFF}Oyuncunun uyarýlarýný sýfýrlar.\n");
	if(IsAdmin(playerid,k_givemoney)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/givemoney (Player ID) (Para) : {FFFFFF}Belirtilen oyuncuya para gönderir.\n");
	if(IsAdmin(playerid,k_giveallmoney)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/giveallmoney (Para) : {FFFFFF}Bütün Hesaplara para gönderir.\n");
	if(IsAdmin(playerid,k_setmoney)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setmoney (Player ID) (Para) : {FFFFFF}Belirtilen oyuncunun parasýný deðiþtirir.\n");
	if(IsAdmin(playerid,k_setallmoney)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setallmoney (Player ID) (Para) : {FFFFFF}Bütün Hesaplarýn parasýný deðiþtirir.\n");
    strcat(str,"{c0c0c0}=========================================================================");
    Dialog(playerid,DIALOG+6,d_msgbox,str,"Devam","Tamam");
	return 1;
}

public aYardimSayfa2(playerid)
{
    new str[3048];
    strcat(str,"{c0c0c0}Leveline Ýzin Verilen Komutlar\n");
    strcat(str,"{c0c0c0}=========================================================================\n");
	if(IsAdmin(playerid,k_setscore)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setscore (Player ID) (Score) : {FFFFFF}Oyuncunun skorunu deðiþtirir.\n");
	if(IsAdmin(playerid,k_givescore)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/givescore (Player ID) (Score) : {FFFFFF}Oyuncuya skor gönderir.\n");
	if(IsAdmin(playerid,k_givecar)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/givecar (Player ID) (Veh ID) : {FFFFFF}Oyuncuyu belirtilen araca bindirir.\n");
	if(IsAdmin(playerid,k_car)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/car (Veh ID) : {FFFFFF}Belirtilen araç oyuncuya bindirilir.\n");
	if(IsAdmin(playerid,k_showstats)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/showstats (Player ID) : {FFFFFF}Oyuncunun istatistiklerini gösterir.\n");
	if(IsAdmin(playerid,k_setwanted)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setwanted (Player ID) (Wanted Level) : {FFFFFF}Oyuncunun wanted leveli deðiþtirilir.\n");
	if(IsAdmin(playerid,k_setallwanted)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setallwanted (Wandted Level) : {FFFFFF}Bütün Hesaplarýn wanted leveli deðiþtirilir.\n");
	if(IsAdmin(playerid,k_setallskin)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setallskin (Skin ID) : {FFFFFF}Bütün Hesaplarýn skini deðiþtirilir.\n");
	if(IsAdmin(playerid,k_sethealth)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/sethealth (Player ID) (Deðer) : {FFFFFF}Bütün Hesaplarýn caný belirtilen deðer ile deðiþtirilir.\n");
	if(IsAdmin(playerid,k_setarmour)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/setarmour (Player ID) (Deðer) : {FFFFFF}Bütün Hesaplarýn zýrhý belirtilen deðer ile deðiþtirilir.\n");
	if(IsAdmin(playerid,k_akill)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/akill (Player ID) : {FFFFFF}Oyuncuyu öldürür.\n");
	if(IsAdmin(playerid,k_killall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/killall : {FFFFFF}Bütün Hesaplarý öldürür.\n");
	if(IsAdmin(playerid,k_kickall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/kickall (Sebep) : {FFFFFF}Bütün Hesaplarý oyundan atar.\n");
	if(IsAdmin(playerid,k_disarm)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/disarm (Player ID) : {FFFFFF}Oyuncunun silahlarýný resetler.\n");
	if(IsAdmin(playerid,k_disarmall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/disarmall : {FFFFFF}Bütün Hesaplarýn silahlarýný resetler.\n");
	if(IsAdmin(playerid,k_ejectall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/ejectall : {FFFFFF}Bütün Hesaplarý araçlarýndan atar.\n");
	if(IsAdmin(playerid,k_spawn)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/spawn (Player ID) : {FFFFFF}Belirtilen oyuncuyu spawnlar.\n");
	if(IsAdmin(playerid,k_spawnall)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/spawnall : {FFFFFF}Bütün Hesaplarý spawnlar.\n");
	if(IsAdmin(playerid,k_cmdmute)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/cmdmute (Player ID) : {FFFFFF}Oyuncunun komut kullanmasýný engeller.\n");
	if(IsAdmin(playerid,k_cmdunmute)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/cmdunmute (Player ID) : {FFFFFF}Oyuncunun komut kullanma engelini kaldýrýr.\n");
	if(IsAdmin(playerid,k_giveweapon)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/giveweapon (Player ID) (Weap ID) (Ammo) : {FFFFFF}Belirtilen oyuncuya silah ve kurþun verir.\n");
	if(IsAdmin(playerid,k_giveallweapon)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/giveallweapon (Weap ID) (Ammo) : {FFFFFF}Bütün Hesaplara silah ve kurþun verir.\n");
	if(IsAdmin(playerid,k_move)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/move (x,y,z) (Deðer) : {FFFFFF}Belirtilen yönde hareket ettirir.\n");
	if(IsAdmin(playerid,k_god)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/god : {FFFFFF}Ölümsüzlük modunu açar.\n");
	if(IsAdmin(playerid,k_godcar)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/godcar : {FFFFFF}Araç ölümsüzlük modunu açar.\n");
	if(IsAdmin(playerid,k_agod)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/agod (Player ID) : {FFFFFF}Bir oyuncuya ölümsüzlük modu açtýrýr.\n");
	if(IsAdmin(playerid,k_inv)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/inv : {FFFFFF}Oyuncu haritada görünmez olur.\n");
	if(IsAdmin(playerid,k_jetpack)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/jetpack : {FFFFFF}Oyuncuya jetpack verir.\n");
	if(IsAdmin(playerid,k_makeadmin)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/makeadmin (Player ID) (Level) : {FFFFFF}Oyuncunun admin levelini deðiþtirir.\n");
	if(IsAdmin(playerid,k_restart)) strcat(str,"{00FF00}"); else strcat(str,"{FF0000}");
	strcat(str,"/restart (Saniye) : {FFFFFF}Sunucuya belirtilen zamanda restart atar.\n");
    strcat(str,"{c0c0c0}=========================================================================");
    Dialog(playerid,DIALOG+7,d_msgbox,str,"Geri","Tamam");
	return 1;
}

public HapisKontrol(playerid)
{
	if(Oyuncu[playerid][a_jail] == 1)
	{
		SetPlayerPos(playerid,Jail_CordX,Jail_CordY,Jail_CordZ);
		SetPlayerInterior(playerid,Jail_CordInt);
		SetPlayerVirtualWorld(playerid,9999);
		GameTextForPlayer(playerid,"~w~jail sureniz bitmedigi icin tekrar~n~~r~hapse gonderildiniz!",5000,3);
	} else SetPlayerVirtualWorld(playerid,0);
	return 1;
}

stock KaydetINT(playerid,yazi[],deger)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	dini_IntSet(dosya,yazi,deger);
}

stock KaydetSTR(playerid,yazi[],deger[])
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	dini_et(dosya,yazi,deger);
}

stock KaydetFLO(playerid,yazi[],Float:deger)
{
	new dosya[64];
	format(dosya,sizeof(dosya),"/Hesaplar/Bilgiler/%s.ini",PlayerName(playerid));
	dini_IntSet(dosya,yazi,deger);
}

stock EkranTemizle(playerid)
{
	for(new i;i<100;i++) SendClientMessage(playerid,-1," ");
}

stock BanPlayer(adminid,playerid,sebep[])
{
	new y[128];
	TarihAl();
	EkranTemizle(playerid);
	format(y,sizeof(y),"{FF0000}Admin tarafýndan sunucudan yasaklandýnýz.\n");
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"\n");
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Admin: {FFFFFF}%s\n",PlayerName(adminid));
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Tarih: {FFFFFF}%02d %s %d\n",gun,ay,yil);
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Saat: {FFFFFF}%02d:%02d:%02d\n",saat,dakika,saniye);
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Sebep: {FFFFFF}%s",sebep);
	SendClientMessage(playerid,-1,y);
	OyuncuCikisSebep[playerid] = 3;
	PlayerPlaySound(playerid,1068,0.0,0.0,0.0);
	TogglePlayerControllable(playerid,false);
	Ban(playerid);
}

stock KickPlayer(adminid,playerid,sebep[])
{
	new y[128];
	TarihAl();
	EkranTemizle(playerid);
	format(y,sizeof(y),"{FF0000}Admin tarafýndan sunucudan atýldýnýz.\n");
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"\n");
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Admin: {FFFFFF}%s\n",PlayerName(adminid));
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Tarih: {FFFFFF}%02d %s %d\n",gun,ay,yil);
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Saat: {FFFFFF}%02d:%02d:%02d\n",saat,dakika,saniye);
	SendClientMessage(playerid,-1,y);
	format(y,sizeof(y),"{FF0000}Sebep: {FFFFFF}%s",sebep);
	SendClientMessage(playerid,-1,y);
	OyuncuCikisSebep[playerid] = 2;
	PlayerPlaySound(playerid,1068,0.0,0.0,0.0);
	TogglePlayerControllable(playerid,false);
	Kick(playerid);
}

stock MutePlayer(playerid)
{
	OyuncuMute[playerid] = true;
}

stock HataMesaj(playerid,yazi[])
{
	new str[256];
	format(str,sizeof(str),"» HATA: {FFFFFF}%s",yazi);
	SendClientMessage(playerid,0xF63845AA,str);
    PlayBadSound(playerid);
	return 1;
}

stock BilgiMesaj(playerid,yazi[])
{
	new str[256];
	format(str,sizeof(str),"» BÝLGÝ: {FFFFFF}%s",yazi);
	SendClientMessage(playerid,0x00A2F6AA,str);
    PlayGoodSound(playerid);
	return 1;
}

stock UyariMesaj(playerid,yazi[])
{
	new str[256];
	format(str,sizeof(str),"» UYARI: {FFFFFF}%s",yazi);
	SendClientMessage(playerid,0x009BFFAA,str);
    PlayBadSound(playerid);
	return 1;
}

stock AdminMesajj(yazi[])
{
	#if ADMIN_MESSAGES == true
	new str[256];
	format(str,sizeof(str),"{ACDA00}» ADMIN: {FFFFFF}%s",yazi);
	for(new i;i<MAX_PLAYERS;i++) if(OyuncuAdmin[i] == true) SendClientMessage(i,-1,str),PlayGoodSound(i);
	#else
	return 1;
	#endif
}

stock Dialog(playerid,did,style,yazi[],button1[],button2[])
{
	ShowPlayerDialog(playerid,did,style,DIALOG_BASLIK,yazi,button1,button2);
}

stock PlayerName(playerid)
{
    new string[24];
    GetPlayerName(playerid,string,24);
    return string;
}

stock WeaponName(weapid)
{
    new string[24];
    GetWeaponName(weapid,string,24);
    return string;
}

stock PlayerIP(playerid)
{
    new string[24];
    GetPlayerIp(playerid,string,24);
    return string;
}

stock udb_hash(buf[]) {
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

stock HexToInt(string[])
{
    if (string[0] == 0)
    {
        return 0;
    }
    new i;
    new cur = 1;
    new res = 0;
    for (i = strlen(string); i > 0; i--)
    {
        if (string[i-1] < 58)
        {
            res = res + cur * (string[i - 1] - 48);
        }
        else
        {
            res = res + cur * (string[i-1] - 65 + 10);
            cur = cur * 16;
        }
    }
    return res;
}

stock Lower(str[])
{
	new s[128],i=0;
	for(;str[i] != 0;i++)
	{
	    s[i]=toLower(str[i]);
	}
	s[i]='\0';
	return s;
}

stock toLower(c) // Ryder Function
{
   return ('A' <= c <= 'Z') ? (c += 'a' - 'A') : (c);
}

stock GetMaxIP(p_ip[])
{
	new ip[32+1];
	new x = 0;
	new ip_adet = 0;
	for(x=0; x<MAX_PLAYERS; x++) {
		if(IsPlayerConnected(x)) {
		    GetPlayerIp(x,ip,32);
		    if(!strcmp(ip,p_ip)) ip_adet++;
		}
	}
	return ip_adet;
}

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

stock strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
