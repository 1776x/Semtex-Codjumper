#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	emz\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	emz\_globallogic::SetupCallbacks();
	level.onStartGameType = ::onStartGameType;
	
	emz\_codjumper::init();
	level._cj_save = emz\_cj_functions::savePos;
	level._cj_load = emz\_cj_functions::loadPos;
}

onStartGameType()
{
	setClientNameMode("auto_change");
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	emz\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
	level.mapCenter = emz\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );

	setMapCenter( level.mapCenter );
	allowed[0] = "bombzone";
	allowed[1] = "sab";
	
	entitytypes = getentarray();
	for(i = 0; i < entitytypes.size; i++)
		if(isdefined(entitytypes[i].script_gameobjectname))
		{
			dodelete = true;
			gameobjectnames = strtok(entitytypes[i].script_gameobjectname, " ");
			for(j = 0; j < allowed.size; j++)
			{
				for (k = 0; k < gameobjectnames.size; k++)
					if(gameobjectnames[k] == allowed[j])
					{	
						dodelete = false;
						break;
					}
				if (!dodelete)
					break;
			}
			if(dodelete)
				entitytypes[i] delete();
		}
	
	level.QuickMessageToAll = true;
}