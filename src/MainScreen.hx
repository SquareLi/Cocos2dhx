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
import DenshionTest;
import flambe.Component;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import haxe.unit.TestStatus;
import flambe.System;
import cc.CCLoader;

/**
 * ...
 * @author Ang Li
 */

class MainScreen extends Component
{
	var _testDenshion : TextSprite;
	var _testLayer : TextSprite;
	var _testSprite: TextSprite;
	
	public var d : DenshionTest;
	public var l : TestSceneAndLayer;
	public var s : SpriteTest;
	
	public static var shareMainScreen : MainScreen;
	public static function getInstance() : MainScreen {
		if (shareMainScreen == null) {
			shareMainScreen = new MainScreen();
		} 
		
		return shareMainScreen;
	}
	private function new() 
	{
		d = new DenshionTest();
		l = new TestSceneAndLayer();
		s = new SpriteTest();
	}
	
	override public function onAdded()
	{
		super.onAdded();
		_testDenshion = new TextSprite(new Font(CCLoader.pack, "myfont"), "Test Denshion");
		_testLayer = new TextSprite(new Font(CCLoader.pack, "myfont"), "Test Layer");
		_testSprite = new TextSprite(new Font(CCLoader.pack, "myfont"), "Test Sprite");
		
		_testDenshion.setXY(0, 0);
		_testLayer.setXY(0, 100);
		_testSprite.setXY(0, 200);
		
		_testDenshion.pointerUp.connect(function(_) {
			owner.dispose();
			System.root.addChild(new Entity().add(d));
		});
		
		
		_testLayer.pointerUp.connect(function(_) {
			owner.dispose();
			l.runScene();
		});

		
		owner.addChild(new Entity().add(_testDenshion));
		owner.addChild(new Entity().add(_testLayer));
	}
}