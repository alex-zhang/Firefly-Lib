package com.fireflyLib.utils
{
	import flash.utils.getQualifiedClassName;

	public final class ObjectFactoryUtil
	{
		private static var _registedImpClslMap:Array = []//BaseClassORInterface - > ImlCls
		
		public static function registImplCls(typeCls:Class, implCls:Class):void
		{
			var typeClsStr:String = flash.utils.getQualifiedClassName(typeCls);
			
			if(!_registedImpClslMap[typeClsStr])
			{
				_registedImpClslMap[typeClsStr] = implCls;
			}
		}
		
		public static function getRegistedImplCls(typeCls:Class):Class
		{
			var typeClsStr:String = flash.utils.getQualifiedClassName(typeCls);
			
			return _registedImpClslMap[typeClsStr];
		}
		
		public static function createNewInstanceFromRegistedImplCls(typeCls:Class, 
																	properties:Object = null, 
																	constructorParameters:* = undefined):*
		{
			var implCls:Class = getRegistedImplCls(typeCls);
			
			if(!implCls) return null;
			
			var f:ClassFactory = new ClassFactory(implCls, properties, constructorParameters);
			
			return f.newInstance();
		}

		//--
		
		private static var _registedSingletonInstancelMap:Array = [];//BaseClassORInterface - > instance
		
		public static function registSingletonInstance(typeCls:Class, intance:*):*
		{
			var typeClsStr:String = flash.utils.getQualifiedClassName(typeCls);
			
			if(!_registedSingletonInstancelMap[typeClsStr])
			{
				_registedSingletonInstancelMap[typeClsStr] = intance;
				
				return intance;
			}
			
			throw new Error("ClassFactoryUtil::registSingletonInstance " + typeClsStr + "is Singleton Mode!!!");
		}
		
		public static function getSingletonIntance(typeCls:Class):*
		{
			var typeClsStr:String = flash.utils.getQualifiedClassName(typeCls);
			return _registedSingletonInstancelMap[typeClsStr];
		}
	}
}