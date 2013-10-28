package cc.platform;

/**
 * //Todo
 * @author Ang Li
 */
class CCGZip
{
	var data : String;
	var debug : Bool;
	var gpflags : Bool;
	var files : Int;
	var unzipped : Array<Dynamic>;
	var buf32k : Array<Dynamic>;
	var bIdx : Int;
	var modeZIP : Bool;
	var bytepos : Int;
	var bb : Int;
	var bits : Int;
	var nameBuf : Array<Dynamic>;
	//var fileout
	var literalTree : Array<Dynamic>;
	var distanceTree : Array<Dynamic>;
	var treepos : Int = 0;
	var Places : Dynamic;
	var len : Int = 0;
	var fpos = new Array<Dynamic>;
	var flens : Int;
	var fmax : Int;
	
	var outputArr : Array<Dynamic>;
	
	public function new() 
	{
		//this.gpflags = undefined;
		this.files = 0;
		this.unzipped = [];
		this.buf32k = new Array(32768);
		this.bIdx = 0;
		this.modeZIP = false;
		this.bytepos = 0;
		this.bb = 1;
		this.bits = 0;
		this.nameBuf = [];
		this.fileout = undefined;
		this.literalTree = new Array(cc.Codec.GZip.LITERALS);
		this.distanceTree = new Array(32);
		this.treepos = 0;
		this.Places = null;
		this.len = 0;
		this.fpos = new Array(17);
		this.fpos[0] = 0;
		this.flens = undefined;
		this.fmax = undefined;
	}
	
	//public static function gunzip(data : String) : String {
		//var gzip = new CCGZip(data);
		//return 
	//}
	
	public function gunzip() : Array<Dynamic> {
		outputArr = new Array<Dynamic>();
		this.nextFile();
		return this.unzipped;
	}
	
	
	public function readByte() : Int{
		this.bits += 8;
		if (this.bytepos < this.data.length) {
			return this.data.charCodeAt(this.bytepos++);
		} else {
			return -1;
		}
	}
	
	public function byteAlign() {
		this.bb = 1;
	}
	
	public function readBit() : Int {
		this.bits++;
		var carry = this.bb & 1;
		this.bb >>= 1;
		if (this.bb == 0) {
			this.bb = this.readByte();
			carry = this.bb & 1;
			this.bb = (this.bb >> 1) | 0x80;
		}
		return carry;
	}
	
	public function readBits(a : Int) {
		//var res : Int = 0;
		//var i : Int = a;
		//
		//while (i--) 
	}
}