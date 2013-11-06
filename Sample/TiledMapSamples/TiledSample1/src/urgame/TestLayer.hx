package urgame;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.spritenodes.CCSprite;
import cc.tilemapparallaxnodes.CCTMXLayer;
import cc.tilemapparallaxnodes.CCTMXTiledMap;
import cc.touchdispatcher.CCPointer;
import flambe.input.KeyboardEvent;
import flambe.math.Point;
import flambe.input.Key;
import cc.cocoa.CCGeometry;
import cc.support.CCPointExtension;
import cc.CCDirector;
/**
 * ...
 * @author Ang Li(李昂)
 */
class TestLayer extends CCLayer
{
	var map : CCTMXTiledMap;
	var block : Array<Array<Int>>;
	var metaLayer : CCTMXLayer;
	var player : CCSprite;
	var offset : Point;
	var isMove : Bool = false;
	public function new() 
	{
		super();
		map = CCTMXTiledMap.create("Resources/level-1.tmx", "Resources");
		this.addChild(map);
		setPointerEnabled(true);
		//
		player = CCSprite.create("Resources/Player");
		
		player.setPosition(map.getMapSize().width * map.getTileSize().width / 2 + 32, 16);
		player.setAnchorPoint(new Point(0.5, 1));
		tilePosFromLocation(player.getPosition());
		this.setKeyboardEnabled(true);
		offset = new Point();
		metaLayer = map.getLayer("Meta");
		map.getLayer("Houses").addChild(player);
		
		
	}
	
	override public function update(dt:Float)
	{
		super.update(dt);
		if (isMove) {
			var p = CCPointExtension.pAdd(player.getPosition(), offset);
			if (!checkCollision(p)) {
				player.setPosition(p.x, p.y);
			}
			updateZOrder();
		}
		
	}
	
	private function checkCollision(pos : Point) : Bool {
		var pt : Point = tilePosFromLocation(pos);
		//trace(pt);
		var array = metaLayer.getTiles();
		
		var count : Int = 0;
		for (i in array) {
			if (i != 0) {
				var y = Math.floor(count / map.getMapSize().width);
				var x = count % map.getMapSize().width;
				if (pt.x == x && pt.y == y) {
					trace('x = $x, y = $y');
					return true;
				}
			}
			count++;
		}
		
		
		return false;
	}
	
	private function updateZOrder() {
		var position : Point = player.getPosition();
		var pt : Point = tilePosFromLocation(position);
		player.setZOrder(Std.int(pt.x + pt.y));
	}
	
	private function tilePosFromLocation(location : Point) : Point
	{	
		var tw : Float = map.getTileSize().width;
		var th: Float = map.getTileSize().height;
		var w : Float = map.getMapSize().width;
		var ret : Point = new Point();
		var x = location.x;
		var y = location.y;

		var retx = Math.floor((x / tw) + (y / th) - (w / 2) - 1);
		var rety = Math.floor((y / th) - (x / tw) + (w / 2));
		
		ret.x = retx ;
		ret.y = rety;
		//trace(ret);
		return ret;
	}
	
	var start : Point;
	var end : Point;
	override public function onPointerDown(event:CCPointer):Bool 
	{
		start = event.getLocation();
		trace(start);
		var pos : Point = event.getLocation();
		
		
		if (pos.y <= 100) {
			offset.y -= speedY;
			isMove = true;
		} else if(pos.y > 300){
			offset.y += speedY;
				isMove = true;
		} else if (pos.x < 100) {
			offset.x -= speedX;
				isMove = true;
		} else if (pos.x > 220) {
			offset.x += speedX;
				isMove = true;
		}
		
		return true;
	}
	
	override public function onPointerDragged(event:CCPointer):Bool 
	{
		var x = this.getPositionX();
		var y = this.getPositionY();
		
		x = x + event.getLocation().x - start.x;
		y = y + event.getLocation().y - start.y;
		this.setPosition(x, y);
	
		
		start = event.getLocation();
		
		isMove = false;
				offset.x = 0;
				offset.y = 0;
		return false;
	}
	
	override public function onPointerUp(event:CCPointer):Bool 
	{
		isMove = false;
				offset.x = 0;
				offset.y = 0;
		return true;
	}
	
	var speedY = 32;
	var speedX = 32;
	override public function onKeyDown(event:KeyboardEvent)
	{
		//var position : Point = player.getPosition();
		switch(event.key) {
			case Key.Up :
				offset.y -= speedY;
				isMove = true;
			case Key.Down :
				offset.y += speedY;
				isMove = true;
			case Key.Right :
				offset.x += speedX;
				isMove = true;
			case Key.Left :
				offset.x -= speedX;
				isMove = true;
			default :
				null;
				
		}
	}
	
	override public function onKeyUp(event:KeyboardEvent) {
		switch(event.key) {
			case Key.Up :
				isMove = false;
				offset.x = 0;
				offset.y = 0;
			case Key.Down :
				isMove = false;
				offset.x = 0;
				offset.y = 0;
			case Key.Right :
				isMove = false;
				offset.x = 0;
				offset.y = 0;
			case Key.Left :
				isMove = false;
				offset.x = 0;
				offset.y = 0;
			default :
				null;
				
		}
	}
}