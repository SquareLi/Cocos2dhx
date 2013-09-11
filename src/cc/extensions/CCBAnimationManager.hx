package cc.extensions;
import cc.basenodes.CCNode;
import cc.cocoa.CCGeometry;
import cc.menunodes.CCMenuItem;
import cc.extensions.CCBSequence;
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
	
}

class CCBuilderAnimationManager {
	var _sequences : Array<CCBuilderSequence>;
    var _nodeSequences : _Dictionary;
    var _baseValues : _Dictionary;
    var _autoPlaySequenceId : Int = 0;

    var _rootNode : CCNode;
    var _rootContainerSize : CCSize;

    var _delegate : CCBuilderAnimationManagerDelegate;
    //_runningSequence:null,

    var _documentOutletNames : Array<String>;
    var _documentOutletNodes : Array<CCNode>;
    var _documentCallbackNames : Array<String>;
    var _documentCallbackNodes : Array<CCMenuItem>;
    var _documentControllerName : String = "";
    var _lastCompletedSequenceName : String = "";

   // _animationCompleteCallbackFunc:null,
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
	
	//public function getRunningSequenceName() : String {
		//return this._runningSequence.getName();
	//}
	
	public function getContainerSize(?node : CCNode) : CCSize {
		if (node != null) {
			return node.getContentSize();
		} else {
			return this._rootContainerSize;
		}
	}
	
	public function addNode(node : CCNode, seq : Int) {
		this._nodeSequences.setObject(seq, node);
	}
	
	public function setBaseValue(value : Array<Float>, node : CCNode, propName : String) {
		var props = this._baseValues.objectForKey(node);
		if (props == null) {
			props = new _Dictionary();
			this._baseValues.setObject(props, node);
		}
		
		props.setObject(value, propName);
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