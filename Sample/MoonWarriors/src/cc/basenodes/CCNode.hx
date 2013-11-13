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
package cc.basenodes;
import cc.action.CCAction;
import cc.action.CCActionManager;
import cc.CCComponent;
import cc.CCDirector;
import cc.CCScheduler;
import cc.cocoa.CCGeometry;
import cc.extensions.ccbreader.CCBAnimationManager;
import cc.spritenodes.CCSprite;
import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.Font;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.platform.DummyWeb;
import cc.platform.CCConfig;
import cc.platform.CCCommon;
import flambe.display.FillSprite;
import cc.menunodes.CCMenu;
/**
 * 
 * @author Ang L1
 */
class CCNode 
{
	public static var NODE_TAG_INVALID : Int = -1;
	public static var NODE_ON_ENTER : Dynamic = null;
	public static var NODE_ON_EXIT : Dynamic = null;
	
	public static var s_globalOrderOfArrival : Int = 1;
	
	
	//For Flambe
	public var entity : Entity;
	public var sprite : Sprite;
	public var component : CCComponent;
	public var cbUpdate : Array<CbClass>;
	public var action : CCAction;
	
	public var actions : Array<CCAction>;
	
	//CCBReader
	public var controller : Dynamic;
	public var animationManager : CCBuilderAnimationManager;
	
	//zOrder is not finished. 
	var _zOrder : Int = 0;  
	var _vertextZ : Float = 0;
	var _rotation : Float = 0;
	var _rotationX : Float = 0;
	var _rotationY : Float = 0;
	var _scaleX : Float = 1;
	var _scaleY : Float = 1;
	var _position : Point;
	var _skewX : Float = 0.0;
	var _skewY : Float = 0.0;
	
	var _children : Array<CCNode>;
	var _camera : Dynamic;
	var _grid : Dynamic;
	var _visible : Bool = true;
	var _anchorPoint : Point;
	var _anchorPointInPoints : Point;
	var _contentSize : CCSize;
	var _running : Bool = false;
	var _parent : CCNode;
	var _ignoreAnchorPointForPosition : Bool = false;
	var _tag : Int;
	var _userData : Dynamic;
	var _userObject : Dynamic;
	var _transformDirty : Bool = true;
	var _inverseDirty : Bool = true;
	var _cacheDirty : Bool = true;
	var _transformGLDirty : Dynamic;
	var _transform : CCAffineTransform;
	var _inverse : CCAffineTransform;
	var _reorderChildDirty : Bool = false;
	var _shaderProgram : CCActionManager;
	var _orderOfArrival : Int = 0;
	var _glServerState : Dynamic;
	var _actionManager : Dynamic;
	var _scheduler : CCScheduler;
	var _initializedNode : Bool = false;
	//var _orderOfArrival : Int = 0;
	
	public var isOriginTopLeft : Bool = true;
	public function new() 
	{
		//trace("ctor in CCNode");
		init();
	}
	
	private function _initNode() {
		//trace('_initNode');
		if (CCConfig.NODE_TRANSFORM_USING_AFFINE_MATRIX == 1) {
			this._transformGLDirty = true;
		}
		_position = new Point(0, 0);
		_anchorPoint = new Point(0, 0);
		_anchorPointInPoints = new Point(0, 0);
		_contentSize = new CCSize();
		
		var director : CCDirector = CCDirector.getInstance();
		//trace(director.getWinSize().width);
		this._initializedNode = true;
		this._scaleX = 1;
		this._scaleY = 1;
		this._children = new Array<CCNode>();
		
		
		_contentSize = new CCSize(director.getWinSize().width, director.getWinSize().height);
		//trace(_contentSize.width);
		
		
		
		//Flambe
		entity = new Entity();
		
		sprite = new Sprite();
		
		cbUpdate = new Array<CbClass>();
		
		actions = new Array<CCAction>();
		//entity.add(sprite);
/*		this.component = new CCComponent(this);
		this.entity.add(component);*/
	}
	
	public function init() : Bool {
		if (this._initializedNode == false) {
			this._initNode();
		}
		return true;
	}
	
	public function getSkewX() : Float {
		return this._skewX;
	}
	
	public function setSkewX(newSkewX : Float) {
		this._skewX = newSkewX;
		
	}
	
	public function getSkewY() : Float {
		return this._skewY;
	}
	
	public function setSkewY(newSkewY : Float) {
		this._skewY = newSkewY;
		
	}
	
	public function getZOrder() {
		return this._zOrder;
	}
	
