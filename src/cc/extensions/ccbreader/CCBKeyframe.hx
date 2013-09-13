package cc.extensions.ccbreader;

/**
 * ...
 * @author Ang Li
 */
class CCBKeyframe
{

	public function new() 
	{
		
	}
	
}

class CCBuilderKeyFrame {
	var _value : Dynamic;
	var _time : Float;
	var _easingType : Int = 0;
	var _easingOpt : Float = 0;
	
	public function new() {
		
	}
	
	public function getValue() : Dynamic {
		return this._value;
	}
	
	public function setValue(value : Dynamic) {
		this._value = value;
	}
	
	public function getTime() : Float {
		return this._time;
	}
	
	public function setTime(time : Float) {
		this._time = time;
	}
	
	public function getEasingType() : Int { 
		return this._easingType;
	}
	
	public function setEasingType(easingType : Int) {
		this._easingType = easingType;
	}
	
	public function getEasingOpt() : Float { 
		return this._easingOpt;
	}
	
	public function setEasingOpt(easingOpt : Float) {
		this._easingOpt = easingOpt;
	}
}