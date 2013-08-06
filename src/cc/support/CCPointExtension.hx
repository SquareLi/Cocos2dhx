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

package cc.support;
import flambe.math.Point;
import cc.cocoa.CCGeometry;
/**
 * ...
 * @author Ang Li
 */

class CCPointExtension 
{
	public static var POINT_EPSILON = Std.parseFloat('1.192092896e-07F');
	public function new() 
	{
		
	}
	
	/**
	 * Returns opposite of point.
	 * @param {cc.Point} point
	 * @return {cc.Point}
	 */
	public static function pNeg(point : Point) : Point {
		return new Point( -point.x, -point.y);
	}
	
	/**
	 * Calculates sum of two points.
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {cc.Point}
	 */
	public static function pAdd(v1 : Point, v2 : Point) : Point {
		return new Point(v1.x + v2.x, v1.y + v2.y);
	}
	
	/**
	 * Calculates difference of two points.
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {cc.Point}
	 */
	public static function pSub(v1 : Point, v2 : Point) : Point {
		return new Point(v1.x - v2.x, v1.y - v2.y);
	}
	
	/**
	 * Returns point multiplied by given factor.
	 * @param {cc.Point} point
	 * @param {Number} floatVar
	 * @return {cc.Point}
	 */
	public static function pMult(point : Point, floatVar : Float) : Point {
		return new Point(point.x * floatVar, point.y * floatVar);
	}
	
	/**
	 * Calculates midpoint between two points.
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {cc.pMult}
	 */
	public static function pMidPoint(v1 : Point, v2 : Point) : Point{
		return pMult(pAdd(v1, v2), 0.5);
	}
	
	/**
	 * Calculates dot product of two points.
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {Number}
	 */
	public static function pDot(v1 : Point, v2 : Point) : Float {
		return v1.x * v2.x + v1.y * v2.y;
	}

	/**
	 * Calculates cross product of two points.
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {Number}
	 */
	public static function pCross(v1 : Point, v2 : Point) : Float{
		return v1.x * v2.y - v1.y * v2.x;
	}

	/**
	 * Calculates perpendicular of v, rotated 90 degrees counter-clockwise -- cross(v, perp(v)) >= 0
	 * @param {cc.Point} point
	 * @return {cc.Point}
	 */
	public static function pPerp(point : Point) : Point {
		return new Point(-point.y, point.x);
	}

	/**
	 * Calculates perpendicular of v, rotated 90 degrees clockwise -- cross(v, rperp(v)) <= 0
	 * @param {cc.Point} point
	 * @return {cc.Point}
	 */
	public static function pRPerp(point : Point) : Point {
		return new Point(point.y, -point.x);
	}

	/**
	 * Calculates the projection of v1 over v2.
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {cc.pMult}
	 */
	public static function pProject(v1 : Point, v2 : Point) : Point {
		return pMult(v2, pDot(v1, v2) / pDot(v2, v2));
	}

	/**
	 * Rotates two points.
	 * @param  {cc.Point} v1
	 * @param  {cc.Point} v2
	 * @return {cc.Point}
	 */
	public static function pRotate(v1 : Point, v2 : Point) {
		return new Point(v1.x * v2.x - v1.y * v2.y, v1.x * v2.y + v1.y * v2.x);
	}

	/**
	 * Unrotates two points.
	 * @param  {cc.Point} v1
	 * @param  {cc.Point} v2
	 * @return {cc.Point}
	 */
	public static function pUnrotate(v1 : Point, v2 : Point) : Point {
		return new Point(v1.x * v2.x + v1.y * v2.y, v1.y * v2.x - v1.x * v2.y);
	}

	/**
	 * Calculates the square length of a cc.Point (not calling sqrt() )
	 * @param  {cc.Point} v
	 *@return {cc.pDot}
	 */
	public static function pLengthSQ(v : Point) :  Float{
		return pDot(v, v);
	}

	/**
	 * Calculates distance between point an origin
	 * @param  {cc.Point} v
	 * @return {Number}
	 */
	public static function pLength(v : Point) : Float {
		return Math.sqrt(pLengthSQ(v));
	}

	/**
	 * Calculates the distance between two points
	 * @param {cc.Point} v1
	 * @param {cc.Point} v2
	 * @return {cc.pLength}
	 */
	public static function pDistance(v1 : Point, v2 : Point) : Float {
		return pLength(pSub(v1, v2));
	}

