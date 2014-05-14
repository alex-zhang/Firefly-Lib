package com.fireflyLib.utils
{
	public class ClassFactory implements IFactory
	{
		public var cotor:Class = null;
		public var cotorParams:Array = null;
		public var props:Object = null;
		
		public function ClassFactory()
		{
			super();
		}
		
		public function newInstance():*
		{
			return ObjectFactoryUtil.create(cotor, props, cotorParams);
		}
	}
}
