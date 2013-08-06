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

import cc.layersscenestransitionsnodes.CCScene;
import cc.spritenodes.CCAnimation;
import cc.spritenodes.CCSprite;
import cc.spritenodes.CCSpriteFrameCache;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.System;
import cc.CCDirector;
import cc.action.CCActionInterval;
import cc.CCLoader;
import sample.GameLayer;
import tests.TestLabelTTF;
import tests.TestMenu;
import sample.SysMenu;
import sample.AboutLayer;
/**
 * ...
 * @author Ang Li
 */
class Main 
{
    private static function onSuccess (pack :AssetPack) 
    {
		AllAssets.pack = pack;
		//var m = MainScreen.getInstance();
		//System.root.addChild(new Entity().add(m));
		/*var name = neko.Sys.args()[0];
   
		var counter = new SlocCount(name);*/
		CCLoader.pack = pack;
		//
		//System.root.add(MainScreen.getInstance());
		
		//Run Layer and Image test
		//var s : TestSceneAndLayer = new TestSceneAndLayer();
		//s.runScene();
		
		//Run Image test
		//var i : SpriteTest = new SpriteTest();
		//i.addNewSprite();
		
		//Run Audio test
		//var a : DenshionTest = new DenshionTest();
		//System.root.add(a);
		
		//Run Sprite Sheet
		//System.root.add(new FillSprite(0xffffff, 320, 576));
		//var spriteSheet  = new TestSpriteSheet();
		//spriteSheet.test();
		
		//Run LabelTTF test
		//var t : TestLabelTTF = new TestLabelTTF();
		//t.runTest();
		
		//Run Menu test
		//var t : TestMenu = new TestMenu();
		//t.runTest();
		var director : CCDirector = CCDirector.getInstance();
		//var s = CCScene.create();
		//s.addChild(AboutLayer.create());
		director.runWithScene(SysMenu.scene());
    }

    private static function main () 
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }
}
