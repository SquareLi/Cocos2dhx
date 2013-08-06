/****************************************************************************
 cocos2dhx 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

package ;
import cc.denshion.AudioEngine;
import flambe.Component;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import haxe.unit.TestStatus;
import flambe.System;
import cc.CCLoader;

/**
 * ...
 * @author Ang Li
 */
class DenshionTest extends Component
{
	var back : TextSprite;
	
	var playMusic : TextSprite;
	var pauseMusic : TextSprite;
	var stopMusic : TextSprite;
	var resumeMusic : TextSprite;
	
    var playEffect1 : TextSprite;
	var pauseEffect1 : TextSprite;
	var stopEffect1 : TextSprite;
	var resumeEffect1 : TextSprite;
	
	var playEffect2 : TextSprite;
	var pauseEffect2 : TextSprite;
	var stopEffect2 : TextSprite;
	var resumeEffect2 : TextSprite;
	
	var pauseAllEffects : TextSprite;
	var stopAllEffects : TextSprite;
	var resumeAllEffects : TextSprite;
	var audioEngine : AudioEngine;
	var font : Font;
	
	public function new() 
	{
		audioEngine = AudioEngine.getInstance(CCLoader.pack);
	}
	
	override public function onAdded()
	{	
		back = new TextSprite(new Font(CCLoader.pack, "myfont"), "BACK");
		back.setXY(800, 0);
		back.pointerUp.connect(function(_) {
			owner.dispose();
			System.root.addChild(new Entity().add(MainScreen.getInstance()));
		});
		owner.addChild(new Entity().add(back));
		
		playMusic = new TextSprite(new Font(CCLoader.pack, "myfont"), "PlayMusic");
		playMusic.setAnchor(0, 0).setXY(0, 0);
		owner.addChild(new Entity().add(playMusic ));
		playMusic.pointerUp.connect(function(_) {
			audioEngine.playMusic("TestMusic/BadDay");
		});
		
		
		stopMusic = new TextSprite(new Font(CCLoader.pack, "myfont"), "StopMusic");
		stopMusic.setAnchor(0, 0).setXY(200, 0);
		owner.addChild(new Entity().add(stopMusic));

		stopMusic.pointerUp.connect(function(_) {
			audioEngine.stopMusic();
		});
		
		pauseMusic = new TextSprite(new Font(CCLoader.pack, "myfont"), "PauseMusic");
		pauseMusic.setAnchor(0, 0).setXY(400, 0);
		owner.addChild(new Entity().add(pauseMusic ));
		pauseMusic.pointerUp.connect(function(_) {
			audioEngine.pauseMusic();
		});
		
		
		resumeMusic = new TextSprite(new Font(CCLoader.pack, "myfont"), "ResumeMusic");
		resumeMusic.setAnchor(0, 0).setXY(600, 0);
		owner.addChild(new Entity().add(resumeMusic));

		resumeMusic.pointerUp.connect(function(_) {
			audioEngine.resumeMusic();
		});
		
		var rewindMusic = new TextSprite(new Font(CCLoader.pack, "myfont"), "RewindMusic");
		rewindMusic.setAnchor(0, 0).setXY(0, 600);
		owner.addChild(new Entity().add(rewindMusic));

		rewindMusic.pointerUp.connect(function(_) {
			audioEngine.rewindMusic();
		});

		addEffect1();
		addEffect2();
		addAllEffects();
		addVolume();
	}
	
	private function addEffect1() {
		var e1 : String = "TestMusic/Effect1";
		playEffect1 = new TextSprite(new Font(CCLoader.pack, "myfont"), "PlayEffect1");
		playEffect1.setAnchor(0, 0).setXY(0, 100);
		owner.addChild(new Entity().add(playEffect1));
		playEffect1.pointerUp.connect(function(_) {
			audioEngine.playEffect(e1, true);
		});
		
		
		stopEffect1 = new TextSprite(new Font(CCLoader.pack, "myfont"), "StopEffect1");
		stopEffect1.setAnchor(0, 0).setXY(200, 100);
		owner.addChild(new Entity().add(stopEffect1));

		stopEffect1.pointerUp.connect(function(_) {
			audioEngine.stopEffect(e1);
		});
		
		pauseEffect1 = new TextSprite(new Font(CCLoader.pack, "myfont"), "PauseEffect1");
		pauseEffect1.setAnchor(0, 0).setXY(400, 100);
		owner.addChild(new Entity().add(pauseEffect1));
		pauseEffect1.pointerUp.connect(function(_) {
			audioEngine.pauseEffect(e1);
		});
		
		
		resumeEffect1 = new TextSprite(new Font(CCLoader.pack, "myfont"), "ResumeEffect1");
		resumeEffect1.setAnchor(0, 0).setXY(600, 100).setScale(0.8);
		owner.addChild(new Entity().add(resumeEffect1));

		resumeEffect1.pointerUp.connect(function(_) {
			audioEngine.resumeEffect(e1);
		});
	}
	
