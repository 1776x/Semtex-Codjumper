/* ______      ____      __
  / ____/___  / __ \    / /_  ______ ___  ____  ___  _____ _________  ____ ___
 / /   / __ \/ / / /_  / / / / / __ `__ \/ __ \/ _ \/ ___// ___/ __ \/ __ `__ \
/ /___/ /_/ / /_/ / /_/ / /_/ / / / / / / /_/ /  __/ /  _/ /__/ /_/ / / / / / /
\____/\____/_____/\____/\__,_/_/ /_/ /_/ .___/\___/_/  (_)___/\____/_/ /_/ /_/
                                      /_/
   --------------------------------------------------
   - Thanks for taking an interest in OUR mod.      -
   - Feel free to borrow our code and claim it as   -
   - your own. It hasn't stopped you in the past.   -                                         -
   -               * CoDJumper Team *               -
   ------------------------------------------------*/

#include emz\_utility;
#include emz\_cj_client;
#include emz\_hud_util;
#include common_scripts\utility;

init()
{
	//thread emz\_rank_bots::init();
	emz\_setup::setupDvars();

	thread emz\_cj_admins::adminInit();
	thread emz\_cj_mappers::init();
	thread emz\ninja_serverfile::init();
	thread emz\_checkpoints::init();

	addons\addon::init();

	thread onPlayerConnect();

	thread emz\_cj_voting::voteCancelled();
	thread emz\_cj_voting::voteForced();

	thread mapList();
	if(getDvarInt("developer"))
		thread bots();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		
		player add_config("CJ_PLAYED");

		player thread emz\_setup::setupPlayer();
		player thread emz\_setup::setupLanguage();
		player thread emz\_menus::onMenuResponse();

		player thread emz\_cj_client::use_config();
		player thread emz\_cj_admins::checkAdmin();

		player thread emz\_cj_voting::playerList();
		player thread emz\_cj_voting::mapBrowse();

		player thread addons\_playernames::createhud_playernames();
		player thread while_alive();

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self notify("endcommands");

		self thread _MeleeKey();
		self thread _UseKey();
		self thread checkSuicide();

		if(isEven(int(self get_config("CJ_PLAYED"))) && !isDefined(self.cj["spawnedonce"]))
		{
			self.cj["spawnedonce"] = true;
			self thread doWelcomeMessages();
//			self playLocalSound("spawnmusic");
		}
	}
}

while_alive()
{
	while(isAlive(self) && self.sessionstate == "playing")
	{
		self thread addons\_playernames::while_alive();
		wait 0.05;
	}
}

_MeleeKey()
{
	self endon("disconnect");
	self endon("killed_player");
	self endon("joined_spectators");

	for(;;)
	{
		if(self meleeButtonPressed())
		{
			catch_next = false;
			count = 0;

			for(i=0; i<0.5; i+=0.05)
			{
				if(catch_next && self meleeButtonPressed() && self isOnGround())
				{
					self thread [[level._cj_save]](1);
					wait 1;
					break;
				}
				else if(catch_next && self attackButtonPressed() && self isOnGround())
				{
					while(self attackButtonPressed() && count < 1)
					{
						count+=0.1;
						wait 0.1;
					}
					if(count >= 1 && self isOnGround())
						self thread [[level._cj_save]](3);
					else if(count < 1 && self isOnGround())
						self thread [[level._cj_save]](2);

					wait 1;
					break;
				}
				else if(!(self meleeButtonPressed()) && !(self attackButtonPressed()))
					catch_next = true;

				wait 0.05;
			}
		}

		wait 0.05;
	}
}

_UseKey()
{
	self endon("disconnect");
	self endon("killed_player");
	self endon("joined_spectators");

	for(;;)
	{
		if(self useButtonPressed())
		{
			catch_next = false;
			count = 0;

			for(i=0; i<=0.5; i+=0.05)
			{
				if(catch_next && self useButtonPressed() && !(self isMantling()))
				{
					self thread [[level._cj_load]](1);
					wait 1;
					break;
				}
				else if(catch_next && self attackButtonPressed() && !(self isMantling()))
				{
					while(self attackButtonPressed() && count < 1)
					{
						count+= 0.1;
						wait 0.1;
					}
					if(count < 1 && self isOnGround() && !(self isMantling()))
						self thread [[level._cj_load]](2);
					else if(count >= 1 && self isOnGround() && !(self isMantling()))
						self thread [[level._cj_load]](3);

					wait 1;
					break;
				}
				else if(!(self useButtonPressed()))
					catch_next = true;

				wait 0.05;
			}
		}

		wait 0.05;
	}
}

checkSuicide()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("killed_player");

	while(1)
	{
		i = 0;

		while(!self meleeButtonPressed())
			wait 0.05;

		while(self meleeButtonPressed() && i <= 2)
		{
			wait 0.05;
			i+=0.05;
		}

		if(i >= 2)
			self suicide();
	}
}

doWelcomeMessages()
{
	self endon("disconnect");

	if(isDefined(self.cj["welcome"]))
		return;

	msg = getDvar("cj_welcome");
	tokens = strTok(msg, "::");

	if(tokens.size == 1)
		self iprintlnbold("" + tokens[0]);
	else if(tokens.size > 1)
	{
		messages = [];

		for(i=0;i<tokens.size;i++)
		{
			if( isEven(i) )
				wait(int(tokens[i]));
			else
				self iprintlnbold("" + tokens[i]);
		}
	}

	self.cj["welcome"] = true;
}

bots()
{
	wait 5;
	iNumBots = 5;
	bots = [];

	for(i = 0; i < iNumBots; i++)
	{
	  bots[i] = addtestclient();
	  bots[i].pers["isBot"] = true;
	  wait 0.05;
	  bots[i] notify("menuresponse", "bot",  "player");
	}
}
