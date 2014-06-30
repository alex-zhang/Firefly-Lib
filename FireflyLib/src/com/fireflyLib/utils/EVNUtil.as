package com.fireflyLib.utils
{
	import flash.system.Capabilities;

	public final class EVNUtil
	{
		private static var mHasDetectOS:Boolean = false;
		
		private static var mIsMac:Boolean = false;
		public static function isMac():Boolean
		{
			if(!mHasDetectOS)
			{
				mIsMac = StringUtil.startWithChars(Capabilities.os, "Mac OS");
				mHasDetectOS = true;
			}
			
			return mIsMac;
		}
		
		private static var mIsWindows:Boolean = false;
		public static function isWindows():Boolean
		{
			if(!mHasDetectOS)
			{
				mIsWindows = StringUtil.startWithChars(Capabilities.os, "Windows");
				mHasDetectOS = true;
			}
			
			return mIsWindows;
		}
		
		private static var mIsLinux:Boolean = false;
		public static function isLinux():Boolean
		{
			if(!mHasDetectOS)
			{
				mIsLinux = StringUtil.startWithChars(Capabilities.os, "Linux");
				mHasDetectOS = true;
			}
			
			return mIsLinux;
		}
	}
}