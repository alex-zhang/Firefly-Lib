package com.fireflyLib.debug
{
	import com.fireflyLib.core.SystemGlobal;
	import com.fireflyLib.debug.Console;
	import com.fireflyLib.debug.ILogAppender;
	
	import flash.events.KeyboardEvent;

	/**
	 * LogAppender for displaying log messages in a LogViewer. The LogViewer will be
     * attached and detached from the main view when the defined hot key is pressed. The tilde (~) key 
	 * is the default hot key.
	 */	
	public class UIAppender implements ILogAppender
	{
		protected var mLogViewer:LogViewer;
	   
		public function UIAppender()
		{
			SystemGlobal.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			
			mLogViewer = new LogViewer();
		}
  
		protected function onKeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode != Console.hotKeyCode) return;
			 
			if(mLogViewer)
			{
				if (mLogViewer.parent)
				{
					mLogViewer.parent.removeChild(mLogViewer);
					mLogViewer.deactivate();
				}
				else
				{
					SystemGlobal.stage.addChild(mLogViewer);
					
					var char:String = String.fromCharCode(event.charCode);
					mLogViewer.restrict = "^" + char.toUpperCase() + char.toLowerCase();	// disallow hotKey character
					mLogViewer.activate();
				}
			}
		}
  
		public function addLogMessage(level:String, loggerName:String, message:String):void
		{
			mLogViewer.addLogMessage(level, loggerName, message);
		}
	}
}