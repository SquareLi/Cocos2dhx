package cc.extensions.ccbreader;
import cc.basenodes.CCNode;
import cc.extensions.ccbreader.CCBReader;
import cc.menunodes.CCMenuItem;
import cc.spritenodes.CCSprite;
import cc.platform.CCTypes;
import cc.spritenodes.CCSpriteFrame;
import flambe.asset.File;
import flambe.display.BlendMode;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.menunodes.CCMenu;
import cc.extensions.ccbreader.CCNodeLoader;
import cc.labelnodes.CCLabelBMFont;


/**
 * ...
 * @author Ang Li
 */
class CCSpriteLoader extends CCNodeLoader
{
	public static var PROPERTY_FLIP : String = "flip";
	public static var PROPERTY_DISPLAYFRAME : String = "displayFrame";
	public static var PROPERTY_COLOR : String = "color";
	public static var PROPERTY_OPACITY : String = "opacity";
	public static var PROPERTY_BLENDFUNC : String = "blendFunc";
	public function new() 
	{
		super();
	}
	
	override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		var ret : CCSprite = CCSprite.create();
		ret.setTag(250);
		//trace(ret.getTag());
		return ret;
	}
	
	override public function onHandlePropTypeColor3(node:CCNode, parent:CCNode, propertyName:String, ccColor3B:CCColor3B, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_COLOR) {
			//if (ccColor3B.r != 255 || ccColor3B.g != 255 || ccColor3B.b != 255) {
				//
			//}
		} else {
			super.onHandlePropTypeColor3(node, parent, propertyName, ccColor3B, ccbReader);
		}
		
		
	}
	
	override public function onHandlePropTypeByte(node:CCNode, parent:CCNode, propertyName:String, byteValue:Int, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_OPACITY) {
			node.setOpacity(byteValue);
		} else {
			super.onHandlePropTypeByte(node, parent, propertyName, byteValue, ccbReader);
		}
	}
	
	override public function onHandlePropTypeBlendFunc(node:CCNode, parent:CCNode, propertyName:String, ccBlendFunc : BlendMode, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_BLENDFUNC) {
			var s : CCSprite = cast (node, CCSprite);
			s.setBlendFunc(ccBlendFunc);
		} else {
			super.onHandlePropTypeBlendFunc(node, parent, propertyName, ccBlendFunc, ccbReader);
		}
		
	}
	
	override public function onHandlePropTypeSpriteFrame(node:CCNode, parent:CCNode, propertyName:String, spriteFrame:CCSpriteFrame, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_DISPLAYFRAME) {
			if (spriteFrame != null) {
				var s : CCSprite = cast(node, CCSprite);
				s.setDisplayFrame(spriteFrame);
			} else {
				trace("ERROR: SpriteFrame is null");
			}
		} else {
			super.onHandlePropTypeSpriteFrame(node, parent, propertyName, spriteFrame, ccbReader);
		}
		
	}
	
	override public function onHandlePropTypeFlip(node:CCNode, parent:CCNode, propertyName:String, flip:Dynamic, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_FLIP) {
			
		} else {
			super.onHandlePropTypeFlip(node, parent, propertyName, flip, ccbReader);
		}
		
	}
	
	public static function loader() : CCSpriteLoader {
		return new CCSpriteLoader();
	}
}

