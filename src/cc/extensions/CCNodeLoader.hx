package cc.extensions;
import cc.basenodes.CCNode;
import cc.platform.CCCommon;
import cc.extensions.CCBReader;
import cc.extensions.CCNodeLoaderLibrary;
import cc.cocoa.CCGeometry;
import flambe.math.Point;
import cc.CCScheduler;
/**
 * ...
 * @author Ang Li
 */
class CCNodeLoader
{
	public static var PROPERTY_POSITION : String = "position";
	public static var PROPERTY_CONTENTSIZE : String = "contentSize";
	public static var PROPERTY_ANCHORPOINT : String = "anchorPoint";
	public static var PROPERTY_SCALE : String = "scale";
	public static var PROPERTY_ROTATION : String = "rotation";
	public static var PROPERTY_TAG : String = "tag";
	public static var PROPERTY_IGNOREANCHORPOINTFORPOSITION : String = "ignoreAnchorPointForPosition";
	public static var PROPERTY_VISIBLE : String = "visible";
	
	var _customProperties :_Dictionary;
	
	public function new() 
	{
		this._customProperties = new _Dictionary();
	}
	
	public function loadCCNode(parent : CCNode, ccbReader : CCBuilderReader) : CCNode {
		return this._createCCNode(parent, ccbReader);
	}
	
	public function parseProperties(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
		var numRegularProps = ccbReader.readInt(false);
		var numExturaProps = ccbReader.readInt(false);
		var propertyCount = numRegularProps + numExturaProps;
		
		for (i in 0...propertyCount) {
			var isExtraProp : Bool = (i >= numRegularProps);
			var type = ccbReader.readInt(false);
			var propertyName = ccbReader.readCachedString();
			
			var setProp = false;
			
			var platform = ccbReader.readByte();
			if ((platform == CCBReader.CCB_PLATFORM_ALL) ||(platform == CCBReader.CCB_PLATFORM_IOS) ||(platform == CCBReader.CCB_PLATFORM_MAC) )
                setProp = true;
			if (Std.is(node, CCBuilderFile)) {
				var n : CCBuilderFile = cast (node, CCBuilderFile);
				node = n.getCCBFileNode();
				//var getExtraPropsNames = 
			} else if (isExtraProp && node == ccbReader.getAnimationManager().getRootNode()) {
				var extraPropsNames = node.getUserObject();
				if (extraPropsNames == null) {
					extraPropsNames = new Array<String>();
					node.setUserObject(extraPropsNames);
				}
				extraPropsNames.push(propertyName);
			}
			
			switch(type) {
				case CCBReader.CCB_PROPTYPE_POSITION:
					var position = this.parsePropTypePosition(node, parent, ccbReader, propertyName);
					if (setProp) {
						this.onHandlePropTypePosition(node, parent, propertyName, position, ccbReader);
					}
				
			}
		}
	}
	
	public function getCustomProperties() : _Dictionary {
		return this
	}
	
	private function _createCCNode(parent : CCNode, ccbReader : CCBuilderReader) : CCNode {
		return CCNode.create();
	}
	
	public function parsePropTypePosition(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Point {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		var type = ccbReader.readInt(false);
		
		var containerSize : CCSize = ccbReader.getAnimationManager().getContainerSize(parent);
		var pt = CCBRelativePositioning._getAbsolutePosition(x, y, type, containerSize, propertyName);
		var p = CCBRelativePositioning.getAbsolutePosition(pt, type, containerSize, propertyName);
		node.setPosition(p.x, p.y);
		
		if (CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1) {
			var typeFloat = Std.parseFloat(Std.string(type));
			var baseValue = [x, y, typeFloat];
			ccbReader.getAnimationManager().setBaseValue(baseValue, node, propertyName);
		}
		return pt;
	}
	
	public function parsePropTypePoint(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Point {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		return new Point(x, y);
	}
	
	public function parsePropTypePointLock(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Point {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		return new Point(x, y);
	}
	
	public function parsePropTypeSize(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : CCSize {
		var width = ccbReader.readFloat();
		var height = ccbReader.readFloat();
		
		var type = ccbReader.readInt(false);
		
		var containerSize = ccbReader.getAnimationManager().getContainerSize(parent);
		
		switch (type) {
			case CCBReader.CCB_SIZETYPE_ABSOLUTE:
                /* Nothing. */
            case CCBReader.CCB_SIZETYPE_RELATIVE_CONTAINER:
                width = containerSize.width - width;
                height = containerSize.height - height;
            case CCBReader.CCB_SIZETYPE_PERCENT:
                width = (containerSize.width * width / 100.0);
                height = (containerSize.height * height / 100.0);
            case CCBReader.CCB_SIZETYPE_HORIZONTAL_PERCENT:
                width = (containerSize.width * width / 100.0);
            case CCBReader.CCB_SIZETYPE_VERTICAL_PERCENT:
                height = (containerSize.height * height / 100.0);
            case CCBReader.CCB_SIZETYPE_MULTIPLY_RESOLUTION:
                var resolutionScale = cc.BuilderReader.getResolutionScale();
                width *= resolutionScale;
                height *= resolutionScale;
            default:
                trace("Unknown CCB type.");
		}
		return new CCSize(width, height);
	}
	
	public function parsePropTypeScaleLock(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Array<Float> {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		var type = ccbReader.readInt(false);
		
		CCBRelativePositioning.setRelativeScale(node, x, y, type, propertyName);
		if (CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1) {
			var typeFloat = Std.parseFloat(Std.string(type));
			var baseValue = [x, y, typeFloat];
			ccbReader.getAnimationManager().setBaseValue(baseValue);
		}
		
		if (type == CCBReader.CCB_SCALETYPE_MULTIPLY_RESOLUTION) {
			x *= CCBuilderReader.getResolutionScale();
            y *= CCBuilderReader.getResolutionScale();
		}
		return [x, y];
	}
	
	public function parsePropTypeFloat(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Float {
		return ccbReader.readFloat();
	}
	
	
	
	public static function ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName : String) {
		CCCommon.assert(false, "Unexpected property: '" + propertyName + "'!");
	}
	
	public static function ASSERT_FAIL_UNEXPECTED_PROPERTYTYPE(propertyName : String) {

		CCCommon.assert(false, "Unexpected property type: '" + propertyName + "'!");
	}
	
}

class BlockData {
	
}

class BlockCCControlData {
	
}