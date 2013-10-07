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
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.platform.CCTypes;
import cc.cocoa.CCGeometry;
import cc.CCDirector;
import cc.platform.CCMacro;
import cc.platform.CCCommon;
import cc.touchdispatcher.CCPointer;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.menunodes.CCMenuItem;
/**
 * <p> Features and Limitation:<br/>
 *  - You can add MenuItem objects in runtime using addChild:<br/>
 *  - But the only accecpted children are MenuItem objects</p>
 * @class
 * @extends cc.Layer
 */
class CCMenu extends CCLayer
{
	public static var MENU_STATE_WAITING : Int = 0;
	public static var MENU_STATE_TRACKING_TOUCH : Int = 1;
	public static var MENU_HANDLER_PRIORITY : Int = -128;
	public static var DEFAULT_PADDING : Float = 5;
	
	public var RGBAProtocol : Bool = true;
	
	var _state : Int = -1;
	//var _color : CCColor3B;
	public function new() 
	{
		super();
		//this.sprite = new Sprite();
		//this.sprite = new FillSprite(0x000000, 0, 0);
		//this.sprite.setAnchor(0, 0);
		//this.sprite.y._ = 200;
		//var f : FillSprite = cast(this.sprite, FillSprite);
		//sprite.alpha._ = 1;
		//var f : FillSprite = cast(this.sprite, FillSprite);
		//f.alpha 
		//this.entity.add(sprite);
		//this.component = new CCComponent(this);
		//this.entity.add(component);
		//_color = new CCColor3B();
	}
	
	
	
	//override public function setAnchorPoint(point:Point)
	//{
		//
		//super.setAnchorPoint(new Point(0, 0));
		//
		//this.sprite.anchorX._ = 0;
		//this.sprite.anchorY._ = _contentSize.height;
	//}
	
	//public function getColor() : CCColor3B {
		//return this._color;
	//}
	//
	//public function setColor(color : CCColor3B) {
		//this._color = color;
		//
		//if (this._children != null && this._children.length > 0) {
			//for (i in this._children) {
				//i.setColor
			//}
		//}
	//}
	
	var _enabled : Bool = false;
	
	public function isEnabled() : Bool {
		return this._enabled;
	}
	
	public function setEnabled(enabled : Bool) {
		this._enabled = enabled;
	}
	
	var _selectedItem : CCMenuItem;
	
	/**
     * initializes a cc.Menu with it's items
     * @param {Array} args
     * @return {Boolean}
     */
	public function initWithItems(args : Array<CCMenuItem>) : Bool {
		var pArray : Array<CCMenuItem> = new Array<CCMenuItem>();
		if (args != null) {
			for (i in 0...args.length) {
				pArray.push(args[i]);
			}
		}
		return this.initWithArray(pArray);
	}
	
	/**
     * initializes a cc.Menu with a Array of cc.MenuItem objects
     */
	public function initWithArray(arrayOfItems : Array<CCMenuItem>) : Bool{
		if (this.init()) {
			//this.registerWithTouchDispatcher();
			this._enabled = true;
			
			//menu in the center of the screen
			var winSize : CCSize = CCDirector.getInstance().getWinSize();
			//this.ignoreAnchorPointForPosition(true);
			
			//this.sprite.getNaturalHeight
			//this.setCenterAnchor();
			
			this.setContentSize(winSize);
			//this.sprite.centerAnchor();
			//this.setPosition(winSize.width / 2, winSize.height / 2);
			
			if (arrayOfItems != null) {
				for (i in 0...arrayOfItems.length) {
					this.addChild(arrayOfItems[i], i);
					arrayOfItems[i].setPosition(0, 0);
				}
			}
			
			this._selectedItem = null;
			this._state = MENU_STATE_WAITING;
			return true;
		}
		
		return false;
	}
	
	/**
     * @param {cc.Node} child
     * @param {Number|Null} zOrder
     * @param {Number|Null} tag
     */
	override public function addChild(child:CCNode, ?zOrder:Int, ?tag:Int)
	{
		CCCommon.assert(Std.is(child, CCMenuItem), "Menu only supports MenuItem objects as children");
		
		super.addChild(child, zOrder, tag);
	}
	
	public function alignItemsVertically() {
		this.alignVerticallyWithPadding(DEFAULT_PADDING);
	}
	
	public function alignVerticallyWithPadding(padding : Float) {
		var height : Float = padding;
		if (this._children != null && this._children.length > 0) {
			for (i in 0..._children.length) {
				//this._children[i].setCenterAnchor();
				this._children[i].setPosition(0, height);
				height += this._children[i].getContentSize().height * this._children[i].getScaleY() + padding;
			}
		}
		
		//var y = height;
		//if (this._children != null && this._children.length > 0) {
			//for (i in 0..._children.length) {
				//this._children[i].setPosition(0, y - this._children[i].getContentSize().height * this._children[i].getScaleY() / 2);
				//y -= this._children[i].getContentSize().height * this._children[i].getScaleY() + padding;
			//}
		//}
	}
	
