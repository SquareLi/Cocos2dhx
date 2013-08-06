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
package cc.action;
import cc.spritenodes.CCSprite;
import cc.action.CCAction;

/**
 * ...
 * @author Ang Li
 */
class CCActionInstant extends CCFiniteTimeAction
{

	public function new() 
	{
		super();
	}
	
	override public function isDone():Bool 
	{
		return true;
	}
	
	override public function step(dt:Float)
	{
		this.update(1);
	}
	
	override public function update(time:Float)
	{
		
	}
}

class CCCallFunc extends CCActionInstant
{
	var _data : Dynamic;
	var _callFunc : Void -> Void;
	var _selectorTarget : CCSprite;
	private function new() {
		super();
	}
	
	public function initWithTargetCallFunc(selector : Void -> Void, selectorTarget : CCSprite, ?data : Dynamic) {
		this._data = data;
		this._callFunc = selector;
		this._selectorTarget = selectorTarget;
		return true;
	}
	
	public function execute() {
		if (this._callFunc != null) {
			this._callFunc();
		}
	}
	
	override public function update(time:Float)
	{
		this.execute();
	}
	
	public function getTargetCallback() : CCSprite {
		return this._selectorTarget;
	}
	
	public function setTargeetCallback(sel : CCSprite) {
		if (sel != this._selectorTarget) {
			if (this._selectorTarget != null) {
				this._selectorTarget = null;
			}
			this._selectorTarget = sel;
		}
	}
	
	public static function create(selector : Void -> Void, selectorTarget : CCSprite, ?data : Dynamic) {
		var ret : CCCallFunc = new CCCallFunc();
		if (ret != null) {
			ret._callFunc = selector;
			return ret;
		}
		
		return null;
	}
}