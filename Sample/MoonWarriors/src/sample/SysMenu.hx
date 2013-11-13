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
import cc.layersscenestransitionsnodes.CCLayer;
import cc.cocoa.CCGeometry;
import cc.CCDirector;
import cc.spritenodes.CCSprite;
import cc.layersscenestransitionsnodes.CCScene;
import cc.layersscenestransitionsnodes.CCTransitionFade;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.menunodes.CCMenu;
import cc.menunodes.CCMenuItem;
import sample.config.GameConfig;
import cc.denshion.CCAudioEngine;
/**
 * ...
 * @author Ang Li
 */
class SysMenu extends CCLayer
{
	var winSize : CCSize;
	public function new() 
	{
		super();
	}
	
	override public function init():Bool 
	{
		var bRet = false;
		if (super.init()) {
			winSize = CCDirector.getInstance().getWinSize();
			GameLayer.winSize = winSize;
			var logo = CCSprite.create("Sample/logo");
			logo.setAnchorPoint(new Point(0, 0));
			logo.setPosition(0, 100);
			this.addChild(logo, 10, 2);
			
			
			var sp = CCSprite.create("Sample/loading");
			sp.setAnchorPoint(new Point(0, 0));
			this.addChild(sp, 1, 1);
			
			
			
			
			var newGameNormal = CCSprite.create("Sample/menu", new Rectangle(0, 0, 126, 33));
			var newGameSelected = CCSprite.create("Sample/menu", new Rectangle(0, 33, 126, 33));
			var newGameDisabled = CCSprite.create("Sample/menu", new Rectangle(0, 33 * 2, 126, 33));

			var gameSettingsNormal = CCSprite.create("Sample/menu", new Rectangle(126, 0, 126, 33));
			var gameSettingsSelected = CCSprite.create("Sample/menu", new Rectangle(126, 33, 126, 33));
			var gameSettingsDisabled = CCSprite.create("Sample/menu", new Rectangle(126, 33 * 2, 126, 33));

			var aboutNormal = CCSprite.create("Sample/menu", new Rectangle(252, 0, 126, 33));
			var aboutSelected = CCSprite.create("Sample/menu", new Rectangle(252, 33, 126, 33));
			var aboutDisabled = CCSprite.create("Sample/menu", new Rectangle(252, 33 * 2, 126, 33));
			
			var newGame = CCMenuItemSprite.create(newGameNormal, newGameSelected, newGameDisabled, function() {
				this.onButtonEffect();
				Effect.flareEffect(this, this, this.onNewGame);
			},this);
			var gameSettings = CCMenuItemSprite.create(gameSettingsNormal, gameSettingsSelected, gameSettingsDisabled, this.onSettings, this);
			var about = CCMenuItemSprite.create(aboutNormal, aboutSelected, aboutDisabled, this.onAbout, this);
			
			var _menu = CCMenu.create([newGame, gameSettings, about]);
			_menu.alignVerticallyWithPadding(10);
			
			_menu.setCenterAnchor();
			_menu.setPosition(97, 250);
			this.addChild(_menu, 6, 2);
			bRet = true;
			
			if (GameConfig.SOUND) {
				CCAudioEngine.getInstance().set__musicVolume(0.7);
				CCAudioEngine.getInstance().playMusic("Sample/Music/mainMainMusic", true);
			}
			
			
		}
			
		return bRet;
	}
	
	public function onNewGame() {
		//this.onButtonEffect();
		//trace("123");
		var scene = CCScene.create();
		scene.addChild(GameLayer.create());
		CCDirector.getInstance().replaceScene(CCTransitionFade.create(1.2, scene));
	}
	
	public function onSettings() {
		this.onButtonEffect();
		var scene = CCScene.create();
		scene.addChild(SettingsLayer.create());
		CCDirector.getInstance().replaceScene(scene);
	}
	
	public function onAbout() {
		this.onButtonEffect();
		var scene = CCScene.create();
		scene.addChild(AboutLayer.create());
		CCDirector.getInstance().replaceScene(scene);
	}
	
	public function onButtonEffect() {
		if (GameConfig.SOUND) {
			CCAudioEngine.getInstance().playEffect("Sample/Music/buttonEffect");
		}
	}
	
	public static function create() : SysMenu {
		var sg = new SysMenu();
		if (sg != null) {
			return sg;
		}
		return null;
	}
	
	public static function scene() : CCScene {
		var scene = CCScene.create();
		var layer = SysMenu.create();
		scene.addChild(layer);
		return scene;
	}
}