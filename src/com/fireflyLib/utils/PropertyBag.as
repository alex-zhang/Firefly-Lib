package com.fireflyLib.utils
{
	public class PropertyBag extends EventEmitter
	{
		public static const WRITE:String = "write";
		public static const UPDATE:String = "update";
		public static const REMOVE:String = "remove";
		public static const CLEAR:String = "clear";
		
		protected var mPropertiesRowData:Array = null;
		
		public function PropertyBag(data:Object = null)
		{
			mPropertiesRowData = [];
			
			for(var key:String in data)
			{
				mPropertiesRowData[key] = data[key];
			}
		}
		
		public function has(name:String):Boolean
		{
			return mPropertiesRowData[name] !== undefined;
		}
		
		public function write(name:String, value:*, hasEvent:Boolean = false):*
		{
			var result:* = mPropertiesRowData[name];
			mPropertiesRowData[name] = value;
			
			if(hasEvent && hasEventListener(WRITE))
			{
				dispatchEvent(WRITE, {name:name, value:value});
			}
			
			return result;
		}
		
		public function read(name:String):*
		{
			return mPropertiesRowData[name];
		}
		
		public function update(name:String, value:*, hasEvent:Boolean = false):*
		{
			if(has(name))
			{
				var result:* = mPropertiesRowData[name];
				mPropertiesRowData[name] = value;
				
				if(hasEvent && hasEventListener(UPDATE))
				{
					dispatchEvent(UPDATE, {name:name, lastValue: result, value:value});
				}
				
				return result;
			} 
			else 
			{
				return undefined;
			}	
		}
		
		public function remove(name:String, hasEvent:Boolean = false):*
		{
			var result:* = mPropertiesRowData[name];
			delete mPropertiesRowData[name];
			
			if(hasEvent && hasEventListener(REMOVE))
			{
				dispatchEvent(REMOVE, {name:name, value:result});
			}
			
			return result;
		}
		
		public function clear(hasEvent:Boolean = false):void
		{
			for(var key:String in mPropertiesRowData)
			{
				delete mPropertiesRowData[key];
			}
			
			if(hasEvent && hasEventListener(CLEAR))
			{
				dispatchEvent(CLEAR);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			clear();
			mPropertiesRowData = null;
		}
		
		override public function toString():String
		{
			var results:String = super.toString();
				
			for(var key:String in mPropertiesRowData)
			{
				results += "key: " + key + " value: " + mPropertiesRowData[key] + "\n";
			}
			
			return results;
		}
	}
}