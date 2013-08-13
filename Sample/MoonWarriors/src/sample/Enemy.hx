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
import flambe.math.Point;
import flambe.math.Rectangle;
import sample.config.EnemyType;
import sample.config.GameConfig;
import cc.CCScheduler;
import cc.cocoa.CCGeometry;
import cc.spritenodes.CCSpriteFrameCache;
/**
 * ...
 * @author Ang Li
 */
class Enemy extends CCSprite
{
	public var eID : Int = 0;
	public var active : Bool = true;
	public var speed : Float = 200;
	public var bulletSpeed : Float = -200;
	public var hp : Int = 15;
	public var bulletPowerValue : Int = 1;
	public var moveType : Int;
	public var scoreValue : Int = 200;
	public var zOrder : Int = 3000;
	public var delayTime : Float;
	public var attackMode : Int;
	var _hurtColorLife : Int = 0; 
	
	public function new(enemyType : EnemyType) 
	{
		super();
		this.moveType = enemyType.moveType;
		this.hp = enemyType.HP;
		this.scoreValue = enemyType.scoreValue;
		this.attackMode = enemyType.attackMode;
		this.initWithSpriteFrameName(enemyType.textureName);
		this.delayTime = 1 + 1.2 * Math.random();
		//trace(enemyType.textureName);
		
		this.schedule(this.shoot, this.delayTime);
	}
	
	var _timeTick : Float = 0;
	
	override public function update(dt:Float)
	{
		super.update(dt);
		var p = this.getPosition();
		if (this.hp <= 0 || p.x < 0 || p.x > GameLayer.winSize.width || p.y < -50 || p.y > 600) {
			this.active = false;
			destroy();
		}
		
		this._timeTick += dt;
		if (this._timeTick > 0.1) {
			this._timeTick = 0;
			
		}
		
	}
	
	public function destroy() {
		GameConfig.SCORE += this.scoreValue;
		var a : Explosion = new Explosion();
		//a.setCenterAnchor();
		a.setPosition(this.getPosition().x - 38, this.getPosition().y - 45);
		this.getParent().addChild(a);
		Effect.spark(new Point(this.getPosition().x + 20, this.getPosition().y), this.getParent(), 1.2, 0.7);
		CCScheduler.ArrayRemoveObject(GameConfig.ENEMIES, this);
		this.removeFromParent(true);
	}
	
	public function shoot() {
		var p = this.getPosition();
		var b = new Bullet(this.bulletSpeed, "W2.png", this.attackMode);
		GameConfig.ENEMY_BULLETS.push(b);
		this.getParent().addChild(b, b.zOrder, UNIT_TAG.ENEMY_BULLET);
		b.setPosition(p.x, p.y - this.getContentSize().height * 0.2);
	}
	
	
	public function hurt() {
		this.hp--;
		
	}
	
	public function collideRect() : Rectangle {
		var a : CCSize = this.getContentSize();
		var p : Point = this.getPosition();
		
		return new Rectangle(p.x, p.y - a.height / 4, a.width, a.height / 2);
		
	}
	
	public static function sharedEnemy() {
		CCSpriteFrameCache.getInstance().addSpriteFrames("Sample/Enemy.plist");
	}
}