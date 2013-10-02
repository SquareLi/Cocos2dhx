package cc.extensions.gui.cccontrolextension;
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.CCDirector;

import cc.spritenodes.CCSprite;
import cc.texture.CCTexture2D;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.platform.CCTypes;
import cc.cocoa.CCGeometry;
import cc.platform.CCCommon;
import cc.basenodes.CCAffineTransform;
import flash.automation.StageCaptureEvent;
import cc.spritenodes.CCSpriteBatchNode;
/**
 * ...
 * @author Ang Li
 */
class CCScale9Sprite extends CCNode
{
	public static inline var POSITIONS_CENTRE : Int = 0;
	public static inline var POSITIONS_TOP : Int = 1;
	public static inline var POSITIONS_LEFT : Int = 2;
	public static inline var POSITIONS_RIGHT : Int = 3;
	public static inline var POSITIONS_BOTTOM : Int = 4;
	public static inline var POSITIONS_TOPRIGHT : Int = 5;
	public static inline var POSITIONS_TOPLEFT : Int = 6;
	public static inline var POSITIONS_BOTTOMRIGHT : Int = 7;
	public static inline var POSITIONS_BOTTOMLEFT : Int = 8;
	
	var RGBAProtocol : Bool = true;

	var _spriteRect : Rectangle;
	var _capInsetsInternal : Rectangle;
	var _positionsAreDirty : Bool = false;

	var _scale9Image : CCSpriteBatchNode;
	var _topLeft : CCSprite;
	var _top : CCSprite;
	var _topRight : CCSprite;
	var _left : CCSprite;
	var _centre : CCSprite;
	var _right :CCSprite;
	var _bottomLeft : CCSprite;
	var _bottom : CCSprite;
	var _bottomRight : CCSprite;

	var _colorUnmodified : CCColor3B;
	var _opacityModifyRGB : Bool = false;

	var _originalSize : CCSize;
	var _preferredSize : CCSize;
	var _opacity : Int = 0;
	var _color : CCColor3B;
	var _capInsets : Rectangle;
	var _insetLeft : Float = 0;
	var _insetTop : Float = 0;
	var _insetRight : Float = 0;
	var _insetBottom : Float = 0;

	var _spritesGenerated : Bool = false;
	var _spriteFrameRotated : Bool = false;
	
	
	public function new() 
	{
		super();
        this._spriteRect = CCGeometry.rectZero();
        this._capInsetsInternal = CCGeometry.rectZero();

        this._colorUnmodified = CCTypes.white();
        this._originalSize = new CCSize(0, 0);
        this._preferredSize = new CCSize(0, 0);
        this._color = CCTypes.white();
        this._opacity = 255;
        this._capInsets = CCGeometry.rectZero();
	}
	
	private function _updateCapInset() {
		var insets : Rectangle;
		var locInsetLeft : Float = this._insetLeft;
		var locInsetTop : Float = this._insetTop;
		var locInsetRight : Float = this._insetRight;
		var locSpriteRect : Rectangle = this._spriteRect;
		var locInsetBottom : Float = this._insetBottom;
		
		if (locInsetLeft == 0 && locInsetTop == 0 && locInsetRight == 0 && locInsetBottom == 0) {
            insets = CCGeometry.rectZero();
        } else {
            insets = this._spriteFrameRotated ? new Rectangle(locInsetBottom, locInsetLeft,
                locSpriteRect.width - locInsetRight - locInsetLeft,
                locSpriteRect.height - locInsetTop - locInsetBottom) :
                new Rectangle(locInsetLeft, locInsetTop,
                    locSpriteRect.width - locInsetLeft - locInsetRight,
                    locSpriteRect.height - locInsetTop - locInsetBottom);
        }
        this.setCapInsets(insets);
	}
	
