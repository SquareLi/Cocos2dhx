package cc.extensions.ccbreader;
import cc.extensions.ccbreader.CCBuilderReader;
import cc.basenodes.CCNode;

/**
 * ...
 * @author Ang Li
 */
class CCControlLoader extends CCNodeLoader
{
	public static var PROPERTY_CCBFILE : String = "ccbFile";
	
	public static var PROPERTY_ENABLED : String = "enabled";
	public static var PROPERTY_SELECTED : String = "selected";
	public static var PROPERTY_CCCONTROL : String = "ccControl";
	
	public static var PROPERTY_ZOOMONTOUCHDOWN : String = "zoomOnTouchDown";
	public static var PROPERTY_TITLE_NORMAL : String = "title|1";
	public static var PROPERTY_TITLE_HIGHLIGHTED : String = "title|2";
	public static var PROPERTY_TITLE_DISABLED : String = "title|3";
	public static var PROPERTY_TITLECOLOR_NORMAL : String = "titleColor|1";
	public static var PROPERTY_TITLECOLOR_HIGHLIGHTED : String = "titleColor|2";
	public static var PROPERTY_TITLECOLOR_DISABLED : String = "titleColor|3";
	public static var PROPERTY_TITLETTF_NORMAL : String = "titleTTF|1";
	public static var PROPERTY_TITLETTF_HIGHLIGHTED : String = "titleTTF|2";
	public static var PROPERTY_TITLETTF_DISABLED : String = "titleTTF|3";
	public static var PROPERTY_TITLETTFSIZE_NORMAL : String = "titleTTFSize|1";
	public static var PROPERTY_TITLETTFSIZE_HIGHLIGHTED : String = "titleTTFSize|2";
	public static var PROPERTY_TITLETTFSIZE_DISABLED : String = "titleTTFSize|4";
	public static var PROPERTY_LABELANCHORPOINT : String = "labelAnchorPoint";
	public static var PROPERTY_PREFEREDSIZE : String = "preferedSize";         // TODO Should be = "preferredSize". This is a typo in cocos2d-iphone, cocos2d-x and CocosBuilder!
	public static var PROPERTY_BACKGROUNDSPRITEFRAME_NORMAL : String = "backgroundSpriteFrame|1";
	public static var PROPERTY_BACKGROUNDSPRITEFRAME_HIGHLIGHTED : String = "backgroundSpriteFrame|2";
	public static var PROPERTY_BACKGROUNDSPRITEFRAME_DISABLED : String = "backgroundSpriteFrame|3";

	override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		//return super._createCCNode(parent, ccbReader);
		return null;
	}
	
	override public function onHandlePropTypeBlockCCControl(node:CCNode, parent:CCNode, propertyName:String, blockCCControlData:Dynamic, ccbReader:CCBuilderReader):Dynamic 
	{
		if (propertyName == CCControlLoader.PROPERTY_CCCONTROL) {
			
		}
		super.onHandlePropTypeBlockCCControl(node, parent, propertyName, blockCCControlData, ccbReader);
	}
	
	public function new() 
	{
		
	}
	
}

class CCBuilderFileLoader extends CCNodeLoader {
	override private function _createCCNode(parent:CCNode, ccbReader:CCBuilderReader):CCNode 
	{
		return new CCBuilderFile.create();
	}
	
	override public function onHandlePropTypeCCBFile(node:CCNode, parent:CCNode, propertyName:String, ccbFilenode:Dynamic, ccbReader:CCBuilderReader):Dynamic 
	{
		if (propertyName == CCControlLoader.PROPERTY_CCBFILE) {
			var n : CCBuilderFile = cast(node, CCBuilderFile);
			n.setCCBFileNode(ccbFilenode);
		} else {
			super.onHandlePropTypeCCBFile(node, parent, propertyName, ccbFilenode, ccbReader);
		}
		
	}
	
	public static function loader() : CCBuilderFileLoader {
		return new CCBuilderFileLoader();
	}
}

