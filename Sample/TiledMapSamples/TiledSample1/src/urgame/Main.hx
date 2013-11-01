package urgame;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;

import cc.CCDirector;
import cc.tilemapparallaxnodes.CCTMXTiledMap;
import cc.layersscenestransitionsnodes.CCScene;
import cc.CCLoader;

class Main
{
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.build("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
    }

    private static function onSuccess (pack :AssetPack)
    {
	   CCLoader.pack = pack;
       
	   
	   var scene : CCScene = CCScene.create();
	   
	   scene.addChild(new TestLayer());
	   var d : CCDirector = CCDirector.getInstance();
	   
	   d.runWithScene(scene);
    }
}
