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

package cc;
import cc.keyboarddispatcher.CCKeyboardDispatcher;
import flambe.math.Point;
import flambe.scene.Director;
import haxe.CallStack;
import cc.action.CCActionManager;
import cc.cocoa.CCGeometry;
import cc.basenodes.CCNode;
import flambe.System;
import cc.layersscenestransitionsnodes.CCScene;
import cc.layersscenestransitionsnodes.CCTransitionScene;
import cc.touchdispatcher.CCPointerDispatcher;
/**
 * ...
 * @author Ang Li
 */

class CCDirector 
{
	public static var g_NumberOfDraws = 0;
	//Possible OpenGL projections used by director
	/**
	 * sets a 2D projection (orthogonal projection)
	 * @constant
	 * @type Number
	 */
	public static var DIRECTOR_PROJECTION_2D : Int = 0;
	
	/**
	 * sets a 3D projection with a fovy=60, znear=0.5f and zfar=1500.
	 * @constant
	 * @type Number
	 */
	public static var DIRECTOR_PROJECTION_3D : Int = 1;
	
	/**
	 * it calls "updateProjection" on the projection delegate.
	 * @constant
	 * @type Number
	 */
	public static var DIRECTOR_PROJECTION_CUSTOM : Int = 3;
	
	/**
	 * Detault projection is 3D projection
	 * @constant
	 * @type Number
	 */
	public static var DIRECTOR_PROJECTION_DEFAULT : Int = DIRECTOR_PROJECTION_3D;
	
	//----------------------------------------------------------------------------------------------------------------------
	//Possible device orientations
	/**
	 * Device oriented vertically, home button on the bottom (UIDeviceOrientationPortrait)
	 * @constant
	 * @type Number
	 */
	public static var DEVICE_ORIENTATION_PORTRAIT : Int = 0;
	
	/**
	 * Device oriented horizontally, home button on the right (UIDeviceOrientationLandscapeLeft)
	 * @constant
	 * @type Number
	 */
	public static var DEVICE_ORIENTATION_LANDSCAPE_LEFT : Int = 1;
	
	/**
	 * Device oriented vertically, home button on the top (UIDeviceOrientationPortraitUpsideDown)
	 * @constant
	 * @type Number
	 */
	public static var DEVICE_ORIENTATION_PORTRAIT_UPSIDE_DOWN : Int = 2;

	/**
	 * Device oriented horizontally, home button on the left (UIDeviceOrientationLandscapeRight)
	 * @constant
	 * @type Number
	 */
	public static var DEVICE_ORIENTATION_LANDSCAPE_RIGHT : Int = 3;

	/**
	 * In browsers, we only support 2 orientations by change window size.
	 * @constant
	 * @type Number
	 */
	public static var DEVICE_MAX_ORIENTATIONS : Int = 2;
	
	public static var defaultFPS : Float = 60;
	public static var firstUseDirector : Bool = true;
	public static var s_SharedDirector : CCDirector = null;
	
	//Variables for Flambe
	var director : Director;
	var length : Int;
	
	/**
	 * is director first run
	 */
	public static var firstRun : Bool = true;

	//Variables
	var _isContentScaleSupported : Bool = false;
	var _landscape : Bool = false;
	var _nextDeltaTimeZero : Bool = false;
	var _paused : Bool = false;
	var _purgeDirectorInNextLoop : Bool = false;
	var _sendClenupToScene : Bool = false;
	var _animationInterval : Float = 0.0;
	var _oldAnimationInterval : Float = 0.0;
	var _projection : Float = 0.0;
	var _accumDt : Float = 0.0;
	var _contentScaleFactor : Float = 0.0;
	
	var _displayStats : Bool = false;
	var _deltaTime : Float = 0.0;
	var _frameRate : Float = 0.0;
	
	var _FPSLabel : Dynamic = null;
	var _SPFLabel : Dynamic = null;
	var _drawsLabel : Dynamic = null;
	
	var _winSizeInPixels : CCSize = null;
    var _winSizeInPoints : CCSize = null;

    var _lastUpdate : Dynamic = null;
    var _nextScene : Dynamic = null;
    var _notificationNode : CCNode = null;
    var _openGLView : Dynamic = null;
    var _scenesStack : Dynamic = null;
    var _projectionDelegate : Dynamic = null;
    var _runningScene : CCScene = null;
	
	var _frames : Int = 0;
    var _totalFrames : Int = 0;
    var _secondsPerFrame : Int = 0;
	
	var _dirtyRegion: Dynamic = null;

    var _scheduler : Dynamic = null;
    var _actionManager : CCActionManager = null;
    var _touchDispatcher : Dynamic = null;
    var _accelerometer : Dynamic = null;
    var _pointerDispatcher : CCPointerDispatcher;
	var _keyboardDispatcher : CCKeyboardDispatcher;

    var _watcherFun : Dynamic = null;
    var _watcherSender : Dynamic = null;
	
	var _isBlur : Bool = false;
	
	public function new() 
	{
		//this._lastUpdate
	}
	
