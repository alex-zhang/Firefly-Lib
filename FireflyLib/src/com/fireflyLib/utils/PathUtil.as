package com.fireflyLib.utils
{
	

	public final class PathUtil
	{
		private static const DEFAULT_SEP:String = "/";
		private static const WONDOWS_SEP:String = "\\";
		
		public static function get osSeparator():String
		{
			if(EVNUtil.isWindows()) return WONDOWS_SEP;

			return DEFAULT_SEP;
		}
		/**
		 * Return the last portion of a path. Similar to the Unix basename command.
		 *  
		 * @return 
		 * 
		 */		
		public static function basename(path:String, separator:String = "/", suffix:String = null):String
		{
			var parts:Array = path.split(separator);
			var lastPart:String = (parts && parts.length) ? parts[parts.length - 1] : "";
			
			return suffix ? StringUtil.trimCharsAnd(lastPart, suffix, 1) : lastPart;
		}
		
		/**
		 * Return the extension of the path, from the last '.' to end of string in the last portion of the path. 
		 * If there is no '.' in the last portion of the path or the first character of it is '.', 
		 * then it returns an empty string. Examples: 
		 * path.extname('index')
		 * returns
		 * ''
		 * 
		 * @param url
		 * @param ext
		 * @return 
		 * 
		 */		
		public static function extname(path:String, ext:String = null):String
		{
			var extIndex:Number = path.lastIndexOf(".");
			
			return extIndex != -1 ?
				path.substr(extIndex + 1) :
				"";
		}
		
			
		/**
		 * @private
		 * Test whether a url is on the local filesystem. We can only
		 * really tell this with URLs that begin with "file:" or a
		 * Windows-style drive notation such as "C:". This fails some
		 * cases like the "/" notation on Mac/Unix.
		 * 
		 * @param url
		 * the url to check against
		 * 
		 * @return
		 * true if url is local, false if not or unable to determine
		 **/
		public static function isLocal(url:String):Boolean
		{
			return (url.indexOf("file:") == 0 || url.indexOf(":") == 1);
		}
		
		/**
		 *  @private 
		 * 
		 *  Use this method when you want to load resources with relative URLs.
		 * 
		 *  Combine a root url with a possibly relative url to get a absolute url.
		 *  Use this method to convert a relative url to an absolute URL that is 
		 *  relative to a root URL.
		 * 
		 *  @param rootURL An url that will form the root of the absolute url.
		 *  If the <code>rootURL</code> does not specify a file name it must be 
		 *  terminated with a slash. For example, "http://a.com" is incorrect, it
		 *  should be terminated with a slash, "http://a.com/". If the rootURL is
		 *  taken from loaderInfo, it must be passed thru <code>normalizeURL</code>
		 *  before being passed to this function.
		 * 
		 *  When loading resources relative to an application, the rootURL is 
		 *  typically the loaderInfo.url of the application.
		 * 
		 *  @param url The url of the resource to load (may be relative).
		 * 
		 *  @return If <code>url</code> is already an absolute URL, then it is 
		 *  returned as is. If <code>url</code> is relative, then an absolute URL is
		 *  returned where <code>url</code> is relative to <code>rootURL</code>. 
		 */ 
		public static function createAbsoluteURL(rootURL:String, url:String):String
		{
			var absoluteURL:String = url;
			
			// make relative paths relative to the SWF loading it, not the top-level SWF
			if (rootURL &&
				!(url.indexOf(":") > -1 || url.indexOf("/") == 0 || url.indexOf("\\") == 0))
			{
				// First strip off the search string and then any url fragments.
				var index:int;
				
				if ((index = rootURL.indexOf("?")) != -1 )
					rootURL = rootURL.substring(0, index);
				
				if ((index = rootURL.indexOf("#")) != -1 )
					rootURL = rootURL.substring(0, index);
				
				// If the url starts from the current directory, then just skip
				// over the "./".
				// If the url start from the parent directory, the we need to
				// modify the rootURL.
				var lastIndex:int = Math.max(rootURL.lastIndexOf("\\"), rootURL.lastIndexOf("/"));
				if (url.indexOf("./") == 0)
				{
					url = url.substring(2);
				}
				else
				{
					while (url.indexOf("../") == 0)
					{
						url = url.substring(3);
						lastIndex = Math.max(rootURL.lastIndexOf("\\", lastIndex - 1), 
							rootURL.lastIndexOf("/", lastIndex - 1));
					}
				}
				
				if (lastIndex != -1)
					absoluteURL = rootURL.substr(0, lastIndex + 1) + url;
			}
			
			return absoluteURL;
		}

        /**
         * <pre>
         * http://www.google.com -> http
         * file://...            -> file
         *
         * </pre>
         */
        public function protocol(url:String):String
        {
            var indexOfProtocolSepator:int = url.indexOf('://');
            if(indexOfProtocolSepator == -1) return null;

            return url.substring(0, indexOfProtocolSepator)
        }
	}
}