	public function setZOrder(z : Int) {
		this._setZOrder(z);
		this.entity.setZOrder(z);
	}
	
	private function _setZOrder(z : Int) {
		this._zOrder = z;
	}
	
	public function getRotation() : Float {
		return this._rotation;
	}
	
	public function setRotation(newRotation : Float) {
		if (this._rotation == newRotation) return;
		this._rotation = newRotation;
		
		if (sprite != null) {
			sprite.rotation._ = this._rotation;
		}
	}
	
	public function getScale() : Float {
		CCCommon.assert(this._scaleX == this._scaleY, 
			"cc.Node#scale. ScaleX != ScaleY. Don't know which one to return");
		return this._scaleX;
	}
	
	public function setScale(scale : Float, ?scaleY : Float) {
		this._scaleX = scale;
		
		if (scaleY == null) {
			this._scaleY = scale;
			sprite.setScale(scale);
		}
		else {
			this._scaleY = scaleY;
			sprite.setScaleXY(this._scaleX, this._scaleY);
			
			
		}
		//this._contentSize.width *= scale;
		//this._contentSize.height *= scale;
		//trace(this._contentSize.width);
	}
	
	public function getScaleX() : Float {
		return this._scaleX;
	}
	
	public function setScaleX(newScaleX : Float) {
		this._scaleX = newScaleX;
		sprite.scaleX._ = newScaleX;
	}
	
	public function getScaleY() : Float {
		return this._scaleY;
	}
	
	public function setScaleY(newScaleY : Float) {
		this._scaleY = newScaleY;
		sprite.scaleY._ = newScaleY;
	}
	
	//Only accept Float values
	public function setPosition(xValue : Float, yValue : Float) {
		this._position = new Point(xValue, yValue);
		sprite.x._ = this._position.x;
		sprite.y._ = this._position.y;
		_hasSetPosition = true;
		//trace(sprite.getNaturalHeight());
	}
	
	public function getPosition() : Point {
		return new Point(_position.x, _position.y); //Deep Copy
	}
	
	public function getPositionX() : Float {
		return this._position.x;
	}
	
	public function setPositionX(x : Float) {
		this._position.x = x;
		sprite.x._ = this._position.x;
		sprite.y._ = this._position.y;
	}
	
	public function getPositionY() : Float {
		return this._position.y;
	}
	
	public function setPositionY(y : Float){
		this._position.y = y;
		sprite.x._ = this._position.x;
		sprite.y._ = this._position.y;
	}
	
	//Dont use it
	public function syncPosition() {
		this._position.x = this.sprite.x._;
		this._position.y = this.sprite.y._;
	}
	
	public function getChildrenCount() : Int {
		if (this._children != null) {
			return this._children.length;
		} else {
			return 0;
		}
	}
	
	public function getChildren() : Array<CCNode> {
		if (this._children == null) {
			this._children = new Array<CCNode>();
		}
		return this._children;
	}
	
	public function getGrid() : Void {
		
	}
	
	public function setGrid() {
		
	}
	
	public function isVisible() : Bool {
		return this._visible;
	}
	
	public function setVisible(v : Bool ){
		this._visible = v;
		sprite.visible = v;
	}
	
	public function getAnchorPoint() : Point{
		return new Point(this._anchorPoint.x, this._anchorPoint.y);
	}
	
	
	
	public function setAnchorPoint(point : Point) {
		if (isIgnoreAnchorPointForPosition()) {
			return;
		}
		
		this._anchorPoint = new Point(point.x, point.y);
		
		
		
		var width : Float = this.sprite.getNaturalWidth();
		var height : Float = this.sprite.getNaturalHeight();
		
		if (isOriginTopLeft) {
			sprite.setAnchor(this._anchorPoint.x * width, this._anchorPoint.y * height);
		} else {
			//trace("else");
			sprite.setAnchor(this._anchorPoint.x * width, (1 - this._anchorPoint.y) * height);
			//trace('height = $height');
		}
		
	}
	
	public function setCenterAnchor() {
		//sprite.centerAnchor();
		//this._anchorPoint.set(sprite.anchorX._, sprite.anchorY._);
	}
	
	
	public function getContentSize() : CCSize {
		return this._contentSize;
	}
	
	public function setContentSize(size : CCSize) {
		this._contentSize = new CCSize(size.width, size.height);
		//this.sprite.wSprite = this._contentSize.width;
		//this.sprite.hSprite = this._contentSize.height;
	}
	
	public function isRunning() : Bool {
		return this._running;
	}
	
	public function getParent() : CCNode {
		return this._parent;
	}
	
