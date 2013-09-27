package tests;
import cc.basenodes.CCNode;
import cc.labelnodes.CCLabelBMFont;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.spritenodes.CCSprite;
import cc.particlenodes.CCParticleSystem;
import flambe.display.BlendMode;
import flambe.Log;
import flambe.math.Point;
import cc.action.CCActionInterval;
import cc.support.Utils;
import cc.action.CCActionInstant;

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
	var kTimeBetweenGemAdds : Float = 8;
	var kTotalGameTime : Float = 60000;
	var kIntroTime : Int = 1800;
	var kNumRemovalFrames : Int = 8;
	var kDelayBeforeHint : Float = 3000;
	var kMaxTimeBetweenConsecutiveMoves : Float = 1000;

	var kGameOverGemSpeed : Float = 0.1;
	var kGameOverGemAcceleration : Float = 0.005;

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
	var gTimeSinceAddInColumn : Array<Int>;
//
	//var gLastTakenGemTime : Float ;
	//var gNumConsecutiveGems;
	//var gIsPowerPlay;
	//var gPowerPlayParticles;
	//var gPowerPlayLayer;
//
	var gGameLayer : CCNode;
	var gParticleLayer : CCNode;
	var gHintLayer : CCNode;
	var gShimmerLayer : CCNode;
	var gEffectsLayer : CCNode;

	var gTimer;

	var gStartTime : Float;
	var gLastMoveTime : Float;
	var gIsDisplayingHint : Bool;

	var gBoardChangedSinceEvaluation : Bool;
	var gPossibleMove : Int;
//
	//var gIsGameOver : Bool;
	//var gGameOverGems;
	//var gScoreLabel;
	//var gEndTimerStarted;
	public function new() 
	{
		this.kNumTotalGems =  Std.int(kBoardWidth * kBoardHeight);
	}
	
	//public function setupBoard() {
		//gBoard = new Array<Int>();
		//for (i in 0...kNumTotalGems)
		//{
			//gBoard[i] = -1;
		//}
		//
		//gBoardSprites = new Array(kNumTotalGems);
//
		//gNumGemsInColumn = new Array<Int>();
		//gTimeSinceAddInColumn = new Array<Int>();;
		//
		//for (x in 0...kBoardWidth)
		//{
			//gNumGemsInColumn[x] = 0;
			//gTimeSinceAddInColumn[x] = 0;
		//}
//
		// Setup falling pieces
		//gFallingGems = new Array<Int>();
		//for (x in 0...kBoardWidth)
		//{
			//gFallingGems[x] = new Array<TempGem>();
		//}
//
		//gBoardChangedSinceEvaluation = true;
		//gPossibleMove = -1;
	//}
	//
	//public function findConnectedGems_(x : Int, y : Int, arr : Array<Int>, getType : Int) {
		// Check for bounds
		//if (x < 0 || x >= kBoardWidth) return;
		//if (y < 0 || y >= kBoardHeight) return;
//
		//var idx : Int = x + y*kBoardWidth;
//
		// Make sure that the gems type match
		//if (gBoard[idx] != gemType) return;
//
//
		// Check if idx is already visited
		//for (i in 0...arr.length)
		//{
			//if (arr[i] == idx) return;
		//}
//
		// Add idx to array
		//arr.push(idx);
//
		// Visit neighbours
		//findConnectedGems_(x+1, y, arr, gemType);
		//findConnectedGems_(x-1, y, arr, gemType);
		//findConnectedGems_(x, y+1, arr, gemType);
		//findConnectedGems_(x, y-1, arr, gemType);
	//}
	//
	//public function findConnectedGems(x : Int, y : Int) : Array<Int> {
		//var connected : Array<Int> = new Array<Int>();
		//if (gBoard[x + y*kBoardWidth] <= -1) return connected;
//
		//findConnectedGems_(x, y, connected, gBoard[x + y*kBoardWidth]);
//
		//return connected;
	//}
	//
	//public function removeConnectedGems(x : Int, y : Int) : Bool{
		// Check for bounds
		//if (x < 0 || x >= kBoardWidth) return;
		//if (y < 0 || y >= kBoardHeight) return;
//
		//var connected : Array<Int> = findConnectedGems(x,y);
		//var removedGems : Bool = false;
