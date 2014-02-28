package com.fireflyLib.utils.plugin
{
	import com.fireflyLib.utils.EventEmitter;
	import com.fireflyLib.utils.PropertyBag;

	public class PluginEntity implements IPluginEntity
	{
		public var __onPluginComponent:Function = onPluginComponent;
		public var __onPlugoutComponent:Function = onPlugoutComponent;
		
		protected var mPluginComponentsMap:Array = [];//IPluginComponent
		protected var mEventEmitter:EventEmitter;
		protected var mPropertyBag:PropertyBag = null;
		
		private var mHost:IPluginEntity;
		
		public function PluginEntity(host:IPluginEntity = null)
		{
			super();

			mHost = host;
		}
		
		public final function get host():IPluginEntity
		{
			return mHost || this;
		}
		
		public final function get eventEmitter():EventEmitter
		{
			if(!mEventEmitter) mEventEmitter = new EventEmitter(this);
			
			return mEventEmitter;
		}
		
		public final function get propertyBag():PropertyBag
		{
			if(!mPropertyBag) mPropertyBag = new PropertyBag();
			
			return mPropertyBag;
		}
		
		public function pluginComponent(pluginName:String, component:IPluginComponent):IPluginComponent
		{
			if(component && !hasPluginComponent(pluginName))
			{
				mPluginComponentsMap[pluginName] = component;
				
				__onPluginComponent(component);
				
				return component;
			}

			return null;
		}

		protected function onPluginComponent(component:IPluginComponent):void
		{
			component.pluginEntity = host;
			component.onAttachToPluginEntity();
		}
		
		public function plugOutComponent(pluginName:String):IPluginComponent
		{
			var plugin:IPluginComponent = findPluinComponent(pluginName);
			if(plugin)
			{
				delete mPluginComponentsMap[pluginName];
				
				__onPlugoutComponent(plugin);

				return plugin;
			}
			
			return null;
		}
		
		protected function onPlugoutComponent(plugin:IPluginComponent):void
		{
			plugin.onDettachFromPluginEntity();
			plugin.pluginEntity = null;
		}
		
		public function hasPluginComponent(pluginName:String):Boolean
		{
			return Boolean(mPluginComponentsMap[pluginName]);
		}
		
		public function findPluinComponent(pluginName:String):IPluginComponent
		{
			return mPluginComponentsMap[pluginName] as IPluginComponent;
		}
		
		public function findPluinComponentByTypeCls(typeCls:Class):IPluginComponent
		{
			for each(var plugin:IPluginComponent in mPluginComponentsMap)
			{
				if(plugin is typeCls)
				{
					return plugin;
				}
			}
			
			return null;
		}
		
		public function findPluinComponentsByTypeCls(typeCls:Class, results:Array = null):Array
		{
			if(!results) results = [];
			
			for each(var plugin:IPluginComponent in mPluginComponentsMap)
			{
				if(plugin is typeCls)
				{
					results.push(plugin);
				}
			}
			
			return results;
		}
		
		public function findPluinComponentByFilterFunction(filterFunc:Function):IPluginComponent
		{
			for each(var plugin:IPluginComponent in mPluginComponentsMap)
			{
				if(filterFunc(plugin))
				{
					return plugin;
				}
			}
			
			return null;
		}
		
		public function findPluinComponentsByFilterFunction(filterFunc:Function, results:Array = null):Array
		{
			if(!results) results = [];
			
			for each(var plugin:IPluginComponent in mPluginComponentsMap)
			{
				if(filterFunc(plugin))
				{
					results.push(plugin);
				}
			}
			
			return results;
		}
		
		public function findAllPluinComponents(results:Array = null):Array
		{
			if(!results) results = [];
			
			for each(var plugin:IPluginComponent in mPluginComponentsMap)
			{
				results.push(plugin);
			}
			
			return results;
		}
	}
}