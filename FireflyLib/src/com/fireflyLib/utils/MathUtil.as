package com.fireflyLib.utils
{
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class MathUtil
	{
		public static const helperFlashPoint:Point = new Point();
		public static const helperMatrix:Matrix = new Matrix();
		
		/**
		 * Two times PI. 
		 */
		public static const TWO_PI:Number = Math.PI * 2.0;
		
		public static const HALF_PI:Number = Math.PI * 0.5;
		
		public static const QUARTER_PI:Number = HALF_PI * 0.5;
		
		//Basic Math
		//======================================================================
		/**
		 * Figure out which number is larger.
		 * 
		 * @param	Number1		Any number.
		 * @param	Number2		Any number.
		 * 
		 * @return	The larger of the two numbers.
		 */
		public static function max(number1:Number, number2:Number):Number
		{
			return (number1 < number2) ? number2 : number1;
		}
		
		/**
		 * Figure out which number is smaller.
		 * 
		 * @param	Number1		Any number.
		 * @param	Number2		Any number.
		 * 
		 * @return	The larger of the two numbers.
		 */
		public static function min(number1:Number, number2:Number):Number
		{
			return (number1 > number2) ? number2 : number1;
		}
		
		/**
		 * Keep a number between a min and a max.
		 */
		public static function clamp(v:Number, min:Number = 0, max:Number = 1):Number
		{
			if(v < min) return min;
			if(v > max) return max;
			
			return v;
		}
		
		/**
		 * Calculate the absolute value of a number.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The absolute value of that number.
		 */
		public static function abs(value:Number):Number
		{
			return value > 0 ? value : -value;
		}
		
		/**
		 * Round to the closest whole number. E.g. round(1.7) == 2, and round(-2.3) == -2.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The rounded value of that number.
		 */
		public static function round(value:Number):Number
		{
			var number:Number = int(value + (value > 0 ? 0.5 : -0.5));
			
			return value > 0 ?
				(number) :
				(number != value ? number - 1 : number);
		}
		
		//Math.round(90.337 / 0.1) * 0.1 => 90.34 //保留小数点后两位
		//Math.round(90.2 / 10) * 10 => 90        //90.2取10的最近倍数值
		//Math.round(90.2 / 5) * 5 => 90        //90.2取5的最近倍数值
		public static function roundByPrecision(value:Number, precision:Number):Number
		{
			if(value == 0) return value;
			
			return Math.round(value / precision) * precision;
		}
		
		/**
		 * Round down to the next whole number. E.g. floor(1.7) == 1, and floor(-2.7) == -2.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The rounded value of that number.
		 */
		public static function floor2(value:Number):Number
		{
			return int(value);
		}
		
		/**
		 * Round up to the next whole number.  E.g. ceil(1.3) == 2, and ceil(-2.3) == -3.
		 * 
		 * @param	Value	Any number.
		 * 
		 * @return	The rounded value of that number.
		 */
		public static function ceil2(value:Number):Number
		{
			var number:Number = int(value);
			return value > 0 ?
				(number != value ? number + 1: number) :
				(number != value ? number - 1: number);
		}
		
		public static function getBitMaskValue(value:uint, mask:uint):uint
		{
			return value & mask;
		}
		
		/**
		 * Linear interpolation function
		 * @param	a start value
		 * @param	b end value
		 * @param	ratio interpolation amount
		 * @return
		 */
		public static function lerp(a:Number,b:Number,ratio:Number):Number
		{
			return a + (b - a) * ratio;
		}
		
		public static function isEquivalent(a:Number, b:Number, epsilon:Number = 0.0001):Boolean
		{
			return (a - epsilon < b) && (a + epsilon > b);
		}
		
		//Abount angle
		//======================================================================
		/**
		 * Converts an angle in radians to an angle in degrees.
		 * 
		 * @param radians The angle to convert.
		 * 
		 * @return The converted value.
		 */
		public static function radiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		/**
		 * Converts an angle in degrees to an angle in radians.
		 * 
		 * @param degrees The angle to convert.
		 * 
		 * @return The converted value.
		 */
		public static function degreesToRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		public static function twoPointToRadian(startX:Number, startY:Number, endX:Number, endY:Number):Number
		{
			return Math.atan2(endY - startY, endX - startX);
		}
		
		//About Geom
		//======================================================================
		public static function distance(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			const dy:Number = y1 - y0;
			const dx:Number = x1 - x0;
			
			return Math.sqrt(dy * dy + dx * dx);
		}
		
		//About Random
		public static function randomNumberBetween(min:Number, max:Number):Number
		{
			return lerp(min, max, Math.random());
		}
		
		public static function randomFromValues(values:Array):*
		{
			return values[randomIndex(values.length)];
		}
		
		public static function randomIndex(count:uint):int
		{
			if(count == 0) return -1;
			
			return Math.random() * count;
		}
		
		public static function randomTrueByProbability(probability:Number/*0-1*/):Boolean
		{
			if(probability <= 0) return false;
			else if(probability >= 1) return true;
			
			return Math.random() <= probability;
		}
		
		/**
		 * Shuffles the entries in an array into a new random order.
		 * <code>FlxG.shuffle()</code> is deterministic and safe for use with replays/recordings.
		 * HOWEVER, <code>FlxU.shuffle()</code> is NOT deterministic and unsafe for use with replays/recordings.
		 * 
		 * @param	A				A Flash <code>Array</code> object containing...stuff.
		 * @param	HowManyTimes	How many swaps to perform during the shuffle operation.  Good rule of thumb is 2-4 times as many objects are in the list.
		 * 
		 * @return	The same Flash <code>Array</code> object that you passed in in the first place.
		 */
		public static  function shuffle(cards:Array, howManyTimes:uint):Array
		{
			var i:uint = 0;
			var index1:uint;
			var index2:uint;
			var card:Object;
			
			while(i < howManyTimes)
			{
				index1 = randomIndex(cards.length);
				index2 = randomIndex(cards.length);
				
				card = cards[index2];
				
				cards[index2] = cards[index1];
				cards[index1] = card;
				
				i++;
			}
			
			return cards;
		}
	}
}