package cc.basenodes;
import flambe.input.PointerEvent;
import flambe.math.Point;
import cc.cocoa.CCGeometry;
import flambe.math.Rectangle;

/**
 * ...
 * @author Ang Li
 */
class CCAffineTransform
{
	public var a : Float;
	public var b : Float;
	public var c : Float;
	public var d : Float;
	public var tx : Float;
	public var ty : Float;
	
	public function new(a : Float, b : Float, c : Float, d : Float, tx : Float ,ty : Float) 
	{
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
	}
	
	public static function AffineTransforMake(a : Float, b : Float, c : Float, d : Float, tx : Float ,ty : Float) 
	{
		return new CCAffineTransform(a, b, c, d, tx, ty);
	}
	
	public static function __PointApplyAffineTransform(point : Point, t : CCAffineTransform) : Point {
		return new Point(t.a * point.x + t.c * point.y + t.tx, t.b * point.x + t.d * point.y + t.ty);
	}
	
	public static function _PointApplyAffineTransform(x : Float, y : Float, t : CCAffineTransform) : Point {
		return new Point(t.a * x + t.c * y + t.tx, t.b * x + t.d * y + t.ty);
	}
	
	public static function PointApplyAffineTransform(point : Point, t : CCAffineTransform) : Point {
		return new Point(t.a * point.x + t.c * point.y + t.tx, t.b * point.x + t.d * point.y + t.ty);
	}
	
	public static function SizeApplyAffineTransform(size : CCSize, t : CCAffineTransform) : CCSize {
		return new CCSize(t.a * size.width + t.c * size.height, t.b * size.width + t.d * size.height);
	}
	
	public static function AffineTransformMakeIdentity() : CCAffineTransform {
		return new CCAffineTransform(1, 0, 0, 1, 0, 0);
	}
	
	public static function AffineTransformIdentity() : CCAffineTransform {
		return new CCAffineTransform(1, 0, 0, 1, 0, 0);
	}
	
	public static function RectApplyAffineTransform(rect : Rectangle, anAffineTransform : CCAffineTransform) : Rectangle {
		var top = CCGeometry.rectGetMinY(rect);
		var left = CCGeometry.rectGetMinX(rect);
		var right = CCGeometry.rectGetMaxX(rect);
		var bottom = CCGeometry.rectGetMaxY(rect);

		var topLeft : Point = PointApplyAffineTransform(new Point(left, top), anAffineTransform);
		var topRight : Point = PointApplyAffineTransform(new Point(right, top), anAffineTransform);
		var bottomLeft : Point = PointApplyAffineTransform(new Point(left, bottom), anAffineTransform);
		var bottomRight : Point = PointApplyAffineTransform(new Point(right, bottom), anAffineTransform);

		var minX = Math.min(Math.min(topLeft.x, topRight.x), Math.min(bottomLeft.x, bottomRight.x));
		var maxX = Math.max(Math.max(topLeft.x, topRight.x), Math.max(bottomLeft.x, bottomRight.x));
		var minY = Math.min(Math.min(topLeft.y, topRight.y), Math.min(bottomLeft.y, bottomRight.y));
		var maxY = Math.max(Math.max(topLeft.y, topRight.y), Math.max(bottomLeft.y, bottomRight.y));

		return new Rectangle(minX, minY, (maxX - minX), (maxY - minY));
	}
	
	public static function _RectApplyAffineTransformIn(rect : Rectangle, anAffineTransform : CCAffineTransform) : Rectangle {
		var top = CCGeometry.rectGetMinY(rect);
		var left = CCGeometry.rectGetMinX(rect);
		var right = CCGeometry.rectGetMaxX(rect);
		var bottom = CCGeometry.rectGetMaxY(rect);

		var topLeft = _PointApplyAffineTransform(left, top, anAffineTransform);
		var topRight = _PointApplyAffineTransform(right, top, anAffineTransform);
		var bottomLeft = _PointApplyAffineTransform(left, bottom, anAffineTransform);
		var bottomRight = _PointApplyAffineTransform(right, bottom, anAffineTransform);

		var minX = Math.min(Math.min(topLeft.x, topRight.x), Math.min(bottomLeft.x, bottomRight.x));
		var maxX = Math.max(Math.max(topLeft.x, topRight.x), Math.max(bottomLeft.x, bottomRight.x));
		var minY = Math.min(Math.min(topLeft.y, topRight.y), Math.min(bottomLeft.y, bottomRight.y));
		var maxY = Math.max(Math.max(topLeft.y, topRight.y), Math.max(bottomLeft.y, bottomRight.y));

		rect.x = minX;
		rect.y = minY;
		rect.width = maxX - minX;
		rect.height = maxY - minY;
		return rect;
	}
	
	public static function AffineTransformTranslate(t : CCAffineTransform, tx : Float, ty : Float) : CCAffineTransform {
		return new CCAffineTransform(t.a, t.b, t.c, t.d, t.tx + t.a * tx + t.c * ty, t.ty + t.b * tx + t.d * ty);
	}
	
	public static function AffineTransformScale(t : CCAffineTransform, sx : Float, sy : Float) : CCAffineTransform {
		return new CCAffineTransform(t.a * sx, t.b * sx, t.c * sy, t.d * sy, t.tx, t.ty);
	}
	
	public static function AffineTransformRotate(aTransform : CCAffineTransform, anAngle : Float) : CCAffineTransform {
		var fSin = Math.sin(anAngle);
		var fCos = Math.cos(anAngle);

		return new CCAffineTransform(aTransform.a * fCos + aTransform.c * fSin,
			aTransform.b * fCos + aTransform.d * fSin,
			aTransform.c * fCos - aTransform.a * fSin,
			aTransform.d * fCos - aTransform.b * fSin,
			aTransform.tx,
			aTransform.ty);
	}
	
	public static function AffineTransformConcat(t1 : CCAffineTransform, t2 : CCAffineTransform) : CCAffineTransform {
		return new CCAffineTransform(t1.a * t2.a + t1.b * t2.c,                          //a
				t1.a * t2.b + t1.b * t2.d,                               //b
				t1.c * t2.a + t1.d * t2.c,                               //c
				t1.c * t2.b + t1.d * t2.d,                               //d
				t1.tx * t2.a + t1.ty * t2.c + t2.tx,                    //tx
				t1.tx * t2.b + t1.ty * t2.d + t2.ty);				    //ty
	}
	
	public static function AffineTransformEqualToTransform(t1 : CCAffineTransform, t2 : CCAffineTransform) : Bool {
		return ((t1.a == t2.a) && (t1.b == t2.b) && (t1.c == t2.c) && (t1.d == t2.d) && (t1.tx == t2.tx) && (t1.ty == t2.ty));
	}
	
	public static function AffineTransformInvert(t : CCAffineTransform) : CCAffineTransform {
		var determinant : Float = 1 / (t.a * t.d - t.b * t.c);
		return new CCAffineTransform(determinant * t.d, -determinant * t.b, -determinant * t.c, determinant * t.a,
			determinant * (t.c * t.ty - t.d * t.tx), determinant * (t.b * t.tx - t.a * t.ty));
	}
}