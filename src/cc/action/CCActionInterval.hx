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
import cc.spritenodes.CCAnimation;
import cc.action.CCAction;
import cc.spritenodes.CCSprite;
import cc.spritenodes.CCSpriteFrame;
import flambe.math.Point;
import flambe.swf.MovieSprite;
import haxe.remoting.FlashJsConnection;

/**
 * ...
 * @author Ang Li
 */

class CCActionInterval extends CCFiniteTimeAction
{
	var _elapsed : Float;
	var _firstTick : Bool;
	
	public function new() 
	{
		super();
		_elapsed = 0;
		_firstTick = false;
	}
	
	/** How many seconds had elapsed since the actions started to run
	 */
	public function getElapsed() : Float {
		return this._elapsed;
	}
	
	/**initializes the action**/
	public function initWithDuration(d : Float) : Bool {
		this._duration = d;
		this._elapsed = 0;
		this._firstTick = true;
		return true;
	}
	
	/** returns true if the action has finished **/
	override public function isDone() : Bool {
		return (this._elapsed >= this._duration);
	}
	
	override public function step(dt : Float) {
		if (this._firstTick) {
			this._firstTick = false;
			this._elapsed = 0;
		} else {
			this._elapsed += dt;
		}
		
		if (this._duration < 0.0000001192092896) {
			this._duration = 0.0000001192092896;
		} 
		
		var t : Float = this._elapsed / this._duration;
		
		if (1 < t) {
			t = 1;
		} 
		
		if (t < 0) {
			t = 0;
		}
		
		update(t);
	}
	
	override public function update(time:Float)
	{
		super.update(time);
		
	}
	override public function stop() {
		super.stop();
	}
	
	override public function startWithTarget(target : CCNode) {
		super.startWithTarget(target);
		this._elapsed = 0;
		this._firstTick = true;
	}
}

/** Runs actions sequentially, one after another
 * @class
 * @extends cc.ActionInterval
 */
class CCSequence extends CCActionInterval {
	var _actions : Array<CCFiniteTimeAction>;
	var _split : Float;
	var _last : Float;
	
	private function new() {
		super();
		this._actions = new Array<CCFiniteTimeAction>();
	}
	
	/** initializes the action <br/>
     * @param {cc.FiniteTimeAction} actionOne
     * @param {cc.FiniteTimeAction} actionTwo
     * @return {Boolean}
     */
	public function initOneTwo(actionOne : CCFiniteTimeAction, actionTwo : CCFiniteTimeAction) : Bool{
		var one : Float = actionOne.getDuration();
		var two : Float = actionTwo.getDuration();
		
		var d : Float = actionOne.getDuration() + actionTwo.getDuration();
		this.initWithDuration(d);
		
		this._actions[0] = actionOne;
		this._actions[1] = actionTwo;
		
		return true;
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		
		this._split = this._actions[0].getDuration() / this._duration;
		this._last = -1;
	}
	
	override public function update(time:Float)
	{
		super.update(time);
		var new_t : Float = 0;
		var found : Int = 0;
		if (time < this._split) {
			//action[0]
			new_t = (this._split != 0) ? time / this._split : 1;
		} else {
			found = 1;
			new_t = (this._split == 1) ? 1 : (time - this._split) / (1 - this._split);
			
			if (this._last == -1) {
				// action[0] was skipped, execute it.
				this._actions[0].startWithTarget(this._target);
				this._actions[0].update(1);
				this._actions[0].stop();
			}
			
			if (this._last == 0) {
				// switching to action 1. stop action 0.
				this._actions[0].update(1);
				this._actions[0].stop();
			}
		}
		
		//Last action found and it is done.
		if (this._last == found && this._actions[found].isDone()) {
			return;
		}
		
		//Last action found and it is done
		if (this._last != found) {
			this._actions[found].startWithTarget(this._target);
		}
		
		this._actions[found].update(new_t);
		this._last = found;
	}
	
	
	public static function create(?tempArray : Array<CCFiniteTimeAction>) : CCFiniteTimeAction {
		var paraArray : Array<CCFiniteTimeAction> = tempArray;
		var prev : CCFiniteTimeAction = paraArray[0];
		for (i in 1...paraArray.length) {
			if (paraArray[i] != null) {
				prev = CCSequence._actionOneTwo(prev, paraArray[i]);
			}
		}
		
		return prev;
	}
	
