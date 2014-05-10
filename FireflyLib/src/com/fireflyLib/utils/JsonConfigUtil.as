package com.fireflyLib.utils
{
	public final class JsonConfigUtil
	{
//		//String, Function, ClassFactory, Class, Config
//		public static function newInstance2(classDef:*):*
//		{
//			if(classDef is Class)
//			{
//				return new classDef();
//			}
//			else if(classDef is String)
//			{
//				var cls:Class = TypeUtility.getClassFromName(classDef);
//				return new cls();
//			}
//			else if(classDef is Function)
//			{
//				return classDef();
//			}
//			else if(classDef is ClassFactory)
//			{
//				return ClassFactory(classDef).newInstance();
//			}
//			else if(isObectConfigFormat(classDef))
//			{
//				return newInstanceFromObject(classDef);
//			}
//			
//			throw new Error("ObjectFactoryUtil::newInstance2 invalid classDef " + classDef);
//		}
//		
//		/**
//		 * config format.
//		 * {
//		 * 		clsProperties:
//		 * 		{
//		 * 			name:"xxx",
//		 * 			functionName:[1, 2, 3]// u can defined the function here.
//		 * 		}
//		 * 
//		 * 		clsType:"xxx.xxx.xxx", //Class or String or Function,
//		 * 
//		 * 		constructorParams:[1, 2, 3, "(class)xxx.xxx.xxx"],
//		 * 
//		 * 		properties:
//		 * 		{
//		 * 			name:"xxx",
//		 * 			functionName:[1, 2, 3]// u can defined the function here.
//		 * 		}
//		 * }
//		 */
//		public static function newInstanceFromConfig(config:*):*
//		{
//			if(isObectConfigFormat(config))
//			{
//				return newInstanceFromObject(config);
//			}
//			
//			throw new Error("not config format!");
//		}
//		
//		public static function isObectConfigFormat(config:Object):Boolean
//		{
//			return TypeUtility.isRootObjectType(config) && CLS_TYPE in config;
//		}
//		
//		private static function newInstanceFromAny(config:*):*
//		{
//			if(config is String)
//			{
//				return newInstanceFromString(config);
//			}
//			else if(config is Array)
//			{
//				return newInstanceFromArray(config);
//			}
//			else if(TypeUtility.isRootObjectType(config))
//			{
//				return newInstanceFromObject(config);
//			}
//			else
//			{
//				return config;
//			}
//		}
//		
//		private static function newInstanceFromObject(config:Object):*
//		{
//			var objectConfigFormat:Boolean = CLS_TYPE in config;
//			
//			for(var key:String in config)
//			{
//				if(key != CLS_TYPE)
//				{
//					config[key] = newInstanceFromAny(config[key]);
//				}
//			}
//			
//			if(objectConfigFormat)
//			{
//				return newInstance(config.clsType, 
//					config.properties, 
//					config.constructorParams, 
//					config.clsProperties);
//			}
//			else
//			{
//				return config;
//			}
//		}
//		
//		private static function newInstanceFromArray(arrConfig:Array):*
//		{
//			var n:int = arrConfig ? arrConfig.length : 0;
//			for(var i:int = 0; i < n; i++)
//			{
//				arrConfig[i] = newInstanceFromAny(arrConfig[i]);
//			}
//			
//			return arrConfig;
//		}
//		
//		public static function newInstanceFromString(strConfig:String):*
//		{
//			switch(strConfig)
//			{
//				case CHARS_NULL_FLAG:
//					return null;
//					break;
//				
//				case CHARS_UNDEFINED_FLAG:
//					return undefined;
//					break;
//				
//				case CHARS_STAGE_FLAG:
//					return GlobalPropertyBag.stage;
//					break;
//			}
//			
//			if(StringUtil.startWithChars(strConfig, CHARS_CLASS_FLAG))
//			{
//				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_CLASS_FLAG);
//				return TypeUtility.getClass(strConfig);
//			}
//			
//			if(StringUtil.startWithChars(strConfig, CHARS_BOOLEAN_FLAG))
//			{
//				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_BOOLEAN_FLAG, -1).toLowerCase();
//				return strConfig == "true" ? true: false;
//			}
//			
//			if(StringUtil.startWithChars(strConfig, CHARS_NUMBER_FLAG))
//			{
//				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_NUMBER_FLAG, -1);
//				return parseFloat(strConfig);
//			}
//			
//			if(StringUtil.startWithChars(strConfig, CHARS_INT_FLAG))
//			{
//				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_INT_FLAG, -1);
//				return parseInt(strConfig);
//			}
//			
//			if(StringUtil.startWithChars(strConfig, CHARS_GLOBAL_FLAG))
//			{
//				//here is GlobalPropertyBag 
//				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_GLOBAL_FLAG, -1);
//				return GlobalPropertyBag.read(strConfig);
//			}
//			
//			return strConfig;
//		}
		
		private static const CLS_TYPE:String = "clsType";
		
		private static const CHARS_NULL_FLAG:String = "(null)";
		private static const CHARS_UNDEFINED_FLAG:String = "(undefined)";
		private static const CHARS_STAGE_FLAG:String = "(stage)";
		private static const CHARS_GLOBAL_FLAG:String = "(global)";
		private static const CHARS_CLASS_FLAG:String = "(class)";
		private static const CHARS_BOOLEAN_FLAG:String = "(boolean)";
		private static const CHARS_NUMBER_FLAG:String = "(number)";
		private static const CHARS_INT_FLAG:String = "(int)";
	}
}