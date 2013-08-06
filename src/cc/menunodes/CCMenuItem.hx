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

package cc.menunodes;
import cc.action.CCAction;
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.labelnodes.CCLabelBMFont;
import cc.spritenodes.CCAnimation;
import cc.spritenodes.CCSprite;
import cc.spritenodes.CCSpriteFrame;
import flambe.display.Sprite;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.action.CCActionInterval;

/**
 * Subclass cc.MenuItem (or any subclass) to create your custom cc.MenuItem objects.
 * @class
 * @extends cc.Node
 */
class CCMenuItem extends CCNode
{
	/**
	 * default size for font size
	 * @constant
	 * @type Number
	 */
	public static var ITEM_SIZE : Int = 32;
	public static var _fontSize : Int = 32;
	public static var _fontName : String = "Arial";
	public static var _FontNameRelease : Bool = false;
	
	/**
	 * default tag for current item
	 * @constant
	 * @type Number
	 */
	public static var CURRENT_ITEM : Int = 0xc0c05001;
	
	/**
	 * default tag for zoom action tag
	 * @constant
	 * @type Number
	 */
	public static var ZOOM_ACTION_TAG : Int = 0xc0c05002;
	
	/**
	 * default tag for normal
	 * @constant
	 * @type Number
	 */
	public static var NORMAL_TAG : Int = 8801;
	
	/**
	 * default selected tag
	 * @constant
	 * @type Number
	 */
	public static var SELECTED_TAG : Int = 8802;
	
	/**
	 * default disabled tag
	 * @constant
	 * @type Number
	 */
	public static var DISABLE_TAG : Int = 8803;
	
	
	var _listener : CCNode;
	var _selector : Void -> Void;
	var _isSelected : Bool = false;
	var _isEnabled : Bool = false;
	public function new() 
	{
		super();
		this.sprite = new Sprite();
		this.entity.add(sprite);
		this.component = new CCComponent(this);
		this.entity.add(component);
	}
	
	/**
     * MenuItem is selected
     * @return {Boolean}
     */
	public function isSelected() : Bool {
		return this._isSelected;
	}
	
	/**
     * set the target/selector of the menu item
     * @param {function|String} selector
     * @param {cc.Node} rec
     */
	public function setTarget(selector : Void -> Void, rec : CCNode) {
		this._listener = rec;
		this._selector = selector;
	}
	
	/**
     * MenuItem is Enabled
     * @return {Boolean}
     */
	public function isEnabled() : Bool {
		return this._isEnabled;
	}
	
	/**
     * set enable value of MenuItem
     * @param {Boolean} enable
     */
	public function setEnabled(enable : Bool) {
		this._isEnabled = enable;
	}
	
	/**
     * @param {function|String} selector
     * @param {cc.Node} rec
     * @return {Boolean}
     */
	public function initWithCallback(selector : Void -> Void, rec : CCNode) : Bool {
		this._listener = rec;
		this._selector = selector;
		this._isEnabled = true;
		this._isSelected = false;
		return true;
	}
	
	/**
     * return rect value of cc.MenuItem
     * @return {cc.Rect}
     */
	public function rect() : Rectangle {
		//trace(this._position.x + "," + this._anchorPoint.x);
		return new Rectangle(this._position.x + this._parent._position.x - this._anchorPoint.x,
            this._position.y + this._parent._position.y - this._anchorPoint.y,
            this._contentSize.width, this._contentSize.height);
		//return this.getBoundingBox();
	}
	
	/**
     * same as setIsSelected(true)
     */
	public function selected() {
		this._isSelected = true;
	}
	
	/**
     * same as setIsSelected(false)
     */
	public function unselected() {
		this._isSelected = false;
	}
	
	/**
     * @param {function|String} selector
     * @param {cc.Node} rec
     */
	public function setCallback(selector : Void -> Void, rec : CCNode) {
		this._listener = rec;
		this._selector = selector;
	}
	
	/**
     * call the selector with target
     */
	public function activate() {
		if (this._isEnabled && _selector != null) {
			this._selector();
		}
	}
	
	public static function create(selector : Void -> Void, rec : CCNode) {
		var ret : CCMenuItem = new CCMenuItem();
		ret.initWithCallback(selector, rec);
		return ret;
	}
}

/**
 * Any cc.Node that supports the cc.LabelProtocol protocol can be added.<br/>
 * Supported nodes:<br/>
 * - cc.BitmapFontAtlas<br/>
 * - cc.LabelAtlas<br/>
 * - cc.LabelTTF<br/>
 * @class
 * @extends cc.MenuItem
 */
