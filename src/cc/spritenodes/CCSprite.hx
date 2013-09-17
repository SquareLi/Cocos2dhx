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

package cc.spritenodes;
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.support.CCPointExtension;
import cc.texture.CCTexture2D;
import flambe.asset.AssetPack;
import flambe.display.BlendMode;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.cocoa.CCGeometry;
import cc.platform.CCTypes;
import cc.platform.CCMacro;
import flambe.swf.MovieSprite;
import cc.CCLoader;
import cc.texture.CCTextureCache;
/**
 * ...
 * @author Ang Li
 */

class CCSprite extends CCNode
{
	var RGBAProtocol : Bool = true;
	//var _textureAtlas : CCTextureAtlas;
	var _atlasIndex : Int = 0;
	var _batchNode : CCSpriteBatchNode;
	var _dirty : Bool;
	var _recursiveDirty : Bool;
	var _hasChildren : Bool;
	var _shouldBeHidden : Bool;
	var _transformToBatch : Dynamic;
	
	var _opacity : Int = 255;
	
	//Data used when the sprite is self-rendered
	var _blendFunc : BlendMode;
	var _texture : CCTexture2D;
	var _color : CCColor3B;
	var _colorized : Bool = false;
	
	//Texture
	var _rect : Rectangle; //Flambe has a good Rectangel class, so I do not create a new one for CC
	var _rectRotated : Bool;
	
	//Offset Position
	var _offsetPosition : Point;
	var _unflippedOffsetPositionFromCenter : Point;
	
	//vertex coords, texture coords and color info
	var _quad : CCV3F_C4B_T2F_Quad;
	
	// opacity and RGB protocol
    var _colorUnmodified : CCColor3B;
    var _opacityModifyRGB : Bool;
	
	// image is flipped
    var _flipX : Bool;
    var _flipY : Bool;
	
	//Flambe
	
	
	var _isLighterMode : Bool = false;
	public function new() 
	{
		super();
		this._color = CCColor3B.white();
		_offsetPosition = new Point(0, 0);
		_unflippedOffsetPositionFromCenter = CCGeometry.p(0, 0);
		this._shouldBeHidden = false;
		

	}
	
	public function isDirty() : Bool {
		return this._dirty;
	}
	
	public function setDirty(bDirty : Bool) {
		this._dirty = bDirty;
	}
	
	public function getQuad() : CCV3F_C4B_T2F_Quad {
		return this._quad;
	}
	
	public function isTextureRectRotated() : Bool {
		return this._rectRotated;
	}
	
	public function getAtlasIndex() : Int {
		return this._atlasIndex;
	}
	
	public function setAtlasIndex(atlasIndex : Int) {
		this._atlasIndex = atlasIndex;
	}
	
	public function getTextureRect() : Rectangle {
		return new Rectangle(this._rect.x, this._rect.y, this._rect.width, this._rect.height);
	}
	
	//public function setTextureAtlas(textureAtlas : CCTextureAtlas) {
		//this._textureAtlas = textureAtlas;
	//}
	//
	//public function getTextureAtlas() : CCTextureAtlas {
		//return this._textureAtlas;
	//}
	public function getSpriteBatchNode() : CCSpriteBatchNode {
		return this._batchNode;
	}
	
	public function setSpriteBatchNode(spriteBatchNode : CCSpriteBatchNode) {
		this._batchNode = spriteBatchNode;
	}
	
	public function getOffsetPosition() : Point {
		return new Point(this._offsetPosition.x, this._offsetPosition.y);
	}
	
	public function getBlendFunc() : BlendMode {
		return this._blendFunc;
	}
	
	public function setBlendFunc(blend : BlendMode) {
		//this._blendFunc = new CCBlendFunc(src, dst);
	   //this._isLighterMode = (this._blendFunc && (this._blendFunc.src == gl.SRC_ALPHA) && (this._blendFunc.dst == gl.ONE));
	
		this._blendFunc = blend;
		this.sprite.blendMode = blend;
	}
	
	override public function getOpacity() : Int {
		return this._opacity;
	}
	
	override public function setOpacity(opacity : Int) {
		this._opacity = opacity;
		this.sprite.alpha._ = opacity / 255;
	}
	
	//override public function setPosition(pos : Point) {
		//super.setPosition(pos.x, pos.y);
	//}
	
