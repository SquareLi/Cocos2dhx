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

package cc.platform;

import cc.basenodes.CCNode;
import cc.CCDirector;
import flambe.math.Point;
import cc.cocoa.CCGeometry;
import flambe.math.Rectangle;
/**
 * ...
 * @author Ang Li
 */

class CCMacro 
{
	public static var INVALID_INDEX : Int = -1;
	public static var PI : Float = Math.PI;
	public static var FLT_MAX = Std.parseFloat("3.402823466e+38F");
	public static var RAD : Float = PI / 180;
	public static var DEG : Float = 180 / PI;
	public static var UINT_MAX = 0xffffffff;
	
	public function new() 
	{
		
	}
	
	public static function CONTENT_SCALE_FACTOR() : Float{
		if (CCConfig.IS_RETINA_DISPLAY_SUPPORTED == 1) {
			return CCDirector.getInstance().getContentScaleFactor();
		} else {
			return 1;
		}
	}
	
	/*public static function SWAP(x : Dynamic, y : Dynamic, ref : Dynamic) {
		
	}*/
	
	/**
	 * <p>
	 *     Linear interpolation between 2 numbers, the ratio sets how much it is biased to each end
	 * </p>
	 * @param {Number} a number A
	 * @param {Number} b number B
	 * @param {Number} r ratio between 0 and 1
	 * @function
	 * @example
	 * cc.lerp(2,10,0.5)//returns 6<br/>
	 * cc.lerp(2,10,0.2)//returns 3.6
	 */
	public static function lerp(a : Float, b : Float, r : Float) : Float {
		return a + (b - a) * r;
	}
	
	
	/**
	 * returns a random float between -1 and 1
	 * @return {Number}
	 * @function
	 */
	public static function RANDOM_MINUS1_1() : Float {
		return (Math.random() - 0.5) * 2;
	}
	
	/**
	 * returns a random float between 0 and 1
	 * @return {Number}
	 * @function
	 */
	 public static function RANDOM_0_1() : Float {
		 return Math.random();
	 }
	 
	 /**
	 * converts degrees to radians
	 * @param {Number} angle
	 * @return {Number}
	 * @function
	 */
	 public static function DEGREES_TO_RADIANS(angle : Float) : Float {
		 return angle * CCMacro.RAD;
	 }
	 
	 /**
	 * converts radians to degrees
	 * @param {Number} angle
	 * @return {Number}
	 * @function
	 */
	 public function RADIANS_TO_DEGREES(angle : Float) : Float{
		return angle * CCMacro.DEG;
	}

	/**
	 * @constant
	 * @type Number
	 */
	//public var REPEAT_FOREVER : Int =  - 1;

	/**
	 * default gl blend src function. Compatible with premultiplied alpha images.
	 * @constant
	 * @type Number
	 */
	public static var BLEND_SRC : Int = 1;

	/**
	 * default gl blend dst function. Compatible with premultiplied alpha images.
	 * @constant
	 * @type Number
	 */
	public static var BLEND_DST : Int = 0x0303;

	/**
	 * Helpful macro that setups the GL server state, the correct GL program and sets the Model View Projection matrix
	 * @param {cc.Node} node setup node
	 * @function
	 */
	//public static function NODE_DRAW_SETUP(node : CCNode) {
		//ccGLEnable(node._glServerState);
		//cc.Assert(node.getShaderProgram(), "No shader program set for this node");
		//{
			//node.getShaderProgram().use();
			//node.getShaderProgram().setUniformForModelViewProjectionMatrix();
		//}
	//};

	/**
	 * <p>
	 *     GL states that are enabled:<br/>
	 *       - GL_TEXTURE_2D<br/>
	 *       - GL_VERTEX_ARRAY<br/>
	 *       - GL_TEXTURE_COORD_ARRAY<br/>
	 *       - GL_COLOR_ARRAY<br/>
	 * </p>
	 * @function
	 
	 */
	//cc.ENABLE_DEFAULT_GL_STATES = function () {
		//TODO OPENGL STUFF
		///*
		 //glEnableClientState(GL_VERTEX_ARRAY);
		 //glEnableClientState(GL_COLOR_ARRAY);
		 //glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		 //glEnable(GL_TEXTURE_2D);*/
	//};

	/**
	 * <p>
	 *   Disable default GL states:<br/>
	 *     - GL_TEXTURE_2D<br/>
	 *     - GL_TEXTURE_COORD_ARRAY<br/>
	 *     - GL_COLOR_ARRAY<br/>
	 * </p>
	 * @function
	 */
	//cc.DISABLE_DEFAULT_GL_STATES = function () {
		//TODO OPENGL
		///*
		 //glDisable(GL_TEXTURE_2D);
		 //glDisableClientState(GL_COLOR_ARRAY);
		 //glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		 //glDisableClientState(GL_VERTEX_ARRAY);
		 //*/
	//};

