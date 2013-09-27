package tests;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCDirector;
import cc.extensions.ccbreader.CCBReader;
import flambe.System;
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
		var about : AboutScene = new AboutScene();
		var game : GameScene = new GameScene();
		CCBReader.CCB_CLASS_ROOT_PATH = "tests.";
		//Type.createInstance(Type.resolveClass("tests.About"), []);
		var scene : CCScene = CCBuilderReader.loadAsScene("crystal/MainScene.ccbi", null, null, "crystal/");
		
		var director : CCDirector = CCDirector.getInstance();
		director.runWithScene(scene);
		
	}
}