package cc.spritenodes;
import cc.basenodes.CCNode;
import flambe.math.Point;
import flambe.swf.Library;
import flambe.swf.MoviePlayer;
import cc.CCLoader;
import flambe.swf.MovieSprite;
/**
 * ...
 * @author(李昂)
 */
class CCFlumpSprite extends CCNode
{
	
	var flumpPlayer : MoviePlayer;
	var _currentSprite : MovieSprite;
	public function new() 
	{
		super();
	}
	
	public function initFlump(dir : String) {
		flumpPlayer = new MoviePlayer(new Library(CCLoader.pack, dir)).loop("SE_idle_MC");
		//this.entity.add(this.sprite);
		_currentSprite = flumpPlayer.movie._;
		this.entity.add(flumpPlayer);
	}
	
	override public function setPosition(xValue:Float, yValue:Float)
	{
		if (_currentSprite != null) {
			_currentSprite.setXY(xValue, yValue);
		}
		this._position = new Point(xValue, yValue);
		this._hasSetPosition = true;
		
	}
	
	override public function setAnchorPoint(point:Point)
	{
		//var width : Float = this._currentSprite.getNaturalWidth();
		//var height : Float = this._currentSprite.getNaturalHeight();
		//
		//if (isOriginTopLeft) {
			//sprite.setAnchor(this._anchorPoint.x * width, this._anchorPoint.y * height);
		//} else {
			//trace("else");
			//sprite.setAnchor(this._anchorPoint.x * width, (1 - this._anchorPoint.y) * height);
			//trace('height = $height');
		//}
		_currentSprite.setAnchor(point.x, point.y);
		
	}
	
	public static function create(dir : String) : CCFlumpSprite {
		var ret : CCFlumpSprite = new CCFlumpSprite();
		ret.initFlump(dir);
		return ret;
	}
	
	public function play(movieName : String) {
		this.flumpPlayer.play(movieName);
		_currentSprite = this.flumpPlayer.movie._;
	}
	
	public function loop(movieName : String) {
		this.flumpPlayer.loop(movieName);
		_currentSprite = this.flumpPlayer.movie._;
	}
	
	
	
}