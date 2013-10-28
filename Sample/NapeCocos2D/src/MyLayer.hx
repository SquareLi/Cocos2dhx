package ;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.spritenodes.CCSprite;
import cc.touchdispatcher.CCPointer;
import flambe.math.Point;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.phys.BodyType;
import cc.CCDirector;

/**
 * ...
 * @author Ang Li(李昂)
 */
class MyLayer extends CCLayer
{
	public var isMouseDown : Bool = false;
	public var helloImg : CCSprite;
	
	public function new() 
	{
		super();
		var thickness : Float  = 50;
		this.setPointerEnabled(true);
		
		var floor : Polygon = new Polygon(Polygon.box(this.getContentSize().width, thickness), 
			new Material(1, 1, 1));
			
		var lwall : Polygon = new Polygon(Polygon.box(thickness, this.getContentSize().height), 
			new Material(1, 1, 1));
			
		var rwall : Polygon = new Polygon(Polygon.box(thickness, this.getContentSize().height), 
			new Material(1, 1, 1));
			
		var ceiling : Polygon = new Polygon(Polygon.box(this.getContentSize().width, thickness), 
			new Material(1, 1, 1));
		
		var floorBody : Body = new Body(BodyType.STATIC, new Vec2(this.getContentSize().width /2 , this.getContentSize().height + thickness));
		floorBody.shapes.add(floor);
		floorBody.space = CPSprite.space;
		
		var lwallBody : Body = new Body(BodyType.STATIC, new Vec2(-thickness, this.getContentSize().height / 2));
		lwallBody.shapes.add(lwall);
		lwallBody.space = CPSprite.space;
		
		var rwallBody : Body = new Body(BodyType.STATIC, new Vec2(this.getContentSize().width,  this.getContentSize().height / 2));
		rwallBody.shapes.add(rwall);
		rwallBody.space = CPSprite.space;
		
		var ceilingBody : Body = new Body(BodyType.STATIC, new Vec2(this.getContentSize().width /2, -thickness));
		ceilingBody.shapes.add(ceiling);
		ceilingBody.space = CPSprite.space;
		
		this.addPhysicsBody(new Point(this.getContentSize().width / 2, this.getContentSize().height / 2));
	}
	
	public function addPhysicsBody(pos : Point) {
		var box : CPSprite = new CPSprite("res/Icon", pos);
		this.addChild(box);
	}
	
	override public function onPointerUp(event:CCPointer):Bool 
	{
		this.addGrossini(event.getLocation());
		return true;
	}
	
	public var count : Int = 0;
	
	public function addGrossini(pos : Point) {
		if (this.count < 15) {
			var gros = new Grossini(pos);
			gros.spawn(this);
			this.count ++;
		}
	}
	
	override public function update(dt:Float)
	{
		super.update(dt);
		dt = dt > 0.2 ? 0.1 : dt;
		CPSprite.space.step(dt, 5, 5);
	}
	
	
	
}