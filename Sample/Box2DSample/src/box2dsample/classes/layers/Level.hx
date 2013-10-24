package box2dsample.classes.layers;
import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2dsample.classes.maps.TiledMeadow;
import box2dsample.classes.sprites.Background;
import box2dsample.classes.sprites.Hedgehog;
import box2dsample.Game;
import cc.layersscenestransitionsnodes.CCLayer;
import box2dsample.classes.sprites.Snail;
import box2D.dynamics.B2Body;
import cc.CCDirector;
import cc.cocoa.CCGeometry;
import cc.tilemapparallaxnodes.CCTMXObject;
import cc.tilemapparallaxnodes.CCTMXObjectGroup;
import cc.touchdispatcher.CCPointer;
import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.input.Key;
/**
 * ...
 * @author Ang Li(李昂)
 */

 typedef Arrows = {
	public var left : Bool;
	public var right : Bool;
	public var up : Bool;
	public var down : Bool;
 }
 
 
class Level extends CCLayer
{
	public var snails : Array<Snail>;
	public var numberOfSnails : Int = 0;
	public var snailsBodies : Array<B2Body>;
	public var snailToRemove : Int;
	public var hedgehogBody : B2Body;
	public var keyboardArrows : Arrows;
	public var game : Game;
	public var tiledMap : TiledMeadow; 
	public var hedgehog : Hedgehog;
	public var background : Background;
	var isUpdate : Bool = false;
	public function new() 
	{
		super();
		trace("classes.layers.Level.ctor()");
		
		game = Game.getInstance();
		this.setKeyboardEnabled(true);
		//this.addExitAppButton();
		var that = this;
		this.snails = [];
		this.numberOfSnails = 0;

		this.snailToRemove = -1;

		this.snailsBodies = []; // box2dweb snail body
		//this.hedgehogBody = new B2Body(); // box2dweb hedgehog body
		this.keyboardArrows = {
			left : false,
			right : false,
			up : false,
			down : false
		};

		this.initTiledMap();
		this.initSnails();
		this.initBox2d();
		var size : CCSize = CCDirector.getInstance().getWinSize();

		// Timeout
		//var timeDisplayer = document.getElementById("timeLeft");
		//timeDisplayer.innerHTML = this.timer(game.config.timeout);

		//game.startCountdown(function(time) {
			//timeDisplayer.innerHTML = that.timer(game.config.timeout);
		//});
//
		//this.scheduleUpdate();
		
		isUpdate = true;
	}
	
	public function updateBox2d(wor : B2World) {
		wor.step(1 / 60, 10, 10);
		//wor.DrawDebugData();
		wor.clearForces();
	}
	
	override public function update(dt:Float)
	{
		if (!isUpdate) {
			return;
		}
		updateBox2d(game.getBox2dWorld());
		var that = this;
		this.moveAndCheckForObstacles(this.hedgehog, dt);
		
		for (snail in snails) {
			that.moveAndCheckForObstacles(snail, dt);
		}

		 //set new box2dweb bodies positions
		this.hedgehogBody
				.setPosition(new B2Vec2(
						this.hedgehog.getX() / game.config.box2dScale,
						game.config.heightInMeters
								- (this.hedgehog.getY() / game.config.box2dScale)));

		for ( i in 0...this.snails.length) {
			this.snailsBodies[i]
					.setPosition(new B2Vec2(
							this.snails[i].getX()
									/ game.config.box2dScale,
							game.config.heightInMeters
									- (this.snails[i].getY() / game.config.box2dScale)));
		}

		if (this.snailToRemove != -1) {
			this.removeSnail(this.snailToRemove);
			this.snailToRemove = -1;
		}
	}
	
	/**
	 * Initializes static sprite as a background
	 */
	public function initBackground() {
		this.background = new Background();
		this.addChild(this.background, -9);
	}

	public function initTiledMap() {
		this.tiledMap = new TiledMeadow();
		this.addChild(this.tiledMap, -8);

		var objectGroup = this.tiledMap.getObjectGroup("hedgehog");
		var startPoint = objectGroup.objectNamed("StartPosition");

		this.hedgehog = new Hedgehog();
		this.hedgehog.setPosition(0, 0);
				//startPoint.y);
		if (!game.config.box2dDebug)
			this.addChild(this.hedgehog, 2);
	}

