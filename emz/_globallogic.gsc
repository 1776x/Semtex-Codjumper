#include maps\mp\_utility;
#include common_scripts\utility;
#include emz\_hud_util;
#include emz\_utility;

init()
{
	emz\_precache::precache();
	emz\_files::init();
	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );
	thread deleteUselessMapStuff();
}

deleteUselessMapStuff()
{	
	deletePlacedEntity("misc_turret");
	deletePlacedEntity("misc_mg42");
	arrayForDelete = getentarray( "oldschool_pickup", "targetname" );	
	for ( i = 0; i < arrayForDelete.size; i++ ){
		if ( isdefined( arrayForDelete[i].target ) )
			getent( arrayForDelete[i].target, "targetname" ) delete();
		arrayForDelete[i] delete();
	}
	wait 0.05;
	AmbientStop( 0 );
}

SetupCallbacks()
{
	level.menuPlayer = ::menuPlayer;
	level.spawnPlayer = ::spawnPlayer;
	level.menuSpectator = ::menuSpectator;
	level.onPlayerStartedMap = ::onPlayerStartedMap;
	level.onMapFinished = ::onMapFinished;
}
onPlayerStartedMap()
{
	self.cj["mapStartTime"] = getTime();
}
onMapFinished() 
{
	level.finishers[level.finishers.size] = self;
	iPrintLn(self.name + " finished the map in: " + self getMapFinishTime());
}
getMapFinishTime()
{
	if(entityInArray(level.finishers,self))
		return secondsToTime(mSecToSec(getTime() - self.cj["mapStartTime"]));

	return false;
}

Callback_PlayerConnect()
{
	if( isDefined( self ) )
		level notify( "connecting", self );
		
	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );
	waittillframeend;

	if(self isBot())
		return;
		
	level notify( "connected", self );
		
	self initHudStuff();
	self setSpectatePermission();	
	self.spectatorClient = -1;
	self.sessionteam = "allies";

	iPrintLn(&"MP_CONNECTED",self.name);

	/*if(level.welcometime) 
		self thread emz\_chatmsg::write();*/
		
	self thread emz\shop::connect();
		
	logPrint("J;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n");
	level.players[level.players.size] = self;
	level endon( "game_ended" );	
	[[level.menuPlayer]]();
}

menuPlayer()
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );

	self closeMenu();
	self closeInGameMenu();
	self setClientDvar( "ui_hud_spectator", 0 );
	if(isAlive(self))
		self suicide();
	self notify("joined_team");
	level notify("joined_team", self );

	self.statusicon = "";
	self setclientdvars( "g_scriptMainMenu", "class" );
	self thread	[[level.spawnPlayer]]();
}
spawnPlayer()
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self notify( "spawned" );

	self.sessionstate = "playing";
	self.cj["team"] = "player";
	self.sessionteam = "allies";

	self.maxhealth = 100;
	self.health = 100;
	spawnPoint = emz\_spawnlogic::getSpawnpoint_Random( emz\_spawnlogic::getTeamSpawnPoints( "allies" ) );
	self spawn( spawnPoint.origin, spawnPoint.angles );
	waittillframeend;
	self notify( "spawned_player" );
	waittillframeend;
	self emz\_setup::onPlayerSpawned();	
}

menuSpectator()
{
	self endon("disconnect");
	self endon("spawned_player");	

	self closeMenu();
	self closeInGameMenu();
	
	self setClientDvar( "ui_hud_spectator", 1 );
	
	angles = self getPlayerAngles();
	position = self getOrigin();

	if(isAlive(self))
		self suicide();
	
	self notify("spawned");
	self notify("joined_spectator");
	level notify("joined_spectator", self );
	
	self.sessionstate = "spectator";
	self.cj["team"] = "spectator";
	self.sessionteam = "axis";
	self.statusicon = "hud_status_spectator";
	self spawn( position, angles );
	
	self thread emz\_setup::onJoinedSpectators();
	self notify( "joined_spectators" );
}

Callback_StartGameType()
{
	game["gamestarted"] = true;
	level.teamSpawnPoints["allies"] = [];
	initLevelUiParent();
	thread emz\_serversettings::init();
	thread emz\_holographic::init();
	thread emz\_advertise::init();
	thread emz\_chatmsg::main();
	thread emz\_redirect::main();
	thread emz\shop::main();
	level.players = [];
	[[level.onStartGameType]]();
	level.startTime = getTime();
	level thread updateGameTypeDvars();
}

setSpectatePermission()
{
	self allowSpectateTeam( "allies", true);
	self allowSpectateTeam( "axis", true );
	self allowSpectateTeam( "none", true );
	self allowSpectateTeam( "freelook", true );
}