	/**
     * align items horizontally with default padding
     */
	public function alignItemsHorizontally() {
		this.alignItemsHorizontallyWithPadding(DEFAULT_PADDING);
	}
	
	/**
     * align items horizontally with specified padding
     * @param {Number} padding
     */
	public function alignItemsHorizontallyWithPadding(padding : Float) {
		var width = -padding;
        if (this._children != null && this._children.length > 0) {
            for (i in 0..._children.length) {
                width += this._children[i].getContentSize().width * this._children[i].getScaleX() + padding;
            }
        }

        var x = -width / 2.0;
        if (this._children != null && this._children.length > 0) {
            for (i in 0..._children.length) {
                this._children[i].setPosition(x + this._children[i].getContentSize().width * this._children[i].getScaleX() / 2, 0);
                x += this._children[i].getContentSize().width * this._children[i].getScaleX() + padding;
            }
        }
	}
	
	public function alignItemsInColumns(args : Array<Int>) {
		var rows : Array<Int> = new Array<Int>();
		
		for (i in 0...args.length) {
			rows.push(args[i]);
		}
		
		var height : Float = -5;
		var row : Int = 0;
		var rowHeight : Float = 0;
		var columnsOccupied : Int = 0;
		var rowColumns : Int = 0;
		
		if (this._children != null && this._children.length > 0) {
			for (i in 0...this._children.length) {
				CCCommon.assert(row < rows.length, "");
				
				rowColumns = rows[row];
				//can not have zero columns on a row
				CCCommon.assert(rowColumns != 0, "");
				
				var tmp = this._children[i].getContentSize().height;
				rowHeight = ((rowHeight >= tmp || Math.isNaN(tmp)) ? rowHeight : tmp);
				
				++columnsOccupied;
				if (columnsOccupied >= rowColumns) {
					height += rowHeight + 5;
					
					columnsOccupied = 0;
					rowHeight = 0;
					++row;
				}
			}
		}
		
		//CCCommon.assert(!columnsOccupied, "");
		var winSize : CCSize = CCDirector.getInstance().getWinSize();
		
		row = 0;
		rowHeight = 0;
		rowColumns = 0;
		var w : Float = 0.0;
		var x : Float = 0.0;
		var y : Float = (height / 2);
		
		if (this._children != null && this._children.length > 0) {
			for (i in 0...this._children.length) {
				var child : CCMenuItem = cast (this._children[i], CCMenuItem);
				if (rowColumns == 0) {
					rowColumns = rows[row];
					w = winSize.width / (1 + rowColumns);
					x = w;
				}
				
				var tmp : Float = child.getContentSize().height;
				rowHeight = ((rowHeight >= tmp || Math.isNaN(tmp)) ? rowHeight : tmp);
				
				child.setPosition(x - winSize.width / 2, y - child.getContentSize().height / 2);
				x += w;
				++columnsOccupied;
				
				if (columnsOccupied >= rowColumns) {
					y -= rowHeight + 5;
					
					columnsOccupied = 0;
					rowColumns = 0;
					rowHeight = 0;
					++row;
				}
			}
		}
	}
	
	public function alignItemsInRows(args : Array<Int>) {
		var columns : Array<Int> = new Array<Int>();
		for (i in args) {
			columns.push(i);
		}
		
		var columnWidths : Array<Float> = new Array<Float>();
		var columnHeights : Array<Float> = new Array<Float>();
		
		var width : Float = -10;
		var columnHeight : Float = -5;
		var column : Int = 0;
		var columnWidth : Float = 0;
		var rowsOccupied : Int = 0;
		var columnRows : Int;
		
		if (this._children != null && this._children.length > 0) {
			for (i in 0...this._children.length) {
				var child : CCNode = this._children[i];
				// check if too many menu items for the amount of rows/columns
				CCCommon.assert(column < columns.length, ""); 
				
				columnRows = columns[column];
				//can't have zero rows on a column
				CCCommon.assert(columnRows != 0, "");
				
				var tmp : Float = child.getContentSize().width;
				columnWidth = ((columnWidth >= tmp || Math.isNaN(tmp)) ? columnWidth : tmp);
				
				columnHeight += (child.getContentSize().height + 5);
				++rowsOccupied;
				
				 if (rowsOccupied >= columnRows) {
                    columnWidths.push(columnWidth);
                    columnHeights.push(columnHeight);
                    width += columnWidth + 10;

                    rowsOccupied = 0;
                    columnWidth = 0;
                    columnHeight = -5;
                    ++column;
                }
			}
		}
		
		CCCommon.assert(rowsOccupied == 0, "");
		
		var winSize : CCSize = CCDirector.getInstance().getWinSize();
		
		var column : Int = 0;
		var columnWidth : Float = 0;
		var columnRows : Float = 0;
		var x : Float = -width / 2 ;
		var y = 0.0;
		
		if (this._children != null && this._children.length > 0) {
			for (i in 0...this._children.length) {
				var child : CCNode = this._children[i];
				if (columnRows == 0) {
					columnRows = columns[column];
					y = columnHeights[column];
				}
				
				var tmp : Float = child.getContentSize().width;
				columnWidth = ((columnWidth >= tmp || Math.isNaN(tmp)) ? columnWidth : tmp);
				child.setPosition(x + columnWidths[column] / 2,
                    y - winSize.height / 2);
					
				y -= child.getContentSize().height + 10;
                ++rowsOccupied;
				
				if (rowsOccupied >= columnRows) {
                    x += columnWidth + 5;
                    rowsOccupied = 0;
                    columnRows = 0;
                    columnWidth = 0;
                    ++column;
                }
			}
		}
	}
	
