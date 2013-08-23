package tests;
import cc.layersscenestransitionsnodes.CCScene;
import flambe.display.EmitterMold;
import flambe.System;
import cc.particlenodes.CCParticleSystem;
import cc.CCDirector;
/**
 * ...
 * @author Ang Li
 */
class TestPartical
{

	public function new() 
	{
		
	}
	
	public function run() {
		var s : CCScene = CCScene.create();
		
		var p = CCParticleSystem.create("radialTest");
		p.setPosition(150, 150);
		s.addChild(p);
		CCDirector.getInstance().runWithScene(s);
	}
	
}