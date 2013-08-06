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

import cc.layersscenestransitionsnodes.CCLayerColor;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCDirector;
import cc.spritenodes.CCSprite;
import cc.CCLoader;

/**
 * ...
 * @author Ang Li
 */

class TestSceneAndLayer
{
	var dir : CCDirector;
	public function new() 
	{
		
	}
	
	public function runScene() {
		dir = CCDirector.getInstance();
		var layerColor : TestLayerColor = new TestLayerColor();
		var s : CCScene = new CCScene();
		s.addChild(layerColor);
		
		var sprite : CCSprite = CCSprite.create("TestSprite/AM");
		sprite.setPosition(200, 200);
		//sprite.setScale(1);
		layerColor.addChild(sprite);
		dir.pushScene(s);
	}
	
}