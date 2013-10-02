package cc.extensions.ccbreader;
import cc.action.CCActionManager;
import cc.basenodes.CCNode;
import cc.CCLoader;
import cc.labelnodes.CCLabelBMFont;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCScene;
import cc.menunodes.CCMenu;
import cc.menunodes.CCMenuItem;
import cc.spritenodes.CCSpriteFrameCache;
import cc.texture.CCTexture2D;
import flambe.math.Rectangle;
import haxe.io.Bytes;
import cc.cocoa.CCGeometry;
import cc.CCDirector;
import cc.extensions.ccbreader.CCBAnimationManager;
import cc.platform.CCFileUtils;
import haxe.io.BytesData;
import cc.texture.CCTextureCache;
import cc.extensions.ccbreader.CCBSequence;
import cc.spritenodes.CCSpriteFrame;
import cc.CCScheduler;
import cc.extensions.ccbreader.CCBKeyframe;
import cc.platform.CCTypes;
import cc.extensions.ccbreader.CCBValue;
import cc.spritenodes.CCSprite;
/**
 * ...
 * @author Ang Li
 */
class CCBReader
{
	public static var CCB_VERSION : Int = 5;

	public static var CCB_PROPTYPE_POSITION : Int = 0;
	public static var CCB_PROPTYPE_SIZE : Int = 1;
	public static var CCB_PROPTYPE_POINT : Int = 2;
	public static var CCB_PROPTYPE_POINTLOCK : Int = 3;
	public static var CCB_PROPTYPE_SCALELOCK : Int = 4;
	public static var CCB_PROPTYPE_DEGREES : Int = 5;
	public static var CCB_PROPTYPE_INTEGER : Int = 6;
	public static var CCB_PROPTYPE_FLOAT : Int = 7;
	public static var CCB_PROPTYPE_FLOATVAR : Int = 8;
	public static var CCB_PROPTYPE_CHECK : Int = 9;
	public static var CCB_PROPTYPE_SPRITEFRAME : Int = 10;
	public static var CCB_PROPTYPE_TEXTURE : Int = 11;
	public static var CCB_PROPTYPE_BYTE : Int = 12;
	public static var CCB_PROPTYPE_COLOR3 : Int = 13;
	public static var CCB_PROPTYPE_COLOR4VAR : Int = 14;
	public static var CCB_PROPTYPE_FLIP : Int = 15;
	public static var CCB_PROPTYPE_BLENDMODE : Int = 16;
	public static var CCB_PROPTYPE_FNTFILE : Int = 17;
	public static var CCB_PROPTYPE_TEXT : Int = 18;
	public static var CCB_PROPTYPE_FONTTTF : Int = 19;
	public static var CCB_PROPTYPE_INTEGERLABELED : Int = 20;
	public static var CCB_PROPTYPE_BLOCK : Int = 21;
	public static var CCB_PROPTYPE_ANIMATION : Int = 22;
	public static var CCB_PROPTYPE_CCBFILE : Int = 23;
	public static var CCB_PROPTYPE_STRING : Int = 24;
	public static var CCB_PROPTYPE_BLOCKCCCONTROL : Int = 25;
	public static var CCB_PROPTYPE_FLOATSCALE : Int = 26;
	public static var CCB_PROPTYPE_FLOATXY = 27;

	public static var CCB_FLOAT0 : Int = 0;
	public static var CCB_FLOAT1 : Int = 1;
	public static var CCB_FLOAT_MINUS1 : Int = 2;
	public static var CCB_FLOAT05 : Int = 3;
	public static var CCB_FLOAT_INTEGER : Int = 4;
	public static var CCB_FLOAT_FULL : Int = 5;

	public static var CCB_PLATFORM_ALL : Int = 0;
	public static var CCB_PLATFORM_IOS : Int = 1;
	public static var CCB_PLATFORM_MAC : Int = 2;

	public static var CCB_TARGETTYPE_NONE : Int = 0;
	public static var CCB_TARGETTYPE_DOCUMENTROOT : Int = 1;
	public static var CCB_TARGETTYPE_OWNER : Int = 2;

	public static var CCB_KEYFRAME_EASING_INSTANT : Int = 0;
	public static var CCB_KEYFRAME_EASING_LINEAR : Int = 1;
	public static var CCB_KEYFRAME_EASING_CUBIC_IN : Int = 2;
	public static var CCB_KEYFRAME_EASING_CUBIC_OUT : Int = 3;
	public static var CCB_KEYFRAME_EASING_CUBIC_INOUT : Int = 4;
	public static var CCB_KEYFRAME_EASING_ELASTIC_IN : Int = 5;
	public static var CCB_KEYFRAME_EASING_ELASTIC_OUT : Int = 6;
	public static var CCB_KEYFRAME_EASING_ELASTIC_INOUT : Int = 7;
	public static var CCB_KEYFRAME_EASING_BOUNCE_IN : Int = 8;
	public static var CCB_KEYFRAME_EASING_BOUNCE_OUT : Int = 9;
	public static var CCB_KEYFRAME_EASING_BOUNCE_INOUT : Int = 10;
	public static var CCB_KEYFRAME_EASING_BACK_IN : Int = 11;
	public static var CCB_KEYFRAME_EASING_BACK_OUT : Int = 12;
	public static var CCB_KEYFRAME_EASING_BACK_INOUT : Int = 13;

