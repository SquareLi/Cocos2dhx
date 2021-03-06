package cc.tilemapparallaxnodes;
import cc.cocoa.CCGeometry;
import flambe.animation.AnimatedFloat;
import flambe.asset.AssetPack;
import flambe.display.Texture;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.math.Rectangle;
import cc.CCLoader;
import cc.platform.CCCommon;
import cc.platform.CCBase64;
import cc.platform.CCZipUtils;
/**
 * ...
 * @author
 */
class CCTMXXMLParser
{
	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_LAYER_ATTRIB_NONE : Int = 1 << 0;
	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_LAYER_ATTRIB_BASE64 : Int = 1 << 1;
	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_LAYER_ATTRIB_GZIP : Int = 1 << 2;
	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_LAYER_ATTRIB_ZLIB : Int = 1 << 3;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_PROPERTY_NONE : Int = 0;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_PROPERTY_MAP : Int = 1;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_PROPERTY_LAYER : Int = 2;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_PROPERTY_OBJECTGROUP : Int = 3;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_PROPERTY_OBJECT : Int = 4;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_PROPERTY_TILE : Int = 5;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_TILE_HORIZONTAL_FLAG : Int = 0x80000000;


	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_TILE_VERTICAL_FLAG : Int = 0x40000000;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_TILE_DIAGONAL_FLAG : Int = 0x20000000;
	
	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_TILE_FLIPPED_ALL : Int = (TMX_TILE_HORIZONTAL_FLAG | TMX_TILE_VERTICAL_FLAG | TMX_TILE_DIAGONAL_FLAG) >>> 0;

	/**
	 * @constant
	 * @type Number
	 */
	public static var TMX_TILE_FLIPPED_MASK : Int = (~(TMX_TILE_FLIPPED_ALL)) >>> 0;
	
	public function new() 
	{
		
	}
	
}

class CCTMXLayerInfo {
	public var _properties : Map<String, String>;
	public var name : String = "";
	public var _layerSize : CCSize;
	public var _tiles : Array<Int>;
	public var visible : Bool;
	public var _opacity : Int;
	public var ownTiles : Bool = true;
	public var _minGID : Int = 100000;
	public var _maxGID : Int = 0;
	public var offset : Point;
	
	public function new() {
		offset = new Point();
		_properties = new Map<String, String>();
		_tiles = new Array<Int>();
	}
	
	public function getProperties() : Map < String, String > {
		return this._properties;
	}
	
	public function setProperties(name : String, value : String ) {
		this._properties.set(name, value);
	}
}

class CCTMXTilesetInfo {
	public var name : String = "";
	public var firstGid : Int = 0;
	public var lastGid : Int = 0;
	public var _tileSize : CCSize;
	public var spacing : Float;
	public var margin : Float;
	public var sourceImage : String;
	public var sourceImageWidth : Float;
	public var sourceImageHeight : Float;
	public var imageSize : CCSize;
	
	public var texture : Texture;
	
	public function new() {
		_tileSize = new CCSize();
	}
	public function rectForGID(gid : Int) : Rectangle {
		var rect = new Rectangle();
		rect.width = this._tileSize.width;
		rect.height = this._tileSize.height;
		gid = gid - this.firstGid;
		var max_x = (this.imageSize.width - this.margin * 2 + this.spacing) / (this._tileSize.width + this.spacing);
		rect.x = (gid % max_x) * (this._tileSize.width + this.spacing) + this.margin;
		
		//var max_y = this.imageSize / this._tileSize.height;
		//rect.y = (git / max_x) * 
		rect.y = Std.int((gid / max_x)) * (this._tileSize.height + this.spacing) + this.margin;
		return rect;
	}
}

class CCTMXMapInfo {
	var _orientation : Int;
	var _mapSize : CCSize;
	var _tileSize : CCSize;
	var _layers : Array<CCTMXLayerInfo>;
	var _tileSets : Array<CCTMXTilesetInfo>;
	var _objectGroups : Array<CCTMXObjectGroup>;
	var _parentElement : Int;
	var _parentGID : Int;
	var _layerAttribs : Int;
	var _storingCharacters : Bool = false;
	var _properties : Array<Map<String, String>>;
	
	var _TMXFileName : String;
	var _currentString : String;
	var _tileProperties : Map < Int, Map < String, String >> ;
	var _resources : String;
	
	var pack : AssetPack;
	