//
		//if (connected.length >= 3)
		//{
			//gBoardChangedSinceEvaluation = true;
			//removedGems = true;
//
			//addScore(100*connected.length);
//
			//var idxPup : Int = -1;
			//var pupX : Int = 0;
			//var pupY : Int = 0;
			//if (connected.length >= 6)
			//{
				// Add power-up
				//idxPup = connected[Math.floor(Math.random()*connected.length)];
				//pupX = idxPup % kBoardWidth;
				//pupY = Math.floor(idxPup/kBoardWidth);
			//}
//
			//for (i in 0...connected.length)
			//{
				//var idx : Int = connected[i];
				//var gemX : Int = idx % kBoardWidth;
				//var gemY : Int = Math.floor(idx/kBoardWidth);
//
				//gBoard[idx] = -kNumRemovalFrames;
				//gGameLayer.removeChild(gBoardSprites[idx], true);
				//gBoardSprites[idx] = null;
//
				// Add particle effect
				//var particle : CCParticleSystem = CCParticleSystem.create("particles/taken-gem.plist");
				//particle.setPosition(Utils.toFloat(gemX * kGemSize+kGemSize/2), Utils.toFloat(gemY*kGemSize+kGemSize/2));
				//particle.setAutoRemoveOnFinish(true);
				//gParticleLayer.addChild(particle);
//
				// Add power-up
				//if (idx == idxPup)
				//{
					//gBoard[idx] = kBoardTypePup0;
//
					//var sprt : CCSprite = CCSprite.create("crystals/bomb.png");
					//sprt.setPosition(Std.parseFloat('${gemX*kGemSize}'), Std.parseFloat('${gemY*kGemSize}'));
					//sprt.setAnchorPoint(new Point(0,0));
					//sprt.setOpacity(0);
					//sprt.runAction(CCFadeIn.create(0.4));
//
					//var sprtGlow :CCSprite = CCSprite.create("crystals/bomb-hi.png");
					//sprtGlow.setAnchorPoint(new Point(0,0));
					//sprtGlow.setOpacity(0);
					//sprtGlow.runAction(CCRepeatForever.create(CCSequence.create(CCFadeIn.create(0.4),CCFadeOut.create(0.4))));
					//sprt.addChild(sprtGlow);
//
					//gBoardSprites[idx] = sprt;
					//gGameLayer.addChild(sprt);
				//}
				//else if (idxPup != -1)
				//{
					// Animate effect for power-up
					//var sprtLight : CCSprite = CCSprite.create("crystals/bomb-light.png");
					//sprtLight.setPosition(Std.parseFloat('{gemX*kGemSize+kGemSize/2}'), Std.parseFloat('${gemY*kGemSize+kGemSize/2}'));
					//sprtLight.setBlendFunc(BlendMode.Add);
					//gEffectsLayer.addChild(sprtLight);
//
					//var movAction = CCMoveTo.create(0.2, new Point(Utils.toFloat(pupX*kGemSize+kGemSize/2), Utils.toFloat(pupY*kGemSize+kGemSize/2)));
					//var seqAction = CCSequence.create(movAction, CCCallFunc.create(onRemoveFromParent, this));
//
					//sprtLight.runAction(seqAction);
				//}
			//}
		//}
		//else
		//{
			//gAudioEngine.playEffect("sounds/miss.wav");
		//}
//
		//gLastMoveTime = Date.now();
//
		//return removedGems;
	//}
	//
	//public function activatePowerUp(x : Int, y : Int) : Bool {
		// Check for bounds
		//if (x < 0 || x >= kBoardWidth) return;
		//if (y < 0 || y >= kBoardHeight) return;
//
		//var removedGems : Bool = false;
//
		//var idx : Int = x + y * kBoardWidth;
		//if (gBoard[idx] == kBoardTypePup0)
		//{
			// Activate bomb
			//gAudioEngine.playEffect("sounds/powerup.wav");
//
			//removedGems = true;
//
			//addScore(2000);
//
			//gBoard[idx] = -kNumRemovalFrames;
			//gGameLayer.removeChild(gBoardSprites[idx], true);
			//gBoardSprites[idx] = null;
			//
			// Remove a horizontal line
			//var idxRemove;
			//for (xRemove in 0...kBoardWidth)
			//{
				//idxRemove = xRemove + y * kBoardWidth;
				//if (gBoard[idxRemove] >= 0 && gBoard[idxRemove] < 5)
				//{
					//gBoard[idxRemove] = -kNumRemovalFrames;
					//gGameLayer.removeChild(gBoardSprites[idxRemove], true);
					//gBoardSprites[idxRemove] = null;
				//}
			//}