	private function addEffect2() {
		var e2 : String = "TestMusic/Effect2";
		playEffect2 = new TextSprite(new Font(CCLoader.pack, "myfont"), "PlayEffect2");
		playEffect2.setAnchor(0, 0).setXY(0, 200);
		owner.addChild(new Entity().add(playEffect2));
		playEffect2.pointerUp.connect(function(_) {
			audioEngine.playEffect(e2, true);
		});
		
		
		stopEffect2 = new TextSprite(new Font(CCLoader.pack, "myfont"), "StopEffect2");
		stopEffect2.setAnchor(0, 0).setXY(200, 200);
		owner.addChild(new Entity().add(stopEffect2));

		stopEffect2.pointerUp.connect(function(_) {
			audioEngine.stopEffect(e2);
		});
		
		pauseEffect2 = new TextSprite(new Font(CCLoader.pack, "myfont"), "PauseEffect2");
		pauseEffect2.setAnchor(0, 0).setXY(400, 200);
		owner.addChild(new Entity().add(pauseEffect2));
		pauseEffect2.pointerUp.connect(function(_) {
			audioEngine.pauseEffect(e2);
		});
		
		
		resumeEffect2 = new TextSprite(new Font(CCLoader.pack, "myfont"), "ResumeEffect2");
		resumeEffect2.setAnchor(0, 0).setXY(600, 200);
		owner.addChild(new Entity().add(resumeEffect2));

		resumeEffect2.pointerUp.connect(function(_) {
			audioEngine.resumeEffect(e2);
		});
	}
	
	private function addAllEffects() {		
		stopAllEffects = new TextSprite(new Font(CCLoader.pack, "myfont"), "StopAllEffects");
		stopAllEffects.setAnchor(0, 0).setXY(0, 300);
		owner.addChild(new Entity().add(stopAllEffects));

		stopAllEffects.pointerUp.connect(function(_) {
			audioEngine.stopAllEffects();
		});
		
		pauseAllEffects = new TextSprite(new Font(CCLoader.pack, "myfont"), "PauseAllEffects");
		pauseAllEffects.setAnchor(0, 0).setXY(300, 300);
		owner.addChild(new Entity().add(pauseAllEffects));
		pauseAllEffects.pointerUp.connect(function(_) {
			audioEngine.pauseAllEffects();
		});
		
		
		resumeAllEffects = new TextSprite(new Font(CCLoader.pack, "myfont"), "ResumeAllEffects");
		resumeAllEffects.setAnchor(0, 0).setXY(600, 300);
		owner.addChild(new Entity().add(resumeAllEffects));

		resumeAllEffects.pointerUp.connect(function(_) {
			audioEngine.resumeAllEffects();
		});
	}
	
	private function addVolume() {
		var effectVolumeI = new TextSprite(new Font(CCLoader.pack, "myfont"), "EffectVolume+").setAnchor(0, 0).setXY(0, 400);
		owner.addChild(new Entity().add(effectVolumeI));
		effectVolumeI.pointerUp.connect(function(_) {
			audioEngine.set__effectVolume(audioEngine.get__effectVolume() + 0.1);
		});
		
		var effectVolumeD = new TextSprite(new Font(CCLoader.pack, "myfont"), "EffectVolume-").setAnchor(0, 0).setXY(400, 400);
		owner.addChild(new Entity().add(effectVolumeD));
		effectVolumeD.pointerUp.connect(function(_) {
			audioEngine.set__effectVolume(audioEngine.get__effectVolume() - 0.1);
		});
		
		var musicVolumeI = new TextSprite(new Font(CCLoader.pack, "myfont"), "MusicVolume+").setAnchor(0, 0).setXY(0, 500);
		owner.addChild(new Entity().add(musicVolumeI));
		musicVolumeI.pointerUp.connect(function(_) {
			audioEngine.set__musicVolume(audioEngine.get__musicVolume() + 0.1);
		});
		
		var musicVolumeD = new TextSprite(new Font(CCLoader.pack, "myfont"), "MusicVolume-").setAnchor(0, 0).setXY(400, 500);
		owner.addChild(new Entity().add(musicVolumeD));
		musicVolumeD.pointerUp.connect(function(_) {
			audioEngine.set__musicVolume(audioEngine.get__musicVolume() - 0.1);
		});
		owner.addChild(new Entity().add(effectVolumeD));
		owner.addChild(new Entity().add(effectVolumeI));
		owner.addChild(new Entity().add(musicVolumeD));
		owner.addChild(new Entity().add(musicVolumeI));
	}
	
}