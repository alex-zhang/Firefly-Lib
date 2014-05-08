package com.fireflyLib.utils
{
	import flash.utils.getQualifiedClassName;
	
	public class EventEmitter
	{
		private var mEventListeners:Array
		private var mOwner:Object;
		
		public function EventEmitter(owner:Object = null)
		{
			super();

			mOwner = owner;
		}
		
		public final function get owner():Object
		{
			return mOwner || this;
		}
		
		public function addEventListener(eventType:String, listener:Function):void
		{
			if(!mEventListeners) mEventListeners = [];
			
			var listeners:Vector.<Function> = mEventListeners[eventType] as Vector.<Function>;
			if(listeners == null)
			{
				mEventListeners[eventType] = new <Function>[listener];
			}
			else if (listeners.indexOf(listener) == -1) // check for duplicates
			{
				listeners.push(listener);
			}
		}
		
		public function removeEventListener(eventType:String, listener:Function):void
		{
			if(mEventListeners)
			{
				var listeners:Vector.<Function> = mEventListeners[eventType] as Vector.<Function>;
				if(listeners)
				{
					var delIndex:int = listeners.indexOf(listener);
					if(delIndex != -1)
					{
						listeners.splice(delIndex, 1);
						if(listeners.length == 0) delete mEventListeners[eventType];
					}
				}
			}
		}
		
		public function removeEventListeners(eventType:String = null):void
		{
			if(eventType && mEventListeners)
			{
				delete mEventListeners[eventType];
			}
			else
			{
				mEventListeners = null;
			}
		}
		
		public function hasEventListener(eventType:String):Boolean
		{
			var listeners:Vector.<Function> = mEventListeners ?
				mEventListeners[eventType] as Vector.<Function> : null;
			return listeners ? listeners.length != 0 : false;
		}
		
		public function dispatchEvent(eventType:String, eventObject:Object = null):void
		{
			if(mEventListeners == null) return;
			
			var listeners:Vector.<Function> = mEventListeners[eventType] as Vector.<Function>;
			if(listeners == null) return;
			
			var listenerLength:uint = listeners.length;
			for(var i:int = 0; i < listenerLength; i++)
			{
				if(mOwner)
				{
					listeners[i].call(null, mOwner, eventObject);
				}
				else
				{
					listeners[i].call(null, this, eventObject);
				}
			}
		}
		
		public function dispose():void
		{
			mEventListeners = null;
			mOwner = null;
		}
		
		public function toString():String
		{
			var results:String = "class: " + getQualifiedClassName(this) + "\n";
			
			if(mEventListeners != null)
			{
				var listeners:Vector.<Function>;
				for(var eventType:String in mEventListeners)
				{
					listeners = mEventListeners[eventType] as Vector.<Function>;
					
					results += "listen eventType: " + eventType + " count: " + listeners.length + "\n";
				}
			}
			
			return results;
		}
	}
}