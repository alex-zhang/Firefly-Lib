package com.fireflyLib.utils.coralPackFile
{
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	/**
	 * CoralPackFile Bytes Structure
	 *
	 * |------------------------------------------------------------------------
	 * | flag 'coral'          | version				   |
	 * | 4Bytes				   | 16bit + charBytes         |
	 * |
	 * | hasCompressed         |
	 * | 1Byte
	 * |
	 * | contentBytesLen  	   | contentBytes
	 * | 32bit            	   | bytes
	 * |
	 * | ----------------------------------------
	 * | fileCount
	 * | 16bit
	 * | 
	 * | fileBytesLength       | CoralPackFile(Bytes Structure)
	 * | 32bit                 | bytes
	 * |
	 * | ...
	 * |
	 * | ----------------------------------------
	 * |
	 * |------------------------------------------------------------------------
	 * 
	 * @author Alex Zhang
	 * 
	 */	 

	public class CoralPackFile
	{
		public static const FILE_FLAG:String = "coral";
		public static const VERSION:String = "0.0.1";
		
		private var mVersion:String = VERSION;
		private var mIsContentCompress:Boolean = false;
		
		private var mFileCount:int = 0;
		private var mFileFullNameMap:Array = [];
		
		private var mContentBytes:ByteArray;
		
		public function CoralPackFile()
		{
			super();
		}
		
		public final function get version():String { return mVersion; };

		public function get isCompress():Boolean { return mIsContentCompress; }
		public function set isCompress(value:Boolean):void { mIsContentCompress = value; }
		
		public function get fileCount():Boolean { return mFileCount; }
		
		public function hasFile(fileFullName:String):Boolean
		{
			return mFileFullNameMap[fileFullName] !== undefined;
		}
		
		public function getFile(fileFullName:String):CoralFile
		{
			return mFileFullNameMap[fileFullName];
		}
		
		public function getAllFiles(results:Vector.<CoralFile> = null):Vector.<CoralFile>
		{
			results ||= new Vector.<CoralFile>();
			for each(var file:CoralFile in mFileFullNameMap)
			{
				results.push(file);
			}
			return results;
		}
		
		public function getFilesByExtention(extention:String, results:Vector.<CoralFile> = null):Vector.<CoralFile>
		{
			results ||= new Vector.<CoralFile>();
			for each(var file:CoralFile in mFileFullNameMap)
			{
				if(file.extention == extention)
				{
					results.push(file);	
				}
			}

			return results;
		}
		
		public function getFilesByFilter(filterFunction:Function, results:Vector.<CoralFile> = null):Vector.<CoralFile>
		{
			results ||= new Vector.<CoralFile>();
			for each(var file:CoralFile in mFileFullNameMap)
			{
				if(filterFunction(file))
				{
					results.push(file);
				}
			}
			
			return results;
		}
		
		public function addFile(file:CoralFile):CoralFile
		{
			var fileFullName:String = file.fullName;
			
			if(hasFile(fileFullName)) return null;
			
			mFileFullNameMap[fileFullName] = file;
			mFileCount++;
			
			return file;
		}
		
		public function addFile2(fileFullName:String, fileBytes:ByteArray):CoralFile
		{
			if(hasFile(fileFullName)) return null;
			
			var coralFile:CoralFile = new CoralFile();
			coralFile.fullName = fileFullName;
			coralFile.contentBytes = fileBytes;
			
			return addFile(coralFile);
		}
		
		public function removeFile(fileFullName:String, dispose:Boolean = false):CoralFile
		{
			if(!hasFile(fileFullName)) return null;
			
			var file:CoralFile = mFileFullNameMap[fileFullName];
			if(dispose)
			{
				file.dispose();
			}
			
			delete mFileFullNameMap[fileFullName];
			mFileCount--;
			
			return file;
		}
		
		public function deserialize(input:ByteArray):void
		{
			input.position += FILE_FLAG.length;//ignore file flag.
			mVersion = input.readUTF();
			mIsContentCompress = input.readBoolean();
			
			mContentBytes = null;
			var contentBytesLen:uint = input.readUnsignedInt();
			if(contentBytesLen > 0)
			{
				mContentBytes = new ByteArray();
				input.readBytes(mContentBytes, 0, contentBytesLen);
				
				if(mIsContentCompress)
				{
					mContentBytes.uncompress(CompressionAlgorithm.LZMA);
				}
				
				mFileCount = mContentBytes.readShort();
				
				var fileBytesLen:uint = 0;
				var fileBytes:ByteArray;
				var file:CoralFile;
				
				for(var i:int = 0; i < mFileCount; i++)
				{
					fileBytesLen = mContentBytes.readUnsignedInt();
					fileBytes = new ByteArray();
					mContentBytes.readBytes(fileBytes, 0, fileBytesLen);
					
					file = new CoralFile();
					file.deserialize(fileBytes);
					
					addFile(file);
				}
			}
		}
		
		public function serialize(outPut:ByteArray):void
		{
			mContentBytes = null;
			
			if(mFileCount > 0)
			{
				mContentBytes = new ByteArray();
				mContentBytes.writeShort(mFileCount);
				
				var fileBytesLen:uint = 0;
				var fileBytes:ByteArray;
				for each(var file:CoralFile in mFileFullNameMap)
				{
					fileBytes = new ByteArray();
					file.serialize(fileBytes);

					fileBytesLen = fileBytes.length;
					mContentBytes.writeUnsignedInt(fileBytesLen);
					mContentBytes.writeBytes(fileBytes);
				}
				
				if(mIsContentCompress)
				{
					mContentBytes.compress(CompressionAlgorithm.LZMA);
				}
			}
			
			var contentBytesLen:uint = mContentBytes ? mContentBytes.length : 0;
			
			outPut.writeUTFBytes(FILE_FLAG);
			outPut.writeUTF(VERSION);
			outPut.writeBoolean(mIsContentCompress);
			outPut.writeUnsignedInt(contentBytesLen);
			
			if(contentBytesLen > 0)
			{
				outPut.writeBytes(mContentBytes);
			}
		}
		
		public function clear():void
		{
			if(mContentBytes)
			{
				mContentBytes.clear();
				mContentBytes = null;
			}

			mFileFullNameMap = [];
			mFileCount = 0;
		}
		
		public function dispose():void
		{
			if(mContentBytes)
			{
				mContentBytes.clear();
				mContentBytes = null;
			}
			
			if(mFileFullNameMap)
			{
				for each(var file:CoralFile in mFileFullNameMap)
				{
					file.dispose();
				}
				
				mFileFullNameMap = null;
				mFileCount = 0;
			}
		}
	}
}