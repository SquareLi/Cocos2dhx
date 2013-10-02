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
/**
 * ...
 * @author Ang Li
 */
class CCSAXParser
{
	var xmlDoc : Xml;
	var plist : Array<CCPlistEntry>;
	
	private static var _instance : CCSAXParser;
	public function new() 
	{
		plist = new Array<CCPlistEntry>();
	}
	
	var frames : Xml;
	var metadata : Xml;
	public function parse(textxml : String) : Array<CCPlistEntry> {
		this.xmlDoc = Xml.parse(CCLoader.pack.getFile(textxml).toString());
		
		var index : Int = 0;
		for (x in xmlDoc.firstElement().firstElement().elements()) {
			if (x.firstChild().nodeValue == "frames") {
				index = 1;
			} else if (x.nodeName == "dict" && index == 1) {
				frames = x;
			} else if (x.firstChild().nodeValue == "metadata") {
				index = 2;
			} else if (x.nodeName == "dict" && index == 2) {
				metadata = x;
			}
			//trace(x.firstChild().nodeValue);
		}
		
		//trace(frames.firstElement().firstChild().nodeValue);
		
		index = 1;
		var tempEntry : CCPlistEntry = new CCPlistEntry();
		var tempKey : String = "";
		for (x in frames.elements()) {
			if (x.nodeName == "key" && index == 1) {
				
				tempEntry.name = x.firstChild().nodeValue;
				index = 2;
			} else if (x.nodeName == "dict" && index == 2) {
				//trace(x.toString());
				index = 1;
				for (info in x.elements()) {
					if (info.nodeName == "key") {
						tempKey = info.firstChild().nodeValue;
						//trace(tempKey);
					} else {
						switch(tempKey) {
							case "frame" : 
								var s : Array<Float> = parseString(info.firstChild().nodeValue);
								tempEntry.x = s[0];
								tempEntry.y = s[1];
								tempEntry.width = s[2];
								tempEntry.height = s[3];
								
								//break;
							case "sourceColorRect":
								var s : Array<Float> = parseString(info.firstChild().nodeValue);
								tempEntry.sourceColorX = s[0];
								//trace(s[0]);
								tempEntry.sourceColorY = s[1];
								
								
							case "rotated":
								if (info.nodeName == "true") {
									tempEntry.rotated = true;
								} else {
									tempEntry.rotated = false;
								}
								
								//trace(info.nodeName);
								
						}
					}
				}
				plist.push(new CCPlistEntry(tempEntry));
			}
		}
		
		//trace(plist[0].toString());
		return plist;
	}
	
	public function parseString(str : String) : Array<Float> {
		var ret : Array<Float> = new Array<Float>();
		var index : Int;
		var temp : String;
		var buf : StringBuf = new StringBuf();
		
		for (i in 0...str.length) {
			if (str.charAt(i) != "{" && str.charAt(i) != "}") {
				buf.addSub(str.charAt(i), 0);
			}
		}
		
		var newString : String = buf.toString();
		for (i in newString.split(",")) {
			ret.push(Std.parseFloat(i));
		}
		
		//trace(ret[0]);
		return ret;
	}
	
	public static function getInstance() : CCSAXParser {
		if (CCSAXParser._instance == null) {
			CCSAXParser._instance = new CCSAXParser();
		}
		return _instance;
	}
}