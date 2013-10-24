package box2dsample.classes.sprites;
import box2dsample.Game;
import box2dsample.Sensors;
import cc.spritenodes.CCSprite;
import box2dsample.classes.layers.Level;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.cocoa.CCGeometry;

/**
 * ...
 * @author Ang Li(李昂)
 */
class Hedgehog extends CCSprite
{
	public var width : Float = 30;
	public var height : Float = 30;
	public var speed : Float = 130;
	var game : Game;
	var sensors : Sensors;
	public function new() 
	{
		super();
		game = Game.getInstance();
		sensors = Sensors.getInstance();
		trace("classes.sprites.Hedgehog.ctor()");
		this.initWithFile("images/hedgehog");
		this.setPosition(0, 0);
	}
	
	public function move(dt : Float , keyboardArrows : Arrows ) : Point {
		var pos = this.getPosition();
		/**
		 * TODO: Axis are inverted for different types of devices.
		 * 
		 */
		if (keyboardArrows.left) {
			pos.x = pos.x - this.speed * dt;
		}
		if (keyboardArrows.right) {
			pos.x = pos.x + this.speed * dt;
		}
		if (keyboardArrows.up) {
			pos.y = pos.y - this.speed * dt;
		}
		if (keyboardArrows.down) {
			pos.y = pos.y + this.speed * dt;
		}

		pos.x = pos.x - (sensors.getBeta() / 4);
		pos.y = pos.y - (sensors.getGamma() / 5);

		if (pos.x < this.width / 2) {
			pos.x = this.width / 2;
		} else if (pos.x > (game.getWindowSize().width - this.width / 2)) {
			pos.x = (game.getWindowSize().width - this.width / 2);
		}
		if (pos.y < this.height / 2) {
			pos.y = this.height / 2;
		} else if (pos.y > (game.getWindowSize().height - this.height / 2)) {
			pos.y = (game.getWindowSize().height - this.height / 2);
		}
		return new Point(pos.x, pos.y);
	}
	
	
	public function collideRect() : Rectangle {
		var a = this.getContentSize();
		var p = this.getPosition();
		return new Rectangle(p.x - a.width / 2, p.y - a.height / 2, a.width,
				a.height);
	}
	
	public function getX() : Float {
		return this.getPosition().x;
	}
	
	public function getY() : Float {
		return this.getPosition().y;
	}
	
}