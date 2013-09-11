package cc.extensions;
import cc.basenodes.CCNode;
import flambe.math.Point;
import cc.cocoa.CCGeometry;
import cc.platform.CCCommon;
/**
 * ...
 * @author Ang Li
 */
class CCBRelativePositioning
{

	public function new() 
	{
		
	}
	
	public static function getAbsolutePosition(pt : Point, type : Int, containerSize : CCSize, propName : String) {
		var absPt : Point = new Point(0, 0);
		if (type == CCBReader.CCB_POSITIONTYPE_RELATIVE_BOTTOM_LEFT) {
			absPt = pt;
		} else if(type == CCBReader.CCB_POSITIONTYPE_RELATIVE_TOP_LEFT){
			absPt.x = pt.x;
			absPt.y = containerSize.height - pt.y;
		} else if(type == CCBReader.CCB_POSITIONTYPE_RELATIVE_TOP_RIGHT){
			absPt.x = containerSize.width - pt.x;
			absPt.y = containerSize.height - pt.y;
		} else if (type == CCBReader.CCB_POSITIONTYPE_RELATIVE_BOTTOM_RIGHT) {
			absPt.x = containerSize.width - pt.x;
			absPt.y = pt.y;
		} else if (type == CCBReader.CCB_POSITIONTYPE_PERCENT) {
			absPt.x = (containerSize.width * pt.x / 100.0);
			absPt.y = (containerSize.height * pt.y / 100.0);
		} else if (type == CCBReader.CCB_POSITIONTYPE_MULTIPLY_RESOLUTION) {
			var resolutionScale = cc.BuilderReader.getResolutionScale();
			absPt.x = pt.x * resolutionScale;
			absPt.y = pt.y * resolutionScale;
		}
		
		return absPt
	}
	public static function _getAbsolutePosition(x : Float, y : Float, type : Int, containerSize : CCSize, propName : String) : Point {
		var absPt : Point = new Point();
		if (type == CCBReader.CCB_POSITIONTYPE_RELATIVE_BOTTOM_LEFT) {
			absPt.x = x;
			absPt.y = y;
		}else if(type == CCBReader.CCB_POSITIONTYPE_RELATIVE_TOP_LEFT){
			absPt.x = x;
			absPt.y = containerSize.height - y;
		} else if(type == CCBReader.CCB_POSITIONTYPE_RELATIVE_TOP_RIGHT){
			absPt.x = containerSize.width - x;
			absPt.y = containerSize.height - y;
		} else if (type == CCBReader.CCB_POSITIONTYPE_RELATIVE_BOTTOM_RIGHT) {
			absPt.x = containerSize.width - x;
			absPt.y = y;
		} else if (type == CCBReader.CCB_POSITIONTYPE_PERCENT) {
			absPt.x = (containerSize.width * x / 100.0);
			absPt.y = (containerSize.height * y / 100.0);
		} else if (type == CCBReader.CCB_POSITIONTYPE_MULTIPLY_RESOLUTION) {
			var resolutionScale = cc.BuilderReader.getResolutionScale();
			absPt.x = x * resolutionScale;
			absPt.y = y * resolutionScale;
		}
		
		return absPt;
	}
	
	public static function setRelativeScale(node : CCNode, scaleX : Float, scaleY : Float, type : Int, propName : String) {
		CCCommon.assert(node != null, "pNode should not be null");
		
		if (type == CCBReader.CCB_POSITIONTYPE_MULTIPLY_RESOLUTION) {
			var resolutionScale = CCBuilderReader.getResolutionScale();
			
			scaleX *= resolutionScale;
			scaleY *= resolutionScale;
		}
		
		node.setScaleX(scaleX);
		node.setScaleY(scaleY);
	}
	
}