package sample.config;

/**
 * ...
 * @author Ang Li
 */
class Level
{
	
	public var enemies : Array<Entry>;
	public function new() 
	{
		
		
	}
	
	public static function initLevel1() : Level{
		var level1 : Level = new Level();
		
		level1.enemies = new Array<Entry>();
		var e : Entry = new Entry();
		e.showType = "Repeate";
		e.showTime = "00:02";
		e.types = [0, 1, 2];
		level1.enemies.push(e);
		
		var e1 : Entry = new Entry();
		e1.showType = "Repeate";
		e1.showTime = "00:05";
		e1.types = [3, 4, 5];
		level1.enemies.push(e1);
		return level1;
	}
	
}

class Entry {
	public var showType : String;
	public var showTime : String;
	public var types : Array<Int>;
	
	public function new() {
		
	}
}