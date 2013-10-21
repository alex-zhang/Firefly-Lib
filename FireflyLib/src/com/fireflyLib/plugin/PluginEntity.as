package com.fireflyLib.plugin
{
	public class PluginEntity implements IPluginEntity
	{
		public var host:IPluginEntity;
		
		protected var myPlugins:Array = [];//IPluginComponent
		
		public function PluginEntity(host:IPluginEntity = null)
		{
			super();
			
			this.host = host;
		}
		
		public function addPlugin(pluginName:String, plugin:IPluginComponent):IPluginComponent
		{
			if(plugin && !hasRegisteredPlugin(pluginName))
			{
				myPlugins[pluginName] = plugin;
				
				onAddedPlugin(plugin);
				
				return plugin;
			}

			return null;
		}
		
		protected function onAddedPlugin(plugin:IPluginComponent):void
		{
			//there's some bug appear when i wrote like this, plugin.pluginEntity = host != null ? host : this
			//or like this plugin.pluginEntity = host || this;
			if(host != null)
			{
				plugin.pluginEntity = host;
			}
			else
			{
				plugin.pluginEntity = this;
			}
			
			plugin.onAttachToPluginEntity();
		}
		
		public function removePlugin(pluginName:String):IPluginComponent
		{
			var plugin:IPluginComponent = findPluinByName(pluginName);
			
			if(plugin)
			{
				delete myPlugins[pluginName];
				
				onRemovePlugin(plugin);
				
				return plugin;
			}
			
			return null;
		}
		
		protected function onRemovePlugin(plugin:IPluginComponent):void
		{
			plugin.onDettachFromPluginEntity();
			
			plugin.pluginEntity = null;
		}
		
		public function hasRegisteredPlugin(pluginName:String):Boolean
		{
			return Boolean(myPlugins[pluginName]);
		}
		
		public function findPluinByName(pluginName:String):IPluginComponent
		{
			return myPlugins[pluginName];
		}
		
		public function findPluinByType(type:Class):IPluginComponent
		{
			for each(var plugin:IPluginComponent in myPlugins)
			{
				if(plugin is type)
				{
					return plugin;
				}
			}
			
			return null;
		}
		
		public function findPluinByFunction(func:Function):IPluginComponent
		{
			for each(var plugin:IPluginComponent in myPlugins)
			{
				if(func(plugin))
				{
					return plugin;
				}
			}
			
			return null;
		}
		
		public function findPluinsByFunction(func:Function):Array
		{
			var result:Array = [];
			for each(var plugin:IPluginComponent in myPlugins)
			{
				if(func(plugin))
				{
					result.push(plugin);
				}
			}
			
			return result;
		}
	}
}