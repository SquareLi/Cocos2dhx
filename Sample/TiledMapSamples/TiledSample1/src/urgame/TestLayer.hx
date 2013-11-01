package urgame;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.tilemapparallaxnodes.CCTMXTiledMap;
import cc.touchdispatcher.CCPointer;
import flambe.math.Point;

/**
 * ...
 * @author Ang Li(李昂)
 */
class TestLayer extends CCLayer
{
	var map : CCTMXTiledMap;
	public function new() 
	{
		super();
		map = CCTMXTiledMap.create("Resources/level-1.tmx", "Resources");
		this.addChild(map);
		setPointerEnabled(true);
	}
	
	var start : Point;
	var end : Point;
	override public function onPointerDown(event:CCPointer):Bool 
	{
		start = event.getLocation();
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
		return false;
	}
	
}