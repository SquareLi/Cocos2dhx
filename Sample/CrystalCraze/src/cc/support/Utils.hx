package cc.support;

/**
 * ...
 * @author
 */
class Utils
{

	public function new() 
	{
		
	}
	
	public static function toFloat(x : Int) : Float {
		var s : String = Std.string(x);
		return Std.parseFloat(s
		);
	}
	
}