	private function new() {
		this._tileProperties = new Map < Int, Map < String, String >> ();
		this._properties = new Array < Map < String, String >> ();
		pack = CCLoader.pack;
	}
	
	public function getOrientation() :Int {
		return this._orientation;
	}
	
	public function setOrientation(v : Int) {
		this._orientation = v;
	}
	
	public function getMapSize() : CCSize {
		return this._mapSize;
	}
	
	public function setMapSize(v : CCSize) {
		this._mapSize = v;
	}
	
	public function getTileSize() : CCSize {
		return this._tileSize;
	}
	
	public function setTileSize(v : CCSize) {
		this._tileSize = v;
	}
	
	public function getLayers() : Array<CCTMXLayerInfo> {
		return this._layers;
	}
	
	public function setLayers(v : CCTMXLayerInfo) {
		this._layers.push(v);
	}
	
	public function getTilesets() : Array<CCTMXTilesetInfo> {
		return this._tileSets;
	}
	
	public function setTilesets(v : CCTMXTilesetInfo) {
		this._tileSets.push(v);
	}
	
	public function getObjectGroups() : Array<CCTMXObjectGroup> {
		return this._objectGroups;
	}
	
	public function setObjectGroups(v : CCTMXObjectGroup) {
		this._objectGroups.push(v);
	}
	
	//public function getParentElement : Int {
	//public function getParentElement : Int {
		//return this._parentElement;
	//}
	//
	//public function setParentElement(v : Int) {
		//this._parentElement = v;
	//}
	
	public function getParentGID() : Int {
		return this._parentGID;
	}
	
	public function setParentGID(v : Int) {
		this._parentGID = v;
	}
	
	public function getLayerAttribs() : Int {
		return this._layerAttribs;
	}
	
	public function setLayerAttribs(v : Int) {
		this._layerAttribs = v;
	}
	
	public function getStoringCharacters() : Bool {
		return this._storingCharacters;
	}
	
	public function setStoringCharacters(v : Bool) {
		this._storingCharacters = v;
	}
	
	public function getProperties() : Array < Map < String, String >> {
		return this._properties;
	}
	
	public function setProperties(v : Map < String, String > ) {
		this._properties.push(v);
	}
	
	public function initWithTMXFile(tmxFile : String, resourcePath : String) {
		this._initernalInit(tmxFile, resourcePath);
		return this.parseXMLFile(this._TMXFileName);
	}
	
	public function parseXMLFile(tmxFile : String) {
		var map : Xml = Xml.parse(CCLoader.pack.getFile(tmxFile).toString()).firstElement();

		
		var version = map.get("version");
		var orientationStd = map.get("orientation");
		
		var mapSize : CCSize = new CCSize();
		mapSize.width = Std.parseFloat(map.get("width"));
		mapSize.height = Std.parseFloat(map.get("height"));
		this.setMapSize(mapSize);
		
		mapSize = new CCSize();
		mapSize.width = Std.parseFloat(map.get("tilewidth"));
		mapSize.height = Std.parseFloat(map.get("tileheight"));
		this.setTileSize(mapSize);
		
		switch (orientationStd) {
			case "orthogonal" :
				this.setOrientation(CCTMXTiledMap.TMX_ORIENTATION_ORTHO);
			case "isometric" :
				this.setOrientation(CCTMXTiledMap.TMX_ORIENTATION_ISO);
			case "hexagonal" :
				this.setOrientation(CCTMXTiledMap.TMX_ORIENTATION_HEX);
			default :
				CCCommon.log("cocos2d: TMXFomat: Unsupported orientation:" + this.getOrientation());
		}
		
		for (elem in map.elements()) {
			switch (elem.nodeName) {
				case "tileset" : 
					this.loadTileset(elem);
					//trace("tileset");
				case "layer":
					this.loadLayer(elem);
				case "objectgroup" :
					this.loadObjectGroup(elem);
				case "properties" :
					this.loadProperties(elem);
			}
		}	
	}
	
