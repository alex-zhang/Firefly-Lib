package com.fireflyLib.utils
{
	public final class ClassFactory implements IFactory
	{
		public static function classInstance(constructor:Class, constructorParameters:Array = null):*
		{
			//In Actionscript ,there is no way to call constructor by arguments like the Function.apply
			//so no suggest pass the value from constructor. so here the constructor is only support one parameter.
			var instance:* = null;
			var constructorParametersLen:int = constructorParameters ? constructorParameters.length : 0;
			switch(constructorParametersLen)
			{
				case 0: instance = new constructor(); break;
				case 1: instance = new constructor(constructorParameters[0]); break;
				case 2: instance = new constructor(constructorParameters[0], 
					constructorParameters[1]); break;
				case 3: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2]); break;
				case 4: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2],
					constructorParameters[3]); break;
				case 5: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2],
					constructorParameters[3],
					constructorParameters[4]); break;
				case 6: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2],
					constructorParameters[3],
					constructorParameters[4],
					constructorParameters[5]); break;
				case 7: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2],
					constructorParameters[3],
					constructorParameters[4],
					constructorParameters[5],
					constructorParameters[6]); break;
				case 8: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2],
					constructorParameters[3],
					constructorParameters[4],
					constructorParameters[5],
					constructorParameters[6],
					constructorParameters[7]); break;
				case 9: instance = new constructor(constructorParameters[0], 
					constructorParameters[1], 
					constructorParameters[2],
					constructorParameters[3],
					constructorParameters[4],
					constructorParameters[5],
					constructorParameters[6],
					constructorParameters[7],
					constructorParameters[8]); break;
				
				default:
					throw new RangeError("constructorParameters length is no long!");
					break;
				
				/* we only support the count of constructor pameraters count to 9, 
				i think it's enough. other wise you'd better refactor your code. */
			}
			
			return instance;
		}
		
		public var constructor:Class;
		public var constructorParameters:Array;
		public var properties:Object;
		
		public function ClassFactory(constructor:Class, 
									 properties:Object = null, 
									 constructorParameters:Array = null)
		{
			super();
			
			this.constructor = constructor;
			this.constructorParameters = constructorParameters;
			this.properties = properties;
		}

		public function newInstance():*
		{
			var instance:* = classInstance(constructor, constructorParameters);
			
			if (properties != null)
			{
				for (var p:String in properties)
				{
					if(p in instance)
					{
//						trace(properties[p], instance[p]);
						if(instance[p] is Function)
						{
							var f:Function = instance[p];
							f.apply(instance, properties[p]);
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
	}
}
