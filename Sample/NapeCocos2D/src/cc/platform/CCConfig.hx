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
import flambe.math.Point;

/**
 * ...
 * @author
 */

class CCConfig 
{
	/**
	 * <p>
	 * The current version of Cocos2d-html5 being used.<br/>
	 * Please DO NOT remove this String, it is an important flag for bug tracking.<br/>
	 * If you post a bug to forum, please attach this flag.
	 * </p>
	 * @constant
	 * @type String
	 */
	public static var ENGINE_VERSION = "Cocos2d-html5-v2.1.1";

	/**
	 * <p>
	 *   If enabled, the texture coordinates will be calculated by using this formula: <br/>
	 *      - texCoord.left = (rect.origin.x*2+1) / (texture.wide*2);                  <br/>
	 *      - texCoord.right = texCoord.left + (rect.size.width*2-2)/(texture.wide*2); <br/>
	 *                                                                                 <br/>
	 *  The same for bottom and top.                                                   <br/>
	 *                                                                                 <br/>
	 *  This formula prevents artifacts by using 99% of the texture.                   <br/>
	 *  The "correct" way to prevent artifacts is by using the spritesheet-artifact-fixer.py or a similar tool.<br/>
	 *                                                                                  <br/>
	 *  Affected nodes:                                                                 <br/>
	 *      - public static var Sprite / public static var SpriteBatchNode and subclasses: public static var LabelBMFont, public static var TMXTiledMap <br/>
	 *      - public static var LabelAtlas                                                              <br/>
	 *      - public static var QuadParticleSystem                                                      <br/>
	 *      - public static var TileMap                                                                 <br/>
	 *                                                                                  <br/>
	 *  To enabled set it to 1. Disabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var FIX_ARTIFACTS_BY_STRECHING_TEXEL : Int = 0;

	/**
	 * Position of the FPS (Default: 0,0 (bottom-left corner))
	 * @constant
	 * @type public static var Point
	 */
	public static var DIRECTOR_STATS_POSITION : Point = new Point(0, 0);

	/**
	 * <p>
	 *   Senconds between FPS updates.<br/>
	 *   0.5 seconds, means that the FPS number will be updated every 0.5 seconds.<br/>
	 *   Having a bigger number means a more reliable FPS<br/>
	 *   <br/>
	 *   Default value: 0.1f<br/>
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var DIRECTOR_FPS_INTERVAL : Float = 0.5;

	/**
	 * <p>
	 *    If enabled, the public static var Node objects (public static var Sprite, public static var Label,etc) will be able to render in subpixels.<br/>
	 *    If disabled, integer pixels will be used.<br/>
	 *    <br/>
	 *    To enable set it to 1. Enabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var COCOSNODE_RENDER_SUBPIXEL : Int = 1;

	/**
	 * <p>
	 *   If enabled, the public static var Sprite objects rendered with public static var SpriteBatchNode will be able to render in subpixels.<br/>
	 *   If disabled, integer pixels will be used.<br/>
	 *   <br/>
	 *   To enable set it to 1. Enabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var SPRITEBATCHNODE_RENDER_SUBPIXEL : Int = 1;

	/**
	 * <p>
	 *   If enabled, public static var Node will transform the nodes using a cached Affine matrix.<br/>
	 *   If disabled, the node will be transformed using glTranslate,glRotate,glScale.<br/>
	 *   Using the affine matrix only requires 2 GL calls.<br/>
	 *   Using the translate/rotate/scale requires 5 GL calls.<br/>
	 *   But computing the Affine matrix is relative expensive.<br/>
	 *   But according to performance tests, Affine matrix performs better.<br/>
	 *   This parameter doesn't affect public static var SpriteBatchNode nodes.<br/>
	 *   <br/>
	 *   To enable set it to a value different than 0. Enabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var NODE_TRANSFORM_USING_AFFINE_MATRIX : Int = 1;

	/**
	 * <p>
	 *     If most of your imamges have pre-multiplied alpha, set it to 1 (if you are going to use .PNG/.JPG file images).<br/>
	 *     Only set to 0 if ALL your images by-pass Apple UIImage loading system (eg: if you use libpng or PVR images)<br/>
	 *     <br/>
	 *     To enable set it to a value different than 0. Enabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var OPTIMIZE_BLEND_FUNC_FOR_PREMULTIPLIED_ALPHA  : Int = 1;

	/**
	 * <p>
	 *   Use GL_TRIANGLE_STRIP instead of GL_TRIANGLES when rendering the texture atlas.<br/>
	 *   It seems it is the recommend way, but it is much slower, so, enable it at your own risk<br/>
	 *   <br/>
	 *   To enable set it to a value different than 0. Disabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var TEXTURE_ATLAS_USE_TRIANGLE_STRIP : Int = 0;

	/**
	 * <p>
	 *    By default, public static var TextureAtlas (used by many cocos2d classes) will use VAO (Vertex Array Objects).<br/>
	 *    Apple recommends its usage but they might consume a lot of memory, specially if you use many of them.<br/>
	 *    So for certain cases, where you might need hundreds of VAO objects, it might be a good idea to disable it.<br/>
	 *    <br/>
	 *    To disable it set it to 0. Enabled by default.<br/>
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var TEXTURE_ATLAS_USE_VAO :Int = 1;

	/**
	 * <p>
	 *  If enabled, NPOT textures will be used where available. Only 3rd gen (and newer) devices support NPOT textures.<br/>
	 *  NPOT textures have the following limitations:<br/>
	 *     - They can't have mipmaps<br/>
	 *     - They only accept GL_CLAMP_TO_EDGE in GL_TEXTURE_WRAP_{S,T}<br/>
	 *  <br/>
	 *  To enable set it to a value different than 0. Disabled by default. <br/>
	 *  <br/>
	 *  This value governs only the PNG, GIF, BMP, images.<br/>
	 *  This value DOES NOT govern the PVR (PVR.GZ, PVR.CCZ) files. If NPOT PVR is loaded, then it will create an NPOT texture ignoring this value.
	 * </p>
	 * @constant
	 * @type Number
	 * @deprecated This value will be removed in 1.1 and NPOT textures will be loaded by default if the device supports it.
	 */
	public static var TEXTURE_NPOT_SUPPORT : Int = 0;

