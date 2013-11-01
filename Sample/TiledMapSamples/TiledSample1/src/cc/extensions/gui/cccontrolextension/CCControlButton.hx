package cc.extensions.gui.cccontrolextension;
import cc.action.CCAction;
import cc.basenodes.CCNode;
import cc.cocoa.CCGeometry;
import cc.platform.CCTypes;
import cc.spritenodes.CCSprite;
import cc.touchdispatcher.CCPointer;
import flambe.math.Point;
import cc.labelnodes.CCLabelBMFont;
import flambe.math.Rectangle;
import cc.platform.CCCommon;
import cc.action.CCActionInterval;
import cc.action.CCActionInstant;
/**
 * ...
 * @author Ang Li
 */
class CCControlButton extends CCControl
{
	var _doesAdjustBackgroundImage : Bool = false;
    var _zoomOnTouchDown : Bool = false;
    var _preferredSize : CCSize;
    var _labelAnchorPoint : Point;
    var _currentTitle : String;
    var _currentTitleColor : CCColor3B;
    var _titleLabel : CCLabelBMFont;
    var _backgroundSprite : CCScale9Sprite;
    var _opacity : Int = 0;
    var _isPushed : Bool = false;
    var _titleDispatchTable : Map<Int, String>;
   // var _titleColorDispatchTable:null;
    var _titleLabelDispatchTable : Map<Int, CCNode>;
    var _backgroundSpriteDispatchTable : Map<Int, CCScale9Sprite>;
    var _parentInited : Bool = false;

    var _marginV : Float = 0;
    var _marginH : Float = 0;

    public function new() {
        super();
        this._preferredSize = new CCSize(0, 0);
        this._labelAnchorPoint = new Point(0, 0);
        this._currentTitle = "";
        this._currentTitleColor = CCTypes.white();
        this._titleDispatchTable = new Map<Int, String>;
        //this._titleColorDispatchTable = {};
       this._titleLabelDispatchTable = new Map<Int, CCNode>;
        //this._backgroundSpriteDispatchTable = {};
    }

    override public function init():Bool 
	{
		//return this.initWithLabelAndBackgroundSprite(cc.LabelTTF.create("", "Arial", 12), cc.Scale9Sprite.create());
		return true;
	}

    override public function needsLayout()
	{
		if (!this._parentInited) {
            return;
        }
		
        // Hide the background and the label
        if(this._titleLabel != null)
            this._titleLabel.setVisible(false);
        if(this._backgroundSprite != null)
            this._backgroundSprite.setVisible(false);

        // Update anchor of all labels
        this.setLabelAnchorPoint(this._labelAnchorPoint);

        // Update the label to match with the current state
        //CC_SAFE_RELEASE(this._currentTitle)
        var locState = this._state;

        this._currentTitle = this.getTitleForState(locState);
        this._currentTitleColor = this.getTitleColorForState(locState);
        this._titleLabel = this.getTitleLabelForState(locState);

        var label : CCLabelBMFont = this._titleLabel;
        if (label != null)
            label.setString(this._currentTitle);
        //if (label && label.RGBAProtocol)
            //label.setColor(this._currentTitleColor);

        var locContentSize : CCSize = this.getContentSize();
        if(label != null)
            label.setPosition(locContentSize.width / 2, locContentSize.height / 2);

        // Update the background sprite
        this._backgroundSprite = this.getBackgroundSpriteForState(locState);
        var locBackgroundSprite : CCScale9Sprite = this._backgroundSprite;
        if(locBackgroundSprite != null)
            locBackgroundSprite.setPosition(locContentSize.width / 2, locContentSize.height / 2);

        // Get the title label size
        var titleLabelSize : CCSize = (label != null) ? label.getBoundingBox().size : new CCSize(0, 0);

        // Adjust the background image if necessary
        if (this._doesAdjustBackgroundImage) {
            // Add the margins
            if(locBackgroundSprite != null)
                locBackgroundSprite.setContentSize(new CCSize(titleLabelSize.width + this._marginH * 2, titleLabelSize.height + this._marginV * 2));
        } else {
            //TODO: should this also have margins if one of the preferred sizes is relaxed?
            if(locBackgroundSprite != null){
                var preferredSize : CCSize = locBackgroundSprite.getPreferredSize();
                preferredSize = new CCSize(preferredSize.width, preferredSize.height);
                if (preferredSize.width <= 0)
                    preferredSize.width = titleLabelSize.width;
                if (preferredSize.height <= 0)
                    preferredSize.height = titleLabelSize.height;

                locBackgroundSprite.setContentSize(preferredSize);
            }
        }

        // Set the content size
        var rectTitle = (label != null)? label.getBoundingBox() : new Rectangle(0,0,0,0);
        var rectBackground = (locBackgroundSprite != null) ? locBackgroundSprite.getBoundingBox() : new Rectangle(0,0,0,0);
        var maxRect = CCGeometry.rectUnion(rectTitle, rectBackground);
        this.setContentSize(new CCSize(maxRect.width, maxRect.height));
        locContentSize = this.getContentSize();
        if(label != null){
            label.setPosition(locContentSize.width / 2, locContentSize.height / 2);
            label.setVisible(true);
        }
        if(locBackgroundSprite != null){
            locBackgroundSprite.setPosition(locContentSize.width / 2, locContentSize.height / 2);
            locBackgroundSprite.setVisible(true);
        }
	}

