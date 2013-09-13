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

package cc.layersscenestransitionsnodes;
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.CCDirector;
import cc.keyboarddispatcher.CCKeyboardDelegate;
import cc.touchdispatcher.CCPointer;
import flambe.display.Sprite;
import flambe.subsystem.PointerSystem;
import flambe.input.PointerEvent;
import cc.touchdispatcher.CCPointerEventDelegate;
import flambe.math.Point;
import flambe.input.KeyboardEvent;


/**
 * ...
 * @author Ang Li
 */

 import cc.touchdispatcher.CCPointerEventDelegate;

class CCLayer extends CCNode implements CCPointerEventDelegate implements CCKeyboardDelegate
{
	var _isPointerEnabled : Bool = false;
	var _isAccelerometerEnabled : Bool = false;
	var _isKeyboardEnabled : Bool = false;
	var _pointerPriority : Int = 0;
	
	public function new() 
	{
		super();
	}
	
	private function _initLayer() {
		this.setAnchorPoint(new Point(0, 0));
		this._ignoreAnchorPointForPosition = true;
		
		var director : CCDirector = CCDirector.getInstance();
		
		this.setContentSize(director.getWinSize());
		this._isPointerEnabled = false;
		this._pointerPriority = 0;
		addComponent();
		//trace("_initLayer");
	}
	
	public function addComponent() {
		if (this.component == null) {
			this.component = new CCComponent(this);
			this.entity.add(component);
			
			if (!this.entity.has(Sprite)) {
				//this.sprite = new Sprite();
				this.entity.add(sprite);
			}
		}
		
	}
	
	override public function init():Bool 
	{
		super.init();
		this._initLayer();
		return true;
	}
	
	public function registerWithTouchDispatcher() {
		//trace("reg");
		//this._isPointerEnabled = true;
		CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this, this._pointerPriority);
	}
	
	public function isPointerEnabled() : Bool {
		return this._isPointerEnabled;
	}
	
	public function setPointerEnabled(enabled : Bool) {
		if (this._isPointerEnabled != enabled) {
			this._isPointerEnabled = enabled;
			if (this._running) {
				if (enabled) {
					CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this, this._pointerPriority);
				} else {
					CCDirector.getInstance().getPointerDispatcher().removeAllMouseDelegates();
				}
			}
		}
		
		
	}
	
	public function setPointerPriority(priority : Int) {
		if (this._pointerPriority != priority) {
			this._pointerPriority = priority;
			if (this._isPointerEnabled) {
				this.setPointerEnabled(false);
				this.setPointerEnabled(true);
			}
			
		}
	}
	
	public function getPointerPriority() : Int {
		return this._pointerPriority;
	}
	
	public function isKeyboardEnabled() : Bool {
		return this._isKeyboardEnabled;
	}
	
	public function setKeyboardEnabled(enabled : Bool) {
		if (enabled != this._isKeyboardEnabled) {
			this._isKeyboardEnabled = enabled;
			if (this._running) {
				var director = CCDirector.getInstance();
				if (enabled) {
					director.getKeyboardDispatcher().addDelegate(this);
				} else {
					director.getKeyboardDispatcher().removeDelegate(this);
				}
			}
		}
	}
	
	
	override public function draw() 
	{
		//trace("Layer dras");
	}
	
	override public function onEnter()
	{
		var director = CCDirector.getInstance();
		
		if (this._isPointerEnabled = true) {
			this.registerWithTouchDispatcher();
		}
		super.onEnter();
	}
	
	override public function onExit() 
	{
		
		var director = CCDirector.getInstance();
		
		if (this._isPointerEnabled) {
			//trace("remove Pointer");
			
		}
		director.getPointerDispatcher().removePointerDelegate(this);
		super.onExit();
		
		//trace("onExit");
	}
	
	public function onPointerDown(event : CCPointer) : Bool {
		return false;
	}
	
	public function onPointerDragged(event : CCPointer) : Bool {
		return false;
	}
	
	public function onPointerMoved(event : CCPointer) : Bool {
		return false;
	}
	
	public function onPointerUp(event : CCPointer) : Bool {
		return false;
	}
	
	public function onKeyDown(event : KeyboardEvent) {
		
	}
	
	public function onKeyUp(event : KeyboardEvent) {
		
	}
	
	public static function create() : CCLayer {
		var ret : CCLayer = new CCLayer();
		if (ret != null && ret.init()) {
			return ret;
		}
		return null;
	}
}