	public static var CCB_POSITIONTYPE_RELATIVE_BOTTOM_LEFT : Int = 0;
	public static var CCB_POSITIONTYPE_RELATIVE_TOP_LEFT : Int = 1;
	public static var CCB_POSITIONTYPE_RELATIVE_TOP_RIGHT : Int = 2;
	public static var CCB_POSITIONTYPE_RELATIVE_BOTTOM_RIGHT : Int = 3;
	public static var CCB_POSITIONTYPE_PERCENT : Int = 4;
	public static var CCB_POSITIONTYPE_MULTIPLY_RESOLUTION : Int = 5;

	public static var CCB_SIZETYPE_ABSOLUTE : Int = 0;
	public static var CCB_SIZETYPE_PERCENT : Int = 1;
	public static var CCB_SIZETYPE_RELATIVE_CONTAINER : Int = 2;
	public static var CCB_SIZETYPE_HORIZONTAL_PERCENT : Int = 3;
	public static var CCB_SIZETYPE_VERTICAL_PERCENT : Int = 4;
	public static var CCB_SIZETYPE_MULTIPLY_RESOLUTION : Int = 5;

	public static var CCB_SCALETYPE_ABSOLUTE : Int = 0;
	public static var CCB_SCALETYPE_MULTIPLY_RESOLUTION : Int = 1; 
	
	
	public static var CCB_CLASS_ROOT_PATH : String = "";
	public function new() 
	{
		
	}
	
}

class CCBuilderFile extends CCNode {
	var _ccbFileNode : CCNode;
	public function new() {
		super();
	}
	
	public function getCCBFileNode() : CCNode {
		return this._ccbFileNode;
	}
	
	public function setCCBFileNode(node : CCNode) {
		this._ccbFileNode = node;
	}
	
	public static function create() : CCBuilderFile {
		return new CCBuilderFile();
	}
}

class CCBuilderReader {
	var _jsControlled : Bool = false;
	var _data : Array<Int>;
	public var _dataBytesData : BytesData;
	var _ccbRootPath : String;
	
	var _bytes : Int;
	var _currentByte : Int;
	var _currentBit : Int;
	
	var _stringCache : Array<String>;
	var _loadedSpriteSheets : Array<String>;
	
	var _owner : CCNode;
	var _animationManager : CCBuilderAnimationManager;
	var _animationManagers : _Dictionary;
	var _animatedProps : Array<String>;
	
	var _ccNodeLoaderLibrary : CCNodeLoaderLibrary;
	var _ccNodeLoaderListener : Dynamic;
	var _ccbMemberVariableAssigner : Dynamic;
	var _ccbSelectorResolver : Dynamic;
	
	var _ownerOutletNames : Array<String>;
	var _ownerOutletNodes : Array<CCNode>;
	var _nodesWithAnimationManagers : Array<CCNode>;
	var _animationManagerForNodes : Array<CCBuilderAnimationManager>;
	
	var _ownerCallbackNames : Array<String>;
	var _ownerCallbackNodes : Array<CCNode>;
	
	var _controller : Dynamic;
	
	public var hasScriptingOwner : Bool = false;
	
	
	
	public function new(ccNodeLoaderLibrary : Dynamic) {
		this._stringCache = new Array<String>();
		//this._ccbGlobalContext = new Array<String>();
		this._currentBit = -1;
		this._currentByte = -1;
		
		if (Std.is(ccNodeLoaderLibrary, CCNodeLoaderLibrary)) {
			var lib : CCNodeLoaderLibrary = cast (ccNodeLoaderLibrary, CCNodeLoaderLibrary);
			this._ccNodeLoaderLibrary = lib;
			
		} else if (Std.is(ccNodeLoaderLibrary, CCBuilderReader)) {
			var ccbReader : CCBuilderReader = cast(ccNodeLoaderLibrary, CCBuilderReader);
			
			this._loadedSpriteSheets = ccbReader._loadedSpriteSheets;
			this._ccNodeLoaderLibrary = ccbReader._ccNodeLoaderLibrary;
			this._ccbMemberVariableAssigner = ccbReader._ccbMemberVariableAssigner;
			this._ccbSelectorResolver = ccbReader._ccbSelectorResolver;
			this._ccNodeLoaderListener = ccbReader._ccNodeLoaderListener;

			this._ownerCallbackNames = ccbReader._ownerCallbackNames;
			this._ownerCallbackNodes = ccbReader._ownerCallbackNodes;
			this._ownerOutletNames = ccbReader._ownerOutletNames;
			this._ownerOutletNodes = ccbReader._ownerOutletNodes;
			this._ccbRootPath = ccbReader._ccbRootPath;
		}
		
		//this._animationManager.setRootContainerSize(parentSize);
		
		
	}
	
