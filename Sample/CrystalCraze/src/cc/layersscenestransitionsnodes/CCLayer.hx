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

package cc.layersscenestransitionsnodes;
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.CCDirector;
import cc.keyboarddispatcher.CCKeyboardDelegate;
import cc.touchdispatcher.CCPointer;
import flambe.display.Sprite;
import flambe.subsystem.PointerSystem;
import flambe.input.PointerEvent;
import cc.touchdispatcher.CCPointerEventDelegate;
import flambe.math.Point;
import flambe.input.KeyboardEvent;
import cc.platform.CCTypes;
import cc.touchdispatcher.CCPointerEventDelegate;
import cc.menunodes.CCMenu;
/**
 * ...
 * @author Ang Li
 */

 

class CCLayer extends CCNode implements CCPointerEventDelegate implements CCKeyboardDelegate
{
	var _isPointerEnabled : Bool = false;
	var _isAccelerometerEnabled : Bool = false;
	var _isKeyboardEnabled : Bool = false;
	var _pointerPriority : Int = 0;
	
	public function new() 
	{
		//trace('ctor in CCLayer');
		super();
	}
	
	private function _initLayer() {
		//trace("_initLayer");
		this.setAnchorPoint(new Point(0, 0));
		this._ignoreAnchorPointForPosition = true;
		
		var director : CCDirector = CCDirector.getInstance();
		
		this.setContentSize(director.getWinSize());
		this._isPointerEnabled = false;
		this._pointerPriority = 0;
		addComponent();
		
	}
	
	public function addComponent() {
		if (this.component == null) {
			this.component = new CCComponent(this);
			this.entity.add(component);
			
			if (!this.entity.has(Sprite)) {
				//this.sprite = new Sprite();
				this.entity.add(sprite);
			}
		}
		
	}
	
	override public function init():Bool 
	{
		//trace("init in CCLayer");
		super.init();
		this._initLayer();
		
		return true;
	}
	
	public function registerWithTouchDispatcher() {
		//trace("reg");
		//this._isPointerEnabled = true;
		CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this, this._pointerPriority);
	}
	
	public function isPointerEnabled() : Bool {
		return this._isPointerEnabled;
	}
	
	public function setPointerEnabled(enabled : Bool) {
		if (this._isPointerEnabled != enabled) {
			this._isPointerEnabled = enabled;
			if (this._running) {
				if (enabled) {
					CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this, this._pointerPriority);
				} else {
					CCDirector.getInstance().getPointerDispatcher().removeAllMouseDelegates();
				}
			}
		}
		
		
	}
	
	public function setPointerPriority(priority : Int) {
		if (this._pointerPriority != priority) {
			this._pointerPriority = priority;
			if (this._isPointerEnabled) {
				this.setPointerEnabled(false);
				this.setPointerEnabled(true);
			}
			
		}
	}
	
	public function getPointerPriority() : Int {
		return this._pointerPriority;
	}
	
	public function isKeyboardEnabled() : Bool {
		return this._isKeyboardEnabled;
	}
	
	public function setKeyboardEnabled(enabled : Bool) {
		if (enabled != this._isKeyboardEnabled) {
			this._isKeyboardEnabled = enabled;
			if (this._running) {
				var director = CCDirector.getInstance();
				if (enabled) {
					director.getKeyboardDispatcher().addDelegate(this);
				} else {
					director.getKeyboardDispatcher().removeDelegate(this);
				}
			}
		}
	}
	
	
	override public function draw() 
	{
		//trace("Layer dras");
	}
	
	override public function onEnter()
	{
		var director = CCDirector.getInstance();
		
		if (this._isPointerEnabled = true) {
			this.registerWithTouchDispatcher();
		}
		super.onEnter();
	}
	
	override public function onExit() 
	{
		
		var director = CCDirector.getInstance();
		
		if (this._isPointerEnabled) {
			//trace("remove Pointer");
			
		}
		director.getPointerDispatcher().removePointerDelegate(this);
		super.onExit();
	}
	
	@:keep public dynamic function onPointerDown(event : CCPointer) : Bool {
		return false;
	}
	
	@:keep public dynamic function onPointerDragged(event : CCPointer) : Bool {
		return false;
	}
	
	@:keep public dynamic function onPointerMoved(event : CCPointer) : Bool {
		return false;
	}
	
	@:keep public dynamic function onPointerUp(event : CCPointer) : Bool {
		return false;
	}
	
	public function onKeyDown(event : KeyboardEvent) {
		
	}
	
	public function onKeyUp(event : KeyboardEvent) {
		
	}
	
	public static function create() : CCLayer {
		var ret : CCLayer = new CCLayer();
		if (ret != null) {
			return ret;
		}
		return null;
	}
}