	private function _updatePositions() {
        // Check that instances are non-NULL
        if (!((this._topLeft != null) && (this._topRight != null) && (this._bottomRight != null) &&
            (this._bottomLeft != null) && (this._centre != null))) {
            // if any of the above sprites are NULL, return
            return;
        }

        var size : CCSize = this._contentSize;
        var locTopLeft : CCSprite = this._topLeft; 
		var locTopRight : CCSprite = this._topRight;
		var locBottomRight : CCSprite = this._bottomRight;
        var locCenter : CCSprite = this._centre;
		var locCenterContentSize : CCSize = this._centre.getContentSize();

        var sizableWidth : Float = size.width - locTopLeft.getContentSize().width - locTopRight.getContentSize().width;
        var sizableHeight : Float = size.height - locTopLeft.getContentSize().height - locBottomRight.getContentSize().height;
        var horizontalScale : Float = sizableWidth / locCenterContentSize.width;
        var verticalScale : Float = sizableHeight / locCenterContentSize.height;
        var rescaledWidth : Float = locCenterContentSize.width * horizontalScale;
        var rescaledHeight : Float = locCenterContentSize.height * verticalScale;

        var locBottomLeft : CCSprite = this._bottomLeft;
        var leftWidth : Float = locBottomLeft.getContentSize().width;
        var bottomHeight : Float = locBottomLeft.getContentSize().height;

        //if(!cc.Browser.supportWebGL) {
            //browser is in canvas mode, need to manually control rounding to prevent overlapping pixels
            //var roundedRescaledWidth = Math.round(rescaledWidth);
            //if(rescaledWidth != roundedRescaledWidth) {
                //rescaledWidth = roundedRescaledWidth;
                //horizontalScale = rescaledWidth/locCenterContentSize.width;
            //}
            //var roundedRescaledHeight = Math.round(rescaledHeight);
            //if(rescaledHeight != roundedRescaledHeight) {
                //rescaledHeight = roundedRescaledHeight;
                //verticalScale = rescaledHeight/locCenterContentSize.height;
            //}
        //}
        locCenter.setScaleX(horizontalScale);
        locCenter.setScaleY(verticalScale);

        var locLeft : CCSprite = this._left;
		var locRight : CCSprite = this._right;
		var locTop : CCSprite = this._top; 
		var locBottom : CCSprite = this._bottom;
        var tempAP : Point = new Point(0, 0);
        locBottomLeft.setAnchorPoint(tempAP);
        locBottomRight.setAnchorPoint(tempAP);
        locTopLeft.setAnchorPoint(tempAP);
        locTopRight.setAnchorPoint(tempAP);
        locLeft.setAnchorPoint(tempAP);
        locRight.setAnchorPoint(tempAP);
        locTop.setAnchorPoint(tempAP);
        locBottom.setAnchorPoint(tempAP);
        locCenter.setAnchorPoint(tempAP);

        // Position corners
        locBottomLeft.setPosition(0, bottomHeight + rescaledHeight);
        locBottomRight.setPosition(leftWidth + rescaledWidth, bottomHeight + rescaledHeight);
        locTopLeft.setPosition(0, 0);
        locTopRight.setPosition(leftWidth + rescaledWidth, 0);

        // Scale and position borders
        locLeft.setPosition(0, bottomHeight);
        locLeft.setScaleY(verticalScale);
        locRight.setPosition(leftWidth + rescaledWidth, bottomHeight);
        locRight.setScaleY(verticalScale);
        locBottom.setPosition(leftWidth, bottomHeight + rescaledHeight);
        locBottom.setScaleX(horizontalScale);
        locTop.setPosition(leftWidth, 0);
        locTop.setScaleX(horizontalScale);

        // Position centre
        locCenter.setPosition(leftWidth, bottomHeight);
    }
	
	/** Original sprite's size. */
    public function getOriginalSize() : CCSize{
        return this._originalSize;
    }

    //if the preferredSize component is given as -1, it is ignored
    public function getPreferredSize() : CCSize{
        return this._preferredSize;
    }
	
    public function setPreferredSize(preferredSize : CCSize) {
        this.setContentSize(preferredSize);
        this._preferredSize = preferredSize;
    }

    /** Opacity: conforms to CCRGBAProtocol protocol */
    override public function getOpacity() : Int {
        return this._opacity;
    }
	
    override public function setOpacity(opacity : Int) {
        this._opacity = opacity;
        var scaleChildren : Array<CCNode> = this._scale9Image.getChildren();
        for (i in 0...scaleChildren.length) {
            var selChild : CCScale9Sprite = cast (scaleChildren[i], CCScale9Sprite);
			//if (selChild && selChild.RGBAProtocol)
            if (selChild != null)
                selChild.setOpacity(opacity);
        }
    }