	public function setParent(v : CCNode) {
		this._parent = v;
	}
	
	/** ignoreAnchorPointForPosition getter
     * @return {Boolean}
     */
	public function isIgnoreAnchorPointForPosition() : Bool {
		return this._ignoreAnchorPointForPosition;
	}
	
	var _hasSetPosition : Bool = false;
	public function ignoreAnchorPointForPosition(newValue : Bool, ?containerSize : CCSize) {
		//if (Std.is(this, CCMenu)) {
			//trace("CCMenu ignore");
		//}
		this._ignoreAnchorPointForPosition = newValue;
		if (newValue && !isOriginTopLeft) {
			
			
			this._anchorPoint = new Point(0, 0);
			this.sprite.anchorX._ = 0;
			this.sprite.anchorY._ = _contentSize.height;
			
			//trace(sprite.anchorY._);
			
			if (containerSize != null && !_hasSetPosition) {
				this.setPosition(_position.x, containerSize.height - _position.y);
				_hasSetPosition = true;
			} else {
				this.setPosition(_position.x, _position.y);
			}
			
			//if (containerSize != null ) {
				//
				//_hasSetPosition = true;
			//} else {
				//this.setPosition(_position.x, _position.y);
				//_hasSetPosition = true;
			//}
			//this.setPosition(_position.x, _contentSize.height - _position.y);
			//_hasSetPosition = true;
			
			//trace(this._position.y);
			//trace("ignore");
				//this._hasSetPosition = true;
			//if (!_hasSetPosition) {
				//
				//
			//}
			
			//this.setCenterAnchor();
		} else if (newValue) {
			
		}
	}
	public function getTag() : Int {
		return this._tag;
	}
	
	public function setTag(v : Int) {
		this._tag = v;
	}
	
	public function getBoundingBox() : Rectangle{
		return Sprite.getBounds(this.entity);
	}
	
	public function getBoundingBoxToWorld() : Rectangle {
		return Sprite.getBounds(this.entity);
	}
	
	public function nodeToParentTransform() : CCAffineTransform {
		if (this._transform == null) {
			this._transform = new CCAffineTransform(1, 0, 0, 1, 0, 0);
		}
		
		if (this._transformDirty) {
            var t : CCAffineTransform= this._transform;// quick reference
             //base position
            t.tx = this._position.x;
            t.ty = this._position.y;

            //rotation Cos and Sin
            var Cos = 1, Sin = 0;

            //base abcd
            t.a = t.d = Cos;
            t.b = -Sin;
            t.c = Sin;

            var lScaleX = this._scaleX, lScaleY = this._scaleY;
            var appX = this._anchorPointInPoints.x, appY = this._anchorPointInPoints.y;

             //Firefox on Vista and XP crashes
             //GPU thread in case of scale(0.0, 0.0)
            var sx = (lScaleX < 0.000001 && lScaleX > -0.000001)?  0.000001 : lScaleX,
                sy = (lScaleY < 0.000001 && lScaleY > -0.000001)? 0.000001 : lScaleY;

           

             //scale
            if (lScaleX != 1 || lScaleY != 1) {
                t.a *= sx;
                t.c *= sx;
                t.b *= sy;
                t.d *= sy;
            }

            //adjust anchorPoint
            t.tx += Cos * -appX * sx + -Sin * appY * sy;
            t.ty -= Sin * -appX * sx + Cos * appY * sy;

            //if ignore anchorPoint
            if (this._ignoreAnchorPointForPosition) {
                t.tx += appX;
                t.ty += appY;
            }

            //if (this._additionalTransformDirty) {
                //this._transform = cc.AffineTransformConcat(this._transform, this._additionalTransform);
                //this._additionalTransformDirty = false;
            //}

            this._transformDirty = false;
        }
        return this._transform;
		
	}
	
	public function parentToNodeTransform() : CCAffineTransform {
		if (this._inverseDirty) {
			this._inverse = CCAffineTransform.AffineTransformInvert(this.nodeToParentTransform());
			this._inverseDirty = false;
		}
		
		return this._inverse;
	}
	
	public function nodeToWorldTransform() : CCAffineTransform {
		var t = this.nodeToParentTransform();
		var p : CCNode = this._parent;
		while (p != null) {
			t = CCAffineTransform.AffineTransformConcat(t, p.nodeToParentTransform());
			p = p.getParent();
		}
		
		return t;
	}
	
	public function worldToNodeTransform() : CCAffineTransform {
		return CCAffineTransform.AffineTransformInvert(this.nodeToWorldTransform());
	}
	
