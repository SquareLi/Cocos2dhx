package ;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCScene;
import flambe.math.Point;
import nape.constraint.AngleJoint;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.dynamics.InteractionGroup;
import nape.geom.Vec2;
import cc.platform.CCMacro;

/**
 * ...
 * @author Ang Li(李昂)
 */
class Grossini
{
	public static var num : Int = 1;
	public var heads : Array<Int>;
	public var head : CPSprite;
	public var leftArm : CPSprite;
	public var rightArm : CPSprite;
	public var body : CPSprite;
	public var leftLeg : CPSprite;
	public var rightLeg : CPSprite;
	public function new(pos : Point) 
	{
		heads = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		var ran : Int = 0;
		if (Grossini.num < 10) {
			ran = heads[Grossini.num - 1];
		} else {
			ran = 0 | Std.int(Math.random() * heads.length);
		}
		
		this.head = new CPSprite('res/head' + ran, new Point(pos.x, pos.y - 35.5), 15, 1.4, 0.2);
		this.body = new CPSprite('res/body', pos, 12, 1, 0.5);
        this.leftArm = new CPSprite('res/leftarm', new Point(pos.x - 29.87, pos.y - 11), 2, 1.4, 0.2);
        this.rightArm = new CPSprite('res/rightarm', new Point(pos.x + 29.87, pos.y - 11), 2,1.4,0.2);
        this.leftLeg = new CPSprite('res/leftleg', new Point(pos.x - 7, pos.y + 32), 5, 1.4, 0);
        this.rightLeg = new CPSprite('res/rightleg', new Point(pos.x + 7, pos.y + 32), 15,1.4,0);

        //this.head.shape = Grossini.num;
        //this.leftArm.shape.group = Grossini.num;
        //this.rightArm.shape.group = Grossini.num;
        //this.body.shape.group =Grossini.num;
        //this.leftLeg.shape.group =Grossini.num;
        //this.rightLeg.shape.group = Grossini.num;
		
		var group : InteractionGroup = new InteractionGroup();
		this.head.body.group = group;
		this.body.body.group = group;
		this.leftArm.body.group = group;
		this.leftLeg.body.group = group;
		this.rightArm.body.group = group;
		this.rightLeg.body.group = group;

        this.leftArm.setRotation(90);
        this.leftArm.body.rotation = (CCMacro.DEGREES_TO_RADIANS(90));

        this.rightArm.setRotation(-90);
        this.rightArm.body.rotation = (CCMacro.DEGREES_TO_RADIANS(-90));


		var pivotJoint1 : PivotJoint = 
			new PivotJoint(this.body.body, this.head.body, this.body.body.worldPointToLocal(new Vec2(pos.x, pos.y - 23)), this.head.body.worldPointToLocal(new Vec2(pos.x, pos.y - 23)));
		format(pivotJoint1);

	
		
		
		var pivotJoint2 : PivotJoint = new PivotJoint(this.body.body, this.leftArm.body, this.body.body.worldPointToLocal(new Vec2(pos.x - 13.5, pos.y - 11)), this.leftArm.body.worldPointToLocal(new Vec2(pos.x - 13.5, pos.y - 11)));
		var aj2 : AngleJoint = new AngleJoint(this.body.body, this.leftArm.body, CCMacro.DEGREES_TO_RADIANS(-20), CCMacro.DEGREES_TO_RADIANS(180));
		format(pivotJoint2);
		format(aj2);

		var pivotJoint3 : PivotJoint = new PivotJoint(this.body.body, this.rightArm.body, this.body.body.worldPointToLocal(new Vec2(pos.x + 13.5, pos.y - 11)), this.rightArm.body.worldPointToLocal(new Vec2(pos.x + 13.5, pos.y - 11)));
		var aj3 : AngleJoint = new AngleJoint(this.body.body, this.rightArm.body, CCMacro.DEGREES_TO_RADIANS(-180), CCMacro.DEGREES_TO_RADIANS(20));
		format(pivotJoint3);
		format(aj3);

		
		var pivotJoint4 : PivotJoint = new PivotJoint(this.body.body, this.leftLeg.body, this.body.body.worldPointToLocal(new Vec2(pos.x - 6.5, pos.y + 16)), this.leftLeg.body.worldPointToLocal(new Vec2(pos.x - 6.5, pos.y + 16)));
		var aj4 : AngleJoint = new AngleJoint(this.body.body, this.leftLeg.body, CCMacro.DEGREES_TO_RADIANS(-20), CCMacro.DEGREES_TO_RADIANS(70));
		format(pivotJoint4);
		format(aj4);

		var pivotJoint5 : PivotJoint = new PivotJoint(this.body.body, this.rightLeg.body, this.body.body.worldPointToLocal(new Vec2(pos.x + 6.5, pos.y + 16)), this.rightLeg.body.worldPointToLocal(new Vec2(pos.x + 6.5, pos.y + 16)));
		pivotJoint5.space = CPSprite.space;
		var aj5 : AngleJoint = new AngleJoint(this.body.body, this.rightLeg.body, CCMacro.DEGREES_TO_RADIANS(-70), CCMacro.DEGREES_TO_RADIANS(20));
		format(pivotJoint5);
		format(aj5);
		
		//var a : AngleJoint = new AngleJoint(
		
		
        //space.addConstraint(new cp.PivotJoint(this.body.body, this.head.body, cp.v.add(cp.v(pos.x,pos.y),cp.v(-0.01, 23.0))));
        //Space.addConstraint(new cp.DampedRotarySpring(this.body.body, this.head.body, 0, 1000000, 0));
//
        //Space.addConstraint(new cp.PivotJoint(this.body.body, this.leftArm.body, cp.v.add(cp.v(pos.x,pos.y),cp.v(-13.5,11))));
        //Space.addConstraint(new cp.RotaryLimitJoint(this.body.body, this.leftArm.body, cc.DEGREES_TO_RADIANS(-180), cc.DEGREES_TO_RADIANS(20)));
//
        //Space.addConstraint(new cp.PivotJoint(this.body.body, this.rightArm.body, cp.v.add(cp.v(pos.x,pos.y),cp.v(13.5,11))));
        //Space.addConstraint(new cp.RotaryLimitJoint(this.body.body, this.rightArm.body, cc.DEGREES_TO_RADIANS(-20), cc.DEGREES_TO_RADIANS(180)));
//
        //Space.addConstraint(new cp.PivotJoint(this.body.body, this.leftLeg.body, cp.v.add(cp.v(pos.x,pos.y),cp.v(-6.5,-16))));
        //Space.addConstraint(new cp.RotaryLimitJoint(this.body.body, this.leftLeg.body, cc.DEGREES_TO_RADIANS(-70), cc.DEGREES_TO_RADIANS(20)));
        //Space.addConstraint(new cp.DampedRotarySpring(this.body.body, this.leftLeg.body, cc.DEGREES_TO_RADIANS(13), 500000, 10));
//
//
        //Space.addConstraint(new cp.PivotJoint(this.body.body, this.rightLeg.body, cp.v.add(cp.v(pos.x,pos.y),cp.v(6.5,-16))));
        //Space.addConstraint(new cp.RotaryLimitJoint(this.body.body, this.rightLeg.body, cc.DEGREES_TO_RADIANS(-20), cc.DEGREES_TO_RADIANS(70)));
        //Space.addConstraint(new cp.DampedRotarySpring(this.body.body, this.rightLeg.body, cc.DEGREES_TO_RADIANS(-13), 500000, 10));




        Grossini.num++;
		
	}
	
	public function spawn(layer : CCLayer){
        //spawn at this location
		layer.addChild(this.body);
        layer.addChild(this.head);
        layer.addChild(this.leftLeg);
        layer.addChild(this.rightLeg);
        layer.addChild(this.leftArm);
        layer.addChild(this.rightArm);
    }
	
	public function format(c : Constraint) {
		c.stiff = false;
		//c.
		c.frequency = 20;
		c.damping = 1;
		c.space = CPSprite.space;
	}
}