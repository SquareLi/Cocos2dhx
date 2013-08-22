package cc.particlenodes;

/**
 * ...
 * @author Ang Li
 */
class CCParticleSystemQuad extends CCParticleSystem
{

	public function new() 
	{
		
	}
	
	public static function create(pListFile : String) : CCParticleSystem {
		var ret = new CCParticleSystemQuad();
		
		if (ret != null && ret.initWithFile(pListFile)) {
			return ret;
		}
		
		return null;
	}
	
}