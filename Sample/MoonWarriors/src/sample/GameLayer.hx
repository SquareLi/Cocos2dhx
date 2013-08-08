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
import cc.labelnodes.CCLabelBMFont;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCScene;
import cc.menunodes.CCMenu;
import cc.menunodes.CCMenuItem;
import cc.spritenodes.CCSprite;
import cc.texture.CCTexture2D;
import cc.touchdispatcher.CCPointer;
import flambe.animation.AnimatedFloat;
import flambe.math.Point;
import flambe.math.Rectangle;
import sample.config.GameConfig;
import cc.action.CCActionInterval;
import cc.cocoa.CCGeometry;
import cc.CCDirector;
import cc.texture.CCTextureCache;
import cc.basenodes.CCNode;
import sample.config.EnemyType;
/**
 * ...
 * @author Ang Li
 */
class GameLayer extends CCLayer
{
	public static var STATE_PLAYING : Int = 0;
	public static var STATE_GAMEOVER : Int = 1;
	
	public var _ship : Ship;
	var _state : Int;
	var _time : Int = 0;
	var _beginPos : Point;
	var _isTouch : Bool = false;
	var _backSky : CCSprite;
	var _backSkyHeight : Float;
	var _backSkyRe : CCSprite;
	var _tmpScore : Float = 0;
	var _isBackSkyReload : Bool;
	var _levelManager : LevelManager;
	var _lbLife : CCLabelBMFont;
	var lbScore : CCLabelBMFont;
	public static var winSize : CCSize;
	public var screenRect : Rectangle;
	
	public function new() 
	{
		super();
		
	}
	
	override public function init():Bool 
	{
		var bRet = false;
		this.registerWithTouchDispatcher();
		if (super.init()) {
			GameConfig.ENEMIES = [];
			GameConfig.ENEMY_BULLETS = [];
			GameConfig.PLAYER_BULLETS = [];
			GameConfig.SCORE = 0;
			GameConfig.LIFE = 4;
			this._state = STATE_PLAYING;
			
			
			Explosion.sharedExplosion();
			Enemy.sharedEnemy();
			this._levelManager = new LevelManager(this);
			winSize = CCDirector.getInstance().getWinSize();
			_state = GameLayer.STATE_PLAYING;
			_beginPos = new Point(0, 0);
			_isBackSkyReload = false;
			
			initBackground();
			this.screenRect = new Rectangle(0, 0, winSize.width, winSize.height);
			
			//score
			this.lbScore = CCLabelBMFont.create("Score: 0", "Sample/arial-14");
			this.addChild(this.lbScore, 1000);
			this.lbScore.setPosition(240, 0);
			
			//ship life
			var shipTexture : CCTexture2D = CCTextureCache.getInstance().addImage("Sample/ship01");
			var life : CCSprite = CCSprite.createWithTexture(shipTexture, new Rectangle(0, 0, 60, 38));
			life.setScale(0.6);
			life.setPosition(0, 0);
			this.addChild(life, 1, 5);
			
			//shit life count
			this._lbLife = CCLabelBMFont.create("0", "Sample/arial-14");
			this._lbLife.setPosition(40, 0);
			this.addChild(this._lbLife, 1000);
			
			
			//ship
			_ship = new Ship();
			this.addChild(this._ship, this._ship.zOrder, UNIT_TAG.PLAYER);

			//Main Menu
			var mainMenuButton : CCLabelBMFont = CCLabelBMFont.create("Main Menu", "Sample/arial-14");
			var mainMenuItem : CCMenuItemLabel = CCMenuItemLabel.create(mainMenuButton, onMainMenu, this);
			var menu : CCMenu = CCMenu.create([mainMenuItem]);
			menu.setPosition(240, 450);
			this.addChild(menu, 1100);
		    this.schedule(this.scoreCounter, 1);
		}
		
		return true;
	}
	