	override public function registerWithTouchDispatcher()
	{
		//super.registerWithTouchDispatcher();
		CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this, MENU_HANDLER_PRIORITY);
	}
	
	@:keep override public function onPointerDown(event:CCPointer):Bool 
	{

		if (this._state != MENU_STATE_WAITING || !this._visible || !this._enabled) {
			//trace("false");
			return true;
		}
		
		var c : CCNode = this._parent;
		while (c != null) {
			if (!c.isVisible()) {
				return false;
			}
			
			c = c.getParent();
		}
		this._selectedItem = this._itemForTouch(event);
		if (this._selectedItem == null) {
		}
		if (this._selectedItem != null) {
			this._state = MENU_STATE_TRACKING_TOUCH;
			this._selectedItem.selected();
			return true;
		}
		return false;
	}
	
	@:keep override public function onPointerUp(event:CCPointer):Bool 
	{
		if (!_enabled) {
			return true;
		}
		//CCCommon.assert(this._state == MENU_STATE_TRACKING_TOUCH, "[Menu onTouchEnded] -- invalid state");
		if (this._selectedItem != null) {
			this._selectedItem.unselected();
			this._selectedItem.activate();
		}
		
		this._state = MENU_STATE_WAITING;
		return true;
	}
	
	@:keep override public function onPointerDragged(event:CCPointer):Bool 
	{
		if (!_enabled) {
			return true;
		}
		//CCCommon.assert(this._state == MENU_STATE_TRACKING_TOUCH, "[Menu onTouchMoved] -- invalid state");
		var currentItem : CCMenuItem = this._itemForTouch(event);
		if (currentItem != this._selectedItem) {
			if (this._selectedItem != null) {
				this._selectedItem.unselected();
			}
			this._selectedItem = currentItem;
			if (this._selectedItem != null) {
				this._selectedItem.selected();
			}
		}
		return true;
	}
	
	@:keep override public function onPointerMoved(event:CCPointer):Bool 
	{
		return true;
	}
	
	override public function onExit()
	{
		if (this._state == MENU_STATE_TRACKING_TOUCH) {
			this._selectedItem.unselected();
			this._state = MENU_STATE_WAITING;
			this._selectedItem = null;
		}
		//trace("CCMenu onExit");
		super.onExit();
	}
	
	private function _itemForTouch(touch : CCPointer) : CCMenuItem{
		var touchLocation = touch.getLocation();
		
		if (this._children != null && this._children.length > 0) {
			for (i in 0...this._children.length) {
				var child : CCMenuItem = cast(this._children[i], CCMenuItem);
				if (child.isVisible() && child.isEnabled()) {
					var r : Rectangle = child.rect();
					//trace(r.toString());
					//r.x = r.x + this._position.x;
					//r.y = r.y + this._position.y;
					//trace(r.toString());
					
					var temp : CCMenuItemImage = null;
					var isContain : Bool = false;

					var tempNode : CCNode = child.getCurrentNode();
					if (tempNode != null) {
						isContain = tempNode.getSprite().contains(touch.getLocation().x, touch.getLocation().y);
					}
					
					if (isContain) {
						//trace(touch.getLocation().x);
						return child;
					}
				}
			}
		}
		return null;
	}
	
	public function setHandlerPriority(newPriority : Int) {
		CCDirector.getInstance().getPointerDispatcher().setPriority(newPriority, this);
	}
	
	public static function create(?args : Array<CCMenuItem>) : CCMenu {
		var ret : CCMenu = new CCMenu();
		if (args == null) {
			ret.initWithItems(null);
			ret.initWithArray([]);
			return ret;
		}
		
		if (args.length == 0) {
			ret.initWithItems(null);
		} 
		
		ret.initWithArray(args);
		
		return ret;
	}
}