	public function convertToNodeSpace(worldPoint : Point)  : Point {
		return CCAffineTransform.PointApplyAffineTransform(worldPoint, this.worldToNodeTransform());
	}
	
	
	public function cleanup() {
		this.unscheduleAllCallbacks();
		//this.entity.disposeChildren();
		this.entity.dispose();
		
	}
	
	public function description() : String{
		return "";
	}
	
	public function _childrenAlloc() {
		
	}
	
	public function getChildByTag(aTag : Int) : CCNode {
		CCCommon.assert(aTag != CCNode.NODE_TAG_INVALID, "Invalid tag");
		//trace(aTag);
		if (this._children != null) {
			for (i in 0...this._children.length) {
				var node = this._children[i];
				//trace(node._tag);
				if (node != null && node._tag == aTag) {
					//trace("get");
					return node;
				}
			}
		}
		return null;
	}
	
	public function addChild(child : CCNode, ?zOrder : Int, ?tag : Int) {
		if (child == this) {
			return;
		}
		
		CCCommon.assert(child != null, "Argument must be non-nil");
		
		if (child._parent != null) {
			CCCommon.assert(child._parent == null, "child already added. It can't be added again");
			return;
		}
		//var tempzOrder : Int;
		//if (zOrder == null) {
			//tempzOrder = child.getZOrder();
		//} else {
			//tempzOrder = zOrder;
		//}
		//trace(tempzOrder);
		
		var tempTag : Int = 0;
		if (tag == null) {
			tag = child.getTag();
		} else {
			tempTag = tag;
		}
		child._tag = tempTag;
		
		child.setParent(this);
		//trace("parent");
		//trace("CCNode.addChild" + zOrder);
		entity.addChild(child.entity, true, zOrder);
		child._zOrder = zOrder;
		
		this._children.push(child);
	}
	

	
	public function removeFromParent(cleanup : Bool)  {
		if (this._parent != null) {
			//if (cleanup == null) {
			//cleanup = true;
			//}
			this._parent.removeChild(this, cleanup);
		}
	}
	
	public function removeFromParentAndCleanup() {
		this.removeFromParent(true);
	}
	
	public function removeChild(child : CCNode, cleanup : Bool = true) {
		if (this._children == null) {
			return;
		}
		
		//if (cleanup == null) {
		//cleanup = true;
		//}
		
		this._detachChild(child, cleanup);
		//Todo
	}
	
	public function removeChildByTag(tag : Int, cleanup : Bool) {
		CCCommon.assert(tag != CCNode.NODE_TAG_INVALID, "Invalid tag");
		
		var child = this.getChildByTag(tag);
		if (child == null) {
			//Log
		} else {
			this.removeChild(child, cleanup);
		}
	}
	
	public function removeAllChildren(cleanup : Bool) {
		if (this._children != null) {
			//if (cleanup == null) {
				cleanup = true;
			//}
			
			for (i in 0...this._children.length) {
				var node : CCNode = this._children[i];
				//if (node != null) {
					node.setParent(null);
				//}
			}
			this._children = [];
			entity.disposeChildren();
		}
	}
	
	private function _detachChild(child : CCNode, doCleanup : Bool) {
		
		this._children.remove(child);
		this.entity.removeChild(child.getEntity());
		child.onExit();
		child._parent = null;
		
		//trace(doCleanup);
		if (doCleanup) {
			
			child.cleanup();
		}

	}
	
	//private function _insertChild(child : CCNode, z : Int) {
		//this._children.push(child);
		//
		//
		//
		//var a = this._children[this._children.length - 1];
		//if (a == null || a.getZOrder() <= z) {
			//this._children.push(child);
			//entity.addChild(child.getEntity());
		//} else {
			//for (i in 0...this._children._children) {
				//var node = this._children[i];
				//if (node != null && (node.getZOrder() > z)) {
					//CCScheduler.ArrayAppendObjectToIndex(this._children, child, i);
					//this._reorderChildDirty = true;
					//break;
				//}
			//}
		//}
	//}
	//
	//public function reorderChild(child : CCNode, zOrder : Int) {
		//CCCommon.assert(child != null, "Child must be non-nul");
		//this._reorderChildDirty = true;
		//
		//child.setOrderOfArrival(CCNode.s_globalOrderOfArrival++);
		//child._setZOrder(zOrder);
	//}
	//
	//public function sortAllChildren() {
		//if (this._reorderChildDirty) {
			//var i : Int = 0;
			//var j : Int = this._children.length;
			//var length : Int = this._children.length;
			//insertion sort
			//for (i in 0...length) {
				//var tempItem  = this._children[i];
				//j = i - 1;
				//
				//while (j >= 0 && (tempItem._zOrder < this._children[j]._zOrder ||
					//(tempItem._zOrder == this._children[j]._zOrder && tempItem._orderOfArrival < this._children[j]._orderOfArrival))) {
					//this._children[j + 1] = this._children[j];
					//j = j - 1;
				//}
				//this._children[j + 1] = tempItem;
			//}
		//}
		//this._reorderChildDirty = false;
		//
		//var tail = null, p = this.entity.firstChild;
		//var small : Entity;
		//while ( p != null) {
			//
		//}
	//}
	
	
	
	
	
	
	public function draw() {
		trace("Node Draw");
	}
	