    /** Color: conforms to CCRGBAProtocol protocol */
    public function getColor() : CCColor3B {
        return this._color;
    }
	
    public function setColor(color : CCColor3B) {
        //this._color = color;
        //var scaleChildren = this._scale9Image.getChildren();
        //for (var i = 0; i < scaleChildren.length; i++) {
            //var selChild = scaleChildren[i];
            //if (selChild && selChild.RGBAProtocol)
                //selChild.setColor(color);
        //}
    }

    public function getCapInsets() : Rectangle{
        return this._capInsets;
    }

    public function setCapInsets(capInsets : Rectangle) {
        var contentSize : CCSize = this._contentSize;
        contentSize = new CCSize(contentSize.width,contentSize.height);
        this.updateWithBatchNode(this._scale9Image, this._spriteRect, this._spriteFrameRotated, capInsets);
        this.setContentSize(contentSize);
    }

    /**
     * Gets the left side inset
     * @returns {number}
     */
	public function getInsetLeft(): Float{
        return this._insetLeft;
    }

    /**
     * Sets the left side inset
     * @param {Number} insetLeft
     */
    public function setInsetLeft(insetLeft : Float) {
        this._insetLeft = insetLeft;
        this._updateCapInset();
    }

    /**
     * Gets the top side inset
     * @returns {number}
     */
	public function getInsetTop() : Float {
        return this._insetTop;
    }

    /**
     * Sets the top side inset
     * @param {Number} insetTop
     */
    public function setInsetTop(insetTop : Float) {
        this._insetTop = insetTop;
        this._updateCapInset();
    }

    /**
     * Gets the right side inset
     * @returns {number}
     */
	public function getInsetRight() : Float {
        return this._insetRight;
    }
	
    /**
     * Sets the right side inset
     * @param {Number} insetRight
     */
    public function setInsetRight(insetRight : Float) {
        this._insetRight = insetRight;
        this._updateCapInset();
    }

    /**
     * Gets the bottom side inset
     * @returns {number}
     */
	public function getInsetBottom() : Float {
        return this._insetBottom;
    }
    /**
     * Sets the bottom side inset
     * @param {number} insetBottom
     */
    public function setInsetBottom(insetBottom : Float) {
        this._insetBottom = insetBottom;
        this._updateCapInset();
    }

    override public function setContentSize(size : CCSize) {
        super.setContentSize(size);
        //this.m_positionsAreDirty = true;
		this._updatePositions();
    }
	
	override public function visit()
	{
		//if (this.m_positionsAreDirty) {
            //this._updatePositions();
            //this.m_positionsAreDirty = false;
        //}

		super.visit();
	}

	override public function init():Bool 
	{
		super.init();
		this.entity.add(this.sprite);
		this.component = new CCComponent(this);
		this.entity.add(component);
		return this.initWithBatchNode(null, CCGeometry.rectZero(), false, CCGeometry.rectZero());
	}

    public function initWithBatchNode(batchNode : CCSpriteBatchNode, rect : Rectangle, rotated : Bool, capInsets : Rectangle) : Bool {
        //if (arguments.length === 3) {
            //capInsets = rotated;
            //rotated = false;
        //}

        if (batchNode != null) {
            this.updateWithBatchNode(batchNode, rect, rotated, capInsets);
        }
        this.setAnchorPoint(new Point(0.5, 0.5));
        //this.m_positionsAreDirty = true;
        return true;
    }
	
	/**
     * Initializes a 9-slice sprite with a texture file, a delimitation zone and
     * with the specified cap insets.
     * Once the sprite is created, you can then call its "setContentSize:" method
     * to resize the sprite will all it's 9-slice goodness intract.
     * It respects the anchorPoint too.
     *
     * @param file The name of the texture file.
     * @param rect The rectangle that describes the sub-part of the texture that
     * is the whole image. If the shape is the whole texture, set this to the
     * texture's full rect.
     * @param capInsets The values to use for the cap insets.
     */
    public function initWithFile(file : String , ?rect : Rectangle, ?capInsets : Rectangle) : Bool{
        //if (file instanceof cc.Rect) {
            //file = arguments[1];
            //capInsets = arguments[0];
            //rect = cc.RectZero();
        //} else {
            //rect = rect || cc.RectZero();
            //capInsets = capInsets || cc.RectZero();
        //}
		
		if (rect == null) {
			rect = CCGeometry.rectZero();
		}
		
		if (capInsets == null) {
			capInsets = CCGeometry.rectZero();
		}

        CCCommon.assert(file != null, "Invalid file for sprite");
        var batchnode : CCSpriteBatchNode = CCSpriteBatchNode.create(file, 9);
        return this.initWithBatchNode(batchnode, rect, false, capInsets);
    }

