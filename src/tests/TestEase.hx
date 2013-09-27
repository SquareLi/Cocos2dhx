package tests;
import cc.action.CCActionEase;
import cc.CCDirector;
import cc.layersscenestransitionsnodes.CCScene;
import cc.spritenodes.CCSprite;
import cc.action.CCActionInterval;


/**
 * ...
 * @author Ang Li
 */
class TestEase
{

	public function new() 
	{
		
	}
	
	public static function run() {
		var sprite : CCSprite = CCSprite.create("crystal/mainscene/btn-about");
		var action : CCEaseBounceOut = CCEaseBounceOut.create(CCScaleTo.create(1, 3));
		
		var scene : CCScene = CCScene.create();
		scene.addChild(sprite);
		sprite.runAction(action);
		CCDirector.getInstance().runWithScene(scene);
	}
	
}