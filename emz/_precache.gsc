precache()
{
	precacheShader("black");
	precacheShader("white");
	precacheShader("damage_feedback");
	precacheShader("cj_frame");
	precacheShader("ObjPoint_default");
	precacheShader("progress_bar_fill");
	precacheShader("progress_bar_bg");

	for ( i = 0; i <= 6; i++ )
	{
		precacheShader( tableLookup( "mp/rankIconTable.csv", 0, i, 1 ) );
		precacheString( tableLookupIString( "mp/rankTable.csv", 0, i, 16 ) );
	}
	
	precacheLocationSelector( "map_artillery_selector" );
	
	precacheStatusIcon( "hud_status_connecting" );
	precacheStatusIcon( "hud_status_spectator" );
	
	precacheHeadIcon( "talkingicon" );
		
	precacheMenu( "class" );
	precacheMenu( "ingame_controls" );
	precacheMenu( "ingame_options" );
	precacheMenu( "muteplayer" );
	precacheMenu( "scoreboard" );
	precacheMenu( "team_marinesopfor" );
	precacheMenu( "quickcommands" );
	precacheMenu("shop");

	precacheMenu("cj");
	precacheMenu("admin");
	precacheMenu("graphics");
	precacheMenu("cjvote");
	precacheMenu("poslog");
	precacheMenu("clientcmd");
	precacheMenu("vip");
	
	precacheItem("gravitygun_mp");
	precacheItem("no_weapon_mp");
	precacheItem("frag_grenade_mp");
	precacheItem("rpg_mp");
	precacheItem("beretta_mp");
	precacheItem("deserteagle_mp");
	precacheItem("deserteaglegold_mp");
	precacheItem("deserteagle_tactical_mp");
	precacheItem("colt45_mp");
	precacheItem("usp_mp");
	precacheItem("brick_blaster_mp");

	precacheModel("body_mp_sas_urban_assault");
	precacheModel("viewhands_usmc");
	precacheModel("playermodel_dnf_duke");
	precacheModel("viewhands_dnf_duke");
	precacheModel("body_makarov");
	precacheModel("body_zoey");
	precacheModel("mc_char");
	precacheModel("body_masterchief");
	precacheModel("body_shepherd");
	precacheModel("body_juggernaut");
	precacheModel("body_complete_mp_al_asad");
	precacheModel("body_complete_mp_price_woodland");
	precacheModel("body_complete_mp_russian_farmer");
	precacheModel("body_complete_mp_zakhaev");
	precacheModel("playermodel_ghost_recon");
	precacheModel("playermodel_GTA_IV_NICO");
	precacheModel("playermodel_vin_diesel");
	precacheModel("playermodel_terminator");
	precacheModel("playermodel_fifty_cent");
	precacheModel("playermodel_css_badass_terrorist");
	precacheModel("body_mp_usmc_rifleman");
	precacheModel("body_complete_mp_velinda_desert");
	precacheModel("body_complete_mp_zack_desert");
	
	
	precacheShellShock("flashbang");
}