init()
{ 
	level.ninjaServerFile = true;
	level.authorizeMode = getDvarInt("sv_authorizemode");
	level.getGuid = ::_getGuid;
	
	if(level.authorizeMode)
	level.getGuid = ::_getUid;
	
	level.setJumpHeight = ::_setJumpHeight;
	level.getUserInfo = ::_getUserInfo;
	thread emz\_clock::init();
} 
_getUserInfo(arg)
{
	return self getUserInfo(arg);
}
_getUid()
{
	return self getUid();
}
_getGuid()
{
	return self getGuid();
}
_setJumpHeight(x)
{
	self setJumpHeight(x);
}