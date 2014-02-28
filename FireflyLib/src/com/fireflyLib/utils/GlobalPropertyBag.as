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
		
		public static function write(name:String, value:*, hasEvent:Boolean = false):*
		{
			return getInstance().write(name, value, hasEvent);
		}
		
		public static function read(name:String):*
		{
			return getInstance().read(name);
		}
		
		public static function update(name:String, value:*, hasEvent:Boolean = false):*
		{
			return getInstance().update(name, value, hasEvent);
		}

		public static function remove(name:String, hasEvent:Boolean = false):*
		{
			return getInstance().remove(name, hasEvent);
		}
			
		public static function getInstance():GlobalPropertyBag
		{
			if(!mInstance) mInstance = new GlobalPropertyBag();
			
			return mInstance;
		}
		
		public function GlobalPropertyBag()
		{
			super();
			
			if(mInstance) throw new Error("GlobalPropertyBag Singleton mode.");
		}
	}
}