	/**
	 * <p>
	 *    If enabled, cocos2d supports retina display.<br/>
	 *    For performance reasons, it's recommended disable it in games without retina display support, like iPad only games.<br/>
	 *    <br/>
	 *    To enable set it to 1. Use 0 to disable it. Enabled by default.<br/>
	 *    <br/>
	 *    This value governs only the PNG, GIF, BMP, images.<br/>
	 *    This value DOES NOT govern the PVR (PVR.GZ, PVR.CCZ) files. If NPOT PVR is loaded, then it will create an NPOT texture ignoring this value.
	 * </p>
	 * @constant
	 * @type Number
	 * @deprecated This value will be removed in 1.1 and NPOT textures will be loaded by default if the device supports it.
	 */
	public static var RETINA_DISPLAY_SUPPORT : Int = 1;

	/**
	 * <p>
	 *    It's the suffix that will be appended to the files in order to load "retina display" images.<br/>
	 *    <br/>
	 *    On an iPhone4 with Retina Display support enabled, the file @"sprite-hd.png" will be loaded instead of @"sprite.png".<br/>
	 *    If the file doesn't exist it will use the non-retina display image.<br/>
	 *    <br/>
	 *    Platforms: Only used on Retina Display devices like iPhone 4.
	 * </p>
	 * @constant
	 * @type String
	 */
	public static var RETINA_DISPLAY_FILENAME_SUFFIX : String = "-hd";

	/**
	 * <p>
	 *   If enabled, all subclasses of public static var Sprite will draw a bounding box<br/>
	 *   Useful for debugging purposes only. It is recommened to leave it disabled.<br/>
	 *   <br/>
	 *   To enable set it to a value different than 0. Disabled by default:<br/>
	 *      0 -- disabled<br/>
	 *      1 -- draw bounding box<
	 * @constant
	 * @type Number
	 */
	public static var SPRITE_DEBUG_DRAW : Int = 0;

	/**
	 * <p>
	 *    If enabled, all subclasses of public static var Sprite that are rendered using an public static var SpriteBatchNode draw a bounding box.<br/>
	 *    Useful for debugging purposes only. It is recommened to leave it disabled.<br/>
	 *    <br/>
	 *    To enable set it to a value different than 0. Disabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var SPRITEBATCHNODE_DEBUG_DRAW : Int = 0;

	/**
	 * <p>
	 *   If enabled, all subclasses of public static var LabelBMFont will draw a bounding box <br/>
	 *   Useful for debugging purposes only. It is recommened to leave it disabled.<br/>
	 *   <br/>
	 *   To enable set it to a value different than 0. Disabled by default.<br/>
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var LABELBMFONT_DEBUG_DRAW : Int = 0;

	/**
	 * <p>
	 *    If enabled, all subclasses of public static var LabeltAtlas will draw a bounding box<br/>
	 *    Useful for debugging purposes only. It is recommened to leave it disabled.<br/>
	 *    <br/>
	 *    To enable set it to a value different than 0. Disabled by default.
	 * </p>
	 * @constant
	 * @type Number
	 */
	public static var LABELATLAS_DEBUG_DRAW : Int = 0;

	/**
	 * whether or not support retina display
	 * @constant
	 * @type Number
	 */
	public static var IS_RETINA_DISPLAY_SUPPORTED : Int = 0;

	/**
	 * default engine
	 * @constant
	 * @type String
	 */
	public static var DEFAULT_ENGINE = ENGINE_VERSION + "-canvas";


	/**
	  Runtime information.
	  @deprecated Use "sys" instead.
	*/
	//public static var config = {
		//'platform' : sys.platform
	//};

	/**
	 * dump config info, but only in debug mode
	 */
	/*public static var dumpConfig = function()
	{
		for( i in sys )
			public static var log( i + " = " + sys[i] );
	};*/
	
	

}