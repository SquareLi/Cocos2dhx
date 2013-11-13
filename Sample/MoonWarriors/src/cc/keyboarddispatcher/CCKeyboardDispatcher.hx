package cc.keyboarddispatcher;
import cc.platform.CCCommon;
import cc.keyboarddispatcher.CCKeyboardDelegate;
import flambe.input.KeyboardEvent;
import flambe.System;
/**
 * ...
 * @author
 */
class CCKeyboardDispatcher
{
	var _delegates : Array<CCKeyboardHandler>;
	var _locked : Bool = false;
	var _toAdd : Bool = false;
	var _toRemove : Bool = false;

	var _handlersToAdd : Array<CCKeyboardDelegate>;
	var _handlersToRemove : Array<CCKeyboardDelegate>;
	
	private static var keyboardDispatcher : CCKeyboardDispatcher;
	
	private function new() {
		_handlersToAdd = new Array<CCKeyboardDelegate>();
		_handlersToRemove = new Array<CCKeyboardDelegate>();
		_delegates = new Array<CCKeyboardHandler>();
		
	}
	public function addDelegate(delegate : CCKeyboardDelegate) {
		
		if (delegate == null) {
			return ;
		}
		
		
		if (!this._locked) {
			this.forceAddDelegate(delegate);
		} else {
			this._handlersToAdd.push(delegate);
			this._toAdd = true;
		}
	}
	
	public function removeDelegate(delegate : CCKeyboardDelegate) {
		if (delegate == null) {
			return;
		}
		
		if (!this._locked) {
			this.forceRemoveDelegate(delegate);
		} else {
			this._handlersToRemove.push(delegate);
			this._toRemove = true;
		}
	}
	
	public function forceAddDelegate(delegate : CCKeyboardDelegate) {
		
		var handler = CCKeyboardHandler.create(delegate);
		if (handler != null) {
			for (d in this._delegates) {
				if (d.getDelegate() == handler.getDelegate()) {
					return;
				}
			}
			this._delegates.push(handler);
		
		}
		
	}
	
	public function forceRemoveDelegate(delegate : CCKeyboardDelegate) {
		var remove : CCKeyboardHandler = null;
		for (d in this._delegates) {
			if (d.getDelegate() == delegate) {
				remove = d;
				break;
			}
		}
		
		if (remove != null) {
			this._delegates.remove(remove);
		}
	}
	
	public function displatchKeyboardMSG(event : KeyboardEvent, keydown : Bool) : Bool {
		this._locked = true;
		var i = 0;
		if (keydown && event != null) {
			for (d in this._delegates) {
				d.getDelegate().onKeyDown(event);
			}
		} else if (!keydown && event != null) {
			for (d in this._delegates) {
				d.getDelegate().onKeyUp(event);
			}
		}
		this._locked = false;
		if (this._toRemove) {
			this._toRemove = false;
			
			for (h in this._handlersToRemove) {
				this.forceRemoveDelegate(h);
			}
			
			this._handlersToRemove = [];
		}
		
		if (this._toAdd) {
			this._toAdd = false;
			for (h in this._handlersToAdd) {
				this.forceAddDelegate(h);
			}
			this._handlersToAdd = [];
		}
		
		return true;
	}

	public static function getInstance() {
		if (keyboardDispatcher == null) {
			keyboardDispatcher = new CCKeyboardDispatcher();
			
			System.keyboard.up.connect(function(event : KeyboardEvent) {
				keyboardDispatcher.displatchKeyboardMSG(event, false);
			});
			
			System.keyboard.down.connect(function(event : KeyboardEvent) {
				keyboardDispatcher.displatchKeyboardMSG(event, true);
			});
		}
		
		return keyboardDispatcher;
	}
	
	public static function purgeSharedDispatcher() {
		if (keyboardDispatcher != null) {
			keyboardDispatcher = null;
		}
	}
}



