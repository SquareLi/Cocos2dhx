package tests;
import cc.extensions.gui.cccontrolextension.CCScale9Sprite;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCDirector;
import cc.cocoa.CCGeometry;
/**
 * ...
 * @author Ang Li
 */
class TestScale9Sprite
{

	public function new() 
	{
		
	}
	
	public static function run() {
		var scale9Sprite : CCScale9Sprite = CCScale9Sprite.create("Scale9Sprite/blocks9");
		var scene : CCScene = CCScene.create();
		scale9Sprite.setPosition(100, 100);
		
		scale9Sprite.setContentSize(new CCSize(300, 300));
		scene.addChild(scale9Sprite);
		
		var d : CCDirector = CCDirector.getInstance();
		d.runWithScene(scene);
	}
	
}