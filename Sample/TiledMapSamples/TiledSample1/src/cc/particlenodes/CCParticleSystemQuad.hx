package cc.particlenodes;

/**
 * ...
 * @author
 */
class CCParticleSystemQuad extends CCParticleSystem
{

	public function new() 
	{
		super();
	}
	
	public static function create(pListFile : String) : CCParticleSystem {
		var ret = new CCParticleSystemQuad();
		
		if (ret != null && ret.initWithFile(pListFile)) {
			return ret;
		}
		
		return null;
	}
	
}