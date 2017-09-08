#include emz\_cj_client;
#include emz\_utility;

onMenuResponse()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("menuresponse", menu, response);
//		iPrintLn(menu, " ", response);

		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();	
		}

		if(response == "asd")
		{
			self thread emz\_setup::sprayLogo();	
		}
		if(response == "vip")
		{
			if(!self _isPlayer())
			self openMenu("vip");	
		}
			
		if(self isAdmin() && menu != "cj")
		{
			res = "easy";

			if(issubstr(response,"easy"))
				res = "easy";

			if(issubstr(response,"hard"))
				res = "hard";

			if(issubstr(response,"normal"))
				res = "normal";

			if(issubstr(response,"inter"))
				res = "inter";

			if( issubstr(response,"newcheckpoint")) 
			{
				self iPrintLn("^1Creating checkpoint!");
				if( IsAlive(self) )
					self thread emz\_files::storePoint(self.origin, self GetPlayerAngles(), res);
			}
			
			if( issubstr(response,"savefile") ) 
			{
				self iPrintLn("^1Saving File!");
				self thread emz\_files::savePointsFile(res);
			}
			
			if( issubstr(response,"deletecheckpoint") ) 
			{
				self iPrintLn("^1Deleting position!");
				self thread emz\_files::deleteNearby(res);
			}
		}


		if( response == "myshortguid")
		{
			self iPrintLn("Your guid is: ", getsubstr( self getGuid(), 24, 32 ));	
		}

		if( isSubStr(response,"tpmeto:"))
		{
			tpmeto = strTok(response,":")[1];
			player = getPlayerByNamePart(tpmeto);
			self setOrigin(player.origin);
			self setPlayerAngles(player.angles);
		}

		if( isSubStr(response,"tptome:"))
		{
			tptome = strTok(response,":")[1];
			player = getPlayerByNamePart(tptome);
			player setOrigin(self.origin);
			player setPlayerAngles(self.angles);
		}

		if( isSubStr(response,"asshole:"))
		{
			p = strTok(response,":")[1];
			player = getPlayerByNamePart(p);
			player setRank(6);
			player.cj["status"] = 6;
			player iPrintLnBold("You are an asshole!");
		}
				
		if(response == "oldschool")
		{
			if(!isDefined(self.cj["os_mode"]))
				self.cj["os_mode"] = self get_config("CJ_OLDSCHOOL");
				
			if(self.cj["os_mode"])
			{
				self thread emz\_setup::setChosenJumpStyle(0);
				self.cj["os_mode"] = false;
				self setClientDvar("os_mode", "^1Disabled");
				self set_config("CJ_OLDSCHOOL", 0);
			}
			else if(!self.cj["os_mode"])
			{
				self thread emz\_setup::setChosenJumpStyle(1);
				self.cj["os_mode"] = true;
				self setClientDvar("os_mode", "^2Enabled");
				self set_config("CJ_OLDSCHOOL", 1);
			}	
		}

		if(response == "player")
		{
			self [[level.menuPlayer]]();
		}
			
		else if(response == "spectate")
		{
			self [[level.menuSpectator]]();		
		}
		if(menu == "vip")
		{
			if(!self _isPlayer())
			{
				self detachAll();
				self setClientDvar("currentmodel",TableLookup( "mp/modelTable.csv", 0, response, 1 ));
				self setModel(TableLookup( "mp/modelTable.csv", 0, response, 2 ));
				self setViewModel(TableLookup( "mp/modelTable.csv", 0, response, 3 ));
				self setStat(100,int(response));
			}
		}
		if(menu == "shop")
		{
				if(self getStat(110+int(response))==1 && self getStat(1169)==(int(response)+1)) 
					self setClientDvar("shop"+int(response)+"action","^2Activated");
				if(self getStat(110+int(response))==1 && self getStat(1169)!=(int(response)+1)){
					self detachAll();
					self setModel(level.shopmodel[int(response)+1][0]);
					self setClientDvar("shopmodel",level.shopmodel[int(response)+1][1]);
					self setClientDvar("shop"+int(response)+"action","^3Activated");
					self setStat(1169,int(response)+1);
					self thread emz\shop::check();
				}
				else if(self.pers["points"] >= level.modelcost[int(response)]){
					self.pers["points"] = self.pers["points"]-level.modelcost[int(response)];
					self setStat(2561,self.pers["points"]);
					self setStat(110+int(response),1);
					self setStat(1169,int(response)+1);
					self detachAll();
					self setModel(level.shopmodel[int(response)+1][0]);
					self setClientDvar("shopmodel",level.shopmodel[int(response)+1][1]);
					self setClientDvar("shop"+int(response)+"action","^3Activated");
					self thread emz\shop::check();
		}
		}


		if(menu == "quickcommands")
		{
			maps\mp\gametypes\_quickmessages::quickcommands(response);	
		}

		if(menu == "poslog" && isSubStr(response,"poslog_") && self.sessionstate != "spectator")
		{
			log = (int(strTok(response,"_")[1]) - 1);
			self emz\_cj_functions::loadLoggedPosition(log);		
		}

		if(menu == "cj" && self.sessionstate != "spectator")
		{
			if(isSubStr(response,"save"))
			{
				save = strTok(response,"e")[1];
				if(!isDefined(save))
					self [[level._cj_save]](1);
				else
					self [[level._cj_save]](save);
				
				
			}
			if(isSubStr(response,"load"))
			{
				load = strTok(response,"d")[1];
				if(!isDefined(load))
					self [[level._cj_load]](1);
				else
					self [[level._cj_load]](load);

				
			}
			if(response == "suicide")
				self suicide();	
		}

		if(menu == "graphics")
		{
			self thread graphics(response);	
		}

		if(response == "next" || response == "prev" && self.sessionstate != "spectator")
		{
			self.cj["vote"]["dir"] = response;
			self notify("playerlist");	
		}

		else if(response == "mnext" || response == "mprev" && self.sessionstate != "spectator")
		{
			self.cj["vote"]["dir"] = response;
			self notify("maplist");		
		}

		else if(response == "kick" || response == "change" || response == "extend" || response == "rotate") 
		{			
			if(response == "kick")
				arg = self.cj["vote"]["player"];
			else if(response == "change")
				arg = self.cj["vote"]["map"];
			else
				arg = undefined;

			if(voteInProgress() || !self canVote())
				self iPrintLn("You can't vote at the time.");
			else
				thread emz\_cj_voting::cjVoteCalled(response, self, arg, undefined);
		}

		else if(response == "cjvoteyes")
		{
			if(level.cjvoteinprogress == 1)
			{
				if(self.cj["vote"]["voted"] == true)
					self iPrintLn("You have already voted!");
				else
				{
					level.cjvoteyes++;
					self.cj["vote"]["voted"] = true;
					self iPrintLn("Vote Cast");

					if(self isVip() || self isAdmin())
 						level.cjvoteyes++;
				}
			}
			else
				self iPrintLn("There is no vote in progress");	
		}

		else if(response == "cjvoteno")
		{
			if(level.cjvoteinprogress == 1)
			{
				if(self.cj["vote"]["voted"] == true)
					self iPrintLn("You have already voted!");
				else
				{
					level.cjvoteno++;
					self.cj["vote"]["voted"] = true;
					self iPrintLn("Vote Cast");

					if(self isVip() || self isAdmin())
 						level.cjvoteno++;
				}
			}
			else
				self iPrintLn("There is no vote in progress");		
		}

		else if(response == "cjcancel")
		{
			if(level.cjvoteinprogress == 1)
			{
				if(!self isAdmin())
					self iPrintLn("You do not have privileges to cancel votes");
				else
					level notify("votecancelled");
			}
			else
				self iPrintLn("There is no vote in progress");			
		}

		else if(response == "cjforce")
		{
			if(level.cjvoteinprogress == 1)
			{
				if(!self isAdmin())
					self iPrintLn("You do not have privileges to force votes");
				else
					level notify("voteforce");
			}
			else
				self iPrintLn("There is no vote in progress");		
		}

	}
}
canVote()
{
	if(self isAsshole())
		return false;

	if(self isAdmin() || self isVip())
        return true;

	return int(mSecToMin(getTime() - self.cj["connectTime"]) > 3);
	return 0;
}