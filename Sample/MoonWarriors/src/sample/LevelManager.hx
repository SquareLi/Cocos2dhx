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

import cc.action.CCAction;
import cc.platform.CCMacro;
import cc.touchdispatcher.CCPointer;
import flambe.math.Point;
import sample.config.Level;
import sample.config.GameConfig;
import sample.config.EnemyType;
import cc.action.CCActionInterval;
import cc.action.CCActionInstant;
/**
 * ...
 * @author Ang Li
 */
class LevelManager
{
	var _currentLevel : Level;
	var _gameLayer : GameLayer;
	
	public function new(gameLayer : GameLayer) 
	{
		if (gameLayer == null) {
			throw "gameLayer must be non-nil";
		}
		this._currentLevel = Level.initLevel1();
		this._gameLayer = gameLayer;
		this.setLevel(this._currentLevel);
		EnemyType.create();
	}
	
	public function setLevel(level : Level) {
		for (i in 0...level.enemies.length) {
			this._currentLevel.enemies[i].showTime = this._minuteToSecond(this._currentLevel.enemies[i].showTime);
		}
	}
	
	private function _minuteToSecond(minuteStr : String) : String {
		if (minuteStr == null) {
			return "0";
		}
		
		
		var mins : Array<String> = minuteStr.split(':');
		if (mins.length == 1) {
			return Std.string(Std.parseInt(mins[0]));
		} else {
			return Std.string((Std.parseInt(mins[0]) * 60) + Std.parseInt(mins[1]));
		}
		
		return minuteStr;
	}
	
	public function loadLevelResource(deltaTime : Int) {
		//load enemy
		for (i in 0...this._currentLevel.enemies.length) {

			var selEnemy : Entry = this._currentLevel.enemies[i];
			if (selEnemy != null) {
				if (selEnemy.showType == "Once") {
					
				} else if (selEnemy.showType == "Repeate") {
				
					//trace(selEnemy.showTime);
					if (deltaTime % Std.parseInt(selEnemy.showTime) == 0) {
						//trace("add enemy");
						for (rIndex in 0...selEnemy.types.length) {
						//	trace("add enemy");
							this.addEnemyToGameLayer(selEnemy.types[rIndex]);
						}
					}
				}
			}
		}
	}
	
	public function addEnemyToGameLayer(enemytype : Int) {
		if (this._gameLayer._ship == null) {
			return ;
		}
		var addEnemy : Enemy = new Enemy(EnemyType.ENEMY_TYPE_LIST[enemytype]);
		
		var enemypos : Point = new Point(Math.random() * GameLayer.winSize.width, 0);
		var enemycs = addEnemy.getContentSize();
		addEnemy.setPosition(enemypos.x, enemypos.y);
		//trace(enemypos.x, enemypos.y);
		
		var offset : Point;
		var tmpAction : CCAction = CCAction.create();
		
		var a0 : CCMoveBy;
		var a1 : CCMoveBy;
		
		switch(addEnemy.moveType) {
			case ENEMY_MOVE_TYPE.ATTACK:
				offset = this._gameLayer._ship.getPosition();
				tmpAction = CCMoveTo.create(1, offset);
			case ENEMY_MOVE_TYPE.VERTICAL:
				offset = new Point(0, GameLayer.winSize.height + enemycs.height);
				tmpAction = CCMoveBy.create(4, offset);
			case ENEMY_MOVE_TYPE.HORIZONTAL:
				//offset = new Point(0, -100 - 200 * Math.random());
				//a0 = CCMoveBy.create(0.5, offset);
				//a1 = CCMoveBy.create(1, new Point( -50 - 100 * Math.random(), 0));
				//var onComplete
				offset = new Point(0, GameLayer.winSize.height + enemycs.height);
				tmpAction = CCMoveBy.create(4, offset);
			case ENEMY_MOVE_TYPE.OVERLAP:
				var newX : Float = (enemypos.x <= GameLayer.winSize.width / 2) ? 320 : -320;
				a0 = CCMoveBy.create(4, new Point(newX, 240));
				a1 = CCMoveBy.create(4, new Point( -newX, 320));
				tmpAction = CCSequence.create([a0, a1]);
				
		}
		
		this._gameLayer.addChild(addEnemy, addEnemy.zOrder, UNIT_TAG.ENEMY);
		GameConfig.ENEMIES.push(addEnemy);
		if (Std.is(tmpAction, CCSequence)) {
			var s : CCSequence = cast(tmpAction, CCSequence);
			addEnemy.runAction(s);
		} else if (Std.is(tmpAction, CCMoveTo)) {
			var s : CCMoveTo = cast(tmpAction, CCMoveTo);
			addEnemy.runAction(s);
		} else if (Std.is(tmpAction, CCMoveBy)) {
			var se : CCMoveBy = cast(tmpAction, CCMoveBy);
			addEnemy.runAction(se);
		}
		//
		
		
		
	}
	
}