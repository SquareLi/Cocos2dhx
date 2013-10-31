package cc.platform;

/**
 * Todo
 * @author Ang Li
 */
class CCZipUtils
{

	public function new() 
	{
		
	}
	
	
	public static function unzipBase64(input : String) : String {
		var tmpInput = CCBase64.decode(input);
		return CCGZip.gunzip(tmpInput);
	}
	
	public static function unzipBase64AsArray(input : String, lineWidth : Int, ?bytes : Int = 1) : Array<Array<Int>>{
		var dec : String  = unzipBase64(input);
		var ar : Array<Int> = [];
		var len : Int = Std.int(dec.length / bytes);
		
		for (i in 0...len) {
			ar[i] = 0;
			var j = bytes - 1;
			while (j >= 0) {
			//for (j = bytes - 1; j >= 0; --j) {
				var t = dec.charCodeAt((i * bytes) + j) << (j * 8);
				ar[i] += t;
				//trace(t);
				j--;
			}
		}
		//trace(ar);
		var ret : Array<Array<Int>> = new Array<Array<Int>>();
		var row : Array<Int> = new Array<Int>();
		var count : Int = 0;
		for (i in ar) {
			if (count == lineWidth) {
				ret.push(row);
				row = [];
				count = 0;
			}
			row[count] = i;
			count++;
		}
		//trace(ret);
		return ret;
	}
}