package ;
import cc.spritenodes.CCSprite;
import flambe.math.Point;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Shape;
import nape.space.Space;
import nape.phys.BodyType;
import nape.shape.Polygon;
import cc.cocoa.CCGeometry;
import cc.platform.CCMacro;
import flambe.math.FMath;

/**
 * ...
 * @author Ang Li(李昂)
 */
class CPSprite extends CCSprite
{

	public static var space : Space = new Space(new Vec2(0, 750));
	public var body : Body;
	public var shape : Polygon;
	public function new(filename : String, pos : Point, ?mass : Float, ?elasticity : Float, ?friction : Float) 
	{
		super();
		this.initWithFile(filename);
		mass = (mass != null) ? mass : 5;
		
		
		var bodyLocal : Body = new Body(BodyType.DYNAMIC);
		bodyLocal.position = new Vec2(pos.x, pos.y);
		bodyLocal.space = space;
		
		var poly : Polygon = new Polygon(Polygon.box(this.getContentSize().width, this.getContentSize().height), new Material(elasticity, friction, friction));
		bodyLocal.mass = mass;
		bodyLocal.shapes.add(poly);
		
		this.body = bodyLocal;
		this.shape = poly;	
	}
	
	override public function update(dt:Float)
	{
		if (this.body != null) {
			var pos : Vec2 = this.body.position;
			this.setPosition(pos.x, pos.y);
			this.setRotation(CCMacro.RADIANS_TO_DEGREES( this.body.rotation));
			//trace(this.getSprite().anchorX);
			//trace(this.body.rotation);
			//trace(CCMacro.RADIANS_TO_DEGREES( this.body.rotation));
			//FMath.toDegrees
		} else {
			trace("no body?");
		}
		super.update(dt);
	}
	
}