/**
 * <p>
 *     CCLayerRGBA is a subclass of CCLayer that implements the CCRGBAProtocol protocol using a solid color as the background.                        <br/>
 *     All features from CCLayer are valid, plus the following new features that propagate into children that conform to the CCRGBAProtocol:          <br/>
 *       - opacity                                                                                                                                    <br/>
 *       - RGB colors
 * </p>
 * @class
 * @extends cc.Layer
 */
class CCLayerRGBA extends CCLayer {
	public var RGBAProtocol : Bool = true;
	var _displayedOpacity : Int = 0;
	var _realOpacity : Int = 0;
	var _displayedColor : CCColor3B;
	var _realColor : CCColor3B;
	var _cascadeOpacityEnabled : Bool = false;
    var _cascadeColorEnabled : Bool = false;
	
	public function new() {
		super();
		this.RGBAProtocol = true;
		this._displayedOpacity = 255;
		this._realOpacity = 255;
		this._displayedColor = CCTypes.white();
		this._realColor = CCTypes.white();
		this._cascadeOpacityEnabled = false;
		this._cascadeColorEnabled = false;
	}

	override public function init():Bool 
	{
		if (super.init()) {
			this.setCascadeOpacityEnabled(false);
			this.setCascadeColorEnabled(false);
			return true;
		}
		
		return false;
	}
	
	/**
     *
     * @returns {number}
     */
	override public function getOpacity() : Int{
        return this._realOpacity;
    }


    /**
     *
     * @returns {number}
     */
	public function getDisplayedOpacity() : Int{
        return this._displayedOpacity;
    }

    /**
     * Override synthesized setOpacity to recurse items
     * @param {Number} opacity
     */
    override public function setOpacity(opacity : Int) {
        this._displayedOpacity = this._realOpacity = opacity;

        if( this._cascadeOpacityEnabled ) {
            var parentOpacity = 255;
            var locParent : CCLayerRGBA = cast (this._parent, CCLayerRGBA);
            if ((locParent != null) && locParent.RGBAProtocol && locParent.isCascadeOpacityEnabled())
                parentOpacity = locParent.getDisplayedOpacity();

            this.updateDisplayedOpacity(parentOpacity);
        }
    }

    /**
     *
     * @param {Number} parentOpacity
     */
    public function updateDisplayedOpacity(parentOpacity : Int) {
        this._displayedOpacity = Std.int(this._realOpacity * parentOpacity/255.0);

        if (this._cascadeOpacityEnabled){
            var locChildren = this._children;
            for(i in 0...locChildren.length){
                var selItem : CCLayerRGBA = cast (locChildren[i], CCLayerRGBA);
                if((selItem != null) && selItem.RGBAProtocol)
                    selItem.updateDisplayedOpacity(this._displayedOpacity);
            }
        }
    }

    public function isCascadeOpacityEnabled() : Bool {
        return this._cascadeOpacityEnabled;
    }

    public function setCascadeOpacityEnabled(cascadeOpacityEnabled : Bool) {
        this._cascadeOpacityEnabled = cascadeOpacityEnabled;
    }

    public function getColor() : CCColor3B{
        return this._realColor;
    }

    public function getDisplayedColor() : CCColor3B{
        return this._displayedColor;
    }

    public function setColor(color : CCColor3B) {
        this._displayedColor = CCTypes.c3b(color.r, color.g, color.b);
        this._realColor = CCTypes.c3b(color.r,color.g, color.b);

        if (this._cascadeColorEnabled){
            var parentColor : CCColor3B = CCTypes.white();
            var locParent : CCLayerRGBA = cast(this._parent, CCLayerRGBA);
            if ((locParent != null) && locParent.RGBAProtocol && locParent.isCascadeColorEnabled())
                parentColor = locParent.getDisplayedColor();
            this.updateDisplayedColor(parentColor);
        }
    }

	public function updateDisplayedColor(parentColor : CCColor3B) {
        var locDispColor : CCColor3B = this._displayedColor;
		var locRealColor : CCColor3B = this._realColor;
        locDispColor.r = Std.int(locRealColor.r * parentColor.r/255.0);
        locDispColor.g = Std.int(locRealColor.g * parentColor.g/255.0);
        locDispColor.b = Std.int(locRealColor.b * parentColor.b/255.0);

        if (this._cascadeColorEnabled){
            var selChildren = this._children;
            for(i in 0...selChildren.length){
                var item : CCLayerRGBA = cast (selChildren[i], CCLayerRGBA);
                if((item != null) && item.RGBAProtocol)
                    item.updateDisplayedColor(locDispColor);
            }
        }
    }

    public function isCascadeColorEnabled() : Bool {
        return this._cascadeColorEnabled;
    }

    public function setCascadeColorEnabled(cascadeColorEnabled : Bool) {
        this._cascadeColorEnabled = cascadeColorEnabled;
    }

    public function setOpacityModifyRGB(bValue : Bool) {
    }

    public function isOpacityModifyRGB() : Bool{
        return false;
    }
	
	
}