	/**
	 * Returns point multiplied to a length of 1.
	 * @param {cc.Point} v
	 * @return {cc.pMult}
	 */
	public static function pNormalize(v : Point) : Point {
		return pMult(v, 1.0 / pLength(v));
	}

	/**
	 * Converts radians to a normalized vector.
	 * @param {Number} a
	 * @return {cc.Point}
	 */
	public static function pForAngl(a : Float) : Point{
		return new Point(Math.cos(a), Math.sin(a));
	}

	/**
	 * Converts a vector to radians.
	 * @param {cc.Point} v
	 * @return {Number}
	 */
	public static function pToAngle(v : Point) : Float {
		return Math.atan2(v.y, v.x);
	}

	/**
	 * Clamp a value between from and to.
	 * @param {Number} value
	 * @param {Number} min_inclusive
	 * @param {Number} max_inclusive
	 * @return {Number}
	 */
	public static function clampf(value : Float, min_inclusive : Float, max_inclusive : Float) : Float {
		if (min_inclusive > max_inclusive) {
			var temp = min_inclusive;
			min_inclusive = max_inclusive;
			max_inclusive = temp;
		}
		return value < min_inclusive ? min_inclusive : value < max_inclusive ? value : max_inclusive;
	}

	/**
	 * Clamp a point between from and to.
	 * @param {Number} p
	 * @param {cc.Point} min_inclusive
	 * @param {cc.Point} max_inclusive
	 * @return {cc.Point}
	 */
	public static function pClamp(p : Point, min_inclusive : Point, max_inclusive : Point) : Point {
		return new Point(clampf(p.x, min_inclusive.x, max_inclusive.x), clampf(p.y, min_inclusive.y, max_inclusive.y));
	}

	/**
	 * Quickly convert cc.Size to a cc.Point
	 * @param {cc.Size} s
	 * @return {cc.Point}
	 */
	public static function pFromSize(s : CCSize) : Point{
		return new Point(s.width, s.height);
	}

	/**
	 * Run a math operation function on each point component <br />
	 * Math.abs, Math.fllor, Math.ceil, Math.round.
	 * @param {cc.Point} p
	 * @param {Function} opFunc
	 * @return {cc.Point}
	 * @example
	 * //For example: let's try to take the floor of x,y
	 * var p = cc.pCompOp(cc.p(10,10),Math.abs);
	 */
	//public static function pCompOp(p : Point, opFunc : Function) : Point {
		//return new Point(opFunc(p.x), opFunc(p.y));
	//}

	/**
	 * Linear Interpolation between two points a and b
	 * alpha == 0 ? a
	 * alpha == 1 ? b
	 * otherwise a value between a..b
	 * @param {cc.Point} a
	 * @param {cc.Point} b
	 * @param {Number} alpha
	 * @return {cc.pAdd}
	 */
	public static function pLerp(a : Point, b : Point, alpha : Float) : Point{
		return pAdd(pMult(a, 1 - alpha), pMult(b, alpha));
	}

