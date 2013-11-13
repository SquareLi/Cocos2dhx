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
import flambe.scene.Transition;

/**
 * ...
 * @author
 */

class CCTransitionScene extends CCScene
{
	public var transition : Transition;
	var _inScene : CCScene;
	var _duration : Float;
	var _isInSceneOnTop : Bool = false;
	var _isSendCleanupToScene : Bool = false;
	public function new() 
	{
		super();
	}
	
	
	
	public function initWithDuration(t : Float, scene : CCScene) : Bool{
		if (this.init()) {
			this._duration = t;
			this.setPosition(0 , 0);
			this._inScene = scene;
			return true;
		} else {
			return false;
		}
	}
	
	public function getInScene() : CCScene {
		return this._inScene;
	}
	
	public function getTransition() : Transition {
		return this.transition;
	}
	
	public static function create(t : Float, scene : CCScene) : CCTransitionScene {
		var ret = new CCTransitionScene();
		if ((ret != null) && (ret.initWithDuration(t, scene))) {
			return ret;
		}
		return null;
	}
	
}