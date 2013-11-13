package cc.tilemapparallaxnodes;
import cc.CCComponent;
import cc.spritenodes.CCSprite;
import cc.cocoa.CCGeometry;
import cc.spritenodes.CCSpriteBatchNode;
import cc.texture.CCTexture2D;
import flambe.math.Point;
import flambe.math.Rectangle;
import haxe.Int64;
import cc.tilemapparallaxnodes.CCTMXXMLParser;
import cc.platform.CCCommon;
import cc.texture.CCTextureCache;
/**
 * ...
 * @author
 */
class CCTMXLayer extends CCSpriteBatchNode
{
	var _layerSize : CCSize;
	var _mapTileSize : CCSize;
	var _tiles : Array<Int>;
	var _tileSet : CCTMXTilesetInfo;
	var _layerOrientation : Int;
	var _properties : Map<String, String>;
	var _layerName : String;
	var _opacity : Int;
	var _minGID : Int;
	var _maxGID : Int;
	var _useAutomaticVertexZ : Bool;
	var _vertexZvalue : Int;
	
	
	public function new() 
	{
		super();
		this._children = [];
		this._layerSize = new CCSize();
		this._mapTileSize = new CCSize();
		this._opacity = 255;
		this._layerName = "";
		_tiles = new Array<Int>();
		_properties = new Map<String, String>();
		_useAutomaticVertexZ = false;
	}
	
	public function getVertexZvalue() : Int {
		return this._vertexZvalue;
	}
	