    public function initWithLabelAndBackgroundSprite(label : CCLabelBMFont, backgroundSprite : CCScale9Sprite) {
        if (super.init()) {
            CCCommon.assert(label != null, "node must not be nil");
            CCCommon.assert(label != null || backgroundSprite != null, "");

            this._parentInited = true;

            // Initialize the button state tables
            //this._titleDispatchTable = {};
            //this._titleColorDispatchTable = {};
            //this._titleLabelDispatchTable = {};
            //this._backgroundSpriteDispatchTable = {};

            this.setTouchEnabled(true);
            this._isPushed = false;
            this._zoomOnTouchDown = true;

            this._currentTitle = null;

            // Adjust the background image by default
            this.setAdjustBackgroundImage(true);
            this.setPreferredSize(CCSize(0,0));

            // Zooming button by default
            this._zoomOnTouchDown = true;

            // Set the default anchor point
            this.ignoreAnchorPointForPosition(false);
            this.setAnchorPoint(new Point(0.5, 0.5));

            // Set the nodes
            this._titleLabel = label;
            this._backgroundSprite = backgroundSprite;

            // Set the default color and opacity
            this.setOpacity(255);
            this.setOpacityModifyRGB(true);

            // Initialize the dispatch table
            var tempString : String = label.getString();
            //tempString.autorelease();
            this.setTitleForState(tempString, CCControl.CONTROL_STATE_NORMAL);
            //this.setTitleColorForState(label.getColor(), cc.CONTROL_STATE_NORMAL);
            this.setTitleLabelForState(label, CONTROL_STATE_NORMAL);
            this.setBackgroundSpriteForState(backgroundSprite, CONTROL_STATE_NORMAL);

            this._state = CONTROL_STATE_NORMAL;

            //default margins
            this._marginH = 24;
            this._marginV = 12;

            this._labelAnchorPoint = new Point(0.5, 0.5);

            this.setPreferredSize(new CCSize(0,0));

            // Layout update
            this.needsLayout();
            return true;
        }//couldn't init the CCControl
        else
            return false;
    }

    public function initWithTitleAndFontNameAndFontSize(title : String, fontName : String , ?fontSize : Int) {
		//Only support Bitmap Font 
		//Todo CCLabelTTF
		var label : CCLabelBMFont = CCLabelBMFont.create(title, fontName);
        //var label = cc.LabelTTF.create(title, fontName, fontSize);
        return this.initWithLabelAndBackgroundSprite(label, CCScale9Sprite.create());
    }

