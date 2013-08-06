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
import cc.platform.CCCommon;
import cc.spritenodes.CCAnimation;
import cc.spritenodes.CCSprite;
import cc.cocoa.CCGeometry;
import cc.support.CCPointExtension;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.CCDirector;
/**
 * ...
 * @author Ang Li
 */

class CCAction 
{
	public static var ACTION_TAG_INVALID : Int = -1;
	
	var _originalTarget : CCNode;
	var _target : CCNode;
	var _tag : Int;
	var _animation : CCAnimation;
	public function new() 
	{
		_tag = CCAction.ACTION_TAG_INVALID;
	}
	
	public function descriptioin() : String {
		return "<cc.Action | Tag = " + this._tag + ">";
	}
	
	/**
	 * to copy object with deep copy.
	 * @param {object} zone
	 * @return {object}
	 */
	public function copyWithZone(zone : Dynamic) {
		 return this.copy();
	}
	 
	public function copy() : CCAction{
		 return CCCommon.clone(this);
	}
	
	/**
	 * return true if the action has finished
	 */
	public function isDone() : Bool{
		return true;
	}
	
	/**
	 * called before the action start. It will also set the target.
	 */
	public function startWithTarget(target : CCNode) {
		this._originalTarget = target;
		this._target = target;
	}
	
	/**
     * called after the action has finished. It will set the 'target' to nil.
     * IMPORTANT: You should never call "action stop" manually. Instead, use: "target.stopAction(action);"
     */
	public function stop() {
		this._target = null;
	}
	
	/** called every frame with it's delta time. DON'T override unless you know what you are doing.
     *
     * @param {Number} dt
     */
	public function step(dt : Float) {
		trace("[Action step].. override me");
	}
	
	/**
     <p>called once per frame. time a value between 0 and 1  </P>

     <p>For example:  <br/>
     - 0 means that the action just started <br/>
     - 0.5 means that the action is in the middle<br/>
     - 1 means that the action is over </P>
     * @param {Number}  time
     */
	
	public function update(time : Float) {
		//trace("[Action update]. override me");
	}
	
	public function getTarget() : CCNode {
		return this._target;
	}
	
	public function setTarget(target : CCSprite) {
		this._target = target;
	}
	
	public function getOriginalTarget() : CCNode {
		return this._originalTarget;
	}
	
	/** Set the original target, since target can be nil. <br/>
     * Is the target that were used to run the action.  <br/>
     * Unless you are doing something complex, like cc.ActionManager, you should NOT call this method. <br/>
     * The target is 'assigned', it is not 'retained'. <br/>
     * @param {cc.Node} originalTarget
     */
	public function setOriginalTarget(originalTarget : CCNode) {
		this._originalTarget = originalTarget;
	}
	
	public function getTag() : Int {
		return this._tag;
	}
	
	public function setTag(tag : Int) {
		this._tag = tag;
	}
	
	/**
     * Currently JavaScript Bindigns (JSB), in some cases, needs to use retain and release. This is a bug in JSB,
     * and the ugly workaround is to use retain/release. So, these 2 methods were added to be compatible with JSB.
     * This is a hack, and should be removed once JSB fixes the retain/release bug
     */
    public function retain() {
    }
    public function release() {
    }
	
	public function getAnimation() : CCAnimation {
		return this._animation;
	}
	
	public function setAnimation(animation : CCAnimation) {
		this._animation = animation;
	}
	
	/** Allocates and initializes the action
	 * @returns {cc.Action}
	 * @example
	 * // example
	 * var action = cc.Action.create();
	 */
	 public static function create() : CCAction{
		 return new CCAction();
	 }
}

class CCSpeed extends CCAction
{
	public function new() {
		super();
	}
	var _speed : Float = 0.0;
	
}

class CCFollow extends CCAction
{
	//node to follow
	var _followedNode : CCNode;
	//Whether camera should be limited to certain area
	var _boundarySet : Bool = false;
	//If screen size is bigger than the boundary - update not needed
	var _boundaryFullyCovered : Bool = false;
	//Fast access to the screen dimesions
	var _halfScreenSize : Point;
	var _fullScreenSize : Point;
	
