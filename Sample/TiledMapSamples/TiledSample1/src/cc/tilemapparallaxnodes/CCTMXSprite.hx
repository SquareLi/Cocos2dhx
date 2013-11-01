package cc.tilemapparallaxnodes;
import flambe.display.Graphics;
import flambe.display.Sprite;
import cc.tilemapparallaxnodes.CCTMXXMLParser;
import flambe.math.Point;
import flambe.math.Rectangle;

/**
 * ...
 * @author Ang Li
 */
class CCTMXSprite extends Sprite
{
	var _mapInfo : CCTMXMapInfo;
	var _layerInfo : CCTMXLayerInfo;
	var _height : Float;
	var _width : Float;
	public function new(layerInfo : CCTMXLayerInfo, mapInfo : CCTMXMapInfo) 
	{
		super();
		this._layerInfo = layerInfo;
		this._mapInfo = mapInfo;
	}
	var flag : Bool = true;
	override public function draw(g:Graphics)
	{
		var count : Int = 0;

		for (row in 0..._layerInfo._tiles.length) {
			for (col in 0..._layerInfo._tiles[0].length) {
				var gid = _layerInfo._tiles[row][col];
				if (gid == 0) {
					continue;
				} else {
					var tilesetInfo : CCTMXTilesetInfo = getTilesetInfo(gid);
					var o : Int = _mapInfo.getOrientation();
					var x : Float = 0;
					var y : Float = 0;
					if (o == CCTMXTiledMap.TMX_ORIENTATION_ORTHO) {
						x = col * _mapInfo.getTileSize().width;
						y = row * _mapInfo.getTileSize().height;
						//trace("ortho");
					} else if (o == CCTMXTiledMap.TMX_ORIENTATION_ISO) {
						x = _mapInfo.getTileSize().width / 2 
							* ( this._layerInfo._layerSize.width + col - row);
						y = _mapInfo.getTileSize().height / 2 
							* (row + col) - tilesetInfo._tileSize.height;
					}
					
					var rect : Rectangle = tilesetInfo.rectForGID(gid);
					
					g.drawSubImage(tilesetInfo.texture, x, y, rect.x, rect.y, rect.width, rect.height);
				}
			}
		}
	}
	
	private function getTilesetInfo(gid : Int) : CCTMXTilesetInfo {
		//trace(gid);
		var a = _mapInfo.getTilesets();
		//var tileset : CCTMXTilesetInfo = new CCTMXTilesetInfo();
		for (i in 0..._mapInfo.getTilesets().length) {
			//trace(a[i].firstGid);
			if (a[i + 1] != null) {
				if (gid >= a[i].firstGid && gid < a[i + 1].firstGid) {
					//trace(gid);
					return a[i];
				}
			} else {
				return a[i];
			}
		}
		return null;
	}
	
	 
	
	override public function getNaturalWidth():Float 
	{
		return _layerInfo._layerSize.width * _mapInfo.getTileSize().width;
	}
	
	override public function getNaturalHeight():Float 
	{
		return _layerInfo._layerSize.height * _mapInfo.getTileSize().height;
	}
}