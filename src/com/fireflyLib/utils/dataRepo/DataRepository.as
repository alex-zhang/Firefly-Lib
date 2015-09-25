package com.fireflyLib.utils.dataRepo
{
	import flash.utils.ByteArray;

	/**
	 * DataRepository Bytes Structure
	 *
	 * |------------------------------------------------------------------------
	 * | flag 'drp' 3Bytes
	 * 
	 * | version
	 * | 16bit + charBytes
	 * 
	 * | table count       |
	 * | 16bit             |
	 * 
	 * | tableName         | tableContentBytesLen | table Content Bytes |
	 * | 16bit + charBytes | 32bit                | bytes                    |
	 * 
	 * |------------------------------------------------------------------------
	 * 
	 * @author zhangcheng
	 * 
	 */	 
	
	public class DataRepository
	{
		public static const FILE_FLAG:String = "drp";
		public static const VERSION:String = "1.0.0";
		
		private var mVersion:String = VERSION;
		private var mTableImplClssesMap:Array = [];//tableName => TableClass
		private var mTablesMap:Array = [];//tableName ->[0, 1] TableInstance Bytes
		private var mTableCount:int = 0;
		
		public function DataRepository()
		{
			super();
		}
		
		public final function get version():String { return mVersion; }
		
		public function registTableImplClass(tableName:String, tableModelImplCls:Class = null, tableImplCls:Class = null):void
		{
			if(!mTableImplClssesMap[tableName])
			{
				mTableImplClssesMap[tableName] = [tableImplCls, tableModelImplCls];
			}
		}
		
		private function hasRegistTableImplClasses(tableName:String):Boolean
		{
			return mTableImplClssesMap[tableName] !== undefined;
		}
		
		public function deserialize(input:ByteArray):void
		{
			//the rawdata flag
			input.readUTFBytes(3);//->drp
			mVersion = input.readUTF();//version
			mTableCount = input.readUnsignedShort();
			
			var tableName:String;
			
			var tableContentBytesLen:uint = 0;
			var tableContentBytes:ByteArray = null;
			mTablesMap = [];
			
			for(var i:int = 0; i < mTableCount; i++)
			{
				//tableNameLen 16bit
				tableName = input.readUTF();
				
				tableContentBytesLen = input.readUnsignedInt();
				tableContentBytes = new ByteArray();
				input.readBytes(tableContentBytes, 0, tableContentBytesLen);
				
				mTablesMap[tableName] = [null, tableContentBytes];
			}
		}
		
		public function serialize(outPut:ByteArray):void
		{
			outPut.writeUTFBytes(FILE_FLAG);
			outPut.writeUTF(mVersion);//version
			outPut.writeShort(mTableCount);
			
			var table:DataTable = null
			var tableContentBytes:ByteArray = null;
			
			for(var tableName:String in mTablesMap)
			{
				outPut.writeUTF(tableName);
				
				table = mTablesMap[tableName][0];
				if(table)
				{
					tableContentBytes = new ByteArray();
					table.serialize(tableContentBytes)
				}
				else
				{
					tableContentBytes = mTablesMap[tableName][1];
				}
				
				outPut.writeUnsignedInt(tableContentBytes.length);
				outPut.writeBytes(tableContentBytes);
			}
		}
		
		public function createTable(tableName:String,
									table:DataTable):void
		{
			if(hasTable(tableName))
			{
				throw Error("DataRepository.createTable: " + tableName + "has exsit!");
			}

			mTablesMap[tableName] = [table, null];
			mTableCount++;
			
			onTableCreated(tableName, table);
		}
		
		public function createTable2(tableName:String,
									tableBytesData:ByteArray):void
		{
			if(hasTable(tableName))
			{
				throw Error("DataRepository.createTable: " + tableName + "has exsit!");
			}
			
			mTablesMap[tableName] = [null, tableBytesData];
			mTableCount++;
		}
		
		public function dropTable(tableName:String):void
		{
			if(!hasTable(tableName))
			{
				throw Error("DataRepository.dropTable: " + tableName + "not exsit!");
			}
			
			var tableData:Array = mTablesMap[tableName];
			
			delete mTablesMap[tableName];
			mTableCount--;
			
			var table:DataTable = tableData[0];
			if(table)
			{
				onTableDropped(table);
			}
			else if(tableData[1])
			{
				ByteArray(tableData[1]).clear();
			}
		}
		
		protected function onTableDropped(table:DataTable):void
		{
			table.dispose();
		}
		
		public function hasTable(tableName:String):Boolean
		{
			return mTablesMap[tableName] !== undefined;
		}
		
		public function findTable(tableName:String):DataTable
		{
			if(!hasTable(tableName)) return null;
			
			var tableData:Array = mTablesMap[tableName];
			if(tableData[1] != null)
			{
				var tableBytes:ByteArray = tableData[1];
				
				var tableImplCls:Class = null;
				var tableModelImplCls:Class = null;
				
				if(hasRegistTableImplClasses(tableName))
				{
					var tableImplClsses:Array = mTableImplClssesMap[tableName];
					
					tableImplCls = tableImplClsses[0] as Class;
					tableModelImplCls = tableImplClsses[1] as Class;
				}
				
				tableImplCls ||= DataTable;

				var table:DataTable = new tableImplCls(tableName, tableModelImplCls);
				
				onTableInerDeserialize(tableName, table, tableBytes);
				onTableCreated(tableName, table);
				
				tableBytes.clear();
				tableData[1] = null;

				tableData[0] = table;
			}

			return tableData[0] as DataTable;
		}
		
		protected function onTableInerDeserialize(tableName:String, table:DataTable, tableBytes:ByteArray):void
		{
			table.deserialize(tableBytes);
		}
		
		protected function onTableCreated(tableName:String, table:DataTable):void
		{
		}
		
		public function findAllTables():Array
		{
			var results:Array = [];
			
			for(var tableName:String in mTablesMap)
			{
				results.push(findTable(tableName));
			}
			
			return results;
		}
		
		public function getAllTableCount():uint
		{
			return mTableCount;
		}
		
		public function listAllTableNames():Array
		{
			var results:Array = [];
			
			for(var tableName:String in mTablesMap)
			{
				results.push(tableName);
			}
			
			return results;
		}
		
		public function dispose():void
		{
			for each(var tableData:Array in mTablesMap)
			{
				var table:DataTable = tableData[0];
				if(table)
				{
					onTableDropped(table);
				}
				else if(tableData[1])
				{
					ByteArray(tableData[1]).clear();
				}
			}
			
			mTablesMap = null;
			
			mTableImplClssesMap = null;
			mTableCount = 0;
		}
		
		public function toString():String 
		{
			var results:String = "version: " + mVersion + "\n" +
				"tableCount: " + mTableCount + "\n";
			
			var tableData:Array = null;
			var table:DataTable = null;
			for(var tableName:String in mTablesMap)
			{
				tableData = mTablesMap[tableName];
				if(tableData[0] != null)
				{
					table = tableData[0];
					results += table.toString() + "\n";
				}
				else 
				{
					var bytes:ByteArray = tableData[1];
					results += "tableName: " + tableName + 
						" bytes: " + Number(bytes.length / 1024).toFixed(2) + " k" + "\n";
				}
			}
			
			return results;
				
		}
	}
}