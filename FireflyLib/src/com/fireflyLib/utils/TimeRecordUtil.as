package com.fireflyLib.utils
{
	import flash.utils.getTimer;

	public final class TimeRecordUtil
	{
		private static var mRecordedRunTimeMap:Array = [];//timeHandle -> []
		
		public static function recordCurrentRunTime(timeHandle:String):void
		{
			if(mRecordedRunTimeMap[timeHandle] == null)
			{
				mRecordedRunTimeMap[timeHandle] = [];
			}
			
			mRecordedRunTimeMap[timeHandle].push(getTimer());
		}
		
		public static function getRecordedRunTimeCount(timeHandle:String):uint
		{
			if(mRecordedRunTimeMap[timeHandle] != null)
			{
				return mRecordedRunTimeMap[timeHandle].length;
			}
			
			return 0;
		}
		
		public static function getRecordedRunTimeByIndex(timeHandle:String, index:int):int
		{
			if(mRecordedRunTimeMap[timeHandle] != null)
			{
				var n:uint = mRecordedRunTimeMap[timeHandle].length;

				if(n == 0) return 0;
				
				return int(mRecordedRunTimeMap[timeHandle][index]);
			}
			
			return 0;
		}
		
		public static function getRecordedTotalRunTime(timeHandle:String, isClearReacord:Boolean = true):int
		{
			if(mRecordedRunTimeMap[timeHandle] != null)
			{
				var time:int = 0;
				
				var n:uint = mRecordedRunTimeMap[timeHandle].length;
				if(n > 1)
				{
					time = mRecordedRunTimeMap[timeHandle][n - 1] - mRecordedRunTimeMap[timeHandle][0]; 
				}
				else if(n == 1)
				{
					time = getTimer() - mRecordedRunTimeMap[timeHandle][0];
				}
				
				if(isClearReacord)
				{
					clearRecordedRunTime(timeHandle);	
				}
				
				return time;
			}
			
			return 0;
		}
		
		private static function clearRecordedRunTime(timeHandle:String):void
		{
			if(mRecordedRunTimeMap[timeHandle] != null)
			{
				delete mRecordedRunTimeMap[timeHandle];
			}
		}
	}
}