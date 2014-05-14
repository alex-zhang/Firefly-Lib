package com.fireflyLib.utils
{
	import flash.display.Stage;

	public class GlobalPropertyBag extends PropertyBag
	{
		public static var stage:Stage = null;
		
		private static var mInstance:GlobalPropertyBag;
		
		public static function has(name:String):Boolean
		{
			if(!mInstance) mInstance = new GlobalPropertyBag();
			
			return mInstance.has(name);
		}
		
		public static function write(name:String, value:*, hasEvent:Boolean = false):*
		{
			if(!mInstance) mInstance = new GlobalPropertyBag();
			
			return mInstance.write(name, value, hasEvent);
		}
		
		public static function read(name:String):*
		{
			if(!mInstance) mInstance = new GlobalPropertyBag();
			
			return mInstance.read(name);
		}
		
		public static function update(name:String, value:*, hasEvent:Boolean = false):*
		{
			if(!mInstance) mInstance = new GlobalPropertyBag();
			
			return mInstance.update(name, value, hasEvent);
		}

		public static function remove(name:String, hasEvent:Boolean = false):*
		{
			if(!mInstance) mInstance = new GlobalPropertyBag();
			
			return mInstance.remove(name, hasEvent);
		}
		
		public function GlobalPropertyBag()
		{
			super();
			
			if(mInstance) throw new Error("GlobalPropertyBag Singleton mode.");
			mInstance = this;
		}
	}
}