	override public function init():Bool 
	{
		//trace("init");
		super.init();
		this._dirty = this._recursiveDirty = false;
		
		this._opacityModifyRGB = true;
		this._opacity = 1;
		this._color = CCTypes.white();
		this._colorUnmodified = CCTypes.white();
		
		//this._blendFunc = new CCBlendFunc(0, 0);
		//this._blendFunc.src = CCMacro.BLEND_SRC;
		//this._blendFunc.dst = CCMacro.BLEND_DST;
		
		//this.setTexture(null);
		
		this._flipX = this._flipY = false;
		
		this.setAnchorPoint(new Point(0, 0));
		
		this._offsetPosition = new Point(0, 0);
		this._hasChildren = false;
		
		var tmpColor = new CCColor4B(255, 255, 255, 1);
		
		this._quad = CCTypes.V3F_C4B_T2F_QuadZero();
		this._quad.bl.colors = tmpColor;
		this._quad.br.colors = tmpColor;
		this._quad.tl.colors = tmpColor;
		this._quad.tr.colors = tmpColor;
		
		this.setTextureRect(CCGeometry.rectZero(), false, CCGeometry.sizeZero());
		
		
		
		
		return true;
	}
	
	var _isAdded : Bool = false;
	public function initWithTexture(texture : CCTexture2D, ?rect : Rectangle, ?rotated : Bool) : Bool {
		if (rotated == null) {
			rotated = false;
		}
		
		if (rect == null) {
			rect = new Rectangle(0, 0, 0, 0);
			rect.width = texture.getPixelsWide();
			rect.height = texture.getPixelsHigh();
			this.sprite = new ImageSprite(texture.getTexture());
			this._contentSize = new CCSize(sprite.getNaturalWidth(), sprite.getNaturalHeight());
			this.entity.add(sprite);
		
			this.component = new CCComponent(this);
			this.entity.add(component);
		} else {
			this.sprite = new CCSpriteSheet();
			var s : CCSpriteSheet = cast (this.sprite, CCSpriteSheet);
			var f : CCSpriteFrame = CCSpriteFrame.createWithTexture(texture, rect, rotated, _position, new CCSize());
			s.updateFrame(f);
			this.entity.add(s);
			this.component = new CCComponent(this);
			this.entity.add(component);
			
			this._contentSize = new CCSize(rect.width, rect.height);
			
			this._isAdded = true;
			//trace(f.toString());
		}
		
		this.setTexture(texture);
		this.setTextureRect(rect, rotated, new CCSize(rect.width, rect.height));
		return true;
	}
	
	public function initWithFile(fileName : String, ?rect : Rectangle) {
		
		var pack = CCLoader.pack;
		var t = pack.getTexture(fileName);
		
		var texture : CCTexture2D = CCTextureCache.getInstance().addImage(fileName);
		
		if (rect == null) {
			this.sprite = new ImageSprite(t);
			this._contentSize = new CCSize(sprite.getNaturalWidth(), sprite.getNaturalHeight());
			this.entity.add(sprite);
			this.component = new CCComponent(this);
			this.entity.add(component);
		} else {
			this.initWithTexture(texture, rect);
		}
		
		
		
	}
	
	public function initWithSpriteFrame(spriteFrame : CCSpriteFrame) : Bool {
		_position.x = spriteFrame.getOffset().x;
		_position.y = spriteFrame.getOffset().y;
		var ret : Bool = this.initWithTexture(spriteFrame.getTexture(), spriteFrame.getRect(), spriteFrame.isRotated());
		//_position.x = spriteFrame.getOffset().x;
		
		return ret;
	}
	
	public function initWithSpriteFrameName(spriteFrameName : String) : Bool {
		var frame = CCSpriteFrameCache.getInstance().getSpriteFrame(spriteFrameName);
		return this.initWithSpriteFrame(frame);
	}
	public function setTextureRect(rect : Rectangle, ?rotated : Bool, ?untrimmedSize : CCSize) {
		//thi
		//if (rotated == null) {
			//this._rectRotated = false;
		//} else {
			//this._rectRotated = rotated;
		//}
		//
		//if (untrimmedSize == null) {
			//this.setContentSize(new CCSize(rect.width, rect.height));
		//} else {
			//this.setContentSize(untrimmedSize);
		//}
		
		//this.setVertexRect(rect);
		//this._setTextureCoords(rect);
		
		//var relativeOffset = this._unflippedOffsetPositionFromCenter;
		//
		//this._offsetPosition.x = relativeOffset.x + (this._contentSize.width - this._rect.width) / 2;
        //this._offsetPosition.y = relativeOffset.y + (this._contentSize.height - this._rect.height) / 2;
		//
		//if (this._batchNode != null) {
			//this._dirty = true;
		//} else {
			// Atlas: Vertex
            //var x1 = 0 + this._offsetPosition.x;
            //var y1 = 0 + this._offsetPosition.y;
            //var x2 = x1 + this._rect.width;
            //var y2 = y1 + this._rect.height;
//
            // Don't update Z.
			//
            //this._quad.bl.vertices = new CCVertex3F(x1, y1, 0);
            //this._quad.br.vertices = new CCVertex3F(x2, y1, 0);
            //this._quad.tl.vertices = new CCVertex3F(x1, y2, 0);
            //this._quad.tr.vertices = new CCVertex3F(x2, y2, 0);
		//}
	}
	
