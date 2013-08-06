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

package cc.labelnodes;
import cc.CCComponent;
import cc.spritenodes.CCSprite;
import cc.cocoa.CCGeometry;
import cc.platform.CCTypes;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.util.Strings;
import cc.platform.CCCommon;
import cc.CCLoader;
/**
 * cc.LabelTTF is a subclass of cc.TextureNode that knows how to render text labels<br/>
 * All features from cc.TextureNode are valid in cc.LabelTTF<br/>
 * cc.LabelTTF objects are slow for js-binding on mobile devices.<br/>
 * Consider using cc.LabelAtlas or cc.LabelBMFont instead.<br/>
 * @class
 * @extends cc.Sprite
 */
class CCLabelTTF extends CCSprite
{
	var _dimensions : CCSize;
	var _hAlignment : Int;
	var _vAlignment : Int;
	var _fontName : String;
	var _fontSize : Float;
	var _string : String;
	var _fontStyleStr : String;
	var _colorStyleStr : String;
	
	var _font : Font;
	var _spriteText : TextSprite;
	
	public function new() 
	{
		super();
		_hAlignment = CCTypes.TEXT_ALIGNMENT_CENTER;
		_vAlignment = CCTypes.VERTICAL_TEXT_ALIGNMENT_TOP;
		this._opacityModifyRGB = false;
		this._fontStyleStr = "";
		this._colorStyleStr = "";
		this._opacity = 255;
		this._color = CCTypes.white();
		this._setColorStyleStr();
	}
	
	//override public function init():Bool 
	//{
		//this.initWithString([" ", this._fontName, this._fontSize]);
		//return super.init();
	//}
	
	override public function description() : String {
		return "<cc.LabelTTF | FontName =" + this._fontName + " FontSize = " + this._fontSize + ">";
	}
	
	public function setColor(color3 : CCColor3B) {
		if ((this._color.r == color3.r) && (this._color.g == color3.g) && (this._color.b == color3.b)) {
            return;
        }
		
		this._color = this._colorUnmodified = new CCColor3B(color3.r, color3.g, color3.b);
        this._setColorStyleStr();
		//this.setNodeDirty();
	}
	
	override public function setOpacity(opacity : Int) {
		if (this._opacity == opacity) {
            return;
        }

        this._opacity = opacity;
		this.sprite.alpha._ = this._opacity / 255;
        this._setColorStyleStr();
        //this.setNodeDirty();
	}
	
	private function _setColorStyleStr() {
		this._colorStyleStr = "rgba(" + this._color.r + "," + this._color.g + "," + this._color.b + ", " + this._opacity / 255 + ")";
	}
	
	/**
     * changes the string to render
     * @warning Changing the string is as expensive as creating a new cc.LabelTTF. To obtain better performance use cc.LabelAtlas
     * @param {String} string text for the label
     */
	public function setString(string : String) {
		 if (this._string != string) {
            this._string = string + "";

            // Force update
            if (this._string.length > 0) {
                _spriteText.text = this._string;
            }
        }
	}
	
	/**
     * returns the text of the label
     * @return {String}
     */
	public function getString() : String {
		return this._string;
	}
	
	/**
     * return Horizontal Alignment of cc.LabelTTF
     * @return {cc.TEXT_ALIGNMENT_LEFT|cc.TEXT_ALIGNMENT_CENTER|cc.TEXT_ALIGNMENT_RIGHT}
     */
	public function getHorizontalAligment() : Int {
		return this._hAlignment;
	}
	
	/**
     * set Horizontal Alignment of cc.LabelTTF
     * @param {cc.TEXT_ALIGNMENT_LEFT|cc.TEXT_ALIGNMENT_CENTER|cc.TEXT_ALIGNMENT_RIGHT} Horizontal Alignment
     */
	public function setHorizontalAlignment(alignment : Int) {
		 if (alignment != this._hAlignment) {
            this._hAlignment = alignment;

            // Force update
            if (this._string.length > 0) {
                _spriteText.align = this.getAlign(this._hAlignment);
            }
        }
	}
	
	/**
     * return Vertical Alignment of cc.LabelTTF
     * @return {cc.VERTICAL_TEXT_ALIGNMENT_TOP|cc.VERTICAL_TEXT_ALIGNMENT_CENTER|cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM}
     */
	 public function getVerticalAlignment() : Int {
        return this._vAlignment;
    }
	
	/**
     * set Vertical Alignment of cc.LabelTTF
     * @param {cc.VERTICAL_TEXT_ALIGNMENT_TOP|cc.VERTICAL_TEXT_ALIGNMENT_CENTER|cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM} verticalAlignment
     */
    public function setVerticalAlignment(verticalAlignment : Int) {
        if (verticalAlignment != this._vAlignment) {
            this._vAlignment = verticalAlignment;

            // Force update
            if (this._string.length > 0) {
                this._updateTTF();
            }
        }
    }
	
