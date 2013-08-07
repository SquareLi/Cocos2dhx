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
package cc.layersscenestransitionsnodes;
import cc.basenodes.CCNode;
import cc.cocoa.CCGeometry;
import cc.platform.CCTypes;
import flambe.display.FillSprite;
import cc.CCDirector;
import cc.CCComponent;

/**
 * ...
 * @author Ang Li
 */

class CCLayerColor extends CCLayer
{
	var _color : CCColor3B;
	var _opacity : Float;
	var _colorSprite : FillSprite;
	public function new() 
	{
		super();
		this._color = new CCColor3B(0, 0, 0);
		_opacity = 0.0;
	}
	
	public function getOpacity() : Float {
		return this._opacity;
	}
	
	public function setOpacity(v : Float) {
		this._opacity = v;
		this.sprite.alpha._ = v;
	}
	
	public function getColor() : CCColor3B {
		return this._color;
	}
	
	public function setColor(c : CCColor3B) {
		this._color = c;
		//sprite = cast(
	}
	
	public function initLayerColor(?color : CCColor4B, ?width : Float, ?height : Float) : Bool {
		//super.init();
		var winSize = CCDirector.getInstance().getWinSize();
		var w : Float;
		var h : Float;
		var c : CCColor4B;
		if (color == null) {
			c = new CCColor4B(0, 0, 0, 1.0);
			//trace("123");
		} else {
			c = color;
		}
		
		if (width == null) {
			w = winSize.width;
		} else {
			w = width;
		}
		
		if (height == null) {
			h = winSize.height;
		} else {
			h = height;
		}
		
		this._color = new CCColor3B(c.r, c.g, c.b);
		
		this._opacity = c.a;
		
		
		this.setContentSize(new CCSize(w, h));
		//trace(getContentSize().width);
		
		
		
		sprite = new FillSprite(_color.color, this.getContentSize().width, this.getContentSize().height);
		//trace(sprite.getNaturalWidth());
		sprite.setAnchor(this._anchorPoint.x, this._anchorPoint.y)
		.setXY(this._position.x, this._position.y)
		.setScaleXY(this._scaleX, this._scaleY);
		
		//trace(this._opacity);
		sprite.alpha._ = _opacity;
		entity.add(sprite);
		
		this.addComponent();
		return true;
	}
	
	override public function onEnter()
	{
		
		
		
/*		this.sprite.pointerDown.connect(this.onMouseDown);
		this.sprite.pointerMove.connect(this.onMouseMoved);
		this.sprite.pointerUp.connect(this.onMouseUp);*/
		
		
	}
	override public function draw()
	{
		//trace("color draw");
		
		
	}
	
	public static function create(?color : CCColor4B, ?width : Float, ?height : Float) : CCLayerColor {
		var ret = new CCLayerColor();
		
		ret.initLayerColor(color);
		return ret;
	}
	
	
	
}