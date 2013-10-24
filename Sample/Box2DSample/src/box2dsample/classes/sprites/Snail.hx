package box2dsample.classes.sprites;
import cc.spritenodes.CCSprite;
import flambe.math.Point;
import box2dsample.Game;
import box2dsample.Sensors;
import flambe.math.Rectangle;
import cc.cocoa.CCGeometry;

/**
 * ...
 * @author Ang Li(李昂)
 */
class Snail extends CCSprite
{
	public var width : Float = 30;
	public var height : Float = 30;
	public var x : Float = 0;
	public var y : Float = 0;
	public var vx : Float = 0;
	public var vy : Float = 0;
	var game : Game;
	var sensors : Sensors;
	public function new() 
	{
		super();
		game = Game.getInstance();
		sensors = Sensors.getInstance();
		this.initWithFile("images/snail");
	}
	
	public function move() : Point {
		var DAMP : Float = 0.99;
		//trace('Before move x = ${this.x}, y = ${this.y}');
		this.x = this.getPosition().x;
		this.y = this.getPosition().y;

		this.vx += (Math.random() * 0.5 - 0.25) * 2;
		this.vy += (Math.random() * 0.5 - 0.25) * 2;

		var newx = this.x + this.vx;
		var newy = this.y + this.vy;

		this.x += this.vx;
		this.y += this.vy;

		this.vx *= DAMP;
		this.vy *= DAMP;

		this.vx = this.x < 50 ? this.vx * -1 : this.x > 1200 ? this.vx
				* -1 : this.vx;
		this.vy = this.y < 50 ? this.vy * -1 : this.y > 600 ? this.vy
				* -1 : this.vy;
		this.x = this.x < 0 ? game.getWindowSize().width
				: this.x > game.getWindowSize().width ? 0 : this.x;
		this.y = this.y < 0 ? game.getWindowSize().height
				: this.y > game.getWindowSize().height ? 0 : this.y;

		//trace('After move x = ${this.x}, y = ${this.y}');
		return new Point(this.x, this.y);
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