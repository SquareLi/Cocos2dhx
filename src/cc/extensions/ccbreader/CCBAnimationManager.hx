package cc.extensions.ccbreader;
import cc.action.CCAction;
import cc.action.CCActionInstant;
import cc.action.CCActionInterval;
import cc.basenodes.CCNode;
import cc.cocoa.CCGeometry;
import cc.menunodes.CCMenuItem;
import cc.extensions.ccbreader.CCBSequence;
import cc.extensions.ccbreader.CCBKeyframe;
import cc.particlenodes.CCParticleSystem;
import cc.spritenodes.CCSpriteFrame;
import cc.spritenodes.CCSprite;
import cc.platform.CCCommon;
import cc.denshion.CCAudioEngine;
import flash.display.DisplayObjectContainer;
import flash.display.InterpolationMethod;
import cc.action.CCActionEase;
import cc.CCScheduler;
import cc.extensions.ccbreader.CCBReader;
/**
 * ...
 * @author Ang Li
 */
class CCBAnimationManager
{

	public function new() 
	{
		
	}
	
}

class CCBuilderAnimationManagerDelegate {
	public function completedAnimationSequenceNamed(name : String) {
		
	}
}

class CCBuilderAnimationManager {
	var _sequences : Array<CCBuilderSequence>;
    var _nodeSequences : _Dictionary;
    var _baseValues : _Dictionary;
    var _autoPlaySequenceId : Int = 0;

    var _rootNode : CCNode;
    var _rootContainerSize : CCSize;

    var _delegate : CCBuilderAnimationManagerDelegate;
    var _runningSequence : CCBuilderSequence;

    var _documentOutletNames : Array<String>;
    var _documentOutletNodes : Array<CCNode>;
    var _documentCallbackNames : Array<String>;
    var _documentCallbackNodes : Array<CCMenuItem>;
    var _documentControllerName : String = "";
    var _lastCompletedSequenceName : String = "";

    var _animationCompleteCallbackFunc : Void -> Void = null;
    var _target : CCNode;
	public function new() {
		this._rootContainerSize = new CCSize(0, 0);
		this.init();
	}
	
	public function init() : Bool {
		this._sequences = new Array<CCBuilderSequence>();
		this._nodeSequences = new _Dictionary();
		this._baseValues = new _Dictionary();
		
		this._documentOutletNames = new Array<String>();
		this._documentOutletNodes = new Array<CCNode>();
		this._documentCallbackNames = new Array<String>();
		this._documentCallbackNodes = new Array<CCMenuItem>();
		
		
		return true;
	}
	
	public function getSequences() : Array<CCBuilderSequence> {
		return this._sequences;
	}
	
	public function getAutoPlaySequenceId() : Int {
		return this._autoPlaySequenceId;
	}
	
	public function setAutoPlaySequenceId(autoPlaySequenceId : Int) {
		this._autoPlaySequenceId = autoPlaySequenceId;
	}
	
	public function getRootNode() : CCNode {
		return this._rootNode;
	}
	
	public function setRootNode(rootNode : CCNode) {
		this._rootNode = rootNode;
	}
	
	public function addDocumentCallbackNode(node : CCMenuItem) {
		this._documentCallbackNodes.push(node);
	}
	
	public function addDocumentCallbackName(name : String) {
		this._documentCallbackNames.push(name);
	}
	
	public function addDocumentOutletNode(node : CCNode) {
		this._documentOutletNodes.push(node);
	}
	
	public function addDocumentOutletName(name : String) {
		this._documentOutletNames.push(name);
	}
	
	public function setDocumentControllerName(name : String) {
		this._documentControllerName = name;
	}
	
	public function getDocumentControllerName() : String {
		return this._documentControllerName;
	}
	
	public function getDocumentCallbackNames() : Array<String> {
		return this._documentCallbackNames;
	}
	
	public function getDocumentCallbackNodes() : Array<CCMenuItem> {
		return this._documentCallbackNodes;
	}
	
	public function getDocumentOutletNames() : Array<String> {
		return this._documentOutletNames;
	}
	
	public function getDocumentOutletNodes() : Array<CCNode> {
		return this._documentOutletNodes;
	}
	
