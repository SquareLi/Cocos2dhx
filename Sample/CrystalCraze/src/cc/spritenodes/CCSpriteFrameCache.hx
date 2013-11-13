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
import cc.texture.CCTexture2D;
import flambe.asset.AssetPack;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.swf.Library;
import flambe.swf.MovieSprite;
import flambe.swf.MoviePlayer;
import cc.CCLoader;
import cc.platform.CCPlistEntry;
import cc.platform.CCFileUtils;
import cc.cocoa.CCGeometry;

/**
 * ...
 * @author
 */

class CCSpriteFrameCache 
{
	var _spriteFrames : Map<String, CCSpriteFrame>;
	private static var s_sharedSpriteFrameCache : CCSpriteFrameCache;
	
	private function new() {
		this._spriteFrames = new Map<String, CCSpriteFrame>();
		
	}
	
	private function _addSpriteFramesWithDictionary(dict : Array<CCPlistEntry>, texture : CCTexture2D) {
		for (p in dict) {
			var rect : Rectangle = new Rectangle(p.x, p.y, p.width, p.height);
			var rotated : Bool = p.rotated;
			var offset : Point = new Point(p.sourceColorX, p.sourceColorY);
			var size : CCSize = new CCSize(0, 0);
			var frame : CCSpriteFrame = 
			CCSpriteFrame.createWithTexture(texture, rect, rotated, offset, size);
			this._spriteFrames.set(p.name, frame);
			//trace(p.name, p.toString());
		}
	}
	
	/**
     * <p>
     *   Adds multiple Sprite Frames from a plist file.<br/>
     *   A texture will be loaded automatically. The texture name will composed by replacing the .plist suffix with .png<br/>
     *   If you want to use another texture, you should use the addSpriteFrames:texture method.<br/>
     * </p>
     * @param {String} plist plist filename
     * @param {HTMLImageElement|cc.Texture2D} texture
     * @example
     * // add SpriteFrames to SpriteFrameCache With File
     * cc.SpriteFrameCache.getInstance().addSpriteFrames(s_grossiniPlist);
     */
	public function addSpriteFrames(plist : String, ?texture : CCTexture2D) {
		var dict : Array<CCPlistEntry> = CCFileUtils.getInstance().dictionaryWithContentsOfFile(plist);
		var t : CCTexture2D = new CCTexture2D();
		if (texture == null) {
			var name : String = plist.split(".pli")[0];
			
			t.setTexture(CCLoader.pack.getTexture(name));
			texture = t;
			//trace(t.getTexture().height);
			
		}
		
		this._addSpriteFramesWithDictionary(dict, t);
		
	}
	
	public function addSpriteFrame(frame : CCSpriteFrame, frameName : String) {
		this._spriteFrames.set(frameName, frame);
	}
	
	public function removeSpriteFrames() {
		this._spriteFrames = null;
	}
	
	public function removeSpriteFrameByName(name : String) {
		if (name == null) {
			return;
		}
		
		if (this._spriteFrames.exists(name)) {
			this._spriteFrames.remove(name);
		}
	}
	
	/**
     * <p>
     *   Returns an Sprite Frame that was previously added.<br/>
     *   If the name is not found it will return nil.<br/>
     *   You should retain the returned copy if you are going to use it.<br/>
     * </p>
     * @param {String} name name of SpriteFrame
     * @return {cc.SpriteFrame}
     * @example
     * //get a SpriteFrame by name
     * var frame = cc.SpriteFrameCache.getInstance().getSpriteFrame("grossini_dance_01.png");
     */
	public function getSpriteFrame(name : String) : CCSpriteFrame {
		if (this._spriteFrames.exists(name)) {
			return this._spriteFrames.get(name);
		} else {
			return null;
		}
	}
	
	public static function getInstance() : CCSpriteFrameCache {
		if (s_sharedSpriteFrameCache == null) {
			s_sharedSpriteFrameCache = new CCSpriteFrameCache();
		}
		
		return s_sharedSpriteFrameCache;
	}
}