class CCMenuItemLabel extends CCMenuItem {
	var _label : CCLabelBMFont;  //Only support CCLabelBMFont 
	var _originalScale : Float = 0;

	
	public function new() {
		super();
	}
	public function getLabel() : CCLabelBMFont {
		return _label;
	}
	
	public function setLabel(label : CCLabelBMFont) {
		if (label != null) {
			this.addChild(label);
			this.setContentSize(label.getContentSize());
			//trace(label.getContentSize().width + "," + label.getContentSize().height);
		}
		
		if (this._label != null) {
			this.removeChild(this._label, true);
		}
		
		this._label = label;
	}
	
	override public function setEnabled(enable:Bool) 
	{
		if (this._isEnabled != enable) {
			if (!enable) {
				
			} else {
				
			}
		}
		super.setEnabled(enable);
	}
	
	public function setOpacity(opacity : Int) {
		_label.setOpacity(opacity);
	}
	
	public function getOpacity() : Int {
		return this._label.getOpacity();
	}
	
	public function initWithLabel(label : CCLabelBMFont, selector : Void -> Void, target : CCNode) {
		this.initWithCallback(selector, target);
		this._originalScale = 1;
		this.setLabel(label);
		//this.setCenterAnchor();
		return true;
	}
	
	public function setString(label : String) {
		this._label.setString(label);
	}
	
	override public function activate()
	{	
		if (this._isEnabled) {
			//this.stopAllActions(); 
			this.setScale(this._originalScale);
			super.activate();
		}
	}
	
	override public function selected()
	{
		if (this._isEnabled) {
			super.selected();
			var action : CCAction = this.getActionByTag(CCMenuItem.ZOOM_ACTION_TAG);
			if (action != null) {
				this.stopAction(action);
			} else {
				this._originalScale = this.getScale();
			}
			
			var zoomAction : CCScaleTo = CCScaleTo.create(0.1, this._originalScale * 1.2);
			zoomAction.setTag(CCMenuItem.ZOOM_ACTION_TAG);
			this._label.runAction(zoomAction);
		}
	}
	
	override public function unselected()
	{
		if (this._isEnabled) {
			super.unselected();
			this.stopActionByTag(CCMenuItem.ZOOM_ACTION_TAG);
			var zoomAction : CCScaleTo = CCScaleTo.create(0.1, this._originalScale);
			zoomAction.setTag(CCMenuItem.ZOOM_ACTION_TAG);
			this.runAction(zoomAction);
		}
	}
	
	public static function create(label : CCLabelBMFont, selector : Void -> Void, target : CCNode) : CCMenuItemLabel {
		var ret = new CCMenuItemLabel();
		ret.initWithLabel(label, selector, target);
		//label.setCenterAnchor();
		
		return ret;
	}
}

class CCMenuItemSprite extends CCMenuItem {
	var _normalImage : CCSprite;
	var _selectedImage : CCSprite;
	var _disabledImage : CCSprite;
	
	private function new() {
		super();
		
	}
	
	public function getNormalImage() : CCSprite {
		return this._normalImage;
	}
	
	public function setNormalImage(normalImage : CCSprite) {
		if (this._normalImage == normalImage) {
			return ;
		}
		
		if (normalImage != null) {
			this.addChild(normalImage, 0, CCMenuItem.NORMAL_TAG);
		}
		
		if (this._normalImage != null) {
			this.removeChild(this._normalImage, true);
		}
		
		this._normalImage = normalImage;
		this.setContentSize(this._normalImage.getContentSize());
		this._updateImagesVisibility();
	}
	
	public function getSelectedImage() : CCSprite {
		return this._selectedImage;
	}
	
	public function setSelectedImage(selectedImage : CCSprite) {
		if (this._selectedImage == selectedImage)
            return;

        if (selectedImage != null) {
            this.addChild(selectedImage, 0, CCMenuItem.SELECTED_TAG);
        }

        if (this._selectedImage != null) {
            this.removeChild(this._selectedImage, true);
        }

        this._selectedImage = selectedImage;
        this._updateImagesVisibility();
	}
	
	public function getDisabledImage() : CCSprite {
		return this._disabledImage;
	}
	
	public function setDisabledImage(disabledImage : CCSprite) {
		if (this._disabledImage == disabledImage)
            return;

        if (disabledImage != null) {
            this.addChild(disabledImage, 0, CCMenuItem.DISABLE_TAG);
        }

        if (this._disabledImage != null) {
            this.removeChild(this._disabledImage, true);
        }

        this._disabledImage = disabledImage;
        this._updateImagesVisibility();
	}
	
