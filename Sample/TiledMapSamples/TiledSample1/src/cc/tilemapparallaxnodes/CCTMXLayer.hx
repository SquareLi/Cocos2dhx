package cc.tilemapparallaxnodes;
import cc.CCComponent;
import cc.spritenodes.CCSprite;
import cc.cocoa.CCGeometry;
import flambe.math.Point;
import flambe.tmx.data.TiledAttributes;
import haxe.Int64;
import cc.tilemapparallaxnodes.CCTMXXMLParser;
import cc.platform.CCCommon;
/**
 * ...
 * @author Ang Li
 */
class CCTMXLayer extends CCSprite
{
	var _layerSize : CCSize;
	var _mapTileSize : CCSize;
	var _tiles : Array<Array<Int>>;
	//var _tileSet : CCTMXTilesetInfo;
	var _layerOrientation : Int;
	var _properties : Map<String, String>;
	var _layerName : String;
	//var _opacity : Int;
	var _minGID : Int;
	var _maxGID : Int;
	
	
	public function new() 
	{
		super();
		this._children = [];
		this._layerSize = new CCSize();
		this._mapTileSize = new CCSize();
		this._opacity = 255;
		this._layerName = "";
		_tiles = new Array<Array<Int>>();
		_properties = new Map<String, String>();
	}
	
	public function getLayerSize() : CCSize {
		return this._layerSize;
	}
	
	public function setLayerSize(v : CCSize) {
		this._layerSize = v;
	}
	
	public function getLayerName() : String {
		return this._layerName;
	}
	
	public function setLayerName(layerName : String) {
		this._layerName = layerName;
	}
	
	public function getMapTileSize() : CCSize {
		return this._mapTileSize;
	}
	
	public function setMapTileSize(v : CCSize) {
		this._mapTileSize = v;
	}
	
	public function getTiles() : Array<Array<Int>> {
		return this._tiles;
	}
	
	public function setTiles(v : Array<Array<Int>>) {
		this._tiles = v;
	}
	
	//public function getTileSet() : CCTMXTilesetInfo {
		//return this._tileSet;
	//}
	//
	//public function setTileSet(v : CCTMXTilesetInfo) {
		//this._tileSet = v;
	//}
	
	public function getLayerOrientation() : Int {
		return this._layerOrientation;
	}
	
	public function setLayerOrientation(v : Int) {
		this._layerOrientation = v;
	}
	
	public function getProperties() : Map < String, String > {
		return this._properties;
	}
	
	public function setProperties(v : Map < String, String > ) {
		this._properties = v;
	}
	
	public function getTileGIDAt(pos : Point) : Int {
		CCCommon.assert(pos.x < this._layerSize.width && pos.y < this._layerSize.height && pos.x >= 0 && pos.y >= 0, "TMXLayer: invalid position");
        //CCCommon.assert(this._tiles != null && this._atlasIndexArray, "TMXLayer: the tiles map has been released");

        //var idx = 0 | (pos.x + pos.y * this._layerSize.width);
        // Bits on the far end of the 32-bit global tile ID are used for tile flags
		
        var tile = this._tiles[Std.int(pos.y)][Std.int(pos.x)];

        //return (tile & cc.TMX_TILE_FLIPPED_MASK) >>> 0;
		return tile;
	}
	
	public function initWithTilesetInfo(layerInfo : CCTMXLayerInfo, mapInfo : CCTMXMapInfo) : Bool {
		var size = layerInfo._layerSize;
		var totalNumberOfTiles = Std.int(size.width * size.height);
		
		
		this.sprite = new CCTMXSprite(layerInfo, mapInfo);
		this.setAnchorPoint(new Point(0, 0));
		this.entity.add(sprite);
		this.component = new CCComponent(this);
		this.entity.add(this.component);
		
		this.setContentSize(new CCSize(this.sprite.getNaturalWidth(), this.sprite.getNaturalHeight()));
		this._layerSize = this.getContentSize();
		this._layerName = layerInfo.name;
		this._tiles = layerInfo._tiles;
		this._minGID = layerInfo._minGID;
		this._maxGID = layerInfo._maxGID;
		this.setProperties(layerInfo.getProperties());
		this._opacity = layerInfo._opacity;
		this.setOpacity(this._opacity);
		
		
		return true;
	}
	
	public static function create(layerInfo : CCTMXLayerInfo, mapInfo : CCTMXMapInfo) {
		var ret = new CCTMXLayer();
		if (ret.initWithTilesetInfo(layerInfo, mapInfo)) {
			return ret;
		}
		
		return null;
	}
	
}