class CCLayerLoader extends CCNodeLoader {
	public static var PROPERTY_TOUCH_ENABLED : String = "touchEnabled";
	public static var PROPERTY_IS_TOUCH_ENABLED : String = "isTouchEnabled";
	public static var PROPERTY_ACCELEROMETER_ENABLED : String = "accelerometerEnabled";
	public static var PROPERTY_IS_ACCELEROMETER_ENABLED : String = "isAccelerometerEnabled";
	public static var PROPERTY_IS_MOUSE_ENABLED : String = "isMouseEnabled";
	public static var PROPERTY_MOUSE_ENABLED : String = "mouseEnabled";
	public static var PROPERTY_KEYBOARD_ENABLED : String = "keyboardEnabled";
	public static var PROPERTY_IS_KEYBOARD_ENABLED : String = "isKeyboardEnabled";
	override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		var ret : CCLayer = CCLayer.create();
		ret.setTag(200);
		return ret;
	}
	
	override public function onHandlePropTypeCheck(node:CCNode, parent:CCNode, propertyName:String, check:Bool, ccbReader:CCBuilderReader)
	{
		var layer : CCLayer = cast (node, CCLayer);
		if (propertyName == PROPERTY_TOUCH_ENABLED || propertyName == PROPERTY_IS_TOUCH_ENABLED) {
			layer.setPointerEnabled(check);
		}
		//} else if (propertyName == PROPERTY_ACCELEROMETER_ENABLED || propertyName == PROPERTY_IS_ACCELEROMETER_ENABLED) {
            //node.setAccelerometerEnabled(check);
        //} 
		else if (propertyName == PROPERTY_MOUSE_ENABLED || propertyName == PROPERTY_IS_MOUSE_ENABLED ) {
            layer.setPointerEnabled(check);
        } else if (propertyName == PROPERTY_KEYBOARD_ENABLED || propertyName == PROPERTY_IS_KEYBOARD_ENABLED) {
            layer.setKeyboardEnabled(check);
        } else {
            super.onHandlePropTypeCheck(node, parent, propertyName, check, ccbReader);
        }
		
	}
	
	public static function loader() : CCLayerLoader {
		return new CCLayerLoader();
	}
}

class CCMenuLoader extends CCLayerLoader{
    override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		
		return CCMenu.create();
	}
	
	public static function loader() : CCMenuLoader {
		return new CCMenuLoader();
	}
}



class CCMenuItemLoader extends CCNodeLoader {
	public static var PROPERTY_BLOCK : String = "block";
	public static var PROPERTY_ISENABLED : String = "isEnabled";
    override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		return null;
	}

    override public function onHandlePropTypeBlock(node:CCNode, parent:CCNode, propertyName:String, blockData : BlockData, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_BLOCK) {
			if (blockData != null) { // Add this condition to allow CCMenuItemImage without target/selector predefined
				var n : CCMenuItem = cast(node, CCMenuItem);
                n.setTarget(blockData.selMenuHander, blockData.target);
            }
		} else {
			super.onHandlePropTypeBlock(node, parent, propertyName, blockData, ccbReader);
		}
		
	}
	
	override public function onHandlePropTypeCheck(node:CCNode, parent:CCNode, propertyName:String, check:Bool, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_ISENABLED) {
			var n : CCMenuItem = cast (node, CCMenuItem);
			n.setEnabled(check);
		} else {
			super.onHandlePropTypeCheck(node, parent, propertyName, check, ccbReader);
		}
		
	}  
}




class CCMenuItemImageLoader extends CCMenuItemLoader {
	public static var PROPERTY_NORMALDISPLAYFRAME : String = "normalSpriteFrame";
	public static var PROPERTY_SELECTEDDISPLAYFRAME : String = "selectedSpriteFrame";
	public static var PROPERTY_DISABLEDDISPLAYFRAME : String = "disabledSpriteFrame";
	override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		return CCMenuItemImage.create();
	}
	
	override public function onHandlePropTypeSpriteFrame(node:CCNode, parent:CCNode, propertyName:String, spriteFrame:CCSpriteFrame, ccbReader:CCBuilderReader)
	{
		
		if (propertyName == PROPERTY_NORMALDISPLAYFRAME) {
            if (spriteFrame != null) {
				var n : CCMenuItemImage = cast (node, CCMenuItemImage);
                n.setNormalSpriteFrame(spriteFrame);
            }
        } else if (propertyName == PROPERTY_SELECTEDDISPLAYFRAME) {
            if (spriteFrame != null) {
				var n : CCMenuItemImage = cast (node, CCMenuItemImage);
                n.setSelectedSpriteFrame(spriteFrame);
            }
        } else if (propertyName == PROPERTY_DISABLEDDISPLAYFRAME) {
            if (spriteFrame != null) {
				var n : CCMenuItemImage = cast (node, CCMenuItemImage);
                n.setDisabledSpriteFrame(spriteFrame);
            }
        } else {
            super.onHandlePropTypeSpriteFrame(node, parent, propertyName, spriteFrame, ccbReader);
        }
	}
	
	public static function loader() : CCMenuItemImageLoader {
		return new CCMenuItemImageLoader();
	}
}
	