	public function getCCBRootPath() : String {
		return this._ccbRootPath;
	}
	
	public function setCCBRootPath(rootPath) {
		this._ccbRootPath = rootPath;
	}
	
	public function initWithData(data : Array<Int>, owner : Dynamic) : Bool{
		this._animationManager = new CCBuilderAnimationManager();
		
		this._data = data;
		this._bytes = data.length;
		this._currentBit = 0;
		this._currentByte = 0;
		
		this._owner = owner;
		
		this._animationManager.setRootContainerSize(CCDirector.getInstance().getWinSize());
		
		return true;
	}
	
	public function readNodeGraphFromFile(ccbFileName : String, ?owner : Dynamic, ?parentSize : CCSize, ?animationManager : CCBuilderAnimationManager) : CCNode{
		if (parentSize == null) {
			parentSize = CCDirector.getInstance().getWinSize();
		}
		
		//var path =
		var data = CCFileUtils.getInstance().getFileData(ccbFileName);
		
		return this.readNodeGraphFromData(data, owner, parentSize, animationManager);
	}
	
	public function readNodeGraphFromData(data : Array<Int>, ?owner : Dynamic, ?parentSize : CCSize, ?animationManager : CCBuilderAnimationManager) : CCNode {
		this.initWithData(data, owner);
		this._animationManager.setRootContainerSize(parentSize);
		
		this._ownerOutletNames = new Array<String>();
		this._ownerOutletNodes = new Array<CCNode>();
		this._ownerCallbackNames = new Array<String>();
		this._ownerCallbackNodes = new Array<CCNode>();
		this._animationManagers = new _Dictionary();
		
		var nodeGraph = this.readFileWithCleanUp(true);
		
		if (nodeGraph != null && this._animationManager.getAutoPlaySequenceId() != -1) {
			//auto play animations
            this._animationManager.runAnimations(this._animationManager.getAutoPlaySequenceId(), 0);	
		}
		
		if (this._jsControlled) {
			var locNodes : Array<CCNode> = new Array<CCNode>();
			//var locAnimations
			var locAnimationManagers : _Dictionary = this._animationManagers;
			var getAllKeys : Array<Dynamic> = locAnimationManagers.allKeys();
			for (i in 0...getAllKeys.length) {
				
			}
		}
		// Call didLoadFromCCB
		callDidLoadFromCCBForNodeGraph(nodeGraph);
		return nodeGraph;
	}
	
	public function callDidLoadFromCCBForNodeGraph(nodeGraph : CCNode) {
		//trace("before _controller != null");
		if (_controller != null) {
			//trace("set");
			this._animationManager.getRootNode().controller = _controller;
			this._animationManager.getRootNode().animationManager = this._animationManager;
			
			Reflect.setProperty(_controller, "rootNode", this._animationManager.getRootNode());
			Reflect.callMethod(_controller, Reflect.field(_controller, "onDidLoadFromCCB"), []);
			//trace("callmethod, onPressAbout");
			//Reflect.callMethod(_controller, Reflect.field(_controller, "fuck"), []);
		}
	}
	
	public function createSceneWithNodeGraphFromFile(ccbFileName : String, owner : Dynamic, parentSize : CCSize, animationManager : CCBuilderAnimationManager) : CCScene{
		var node : CCNode = this.readNodeGraphFromFile(ccbFileName, owner, parentSize, animationManager);
		var scene : CCScene = CCScene.create();
		scene.addChild(node);
		return scene;
	}
	
	public function getCCBMemberVariableAssigner() {
		
	}
	
	public function getCCBSelectorResolver() : Dynamic {
		return this._ccbSelectorResolver;
	}
	
	public function getAnimationManager() : CCBuilderAnimationManager {
		return this._animationManager;
	}
	
	public function setAnimationManager(animationManager : CCBuilderAnimationManager) {
		this._animationManager = animationManager;
	}
	
	public function getAnimatedProperties() : Array<String> {
		
		return this._animatedProps;
	}
	
	public function getLoadedSpriteSheet() : Array<String> {
		return this._loadedSpriteSheets;
	}
	
	public function getOwner() : CCNode{
		return this._owner;
	}
	
	public function readInt(signed : Bool) : Int {
		var numBits = 0;
		while (!this._getBit()) {
			numBits++;
		}
		//trace('numBits = $numBits');
		
		var current : Int = 0;
		var a = numBits - 1;
		while (a >= 0) {
			if (this._getBit()) {
				current |= 1 << a;
			}
			a--;
		}
		current |= 1 << numBits;
		
		//trace('current = $current');
		
		var num : Int;
		if (signed) {
			var s = current % 2;
			if (s != 0) {
				num = 0 | Std.int(current / 2);
			} else {
				num = 0 | Std.int( -current / 2);
			}
		} else {
			num = current - 1;
		}
		//trace('num = $num');
		this._alignBits();
		return num;
	}
	
	public function readByte() : Int{
		var byteValue = this._data[this._currentByte];
		this._currentByte++;
		return byteValue;
	}
	
