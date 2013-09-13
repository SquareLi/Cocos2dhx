package cc.spritenodes;
import cc.layersscenestransitionsnodes.CCTransitionFade;
import cc.texture.CCTexture2D;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.swf.Library;
import flambe.swf.MovieSprite;
import cc.cocoa.CCGeometry;

/**
 * ...
 * @author Ang Li
 */

 //Point pixels to points has not finished
class CCSpriteFrame 
{
	var _offset : Point;
	var _originalSize : CCSize;
	var _rectInPixels : Rectangle;
	var _rotated : Bool;
	var _rect : Rectangle;
	var _offsetInPixels : Point;
	var _originalSizeInPixels : CCSize;
	var _texture : CCTexture2D;
	var _textureFilname : String;
	
	public function new() {
		this._offset = new Point(0, 0);
		this._offsetInPixels = new Point(0, 0);
		this._originalSize = new CCSize(0, 0);
		this._rectInPixels = new Rectangle(0, 0, 0, 0);
		this._rect = new Rectangle(0, 0, 0, 0);
		this._originalSizeInPixels = new CCSize(0, 0);
		this._textureFilname = "";
	}
	
	public function getRectInPixels() : Rectangle {
		return this._rectInPixels;
	}
	
	public function setRectInPixels(rectInPixels : Rectangle) {
		this._rectInPixels = rectInPixels;
		this._rect = rectInPixels;
	}
	
	public function isRotated() : Bool {
		return this._rotated;
	}
	
	public function setRotated(bRotated : Bool) {
		this._rotated = bRotated;
	}
	
	public function getRect() : Rectangle {
		return this._rect;
	}
	
	public function setRect(rect :Rectangle) {
		this._rect = rect;
		this._rectInPixels = rect;
	}
	
	public function getOffsetInPixels() : Point {
		return new Point(this._offsetInPixels.x, this._offsetInPixels.y);
	}
	
	public function setOffsetInPixels(offsetInPixels : Point) {
		this._offsetInPixels = offsetInPixels;
		this._offset = offsetInPixels;
	}
	
	public function getOriginalSizeInPixels() : CCSize {
		return this._originalSizeInPixels;
	}
	
	public function setOriginalSizePixels(sizeInPixels : CCSize) {
		this._originalSizeInPixels = sizeInPixels;
	}
	
	public function getOriginalSize() : CCSize {
		return new CCSize(this._originalSize.width, this._originalSize.height);
	}
	
	public function setOriginalSize(sizeInPixels : CCSize) {
		this._originalSize = sizeInPixels;
	}
	
	public function getTexture() : CCTexture2D {
		if (this._texture != null) {
			return this._texture;
		}
		return null;
		//if (this._textureFilname != "") {
			//return 
		//}
	}
	
	public function setTexture(texture : CCTexture2D) {
		if (this._texture != texture) {
			this._texture = texture;
		}
	}
	
	public function getOffset() : Point {
		return new Point(this._offset.x, this._offset.y);
	}
	
	public function setOffset(offsets : Point) {
		this._offset = offsets;
	}
	
	
	public function copyWithZone() : CCSpriteFrame {
		var copy : CCSpriteFrame = new CCSpriteFrame();
		copy.initWithTextureFilename(this._textureFilname, this._rect, this._rotated, this._offset, this._originalSize);
		copy.setTexture(this._texture);
		return copy;
	}
	
	public function initWithTexture(texture : CCTexture2D, rect : Rectangle, rotated : Bool, offset : Point, originalSize : CCSize) : Bool{
		this._texture = texture;
		this._rectInPixels = rect;
		this._rect = rect;
		this._offsetInPixels = offset;
		this._offset = offset;
		this._originalSizeInPixels = originalSize;
		this._originalSize = originalSize;
		this._rotated = rotated;
		return true;
	}
	
	public function initWithTextureFilename(filename : String, rect : Rectangle, rotated : Bool, offset : Point, originalSize : CCSize) : Bool {
		this._texture = null;
		this._textureFilname = filename;
		this._rectInPixels = rect;
		this._rect = rect;
		this._rotated = rotated;
		this._offsetInPixels = offset;
		this._offset = offset;
		this._originalSize = originalSize;
		this._originalSizeInPixels = originalSize;
		return true;
	}
	
	public function toString() : String {
		var ret : String = _offset.x + "," + _offset.y + "," + isRotated() + "," + _rect.x + "," + _rect.y + "," +  _rect.width + "," + _rect.height;
		return ret;
	}
	/**
	 * <p>
	 *    Create a cc.SpriteFrame with a texture filename, rect, rotated, offset and originalSize in pixels.<br/>
	 *    The originalSize is the size in pixels of the frame before being trimmed.
	 * </p>
	 * @param {string} filename
	 * @param {cc.Rect} rect
	 * @param {Boolean} rotated
	 * @param {cc.Point} offset
	 * @param {cc.Size} originalSize
	 * @return {cc.SpriteFrame}
	 */
	public static function create(filename : String, rect : Rectangle, rotated : Bool, offset : Point, originalSize : CCSize) : CCSpriteFrame {
		var spriteFrame : CCSpriteFrame = new CCSpriteFrame();
		spriteFrame.initWithTextureFilename(filename, rect, rotated, offset, originalSize);
		return spriteFrame;
	}
	 
	/**
	 * Create a cc.SpriteFrame with a texture, rect, rotated, offset and originalSize in pixels.
	 * @param {cc.Texture2D|HTMLImageElement} texture
	 * @param {cc.Rect} rect
	 * @param {Boolean} rotated
	 * @param {cc.Point} offset
	 * @param {cc.Size} originalSize
	 * @return {cc.SpriteFrame}
	 * @example
	 * //Create a cc.SpriteFrame with a texture, rect in texture.
	 * var frame1 = cc.SpriteFrame.createWithTexture("grossini_dance.png",cc.rect(0,0,90,128));
	 *
	 * //Create a cc.SpriteFrame with a texture, rect, rotated, offset and originalSize in pixels.
	 * var frame2 = cc.SpriteFrame.createWithTexture(texture, frameRect, rotated, offset, sourceSize);
	 */
	public static function createWithTexture(texture : CCTexture2D, rect : Rectangle, ?rotated : Bool, ?offset : Point, ?originalSize : CCSize) : CCSpriteFrame {
		var spriteFrame : CCSpriteFrame = new CCSpriteFrame();
		spriteFrame.initWithTexture(texture, rect, rotated, offset, originalSize);
		return spriteFrame;
	}
}