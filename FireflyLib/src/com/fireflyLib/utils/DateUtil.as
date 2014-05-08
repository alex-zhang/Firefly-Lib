package com.fireflyLib.utils
{
	public final class DateUtil
	{
		public static const ONE_SECOND_MILLISECOND:uint = 1000;
		public static const ONE_MINNUTE_MILLISECOND:uint = ONE_SECOND_MILLISECOND * 60;
		public static const ONE_HOUR_MILLISECOND:uint = ONE_MINNUTE_MILLISECOND * 60;
		public static const ONE_DAY_MILLISECOND:uint = ONE_HOUR_MILLISECOND * 24;
		
		private static const _dateInstance:Date = new Date();
		
		public static function getMaxDateByYearMoth(year:uint, month:uint):uint
		{
			var dateValue:uint = 25;
			
			_dateInstance.fullYear = year;
			_dateInstance.month = month;
			_dateInstance.date = dateValue;
			
			while(true)
			{
				dateValue += 1;

				_dateInstance.date = dateValue;

				if(_dateInstance.month != month)
				{
					dateValue -= 1;
					break;
				}
			}
			
			return dateValue;
		}
		
		//获取某年某月的第一天是星期几0-6
		public static function getFirstDateDayByYearMoth(year:uint, month:uint):uint
		{
			_dateInstance.fullYear = year;
			_dateInstance.month = month;
			_dateInstance.date = 1;
			
			return _dateInstance.day;
		}
		
		public static function cloneDate(date:Date):Date
		{
			if(date == null) return null;
			
			var d:Date = new Date();
			d.time = date.time;
			
			return d;
		}
		
		//d(day):0, h(hour):0, m(minute):0,s(second):0,ms(millisecond):0 
		public static function calculateTimeByMillisecond(ms:Number, results:Object = null):Object
		{
			var quotient:uint;//商
			var modulo:Number;//余数
			
			var day:uint = ms / ONE_DAY_MILLISECOND;
			ms %= ONE_DAY_MILLISECOND;
			
			var hour:uint = ms / ONE_HOUR_MILLISECOND;
			ms %= ONE_HOUR_MILLISECOND;
			
			var minute:uint = ms / ONE_MINNUTE_MILLISECOND;
			ms %=  ONE_MINNUTE_MILLISECOND;
			
			var second:uint = ms / ONE_SECOND_MILLISECOND;
			var millisecond:uint = ms % ONE_SECOND_MILLISECOND;
			
			results ||= {};
			
			results.d = day;
			results.h = hour;
			results.m = minute;
			results.s = second;
			results.ms = millisecond;
			return results;
		}
	}
}