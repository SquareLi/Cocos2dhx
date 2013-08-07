package sample;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import cc.CCDirector;
import sample.SysMenu;
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
        // Add a solid color background
        //var background = new FillSprite(0x202020, System.stage.width, System.stage.height);
        //System.root.addChild(new Entity().add(background));
		CCLoader.pack = pack;
        var director : CCDirector = CCDirector.getInstance();
		director.runWithScene(SysMenu.scene());
    }
}