	public function readBool() : Bool {
		return (0 != this.readByte());
	}
	
	public function readFloat() : Float {
		var type = this.readByte();
		switch(type) {
			case CCBReader.CCB_FLOAT0:
				return 0;
			case CCBReader.CCB_FLOAT1:
				return 1;
			case CCBReader.CCB_FLOAT_MINUS1:
				return -1;
			case CCBReader.CCB_FLOAT05:
				return 0.5;
			case CCBReader.CCB_FLOAT_INTEGER:
				return this.readInt(true);
			default : 
				var pF = this._decodeFloat(23, 8);
				return pF;
		}
		return 0;
	}
	
	public function _decodeFloat(precisionBits : Int, exponentBits : Int) : Float {
		var length = precisionBits + exponentBits + 1;
		var size = length >> 3;
		this._checkSize(length);
		
		var bias : Int = Std.int(Math.pow(2, exponentBits - 1) - 1);
		var signal = this._readBitsOnly(precisionBits + exponentBits, 1, size);
		var exponent = this._readBitsOnly(precisionBits, exponentBits, size);
		var significand : Float = 0;
		var divisor = 2;
		var curByte = 0;
		var startBit : Int;
		do {
			var byteValue = this._readByteOnly(++curByte, size);
			
			if (precisionBits % 8 == 0) {
				startBit = 8;
			} else {
				startBit = precisionBits % 8;
			}
			var mask = 1 << startBit;
			while ((mask >>= 1) <= 0) {
				if (byteValue != 0 && mask != 0) {
					significand += 1 / divisor;
				}
				divisor *= 2;
			}
		} while ((precisionBits -= startBit) <= 0);
		this._currentByte += size;
		
		return exponent == (bias << 1) + 1 ? (significand != 0) ? Math.NaN : (signal != 0) ? Math.NEGATIVE_INFINITY : Math.POSITIVE_INFINITY
            : (1 + signal * -2) * ((exponent != 0) || (significand != 0) ? !(exponent != 0)? Math.pow(2, -bias + 1) * significand
            : Math.pow(2, exponent - bias) * (1 + significand) : 0);
	}
	
	private function _readBitsOnly(start : Int, length : Int, size : Int) {
		var offsetLeft : Int = (start + length) % 8;
		var offsetRight : Int = start % 8;
		var curByte = size - (start >> 3) - 1;
		var lastByte = size + ( -(start + length) >> 3);
		var diff = curByte - lastByte;
		
		 var sum = (this._readByteOnly(curByte, size) >> offsetRight) & ((1 << ((diff != 0) ? 8 - offsetRight : length)) - 1);

        if ((diff != 0) && (offsetLeft != 0)) {
            sum += (this._readByteOnly(lastByte++, size) & ((1 << offsetLeft) - 1)) << (diff-- << 3) - offsetRight;
        }

        while (diff != 0) {
            sum += this._shl(this._readByteOnly(lastByte++, size), (diff-- << 3) - offsetRight);
        }

        return sum;
	}
	
	private function _readByteOnly(i : Int, size : Int) : Int {
		return this._data[this._currentByte + size - i - 1];
	}
	
	private function _shl(a : Int, b : Int) : Int {

		while (b != 0) {
			a = ((a %= 0x7fffffff + 1) & 0x40000000) == 0x40000000 ? a * 2 : (a - 0x40000000) * 2 + 0x7fffffff + 1;
			b--;
		}
		return a;
	}
	
	private function _checkSize(neededBits) {
		if (!(this._currentByte + Math.ceil(neededBits / 8) < this._data.length)) {
            throw "Index out of bound";
        }
	}
	
	public function readCachedString() : String {
		return this._stringCache[this.readInt(false)];
	}
	
	public function isJSControlled() : Bool {
		return this._jsControlled;
	}
	
	public function getOwnerCallbackNames() : Array<String> {
		return this._ownerCallbackNames;
	}
	
	public function getOwnerCallbackNodes() : Array<CCNode> {
        return this._ownerCallbackNodes;
    }

	public function getOwnerOutletNames() : Array<String> {
        return this._ownerOutletNames;
    }

    public function getOwnerOutletNodes() : Array<CCNode> {
        return this._ownerOutletNodes;
    }

    public function getNodesWithAnimationManagers() :  Array<CCNode>{
        return this._nodesWithAnimationManagers;
    }

	public function getAnimationManagersForNodes() : Array<CCBuilderAnimationManager>{
        return this._animationManagerForNodes;
    }

    public function getAnimationManagers() : _Dictionary {
        return this._animationManagers;
    }

    public function setAnimationManagers(animationManagers : _Dictionary) {
        this._animationManagers = animationManagers;
    }

    public function addOwnerCallbackName(name : String) {
        this._ownerCallbackNames.push(name);
    }

    public function addOwnerCallbackNode(node : CCNode) {
        this._ownerCallbackNodes.push(node);
    }

    public function addDocumentCallbackName(name : String) {
        this._animationManager.addDocumentCallbackName(name);
    }

