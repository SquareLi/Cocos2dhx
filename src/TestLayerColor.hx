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

import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCLayerColor;
import cc.layersscenestransitionsnodes.CCTransitionFade;
import cc.platform.CCTypes;
import cc.touchdispatcher.CCPointer;
import flambe.Entity;
import flambe.input.PointerEvent;
import cc.layerandscenes.CCScene;
import cc.CCDirector;
import flambe.math.Rectangle;
import flambe.System;

/**
 * ...
 * @author Ang Li
 */

class TestLayerColor extends CCLayerColor
{
	var isNew : Bool;
	var d : CCDirector;
	public function new() 
	{
		super();
		this.initLayerColor(new CCColor4B(255, 0, 0, 1));
		this.registerWithTouchDispatcher();
		isNew = false;
		d = CCDirector.getInstance();
	}
	
	override public function onPointerDown(event:CCPointer):Bool 
	{
		var rect : Rectangle =  new Rectangle(this.getPosition().x, this.getPosition().y, this.getContentSize().width, this.getContentSize().height);
		if (rect.contains(event.getLocation().x, event.getLocation().y) && !isNew) {
			
			var layerColor : CCLayerColor = CCLayerColor.create(new CCColor4B(200, 255, 123, 1));
			
			var scene : CCScene = CCScene.create();
			scene.addChild(layerColor);
			//s.initWithDuration(1);
			//s.addChild(layerColor);
			var s : CCTransitionFade = CCTransitionFade.create(1, scene);
			

			d.pushScene(s);
			isNew = true;
		} else if (rect.contains(event.getLocation().x, event.getLocation().y) && isNew) {
			isNew = false;
			d.popToRootScene();
			d.popScene();
			CCDirector.getInstance().getPointerDispatcher().removePointerDelegate(this);
			System.root.addChild(new Entity().add(MainScreen.getInstance()));
			
		}
		
		return false;
	}
}