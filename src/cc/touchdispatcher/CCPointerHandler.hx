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

/**
 * ...
 * @author Ang Li
 */

class CCPointerHandler
{
	var _delegate : CCPointerEventDelegate;
	var _priority : Int = 0;
	var _enabledSelectors : Int = 0;
	
	var _claimedPointers : Array<CCPointer>;
	
	public function new() {
		
	}
	
	public function getDelegate() : CCPointerEventDelegate {
		return this._delegate;
	}
	
	public function setDelegate(delegate : CCPointerEventDelegate) {
		this._delegate = delegate;
	}
	
	public function getPriority() : Int {
		return this._priority;
	}
	
	public function setPriority(p : Int) {
		this._priority = p;
	}
	
	public function getEnabledSelectors() : Int {
		return this._enabledSelectors;
	}
	
	public function setEnabledSelectors(value : Int) {
		this._enabledSelectors = value;
	}
	
	public function getClaimedTouches() : Array<CCPointer> {
		return this._claimedPointers;
	}
	
	public function initWithDelegate(delegate : CCPointerEventDelegate, priority : Int) {
		this._delegate = delegate;
		this._priority = priority;
		this._claimedPointers = new Array<CCPointer>();
	}
	
	public static function create(delegate : CCPointerEventDelegate, priority : Int) : CCPointerHandler {
		var handler = new CCPointerHandler();
		handler.initWithDelegate(delegate, priority);
		return handler;
	}
}