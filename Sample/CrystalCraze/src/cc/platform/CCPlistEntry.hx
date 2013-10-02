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

package cc.platform;

/**
 * ...
 * @author Ang Li
 */
class CCPlistEntry
{
	public var name : String;
	public var x : Float;
	public var y : Float;
	public var width : Float;
	public var height : Float;
	public var sourceColorX : Float;
	public var sourceColorY : Float;
	public var rotated : Bool;
	
	
	public function new(?entry : CCPlistEntry) {
		if (entry == null) {
			return;
		}
		this.name = entry.name;
		this.x = entry.x;
		this.y = entry.y;
		this.width = entry.width;
		this.height = entry.height;
		this.sourceColorX = entry.sourceColorX;
		this.sourceColorY = entry.sourceColorY;
		this.rotated = entry.rotated;
	}
	
	public function toString() : String {
		var ret : String = name + "," + Std.string(x) + "," + Std.string(y) + "," +
			Std.string(sourceColorX) + "," + Std.string(sourceColorY) + "," + Std.string(rotated);
		return ret;
		
	}	
}