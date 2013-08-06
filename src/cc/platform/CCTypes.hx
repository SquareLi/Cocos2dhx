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

package cc.platform;
import flambe.display.FillSprite;

/**
 * ...
 * @author Ang Li
 */
class CCTypes {
	/**
	 * text alignment : left
	 * @constant
	 * @type Number
	 */
	
	public static var TEXT_ALIGNMENT_LEFT : Int = 0;
	/**
	 * text alignment : center
	 * @constant
	 * @type Number
	 */
	
	public static var TEXT_ALIGNMENT_CENTER : Int = 1;
	/**
	 * text alignment : right
	 * @constant
	 * @type Number
	 */
	public static var TEXT_ALIGNMENT_RIGHT : Int = 2;

	/**
	 * text alignment : top
	 * @constant
	 * @type Number
	 */
	public static var VERTICAL_TEXT_ALIGNMENT_TOP : Int = 0;

	/**
	 * text alignment : center
	 * @constant
	 * @type Number
	 */
	public static var VERTICAL_TEXT_ALIGNMENT_CENTER : Int = 1;

	/**
	 * text alignment : bottom
	 * @constant
	 * @type Number
	 */
	public static var VERTICAL_TEXT_ALIGNMENT_BOTTOM : Int = 2;

	
	public static function c3b(r : Int, g : Int, b : Int) : CCColor3B {
		return new CCColor3B(r, g, b);
	}
	
	public static function white() {
		return new CCColor3B(255, 255, 255);
	}
	//public static function integerToColor3B(color : Int)
	
	public static function  c4b(r : Int, g : Int, b : Int, a : Float) : CCColor4B{
		return new CCColor4B(r, g, b, a);
	}
	
	/*public static function  c4f(color : Int, a : Float) : CCColor4F{
		return new CCColor4F(color, a);
	}*/
	
	public static function vertex3(x : Float, y: Float, z : Float) : CCVertex3F {
		return new CCVertex3F(x , y , z);
	}
	
	public static function text2(u : Float, v : Float) {
		return new CCTex2F(u, v);
	}
	
	public static function g(x : Float, y : Float) {
		return new CCGridSize(x, y);
	}
	
	public static function V2F_C4B_T2F_QuadZero() : CCV2F_C4B_T2F_Quad {
		return new CCV2F_C4B_T2F_Quad(
			new CCV2F_C4B_T2F(new CCVertex2F(0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0)),
			new CCV2F_C4B_T2F(new CCVertex2F(0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0)),
			new CCV2F_C4B_T2F(new CCVertex2F(0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0)),
			new CCV2F_C4B_T2F(new CCVertex2F(0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0))
		);
	}
	
	public static function V3F_C4B_T2F_QuadZero() : CCV3F_C4B_T2F_Quad {
		return new CCV3F_C4B_T2F_Quad(
			new CCV3F_C4B_T2F(new CCVertex3F(0, 0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0)),
			new CCV3F_C4B_T2F(new CCVertex3F(0, 0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0)),
			new CCV3F_C4B_T2F(new CCVertex3F(0, 0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0)),
			new CCV3F_C4B_T2F(new CCVertex3F(0, 0, 0), new CCColor4B(0, 0, 0, 1), new CCTex2F(0, 0))
		);
	}
	
	public static function convertHexNumToColor3B(clrSt : String) : CCColor3B {

		var nAr = clrSt.substr(1).split("");
		var r : Int = Std.parseInt("0x" + nAr[0] + nAr[1]);
		var g : Int = Std.parseInt("0x" + nAr[2] + nAr[3]);
		var b : Int = Std.parseInt("0x" + nAr[4] + nAr[5]);
		
		return new CCColor3B(r, g, b);
	}
	
	public static function convertColor3BtoHexString(clr : CCColor3B) : String {
		var ret = (clr.r & 0xFF) << 16 | (clr.g & 0xFF) << 8 | (clr.b & 0xFF);
		
		var s = StringTools.hex(ret);
		return "0x" + s;
	}
}

class CCColor3B 
{
	public var r : Int;
	public var g : Int;
	public var b : Int;
	
	public var color : Int;
	public function new(r : Int, g : Int, b : Int) 
	{
		this.r = r;
		this.g = g;
		this.b = b;
		
		color = Std.parseInt(CCTypes.convertColor3BtoHexString(this));
	}

	public static function white() : CCColor3B {
		return new CCColor3B(255, 255, 255); 
	}
	
	public static function yellow() : CCColor3B {
		return new CCColor3B(255, 255, 0);
	}
	
	public static function blue() : CCColor3B {
		return new CCColor3B(0, 0, 255);
	}
	
	public static function green() : CCColor3B {
		return new CCColor3B(0, 255, 0);
	}
	
	public static function red() : CCColor3B {
		return new CCColor3B(255, 0, 0);
	}
	
	public static function magenta() : CCColor3B {
		return new CCColor3B(255, 0, 255);
	}
	
