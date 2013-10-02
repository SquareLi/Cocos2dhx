package com.angli;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import cc.CCLoader;
import cc.extensions.ccbreader.CCBReader;
import cc.layersscenestransitionsnodes.CCScene;
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
		CCLoader.pack = pack;
        var about : AboutScene = new AboutScene();
		var game : GameScene = new GameScene();
		var main : MainScene = new MainScene();
		CCBReader.CCB_CLASS_ROOT_PATH = "com.angli.";
		//Type.createInstance(Type.resolveClass("tests.About"), []);
		var scene : CCScene = CCBuilderReader.loadAsScene("crystal/MainScene.ccbi", null, null, "crystal/");
		
		var director : CCDirector = CCDirector.getInstance();
		director.runWithScene(scene);
    }
}
