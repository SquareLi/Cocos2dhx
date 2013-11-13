package cc.keyboarddispatcher;
import flambe.input.KeyboardEvent;
import cc.platform.CCCommon;

/**
 * ...
 * @author
 */
interface CCKeyboardDelegate
{
	public function onKeyDown(event : KeyboardEvent) : Void;
	
	public function onKeyUp(event : KeyboardEvent) : Void;
	
}

class CCKeyboardHandler {
	var _delegate : CCKeyboardDelegate;
	
	private function new() {
		
	}
	public function getDelegate() : CCKeyboardDelegate {
		return this._delegate;
	}
	
	public function setDelegate(d : CCKeyboardDelegate) {
		this._delegate = d;
	}
	
	public function initWithDelegate(delegate : CCKeyboardDelegate) : Bool {
		CCCommon.assert(delegate != null, "It's a wrong delegate!");
		this._delegate = delegate;
		return true;
	}
	
	public static function create(delegate : CCKeyboardDelegate) : CCKeyboardHandler {
		var handler = new CCKeyboardHandler();
		handler.initWithDelegate(delegate);
		return handler;
	}
}