	public static function getInstance() : CCDirector {
		if (CCDirector.firstUseDirector) {
			CCDirector.firstUseDirector = false;
			CCDirector.s_SharedDirector = new CCDirector();
			s_SharedDirector.init();
		}
		//trace(s_SharedDirector.getWinSize());
		return CCDirector.s_SharedDirector;
	}
	
	
	public function init() {
		this._oldAnimationInterval = this._animationInterval = 1.0 / CCDirector.defaultFPS;
		this._scenesStack = new Array<Dynamic>();
		//Set default projection(3D)
		this._projection = CCDirector.DIRECTOR_PROJECTION_DEFAULT;
		this._projectionDelegate = null;
		this._contentScaleFactor = 1.0;
		
		//scheduler
		this._scheduler = new CCScheduler();
		//action manager
		this._actionManager = new CCActionManager();
		
		_winSizeInPoints = new CCSize(System.stage.width, System.stage.height);
		//_winSizeInPoints = new CCSize(System.stage.height);
		
		//trace(this.getWinSize().height);
		
		this._pointerDispatcher = new CCPointerDispatcher();
		this._keyboardDispatcher = CCKeyboardDispatcher.getInstance();
		
		
		
		//Flambe
		length = 0;
		director = new Director();
		System.root.add(director);
	}
	
	/**
     * calculates delta time since last time it was called
     */
	public function calculateDeltaTime() {
		var now = Date.now().getTime();
		
		if (this._nextDeltaTimeZero) {
			this._deltaTime = 0;
			this._nextDeltaTimeZero = false;
		} else {
			this._deltaTime = (now - this._lastUpdate) / 1000;
		}
		
/*		if (cc.DEBUG) {
            if (this._deltaTime > 0.2) {
                this._deltaTime = 1 / 60.0;
            }
        }*/
		
		this._lastUpdate = now;
	}
	
	/**
     * <p>
     *     converts a UIKit coordinate to an OpenGL coordinate<br/>
     *     Useful to convert (multi) touches coordinates to the current layout (portrait or landscape)
     * </p>
     * @param {cc.Point} point
     * @return {cc.Point}
     */
	 public function convertToGL(point : Point) {
		 var newY = this._winSizeInPoints.height - point.y;
		 return new Point(point.x, newY);
	 }
	 
	 /**
     * <p>converts an OpenGL coordinate to a UIKit coordinate<br/>
     * Useful to convert node points to window points for calls such as glScissor</p>
     * @param {cc.Point} point
     * @return {cc.Point}
     */
	 public function convertToUI(point : Point) {
		 var oppositeY = this._winSizeInPoints.height - point.y;
		 return new Point(point.x, oppositeY);
	 }
	 
	 public function end() {
		 this._purgeDirectorInNextLoop = true;
	 }
	 
	 public function getContentScaleFactor() : Float {
		 return this._contentScaleFactor;
	 }
	 
	 public function getNotificationNode() : CCNode {
		 return this._notificationNode;
	 }
	 
	 public function getWinSize() : CCSize {
		 return this._winSizeInPoints;
	 }
	 
	 public function setWinSize(s : CCSize) {
		 this._winSizeInPoints = new CCSize(s.width, s.height);
	 }
	 public function getWinSizeInPixels() : CCSize {
		 return this._winSizeInPixels; 
	 }
	 
	 public function getZEye() {
		 return (this._winSizeInPixels.height / 1.1566 / 1);
	 }
	 
	 public function pause() {
		 if (this._paused) {
			 return;
		 }
		 //this.setAnimationInterval(1 / 4.0);
		 this._paused = true;
	 }
	 
	 public function popScene() {
		 director.popScene();
		 length--;
	 }
	 
	 public function purgeCachedData() {
		 //Todo
	 }
	 
	 public function purgeDirector() {
		 //Todo
	 }
	 
	 public function pushScene(scene : CCScene) {
		 var s : CCTransitionScene;
		 if (Std.is(scene, CCTransitionScene)) {
			 s = cast(scene, CCTransitionScene);
			 director.pushScene(s.getInScene().entity, s.getTransition());
		 } else {
			  director.pushScene(scene.getEntity());
		 }
		
		 length++;
	 }
	 
	 public function replaceScene(scene : CCScene) {
		 //What's the difference between push and replace
		 //var s : CCTransitionScene;
		 //if (Std.is(scene, CCTransitionScene)) {
			 //s = cast(scene, CCTransitionScene);
			 //director.popScene(s.getTransition());
		 //} else {
			  //director.popScene();
		 //}
		//
		 //length--;
		 //director.
		 this.popScene();
		if (Std.is(scene, CCTransitionScene)) {
			 var s = cast(scene, CCTransitionScene);
			 director.pushScene(s.getInScene().entity);
		 } else {
			 director.pushScene(scene.entity);
		 }
		 length++;
		 
	 }
	 
	 public function resume() {
		 
	 }
	 
	 public function runWithScene(scene : CCScene) {
		 director.pushScene(scene.getEntity());
	 }
	 
	 public function getRunningScene() : CCScene {
		 return this._runningScene;
	 }
	 
	 public function popToRootScene() {
		 if (length == 1) {
			 this.popScene();
		 } else {
			 while (length > 1) {
				 this.popScene();
			 }
		 }
	 }
	 
	 public function getActionManager() : CCActionManager {
		 return this._actionManager;
	 }
	 
	 public function setActionManager(actionManager : CCActionManager) {
		 if (this._actionManager != actionManager) {
			 this._actionManager = actionManager;
		 }
	 }
	 
	 public function getPointerDispatcher() : CCPointerDispatcher {
		 return this._pointerDispatcher;
	 }
	 
	 public function setPointerDispather(p : CCPointerDispatcher) {
		 this._pointerDispatcher = p;
	 }
	 
	 public function getKeyboardDispatcher() : CCKeyboardDispatcher {
		 return this._keyboardDispatcher;
	 }
	 
	 public function setKeyboardDispatcher(keyboardDispatcher : CCKeyboardDispatcher) {
		 this._keyboardDispatcher = keyboardDispatcher;
	 }
}