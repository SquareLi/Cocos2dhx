package box2dsample.classes.sprites;
import box2dsample.Game;
import cc.spritenodes.CCSprite;

/**
 * ...
 * @author Ang Li(李昂)
 */
class Background extends CCSprite
{	
	var width : Float = 1280;
	var height : Float = 670;
	var game : Game;
	public function new() 
	{
		super();
		game = Game.getInstance();
		trace("classes.sprites.Background.ctor()");
        this.initWithFile("images/meadow");
        this.setPosition(game.getWindowSize().width / 2, game
                .getWindowSize().height / 2);
	}
	
}