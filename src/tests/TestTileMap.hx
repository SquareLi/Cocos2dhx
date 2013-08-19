package tests;
import cc.layersscenestransitionsnodes.CCScene;
import cc.tilemapparallaxnodes.CCTMXTiledMap;
import cc.tilemapparallaxnodes.CCTMXXMLParser;
import cc.tilemapparallaxnodes.CCTMXSprite;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.System;
import cc.CCDirector;
/**
 * ...
 * @author Ang Li
 */
class TestTileMap
{
	var map : CCTMXTiledMap;
	public function new() 
	{
		map = new CCTMXTiledMap();
		
	}
	
	public function run() {

		
		var map : CCTMXTiledMap = CCTMXTiledMap.create("tmxsample/TileMap1.tmx", "tmxsample");

		
		
		var scene : CCScene = CCScene.create();
		scene.addChild(map);
		
		CCDirector.getInstance().runWithScene(scene);
	}
	
}