    /**
     * Initializes a 9-slice sprite with an sprite frame and with the specified
     * cap insets.
     * Once the sprite is created, you can then call its "setContentSize:" method
     * to resize the sprite will all it's 9-slice goodness intract.
     * It respects the anchorPoint too.
     *
     * @param spriteFrame The sprite frame object.
     * @param capInsets The values to use for the cap insets.
     */
    //initWithSpriteFrame: function (spriteFrame, capInsets) {
        //capInsets = capInsets || cc.RectZero();
//
        //cc.Assert(spriteFrame != null, "Sprite frame must not be nil");
        //var selTexture = spriteFrame.getTexture();
        //cc.Assert(selTexture != null, "Texture must be not nil");
//
        //if(!spriteFrame.textureLoaded()){
            //spriteFrame.addLoadedEventListener(function(sender){
                // the texture is rotated on Canvas render mode, so isRotated always is false.
                //var preferredSize = this._preferredSize;
                //preferredSize = cc.size(preferredSize.width, preferredSize.height);
                //this.updateWithBatchNode(this._scale9Image, sender.getRect(), cc.Browser.supportWebGL ? sender.isRotated() : false, this._capInsets);
                //this.setPreferredSize(preferredSize);
                //this.m_positionsAreDirty = true;
            //},this);
        //}
        //var batchNode = cc.SpriteBatchNode.createWithTexture(selTexture, 9);
        // the texture is rotated on Canvas render mode, so isRotated always is false.
        //return this.initWithBatchNode(batchNode, spriteFrame.getRect(), cc.Browser.supportWebGL ? spriteFrame.isRotated() : false, capInsets);
    //}

    /**
     * Initializes a 9-slice sprite with an sprite frame name and with the specified
     * cap insets.
     * Once the sprite is created, you can then call its "setContentSize:" method
     * to resize the sprite will all it's 9-slice goodness intract.
     * It respects the anchorPoint too.
     *
     * @param spriteFrameName The sprite frame name.
     * @param capInsets The values to use for the cap insets.
     */
    //initWithSpriteFrameName: function (spriteFrameName, capInsets) {
        //capInsets = capInsets || cc.RectZero();
//
        //cc.Assert(spriteFrameName != null, "Invalid spriteFrameName for sprite");
        //var frame = cc.SpriteFrameCache.getInstance().getSpriteFrame(spriteFrameName);
        //cc.Assert(frame != null, "cc.SpriteFrame must be non-NULL");
        //if (frame == null)
            //return false;
        //return this.initWithSpriteFrame(frame, capInsets);
    //},

    /**
     * Creates and returns a new sprite object with the specified cap insets.
     * You use this method to add cap insets to a sprite or to change the existing
     * cap insets of a sprite. In both cases, you get back a new image and the
     * original sprite remains untouched.
     *
     * @param capInsets The values to use for the cap insets.
     */
    public function resizableSpriteWithCapInsets(capInsets : Rectangle) : CCScale9Sprite {
        var pReturn = new CCScale9Sprite();
        if (pReturn != null && pReturn.initWithBatchNode(this._scale9Image, this._spriteRect, false, capInsets)) {
            return pReturn;
        }
        return null;
    }

    /** sets the premultipliedAlphaOpacity property.
     If set to NO then opacity will be applied as: glColor(R,G,B,opacity);
     If set to YES then oapcity will be applied as: glColor(opacity, opacity, opacity, opacity );
     Textures with premultiplied alpha will have this property by default on YES. Otherwise the default value is NO
     @since v0.8
     */
    //setOpacityModifyRGB: function (value) {
        //this._opacityModifyRGB = value;
        //var scaleChildren = this._scale9Image.getChildren();
        //if (scaleChildren) {
            //for (var i = 0, len = scaleChildren.length; i < len; i++)
                //scaleChildren[i].setOpacityModifyRGB(value);
        //}
    //}

