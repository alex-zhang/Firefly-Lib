package com.fireflyLib.utils
{
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;

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
		
		public static function isDestopPlayer():Boolean
		{
			//Air
			return Capabilities.playerType == "Desktop";
		}
		
		public static function isActivePlayer():Boolean
		{
			return Capabilities.playerType == "ActiveX"; 
		}
		
		public function isPlugInPlayer():Boolean
		{
			return Capabilities.playerType == "PlugIn";
		}
		
		public static function reportedDPI():Number
		{
			var serverString:String = unescape(Capabilities.serverString); 
			var reportedDpi:Number = Number(serverString.split("&DP=", 2)[1]);
			return reportedDpi;
		}
		
		private static var mAppVersion:String;
		public static function getAppVersion():String
		{
			if(mAppVersion) return mAppVersion;
			
			var nativeApplicationCls:Class = getDefinitionByName("flash.desktop::NativeApplication") as Class;
			
			var appDescriptor:XML = nativeApplicationCls.applicationDescriptor;
			var ns:Namespace = appDescriptor.namespace(); 
			
			mAppVersion = appDescriptor.ns::versionNumber;
			return mAppVersion;
		}
	}
}