package com.fireflyLib.utils.plugin
{
	import com.fireflyLib.utils.EventEmitter;
	import com.fireflyLib.utils.PropertyBag;

	public interface IPluginEntity
	{
		function get eventEmitter():EventEmitter
		function get propertyBag():PropertyBag;
		
		function pluginComponent(pluginName:String, component:IPluginComponent):IPluginComponent;
		function plugOutComponent(pluginName:String):IPluginComponent;
		
		function hasPluginComponent(pluginName:String):Boolean;
		function findPluinComponent(pluginName:String):IPluginComponent;
		function findPluinComponentByTypeCls(typeCls:Class):IPluginComponent;
		function findPluinComponentsByTypeCls(typeCls:Class, results:Array = null):Array;
		function findPluinComponentByFilterFunction(filterFunc:Function):IPluginComponent;
		function findPluinComponentsByFilterFunction(filterFunc:Function, results:Array = null):Array;
		function findAllPluinComponents(results:Array = null):Array;
	}
}