	/**
	 * @param {cc.Point} a
	 * @param {cc.Point} b
	 * @param {Number} variance
	 * @return {Boolean} if points have fuzzy equality which means equal with some degree of variance.
	 */
	public static function pFuzzyEqual(a : Point, b : Point, variance : Float) : Bool{
		if (a.x - variance <= b.x && b.x <= a.x + variance) {
			if (a.y - variance <= b.y && b.y <= a.y + variance) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Multiplies a nd b components, a.x*b.x, a.y*b.y
	 * @param {cc.Point} a
	 * @param {cc.Point} b
	 * @return {cc.Point}
	 */
	public static function pCompMult(a : Point, b : Point) {
		return new Point(a.x * b.x, a.y * b.y);
	}

	/**
	 * @param {cc.Point} a
	 * @param {cc.Point} b
	 * @return {Number} the signed angle in radians between two vector directions
	 */
	public static function pAngleSigned(a : Point, b : Point) : Float {
		var a2 = pNormalize(a);
		var b2 = pNormalize(b);
		var angle = Math.atan2(a2.x * b2.y - a2.y * b2.x, pDot(a2, b2));
		if (Math.abs(angle) < POINT_EPSILON) {
			return 0.0;
		}
		return angle;
	}

	/**
	 * @param {cc.Point} a
	 * @param {cc.Point} b
	 * @return {Number} the angle in radians between two vector directions
	 */
	public static function pAngle(a : Point, b : Point) : Float {
		var angle = Math.acos(pDot(pNormalize(a), pNormalize(b)));
		if (Math.abs(angle) < POINT_EPSILON) return 0.0;
		return angle;
	}

	/**
	 * Rotates a point counter clockwise by the angle around a pivot
	 * @param {cc.Point} v v is the point to rotate
	 * @param {cc.Point} pivot pivot is the pivot, naturally
	 * @param {Number} angle angle is the angle of rotation cw in radians
	 * @return {cc.Point} the rotated point
	 */
	public static function pRotateByAngle(v : Point, pivot : Point, angle : Float) : Point{
		var r = pSub(v, pivot);
		var cosa = Math.cos(angle);
		var sina = Math.sin(angle);
		var t = r.x;
		r.x = t * cosa - r.y * sina + pivot.x;
		r.y = t * sina + r.y * cosa + pivot.y;
		return r;
	}

	/**
	 * A general line-line intersection test
	 * @param {cc.Point} A A is the startpoint for the first line P1 = (p1 - p2).
	 * @param {cc.Point} B B is the endpoint for the first line P1 = (p1 - p2).
	 * @param {cc.Point} C C is the startpoint for the second line P2 = (p3 - p4).
	 * @param {cc.Point} D D is the endpoint for the second line P2 = (p3 - p4).
	 * @param {cc.Point} retP retP.x is the range for a hitpoint in P1 (pa = p1 + s*(p2 - p1)), <br />
	 * retP.y is the range for a hitpoint in P3 (pa = p2 + t*(p4 - p3)).
	 * @return {Boolean}
	 * indicating successful intersection of a line<br />
	 * note that to truly test intersection for segments we have to make<br />
	 * sure that s & t lie within [0..1] and for rays, make sure s & t > 0<br />
	 * the hit point is        p3 + t * (p4 - p3);<br />
	 * the hit point also is    p1 + s * (p2 - p1);
	 */
	public static function pLineIntersect(A : Point, B : Point, C : Point, D : Point, retP : Point) : Bool {
		if ((A.x == B.x && A.y == B.y) || (C.x == D.x && C.y == D.y)) {
			return false;
		}
		var BAx = B.x - A.x;
		var BAy = B.y - A.y;
		var DCx = D.x - C.x;
		var DCy = D.y - C.y;
		var ACx = A.x - C.x;
		var ACy = A.y - C.y;

		var denom = DCy * BAx - DCx * BAy;

		retP.x = DCx * ACy - DCy * ACx;
		retP.y = BAx * ACy - BAy * ACx;

		if (denom == 0) {
			if (retP.x == 0 || retP.y == 0) {
				// Lines incident
				return true;
			}
			// Lines parallel and not incident
			return false;
		}

		retP.x = retP.x / denom;
		retP.y = retP.y / denom;

		return true;
	}

	/**
	 * ccpSegmentIntersect return YES if Segment A-B intersects with segment C-D.
	 * @param {cc.Point} A
	 * @param {cc.Point} B
	 * @param {cc.Point} C
	 * @param {cc.Point} D
	 * @return {Boolean}
	 */
	public static function pSegmentIntersect(A : Point, B : Point, C : Point, D : Point) : Bool{
		var retP = new Point(0, 0);
		if (pLineIntersect(A, B, C, D, retP))
			if (retP.x >= 0.0 && retP.x <= 1.0 && retP.y >= 0.0 && retP.y <= 1.0)
				return true;
		return false;
	}

	/**
	 * ccpIntersectPoint return the intersection point of line A-B, C-D
	 * @param {cc.Point} A
	 * @param {cc.Point} B
	 * @param {cc.Point} C
	 * @param {cc.Point} D
	 * @return {cc.Point}
	 */
	public static function pIntersectPoint(A : Point, B : Point, C : Point, D : Point) : Point {
		var retP = new Point(0, 0);

		if (pLineIntersect(A, B, C, D, retP)) {
			// Point of intersection
			var P = new Point(0, 0);
			P.x = A.x + retP.x * (B.x - A.x);
			P.y = A.y + retP.x * (B.y - A.y);
			return P;
		}

		return new Point(0, 0);
	}

	/**
	 * check to see if both points are equal
	 * @param {cc.Point} A A ccp a
	 * @param {cc.Point} B B ccp b to be compared
	 * @return {Boolean} the true if both ccp are same
	 */
	public static function pSameAs(A : Point, B : Point) : Bool {

			return (A.x == B.x && A.y == B.y);

		return false;
	}
}