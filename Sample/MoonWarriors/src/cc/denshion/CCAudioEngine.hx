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
package cc.denshion;
import flambe.asset.AssetPack;
import flambe.sound.Mixer;
import flambe.sound.Playback;
import flambe.sound.Sound;
import cc.CCLoader;
/**
 * ...
 * @author Ang Li
 */

class CCAudioEngine
{
	//var _supportedFormat : Array;
	var _soundEnable : Bool = false;
	var _effectList : Map<String,Playback>;
	var _musicList : Map<String,Playback>;
	var _cacheMusic : Sound;
	var _isMusicPlaying (get, null) : Bool;
	var _isMusicStop : Bool;
	var _isMusicLoop : Bool;
	
	var _playingMusic : Playback;
	var _pack : AssetPack;
	@:isVar
	var _effectVolume (get, set) : Float;
	@:isVar
	var _musicVolume (get, set) : Float;
	
	private static var _instance : CCAudioEngine;
	private function new() 
	{
		_pack = CCLoader.pack;
		_effectVolume = 1;
		_musicVolume = 1;
		_effectList = new Map<String,Playback>();
		_musicList = new Map<String,Playback>();
	}
	
	public static function getInstance() : CCAudioEngine {
		if (CCAudioEngine._instance == null) {
			_instance = new CCAudioEngine();
			_instance.init();
		}
		
		return _instance;
	}
	
	public function end() {
	}
	
	public function get__effectVolume() : Float {
		return this._effectVolume;
	}
	
	public function get__musicVolume() : Float {
		return this._musicVolume;
	}
	
	public function init() {
		
	}
	
	public function get__isMusicPlaying() : Bool {
		return this._isMusicPlaying;
	}
	
	public function pauseAllEffects() {
		for (k in _effectList.keys()) {
			var p : Playback = _effectList.get(k);
			p.paused = true;
		}
	}
	
	public function pauseEffect(path : String) {
		if (_effectList.exists(path)) {
			_effectList.get(path).paused = true;
/*			trace("Pause " + path);*/
		} else {
			return;
		}
	}
	
	public function pauseMusic() {
		if (_playingMusic == null) {
			return;
		}
		_playingMusic.paused = true;
	}
	
	public function playEffect(path : String, ?loop : Bool = false) {
		var sound = _pack.getSound(path);
		if (_effectList.exists(path)) {
			var tempPlayback : Playback = _effectList.get(path);
			//tempPlayback.paused = true;
			tempPlayback.dispose();
		}
		if (loop) _effectList.set(path, sound.loop(_effectVolume));
		else _effectList.set(path, sound.play(_effectVolume));
	}
	
	public function playMusic(path : String, ?loop : Bool = false) {
		var music : Sound = _pack.getSound(path);
		if (_playingMusic != null) {
			_playingMusic.paused = true;
			_playingMusic.dispose();
		}
		
		_cacheMusic = music;
		if (loop) {
			_playingMusic = music.loop(_musicVolume);
		} else {
			_playingMusic = music.play(_musicVolume);
		}
		_isMusicLoop = loop;
		_isMusicPlaying = true;
	}
	
	public function preloadEffect(path : String) {
	}
	
	public function preloadMusic(path : String) { }
	
	public function resumeAllEffects() {
		var i = _effectList.iterator();
		while (i.hasNext()) {
			i.next().paused = false;
		}
	}
	
	public function resumeEffect(path : String) {
		if (_effectList.exists(path)) {
			_effectList.get(path).paused = false;
		} else {
			return;
		}
	}
	
	public function resumeMusic() {
		if (_playingMusic == null) {
			return;
		} else {
			_playingMusic.paused = false;
		}
		_isMusicPlaying = true;
	}
	
	public function rewindMusic() {
		if (_playingMusic == null) {
			return;
		}
		_playingMusic.paused = true;
		
		if (_isMusicLoop) {
			_playingMusic = _playingMusic.sound.loop(_musicVolume);
		} else {
			_playingMusic = _playingMusic.sound.play(_musicVolume);
		}
		_isMusicPlaying = true;
	}
	
	public function set__effectVolume(volume : Float) : Float {
		if (volume <= 0) {
			volume = 0;
		} else if (volume > 1) {
			volume = 1;
		}
		return _effectVolume = volume;
	}
	
	public function set__musicVolume(volume : Float) : Float {
		if (volume <= 0) {
			volume = 0;
		} else if (volume > 1) {
			volume = 1;
		}
		return _musicVolume = volume;
	}
	
	public function stopAllEffects() {
		for (k in _effectList.keys()) {
			_effectList.get(k).paused = true;
			_effectList.get(k).dispose();
			trace(k);
		}
		_effectList = new Map<String,Playback>();
		trace("123");
	}
	
	public function stopEffect(path : String) {
		if (!_effectList.exists(path)) {
			return;
		}
		
		_effectList.get(path).dispose();
		trace("Stop " + path);
		_effectList.remove(path);
	}
	
	public function stopMusic() {
		if (_playingMusic == null)
			return;
		_playingMusic.dispose();
		_playingMusic = null;
		_cacheMusic = null;
		_isMusicPlaying = false;
	}
}