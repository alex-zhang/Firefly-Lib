package src.com.fireflyLib.utils.coralPackFile
{
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;

	/**
	 * CoralPackFile Bytes Structure
	 *
	 * |------------------------------------------------------------------------
	 * | flag 'crf' 3Bytes         |
	 * 
	 * | version				   |
	 * | 16bit + charBytes
	 * 
	 * | fileFullName
	 * | 16bit + charBytes
	 * 
	 * | hasCompressed             | compression
	 * 	 1Byte                     | 16bit + charBytes
	 * 
	 * | contentBytesLen  		   | contentBytes
	 * | 32bit            		   | bytes
	 * |------------------------------------------------------------------------
	 * 
	 * @author zhangcheng
	 * 
	 */	 
	
	public class CoralFile
	{
		public static const FILE_FLAG:String = "crf";
		public static const VERSION:String = "1.0.0";
		
		private var mVersion:String = VERSION;

		private var mPureName:String;
		private var mFullName:String;
		private var mExtention:String;
		
		//deflate, lzma, zlib CompressionAlgorithm
		private var mContentCompression:String = null;

		internal var mContentBytes:ByteArray;
		
		public function CoralFile()
		{
			super();
		}
		
		public final function get version():String { return mVersion; };
		
		//here is full name
		public function get pureName():String { return mPureName; };
		public function get fullName():String { return mFullName };
		public function set fullName(value:String):void 
		{ 
			mFullName = value;
			updatePureNameAndExtentionByFullName();
		}
		
		private function updatePureNameAndExtentionByFullName():void
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
		
		public function get extention():String { return mExtention };
		
		public function get compression():String { return mContentCompression; };
		public function set compression(value:String):void 
		{
			if(value == null ||
				value == "" ||
				value == CompressionAlgorithm.DEFLATE ||
				value == CompressionAlgorithm.LZMA ||
				value == CompressionAlgorithm.ZLIB)
			{
				mContentCompression = value;
			}
			else
			{
				throw ArgumentError("compression: " + value);
			}
		}
		
		public function get contentBytes():ByteArray { return mContentBytes; };
		public function set contentBytes(value:ByteArray):void { mContentBytes = value; };
		
		public function deserialize(input:ByteArray):void
		{
			input.readUTFBytes(3);//->crf just ignore
			mVersion = input.readUTF();//version
			mFullName = input.readUTF();//fullName
			updatePureNameAndExtentionByFullName();
			
			var hasCompressed:Boolean = input.readBoolean();
			mContentCompression = hasCompressed ? input.readUTF() : null;
			
			var contentBytesLen:uint = input.readUnsignedInt();
			
			mContentBytes = new ByteArray();
			input.readBytes(mContentBytes, 0, contentBytesLen);

			if(hasCompressed)
			{
				mContentBytes.uncompress(mContentCompression);
			}
		}
		
		public function serialize(outPut:ByteArray):void
		{
			outPut.writeUTFBytes(FILE_FLAG);
			outPut.writeUTF(VERSION);
			outPut.writeUTF(mFullName);
			outPut.writeUTF(mExtention);
			
			if(mContentCompression == CompressionAlgorithm.DEFLATE ||
				mContentCompression == CompressionAlgorithm.LZMA ||
				mContentCompression == CompressionAlgorithm.ZLIB)
			{
				outPut.writeBoolean(true);
				outPut.writeUTF(mContentCompression);
				
				mContentBytes.compress(mContentCompression);
			}
			else
			{
				outPut.writeBoolean(false);
			}
			
			outPut.writeUnsignedInt(mContentBytes.length);
			outPut.writeBytes(mContentBytes);
		}
		
		public function dispose():void
		{
			mVersion = null;
			mFullName = null;
			mExtention = null;
			mPureName = null;
			mContentCompression = null;
			
			if(mContentBytes)
			{
				mContentBytes.clear();
				mContentBytes = null;
			}
		}
	}
}