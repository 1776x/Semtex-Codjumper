#include common_scripts\utility;

while_alive()
{
    /*
    players = getentarray("player", "classname");
    show_player = undefined;
    show_player_mindist = undefined;
    maxdist = 35 * 35;
    fw = anglestoforward(self getplayerangles());
    for(i = 0; i < players.size; i++)
    {
        if(isdefined(players[i].sessionstate) && players[i].sessionstate == "playing" && players[i] != self)
        {
            vec = players[i].origin - self.origin;
            inpr = vectordot(fw, vec);
            vec2 = self.origin + vectorScale(fw, inpr);
            dist = distancesquared(vec2, players[i].origin);
            if(dist < (maxdist * (1 + length(vec) / 2000)) && inpr > 45)
            {
                if(!isdefined(show_player) || show_player_mindist > distancesquared(self.origin, players[i].origin))
                {
                    show_player_mindist = distancesquared(self.origin, players[i].origin);
                    show_player = players[i];
                }
            }
        }
        if(isdefined(show_player) && isdefined(self.cj["hud_playernames"]))
        {
            trace = bullettrace(self.origin + (0, 0, 40), show_player.origin + (0, 0, 40), false, undefined);
            if(trace["fraction"] == 1)
            {
                self.cj["hud_playernames"].alpha = 0.6;
                self.cj["hud_playernames"] setplayernamestring(show_player);
            }
            else
                self.cj["hud_playernames"].alpha = 0;
        }
        else if(isdefined(self.cj["hud_playernames"]))
            self.cj["hud_playernames"].alpha = 0;
    }
    */
}

onkill()
{
    if(isdefined(self.cj["hud_playernames"]))
        self.cj["hud_playernames"].alpha = 0;
}

createhud_playernames()
{
    if(!isdefined(self.cj["hud_playernames"]))
    {
        self.cj["hud_playernames"] = newclienthudelem(self);
        self.cj["hud_playernames"].horzAlign = "center_safearea";
        self.cj["hud_playernames"].vertAlign = "center_safearea";
        self.cj["hud_playernames"].alignX = "center";
        self.cj["hud_playernames"].alignY = "middle";
        self.cj["hud_playernames"].x = 0;
        self.cj["hud_playernames"].y = -50;
        self.cj["hud_playernames"].fontscale = 1.5;
        self.cj["hud_playernames"].archived = true;
        self.cj["hud_playernames"].sort = -1;
    }
    self.cj["hud_playernames"].alpha = 0;
}