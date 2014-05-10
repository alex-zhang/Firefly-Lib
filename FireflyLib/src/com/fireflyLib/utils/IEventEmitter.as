package com.fireflyLib.utils
{
	public interface IEventEmitter
	{
		function addEventListener(eventType:String, listener:Function):void;
		function removeEventListener(eventType:String, listener:Function):void;
		function removeEventListeners(eventType:String = null):void;
		function hasEventListener(eventType:String):Boolean;

		function dispatchEvent(eventType:String, eventObject:Object = null):void;
	}
}