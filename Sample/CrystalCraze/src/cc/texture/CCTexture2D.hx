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

package cc.texture;
import cc.cocoa.CCGeometry;
import cc.platform.CCTypes;
import flambe.display.TextSprite;
import flambe.display.Texture;
import cc.platform.CCMacro;

/**
 * ...
 * @author Ang Li
 */

class CCTexture2D 
{
	var _texture : Texture;
	var _name : String;
	var _contentSize : CCSize;
	var _pixelFormat : Int;
	var _pixelsWide : Float;
	var _pixelsHigh : Float;
	var _maxS : Float;
	var _maxT : Float;
	var _hasPremultipliedAlpha : Bool;
	public function new() 
	{
		_contentSize = new CCSize();
	}
	
	public function getTexture() : Texture {
		return this._texture;
	}
	
	public function setTexture(t : Texture) {
		this._texture = t;
		this._contentSize.width = Std.parseFloat(Std.string(this._texture.width));
		this._contentSize.height = Std.parseFloat(Std.string(this._texture.height));
	}
	public function getPixelsWide() : Float {
		return _texture.width;
	}
	
	public function getPixelsHigh() : Float {
		return _texture.height;
	}
	
	public function getName() : String {
		return this._name;
	}
	
	public function getContentSize() : CCSize {
		var ret = new CCSize(0, 0);
		ret.width = this._contentSize.width;
		ret.height = this._contentSize.height;
		return ret;
	}
	public function getContentSizeInPixels() : CCSize {
		var ret = new CCSize(0, 0);
		ret.width = this._contentSize.width / CCMacro.CONTENT_SCALE_FACTOR();
		ret.height = this._contentSize.height / CCMacro.CONTENT_SCALE_FACTOR();
		
		return ret;
	}
	
	public function getMaxS() : Float {
		return this._maxS;
	}
	
	public function setMaxS(maxS : Float){
		this._maxS = maxS;
	}
	
		public function getMaxT() : Float {
		return this._maxT;
	}
	
	public function setMaxT(maxT : Float){
		this._maxT = maxT;
	}
	
	public function getHasPremultipliedAlpha() : Bool {
		return this._hasPremultipliedAlpha;
	}
	
	public function description() : String {
		var ret = "<CCTexture2D | Name = " + this._name + " | Dimensions = " + Std.string(this._pixelsWide) + " x " + Std.string(this._pixelsHigh)
		    + " | Coordinates = (" + Std.string(this._maxS) + ", " + Std.string(this._maxT) + ")>";
		return ret;
	}
	
	public function initWithData(pixelFormat : Int, pixelsWide : Float, pixelsHigh : Float, contentSize : CCSize) : Bool{
		this._contentSize = contentSize;
		this._pixelsWide = pixelsWide;
		this._pixelsHigh = pixelsHigh;
		this._maxS = contentSize.width / pixelsWide;
		this._maxT = contentSize.width / pixelsHigh;
		
		this._hasPremultipliedAlpha = false;
		return true;
	}
}