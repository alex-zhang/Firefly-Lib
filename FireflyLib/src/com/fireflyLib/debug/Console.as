package com.fireflyLib.debug
{
    import com.fireflyLib.utils.GlobalPropertyBag;
    import com.fireflyLib.utils.StringUtil;
    
    import flash.display.Stage;
    import flash.external.ExternalInterface;
    
    /**
     * Process simple text mCommands from the user. Useful for debugging.
     */
    public class Console
    {
		public static const REPORTER_NAME:String = "Console";
		
        /**
         * The mCommands, indexed by name.
         */
        protected static var mCommands:Object = {};
        
        /**
         * Alphabetically ordered list of mCommands.
         */
        protected static var mCommandList:Array = [];
        protected static var mCommandListOrdered:Boolean = false;
        
        protected static var mHotKeyCode:uint = 192;//~
        
        protected static var mStats:Stats;
        
        protected static var mPrevTimescale:Number;
		
        public static var verbosity:int = 0;
		
        public static var showStackTrace:Boolean = false;
        
        
        /**
         * Register a command which the user can execute via the console.
         *
         * <p>Arguments are parsed and cast to match the arguments in the user's
         * function. Command names must be alphanumeric plus underscore with no
         * spaces.</p>
         *
         * @param name The name of the command as it will be typed by the user. No spaces.
         * @param callback The function that will be called. Can be anonymous.
         * @param docs A description of what the command does, its arguments, etc.
         *
         */
        public static function registerCommand(name:String, callback:Function, docs:String = null):void
        {
            // Sanity checks.
            if (callback == null)
                Logger.error(REPORTER_NAME, "registerCommand " + name + " has no callback!");
            
            if (!name || name.length == 0)
                Logger.error(REPORTER_NAME, "registerCommand Command has no name!");

            if (name.indexOf(" ") != -1)
				Logger.error(REPORTER_NAME, "registerCommand Command " + name + " has a space in it, it will not work.");
            
			name = name.toLowerCase();
            
            if (mCommands[name])
                Logger.warn(REPORTER_NAME, "registerCommand Replacing existing command " + name + ".");
            
			// Fill in description.
			var c:ConsoleCommand = new ConsoleCommand();
			c.name = name;
			c.callback = callback;
			c.docs = docs;
			
            // Set it.
            mCommands[name] = c;
            
            // Update the list.
            mCommandList.push(c);
            mCommandListOrdered = false;
        }
        
        /**
         * @return An alphabetically sorted list of all the console mCommands.
         */
        public static function getCommandList():Array
        {
            ensuremCommandsOrdered();
            return mCommandList;
        }
        
        /**
         * Take a line of console input and process it, executing any command.
         * @param line String to parse for command.
         */
        public static function processLine(line:String):void
        {
            // Make sure everything is in order.
            ensuremCommandsOrdered();
            
            // Match Tokens, this allows for text to be split by spaces excluding spaces between quotes.
            // TODO Allow escaping of quotes
            var pattern:RegExp = /[^\s"']+|"[^"]*"|'[^']*'/g;
            var args:Array = [];
            var test:Object = {};
            while (test)
            {
                test = pattern.exec(line);
                if (test)
                {
                    var str:String = test[0];
                    str = StringUtil.trimChar(str, "'");
                    str = StringUtil.trimChar(str, "\"");
                    args.push(str);	// If no more matches can be found, test will be null
                }
            }
            
            // Look up the command.
            if (args.length == 0)
                return;
			
            var potentialCommand:ConsoleCommand = mCommands[args[0].toString().toLowerCase()];
            
            if (!potentialCommand)
            {
                Logger.warn(REPORTER_NAME, "processLine No such command '" + args[0].toString() + "'!");
                return;
            }
            
            // Now call the command.
            try
            {
                potentialCommand.callback.apply(null, args.slice(1));
            }
            catch(e:Error)
            {
                var errorStr:String = "Error: " + e.toString();
                if (showStackTrace)
                {
                    errorStr += " - " + e.getStackTrace();
                }
                Logger.error(REPORTER_NAME, args[0] + " " + errorStr);
            }
        }
        
        /**
         * Internal initialization, this will get called on its own.
         */
        public static function init():void
        {
            /*** THESE ARE THE DEFAULT CONSOLE mCommands ***/
            registerCommand("help", function(prefix:String = null):void
            {
                // Get mCommands in alphabetical order.
                ensuremCommandsOrdered();
                
                Logger.print(REPORTER_NAME, "Keyboard shortcuts: ");
                Logger.print(REPORTER_NAME, "[SHIFT]-TAB - Cycle through autocompleted mCommands.");
                Logger.print(REPORTER_NAME, "PGUP/PGDN   - Page log view up/down a page.");
                Logger.print(REPORTER_NAME, "");
                
                // Display results.
                Logger.print(REPORTER_NAME, "Commands:");
                for (var i:int = 0; i < mCommandList.length; i++)
                {
                    var cc:ConsoleCommand = mCommandList[i] as ConsoleCommand;
                    
                    // Do prefix filtering.
                    if (prefix && prefix.length > 0 && cc.name.substr(0, prefix.length) != prefix)
                        continue;
                    
                    Logger.print(REPORTER_NAME, "   " + cc.name + " - " + (cc.docs ? cc.docs : ""));
                }
                
                // List input options.
            }, "[prefix] - List known mCommands, optionally filtering by prefix.");
            
            registerCommand("fps", function():void
            {
                if (!mStats)
                {
                    mStats = new Stats();
					Stage(GlobalPropertyBag.stage).addChild(mStats);
                    Logger.print(REPORTER_NAME, "Enabled FPS display.");
                }
                else
                {
					Stage(GlobalPropertyBag.read("stage")).removeChild(mStats);
                    mStats = null;
                    Logger.print(REPORTER_NAME, "Disabled FPS display.");
                }
            }, "Toggle an FPS/Memory usage indicator.");
            
            registerCommand("verbose", function(level:int):void
            {
                Console.verbosity = level;
                Logger.print(REPORTER_NAME, "Verbosity set to " + level);
            }, "Set verbosity level of console output.");
            
            if(ExternalInterface.available)
            {
                registerCommand("exit", function():void
				{
					if(ExternalInterface.available)
					{
						Logger.info(REPORTER_NAME, "exit " + ExternalInterface.call("window.close"));	
					}
					else
					{
						Logger.warn(REPORTER_NAME, "exit ExternalInterface is not avaliable");
					}
				}, "Attempts to exit the application using ExternalInterface if avaliable");
            }
        }
        
        protected static function ensuremCommandsOrdered():void
        {
            // Avoid extra work.
            if (mCommandListOrdered == true)
                return;
            
            // Register default mCommands.
            if (mCommands.help == null)
                init();
            
            // Note we are done.
            mCommandListOrdered = true;
            
            // Do the sort.
            mCommandList.sort(function(a:ConsoleCommand, b:ConsoleCommand):int
            {
                if (a.name > b.name)
                    return 1;
                else
                    return -1;
            });
        }
        
        protected static function generateIndent(indent:int):String
        {
            var str:String = "";
            for (var i:int = 0; i < indent; i++)
            {
                // Add 2 spaces for indent
                str += "  ";
            }
            
            return str;
        }
        
        /**
         * The keycode to toggle the Console interface.
         */
        public static function set hotKeyCode(value:uint):void
        {
            Logger.print(REPORTER_NAME, "Setting hotKeyCode to: " + value);
            mHotKeyCode = value;
        }
        
        public static function get hotKeyCode():uint
        {
            return mHotKeyCode;
        }
    }
}

final class ConsoleCommand
{
    public var name:String;
    public var callback:Function;
    public var docs:String;
}