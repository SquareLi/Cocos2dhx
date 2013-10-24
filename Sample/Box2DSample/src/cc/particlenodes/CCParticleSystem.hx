package cc.particlenodes;
import cc.basenodes.CCNode;
import cc.CCComponent;
import cc.CCLoader;
import cc.spritenodes.CCSprite;
import flambe.display.EmitterMold;
import flambe.display.EmitterSprite;

/**
 * ...
 * @author Ang Li
 */
class CCParticleSystem extends CCNode
{
	var _plistFile : String;
	var _emmiterMold : EmitterMold;
	public function new() 
	{
		super();
	}
	
	public function initWithFile(plistFile : String) : Bool {
		this._plistFile = plistFile;
		_emmiterMold = new EmitterMold(CCLoader.pack, plistFile, false);
		var emmiterSprite : EmitterSprite = _emmiterMold.createEmitter();
		this.sprite = emmiterSprite;
		this.entity.add(sprite);
		this.component = new CCComponent(this);
		this.entity.add(this.component);
		
		return true;
	}
	
	public static function create(plistFile : String) : CCParticleSystem{
		return CCParticleSystemQuad.create(plistFile);
	}
}