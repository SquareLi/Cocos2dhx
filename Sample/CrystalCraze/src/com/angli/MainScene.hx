package com.angli;
import cc.basenodes.CCNode;
import cc.extensions.ccbreader.CCBAnimationManager;
import cc.extensions.ccbreader.CCSpriteLoader;
import cc.labelnodes.CCLabelBMFont;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.menunodes.CCMenu;
import cc.spritenodes.CCSprite;
import cc.action.CCActionInterval;
import flambe.display.Sprite;
import flambe.math.Point;
import cc.extensions.ccbreader.CCBReader;
import cc.CCDirector;
import cc.particlenodes.CCParticleSystem;
import cc.spritenodes.CCSpriteFrameCache;
import cc.layersscenestransitionsnodes.CCScene;
import flambe.System;
/**
 * ...
 * @author Ang Li
 */

@:keep class MainScene
{
	public static var kMenuSelectionNone : Int = 0;
	public static var kMenuSelectionPlay : Int = 1;
	public static var kMenuSelectionAbout : Int = 2;
	@:keep public var animationManager : CCBuilderAnimationManager;
	@:keep public var star : CCSprite;
	@:keep public var menu : CCMenu;
	@:keep public var lblLastScore : CCLabelBMFont;
	@:keep public var fallingGemsLayer : CCNode;
	@:keep public var starNode : CCNode;
	@:keep public var menuSelection : Int;
	@:keep public var gLastScore : Int = 0;
	@:keep public var rootNode : CCNode;
	@:keep public var fallingGems : Array<Gem>;
	
	
	public function new() 
	{
		star = null;
		fallingGems = new Array<Gem>();	
	}
	
	@:keep public function onDidLoadFromCCB() {
		//var starParticles = CCParticleSystem.create("crystal/particles/bg-stars");
		//this.starNode.addChild(starParticles);
		
		this.menuSelection = kMenuSelectionNone;
		this.lblLastScore.setString('$gLastScore');
		//this.rootNode = animationManager.getRootNode();
		
		this.rootNode.animationManager.setCompletedAnimationCallback(this, this.onAnimationComplete);
		
		this.rootNode.schedule(this.onUpdate, 0.01);
		
		// Load sprite sheets
		CCSpriteFrameCache.getInstance().addSpriteFrames("crystal/crystals.plist");
		
		//if (menu == null) {
			//trace("menu is null");
		//}
		
		
		//To resize the game to fit mobile safari.
		//If  you don't want to resize the game, just change the content size in index file to 320 * 480
		//and comment this part. 
		var s : Sprite = new Sprite();
		System.root.add(s);
		s.setScale(0.8);
		

	}
	@:keep public function onPressPlay() {
		this.menuSelection = kMenuSelectionPlay;
		this.rootNode.animationManager.runAnimationsForSequenceNamed("Outro");

		//gAudioEngine.playEffect("sounds/click.wav");

		// Fade out gems
		for (i in 0...this.fallingGems.length)
		{
			var gem = this.fallingGems[i];
			gem.sprt.runAction(CCFadeOut.create(0.5));
		}
		
	}
	
	@:keep public function onPressAbout() {
		this.menu.setEnabled(false);
		
		var aboutNode : CCNode = CCBuilderReader.load("crystal/AboutScene.ccbi", null, null, "crystal/");

		this.rootNode.addChild(aboutNode, 10);
	}
	
	@:keep public function onAnimationComplete() {
		if (this.menuSelection == kMenuSelectionPlay)
		{
			var scene : CCScene = CCBuilderReader.loadAsScene("crystal/GameScene.ccbi", null, null, "crystal/");
			CCDirector.getInstance().replaceScene(scene);
			//gAudioEngine.stopMusic();
		}
	}
	
	var isNull : Bool = false;
	@:keep public function onUpdate() {
		
		var kGemSize : Float = 80;
		
		
		if (Math.random() < 0.02) {
			var type : Int = Math.floor(Math.random()*5);
			var sprt : CCSprite = CCSprite.createWithSpriteFrameName("crystals/" + Std.string(type) + ".png");
			//var sprt = cc.Sprite.create("crystals/"+type+".png");
			//var p = cc.ParticleSystem.create("particles/falling-gem.plist");

			var x : Float = Math.random()*this.fallingGemsLayer.getContentSize().width;
			var y : Float = this.fallingGemsLayer.getContentSize().height + kGemSize/2;
			var scale : Float = 0.2 + 0.8 * Math.random();

			var speed = 2*scale*kGemSize/40;

			sprt.setPosition(x , this.fallingGemsLayer.getContentSize().height - y);
			sprt.setScale(scale);

			var gem = new Gem(speed, sprt);
			//var gem = {sprt:sprt, speed:speed, particle:p};
			this.fallingGems.push(gem);

			//this.fallingGemsLayer.addChild(p);
			this.fallingGemsLayer.addChild(sprt);
		}
		
		var i : Int = this.fallingGems.length - 1;
		while (i >= 0) {
			
			var gem : Gem = this.fallingGems[i];
			
			var pos : Point = gem.sprt.getPosition();
			pos.y += gem.speed;
			gem.sprt.setPosition(pos.x, pos.y);
			//trace('gem.y = ${pos.y}');
			//gem.particle.setPosition(pos);

			if (pos.y > 480)
			{
				this.fallingGemsLayer.removeChild(gem.sprt, true);
				//gem.particle.stopSystem();
				this.fallingGems.splice(i, 1);
			}
			
			i--;
		}
		
	}
}

class Gem {
	public var speed : Float;
	public var sprt : CCSprite;
	
	public function new(speed: Float, sprite : CCSprite) {
		this.speed = speed;
		this.sprt = sprite;
	}
}