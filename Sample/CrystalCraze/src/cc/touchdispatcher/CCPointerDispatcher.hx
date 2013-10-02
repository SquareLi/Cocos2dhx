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

package cc.touchdispatcher;

import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.System;
import cc.CCDirector;
import cc.CCScheduler;

/**
 * ...
 * @author Ang Li
 */

class CCPointerDispatcher 
{
	var _pointerPressed : Bool;
	var _pointerDelegateHandlers : Array<CCPointerHandler>;
	var _dispatchEvents : Bool;
	
	public static var POINTER_DOWN : Int = 0;
	public static var POINTER_UP : Int = 3 ;
	public static var POINTER_MOVED : Int = 1;
	public static var POINTER_DRAGGED : Int = 2;
	public static var _prePoint : Point = new Point(0, 0);
	
	public function new() 
	{
		this._dispatchEvents = true;
		this._pointerPressed = false;
		this._pointerDelegateHandlers = new Array<CCPointerHandler>();
		CCPointerDispatcher._registerPointerEvent();
	}
	
	public function _setPointerPressed(pressed : Bool) {
		this._pointerPressed = pressed;
	}
	
	public function _getPointerPressed() : Bool {
		return this._pointerPressed;
	}
	
	public function addPointerDelegate(delegate : CCPointerEventDelegate, priority : Int) {
		//trace("add");
		var handler : CCPointerHandler = CCPointerHandler.create(delegate, priority);
		
		this._pointerDelegateHandlers = this.forceAddHandler(handler, this._pointerDelegateHandlers);
	}
	
	public function forceAddHandler(handler : CCPointerHandler, array : Array<CCPointerHandler>) : Array<CCPointerHandler> {
		
		
		var u = 0;
		
		for (i in 0...array.length) {
			var h : CCPointerHandler = array[i];
			
			if (h != null) {
				if (h.getPriority() < handler.getPriority()) {
					++u;
				}
			}
			
			if (h.getDelegate() == handler.getDelegate()) {
				return array;
			}
		}
		
		return CCScheduler.ArrayAppendObjectToIndex(array, handler, u);
	}
	
	public function removePointerDelegate(delegate : CCPointerEventDelegate) {

		if (delegate == null) return;
		for (i in 0...this._pointerDelegateHandlers.length) {
			var handler = this._pointerDelegateHandlers[i];
			if (handler != null && handler.getDelegate() == delegate) {
				
				CCScheduler.ArrayRemoveObject(this._pointerDelegateHandlers, handler);
				break;
			}
		}
	}
	
	private function _findHandler(delegate : CCPointerEventDelegate) : CCPointerHandler {
		for (i in 0...this._pointerDelegateHandlers.length) {
			if (this._pointerDelegateHandlers[i] != null 
				&& this._pointerDelegateHandlers[i].getDelegate() == delegate) {
				return this._pointerDelegateHandlers[i];	
			}
		}
		
		return null;
	}
	
	public function setPriority(priority : Int, delegate : CCPointerEventDelegate) {
		if (delegate == null) return;
		var handler : CCPointerHandler = this._findHandler(delegate);
		if (handler == null) return;
		
		if (handler.getPriority() != priority) {
			handler.setPriority(priority);
			this._pointerDelegateHandlers.sort(less);
		}
	}
	
	public function removeAllMouseDelegates() {
		this._pointerDelegateHandlers = [];
	}
	
	public function pointerHandle(pointerObj : CCPointer, event : PointerEvent, index : Int) {
		
		var a : Int = 0;
		var b : Int = 3;
		var c : Int = 1;
		var b : Bool = false;
		for (h in this._pointerDelegateHandlers) {
			switch(index) {
				case 0:
					b = h.getDelegate().onPointerDown(pointerObj);
					//trace(this._pointerDelegateHandlers.length);
				case 3:
					b = h.getDelegate().onPointerUp(pointerObj);
				case 1:
					if (this._pointerPressed) {
						b = h.getDelegate().onPointerDragged(pointerObj);
					} else {
						b = h.getDelegate().onPointerMoved(pointerObj);
					}
			}
			if (b) {
				return;
			}
		}
	}
	
	public static function less(p1 : CCPointerHandler, p2 : CCPointerHandler) : Int {
		if (p1.getPriority() > p2.getPriority()) {
			return 1;
		} else if (p1.getPriority() == p2.getPriority()) {
			return 0;
		} else {
			return -1;
		}
	}
	public static function getPointerByEvent(event : PointerEvent) : CCPointer {
		var tx = event.viewX;
		var ty = event.viewY;
		
		var pointer : CCPointer = new CCPointer(tx, ty);
		pointer._setPrevPoint(_prePoint.x, _prePoint.y);
		
		CCPointerDispatcher._prePoint.x = tx;
		CCPointerDispatcher._prePoint.y = ty;
		
		return pointer;
	}
	
	public static function _registerPointerEvent() {
		System.pointer.down.connect(function(event : PointerEvent) {
			CCDirector.getInstance().getPointerDispatcher()._setPointerPressed(true);
			CCDirector.getInstance().getPointerDispatcher()
			.pointerHandle(getPointerByEvent(event), event, CCPointerDispatcher.POINTER_DOWN);
		});
		
		System.pointer.up.connect(function(event : PointerEvent) {
			CCDirector.getInstance().getPointerDispatcher()._setPointerPressed(false);
			CCDirector.getInstance().getPointerDispatcher()
			.pointerHandle(getPointerByEvent(event), event, CCPointerDispatcher.POINTER_UP);
		});
		
		System.pointer.move.connect(function(event : PointerEvent) {
			CCDirector.getInstance().getPointerDispatcher()
			.pointerHandle(getPointerByEvent(event), event, CCPointerDispatcher.POINTER_MOVED);
		});
	}
}






