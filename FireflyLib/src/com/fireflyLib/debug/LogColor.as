package com.fireflyLib.debug
{
    public class LogColor
    {
        public static const DEBUG:String 	= "#DDDDDD";
        public static const INFO:String 	= "#BBBBBB";
        public static const WARN:String 	= "#FF6600";
        public static const ERROR:String 	= "#FF0000";
        public static const TRACE:String 	= "#FFFFFF";
        public static const CMD:String 		= "#00DD00";
        
        public static function getColor(level:String):String
        {
            switch(level)
            {
                case LogEntry.DEBUG:
                    return DEBUG;
                case LogEntry.INFO:
                    return INFO;
                case LogEntry.WARNING:
                    return WARN;
                case LogEntry.ERROR:
                    return ERROR;
                case LogEntry.TRACE:
                    return TRACE;
                case "CMD":
                    return CMD;
                default:
                    return TRACE;
            }
        }
    }
}