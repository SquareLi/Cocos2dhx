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

import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCScene;
import cc.spritenodes.CCSprite;
import AllAssets;
import cc.CCDirector;
import cc.touchdispatcher.CCPointer;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.System;
import flambe.Entity;
import cc.action.CCActionInterval;
/**
 * ...
 * @author Ang Li
 */

class SpriteTest extends CCLayer
{
	var director : CCDirector;
	var s : CCSprite;
	public function new() 
	{
		super();
		this.init();
		this.registerWithTouchDispatcher();
	}
	
	public function addNewSprite() {
		director = CCDirector.getInstance();
		s = CCSprite.create("TestSprite/AM");
		s.setPosition(200, 200);
		s.setScale(1);
		s.setCenterAnchor();
		var m : CCMoveBy = CCMoveBy.create(3, new Point(100, 100));
		s.runAction(m);
		var scene  = new CCScene();
		scene.addChild(this);
		this.addChild(s);
		director.pushScene(scene);

	}
	
	override public function onPointerDown(event:CCPointer):Bool 
	{
		var r : Rectangle = new Rectangle(s.getPositionX(), s.getPositionY(), s.getContentSize().width, s.getContentSize().height);
		trace(r.x, r.y, r.height, r.width);
		if (r.contains(event.getLocation().x, event.getLocation().y)) {
			trace("pointer down");
			director.popScene();
			
			//s.setPosition(event.getLocation().x, event.getLocation().y);
			//System.root.addChild(new Entity().add(MainScreen.getInstance()));
		}
		
		return true;
	}
	
}