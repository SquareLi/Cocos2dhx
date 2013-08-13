package sample;
import cc.basenodes.CCNode;
import cc.spritenodes.CCSprite;
import cc.action.CCActionInterval;
import cc.action.CCActionInstant;
import cc.action.CCActionEase;
import flambe.input.PointerEvent;
import flambe.math.Point;
import cc.action.CCAction;
import flambe.display.BlendMode;
/**
 * ...
 * @author Ang Li
 */
class Effect
{
	static var _parent : CCNode;
	static var _target : CCNode;

	public function new() 
	{
		
	}
	
	public static function flareEffect(parent : CCNode, target : CCNode, cb : Void -> Void) {
		_parent = parent;
		_target = target;
		
		var flare = CCSprite.create("Sample/flare");
		flare.setBlendFunc(BlendMode.Add);
		parent.addChild(flare, 10);
		flare.setOpacity(255);
		flare.setPosition(-30, 183);
		flare.setRotation(-120);
		flare.setScale(0.2);
		flare.setCenterAnchor();
		
		var opacityAnim = CCFadeTo.create(0.5, 255);
		var opacDim = CCFadeTo.create(1, 0);
		var biggeAnim = CCScaleBy.create(0.7, 1.2, 1.2);
		var biggerEase = CCEaseSineOut.create(biggeAnim);
		var moveAnim = CCMoveBy.create(0.5, new Point(328, 0));
		var easeMove = CCEaseSineOut.create(moveAnim);
		var rotateAnim = CCRotateBy.create(2.5, 90);
		var rotateEase = CCEaseExponentialOut.create(rotateAnim);
		var bigger = CCScaleTo.create(0.5, 1);
		//
		var onComplete = CCCallFunc.create(cb, target);
		
		var killflare = CCCallFunc.create(function() {
			parent.removeChild(target, true);
		}, flare);
		//
		flare.runAction(CCSequence.create([opacityAnim, biggerEase, opacDim, killflare, onComplete]));
		flare.runAction(moveAnim);
		flare.runAction(rotateEase);
		flare.runAction(bigger);
	}
	
	public static function removeFromParent() {
		_target.removeFromParentAndCleanup();
	}
	
	public static function spark(ccpoint : Point, parent : CCNode, ?scale : Float, ?duration : Float) {
		_parent = parent;
		
		if (scale == null) {
			scale = 0.3;
		}
		
		if (duration == null) {
			duration = 0.5;
		}
		
		var one :CCSprite = CCSprite.create("Sample/explode1");
		var two = CCSprite.create("Sample/explode2");
		var three : CCSprite = CCSprite.create("Sample/explode3");
		
		one.setBlendFunc(BlendMode.Add);
		two.setBlendFunc(BlendMode.Add);
		three.setBlendFunc(BlendMode.Add);
		
		one.setPosition(ccpoint.x, ccpoint.y);
		two.setPosition(ccpoint.x, ccpoint.y);
		three.setPosition(ccpoint.x, ccpoint.y);
		
		parent.addChild(one);
		parent.addChild(two);
		parent.addChild(three);
		one.setScale(scale);
		two.setScale(scale);
		three.setScale(scale);
		
		one.setCenterAnchor();
		two.setCenterAnchor();
		three.setCenterAnchor();
		
		three.setRotation(Math.random() * 360);
		
		var left = CCRotateBy.create(duration, -45);
		var right = CCRotateBy.create(duration, 45);
		var scaleBy1 = CCScaleBy.create(duration, 3, 3);
		var scaleBy2 = CCScaleBy.create(duration, 3, 3);
		var scaleBy3 = CCScaleBy.create(duration, 3, 3);
		var fadeOut1 = CCFadeOut.create(duration);
		var fadeOut2 = CCFadeOut.create(duration);
		var fadeOut3 = CCFadeOut.create(duration);
		
		one.runAction(left);
		two.runAction(right);
		
		one.runAction(scaleBy1);
		two.runAction(scaleBy2);
		three.runAction(scaleBy3);
		
		one.runAction(CCSequence.create([fadeOut1, CCCallFunc.create(one.removeFromParentAndCleanup, one)]));
		two.runAction(CCSequence.create([fadeOut2, CCCallFunc.create(two.removeFromParentAndCleanup, two)]));
		three.runAction(CCSequence.create([fadeOut3, CCCallFunc.create(three.removeFromParentAndCleanup, three)]));
	}
}