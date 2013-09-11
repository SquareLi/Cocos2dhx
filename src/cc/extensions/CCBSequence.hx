package cc.extensions;

/**
 * ...
 * @author Ang Li
 */
class CCBSequence {
	
}
class CCBuilderSequence
{
	var _duration : Float = 0;
	var _name : String = "";
	var _sequenceId : Int = 0;
	var _chainedSequenceId : Int = 0;
	
	public function new() 
	{
		this._name = "";
	}
	
	public function getDuration() : Float {
		return this._duration;
	}
	
	public function setDuration(duration : Float) {
		this._duration = duration;
	}
	
	public function getName() : String {
		return this._name;
	}
	
	public function setName(name : String) {
		this._name = name;
	}
	
	public function getSequenceId() : Int {
		return this._sequenceId;
	}
	
	public function setSequenceId(sequenceId : Int) {
		this._sequenceId = sequenceId;
	}
	
	public function getChainedSequenceId() : Int {
		return this._chainedSequenceId;
	}
	
	public function setChainedSequenceId(chainedSequenceId : Int) {
		this._chainedSequenceId = chainedSequenceId;
	}
}

class CCBuilderSequenceProperty {
	var _name : String;
	var _type : Int;
	var _keyFrames : Array<Dynamic>;
	
	public function new() {
		this.init();
	}
	
	public function init() {
		this._keyFrames = new Array<Dynamic>();
		this._name = "";
	}
	
	public function getName() : String {
		return this._name;
	}
	
	public function setName(name : String) {
		this._name = name;
	}
	
	public function getType() : Int {
		return this._type;
	}
	
	public function setType(type : Int) {
		this._type = type;
	}
	
	public function getKeyFrames() : Array<Dynamic> {
		return this._keyFrames;
	}
}