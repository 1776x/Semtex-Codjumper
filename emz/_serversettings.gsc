init()
{
	level.hostname = getdvar( "sv_hostname" );
	if(level.hostname == "")
		level.hostname = "CoDJUMPER BY EMZ";
	setdvar( "sv_hostname", level.hostname );
	setdvar( "ui_hostname", level.hostname );
	makedvarserverinfo( "ui_hostname", level.hostname );
	makedvarserverinfo( "ui_allowvote", "1" );
	makedvarserverinfo( "ui_friendlyfire", "0" );
	
	setdvar( "scr_teambalance", 0 );
	setDvar( "scr_oldschool", 0 );
	setDvar( "bg_fallDamageMinHeight", 99990 );
	setDvar( "bg_fallDamageMaxHeight", 100000 );
	setDvar( "bg_bobMax", 0 );
	setDvar( "jump_slowdownEnable", 0 );
	setDvar( "scr_player_sprinttime", 12.8 );
	setDvar( "g_deadChat", 1 );
	setDvar( "scr_allies", "" );
	setDvar( "scr_axis", "" );
	setDvar( "loc_warnings", 0 );
	setDvar( "g_ScoresColor_Spectator", "" );
	setDvar( "g_ScoresColor_Free", "" );
	setDvar( "g_teamColor_MyTeam", "1 1 1 1" );
	setDvar( "g_teamColor_EnemyTeam", "1 1 1 1" );
	setDvar( "g_teamIcon_Allies", "" );
	setDvar( "g_teamIcon_Axis", "" );
	setDvar( "g_teamName_Allies", "" );
	setDvar( "g_teamName_Axis", "" );
	setDvar( "g_TeamColor_Allies", "1 1 1" );
	setDvar( "g_ScoresColor_Allies", "0 0 0" );
	setDvar( "g_TeamColor_Axis", "1 1 1" );
	setDvar( "g_ScoresColor_Axis", "0 0 0" );
	
	if(getdvar("scr_mapsize") == "")
		setdvar("scr_mapsize", "64");
	else if(getdvarFloat("scr_mapsize") >= 64)
		setdvar("scr_mapsize", "64");
	else if(getdvarFloat("scr_mapsize") >= 32)
		setdvar("scr_mapsize", "32");
	else if(getdvarFloat("scr_mapsize") >= 16)
		setdvar("scr_mapsize", "16");
	else
		setdvar("scr_mapsize", "8");
	level.mapsize = getdvarFloat("scr_mapsize");

	constrainMapSize(level.mapsize);

	for(;;)
	{
		sv_hostname = getdvar("sv_hostname");
		if(level.hostname != sv_hostname){
			level.hostname = sv_hostname;
			setdvar("ui_hostname", level.hostname);
		}
		wait 5;
	}
}
constrainMapSize(mapsize)
{
	entities = getentarray();
	for(i = 0; i < entities.size; i++)
	{
		entity = entities[i];
		
		if(int(mapsize) == 8)
		{
			if(isdefined(entity.script_mapsize_08) && entity.script_mapsize_08 != "1")
				entity delete();
		}
		else if(int(mapsize) == 16)
		{
			if(isdefined(entity.script_mapsize_16) && entity.script_mapsize_16 != "1")
				entity delete();
		}
		else if(int(mapsize) == 32)
		{
			if(isdefined(entity.script_mapsize_32) && entity.script_mapsize_32 != "1")
				entity delete();
		}
		else if(int(mapsize) == 64)
		{
			if(isdefined(entity.script_mapsize_64) && entity.script_mapsize_64 != "1")
				entity delete();
		}
	}
}