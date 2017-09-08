#include emz\exec;
init()
{
	/*for(;;)
	{
		wait 60;
		send("Help us to keep this community and our servers alive with buying VIP membership!");
		wait 1;
		send("Details at our website: ^5www.semtex.tk");
		wait 60;
		send("SemteX ^5DeathRun server ^7IP:178.33.10.14:30000 or use ^5!deathrun");
		wait 60;
		send("Add the server's new IP to your favourites: ^5178.33.10.14:30001");
		wait 20;
		send("SemteX ^5PromodLive SD server ^7IP:178.33.10.14:30003 or use ^5!promod");
		wait 60;
		send("SemteX ^5Ghosts Promod server ^7IP:178.33.10.14:30002 or use ^5!ghosts");
		wait 60;
		send("SemteX ^5Hard^7Core HIGH XP server ^7IP:178.33.10.14:30004 or use ^5!hardcore");
		wait 60;
		send("Visit us at our new website: ^5www.semtex.tk"); 
		wait 10;
		send("Add the server's new IP to your favourites: ^5178.33.10.14:30001");
	}*/
	for(;;){
	send("Press B->4 to open the New Shop Menu!");
	wait 120; }
}
send(msg) {
exec("say "+msg); }