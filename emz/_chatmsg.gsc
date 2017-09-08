#include emz\exec;

main()
{
	level.welcometime = false; 
	thread counter();
	level.groups[0] = "Player";
	level.groups[1] = "Member";
	level.groups[2] = "VIP";
	level.groups[3] = "Admin";
	level.groups[4] = "Master Admin";
	level.groups[5] = "Master Admin";
}

write()
{
	self endon("disconnect");
	wait 2;
	exec("say Welcome ^5"+ level.groups[self.cj["status"]]+ " ^7"+ self.name+ " connected from ^5"+ self getGeoLocation(2)); 
}

counter()
{
	wait 60;
	level.welcometime = true; 
}