    public function initWithBackgroundSprite (sprite : CCSprite) {
        var label : CCLabelBMFont = CCLabelBMFont.create("");
        return this.initWithLabelAndBackgroundSprite(label, sprite);
    }

    /**
     * Adjust the background image. YES by default. If the property is set to NO, the background will use the prefered size of the background image.
     * @return {Boolean}
     */
	public function doesAdjustBackgroundImage() : Bool {
        return this._doesAdjustBackgroundImage;
    }

    public function setAdjustBackgroundImage(adjustBackgroundImage : Bool) {
        this._doesAdjustBackgroundImage = adjustBackgroundImage;
        this.needsLayout();
    }

    /** Adjust the button zooming on touchdown. Default value is YES. */
    public function getZoomOnTouchDown() : Bool{
        return this._zoomOnTouchDown;
    }

    public function setZoomOnTouchDown(zoomOnTouchDown : Bool) {
        this._zoomOnTouchDown = zoomOnTouchDown;
    }

    /** The prefered size of the button, if label is larger it will be expanded. */
    public function getPreferredSize() : CCSize {
        return this._preferredSize;
    }

    public function setPreferredSize(size : CCSize) {
        if (size.width == 0 && size.height == 0) {
            this._doesAdjustBackgroundImage = true;
        } else {
            this._doesAdjustBackgroundImage = false;
            var locTable = this._backgroundSpriteDispatchTable;
            for (itemKey in locTable)
                locTable[itemKey].setPreferredSize(size);
        }
        this._preferredSize = size;
        this.needsLayout();
    }

    public function getLabelAnchorPoint() : Point {
        return this._labelAnchorPoint;
    }
	
    public function setLabelAnchorPoint(labelAnchorPoint : Point) {
        this._labelAnchorPoint = labelAnchorPoint;
        if(this._titleLabel != null)
            this._titleLabel.setAnchorPoint(labelAnchorPoint);
    }

    /**
     * The current title that is displayed on the button.
     * @return {string}
     */
	public function _getCurrentTitle() : String {
        return this._currentTitle;
    }

    /** The current color used to display the title. */
    //_getCurrentTitleColor:function () {
        //return this._currentTitleColor;
    //},

    /* Override setter to affect a background sprite too */
    public function getOpacity() : Int {
        return this._opacity;
    }

    public function setOpacity(opacity) {
        // XXX fixed me if not correct
		super.setOpacity(opacity);
        /*this._opacity = opacity;
        var controlChildren = this.getChildren();
        for (var i = 0; i < controlChildren.length; i++) {
            var selChild = controlChildren[i];
            if (selChild && selChild.RGBAProtocol)
                selChild.setOpacity(opacity);
        }*/
        var locTable = this._backgroundSpriteDispatchTable;
        for (var itemKey in locTable)
            locTable[itemKey].setOpacity(opacity);
    }

    //public function setColor(color){
        //cc.Control.prototype.setColor.call(this,color);
        //var locTable = this._backgroundSpriteDispatchTable;
        //for(var key in locTable)
            //locTable[key].setColor(color);
    //}

    //getColor:function(){
      //return this._realColor;
    //},


    /** Flag to know if the button is currently pushed.  */
    public function isPushed() : Bool {
        return this._isPushed;
    }

    /* Define the button margin for Top/Bottom edge */
    pubic function _getVerticalMargin() : Float {
        return this._marginV;
    }
	
    /* Define the button margin for Left/Right edge */
    public function _getHorizontalOrigin() : FLoat {
        return this._marginH;
    }

    /**
     * set the margins at once (so we only have to do one call of needsLayout)
     * @param {Number} marginH
     * @param {Number} marginV
     */
    public function setMargins : (marginH : Float, marginV : Float) {
        this._marginV = marginV;
        this._marginH = marginH;
        this.needsLayout();
    }

