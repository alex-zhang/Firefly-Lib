package com.fireflyLib.utils
{
	public class PropertyBag
	{
		protected var mPropertiesData:Array = null;
		
		public function PropertyBag(data:Object = null)
		{
			mPropertiesData = [];
			
			for(var key:String in data)
			{
				mPropertiesData[key] = data[key];
			}
		}
		
		public function has(name:String):Boolean
		{
			return mPropertiesData[name] !== undefined;
		}
		
		public function write(name:String, value:*):*
		{
			var result:* = mPropertiesData[name];
			mPropertiesData[name] = value;
			
			return result;
		}
		
		public function read(name:String):*
		{
			return mPropertiesData[name];
		}
		
		public function update(name:String, value:*):*
		{
			var result:*;
			
			if(has(name))
			{
				result = mPropertiesData[name];
				mPropertiesData[name] = value;
				return result;
			} 
			else 
			{
				return undefined;
			}	
		}
		
		public function remove(name:String):*
		{
			var result:* = mPropertiesData[name];
			delete mPropertiesData[name];
			
			return result;
		}
		
		public function clear():void
		{
			for(var key:String in mPropertiesData)
			{
				delete mPropertiesData[key];
			}
		}
	}
}