package box2dsample.classes.maps;
import cc.tilemapparallaxnodes.CCTMXLayer;
import cc.tilemapparallaxnodes.CCTMXTiledMap;
import flambe.math.Point;
import flambe.math.Rectangle;

/**
 * ...
 * @author Ang Li(李昂)
 */
class TiledMeadow extends CCTMXTiledMap
{
	public var obstacles : Array<Rectangle>;
	public function new() 
	{
		super();
		trace("classes.maps.TiledMeadow.ctor()");
		this.initWithTMXFile("images/tiledMeadow.tmx", "images");
		this.initObstacles();
	}
	
	public function getTileCoordForPosition(position : Point) : Point{
		var x = Math.floor(position.x / this.getTileSize().width);
		var y = Math.floor(((this.getTileSize().height * this
				.getMapSize().height) - position.y)
				/ this.getTileSize().height);
		return new Point(x, y);
	}

	public function isCollidable(tileCoord) : Bool {
		var collidableLayer : CCTMXLayer = this.getLayer("collidable");
		var gid : Int = collidableLayer.getTileGIDAt(tileCoord);
		if (gid != 0) {
			//var tileProperties = this.propertiesForGID(gid);
			return true;
		}
		
		return false;
	}

	public function initObstacles() {
		this.obstacles = new Array<Rectangle>();
		var mapWidth : Int  = Std.int(this.getMapSize().width);
		var mapHeight : Int = Std.int(this.getMapSize().height);
		var tileWidth = this.getTileSize().width;
		var tileHeight = this.getTileSize().height;
		var collidableLayer : CCTMXLayer = this.getLayer("collidable");
		//collidableLayer._til
		//trace('mapWidth = $mapWidth, mapHeight = $mapHeight');
		for (i in 0...mapWidth) {
			for (j in 0...mapHeight) {
				var tileCoord = new Point(i, j);
				var gid = collidableLayer.getTileGIDAt(tileCoord);
				//trace('mapWidth = $mapWidth, mapHeight = $mapHeight');
			
				if (gid != 0) {
					var tileXPosition = i * tileWidth;
					//var tileYPosition = (mapHeight * tileHeight)
							//- ((j + 1) * tileHeight);
					
					var tileYPosition = (j) * tileHeight;
					var react = new Rectangle(tileXPosition, tileYPosition,
							tileWidth, tileHeight);
					this.obstacles.push(react);
					//trace(react);
				}
			}
		}
		trace("TiledMeadow: There are "
				+ this.obstacles.length + " tiled obstacles");
	}
}