package cc.tilemapparallaxnodes;
import cc.basenodes.CCNode;
import cc.spritenodes.CCSprite;
import flambe.display.Sprite;
import flambe.Entity;
import cc.cocoa.CCGeometry;
import cc.platform.CCCommon;
import cc.tilemapparallaxnodes.CCTMXXMLParser;
import flambe.math.Point;
import flambe.math.Rectangle;

/**
 * ...
 * @author Ang Li
 */
class CCTMXTiledMap extends CCSprite
{
	public static var useViewPort : Bool = false;
	public static var viewPort : Rectangle = new Rectangle();
	/**
	 Orthogonal orientation
	 * @constant
	 * @type Number
	 */
	public static var TMX_ORIENTATION_ORTHO : Int = 0;

	/**
	 * Hexagonal orientation
	 * @constant
	 * @type Number
	 */

	public static var TMX_ORIENTATION_HEX : Int = 1;

	/**
	 * Isometric orientation
	 * @constant
	 * @type Number
	 */
	public static var TMX_ORIENTATION_ISO : Int = 2;
	
	
	//var _tiledMap : TiledMap;
	
	var _mapSize : CCSize;
	var _tileSize : CCSize;
	var _properties : Array < Map < String, String >> ;
	var _objectGroups : Array<CCTMXObjectGroup>;
	var _mapOrientation : Int;
	var _TMXLayers : Array<CCTMXLayer>;
	var _tileProperties : Map < Int, Map < String, String >>;
	
	public function new() 
	{
		super();
		_mapOrientation = 0;
		_mapSize = new CCSize();
		_tileSize = new CCSize();
		_objectGroups = new Array<CCTMXObjectGroup>();
		_TMXLayers = new Array<CCTMXLayer>();

	}
	
	public function getMapSize() : CCSize {
		return this._mapSize;
	}
	
	public function setMapSize(v : CCSize) {
		this._mapSize = v;
		//this._tiledMap.height = v.height;
		//this._tiledMap.width = v.width;
	}
	
	public function getTileSize() : CCSize {
		return this._tileSize;
	}
	
	public function setTileSize(v : CCSize) {
		this._tileSize = v;
		//_tiledMap.tileheight = v.height;
		//_tiledMap.tilewidth = v.width;
	}
	
	public function getMapOrientation() : Int {
		return this._mapOrientation;
	}
	
	public function setMapOrientation(v : Int) {
		this._mapOrientation = v;
		//this._tiledMap.orientation
	}
	
	public function getObjectGroups() : Array<CCTMXObjectGroup> {
		return this._objectGroups;
	}
	
	public function setObjectGroups(v : Array<CCTMXObjectGroup>) {
		this._objectGroups = v;
	}
	
	//public function getProperties(
	
	public function initWithTMXFile(tmxFile : String, ?resourcePath : String) : Bool {
		CCCommon.assert(tmxFile != null && tmxFile.length > 0, "TMXTiledMap: tmx file should not be nil");
		this.setContentSize(new CCSize(0, 0));
		var mapInfo : CCTMXMapInfo = CCTMXMapInfo.create(tmxFile, resourcePath);
		for (l in mapInfo.getLayers()) {
			//trace(l.name);
			//trace(l._tiles);
			//trace(l._tiles.length);
		}
		if (mapInfo == null) {
			return false;
		}
		
		CCCommon.assert(mapInfo.getTilesets().length != 0, "TMXTiledMap: Map not found. Please check the filename.");
		this._buildWithMapInfo(mapInfo);
		return true;
	}
	
	private function _buildWithMapInfo(mapInfo : CCTMXMapInfo) {
		this._mapSize = mapInfo.getMapSize();
		this._tileSize = mapInfo.getTileSize();
		this._mapOrientation = mapInfo.getOrientation();
        this._objectGroups = mapInfo.getObjectGroups();
        this._properties = mapInfo.getProperties();
        this._tileProperties = mapInfo.getTileProperties();
		
		var idx = 0;
		var layers = mapInfo.getLayers();
		if (layers != null) {
			for (l in layers) {
				var child : CCTMXLayer = this._parseLayer(l, mapInfo);
				child.setAnchorPoint(new Point(0, 0));
				child.setPosition(0, 0);
				this.addChild(child, idx, idx);
				idx++;
				
				
				var childSize = child.getContentSize();
				var currentSize = this.getContentSize();
				currentSize.width = Math.max(currentSize.width, childSize.width);
				currentSize.height = Math.max(currentSize.height, childSize.height);
				
				this.setContentSize(currentSize);
				
			}
		}
	}
	
	private function _parseLayer(layerInfo, mapInfo) : CCTMXLayer {
		var tileset = this._tilesetForLayer(layerInfo, mapInfo);
		var layer : CCTMXLayer = CCTMXLayer.create(tileset, layerInfo, mapInfo);
		layer.setupTiles();
		return layer;
	}
	
	private function _tilesetForLayer(layerInfo : CCTMXLayerInfo, mapInfo : CCTMXMapInfo) : CCTMXTilesetInfo {
		var size = layerInfo._layerSize;
        var tilesets = mapInfo.getTilesets();
        if (tilesets != null) {
			var i = tilesets.length - 1;
			while ( i >= 0) {
            //for (var i = tilesets.length - 1; i >= 0; i--) {
                var tileset = tilesets[i];
                if (tileset != null) {
                    for (y in 0...Std.int(size.height)) {
                        for (x in 0...Std.int(size.width)) {
                            //var pos = x + size.width * y;
                            var gid = layerInfo._tiles[Std.int(y * size.width) + x];
                            if (gid != 0) {
                                // Optimization: quick return
                                // if the layer is invalid (more than 1 tileset per layer) an cc.Assert will be thrown later
                                if (((gid & CCTMXXMLParser.TMX_TILE_FLIPPED_MASK)>>>0) >= tileset.firstGid) {
                                    return tileset;
                                }
                            }

                        }
                    }
                }
				i--;
            }
		}
		return null;
	}
	
	/** return the TMXLayer for the specific layer
     * @param {String} layerName
     * @return {cc.TMXLayer}
     */
	 public function getLayer(layerName : String) : CCTMXLayer {
        CCCommon.assert(layerName != null && layerName.length > 0, "Invalid layer name!");

        for (i in 0...this._children.length) {
            var layer : CCTMXLayer = cast (this._children[i], CCTMXLayer);
            if (layer != null) {
                if (layer.getLayerName() == layerName) {
                    return layer;
                }
            }
        }

        // layer not found
        return null;
    }
	
	public function getObjectGroup(groupName : String) : CCTMXObjectGroup {
		CCCommon.assert(groupName != null && groupName.length > 0, "Invalid group name!");
		if (this._objectGroups != null) {
			for (o in _objectGroups) {
				if (o != null && o.getGroupName() == groupName) {
					return o;
				}
			}
		}
		return null;
	}
	public static function create(tmxFile : String, resourcePath : String) : CCTMXTiledMap {
		var ret = new CCTMXTiledMap();
		if (ret.initWithTMXFile(tmxFile, resourcePath)) {
			return ret;
		}
		
		return null;
	}
	
	
}