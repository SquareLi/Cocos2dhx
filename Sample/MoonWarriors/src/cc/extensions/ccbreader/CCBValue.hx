package cc.extensions.ccbreader;
import cc.platform.CCTypes;
/**
 * ...
 * @author
 */
class CCBValue
{
	public static var INT_VALUE : Int = 0;
	public static var FLOAT_VALUE : Int = 1;
	public static var POINTER_VALUE : Int = 2;
	public static var BOOL_VALUE : Int = 3;
	public static var UNSIGNEDCHAR_VALUE : Int = 4;
	public function new() 
	{
		
	}
	
}

class CCColor3BWapper {
	var _color : CCColor3B;
	
	private function new() {
		this._color = new CCColor3B(0, 0, 0);
	}
	
	public function getColor() : CCColor3B {
		return this._color;
	}
	
	public static function create(color : CCColor3B) : CCColor3BWapper {
		var ret = new CCColor3BWapper();
		if (ret != null) {
			ret._color.r = color.r;
			ret._color.g = color.g;
			ret._color.b = color.b;
		}
		return ret;
	}
}

//class CCBuilderValue {
	//var 
//}