	public function isAutomaticVertexZ() : Bool {
		return _useAutomaticVertexZ;
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
	
	public function getTiles() : Array<Int> {
		return this._tiles;
	}
	
	public function setTiles(v : Array<Int>) {
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
		
        var tile = this._tiles[Std.int(pos.y * this._layerSize.width) + Std.int(pos.x)];

        //return (tile & cc.TMX_TILE_FLIPPED_MASK) >>> 0;
		return tile;
	}
	
	var _mapInfo : CCTMXMapInfo = null;
	var _layerInfo : CCTMXLayerInfo = null;
	public function initWithTilesetInfo(layerInfo : CCTMXLayerInfo, mapInfo : CCTMXMapInfo) : Bool {
		var size = layerInfo._layerSize;
		var totalNumberOfTiles = Std.int(size.width * size.height);
		_mapInfo = mapInfo;
		this._layerInfo = layerInfo;
		var capacity : Int = Std.int(totalNumberOfTiles * 0.35 + 1);
		
		
		//var texture : CCTexture2D = null;
		//if (tilesetInfo != null) {
			//texture = CCTextureCache.getInstance().addImage(tilesetInfo.sourceImage);
		//}
		
		//if (this.initWithTexture(texture, capacity)) {
			this.setContentSize(new CCSize(this.sprite.getNaturalWidth(), this.sprite.getNaturalHeight()));
			this._layerSize = layerInfo._layerSize;
			this._layerName = layerInfo.name;
			this._tiles = layerInfo._tiles;
			this._minGID = layerInfo._minGID;
			this._maxGID = layerInfo._maxGID;
			this.setProperties(layerInfo.getProperties());
			this._opacity = layerInfo._opacity;
			this._parseInternalProperties();
			
			//this._tileSet = tilesetInfo;
			
			this._mapTileSize = mapInfo.getTileSize();
			this._layerOrientation = mapInfo.getOrientation();
			
			//var offset = this._calculateLayerOffset(layerInfo.offset);
			this._vertexZvalue = 0;
			return true;
		//}
		
		
		
		//return false;
	}
	
	public function setupTiles()
	{
		var count : Int = 0;
		//trace(Std.int(_layerInfo._layerSize.width));
		//trace(Std.int(_layerInfo._layerSize.height));
		for (row in 0...Std.int(_layerInfo._layerSize.height)) {
			for (col in 0...Std.int(_layerInfo._layerSize.width)) {
				var gid = _layerInfo._tiles[Std.int(col + row * _layerInfo._layerSize.width)];
				//if (col == 39)
						//trace(gid);
				if (gid == 0) {
					continue;
				} else {
					var tilesetInfo : CCTMXTilesetInfo = getTilesetInfo(gid);
					var t : CCTexture2D = CCTextureCache.getInstance().addImage(tilesetInfo.sourceImage);
					var o : Int = this._layerOrientation;
					var x : Float = 0;
					var y : Float = 0;
					if (o == CCTMXTiledMap.TMX_ORIENTATION_ORTHO) {
						x = col * this._mapTileSize.width;
						y = row * _mapTileSize.height;
						//trace("ortho");
					} else if (o == CCTMXTiledMap.TMX_ORIENTATION_ISO) {
						x = this._mapTileSize.width / 2 
							* ( this._layerSize.height + col - row);
						y = this._mapTileSize.height / 2 
							* (row + col + 2) - tilesetInfo._tileSize.height;
					}
					
					
					var rect : Rectangle = tilesetInfo.rectForGID(gid);
					
					
					var sprite : CCSprite = CCSprite.createWithTexture(t, rect, CCTMXTiledMap.useViewPort);
					sprite.setAnchorPoint(new Point(0, 0));
					sprite.setPosition(x, y);
					sprite.setOpacity(this._opacity);
					this.addChild(sprite, _vertexZForPos(row, col));
					//if (this._layerName == "WorldItems")
						//trace(sprite.getZOrder());
					//if (row == 13 && col == 39) {
						//trace(gid);
					//}
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
	
	private function _vertexZForPos(row : Int, col : Int) : Int {
		var ret : Int = 0;
		var maxVal = 0;
		if (this._useAutomaticVertexZ) {
			switch(this._layerOrientation) {
				case CCTMXTiledMap.TMX_ORIENTATION_ISO :
					ret = row + col;
				case CCTMXTiledMap.TMX_ORIENTATION_ORTHO :
					ret = row;
				default :
					null;
			}
		} else {
			ret = this._vertexZvalue;
		}
		
		return ret;
	}
	
	
	public static function create(layerInfo : CCTMXLayerInfo, mapInfo : CCTMXMapInfo) {
		var ret = new CCTMXLayer();
		if (ret.initWithTilesetInfo(layerInfo, mapInfo)) {
			return ret;
		}
		
		return null;
	}
	
	/**
     * Return the value for the specific property name
     * @param {String} propertyName
     * @return String
     */
	public function getProperty(propertyName : String) : String {
        return this._properties[propertyName];
    }
	
	//The layer recognizes some special properties, like cc_vertez
    private function _parseInternalProperties() {
        // if cc_vertex=automatic, then tiles will be rendered using vertexz
        var vertexz : String = this.getProperty("cc_vertexz");
        if (vertexz != null) {
            if (vertexz == "automatic") {
                this._useAutomaticVertexZ = true;
                //var alphaFuncVal = this.getProperty("cc_alpha_func");
                //var alphaFuncValue = 0;
                //if (alphaFuncVal)
                    //alphaFuncValue = parseFloat(alphaFuncVal);
//
                //if (cc.renderContextType === cc.WEBGL) {
                    //this.setShaderProgram(cc.ShaderCache.getInstance().programForKey(cc.SHADER_POSITION_TEXTURECOLORALPHATEST));
                    //var alphaValueLocation = cc.renderContext.getUniformLocation(this.getShaderProgram().getProgram(), cc.UNIFORM_ALPHA_TEST_VALUE_S);
                    // NOTE: alpha test shader is hard-coded to use the equivalent of a glAlphaFunc(GL_GREATER) comparison
                    //this.getShaderProgram().use();
                    //this.getShaderProgram().setUniformLocationWith1f(alphaValueLocation, alphaFuncValue);
                //}
            } else
                this._vertexZvalue = Std.parseInt(vertexz);
        }
    }
}