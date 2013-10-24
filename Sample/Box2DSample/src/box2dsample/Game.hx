package box2dsample;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2World;
import cc.denshion.CCAudioEngine;
import cc.extensions.ccbreader.CCSpriteLoader;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCDirector;
import cc.cocoa.CCGeometry;
/**
 * ...
 * @author Ang Li(李昂)
 */

typedef Config = {
	public var cocos2d : Cocos2d;
	public var width : Int;
	public var height : Int;
	public var useSensor : Bool;
	public var debug : Bool;
	public var box2dDebug : Bool;
	public var box2dScale : Float;
	public var timeout : Float;
	public var widthInMeters : Float;
	public var heightInMeters : Float;
}

typedef Cocos2d = {
	public var COCOS2D_DEBUG : Int;
	public var box2d : Bool;
	public var frameRate : Int;
	public var tag : String;
}


class Game
{
	var initialTimeout : Float;
	var audio : CCAudioEngine;
	var world : B2World;
	var scenes : Map<String, CCScene>;
	public var config : Config;
	public function new() 
	{
		audio = CCAudioEngine.getInstance();
		world = new B2World(new B2Vec2(0, 0), false);
		scenes = new Map<String ,CCScene>();
		
		var cc2d : Cocos2d = { 
			COCOS2D_DEBUG : 2, // 0 to turn debug off, 1 for basic debug,
                // and 2 for full debug
			box2d : true,
			frameRate : 60,
			tag : 'gameCanvas' // the dom element to run cocos2d on
		}
		
		config = { 
			cocos2d : cc2d,
			width : 1260,
            height : 660,
            useSensor : true,
            debug : false,
            box2dDebug : false, // Box2d debug mode flag
            box2dScale : 30, // scale for Box2d debug mode
            timeout : 30,
			widthInMeters : 0,
			heightInMeters : 0
		};
			
	}
	
	public function getScene(scene : String) : CCScene {
		return scenes[scene];
	}
	
	public function setScene(name : String, scene : CCScene) {
		scenes[name] = scene;
	}
	
	public function initialize() {
		//tizen.logger = tizen.logger({
                //logLevel : 3
		//});
		//tizen.logger.info("game.initialize()");
		//tizen.view.getScreenWidth();
		//tizen.view.getScreenHeight();
		//audio.init("mp3,ogg");
		//power.setScreen(power.getPowerState().SCREEN_BRIGHT);
		//if (!this.config.box2dDebug) {
			//$('#box2d').css('visibility', 'hidden');
		//}
		this.config.widthInMeters = this.config.width
				/ this.config.box2dScale;
		this.config.heightInMeters = this.config.height
				/ this.config.box2dScale;
	}
	
	public function getRandomXPosition() : Int {
		return Math.floor((Math.random() * this.config.width));
	}
	
	public function getRandomYPosition() : Int {
		return Math.floor((Math.random() * this.config.height));
    }
	
	public function changeScene(scene : CCScene) {
		CCDirector.getInstance().replaceScene(scene);
	}
	
	public function getWindowSize() : CCSize {
		return new CCSize(1260, 660);
	}
	
	public function getAudio() : CCAudioEngine {
		return audio;
	}
	
	public function start() {
		trace("game.start()");
		//application = new classes.Application(classes.scenes.Intro);
	}
	
	//stopCountdown : function() {
		//clearInterval(intPtr);
		//this.getScene('level').levelLayer.cleanGameObjects();
		//this.config.timeout = initialTimeout;
	//}
	//
	//startCountdown : function(callback) {
		//var that = this;
		//initialTimeout = that.config.timeout;
		//intPtr = setInterval(function() {
			//callback(--that.config.timeout);
			//if (that.config.timeout === 0) {
				//that.stopCountdown();
				//alert("Game over... Please try again...");
				//that.getScene('level').levelLayer.removeCounter();
				//that.changeScene(that.getScene('intro'));
			//}
		//}, 1000);
	//},
	
	public function getBox2dWorld() : B2World {
		return world;
	}
	
	public function updateBox2dWeb() {
		world.step(1 / 60, 10, 10);
		//world.drawDebugData();
		world.clearForces();
	}
	
	//setBox2dDebug : function() {
		//if (this.config.box2dDebug) {
			//var b2DebugDraw = Box2D.Dynamics.b2DebugDraw;
			//var debugDraw = new b2DebugDraw();
			//debugDraw.SetSprite(document.getElementById("box2d")
					//.getContext("2d"));
			//debugDraw.SetDrawScale(this.config.box2dScale);
			//debugDraw.SetFillAlpha(1);
			//debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			//world.SetDebugDraw(debugDraw);
		//}
	//}
	
	public static var game : Game = null;
	public static function getInstance() : Game {
		if (game == null) {
			game = new Game();
		}
		
		return game;
	}
	
}