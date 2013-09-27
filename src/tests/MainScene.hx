package tests;
import cc.basenodes.CCNode;
import cc.extensions.ccbreader.CCBAnimationManager;
import cc.extensions.ccbreader.CCSpriteLoader;
import cc.labelnodes.CCLabelBMFont;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.menunodes.CCMenu;
import cc.spritenodes.CCSprite;
import cc.action.CCActionInterval;
import flambe.math.Point;
import cc.extensions.ccbreader.CCBReader;
import cc.CCDirector;
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
		//trace("onDidLoadFromCCB");
		this.menuSelection = kMenuSelectionNone;
		this.lblLastScore.setString('$gLastScore');
		//this.rootNode = animationManager.getRootNode();
		
		this.rootNode.schedule(this.onUpdate, 0.005);
		
		//trace(menu.getPosition());
		//trace(menu.getContentSize());
		//trace(menu.getSprite().anchorY._);
		
		//menu.setPosition(0, 100);
	}
	@:keep public function onPressPlay() {
		this.menuSelection = kMenuSelectionPlay;
		//trace("onPressPlay");
	}
	
	@:keep public function onPressAbout() {
		//trace("onPressAbout");
		
		this.menu.setEnabled(false);
		
		var aboutNode : CCNode = CCBuilderReader.load("crystal/AboutScene.ccbi", null, null, "crystal/");
		//aboutNode.setPosition(170, 240);
		this.rootNode.addChild(aboutNode, 10);
		//trace("about");
	}
	
	@:keep public function onAnimationComplete() {
		//if (this.menuSelection == kMenuSelectionPlay)
		//{
			//var scene = CCBuilderReader.loadAsScene("GameScene.ccbi");
			//cc.Director.getInstance().replaceScene(scene);
			//gAudioEngine.stopMusic();
		//}
	}
	
	@:keep public function onUpdate() {
		var kGemSize : Float = 80;
		
		
		if (Math.random() < 0.02) {
			var type : Int = Math.floor(Math.random()*5);
			var sprt : CCSprite = CCSprite.create("crystal/crystals/" + Std.string(type));
			//var sprt = cc.Sprite.create("crystals/"+type+".png");
			//var p = cc.ParticleSystem.create("particles/falling-gem.plist");

			var x : Float = Math.random()*this.fallingGemsLayer.getContentSize().width;
			var y : Float = this.fallingGemsLayer.getContentSize().height + kGemSize/2;
			var scale : Float = 0.2 + 0.8 * Math.random();

			var speed = 2*scale*kGemSize/40;

			sprt.setPosition(x , this.fallingGemsLayer.getContentSize().height - y);
			sprt.setScale(scale);
			//trace(sprt.getPosition());

			//p.setPosition(cc.p(x,y));
			//p.setScale(scale);
			//p.setAutoRemoveOnFinish(true);

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

			if (pos.y > 400)
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