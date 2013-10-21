package com.fireflyLib.utils
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class EventEmitter
	{
		private var mEventListeners:Dictionary;
		
		public function EventEmitter()
		{
			super();
		}
		
		/** Registers an event listener at a certain object. */
		public function addEventListener(type:String, listener:Function):void
		{
			if (mEventListeners == null) mEventListeners = new Dictionary();
			
			var listeners:Vector.<Function> = mEventListeners[type] as Vector.<Function>;
			if (listeners == null) mEventListeners[type] = new <Function>[listener];
			else if (listeners.indexOf(listener) == -1) // check for duplicates
				listeners.push(listener);
		}
		
		/** Removes an event listener from the object. */
		public function removeEventListener(type:String, listener:Function):void
		{
			if (mEventListeners)
			{
				var listeners:Vector.<Function> = mEventListeners[type] as Vector.<Function>;
				if (listeners)
				{
					var numListeners:int = listeners.length;
					var remainingListeners:Vector.<Function> = new <Function>[];
					
					for (var i:int=0; i< numListeners; ++i)
						if (listeners[i] != listener) remainingListeners.push(listeners[i]);
					
					mEventListeners[type] = remainingListeners;
				}
			}
		}
		
		/** Removes all event listeners with a certain type, or all of them if type is null. 
		 *  Be careful when removing all event listeners: you never know who else was listening. */
		public function removeEventListeners(type:String = null):void
		{
			if (type && mEventListeners)
				delete mEventListeners[type];
			else
				mEventListeners = null;
		}
		
		/** Dispatches an event to all objects that have registered listeners for its type. 
		 *  If an event with enabled 'bubble' property is dispatched to a display object, it will 
		 *  travel up along the line of parents, until it either hits the root object or someone
		 *  stops its propagation manually. */
		public function dispatchEvent(event:Event):void
		{
//			var previousTarget:EventDispatcher = event.target;
//			event.setTarget(this);
//			
//			if (bubbles && this is DisplayObject) bubbleEvent(event);
//			else                                  invokeEvent(event);
//			
//			if (previousTarget) event.setTarget(previousTarget);
		}
	}
}