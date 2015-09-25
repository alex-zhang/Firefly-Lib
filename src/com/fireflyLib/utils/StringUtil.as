package com.fireflyLib.utils
{
    public final class StringUtil
    {
        /**
         * fill the str with char.
         */
        public static function fillString(str:String, length:int, fillChar:String = " "):String
        {
            if(!fillChar || fillChar.length == 0)
            {
                fillChar = " ";
            }
            else if(fillChar.length > 1)
            {
                fillChar = fillChar.charAt(0);
            }

            if(str.length > length)
            {
                str = str.substring(0, length);
            }
            else
            {
                while(str.length < length)
                {
                    str += fillChar;
                }
            }

            return str;
        }


        /**
         * <p>Checks if a String is email pattern.</p>
         *
         * <pre>
         * StringUtils.isEmailFormat("jacky@gmail.com")       = true
         * StringUtils.isEmailFormat("jacky.com")             = false
         * StringUtils.isEmailFormat("jacky.com")             = false
         * StringUtils.isEmailFormat("@jacky.com")            = false
         * </pre>
         *
         * @param str  the String to check, may be null
         * @return <code>true</code> if the String is not empty and not null
         */
        public static function isEmailFormat(str:String):Boolean
        {
            var emailExp:RegExp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/i;
            return emailExp.test(str);
        }

        /**
         * <p>Checks if a String is a valid phone number(including mobile number).</p>
         *
         * @param str  the String to check, may be null
         * @return <code>true</code> if the String is not empty and not null
         */
        public static function isPhoneNumberFormat(str:String):Boolean{
            //see http://www.cnblogs.com/xyzhuzhou/archive/2012/05/08/2490388.html
            var mobileExp:RegExp = /^0?(13[0-9]|15[012356789]|18[0236789]|14[57])[0-9]{8}$/
            return mobileExp.test( str );
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
		
		public static function startWithChars(str:String, chars:String):Boolean
		{
			if(!str) return false;
			
			return str.indexOf(chars) == 0;
		}
		
		public static function endWithChars(str:String, chars:String):Boolean
		{
			if(!str) return false;
			
			return str.lastIndexOf(chars) == str.length - 1;
		}
		
		public static function startOrEndWithChars(str:String, chars:String):Boolean
		{
			return startWithChars(str, chars) || endWithChars(str, chars)
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
		
		public static function uncapitalize(str:String):String
		{
			return str.substring(1, 0).toLowerCase() + str.substring(1);
		}
		
		//trimType: -1 left 1 right 0 both
        public static function trimWhitespace(str:String, trimType:int = 0):String
        {
            if(str == null) return "";
            
			var startIndex:int = 0;
			if(trimType <= 0)
			{
				while (isWhitespace(str.charAt(startIndex)))
				{
					startIndex++;
				}
			}
            
            var endIndex:int = str.length - 1;
			if(trimType >= 0)
			{
				while (isWhitespace(str.charAt(endIndex)))
				{
					endIndex--;
				}
			}
            
            if (endIndex >= startIndex)
			{
                return str.slice(startIndex, endIndex + 1);
			}
            else
			{
                return "";
			}
        }

		//trimChar("abc", "a") = > "bc" 
		//trimType: -1 left 1 right 0 both
		public static function trimChar(str:String, char:String, trimType:int = 0):String
		{
			if(str == null) return "";
			if(!char || char == "") return "";
			
			var startIndex:int = 0;
			if(trimType <= 0)
			{
				while(str.charAt(startIndex) == char)
				{
					startIndex++;
				}
			}
			
			var endIndex:int = str.length - 1;
			if(trimType >= 0)
			{
				while(str.charAt(endIndex) == char)
				{
					endIndex--;
				}	
			}
			
			if(endIndex >= startIndex)
			{
				return str.slice(startIndex, endIndex + 1);
			}
			else
			{
				return "";
			}
		}
		
		//trimCharor("abc123abc", "abc") = > "123"
		//trimType: -1 left 1 right 0 both
		public static function trimCharsAnd(str:String, chars:String, trimType:int = 0):String
		{
			if(str == null) return "";
			if(!chars || chars == "") return "";
			var charsLength:int = chars.length;
			if(charsLength == 0) return "";
			
			var startIndex:int = 0;
			if(trimType <= 0)
			{
				while(str.substr(startIndex, charsLength) == chars)
				{
					startIndex += charsLength;
				}
			}
			
			var endIndex:int = str.length - 1;
			if(trimType >= 0)
			{
				while(str.substr(endIndex - charsLength + 1, charsLength) == chars)
				{
					endIndex -= charsLength;
				}
			}
			
			if(endIndex >= startIndex)
			{
				return str.slice(startIndex, endIndex + 1);
			}
			else
			{
				return "";
			}
		}

		//trimCharor("abc", "a|c") = > "b"
		//trimType: -1 left 1 right 0 both
		public static function trimCharsOr(str:String, chars:Array, trimType:int = 0):String
		{
			if(str == null) return "";
			if(!chars || chars.length == 0) return "";
			
			var startIndex:int = 0;
			if(trimType <= 0)
			{
				while (chars.indexOf(str.charAt(startIndex)) != -1)
				{
					startIndex++;
				}
			}
			
			var endIndex:int = str.length - 1;
			if(trimType >= 0)
			{
				while(chars.indexOf(str.charAt(endIndex)) != -1)
				{
					endIndex--;
				}
			}
			
			if (endIndex >= startIndex)
			{
				return str.slice(startIndex, endIndex + 1);
			}
			else
			{
				return "";
			}
		}
		
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
        
        public static function substitute(str:String, ...args):String
        {
            if(str == null) return "";
            
            var len:int = args.length;
			if(len > 0)
			{
				var i:uint = 0;
				if(len == 1)
				{
					var argsObj:* = args[0];

					//eg1. "AB{0}DEF" + C = > "ABCDEF" only 0 here.
					if(argsObj is String || !isNaN(argsObj))
					{
						str = str.replace(new RegExp("\\{" + i + "\\}", "g"), argsObj);
					}
					//Key-value Map. Array or Object.
					//eg2. "My Name is {name} And I'm {age} years old." + {name:"Alex", age:24} => "My Name is Alex And I'm 24 years old."
					else
					{
						for(var key:String in argsObj)
						{
							str = str.replace(new RegExp("\\{" + key + "\\}", "g"), argsObj[key]);
						}
					}
				}
				//eg3. "AB{0}D{1}{2}" + [C,E,F] = > "ABCDEF"
				else
				{
					for (i = 0; i < len; i++)
					{
						str = str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
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
                {
                    charCodes.push(charCode);
                }
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
		public static function decodeKeyValueStr(str:String, 
											   fstDelimiter:String = ";", 
											   secDelimiter:String = ":", typeClass:Class = null):Object
		{
			var result:Object = typeClass ? new typeClass() : {};
			
			var arr:Array = str.split(fstDelimiter);
			
			var itemStr:String = null;
			var itemArr:Array = null;
			
			for(var i:int = 0, n:int = arr ? arr.length : 0; i < n; i++)
			{
				itemStr = arr[i];
				
				itemArr = itemStr.split(secDelimiter);
				if(itemArr.length == 2)
				{
					result[itemArr[0]] = itemArr[1];					
				}
			}

			return result;
		}
		
		public static function getFileName(file:String):String
		{
			var extensionIndex:Number = file.lastIndexOf(".");
			if(extensionIndex == -1)
			{
				return file;
			}
			else
			{
				return file.substr(0, extensionIndex);
			}
		}
		
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
    }
}
