package cc.extensions.gui.cccontrolextension;
import cc.basenodes.CCNode;
import cc.action.CCActionInstant;

/**
 * ...
 * @author
 */
class CCInvocation
{
	var _action : Dynamic;
	var _target : Dynamic;
	var _controlEvent : Int;
	
	public function new(target : CCNode, action : Dynamic, controlEvent : Int) {
		this._target=target;
        this._action=action;
        this._controlEvent=controlEvent;
	}
	
	public function getAction() : Dynamic {
		return this._action;
	}
	
	public function getTarget() : CCNode {
		return this._target;
	}
	
	public function getControlEvent() : Int {
		return this._controlEvent;
	}
	
	public function invoke() {
		
	}
	
}