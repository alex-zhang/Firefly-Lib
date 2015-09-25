package com.fireflyLib.utils.coralPackFile
{
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	/**
	 * CoralFile Bytes Structure
	 *
	 * |------------------------------------------------------------------------
	 * |
	 * | fileFullName
	 * | 16bit + charBytes
	 * |
	 * | contentBytesLen  		   | contentBytes
	 * | 32bit            		   | bytes
	 * |------------------------------------------------------------------------
	 * 
	 * @author Alex Zhang
	 * 
	 */
	
	public class CoralFile
	{
		private var mPureName:String;
		private var mFullName:String;
		private var mExtention:String;
		private var mContentBytes:ByteArray;
		
		public function CoralFile()
		{
			super();
		}
		
		//here is full name
		public function get pureName():String { return mPureName || "" };
		public function get extention():String { return mExtention || "" };
		
		public function get fullName():String { return mFullName || ""};
		public function set fullName(value:String):void 
		{
			if(mFullName != value)
			{
				mFullName = value;
				updatePureNameAndExtentionByFullName();	
			}
		}
		
		private function updatePureNameAndExtentionByFullName():void
		{
			if(mFullName && mFullName.length > 0)
			{
				var indexOfDot:int = mFullName.lastIndexOf(".");
				if(indexOfDot != -1)
				{
					mPureName = mFullName.slice(0, indexOfDot);
					mExtention = mFullName.substr(indexOfDot + 1);
				}
				else
				{
					mPureName = mFullName;
					mExtention = "";
				}
			}
		}
		
		public function get contentBytes():ByteArray { return mContentBytes; };
		public function set contentBytes(value:ByteArray):void { mContentBytes = value; };
		
		public function deserialize(input:ByteArray):void
		{
			mFullName = input.readUTF();
			updatePureNameAndExtentionByFullName();
			
			mContentBytes = null;
			var mContentBytesLen:uint = input.readUnsignedInt();
			if(mContentBytesLen > 0)
			{
				mContentBytes = new ByteArray();
				input.readBytes(mContentBytes, 0, mContentBytesLen);
			}
		}

		public function serialize(output:ByteArray):void
		{
			output.writeUTF(this.fullName);
			var contentBytesLen:uint = mContentBytes ? mContentBytes.length : 0;
			output.writeUnsignedInt(contentBytesLen);
			if(contentBytesLen > 0)
			{
				output.writeBytes(mContentBytes);
			}
		}
		
		public function getContentIsCoralPackFile():Boolean
		{
			if(!mContentBytes) return false;
			if(mContentBytes.length < CoralPackFile.FILE_FLAG.length) return false;
			
			var lastPosition:uint = mContentBytes.position;
			mContentBytes.position = 0;
			var fileFlag:String = mContentBytes.readUTFBytes(CoralPackFile.FILE_FLAG.length);
			mContentBytes.position = lastPosition;
			if(fileFlag == CoralPackFile.FILE_FLAG)
			{
				return true;
			}
			
			return false;
		}
		
		public function getContentCoralPackFile():CoralPackFile
		{
			if(getContentIsCoralPackFile())
			{
				var coralPackFile:CoralPackFile = new CoralPackFile();
				coralPackFile.deserialize(mContentBytes);
				return coralPackFile;
			}
			
			return null;
		}
		
		public function dispose():void
		{
			mFullName = null;
			mExtention = null;
			mPureName = null;
			
			if(mContentBytes)
			{
				mContentBytes.clear();
				mContentBytes = null;
			}
		}
	}
}