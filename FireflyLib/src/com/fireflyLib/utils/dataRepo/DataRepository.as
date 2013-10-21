package com.fireflyLib.utils.dataRepo
{
	import flash.utils.ByteArray;

	/**
	 * DataRepository Bytes Structure
	 *
	 * |------------------------------------------------------------------------
	 * | table count       |
	 * | 16bit             |
	 * | tableNameLen      | tableName | tableContentBytesLen | table Content Bytes |
	 * | 16bit             | charBytes | 32bit                |                     |
	 * |------------------------------------------------------------------------
	 * 
	 * @author zhangcheng
	 * 
	 */	 
	
	public class DataRepository
	{
		private var mTableImplClssesMap:Array = [];//tableName => TableClass
		private var mTablesMap:Array = [];//tableName ->[0, 1] TableInstance Bytes
		private var mTableCount:int = 0;
		
		public function DataRepository()
		{
			super();
		}
		
		public function registTableImplClass(tableName:String, tableImplCls:Class, tableModelImplCls:Class = null):void
		{
			if(!mTableImplClssesMap[tableName])
			{
				mTableImplClssesMap[tableName] = [tableImplCls, tableModelImplCls];
			}
		}
		
		private function hasRegistTableImplClasses(tableName):Boolean
		{
			return mTableImplClssesMap[tableName] !== undefined;
		}
		
		public function deserialize(input:ByteArray):void
		{
			mTablesMap = [];
			
			//defaunlt
			mTableCount = input.readUnsignedShort();
			
			var tableName:String;
			
			var tableContentBytesLen:uint = 0;
			var tableContentBytes:ByteArray = null;

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
			outPut.writeShort(mTableCount);
			
			var table:TableBasic = null
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
									table:TableBasic):void
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
			
			var table:TableBasic = tableData[0];
			if(table)
			{
				onTableDropped(table);
			}
			else if(tableData[1])
			{
				ByteArray(tableData[1]).clear();
			}
		}
		
		protected function onTableDropped(table:TableBasic):void
		{
			table.dispose();
		}
		
		public function hasTable(tableName:String):Boolean
		{
			return mTablesMap[tableName] !== undefined;
		}
		
		public function findTable(tableName:String):TableBasic
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
				
				tableImplCls ||= TableBasic;

				var table:TableBasic = new tableImplCls(tableModelImplCls);
				
				onTableInerDeserialize(tableName, table, tableBytes);
				onTableCreated(tableName, table);
				
				tableBytes.clear();
				tableData[1] = null;

				tableData[0] = table;
			}

			return tableData[0] as TableBasic;
		}
		
		protected function onTableInerDeserialize(tableName:String, table:TableBasic, tableBytes:ByteArray):void
		{
			table.deserialize(tableBytes);
		}
		
		protected function onTableCreated(tableName:String, table:TableBasic):void
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
				var table:TableBasic = tableData[0];
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
	}
}