	/**
     * return Dimensions of cc.LabelTTF
     * @return {cc.Size}
     */
	public function getDimensions() : CCSize{
       return this._dimensions;
    }
	
	/**
     * set Dimensions of cc.LabelTTF
     * @param {cc.Size} dim
     */
    public function setDimensions(dim : CCSize) {
        if (dim.width != this._dimensions.width || dim.height != this._dimensions.height) {
            this._dimensions = dim;

            // Force udpate
            if (this._string.length > 0) {
                this._updateTTF();
            }
        }
    }
	
	/**
     * return font size of cc.LabelTTF
     * @return {Number}
     */
	public function getFontSize() : Float {
        return this._fontSize;
    }
	
	/**
     * set font size of cc.LabelTTF
     * @param {Number} fontSize
     */
    //public function setFontSize(fontSize : Int) {
        //if (this._fontSize != fontSize) {
            //this._fontSize = fontSize;
//
            // Force update
            //if (this._string.length > 0) {
                //this._updateTTF();
            //}
        //}
    //}
	
	/**
     * return font name of cc.LabelTTF
     * @return {String}
     */
	public function pugetFontName() : String {
        return this._fontName;
    }
	
	/**
     * set font name of cc.LabelTTF
     * @param {String} fontName
     */
    public function setFontName(fontName : String) {
        if (this._fontName != fontName) {
            this._fontName = new String(fontName);
            // Force update
            if (this._string.length > 0) {
				this._font = new Font(CCLoader.pack, fontName);
                _spriteText.font = this._font;
				this._fontSize = this._font.size;
            }
        }
    }
	
	/**
     * initializes the cc.LabelTTF with a font name, alignment, dimension and font size
     * @param {String} initialize string
     * @param {String} fontName
     * @param {Number} fontSize
     * @param {cc.Size} dimensions
     * @param {cc.TEXT_ALIGNMENT_LEFT|cc.TEXT_ALIGNMENT_CENTER|cc.TEXT_ALIGNMENT_RIGHT} alignment
     * @return {Boolean} return false on error
     */
    public function initWithString (initString : String, fontName : String, hAlignment : Int) : Bool {
        //CCCommon.assert(strInfo != null, "cc.LabelTTF.initWithString() label is null");
        if (this.init()) {
			this._fontName = fontName;
			this._font = new Font(CCLoader.pack, _fontName);
            this._dimensions = new CCSize(0, 0);
            
            this._hAlignment = hAlignment;
            this._vAlignment = 0;
            this._fontSize = this._font.size;
            this._string = initString;
            this._fontStyleStr = this._fontSize + "px '" + this._fontName + "'";
			
			
            
			this.sprite = new TextSprite(this._font, this._string);
			this.component = new CCComponent(this);
			
			_spriteText = cast (sprite, TextSprite);
			
			_spriteText.align = this.getAlign(this._hAlignment);
			this.entity.add(this.sprite);
			this.entity.add(this.component);
			
			this._updateTTF();
            return true;
        }
        return false;
    }
	
	private function getAlign(a : Int) : TextAlign {
		var ret : TextAlign = TextAlign.Left;
		switch (a) {
			case 0 : ret = TextAlign.Left;
			case 1 : ret = TextAlign.Center;
			case 2 : ret = TextAlign.Right;
		}
		return ret;
	}
	
	public function _updateTTF() {
        //var oldFontStr = cc.renderContext.font;
        //this._fontStyleStr = this._fontSize + "px '" + this._fontName + "'";
        //cc.renderContext.font = this._fontStyleStr;
        //var dim = cc.renderContext.measureText(this._string);
        //this.setContentSize(cc.size(dim.width, this._fontSize));
        //cc.renderContext.font = oldFontStr;
        //this.setNodeDirty();
		//var s : TextSprite = cast (sprite, TextSprite);
		//s.text = this._string;
		//s.align
		//s.font.size = this._fontSize;
    }
	
	public static function create(initString : String, fontName : String, 
		?hAlignment : Int) : CCLabelTTF {
		var ret : CCLabelTTF = new CCLabelTTF();
		
		//if (dimensions == null) {
			//dimensions = new CCSize(0, fontSize);
		//}
		
		if (hAlignment == null) {
			hAlignment = CCTypes.TEXT_ALIGNMENT_LEFT;
		}
		
		//if (vAlignment == null) {
			//vAlignment = CCTypes.VERTICAL_TEXT_ALIGNMENT_BOTTOM;
		//}
		
		if (ret.initWithString(initString, fontName, hAlignment)) {
			return ret;
		}
		
		return null;
		
	}
}