Callback_PlayerDisconnect()
{		
	self notify("disconnect");
	level notify("disconnect", self);

	logPrint("Q;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n");
	
	for (i = 0; i < level.players.size; i++)
	{
		if (level.players[i] == self)
		{
			while (i < level.players.size - 1)
			{
				level.players[i] = level.players[i + 1];
				i++;
			}
			level.players[i] = undefined;
			break;
		}
	}
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_FALLING"|| sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_IMPACT" )
		return;

	if(isDefined(eAttacker) && isPlayer(eAttacker) && !eAttacker isAdmin())
		iDamage = 0;
	
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
	if(isDefined(eAttacker) && isPlayer(eAttacker))
	{
		eAttacker playlocalsound( "MP_hit_alert" );
		
		eAttacker.hud_damagefeedback.alpha = 1;
		wait 0.5;
		eAttacker.hud_damagefeedback fadeovertime( 0.1 );
		eAttacker.hud_damagefeedback.alpha = 0;
	}
}

Callback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("disconnect");
	eAttacker endon("disconnect");
	self endon( "spawned" );

	if ( self.sessionState == "spectator" )
		return;
		
	self notify( "killed_player" );

	if (isHeadShot(sHitLoc, sMeansOfDeath)) 
		sMeansOfDeath = "MOD_HEAD_SHOT";

	obituary(self, eAttacker, sWeapon, sMeansOfDeath);
	waittillframeend;
	self thread	[[level.spawnPlayer]]();
}

isHeadShot(sHitLoc, sMeansOfDeath)
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_IMPACT";
}

endGameWrapper()
{
	if(!isDefined(level.endgamewrapper))
	{
		level.endgamewrapper = true;
		thread emz\_cj_voting::cjVoteCalled("extend", undefined, undefined, 30);
		level waittill("vote_completed", passed);
		if(!passed)
		{
			wait 3;
			endgame();
		}
		else thread updateGameTypeDvars();

		level.endgamewrapper = false;
	}
}

endGame()
{
	level notify ( "game_ended" );
	wait 0.05;	
	exitLevel( false );
}

updateGameTypeDvars()
{
	level notify("ugtd_exit");
	level endon("ugtd_exit");

	while(1)
	{
		thread checkTimeLimit();
		if (isDefined(level.startTime) && getTimeRemaining() < 3000)
		{
			wait 0.1;
			continue;
		}
		wait 1;
	}
}
checkTimeLimit()
{
	if (!isDefined(level.startTime)) 
		return;
		
	timeLeft = getTimeRemaining();
	setGameEndTime(getTime() + int(timeLeft));

	if (timeLeft > 0) 
		return;
		
	thread endGameWrapper();
}
getTimeRemaining()
{
	return level.timeLimit * 60000 - getTimePassed();
}
getTimePassed()
{
	if (!isDefined(level.startTime)) 
		return 0;
	return (gettime() - level.startTime);
}
initLevelUiParent()
{
	level.uiParent = spawnstruct();
	level.uiParent.horzAlign = "left";
	level.uiParent.vertAlign = "top";
	level.uiParent.alignX = "left";
	level.uiParent.alignY = "top";
	level.uiParent.x = 0;
	level.uiParent.y = 0;
	level.uiParent.width = 0;
	level.uiParent.height = 0;
	level.uiParent.children = [];	
	level.fontHeight = 12;
	level.lowerTextYAlign = "CENTER";
	level.lowerTextY = 70;
	level.lowerTextFontSize = 2;
}
initHudStuff()
{
	self.notifyTitle = createFontString( "objective", 2.5 );
	self.notifyTitle setPoint( "TOP", undefined, 0, 30 );
	self.notifyTitle.glowColor = (0.2, 0.3, 0.7);
	self.notifyTitle.glowAlpha = 1;
	self.notifyTitle.hideWhenInMenu = true;
	self.notifyTitle.archived = false;
	self.notifyTitle.alpha = 0;
	self.notifyText = createFontString( "objective", 1.75 );
	self.notifyText setParent( self.notifyTitle );
	self.notifyText setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyText.glowColor = (0.2, 0.3, 0.7);
	self.notifyText.glowAlpha = 1;
	self.notifyText.hideWhenInMenu = true;
	self.notifyText.archived = false;
	self.notifyText.alpha = 0;
	self.notifyText2 = createFontString( "objective", 1.75 );
	self.notifyText2 setParent( self.notifyTitle );
	self.notifyText2 setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyText2.glowColor = (0.2, 0.3, 0.7);
	self.notifyText2.glowAlpha = 1;
	self.notifyText2.hideWhenInMenu = true;
	self.notifyText2.archived = false;
	self.notifyText2.alpha = 0;
	self.notifyIcon = createIcon( "white", 30, 30 );
	self.notifyIcon setParent( self.notifyText2 );
	self.notifyIcon setPoint( "TOP", "BOTTOM", 0, 0 );
	self.notifyIcon.hideWhenInMenu = true;
	self.notifyIcon.archived = false;
	self.notifyIcon.alpha = 0;
	self.doingNotify = false;
	self.notifyQueue = [];
	
	level.uiParent = spawnstruct();
	level.uiParent.horzAlign = "left";
	level.uiParent.vertAlign = "top";
	level.uiParent.alignX = "left";
	level.uiParent.alignY = "top";
	level.uiParent.x = 0;
	level.uiParent.y = 0;
	level.uiParent.width = 0;
	level.uiParent.height = 0;
	level.uiParent.children = [];
		
	self.hud_damagefeedback = newClientHudElem( self );
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader("damage_feedback", 24, 48);
}
