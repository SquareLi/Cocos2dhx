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
import cc.labelnodes.CCLabelTTF;
import cc.CCDirector;
import cc.layersscenestransitionsnodes.CCScene;
import flambe.scene.Scene;
import cc.labelnodes.CCLabelBMFont;


/**
 * ...
 * @author Ang Li
 */
class TestLabelTTF 
{
	public var label : CCLabelBMFont;
	var _scene : CCScene;
	public function new() 
	{
		label = CCLabelBMFont.create("afefefefee", "Sample/arial-14");
		_scene = CCScene.create();
		label.setOpacity(100);
		_scene.addChild(label);
	}
	
	public function runTest() {
		CCDirector.getInstance().popScene();
		CCDirector.getInstance().pushScene(_scene);
	}
	
}