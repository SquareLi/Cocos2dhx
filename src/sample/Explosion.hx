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

package sample;
import cc.spritenodes.CCSprite;
import cc.spritenodes.CCSpriteFrameCache;
import cc.spritenodes.CCSpriteFrame;
import cc.spritenodes.CCAnimationCache;
import cc.spritenodes.CCAnimation;
import cc.action.CCActionInterval;
import cc.action.CCActionInstant;
/**
 * ...
 * @author Ang Li
 */
class Explosion extends CCSprite
{
	var tmpWidth : Float;
	var tmpHeight : Float;
	public function new() 
	{
		super();
		var pFrame = CCSpriteFrameCache.getInstance().getSpriteFrame("explosion_01.png");
		this.initWithSpriteFrame(pFrame);
		
		var cs = this.getContentSize();
		this.tmpHeight = cs.height;
		this.tmpWidth = cs.width;
		
		var animation = CCAnimationCache.getInstance().getAnimation("Explosion");
		this.runAction(CCSequence.create(
			[CCAnimate.create(animation),
			CCCallFunc.create(this.destroy, this)]));
	}
	
	public function destroy() {
		this.getParent().removeChild(this, true);
	}
	
	public static function sharedExplosion() {
		CCSpriteFrameCache.getInstance().addSpriteFrames("Sample/explosion.plist");
		var str : String = "";
		var animFrames : Array<CCSpriteFrame> = new Array<CCSpriteFrame>();
		for (i in 1...35) {
			str = "explosion_" + (i < 10 ? ("0" + Std.string(i)) : Std.string(i)) + ".png";
			var frame : CCSpriteFrame = CCSpriteFrameCache.getInstance().getSpriteFrame(str);
			animFrames.push(frame);
		}
		
		var animation = CCAnimation.createWithAnimationFrames(animFrames, 0.04);
		CCAnimationCache.getInstance().addAnimation(animation, "Explosion");
	}
}