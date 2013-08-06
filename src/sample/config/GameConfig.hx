package sample.config;
import sample.Bullet;
import sample.Enemy;
/**
 * ...
 * @author Ang Li
 */
class GameConfig
{

	public static var LIFE : Int = 4;
	public static var SCORE : Int = 0;
	public static var SOUND : Bool = true;
	public static var DELTA_X : Int = -100;
	public static var OFFSET_X = -24;
	public static var ROT = -5.625;
	
	public static var KEYS : Array<Dynamic> = new Array<Dynamic>();
	public static var ENEMIES : Array<Enemy> = new Array<Enemy>();
	public static var ENEMY_BULLETS : Array<Bullet> = new Array<Bullet>();
	public static var PLAYER_BULLETS : Array<Bullet> = new Array<Bullet>();
	
	public static var LIFEUP_SCORE : Array<Int> = [50000, 100000, 150000, 200000, 250000, 300000];
	public function new() 
	{
	}
}

class GAME_STATE {
	public static var HOME : Int = 0;
	public static var PLAY : Int = 1;
	public static var OVER : Int = 2;
}

class LEVEL {
	public static var STAGE1 : Int = 1;
	public static var STAGE2 : Int = 2;
	public static var STAGE3 : Int = 3;
}
class ENEMY_MOVE_TYPE {
	public static var ATTACK : Int = 0;
	public static var VERTICAL : Int = 1;
	public static var HORIZONTAL : Int = 2;
	public static var OVERLAP : Int = 3;
	public static var NORMAL : Int = 4;
}
	
class BULLET_TYPE {
	public static var PLAYER : Int = 1;
	public static var ENEMY : Int = 2;
}

class WEAPON_TYPE {
	public static var ONE : Int = 1;
}

class UNIT_TAG {
	public static var ENEMY_BULLET : Int = 900;
	public static var PLAYER_BULLET : Int = 901;
	public static var ENEMY : Int = 1000;
	public static var PLAYER : Int = 1000;
}

class ENEMY_ATTACK_MODE {
	public static var NORMAL : Int = 1;
	public static var TSUIHIKIDAN : Int = 2;
}



