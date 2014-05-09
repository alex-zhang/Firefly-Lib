package com.fireflyLib.utils
{
    public final class ArrayUtil
    {
        public static function toArray(obj:Object):Array
        {
            if (obj == null) return [];
            else if (obj is Array) return obj as Array;
            else return [ obj ];
        }

		public static function random(sourceArray:Array):Array
		{
			if(sourceArray == null) return null;
			
			var results:Array = sourceArray.concat();
			results.sort(
				function(a:*, b:*):Number
				{
					return int(MathUtil.randomFromValues([-1, 0, 1]));
				}
			);
			return results;
		}
    }
}
