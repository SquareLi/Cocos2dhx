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

package cc.touchdispatcher;

import flambe.math.Point;
/**
 * ...
 * @author Ang Li
 */

class CCPointer
{
	var _point : Point;
	var _prevPoint : Point; 
	var _id : Int;
	
	public function new(x : Float, y : Float, ?id : Int = 0) {
		_point = new Point(x, y);
		_prevPoint = new Point(0, 0);
		_id = id;
	}
	
	public function getLocation() : Point {
		return this._point;
	}
	
	public function getPreviousLocation() : Point {
		return this._prevPoint;
	}
	
	public function getId() : Int {
		return this._id;
	}
	
	public function setPointerInfo(id : Int, x : Float, y : Float) {
		this._prevPoint = this._point;
		this._point = new Point(x, y);
		this._id = id;
	}
	
	public function _setPrevPoint(x : Float, y : Float) {
		this._prevPoint = new Point(x, y);
	}
}