#include maps\mp\_utility;
#include emz\_hud_util;
#include emz\_utility;

onJoinedSpectators()
{	
	self thread hideInfoHud();
}
updateInfoHud()
{
	if(level.mapHasCheckPoints)
	{
		s = level.checkPoints["easy"].size;
		c = self.cj["checkpoint"];
		self.cj["progress"] = remap((s-c), 0, s, 1, 0);

		self.cj["hud"]["info"]["progress"] updateBar(self.cj["progress"]);
		self.cj["hud"]["info"]["progress_text"] setValue(self.cj["checkpoint"]);
	}
	
	self.cj["maxfps"] = self getMaxFPS();
	self.cj["hud"]["info"]["loads"] setValue(self.cj["loads"]);
	self.cj["hud"]["info"]["saves"] setValue(self.cj["saves"]);
	self.cj["hud"]["info"]["jumps"] setValue(self.cj["jumps"]);
	self.cj["hud"]["info"]["rpgjumps"] setValue(self.cj["rpgjumps"]);
	self.cj["hud"]["info"]["distance"] setValue(inchToMeter(self.cj["distance"]));
	self.cj["hud"]["info"]["maxfps"] setValue(self.cj["maxfps"]);
	self.cj["hud"]["info"]["os_mode"] setValue(self.cj["os_mode"]);

	self.score = self.cj["saves"];
	self.kills = self.cj["loads"];
	self.assists = self.cj["jumps"];
	self.deaths = self.cj["maxfps"];
}
hideInfoHud()
{
	info = self.cj["hud"]["info"];
	hudarray = getArrayKeys(info);
	for(i = 0 ; i < hudarray.size; i++)
		info[hudarray[i]].alpha = 0;
}
drawInfoHud()
{	
	self thread checkJump();
	self thread checkRPGJumps();
	self thread checkWalkDistance();
	
	if(!isDefined(self.cj["hud"]["info"]))
	{
		self.cj["hud"]["info"] = [];
		self.cj["hud"]["info"]["loads"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["loads"] setPoint( "RIGHT", "TOPRIGHT", -10, 10 );
		self.cj["hud"]["info"]["loads"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["loads"].archived = true;
		self.cj["hud"]["info"]["loads"].alpha = 0;
		self.cj["hud"]["info"]["loads"].label = &"Loads: &&1";

		self.cj["hud"]["info"]["saves"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["saves"] setPoint( "RIGHT", "TOPRIGHT", -10, 25 );
		self.cj["hud"]["info"]["saves"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["saves"].archived = true;
		self.cj["hud"]["info"]["saves"].alpha = 0;
		self.cj["hud"]["info"]["saves"].label = &"Saves: &&1";

		self.cj["hud"]["info"]["jumps"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["jumps"] setPoint( "RIGHT", "TOPRIGHT", -10, 40 );
		self.cj["hud"]["info"]["jumps"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["jumps"].archived = true;
		self.cj["hud"]["info"]["jumps"].alpha = 0;
		self.cj["hud"]["info"]["jumps"].label = &"Jumps: &&1";

		self.cj["hud"]["info"]["rpgjumps"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["rpgjumps"] setPoint( "RIGHT", "TOPRIGHT", -10, 55 );
		self.cj["hud"]["info"]["rpgjumps"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["rpgjumps"].archived = true;
		self.cj["hud"]["info"]["rpgjumps"].alpha = 0;
		self.cj["hud"]["info"]["rpgjumps"].label = &"RPG Jumps: &&1";

		self.cj["hud"]["info"]["distance"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["distance"] setPoint( "RIGHT", "TOPRIGHT", -10, 70 );
		self.cj["hud"]["info"]["distance"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["distance"].archived = true;
		self.cj["hud"]["info"]["distance"].alpha = 0;
		self.cj["hud"]["info"]["distance"].label = &"Distance: &&1m";

		self.cj["hud"]["info"]["time"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["time"] setPoint( "RIGHT", "TOPRIGHT", -10, 85 );
		self.cj["hud"]["info"]["time"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["time"].archived = true;
		self.cj["hud"]["info"]["time"].alpha = 0;
		self.cj["hud"]["info"]["time"].label = &"Time: ";
		self.cj["hud"]["info"]["time"] setTimerUp(0);

		self.cj["hud"]["info"]["maxfps"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["maxfps"] setPoint( "RIGHT", "TOPRIGHT", -10, 100 );
		self.cj["hud"]["info"]["maxfps"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["maxfps"].archived = true;
		self.cj["hud"]["info"]["maxfps"].alpha = 0;
		self.cj["hud"]["info"]["maxfps"].label = &"FPS: &&1";

		self.cj["hud"]["info"]["os_mode"] = createFontString( "default", 1.4 );
		self.cj["hud"]["info"]["os_mode"] setPoint( "RIGHT", "TOPRIGHT", -10, 115 );
		self.cj["hud"]["info"]["os_mode"].hideWhenInMenu = true;
		self.cj["hud"]["info"]["os_mode"].archived = true;
		self.cj["hud"]["info"]["os_mode"].alpha = 0;
		self.cj["hud"]["info"]["os_mode"].label = &"Old School: &&1";

		if(level.mapHasCheckPoints)
		{
			self.cj["hud"]["info"]["progress"] = self createBar((0,0.54,1), 80, 8);
	        self.cj["hud"]["info"]["progress"] setPoint( "LEFT", "BOTTOMLEFT", 5, -10);
	        self.cj["hud"]["info"]["progress"].alpha = 0;
	        self.cj["hud"]["info"]["progress"].hideWhenInMenu = true;
			self.cj["hud"]["info"]["progress"].archived = true;


			self.cj["hud"]["info"]["progress_text"] = createFontString( "default", 1.4 );
			self.cj["hud"]["info"]["progress_text"] setPoint( "LEFT", "BOTTOMLEFT", 5, -22 );
			self.cj["hud"]["info"]["progress_text"].hideWhenInMenu = true;
			self.cj["hud"]["info"]["progress_text"].archived = true;
			self.cj["hud"]["info"]["progress_text"].alpha = 0;
			self.cj["hud"]["info"]["progress_text"].label = &"Checkpoint: &&1";
		}
 	}

	info = self.cj["hud"]["info"];
	hudarray = getArrayKeys(info);
	for(i = 0 ; i < hudarray.size; i++)
	{
		info[hudarray[i]] fadeOverTime(2);
		info[hudarray[i]].alpha = 1;
	}

	self thread updateInfoHud();
}
checkWalkDistance()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	self endon("joined_team");
	
	timer = 0;
	while(1)
	{      
		oldPosition = self.origin;

		wait 0.1;
		timer++;

        if ( self isOnGround() && self.sessionstate != "spectator") 
        {
            travelledDistance = distance( oldPosition, self.origin );

            if ( travelledDistance > 0 ) 
            {
                oldPosition = self.origin;
                self.cj["distance"] += travelledDistance;
            }
        }
        if(timer == 10)
        {
        	self.cj["time"]++;
        	timer = 0;
        }
        self thread updateInfoHud();
    }
}
checkRPGJumps()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	self endon("joined_team");

	while(1)
	{
		while(self getCurrentWeapon() != "rpg_mp")
			wait 0.05;

		self waittill("weapon_fired");

		if(!self isOnGround())
			wait 0.2;

		if(!self isOnGround())
			self.cj["rpgjumps"]++;
	}
}
checkJump()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	self endon("joined_team");

	startZcoord = self.origin[2];
	
	while(1)
	{
		if(self isOnGround())
			startZcoord = self.origin[2];
			
		wait 0.05;
		
		if(self isOnLadder() || self isMantling())
		{
			startZcoord = self.origin[2];
			continue;
		}
		
		diff = self.origin[2] - startZcoord;
		
		if( diff <= 10 || diff >= 25 || self isOnGround())
			continue;

		self.cj["jumps"]++;

		while(!(self isOnGround()))
			wait 0.05;
	}
}