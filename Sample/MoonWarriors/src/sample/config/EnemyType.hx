package sample.config;
import sample.config.GameConfig;

/**
 * ...
 * @author Ang Li
 */
class EnemyType
{
	public var type : Int = 0;
	public var textureName : String;
	public var bulletType : String;
	public var HP : Int = 1;
	public var moveType : Int;
	public var attackMode : Int;
	public var scoreValue : Int;
	public static var ENEMY_TYPE_LIST : Array<EnemyType>;
	public function new(type : Int, textureName : String, bulletType : String,
		hp : Int, moveType : Int, attackMode : Int, scoreValue : Int) 
	{
		this.type = type;
		this.textureName = textureName;
		this.bulletType = bulletType;
		this.HP = hp;
		this.moveType = moveType;
		this.attackMode = attackMode;
		this.scoreValue = scoreValue;
	}
	public static function create() : Array<EnemyType> {
		if (ENEMY_TYPE_LIST == null) {
			ENEMY_TYPE_LIST = new Array<EnemyType>();
			var type0 : EnemyType = new EnemyType(0, "E0.png", "W2.png", 1, ENEMY_MOVE_TYPE.ATTACK, ENEMY_ATTACK_MODE.NORMAL, 15);
			var type1 : EnemyType = new EnemyType(1, "E1.png", "W2.png", 2, ENEMY_MOVE_TYPE.ATTACK, ENEMY_ATTACK_MODE.NORMAL, 40);
			var type2 : EnemyType = new EnemyType(2, "E2.png", "W2.png", 4, ENEMY_MOVE_TYPE.HORIZONTAL, ENEMY_ATTACK_MODE.TSUIHIKIDAN, 60);
			var type3 : EnemyType = new EnemyType(3, "E3.png", "W2.png", 6, ENEMY_MOVE_TYPE.OVERLAP, ENEMY_ATTACK_MODE.NORMAL, 80);
			var type4 : EnemyType = new EnemyType(4, "E4.png", "W2.png", 10, ENEMY_MOVE_TYPE.HORIZONTAL, ENEMY_ATTACK_MODE.TSUIHIKIDAN, 150);
			var type5 : EnemyType = new EnemyType(5, "E5.png", "W2.png", 20, ENEMY_MOVE_TYPE.HORIZONTAL, ENEMY_ATTACK_MODE.NORMAL, 200);
			ENEMY_TYPE_LIST = [type0, type1, type2, type3, type4, type5];
		}
		
		return ENEMY_TYPE_LIST;
	}
}