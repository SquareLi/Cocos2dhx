package cc.layersscenestransitionsnodes;
import cc.layersscenestransitionsnodes.CCScene;
import flambe.scene.FadeTransition;
import cc.layersscenestransitionsnodes.CCTransitionScene;
import cc.platform.CCTypes;

/**
 * ...
 * @author
 */

class CCTransitionFade extends CCTransitionScene
{
	//public var fadeTransition (default, null) : FadeTransition;
	public var duration : Float;
	public function new() 
	{
		super();
	}
	
	//Cannot change color
	override public function initWithDuration(t:Float, scene:CCScene):Bool 
	{
		super.initWithDuration(t, scene);
		this.transition = new FadeTransition(t);
		
		return true;
	}
	
	public static function create(t : Float, scene : CCScene, ?color : CCColor3B) : CCTransitionFade {
		var ret = new CCTransitionFade();
		ret.initWithDuration(t, scene);
		
		return ret;
	}
}