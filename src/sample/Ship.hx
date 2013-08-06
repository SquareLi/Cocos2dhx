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
import cc.basenodes.CCNode;
import cc.spritenodes.CCAnimation;
import cc.spritenodes.CCSprite;
import cc.spritenodes.CCSpriteFrame;
import cc.texture.CCTexture2D;
import cc.texture.CCTextureCache;
import flambe.math.Point;
import flambe.math.Rectangle;
import sample.config.GameConfig;
import cc.cocoa.CCGeometry;
import cc.action.CCActionInterval;
import sample.config.GameConfig;
/**
 * ...
 * @author Ang Li
 */
class Ship extends CCSprite
{
	public var speed : Float = 220;
	public var bulletSpeed : Float = 900;
	public var hp : Float = 1000;
	public var bulletTypeValue : Int = 1;
	public var bulletPowerValue : Int = 1;
	public var throwBombing : Bool = false;
	public var canBeAttack : Bool = true;
	public var zOrder : Int = 3000;
	public var maxBulletPowerValue : Int = 4;
	public var appearPosition : Point;
	var _hurtColorLife : Int = 0;
	public var active : Bool;
	var _ship : CCSprite;
	public function new() 
	{
		super();
		//init life
		this.appearPosition = new Point(160, 40);
		var shipTexture : CCTexture2D = CCTextureCache.getInstance().addImage("Sample/ship01");
		this.initWithTexture(shipTexture, new Rectangle(0, 0, 60, 38));
		this.setPosition(this.appearPosition.x, this.appearPosition.y);
		this.active = true;
		
		//set frame
		var frame0 : CCSpriteFrame = CCSpriteFrame.createWithTexture(shipTexture, new Rectangle(0, 0, 60, 38), false, new Point(0, 0), new CCSize());
		var frame1 : CCSpriteFrame = CCSpriteFrame.createWithTexture(shipTexture, new Rectangle(60, 0, 60, 38), false, new Point(0, 0), new CCSize());
		
		var animFrames : Array<CCSpriteFrame> = new Array<CCSpriteFrame>();
		animFrames.push(frame0);
		animFrames.push(frame1);
		
		//ship animate
		var animation : CCAnimation = CCAnimation.createWithAnimationFrames(animFrames, 0.1);
		var animate : CCAnimate = CCAnimate.create(animation);
		//this.runAction(animate);
		this.runAction(CCRepeatForever.create(animate));
		this.schedule(shoot, 1 / 6);
		
		//revive effect
		//this.canBeAttack = false;
		//var ghostSprite : CCSprite = CCSprite.createWithTexture(shipTexture, new Rectangle(0, 45, 60, 38));
		//ghostSprite.setScale(8);
		//ghostSprite.setPosition(this.getContentSize().width / 2, 12);
		//this.addChild(ghostSprite, 3000, 99999);
		//ghostSprite.runAction(CCScaleTo.create(0.5, 1, 1));
	}
	
	var _bulletTimer : Float = 0;
	
	override public function update(dt:Float) 
	{
		super.update(dt);
		
		if (this.hp <= 0) {
			this.active = false;
		}
		
		
	}
	
	public function shoot() {
		var offset : Float = 13;
		var cs : CCSize = this.getContentSize();
		var a : Bullet = new Bullet(bulletSpeed, "W1.png", ENEMY_ATTACK_MODE.NORMAL);
		
		var p : Point = this.getPosition();
		GameConfig.PLAYER_BULLETS.push(a);
		
		
		a.setPosition(p.x + offset, p.y + 3 + this.getContentSize().height * 0.3);
		//
		//
		this.getParent().addChild(a);
		//
		//
		var b : Bullet = new Bullet(bulletSpeed, "W1.png", ENEMY_ATTACK_MODE.NORMAL);
		b.setPosition(p.x + 3 * offset, p.y + 3 + this.getContentSize().height * 0.3);
		this.getParent().addChild(b);
		GameConfig.PLAYER_BULLETS.push(b);
	}
	
	public function destroy() {
		GameConfig.LIFE--;
		var p : Point = this.getPosition();
		var myParent : CCNode = this.getParent();
		//myParent.addChild(
	}
	
	public function hurt() {
		if (this.canBeAttack) {
			this.hp--;
		}
	}
	
	public function collideRect() : Rectangle {
		var p : Point = this.getPosition();
		var a : CCSize = this.getContentSize();
		var r : Rectangle = new Rectangle(p.x, p.y, a.width, a.height);
		return r;
	}
}