	public function scoreCounter() {
		if (this._state == STATE_PLAYING) {
			this._time++;
			
			var minute : Int = Std.int(this._time / 60);
			var second : Int = this._time % 60;
			
			var minuteStr : String = minute > 9 ? Std.string(minute) : "0" + Std.string(minute);
			var secondStr : String = second > 9 ? Std.string(second) : "0" + Std.string(second);
			
			var curTimeStr : String = minute + ":" + second;
			
			this._levelManager.loadLevelResource(this._time);
		}
	}
	
	override public function onPointerMoved(event:CCPointer):Bool 
	{
		this.processEvent(event);
		return super.onPointerMoved(event);
	}
	
	override public function onPointerDragged(event:CCPointer):Bool 
	{
		this.processEvent(event);
		return super.onPointerMoved(event);
	}
	
	public function processEvent(event : CCPointer) {
		if (this._state == STATE_PLAYING) {
			this._ship.setPosition(event.getLocation().x, event.getLocation().y);
		}
	}
	var _timer : Float = 0;
	override public function update(dt:Float)
	{
		super.update(dt);
		
		this.checkIsCollide();
		//this.removeInactiveUnit(dt);
		//this.checkIsReborn();
		this.updateUI();

		
	}
	
	public function checkIsCollide() {
		var selChild : Enemy;
		var bulletChild : Bullet;
		var pb : Array<Int> = new Array<Int>();
		var eb : Array<Int> = new Array<Int>();
		var e : Array<Int> = new Array<Int>();
		var pbh : Array<Int> = new Array<Int>();
		var ebh : Array<Int> = new Array<Int>();
		var eh : Array<Int> = new Array<Int>();
		for (i in 0...GameConfig.ENEMIES.length) {
			selChild = GameConfig.ENEMIES[i];
			//trace(GameConfig.PLAYER_BULLETS.length);
			for (j in 0...GameConfig.PLAYER_BULLETS.length) {
				//trace("123");
				bulletChild = GameConfig.PLAYER_BULLETS[j];
				if (bulletChild != null) {
					
					if (this.collide(selChild.collideRect(), bulletChild.collideRect())) {
						//trace("hit");
						pbh.push(j);
						eh.push(i);
						//bulletChild.hurt();
						//selChild.hurt();
					} else {
						//trace(selChild.collideRect()
					}
					//trace(bulletChild.getBoundingBox().toString());
					//if (bulletChild.getPositionY() < -100 || bulletChild.getPositionY() > 600) {
						//trace("destroy player bullet");
					   //bulletChild.destroy();
					   //pb.push(j);
					//}
				}
			}
			
			if (this.collide(selChild.collideRect(), this._ship.collideRect())) {
				if (this._ship.active) {
					selChild.hurt();
					this._ship.hurt();
				}
			}
			
			//if (!CCGeometry.rectIntersectsRect(this.screenRect, selChild.getBoundingBox())) {
				//selChild.destroy();
			//}
		}
		
		for (i in pbh) {
			GameConfig.PLAYER_BULLETS[i].hurt();
		}
		pbh = [];
		//for (i in pb) {
			//if (GameConfig.PLAYER_BULLETS[i] != null) {
				//GameConfig.PLAYER_BULLETS[i].destroy();
			//}
			//
		//}
		pb = [];
		for (i in eh) {
			GameConfig.ENEMIES[i].hurt();
		}
		eh = [];
		
		
		var enemyBullet : Bullet;
		for (i in 0...GameConfig.ENEMY_BULLETS.length) {
			enemyBullet = GameConfig.ENEMY_BULLETS[i];
			if (enemyBullet != null) {
				
				if (this.collide(enemyBullet.collideRect(), this._ship.collideRect())) {
					if (this._ship.active) {
						eb.push(i);
						this._ship.hurt();
					}
				}
				//if (!CCGeometry.rectIntersectsRect(this.screenRect, enemyBullet.getBoundingBox())) {
					//trace("destroy enemy bullet");
					//enemyBullet.destroy();
				//}
			}
			
		}
		
		for (i in eb) {
			if (GameConfig.ENEMY_BULLETS[i] != null) {
				GameConfig.ENEMY_BULLETS[i].hurt();
			}
			
		}
	}
	
