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


package ;

import cc.layersscenestransitionsnodes.CCScene;
import cc.spritenodes.CCAnimation;
import cc.spritenodes.CCSprite;
import cc.spritenodes.CCSpriteFrame;
import cc.spritenodes.CCSpriteFrameCache;
import cc.texture.CCTexture2D;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.Entity;
import flambe.math.Point;
import flambe.System;
import cc.CCDirector;
import cc.action.CCActionInterval;
import cc.CCLoader;
import cc.spritenodes.CCSpriteFrame;

/**
 * ...
 * @author Ang Li
 */

class TestSpriteSheet 
{

	public function new() 
	{
	}
		
	public function test() {
		//1) Cache the sprite frames and texture
		var sharedSpriteFrameCache : CCSpriteFrameCache = CCSpriteFrameCache.getInstance();
		sharedSpriteFrameCache.addSpriteFrames("TestSpriteSheet/sb.plist");
		
		
		//3) Gather the list of frames
		var frames : Array<CCSpriteFrame> = new Array<CCSpriteFrame>();
		
		for (i in 0...15) {
			var n : String = "enemySBAppear00";
			if (i + 1 < 10) {
				n = n + "0" + Std.string(i + 1) + ".png";
			} else {
				n = n + Std.string(i + 1) + ".png";
			}
			//trace(n);
			frames.push(sharedSpriteFrameCache.getSpriteFrame(n));
		}
		
		
		//4) Create the animation object
		
		var animation : CCAnimation = CCAnimation.createWithAnimationFrames(frames, 0.1);
		trace(frames[0].toString());
		var animate : CCAnimate = CCAnimate.create(animation);
		
		//5) Create the sprite and run the animation action
		
		var sprite : CCSprite = CCSprite.createWithSpriteFrameName("enemySBAppear0010.png");
		sprite.runAction(CCSequence.create(
			[CCMoveTo.create(3, new Point(200, 200)), CCMoveTo.create(2, new Point(50, 50))]));
		
		var d : CCDirector = CCDirector.getInstance();
		var s : CCScene = new CCScene();
		s.addChild(sprite);
		d.runWithScene(s);
	}
	
}