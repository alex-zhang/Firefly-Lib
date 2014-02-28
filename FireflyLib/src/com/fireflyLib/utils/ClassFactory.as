package com.fireflyLib.utils
{
	public final class ClassFactory implements IFactory
	{
		public var constructor:* = undefined;//String or Class
		public var constructorParams:Array = null;
		public var properties:Object = null;
		
		public function ClassFactory()
		{
			super();
		}
		
		public function newInstance():*
		{
			return ObjectFactoryUtil.newInstance(constructor, properties, constructorParams);
		}
	}
}
