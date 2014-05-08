package com.fireflyLib.debug
{
    public class LogColor
    {
        public static const DEBUG:uint 	= 0xDDDDDD;
        public static const INFO:uint 	= 0xBBBBBB;
        public static const WARNING:uint =	0xFF6600;
        public static const ERROR:uint 	= 0xFF0000;
        public static const TRACE:uint 	= 0xFFFFFF;
        public static const CMD:uint 		= 0x00DD00;
        
        public static function getColor(level:String):uint
        {
            switch(level)
            {
                case LogEntry.DEBUG:
                    return DEBUG;
					
                case LogEntry.INFO:
                    return INFO;
					
                case LogEntry.WARNING:
                    return WARNING;
					
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