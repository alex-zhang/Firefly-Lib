package com.fireflyLib.plugin
{
	public interface IPluginEntity
	{
		function addPlugin(pluginName:String, plugin:IPluginComponent):IPluginComponent;
		function removePlugin(pluginName:String):IPluginComponent;

		function hasRegisteredPlugin(pluginName:String):Boolean;
		
		function findPluinByName(pluginName:String):IPluginComponent;
		function findPluinByType(type:Class):IPluginComponent;
		function findPluinByFunction(func:Function):IPluginComponent;
	}
}