	public function visit() {
		//trace("visit");
		this.draw();
	}
	
	public function onEnter() {
		this._running = true;
	}
	
	public function onExit() {
		this._running = false;
		
		if (_children != null) {
			for (c in _children) {
				c.onExit();
			}
		}
	}
	
	public function runAction(action : CCAction) : CCAction{
		//this.getActionManager().addAction(action, this, !this._running);
		//var s : CCSprite = cast (this, CCSprite);
		//this.action.startWithTarget(s);
		//this.action = action;
		
		for (a in actions) {
			if (a == action) {
				return this.action;
			}
		}
		
		this.actions.push(action);
		action.startWithTarget(this);
		return action;
	}
	
	public function stopAllActions() {
		this.actions = [];
	}
	
	public function stopAction(action : CCAction) {
		this.actions.remove(action);
	}
	
	public function stopActionByTag(tag : Int) {
		var tmp : CCAction = CCAction.create();
		for (a in actions) {
			if (a.getTag() == tag) {
				tmp = a;
				break;
			}
		}
		actions.remove(tmp);
		
	}
	
	public function getActionByTag(tag : Int) : CCAction {
		for (a in actions) {
			if (a.getTag() == tag) {
				return a;
			}
		}
		return null;
	}
	
	public function getOrderOfArrival() : Int {
		return this._orderOfArrival;
	}
	
	public function setOrderOfArrival(v : Int) {
		this._orderOfArrival = v;
	}
	
	public function getActionManager() : CCActionManager {
		if (this._actionManager == null) {
			this._actionManager = CCDirector.getInstance().getActionManager();
		}
		
		return this._actionManager;
	}
	
	public function setActionmanager(actionManager : CCActionManager) {
		if (this._actionManager != actionManager) {
			//this.stopAllActions();
			this._shaderProgram = actionManager;
		}
	}
	
	public function setOpacity(o : Int) {
		
	}
	
	public function getOpacity() : Int {
		return 0;
	}
	
	/**
     * Similar to userData, but instead of holding a void* it holds an id
     * @param {object} newValue
     */
    public function setUserObject(newValue : Dynamic) {
        if (this._userObject != newValue) {
            this._userObject = newValue;
        }
    }
	
	public function getUserObject() : Dynamic {
		return this._userObject;
	}
	
	public function update(dt : Float) {
		for (c in cbUpdate) {
			if (c.curTimer <= 0) {
				c.fun();
				c.curTimer = c.interval;
				//trace("run schedule");
			}
			c.curTimer -= dt;
		}
		
		var temp : Array<CCAction> = new Array<CCAction>();
		for (a in actions) {
			if (a != null) {
				a.step(dt);
				//trace(actions.length);
			}
			
			if (a.isDone()) {
				temp.push(a);
				//trace("remove a");
			}
		}
		
		if (temp != null) {
			for (t in temp) {
				actions.remove(t);
			}
		}
		
		
		//trace("update");
	}
	
	public function schedule(callback_fn : Void -> Void, interval : Float, ?repeat : Float, ?delay : Float) {
		cbUpdate.push(new CbClass(callback_fn, interval));
	}
	
	public function unscheduleAllCallbacks() {
		cbUpdate = [];
	}
	
	//Flambe
	public function getEntity() : Entity{
		return this.entity;
	}
	
	public function getSprite() : Sprite {
		return this.sprite;
	}
	
	public static function create() : CCNode{
		return new CCNode();
	}
	
}

class CbClass {
	public var fun : Void -> Void;
	public var interval : Float;
	public var curTimer : Float;
	
	public function new(fn : Void -> Void, interval : Float) {
		this.fun = fn;
		this.interval = interval;
		curTimer = 0;
	}
}