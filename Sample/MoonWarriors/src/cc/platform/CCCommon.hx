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
import haxe.ds.HashMap;
import haxe.Log;

/**
 * ...
 * @author
 */

class CCCommon 
{

	public function new() 
	{
		
	}
	
	public static function clone<T>( v:T ) : T  { 
		if (!Reflect.isObject(v)) { // simple type 
			return v; 
		}
		else if (Std.is(v, String)) { // string
			return v;
		}
		else if(Std.is( v, Array )) { // array 
			var result = Type.createInstance(Type.getClass(v), []); 
			untyped { 
				for( ii in 0...v.length ) {
					result.push(clone(v[ii]));
				}
			} 
			return result;
		}
		else if(Std.is( v, HashMap )) { // hashmap
			var result = Type.createInstance(Type.getClass(v), []);
			untyped {
				var keys : Iterator<String> = v.keys();
				for( key in keys ) {
					result.set(key, clone(v.get(key)));
				}
			} 
			return result;
		}
		//else if(Std.is( v, IntHash )) { // integer-indexed hashmap
			//var result = Type.createInstance(Type.getClass(v), []);
			//untyped {
				//var keys : Iterator<Int> = v.keys();
				//for( key in keys ) {
					//result.set(key, clone(v.get(key)));
				//}
			//} 
			//return result;
		//}
		else if(Std.is( v, List )) { // list
			//List would be copied just fine without this special case, but I want to avoid going recursive
			var result = Type.createInstance(Type.getClass(v), []);
			untyped {
				var iter : Iterator<Dynamic> = v.iterator();
				for( ii in iter ) {
					result.add(ii);
				}
			} 
			return result; 
		}
		else if(Type.getClass(v) == null) { // anonymous object 
			var obj : Dynamic = {}; 
			for( ff in Reflect.fields(v) ) { 
				Reflect.setField(obj, ff, clone(Reflect.field(v, ff))); 
			}
			return obj; 
		} 
		else { // class 
			var obj = Type.createEmptyInstance(Type.getClass(v)); 
			for(ff in Reflect.fields(v)) {
				Reflect.setField(obj, ff, clone(Reflect.field(v, ff))); 
			}
			return obj; 
		} 
		return null; 
	}
	
	public static function log(message : String) {
		#if debug
			trace(message);
		#end
	}
	
	public static function assert(cond : Bool, message : String) {
		if (!cond) {
			throw message;
		}
	}
	
}