	public function initSnails() {
		if (this.tiledMap != null) {
			var objectGroupSnails : CCTMXObjectGroup = this.tiledMap
					.getObjectGroup("snails");
			var objectSnails : Array<CCTMXObject>= objectGroupSnails.getObjects();
			this.numberOfSnails = objectSnails.length;
			var that = this;
			
			for (objectSnail in objectSnails) {
				var snail = new Snail();
				snail.setPosition(objectSnail.x,
						objectSnail.y);
				that.snails.push(snail);
				if (!game.config.box2dDebug)
					that.addChild(snail, 1);
			}
		}
	}

	public function initBox2d() {

		// canvas width and height in meters
		var height = game.getWindowSize().height
				/ game.config.box2dScale;
		var width = game.getWindowSize().height
				/ game.config.box2dScale;

		var fixDef : B2FixtureDef = new B2FixtureDef();
		fixDef.density = 1.0;
		fixDef.friction = 0.5;
		fixDef.restitution = 0.2;
		fixDef.isSensor = true;

		var bodyDef : B2BodyDef = new B2BodyDef();

		bodyDef.type = B2Body.b2_dynamicBody;

		// create hedgehog
		fixDef.shape = new B2CircleShape(
				height / 45);
		bodyDef.position.x = width / 2;
		bodyDef.position.y = -height / 2;
		this.hedgehogBody = game.getBox2dWorld().createBody(bodyDef);
		this.hedgehogBody.setUserData("hedgehog");
		this.hedgehogBody.createFixture(fixDef);

		// create snails
		for (i in 0...this.snails.length) {

			var ptmRatio : Float = height / 22;// scale snail shape to graphics
			// size on the screen
			var v = [ [ -0.537508 * ptmRatio, -0.40000 * ptmRatio ],
					[ 0.35833 * ptmRatio, -0.36250 * ptmRatio ],
					[ 0.52500 * ptmRatio, 0.37083 * ptmRatio ],
					[ -0.42917 * ptmRatio, 0.37500 * ptmRatio ] ];// vector
			// defining shape of the snail, coordinates determined using
			// Andengine Vertex Helper tool

			var vecs = [];
			for (j in 0...v.length) {
				var temp = new B2Vec2();
				temp.set(v[j][0], v[j][1]);
				vecs[j] = temp;
			}
			var shape : B2PolygonShape = new B2PolygonShape();
			fixDef.shape = shape;
			shape.setAsArray(vecs, vecs.length);

			bodyDef.position.x = this.snails[i].getX()
					/ game.config.box2dScale;
			bodyDef.position.y = game.config.heightInMeters
					- this.snails[i].getY() / game.config.box2dScale;
			var snail = game.getBox2dWorld().createBody(bodyDef);
			snail.setUserData("snail");
			snail.createFixture(fixDef);
			this.snailsBodies.push(snail);
		}

		// setup debug draw
		//game.setBox2dDebug();

		//window.setInterval(this.updateBox2d, 1000 / 120, game
				//.getBox2dWorld());

		// Add listeners for contact
		var listener : B2ContactListener = new LayerContact(this);

		var that = this;

		//listener.beginContact = function(contact) {
//
			//if ((contact.getFixtureA().GetBody().GetUserData() == 'hedgehog' && contact
					//.GetFixtureB().GetBody().GetUserData() == 'snail')
					//|| (contact.GetFixtureA().GetBody().GetUserData() == 'snail' && contact
							//.GetFixtureB().GetBody().GetUserData() == 'hedgehog')) {
//
				//for ( var i = 0; i < this.snailsBodies.length; i++) {
					// check if it is a snail-hedgehog collision (if
					// yes, remove the snail)
					//if (that.snailsBodies[i] === contact.GetFixtureA()
							//.GetBody()
							//|| that.snailsBodies[i] === contact
									//.GetFixtureB().GetBody()) {
						//that.snailToRemove = i;
					//}
				//}
//
			//}
		//}

		game.getBox2dWorld().setContactListener(listener);
	}

