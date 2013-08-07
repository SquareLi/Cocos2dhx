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

package cc.texture;
import flambe.asset.AssetPack;
import cc.CCLoader;

/**
 * ...
 * @author Ang Li
 */
class CCTextureCache
{
	public static var g_sharedTextureCache : CCTextureCache;
	public function new() 
	{
		
	}
	
	public function addImage(path : String) : CCTexture2D {
		var pack : AssetPack = CCLoader.pack;
		var ret : CCTexture2D = new CCTexture2D();
		ret.setTexture(pack.getTexture(path));

		return ret;
	}
	
	public static function getInstance() : CCTextureCache {
		if (g_sharedTextureCache == null) {
			g_sharedTextureCache = new CCTextureCache();
		}
		return g_sharedTextureCache;
	}
}