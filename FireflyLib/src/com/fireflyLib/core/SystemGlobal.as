package com.fireflyLib.core
{
	import flash.display.Stage;

	public final class SystemGlobal
	{
		public static var stage:Stage;
		
		private static var mItems:Array = [];//key->value
		
		public static function get(key:String):*
		{
			return mItems[key];
		}
		
		public static function set(key:String, value:*):void
		{
			mItems[key] = value;
		}
	}
}