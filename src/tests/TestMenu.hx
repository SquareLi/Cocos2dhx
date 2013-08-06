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

package tests;
import cc.layersscenestransitionsnodes.CCScene;
import cc.menunodes.CCMenu;
import cc.spritenodes.CCSprite;
import cc.menunodes.CCMenuItem;
import cc.CCDirector;
import flambe.math.Rectangle;
import cc.spritenodes.CCSprite;
import cc.menunodes.CCMenu;
import cc.menunodes.CCMenuItem;
import sample.GameLayer;
/**
 * ...
 * @author Ang Li
 */
class TestMenu 
{
	var _spriteNormal : CCSprite;
	var _spriteSelected : CCSprite;
	var _pMenuItemSprite : CCMenuItemSprite;
	var _menu : CCMenu;
	
	public function new() 
	{
		//_spriteNormal = CCSprite.create("BoxUP");
		//_spriteSelected = CCSprite.create("BoxOVER");
		//_spriteNormal.setScale(0.5);
		//_spriteSelected.setScale(0.5);
		//
		//_pMenuItemSprite = CCMenuItemSprite.create(_spriteNormal, _spriteSelected, null, 
		//function() {
			//var t : TestLabelTTF = new TestLabelTTF();
			//t.runTest();
		//}, null);
		//
		//var _spriteNormal2 = CCSprite.create("BoxUP");
		//var _spriteSelected2 = CCSprite.create("BoxOVER");
		//_spriteNormal2.setScale(0.5);
		//_spriteSelected2.setScale(0.5);
//
		//
		//var _pMenuItemSprite2 = CCMenuItemSprite.create(_spriteNormal2, _spriteSelected2);
//
		//_menu = CCMenu.create([_pMenuItemSprite, _pMenuItemSprite2]);
		//_menu.alignVerticallyWithPadding(10);
		//this.addChild(_menu);
		
		var newGameNormal = CCSprite.create("Sample/menu", new Rectangle(0, 0, 126, 33));
		var newGameSelected = CCSprite.create("Sample/menu", new Rectangle(0, 33, 126, 33));
		var newGameDisabled = CCSprite.create("Sample/menu", new Rectangle(0, 33 * 2, 126, 33));

		var gameSettingsNormal = CCSprite.create("Sample/menu", new Rectangle(126, 0, 126, 33));
		var gameSettingsSelected = CCSprite.create("Sample/menu", new Rectangle(126, 33, 126, 33));
		var gameSettingsDisabled = CCSprite.create("Sample/menu", new Rectangle(126, 33 * 2, 126, 33));

		var aboutNormal = CCSprite.create("Sample/menu", new Rectangle(252, 0, 126, 33));
		var aboutSelected = CCSprite.create("Sample/menu", new Rectangle(252, 33, 126, 33));
		var aboutDisabled = CCSprite.create("Sample/menu", new Rectangle(252, 33 * 2, 126, 33));
		
		var newGame = CCMenuItemSprite.create(newGameNormal, newGameSelected, newGameDisabled, 
			function() {
				//CCDirector.getInstance().popScene();
				CCDirector.getInstance().pushScene(GameLayer.scene());
			}, null);
		var gameSettings = CCMenuItemSprite.create(gameSettingsNormal, gameSettingsSelected, gameSettingsDisabled);
		var about = CCMenuItemSprite.create(aboutNormal, aboutSelected, aboutDisabled);
		
		_menu = CCMenu.create([newGame, gameSettings, about]);
		_menu.alignVerticallyWithPadding(10);
		//this.addChild(menu, 1, 2);
		//menu.setPosition(cc.p(winSize.width / 2, winSize.height / 2 - 80));
		//this.schedule(this.update, 0.1);
	}
	
	public function runTest() {
		//var newGameNormal = CCSprite.create("Sample/menu", new Rectangle(0, 0, 126, 33));
		var scene : CCScene = CCScene.create();
		scene.addChild(_menu);
		CCDirector.getInstance().runWithScene(scene);
	}
	
}