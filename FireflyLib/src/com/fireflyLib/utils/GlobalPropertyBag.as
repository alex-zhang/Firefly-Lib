package com.fireflyLib.utils
{
	import flash.display.Stage;

	public class GlobalPropertyBag extends PropertyBag
	{
		private static var mInstance:GlobalPropertyBag;
		
		public static var stage:Stage = null;
		
		public static function has(name:String):Boolean
		{
			return getInstance().has(name);
		}
		
		public static function write(name:String, value:*):*
		{
			return getInstance().write(name, value);
		}
		
		public static function read(name:String):*
		{
			return getInstance().read(name);
		}
		
		public static function update(name:String, value:*):*
		{
			return getInstance().update(name, value);
		}

		public static function remove(name:String):*
		{
			return getInstance().remove(name);
		}
			
		private static function getInstance():GlobalPropertyBag
		{
			if(!mInstance)
			{
				mInstance = new GlobalPropertyBag();
			}
			
			return mInstance;
		}
	}
}