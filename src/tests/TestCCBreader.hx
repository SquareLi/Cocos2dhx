package tests;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCDirector;
import cc.extensions.ccbreader.CCBReader;
/**
 * ...
 * @author Ang Li
 */
class TestCCBreader
{

	public function new() 
	{
		
	}
	
	public static function run() {
		var scene : CCScene = CCBuilderReader.loadAsScene("ccbtest/MainScene.ccbi", null, null, "ccbtest/");
		var director : CCDirector = CCDirector.getInstance();
		director.runWithScene(scene);
	}
}