package sample;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.spritenodes.CCSprite;
import flambe.input.PointerEvent;
import flambe.math.Point;
import cc.menunodes.CCMenuItem;
import cc.menunodes.CCMenu;
import cc.labelnodes.CCLabelBMFont;
import flambe.math.Rectangle;
import sample.config.GameConfig;
import cc.denshion.CCAudioEngine;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCDirector;
/**
 * ...
 * @author Ang Li
 */
class GameOver extends CCLayer
{

	public function new() 
	{
		super();
	}
	
	override public function init():Bool 
	{
		var bRet : Bool = false;
		if (super.init()) {
			var sp = CCSprite.create("Sample/loading");
			sp.setAnchorPoint(new Point(0, 0));
			this.addChild(sp, 0, 1);
			
			var logo = CCSprite.create("Sample/gameOver");
			logo.setAnchorPoint(new Point(0 , 0));
			logo.setPosition(0, 80);
			this.addChild(logo, 10, 1);
			
			var playAgainNormal = CCSprite.create("Sample/menu", new Rectangle(378, 0, 126, 33));
            var playAgainSelected = CCSprite.create("Sample/menu", new Rectangle(378, 33, 126, 33));
            var playAgainDisabled = CCSprite.create("Sample/menu", new Rectangle(378, 33 * 2, 126, 33));
			
			var cocos2dhtml5 = CCSprite.create("Sample/cocos2d-html5");
			cocos2dhtml5.setCenterAnchor();
			cocos2dhtml5.setPosition(160, 380);
			this.addChild(cocos2dhtml5, 10);
			var playAgain = CCMenuItemSprite.create(playAgainNormal, playAgainSelected, playAgainDisabled, function(){
                Effect.flareEffect(this,this,this.onPlayAgain);
            }, this);
			
			var menu = CCMenu.create([playAgain]);
			this.addChild(menu, 1, 2);
			menu.setPosition(97, 250);
			
			var lbScore = CCLabelBMFont.create("Your Score:" + GameConfig.SCORE, "Sample/arial-14");
			lbScore.setScale(2);
			lbScore.setCenterAnchor();
			lbScore.setPosition(160, 200);
			this.addChild(lbScore, 10);
			
			if (GameConfig.SOUND) {
				CCAudioEngine.getInstance().playMusic("Sample/Music/mainMainMusic");
			}
			bRet = true;
		}
		
		return bRet;
	}
	
	public function onPlayAgain() {
		var scene = CCScene.create();
		scene.addChild(GameLayer.create());
		CCDirector.getInstance().replaceScene(scene);
	}
	
	public static function create() : GameOver{
		var sg = new GameOver();
		if (sg != null && sg.init()) {
			return sg;
		}
		return null;
	}
}