	private function loadProperties(elem : Xml) {
		for (e in elem.elements()) {
			switch(e.nodeName) {
				case "property" :
					var map : Map<String, String> = new Map<String, String>();
					map[e.get("name")] = e.get("value");
					this.setProperties(map);
				default :  null;
			}
		}
	}
	
	
	private function loadTileset(elem : Xml) {
		var tileset : CCTMXTilesetInfo = new CCTMXTilesetInfo();
		tileset.name = elem.get("name");
		tileset.firstGid = Std.parseInt(elem.get("firstgid"));
		
		
		var marginStr = elem.get("margin");
		if (marginStr == null) {
			marginStr = "0";
		}
		
		var spacingStr = elem.get("spacing");
		if (spacingStr == null) {
			spacingStr = "0";
		}
		tileset.margin = Std.parseInt(marginStr);
		tileset.spacing = Std.parseInt(spacingStr);
		var tilesetSize : CCSize = new CCSize();
		tilesetSize.width = Std.parseFloat(elem.get("tilewidth"));
		tilesetSize.height = Std.parseFloat(elem.get("tileheight"));
		tileset._tileSize = tilesetSize;

		
		for (e in elem.elements()) {
			switch(e.nodeName) {
				case "image" :
					var imgSource = e.get("source");
					imgSource = imgSource.split(".")[0];
					if (imgSource != null) {
						if (this._resources != null) {
							imgSource = this._resources + "/" + imgSource;
						} else {
						
						}
					}
					tileset.sourceImage = imgSource;
					tileset.texture = this.pack.getTexture(tileset.sourceImage);
					tileset.sourceImageWidth = Std.parseFloat(e.get("width"));
					tileset.sourceImageHeight = Std.parseFloat(e.get("height"));
					tileset.imageSize = new CCSize(tileset.sourceImageWidth, tileset.sourceImageHeight);
					this.setTilesets(tileset);
				case "tile":
					var info = this._tileSets[0];
					var id = Std.parseInt(e.get("id"));
					if (id == null) {
						id = 0;
					}
					this.setParentGID(info.firstGid + id);
					var dict : Map<String, String> = new Map<String, String>();
					for (p in e.elements()) {
						switch (p.nodeName) {
							case "properties" :
								var name = p.get("name");
								var value = p.get("value");
								
								dict.set(name, value);
						}
					}
					this._tileProperties.set(this.getParentGID(), dict);
				default : null;
			}
		}
		
	}
	
	private function loadLayer(elem : Xml) {
		var layer : CCTMXLayerInfo = new CCTMXLayerInfo();
		layer.name = elem.get("name");
		
		var layerSize : CCSize = new CCSize();
		layerSize.width = Std.parseFloat(elem.get("width"));
		layerSize.height = Std.parseFloat(elem.get("height"));
		layer._layerSize = layerSize;
		
		var visible = elem.get("visible");
		if (visible == "0") {
			layer.visible = false;
		} else {
			layer.visible = true;
		}
		
		var opacity :String = elem.get("opacity");
		if (opacity == null) {
			opacity = "1";
		}
		

		layer._opacity = Std.parseInt(Std.string(255 * Std.parseFloat(opacity)));
		
		//var x = Std.parseFloat(elem.get("x"));
		//var y = Std.parseFloat(elem.get("y"));
		
		var x = elem.get("x");
		var y = elem.get("y");
		
		if (x == null) {
			x = "0";
		}
		
		if (y == null) {
			y = "0";
		}
		
		layer.offset = new Point(Std.parseFloat(x), Std.parseFloat(y));
		
		var nodeValue :String = "";
		
		for (e in elem.elements()) {
			switch (e.nodeName) {
				case "data":
					loadData(e, layer);
				case "properties":
					loadLayerPros(e, layer);
			}
		}
		this.setLayers(layer);
	}
	private function loadData(xml : Xml, layer : CCTMXLayerInfo) {
		var encoding = xml.get("encoding");
		var compression = xml.get("compression");
		
		if (compression == null) {
			compression = "";
		}
		
		var isCompression : Bool = false;
		switch(compression) {
			case "gzip" :
				layer._tiles = CCZipUtils.unzipBase64AsArray(xml.firstChild().nodeValue, Std.int(layer._layerSize.width), 4);
			case "zlib" :
				//isCompression = true;
				layer._tiles = CCBase64.unzip(xml.firstChild().nodeValue, Std.int(layer._layerSize.width));
				//layer._tiles = CCBase64.decodeAsArray(xml.firstChild().nodeValue, Std.int(layer._layerSize.width), isCompression);
			case "":
				if (encoding == "base64") {
					layer._tiles = CCBase64.decodeAsArray(xml.firstChild().nodeValue, Std.int(layer._layerSize.width));
				} else if (encoding == "csv") {
					layer._tiles = csvToArray(xml.firstChild().nodeValue);
				} else {
					//XML format
					var indexX = 0;
					var indexY = 0;
					var widthMap = this._mapSize.width;
					var heightMap = this._mapSize.height;
					var tilesRow : Array<Int> = new Array<Int>();
					for (elem in xml.elements()) {
						switch (elem.nodeName) {
							case "tile" : 
								//var g : Int = Std.parseInt(elem.get("gid"));
								//tilesRow.push(g);
								//
								//if (indexX == widthMap - 1) {
									//indexX = 0;
									//indexY++;
									//layer._tiles.push(tilesRow);
									//tilesRow = [];
								//} else {
									//indexX++;
								//}
								layer._tiles.push(Std.parseInt(elem.get("gid")));

							default: null;
						}
					}
				}
			default : null;
		}
		
	}
	