	public function getLastCompletedSequenceName() :String {
		return this._lastCompletedSequenceName;
	}
	
	public function getRootContainerSize() : CCSize {
		return this._rootContainerSize;
	}
	
	public function setRootContainerSize(rootContainerSize : CCSize) {
		this._rootContainerSize = new CCSize(rootContainerSize.width, rootContainerSize.height);
	}
	
	public function getDelegate() : CCBuilderAnimationManagerDelegate {
		return this._delegate;
	}
	
	public function setDelegate(delegate :CCBuilderAnimationManagerDelegate) {
		this._delegate = delegate;
	}
	
	public function getRunningSequenceName() : String {
		return this._runningSequence.getName();
	}
	
	public function getContainerSize(?node : CCNode) : CCSize {
		if (node != null) {
			return node.getContentSize();
		} else {
			return this._rootContainerSize;
		}
	}
	
	public function addNode(node : CCNode, seq : _Dictionary) {
		this._nodeSequences.setObject(seq, node);
	}
	
	public function setBaseValue(value : Dynamic, node : CCNode, propName : String) {
		var props = this._baseValues.objectForKey(node);
		if (props == null) {
			props = new _Dictionary();
			this._baseValues.setObject(props, node);
		}
		props.setObject(value, propName);
	}
	
	public function moveAnimationsFromNode() {
		
	}
	
	public function getActionForCallbackChannel() {
		
	}
	
	public function getActionForSoundChannel() {
		
	}
	
	public function runAnimationsForSequenceNamed(name : String) {
		 this.runAnimationsForSequenceIdTweenDuration(this._getSequenceId(name), 0);
	}
	
	public function runAnimationsForSequenceNamedTweenDuration(name : String, tweenDuration : Float) {
		 this.runAnimationsForSequenceIdTweenDuration(this._getSequenceId(name), tweenDuration);
	}
	
	public function runAnimationsForSequenceIdTweenDuration(nSeqId : Int, ?tweenDuration : Float) {
		if (tweenDuration == null) {
			tweenDuration = 0;
		}

        CCCommon.assert(nSeqId != -1, "Sequence id couldn't be found");

        this._rootNode.stopAllActions();

        var allKeys = this._nodeSequences.allKeys();
		//trace(allKeys.length);
        for(i in 0...allKeys.length){
            var node : CCSprite = cast (allKeys[i], CCSprite);
			//trace("node's tag : " + node.getTag());
            node.stopAllActions();
			

            var seqs : _Dictionary = this._nodeSequences.objectForKey(node);
            var seqNodeProps : _Dictionary = seqs.objectForKey(nSeqId);
			
            var seqNodePropNames : Array<String> = new Array<String>();
            if(seqNodeProps != null){
                var propKeys : Array<Dynamic> = seqNodeProps.allKeys();
                for(j in 0...propKeys.length){
                    var propName : String = propKeys[j];
					//trace("propName :" + propName);
                    var seqProp = seqNodeProps.objectForKey(propName);
                    seqNodePropNames.push(propName);

                    this._setFirstFrame(node, seqProp,tweenDuration);
                    this._runAction(node,seqProp,tweenDuration);
                }
            }

            var nodeBaseValues : _Dictionary = this._baseValues.objectForKey(node);
            if(nodeBaseValues != null){
                var baseKeys : Array<Dynamic>= nodeBaseValues.allKeys();
                for(j in 0...baseKeys.length){
                    var selBaseKey =  baseKeys[j];
                    if(CCScheduler.ArrayGetIndexOfValue(seqNodePropNames, selBaseKey) == -1){
                        var value = nodeBaseValues.objectForKey(selBaseKey);
                        if(value != null)
                            this._setAnimatedProperty(selBaseKey,node, value, tweenDuration);
                    }
                }
            }
        }

        // Make callback at end of sequence
        var seq : CCBuilderSequence = this._getSequence(nSeqId);
        var completeAction : CCSequence = CCSequence.create([CCDelayTime.create(seq.getDuration() + tweenDuration),
            CCCallFunc.create(this._sequenceCompleted,null)]);
        this._rootNode.runAction(completeAction);

        // Playback callbacks and sounds
        //var action;
        //if (seq.getCallbackChannel()) {
            // Build sound actions for channel
            //action = this.getActionForCallbackChannel(seq.getCallbackChannel());
            //if (action) {
                //this._rootNode.runAction(action);
            //}
        //}
//
        //if (seq.getSoundChannel()) {
            // Build sound actions for channel
            //action = this.getActionForSoundChannel(seq.getSoundChannel());
            //if (action) {
                //this._rootNode.runAction(action);
            //}
        //}
        // Set the running scene
        this._runningSequence = this._getSequence(nSeqId);
	}
	
