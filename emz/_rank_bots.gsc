/*
AddTestClient
============================
Usage: entity = AddTestClient()


removeAllTestClients
============================
Usage: removeAllTestClients()


RemoveTestClient
============================
Usage: entity = removeTestClient()
*/
#include emz\_utility;
#include common_scripts\utility;

init()
{
	level.bots = [];
	wait 5;
	removeAllTestClients();
	wait 1;
	thread bot_loop();
}
addTestClients(testclients)
{
	if(!isDefined(testclients))
		testclients = 1;

	for( i = 0 ; i < testclients ; i++ )
	{
		bot = addTestClient();

		if( isDefined( bot ) && isPlayer( bot ) )
		{
			bot.pers["isBot"] = true;
			level.bots[level.bots.size] = bot;
			bot thread do_something();
		}
		else
			i--;

		wait randomFloatRange(3,7);
	}
}
do_something()
{
	self endon("disconnect");

	wait randomFloatRange(3,8);

	self.sessionstate = "spectator";
	self.sessionteam = "allies";
	self.team = "allies";
	self.statusicon = "";

	while(1)
	{
		wait randomIntRange(15,30);
		self.score += randomIntRange(1,3);
		self.kills += randomIntRange(1,3);
		self.deaths += randomIntRange(1,2);
		self.assists += randomInt(1);
	}
}

remove_all()
{
	for(i = 0;i < level.bots.size; i++)
	{
		removeTestClient(level.bots[i]);
		wait randomFloatRange(2,5);
	}
	level.bots = [];
}

remove_num(num)
{
	for(i = 0; i < level.bots.size && num != i; i++)
	{
		removeTestClient(level.bots[i]);
		wait randomFloatRange(2,5);
	}
	remove_undefined_from_array(level.bots);
}

bot_loop()
{
	old = level.players.size + 1; // + 1 hack for the first loop.

	while(isDefined(level.players))
	{
		new = level.players.size;
		if(level.players.size == 0 && old != new)
		{
			diff = int(randomIntRange(2,5) - level.bots.size);
			if(diff > 0)
				addTestClients(diff);
			old = level.players.size;	
		}

		if(level.players.size == 1 && old != new)
		{
			diff = int(randomIntRange(1,3) - level.bots.size);
			if(diff > 0)
				addTestClients(diff);
			else
				remove_num(diff);

			old = level.players.size;		
		}

		if(level.players.size > 1 && old != new)
		{
			remove_all();
			old = level.players.size;		
		}
		wait randomFloatRange(7,15);
	}
}