package com.fireflyLib.utils
{
	/**
	 * IUID 接口.
	 * 
	 * <p>在以一个app中IUID一般都做唯一的。</p>
	 * 
	 * @author Alex.Zhang.
	 * 
	 */	
    public interface IUID
    {
        function get uid():String;
        function set uid(value:String):void;
    }
}