	public static function _actionOneTwo(actionOne : CCFiniteTimeAction, actionTwo : CCFiniteTimeAction) : CCSequence {
		var sequence : CCSequence = new CCSequence();
		sequence.initOneTwo(actionOne, actionTwo);
		return sequence;
	}
}

class CCRepeat extends CCActionInterval {
	var _times : Float = 0;
	var _total : Float = 0;
	var _nextDt : Float = 0;
	var _actionInstant : Bool = false;
	var _innerAction : CCFiniteTimeAction;
	var _passTime : Float = 0;
	
	public function initWithActionRepeat(action : CCFiniteTimeAction, times : Float) : Bool{
		var duration : Float = action.getDuration() * times;
		
		if (this.initWithDuration(duration)) {
			this._times = times;
			this._innerAction = action;
			
			//if (Std.is(action, 
		}
		
		this._total = 0;
		return true;
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		
		this._total = 0;
		this._nextDt = this._innerAction.getDuration() / this._duration;
		
		this._innerAction.startWithTarget(target);
	}
	
	override public function stop()
	{
		this._innerAction.stop();
		super.stop();
	}
	
	override public function update(time:Float)
	{
		super.update(time);
		
		this._innerAction.update(time);
		
		_passTime += time;
		
		if (_passTime >= this._innerAction.getDuration()) {
			_passTime = 0;
			_times++;
			
			if (_times >= _total) {
				this.stop();
			}
		}
		
	}
	
	override public function isDone():Bool 
	{
		return this._total == this._times;
	}
	
	public function setInnerAction(action : CCFiniteTimeAction) {
		if (this._innerAction != action) {
			this._innerAction = action;
		}
	}
	
	public function getInnerAction() : CCFiniteTimeAction {
		return this._innerAction;
	}
	
	public static function create(action : CCFiniteTimeAction, times : Float) {
		var repeat : CCRepeat = new CCRepeat();
		repeat.initWithActionRepeat(action, times);
		return repeat;
	}
}

class CCRepeatForever extends CCActionInterval {
	var _innerAction : CCActionInterval;
	
	public function new() {
		super();
	}
	public function initWithAction(action : CCActionInterval) : Bool {
		this._innerAction = action;
		return true;
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		this._innerAction.startWithTarget(target);
	}
	
	override public function step(dt:Float)
	{
		this._innerAction.step(dt);
		if (this._innerAction.isDone()) {
			this._innerAction.startWithTarget(this._target);
			this._innerAction.step(this._innerAction.getElapsed() - this._innerAction.getDuration());
		}
	}
	
	override public function isDone():Bool 
	{
		return false;
	}
	
	public function setInnerAction(action : CCActionInterval) {
		if (this._innerAction != action) {
			this._innerAction = action;
		}
	}
	
	public function getInnerAction() : CCActionInterval {
		return this._innerAction;
	}
	
	public static function create(action : CCActionInterval) : CCRepeatForever {
		var ret : CCRepeatForever = new CCRepeatForever();
		if (ret != null && ret.initWithAction(action)) {
			return ret;
		}
		
		return null;
	}
}


class CCAnimate extends CCActionInterval
{
	//var _animation : CCAnimation;
	var _nextFrame : Int;
	var _origFrame : CCSpriteFrame;
	var _excutedLoops : Float;
	var _splitTimes : Array<Float>;
	var _delatPerUnit : Float;
	
	//var _frames : Map<String, Float>;
	
	public function new() {
		super();
		//_frames = new Map<String,Float>();
		
	}
	