    public function setEnabled(enabled : Bool) {
        //cc.Control.prototype.setEnabled.call(this, enabled);
		super.setEnabled(enabled);
        this.needsLayout();
    }
	
    public function setSelected(enabled : Bool) {
        //cc.Control.prototype.setSelected.call(this, enabled);
		super.setSelected(enabled);
        this.needsLayout();
    }

    public function setHighlighted(enabled : Bool) {
        this._state = enabled ? CONTROL_STATE_HIGHLIGHTED : CONTROL_STATE_NORMAL;

		super.setHighlighted(enabled);
        //cc.Control.prototype.setHighlighted.call(this, enabled);
        var action : CCAction = this.getActionByTag(CONTROL_ZOOM_ACTION_TAG);
        if (action)
            this.stopAction(action);

        this.needsLayout();
        if (this._zoomOnTouchDown) {
            var scaleValue : Float = (this.isHighlighted() && this.isEnabled() && !this.isSelected()) ? 1.1 : 1.0;
            var zoomAction = CCScaleTo.create(0.05, scaleValue);
            zoomAction.setTag(cc.CONTROL_ZOOM_ACTION_TAG);
            this.runAction(zoomAction);
        }
    }
    override public function onPointerDown(event:CCPointer):Bool 
	{
		if (!this.isTouchInside(event) || !this.isEnabled()|| !this.isVisible()||!this.hasVisibleParents())
            return false;

        this._isPushed = true;
        this.setHighlighted(true);
        this.sendActionsForControlEvents(CONTROL_EVENT_TOUCH_DOWN);
        return true;
	}

	override public function onPointerMoved(event:CCPointer):Bool 
	{
		if (!this._enabled || !this._isPushed || this._selected) {
            if (this._highlighted)
                this.setHighlighted(false);
            return;
        }

        var isTouchMoveInside = this.isTouchInside(event);
        if (isTouchMoveInside && !this._highlighted) {
            this.setHighlighted(true);
            this.sendActionsForControlEvents(CONTROL_EVENT_TOUCH_DRAG_ENTER);
        } else if (isTouchMoveInside && this._highlighted) {
            this.sendActionsForControlEvents(CONTROL_EVENT_TOUCH_DRAG_INSIDE);
        } else if (!isTouchMoveInside && this._highlighted) {
            this.setHighlighted(false);
            this.sendActionsForControlEvents(CONTROL_EVENT_TOUCH_DRAG_EXIT);
        } else if (!isTouchMoveInside && !this._highlighted) {
            this.sendActionsForControlEvents(CONTROL_EVENT_TOUCH_DRAG_OUTSIDE);
        }
	}
    
	override public function onPointerUp(event:CCPointer):Bool 
	{
		this._isPushed = false;
        this.setHighlighted(false);

        if (this.isTouchInside(event)) {
            this.sendActionsForControlEvents(cc.CONTROL_EVENT_TOUCH_UP_INSIDE);
        } else {
            this.sendActionsForControlEvents(cc.CONTROL_EVENT_TOUCH_UP_OUTSIDE);
        }
	}


    //onTouchCancelled:function (touch, event) {
        //this._isPushed = false;
        //this.setHighlighted(false);
        //this.sendActionsForControlEvents(cc.CONTROL_EVENT_TOUCH_CANCEL);
    //},

    /**
     * Returns the title used for a state.
     *
     * @param {Number} state The state that uses the title. Possible values are described in "CCControlState".
     * @return {string} The title for the specified state.
     */
    public function getTitleForState:function (state : Int) : String {
        var locTable : Map<Int, String>  = this._titleDispatchTable;
        if (locTable != null) {
			if (locTable[state] != null)
                return locTable[state];
            return locTable[CONTROL_STATE_NORMAL];
        }
        return "";
    }

