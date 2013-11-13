package cc.kazmath;
import flambe.math.Point;

/**
 * ...
 * @author Ang Li(李昂)
 */
class CCMat4
{

	public function new() 
	{
		
	}
	
	/**
	 * Fills a kmMat4 structure with the values from a 16 element array of floats
	 * @Params pOut - A pointer to the destination matrix
	 * @Params pMat - A 16 element array of floats
	 * @Return Returns pOut so that the call can be nested
	 */
	public static function kmMat4Fill(pOut : Point, pMat : Array<Float>) {
		pOut.mat[0] = pOut.mat[1] = pOut.mat[2] =pOut.mat[3] =
			pOut.mat[4] =pOut.mat[5] =pOut.mat[6] =pOut.mat[7] =
				pOut.mat[8] =pOut.mat[9] =pOut.mat[10] =pOut.mat[11] =
					pOut.mat[12] =pOut.mat[13] =pOut.mat[14] =pOut.mat[15] =pMat;
	};
	
}

class CCkmMat4 {
	public var mat : Array<Float> = ([0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0]);
	
	public function new() {
		
	}
}