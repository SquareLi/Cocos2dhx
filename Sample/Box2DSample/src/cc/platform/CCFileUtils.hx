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
import cc.CCLoader;

#if js
import haxe.Http;
import js.Browser;
import js.html.*;
import js.html.XMLHttpRequest;
import js.html.Event;
#end
/**
 * ...
 * @author
 */
class CCFileUtils
{
	var rootDict : Array<CCPlistEntry>;
	
	private static var s_SharedFileUtils : CCFileUtils;
	private function new() 
	{
		rootDict = new Array<CCPlistEntry>();
	}
	
	public function dictionaryWithContentsOfFile(fileName : String) : Array<CCPlistEntry> {
		var parser : CCSAXParser = CCSAXParser.getInstance();
		this.rootDict = parser.parse(fileName);
		
		return this.rootDict;
	}
	
	public static function getInstance() : CCFileUtils {
		if (s_SharedFileUtils == null) {
			s_SharedFileUtils = new CCFileUtils();
		}
		
		return s_SharedFileUtils;
	}
	
	public function getFileData(fileName : String, ?mode : String, ?size : Int) : Dynamic {
		#if flash
			return this._loadBinaryFileData(fileName);
		#elseif js
			fileName = "assets/bootstrap/" + fileName;
			return this.jsLoad(fileName);
		#end
		
	}
	//
	private function _loadBinaryFileData(fileUrl : String) : Array<Int>{
		var str : String = CCLoader.pack.getFile(fileUrl).toString();
		var arrayInfo : Array<Int> = this._stringConvertToArray(str);
		return arrayInfo;
	}
	
	private function _stringConvertToArray(strData : String) : Array<Int> {
		if (strData == null) {
			return null;
		}
		var arrData : Array<Int> = new Array<Int>();
		
		for (i in 0...strData.length) {
				arrData[i] = strData.charCodeAt(i) & 0xff;
		}
		return arrData;
	}
	
	private function jsLoad(fileUrl : String) : Array<Int> {
		
		var ret : Array<Int> = new Array<Int>();
		#if js
		var xhr : XMLHttpRequest = new XMLHttpRequest();
		xhr.open("GET", fileUrl, false);
		
		xhr.overrideMimeType("text/plain; charset=x-user-defined");
		xhr.send(null);
		if (xhr.status != 200) {
			return null;
		}
		ret = this._stringConvertToArray(xhr.responseText);
		#end
		return ret;
	}
}