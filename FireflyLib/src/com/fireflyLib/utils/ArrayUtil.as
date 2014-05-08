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
			results.sort(__randomSortMethod);
			return results;
		}
		
		private static const __randomSortRetureValues:Vector.<int> = Vector.<int>([-1, 0, 1]);
		private static function __randomSortMethod():Number
		{
			return __randomSortMethod[int(Math.random() * 3)]; 
		}
    }
}