	public function setVertexRect(rect : Rectangle) {
		this._rect = rect;
	}
	
	
	public function _setTextureCoords(rect : Rectangle) {
		//if (cc.renderContextType == cc.WEBGL) 
	}
	
	// BatchNode methods
    /**
     * updates the quad according the the rotation, position, scale values.
     */
	public function updateTransform() {
		
	}
	
	override public function draw()
	{
		
	}
	
	public function setTexture(texture : CCTexture2D) {
		this._texture = texture;
	}
	
	public function setDisplayFrame(newFrame : CCSpriteFrame) {
		if (Std.is(this.sprite, CCSpriteSheet)) {
			var s : CCSpriteSheet = cast (this.sprite, CCSpriteSheet);
			s.updateFrame(newFrame);
			
		} else {
			//trace(this.sprite.x._);
			var x = this.sprite.x._;
			var y = this.sprite.y._;
			var scaleX = this.sprite.scaleX._;
			var scaleY = this.sprite.scaleY._;
			var anchorX = this._anchorPoint.x;
			var anchorY = this._anchorPoint.y;
			//trace(anchorX);
			
			this.sprite = new CCSpriteSheet();
			
			
			
			
			
			var s : CCSpriteSheet = cast (this.sprite, CCSpriteSheet);
			s.updateFrame(newFrame);
			this.setAnchorPoint(new Point(anchorX, anchorY));
			this.setPosition(x, y);
			this.setScale(scaleX, scaleY);
			if (!_isAdded) {
				this.entity.add(s);
				this.component = new CCComponent(this);
				this.entity.add(component);
				
				this._contentSize = new CCSize(newFrame.getRect().width, newFrame.getRect().height);
				
				_isAdded = true;
			}
		}
		
		this._rectRotated = newFrame.isRotated();
		var pNewTexture = newFrame.getTexture();
		if (pNewTexture != this._texture) {
			this.setTexture(pNewTexture);
		}
		this.setTextureRect(newFrame.getRect(), this._rectRotated, newFrame.getOriginalSize());
		
	}
	
	public function displayFrame() : CCSpriteFrame{
		if (Std.is(this.sprite, CCSpriteSheet)) {
			var s : CCSpriteSheet = cast(this.sprite, CCSpriteSheet);
			return s.getCurrentFrame();
		}
		return null;
	}
	
	public static function createWithTexture(texture : CCTexture2D, ?rect : Rectangle) : CCSprite {
		var sprite : CCSprite = new CCSprite();
		if (rect == null) {
			sprite.initWithTexture(texture);
		} else {
			sprite.initWithTexture(texture, rect);
		}
		
		return sprite;
	}
	
	
	public static function create(?fileName : String, ?rect : Rectangle) : CCSprite {
		var sprite : CCSprite= new CCSprite();
		
		if (fileName == null) {
			if (sprite.init()) {
				return sprite;
			}
		} else if (rect == null) {
			sprite.init();
			sprite.initWithFile(fileName);
		} else {
			sprite.init();
			sprite.initWithFile(fileName, rect);
		}
		
		
		
		return sprite;
		
		
	}
	
	override public function update(dt:Float)
	{
		super.update(dt);
		//this.getActionManager()
	}
	public static function createWithSpriteFrameName(spriteFrameName : String) : CCSprite {
		var ret : CCSprite = new CCSprite();
		var spriteFrame : CCSpriteFrame;
		spriteFrame = CCSpriteFrameCache.getInstance().getSpriteFrame(spriteFrameName);
		//trace(spriteFrame.toString());
		
		ret.initWithSpriteFrame(spriteFrame);
		return ret;
	}
	
	public static function createWithSpriteFrame(spriteFrame : CCSpriteFrame) : CCSprite {
		var ret = new CCSprite();
		if (Sprite != null && ret.initWithSpriteFrame(spriteFrame)) {
			return ret;
		}
		return null;
	}
}