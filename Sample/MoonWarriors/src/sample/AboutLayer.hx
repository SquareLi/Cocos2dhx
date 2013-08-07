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
import cc.texture.CCTextureCache;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.CCDirector;
import cc.layersscenestransitionsnodes.CCTransitionFade;

/**
 * ...
 * @author Ang Li
 */
class AboutLayer extends CCLayer
{

	public function new() 
	{
		super();
	}
	
	override public function init():Bool 
	{
		var bRet = false;
		if (super.init()) {
			var sp = CCSprite.create("Sample/loading");
			this.addChild(sp, 0, 1);
			
			var cacheImage = CCTextureCache.getInstance().addImage("Sample/menuTitle");
			var title = CCSprite.createWithTexture(cacheImage, new Rectangle(0, 36, 100, 34));
			if (title == null) {
				trace("null");
			}
			title.setCenterAnchor();
			title.setPosition(160, 60);
			this.addChild(title);
			
			//var about =
			var label : CCLabelBMFont = CCLabelBMFont.create("Go back", "Sample/arial-14");
			var back : CCMenuItemLabel = CCMenuItemLabel.create(label, this.backCallback, this);
			var menu : CCMenu = CCMenu.create([back]);
			//menu.setCenterAnchor();
			menu.alignVerticallyWithPadding(0);
			menu.setPosition(134, 300);
			this.addChild(menu);
			bRet = true;
		}
		return bRet;
	}
	
	public function backCallback() {
		var scene : CCScene = CCScene.create();
		scene.addChild(SysMenu.create());
		CCDirector.getInstance().replaceScene(scene);
	}
	
	public static function create() : AboutLayer {
		var sg = new AboutLayer();
		if (sg != null && sg.init()) {
			return sg;
		}
		
		return null;
	}
	
}