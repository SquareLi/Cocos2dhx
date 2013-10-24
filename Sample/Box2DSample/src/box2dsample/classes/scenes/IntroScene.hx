package box2dsample.classes.scenes;
import box2dsample.classes.layers.Intro;
import cc.layersscenestransitionsnodes.CCScene;

/**
 * ...
 * @author Ang Li(李昂)
 */
class IntroScene extends CCScene
{
	var introLayer : Intro;
	public function new() 
	{
		super();
		this.introLayer = new Intro();
		this.addChild(this.introLayer);
	}
	
}