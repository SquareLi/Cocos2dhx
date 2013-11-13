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

package cc;
import cc.basenodes.CCNode;
import cc.touchdispatcher.CCPointerHandler;
/**
 * ...
 * @author
 */

class CCScheduler 
{
	var _timeScale : Float = 1.0;
	var _updatesNegList : List<Type>;
	public function new() 
	{
		
	}
	
	public function scheduleCallbackFortarget(target : CCNode, callback_fn : Void -> Void, interval : Float, repeat : Float, delay : Float, paused : Bool) {
		
	}
	
	@:generic public static function ArrayRemoveObjectAtIndex<T>(arr : Array<T>, index : Int) {
		arr.splice(index, 1);
	}
	@:generic public static function ArrayRemoveObject<T>(arr : Array<T>, delObj : T) {
		arr.remove(delObj);
	}
	
	/**
	 * Removes from arr all values in minusArr. For each Value in minusArr, the first matching instance in arr will be removed.
	 * @function
	 * @param {Array} arr Source Array
	 * @param {Array} minusArr minus Array
	 */
	@:generic public static function ArrayRemoveArray<T>(arr : Array<T>, minusArr : Array<T>) {
		for (i in 0...minusArr.length) {
			CCScheduler.ArrayRemoveObject(arr, minusArr[i]);
		}
	}
	
	/**
	 * Returns index of first occurence of value, -1 if value not found.
	 * @function
	 * @param {Array} arr Source Array
	 * @param {*} value find value
	 * @return {Number} index of first occurence of value
	 */
	@:generic public static function ArrayGetIndexOfValue<T>(arr : Array<T>, value : T) : Int {
		for (i in 0...arr.length) {
			if (arr[i] == value) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * append an object to array
	 * @function
	 * @param {Array} arr
	 * @param {*} addObj
	 */
	@:generic public static function ArrayAppendObject<T>(arr : Array<T>, addObj : T) {
		arr.push(addObj);
	}
	
	
	/**
	 * Inserts an object at index
	 * @function
	 * @param {Array} arr
	 * @param {*} addObj
	 * @param {Number} index
	 * @return {Array}
	 */
	@:generic public static function ArrayAppendObjectToIndex<T>(arr : Array<T>, addObj : T, index : Int) {
		var part1 = arr.splice(0, index);
		var part2 = arr.slice(index);
		part1.push(addObj);
		arr = (part1.concat(part2));
		return arr;
	}
	
	/**
	 * Returns index of first occurence of object, -1 if value not found.
	 * @function
	 * @param {Array} arr Source Array
	 * @param {*} findObj find object
	 * @return {Number} index of first occurence of value
	 */
	@:generic public static function ArrayGetIndexOfObject<T>(arr : Array<T>, findObj : T) : Int {
		for (i in 0...arr.length) {
			if (arr[i] == findObj) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * Returns a Boolean value that indicates whether value is present in the array.
	 * @function
	 * @param {Array} arr
	 * @param {*} findObj
	 * @return {Boolean}
	 */
	 @:generic public static function ArrayContainsObject<T>(arr : Array<T>, findObj : T) : Bool {
		 if (ArrayGetIndexOfObject(arr, findObj) != -1 ) {
			 return true;
		 } else {
			 return false;
		 }
	 }
	 
	 /**
	 * find object from array by target
	 * @param {Array} arr source array
	 * @param {cc.ListEntry|cc.HashUpdateEntry|cc.HashSelectorEntry} findInt find target
	 * @return {cc.ListEntry|cc.HashUpdateEntry|cc.HashSelectorEntry}
	 */
	 //@:generic public static function HASH_FIND_INT<T>(arr : Array<T>, findInt : T) : T {
		 //if (arr == null) {
			 //return null;
		 //}
		 //
		 //for (i in 0...arr.length) {
			 //if (arr[i].
		 //}
	 //}
}

