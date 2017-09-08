#include emz\_utility;

init()
{
	precacheString(&":");
	precacheString(&" ");
	level thread onPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread setup_clock();
	}
}

setup_clock()
{
	x = 298;
	y = 20;
	
	self.clockhour = self new_clock_elem(x,y);
	
	self.clockminute = self new_clock_elem(x+22,y);
	
	self.clockdots = newClientHudElem(self);
	self.clockdots.x = x+17;
	self.clockdots.y = y-2;
	self.clockdots.alignX = "left";
	self.clockdots.alignY = "bottom";
	self.clockdots.font = "default";
	self.clockdots.fontScale = 1.4;
	self.clockdots.archived = false;
	self.clockdots.color = (1, 1, 1);
	
	time = strTok(get_Start_Time(),":");
	
	if(!isDefined(time) || time.size < 2)
		time = strTok("12:00",":");

	h = int(time[0]);
	m = int(time[1]);
	
	self set_clock_time( h, m );
	
	self notify("stop_clock");
	self endon("stop_clock");
	self endon("disconnect");
	
	for(;;)
	{
		if( !isdefined( self.clockdots ) )
			return;
		self.clockdots.label = &":";
		wait 1;
		
		if( !isdefined( self.clockdots ) )
			return;
		self.clockdots.label = &" ";
		wait 1;

		time = strTok(get_Start_Time(),":");

		if(!isDefined(time) || time.size < 2)
			time = strTok("12:00",":");
			
		self set_clock_time( int(time[0]), int(time[1]) );
	}
}

new_clock_elem(x,y)
{
	elem = newClientHudElem(self);
	elem.x = x;
	elem.original_x = x;
	elem.y = y;
	elem.alignX = "left";
	elem.alignY = "bottom";
	elem.font = "default";
	elem.fontScale = 1.4;
	elem.archived = false;
	elem.color = (1, 1, 1);
	
	elem.width = 8;
	
	elem.spacer = newClientHudElem(self);
	elem.spacer.x = x;
	elem.spacer.y = y;
	elem.spacer.alignX = "left";
	elem.spacer.alignY = "bottom";
	elem.spacer.font = "default";
	elem.spacer.fontScale = 1.4;
	elem.spacer.archived = false;
	elem.spacer.color = (1, 1, 1);
	
	elem.spacer.alpha = 0;
	elem.spacer setValue( 0 );
	
	return elem;
}


destroy_clock()
{
	self notify("stop_clock");
	
	if( !isdefined( self.clockhour ) )
		return;
	
	self.clockhour.spacer destroy();
	self.clockhour destroy();
	
	self.clockdots destroy();
	
	self.clockminute.spacer destroy();
	self.clockminute destroy();
}


set_clock_time( h, m )
{
	self.clockhour setDigit( h );
	self.clockminute setDigit( m );
}

setDigit( t )
{
	self setValue( t );
	if( t < 10 )
	{
		self.x = self.original_x+self.width;
		self.spacer.alpha = 1;
	}
	else
	{
		self.x = self.original_x;
		self.spacer.alpha = 0;
	}
}
get_Start_Time()
{
	return TimeToString(getRealTime(),0, "%R");
}