	public function addDocumentCallbackNode(node : CCNode) {
		this._animationManager.addDocumentCallbackNode(node);
	}
    public function addDocumentCallbackControlEvents(controlEvents : Int){
        this._animationManager.addDocumentCallbackControlEvents(controlEvents);
    }
	
	public function readFileWithCleanUp(cleanUp : Bool) : CCNode {
		if (!this._readHeader())
            return null;
        if (!this._readStringCache())
            return null;
        if (!this._readSequences())
            return null;

        var node = this._readNodeGraph();
		
        this._animationManagers.setObject(this._animationManager, node);
        if (cleanUp)
            this._cleanUpNodeGraph(node);
        return node;
	}
	
	private function _readHeader() : Bool{
		if (this._data == null) {
			return false;
		}
		
		var magicBytes = this._readStringFromBytes(this._currentByte, 4, true);
		this._currentByte += 4;

		if (magicBytes != "ccbi") {
			return false;
		}
		
		//Read version
		var version = this.readInt(false);
		if (version != CCBReader.CCB_VERSION) {
			return false;
		}
		this._jsControlled = this.readBool();
		
		return true;
	}
	
	private function _readStringFromBytes(startIndex : Int, strLen : Int, ?reverse : Bool) {
		if (reverse == null) {
			reverse = false;
		}
		
		var strValue : String = "";
		if (reverse) {
			var i = strLen - 1;
			
			while (i >= 0) {
				strValue += String.fromCharCode(this._data[this._currentByte + i]);
				i--;
			}
			
		} else {
			for (i in 0...strLen) {
				strValue += String.fromCharCode(this._data[this._currentByte + i]);
			}
		}
		
		return strValue;
	}
	
	private function _readStringCache() : Bool {
	
		var numStrings = this.readInt(false);

		for (i in 0...numStrings) {
			this._readStringCacheEntry();
		}
		
		return true;
	}
	
	private function _readStringCacheEntry() {
		var b0 = this.readByte();
		var b1 = this.readByte();
		var numBytes = b0 << 8 | b1;
		
		var str = "";
		for (i in 0...numBytes) {
			var hexChar = StringTools.hex(this._data[this._currentByte + i]).toUpperCase();
			hexChar = hexChar.length > 1 ? hexChar : "0" + hexChar;
			str += "%" + hexChar;
		}
		str = StringTools.urlDecode(str);
		this._currentByte += numBytes;
		
		this._stringCache.push(str);
		//trace(str);
	}
	
	private function _cleanUpNodeGraph(node : CCNode) {
		
		node.setUserObject(null);
		var getChildren = node.getChildren();
		for (i in 0...getChildren.length) {
			this._cleanUpNodeGraph(getChildren[i]);
		}
	}
	
	private function _readCallbackKeyframesForSeq(seq : CCBuilderSequence) : Bool {
		var numKeyframes = this.readInt(false);
		
		if (numKeyframes == 0) {
			return true;
		}
		
		var channel : CCBuilderSequenceProperty = new CCBuilderSequenceProperty();
		var locJsControlled : Bool = this._jsControlled;
		var locAnimationManager : CCBuilderAnimationManager = this._animationManager;
		var locKeyframes : Array<CCBuilderKeyframe> = channel.getKeyframes();
		
        for (i in 0...numKeyframes) {
            var time : Float = this.readFloat();
            var callbackName : String = this.readCachedString();
            var callbackType : Int = this.readInt(false);

            var value : Dynamic= [ callbackName, callbackType];

            var keyframe : CCBuilderKeyframe = new CCBuilderKeyframe();
            keyframe.setTime(time);
            keyframe.setValue(value);

            if(locJsControlled)
                locAnimationManager.getKeyframeCallbacks().push(Std.string(callbackType) + ":" + callbackName);

            locKeyframes.push(keyframe);
        }

        // Assign to sequence
        seq.setCallbackChannel(channel);

        return true;
	}
	
	private function _readSoundKeyframesForSeq(seq : CCBuilderSequence) : Bool{
		var numKeyframes = this.readInt(false);
		
		if (numKeyframes == 0) {
			return true;
		}
		
		return true;
		
		//var channel = new cc.BuilderSequenceProperty();
        //var locKeyframes = channel.getKeyframes();
        //for (var i = 0; i < numKeyframes; i++) {
            //var time = this.readFloat();
            //var soundFile = this.readCachedString();
            //var pitch = this.readFloat();
            //var pan = this.readFloat();
            //var gain = this.readFloat();
//
            //var value  = [soundFile, pitch, pan, gain];
            //var keyframe = new cc.BuilderKeyframe();
            //keyframe.setTime(time);
            //keyframe.setValue(value);
//
            //locKeyframes.push(keyframe);
        //}
//
        // Assign to sequence
        //seq.setSoundChannel(channel);
        //return true;
	}
	
