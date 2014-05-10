package com.fireflyLib.utils
{
	public final class ObjectFactoryUtil
	{
		// constructor's type is String Type or Class or Function.
		public static function newInstance(cls:Class, 
										   properties:Object = null, 
										   constructorParams:Array = null, 
										   clsProperties:Object = null):*
		{
			if(!cls) return null;
			
			var f:Function;
			var p:String;
			
			if(clsProperties)
			{
				for(p in clsProperties)
				{
					if(p in cls)
					{
						if(cls[p] is Function)
						{
							f = cls[p];
							f.apply(null, clsProperties[p] as Array);//the value is the method's parms.
						}
						else
						{
							cls[p] = clsProperties[p];
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
				case 0: instance = new cls(); break;
				case 1: instance = new cls(constructorParams[0]); break;
				case 2: instance = new cls(constructorParams[0], 
					constructorParams[1]); break;
				case 3: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2]); break;
				case 4: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3]); break;
				case 5: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4]); break;
				case 6: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5]); break;
				case 7: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6]); break;
				case 8: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6],
					constructorParams[7]); break;
				case 9: instance = new cls(constructorParams[0], 
					constructorParams[1], 
					constructorParams[2],
					constructorParams[3],
					constructorParams[4],
					constructorParams[5],
					constructorParams[6],
					constructorParams[7],
					constructorParams[8]); break;
				case 10: instance = new cls(constructorParams[0], 
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
	}
}