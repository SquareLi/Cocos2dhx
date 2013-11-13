package cc.layersscenestransitionsnodes;

/**
 * ...
 * @author
 */
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