    /**
     * <p>
     * Sets the title string to use for the specified state.                                                  <br/>
     * If a property is not specified for a state, the default is to use the CCButtonStateNormal value.
     * </p>
     * @param {string} title The title string to use for the specified state.
     * @param {Number} state The state that uses the specified title. The values are described in "CCControlState".
     */
    public function setTitleForState(title : String, state : Int) {
        this._titleDispatchTable[state] = (title != null) ? title : "";

        // If the current state if equal to the given state we update the layout
        if (this.getState() == state)
            this.needsLayout();
    }

    /**
     * Returns the title color used for a state.
     *
     * @param {Number} state The state that uses the specified color. The values are described in "CCControlState".
     * @return {cc.Color3B} The color of the title for the specified state.
     */
    //public function getTitleColorForState: function (state) {
        //var colorObject = this._titleColorDispatchTable[state];
        //if (colorObject)
            //return colorObject;
        //colorObject = this._titleColorDispatchTable[cc.CONTROL_STATE_NORMAL];
        //if (colorObject)
            //return colorObject;
        //return cc.white();
    //}

    /**
     * Sets the color of the title to use for the specified state.
     *
     * @param {cc.Color3B} color The color of the title to use for the specified state.
     * @param {Number} state The state that uses the specified color. The values are described in "CCControlState".
     */
    //setTitleColorForState:function (color, state) {
        //ccColor3B* colorValue=&color;
        //this._titleColorDispatchTable[state] = color;
//
        // If the current state if equal to the given state we update the layout
        //if (this.getState() == state)
            //this.needsLayout();
    //},

    /**
     * Returns the title label used for a state.
     *
     * @param state The state that uses the title label. Possible values are described in "CCControlState".
     * @return {cc.Node} the title label used for a state.
     */
    public function getTitleLabelForState:function (state : Int) : CCNode {
        var locTable = this._titleLabelDispatchTable;
        if (locTable.exists(state) && locTable[state] != null)
            return locTable[state];

        return locTable[cc.CONTROL_STATE_NORMAL];
    }

    /**
     * <p>Sets the title label to use for the specified state.                                          <br/>
     * If a property is not specified for a state, the default is to use the CCButtonStateNormal value. </p>
     *
     * @param {cc.Node} titleLabel The title label to use for the specified state.
     * @param {Number} state The state that uses the specified title. The values are described in "CCControlState".
     */
    public function setTitleLabelForState:function (titleLabel : CCNode, state : Int) {
        var locTable : Map<Int, CCNode> = this._titleLabelDispatchTable;
        if (locTable.exists(state)) {
            var previousLabel = locTable[state];
            if (previousLabel != null)
                this.removeChild(previousLabel, true);
        }

        locTable[state] = titleLabel;
        titleLabel.setVisible(false);
        titleLabel.setAnchorPoint(new Point(0.5, 0.5));
        this.addChild(titleLabel, 1);

        // If the current state if equal to the given state we update the layout
        if (this.getState() == state)
            this.needsLayout();
    }

    /**
     * Sets the title TTF filename to use for the specified state.
     * @param {string} fntFile
     * @param {Number} state
     */
    //public function setTitleTTFForState:function (fntFile, state) {
        //var title = this.getTitleForState(state);
        //if (!title)
            //title = "";
        //this.setTitleLabelForState(cc.LabelTTF.create(title, fntFile, 12), state);
    //}

    /**
     * return the title TTF filename to use for the specified state.
     * @param {Number} state
     * @returns {string}
     */
    //getTitleTTFForState:function (state) {
        //var labelTTF = this.getTitleLabelForState(state);
        //if ((labelTTF != null) && (labelTTF instanceof  cc.LabelTTF)) {
            //return labelTTF.getFontName();
        //} else {
            //return "";
        //}
    //},

    /**
     * @param {Number} size
     * @param {Number} state
     */
    //setTitleTTFSizeForState:function (size, state) {
        //var labelTTF = this.getTitleLabelForState(state);
        //if ((labelTTF != null) && (labelTTF instanceof  cc.LabelTTF)) {
            //labelTTF.setFontSize(size);
        //}
    //}

