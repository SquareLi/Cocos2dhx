package box2dsample.classes.layers;
import box2dsample.Game;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.spritenodes.CCSprite;
import cc.CCDirector;
import cc.cocoa.CCGeometry;
import cc.menunodes.CCMenuItem;
import cc.spritenodes.CCSpriteFrame;
import box2dsample.classes.scenes.LevelScene;
import cc.menunodes.CCMenu;
import cc.action.CCActionInterval;
import cc.action.CCActionEase;
/**
 * ...
 * @author Ang Li(李昂)
 */
class Intro extends CCLayer
{
	var isMouseDown : Bool = false;
	var logo : CCSprite;
	var game : Game;
	public function new() 
	{
		super();
		trace("classes.layers.Intro.ctor()");
		game = Game.getInstance();
		//this.addExitAppButton();

		// ask director the window size
		var size : CCSize = CCDirector.getInstance().getWinSize();

		
		var about : CCMenuItemImage = CCMenuItemImage.create("images/forward",
				"images/forward", null, function() {
					var level = new box2dsample.classes.scenes.LevelScene();
					game.setScene('level', level);
					game.changeScene(level);
				}, this);
		var menuNext = CCMenu.create([about]);
		menuNext.setPosition(size.width - 100, 350);

		var background = CCSprite.create("images/splash/bg");
		background.setPosition(
				game.getWindowSize().width / 2,
				game.getWindowSize().height / 2);

		var hedgehog = CCSprite.create("images/splash/hedgehog");
		hedgehog.setPosition(
				200 + game.getWindowSize().width / 2, (game
						.getWindowSize().height / 2) - 150);

		var snail = CCSprite.create("images/splash/snail");
		snail.setPosition(
				(game.getWindowSize().width / 2) - 200, (game
						.getWindowSize().height / 2) - 150);

		this.logo = CCSprite.create("images/splash/logo");
		this.logo.setPosition(
				(game.getWindowSize().width / 2) - 100, (game
						.getWindowSize().height / 2) + 70);

		this.setPointerEnabled(true);

		// adds layers/sprites to this layer in given order
		this.addChild(background, 0);
		this.addChild(menuNext, 1);
		this.addChild(hedgehog, 3);
		this.addChild(snail, 4);
		this.addChild(this.logo, 2);

		//return true;
	}
	
	public function adjustSizeForWindwo() {
		
	}
	override public function onEnter()
	{
		//this.logo.setScale(0.1);
		//this.logo.runAction(CCSequence.create([CCEaseElasticOut
                        //.create(CCScaleTo.create(2, 1, 1), 0.5)]));
		//setTimeout(function() {
			//var level = new classes.scenes.Level();
			//game.setScene('level', level);
			//game.changeScene(level);
		//}, 3000);
	}
	
}