	public function initWithAnimation(animation : CCAnimation) : Bool{
		var singleDuration : Float = animation.getDuration();
		
		this.initWithDuration(singleDuration * animation.getLoops());
		this._nextFrame = 0;
		this.setAnimation(animation);
		
		this._origFrame = this._animation.getFrames()[0].getSpriteFrame();
		this._excutedLoops = 0;
		this._splitTimes = new Array<Float>();
		
		var accumUnitsOfTime : Float = 0;
		var newwUnitOfTimeValue = singleDuration / animation.getTotalDelayUnits();
		var frames : Array<CCAnimationFrame> = animation.getFrames();
		
		for (f in frames) {
			var frame : CCAnimationFrame = f;
			
			var value = (accumUnitsOfTime * newwUnitOfTimeValue) / singleDuration;
			accumUnitsOfTime += frame.getDelayUnits();
			this._splitTimes.push(value);
		}
		
		this._delatPerUnit = this._animation.getDelayPerUnit();
		return true;
	}
	
	override public function startWithTarget(target : CCNode) {
		//var movieSprite = this.getAnimation().getMovieSprite();
		//movieSprite.paused = false;
		//target.getEntity().add(movieSprite);
		super.startWithTarget(target);
		if (this._animation.getRestoreOriginalFrame()) {
			var t = cast (target, CCSprite);
			this._origFrame = t.displayFrame();
		}
		
		this._nextFrame = 0;
		this._excutedLoops = 0;
	}
	
	var index : Int = 0;
	var timer : Float = 0;
	override public function update(time:Float)
	{	
		//trace("update");
		//if (this._target == null) {
			//return;
		//}
		//if (timer <= 0) {
			//trace(_nextFrame);
			//var a : Array<CCAnimationFrame> = this._animation.getFrames();
			//
			//
			//
			//trace(a[_nextFrame].getSpriteFrame().toString());
			//this._target.setDisplayFrame(a[_nextFrame].getSpriteFrame());
			//timer = this._delatPerUnit;
			//_nextFrame++;
			//if (_nextFrame == a.length) {
				//_nextFrame = 0;
				//this._excutedLoops++;
				//if (this._excutedLoops == this._animation.getLoops()) {
					//this.stop();
				//}
			//}
		//}
		//timer -= time;
		// if t==1, ignore. Animation should finish with t==1
		if (time < 1.0) {
			time *= this._animation.getLoops();
			
			// new loop?  If so, reset frame counter
			var loopNumber : Float = time;
			if (loopNumber > this._excutedLoops) {
				this._nextFrame = 0;
				this._excutedLoops++;
			}
			
			timer = time % 1.0;
		}
		
		var frames = this._animation.getFrames();
		var numberOfFrames : Int = frames.length;
		for (i in this._nextFrame...numberOfFrames) {
			if (this._splitTimes[i] < time) {
				//trace(i);
				var t : CCSprite = cast (this._target, CCSprite);
				t.setDisplayFrame(frames[i].getSpriteFrame());
				this._nextFrame = i + 1;
				break;
			}
		}	
	}
	
	override public function stop() {
		if (this._animation.getRestoreOriginalFrame() && this._target != null) {
			var t : CCSprite = cast (this._target, CCSprite);
			t.setDisplayFrame(this._origFrame);
		}
		
		super.stop();
	}
	
	public static function create(animation : CCAnimation) : CCAnimate{
		var animate = new CCAnimate();
		animate.initWithAnimation(animation);
		return animate;
	}
}


class CCMoveTo extends CCActionInterval {
	var _endPosition : Point;
	var _startPosition : Point;
	var _delta : Point;
	var _isMoveTo : Bool = true;
	
	public function new() {
		super();
		
		_endPosition = new Point(0, 0);
		_startPosition = new Point(0, 0);
		_delta = new Point(0, 0);
	}
	
	//Haxe does not support overload
	public function initWithDurationMoveTo(duration : Float, position) {
		super.initWithDuration(duration);
		this._endPosition = position;	
	}
	
