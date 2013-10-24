package box2dsample;

/**
 * ...
 * @author Ang Li(李昂)
 */
class Sensors
{
	var alpha : Float = 0;
	var beta : Float = 0;
	var gamma : Float = 0;
	public function new() 
	{
		
	}
	
	public function init() {
		//izen.logger.info('sensors.init()');
		//window.addEventListener('deviceorientation', function(e) {
			//if (game.config.useSensor) {
				//alpha = e.alpha;
				//beta = e.beta;
				//gamma = e.gamma;
			//}
		//});
		//if (game.config.debug) {
			//setInterval(function() {
				//tizen.logger.info(alpha);
				//tizen.logger.info(beta);
				//tizen.logger.info(gamma);
			//}, 2000);
		//}
	}
	
	public function getAlpha() : Float{
		return alpha;
	}
	
	public function getBeta() : Float{
		if (beta < -90) {
			return -90;
		}
		if (beta > 90) {
			return 90;
		}
		return beta;
	}
	
	public function getGamma() : Float {
		if (gamma < -90) {
			return -90;
		}
		if (gamma > 90) {
			return 90;
		}
		return gamma;
	}
	
	public static var sharedSensors : Sensors = null;
	public static function getInstance() : Sensors {
		if (sharedSensors == null) {
			sharedSensors = new Sensors();
		}
		return sharedSensors;
	}
}