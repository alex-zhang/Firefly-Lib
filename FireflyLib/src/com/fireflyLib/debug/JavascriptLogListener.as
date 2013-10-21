package com.fireflyLib.debug
{
    import com.fireflyLib.debug.ILogAppender;
    
    import flash.external.ExternalInterface;
    
    /**
     * Simple listener to dump log events out to javascript. You might want
     * to customize the name of the function it calls.
     * 
     * Note that this can be an expensive listener to have active. We have
     * observed that it can take as much as 6ms to log one output line. So,
     * you may only want to use this listener when necessary.
     */
    public class JavascriptLogListener implements ILogAppender
    {
        public function addLogMessage(level:String, loggerName:String, message:String):void
        {
			switch(level)
			{
				case LogEntry.ERROR:
					ExternalInterface.call("console.error", loggerName, message);
					break;
				
				case LogEntry.WARNING:
					ExternalInterface.call("console.warn", loggerName, message);
					break;
				
				case LogEntry.DEBUG:
					ExternalInterface.call("console.debug", loggerName, message);
					break;
				
				case LogEntry.INFO:
					ExternalInterface.call("console.info", loggerName, message);
					break;
				
				case LogEntry.TRACE:
					ExternalInterface.call("console.trace", loggerName, message);
					break;
			}
        }
    }
}