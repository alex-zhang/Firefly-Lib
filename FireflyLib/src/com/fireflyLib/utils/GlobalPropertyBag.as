package com.fireflyLib.utils
{
	import flash.display.Stage;

	public final class GlobalPropertyBag extends PropertyBag
	{
		private static const mInstance:GlobalPropertyBag = new GlobalPropertyBag();
		
		//we must pass the right stage value before anything begin.
		public static var stage:Stage = null;
		
		public static function has(name:String):Boolean
		{
			return mInstance.has(name);
		}
		
		public static function write(name:String, value:*, hasEvent:Boolean = false):*
		{
			return mInstance.write(name, value, hasEvent);
		}
		
		public static function read(name:String):*
		{
			return mInstance.read(name);
		}
		
		public static function update(name:String, value:*, hasEvent:Boolean = false):*
		{
			return mInstance.update(name, value, hasEvent);
		}

		public static function remove(name:String, hasEvent:Boolean = false):*
		{

			return mInstance.remove(name, hasEvent);
		}
		
		public function GlobalPropertyBag()
		{
			super();
			
			if(mInstance) throw new Error("GlobalPropertyBag Singleton mode.");
		}
	}
}