	public function runAnimations(name : Int, ?tweenDuration : Float) {
		if (tweenDuration == null) {
			tweenDuration = 0;
		}
		
		var nSeqId : Int = name;
		//if (Std.is(name, String)) {
			//nSeqId = this._getSequenceId(name);
		//} 
		
		this.runAnimationsForSequenceIdTweenDuration(nSeqId, tweenDuration);
	}
	
	public function debug() {
		
	}
	
	public function _getBaseValue(node : CCNode, propName : String) : Dynamic {
		var props = this._baseValues.objectForKey(node);
		if (props != null) {
			return props.objectForKey(propName);
		}
		return null;
	}
	
	public function _getSequenceId(sequenceName : String) : Int{
		var element : CCBuilderSequence;
		var locSequences : Array<CCBuilderSequence> = this._sequences;
		for (i in 0...locSequences.length) {
			element = locSequences[i];
			if (element != null && element.getName() == sequenceName) {
				return element.getSequenceId();
			}
		}
		return -1;
	}
	
	public function _getSequence(sequenceId : Int) : CCBuilderSequence{
		var element : CCBuilderSequence;
		var locSequences : Array<CCBuilderSequence> = this._sequences;
		for (i in 0...locSequences.length) {
			element = locSequences[i];
			if (element != null && element.getSequenceId() == sequenceId) {
				return element;
			}
		}
		return null;
	}
	
	public function _getAction(keyframe0 : CCBuilderKeyFrame, keyframe1 : CCBuilderKeyFrame, propName : String, node : CCNode) : CCActionInterval{
		var duration : Float = keyframe1.getTime() - ((keyframe0 != null) ? keyframe0.getTime() : 0);
		
		var x : Float;
		var y : Float;
		var type : Dynamic;
		var getArr : Dynamic;
		var getValueArr : Array<Dynamic>;
		
		if (propName == "rotation") {
			return CCBuilderRotateTo.create(duration, keyframe1.getValue());
		}else if (propName == "rotationX") {
            return CCBuilderRotateXTo.create(duration, keyframe1.getValue());
        } else if (propName == "rotationY") {
            return CCBuilderRotateYTo.create(duration, keyframe1.getValue());
        } else if (propName == "opacity") {
            return CCFadeTo.create(duration, keyframe1.getValue());
        } else if (propName == "color") {
            //var selColor = keyframe1.getValue().getColor();
            //return cc.TintTo.create(duration, selColor.r, selColor.g, selColor.b);
        } else if (propName == "visible") {
            var isVisible = keyframe1.getValue();
            if (isVisible) {
                return CCSequence.create([CCDelayTime.create(duration), CCShow.create()]);
            } else {
                return CCSequence.create([CCDelayTime.create(duration), CCHide.create()]);
            }
        } else if (propName == "displayFrame") {
            //return CCSequence.create(cc.DelayTime.create(duration), CCBuilderSetSpriteFrame.create(keyframe1.getValue()));
        } else if(propName == "position"){
            getArr = this._getBaseValue(node,propName);
            type = getArr[2];

            //get relative position
            getValueArr = keyframe1.getValue();
            x = getValueArr[0];
            y = getValueArr[1];

            var containerSize : CCSize = this.getContainerSize(node.getParent());

            var absPos = CCBRelativePositioning._getAbsolutePosition(x, y, type, containerSize, propName);
			//trace("duration : " + duration + " , absPos : " + absPos.y);
            return CCMoveTo.create(duration,absPos);
        } else if( propName == "scale"){
            getArr = this._getBaseValue(node,propName);
            type = getArr[2];

            //get relative position
            getValueArr = keyframe1.getValue();
            x = getValueArr[0];
            y = getValueArr[1];

            if(type == CCBReader.CCB_SCALETYPE_MULTIPLY_RESOLUTION){
                //TODO need to test
                var resolutionScale = CCBuilderReader.getResolutionScale();
                x *= resolutionScale;
                y *= resolutionScale;
            }

            return CCScaleTo.create(duration,x,y);
        } else if( propName == "skew") {
            //get relative position
            //getValueArr = keyframe1.getValue();
            //x = getValueArr[0];
            //y = getValueArr[1];
            //return cc.SkewTo.create(duration,x,y);
        } else {
            trace("BuilderReader: Failed to create animation for property: " + propName);
        }
		return null;
	}
	
