package cc.extensions.ccbreader;
import cc.extensions.ccbreader.CCSpriteLoader;
/**
 * ...
 * @author Ang Li
 */
class CCNodeLoaderLibrary
{
	var _ccNodeLoaders : Map<String, CCNodeLoader>;
	
	public static var sSharedCCNodeLoaderLibrary : CCNodeLoaderLibrary;
	private function new() 
	{
		this._ccNodeLoaders = new Map<String, CCNodeLoader>();
		
	}
	
	public function registerDefaultCCNodeLoaders() {
		this.registerCCNodeLoader("CCNode", CCNodeLoader.loader());
        this.registerCCNodeLoader("CCLayer", CCLayerLoader.loader());
        //this.registerCCNodeLoader("CCLayerColor", cc.LayerColorLoader.loader());
        //this.registerCCNodeLoader("CCLayerGradient", cc.LayerGradientLoader.loader());
        this.registerCCNodeLoader("CCSprite", CCSpriteLoader.loader());
        //this.registerCCNodeLoader("CCLabelBMFont", cc.LabelBMFontLoader.loader());
        //this.registerCCNodeLoader("CCLabelTTF", cc.LabelTTFLoader.loader());
        //this.registerCCNodeLoader("CCScale9Sprite", cc.Scale9SpriteLoader.loader());
        //this.registerCCNodeLoader("CCScrollView", cc.ScrollViewLoader.loader());
        //this.registerCCNodeLoader("CCBFile", cc.BuilderFileLoader.loader());
        //this.registerCCNodeLoader("CCMenu", cc.MenuLoader.loader());
        //this.registerCCNodeLoader("CCMenuItemImage", cc.MenuItemImageLoader.loader());
        //this.registerCCNodeLoader("CCControlButton", cc.ControlButtonLoader.loader());
        //this.registerCCNodeLoader("CCParticleSystemQuad", cc.ParticleSystemQuadLoader.loader());
	}
	
	public function registerCCNodeLoader(className : String, ccNodeLoader : CCNodeLoader) {
		this._ccNodeLoaders[className] = ccNodeLoader;
	}
	
	public function unregisterCCNodeLoader(className : String) {
		if (this._ccNodeLoaders.exists(className)) {
			this._ccNodeLoaders.remove(className);
		}
	}
	
	public function getCCNodeLoader(className : String) : CCNodeLoader {
		if (this._ccNodeLoaders.exists(className)) {
			return this._ccNodeLoaders[className];
		}
		return null;
	}
	
	public function purge(releaseCCNodeLoaders : Bool) {
		if (releaseCCNodeLoaders) {
			this._ccNodeLoaders = new Map<String, CCNodeLoader>();
		}
	}
	
	public static function library() : CCNodeLoaderLibrary{
		return new CCNodeLoaderLibrary();
	}
	
	public static function sharedCCNodeLoaderLibrary() : CCNodeLoaderLibrary {
		if (sSharedCCNodeLoaderLibrary == null) {
			sSharedCCNodeLoaderLibrary = new CCNodeLoaderLibrary();
			sSharedCCNodeLoaderLibrary.registerDefaultCCNodeLoaders();
		}
		return sSharedCCNodeLoaderLibrary;
	}
	
	public static function purgeSharedCCNodeLoaderLibrary() {
		sSharedCCNodeLoaderLibrary = null;
	}
	
	public static function newDefaultCCNodeLoaderLibrary() : CCNodeLoaderLibrary {
		var ccNodeLoaderLibrary : CCNodeLoaderLibrary= CCNodeLoaderLibrary.library();
		ccNodeLoaderLibrary.registerDefaultCCNodeLoaders();
		return ccNodeLoaderLibrary;
	}
}