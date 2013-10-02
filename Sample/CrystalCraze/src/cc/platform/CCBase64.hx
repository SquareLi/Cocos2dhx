package cc.platform;


import format.gz.Reader;
/**
 * decodeAsArray and base64ToByteArray are copied from
 * https://github.com/po8rewq/HaxeFlixelTiled/blob/master/org/flixel/tmx/TmxLayer.hx
 */
class CCBase64
{

	public function new() 
	{
		
	}
	
	//public function decode(input : String) : String {
		//
	//}
	
	//Only for Tiledmap
	//public static function decodeAsArray(chunk : String, lineWidth : Int, compressed:Bool) : Array<Array<Int>> {
		//var result:Array<Array<Int>> = new Array<Array<Int>>();
		//var data:ByteArray = base64ToByteArray(chunk);
		//if(compressed)
			//data.uncompress();
		//data.endian = Endian.LITTLE_ENDIAN;
		//while(data.position < data.length)
		//{
			//var resultRow:Array<Int> = new Array<Int>();
			//var i:Int;
			//for (i in 0...lineWidth)
				//resultRow.push(data.readInt());
			//result.push(resultRow);
		//}
		//return result;
	//}
	//
	//public static function decodeAsArrayGZip(chunk : String, lineWidth : Int, compressed : Bool) : Array<Array<Int>> {
		//var result:Array<Array<Int>> = new Array<Array<Int>>();
		//var data:ByteArray = base64ToByteArray(chunk);
		//
		//var s = data.toString();
		//Reader
	//}
	//
	//private static inline var BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
//
	//private static function base64ToByteArray(data:String):ByteArray 
	//{
		//var output:ByteArray = new ByteArray();
		//initialize lookup table
		//var lookup:Array<Int> = new Array<Int>();
		//var c:Int;
		//for (c in 0...BASE64_CHARS.length)
		//{
			//lookup[BASE64_CHARS.charCodeAt(c)] = c;
		//}
//
		//var i:Int = 0;
		//while (i < data.length - 3) 
		//{
			// Ignore whitespace
			//if (data.charAt(i) == " " || data.charAt(i) == "\n")
			//{
				//i++; continue;
			//}
//
			//read 4 bytes and look them up in the table
			//var a0:Int = lookup[data.charCodeAt(i)];
			//var a1:Int = lookup[data.charCodeAt(i + 1)];
			//var a2:Int = lookup[data.charCodeAt(i + 2)];
			//var a3:Int = lookup[data.charCodeAt(i + 3)];
//
			// convert to and write 3 bytes
			//if(a1 < 64)
				//output.writeByte((a0 << 2) + ((a1 & 0x30) >> 4));
			//if(a2 < 64)
				//output.writeByte(((a1 & 0x0f) << 4) + ((a2 & 0x3c) >> 2));
			//if(a3 < 64)
				//output.writeByte(((a2 & 0x03) << 6) + a3);
//
			//i += 4;
		//}
//
		// Rewind & return decoded data
		//output.position = 0;
		//return output;
	//}
	
}