	private function _setAnimatedProperty(propName : String, node : CCNode, value : Dynamic, tweenDuration : Float ) {
        if(tweenDuration > 0){
            // Create a fake keyframe to generate the action from
			var kf1 : CCBuilderKeyFrame= new CCBuilderKeyFrame();
            kf1.setValue(value);
            kf1.setTime(tweenDuration);
            kf1.setEasingType(CCBReader.CCB_KEYFRAME_EASING_LINEAR);

            // Animate
            var tweenAction = this._getAction(null, kf1, propName, node);
            node.runAction(tweenAction);
        } else {
            // Just set the value
            var getArr : Array<Dynamic>;
			var nType : Int;
			var x : Dynamic;
			var y : Dynamic;
            if(propName == "position"){
                getArr = this._getBaseValue(node,propName);
                nType = getArr[2];

                x = value[0];
                y = value[1];
                node.setPosition(CCBRelativePositioning._getAbsolutePosition(x, y, nType, this.getContainerSize(node.getParent()), propName).x,
				CCBRelativePositioning._getAbsolutePosition(x, y, nType, this.getContainerSize(node.getParent()), propName).y);
            }else if(propName == "scale"){
                getArr = this._getBaseValue(node,propName);
                nType = getArr[2];

                x = value[0];
                y = value[1];

                CCBRelativePositioning.setRelativeScale(node,x,y,nType,propName);
            } else if( propName == "skew") {
                //x = value[0];
                //y = value[1];
                //node.setSkewX(x);
                //node.setSkewY(y);
            }else {
                // [node setValue:value forKey:name];
                // TODO only handle rotation, opacity, displayFrame, color
                if(propName == "rotation"){
                    node.setRotation(value);
                } else if(propName == "opacity"){
                    node.setOpacity(value);
                } else if (propName == "displayFrame") {
					var s : CCSprite = cast (node, CCSprite);
                    s.setDisplayFrame(value);
                } else if(propName == "color"){
                    //var ccColor3B = value.getColor();
                    //if(ccColor3B.r !== 255 || ccColor3B.g !== 255 || ccColor3B.b !== 255){
                        //node.setColor(ccColor3B);
                    //}
                } else if( propName == "visible"){
                    value = (value != null) ? value : false;
                    node.setVisible(value);
                } else {
                    trace("unsupported property name is "+ propName);
                    CCCommon.assert(false, "unsupported property now");
                }
            }
        }
    }
	
	private function _setFirstFrame(node : CCNode , seqProp : CCBuilderSequenceProperty, tweenDuration : Float) {
		var keyframes = seqProp.getKeyframes();

        if (keyframes.length == 0) {
            // Use base value (no animation)
            var baseValue = this._getBaseValue(node, seqProp.getName());
            CCCommon.assert((baseValue != null), "No baseValue found for property");
            this._setAnimatedProperty(seqProp.getName(), node, baseValue, tweenDuration);
        } else {
            // Use first keyframe
            var keyframe = keyframes[0];
            this._setAnimatedProperty(seqProp.getName(), node, keyframe.getValue(), tweenDuration);
        }
	}
	