//
			// Remove a vertical line
			//for (yRemove in 0...kBoardHeight)
			//{
				//idxRemove = x + yRemove * kBoardWidth;
				//if (gBoard[idxRemove] >= 0 && gBoard[idxRemove] < 5)
				//{
					//gBoard[idxRemove] = -kNumRemovalFrames;
					//gGameLayer.removeChild(gBoardSprites[idxRemove], true);
					//gBoardSprites[idxRemove] = null;
				//}
			//}
//
			// Add particle effects
			//var hp = CCParticleSystem.create("particles/taken-hrow.plist");
			//hp.setPosition(new Point(Utils.toFloat(kBoardWidth/2*kGemSize+kGemSize/2), Utils.toFloat(y*kGemSize+kGemSize/2)));
			//hp.setAutoRemoveOnFinish(true);
			//gParticleLayer.addChild(hp);
//
			//var vp = CCParticleSystem.create("particles/taken-vrow.plist");
			//vp.setPosition(new Point(Utils.toFloat(x*kGemSize+kGemSize/2), Utils.toFloat(kBoardHeight/2*kGemSize+kGemSize/2)));
			//vp.setAutoRemoveOnFinish(true);
			//gParticleLayer.addChild(vp);
//
			// Add explo anim
			//var center = new Point(Utils.toFloat(x*kGemSize+kGemSize/2), Utils.toFloat(y*kGemSize+kGemSize/2));
//
			// Horizontal
			//var sprtH0 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo.png");
			//sprtH0.setBlendFunc(BlendMode.Add);
			//sprtH0.setPosition(center.x, center.y);
			//sprtH0.setScaleX(5);
			//sprtH0.runAction(CCScaleTo.create(0.5, 30, 1));
			//sprtH0.runAction(CCSequence.create(CCFadeOut.create(0.5), CCCallFunc.create(onRemoveFromParent, this)));
			//gEffectsLayer.addChild(sprtH0);
//
			// Vertical
			//var sprtV0 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo.png");
			//sprtV0.setBlendFunc(BlendMode.Add);
			//sprtV0.setPosition(center.x, center.y);
			//sprtV0.setScaleY(5);
			//sprtV0.runAction(CCScaleTo.create(0.5, 1, 30));
			//sprtV0.runAction(CCSequence.create(CCFadeOut.create(0.5), CCCallFunc.create(onRemoveFromParent, this)));
			//gEffectsLayer.addChild(sprtV0);
//
			// Horizontal
			//var sprtH1 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo-inner.png");
			//sprtH1.setBlendFunc(BlendMode.Add);
			//sprtH1.setPosition(center.x, center.y);
			//sprtH1.setScaleX(0.5);
			//sprtH1.runAction(CCScaleTo.create(0.5, 8, 1));
			//sprtH1.runAction(CCSequence.create(CCFadeOut.create(0.5), CCCallFunc.create(onRemoveFromParent, this)));
			//gEffectsLayer.addChild(sprtH1);
//
			// Vertical
			//var sprtV1 = CCSprite.createWithSpriteFrameName("crystals/bomb-explo-inner.png");
			//sprtV1.setRotation(90);
			//sprtV1.setBlendFunc(BlendMode.Add);
			//sprtV1.setPosition(center.x, center.y);
			//sprtV1.setScaleY(0.5);
			//sprtV1.runAction(CCScaleTo.create(0.5, 8, 1));
			//sprtV1.runAction(CCSequence.create(CCFadeOut.create(0.5), CCCallFunc.create(onRemoveFromParent, this)));
			//gEffectsLayer.addChild(sprtV1);
		//}
//
		//return removedGems;
	//}
	//
	//public function removeMarkedGems() {
		// Iterate through the board
		//for (x in 0...kBoardWidth)
		//{
			//for (y in 0...kBoardHeight)
			//{
				//var i : Int = x + y * kBoardWidth;
