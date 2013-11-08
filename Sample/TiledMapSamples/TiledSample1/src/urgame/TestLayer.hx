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
import flambe.math.Rectangle;
import cc.action.CCActionInterval;
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
	var viewPort : Rectangle;
	var playerVec : Float = 16;
	var speedY : Float = 0;
	var speedX : Float = 0;
	public function new() 
	{
		super();
		
		//Only draw the map in the viewport to improve the performence
		CCTMXTiledMap.useViewPort = true;
		CCTMXTiledMap.viewPort = new Rectangle(0, 0, 3000, 1500);
		map = CCTMXTiledMap.create("Resources/level-1.tmx", "Resources");
		
		this.addChild(map);
		setPointerEnabled(true);
		//
		player = CCSprite.create("Resources/Player");
		//Set the player in the center of the map
		player.setPosition(map.getMapSize().width * map.getTileSize().width / 2 + 32, 16 + map.getMapSize().height * map.getTileSize().height / 2);
		player.setAnchorPoint(new Point(0.5, 1));
		tilePosFromLocation(player.getPosition());
		this.setKeyboardEnabled(true);
		offset = new Point();
		metaLayer = map.getLayer("Meta");
		oldPosition = new Point(player.getPositionX(), player.getPositionY());
		
		
		//Get the objects layer
		map.getLayer("Houses").addChild(player);
		
		//Adjust the viewport
		initCenterPoint(player.getPosition());
		
		
		viewPort = new Rectangle(0, 0, CCDirector.getInstance().getWinSize().width, CCDirector.getInstance().getWinSize().height);
		des = new Point();
		viewPort.x = 0 - this.getPositionX();
		viewPort.y = 0 - this.getPositionY();
		//Update the viewport
		CCTMXTiledMap.viewPort = viewPort;
	}
	
	var oldPosition : Point;
	override public function update(dt:Float)
	{
		super.update(dt);
		if (isMove) {
			var offset = new Point(speedX, speedY);
			var p : Point = CCPointExtension.pAdd(offset, player.getPosition());
			if (!checkCollision(p)) {
				player.setPosition(p.x, p.y);
				this.setPosition(this.getPositionX() - offset.x, this.getPositionY() - offset.y);
				updateZOrder();
				var width = CCDirector.getInstance().getWinSize().width;
				var height = CCDirector.getInstance().getWinSize().height;
				viewPort.x = 0 - this.getPositionX();
				viewPort.y = 0 - this.getPositionY();
				//Update the viewport
				//CCTMXTiledMap.viewPort = viewPort;
				//trace(viewPort);
			} else {
				isMove = false;
				offset.x = 0;
				offset.y = 0;
				this.player.stopAllActions();
			}
		}
	}
	
	public function initCenterPoint(pos : Point) {
		//trace("pos = " + pos);
		var x : Float = this.getPositionX();
		var y : Float = this.getPositionY();
		
		var width = CCDirector.getInstance().getWinSize().width;
		var height = CCDirector.getInstance().getWinSize().height;
		
		var diffx = x + width / 2 - pos.x;
		var diffy = y + height / 2 - pos.y;
		//trace(diffx, diffy);
		
		this.setPosition(x + diffx, y + diffy);
	}
	
	private function checkCollision(pos : Point) : Bool {
		
		
		var pt : Point = tilePosFromLocation(pos);
		if (pt.x < 0 || pt.x > map.getMapSize().width - 1
			|| pt.y < 0 || pt.y > map.getMapSize().height - 1) {
				return true;
		}
		//trace(pt);
		var array = metaLayer.getTiles();
		
		var count : Int = 0;
		for (i in array) {
			if (i != 0) {
				var y = Math.floor(count / map.getMapSize().width);
				var x = count % map.getMapSize().width;
				if (pt.x == x && pt.y == y) {
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
	
	var des : Point;
	override public function onPointerDown(event:CCPointer):Bool 
	{
		
		start = event.getLocation();
		//trace(start);
		//var pos : Point = event.getLocation();
		
		
		//if (pos.y <= 100) {
			//offset.y -= speedY;
			//isMove = true;
		//} else if(pos.y > 300){
			//offset.y += speedY;
				//isMove = true;
		//} else if (pos.x < 100) {
			//offset.x -= speedX;
				//isMove = true;
		//} else if (pos.x > 220) {
			//offset.x += speedX;
				//isMove = true;
		//}
		des = new Point(event.getLocation().x + viewPort.x, event.getLocation().y + viewPort.y);
		//trace(des);
		
		
		var disX = des.x - player.getPositionX();
		var disY = des.y - player.getPositionY();
		
		if (disX == 0 && disY == 0) {
			return true;
		}
		
		var l : Float = disX / disY;
		
		speedX = Math.sqrt((l * l * playerVec * playerVec) / (1 + l * l));
		speedY = Math.sqrt((playerVec * playerVec) / (1 + l * l));
		
		if (disX < 0) {
			speedX = -speedX;
		}
		
		if (disY < 0) {
			speedY = -speedY;
		}
		isMove = true;
		
		return true;
	}
	
	//override public function onPointerDragged(event:CCPointer):Bool 
	//{
		//var x = this.getPositionX();
		//var y = this.getPositionY();
		//
		//x = x + event.getLocation().x - start.x;
		//y = y + event.getLocation().y - start.y;
		//this.setPosition(x, y);
	//
		//
		//start = event.getLocation();
		//
		//isMove = false;
				//offset.x = 0;
				//offset.y = 0;
				//
		//isMove = false;
		//return false;
	//}
	
	override public function onPointerUp(event:CCPointer):Bool 
	{
		isMove = false;
		//offset.x = 0;
		//offset.y = 0;
		player.stopAllActions();
		return true;
	}
	
	
	//override public function onKeyDown(event:KeyboardEvent)
	//{
		//var position : Point = player.getPosition();
		//switch(event.key) {
			//case Key.Up :
				//offset.y -= speedY;
				//isMove = true;
			//case Key.Down :
				//offset.y += speedY;
				//isMove = true;
			//case Key.Right :
				//offset.x += speedX;
				//isMove = true;
			//case Key.Left :
				//offset.x -= speedX;
				//isMove = true;
			//default :
				//null;
				//
		//}
	//}
	//
	//override public function onKeyUp(event:KeyboardEvent) {
		//switch(event.key) {
			//case Key.Up :
				//isMove = false;
				//offset.x = 0;
				//offset.y = 0;
			//case Key.Down :
				//isMove = false;
				//offset.x = 0;
				//offset.y = 0;
			//case Key.Right :
				//isMove = false;
				//offset.x = 0;
				//offset.y = 0;
			//case Key.Left :
				//isMove = false;
				//offset.x = 0;
				//offset.y = 0;
			//default :
				//null;
				//
		//}
	//}
}