	private function _getEaseAction (action : CCActionInterval, easingType : Int, easingOpt : Float ) : CCActionInterval{
        if (easingType == CCBReader.CCB_KEYFRAME_EASING_LINEAR || easingType == CCBReader.CCB_KEYFRAME_EASING_INSTANT ) {
            return action;
		
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_CUBIC_IN) {
            return CCEaseIn.create(action, easingOpt);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_CUBIC_OUT) {
            return CCEaseOut.create(action, easingOpt);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_CUBIC_INOUT) {
            return CCEaseInOut.create(action, easingOpt);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_BACK_IN) {
            return CCEaseBackIn.create(action);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_BACK_OUT) {
            return CCEaseBackOut.create(action);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_BACK_INOUT) {
            return CCEaseBackInOut.create(action);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_BOUNCE_IN) {
            return CCEaseBounceIn.create(action);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_BOUNCE_OUT) {
            return CCEaseBounceOut.create(action);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_BOUNCE_INOUT) {
            return CCEaseBounceInOut.create(action);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_ELASTIC_IN) {
            return CCEaseElasticIn.create(action, easingOpt);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_ELASTIC_OUT) {
            return CCEaseElasticOut.create(action, easingOpt);
        } else if (easingType == CCBReader.CCB_KEYFRAME_EASING_ELASTIC_INOUT) {
            return CCEaseElasticInOut.create(action, easingOpt);
        } else {
            trace("BuilderReader: Unkown easing type " + easingType);
            return action;
        }
    }
	
	private function _runAction(node : CCNode, seqProp : CCBuilderSequenceProperty, tweenDuration : Float) {
		
        var keyframes : Array<CCBuilderKeyFrame> = seqProp.getKeyframes();
        var numKeyframes : Int = keyframes.length;
		

        if (numKeyframes > 1) {
            // Make an animation!
            var actions : Array<CCFiniteTimeAction>= new Array<CCFiniteTimeAction>();

            var keyframeFirst : CCBuilderKeyFrame = keyframes[0];
            var timeFirst : Float = keyframeFirst.getTime() + tweenDuration;
			//trace(keyframes[1].getTime());

            if (timeFirst > 0) {
                actions.push(CCDelayTime.create(timeFirst));
            }

            for (i in 0...numKeyframes - 1) {
                var kf0 : CCBuilderKeyFrame = keyframes[i];
                var kf1 : CCBuilderKeyFrame = keyframes[(i+1)];

                var action : CCActionInterval = this._getAction(kf0, kf1, seqProp.getName(), node);
                if (action != null) {
                    // Apply easing
                    action = this._getEaseAction(action, kf0.getEasingType(), kf0.getEasingOpt());
                    actions.push(action);
                }
            }
			var seq : CCAction = null;
			if (actions.length == 1) {
				seq = actions[0];
				node.runAction(seq);
			} else {
				seq = CCSequence.create(actions);
			
				node.runAction(seq);
			}
        }
    }
	
	private function _sequenceCompleted() {
        var locRunningSequence : CCBuilderSequence = this._runningSequence;
        if(this._lastCompletedSequenceName != locRunningSequence.getName()){
            this._lastCompletedSequenceName = locRunningSequence.getName();
        }

        if (this._delegate != null)
            this._delegate.completedAnimationSequenceNamed(locRunningSequence.getName());

        if(this._target != null && this._animationCompleteCallbackFunc != null){
            this._animationCompleteCallbackFunc();
        }

        var nextSeqId = locRunningSequence.getChainedSequenceId();
        this._runningSequence = null;

        if (nextSeqId != -1)
            this.runAnimations(nextSeqId, 0);
    }
}

class CCBuilderSetSpriteFame extends CCActionInstant {
	var _spriteFrame : CCSpriteFrame;
	
	private function new() {
		super();
	}
	public function initWithSpriteFrame(spriteFrame : CCSpriteFrame) : Bool{
		this._spriteFrame = spriteFrame;
		return true;
	}
	
	override public function update(time:Float)
	{
		var s : CCSprite = null;
		if (Std.is(this._target, CCSprite)) {
			s = cast(this._target, CCSprite);
		}
		
		if (s != null) {
			s.setDisplayFrame(this._spriteFrame);
		}
	}
	
	public static function create(spriteFrame : CCSpriteFrame) : CCBuilderSetSpriteFame {
		var ret = new CCBuilderSetSpriteFame();
		if (ret != null) {
			if (ret.initWithSpriteFrame(spriteFrame)) {
				return ret;
			}
		}
		return null;
	}
}

class CCBuilderRotateTo extends CCActionInterval {
	var _startAngle : Float = 0;
	var _dstAngle : Float = 0;
	var _diffAngle : Float = 0;
	
