package com.fireflyLib.plugin
{
	public interface IPluginComponent
	{
		function get pluginEntity():IPluginEntity;
		function set pluginEntity(value:IPluginEntity):void;
		
		function onAttachToPluginEntity():void;
		function onDettachFromPluginEntity():void;
	}
}