    /** returns whether or not the opacity will be applied using glColor(R,G,B,opacity) or glColor(opacity, opacity, opacity, opacity);
     @since v0.8
     */
	public function isOpacityModifyRGB() : Bool{
        return this._opacityModifyRGB;
    }

    public function updateWithBatchNode(batchNode : CCSpriteBatchNode, rect : Rectangle, rotated : Bool , capInsets : Rectangle) {
        var opacity : Int = this.getOpacity();
        //var color = this.getColor();

        // Release old sprites
        this.removeAllChildren(true);

        if (this._scale9Image != batchNode)
            this._scale9Image = batchNode;

        var locScale9Image : CCSpriteBatchNode = this._scale9Image;
        locScale9Image.removeAllChildren(true);

        this._capInsets = capInsets;
        var selTexture : CCTexture2D = locScale9Image.getTexture();

        // If there is no given rect
		
        if (CCGeometry._rectEqualToZero(rect)) {
            // Get the texture size as original
            var textureSize = selTexture.getContentSize();
            rect = new Rectangle(0, 0, textureSize.width, textureSize.height);
        }

        // Set the given rect's size as original size
        this._spriteRect = rect;
        var rectSize : CCSize = new CCSize(rect.width, rect.height);
        this._originalSize.width = rectSize.width;
        this._originalSize.height = rectSize.height;
        var locPreferredSize : CCSize = this._preferredSize;
        if(locPreferredSize.width == 0 && locPreferredSize.height == 0){
            locPreferredSize.width = rectSize.width;
            locPreferredSize.height = rectSize.height;
        }

        var locCapInsetsInternal : Rectangle = this._capInsetsInternal;
        if(capInsets == null){
            locCapInsetsInternal.x = capInsets.x;
            locCapInsetsInternal.y = capInsets.y;
            locCapInsetsInternal.width = capInsets.width;
            locCapInsetsInternal.height = capInsets.height;
        }
        var w : Float = rectSize.width;
        var h : Float = rectSize.height;

        // If there is no specified center region
        if (CCGeometry._rectEqualToZero(locCapInsetsInternal)) {
            // CCLog("... cap insets not specified : using default cap insets ...");
            locCapInsetsInternal.x = w / 3;
            locCapInsetsInternal.y = h / 3;
            locCapInsetsInternal.width = w / 3;
            locCapInsetsInternal.height = h / 3;
        }

        var left_w : Float = locCapInsetsInternal.x;
        var center_w : Float = locCapInsetsInternal.width;
        var right_w : Float = w - (left_w + center_w);

        var top_h : Float = locCapInsetsInternal.y;
        var center_h : Float = locCapInsetsInternal.height;
        var bottom_h : Float = h - (top_h + center_h);

        // calculate rects
        // ... top row
        var x : Float = 0.0;
        var y : Float = 0.0;

        // top left
        var lefttopbounds : Rectangle = new Rectangle(x, y, left_w, top_h);

        // top center
        x += left_w;
        var centertopbounds : Rectangle = new Rectangle(x, y, center_w, top_h);

        // top right
        x += center_w;
        var righttopbounds : Rectangle= new Rectangle(x, y, right_w, top_h);

        // ... center row
        x = 0.0;
        y = 0.0;

        // center left
        y += top_h;
        var leftcenterbounds = new Rectangle(x, y, left_w, center_h);

        // center center
        x += left_w;
        var centerbounds = new Rectangle(x, y, center_w, center_h);

        // center right
        x += center_w;
        var rightcenterbounds = new Rectangle(x, y, right_w, center_h);

        // ... bottom row
        x = 0.0;
        y = 0.0;
        y += top_h;
        y += center_h;

        // bottom left
        var leftbottombounds = new Rectangle(x, y, left_w, bottom_h);

        // bottom center
        x += left_w;
        var centerbottombounds = new Rectangle(x, y, center_w, bottom_h);

        // bottom right
        x += center_w;
        var rightbottombounds = new Rectangle(x, y, right_w, bottom_h);

        var t = CCAffineTransform.AffineTransformMakeIdentity();
        if (!rotated) {
            // CCLog("!rotated");
            t = CCAffineTransform.AffineTransformTranslate(t, rect.x, rect.y);

            CCAffineTransform._RectApplyAffineTransformIn(centerbounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(rightbottombounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(leftbottombounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(righttopbounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(lefttopbounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(rightcenterbounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(leftcenterbounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(centerbottombounds, t);
            CCAffineTransform._RectApplyAffineTransformIn(centertopbounds, t);

            // Centre
            this._centre = new CCSprite();
            this._centre.initWithTexture(selTexture, centerbounds);
            locScale9Image.addChild(this._centre, 0, POSITIONS_CENTRE);

            // Top
            this._top = new CCSprite();
            this._top.initWithTexture(selTexture, centertopbounds);
            locScale9Image.addChild(this._top, 1, POSITIONS_TOP);

            // Bottom
            this._bottom = new CCSprite();
            this._bottom.initWithTexture(selTexture, centerbottombounds);
            locScale9Image.addChild(this._bottom, 1, POSITIONS_BOTTOM);

            // Left
            this._left = new CCSprite();
            this._left.initWithTexture(selTexture, leftcenterbounds);
            locScale9Image.addChild(this._left, 1, POSITIONS_LEFT);

            // Right
            this._right = new CCSprite();
            this._right.initWithTexture(selTexture, rightcenterbounds);
            locScale9Image.addChild(this._right, 1, POSITIONS_RIGHT);

            // Top left
            this._topLeft = new CCSprite();
            this._topLeft.initWithTexture(selTexture, lefttopbounds);
            locScale9Image.addChild(this._topLeft, 2, POSITIONS_TOPLEFT);

            // Top right
            this._topRight = new CCSprite();
            this._topRight.initWithTexture(selTexture, righttopbounds);
            locScale9Image.addChild(this._topRight, 2, POSITIONS_TOPRIGHT);

            // Bottom left
            this._bottomLeft = new CCSprite();
            this._bottomLeft.initWithTexture(selTexture, leftbottombounds);
            locScale9Image.addChild(this._bottomLeft, 2, POSITIONS_BOTTOMLEFT);

            // Bottom right
            this._bottomRight = new CCSprite();
            this._bottomRight.initWithTexture(selTexture, rightbottombounds);
            locScale9Image.addChild(this._bottomRight, 2, POSITIONS_BOTTOMRIGHT);
        } else {
            // set up transformation of coordinates
            // to handle the case where the sprite is stored rotated
            // in the spritesheet
            // CCLog("rotated");
            var rotatedcenterbounds = centerbounds;
            var rotatedrightbottombounds = rightbottombounds;
            var rotatedleftbottombounds = leftbottombounds;
            var rotatedrighttopbounds = righttopbounds;
            var rotatedlefttopbounds = lefttopbounds;
            var rotatedrightcenterbounds = rightcenterbounds;
            var rotatedleftcenterbounds = leftcenterbounds;
            var rotatedcenterbottombounds = centerbottombounds;
            var rotatedcentertopbounds = centertopbounds;

            t = CCAffineTransform.AffineTransformTranslate(t, rect.height + rect.x, rect.y);
            t = CCAffineTransform.AffineTransformRotate(t, 1.57079633);

            centerbounds = CCAffineTransform.RectApplyAffineTransform(centerbounds, t);
            rightbottombounds = CCAffineTransform.RectApplyAffineTransform(rightbottombounds, t);
            leftbottombounds = CCAffineTransform.RectApplyAffineTransform(leftbottombounds, t);
            righttopbounds = CCAffineTransform.RectApplyAffineTransform(righttopbounds, t);
            lefttopbounds = CCAffineTransform.RectApplyAffineTransform(lefttopbounds, t);
            rightcenterbounds = CCAffineTransform.RectApplyAffineTransform(rightcenterbounds, t);
            leftcenterbounds = CCAffineTransform.RectApplyAffineTransform(leftcenterbounds, t);
            centerbottombounds = CCAffineTransform.RectApplyAffineTransform(centerbottombounds, t);
            centertopbounds = CCAffineTransform.RectApplyAffineTransform(centertopbounds, t);

            rotatedcenterbounds.x = centerbounds.x;
            rotatedcenterbounds.y = centerbounds.y;

            rotatedrightbottombounds.x = rightbottombounds.x;
            rotatedrightbottombounds.y = rightbottombounds.y;

            rotatedleftbottombounds.x = leftbottombounds.x;
            rotatedleftbottombounds.y = leftbottombounds.y;

            rotatedrighttopbounds.x = righttopbounds.x;
            rotatedrighttopbounds.y = righttopbounds.y;

            rotatedlefttopbounds.x = lefttopbounds.x;
            rotatedlefttopbounds.y = lefttopbounds.y;

            rotatedrightcenterbounds.x = rightcenterbounds.x;
            rotatedrightcenterbounds.y = rightcenterbounds.y;

            rotatedleftcenterbounds.x = leftcenterbounds.x;
            rotatedleftcenterbounds.y = leftcenterbounds.y;

            rotatedcenterbottombounds.x = centerbottombounds.x;
            rotatedcenterbottombounds.y = centerbottombounds.y;

            rotatedcentertopbounds.x = centertopbounds.x;
            rotatedcentertopbounds.y = centertopbounds.y;

            // Centre
            this._centre = new CCSprite();
            this._centre.initWithTexture(selTexture, rotatedcenterbounds, true);
            locScale9Image.addChild(this._centre, 0, POSITIONS_CENTRE);

            // Top
            this._top = new CCSprite();
            this._top.initWithTexture(selTexture, rotatedcentertopbounds, true);
            locScale9Image.addChild(this._top, 1, POSITIONS_TOP);

            // Bottom
            this._bottom = new CCSprite();
            this._bottom.initWithTexture(selTexture, rotatedcenterbottombounds, true);
            locScale9Image.addChild(this._bottom, 1, POSITIONS_BOTTOM);

            // Left
            this._left = new CCSprite();
            this._left.initWithTexture(selTexture, rotatedleftcenterbounds, true);
            locScale9Image.addChild(this._left, 1, POSITIONS_LEFT);

            // Right
            this._right = new CCSprite();
            this._right.initWithTexture(selTexture, rotatedrightcenterbounds, true);
            locScale9Image.addChild(this._right, 1, POSITIONS_RIGHT);

            // Top left
            this._topLeft = new CCSprite();
            this._topLeft.initWithTexture(selTexture, rotatedlefttopbounds, true);
            locScale9Image.addChild(this._topLeft, 2, POSITIONS_TOPLEFT);

            // Top right
            this._topRight = new CCSprite();
            this._topRight.initWithTexture(selTexture, rotatedrighttopbounds, true);
            locScale9Image.addChild(this._topRight, 2,POSITIONS_TOPRIGHT);

            // Bottom left
            this._bottomLeft = new CCSprite();
            this._bottomLeft.initWithTexture(selTexture, rotatedleftbottombounds, true);
            locScale9Image.addChild(this._bottomLeft, 2, POSITIONS_BOTTOMLEFT);

            // Bottom right
            this._bottomRight = new CCSprite();
            this._bottomRight.initWithTexture(selTexture, rotatedrightbottombounds, true);
            locScale9Image.addChild(this._bottomRight, 2, POSITIONS_BOTTOMRIGHT);
        }

        this.setContentSize(new CCSize(rect.width, rect.height));
        this.addChild(locScale9Image);

        if (this._spritesGenerated) {
            // Restore color and opacity
            this.setOpacity(opacity);
            //if(color.r !== 255 || color.g !== 255 || color.b !== 255){
                //this.setColor(color);
            //}
        //}
		}
        this._spritesGenerated = true;
		
		_updatePositions();
        return true;
    }

    //public function setSpriteFrame (spriteFrame) {
        //var batchNode = cc.SpriteBatchNode.createWithTexture(spriteFrame.getTexture(), 9);
        // the texture is rotated on Canvas render mode, so isRotated always is false.
        //this.updateWithBatchNode(batchNode, spriteFrame.getRect(), cc.Browser.supportWebGL ? spriteFrame.isRotated() : false, cc.RectZero());
//
        // Reset insets
        //this._insetLeft = 0;
        //this._insetTop = 0;
        //this._insetRight = 0;
        //this._insetBottom = 0;
    //}

	public static function create(file : String, ?rect : Rectangle, ?capInsets : Rectangle) : CCScale9Sprite{
		var pReturn : CCScale9Sprite = new CCScale9Sprite();
		if (pReturn != null && pReturn.initWithFile(file, rect, capInsets)) {
			return pReturn;
		}
		
		return null;
		
	}
}