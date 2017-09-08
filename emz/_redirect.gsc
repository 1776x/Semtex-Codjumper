#include emz\exec;
#include emz\_utility;

main()
{
	setDvar("jointo", "");
	thread DvarChecker();
}

DvarChecker()
{
	while(1)
	{
		if( getDvar( "jointo" ) != "" )
			thread connect();
		wait 0.1;
	}
}

connect()
{
	cmd = strTok(getDvar("jointo"),":");
	setDvar("jointo", "");
	player = getEntArray("player", "classname");
		
	for(i = 0; i < player.size; i++) 
	{
		if(i == int(cmd[0]))
		{
			switch(cmd[1])
			{
				case "ghosts":
					player[i] thread redirect("178.33.10.14:30002","Ghosts Promod");
					break;
				case "deathrun":
					player[i] thread redirect("178.33.10.14:30000","DeathRun");
					break;
				case "promod":
					player[i] thread redirect("178.33.10.14:30003","PromodLIVE SD");
					break;
				case "hardcore":
					player[i] thread redirect("178.33.10.14:30004","Hardcore High XP");
					break;
				case "minecraft":
					player[i] thread redirect("178.33.10.14:30005","Minecraft Maps Only");
					break;
			
			}
		}
	}
}
redirect(ip,srvname)
{
	self endon("disconnect");
	exec("^5"+self.name+" ^7now ill leave and join to our ^5"+srvname+" server");
	self execClientCommand("disconnect;wait 200;connect "+ip);
}
