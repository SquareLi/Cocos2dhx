package cc.extensions.ccbreader;
import cc.basenodes.CCNode;
import cc.extensions.ccbreader.CCBReader;
import cc.spritenodes.CCSprite;
import cc.platform.CCTypes;
import cc.spritenodes.CCSpriteFrame;
import flambe.display.BlendMode;
import cc.layersscenestransitionsnodes.CCLayer;


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

