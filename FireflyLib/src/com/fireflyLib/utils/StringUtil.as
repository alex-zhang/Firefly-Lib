package com.fireflyLib.utils
{
    public final class StringUtil
    {
		/**
		 * Determine the file extension of a file. 
		 * @param file A path to a file.
		 * @return The file extension.
		 * 
		 */
		public static function getFileExtension(file:String):String
		{
			var extensionIndex:Number = file.lastIndexOf(".");
			if(extensionIndex == -1) 
			{
				//No extension
				return "";
			} 
			else 
			{
				return file.substr(extensionIndex + 1,file.length);
			}
		}
		
		/**
		 * Returns the first character of the string passed to it. 
		 */		
		public static function getFirstChar(str:String):String 
		{
			if (str.length == 1) 
			{
				return str;
			}
			
			return str.slice(0, 1);
		}
		
		/**
		 * Capitalize the first letter of a string 
		 * @param str String to capitalize the first leter of
		 * @return String with the first letter capitalized.
		 */		
		public static function capitalize(str:String):String
		{
			return str.substring(1, 0).toUpperCase() + str.substring(1);
		}
		
        public static function trimWhitespace(str:String):String
        {
            if(str == null) return "";
            
            var startIndex:int = 0;
            while (isWhitespace(str.charAt(startIndex)))
                ++startIndex;
            
            var endIndex:int = str.length - 1;
            while (isWhitespace(str.charAt(endIndex)))
                --endIndex;
            
            if (endIndex >= startIndex)
                return str.slice(startIndex, endIndex + 1);
            else
                return "";
        }
		
		public static function trimChar(str:String, char:String):String
		{
			if(str == null) return "";
			
			var startIndex:int = 0;
			while (str.charAt(startIndex) == char)
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while(str.charAt(endIndex) == char)
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}

		public static function trimChars(str:String, chars:Array):String
		{
			if(str == null) return "";
			if(!chars || chars.length == 0) return "";
			
			var startIndex:int = 0;
			while (chars.indexOf(str.charAt(startIndex)) != -1)
				++startIndex;
			
			var endIndex:int = str.length - 1;
			while(chars.indexOf(str.charAt(endIndex)) != -1)
				--endIndex;
			
			if (endIndex >= startIndex)
				return str.slice(startIndex, endIndex + 1);
			else
				return "";
		}
        
//        public static function trimArrayElements(value:String, delimiter:String):String
//        {
//            if (value != "" && value != null)
//            {
//                var items:Array = value.split(delimiter);
//                
//                var len:int = items.length;
//                for (var i:int = 0; i < len; i++)
//                {
//                    items[i] = StringUtil.trim(items[i]);
//                }
//                
//                if (len > 0)
//                {
//                    value = items.join(delimiter);
//                }
//            }
//            
//            return value;
//        }
		
        public static function isWhitespace(character:String):Boolean
        {
            switch (character)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    return true;
                    
                default:
                    return false;
            }
        }
		
		public static function toZeroFilledNumberChars(number:uint, formatDigit:uint):String
		{
			var numberChars:String = number.toString();
			var currentFormatDigit:int = numberChars.length;
			if(currentFormatDigit < formatDigit)
			{
				var zeroCount:int = formatDigit - currentFormatDigit;
				for(var i:int = 0; i < zeroCount; i++)
				{
					numberChars = "0" + numberChars;
				}
			}
			
			return numberChars;
		}
        
		// "AB{0}D{1}F{0}" + C,E => ABCDEFA
		// my name is {name}, my age is {age} + {name:zhang, age:24} => my name is zhang, my age is 24
        public static function substitute(str:String, ... rest):String
        {
            if (str == null) return "";
            
            var len:uint = rest.length;
			if(len > 0)
			{
				var i:uint = 0;
				var argsObj:Object = rest;
				
				if(len == 1)
				{
					if(rest[0] is String || !isNaN(rest[0]))
					{
						str = str.replace(new RegExp("\\{" + i + "\\}", "g"), rest[0].toString());
					}
					else if(rest[0] is Array)
					{
						argsObj = rest[0];
						len = argsObj.length;
						for (i = 0; i < len; i++)
						{
							str = str.replace(new RegExp("\\{" + i + "\\}", "g"), argsObj[i]);
						}
					}
					else
					{
						argsObj = rest[0];
						for(var key:String in argsObj)
						{
							str = str.replace(new RegExp("\\{"+key+"\\}", "g"), argsObj[key]);
						}
					}
				}
				else
				{
					for (i = 0; i < len; i++)
					{
						str = str.replace(new RegExp("\\{" + i + "\\}", "g"), argsObj[i]);
					}
				}
			}
			
            return str;
        }
		
        public static function repeat(str:String, n:int):String
        {
            if (n == 0) return "";
            
            var s:String = str;
            for (var i:int = 1; i < n; i++)
            {
                s += str;
            }
            return s;
        }
        
        public static function restrict(str:String, restrict:String):String
        {
            // A null 'restrict' string means all characters are allowed.
            if (restrict == null)
                return str;
            
            // An empty 'restrict' string means no characters are allowed.
            if (restrict == "")
                return "";
            
            // Otherwise, we need to test each character in 'str'
            // to determine whether the 'restrict' string allows it.
            var charCodes:Array = [];
            
            var n:int = str.length;
            for (var i:int = 0; i < n; i++)
            {
                var charCode:uint = str.charCodeAt(i);
                if (testCharacter(charCode, restrict))
                    charCodes.push(charCode);
            }
            
            return String.fromCharCode.apply(null, charCodes);
        }
        
        private static function testCharacter(charCode:uint, restrict:String):Boolean
        {
            var allowIt:Boolean = false;
            
            var inBackSlash:Boolean = false;
            var inRange:Boolean = false;
            var setFlag:Boolean = true;
            var lastCode:uint = 0;
            
            var n:int = restrict.length;
            var code:uint;
            
            if (n > 0)
            {
                code = restrict.charCodeAt(0);
                if (code == 94) // caret
                    allowIt = true;
            }
            
            for (var i:int = 0; i < n; i++)
            {
                code = restrict.charCodeAt(i)
                
                var acceptCode:Boolean = false;
                if (!inBackSlash)
                {
                    if (code == 45) // hyphen
                        inRange = true;
                    else if (code == 94) // caret
                        setFlag = !setFlag;
                    else if (code == 92) // backslash
                        inBackSlash = true;
                    else
                        acceptCode = true;
                }
                else
                {
                    acceptCode = true;
                    inBackSlash = false;
                }
                
                if (acceptCode)
                {
                    if (inRange)
                    {
                        if (lastCode <= charCode && charCode <= code)
                            allowIt = setFlag;
                        inRange = false;
                        lastCode = 0;
                    }
                    else
                    {
                        if (charCode == code)
                            allowIt = setFlag;
                        lastCode = code;
                    }
                }
            }
            
            return allowIt;
        }
		
		//key:value;key:name
		public static function decodeSimpleKeyValueStr(str:String, 
													   fstDelimiter:String = ";", 
													   secDelimiter:String = ":"):Object
		{
			var result:Object = {};
			
			var arr:Array = str.split(fstDelimiter);
			
			var itemStr:String = null;
			var itemArr:Array = null;
			
			for(var i:int = 0, n:int = arr ? arr.length : 0; i < n; i++)
			{
				itemStr = arr[i];
				
				itemArr = itemStr.split(secDelimiter);
				
				result[itemArr[0]] = itemArr[1];
			}
			
			return result;
		}
    }
}
