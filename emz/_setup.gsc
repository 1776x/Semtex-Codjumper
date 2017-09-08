#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include emz\_utility;

sprayLogo()
{
    self endon( "disconnect" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );
    self notify("endspray");
    self endon("endspray");

    while( isAlive(self) )
    {
        while( !self fragButtonPressed() )
            wait .2;

        if( !self isOnGround() )
        {
            wait 0.2;
            continue;
        }

        angles = self getPlayerAngles();
        eye = self getTagOrigin( "j_head" );
        forward = eye + vector_scale( anglesToForward( angles ), 70 );
        trace = bulletTrace( eye, forward, false, self );

        if( trace["fraction"] == 1 )
        {
            wait 0.1;
            continue;
        }

        position = trace["position"] - vector_scale( anglesToForward( angles ), -2 );
        angles = vectorToAngles( eye - position );
        forward = anglesToForward( angles );
        up = anglesToUp( angles );
        self setClientDvars("fx_enable", 1, "fx_marks", 1 );
        playFX( level.fx_spray, position, forward, up );
        wait 0.05;
        self setClientDvar("fx_enable", self emz\_cj_client::get_config("CJ_FX"));

        wait 5;
    }
}

setupDvars()
{
	level.fx_spray = loadFX( "emz/spray0" );

	setDvarWrapper("cj_welcome", "1::CoD^8Jumper^7.com ^1Mod::2::^1Save Position^7 - DoubleTap ^2Melee^7::0.05::^1Load Position^7 - DoubleTap ^2Use^7::0.05::^1Suicide^7 - Hold ^2Melee^7 [3 seconds]");
	setDvarWrapper("cj_nosave", 0);
	setDvarWrapper("cj_disablerpg", 0);
	setDvarWrapper("cj_voteduration", 30);
	setDvarWrapper("cj_votelockout", 15);
	setDvarWrapper("cj_votedelay", 180);
	setDvarWrapper("cj_timelimit", 45);

	mapname = getDvar("mapname");
	setMapDvar("cj_" + mapname + "_nosave","cj_nosave");
	setMapDvar("cj_" + mapname + "_disablerpg","cj_disablerpg");

	level.cjVoteInProgress = 0;
	level.cjVoteYes = 0;
	level.cjVoteNo = 0;
	level.cjVoteType = "";
	level.cjVoteCalled = "";
	level.cjVoteAgainst = "";
	level.cjVoteArg = undefined;

	level._cj_nosave = getDvarInt("cj_nosave");
	level.cjvoteduration = getDvarInt("cj_voteduration");
	level.cjvotelockout = getDvarInt("cj_votelockout") + level.cjvoteduration;
	level.cjvotedelay = getDvarFloat("cj_votedelay");
	level.timeLimit = getDvarFloat("cj_timelimit");
	level.ggLoopTime = 15;
	level.knockback = getDvar("g_knockback");
}
setupLanguage()
{
	self.cj["local"]["NOPOS"] 		= &"CJ_NOPOS";
	self.cj["local"]["POSLOAD"] 	= &"CJ_POSLOAD";
	self.cj["local"]["SAVED"] 		= &"CJ_SAVED";
	self.cj["local"]["PROMOTED"] 	= &"CJ_PROMOTED";
	self.cj["local"]["DEMOTED"]		= &"CJ_DEMOTED";
	self.cj["local"]["NOSAVE"] 		= &"CJ_NOSAVE";
	self.cj["local"]["NOSAVEZONE"] 	= &"CJ_NOSAVEZONE";
	self.cj["local"]["PREVPOS"] 	= &"CJ_PREVPOS";
	self.cj["local"]["NOPREVPOS"] 	= &"CJ_NOPREVPOS";
}
setChosenJumpStyle( type )
{
	self thread [[level.setJumpHeight]](39);	
		
	if( type )
		self thread [[level.setJumpHeight]](64);
}
setupPlayer()
{
	self endon("disconnect");

	self.cj["save"] = [];
	self.cj["hud"] = [];

	if(!isDefined(self.cj["status"]))
		self.cj["status"] = 0;

	self.cj["vote"] = [];
	self.cj["vote"]["voted"] = false;

	self.cj["admin"] = [];
	self.cj["trigWait"] = 0;
	self.cj["os_mode"] = false;
	
	self.cj["ggUsedTime"] = 0;

	self.cj["loads"] = 0;
	self.cj["saves"] = 0;
	self.cj["jumps"] = 0;
	self.cj["rpgjumps"] = 0;
	self.cj["distance"] = 0;
	self.cj["time"] = 0;
	self.cj["maxfps"] = self getMaxFPS();

	self.cj["spawned"] = 0;
	self.cj["lastCheckPointTime"] = getTime();
	self.cj["checkpoint"] = 0;
	self.cj["progress"] = 0;
	self.cj["lastvotetime"] = getTime();
	self.cj["connectTime"] = getTime();

	if(!isDefined(self.cj["positionLog"]))
		self.cj["positionLog"] = [];

	self setClientDvars("fx_marks", 1, "player_sprintTime", 12.8, "player_sprintRechargePause", 0, "cg_everyoneHearsEveryone", 1, "aim_automelee_range", 0, "r_filmUseTweaks", 1 );
}
onPlayerSpawned()
{
	self thread giveLoadout();
	self thread rpgAmmoCheck();

	self thread emz\_hud::drawInfoHud();
	
	self thread emz\shop::spawnplayer();

	if(!self.cj["spawned"])
	{
		self thread [[level.onPlayerStartedMap]]();
		self.cj["spawned"] = true;
		self.cj["save"]["org0"] = self getOrigin();
		self.cj["save"]["ang0"] = self getPlayerAngles();
		wait 0.05;
		self execClientCommand("setfromdvar temp0 com_maxfps; setu com_maxfps 125; setfromdvar com_maxfps temp0");
	}
}
onJoinedSpectators()
{
	self thread emz\_hud::onJoinedSpectators();
}

