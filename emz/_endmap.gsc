init() // call this;
{
	level.endTriggers = [];
	level.endTrigger = [];
	level.finishers = [];
	level.onMapFinished = ::mapFinished;

	loadTriggers();

	for(i = 0; i < level.endTriggers.size;i++)
	{
		trigger = getEntArray(level.endTriggers[i].name,level.endTriggers[i].expname);
		for(x = 0; x < trigger.size; x++)
		{
			if(isDefined(trigger[x]))
			 trigger[x] thread waitForTrigger();
		}
	}
}
mapFinished()
{
	self iPrintLn("Map Finished!");
}
loadTriggers()
{
	addTrigger("end");
	addTrigger("end2");
	addTrigger("endmap");
	addTrigger("jump","mp_bouncer_training");
	addTrigger("konec");
	addTrigger("konec1");
	addTrigger("konec2");
	addTrigger("konec3");
	addTrigger("goal");
	addTrigger("kill8","mp_codjumper_training");
	addTrigger("easyend");
	addTrigger("hardend");
	addTrigger("digital_completed_trig");
	addTrigger("finish");
	addTrigger("finishhard");
	addTrigger("finisheasy");
	addTrigger("msgeasy");
	addTrigger("msghard");
	addTrigger("msginter");
	addTrigger("theEnd");
	addTrigger("", "mp_crazy_jump", (5732,176,3379));

	//define more end's like this:
	//addTrigger("trigger name if exist","mapname if you want it map specific", "origin if trigger not exist and map exist");
}

triggerDef(name,expname,exporigin)
{
	trigger = SpawnStruct();
	trigger.name = name;
	trigger.expname = expname;
	trigger.exporigin = exporigin;
	return trigger;
}

addTrigger(trig,map,origin)
{
	if(((isDefined(map) && level.script == map) || !isDefined(map)) && !isDefined(origin))
	{
		level.endTriggers[level.endTriggers.size] = triggerDef(trig,"targetname");
		return;
	}

	if(isDefined(origin) && isDefined(map) && level.script == map)
	{
		trigger = spawn( "trigger_radius", origin, 0, 50, 50 );
		level.endTriggers[level.endTriggers.size] = triggerDef("trigger_radius","classname",origin);
		return;
	}

}

waitForTrigger()
{
 	level.endTrigger[level.endTrigger.size] = self;

 	if(isDefined(self.exporigin) && self.exporigin != self.origin)
 		return;

	for(;;)
	{
		self waittill("trigger",player);

		if(!player inArray())
			player thread [[level.onMapFinished]]();
	}
}
inArray()
{
	for(i = 0 ; i < level.finisherssize; i++)
	{
		if(level.finishers[i] == self)
			return true;
	}
	return false;
}