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
import cc.basenodes.CCNode;
import cc.spritenodes.CCSprite;

/**
 * 
 * @author Ang L1
 */

class CCActionManager 
{
	var _targets : Array<MapElement>;
	var _currentTarget : CCNode;
	var _currentTargetSalvaged : Bool;
	public function new() 
	{
		_targets = new Array<MapElement>();
	}
	
	private function _searchElementByTarget(arr : Array<MapElement>, target : CCNode) : MapElement{
		for (n in arr) {
			if (target == n.target) {
				return n;
			}
		}
		return null;
	}
	
	private function _actionAllocWithHashElement(element : MapElement) {
		if (element.actions == null) {
			element.actions = new Array<CCAction>();
		}
	}
	
	public function addAction(action : CCAction, target : CCNode, paused : Bool) {
		var element : MapElement = this._searchElementByTarget(this._targets, target);
		if (element == null) {
			element = new MapElement();
			element.paused = paused;
			element.target = target;
			this._targets.push(element);
		}
		
		//var t : CCSprite = cast (target, CCSprite);
		_actionAllocWithHashElement(element);
		action.startWithTarget(target);
		
	}
	
}

class MapElement {
	public var actions : Array<CCAction>;
	public var target : CCNode;
	public var actionIndex : Int = 0;
	public var currentAction : CCAction;
	public var currentActionSalvaged : Bool;
	public var paused : Bool;
	
	public function new() {
		this.actions = new Array<CCAction>();
	}
	
	public function setPaused(v : Bool) {
		//this.paused = v;
		//this.actions[0].getAnimation().getMovieSprite().paused = v;
	}
	
}