class CCLabelBMFontLoader extends CCNodeLoader {
	public static var PROPERTY_FNTFILE : String = "fntFile";
	
	//var PROPERTY_FONTNAME = "fontName";
	//var PROPERTY_FONTSIZE = "fontSize";
	//var PROPERTY_HORIZONTALALIGNMENT = "horizontalAlignment";
	//var PROPERTY_VERTICALALIGNMENT = "verticalAlignment";
	public static var PROPERTY_STRING = "string";
	//var PROPERTY_DIMENSIONS = "dimensions";
	override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		return CCLabelBMFont.create();
	}

	override public function onHandlePropTypeColor3(node:CCNode, parent:CCNode, propertyName:String, ccColor3B:CCColor3B, ccbReader:CCBuilderReader)
	{
		trace(CCDirector.getInstance().getWinSize());
		//Todo
		if (propertyName == CCSpriteLoader.PROPERTY_COLOR) {
            if(ccColor3B.r != 255 || ccColor3B.g != 255 || ccColor3B.b != 255){
                //node.setColor(ccColor3B);
            }
        } else {
            super.onHandlePropTypeColor3(node, parent, propertyName, ccColor3B, ccbReader);
        }
	}

	override public function onHandlePropTypeByte(node:CCNode, parent:CCNode, propertyName:String, byteValue:Int, ccbReader:CCBuilderReader)
	{
		trace(CCDirector.getInstance().getWinSize());
		if (propertyName == CCSpriteLoader.PROPERTY_OPACITY) {
            node.setOpacity(byteValue);
        } else {
           super.onHandlePropTypeByte(node, parent, propertyName, byteValue, ccbReader);
        }
		
	}
   
	//Todo
	override public function onHandlePropTypeBlendFunc(node:CCNode, parent:CCNode, propertyName:String, ccBlendFunc:BlendMode, ccbReader:CCBuilderReader)
	{
		if (propertyName == CCSpriteLoader.PROPERTY_BLENDFUNC) {
            //node.setBlendFunc(ccBlendFunc);
        } else {
            super.onHandlePropTypeBlendFunc(node, parent, propertyName, ccBlendFunc, ccbReader);
        }
		
	}
	
	override public function onHandlePropTypeFntFile(node : CCNode, parent : CCNode, propertyName : String, fntFile : String, ccbReader : CCBuilderReader)
	{
		if (propertyName == PROPERTY_FNTFILE) {
			var n : CCLabelBMFont = cast(node, CCLabelBMFont);
			var s  = fntFile.split(".fnt");
            n.setFntFile(s[0]);
        } else {
            super.onHandlePropTypeFntFile(node, parent, propertyName, fntFile, ccbReader);
        }
	}
	
	override public function onHandlePropTypeText(node:CCNode, parent:CCNode, propertyName:String, textValue:String, ccbReader:CCBuilderReader)
	{
		if (propertyName == PROPERTY_STRING) {
			var n : CCLabelBMFont = cast(node, CCLabelBMFont);
			
            n.setString(textValue);
        } else {
            super.onHandlePropTypeText(node, parent, propertyName, textValue, ccbReader);
        }
		
	}
	public static function loader() : CCLabelBMFontLoader {
		return new CCLabelBMFontLoader();
	}
}


	  



