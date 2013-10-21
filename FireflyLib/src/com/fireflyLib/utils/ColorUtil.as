package com.fireflyLib.utils
{
    public final class ColorUtil
    {
		public static const WHITE:uint   = 0xffffff;
		public static const SILVER:uint  = 0xc0c0c0;
		public static const GRAY:uint    = 0x808080;
		public static const BLACK:uint   = 0x000000;
		public static const RED:uint     = 0xff0000;
		public static const MAROON:uint  = 0x800000;
		public static const YELLOW:uint  = 0xffff00;
		public static const OLIVE:uint   = 0x808000;
		public static const LIME:uint    = 0x00ff00;
		public static const GREEN:uint   = 0x008000;
		public static const AQUA:uint    = 0x00ffff;
		public static const TEAL:uint    = 0x008080;
		public static const BLUE:uint    = 0x0000ff;
		public static const NAVY:uint    = 0x000080;
		public static const FUCHSIA:uint = 0xff00ff;
		public static const PURPLE:uint  = 0x800080;
		public static const PINK:uint = 0xfff01eff;
		
//		public static function getDefaultColorList():Array
//		{
//			var colors:Array = [0x333333, 0x666666, 0x999999, 
//								0xCCCCCC, 
//								0xFFFFFF, 0x000000,
//								0xFF0000, 0x00FF00, 0x0000FF, 
//								0xFFFF00, 0x00FFFF, 0xFF00FF];
//			return colors;
//		}
		
		/** Returns the alpha part of an ARGB color (0 - 255). */
		public static function getAlpha(color:uint):int { return (color >> 24) & 0xff; }
		
		/** Returns the red part of an (A)RGB color (0 - 255). */
		public static function getRed(color:uint):int   { return (color >> 16) & 0xff; }
		
		/** Returns the green part of an (A)RGB color (0 - 255). */
		public static function getGreen(color:uint):int { return (color >>  8) & 0xff; }
		
		/** Returns the blue part of an (A)RGB color (0 - 255). */
		public static function getBlue(color:uint):int  { return  color        & 0xff; }
		
		/** Creates an RGB color, stored in an unsigned integer. Channels are expected
		 *  in the range 0 - 255. */
		public static function rgbToColor(red:int, green:int, blue:int):uint
		{
			return (red << 16) | (green << 8) | blue;
		}
		
		/** Creates an ARGB color, stored in an unsigned integer. Channels are expected
		 *  in the range 0 - 255. */
		public static function argbToColor(alpha:int, red:int, green:int, blue:int):uint
		{
			return (alpha << 24) | (red << 16) | (green << 8) | blue;
		}
		
		/**
		 * Loads an array with the RGBA values of a Flash <code>uint</code> color.
		 * RGB values are stored 0-255.  Alpha is stored as a floating point number between 0 and 1.
		 * 
		 * @param	Color	The color you want to break into components.
		 * @param	Results	An optional parameter, allows you to use an array that already exists in memory to store the result.
		 * 
		 * @return	An <code>Array</code> object containing the Red, Green, Blue and Alpha values of the given color.
		 */
		public static  function colorToArgb(color:uint, results:Array = null):Array
		{
			results ||= [];
			
			results[0] = color >> 24;//alpha
			results[1] = (color >> 16) & 0xFF;//red
			results[2] = (color >> 8) & 0xFF;//green
			results[3] = color & 0xFF;//blue
			return results;
		}
		
		/**
		 *  Performs a linear brightness adjustment of an RGB color.
		 *
		 *  <p>The same amount is added to the red, green, and blue channels
		 *  of an RGB color.
		 *  Each color channel is limited to the range 0 through 255.</p>
		 *
		 *  @param rgb Original RGB color.
		 *
		 *  @param brite Amount to be added to each color channel.
		 *  The range for this parameter is -255 to 255;
		 *  -255 produces black while 255 produces white.
		 *  If this parameter is 0, the RGB color returned
		 *  is the same as the original color.
		 *
		 *  @return New RGB color.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
        public static function adjustBrightness(rgb:uint, brite:Number):uint
        {
            var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
            var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
            var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
            
            return (r << 16) | (g << 8) | b;
        } 
        
		/**
		 *  Performs a scaled brightness adjustment of an RGB color.
		 *
		 *  @param rgb Original RGB color.
		 *
		 *  @param brite The percentage to brighten or darken the original color.
		 *  If positive, the original color is brightened toward white
		 *  by this percentage. If negative, it is darkened toward black
		 *  by this percentage.
		 *  The range for this parameter is -100 to 100;
		 *  -100 produces black while 100 produces white.
		 *  If this parameter is 0, the RGB color returned
		 *  is the same as the original color.
		 *
		 *  @return New RGB color.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
        public static function adjustBrightness2(rgb:uint, brite:Number):uint
        {
            var r:Number;
            var g:Number;
            var b:Number;
            
            if (brite == 0)
                return rgb;
            
            if (brite < 0)
            {
                brite = (100 + brite) / 100;
                r = ((rgb >> 16) & 0xFF) * brite;
                g = ((rgb >> 8) & 0xFF) * brite;
                b = (rgb & 0xFF) * brite;
            }
            else // bright > 0
            {
                brite /= 100;
                r = ((rgb >> 16) & 0xFF);
                g = ((rgb >> 8) & 0xFF);
                b = (rgb & 0xFF);
                
                r += ((0xFF - r) * brite);
                g += ((0xFF - g) * brite);
                b += ((0xFF - b) * brite);
                
                r = Math.min(r, 255);
                g = Math.min(g, 255);
                b = Math.min(b, 255);
            }
            
            return (r << 16) | (g << 8) | b;
        }
        
        public static function rgbMultiply(rgb1:uint, rgb2:uint):uint
        {
            var r1:Number = (rgb1 >> 16) & 0xFF;
            var g1:Number = (rgb1 >> 8) & 0xFF;
            var b1:Number = rgb1 & 0xFF;
            
            var r2:Number = (rgb2 >> 16) & 0xFF;
            var g2:Number = (rgb2 >> 8) & 0xFF;
            var b2:Number = rgb2 & 0xFF;
            
            return ((r1 * r2 / 255) << 16) |
                ((g1 * g2 / 255) << 8) |
                (b1 * b2 / 255);
        } 
    }
}
