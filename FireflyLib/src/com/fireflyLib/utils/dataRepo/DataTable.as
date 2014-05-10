package com.fireflyLib.utils.dataRepo
{
	import flash.utils.ByteArray;

	/**
	 * Table Bytes Structure
	 * 
	 * |------------------------------------------------------------------------
	 * | fields count      | table row count  |
	 * | 16bit             | 16bit            |
	 * |------------------------------------------------------------------------
 	 * | fieldsNameLen     | fieldsName       | ........... | ........... 
	 * | 16bit             | CharsBytes       | ........... | ...........
	 * |------------------------------------------------------------------------
	 * | rowFieldsBytesLen | rowFieldValueLen | rowFieldValue   | ........... | ...........
	 * | 32bit 			   | 16bit            | CharsBytes      | ........... | ...........
	 * | ................. | ................ | ........... | ...........
	 * | ................. | ................ | ........... | ...........
	 * | ................. | ................ | ........... | ...........
	 * | ................. | ................ | ........... | ...........
	 * | ................. | ................ | ........... | ...........
	 * | ................. | ................ | ........... | ...........
	 * |------------------------------------------------------------------------
	 * 
	 * @author Alex Zhang
	 * 
	 */	
	public class DataTable
	{
		private var mTableName:String;
		private var mModelCls:Class;

		private var mFieldsCount:int = 0;
		private var mFieldsNames:Array = null;
		
		private var mRowCount:int = 0;
		private var mModesMap:Array = [];//key ->[0, 1]0->instance(mModelCls) 1->Bytes
		
		private var mKeyFieldName:String;
		
		private var mIsSimpleObject:Boolean = false;
		
		public function DataTable(tableName:String, modelCls:Class = null)
		{
			mTableName = tableName;
			mModelCls = modelCls;
			
			if(!mModelCls)
			{
				mModelCls = Object;
				mIsSimpleObject = true;
			}
		}
		
		public function deserialize(input:ByteArray):void
		{
			mFieldsNames = [];
			mModesMap = [];
			
			mFieldsCount = input.readUnsignedShort();
			mRowCount = input.readUnsignedShort();
			
			//common
			var colIndex:int = 0;
			var rowIndex:int = 0;
			var offset:uint = 0;
			
			//fields
			var fieldName:String = null;
			for(colIndex = 0; colIndex < mFieldsCount; colIndex++)
			{
				fieldName = input.readUTF();
				mFieldsNames.push(fieldName);
				
				if(colIndex == 0)
				{
					mKeyFieldName = fieldName;
				}
			}
			//rows
			var rowModelKeyLen:uint = 0;
			var rowModelKey:String = null;
			
			var rowModelBytesLen:uint = 0;
			var rowModelBytes:ByteArray = null;
			
			for(rowIndex = 0; rowIndex < mRowCount; rowIndex++)
			{
				rowModelBytesLen = input.readUnsignedInt();
				offset = input.position;
				rowModelKey = input.readUTF();
				offset = input.position - offset;
				rowModelBytesLen = rowModelBytesLen - offset;
				
				rowModelBytes = new ByteArray();
				input.readBytes(rowModelBytes, 0, rowModelBytesLen);
				mModesMap[rowModelKey] = [null, rowModelBytes];
			}
		}
		
		public function serialize(output:ByteArray):void
		{
			output.writeShort(mFieldsCount);
			output.writeShort(mRowCount);
			
			//common
			var colIndex:int = 0;
			var rowIndex:int = 0;
			
			var fieldNameLen:uint = 0;
			var fieldName:String = null;
			for(colIndex = 0; colIndex < mFieldsCount; colIndex++)
			{
				fieldName = mFieldsNames[colIndex] || "";
				
				output.writeUTF(fieldName);
			}
			
			var model:Object = null;
			var modelBytes:ByteArray = null;
			
			for(var rowKey:String in mModesMap)
			{
				model = mModesMap[rowKey][0];
				if(model)
				{
					modelBytes = new ByteArray();
					
					var modelValue:String;
					var modelValueLen:int = 0;
					
					for(colIndex = 0; colIndex < mFieldsCount; colIndex++)
					{
						fieldName = mFieldsNames[colIndex];
						modelValue = model[fieldName] || "";
						
						modelBytes.writeUTF(modelValue);
					}
				}
				else
				{
					modelBytes = mModesMap[rowKey][1];
				}
				
				output.writeUnsignedInt(modelBytes.length);
				output.writeBytes(modelBytes);
			}
		}
		
		public function get tableName():String
		{
			return mTableName;
		}
		
		public function get fieldNames():Array
		{
			return mFieldsNames.concat();
		}
		
		public function set fieldNames(value:Array):void
		{
			mFieldsNames = value;
			mKeyFieldName = mFieldsNames[0];
			mFieldsCount = mFieldsNames.length;
		}
		
		public function get fieldsCount():int
		{
			return mFieldsCount;
		}
		
		public function getFieldNameAt(index:int):String
		{
			return mFieldsNames[index];
		}
		
		public function get keyFieldName():String
		{
			return mKeyFieldName;
		}
		
		public function hasRow(key:String):Boolean
		{
			return mModesMap[key] !== undefined;
		}
		
		public function create(key:String, fieldsAndVaues:Object):void
		{
			if(!key || key == "") 
			{
				throw Error("TableBasic.create: name: " + mTableName + "key: " + key + " is emty key!");
			}
			
			if(hasRow(key))
			{
				throw Error("TableBasic.create: name: " + mTableName + "key: " + key + " has exsit!");
			}

			var model:Object = new mModelCls();
			mModesMap[key] = [model, null];
			mRowCount++;
			
			onRowModeCreated(model, key, fieldsAndVaues);
		}
		
		protected function onRowModeCreated(model:Object, key:String, fieldsAndVaues:Object):void
		{
			updateRowModeValue(key, model, fieldsAndVaues, true);
		}
		
		public function find(key:String):Object
		{
			if(!hasRow(key)) return undefined;
			
			var rowData:Array = mModesMap[key];
			if(rowData[1] != null)
			{
				var rowModelBytes:ByteArray = rowData[1];
				var model:Object = new mModelCls();
				
				onRowInerDeserialize(key, model, rowModelBytes);

				rowModelBytes.clear();
				rowData[1] = null;
				rowData[0] = model

				return model;
			}
			
			return rowData[0];
		}
		
		protected function onRowInerDeserialize(key:String, model:Object, rowModelBytes:ByteArray):void
		{
			var rowFieldName:String;
			var rowFieldValues:String;
			
			var fieldsAndVaues:Object = {};
			
			for(var colIndex:int = 1; colIndex < mFieldsCount; colIndex++)
			{
				rowFieldValues = rowModelBytes.readUTF();

				rowFieldName = mFieldsNames[colIndex];
				
				fieldsAndVaues[rowFieldName] = rowFieldValues;
			}
			
			updateRowModeValue(key, model, fieldsAndVaues, true);
		}
		
		public function findAll():Array
		{
			var results:Array = [];
			
			for(var key:String in mModesMap)
			{
				results.push(find(key));
			}
			
			return results;
		}
		
		public function count():int
		{
			return mRowCount;
		}
		
		public function update(key:String, fieldsAndVaues:Object):void
		{
			if(!hasRow(key))
			{
				throw Error("TableBasic.del: " + key + "not exsit!");
			}
			
			onRowModeUpdated(key, find(key), fieldsAndVaues);
		}
		
		protected function onRowModeUpdated(key:String, model:Object, fieldsAndVaues:Object):void
		{
			updateRowModeValue(key, model, fieldsAndVaues, false);
		}
		
		protected function updateRowModeValue(key:String, model:Object, fieldsAndVaues:Object, isSetKey:Boolean):void
		{
			for(var field:String in fieldsAndVaues)
			{
				if(field != key && (mIsSimpleObject || field in model))
				{
					model[field] = fieldsAndVaues[field];
				}
			}
			
			if(isSetKey)
			{
				model[mKeyFieldName] = key;
			}
		}
		
		public function del(key:String):void
		{
			if(!hasRow(key))
			{
				throw Error("TableBasic.del: " + key + "not exsit!");
			}
			
			var model:Object = find(key);
			
			delete mModesMap[key];
			mRowCount--;
			
			onRowModeDeleted(key, model);
		}
		
		protected function onRowModeDeleted(key:String, model:Object):void
		{
		}

		public function dispose():void
		{
			mFieldsNames = null;
			mModesMap = null;
			mModelCls = null;
		}
		
		public function toString():String
		{
			var results:String = "tableName " + mTableName + "\n" +
				"fieldsCount " + mFieldsCount + "\n" +
				mFieldsNames ? "fieldsNames " + mFieldsNames.join(" ") + "\n" : "" +
				"rowCount " + mRowCount;
				
			return results;
		}
	}
}