giveLoadout()
{
	self endon("disconnect");
	
	wait 0.05;
	self takeAllWeapons();
	self detachAll();

	if(!self _isPlayer())
	{
		self setClientDvar("currentmodel", tableLookup( "mp/modelTable.csv", 0, self getStat(100), 1 ));
		self setModel(tableLookup( "mp/modelTable.csv", 0,  self getStat(100), 2 ));
		self setViewModel(tableLookup( "mp/modelTable.csv", 0,  self getStat(100), 3 ));
	}
	else if(self getStat(1169)!=0)
	{
		self setModel(level.shopmodel[self getStat(1169)][0]);
		self setClientDvar("shopmodel",level.shopmodel[self getStat(1169)][1]);
		self setViewModel("viewhands_usmc");
	}
	else
	{
		self setModel("body_mp_sas_urban_assault");
		self setViewModel("viewhands_usmc");
	}

	self clearPerks();
	self setPerk("specialty_longersprint");
	self setPerk("specialty_fastreload");
	
	self giveWeapon("rpg_mp");
	self giveMaxAmmo("rpg_mp");
	self setActionSlot( 4, "weapon", "rpg_mp" );
	self giveWeapon( "deserteagle_tactical_mp" );
	self setWeaponAmmoClip("deserteagle_tactical_mp", 0);
	self setWeaponAmmoStock("deserteagle_tactical_mp", 0);
	wait 0.05;
	self switchToWeapon( "deserteagle_tactical_mp" );

	if (self isAdmin())
	{
		self giveWeapon("gravitygun_mp");
		self giveWeapon("deserteaglegold_mp");
		self giveMaxAmmo( "gravitygun_mp" );	
		self giveMaxAmmo( "deserteaglegold_mp" );	
		self giveMaxAmmo( "deserteagle_tactical_mp" );
		self setWeaponAmmoClip("deserteagle_tactical_mp", 7);
		self setActionSlot( 3, "weapon", "gravitygun_mp" );
	}
	else if(self isVip())
	{
		self giveWeapon("gravitygun_mp");
		self giveMaxAmmo( "gravitygun_mp" );	
		self giveMaxAmmo( "deserteagle_tactical_mp" );
		self setActionSlot( 3, "weapon", "gravitygun_mp" );
	}
	else
		self thread gravityGun();
}
rpgAmmoCheck()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("killed_player");

	while(1)
	{		
		while(self getAmmoCount("rpg_mp") > 5 || !self hasWeapon("rpg_mp"))	
			wait 0.05;
			
		self giveMaxAmmo("rpg_mp");
		wait 0.05;
	}
}
gravityGun()
{
	self endon("disconnect");
	
	if(isDefined(self.cj["ggthread"]))
		return;

	self.cj["ggthread"] = true;

	while(1)
	{		
		if((self.cj["ggUsedTime"] + minToMSec(level.ggLoopTime)) <= getTime() && !self hasWeapon("gravitygun_mp"))
		{	
			self setClientDvar("gravitygun_timeleft", 0);
			self giveWeapon("gravitygun_mp");
			self setWeaponAmmoStock("gravitygun_mp",0);
			self setWeaponAmmoClip("gravitygun_mp",50);
			self setActionSlot( 3, "weapon", "gravitygun_mp" );
		}
		if( !self getWeaponAmmoClip("gravitygun_mp"))
		{
			self.cj["ggUsedTime"] = getTime();
			self takeWeapon("gravitygun_mp");
			self dvarThread();
		}
		wait 0.05;
	}
}
dvarThread()
{
	self endon("disconnect");

	for(i = minToSec(level.ggLoopTime); i >= 0; i --)
	{
		self setClientDvar("gravitygun_timeleft", i );
		wait 1;
	}
}