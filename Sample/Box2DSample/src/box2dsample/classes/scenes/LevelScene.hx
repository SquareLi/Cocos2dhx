package box2dsample.classes.scenes;
import box2dsample.classes.layers.Level;
import cc.layersscenestransitionsnodes.CCScene;

/**
 * ...
 * @author Ang Li(李昂)
 */
class LevelScene extends CCScene
{
	var levelLayer : Level;
	public function new() 
	{
		super();
		this.levelLayer = new Level();
		this.addChild(this.levelLayer);
	}
	
}