	public function removeSnail(index : Int) {
		/**
		 * TODO: Sound effects temporary turned off
		 */
		// game.getAudio().playEffect("sounds/splat");
		this.removeChild(this.snails[index]);
		this.numberOfSnails--;
		this.snails.splice(index, 1);
		game.getBox2dWorld().destroyBody(this.snailsBodies[index]);
		//this.removeChild(this.snailsBodies[index]);
		this.snailsBodies.splice(index, 1);
		if (this.numberOfSnails == 0) {
			//alert("You win!");
			game.changeScene(game.getScene('intro'));
			//game.stopCountdown();
			//this.removeCounter();
		}
	}

	public function isCollisionInArray(item : Rectangle, array : Array<Rectangle>) : Bool{
		
		for (i in 0...array.length) {
			if (CCGeometry.rectIntersectsRect(item, array[i])) {
				return true;
			}
		}
		return false;
	}

	public function moveAndCheckForObstacles(object : Dynamic, dt : Float ) {
		var newPosition : Point;
		if (Std.is(object, Hedgehog)) {
			var h : Hedgehog = cast(object, Hedgehog);
			newPosition = h.move(dt, this.keyboardArrows);
			
			var newReactangle = new Rectangle(newPosition.x + 2 - h.width/ 2, newPosition.y + 2 - h.height / 2, h.width - 4, h.height - 4);
			//trace(newPosition);
			if (!this.isCollisionInArray(newReactangle, this.tiledMap.obstacles)) {
				//trace("no collision");
				h.setPosition(newPosition.x, newPosition.y);
			} else {
				//trace("collision");
			}
		} else {
			var s : Snail = cast(object, Snail);
			newPosition = s.move();
			
			var newReactangle = new Rectangle(newPosition.x + 2 - s.width
				/ 2, newPosition.y + 2 - s.height / 2,
				s.width - 4, s.height - 4);
			if (!this.isCollisionInArray(newReactangle,
					this.tiledMap.obstacles)) {
				s.setPosition(newPosition.x, newPosition.y);
			}
		}
		//var newPosition = object.move(dt, this.keyboardArrows);
		
	}

	override public function onKeyDown(event:KeyboardEvent)
	{
		//trace(event.key);
		switch (event.key) {
		case Key.Left:
			this.keyboardArrows.left = true;
		case Key.Up:
			this.keyboardArrows.up = true;
		case Key.Right:
			this.keyboardArrows.right = true;
		case Key.Down:
			this.keyboardArrows.down = true;
			
		default:
			null;
		}
	}
	
	override public function onKeyUp(event:KeyboardEvent) 
	{
		//trace(event.key);
		switch (event.key) {
		case Key.Left:
			this.keyboardArrows.left = false;
		case Key.Up:
			this.keyboardArrows.up = false;
		case Key.Right:
			this.keyboardArrows.right = false;
		case Key.Down:
			this.keyboardArrows.down = false;
			
		default:
			null;
		}
	}

	public function removeCounter() {
		//var timeDisplayer = document.getElementById("timeLeft");
		//timeDisplayer.innerHTML = '';
	}

	public function cleanGameObjects() {
		for (i in 0...this.snails.length) {
			this.removeChild(this.snails[i]);
			game.getBox2dWorld().destroyBody(this.snailsBodies[i]);
			//this.removeChild(this.snailsBodies[i]);
		}
		game.getBox2dWorld().destroyBody(this.hedgehogBody);
	}
	
	override public function onPointerDown(event:CCPointer):Bool 
	{
		var pos : Point = event.getLocation();
		
		
		if (pos.y <= 100) {
			this.keyboardArrows.up = true;
		} else if(pos.y > 300){
			this.keyboardArrows.down = true;
		} else if (pos.x < 100) {
			this.keyboardArrows.left = true;
		} else if (pos.x > 220) {
			this.keyboardArrows.right = true;
		}
		return true;
	}
	
	override public function onPointerUp(event:CCPointer):Bool 
	{
		this.keyboardArrows.up = false;
		this.keyboardArrows.down = false;
		this.keyboardArrows.left = false;
		this.keyboardArrows.right = false;
		
		return true;
	}
}