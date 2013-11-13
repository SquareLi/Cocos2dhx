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

package cc.spritenodes;
import cc.texture.CCTexture2D;
import flambe.math.Rectangle;
import flambe.swf.MovieSprite;
import cc.platform.CCPlistEntry;
/**
 * ...
 * @author
 */

class CCAnimation 
{
	var _frames : Array<CCAnimationFrame>;
	var _loops : Int;
	var _restoreOriginalFrame : Bool;
	var _duration : Float;
	var _delayPerUnit : Float;
	var _totalDelayUnits : Float;
	
	private function new() 
	{
		this._frames = new Array<CCAnimationFrame>();
		_restoreOriginalFrame = true;
		_loops = 0;
		_duration = 0;
		this._delayPerUnit = 0;
		this._totalDelayUnits = 0;
	}
	
	//Return a Flambe Movie Sprite
	//MovieSprite contains all the info about the animation
	public function getFrames() : Array<CCAnimationFrame>{
		return this._frames;
	}
	
	public function setFrames(frames : Array<CCAnimationFrame>) {
		this._frames = frames;
	}
	
	public function addSpriteFrame(frame : CCSpriteFrame) {
		var animFrame : CCAnimationFrame = new CCAnimationFrame();
		animFrame.initWithSpriteFrame(frame, 1, null);
		this._frames.push(animFrame);
		this._totalDelayUnits++;
	}
	
	/**
     * Adds a frame with an image filename. Internally it will create a cc.SpriteFrame and it will add it. The frame will be added with one "delay unit".
     * @param {String} fileName
     */
	public function addSpriteFrameWithFile(fileName : String) {
		
	}
	
	/**
     * Adds a frame with a texture and a rect. Internally it will create a cc.SpriteFrame and it will add it. The frame will be added with one "delay unit".
     * @param {cc.Texture2D} texture
     * @param {cc.Rect} rect
     */
	public function addSpriteFrameWithTexture(texture : CCTexture2D, rect : Rectangle) {
		
	}
	
	/**
     * Initializes a cc.Animation with cc.AnimationFrame
     * @param {Array} arrayOfAnimationFrames
     * @param {Number} delayPerUnit
     * @param {Number} loops
     */
	public function initWithAnimationFrames(arrayOfAnimationFrames : Array<CCAnimationFrame>, delayPerUnit : Float, loops : Int) : Bool {
		this._delayPerUnit = delayPerUnit;
		this._loops = loops;
		
		this.setFrames(new Array<CCAnimationFrame>());
		for (a in arrayOfAnimationFrames) {
			var animFrame : CCAnimationFrame = a;
			this._frames.push(animFrame);
			this._totalDelayUnits += animFrame.getDelayUnits();
		}
		
		return true;
	}
	public function getLoops() : Int {
		return this._loops;
	}
	
	public function setLoops(value : Int) {
		this._loops = value;
	}
	
	public function getRestoreOriginalFrame() : Bool {
		return this._restoreOriginalFrame;
	}
	
	public function setRestoreOriginalFrame(v : Bool) {
		this._restoreOriginalFrame = v;
	}
	
	public function getDuration() : Float {
		return this._totalDelayUnits * this._delayPerUnit;
	}
	
	public function getDelayPerUnit() : Float {
		return this._delayPerUnit;
	}

	public function setDelayPerUnit(delayPerUnit : Float) {
		this._delayPerUnit = delayPerUnit;
	}
	
	public function getTotalDelayUnits() : Float {
		return this._totalDelayUnits;
	}
	/**
     * Initializes a cc.Animation with frames and a delay between frames
     * @param {Array} frames
     * @param {Number} delay
     */
	public function initWithSpriteFrames(frames : Array<CCSpriteFrame>, delay : Float) : Bool {
		this._loops = 1;
		this._delayPerUnit = delay;
		
		var tempFrames : Array<CCAnimationFrame> = new Array<CCAnimationFrame>();
		this.setFrames(tempFrames);
		
		if (frames != null ) {
			for (f in frames) {
				var frame : CCSpriteFrame = f;
				var animFrame = new CCAnimationFrame();
				animFrame.initWithSpriteFrame(frame, 1, null);
				this._frames.push(animFrame);
				this._totalDelayUnits++;
				//trace(f.toString());
			}
		}
		return true;
	}
	
	/**
	 * Creates an animation.
	 * @param {Array} frames
	 * @param {Number} delay
	 * @param {Number} loops
	 * @return {cc.Animation}
	 * @example
	 * //Creates an animation
	 * var animation1 = cc.Animation.create();
	 *
	 * //Create an animation with sprite frames
	 * var animFrames = [];
	 * var frame = cache.getSpriteFrame("grossini_dance_01.png");
	 * animFrames.push(frame);
	 * var animation2 = cc.Animation.create(animFrames);
	 *
	 * //Create an animation with sprite frames and delay
	 * var animation3 = cc.Animation.create(animFrames, 0.2);
	 */
	public static function create(frames : Array<CCAnimationFrame>, delay : Float, loops : Int) : CCAnimation {
		var animation : CCAnimation = new CCAnimation();
		animation.initWithAnimationFrames(frames, delay, loops);
		
		return animation;
	}
	
	public static function createWithAnimationFrames(arrayOfAnimationFramesNames : Array<CCSpriteFrame>, delayPerUnit : Float, ?loops : Int) : CCAnimation {
		var animation : CCAnimation = new CCAnimation();
		if (loops == null) {
			animation.initWithSpriteFrames(arrayOfAnimationFramesNames, delayPerUnit);
			
		}
		
			
		return animation;
	}
}

class CCAnimationFrame {
	var _spriteFrame : CCSpriteFrame;
	var _userInfo : CCPlistEntry;
	var _delayPerUnit : Float;
	
	public function new() {
		this._delayPerUnit = 0;
	}
	
	public function copyWithZone() {
		
	}
	
	public function copy() {
		
	}
	
	/**
     * initializes the animation frame with a spriteframe, number of delay units and a notification user info
     * @param {cc.SpriteFrame} spriteFrame
     * @param {Number} delayUnits
     * @param {object} userInfo
     */
	public function initWithSpriteFrame(spriteFrame : CCSpriteFrame, delayUnits : Float, ?userInfo : CCPlistEntry) : Bool {
		this.setSpriteFrame(spriteFrame);
		this.setDelayUnits(delayUnits);
		this.setUserInfo(userInfo);
		
		return true;
	}
	
	/**
     * cc.SpriteFrameName to be used
     * @return {cc.SpriteFrame}
     */
	public function getSpriteFrame() : CCSpriteFrame {
		return this._spriteFrame;
	}
	
	/**
     * cc.SpriteFrameName to be used
     * @param {cc.SpriteFrame} spriteFrame
     */
	public function setSpriteFrame(spriteFrame : CCSpriteFrame) {
		this._spriteFrame = spriteFrame;
	}
	
	public function getDelayUnits() : Float {
		return this._delayPerUnit;
	}
	
	public function setDelayUnits(delayUnits : Float) {
		this._delayPerUnit = delayUnits;
	}
	
	public function getUserInfo() : CCPlistEntry {
		return this._userInfo;
	}
	

	public function setUserInfo(userInfo : CCPlistEntry) {
		this._userInfo = userInfo;
	}
}