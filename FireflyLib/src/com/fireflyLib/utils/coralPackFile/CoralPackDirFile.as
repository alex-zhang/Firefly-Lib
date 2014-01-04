package com.fireflyLib.utils.coralPackFile
{
	import flash.utils.ByteArray;

	/**
	 * CoralPackDirFile Content Bytes Structure
	 *
	 * | fileCount
	 *   16bit
	 * 
	 * | fileBytesLength  | CoralPackFile(Bytes Structure)
	 * | 32bit            | bytes
	 * 
	 * ...
	 * 
	 * @author zhangcheng
	 * 
	 */	
	
	public class CoralPackDirFile extends CoralPackFile
	{
		private var mFileCount:int = 0;
		private var mFileFullNameMap:Array = [];
		
		public function CoralPackDirFile()
		{
			super();
		}
		
		//dead end
		override public function get contentBytes():ByteArray 
		{ 
			throw new Error("u can not call this api again. in CoralPackDirFile"); 
		}
		
		override public function set contentBytes(value:ByteArray):void 
		{ 
			throw new Error("u can not call this api again. in CoralPackDirFile"); 
		}
		
		public function hasFile(fileFullName:String):Boolean
		{
			return mFileFullNameMap[fileFullName] !== undefined;
		}
		
		public function getFile(fileFullName:String):CoralPackFile
		{
			return mFileFullNameMap[fileFullName];
		}
		
		public function getFiles(fileName:String, results:Vector.<CoralPackFile> = null):Vector.<CoralPackFile>
		{
			results ||= new Vector.<CoralPackFile>();
			for each(var file:CoralPackFile in mFileFullNameMap)
			{
				if(file.name == fileName)
				{
					results.push(file);
				}
			}
			
			return results;
		}
		
		public function getFilesByPrefix(filePrefixName:String, results:Vector.<CoralPackFile> = null):Vector.<CoralPackFile>
		{
			results ||= new Vector.<CoralPackFile>();
			for each(var file:CoralPackFile in mFileFullNameMap)
			{
				if(file.name.indexOf(filePrefixName) == 0)
				{
					results.push(file);
				}
			}
			
			return results;
		}
		
		public function getAllFiles(results:Vector.<CoralPackFile> = null):Vector.<CoralPackFile>
		{
			results ||= new Vector.<CoralPackFile>();
			for each(var file:CoralPackFile in mFileFullNameMap)
			{
				results.push(file);
			}
			return results;
		}
		
		public function addFile(file:CoralPackFile):CoralPackFile
		{
			var fullName:String = file.name;
			
			if(hasFile(fullName)) return null;
			
			mFileFullNameMap[fullName] = file;
			mFileCount++;
			
			return file;
		}
		
		public function removeFile(fileFullName:String):CoralPackFile
		{
			if(!hasFile(fileFullName)) return null;
			
			var file:CoralPackFile = mFileFullNameMap[fileFullName];
			
			delete mFileFullNameMap[fileFullName];
			mFileCount--;
			
			return file;
		}
		
		public function removeAllFiles():void
		{
			mFileFullNameMap = [];
			mFileCount = 0;
		}
		
		override public function deserialize(input:ByteArray):void
		{
			super.deserialize(input);
			
			mFileCount = mContentBytes.readShort();
			
			var fileBytesLen:uint = 0;
			var fileBytes:ByteArray;
			var file:CoralPackFile;
			
			for(var i:int = 0; i < mFileCount; i++)
			{
				fileBytesLen = mContentBytes.readUnsignedInt();
				fileBytes = new ByteArray();
				mContentBytes.readBytes(fileBytes, 0, fileBytesLen);
				
				file = new CoralPackFile();
				file.deserialize(fileBytes);
				
				mFileFullNameMap[file.name] = file;
			}
		}
		
		override public function serialize(outPut:ByteArray):void
		{
			mContentBytes = new ByteArray();
			mContentBytes.writeShort(mFileCount);
			
			var fileBytesLen:uint = 0;
			var fileBytes:ByteArray;
			for each(var file:CoralPackFile in mFileFullNameMap)
			{
				fileBytes = new ByteArray();
				file.serialize(fileBytes);
				
				fileBytesLen = fileBytes.length;
				mContentBytes.writeUnsignedInt(fileBytesLen);
				mContentBytes.writeBytes(fileBytes);
			}
			
			super.serialize(outPut);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mFileFullNameMap)
			{
				for each(var file:CoralPackFile in mFileFullNameMap)
				{
					file.dispose();
				}
				
				mFileFullNameMap = null;
			}
			
			mFileCount = 0;
		}
	}
}