#include emz\_utility;
#include common_scripts\utility;

init()
{
    while(!isDefined(level.players))
        wait 0.05;

    for(;;wait 0.05)
    {
    	for(y = 0;y < level.players.size;y++)
			level.players[y] hide(); 

        for(x = 0; x < level.players.size; x++)
        {
            for(i = 0; i < level.players.size; i++)
            {
                if(distance(level.players[x].origin,level.players[i].origin) > 100 && level.players[i] != level.players[x] && level.players[i].sessionstate != "spectator")
                    level.players[i] showToPlayer(level.players[x]); 
            } 
        }  
    }
}