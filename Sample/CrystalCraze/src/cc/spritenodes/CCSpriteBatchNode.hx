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
import cc.texture.CCTexture2D;
import flambe.display.Sprite;
import cc.texture.CCTextureCache;
/**
 * ...
 * @author Ang Li
 */

 
class CCSpriteBatchNode extends CCNode
{
	//var _offset : Sprite
	public static inline var DEFAULT_SPRITE_BATCH_CAPACITY : Int = 29;
	var _originalTexture : CCTexture2D;
	var _texture : CCTexture2D;
	public function new() 
	{
		super();
	}
	
	public function initBatchNode(fileImage : String, capacity : Int) : Bool{
		var texture2D : CCTexture2D = CCTextureCache.getInstance().addImage(fileImage);
		return this.initWithTexture(texture2D, capacity);
	}
	
	public function initWithTexture(tex : CCTexture2D, capacity : Int) : Bool {
		this._originalTexture = tex;
		_texture = tex;
		
		return true;
	}
	
	public function getTexture() : CCTexture2D {
		return this._texture;
	}
	
	public static function create(fileImage : String, ?capacity : Int) : CCSpriteBatchNode {
		if (capacity == null) {
			capacity = DEFAULT_SPRITE_BATCH_CAPACITY;
		}
		var batchNode : CCSpriteBatchNode  = new CCSpriteBatchNode();
		batchNode.initBatchNode(fileImage, capacity);
		return batchNode;
	}
	
}