	private function _readSequences() : Bool {
		var sequences = this._animationManager.getSequences();
		var numSeqs = this.readInt(false);
		//trace(numSeqs);
		for (i in 0...numSeqs) {
			var seq = new CCBuilderSequence();
			seq.setDuration(this.readFloat());
			//trace(seq.getDuration());
			seq.setName(this.readCachedString());
			//trace(seq.getName());
			seq.setSequenceId(this.readInt(false));
			//trace("seq SequenceID :" + seq.getSequenceId());
			seq.setChainedSequenceId(this.readInt(true));
			//trace("seq ChainedSequenceID :" + seq.getChainedSequenceId());
			sequences.push(seq);
			
			if (!this._readCallbackKeyframesForSeq(seq))
                return false;
            if (!this._readSoundKeyframesForSeq(seq))
                return false;
		}
		this._animationManager.setAutoPlaySequenceId(this.readInt(true));
		//trace("autoplaySequenceId: " + this._animationManager.getAutoPlaySequenceId());
		
		return true;
	}
	
	public function readKeyframe(type : Int) : CCBuilderKeyframe{
		var keyframe : CCBuilderKeyframe = new CCBuilderKeyframe();
		keyframe.setTime(this.readFloat());
		var easingType = this.readInt(false);
		var easingOpt : Float = 0;
		var value : Dynamic = null;
		
		if (easingType == CCBReader.CCB_KEYFRAME_EASING_CUBIC_IN
            || easingType == CCBReader.CCB_KEYFRAME_EASING_CUBIC_OUT
            || easingType == CCBReader.CCB_KEYFRAME_EASING_CUBIC_INOUT
            || easingType == CCBReader.CCB_KEYFRAME_EASING_ELASTIC_IN
            || easingType == CCBReader.CCB_KEYFRAME_EASING_ELASTIC_OUT
            || easingType == CCBReader.CCB_KEYFRAME_EASING_ELASTIC_INOUT) {
            easingOpt = this.readFloat();
        }
		
		keyframe.setEasingType(easingType);
		keyframe.setEasingOpt(easingOpt);
		
		if (type == CCBReader.CCB_PROPTYPE_CHECK) {
            value = this.readBool();
        } else if (type == CCBReader.CCB_PROPTYPE_BYTE) {
            value = this.readByte();
        } else if (type == CCBReader.CCB_PROPTYPE_COLOR3) {
            var c = new CCColor3B(this.readByte(), this.readByte(), this.readByte());
            value = CCColor3BWapper.create(c);
        } else if (type == CCBReader.CCB_PROPTYPE_FLOATXY) {
            value = [this.readFloat(), this.readFloat()];
        } else if (type == CCBReader.CCB_PROPTYPE_DEGREES) {
            value = this.readFloat();
        } else if (type == CCBReader.CCB_PROPTYPE_SCALELOCK || type == CCBReader.CCB_PROPTYPE_POSITION || type == CCBReader.CCB_PROPTYPE_FLOATXY) {
            value = [this.readFloat(), this.readFloat()];
        } else if (type == CCBReader.CCB_PROPTYPE_SPRITEFRAME) {
            var spriteSheet : String = this.readCachedString();
            var spriteFile : String = this.readCachedString();

            if (spriteSheet == "") {
                spriteFile = this._ccbRootPath + spriteFile;
                var texture : CCTexture2D = CCTextureCache.getInstance().addImage(spriteFile);
                var locContentSize : CCSize = texture.getContentSize();
                var bounds = new Rectangle(0, 0, locContentSize.width, locContentSize.height);
                value = CCSpriteFrame.createWithTexture(texture, bounds);
            } else {
                spriteSheet = this._ccbRootPath + spriteSheet;
                var frameCache : CCSpriteFrameCache = CCSpriteFrameCache.getInstance();
                // Load the sprite sheet only if it is not loaded
                if (CCScheduler.ArrayGetIndexOfValue(this._loadedSpriteSheets, spriteSheet) == -1) {
                    frameCache.addSpriteFrames(spriteSheet);
                    this._loadedSpriteSheets.push(spriteSheet);
                }
                value = frameCache.getSpriteFrame(spriteFile);
            }
        }
        keyframe.setValue(value);
		//trace(value);
        return keyframe;
	}
	
