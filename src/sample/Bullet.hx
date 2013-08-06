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
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.math.Rectangle;
import sample.config.GameConfig;
import cc.spritenodes.CCSpriteFrameCache;
import cc.CCScheduler;
import cc.action.CCActionInstant;
import cc.action.CCActionInterval;
/**
 * ...
 * @author Ang Li
 */
class Bullet extends CCSprite
{
	public var active : Bool = true;
	public var xVelocity : Float;
	public var yVelocity : Float;
	public var power : Int = 1;
	public var hp : Int = 1;
	public var moveType : ENEMY_MOVE_TYPE;
	public var zOrder : Int = 3000;
	public var attackMoke : Int;
	public var parentType : Int;
	public function new(bulletSpeed : Float, weaponType : String, attackMode : Int) {
		
		super();
		attackMode = ENEMY_ATTACK_MODE.NORMAL;
		parentType = BULLET_TYPE.PLAYER;
		this.yVelocity = bulletSpeed;
		this.xVelocity = 0;
		this.attackMoke = attackMode;
		//CCSpriteFrameCache.getInstance().addSpriteFrames("Sample/bullet.plist");
		//this.initWithSpriteFrameName(weaponType);
		if (weaponType == "W2.png") {
			this.initWithFile("Sample/w2");
		} else {
			this.initWithFile("Sample/bullet1");
		}
		
	}
	
	override public function update(dt:Float)
	{
		super.update(dt);
		var p : Point = this.getPosition();
		p.x -=this.xVelocity * dt;
		p.y -=this.yVelocity * dt;
		//trace(p.y);
		this.setPosition(p.x, p.y);
		
		if (p.y < -100 || p.y > 600 || !this.active) {
			this.destroy();
		}
		
		if (this.hp <= 0) {
			this.active = false;
		}
	}
	
	public function destroy() {
		//trace("destroy");
		var explode : CCSprite = CCSprite.create("Sample/hit");
		explode.setPosition(this.getPosition().x, this.getPosition().y + 20);
		this.setRotation(Math.random() * 360);
		explode.setScale(0.75);
		this.getParent().addChild(explode);
		//CCScheduler.ArrayRemoveObject(GameConfig.ENEMY_BULLETS, this);
		//CCScheduler.ArrayRemoveObject(GameConfig.PLAYER_BULLETS, this);
		GameConfig.ENEMY_BULLETS.remove(this);
		GameConfig.PLAYER_BULLETS.remove(this);
		this.removeFromParent(true);
		//trace("remove bullet");
	    var removeExplode : CCCallFunc = CCCallFunc.create(explode.removeFromParentAndCleanup, explode);
		explode.runAction(CCScaleBy.create(0.3, 2, 2));
		explode.runAction(CCSequence.create([CCFadeOut.create(0.3), removeExplode]));
		
	}
	
	public function hurt() {
		this.hp--;
	}
	public function collideRect() : Rectangle {
		var p = this.getPosition();
		return new Rectangle(p.x - 3, p.y - 3, 6, 6);
	}
}