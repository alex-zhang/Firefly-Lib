package com.fireflyLib.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * TypeUtility is a static class containing methods that aid in type
	 * introspection and reflection.
	 */
	public class TypeUtility
	{
		public static function getSimpleClassName(object:*):String
		{
			var name:String = getQualifiedClassName(object);

			var index:int = name.lastIndexOf("::");//lastindex is better here.
			if (index != -1)
			{
				return name.substr(index + 2);
			}
			
			return name;
		}
		
		public static function isBaiscType(object:*):Boolean
		{
			return (object is String ||
				object is Boolean ||
				object is Number ||
				object is int ||
				object is uint);
		}
		
		public static function isJsonObjectType(object:*):Boolean
		{
			if(!object) return null;
			
			//because the Object instance has no super class.
			return getQualifiedSuperclassName(object);
		}
		
		public static function isDynamicType(object:*):Boolean
		{
			//this way is more faster than use describeType.
			try
			{
				// this test for checking whether an object is dynamic or not is 
				// pretty hacky, but it assumes that no-one actually has a 
				// property defined called "wootHackwoot"
				object["__isDynamicType__"];
			}
			catch (e:Error)
			{
				// our object isn't from a dynamic class
				return false;
			}
			
			return true;
		}
		
		/**
		 * Gets the type of a field as a string for a specific field on an object.
		 * 
		 * @param object The object on which the field exists.
		 * @param field The name of the field whose type is being looked up.
		 * 
		 * @return The fully qualified name of the type of the specified field, or
		 * null if the field wasn't found.
		 */
//		public static function getFieldType(object:*, field:String):String
//		{
//			var typeXML:XML = getTypeDescription(object);
//			
//			// Look for a matching accessor.
//			for each(var property:XML in typeXML.child("accessor"))
//			{
//				if (property.attribute("name") == field)
//				{
//					return property.attribute("type");
//				}
//			}
//			
//			// Look for a matching variable.
//			for each(var variable:XML in typeXML.child("variable"))
//			{
//				if (variable.attribute("name") == field)
//				{
//					return variable.attribute("type");
//				}
//			}
//			
//			return null;
//		}
		
		/**
		 * Determine the type, specified by metadata, for a container class like an Array.
		 */
//		public static function getTypeHint(object:*, field:String):String
//		{
//			var description:XML = getTypeDescription(object);
//			if (!description)
//				return null;
//			
//			for each (var variable:XML in description.*)
//			{
//				// Skip if it's not the field we want.
//				if (variable.@name != field)
//					continue;
//				
//				// Only check variables/accessors.
//				if (variable.name() != "variable" && variable.name() != "accessor")
//					continue;
//				
//				// Scan for TypeHint metadata.
//				for each (var metadataXML:XML in variable.*)
//				{
//					if(metadataXML.@name == "TypeHint")
//					{
//						var value:String = metadataXML.arg.@value.toString();
//						
//						return value;
//						/*
//						if (value == "dynamic")
//						{
//						if (!isNaN(object[field]))
//						{
//						// Is a number...
//						return getQualifiedClassName(1.0);
//						}
//						else
//						{
//						return getQualifiedClassName(object[field]);
//						}
//						}
//						else
//						{
//						return value;
//						}
//						*/
//					}
//				}
//			}
//			
//			return null;
//		}
		
		/**
		 * Get the xml for the metadata of the field.
		 */
//		public static function getEditorData(object:*, field:String):XML
//		{
//			var description:XML = getTypeDescription(object);
//			if (!description)
//				return null;
//			
//			for each (var variable:XML in description.*)
//			{
//				// Skip if it's not the field we want.
//				if (variable.@name != field)
//					continue;
//				
//				// Only check variables/accessors.
//				if (variable.name() != "variable" && variable.name() != "accessor")
//					continue;
//				
//				// Scan for EditorData metadata.
//				for each (var metadataXML:XML in variable.*)
//				{
//					if (metadataXML.@name == "EditorData")
//						return metadataXML;
//				}
//			}
//			return null;
//		}
		
		/**
		 * Gets the xml description of an object's type through a call to the
		 * flash.utils.describeType method. Results are cached, so only the first
		 * call will impact performance.
		 * 
		 * @param object The object to describe.
		 * 
		 * @return The xml description of the object.
		 */
//		public static function getTypeDescription(object:*):XML
//		{
//			var className:String = getQualifiedClassName(object);
//			if (!_typeDescriptions[className])
//			{
//				_typeDescriptions[className] = describeType(object);
//			}
//			
//			return _typeDescriptions[className];
//		}
		
		/**
		 * Gets the xml description of a class through a call to the
		 * flash.utils.describeType method. Results are cached, so only the first
		 * call will impact performance.
		 * 
		 * @param className The name of the class to describe.
		 * 
		 * @return The xml description of the class.
		 */
//		public static function getClassDescription(className:String):XML
//		{
//			if (!_typeDescriptions[className])
//			{
//				try
//				{
//					_typeDescriptions[className] = describeType(getDefinitionByName(className));
//				}
//				catch (error:Error)
//				{
//					return null;
//				}
//			}
//			
//			return _typeDescriptions[className];
//		}
//		private static var _classes:Dictionary = new Dictionary();
//		private static var _typeDescriptions:Dictionary = new Dictionary();
//		private static var _instantiators:Dictionary = new Dictionary();
	}
}