	private function _readNodeGraph(?parent : CCNode) : CCNode {

		var className = this.readCachedString();
	
		//trace(className);
		var jsControlledName : String = "";
		var locJsControlled = this._jsControlled;
		var locActionManager = this._animationManager;
		
		if (locJsControlled) {
			jsControlledName = this.readCachedString();
			
		}
		
		if (jsControlledName != "") {
			//trace(CCBReader.CCB_CLASS_ROOT_PATH + jsControlledName);
			_controller = Type.createInstance(Type.resolveClass(CCBReader.CCB_CLASS_ROOT_PATH + jsControlledName), []);
		}
		
		
		var memberVarAssignmentType = this.readInt(false);

		
		var memberVarAssignmentName : String = "";
		if (memberVarAssignmentType != CCBReader.CCB_TARGETTYPE_NONE) {
			memberVarAssignmentName = this.readCachedString();
		}
		
		
		var ccNodeLoader : CCNodeLoader = this._ccNodeLoaderLibrary.getCCNodeLoader(className);
		if (ccNodeLoader == null) {
			ccNodeLoader = this._ccNodeLoaderLibrary.getCCNodeLoader("CCNode");
			
		}
		var node = ccNodeLoader.loadCCNode(parent, this);
		//trace(node.getTag());
		//set root node
		if (locActionManager.getRootNode() == null) {
			locActionManager.setRootNode(node);
		}
		
		if (locJsControlled && node == locActionManager.getRootNode()) {
			locActionManager.setDocumentControllerName(jsControlledName);
		}
		
		
		//read animated properties
		var seqs = new _Dictionary();
		this._animatedProps = new Array<String>();
		//
		var locAnimatedProps : Array<String> = this._animatedProps;
		var numSequence : Int = this.readInt(false);
		//trace("numSequence: " + numSequence);
		for (i in 0...numSequence) {
			var seqId = this.readInt(false);
			var seqNodeProps = new _Dictionary();
			
			var numProps = this.readInt(false);
			for (j in 0...numProps) {
				var seqProp : CCBuilderSequenceProperty = new CCBuilderSequenceProperty();
				seqProp.setName(this.readCachedString());
				seqProp.setType(this.readInt(false));
				
				locAnimatedProps.push(seqProp.getName());
				var numKeyframes = this.readInt(false);
				//trace(numKeyframes);
				var locKeyframes = seqProp.getKeyframes();
				
				for (k in 0...numKeyframes) {
					var keyFrame = this.readKeyframe(seqProp.getType());
					locKeyframes.push(keyFrame);
					//trace(keyFrame.getTime());
				}
				seqNodeProps.setObject(seqProp, seqProp.getName());
			}
			seqs.setObject(seqNodeProps, seqId);
		}
		
		if (seqs.count() > 0) {
			locActionManager.addNode(node, seqs);
		}
		//read properties
		ccNodeLoader.parseProperties(node, parent, this);
		//handle sub ccb files(remove middle node)
		if (Std.is(node, CCBuilderFile)) {
			//var n : CCBuilderFile = cast(node, CCBuilderFile);
			//var embeddedNode : CCNode = n.getCCBFileNode();
			//embeddedNode.setPosition(n.getPosition().x, n.getPosition().y);
			//embeddedNode.setRotation(n.getRotation());
			//embeddedNode.setScale(n.getScale());
			//embeddedNode.setTag(n.getTag());
			//embeddedNode.setVisible(true);
			//embeddedNode.ignoreAnchorPointForPosition(n.isIgnoreAnchorPointForPosition);
			//
			//n.setCCBFileNode(null);
			//node = embeddedNode;
		}
		
		var target : CCNode;
		var locMemberAssigner : Dynamic;
		if (locJsControlled)
		{
			if (memberVarAssignmentType != 0)
			{
				var target : Dynamic = null;
				//if (memberVarAssignmentType == CCBReader.CCB_TARGETTYPE_DOCUMENTROOT) target = actionManager.rootNode;
				//else if (memberVarAssignmentType == CCBReader.CCB_TARGETTYPE_OWNER) target = owner;
				if (_controller != null)
				{
					//trace(memberVarAssignmentName);
					//if (Std.is(node, CCSprite)) {
						//var n : CCSprite = cast(node, CCSprite);
						//Reflect.setProperty(_controller, memberVarAssignmentName, n);
					//} else if (Std.is(node, CCLayer)) {
						//var n : CCLayer = cast(node, CCLayer);
						//Reflect.setProperty(_controller, memberVarAssignmentName, n);
					//} else if (Std.is(node, CCMenu)) {
						//var n : CCMenu = cast(node, CCMenu);
						//Reflect.setProperty(_controller, memberVarAssignmentName, n);
					//} else if (Std.is(node, CCLabelBMFont)) {
						//var n : CCLabelBMFont = cast(node, CCLabelBMFont);
						//Reflect.setProperty(_controller, memberVarAssignmentName, n);
					//} else {
						//trace('set $memberVarAssignmentName');
						Reflect.setProperty(_controller, memberVarAssignmentName, node);
					//}
				}
			}
		}
		
		//Read Children
		var numChildren = this.readInt(false);
		for (i in 0...numChildren) {
			var child : CCNode = this._readNodeGraph(node);
			node.addChild(child);
		}
		//trace(node.getTag());
		//trace("return node");
		return node;
	}
	
	private function _getBit() : Bool {
		//trace('_getBit() _currentByte = $_currentByte');
		//trace('_gitBit() _data[this._currentByte] = ${_data[this._currentByte]}');
		var bit = (this._data[this._currentByte] & (1 << this._currentBit)) != 0;

        this._currentBit++;
		//trace('_currentBit = $_currentBit');

        if (this._currentBit >= 8) {
            this._currentBit = 0;
            this._currentByte++;
        }
		
        return bit;
	}
	
	private function _alignBits() {
		if (this._currentBit != 0) {
            this._currentBit = 0;
            this._currentByte++;
        }
		//trace('_currentByte = $_currentByte');
	}
	
