package cc.extensions;
import cc.action.CCActionManager;
import cc.basenodes.CCNode;
import cc.CCLoader;
import cc.layersscenestransitionsnodes.CCScene;
import cc.menunodes.CCMenuItem;
import haxe.io.Bytes;
import cc.cocoa.CCGeometry;
import cc.CCDirector;
import cc.extensions.CCBAnimationManager;
import cc.platform.CCFileUtils;
import haxe.io.BytesData;
import cc.extensions.CCBSequence;
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
	public static var CCB_PROPTYPE_FLOATpublic : Int = 8;
	public static var CCB_PROPTYPE_CHECK : Int = 9;
	public static var CCB_PROPTYPE_SPRITEFRAME : Int = 10;
	public static var CCB_PROPTYPE_TEXTURE : Int = 11;
	public static var CCB_PROPTYPE_BYTE : Int = 12;
	public static var CCB_PROPTYPE_COLOR3 : Int = 13;
	public static var CCB_PROPTYPE_COLOR4public : Int = 14;
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
	var _loadedSpriteSheets : Dynamic;
	
	var _owner : CCNode;
	var _actionManager : CCBuilderAnimationManager;
	var _animationManagers : _Dictionary;
	var _animatedProps : Array<String>;
	
	var _ccNodeLoaderLibrary : CCNodeLoaderLibrary;
	var _ccNodeLoaderListener : Dynamic;
	var _ccbMemberVariableAssigner : Dynamic;
	var _ccbSelectorResolver : Dynamic;
	
	var _ownerOutletNames : Array<String>;
	var _ownerOutletNodes : Array<CCNode>;
	var _nodeWithAnimationManagers : Array<CCNode>;
	var _animationManagerForNodes : Array<CCBuilderAnimationManager>;
	
	var _ownerCallbackNames : Array<String>;
	var _ownerCallbackNodes : Array<CCMenuItem>;
	
	public var hasScriptingOwner : Bool = false;
	
	
	public function new(ccNodeLoaderLibrary : CCNodeLoaderLibrary ) {
		this._stringCache = new Array<String>();
		this._currentBit = -1;
		this._currentByte = -1;
		
		this._ccNodeLoaderLibrary = ccNodeLoaderLibrary;
		//this._actionManager.setRootContainerSize(parentSize);
		
		
	}
	
	public function getCCBRootPath() : String {
		return this._ccbRootPath;
	}
	
	public function setCCBRootPath(rootPath) {
		this._ccbRootPath = rootPath;
	}
	
	public function initWithData(data : Array<Int>, owner : Dynamic) : Bool{
		this._actionManager = new CCBuilderAnimationManager();
		
		this._data = data;
		this._bytes = data.length;
		this._currentBit = 0;
		this._currentByte = 0;
		
		this._owner = owner;
		
		//this._actionManager.setRootContainerSize(cc.Director.getInstance().getWinSize());
		
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
		this._actionManager.setRootContainerSize(parentSize);
		
		this._ownerOutletNames = new Array<String>();
		this._ownerOutletNodes = new Array<CCNode>();
		this._ownerCallbackNames = new Array<String>();
		this._ownerCallbackNodes = new Array<CCMenuItem>();
		this._animationManagers = new _Dictionary();
		
		var nodeGraph = this.readFileWithCleanUp(true);
		
		if (nodeGraph != null && this._actionManager.getAutoPlaySequenceId() != -1) {
			//auto play animations
            //this._actionManager.runAnimations(this._actionManager.getAutoPlaySequenceId(), 0);
		}
		
		return nodeGraph;
	}
	
	public function createSceneWithNodeGraphFromFile(ccbFileName : String, owner : Dynamic, parentSize : CCSize, animationManager : CCBuilderAnimationManager) : CCScene{
		var node : CCNode = this.readNodeGraphFromFile(ccbFileName, owner, parentSize, animationManager);
		var scene : CCScene = CCScene.create();
		scene.addChild(node);
		return scene;
	}
	
	public function getCCBMemberVariableAssigner() {
		
	}
	
	public function getCCBSelectorResolver() {
		
	}
	
	public function getAnimationManager() : CCBuilderAnimationManager {
		return this._actionManager;
	}
	
	public function setAnimationManager(animationManager : CCBuilderAnimationManager) {
		this._actionManager = animationManager;
	}
	
	public function getAnimatedProperties() : Array<String> {
		
		return this._animatedProps;
	}
	
	public function getLoadedSpriteSheet() {
		//return this._loadedSpriteSheets;
	}
	
	public function getOwner() {
		
	}
	
	public function readInt(signed : Bool) : Int {
		
		var numBits = 0;
		while (!this._getBit()) {
			numBits++;
		}
		
		var current : Int = 0;
		var a = numBits - 1;
		while (a >= 0) {
			if (this._getBit()) {
				current |= 1 << a;
			}
			a--;
		}
		current |= 1 << numBits;
		
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
	
	public function getOwnerCallbackNodes() : Array<CCMenuItem> {
        return this._ownerCallbackNodes;
    }

	public function getOwnerOutletNames() : Array<String> {
        return this._ownerOutletNames;
    }

    public function getOwnerOutletNodes() : Array<CCNode> {
        return this._ownerOutletNodes;
    }

    //public function getNodesWithAnimationManagers() :  Array<CCNode>{
        //return this._nodesWithAnimationManagers;
    //}

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

    public function addOwnerCallbackNode(node : CCMenuItem) {
        this._ownerCallbackNodes.push(node);
    }

    public function addDocumentCallbackName(name : String) {
        this._actionManager.addDocumentCallbackName(name);
    }

    public function addDocumentCallbackNode(node : CCMenuItem) {
        this._actionManager.addDocumentCallbackNode(node);
    }
	
	public function readFileWithCleanUp(cleanUp : Bool) : CCNode {
		if (!this._readHeader())
            return null;
        if (!this._readStringCache())
            return null;
        if (!this._readSequences())
            return null;

        var node = this._readNodeGraph();
        this._animationManagers.setObject(this._actionManager, node);

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
			var hexChar = StringTools.hex(this._data[this._currentByte + i]);
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
	
	private function _readSequences() : Bool {
		var sequences = this._actionManager.getSequences();
		var numSeqs = this.readInt(false);
		for (i in 0...numSeqs) {
			var seq = new CCBuilderSequence();
			seq.setDuration(this.readFloat());
			seq.setName(this.readCachedString());
			seq.setSequenceId(this.readInt(false));
			seq.setChainedSequenceId(this.readInt(true));
			sequences.push(seq);
		}
		this._actionManager.setAutoPlaySequenceId(this.readInt(true));
		return true;
	}
	
	
	private function _readNodeGraph(?parent : CCNode) : CCNode {
		var className = this.readCachedString();
		trace(className);
		
		var memberVarAssignmentType = this.readInt(false);
		var memberVarAssignmentName : String = "";
		if (memberVarAssignmentType != CCBReader.CCB_TARGETTYPE_NONE) {
			memberVarAssignmentName = this.readCachedString();
		}
		trace(memberVarAssignmentType + ", " + memberVarAssignmentName);
		var ccNodeLoader = this._ccNodeLoaderLibrary.getCCNodeLoader(className);
		if (ccNodeLoader == null) {
			ccNodeLoader = this._ccNodeLoaderLibrary.getCCNodeLoader("CCNode");
		}
		var node = ccNodeLoader.loadCCNode(parent, this);
		
		//set root node
		if (this._actionManager.getRootNode() == null) {
			this._actionManager.setRootNode(node);
		}
		
		//read animated properties
		//var seqs = new _Dictionary();
		//this._animatedProps = new Array<String>();
		//
		//var numSequence : Int = this.readInt(false);
		//for (i in 0...numSequence) {
			//var seqId = this.readInt(false);
			//var seqNodeProps = new _Dictionary();
			//
			//var numProps = this.readInt(false);
			//
			//for (j in 0...numProps) {
				//var seqProp : CCBuilderSequenceProperty = new CCBuilderSequenceProperty();
				//seqProp.setName(this.readCachedString());
				//seqProp.setType(this.readInt(false));
				//
				//this._animatedProps.push(seqProp.getName());
				//var numKeyframes = this.readInt(false);
				//
				//for (k in 0...numKeyframes) {
					//var keyFrame = this.readKeyFrame(seqProp.getType());
					//seqProp.getKeyFrames().push(keyFrame);
				//}
				//seqNodeProps.setObject(seqProp, seqProp.getName());
			//}
			//seqs.setObject(seqNodeProps, seqId);
		//}
		//
		//if (seqs.count() > 0) {
			//this._actionManager.addNode(node, seqs);
		//}
		//
		//read properties
		//ccNodeLoader.parseProperties(node, parent, this);
		
		//handle sub ccb files(remove middle node)
		//if (Std.is(node, CCBuilderFile)) {
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
		//}
		
		//if (memberVarAssignmentType != CCBReader.CCB_TARGETTYPE_NONE) {
			//var target : CCNode = null;
			//if (memberVarAssignmentType == CCBReader.CCB_TARGETTYPE_DOCUMENTROOT) {
				//target = this._actionManager.getRootNode();
			//} else if (memberVarAssignmentType == CCBReader.CCB_TARGETTYPE_OWNER) {
				//target = this._owner;
			//}
			//
			//if (target != null) {
				//var assigned : Bool = false;
				//if (target != null && (target.onA
			//}
			//if (memberVarAssignmentType
		//}
		
		return node;
	}
	
	private function _getBit() : Bool {
		var bit = (this._data[this._currentByte] & (1 << this._currentBit)) != 0;

        this._currentBit++;

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
//		scene.addChild(getNode);
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
		//if (owner != null) {
			//
		//}
		//
		//var nodesWithAnimationManagers = reader.getNodesWithAnimationManagers();
		//var animationManagersForNodes = reader.getAnimationManagersForNodes();
		//
		//for (i in 0...nodesWithAnmiationManagers.length) {
			//var innerNode = nodesWithAnimationManagers[i];
			//var animationManager = animationManagersForNodes[i];
			//
			//innerNode.setUserObject(animationManager);
			//var documentControllerName = animationManager.getDocumentControllerName();
			//if (documentControllerName == null) continue;
			//
			// Create a document controller
			//var controller = new _ccbGlobalContext
			//
			//Callbacks
			//var documentCallbackNames = animationManager.getDocumentCallbackNames();
			//var documentCallbackNodes = animationManager.getDocumentCallbackNodes();
			//for (j in 0...documentCallbackNames.length) {
				//callbackName = documentCallbackNames[j];
				//callbackNode = ownerCallbackNodes[i];
				//callbackNode.setCallback(
			//}
		//}
	}
}