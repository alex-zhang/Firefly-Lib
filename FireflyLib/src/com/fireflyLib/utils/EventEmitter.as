package com.fireflyLib.utils
{
	import flash.utils.Dictionary;
	
	public class EventEmitter
	{
		private var mEventListeners:Dictionary;
		private var mEmitterOwner:Object;
		
		public function EventEmitter(emitterOwner:* = null)
		{
			super();
			
			mEmitterOwner = emitterOwner;
		}
		
		public function dispose():void
		{
			mEventListeners = null;
			mEmitterOwner = null;
		}
		
		public function addEventListener(eventType:String, listener:Function):void
		{
			if(mEventListeners == null) mEventListeners = new Dictionary();
			
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
				if(mEmitterOwner)
				{
					listeners[i].call(null, mEmitterOwner, eventObject);
				}
				else
				{
					listeners[i].call(null, this, eventObject);
				}
			}
		}
	}
}