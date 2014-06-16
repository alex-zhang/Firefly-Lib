package com.fireflyLib.utils
{
	public function getCallStack():String
	{
		try
		{
			var e:Error = new Error();
			
			return e.getStackTrace();
		}
		catch(e:Error)
		{
		}
		
		return "[No StackTrace MSG in Release EVN]";
	}
}