	public function initWithNormalSprite(normalSprite : CCSprite, selectedSprite : CCSprite, disabledSprite : CCSprite, selector : Void -> Void, target : CCNode) : Bool {
		this.initWithCallback(selector, target);
		this.setNormalImage(normalSprite);
		this.setSelectedImage(selectedSprite);
		this.setDisabledImage(disabledSprite);
		
		if (this._normalImage != null) {
			this.setContentSize(this._normalImage.getContentSize());
		}
		
		return true;
	}
	
	//public function setColor(
	
	public function setOpacity(opacity : Int) {
		this._normalImage.setOpacity(opacity);
		
		if (this._selectedImage != null) {
			this._selectedImage.setOpacity(opacity);
		}
		
		if (this._disabledImage != null) {
            this._disabledImage.setOpacity(opacity);
        }
	}
	
	public function getOpacity() : Int {
		return this._normalImage.getOpacity();
	}
	
	override public function selected() {
		super.selected();
		
		if (this._normalImage != null) {
			if (this._disabledImage != null) {
				this._disabledImage.setVisible(false);
			}
			
			if (this._selectedImage != null) {
				this._normalImage.setVisible(false);
				this._selectedImage.setVisible(true);
			} else {
				this._normalImage.setVisible(true);
			}
		}
	}
	
	override public function unselected() {
		super.unselected();
		
		if (this._normalImage != null) {
            this._normalImage.setVisible(true);

            if (this._selectedImage != null) {
                this._selectedImage.setVisible(false);
            }

            if (this._disabledImage != null) {
                this._disabledImage.setVisible(false);
            }
        }
	}
	
	override public function setEnabled(bEnabled : Bool) {
		if (this._isEnabled != bEnabled) {
			super.setEnabled(bEnabled);
			this._updateImagesVisibility();
		}
	}
	
	private function _updateImagesVisibility() {
		if (this._isEnabled) {
            if (this._normalImage != null)
                this._normalImage.setVisible(true);
            if (this._selectedImage != null)
                this._selectedImage.setVisible(false);
            if (this._disabledImage != null)
                this._disabledImage.setVisible(false);
        } else {
            if (this._disabledImage != null) {
                if (this._normalImage != null)
                    this._normalImage.setVisible(false);
                if (this._selectedImage != null)
                    this._selectedImage.setVisible(false);
                if (this._disabledImage != null)
                    this._disabledImage.setVisible(true);
            } else {
                if (this._normalImage != null)
                    this._normalImage.setVisible(true);
                if (this._selectedImage != null)
                    this._selectedImage.setVisible(false);
                if (this._disabledImage != null)
                    this._disabledImage.setVisible(false);
            }
        }
	}
	
	public static function create(normalSprite : CCSprite, ?selectedSprite : CCSprite, ?three : CCSprite, ?four : Void -> Void, ?five : CCNode) {
		var ret = new CCMenuItemSprite();
		ret.initWithNormalSprite(normalSprite, selectedSprite, three, four, five);
		return ret;
	}
}

class CCMenuItemImage extends CCMenuItemSprite {
	private function new() {
		super();
	}
	
	public function setNormalSpriteFrame(frame : CCSpriteFrame) {
		this.setNormalImage(CCSprite.createWithSpriteFrame(frame));
	}
	
	public function setSelectedSpriteFrame(frame : CCSpriteFrame) {
        this.setSelectedImage(CCSprite.createWithSpriteFrame(frame));
    }
	
	public function setDisabledSpriteFrame(frame : CCSpriteFrame) {
		this.setDisabledImage(CCSprite.createWithSpriteFrame(frame));
	}
	
	public function initWithNormalImage(normalImage : CCSpriteFrame, selectedImage : CCSpriteFrame, disabledImage : CCSpriteFrame, selector : Void -> Void, target : CCNode) : Bool{
		var normalSprite : CCSprite = null;
		var selectedSprite : CCSprite = null;
		var disabledSprite : CCSprite = null;
		
		if (normalImage != null) {
            normalSprite = CCSprite.createWithSpriteFrame(normalImage);
        }
        if (selectedImage != null) {
            selectedSprite = CCSprite.createWithSpriteFrame(selectedImage);
        }
        if (disabledImage != null) {
            disabledSprite = CCSprite.createWithSpriteFrame(disabledImage);
        }
        return this.initWithNormalSprite(normalSprite, selectedSprite, disabledSprite, selector, target);
	}
	
	public static function create(normalImage : CCSpriteFrame, selectedImage : CCSpriteFrame, ?three : CCSpriteFrame, ?four : Void -> Void, ?five : CCNode) : CCMenuItem {
		var ret : CCMenuItemImage = new CCMenuItemImage();
		if (ret.initWithNormalImage(normalImage, selectedImage, three, four, five)) {
			return ret;
		}
		return null;
	}
}