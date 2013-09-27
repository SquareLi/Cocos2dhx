/****************************************************************************
 cocos2dhx 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

package cc.cocoa;
import flambe.math.Point;
import flambe.math.Rectangle;

/**
 * ...
 * @author Ang Li
 */

class CCGeometry 
{

	public function new() 
	{
		
	}
	
	public static function pointMake(x : Float, y : Float) : Point {
		return new Point(x, y);
	}
	
	public static function p(x : Float, y : Float) : Point {
		return new Point(x, y);
	}
	
	public static function pointZero() : Point {
		return new Point(0, 0);
	}
	
	public static function pointEqualToPoint(p1 : Point, p2 : Point) : Bool{
		if (p1 == null || p2 == null) {
			return false;
		}
		
		return ((p1.x == p2.x) && (p1.y == p2.y));
	}
	
	public static function sizeMake(w : Float, h : Float) : CCSize {
		return new CCSize(w, h);
	}
	
	public static function sizeZero() : CCSize {
		return new CCSize(0, 0);
	}
	
	public static function sizeEqualToSize(size1 : CCSize, size2 : CCSize) : Bool {
		if (size1 == null || size2 == null) {
			return false;
		}
		
		return ((size1.width == size2.width) && (size1.height == size2.height));
	}
	
	public static function rectMake(x : Float, y : Float, width : Float, height : Float) : Rectangle {
		return new Rectangle(x, y, width, height);
	}
	
	public static function rectZero() : Rectangle {
		return new Rectangle(0, 0, 0, 0);
	}
	
	public static function rectEqualToRect(rect1 : Rectangle, rect2 : Rectangle) : Bool {
		if (rect1 == null || rect2 == null) {
			return false;
		}
		
		return ((rect1.x == rect2.x) && (rect1.y == rect2.y) && (rect1.width == rect2.width) && (rect1.height == rect2.height));
	}
	
	public static function rectGetMaxX(rect : Rectangle) : Float{
		return (rect.x + rect.width);
	}
	
	public static function rectGetMidX(rect : Rectangle) : Float {
		return ((rect.x + rect.width) / 2);
	}
	
	public static function rectGetMinX(rect : Rectangle) : Float {
		return rect.x;
	}
	
	public static function rectGetMaxY(rect : Rectangle) : Float{
		return (rect.y + rect.height);
	}
	
	public static function rectGetMidY(rect : Rectangle) : Float {
		return ((rect.y + rect.height) / 2);
	}
	
	public static function rectGetMinY(rect : Rectangle) : Float {
		return rect.y;
	}
	
	public static function _rectEqualToZero(rect : Rectangle) : Bool {
		return rect.x == 0 && rect.y == 0 && rect.width == 0 && rect.height == 0;
	}
	
	/**
	 * Returns the smallest rectangle that contains the two source rectangles.
	 * @function
	 * @param {cc.Rect} rectA
	 * @param {cc.Rect} rectB
	 * @return {cc.Rect}
	 */
	public static function rectUnion(rectA : Rectangle, rectB : Rectangle) : Rectangle {
		var rect : Rectangle = new Rectangle(0, 0, 0, 0);
		rect.x = Math.min(rectA.x, rectB.x);
		rect.y = Math.min(rectA.y, rectB.y);
		rect.width = Math.max(rectA.x + rectA.width, rectB.x + rectB.width) - rect.x;
		rect.height = Math.max(rectA.y + rectA.height, rectB.y + rectB.height) - rect.y;
		return rect;
	}
	
	public static function rectIntersectsRect(rectA : Rectangle, rectB : Rectangle) : Bool{
		return !(CCGeometry.rectGetMaxX(rectA) < CCGeometry.rectGetMinX(rectB) ||
			CCGeometry.rectGetMaxX(rectB) < CCGeometry.rectGetMinX(rectA) ||
			CCGeometry.rectGetMaxY(rectA) < CCGeometry.rectGetMinY(rectB) ||
			CCGeometry.rectGetMaxY(rectB) < CCGeometry.rectGetMinY(rectA));
	}
}

class CCSize 
{
	public var width : Float;
	public var height : Float;
	public function new(?width : Float = 0, ?height : Float = 0) 
	{
		this.width = width;
		this.height = height;
	}
	
	public function setSize(width : Float , height : Float) {
		this.width = width;
		this.height = height;
	}
	
	public function equals(size : CCSize) : Bool {
		if (this.width == size.width && this.height == size.height) {
			return true;
		} else {
			return false;
		}
	}
	
	public function toString() : String {
		return '$width x $height';
	}
}

