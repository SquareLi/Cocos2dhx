/****************************************************************************
 cocos2dhx 
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

package cc.spritenodes;
import cc.action.CCActionManager;
import flambe.asset.AssetPack;
import flambe.display.Graphics;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.display.Texture;
import cc.CCDirector;

/**
 * ...
 * @author Ang Li
 */
class CCSpriteSheet extends Sprite
{
	public var texture : Texture;
	public var w : Float = 60;
	public var h : Float = 41;
	public var g : Graphics;
	public var counter : Int = 14;
	var _actionManager : CCActionManager;
	var c : Int = 2;
	public var frame : CCSpriteFrame;
	
	public function new() 
	{
		super();
		//texture = Pack.pack.getTexture("plist/explosion");
		//var x : TestXML = new TestXML();
		//frames = x.parse();
		_actionManager = CCDirector.getInstance().getActionManager();
	}
	
	public function updateFrame(frame : CCSpriteFrame) {
		this.frame = frame;
	}
	
	override public function draw(g:Graphics)
	{
		//super.draw(g);
		this.g = g;
		
		
		if (frame.isRotated()) {
			g.translate(frame.getOffset().x, frame.getOffset().y + frame.getRect().height);
			g.rotate( -90);
			g.drawSubImage(frame.getTexture().getTexture(), 0, 0, frame.getRect().x, frame.getRect().y, 
			frame.getRect().height, frame.getRect().width);
			
		} else {
			g.translate(frame.getOffset().x, frame.getOffset().y);
			g.drawSubImage(frame.getTexture().getTexture(), 0, 0, frame.getRect().x, frame.getRect().y, 
			frame.getRect().width, frame.getRect().height);
			
		}
		
		
		//trace(frame.getOffset().x);
	}
	
	public function getCurrentFrame() : CCSpriteFrame {
		return frame;
	}
	var _timer : Float = 1;
	var _flag : Bool = true;
	override public function onUpdate(dt:Float)
	{
		super.onUpdate(dt);
	}
	
	override public function getNaturalHeight():Float 
	{
		return frame.getRect().height;
	}
	
    override public function getNaturalWidth():Float 
	{
		return frame.getRect().width;
	}
	
}