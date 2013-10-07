package com.angli;
import cc.basenodes.CCNode;
import cc.extensions.ccbreader.CCBAnimationManager;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.CCDirector;
import cc.menunodes.CCMenu;
/**
 * ...
 * @author Ang Li
 */
@:keep class AboutScene
{
	@:keep public var rootNode : CCNode;
	@:keep public var pressedDone : Bool = false;
	
	public function new() 
	{
		//rootNode = null;
	}
	
	
	@:keep public function onDidLoadFromCCB() {
		this.rootNode.animationManager.setCompletedAnimationCallback(rootNode, this.onAnimationComplete);	
		
		
	}
	
	@:keep public function onPressDone() {
		//gAudioEngine.playEffect("sounds/click.caf");

		this.pressedDone = true;
		this.rootNode.animationManager.runAnimationsForSequenceNamed("Outro");
	}
	
	@:keep public function onAnimationComplete() {
		if (this.pressedDone)
		{
			var parent : CCNode = this.rootNode.getParent();
			parent.controller.menu.setEnabled(true);
			rootNode.removeFromParent(true);
		}
	}
}