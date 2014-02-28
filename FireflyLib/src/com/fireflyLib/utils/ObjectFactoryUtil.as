package com.fireflyLib.utils
{
	import com.fireflyLib.utils.StringUtil;
	
	import flash.utils.getQualifiedClassName;
	
	public final class ObjectFactoryUtil
	{
		private static var mRegistedImpClslMap:Array = []//BaseClassORInterface - > ImlCls
		
		public static function registImplCls(typeCls:Class, implCls:Class):void
		{
			var typeClsStr:String = TypeUtility.getQualifiedClassName(typeCls);
			
			if(!mRegistedImpClslMap[typeClsStr])
			{
				mRegistedImpClslMap[typeClsStr] = implCls;
			}
		}
		
		public static function getRegistedImplCls(typeCls:Class):Class
		{
			var typeClsStr:String = flash.utils.getQualifiedClassName(typeCls);
			
			return mRegistedImpClslMap[typeClsStr];
		}
		
		public static function createNewInstanceFromRegistedImplCls(typeCls:Class, 
																	properties:Object = null, 
																	constructorParameters:Array = null):*
		{
			var implCls:Class = getRegistedImplCls(typeCls);
			
			if(!implCls) return null;
			
			return ObjectFactoryUtil.newInstance(implCls, properties, constructorParameters);
		}

		//----------------------------------------------------------------------
		
		private static var mRegistedSingletonInstancelMap:Array = [];//BaseClassORInterface - > instance
		
		public static function registSingletonInstance(typeCls:Class, intance:*):*
		{
			var typeClsStr:String = TypeUtility.getQualifiedClassName(typeCls);
			
			if(!mRegistedSingletonInstancelMap[typeClsStr])
			{
				mRegistedSingletonInstancelMap[typeClsStr] = intance;
				
				return intance;
			}
			
			throw new Error("ObjectFactoryUtil::registSingletonInstance " + typeClsStr + "is Singleton Mode!!!");
		}
		
		public static function getSingletonIntance(typeCls:Class):*
		{
			var typeClsStr:String = TypeUtility.getQualifiedClassName(typeCls);

			return mRegistedSingletonInstancelMap[typeClsStr];
		}
		
		//----------------------------------------------------------------------
		
		// constructor's type is String Type or Class or Function.
		public static function newInstance(constructor:*, 
										   properties:Object = null, 
										   constructorParams:Array = null, 
										   clsProperties:Object = null):*
		{
			if(!constructor) return null;
			
			var constructorCls:Class = TypeUtility.getClass(constructor);
			
			var f:Function;
			var p:String;
			
			if(clsProperties)
			{
				for(p in clsProperties)
				{
					if(p in constructorCls)
					{
						if(constructorCls[p] is Function)
						{
							f = constructorCls[p];
							f.apply(null, clsProperties[p] as Array);//the value is the method's parms.
						}
						else
						{
							constructorCls[p] = clsProperties[p];
						}
					}
				}
			}
			
			//In Actionscript ,there is no way to call constructor by arguments like the Function.apply
			//so no suggest pass the value from constructor. so here the constructor is only support one parameter.
			var instance:* = null;
			
			var constructorParamsLen:int = constructorParams ? constructorParams.length : 0;
			switch(constructorParamsLen)
			{
				case 0: instance = new constructorCls(); break;
				case 1: instance = new constructorCls(constructorParams[0]); break;
				case 2: instance = new constructorCls(constructorParams[0], 
					constructorParams[1]); break;
				case 3: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2]); break;
				case 4: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3]); break;
				case 5: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4]); break;
				case 6: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5]); break;
				case 7: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6]); break;
				case 8: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6],
					constructorParams[7]); break;
				case 9: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6],
					constructorParams[7],
					constructorParams[8]); break;
				case 10: instance = new constructorCls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6],
					constructorParams[7],
					constructorParams[8],
					constructorParams[9]); break;
				
				default:
					throw new RangeError("constructorParams length is too long!");
					break;
				
				/* we only support the count of constructor pameraters count to 11, 
				i think it's totally enough. other wise you'd better refactor your code instead. */
			}
			
			if(properties)
			{
				for(p in properties)
				{
					if(p in instance)
					{
						if(instance[p] is Function)
						{
							f = instance[p];
							f.apply(instance, properties[p] as Array);//the value is the method's parms.
						}
						else
						{
							instance[p] = properties[p];
						}
					}
				}
			}
			
			return instance;
		}
		
		//String, Function, ClassFactory, Class, Config
		public static function newInstance2(classDef:*):*
		{
			if(classDef is Class)
			{
				return new classDef();
			}
			else if(classDef is String)
			{
				var cls:Class = TypeUtility.getClassFromName(classDef);
				return new cls();
			}
			else if(classDef is Function)
			{
				return classDef();
			}
			else if(classDef is ClassFactory)
			{
				return ClassFactory(classDef).newInstance();
			}
			else if(isObectConfigFormat(classDef))
			{
				return newInstanceFromObject(classDef);
			}
			
			throw new Error("ObjectFactoryUtil::newInstance2 invalid classDef " + classDef);
		}
		
		/**
		 * config format.
		 * {
		 * 		clsProperties:
		 * 		{
		 * 			name:"xxx",
		 * 			functionName:[1, 2, 3]// u can defined the function here.
		 * 		}
		 * 
		 * 		clsType:"xxx.xxx.xxx", //Class or String or Function,
		 * 
		 * 		constructorParams:[1, 2, 3, "(class)xxx.xxx.xxx"],
		 * 
		 * 		properties:
		 * 		{
		 * 			name:"xxx",
		 * 			functionName:[1, 2, 3]// u can defined the function here.
		 * 		}
		 * }
		 */
		public static function newInstanceFromConfig(config:*):*
		{
			if(isObectConfigFormat(config))
			{
				return newInstanceFromObject(config);
			}
			
			throw new Error("not config format!");
		}
		
		public static function isObectConfigFormat(config:Object):Boolean
		{
			return TypeUtility.isRootObjectType(config) && CLS_TYPE in config;
		}
		
		private static function newInstanceFromAny(config:*):*
		{
			if(config is String)
			{
				return newInstanceFromString(config);
			}
			else if(config is Array)
			{
				return newInstanceFromArray(config);
			}
			else if(TypeUtility.isRootObjectType(config))
			{
				return newInstanceFromObject(config);
			}
			else
			{
				return config;
			}
		}
		
		private static function newInstanceFromObject(config:Object):*
		{
			var objectConfigFormat:Boolean = CLS_TYPE in config;
			
			for(var key:String in config)
			{
				if(key != CLS_TYPE)
				{
					config[key] = newInstanceFromAny(config[key]);
				}
			}
			
			if(objectConfigFormat)
			{
				return newInstance(config.clsType, 
					config.properties, 
					config.constructorParams, 
					config.clsProperties);
			}
			else
			{
				return config;
			}
		}
		
		private static function newInstanceFromArray(arrConfig:Array):*
		{
			var n:int = arrConfig ? arrConfig.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				arrConfig[i] = newInstanceFromAny(arrConfig[i]);
			}
			
			return arrConfig;
		}
		
		public static function newInstanceFromString(strConfig:String):*
		{
			switch(strConfig)
			{
				case CHARS_NULL_FLAG:
					return null;
					break;
				
				case CHARS_UNDEFINED_FLAG:
					return undefined;
					break;
				
				case CHARS_STAGE_FLAG:
					return GlobalPropertyBag.stage;
					break;
			}
			
			if(StringUtil.startWithChars(strConfig, CHARS_CLASS_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_CLASS_FLAG);
				return TypeUtility.getClass(strConfig);
			}
			
			if(StringUtil.startWithChars(strConfig, CHARS_BOOLEAN_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_BOOLEAN_FLAG, -1).toLowerCase();
				return strConfig == "true" ? true: false;
			}
			
			if(StringUtil.startWithChars(strConfig, CHARS_NUMBER_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_NUMBER_FLAG, -1);
				return parseFloat(strConfig);
			}
			
			if(StringUtil.startWithChars(strConfig, CHARS_INT_FLAG))
			{
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_INT_FLAG, -1);
				return parseInt(strConfig);
			}
			
			if(StringUtil.startWithChars(strConfig, CHARS_GLOBAL_FLAG))
			{
				//here is GlobalPropertyBag 
				strConfig = StringUtil.trimCharsAnd(strConfig, CHARS_GLOBAL_FLAG, -1);
				return GlobalPropertyBag.read(strConfig);
			}
			
			return strConfig;
		}
		
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