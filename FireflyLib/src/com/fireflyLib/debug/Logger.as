package com.fireflyLib.debug
{
	import com.fireflyLib.utils.TypeUtility;

    /**
     * The Logger class provides mechanisms to print and listen for errors, warnings,
     * and general messages. The built in 'trace' command will output messages to the
     * console, but this allows you to differentiate between different types of
     * messages, give more detailed information about the origin of the message, and
     * listen for log events so they can be displayed in a UI component.
     * 
     * You can use Logger for localized logging by instantiating an instance and
     * referencing it. For instance:
     * 
     * <code>protected static var logger:Logger = new Logger(MyClass);
     * logger.print("Output for MyClass.");</code>
     *  
     * @see LogEntry
     */
    public class Logger
    {
		protected static var listeners:Array = [];
		protected static var filters:Array = [];
		
        protected static var pendingEntries:Array = [];
		
		protected static var started:Boolean = false;
		protected static var disabled:Boolean = false;
        
        /**
         * Register a ILogAppender to be called back whenever log messages occur.
         */
        public static function registerListener(listener:ILogAppender):void
        {
            listeners.push(listener);
        }
		
		public static function registerFilter(filter:ILogFilter):void
		{
			filters.push(filter);
		}
        
        /**
         * Initialize the logging system.
         */
        public static function startup(configCallback:Function = null):void
        {
            // Put default listeners into the list.
			configCallback ||= function():void
			{
				Logger.registerListener(new TraceAppender());
				Logger.registerListener(new UIAppender());
			}
				
			configCallback();
            
            // Process pending messages.
            started = true;
			
			var n:int = pendingEntries.length;
            for(var i:int = 0; i < n; i++)
			{
                processEntry(pendingEntries[i]);
			}
            
            // Free up the pending entries memory.
            pendingEntries.length = 0;
            pendingEntries = null;
        }
		
        /**
         * Call to destructively disable logging. This is useful when going
         * to production, when you want to remove all logging overhead.
         */
        public static function disable():void
        {
            pendingEntries = null;
            started = false;
            listeners = null;
            disabled = true;
        }
        
        protected static function processEntry(entry:LogEntry):void
        {
            // Early out if we are disabled.
            if(disabled) return;
            
            // If we aren't started yet, just store it up for later processing.
            if(!started)
            {
                pendingEntries.push(entry);
                return;
            }
			
			//filter the log
			var n:int = 0;
			var i:int = 0;
			
			n = filters.length;
			for(i = 0; i < n; i++)
			{
				if(!ILogFilter(filters[i]).test(entry)) return;
			}
			
            // Let all the listeners process it.
			n = listeners.length;
            for(i = 0; i< n; i++)
			{
				ILogAppender(listeners[i]).addLogMessage(entry.type, 
					TypeUtility.getQualifiedClassName(entry.reporter), 
					entry.message);
			}
        }
        
        /**
         * Prints a general message to the log. Log entries created with this method
         * will have the MESSAGE type.
         * 
         * @param reporter The object that reported the message. This can be null.
         * @param message The message to print to the log.
         */
        public static function print(reporter:String, message:String):void
        {
            // Early out if we are disabled.
            if(disabled) return;

            var entry:LogEntry = new LogEntry();
            entry.reporter = reporter;
            entry.message = message;
            entry.type = LogEntry.TRACE;
            processEntry(entry);
        }
        
		/**
		 * Prints an info message to the log. Log entries created with this method
		 * will have the INFO type.
		 * 
		 * @param reporter The object that reported the warning. This can be null.
		 * @param method The name of the method that the warning was reported from.
		 * @param message The warning to print to the log.
		 */
		public static function info(reporter:String, message:String):void
		{
            // Early out if we are disabled.
            if(disabled) return;

            var entry:LogEntry = new LogEntry();
			entry.reporter = reporter;
			entry.message = message;
			entry.type = LogEntry.INFO;
			processEntry(entry);
		}
		
		/**
		 * Prints a debug message to the log. Log entries created with this method
		 * will have the DEBUG type.
		 * 
		 * @param reporter The object that reported the debug message. This can be null.
		 * @param method The name of the method that the debug message was reported from.
		 * @param message The debug message to print to the log.
		 */
		public static function debug(reporter:String, message:String):void
		{
            // Early out if we are disabled.
            if(disabled) return;

            var entry:LogEntry = new LogEntry();
			entry.reporter = reporter;
			entry.message = message;
			entry.type = LogEntry.DEBUG;
			processEntry(entry);
		}
		
        /**
         * Prints a warning message to the log. Log entries created with this method
         * will have the WARNING type.
         * 
         * @param reporter The object that reported the warning. This can be null.
         * @param method The name of the method that the warning was reported from.
         * @param message The warning to print to the log.
         */
        public static function warn(reporter:String, message:String):void
        {
            // Early out if we are disabled.
            if(disabled)
                return;

            var entry:LogEntry = new LogEntry();
            entry.reporter = reporter;
            entry.message = message;
            entry.type = LogEntry.WARNING;
            processEntry(entry);
        }
        
        /**
         * Prints an error message to the log. Log entries created with this method
         * will have the ERROR type.
         * 
         * @param reporter The object that reported the error. This can be null.
         * @param message The error to print to the log.
         */
        public static function error(reporter:String, message:String):void
        {
            // Early out if we are disabled.
            if(disabled)
                return;

            var entry:LogEntry = new LogEntry();
            entry.reporter = reporter;
            entry.type = LogEntry.ERROR;
            processEntry(entry);
        }
        
        /**
         * Prints a message to the log. Log enthries created with this method will have
         * the type specified in the 'type' parameter.
         * 
         * @param reporter The object that reported the message. This can be null.
         * @param method The name of the method that the error was reported from.
         * @param message The message to print to the log.
         * @param type The custom type to give the message.
         */
        public static function printCustom(reporter:String, type:String, message:String):void
        {
            // Early out if we are disabled.
            if(disabled)
                return;

            var entry:LogEntry = new LogEntry();
            entry.reporter = reporter;
            entry.type = type;
            entry.message = message;
            processEntry(entry);
        }
        
        /**
         * Utility function to get the current callstack. Only works in debug build.
         * Useful for noting who called what. Empty when in release build.
         */
        public static function getCallStack():String
        {
            try
            {
                var e:Error = new Error();
                return e.getStackTrace();
            }
            catch(e:Error)
            {
			}
			
            return "[no callstack available]";
        }

        public static function printHeader(report:String, message:String):void
        {
            print(report, message);
        }
        
        public static function printFooter(report:String, message:String):void
        {
            print(report, message);
        }
		
		//--------------------------------------------------------------------------------------------------------------
        
		public var reporter:String = null;
        public var enabled:Boolean = true;
        
        public function Logger(reporter:String)
        {
			this.reporter = reporter;
        }
		
		public function info(message:String):void
		{
			if(enabled) Logger.info(reporter, message);
		}
		
        public function warn(message:String):void
        {
            if(enabled) Logger.warn(reporter, message);
        }
        
        public function error(message:String):void
        {
            if(enabled) Logger.error(reporter, message);
        }

        public function print(message:String):void
        {
            if(enabled) Logger.print(reporter, message);
        }
    }
}