    /**
     * return the font size of LabelTTF to use for the specified state
     * @param {Number} state
     * @returns {Number}
     */
    //getTitleTTFSizeForState:function (state) {
        //var labelTTF = this.getTitleLabelForState(state);
        //if ((labelTTF != null) && (labelTTF instanceof  cc.LabelTTF)) {
            //return labelTTF.getFontSize();
        //}
        //return 0;
    //},

    /**
     * Sets the font of the label, changes the label to a CCLabelBMFont if necessary.
     * @param {string} fntFile The name of the font to change to
     * @param {Number} state The state that uses the specified fntFile. The values are described in "CCControlState".
     */
	public function setTitleBMFontForState(fntFile : String, state : Int) {
        var title : String = this.getTitleForState(state);
        if (title == null)
            title = "";
        this.setTitleLabelForState(CCLabelBMFont.create(title, fntFile), state);
    }

    public function getTitleBMFontForState(state : Int) {
        var labelBMFont = this.getTitleLabelForState(state);
        if ((labelBMFont != null) && (labelBMFont instanceof  cc.LabelBMFont)) {
            return labelBMFont.getFntFile();
        }
        return "";
    }

    /**
     * Returns the background sprite used for a state.
     *
     * @param {Number} state The state that uses the background sprite. Possible values are described in "CCControlState".
     */
    public function getBackgroundSpriteForState(state : Int) : CCScale9Sprite{
        var locTable : Map<Int, CCScale9Sprite> = this._backgroundSpriteDispatchTable;
        if (locTable.exists(state) && locTable[state] != null) {
            return locTable[state];
        }
        return locTable[CONTROL_STATE_NORMAL];
    }

    /**
     * Sets the background sprite to use for the specified button state.
     *
     * @param {Scale9Sprite} sprite The background sprite to use for the specified state.
     * @param {Number} state The state that uses the specified image. The values are described in "CCControlState".
     */
    public function setBackgroundSpriteForState(sprite : CCScale9Sprite, state : Int) {
        var locTable : Map<Int, CCScale9Sprite> = this._backgroundSpriteDispatchTable;
        if (locTable.exists(state)) {
            var previousSprite : CCScale9Sprite = locTable[state];
            if (previousSprite != null)
                this.removeChild(previousSprite, true);
        }

        locTable[state] : CCScale9Sprite = sprite;
        sprite.setVisible(false);
        sprite.setAnchorPoint(new Point(0.5, 0.5));
        this.addChild(sprite);

        var locPreferredSize : CCSize = this._preferredSize;
        if (locPreferredSize.width !== 0 || locPreferredSize.height !== 0) {
            sprite.setPreferredSize(locPreferredSize);
        }

        // If the current state if equal to the given state we update the layout
        if (this._state === state)
            this.needsLayout();
    }

    /**
     * Sets the background spriteFrame to use for the specified button state.
     *
     * @param {SpriteFrame} spriteFrame The background spriteFrame to use for the specified state.
     * @param {Number} state The state that uses the specified image. The values are described in "CCControlState".
     */
    //setBackgroundSpriteFrameForState (spriteFrame, state) {
        //var sprite = cc.Scale9Sprite.createWithSpriteFrame(spriteFrame);
        //this.setBackgroundSpriteForState(sprite, state);
    //}
	public static function create(?label : CCLabelBMFont, ?backgroundSprite : CCScale9Sprite) : CCControlButton {
		var ret : CCControlButton = null;
		if (label == null && backgroundSprite == null) {
			ret = new CCControlButton();
			if (ret != null && ret.init()) {
				return ret;
			}
			return null;
		} else if (label == null && backgroundSprite != null) {
			ret = new CCControlButton();
			ret.initWithBackgroundSprite(backgroundSprite);
			
		} else if (label != null && backgroundSprite != null) {
			ret = new CCControlButton();
			ret.initWithLabelAndBackgroundSprite(label, backgroundSprite);
		}
	}
}