	public function removeInactiveUnit(dt : Float) {
		var enemy : Enemy;
		var bullet : Bullet;
		var layerChilren : Array<CCNode> = this.getChildren();
		
		for (i in layerChilren) {
			if (i != null) {
				//selChild = cast (i, CCSprite);
				if (Std.is(i, Enemy)) {
					enemy = cast (i, Enemy);
					if (!enemy.active) {
						enemy.destroy();
					}
				} else if (Std.is(i, Bullet)) {
					bullet = cast (i, Bullet);
					if (!bullet.active) {
						bullet.destroy();
					}
				}
			}
		}
	}
	
	public function checkIsReborn() {
		if (GameConfig.LIFE > 0 && !this._ship.active) {
			//ship
			this._ship = new Ship();
			this.addChild(this._ship, this._ship.zOrder, UNIT_TAG.PLAYER);
		} else if (GameConfig.LIFE <= 0 && !this._ship.active) {
			this._ship = null;
			//this.runAction(CCSequence.create(
		}
	}
	
	
	
	public function updateUI() {
		if (this._tmpScore < GameConfig.SCORE) {
			this._tmpScore += 5;
		}
		this._lbLife.setString(Std.string(GameConfig.LIFE));
		this.lbScore.setString("Score: " + this._tmpScore);
	}
	
	public function collide(a : Rectangle, b : Rectangle) : Bool {
		if (CCGeometry.rectIntersectsRect(a, b)) {
			return true;
		} else {
			return false;
		}
	}
	
	public function initBackground() {
		this._backSky = CCSprite.create("Sample/bg01");
		this._backSky.setAnchorPoint(new Point(0, 0));
		this._backSkyHeight = this._backSky.getContentSize().height;
		this.addChild(this._backSky, -10);
		winSize = _backSky.getContentSize();
		
		this.schedule(movingBackground, 3);
	}
	
	var _backgroundSpeed : Float = -192;
	var _temp : CCSprite;
	public function movingBackground() {
		//trace(this._backSkyHeight);
		this._backSky.runAction(CCMoveBy.create(3, new Point(0, this._backgroundSpeed)));
		this._backSkyHeight = this._backSkyHeight + this._backgroundSpeed;
		
		if (this._backSkyHeight <= winSize.height) {
			if (!this._isBackSkyReload) {
				this._backSkyRe = CCSprite.create("Sample/bg01");
				this._backSkyRe.setAnchorPoint(new Point(0, 0));
				this.addChild(this._backSkyRe, -10);
				//var p : Point = _ship.getPosition();
				//this.removeChild(_ship, false);
				//_ship._parent = null;
				//this.addChild(_ship);
				this._backSkyRe.setPosition(0, winSize.height);
				this._isBackSkyReload = true;
				
				if (_temp != null) {
					this.removeChild(this._temp, false);
					//trace("remove");
				}
			}
			this._backSkyRe.runAction(CCMoveBy.create(3, new Point(0, this._backgroundSpeed)));
		}
		
		if (this._backSkyHeight <= 0) {
			this._backSkyHeight = this._backSky.getContentSize().height;
			
			this._temp = this._backSky;
			this._backSky = this._backSkyRe;
			this._backSkyRe = null;
			this._isBackSkyReload = false;
		}
		
		
	}
	
	public function onGameOver() {
		
	}
	
	public function onMainMenu() {
		var scene : CCScene = CCScene.create();
		scene.addChild(SysMenu.create());
		CCDirector.getInstance().replaceScene(scene);
	}
	public static function create() : GameLayer {
		var sg = new GameLayer();
		if (sg != null && sg.init()) {
			return sg;
		} 
		return null;
	}
	
	public static function scene() : CCScene{
		var scene : CCScene = CCScene.create();
		var layer : GameLayer = GameLayer.create();
		scene.addChild(layer, 1);
		return scene;
	}
}