//
				//if (gBoard[i] < -1)
				//{
					// Increase the count for negative crystal types
					//gBoard[i]++;
					//if (gBoard[i] == -1)
					//{
						//gNumGemsInColumn[x]--;
						//gBoardChangedSinceEvaluation = true;
//
						// Transform any gem above this to a falling gem
						//for (yAbove in y+1...kBoardHeight)
						//{
							//var idxAbove = x + yAbove*kBoardWidth;
//
							//if (gBoard[idxAbove] < -1)
							//{
								//gNumGemsInColumn[x]--;
								//gBoard[idxAbove] = -1;
							//}
							//if (gBoard[idxAbove] == -1) continue;
//
							// The gem is not connected, make it into a falling gem
							//var gemType = gBoard[idxAbove];
							//var gemSprite = gBoardSprites[idxAbove];
							//
							//var gem : TempGem = new TempGem(gemType, gemSprite, yAbove, 0);
							//gFallingGems[x].push(gem);
//
							// Remove from board
							//gBoard[idxAbove] = -1;
							//gBoardSprites[idxAbove] = null;
//
							//gNumGemsInColumn[x]--;
						//}
					//}
				//}
			//}
		//}
	//}
	//
	//public function getGemType(x : Int, y : Int) : Int {
		//if (x < 0 || x >= kBoardWidth) return -1;
		//if (y < 0 || y >= kBoardHeight) return -1;
//
		//return gBoard[x+y*kBoardWidth];
	//}
	//
	//public function setGemType(x : Int , y : Int, newType : Int)
	//{
		// Check bounds
		//if (x < 0 || x >= kBoardWidth) return;
		//if (y < 0 || y >= kBoardHeight) return;
//
		// Get the type of the gem
		//var idx = x + y*kBoardWidth;
		//var gemType = gBoard[idx];
//
		// Make sure that it is a gem
		//if (gemType < 0 || gemType >= 5) return;
//
		//gBoard[idx] = newType;
//
		// Remove old gem and insert a new one
		//gGameLayer.removeChild(gBoardSprites[idx], true);
//
		//var gemSprite = CCSprite.create("crystals/"+newType+".png");
		//gemSprite.setPosition(Utils.toFloat(x * kGemSize), Utils.toFloat(y * kGemSize));
		//gemSprite.setAnchorPoint(new Point(0, 0));
//
		//gGameLayer.addChild(gemSprite);
		//gBoardSprites[idx] = gemSprite;
//
		//gBoardChangedSinceEvaluation = true;
	//}
	//
	//function findMove()
	//{
		//if (!gBoardChangedSinceEvaluation)
		//{
			//return gPossibleMove;
		//}
//
		// Iterate through all places on the board
		//for (var y = 0; y < kBoardHeight; y++)
		//{
			//for (var x = 0; x < kBoardWidth; x++)
			//{
				//var idx = x + y*kBoardWidth;
				//var gemType = gBoard[idx];
//
				// Make sure that it is a gem
				//if (gemType < 0 || gemType >= 5) continue;
//
				// Check surrounding tiles
				//var numSimilar = 0;
//
				//if (getGemType(x-1, y) == gemType) numSimilar++;
				//if (getGemType(x+1, y) == gemType) numSimilar++;
				//if (getGemType(x, y-1) == gemType) numSimilar++;
				//if (getGemType(x, y+1) == gemType) numSimilar++;
//
				//if (numSimilar >= 2)
				//{
					//gPossibleMove = idx;
					//return idx;
				//}
			//}
		//}
		//gBoardChangedSinceEvaluation = false;
		//gPossibleMove = -1;
		//return -1;
	//}
	
	@:keep public function onDidLoadFromCCB() {
		
	}
	
	@:keep public function processClick() {
		
	}
	
	@:keep public function onTouchesBegan() {
		
	}
	
	@:keep public function onMouseDown() {
		
	}
	
	@:keep public function onPauseClicked() {
		
	}
	
}

//class TempGem {
	//public var gemType : Int;
	//public var sprite : CCSprite;
	//public var yPos :  Int;
	//public var ySpeed : Float;
	//public function new(gemType : Int, gemSprite : CCSprite, yPos : Int, ySpeed : Float) {
		//this.gemType = gemType;
		//this.sprite = gemSprite;
		//this.yPos = yPos;
		//this.ySpeed = ySpeed;
	//}
//}