	public static function black() : CCColor3B {
		return new CCColor3B(0, 0, 0);
	}
	
	public static function orange() : CCColor3B {
		return new CCColor3B(255, 127, 0);
	}
	
	public static function gray() : CCColor3B {
		return new CCColor3B(166, 166, 166);
	}
}

class CCColor4B 
{
	public var r : Int;
	public var g : Int;
	public var b : Int;
	public var a : Float;
	public var color : Int;
	public function new(r : Int, g : Int, b : Int, alpha : Float) 
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = alpha;
		
		color = Std.parseInt(CCTypes.convertColor3BtoHexString(new CCColor3B(r, g, b)));
	}
}

/*class CCColor4F 
{
	public var _color : Int;
	var _alpha : Float;
	public function new(color : Int, a : Float) {
		this._color = color;
		this._alpha = a;
	}
}*/

class CCVertex2F 
{
	public var x : Float;
	public var y : Float;
	public function new(x1 : Float, y1 : Float) 
	{
		x = x1;
		y = y1;
	}
}

class CCVertex3F 
{
	public var x : Float;
	public var y : Float;
	public var z : Float;
	public function new(x1 : Float, y1 : Float, z1 : Float) 
	{
		x = x1;
		y = y1;
		z = z1;
	}
	
}

class CCTex2F 
{
	public var u : Float;
	public var v : Float;
	public function new(u1 : Float, v1 : Float) 
	{
		this.u = u1;
		this.v = v1;
	}
}

class CCPointSprite
{
	public var pos : CCVertex2F;
	public var color : CCColor4B;
	public var size : Float;
	public function new(pos1 : CCVertex2F, color1 : CCColor4B, size1 : Float) {
		this.pos = pos1;
		this.color = color1;
		this.size = size1;
	}
}

class CCQuad2
{
	public var tl : CCVertex2F;
	public var tr : CCVertex2F;
	public var bl : CCVertex2F;
	public var br : CCVertex2F;
	
	public function new (tl1 : CCVertex2F, tr1 : CCVertex2F, bl1 : CCVertex2F, br1 : CCVertex2F) {
		this.tl = tl1;
		this.tr = tr1;
		this.bl = bl1;
		this.br = br1;
	}
}

class CCQuad3
{
	public var tl : CCVertex3F;
	public var tr : CCVertex3F;
	public var bl : CCVertex3F;
	public var br : CCVertex3F;
	
	public function new (tl1 : CCVertex3F, tr1 : CCVertex3F, bl1 : CCVertex3F, br1 : CCVertex3F) {
		this.tl = tl1;
		this.tr = tr1;
		this.bl = bl1;
		this.br = br1;
	}
}

class CCGridSize
{
	public var x : Float;
	public var y : Float;
	public function new(x1 : Float, y1 : Float) {
		x = x1;
		y = y1;
	}
}

class CCV2F_C4B_T2F 
{
	public var vertices : CCVertex2F;
	public var colors : CCColor4B;
	public var texCoords : CCTex2F;
	public function new(vertices1 : CCVertex2F, colors1 : CCColor4B, texCoords1 : CCTex2F) 
	{
		vertices = vertices1;
		this.colors = colors1;
		this.texCoords = texCoords1;
	}
}

class CCV3F_C4B_T2F
{
	public var vertices : CCVertex3F;
	public var colors : CCColor4B;
	public var texCoords : CCTex2F;
	public function new(vertices1 : CCVertex3F, colors1 : CCColor4B, texCoords1 : CCTex2F) 
	{
		vertices = vertices1;
		this.colors = colors1;
		this.texCoords = texCoords1;
	}
}

class CCV2F_C4B_T2F_Quad
{
	public var bl : CCV2F_C4B_T2F;
	public var br : CCV2F_C4B_T2F;
	public var tl : CCV2F_C4B_T2F;
	public var tr : CCV2F_C4B_T2F;
	
	public function new (bl1 : CCV2F_C4B_T2F, br1 : CCV2F_C4B_T2F, tl1 : CCV2F_C4B_T2F, tr1 : CCV2F_C4B_T2F) {
		this.bl = bl1;
		this.br = br1;
		this.tl = tl1;
		this.tr = tr1;
	}
}

class CCV3F_C4B_T2F_Quad
{
	public var bl : CCV3F_C4B_T2F;
	public var br : CCV3F_C4B_T2F;
	public var tl : CCV3F_C4B_T2F;
	public var tr : CCV3F_C4B_T2F;
	
	public function new (bl1 : CCV3F_C4B_T2F, br1 : CCV3F_C4B_T2F, tl1 : CCV3F_C4B_T2F, tr1 : CCV3F_C4B_T2F) {
		this.bl = bl1;
		this.br = br1;
		this.tl = tl1;
		this.tr = tr1;
	}
}

class CCBlendFunc
{
	public var src : Float;
	public var dst : Float;
	public function new(src1 : Float, dst1 : Float) {
		this.src = src1;
		this.dst = dst1;
	}
}