	private function new() {
		super();
	}
	
	public function initWithDurationBuilderRotateTo(duration : Float, angle : Float) : Bool {
		
		if (super.initWithDuration(duration)) {
			this._dstAngle = angle;
			return true;
		} else {
			return false;
		}
	}
	
	override public function update(time:Float)
	{
		this._target.setRotation(this._startAngle + (this._diffAngle * time));
	}
	
	override public function startWithTarget(target:CCNode)
	{
		super.startWithTarget(target);
		this._startAngle = this._target.getRotation();
		this._diffAngle = this._dstAngle - this._startAngle;
	}
	
	public static function create(duration : Float, angle : Float) : CCBuilderRotateTo {
		var ret = new CCBuilderRotateTo();
		if (ret != null) {
			if (ret.initWithDurationBuilderRotateTo(duration, angle)) {
				return ret;
			}
		}
		
		return null;
	}
}

class CCBuilderRotateXTo extends CCActionInterval {
	// TODO: rotationX is not implemented in HTML5
	
	public static function create(duration : Float, angle : Float) : CCBuilderRotateXTo {
		CCCommon.assert(false, "rotationX not implemented in cocos2d-html5");
		return null;
	}
}

class CCBuilderRotateYTo extends CCActionInterval {
	// TODO: rotationX is not implemented in HTML5
	
	public static function create(duration : Float, angle : Float) : CCBuilderRotateYTo {
		CCCommon.assert(false, "rotationX not implemented in cocos2d-html5");
		return null;
	}
}

class CCBuilderSoundEffect extends CCActionInstant {
	var _file : String;
	
	private function new() {
		super();
	}
	
	public function init(file : String) : Bool {
		this._file = file;
		return true;
	}
	
	override public function update(time:Float)
	{
		CCAudioEngine.getInstance().playEffect(this._file);
	}
	
	public static function create(file : String) : CCBuilderSoundEffect {
		var ret = new CCBuilderSoundEffect();
		if (ret != null && ret.init(file)) {
			return ret;
		}
		
		return null;
	}
}

class _Dictionary {
	var _keyMapTb : Map<String, Dynamic>;
	var _valueMapTb : Map<String, Dynamic>;
	var __currId : Int = 0;
	
	public function new() {
		this._keyMapTb = new Map<String, Dynamic>();
		this._valueMapTb = new Map<String, Dynamic>();
		this.__currId = 2 << (0 | Std.int(Math.random() * 10));
	}
	
	public function __getKey() : String {
		this.__currId++;
		return "key " + this.__currId;
	}
	
	public function setObject(value : Dynamic, key : Dynamic) {
		if (key == null) {
			return;
		}
		
		var keyId = this.__getKey();
		this._keyMapTb[keyId] = key;
		this._valueMapTb[keyId] = value;
	}
	
	public function objectForKey(key : Dynamic) :Dynamic {
		if (key == null) {
			return null;
		}
		
		for (keyId in this._keyMapTb.keys()) {
			if (this._keyMapTb[keyId] == key) {
				return this._valueMapTb[keyId];
			}
		}
		
		return null;
	}
	
	public function valueForKey(key : Dynamic) {
		return this.objectForKey(key);
	}
	
	public function removeObjectForKey(key : Dynamic) {
		if (key == null) {
			return;
		}
		
		for (keyId in this._keyMapTb.keys()) {
			if (this._keyMapTb[keyId] == key) {
				this._valueMapTb.remove(keyId);
				this._keyMapTb.remove(keyId);
				return;
			}
		}
	}
	
	public function removeObjectsForKeys(keys : Array<Dynamic>) {
		if (keys == null) {
			return;
		}
		
		for (i in 0...keys.length) {
			this.removeObjectForKey(keys[i]);
		}
	}
	
	public function allKeys() : Array<Dynamic> {
		var keyArr = new Array<Dynamic>();
		for (key in this._keyMapTb.keys()) {
			keyArr.push(this._keyMapTb[key]);
		}
		
		return keyArr;
	}
	
	public function removeAllObjects() {
		this._keyMapTb = new Map<String, Dynamic>();
		this._valueMapTb = new Map<String, Dynamic>();
	}
	
	public function count() : Int {
		return this.allKeys().length;
	}
}