	private function loadLayerPros(xml : Xml, layer : CCTMXLayerInfo) {
		for (elem in xml.elements()) {
			layer.setProperties(elem.get("name"), elem.get("value"));
		}
	}
	
	private function loadObjectGroup(xml : Xml) {
		var objectGroup = new CCTMXObjectGroup();
		objectGroup.setGroupName(xml.get("name"));
		
		var x : Float;
		var y : Float;
		var xStr : String = xml.get("x");
		var yStr : String = xml.get("y");
		if (xStr == null) {
			x = 0;
		} else {
			x = Std.parseFloat(xStr);
		}
		
		if (yStr == null) {
			y = 0;
		} else {
			y = Std.parseFloat(yStr);
		}
		objectGroup.setPositionOffset(new Point(x * this.getTileSize().width,
                    y * this.getTileSize().height));
		for (elem in xml.elements()) {
			var object : CCTMXObject = new CCTMXObject();
			switch (elem.nodeName) {
				case "object" :
					
					object.name = elem.get("name");
					object.type = elem.get("type");
					object.x = Std.parseInt(elem.get("x"));
					object.y = Std.parseInt(elem.get("y"));
					object.width = Std.parseInt(elem.get("width"));
					object.height = Std.parseInt(elem.get("height"));
				case "properties":
					object.properties.set(elem.get("name"), elem.get("value"));
			}
			
			objectGroup.setObjects(object);
		}
		this.setObjectGroups(objectGroup);
	}
	
	
	public function getTileProperties(): Map<Int, Map<String, String>>{
		return this._tileProperties;
	}
	public function setTileProperties() {
		
	}
	
	public function getCurrentString() : String {
		return this._currentString;
	}

	public function setCurrentString(currentString : String) {
		this._currentString = currentString;
	}
	
	public function setTMXFileName(fileName : String) {
		this._TMXFileName = fileName;
		
	}
	
	public function _initernalInit(tmxFileName, resourcePath) {
		this._tileSets = new Array<CCTMXTilesetInfo>();
		this._layers = new Array<CCTMXLayerInfo>();
		
		this._TMXFileName = tmxFileName;
		
		if (resourcePath != null) {
			this._resources = resourcePath;
		}
		
		this._objectGroups = new Array<CCTMXObjectGroup>();
		
		this._currentString = "";
		this._storingCharacters = false;
		this._layerAttribs = CCTMXXMLParser.TMX_LAYER_ATTRIB_NONE;
		this._parentElement = CCTMXXMLParser.TMX_PROPERTY_NONE;
	}
	
	/**
	 * https://github.com/po8rewq/HaxeFlixelTiled/blob/master/org/flixel/tmx/TmxLayer.hx
	 * @param	input
	 * @return
	 */
	public static function csvToArray(input:String):Array<Int>
	{
		var result:Array<Int> = new Array<Int>();
		var rows:Array<String> = input.split("\n");
		var row:String;
		for (row in rows)
		{
			if (row == "") continue;
			var resultRow:Array<Int> = new Array<Int>();
			var entries:Array<String> = row.split(",");
			//trace(entries);
			var entry:String;
			for (entry in entries) {
				var t = Std.parseInt(entry);
				if (t != null) {
					result.push(t); //convert to int
				}
			}
			

		}
		
		//trace(result);
		return result;
	}
	
	public static function create(tmxFile : String, ?resourcePath : String) : CCTMXMapInfo {
		var ret = new CCTMXMapInfo();
		ret.initWithTMXFile(tmxFile, resourcePath);
		
		return ret;
	}
}