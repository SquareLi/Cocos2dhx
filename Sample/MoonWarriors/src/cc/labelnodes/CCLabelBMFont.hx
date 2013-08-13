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
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.spritenodes.CCSprite;
import flambe.display.TextSprite;
import flambe.display.Font;
import flambe.math.Point;
import cc.CCLoader;

/**
 * ...
 * @author Ang Li
 */
class CCLabelBMFont extends CCNode
{
	var _opacity : Int;
	var _string : String = "";
	var _fntFile : String = "";
	var _initialString : String = "";
	var _alignment : TextAlign;
	var _width : Float = 0;
	var _lineBreakWithoutSpaces : Bool = false;
	var _imageOffset : Point;
	
	var _font : Font;
	var _spriteText : TextSprite;
	public function new() 
	{
		super();
		_imageOffset = new Point(0, 0);
	}
	
	/**
     * conforms to cc.RGBAProtocol protocol
     * @return {Number}
     */
	override public function getOpacity() : Int {
        return this._opacity;
    }

    /**
     * set the opacity of this label
     * @param {Number} v
     */
	override public function setOpacity(v : Int) {
        this._opacity = v;
		this.sprite.alpha._ = _opacity / 255.0;
        if (this._children != null) {
            for (i in 0...this._children.length) {
                var node = cast(this._children[i], CCLabelBMFont);
                if (node != null) {
                    node.setOpacity(this._opacity);
                }
            }
        }
    }
	
	/**
     *  init LabelBMFont
     */
    //override public functon init() {
        //return this.initWithString(null, null, null, null, null);
    //}

    /**
     * init a bitmap font altas with an initial string and the FNT file
     * @param {String} str
     * @param {String} fntFile
     * @param {String} width
     * @param {Number} alignment
     * @param {cc.Point} imageOffset
     * @return {Boolean}
     */
	public function initWithString(str : String, fntFile : String, ?width : Float = 0, ?alignment : Int = 0, ?imageOffset : Point) : Bool {
		if (imageOffset == null) {
			imageOffset = new Point(0, 0);
		}
		
		var theString : String = str;
		this._initialString = str;
		_font = new Font(CCLoader.pack, fntFile);
		this.sprite = new TextSprite(_font, theString);
		this._spriteText = cast(sprite, TextSprite);
		this._spriteText.align = getAlign(alignment);
		this._spriteText.wrapWidth._ = width;
		this._imageOffset = imageOffset;
		
		this.component = new CCComponent(this);
		this.entity.add(this.sprite);
		this.entity.add(this.component);
		
		this._contentSize.width = this.sprite.getNaturalWidth();
		this._contentSize.height = this.sprite.getNaturalHeight();
		
		//this._spriteText.setAnchor(0, 0);
		
		return true;
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
	
	/**
     * update String
     * @param {Boolean} fromUpdate
     */
    public function updateString(fromUpdate : Bool) {
        //if (this._children) {
            //for (var i = 0; i < this._children.length; i++) {
                //var node = this._children[i];
                //if (node) {
                    //node.setVisible(false);
                //}
            //}
        //}
//
        //if (this._configuration) {
            //this.createFontChars();
        //}
        if (!fromUpdate) {
			this._spriteText.text = this._string;
        }
    }

    /**
     * get the text of this label
     * @return {String}
     */
	public function getString() : String{
        return this._initialString;
    }

    /**
     * set the text
     * @param newString
     */
    public function setString(newString : String, ?fromUpdate : Bool = false ) {
        if (this._string != newString) {
            this._string = newString;
            //  if(this._initialString == ""){
            this._initialString = newString;
            //}
            this.updateString(fromUpdate);
        }
    }
	
	
	 /**
     * Set text vertical alignment
     * @param {Number} alignment
     */
    public function setAlignment(alignment : Int) {
        this._alignment = this.getAlign(alignment);
		this._spriteText.align = this._alignment;
    }

    /**
     * @param {Number} width
     */
    public function setWidth(width : Float) {
        this._width = width;
        this._spriteText.wrapWidth._ = width;
    }

    /**
     * @param {Boolean}  breakWithoutSpace
     */
    //setLineBreakWithoutSpace(breakWithoutSpace) {
        //this._lineBreakWithoutSpaces = breakWithoutSpace;
        //this.updateLabel();
    //}

    /**
     * @param {Number} scale
     */
    //setScale(scale : Float, ?scaleY : Float) {
        //this._super(scale, scaleY);
        //this.updateLabel();
    //}

    /**
     * @param {Number} scaleX
     */
    //setScaleX(scaleX) {
        //this._super(scaleX);
        //this.updateLabel();
    //}

    /**
     * @param {Number} scaleY
     */
    //setScaleY(scaleY) {
        //this._super(scaleY);
        //this.updateLabel();
    //}
    /**
     * set fnt file path
     * @param {String} fntFile
     */
    public function setFntFile(fntFile : String) {
        this._font = new Font(CCLoader.pack, fntFile);
		this._spriteText.font = this._font;
    }

    /**
     * @return {String}
     */
	public function getFntFile() : String {
        return this._fntFile;
    }

    /**
     * set the anchorpoint of the label
     * @param {cc.Point} point
     */
    //setAnchorPoint(point) {
        //if (!cc.Point.CCPointEqualToPoint(point, this._anchorPoint)) {
            //this._super(point);
            //this.updateLabel();
        //}
    //}
	
	public static function create(str : String, fntFile : String, ?width : Float = 0, ?alignment : Int = 0, ?imageOffset : Point) : CCLabelBMFont{
		var ret : CCLabelBMFont = new CCLabelBMFont();
		
		if (imageOffset == null) {
			imageOffset = new Point(0, 0);
		}
		ret.initWithString(str, fntFile, width, alignment, imageOffset);
		return ret;
	}
}