	/** world leftBoundary
     * @Type {Number}
     */
	var leftBoundary : Float = 0.0;
    /** world rightBoundary
     * @Type Number
     */
    var rightBoundary : Float = 0.0;
    /** world topBoundary
     * @Type Number
     */
    var topBoundary : Float = 0.0;
    /** world bottomBoundary
     * @Type {Number}
     */
	var bottomBoundary : Float = 0.0;
	
	public function isBoundarySet() : Bool {
		return this._boundarySet;
	}
	
	public function setBoundarySet(value : Bool) {
		this._boundarySet = value;
	}
	
	public function new() {
		super();
	}
	
	/** initializes the action
     * initializes the action with a set boundary
     * @param {cc.Node} followedNode
     * @param {cc.Rect} rect
     * @return {Boolean}
     */
	public function initWithTarget(followedNode : CCNode, ?rect : Rectangle = null) : Bool{
		CCCommon.assert(followedNode != null, "");
		
		if (rect == null) {
			rect = new Rectangle(0, 0, 0, 0);
		}
		
		this._followedNode = followedNode;
		
		this._boundarySet = !CCGeometry.rectEqualToRect(rect, new Rectangle(0, 0, 0, 0));
		
		this._boundaryFullyCovered = false;
		
		var winSize = CCDirector.getInstance().getWinSize();
		this._fullScreenSize = new Point(winSize.width, winSize.height);
		this._halfScreenSize = CCPointExtension.pMult(this._fullScreenSize, 0.5);
		
		if (this._boundarySet) {
			this.leftBoundary = -((rect.x + rect.width) - this._fullScreenSize.x);
            this.rightBoundary = -rect.x;
            this.topBoundary = -rect.y;
            this.bottomBoundary = -((rect.y + rect.height) - this._fullScreenSize.y);

            if (this.rightBoundary < this.leftBoundary) {
                 //screen width is larger than world's boundary width
                //set both in the middle of the world
                this.rightBoundary = this.leftBoundary = (this.leftBoundary + this.rightBoundary) / 2;
            }
            if (this.topBoundary < this.bottomBoundary) {
                 //screen width is larger than world's boundary width
                //set both in the middle of the world
                this.topBoundary = this.bottomBoundary = (this.topBoundary + this.bottomBoundary) / 2;
            }

            if ((this.topBoundary == this.bottomBoundary) && (this.leftBoundary == this.rightBoundary)) {
                this._boundaryFullyCovered = true;
            }
		}
		return true;
	}
	/*
	override public function step(dt:Float):Dynamic 
	{
		if (this._boundarySet) {
			if (this._boundaryFullyCovered) return;
			
			var tempPos = CCPointExtension.pSub(this._halfScreenSize, this._followedNode.getPosition());
			
			this._target.setPosition(new Point(CCPointExtension.clampf(tempPos.x, this.leftBoundary, this.rightBoundary),
				CCPointExtension.clampf(tempPos.y, this.bottomBoundary, this.topBoundary)));
				
		} else {
			this._target.setPosition(CCPointExtension.pSub(this._halfScreenSize, this._followedNode.getPosition()));
		}
		
	}*/
	
	override public function isDone(): Bool
	{
		return (!this._followedNode.isRunning());
	}
	
	override public function stop()
	{
		this._target = null;
		
	}
	
	
	
	public static function create(followedNode : CCNode, rect : Rectangle) {
		var ret = new CCFollow();
		ret.initWithTarget(followedNode, rect);
		return ret;
	}
}

//Done
class CCFiniteTimeAction extends CCAction {
	var _duration : Float = 0;
	
	public function new() {
		super();
		this._duration = 0;
	}
	
	public function getDuration() : Float {
		return this._duration;
	}
	
	public function setDuration(d : Float) {
		this._duration = d;
	}
	
	public function reverse() {
		
	}
	
	override public function update(time:Float)
	{
		super.update(time);
	}
	
	override public function stop()
	{
		super.stop();
	}
}