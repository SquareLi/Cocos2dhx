package tests;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.CCDirector;
import cc.cocoa.CCGeometry;
import box2D.dynamics.B2Body;
import cc.spritenodes.CCSpriteBatchNode;
import cc.touchdispatcher.CCPointer;
import flambe.display.FillSprite;
import flambe.input.PointerEvent;
import flambe.math.Point;
import cc.spritenodes.CCSprite;
import flambe.math.Rectangle;
import cc.layersscenestransitionsnodes.CCScene;
import cc.platform.CCMacro;
import flambe.System;
/**
 * ...
 * @author Ang Li(李昂)
 */
class TestBox2D extends CCLayer
{

	public static var TAG_SPRITE_MANAGER : Int = 1;
	public static var PTM_RATIO : Int = 32;
	var world : B2World;
	public function new() 
	{
		super();
		this.setPointerEnabled(true);
		//var b2Vec2 : B2Vec2 = new B2Vec2
		var screenSize : CCSize = CCDirector.getInstance().getWinSize();
		
		this.world = new B2World(new B2Vec2(0, 10), true);
		this.world.setContinuousPhysics(true);
		
		var fixDef : B2FixtureDef = new B2FixtureDef();
		fixDef.density = 1.0;
		fixDef.friction = 0.5;
		fixDef.restitution = 0.2;
		
		var bodyDef : B2BodyDef = new B2BodyDef();
		
		bodyDef.type = B2Body.b2_staticBody;
		var s : B2PolygonShape = new B2PolygonShape();
		fixDef.shape = s;
		s.setAsBox(20, 2);
		
		bodyDef.position.set(5, screenSize.height / PTM_RATIO + 1.8);
		//trace(screenSize.height / PTM_RATIO + 1.8);
		var body : B2Body = this.world.createBody(bodyDef);
		body.createFixture(fixDef);
		
		var f : FillSprite = new FillSprite(0x123456, 20 * PTM_RATIO, 2 * PTM_RATIO);
		f.x._ = body.getPosition().x * PTM_RATIO;
		f.y._ = body.getPosition().y * PTM_RATIO;
		trace(f.x._);
		trace(f.y._);
		
		//System.root.add(f);
		 // bottom
        //bodyDef.position.set(10, -1.8);
        //this.world.createBody(bodyDef).createFixture(fixDef);
//
        //s.setAsBox(2, 14);
		//
		//var f : FillSprite = new FillSprite(0x123456, 
		
        // left
        //bodyDef.position.set(-1.8, 13);
        //this.world.createBody(bodyDef).createFixture(fixDef);

        // right
        //bodyDef.position.set(26.8, 13);
        //this.world.createBody(bodyDef).createFixture(fixDef);
		
		//Set up sprite

        var mgr = CCSpriteBatchNode.create("blocks", 150);
        this.addChild(mgr, 0, TAG_SPRITE_MANAGER);

        this.addNewSpriteWithCoords(new Point(screenSize.width / 2, screenSize.height / 2));

        //var label = cc.LabelTTF.create("Tap screen", "Marker Felt", 32);
        //this.addChild(label, 0);
        //label.setColor(cc.c3b(0, 0, 255));
        //label.setPosition(cc.p(screenSize.width / 2, screenSize.height - 50));

        //this.scheduleUpdate();
		
	}
	
	override public function update(dt:Float)
	{
		//It is recommended that a fixed time step is used with Box2D for stability
        //of the simulation, however, we are using a variable time step here.
        //You need to make an informed choice, the following URL is useful
        //http://gafferongames.com/game-physics/fix-your-timestep/

        var velocityIterations : Int = 8;
        var positionIterations : Int = 1;

        // Instruct the world to perform a single step of simulation. It is
        // generally best to keep the time step and iterations fixed.
        this.world.step(dt, velocityIterations, positionIterations);

        //Iterate over the bodies in the physics world
		var b : B2Body = this.world.getBodyList();
		while ( b != null) {
        //for (var b = this.world.GetBodyList(); b; b = b.GetNext()) {
            if (b.getUserData() != null) {
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                var myActor : CCSprite = b.getUserData();
                myActor.setPosition(b.getPosition().x * PTM_RATIO, b.getPosition().y * PTM_RATIO);
                myActor.setRotation(-1 * CCMacro.RADIANS_TO_DEGREES(b.getAngle()));
                //console.log(b.GetAngle());
				
				//trace("loop");
				//trace(b.getPosition().y);
            }
			b = b.getNext();
			//trace("loop while");
        }

	}
	
	public function addNewSpriteWithCoords(p : Point) {
		//UXLog(L"Add sprite %0.2f x %02.f",p.x,p.y);
        var batch : CCSpriteBatchNode = cast (this.getChildByTag(TAG_SPRITE_MANAGER), CCSpriteBatchNode);

        //We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
        //just randomly picking one of the images
        var idx = (Math.random() > .5 ? 0 : 1);
        var idy = (Math.random() > .5 ? 0 : 1);
        var sprite = CCSprite.createWithTexture(batch.getTexture(), new Rectangle(32 * idx, 32 * idy, 32, 32));
        batch.addChild(sprite);

        sprite.setPosition(p.x, p.y);

        // Define the dynamic body.
        //Set up a 1m squared box in the physics world

        var bodyDef : B2BodyDef = new B2BodyDef();
        bodyDef.type = B2Body.b2_dynamicBody;
        bodyDef.position.set(p.x / PTM_RATIO, p.y / PTM_RATIO);
        bodyDef.userData = sprite;
        var body : B2Body = this.world.createBody(bodyDef);

        // Define another box shape for our dynamic body.
        var dynamicBox : B2PolygonShape = new B2PolygonShape();
        dynamicBox.setAsBox(0.5, 0.5);//These are mid points for our 1m box

        // Define the dynamic body fixture.
        var fixtureDef : B2FixtureDef = new B2FixtureDef();
        fixtureDef.shape = dynamicBox;
        fixtureDef.density = 1.0;
        fixtureDef.friction = 0.3;
        body.createFixture(fixtureDef);
	}
	
	override public function onPointerUp(event:CCPointer):Bool 
	{
		var location = event.getLocation();
		this.addNewSpriteWithCoords(location);
		return true;
	}
	
	public static function run() {
		var scene : CCScene = CCScene.create();
		var l : TestBox2D = new TestBox2D();
		scene.addChild(l);
		var d : CCDirector = CCDirector.getInstance();
		d.runWithScene(scene);
	}
}