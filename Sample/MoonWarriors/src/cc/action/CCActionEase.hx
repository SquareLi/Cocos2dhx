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
import cc.action.CCActionInterval;
import cc.basenodes.CCNode;
import cc.platform.CCCommon;
/**
 * ...
 * @author Ang Li
 */
class CCActionEase extends CCActionInterval
{
	var _other : CCActionInterval;
	private function new() 
	{
		super();
	}
	
	public function initWithAction(action : CCActionInterval) : Bool {
		CCCommon.assert(action != null, "");
		
		if (this.initWithDuration(action.getDuration())) {
			this._other = action;
			return true;
		}
		
		return false;
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		this._other.startWithTarget(this._target);
	}
	
	override public function stop()
	{
		this._other.stop();
		super.stop();
	}
	
	override public function update(time:Float)
	{
		this._other.update(time);
	}
	
	
	public static function create(action : CCActionInterval) : CCActionEase {
		var ret = new CCActionEase();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseRateAction extends CCActionEase {
	var _rate : Float;
	
	private function new() {
		super();
	}
	public function setRate(rate : Float) {
		this._rate = rate;
	}
	
	public function getRate() : Float {
		return this._rate;
	}
	
	public function initWithActionEaseRate(action : CCActionInterval, rate : Float) : Bool {
		if (super.initWithAction(action)) {
			this._rate = rate;
			return true;
		}
		
		return false;
	}
	
	public static function create(action : CCActionInterval, rate : Float) : CCEaseRateAction {
		var ret = new CCEaseRateAction();
		if (ret != null) {
			ret.initWithActionEaseRate(action, rate);
		}
		
		return ret;
	}
}

class CCEaseIn extends CCEaseRateAction {
	
	private function new () {
		super();
	}
	
	override public function update(time:Float) 
	{
		this._other.update(Math.pow(time, this._rate));
	}
	//override public function initWithAction(action:CCActionInterval, rate:Float):Bool 
	//{
		//_ease = function(
	//}
	
	public static function create(action : CCActionInterval, rate : Float) : CCEaseIn {
		var ret = new CCEaseIn();
		if (ret != null) {
			ret.initWithActionEaseRate(action, rate);
		}
		
		return ret;
	}
}

class CCEaseOut extends CCEaseRateAction {
	private function new () {
		super();
	}
	
	override public function update(time:Float) 
	{
		this._other.update(Math.pow(time, 1 / this._rate));
	}
	//override public function initWithAction(action:CCActionInterval, rate:Float):Bool 
	//{
		//_ease = function(
	//}
	
	public static function create(action : CCActionInterval, rate : Float) : CCEaseOut {
		var ret = new CCEaseOut();
		if (ret != null) {
			ret.initWithActionEaseRate(action, rate);
		}
		
		return ret;
	}
}

class CCEaseInOut extends CCEaseRateAction {
	override public function update(time:Float)
	{
		time *= 2;
		if (time < 1) {
			this._other.update(0.5 * Math.pow(time, this._rate));
		} else {
			this._other.update(1.0 - 0.5 * Math.pow(2 - time, this._rate));
		}
	}
	
	public static function create(action : CCActionInterval, rate : Float) : CCEaseInOut{
		var ret = new CCEaseInOut();
		if (ret != null) {
			ret.initWithActionEaseRate(action, rate);
		}
		
		return ret;
	}
}

class CCEaseExponentialIn extends CCActionEase {
	
	override public function update(time:Float)
	{
		this._other.update(time == 0 ? 0 : Math.pow(2, 10 * (time - 1)) - 0.001);
	}
	public static function create(action : CCActionInterval) : CCEaseExponentialIn{
		var ret = new CCEaseExponentialIn();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseExponentialOut extends CCActionEase {
	
	override public function update(time:Float)
	{
		this._other.update(time == 1 ? 1 : (-(Math.pow(2, 10 * time)) + 1));
	}
	public static function create(action : CCActionInterval) : CCEaseExponentialOut{
		var ret = new CCEaseExponentialOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseExponentialInOut extends CCActionEase {
	
	override public function update(time:Float)
	{
		time /= 0.5;
        if (time < 1)
            time = 0.5 * Math.pow(2, 10 * (time - 1));
        else
            time = 0.5 * (-Math.pow(2, -10 * (time - 1)) + 2);

        this._other.update(time);
	}
	public static function create(action : CCActionInterval) : CCEaseExponentialInOut {
		var ret = new CCEaseExponentialInOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseSineIn extends CCActionEase {
	
	override public function update(time:Float) 
	{
		this._other.update(-1 * Math.cos(time * Math.PI / 2) + 1);
	}
	
	public static function create(action : CCActionInterval) : CCEaseSineIn{
		var ret = new CCEaseSineIn();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseSineOut extends CCActionEase {
	
	override public function update(time:Float) 
	{
		this._other.update(Math.sin(time * Math.PI / 2));
	}
	
	public static function create(action : CCActionInterval) : CCEaseSineOut {
		var ret = new CCEaseSineOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseSineInOut extends CCActionEase {
	
	override public function update(time:Float) 
	{
		this._other.update(-0.5 * (Math.cos(Math.PI * time) - 1));
	}
	
	public static function create(action : CCActionInterval) : CCEaseSineInOut{
		var ret = new CCEaseSineInOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseElastic extends CCActionEase {
	var _period : Float;
	public function getPeriod() : Float {
		return this._period;
	}
	
	public function setPeroid(period : Float) : Float {
		return this._period = period;
	}
	
	public function initWithActionEaseElastic(action:CCActionInterval, ?period : Float):Bool 
	{
		super.initWithAction(action);
		this._period = (period == null) ? 3.0 : period;
		return true;
	}
	
	public static function create(action : CCActionInterval, ?period : Float) : CCEaseElastic {
		var ret : CCEaseElastic = new CCEaseElastic();
		if (ret != null) {
			ret.initWithActionEaseElastic(action, period);
		}
		return ret;
	}
}

/**
 * Ease Elastic In action.
 * @warning This action doesn't use a bijective fucntion. Actions like Sequence might have an unexpected result when used with this action.
 * @class
 * @extends cc.EaseElastic
 */
class CCEaseElasticIn extends CCEaseElastic {
    /**
     * @param {Number} time1
     */
    override public function update(time : Float) {
        var newT : Float = 0;
        if (time == 0 || time == 1) {
            newT = time;
        } else {
            var s = this._period / 4;
            time = time - 1;
            newT = -Math.pow(2, 10 * time) * Math.sin((time - s) * Math.PI * 2 / this._period);
        }

        this._other.update(newT);
    }

    public static function create(action : CCActionInterval, ?period : Float) : CCEaseElasticIn {
		var ret : CCEaseElasticIn = new CCEaseElasticIn();
		if (ret != null) {
			ret.initWithActionEaseElastic(action, period);
		}
		return ret;
	}
}

class CCEaseElasticOut extends CCEaseElastic {
    /**
     * @param {Number} time1
     */
    override public function update (time : Float) {
        var newT : Float = 0;
        if (time == 0 || time == 1) {
            newT = time;
        } else {
            var s = this._period / 4;
            newT = Math.pow(2, -10 * time) * Math.sin((time - s) * Math.PI * 2 / this._period) + 1;
        }

        this._other.update(newT);
    }

    public static function create(action : CCActionInterval, ?period : Float) : CCEaseElasticOut {
		var ret : CCEaseElasticOut = new CCEaseElasticOut();
		if (ret != null) {
			ret.initWithActionEaseElastic(action, period);
		}
		return ret;
	}
}

class CCEaseElasticInOut extends CCEaseElastic {
    /**
     * @param {Number} time1
     */
    override public function update (time : Float) {
        var newT :Float = 0;
        if (time == 0 || time == 1) {
            newT = time;
        } else {
            time = time * 2;
            //if (this._period == null)
                //this._period = 0.3 * 1.5;

            var s = this._period / 4;
            time = time - 1;
            if (time < 0)
                newT = -0.5 * Math.pow(2, 10 * time) * Math.sin((time - s) * Math.PI * 2 / this._period);
            else
                newT = Math.pow(2, -10 * time) * Math.sin((time - s) * Math.PI * 2 / this._period) * 0.5 + 1;
        }
        this._other.update(newT);
    }

    public static function create(action : CCActionInterval, ?period : Float) : CCEaseElasticInOut {
		var ret : CCEaseElasticInOut = new CCEaseElasticInOut();
		if (ret != null) {
			ret.initWithActionEaseElastic(action, period);
		}
		return ret;
	}
}

class CCEaseBounce extends CCActionEase {
	public function bounceTime(time : Float) : Float{
		if (time < 1 / 2.75) {
			return 7.5625 * time * time;
		} else if (time < 2.75) {
			time -= 1.5 / 2.75;
			return 7.5625 * time * time + 0.75;
		} else if (time < 2.5 / 2.75) {
			time -= 2.25 / 2.75;
            return 7.5625 * time * time + 0.9375;
		}
		
		time -= 2.625 / 2.75;
		return 7.5625 * time * time + 0.984375;
	}
	
	public static function create(action : CCActionInterval) : CCEaseBounce{
		var ret = new CCEaseBounce();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseBounceIn extends CCEaseBounce {
	override public function update(time:Float)
	{
		var newT = 1 - this.bounceTime(1 - time);
        this._other.update(newT);
	}
	
	public static function create(action : CCActionInterval) : CCEaseBounceIn {
		var ret = new CCEaseBounceIn();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseBounceOut extends CCEaseBounce {
	override public function update(time:Float)
	{
		var newT = this.bounceTime(time);
        this._other.update(newT);
	}
	
	public static function create(action : CCActionInterval) : CCEaseBounceOut {
		var ret = new CCEaseBounceOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseBounceInOut extends CCEaseBounce {
	override public function update(time:Float)
	{
		var newT : Float= 0;
        if (time < 0.5) {
            time = time * 2;
            newT = (1 - this.bounceTime(1 - time)) * 0.5;
        } else {
            newT = this.bounceTime(time * 2 - 1) * 0.5 + 0.5;
        }

		 this._other.update(newT);
	}
	
	public static function create(action : CCActionInterval) : CCEaseBounceInOut {
		var ret = new CCEaseBounceInOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseBackIn extends CCActionEase {
	override public function update(time:Float)
	{
		var overshoot = 1.70158;
        this._other.update(time * time * ((overshoot + 1) * time - overshoot));
	}
	
	public static function create(action : CCActionInterval) : CCEaseBackIn {
		var ret = new CCEaseBackIn();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseBackOut extends CCActionEase {
	override public function update(time:Float)
	{
		var overshoot = 1.70158;

        time = time - 1;
        this._other.update(time * time * ((overshoot + 1) * time + overshoot) + 1);
	}
	
	public static function create(action : CCActionInterval) : CCEaseBackOut {
		var ret = new CCEaseBackOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}

class CCEaseBackInOut extends CCActionEase {
	override public function update(time:Float)
	{
		var overshoot = 1.70158;

        time = time * 2;
        if (time < 1) {
            this._other.update((time * time * ((overshoot + 1) * time - overshoot)) / 2);
        } else {
            time = time - 2;
            this._other.update((time * time * ((overshoot + 1) * time + overshoot)) / 2 + 1);
        }
	}
	
	public static function create(action : CCActionInterval) : CCEaseBackInOut {
		var ret = new CCEaseBackInOut();
		if (ret != null) {
			ret.initWithAction(action);
		}
		
		return ret;
	}
}