	/**
	 * <p>
	 *  Increments the GL Draws counts by one.<br/>
	 *  The number of calls per frame are displayed on the screen when the CCDirector's stats are enabled.<br/>
	 * </p>
	 * @param {Number} addNumber
	 * @function
	 */
	//cc.INCREMENT_GL_DRAWS = function (addNumber) {
		//cc.g_NumberOfDraws += addNumber;
	//};

	/**
	 * @constant
	 * @type Number
	 */
	public static var FLT_EPSILON : Float = 0.0000001192092896;

	/**
	 * Converts a rect in points to pixels
	 * @param {cc.Point} points
	 * @return {cc.Point}
	 * @function
	 */
	 public static function POINT_POINTS_TO_PIXELS(points : Point) : Point {
		return new Point(points.x * CCMacro.CONTENT_SCALE_FACTOR(), points.y * CONTENT_SCALE_FACTOR());
	}

	/**
	 * Converts a rect in points to pixels
	 * @param {cc.Size} sizeInPoints
	 * @return {cc.Size}
	 * @function
	 */
	 public static function SIZE_POINTS_TO_PIXELS(sizeInPoints : CCSize) : CCSize{
		return new CCSize(sizeInPoints.width * CONTENT_SCALE_FACTOR(), sizeInPoints.height * CONTENT_SCALE_FACTOR());
	}

	/**
	 * Converts a rect in pixels to points
	 * @param {cc.Size} sizeInPixels
	 * @return {cc.Size}
	 * @function
	 */
	 public static function SIZE_PIXELS_TO_POINTS(sizeInPixels : CCSize) : CCSize {
		return new CCSize(sizeInPixels.width / CONTENT_SCALE_FACTOR(), sizeInPixels.height / CONTENT_SCALE_FACTOR());
	}

	/**
	 * Converts a rect in pixels to points
	 * @param pixels
	 * @function
	 */
    public static function POINT_PIXELS_TO_POINTS(pixels : Point) : Point {
		return new Point(pixels.x / CONTENT_SCALE_FACTOR(), pixels.y / CONTENT_SCALE_FACTOR());
	}


	/**
	 * Converts a rect in pixels to points
	 * @param {cc.Rect} pixel
	 * @function
	 */
	
	public static function RECT_PIXELS_TO_POINTS(pixel : Rectangle) : Rectangle {
		if ( CCConfig.IS_RETINA_DISPLAY_SUPPORTED == 1) {
			return new Rectangle(pixel.x / CONTENT_SCALE_FACTOR(), pixel.y / CONTENT_SCALE_FACTOR(),
			pixel.width / CONTENT_SCALE_FACTOR(), pixel.height / CONTENT_SCALE_FACTOR());
		} else {
			return pixel;
		}
	} 

	/**
	 * Converts a rect in points to pixels
	 * @param {cc.Rect} point
	 * @function
	 */
	public static function RECT_POINTS_TO_PIXELS(pixel : Rectangle) : Rectangle {
		if ( CCConfig.IS_RETINA_DISPLAY_SUPPORTED == 1) {
			return new Rectangle(pixel.x * CONTENT_SCALE_FACTOR(), pixel.y * CONTENT_SCALE_FACTOR(),
			pixel.width * CONTENT_SCALE_FACTOR(), pixel.height * CONTENT_SCALE_FACTOR());
		} else {
			return pixel;
		}
	} 


	///**
	 //* WebGL constants
	 //* @type {object}
	 //*/
	//var gl = gl || {};
//
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//public static var NEAREST : Int = 0x2600;
//
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//public static var LINEAR : Int = 0x2601;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.REPEAT = 0x2901;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.CLAMP_TO_EDGE = 0x812F;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.CLAMP_TO_BORDER = 0x812D;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.LINEAR_MIPMAP_NEAREST = 0x2701;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.NEAREST_MIPMAP_NEAREST = 0x2700;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.ZERO = 0;
	
	/**
	 * @constant
	 * @type Number
	 */
	public static var ONE : Int = 1;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.SRC_COLOR = 0x0300;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.ONE_MINUS_SRC_COLOR = 0x0301;
	
	/**
	 * @constant
	 * @type Number
	 */
	public static var SRC_ALPHA : Int = 0x0302;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.ONE_MINUS_SRC_ALPHA = 0x0303;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.DST_ALPHA = 0x0304;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.ONE_MINUS_DST_ALPHA = 0x0305;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.DST_COLOR = 0x0306;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.ONE_MINUS_DST_COLOR = 0x0307;
	///**
	 //* @constant
	 //* @type Number
	 //*/
	//gl.SRC_ALPHA_SATURATE = 0x0308;
	 
	 
}