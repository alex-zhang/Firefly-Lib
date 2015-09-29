package com.fireflyLib.utils
{
	import flash.utils.getDefinitionByName;

	/**
	 *  
	 * json format.
	 * {
	 * 		clsProps:
	 * 		{
	 * 			key:"xxx",
	 * 			methodName:[1, 2, 3]// u can defined the function here.
	 * 		}
	 * 
	 * 		clsType:"xxx.xxx.xxx", //Class or String or Function,
	 * 
	 * 		ctorParams:[1, 2, 3, "(class)xxx.xxx.xxx"],
	 * 
	 * 		props:
	 * 		{
	 * 			key:"xxx",
	 * 			functionName:[1, 2, 3]// u can defined the function here.
	 * 		}
	 * 
	 * 		callback:Function(instance)
	 * }
	 * 
	 * @author Alex Zhang
	 * 
	 */	
	public final class JsonObjectFactorUtil
	{
		public static const CLS_TYPE:String = "clsType";

		public static const CHARS_NULL_FLAG:String = "(null)";
		public static const CHARS_UNDEFINED_FLAG:String = "(undefined)";
		private static const CHARS_STAGE_FLAG:String = "(stage)";
		public static const CHARS_GLOBAL_FLAG:String = "(globalProp)";
		public static const CHARS_CLASS_FLAG:String = "(class)";
		public static const CHARS_BOOLEAN_FLAG:String = "(boolean)";
		public static const CHARS_NUMBER_FLAG:String = "(number)";
		public static const CHARS_INT_FLAG:String = "(int)";
		
		public static function createFromJsonConfig(config:*):*
		{
			if(isJsonConfigFormat(config))
			{
				return createFromObject(config);
			}

			throw new Error("not json config format!");
		}
		
		public static function isJsonConfigFormat(config:Object):Boolean
		{
			return TypeUtility.isJsonObjectType(config) && CLS_TYPE in config;
		}

		public static function createFromAny(config:*):*
		{
			if(config is String)
			{
				return createFromString(config);
			}
			else if(config is Array)
			{
				return createFromArray(config);
			}
			else if(TypeUtility.isJsonObjectType(config))
			{
				return createFromObject(config);
			}
			else
			{
				return config;
			}
		}
		
		public static function createFromObject(config:Object):*
		{
			for(var key:String in config)
			{
				config[key] = createFromAny(config[key]);
			}

			if(isJsonConfigFormat(config))
			{
				var clsType:Object = config[CLS_TYPE];
				if(clsType is Function)
				{
					clsType = Function(clsType)();
				}
				
				var callback:Function = config.callback as Function;

				config = ObjectFactoryUtil.create(
						clsType as Class, 
						config.props,
						config.ctorParams,
						config.clsProps);
				
				if(callback != null)
				{
					callback(config);
				}
			}
			
			return config;
		}
		
		public static function createFromArray(arrConfig:Array):*
		{
			var n:int = arrConfig ? arrConfig.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				arrConfig[i] = createFromAny(arrConfig[i]);
			}
			
			return arrConfig;
		}

		public static function createFromString(strConfig:String):*
		{
			switch(strConfig)
			{
				//"(null)"
				case CHARS_NULL_FLAG:
					return null;
					break;
				
				//"(undefined)"
				case CHARS_UNDEFINED_FLAG:
					return undefined;
					break;
				
				//"(stage)"
				case CHARS_STAGE_FLAG:
					return GlobalPropertyBag.stage;
					break;
			}
			
			//"(clsType)flash.display.DisplayObject"
			if(StringUtil.startWithChars(strConfig, CHARS_CLASS_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_CLASS_FLAG);
				return getDefinitionByName(strConfig);
			}
			
			//"(boolean)true|false"
			if(StringUtil.startWithChars(strConfig, CHARS_BOOLEAN_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_BOOLEAN_FLAG, -1).toLowerCase();
				return strConfig == "true" ? true: false;
			}
			
			//"(number)1.234"
			if(StringUtil.startWithChars(strConfig, CHARS_NUMBER_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_NUMBER_FLAG, -1);
				return parseFloat(strConfig);
			}
			
			//"(int)1000"
			if(StringUtil.startWithChars(strConfig, CHARS_INT_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_INT_FLAG, -1);
				return parseInt(strConfig);
			}
			
			//"(globalProp)key"
			if(StringUtil.startWithChars(strConfig, CHARS_GLOBAL_FLAG))
			{
				//here is GlobalPropertyBag
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_GLOBAL_FLAG, -1);
				return GlobalPropertyBag.read(strConfig);
			}
			
			return strConfig;
		}
	}
}