	override public function update(time:Float)
	{
		_target.syncPosition();
	}
	override public function startWithTarget(target:CCNode) 
	{
		super.startWithTarget(target);
		if (this._target.getSprite() == null) {
			return;
		}
		
		if (this._isMoveTo) {
			this._target.getSprite().x.animateTo(_endPosition.x, this.getDuration());
			this._target.getSprite().y.animateTo(_endPosition.y, this.getDuration());
			//trace("123");
		}
		
	}
	
	public static function create(duration : Float, position : Point) : CCMoveTo {
		var moveTo = new CCMoveTo();
		moveTo.initWithDurationMoveTo(duration, position);
		return moveTo;
	}
}



class CCMoveBy extends CCMoveTo {
	override public function initWithDurationMoveTo(duration:Float, position)
	{
		super.initWithDurationMoveTo(duration, position);
		this._delta = position;
		this._isMoveTo = false;
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		if (this._target.getSprite() == null) {
			return;
		}
		this._target.getSprite().x.animateBy(_endPosition.x, this.getDuration());
		this._target.getSprite().y.animateBy(_endPosition.y, this.getDuration());
	
	}	
	public static function create(duration : Float, position : Point) : CCMoveBy{
		var moveBy : CCMoveBy = new CCMoveBy();
		moveBy.initWithDurationMoveTo(duration, position);
		return  moveBy;
	}
}

class CCScaleTo extends CCActionInterval {
	var _scaleX : Float;
	var _scaleY : Float;
	var _startScaleX : Float;
	var _startSclaeY : Float;
	var _endScaleX : Float;
	var _endScaleY : Float;
	var _deltaX : Float;
	var _deltaY : Float;
	var _isTo : Bool = true;
	
	private function new() {
		super();
		_scaleX = 1;
		_scaleY = 1;
		_startScaleX = 1;
		_startSclaeY = 1;
		_endScaleX = 0;
		_endScaleY = 0;
		_deltaX = 0;
		_deltaY = 0;
	}
	
	public function initWithDurationScaleTo(duration : Float, sx : Float, ?sy : Float) : Bool{
		super.initWithDuration(duration);
		this._endScaleX = sx;
		if (sy == null) {
			this._endScaleY = sx;
		} else {
			this._endScaleY = sy;
		}
		
		return true;
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		this._startScaleX = target.getScaleX();
		this._startSclaeY = target.getScaleY();
		this._deltaX = this._endScaleX - this._startScaleX;
		this._deltaY = this._endScaleY - this._startSclaeY;
		
		if (this._isTo) {
			this._target.getSprite().scaleX.animateTo(this._endScaleX, this._duration);
			this._target.getSprite().scaleY.animateTo(this._endScaleY, this._duration);
			
		}
		
	}
	
	public static function create(duration : Float, sx : Float, ?sy : Float) : CCScaleTo {
		var scaleTo : CCScaleTo = new CCScaleTo();
		if (sy == null) {
			scaleTo.initWithDurationScaleTo(duration, sx);
		} else {
			scaleTo.initWithDurationScaleTo(duration, sx, sy);
		}
		
		return scaleTo;
	}
}

class CCScaleBy extends CCScaleTo{
	override public function startWithTarget(target:CCNode)
	{
		this._isTo = false;
		
		super.startWithTarget(target);
		this._target.getSprite().scaleX.animateBy(_endScaleX, _duration);
		this._target.getSprite().scaleY.animateBy(this._endScaleY, this._duration);
	}
	
	public static function create(duration : Float, sx : Float, ?sy : Float) : CCScaleBy {
		var scaleBy : CCScaleBy = new CCScaleBy();
		if (sy == null) {
			scaleBy.initWithDurationScaleTo(duration, sx);
		} else {
			scaleBy.initWithDurationScaleTo(duration, sx, sy);
		}
		
		return scaleBy;
	}
}

class CCFadeOut extends CCActionInterval {
	public function new() {
		super();
	}
	override public function update(time:Float)
	{
		//this._target.setOpacity
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		this._target.getSprite().alpha.animateTo(0, _duration);
	}
	
	public static function create(d : Float) {
		var action : CCFadeOut = new CCFadeOut();
		action.initWithDuration(d);
		
		return action;
	}
}