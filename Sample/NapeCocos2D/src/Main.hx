package ;

import cc.layersscenestransitionsnodes.CCScene;
import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import cc.CCLoader;
import cc.CCDirector;


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
        // Add a solid color background
		CCLoader.pack = pack;
		
		var d : CCDirector = CCDirector.getInstance();
		var scene : CCScene = CCScene.create();
		scene.addChild(new MyLayer());
		d.runWithScene(scene);
       
    }
}
