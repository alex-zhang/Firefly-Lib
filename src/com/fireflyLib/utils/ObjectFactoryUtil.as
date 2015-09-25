package com.fireflyLib.utils
{
	public final class ObjectFactoryUtil
	{
		// constructor's type is String Type or Class or Function.
		public static function create(clsType:Class, 
										   props:Object = null,
										   ctorParams:Object = null,//Object Or Array
										   clsProps:Object = null):*
		{
			if(!clsType) return null;

			var f:Function;
			var p:String;

			if(clsProps)
			{
				for(p in clsProps)
				{
					if(p in clsType)
					{
						if(clsType[p] is Function)
						{
							f = clsType[p];
							f.apply(null, clsProps[p] as Array);//the value is the method's parms.
						}
						else
						{
							clsType[p] = clsProps[p];
						}
					}
				}
			}
			
			//In Actionscript ,there is no way to call constructor by arguments like the Function.apply
			//so no suggest pass the value from constructor. so here the constructor is only support one parameter.
			var instance:* = null;
			
			var ctorParamsLen:int = 0;
			if(ctorParams)
			{
				if(!(ctorParams is Array))
				{
					ctorParams = [ctorParams];
				}

				ctorParamsLen = ctorParams.length;
			}

			switch(ctorParamsLen)
			{
				case 0: instance = new clsType(); break;
				case 1: instance = new clsType(ctorParams[0]); break;
				case 2: instance = new clsType(ctorParams[0], 
					ctorParams[1]); break;
				case 3: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2]); break;
				case 4: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3]); break;
				case 5: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3],
					ctorParams[4]); break;
				case 6: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3],
					ctorParams[4],
					ctorParams[5]); break;
				case 7: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3],
					ctorParams[4],
					ctorParams[5],
					ctorParams[6]); break;
				case 8: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3],
					ctorParams[4],
					ctorParams[5],
					ctorParams[6],
					ctorParams[7]); break;
				case 9: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3],
					ctorParams[4],
					ctorParams[5],
					ctorParams[6],
					ctorParams[7],
					ctorParams[8]); break;
				case 10: instance = new clsType(ctorParams[0], 
					ctorParams[1], 
					ctorParams[2],
					ctorParams[3],
					ctorParams[4],
					ctorParams[5],
					ctorParams[6],
					ctorParams[7],
					ctorParams[8],
					ctorParams[9]); break;
				case 11: instance = new clsType(ctorParams[0],
						ctorParams[1],
						ctorParams[2],
						ctorParams[3],
						ctorParams[4],
						ctorParams[5],
						ctorParams[6],
						ctorParams[7],
						ctorParams[8],
						ctorParams[9],
						ctorParams[10]); break;
				
				default:
					throw new RangeError("ctorParams length is too long!");
					break;
				
				/* we only support the count of constructor pameraters count to 11, 
				i think it's totally enough. other wise you'd better refactor your code instead. */
			}

			if(props)
			{
				for(p in props)
				{
					if(p in instance)
					{
						if(instance[p] is Function)
						{
							f = instance[p];
							f.apply(instance, props[p] as Array);//the value is the method's parms.
						}
						else
						{
							instance[p] = props[p];
						}
					}
				}
			}
			
			return instance;
		}
	}
}