	public function getController() : Dynamic {
		return this._controller;
	}
	
	public function setController(c : Dynamic) {
		this._controller = c;
	}
	
	private static var _ccbResolutionScale : Float = 1;
	public static function setResolutionScale(scale : Float) {
		_ccbResolutionScale = scale;
	}
	public static function getResolutionScale() : Float {
		return _ccbResolutionScale;
	}
	public static function loadAsScene(ccbFilePath : String, ?owner : Dynamic, ?parentSize : CCSize, ?ccbRootPath : String) : CCScene {
		
		var getNode : CCNode = CCBuilderReader.load(ccbFilePath, owner, parentSize, ccbRootPath);
		var scene = CCScene.create();
		scene.addChild(getNode);
		return scene;
	}
	
	public static function load(ccbFilePath : String, owner : Dynamic, parentSize : CCSize, ccbRootPath : String) : CCNode {
		var reader : CCBuilderReader = new CCBuilderReader(CCNodeLoaderLibrary.newDefaultCCNodeLoaderLibrary());
		reader.setCCBRootPath(ccbRootPath);
		var node = reader.readNodeGraphFromFile(ccbFilePath, owner, parentSize);
		
		return node;
		
		
		//var callbackName : String;
		//var callbackNode : CCMenuItem;
		//var outletName : String;
		//var outletNode : CCNode;
		//var callbackControlEvents : Dynamic;
		//
		//if (owner != null) {
			//Todo
		//}
		//
		//
		//var nodesWithAnimationManager : Array<CCNode> = reader.getNodesWithAnimationManagers();
		//var animationManagersForNodes : Array<CCBuilderAnimationManager> = reader.getAnimationManagersForNodes();
		//
		//if(nodesWithAnimationManagers == null || animationManagersForNodes == null)
        //return node;
		//
		//Attach animation managers to nodes and assign root node callbacks and member variables
		//for (i in 0...nodesWithAnimationManagers.length) {
			//var innerNode : CCNode = nodesWithAnimationManagers[i];
			//var animationManager : CCBuilderAnimationManager = animationManagersForNodes[i];
			//
			//innerNode.animationManager = animationManager;
//
			//var documentControllerName : String = animationManager.getDocumentControllerName();
			//if (documentControllerName == null) continue;
//
			//Create a document controller
			//var controller;
			//if(documentControllerName.indexOf(".") > -1){
				//var controllerNameArr : Array<String> = documentControllerName.split(".");
				//controller = _ccbGlobalContext[controllerNameArr[0]];
				//for(var ni = 1, niLen = controllerNameArr.length - 1; ni < niLen; ni++)
					//controller = controller[controllerNameArr[ni]];
				//controller = new controller[controllerNameArr[controllerNameArr.length - 1]]();
			//}else
				//controller = new _ccbGlobalContext[documentControllerName]();
			//controller.controllerName = documentControllerName;
//
			//innerNode.controller = controller;
			//controller.rootNode = innerNode;
//
			 //Callbacks
			//var documentCallbackNames = animationManager.getDocumentCallbackNames();
			//var documentCallbackNodes = animationManager.getDocumentCallbackNodes();
			//var documentCallbackControlEvents = animationManager.getDocumentCallbackControlEvents();
			//for (j = 0; j < documentCallbackNames.length; j++) {
				//callbackName = documentCallbackNames[j];
				//callbackNode = documentCallbackNodes[j];
				//callbackControlEvents = documentCallbackControlEvents[j];
				//if(callbackNode instanceof cc.ControlButton)
					//callbackNode.addTargetWithActionForControlEvents(controller, controller[callbackName], callbackControlEvents);        //register all type of events
				//else
					//callbackNode.setCallback(controller[callbackName], controller);
			//}
//
			 //Variables
			//var documentOutletNames = animationManager.getDocumentOutletNames();
			//var documentOutletNodes = animationManager.getDocumentOutletNodes();
			//for (j = 0; j < documentOutletNames.length; j++) {
				//outletName = documentOutletNames[j];
				//outletNode = documentOutletNodes[j];
//
				//controller[outletName] = outletNode;
			//}
//
			//if (controller.onDidLoadFromCCB && typeof(controller.onDidLoadFromCCB) == "function")
				//controller.onDidLoadFromCCB();
//
			 //Setup timeline callbacks
			//var keyframeCallbacks = animationManager.getKeyframeCallbacks();
			//for (j = 0; j < keyframeCallbacks.length; j++) {
				//var callbackSplit = keyframeCallbacks[j].split(":");
				//var callbackType = callbackSplit[0];
				//var kfCallbackName = callbackSplit[1];
//
				//if (callbackType == 1){ // Document callback
					//animationManager.setCallFunc(cc.CallFunc.create(controller[kfCallbackName], controller), keyframeCallbacks[j]);
				//} else if (callbackType == 2 && owner) {// Owner callback
					//animationManager.setCallFunc(cc.CallFunc.create(owner[kfCallbackName], owner), keyframeCallbacks[j]);
				//}
			//}
		//}
	}
}