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

package cc.spritenodes;

/**
 * ...
 * @author
 */
class CCAnimationCache
{
	var _animations : Map<String, CCAnimation>;
	private static var s_sharedAnimationCache : CCAnimationCache;
	private function new() 
	{
		
	}
	
	/**
     * Adds a cc.Animation with a name.
     * @param {cc.Animation} animation
     * @param {String} name
     */
	public function addAnimation(animation : CCAnimation, name : String) {
		this._animations.set(name, animation);
	}
	
	/**
     *  Deletes a cc.Animation from the cache.
     * @param  {String} name
     */
	public function removeAnimation(name) {
		if (name == null) {
			return;
		}
		
		if (this._animations.exists(name)) {
			this._animations.remove(name);
		}
	}
	
	/**
     * <p>
     *     Returns a cc.Animation that was previously added.<br/>
     *      If the name is not found it will return nil.<br/>
     *      You should retain the returned copy if you are going to use it.</br>
     * </p>
     * @param {String} name
     * @return {cc.Animation}
     */
	public function getAnimation(name) : CCAnimation {
		if (this._animations.exists(name)) {
			return this._animations[name];		
		}
		return null;
	}
	
	public function addAnimationsWithDictionary() {
		
	}
	
	public function init() : Bool{
		this._animations = new Map<String, CCAnimation>();
		return true;
	}
	public static function purgeSharedAnimationCache() {
		if (s_sharedAnimationCache != null) {
			s_sharedAnimationCache._animations = null;
			s_sharedAnimationCache = null;
		}
	}
	
	public static function getInstance() : CCAnimationCache {
		if (s_sharedAnimationCache == null) {
			s_sharedAnimationCache = new CCAnimationCache();
			s_sharedAnimationCache.init();
		}
		
		return s_sharedAnimationCache;
	}
}