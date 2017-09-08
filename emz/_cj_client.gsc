get_config(dataName)
{
	return int(self getStat(int(tableLookup("mp/CJStatsTable.csv", 1, dataName, 0))));
}
set_config(dataName, value)
{
	self setStat(int(tableLookup("mp/CJStatsTable.csv", 1, dataName, 0)), value);
	return value;
}
toggle(name)
{
	return int(self set_config(name, int(!self get_config(name))));
}
add_config(name)
{
	value = int(self get_config(name) + 1);
	return self set_config(name, value);
}
loopthrough(name, limit)
{
	value = self get_config(name) + 1;
	if (value > limit) value = 0;
	return self set_config(name, value);
}
setGraphicsDvar(name,dvar)
{
	if(self get_config(name))
		self setClientDvar(dvar, "^2");
	else
		self setClientDvar(dvar, "^1");
}
setDrawDistanceDvar()
{
	if(!self get_config("CJ_DRAW"))
		self setClientDvar("ui_drawdistance", "^1off");
	else
		self setClientDvar("ui_drawdistance", 250 * self get_config("CJ_DRAW"));
}
use_config()
{
	self endon("disconnect");

	self setGraphicsDvar("CJ_DECALS","ui_drawdecals");
	self setGraphicsDvar("CJ_BRIGHT","ui_fullbright");
	self setGraphicsDvar("CJ_FX","ui_fxenable");
	self setGraphicsDvar("CJ_FOG","ui_fogenable");
	self setGraphicsDvar("CJ_THIRDPERSON","ui_thirdperson");
	self setGraphicsDvar("CJ_FOVSCALE","ui_fovscale");
	self setDrawDistanceDvar();
	
	if(self get_config("CJ_OLDSCHOOL"))
	{
		self thread emz\_setup::setChosenJumpStyle(1);
		self setClientDvar("os_mode", "^2Enabled");
	}
	else self setClientDvar("os_mode", "^1Disabled");

	
	self setClientDvars("r_drawdecals", self get_config("CJ_DECALS"), "r_fullbright", self get_config("CJ_BRIGHT"), "fx_enable", self get_config("CJ_FX"), "r_zfar", self get_config("CJ_DRAW"), "r_fog", self get_config("CJ_FOG"), "cg_thirdperson", self get_config("CJ_THIRDPERSON")/*, "cg_thirdpersonrange", self get_config("CJ_THIRDPERSON_RANGE"), "cg_thirdpersonangle", self get_config("CJ_THIRDPERSON_ANGLE")*/, "cg_fovscale", 1 + int(!self get_config("CJ_FOVSCALE")) * 0.125);
}
graphics(response)
{
	self endon("disconnect");
	switch (response)
	{
		case "0":
			self setClientDvar("r_drawdecals", self toggle("CJ_DECALS"));
			self setGraphicsDvar("CJ_DECALS","ui_drawdecals");
			break;
			
		case "1":
			self setclientdvar("r_fullbright", self toggle("CJ_BRIGHT"));
			self setGraphicsDvar("CJ_BRIGHT","ui_fullbright");
			break;
			
		case "2":
			self setclientdvar("fx_enable", self toggle("CJ_FX"));
			self setGraphicsDvar("CJ_FX","ui_fxenable");
			break;
			
		case "3":
			self setclientdvar("r_zfar", 250 * self loopthrough("CJ_DRAW", 16));
			self setDrawDistanceDvar();
			break;
			
		case "4":
			self setclientdvar("r_fog", self toggle("CJ_FOG"));
			self setGraphicsDvar("CJ_FOG","ui_fogenable");
			break;
			
		case "5":
			self setclientdvar("cg_thirdperson", self toggle("CJ_THIRDPERSON"));
			self setGraphicsDvar("CJ_THIRDPERSON","ui_thirdperson");
			break;
			
		case "6":
			self setclientdvar("cg_fovscale", 1 + int(!self toggle("CJ_FOVSCALE")) * 0.125);
			self setGraphicsDvar("CJ_FOVSCALE","ui_fovscale");
			break;
	}
}