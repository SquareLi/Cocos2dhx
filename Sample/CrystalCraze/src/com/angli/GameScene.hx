package com.angli;
import cc.action.CCAction;
import cc.basenodes.CCNode;
import cc.CCDirector;
import cc.labelnodes.CCLabelBMFont;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCScene;
import cc.spritenodes.CCSprite;
import cc.particlenodes.CCParticleSystem;
import cc.touchdispatcher.CCPointer;
import flambe.display.BlendMode;
import flambe.Log;
import flambe.math.Point;
import cc.action.CCActionInterval;
import cc.support.Utils;
import cc.action.CCActionInstant;
import cc.spritenodes.CCSpriteFrameCache;
import cc.action.CCActionEase;
import cc.support.CCPointExtension;
import cc.extensions.ccbreader.CCBReader;

/**
 * ...
 * @author Ang Li
 */
@:keep class GameScene
{
	@:keep public var rootNode : CCNode;
	@:keep public var sprtHeader : CCSprite;
	@:keep public var gameLayer : CCLayer;
	@:keep public var sprtTimer : CCSprite;
	@:keep public var lblScore : CCLabelBMFont;
	
	var kGemSize : Int = 40;
	var kBoardWidth : Int = 8;
	var kBoardHeight : Int = 10;
	var kNumTotalGems : Int;
	var kTimeBetweenGemAdds : Float = 3;
	var kTotalGameTime : Float = 60000;
	var kIntroTime : Float = 1800;
	var kNumRemovalFrames : Int = 8;
	var kDelayBeforeHint : Float = 3000;
	var kMaxTimeBetweenConsecutiveMoves : Float = 1000;
	
	var kGameOverGemSpeedX : Float = 0.2;
	var kGameOverGemSpeed : Float = 0.2;
	var kGameOverGemAcceleration : Float = 0.08;

	var kBoardTypeGem0 : Int = 0;
	var kBoardTypeGem1 : Int = 1;
	var kBoardTypeGem2 : Int = 2;
	var kBoardTypeGem3 : Int = 3;
	var kBoardTypeGem4 : Int = 4;
	var kBoardTypePup0 : Int = 5;

	var gFallingGems : Array<Array<TempGem>>;
	var gBoard : Array<Int>;
	var gBoardSprites : Array<CCSprite>;
	var gNumGemsInColumn : Array<Int>;
	var gTimeSinceAddInColumn : Array<Float>;
	var gScore : Int;

	var gLastTakenGemTime : Float ;
	var gNumConsecutiveGems : Int ;
	var gIsPowerPlay : Bool;
	//var gPowerPlayParticles;
	//var gPowerPlayLayer;

	var gGameLayer : CCNode;
	var gParticleLayer : CCNode;
	var gHintLayer : CCNode;
	var gShimmerLayer : CCNode;
	var gEffectsLayer : CCNode;

	//var gTimer;

	var gStartTime : Float;
	var gLastMoveTime : Float;
	var gIsDisplayingHint : Bool;

	var gBoardChangedSinceEvaluation : Bool;
	var gPossibleMove : Int;

	var gIsGameOver : Bool;
	var gGameOverGems : Array<GameOverGem>;
	var gScoreLabel : CCLabelBMFont;
	var gEndTimerStarted : Bool;
	public function new() 
	{
		this.kNumTotalGems =  Std.int(kBoardWidth * kBoardHeight);
	}
	
	public function setupBoard() {
		gBoard = new Array<Int>();
		for (i in 0...kNumTotalGems)
		{
			gBoard[i] = -1;
		}
		
		gBoardSprites = new Array<CCSprite>();

		gNumGemsInColumn = new Array<Int>();
		gTimeSinceAddInColumn = new Array<Float>();
		
		for (x in 0...kBoardWidth)
		{
			gNumGemsInColumn[x] = 0;
			gTimeSinceAddInColumn[x] = 0;
		}

		 //Setup falling pieces
		gFallingGems = new Array<Array<TempGem>>();
		for (x in 0...kBoardWidth)
		{
			gFallingGems[x] = new Array<TempGem>();
		}

		gBoardChangedSinceEvaluation = true;
		gPossibleMove = -1;
	}
	
	public function findConnectedGems_(x : Int, y : Int, arr : Array<Int>, gemType : Int) {
		 //Check for bounds
		if (x < 0 || x >= kBoardWidth) return;
		if (y < 0 || y >= kBoardHeight) return;

		var idx : Int = x + y*kBoardWidth;
		//trace('type = ${gBoard[idx]}');
		 //Make sure that the gems type match
		if (gBoard[idx] != gemType) return;


		 //Check if idx is already visited
		for (i in 0...arr.length)
		{
			if (arr[i] == idx) return;
		}

		 //Add idx to array
		arr.push(idx);

		 //Visit neighbours
		findConnectedGems_(x+1, y, arr, gemType);
		findConnectedGems_(x-1, y, arr, gemType);
		findConnectedGems_(x, y+1, arr, gemType);
		findConnectedGems_(x, y-1, arr, gemType);
	}
	
	public function findConnectedGems(x : Int, y : Int) : Array<Int> {
		var connected : Array<Int> = new Array<Int>();
		if (gBoard[x + y*kBoardWidth] <= -1) return connected;

		findConnectedGems_(x, y, connected, gBoard[x + y*kBoardWidth]);

		return connected;
	}
	
	public function removeConnectedGems(x : Int, y : Int) : Bool{
		 //Check for bounds
		if (x < 0 || x >= kBoardWidth) return false;
		if (y < 0 || y >= kBoardHeight) return false ;

		var connected : Array<Int> = findConnectedGems(x,y);
		var removedGems : Bool = false;
		//trace(connected.length);
		if (connected.length >= 3)
		{
			gBoardChangedSinceEvaluation = true;
			removedGems = true;

			addScore(100*connected.length);

			var idxPup : Int = -1;
			var pupX : Int = 0;
			var pupY : Int = 0;
			if (connected.length >= 6)
			{
				 //Add power-up
				idxPup = connected[Math.floor(Math.random()*connected.length)];
				pupX = idxPup % kBoardWidth;
				pupY = Math.floor(idxPup/kBoardWidth);
			}

			for (i in 0...connected.length)
			{
				var idx : Int = connected[i];
				var gemX : Int = idx % kBoardWidth;
				var gemY : Int = Math.floor(idx/kBoardWidth);

				gBoard[idx] = -kNumRemovalFrames;
				gGameLayer.removeChild(gBoardSprites[idx], true);
				gBoardSprites[idx] = null;

				 //Add particle effect
				var particle : CCParticleSystem = CCParticleSystem.create("crystal/particles/taken-gem");
				particle.setPosition(gemX * kGemSize+kGemSize/2, gemY*kGemSize+kGemSize/2);
				//particle.setAutoRemoveOnFinish(true);
				gParticleLayer.addChild(particle);

				 //Add power-up
				if (idx == idxPup)
				{
					gBoard[idx] = kBoardTypePup0;

					var sprt : CCSprite = CCSprite.createWithSpriteFrameName("crystals/bomb.png");
					sprt.setPosition(Std.parseFloat('${gemX*kGemSize}'), Std.parseFloat('${gemY*kGemSize}'));
					sprt.setAnchorPoint(new Point(0,0));
					sprt.setOpacity(0);
					sprt.runAction(CCFadeIn.create(0.4));

					var sprtGlow :CCSprite = CCSprite.createWithSpriteFrameName("crystals/bomb-hi.png");
					sprtGlow.setAnchorPoint(new Point(0,0));
					sprtGlow.setOpacity(0);
					sprtGlow.runAction(CCRepeatForever.create(CCSequence.create([CCFadeIn.create(0.4),CCFadeOut.create(0.4)])));
					sprt.addChild(sprtGlow);

					gBoardSprites[idx] = sprt;
					gGameLayer.addChild(sprt);
				}
				else if (idxPup != -1)
				{
					 //Animate effect for power-up
					var sprtLight : CCSprite = CCSprite.createWithSpriteFrameName("crystals/bomb-light.png");
					sprtLight.setPosition(Std.parseFloat('{gemX*kGemSize+kGemSize/2}'), Std.parseFloat('${gemY*kGemSize+kGemSize/2}'));
					sprtLight.setBlendFunc(BlendMode.Add);
					gEffectsLayer.addChild(sprtLight);

					var movAction = CCMoveTo.create(0.2, new Point(pupX*kGemSize+kGemSize/2, pupY*kGemSize+kGemSize/2));
					var seqAction = CCSequence.create([movAction, CCCallFunc.createWithParams(onRemoveFromParent, rootNode, sprtLight)]);

					sprtLight.runAction(seqAction);
				}
			}
		}
		else
		{
			//gAudioEngine.playEffect("sounds/miss.wav");
		}

		gLastMoveTime = Date.now().getTime();

		return removedGems;
	}
	
	public function activatePowerUp(x : Int, y : Int) : Bool {
		 //Check for bounds
		if (x < 0 || x >= kBoardWidth) return false;
		if (y < 0 || y >= kBoardHeight) return false;

		var removedGems : Bool = false;

		var idx : Int = x + y * kBoardWidth;
		if (gBoard[idx] == kBoardTypePup0)
		{
			 //Activate bomb
			//gAudioEngine.playEffect("sounds/powerup.wav");

			removedGems = true;

			addScore(2000);

			gBoard[idx] = -kNumRemovalFrames;
			gGameLayer.removeChild(gBoardSprites[idx], true);
			gBoardSprites[idx] = null;
			
			 //Remove a horizontal line
			var idxRemove;
			for (xRemove in 0...kBoardWidth)
			{
				idxRemove = xRemove + y * kBoardWidth;
				if (gBoard[idxRemove] >= 0 && gBoard[idxRemove] < 5)
				{
					gBoard[idxRemove] = -kNumRemovalFrames;
					gGameLayer.removeChild(gBoardSprites[idxRemove], true);
					gBoardSprites[idxRemove] = null;
				}
			}

			 //Remove a vertical line
			for (yRemove in 0...kBoardHeight)
			{
				idxRemove = x + yRemove * kBoardWidth;
				if (gBoard[idxRemove] >= 0 && gBoard[idxRemove] < 5)
				{
					gBoard[idxRemove] = -kNumRemovalFrames;
					gGameLayer.removeChild(gBoardSprites[idxRemove], true);
					gBoardSprites[idxRemove] = null;
				}
			}

			 //Add particle effects
			//var hp = CCParticleSystem.create("crystal/particles/taken-hrow");
			//hp.setPosition(kBoardWidth/2*kGemSize+kGemSize/2, y*kGemSize+kGemSize/2);
			//hp.setAutoRemoveOnFinish(true);
			//gParticleLayer.addChild(hp);
//
			//var vp = CCParticleSystem.create("crystal/particles/taken-vrow");
			//vp.setPosition(x*kGemSize+kGemSize/2, kBoardHeight/2*kGemSize+kGemSize/2);
			//vp.setAutoRemoveOnFinish(true);
			//gParticleLayer.addChild(vp);

			 //Add explo anim
			var center = new Point(x*kGemSize+kGemSize/2, y*kGemSize+kGemSize/2);

			 //Horizontal
			var sprtH0 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo.png");
			sprtH0.setBlendFunc(BlendMode.Add);
			sprtH0.setPosition(center.x, center.y);
			sprtH0.setScaleX(5);
			sprtH0.runAction(CCScaleTo.create(0.5, 30, 1));
			sprtH0.runAction(CCSequence.create([CCFadeOut.create(0.5), CCCallFunc.createWithParams(onRemoveFromParent, rootNode, sprtH0)]));
			gEffectsLayer.addChild(sprtH0);

			 //Vertical
			var sprtV0 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo.png");
			sprtV0.setBlendFunc(BlendMode.Add);
			sprtV0.setPosition(center.x, center.y);
			sprtV0.setScaleY(5);
			sprtV0.runAction(CCScaleTo.create(0.5, 1, 30));
			sprtV0.runAction(CCSequence.create([CCFadeOut.create(0.5), CCCallFunc.createWithParams(onRemoveFromParent, rootNode, sprtV0)]));
			gEffectsLayer.addChild(sprtV0);

			 //Horizontal
			var sprtH1 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo-inner.png");
			sprtH1.setBlendFunc(BlendMode.Add);
			sprtH1.setPosition(center.x, center.y);
			sprtH1.setScaleX(0.5);
			sprtH1.runAction(CCScaleTo.create(0.5, 8, 1));
			sprtH1.runAction(CCSequence.create([CCFadeOut.create(0.5), CCCallFunc.createWithParams(onRemoveFromParent, rootNode, sprtH1)]));
			gEffectsLayer.addChild(sprtH1);

			 //Vertical
			var sprtV1 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo-inner.png");
			sprtV1.setRotation(90);
			sprtV1.setBlendFunc(BlendMode.Add);
			sprtV1.setPosition(center.x, center.y);
			sprtV1.setScaleY(0.5);
			sprtV1.runAction(CCScaleTo.create(0.5, 8, 1));
			sprtV1.runAction(CCSequence.create([CCFadeOut.create(0.5), CCCallFunc.createWithParams(onRemoveFromParent, rootNode, sprtV1)]));
			gEffectsLayer.addChild(sprtV1);
		}
		return removedGems;
	}
	
	public function removeMarkedGems() {
		 //Iterate through the board
		for (x in 0...kBoardWidth)
		{
			for (y in 0...kBoardHeight)
			{
				var i : Int = x + y * kBoardWidth;

				if (gBoard[i] < -1)
				{
					 //Increase the count for negative crystal types
					gBoard[i]++;
					if (gBoard[i] == -1)
					{
						gNumGemsInColumn[x]--;
						gBoardChangedSinceEvaluation = true;

						 //Transform any gem above this to a falling gem
						var yAbove : Int = y - 1;
						while (yAbove >= 0) 
						//for (yAbove in 0...y)
						{
							var idxAbove = x + yAbove*kBoardWidth;

							if (gBoard[idxAbove] < -1)
							{
								gNumGemsInColumn[x]--;
								gBoard[idxAbove] = -1;
							}
							if (gBoard[idxAbove] == -1) {
								yAbove--;
								continue;
							}

							 //The gem is not connected, make it into a falling gem
							var gemType = gBoard[idxAbove];
							var gemSprite = gBoardSprites[idxAbove];
							
							var gem : TempGem = new TempGem(gemType, gemSprite, yAbove, 0);
							//gFallingGems[x].push(gem);
							gFallingGems[x].insert(0, gem);
							 //Remove from board
							gBoard[idxAbove] = -1;
							gBoardSprites[idxAbove] = null;

							gNumGemsInColumn[x]--;
							yAbove--;
						}
					}
				}
			}
		}
		
	}
	
	public function getGemType(x : Int, y : Int) : Int {
		if (x < 0 || x >= kBoardWidth) return -1;
		if (y < 0 || y >= kBoardHeight) return -1;

		return gBoard[x+y*kBoardWidth];
	}
	
	public function setGemType(x : Int , y : Int, newType : Int)
	{
		 //Check bounds
		if (x < 0 || x >= kBoardWidth) return;
		if (y < 0 || y >= kBoardHeight) return;

		 //Get the type of the gem
		var idx = x + y*kBoardWidth;
		var gemType = gBoard[idx];

		 //Make sure that it is a gem
		if (gemType < 0 || gemType >= 5) return;

		gBoard[idx] = newType;

		 //Remove old gem and insert a new one
		gGameLayer.removeChild(gBoardSprites[idx], true);

		var gemSprite = CCSprite.createWithSpriteFrameName("crystals/"+newType+".png");
		gemSprite.setPosition(Utils.toFloat(x * kGemSize), Utils.toFloat(y * kGemSize));
		gemSprite.setAnchorPoint(new Point(0, 0));

		gGameLayer.addChild(gemSprite);
		gBoardSprites[idx] = gemSprite;

		gBoardChangedSinceEvaluation = true;
	}
	
	public function findMove() : Int 
	{
		if (!gBoardChangedSinceEvaluation)
		{
			return gPossibleMove;
		}

		//Iterate through all places on the board
		for (y in 0...kBoardHeight)
		{
			for (x in 0...kBoardWidth)
			{
				var idx : Int = x + y * kBoardWidth;
				var gemType : Int = gBoard[idx];

				//Make sure that it is a gem
				if (gemType < 0 || gemType >= 5) continue;

				//Check surrounding tiles
				var numSimilar : Int = 0;

				if (getGemType(x-1, y) == gemType) numSimilar++;
				if (getGemType(x+1, y) == gemType) numSimilar++;
				if (getGemType(x, y-1) == gemType) numSimilar++;
				if (getGemType(x, y+1) == gemType) numSimilar++;

				if (numSimilar >= 2)
				{
					gPossibleMove = idx;
					return idx;
				}
			}
		}
		gBoardChangedSinceEvaluation = false;
		gPossibleMove = -1;
		return -1;
	}
	
	public function createRandomMove()
	{
		// Find a random place in the lower part of the board
		var x : Int = Math.floor(Math.random()*kBoardWidth-1);
		var y : Int = Math.floor(Math.random()*kBoardHeight/2);

		// Make sure it is a gem that we found
		var gemType = gBoard[x+y*kBoardWidth];
		if (gemType == -1 || gemType >= 5) return;

		// Change the color of two surrounding gems
		setGemType(x+1, y, gemType);
		setGemType(x, y+1, gemType);

		gBoardChangedSinceEvaluation = true;
	}

	public function createGameOver()
	{
		gGameOverGems = [];

		for (x in 0...kBoardWidth)
		{
			var column : Array<TempGem> = gFallingGems[x];
			for (i in 0...column.length)
			{
				var gem : TempGem = column[i];

				var ySpeed : Float = (Math.random()*2-1)*kGameOverGemSpeed;
				var xSpeed : Float = (Math.random()*2-1)*kGameOverGemSpeed;
				
				var gameOverGem = new GameOverGem(gem.sprite, x, gem.yPos, ySpeed, xSpeed);
				gGameOverGems.push(gameOverGem);
			}

			for (y in 0...kBoardHeight)
			{
				var i1 : Int = x + y * kBoardWidth;
				if (gBoardSprites[i1] != null)
				{
					var ySpeed1 : Float = (Math.random()*2-1)*kGameOverGemSpeed;
					var xSpeed1 : Float = (Math.random()*2-1)*kGameOverGemSpeedX;
					//trace('xSpeed1 = $xSpeed1, ySpeed1 = $ySpeed1');
					var gameOverGem1 = new GameOverGem(gBoardSprites[i1], x, y, ySpeed1, xSpeed1);
					//trace(gameOverGem1.xSpeed);
					gGameOverGems.push(gameOverGem1);
				}
			}
		}

		gHintLayer.removeAllChildren(true);

		removeShimmer();
	}

	//var a : Bool = true;
	public function updateGameOver()
	{
		for (i in 0...gGameOverGems.length)
		{
			var gem : GameOverGem = gGameOverGems[i];

			gem.xPos = gem.xPos + Std.int(gem.xSpeed);
			gem.yPos = gem.yPos + Std.int(gem.ySpeed);
			gem.ySpeed += kGameOverGemAcceleration;
			//gem.xSpeed += 0.1;
			
			//if (a) {
				//trace('xPos = ${gem.xPos}');
				//
				//a = false;
			//}
			

			gem.sprite.setPosition(gem.xPos * kGemSize, gem.yPos * kGemSize);
		}
		//a = true;
	}

	public function displayHint()
	{
		gIsDisplayingHint = true;

		var idx = findMove();
		var x : Int = idx % kBoardWidth;
		var y : Int = Math.floor(idx/kBoardWidth);

		var connected : Array<Int>= findConnectedGems(x,y);

		for (i in 0...connected.length)
		{
			idx = connected[i];
			x = idx % kBoardWidth;
			y = Math.floor(idx/kBoardWidth);

			var actionFadeIn : CCFadeIn = CCFadeIn.create(0.5);
			var actionFadeOut : CCFadeOut = CCFadeOut.create(0.5);
			var actionSeq = CCSequence.create([actionFadeIn, actionFadeOut]);
			var action = CCRepeatForever.create(actionSeq);

			var hintSprite = CCSprite.createWithSpriteFrameName("crystals/hint.png");
			hintSprite.setOpacity(0);
			hintSprite.setPosition(Utils.toFloat(x*kGemSize), Utils.toFloat(y*kGemSize));
			hintSprite.setAnchorPoint(new Point(0, 0));
			gHintLayer.addChild(hintSprite);
			hintSprite.runAction(action);
		}
	}

	public function debugPrintBoard()
	{
		var y = kBoardHeight - 1;
		while (y >= 0) {
			var i = kBoardWidth*y;
			trace(""+gBoard[i]+gBoard[i+1]+gBoard[i+2]+gBoard[i+3]+gBoard[i+4]+gBoard[i+5]+gBoard[i+6]+gBoard[i+7]);
			y--;
		}
		trace("--------");
		trace(""+gNumGemsInColumn[0]+" "+gNumGemsInColumn[1]+" "+gNumGemsInColumn[2]+" "+gNumGemsInColumn[3]+" "+
			gNumGemsInColumn[4]+" "+gNumGemsInColumn[5]+" "+gNumGemsInColumn[6]+" "+gNumGemsInColumn[7]);
	}

	public function setupShimmer()
	{
		CCSpriteFrameCache.getInstance().addSpriteFrames("crystal/gamescene/shimmer.plist");

		for (i in 0...2)
		{
			var sprt : CCSprite = CCSprite.createWithSpriteFrameName("gamescene/shimmer/bg-shimmer-"+i+".png");

			var seqRot : CCActionInterval = null;
			var seqMov : CCActionInterval = null;
			var seqSca : CCActionInterval = null;
			
			var x : Float;
			var y : Float;
			var rot : Float ;

			for (j in 0...10)
			{
				var time : Float = Math.random()*10+5;
				x  = kBoardWidth*kGemSize/2;
				y  = Math.random()*kBoardHeight*kGemSize;
				rot = Math.random()*180-90;
				var scale = Math.random()*3 + 3;

				var actionRot = CCEaseInOut.create(CCRotateTo.create(time, rot), 2);
				var actionMov = CCEaseInOut.create(CCMoveTo.create(time, new Point(x,y)), 2);
				var actionSca = CCScaleTo.create(time, scale);

				if (seqRot == null)
				{
					seqRot = actionRot;
					seqMov = actionMov;
					seqSca = actionSca;
				}
				else
				{
					seqRot = CCSequence.create([seqRot, actionRot]);
					seqMov = CCSequence.create([seqMov, actionMov]);
					seqSca = CCSequence.create([seqSca, actionSca]);
				}
			}

			x = kBoardWidth*kGemSize/2;
			y = Math.random()*kBoardHeight*kGemSize;
			rot = Math.random()*180-90;

			sprt.setPosition(x,y);
			sprt.setRotation(rot);

			sprt.setPosition(kBoardWidth*kGemSize/2, kBoardHeight*kGemSize/2);
			sprt.setBlendFunc(BlendMode.Add);
			sprt.setScale(3);

			gShimmerLayer.addChild(sprt);
			sprt.setOpacity(0);
			sprt.runAction(CCRepeatForever.create(seqRot));
			sprt.runAction(CCRepeatForever.create(seqMov));
			sprt.runAction(CCRepeatForever.create(seqSca));

			sprt.runAction(CCFadeIn.create(2));
		}
	}

	public function removeShimmer()
	{
		var children = gShimmerLayer.getChildren();
		for (i in 0...children.length)
		{
			children[i].runAction(CCFadeOut.create(1));
		}
	}

	public function updateSparkle()
	{
		if (Math.random() > 0.1) return;
		var idx : Int = Math.floor(Math.random()*kNumTotalGems);
		var gemSprite : CCSprite = gBoardSprites[idx];
		if (gBoard[idx] < 0 || gBoard[idx] >= 5) return;
		if (gemSprite == null) return;

		if (gemSprite.getChildren().length > 0) return;

		var sprite = CCSprite.createWithSpriteFrameName("crystals/sparkle.png");
		sprite.runAction(CCRepeatForever.create(CCRotateBy.create(3, 360)));

		sprite.setOpacity(0);

		sprite.runAction(CCSequence.create([
			CCFadeIn.create(0.5),
			CCFadeOut.create(2),
			CCCallFunc.createWithParams(onRemoveFromParent, rootNode, sprite)]));

		sprite.setPosition(kGemSize*(2/6), kGemSize*(4/6));

		gemSprite.addChild(sprite);
	}

	public function onRemoveFromParent(node : CCNode)
	{
		node.getParent().removeChild(node, true);
	}

	public function updatePowerPlay()
	{
		//var powerPlay : Bool = (gNumConsecutiveGems >= 5);
		//if (powerPlay == gIsPowerPlay) return;
//
		//if (powerPlay)
		//{
			// Start power-play
			//gPowerPlayParticles = CCParticleSystem.create("particles/power-play.plist");
			//gPowerPlayParticles.setAutoRemoveOnFinish(true);
			//gParticleLayer.addChild(gPowerPlayParticles);
//
			//if( 'opengl' in sys.capabilities ) {
//
				//var contentSize = gGameLayer.getContentSize();
				//gPowerPlayLayer = cc.LayerColor.create(cc.c4b(85, 0, 70, 0), contentSize.width, contentSize.height);
//
				//var action = cc.Sequence.create(cc.FadeIn.create(0.25), cc.FadeOut.create(0.25));
				//gPowerPlayLayer.runAction(cc.RepeatForever.create(action));
				//gPowerPlayLayer.setBlendFunc(gl.SRC_ALPHA, gl.ONE);
//
				//gEffectsLayer.addChild(gPowerPlayLayer);
			//}
//
		//}
		//else
		//{
			// Stop power-play
			//if (gPowerPlayParticles)
			//{
				//gPowerPlayParticles.stopSystem();
//
				//if( 'opengl' in sys.capabilities ) {
					//gPowerPlayLayer.stopAllActions();
					//gPowerPlayLayer.runAction(cc.Sequence.create(cc.FadeOut.create(0.5), cc.CallFunc.create(onRemoveFromParent, this)));
				//}
			//}
		//}
//
		//gIsPowerPlay = powerPlay;
	}

	public function addScore(score : Int)
	{
		if (gIsPowerPlay) score *= 3;
		gScore += score;
		gScoreLabel.setString(""+gScore);
	}

//
// MainScene class
//

// Game main loop
	
	
	@:keep public function processClick(loc : Point) {
		//trace(gBoard);
		
		loc = CCPointExtension.pSub(loc,new Point(0, 80));
		//trace(this.gameLayer.getPosition());
		
		var x = Math.floor(loc.x/(kGemSize * 0.8));
		var y = Math.floor(loc.y / (kGemSize * 0.8));
		//trace(x + "," + y);

		if (!gIsGameOver)
		{
			gHintLayer.removeAllChildren(true);
			gIsDisplayingHint = false;

			if (activatePowerUp(x,y) ||
				removeConnectedGems(x,y))
			{
				// Player did a valid move
				var sound : Int = gNumConsecutiveGems;
				if (sound > 4) sound = 4;
				//gAudioEngine.playEffect("sounds/gem-"+sound+".wav");
//
				gNumConsecutiveGems++;
			}
			else
			{
				gNumConsecutiveGems = 0;
			}

			gLastMoveTime = Date.now().getTime();
		}
	}
	
	@:keep public function onMouseDown(event : CCPointer) {
		var loc : Point = event.getLocation();
		this.processClick(loc);
	}
	
	@:keep public function onAnimationComplete() {
		if (gIsGameOver) {
			var scene : CCScene = CCBuilderReader.loadAsScene("crystal/MainScene.ccbi", null, null, "crystal/");
			CCDirector.getInstance().replaceScene(scene);
		}
	}
	@:keep public function onPauseClicked() {
		createGameOver();
		this.rootNode.animationManager.runAnimationsForSequenceNamed("Outro");
		gIsGameOver = true;
	}
	
	@:keep public function onUpdate() {
		if (!gIsGameOver)
		{
			removeMarkedGems();

			var gem : TempGem = null;
			
			// Add falling gems
			for (x in 0...kBoardWidth)
			{
				if (gNumGemsInColumn[x] + gFallingGems[x].length < kBoardHeight &&
					gTimeSinceAddInColumn[x] >= kTimeBetweenGemAdds)
				{
					// A gem should be added to this column!
					//trace('num of column = $x');
					var gemType = Math.floor(Math.random()*5);
					var gemSprite : CCSprite = CCSprite.createWithSpriteFrameName("crystals/"+gemType+".png");
					//gemSprite.setPosition(x * kGemSize, kBoardHeight * kGemSize);
					gemSprite.setPosition(x * kGemSize, -30);
					gemSprite.setAnchorPoint(new Point(0,0));

					gem = new TempGem(gemType, gemSprite, -30, 0);
					//gFallingGems[x].push(gem);
					gFallingGems[x].insert(0, gem);
					//trace(gem);
					gGameLayer.addChild(gemSprite);

					gTimeSinceAddInColumn[x] = 0;
				}
				//gFallingGems[x].reverse();

				gTimeSinceAddInColumn[x] += 1;
			}
			
			

			// Move falling gems
			var gemLanded : Bool = false;
			//var x = kBoardWidth - 1;
			//while(x >= 0) 
			for (x in 0...kBoardWidth)
			{
				var column : Array<TempGem> = gFallingGems[x];
				
				var numFallingGems = gFallingGems[x].length;
				
				
				var i = numFallingGems - 1;
				while ( i >= 0) {
					
					gem = column[i];
					//trace(gem);
					gem.ySpeed += 4;
					//gem.ySpeed *= 0.99;
					gem.yPos += Std.int(gem.ySpeed);
					//trace(gem.yPos);
					if (gem.yPos >= 10 - gNumGemsInColumn[x])
					{
						// The gem hit the ground or a fixed gem
						if (!gemLanded)
						{
							//gAudioEngine.playEffect("sounds/tap-"+Math.floor(Math.random()*4)+".wav");
							gemLanded = true;
						}

						column.splice(i, 1);

						// Insert into board
						var y = gNumGemsInColumn[x];

						if (gBoard[x + (kBoardHeight - 1- y)*kBoardWidth] != -1)
						{
							//trace("Warning! Overwriting board idx: "+x + y*kBoardWidth+" type: "+gBoard[x + y*kBoardWidth]);
						}

						gBoard[x + (kBoardHeight - 1- y)*kBoardWidth] = gem.gemType;
						gBoardSprites[x + (kBoardHeight - 1- y)*kBoardWidth] = gem.sprite;

						// Update fixed position
						gem.sprite.setPosition(Utils.toFloat(x*kGemSize), Utils.toFloat((9 - y)*kGemSize));
						gNumGemsInColumn[x] ++;

						gBoardChangedSinceEvaluation = true;
					}
					else
					{
						// Update the falling gems position
						gem.sprite.setPosition(Utils.toFloat(x*kGemSize), Utils.toFloat(gem.yPos*kGemSize));
					}
					i--;
				}
				//x--;
			}

			// Check if there are possible moves and no gems falling
			var isFallingGems = false;
			for (x in 0...kBoardWidth)
			{
				if (gNumGemsInColumn[x] != kBoardHeight)
				{
					isFallingGems = true;
					break;
				}
			}

			if (!isFallingGems)
			{
				var possibleMove = findMove();
				if (possibleMove == -1)
				{
					// Create a possible move
					createRandomMove();
				}
			}

			// Update timer
			var currentTime : Float = Date.now().getTime();
			var elapsedTime : Float = (currentTime - gStartTime)/kTotalGameTime;
			var timeLeft : Float  = (1 - elapsedTime)*100;
			if (timeLeft < 0) timeLeft = 0;
			if (timeLeft > 99.9) timeLeft = 99.9;
//
			//gTimer.setPercentage(timeLeft);

			// Update consecutive moves / powerplay
			if (currentTime - gLastMoveTime > kMaxTimeBetweenConsecutiveMoves)
			{
				gNumConsecutiveGems = 0;
			}
			updatePowerPlay();

			// Update sparkles
			updateSparkle();

			// Check if timer sound should be played
			if (timeLeft < 6.6 && !gEndTimerStarted)
			{
				//gAudioEngine.playEffect("sounds/timer.wav");
				//gEndTimerStarted = true;
			}

			// Check for game over
			if (timeLeft == 0)
			{
				createGameOver();
				this.rootNode.animationManager.runAnimationsForSequenceNamed("Outro");
				gIsGameOver = true;
				//gAudioEngine.stopAllEffects();
				//trace("stopAllEffects not working!");
				//gAudioEngine.playEffect("sounds/endgame.wav");
				//gLastScore = gScore;
			}
			else if (currentTime - gLastMoveTime > kDelayBeforeHint && !gIsDisplayingHint)
			{
				displayHint();
			}
		}
		else
		{
			// It's game over
			//trace("gameover");
			updateGameOver();
			
		}
	}
	
	
	
	@:keep public function onDidLoadFromCCB() {
		// Setup board
		setupBoard();

		gIsGameOver = false;
		gIsDisplayingHint = false;

		//if( sys.platform == 'browser')
			//this.rootNode.setMouseEnabled( true );

		var layer : CCLayer;
		layer = cast(rootNode, CCLayer);
		
		// Forward relevant touch events to controller (this)
		//layer.onPointerDown = function( touches, event) {
			//this.onTouchesBegan(touches, event);
			//return true;
		//};
		//layer.onPointerDown = 
		//
		var f = function(event : CCPointer) : Bool {
			this.onMouseDown(event);
			return true;
		};
		
		gameLayer.onPointerDown = f;
		
		

		// Setup timer
		//this.sprtTimer.setVisible(false);
		//gTimer = cc.ProgressTimer.create(CCSprite.create("gamescene/timer.png"));
		//gTimer.setPosition(this.sprtTimer.getPosition());
		//gTimer.setPercentage(100);
		//gTimer.setType(cc.PROGRESS_TIMER_TYPE_BAR);
		//gTimer.setMidpoint(cc.p(0, 0.5));
		//gTimer.setBarChangeRate(cc.p(1, 0));
		//this.sprtHeader.addChild(gTimer);

		var dNow : Float = Date.now().getTime();
		gStartTime = dNow + kIntroTime;
		gLastMoveTime = dNow;
		gNumConsecutiveGems = 0;
		gIsPowerPlay = false;
		gEndTimerStarted = false;

		gScore = 0;

		// Schedule callback
		//this.rootNode.onUpdate = function(dt) {
			//this.controller.onUpdate();
		//};
		this.rootNode.schedule(this.onUpdate, 0.015);

		// TODO: Make into batch node

		//if ("opengl" in sys.capabilities && "browser" != sys.platform)
		//{
			//cc.log("OpenGL rendering");
			//gParticleLayer = cc.ParticleBatchNode.create("particles/taken-gem.png", 250);
			//gGameLayer = cc.SpriteBatchNode.create("crystals.pvr.ccz");
		//}
		//else
		//{
			gParticleLayer = CCNode.create();
			gGameLayer = CCNode.create();
		//}

		gGameLayer.setContentSize(this.gameLayer.getContentSize());
		//gParticleLayer = cc.ParticleBatchNode.create("particles/taken-gem.png", 250);
		//gParticleLayer = cc.Node.create();
		gHintLayer = CCNode.create();
		gShimmerLayer = CCNode.create();
		gEffectsLayer = CCNode.create();

		this.gameLayer.addChild(gShimmerLayer, -1);
		this.gameLayer.addChild(gParticleLayer, 1);
		this.gameLayer.addChild(gGameLayer, 0);
		this.gameLayer.addChild(gHintLayer, 3);
		this.gameLayer.addChild(gEffectsLayer, 2);

		//gGameLayer = this.gameLayer;

		// Setup callback for completed animations
		this.rootNode.animationManager.setCompletedAnimationCallback(rootNode, this.onAnimationComplete);

		setupShimmer();
		//setupSparkle();

		// Setup score label
		gScoreLabel = this.lblScore;
		
		CCSpriteFrameCache.getInstance().addSpriteFrames("crystal/crystals.plist");
		
		//this.rootNode.ignoreAnchorPointForPosition(false);
		//this.rootNode.setAnchorPoint(new Point(0, 1));
		//this.rootNode.setPosition(0, 0);
		//this.rootNode.setScale(0.8);
	
	}
}

class TempGem {
	public var gemType : Int;
	public var sprite : CCSprite;
	public var yPos :  Int;
	public var ySpeed : Float;
	public function new(gemType : Int, gemSprite : CCSprite, yPos : Int, ySpeed : Float) {
		this.gemType = gemType;
		this.sprite = gemSprite;
		this.yPos = yPos;
		this.ySpeed = ySpeed;
	}
	
	public function toString() : String {
		switch (gemType) {
			case 0 : return "blue";
			case 1 : return "green";
			case 2 : return "purple";
			case 3 : return "yellow";
			case 4 : return "red";
			default : return null;
		}
	}
}

class GameOverGem {
	public var sprite : CCSprite;
	public var xPos : Int;
	public var yPos : Int;
	public var xSpeed : Float;
	public var ySpeed : Float;
	
	public function new (sprite : CCSprite, xPos : Int, yPos : Int, ySpeed : Float, xSpeed : Float) {
		this.sprite = sprite;
		this.xPos = xPos;
		this.yPos = yPos;
		this.xSpeed = xSpeed;
		this.ySpeed = ySpeed;
	}
}