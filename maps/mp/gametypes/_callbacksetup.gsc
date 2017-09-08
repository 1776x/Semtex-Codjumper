#include emz\_utility;

CodeCallback_StartGameType()
{
//	addCommands();

	if(!isDefined(level.gametypestarted) || !level.gametypestarted){
		[[level.callbackStartGameType]]();
		level.gametypestarted = true;
		setDvar("g_gravity", 800);
		setDvar("g_speed", 190);
	}
}
CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	[[level.callbackPlayerConnect]]();
}

CodeCallback_PlayerDisconnect()
{
	self notify("disconnect");
	[[level.callbackPlayerDisconnect]]();
}

CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	self endon("disconnect");
	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	[[level.callbackPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

CodeCallback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration )
{
}

//=============================================================================

SetupCallbacks()
{
	SetDefaultCallbacks();
	
	level.iDFLAGS_RADIUS			= 1;
	level.iDFLAGS_NO_ARMOR			= 2;
	level.iDFLAGS_NO_KNOCKBACK		= 4;
	level.iDFLAGS_PENETRATION		= 8;
	level.iDFLAGS_NO_TEAM_PROTECTION = 16;
	level.iDFLAGS_NO_PROTECTION		= 32;
	level.iDFLAGS_PASSTHRU			= 64;
}

SetDefaultCallbacks()
{
	level.callbackStartGameType = emz\_globallogic::Callback_StartGameType;
	level.callbackPlayerConnect = emz\_globallogic::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = emz\_globallogic::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = emz\_globallogic::Callback_PlayerDamage;
	level.callbackPlayerKilled = emz\_globallogic::Callback_PlayerKilled;
}

AbortLevel()
{
	println("Aborting level - gametype is not supported");
	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;
	setDvar("g_gametype", "cj");
	exitLevel(false);
}

callbackVoid()
{
}

addCommands()
{
/*	addScriptCommand("cjcancel", 50);
	addScriptCommand("cjforce", 50);
	addScriptCommand("tptome", 25);
	addScriptCommand("tpmeto", 25);
	addScriptCommand("changemodel", 25);
	addScriptCommand("myshortguid", 1);
	addScriptCommand("sayhello", 1);
	addScriptCommand("givesmxadmin", 90);
	addScriptCommand("takesmxadmin", 90);*/
}

CodeCallback_ScriptCommand(command, arguments)
{
	if(self.name != "")
		Callback_ScriptCommandPlayer( command, arguments );
	else
		Callback_ScriptCommand( command, arguments );
}

Callback_ScriptCommandPlayer(command, arguments)
{

    switch(command)
    {
        case "sayhello":
        {
    		self sayAll("Hello!");
    		break;
    	}

	    case "givesmxadmin":
	    {	
	    	args = strTok(arguments, " ");
	    	if(args.size == 3)
	    		setDvar("smx_promote", args[0] + ":" + args[1] + ":" + args[2]);
	    	break;
	    }

	    case "takesmxadmin":
	    {	
	    	args = strTok(arguments, " ");
	    	if(args.size == 2)
	    		setDvar("smx_demote", args[0] + ":" + args[1]);
	    	break;
	    }	

	    case "myshortguid":
	    	self iPrintLn("Your short guid is: ", getSubStr( self getGuid(), 24, 32 ));
	    	break;

	    case "tpmeto":
	    {
			player = getPlayerByNamePart(arguments);
			self setOrigin(player.origin);
			self setPlayerAngles(player.angles);
			break;
		}

		case "tptome":
		{
			player = getPlayerByNamePart(arguments);
			player setOrigin(self.origin);
			player setPlayerAngles(self.angles);
			break;
		}

		case "cjcancel":
		{
			if(level.cjvoteinprogress == 1)
			{
				if(self.cj["status"] < 2)
					self iprintln("You do not have privileges to cancel votes");
				else
					level notify("votecancelled");
			}
			else
				self iprintln("There is no vote in progress");

			break;		
		}
		case "cjforce":
		{
			if(level.cjvoteinprogress == 1)
			{
				if(self.cj["status"] < 2)
					self iprintln("You do not have privileges to force votes");
				else
					level notify("voteforce");
			}
			else
				self iprintln("There is no vote in progress");	

			break;
		}

		case "changemodel":
		{
			self detachAll();
			self setViewModel("viewhands_usmc");	

			switch(arguments)
			{
			
			case "zoey":
			self setModel("body_zoey");
			break;
			
			case "mc":
			self setModel("mc_char");
			break;
			
			case "price":
			self setModel("body_complete_mp_price_woodland");
			break;
			
			case "makarov":
			self setModel("body_makarov");
			break;
			
			case "shepherd":
			self setModel("body_shepherd");
			break;
			
			case "masterchief":
			self setModel("body_masterchief");
			break;
			
			case "juggernaut":
			self setModel("body_juggernaut");
			break;
			
			case "farmer":
			self setModel("body_complete_mp_russian_farmer");
			break;
			
			case "alasad":
			self setModel("body_complete_mp_al_asad");
			break;
			
			case "zakhaev":
			self setModel("body_complete_mp_zakhaev");
			break;
			
			case "duke":
			self detachAll();
			self setModel("playermodel_dnf_duke");
			self setViewModel("viewhands_dnf_duke");	
			break;
			
			default:
			self setModel("body_mp_sas_urban_assault");
			break;
			}

			break;
		}

    }
}

Callback_ScriptCommand(command, arguments)
{
	iPrintLn("Rcon Command: ", command, " Arguments: ",arguments);
}