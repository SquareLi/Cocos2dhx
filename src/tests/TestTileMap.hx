package tests;
import cc.layersscenestransitionsnodes.CCLayer;
import cc.layersscenestransitionsnodes.CCScene;
import cc.spritenodes.CCSprite;
import cc.tilemapparallaxnodes.CCTMXObject;
import cc.tilemapparallaxnodes.CCTMXTiledMap;
import cc.tilemapparallaxnodes.CCTMXXMLParser;
import cc.tilemapparallaxnodes.CCTMXSprite;
import flambe.display.FillSprite;
import flambe.Entity;
import flambe.System;
import cc.CCDirector;
import flambe.input.KeyboardEvent;
import flambe.input.Key;
/**
 * ...
 * @author Ang Li
 */
class TestTileMap extends CCLayer
{
	var map : CCTMXTiledMap;
	var player : CCSprite;
	public function new() 
	{
		super();
		
		
	}
	
	public function run() {

		
		map = CCTMXTiledMap.create("tmxsample/TileMap_zlib.tmx", "tmxsample");
		//trace(mapInfo.getLayers()[0]._tiles.length);
		//trace(mapInfo.getLayers()[0]._tiles[0].length);
		//for (row in 0...mapInfo.getLayers()[0]._tiles.length) {
			//for (col in 0...mapInfo.getLayers()[0]._tiles[0].length) {
				//var gid = mapInfo.getLayers()[0]._tiles[row][col];
				//trace(gid);
			//}
		//}
		
		//var playerObj : CCTMXObject = map.getObjectGroup("Objects").objectNamed("SpawnPoint");
		//player = CCSprite.create("tmxsample/Player");
		//player.setPosition(playerObj.x, playerObj.y);
		
		var scene : CCScene = CCScene.create();
		scene.addChild(this);
		this.addChild(map);
		//this.addChild(player);
		
		//this.setKeyboardEnabled(true);
		
		CCDirector.getInstance().runWithScene(scene);
		//System.root.addChild(new Entity().add(sprite));
	}
	
	//override public function onKeyDown(event:KeyboardEvent)
	//{
		//var x = this.player.getPositionX();
		//var y = this.player.getPositionY();
		//
		//var xLayer = this.getPositionX();
		//var yLayer = this.getPositionY();
		//switch(event.key) {
			//case Key.Left :
				//this.player.setPositionX(x - 32);
				//
				//
				//this.setPositionX(xLayer + 32);
				//
			//case Key.Right : 
				//this.player.setPositionX(x + 32);
				//this.setPositionX(xLayer - 32);
			//case Key.Up :
				//this.player.setPositionY(y - 32);
			//case Key.Down:
				//this.player.setPositionY(y + 32);
			//default : null;
		//}
	//}
}