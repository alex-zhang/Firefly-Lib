package com.fireflyLib.utils
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MathUtil
	{
		public static const helperPoint:Point = new Point();
		public static const helperMatrix:Matrix = new Matrix();
		public static const helperRect:Rectangle = new Rectangle();
		
		/**
		 * const of PI.
		 */
		public static const TWO_PI:Number = Math.PI * 2.0;//360
		public static const HALF_PI:Number = Math.PI * 0.5;//90
		public static const QUARTER_PI:Number = HALF_PI * 0.5;//45
		
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

		//Abount angle
		//======================================================================
		public static function caculateRadianByTwoPoint(startX:Number, startY:Number, endX:Number, endY:Number):Number
		{
			return Math.atan2(endY - startY, endX - startX);
		}
		
		/**
		 * Take a radian measure and make sure it is between -pi..pi. 
		 */
		public static function clampRadian(r:Number):Number 
		{ 
			r = r % MathUtil.TWO_PI;
			if (r > Math.PI)  r -= MathUtil.TWO_PI; 
			else if (r < -Math.PI) r += MathUtil.TWO_PI; 
			
			return r; 
		} 
		
		/**
		 * Take a degree measure and make sure it is between -180..180.
		 */
		public static function clampDegrees(r:Number):Number
		{
			r = r % 360;
			if (r > 180) r -= 360;
			else if (r < -180) r += 360;
			
			return r;
		}
		
		public static function mirrorRadinByYAxe(r:Number):Number
		{
			r = clampRadian(r);
			
			//-pi-pi
			if(r < 0)
			{
				return -Math.PI - r;
			}
			else
			{
				return Math.PI - r;
			}
		}
		
		/**
		 * Return the shortest distance to get from from to to, in radians.
		 */
		public static function getRadianShortDelta(from:Number, to:Number):Number
		{
			// Unwrap both from and to.
			from = clampRadian(from);
			to = clampRadian(to);
			
			// Calc delta.
			var delta:Number = to - from;
			
			// Make sure delta is shortest path around circle.
			delta = clampRadian(delta);
			
			// Done
			return delta;
		}
		
		/**
		 * Return the shortest distance to get from from to to, in degrees.
		 */
		public static function getDegreesShortDelta(from:Number, to:Number):Number
		{
			// Unwrap both from and to.
			from = clampRadian(from);
			to = clampRadian(to);
			
			// Calc delta.
			var delta:Number = to - from;
			
			// Make sure delta is shortest path around circle.
			
			delta = clampRadian(delta);
			
			// Done
			return delta;
		}
		
		//About Geom
		//======================================================================
		public static function distance(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			const dy:Number = y1 - y0;
			const dx:Number = x1 - x0;
			
			return Math.sqrt(dy * dy + dx * dx);
		}

		public static function lerpByTwoPoints(p0x:Number, p0y:Number,
													p1x:Number, p1y:Number, ratio:Number, 
													result:Point = null):Point
		{
			result ||= new Point();
			
			result.x = MathUtil.lerp(p0x, p1x, ratio);
			result.y = MathUtil.lerp(p0y, p1y, ratio);
			
			return result;
		}
		
		//path item .x, .y
		public static function caculateLengthOfPoints(points:Array):Number
		{
			var result:Number = 0;
			
			var currentPoint:Object = null;
			var lastPoint:Object = null;

			for(var i:uint = 1, n:uint = points ? points.length : 0; i < n; i++)
			{
				currentPoint = points[i];
				lastPoint = points[i - 1];
				
				result += MathUtil.distance(currentPoint.x, currentPoint.y, lastPoint.x, lastPoint.y);
			}
			
			return result;
		}
		
		//计算椭圆上的点
		public static function caculatePointOnEllipse(circleCenterX:Number, circleCenterY:Number, 
													  radian:Number, radiusX:Number, radiusY:Number,  
													  result:Point = null):Point
		{
			result ||= new Point();
			result.x = circleCenterX + Math.cos(radian) * radiusX;
			result.y = circleCenterY + Math.sin(radian) * radiusY;
			return result;
		}
		
		//求圆上一点点坐标
		public static function caculatePointOnCircle(circleCenterX:Number, circleCenterY:Number, 
													 radian:Number, radius:Number,
													 result:Point = null):Point
		{
			result ||= new Point();
			result.x = circleCenterX + Math.cos(radian) * radius;
			result.y = circleCenterY + Math.sin(radian) * radius;
			return result;
		}
		
		public static function caculateTargetAxePointInSourceAxePoint(targetAxePointX:Number, targetAxePointY:Number,
																	  targetAxeXDirectionRadianInSourceAxe:Number,
																	  targetAxeOriginPointX:Number, targetAxeOriginPointY:Number,
																	  result:Point = null):Point
		{
			result ||= new Point();
			
			var sinValue:Number = Math.sin(targetAxeXDirectionRadianInSourceAxe);
			var cosVlaue:Number = Math.cos(targetAxeXDirectionRadianInSourceAxe);

			result.x = cosVlaue * targetAxePointX - sinValue * targetAxePointY + targetAxeOriginPointX;
			result.y = cosVlaue * targetAxePointY + sinValue * targetAxePointX + targetAxeOriginPointY;
			
			return result;
		}
		
		//已知点p，求该点与p0,p1线垂直的线的焦点坐标
		public static function caculatePerpendicularIntersectionPoint(px:Number, py:Number, 
														  lineP0x:Number, lineP0y:Number, 
														  lineP1x:Number, lineP1y:Number, 
														  result:Point = null):Point
		{
			result ||= new Point();
			
			if(lineP0x == lineP1x)
			{
				result.setTo(lineP0x, py);
				return result;
			}
			
			var linek:Number = (lineP1y - lineP0y) / (lineP1x - lineP0x);
			var perpendicularLinek:Number = 1 / linek;
			
			return MathUtil.caculateIntersectionPoint(px, py, perpendicularLinek, lineP0x, lineP0y, linek);
		}
		
		public static function caculateIntersectionPoint(line0Px:Number, line0Py:Number, line0K:Number, 
														 line1Px:Number, line1Py:Number, line1K:Number, 
														 result:Point = null):Point
		{
			if(line0K == line1K) return null;
			
			//			y=a0x+b0,y=a1x+b1
			var b0:Number;
			var b1:Number;
			var x:Number;
			var y:Number;
			
			if(line0K == Infinity)
			{
				x = line0Px;
				b1 = line1Py - line1Px * line1K;
				y = line1K * x + b1;
			}
			else if(line1K == Infinity)
			{
				x = line1Px;
				b0 = line0Py - line0Px * line0K;
				y = line0K * x + b0;
			}
			else
			{
				b0 = line0Py - line0Px * line0K;
				b1 = line1Py - line1Px * line1K;
				
				x = (b1 - b0) / (line1K - line0K);
				y = line0K * (b1 - b0) / (line1K - line0K) + b0;
			}
			
			result ||= new Point();
			result.setTo(x, y);
			
			return result;
		}
		
		public static function isOverlapPointAndPoint(point0X:Number, point0Y:Number, 
													  point1X:Number, point1Y:Number):Boolean
		{
			return point0X == point1X && point0Y == point1Y;
		}
		
		public static function isOverlapPointAndRectangle(pointX:Number, pointY:Number, 
														  rectX:Number, rectY:Number, 
														  rectWidth:Number, rectHeight:Number):Boolean
		{
			if(pointX < rectX) return false;
			else if(pointX > rectX + rectWidth) return false;
			
			if(pointY < rectY) return false;
			else if(pointY > rectY + rectHeight) return false;
			
			return true;
		}
		
		public static function isOverlapPointAndCircle(pointX:Number, pointY:Number, 
													   circleCenterX:Number, 
													   circleCenterY:Number, 
													   circleRadius:Number):Boolean
		{
			var distance:Number = MathUtil.distance(pointX, pointY, circleCenterX, circleCenterY);
			
			if(distance > circleRadius) return false; 
			
			return true;
		}
		
		public static function isOverlapRectangleAndRectangle(rect0X:Number, rect0Y:Number, 
															  rect0Width:Number, rect0Height:Number, 
															  rect1X:Number, rect1Y:Number, 
															  rect1Width:Number, rect1Height:Number):Boolean
		{
			if(rect0X + rect0Width < rect1X) return false;
			else if(rect0X > rect1X + rect1Width) return false;
			
			if(rect0Y + rect0Height < rect1Y) return false;
			else if(rect0Y > rect1Y + rect1Height) return false;
			
			return true;
		}
		
		public static function isOverlapRectangleAndCircle(rectX:Number, rectY:Number, 
														   rectWidth:Number, rectHeight:Number,
														   circleCenterX:Number, 
														   circleCenterY:Number, 
														   circleRadius:Number):Boolean
		{
			if(circleCenterX + circleRadius < rectX) return false;
			else if(circleCenterX - circleRadius  > rectX + rectWidth) return false;
			
			if(circleCenterY + circleRadius < rectY) return false;
			else if(circleCenterY - circleRadius > rectY + rectHeight) return false;
			
			return true;
		}
		
		public static function isOverlapCircleAndCircle(circleCenter0X:Number, 
														circleCenter0Y:Number, 
														circle0Radius:Number, 
														circle1CenterX:Number, 
														circle1CenterY:Number, 
														circle1Radius:Number):Boolean
		{
			var cicleMiddleDistance:Number = MathUtil.distance(circleCenter0X, circleCenter0Y, circle1CenterX, circle1CenterY);
			var cicleMiddleMinDistance:Number = circle0Radius + circle1Radius;
			
			if(cicleMiddleMinDistance > cicleMiddleDistance) return false;
			
			return true;
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
		 * Generates a random number based on the seed provided.
		 * 
		 * @param	Seed	A number between 0 and 1, used to generate a predictable random number (very optional).
		 * 
		 * @return	A <code>Number</code> between 0 and 1.
		 */
		public static function srand(seed:Number):Number
		{
			return ((69621 * int(seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
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

		/** Returns the next power of two that is equal to or bigger than the specified number. */
		public static function getNextPowerOfTwo(number:int):int
		{
			if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
				return number;
			else
			{
				var result:int = 1;
				while (result < number) result <<= 1;
				return result;
			}
		}

		/** Uses a matrix to transform 2D coordinates into a different space. If you pass a 
         *  'resultPoint', the result will be stored in this point instead of creating a new object.*/
        public static function transformCoords(matrix:Matrix, x:Number, y:Number,
                                               resultPoint:Point=null):Point
        {
            if (resultPoint == null) resultPoint = new Point();   
            
            resultPoint.x = matrix.a * x + matrix.c * y + matrix.tx;
            resultPoint.y = matrix.d * y + matrix.b * x + matrix.ty;
            
            return resultPoint;
        }

		public static function getBounds(rect:Rectangle, matrix:Matrix, result:Rectangle):Rectangle
		{
			if(!result) result = new Rectangle();
			
			var x0:Number = rect.x;
			var y0:Number = rect.y;
			var x1:Number = rect.right;
			var y1:Number = rect.bottom;
			
			//x0, y0
			transformCoords(matrix, x0, y0, helperPoint);
			var minX:Number = helperPoint.x;
			var maxX:Number = helperPoint.x;
			var minY:Number = helperPoint.y;
			var maxY:Number = helperPoint.y;
			
			//x1, y0
			transformCoords(matrix, x1, y0, helperPoint);
			minX = MathUtil.min(minX, helperPoint.x);
			maxX = MathUtil.max(maxX, helperPoint.x);
			minY = MathUtil.min(minY, helperPoint.y);
			maxY = MathUtil.max(maxY, helperPoint.y);
			
			//x0, y1
			transformCoords(matrix, x0, y1, helperPoint);
			minX = MathUtil.min(minX, helperPoint.x);
			maxX = MathUtil.max(maxX, helperPoint.x);
			minY = MathUtil.min(minY, helperPoint.y);
			maxY = MathUtil.max(maxY, helperPoint.y);
			
			//x1, y1
			transformCoords(matrix, x1, y1, helperPoint);
			minX = MathUtil.min(minX, helperPoint.x);
			maxX = MathUtil.max(maxX, helperPoint.x);
			minY = MathUtil.min(minY, helperPoint.y);
			maxY = MathUtil.max(maxY, helperPoint.y);
			
			result.setTo(minX, minY, maxX - minX, maxY - minY);
			
			return result;
		}
	}
}