package cc.extensions.ccbreader;
import cc.basenodes.CCNode;
import cc.menunodes.CCMenuItem;
import cc.platform.CCCommon;
import cc.extensions.ccbreader.CCBReader;
import cc.extensions.ccbreader.CCNodeLoaderLibrary;
import cc.cocoa.CCGeometry;
import cc.spritenodes.CCAnimation;
import cc.spritenodes.CCAnimationCache;
import cc.spritenodes.CCSpriteFrame;
import cc.spritenodes.CCSpriteFrameCache;
import flambe.display.BlendMode;
import flambe.math.Point;
import cc.CCScheduler;
import cc.texture.CCTextureCache;
import cc.texture.CCTexture2D;
import flambe.math.Rectangle;
import cc.platform.CCTypes;
import cc.extensions.ccbreader.CCBValue;
import cc.platform.CCMacro;
import cc.extensions.ccbreader.CCBAnimationManager;
/**
 * ...
 * @author Ang Li
 */
class CCNodeLoader
{
	public static var PROPERTY_POSITION : String = "position";
	public static var PROPERTY_CONTENTSIZE : String = "contentSize";
	public static var PROPERTY_ANCHORPOINT : String = "anchorPoint";
	public static var PROPERTY_SCALE : String = "scale";
	public static var PROPERTY_ROTATION : String = "rotation";
	public static var PROPERTY_TAG : String = "tag";
	public static var PROPERTY_IGNOREANCHORPOINTFORPOSITION : String = "ignoreAnchorPointForPosition";
	public static var PROPERTY_VISIBLE : String = "visible";
	
	var _customProperties :_Dictionary;
	
	public function new() 
	{
		this._customProperties = new _Dictionary();
	}
	
	public function loadCCNode(parent : CCNode, ccbReader : CCBuilderReader) : CCNode {
		return this._createCCNode(parent, ccbReader);
	}
	
	public function parseProperties(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
		
		var numRegularProps = ccbReader.readInt(false);
		//trace(numRegularProps);
		var numExturaProps = ccbReader.readInt(false);
		//trace(numExturaProps);
		var propertyCount = numRegularProps + numExturaProps;
		//trace(propertyCount);
		for (i in 0...propertyCount) {
			var isExtraProp : Bool = (i >= numRegularProps);
			var type = ccbReader.readInt(false);
			//trace("type = " + type);
			var propertyName = ccbReader.readCachedString();
			
			var setProp = false;
			
			var platform = ccbReader.readByte();
			if ((platform == CCBReader.CCB_PLATFORM_ALL) ||(platform == CCBReader.CCB_PLATFORM_IOS) ||(platform == CCBReader.CCB_PLATFORM_MAC) )
                setProp = true;
			if (Std.is(node, CCBuilderFile)) {
				var n : CCBuilderFile = cast (node, CCBuilderFile);
				node = n.getCCBFileNode();
				//var getExtraPropsNames = 
			} else if (isExtraProp && node == ccbReader.getAnimationManager().getRootNode()) {
				var extraPropsNames = node.getUserObject();
				if (extraPropsNames == null) {
					extraPropsNames = new Array<String>();
					node.setUserObject(extraPropsNames);
				}
				extraPropsNames.push(propertyName);
			}
			
			switch(type) {
				case CCBReader.CCB_PROPTYPE_POSITION:
					var position = this.parsePropTypePosition(node, parent, ccbReader, propertyName);
					if (setProp) {
						this.onHandlePropTypePosition(node, parent, propertyName, position, ccbReader);
					}
				case CCBReader.CCB_PROPTYPE_POINT:
                    var point = this.parsePropTypePoint(node, parent, ccbReader);
                    if (setProp)
                        this.onHandlePropTypePoint(node, parent, propertyName, point, ccbReader);
                case CCBReader.CCB_PROPTYPE_POINTLOCK:
                    var pointLock = this.parsePropTypePointLock(node, parent, ccbReader);
                    if (setProp)
                        this.onHandlePropTypePointLock(node, parent, propertyName, pointLock, ccbReader);
                case CCBReader.CCB_PROPTYPE_SIZE:
                    var size = this.parsePropTypeSize(node, parent, ccbReader);
                    if (setProp)
                        this.onHandlePropTypeSize(node, parent, propertyName, size, ccbReader);
                case CCBReader.CCB_PROPTYPE_SCALELOCK:
                    var scaleLock = this.parsePropTypeScaleLock(node, parent, ccbReader, propertyName);
					
                    if (setProp)
                        this.onHandlePropTypeScaleLock(node, parent, propertyName, scaleLock, ccbReader);
                case CCBReader.CCB_PROPTYPE_FLOATXY:
                    var xy = this.parsePropTypeFloatXY(node, parent, ccbReader);
                    if (setProp)
                        this.onHandlePropTypeFloatXY(node, parent, propertyName, xy, ccbReader);
                case CCBReader.CCB_PROPTYPE_FLOAT:
                    var f = this.parsePropTypeFloat(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeFloat(node, parent, propertyName, f, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_DEGREES:
                    var degrees = this.parsePropTypeDegrees(node, parent, ccbReader, propertyName);
                    if (setProp) {
                        this.onHandlePropTypeDegrees(node, parent, propertyName, degrees, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_FLOATSCALE:
                    var floatScale = this.parsePropTypeFloatScale(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeFloatScale(node, parent, propertyName, floatScale, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_INTEGER:
                    var integer = this.parsePropTypeInteger(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeInteger(node, parent, propertyName, integer, ccbReader);
					}
                case CCBReader.CCB_PROPTYPE_INTEGERLABELED:

                    var integerLabeled = this.parsePropTypeIntegerLabeled(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeIntegerLabeled(node, parent, propertyName, integerLabeled, ccbReader);
					}
                case CCBReader.CCB_PROPTYPE_FLOATVAR:
                    var floatVar = this.parsePropTypeFloatVar(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeFloatVar(node, parent, propertyName, floatVar, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_CHECK:
                    var check = this.parsePropTypeCheck(node, parent, ccbReader, propertyName);
                    if (setProp) {
                        this.onHandlePropTypeCheck(node, parent, propertyName, check, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_SPRITEFRAME:
					//trace("CCB_PROPTYPE_SPRITEFRAME");
                    var ccSpriteFrame : CCSpriteFrame = this.parsePropTypeSpriteFrame(node, parent, ccbReader, propertyName);
                    if (setProp) {
                        this.onHandlePropTypeSpriteFrame(node, parent, propertyName, ccSpriteFrame, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_ANIMATION:
					//trace("CCB_PROPTYPE_ANIMATION");
                    //var ccAnimation = this.parsePropTypeAnimation(node, parent, ccbReader);
                    //if (setProp) {
                        //this.onHandlePropTypeAnimation(node, parent, propertyName, ccAnimation, ccbReader);
                    //}
                case CCBReader.CCB_PROPTYPE_TEXTURE:
                    var ccTexture2D = this.parsePropTypeTexture(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeTexture(node, parent, propertyName, ccTexture2D, ccbReader);
                    }

                case CCBReader.CCB_PROPTYPE_BYTE:
                    var byteValue = this.parsePropTypeByte(node, parent, ccbReader, propertyName);
                    if (setProp) {
                        this.onHandlePropTypeByte(node, parent, propertyName, byteValue, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_COLOR3:
                    var color3B = this.parsePropTypeColor3(node, parent, ccbReader, propertyName);
                    if (setProp) {
                        this.onHandlePropTypeColor3(node, parent, propertyName, color3B, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_COLOR4VAR:
                    var color4FVar = this.parsePropTypeColor4FVar(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeColor4FVar(node, parent, propertyName, color4FVar, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_FLIP:
                    var flip = this.parsePropTypeFlip(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeFlip(node, parent, propertyName, flip, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_BLENDMODE:
                    var blendFunc = this.parsePropTypeBlendFunc(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeBlendFunc(node, parent, propertyName, blendFunc, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_FNTFILE:
                    var fntFile = ccbReader.getCCBRootPath() + this.parsePropTypeFntFile(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeFntFile(node, parent, propertyName, fntFile, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_FONTTTF:
                    var fontTTF = this.parsePropTypeFontTTF(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeFontTTF(node, parent, propertyName, fontTTF, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_STRING:
                    var stringValue = this.parsePropTypeString(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeString(node, parent, propertyName, stringValue, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_TEXT:
                    var textValue = this.parsePropTypeText(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeText(node, parent, propertyName, textValue, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_BLOCK:
                    var blockData = this.parsePropTypeBlock(node, parent, ccbReader);
                    if (setProp) {
                        this.onHandlePropTypeBlock(node, parent, propertyName, blockData, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_BLOCKCCCONTROL:
                    var blockCCControlData = this.parsePropTypeBlockCCControl(node, parent, ccbReader);
                    if (setProp && blockCCControlData != null) {
                        this.onHandlePropTypeBlockCCControl(node, parent, propertyName, blockCCControlData, ccbReader);
                    }
                case CCBReader.CCB_PROPTYPE_CCBFILE:
					//trace("CCB_PROPTYPE_CCBFILE");
                    //var ccbFileNode = this.parsePropTypeCCBFile(node, parent, ccbReader);
                    //if (setProp) {
                        //this.onHandlePropTypeCCBFile(node, parent, propertyName, ccbFileNode, ccbReader);
                    //}
                default:
                    ASSERT_FAIL_UNEXPECTED_PROPERTYTYPE(Std.string(type));
			}
		}
	}
	
	public function getCustomProperties() : _Dictionary {
		return this._customProperties;
	}
	
	private function _createCCNode(parent : CCNode, ccbReader : CCBuilderReader) : CCNode {
		var ret : CCNode = CCNode.create();
		return ret;
	}
	
	public function parsePropTypePosition(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Point {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		//trace('x = $x, y = $y');
		
		
		var type = ccbReader.readInt(false);
		
		var containerSize : CCSize = ccbReader.getAnimationManager().getContainerSize(parent);
		
		//trace('width = ${containerSize.width}, height = ${containerSize.height}');
		var pt = CCBRelativePositioning._getAbsolutePosition(x, y, type, containerSize, propertyName);
		//var p = CCBRelativePositioning.getAbsolutePosition(pt, type, containerSize, propertyName);
		
		//var p : Point = new Point(pt.x, containerSize.height - pt.y);
		
		//p.y = containerSize.height - p.y;
		node.setPosition(pt.x, pt.y);
		//trace('pt.x = ${pt.x}, pt.y = ${pt.y}');
		//trace('p.x = ${p.x}, p.y = ${p.y}');
		
		
		
		if (CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1) {
			var typeFloat = Std.parseFloat(Std.string(type));
			var baseValue = [x, y, typeFloat];
			ccbReader.getAnimationManager().setBaseValue(baseValue, node, propertyName);
		}
		//trace(pt);
		
		//trace('pt.x = ${pt.x}, pt.y = ${pt.y}');
		//trace('p.x = ${p.x}, p.y = ${p.y}');
		return pt;
	}
	
	public function parsePropTypePoint(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Point {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		return new Point(x, y);
	}
	
	public function parsePropTypePointLock(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Point {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		return new Point(x, y);
	}
	
	public function parsePropTypeSize(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : CCSize {
		var width = ccbReader.readFloat();
		var height = ccbReader.readFloat();
		
		var type = ccbReader.readInt(false);
		
		var containerSize = ccbReader.getAnimationManager().getContainerSize(parent);
		
		switch (type) {
			case CCBReader.CCB_SIZETYPE_ABSOLUTE:
                /* Nothing. */
            case CCBReader.CCB_SIZETYPE_RELATIVE_CONTAINER:
                width = containerSize.width - width;
                height = containerSize.height - height;
            case CCBReader.CCB_SIZETYPE_PERCENT:
                width = (containerSize.width * width / 100.0);
                height = (containerSize.height * height / 100.0);
            case CCBReader.CCB_SIZETYPE_HORIZONTAL_PERCENT:
                width = (containerSize.width * width / 100.0);
            case CCBReader.CCB_SIZETYPE_VERTICAL_PERCENT:
                height = (containerSize.height * height / 100.0);
            case CCBReader.CCB_SIZETYPE_MULTIPLY_RESOLUTION:
                var resolutionScale = CCBuilderReader.getResolutionScale();
                width *= resolutionScale;
                height *= resolutionScale;
            default:
                trace("Unknown CCB type.");
		}
		return new CCSize(width, height);
	}
	
	
	public function parsePropTypeScaleLock(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Array<Float> {
		var x = ccbReader.readFloat();
		var y = ccbReader.readFloat();
		
		var type = ccbReader.readInt(false);
		
		CCBRelativePositioning.setRelativeScale(node, x, y, type, propertyName);
		if (CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1) {
			var typeFloat = Std.parseFloat(Std.string(type));
			var baseValue = [x, y, typeFloat];
			ccbReader.getAnimationManager().setBaseValue(baseValue, node, propertyName);
		}
		
		if (type == CCBReader.CCB_SCALETYPE_MULTIPLY_RESOLUTION) {
			x *= CCBuilderReader.getResolutionScale();
            y *= CCBuilderReader.getResolutionScale();
		}
		return [x, y];
	}
	
	public function parsePropTypeFloat(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Float {
		return ccbReader.readFloat();
	}
	
	public function parsePropTypeDegrees(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Float {
		var ret : Float = ccbReader.readFloat();
		if (CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1) {
			ccbReader.getAnimationManager().setBaseValue(ret, node, propertyName);
		}
		return ret;
	}
	//------------------------
	public function parsePropTypeFloatScale(node, parent : CCNode, ccbReader : CCBuilderReader) : Float {
        var f = ccbReader.readFloat();

        var type = ccbReader.readInt(false);

        if (type == CCBReader.CCB_SCALETYPE_MULTIPLY_RESOLUTION) {
            f *= CCBuilderReader.getResolutionScale();
        }

        return f;
    }

    public function parsePropTypeInteger(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Int{
        return ccbReader.readInt(true);
    }

    public function parsePropTypeIntegerLabeled(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Int{
        return ccbReader.readInt(true);
    }

    public function parsePropTypeFloatVar(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Array<Float>{
        var f = ccbReader.readFloat();
        var fVar = ccbReader.readFloat();
        return [f, fVar];
    }

     public function parsePropTypeCheck(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Bool {
        var ret = ccbReader.readBool();
        if(CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1){
            ccbReader.getAnimationManager().setBaseValue(ret,node, propertyName);
        }
        return ret;
    }

    public function parsePropTypeSpriteFrame(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : CCSpriteFrame{
        //trace("sprite frame");
		var spriteSheet = ccbReader.readCachedString();
        var spriteFile : String =  ccbReader.readCachedString();

        var spriteFrame : CCSpriteFrame = null;
        if(spriteFile != null && spriteFile.length != 0){
            if (spriteSheet.length == 0) {
				spriteFile = spriteFile.split(".")[0];
                spriteFile = ccbReader.getCCBRootPath() + spriteFile;
                var texture : CCTexture2D = CCTextureCache.getInstance().addImage(spriteFile);

                var locContentSize : CCSize = texture.getContentSize();
				//trace("width : " + locContentSize.width);
                var bounds : Rectangle = new Rectangle(0, 0, locContentSize.width, locContentSize.height);
                spriteFrame = CCSpriteFrame.createWithTexture(texture, bounds, false, new Point(0, 0), new CCSize());
            } else {
                var frameCache : CCSpriteFrameCache = CCSpriteFrameCache.getInstance();
                spriteSheet = ccbReader.getCCBRootPath() + spriteSheet;
                //load the sprite sheet only if it is not loaded
				if (CCScheduler.ArrayGetIndexOfValue(ccbReader.getLoadedSpriteSheet(), spriteSheet) == -1) {
					frameCache.addSpriteFrames(spriteSheet);
                    ccbReader.getLoadedSpriteSheet().push(spriteSheet);
				}
                spriteFrame = frameCache.getSpriteFrame(spriteFile);
            }
            if(CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1){
                ccbReader.getAnimationManager().setBaseValue(spriteFrame,node,propertyName);
            }
        }

        return spriteFrame;
    }

    public function parsePropTypeAnimation(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader){
        //var animationFile = ccbReader.getCCBRootPath() + ccbReader.readCachedString();
        //var animation = ccbReader.readCachedString();
//
        //var ccAnimation = null;
//
        // Support for stripping relative file paths, since ios doesn't currently
        // know what to do with them, since its pulling from bundle.
        // Eventually this should be handled by a client side asset manager
        // interface which figured out what resources to load.
        // TODO Does this problem exist in C++?
        //animation = cc.BuilderReader.lastPathComponent(animation);
        //animationFile = cc.BuilderReader.lastPathComponent(animationFile);
//
        //if (animation != null && animation != "") {
            //var animationCache : CCAnimationCache = CCAnimationCache.getInstance();
            //animationCache.addAnimations(animationFile);
//
            //ccAnimation = animationCache.getAnimation(animation);
        //}
        //return ccAnimation;
		//return CCAnimation.create(null, null, null);
    }

    public function parsePropTypeTexture(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : CCTexture2D {
        var spriteFile = ccbReader.getCCBRootPath() + ccbReader.readCachedString();
		//trace(spriteFile);
        if(spriteFile != "")
            return CCTextureCache.getInstance().addImage(spriteFile);
        return null;
    }

    public function parsePropTypeByte(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : Int {
        var ret = ccbReader.readByte();
        if(CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1){
            ccbReader.getAnimationManager().setBaseValue(ret,node, propertyName);
        }
        return ret;
    }

    public function parsePropTypeColor3(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader, propertyName : String) : CCColor3B {
        var red = ccbReader.readByte();
        var green = ccbReader.readByte();
        var blue = ccbReader.readByte();
        var color : CCColor3B = new CCColor3B(red, green, blue);
        if(CCScheduler.ArrayGetIndexOfValue(ccbReader.getAnimatedProperties(), propertyName) > -1){
            ccbReader.getAnimationManager().setBaseValue(CCColor3BWapper.create(color),node, propertyName);
        }
        return color;
    }

    public function parsePropTypeColor4FVar(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Array<CCColor4B> {
        var red = Std.int(ccbReader.readFloat());
        var green = Std.int(ccbReader.readFloat());
        var blue = Std.int(ccbReader.readFloat());
        var alpha = Std.int(ccbReader.readFloat());
        var redVar = Std.int(ccbReader.readFloat());
        var greenVar = Std.int(ccbReader.readFloat());
        var blueVar = Std.int(ccbReader.readFloat());
        var alphaVar = Std.int(ccbReader.readFloat());

        var colors : Array<CCColor4B> = new Array<CCColor4B>();
        colors[0] = new CCColor4B(red, green, blue, alpha);
        colors[1] = new CCColor4B(redVar, greenVar, blueVar, alphaVar);

        return colors;
    }

    public function parsePropTypeFlip(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Array<Bool>{
        var flipX : Bool = ccbReader.readBool();
        var flipY : Bool = ccbReader.readBool();

        return [flipX, flipY];
    }

    public function parsePropTypeBlendFunc(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : BlendMode{
        var source = ccbReader.readInt(false);
        var destination = ccbReader.readInt(false);
		if (source == CCMacro.SRC_ALPHA && source == CCMacro.ONE) {
			return BlendMode.Add;
		}
        return null;
    }

    public function parsePropTypeFntFile(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        return ccbReader.readCachedString();
    }

    public function parsePropTypeString(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        return ccbReader.readCachedString();
    }

    public function parsePropTypeText(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        return ccbReader.readCachedString();
    }

    public function parsePropTypeFontTTF(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        return ccbReader.readCachedString();
        //var ttfEnding = ".ttf";

        //TODO Fix me if it is wrong
        /* If the fontTTF comes with the ".ttf" extension, prepend the absolute path.
         * System fonts come without the ".ttf" extension and do not need the path prepended. */
        /*if (cc.CCBReader.endsWith(fontTTF.toLowerCase(), ttfEnding)) {
            fontTTF = ccbReader.getCCBRootPath() + fontTTF;
        }*/
    }

    public function parsePropTypeBlock(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        var selectorName = ccbReader.readCachedString();
        var selectorTarget = ccbReader.readInt(false);
		
		//trace(selectorName + ", " + selectorTarget);

        if (selectorTarget != CCBReader.CCB_TARGETTYPE_NONE) {
            var target = null;

			var mi : CCMenuItem = cast (node, CCMenuItem);
			//Reflect.callMethod(ccbReader.getController(), Reflect.field(ccbReader.getController(), "fuck"), []);
			mi.setCallback(Reflect.field(ccbReader.getController(), selectorName), ccbReader.getController());
        }
        return null;
    }

    public function parsePropTypeBlockCCControl(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        var selectorName = ccbReader.readCachedString();
        var selectorTarget = ccbReader.readInt(false);
        var controlEvents = ccbReader.readInt(false);

        //if (selectorTarget != CCBReader.CCB_TARGETTYPE_NONE) {
            //if (!ccbReader.isJSControlled()) {
				//
			//} else if(selectorTarget == CCBReader.CCB_TARGETTYPE_DOCUMENTROOT){
                    //ccbReader.addDocumentCallbackNode(node);
                    //ccbReader.addDocumentCallbackName(selectorName);
                    //ccbReader.addDocumentCallbackControlEvents(controlEvents);
            //} else{
                    //ccbReader.addOwnerCallbackNode(node);
                    //ccbReader.addOwnerCallbackName(selectorName);
			//}
        //}
        
        return null;
    }

    public function parsePropTypeCCBFile(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) {
        //var ccbFileName = ccbReader.getCCBRootPath() + ccbReader.readCachedString();
//
        ///* Change path extension to .ccbi. */
        //var ccbFileWithoutPathExtension = cc.BuilderReader.deletePathExtension(ccbFileName);
        //ccbFileName = ccbFileWithoutPathExtension + ".ccbi";
//
        //load sub file
        //var fileUtils = CCFileUtils.getInstance();
        //var path = fileUtils.fullPathFromRelativePath(ccbFileName);
        //var myCCBReader = new CCBuilderReader(ccbReader);
//
        //var size : CCSize;
        //var bytes = fileUtils.getByteArrayFromFile(path,"rb", size);
//
        //myCCBReader.initWithData(bytes,ccbReader.getOwner());
        //myCCBReader.getAnimationManager().setRootContainerSize(parent.getContentSize());
        //myCCBReader.setAnimationManagers(ccbReader.getAnimationManagers());
//
        //myCCBReader.getAnimationManager().setOwner(ccbReader.getOwner());
        //var ccbFileNode = myCCBReader.readFileWithCleanUp(false);
//
        //ccbReader.setAnimationManagers(myCCBReader.getAnimationManagers());
//
        //if(ccbFileNode && myCCBReader.getAnimationManager().getAutoPlaySequenceId() != -1)
            //myCCBReader.getAnimationManager().runAnimations(myCCBReader.getAnimationManager().getAutoPlaySequenceId(),0);
//
        //return ccbFileNode;
    }

    public function parsePropTypeFloatXY(node : CCNode, parent : CCNode, ccbReader : CCBuilderReader) : Array<Float>{
        var x = ccbReader.readFloat();
        var y = ccbReader.readFloat();
        return [x,y];
    }

    public function onHandlePropTypePosition(node : CCNode, parent : CCNode, propertyName : String, position : Point, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_POSITION) {
            node.setPosition(position.x, position.y);
			//trace(position);
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }

    public function onHandlePropTypePoint(node : CCNode, parent : CCNode, propertyName : String, position : Point, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_ANCHORPOINT) {
			var p : Point = new Point(position.x, position.y);
			node.isOriginTopLeft = false;
			node.setAnchorPoint(p);
			
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }

    public function onHandlePropTypePointLock(node : CCNode, parent : CCNode, propertyName : String, pointLock : Dynamic, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }

    public function onHandlePropTypeSize(node : CCNode, parent : CCNode, propertyName : String, sizeValue : CCSize, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_CONTENTSIZE) {
            node.setContentSize(sizeValue);
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }

    public function onHandlePropTypeScaleLock(node : CCNode, parent : CCNode, propertyName : String, scaleLock : Array<Float>, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_SCALE) {
            node.setScaleX(scaleLock[0]);
            node.setScaleY(scaleLock[1]);
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }
    public function onHandlePropTypeFloatXY(node : CCNode, parent : CCNode, propertyName : String, xy : Array<Float>, ccbReader : CCBuilderReader) {
        //if (propertyName == PROPERTY_SKEW) {
            //node.setSkewX(xy[0]);
            //node.setSkewY(xy[1]);
        //} else {
            //var nameX = propertyName + "X";
            //var nameY = propertyName + "Y";
            //if (!node[nameX] || !node[nameY])
                //ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
            //TODO throw an error when source code was confused
            //node[nameX](xy[0]);
            //node[nameY](xy[1]);
        //}
    }
    public function onHandlePropTypeFloat(node : CCNode, parent : CCNode, propertyName : String, floatValue : Float, ccbReader : CCBuilderReader) {
        //ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        // It may be a custom property, add it to custom property dictionary.
        this._customProperties.setObject(floatValue, propertyName);
    }

    public function onHandlePropTypeDegrees(node : CCNode, parent : CCNode, propertyName : String, degrees : Float, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_ROTATION) {
            node.setRotation(degrees);
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }

    public function onHandlePropTypeFloatScale(node : CCNode, parent : CCNode, propertyName : String, floatScale : Float, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }

    public function onHandlePropTypeInteger(node : CCNode, parent : CCNode, propertyName : String, integer : Int, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_TAG) {
            node.setTag(integer);
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }

    public function onHandlePropTypeIntegerLabeled(node : CCNode, parent : CCNode, propertyName : String, integerLabeled : Dynamic, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }

    public function onHandlePropTypeFloatVar(node : CCNode, parent : CCNode, propertyName : String, floatVar : Array<Float>, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }

    public function onHandlePropTypeCheck(node : CCNode, parent : CCNode, propertyName : String, check : Bool, ccbReader : CCBuilderReader) {
        if (propertyName == PROPERTY_VISIBLE) {
            node.setVisible(check);
        } else if (propertyName == PROPERTY_IGNOREANCHORPOINTFORPOSITION) {
            node.ignoreAnchorPointForPosition(check);
        } else {
            ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        }
    }

    public function onHandlePropTypeSpriteFrame(node : CCNode, parent : CCNode, propertyName : String, spriteFrame : CCSpriteFrame, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }

    public function onHandlePropTypeAnimation(node : CCNode, parent : CCNode, propertyName : String, ccAnimation : CCAnimation, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }

    public function onHandlePropTypeTexture(node : CCNode, parent : CCNode, propertyName : String, ccTexture2D : CCTexture2D, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeByte(node : CCNode, parent : CCNode, propertyName : String, byteValue : Int, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeColor3(node : CCNode, parent : CCNode, propertyName : String, ccColor3B : CCColor3B, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeColor4FVar(node : CCNode, parent : CCNode, propertyName : String, ccColor4FVar : Array<CCColor4B>, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeFlip(node : CCNode, parent : CCNode, propertyName : String, flip : Dynamic, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeBlendFunc(node : CCNode, parent : CCNode, propertyName : String, ccBlendFunc : BlendMode, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeFntFile(node : CCNode, parent : CCNode, propertyName : String, fntFile : Dynamic, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeString(node : CCNode, parent : CCNode, propertyName : String, strValue : String, ccbReader : CCBuilderReader) {
        //ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
        // It may be a custom property, add it to custom property dictionary.
        this._customProperties.setObject(strValue, propertyName);
    }
    public function onHandlePropTypeText(node : CCNode, parent : CCNode, propertyName : String, textValue : String, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeFontTTF(node : CCNode, parent : CCNode, propertyName : String, fontTTF : String, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeBlock(node : CCNode, parent : CCNode, propertyName : String, blockData : BlockData, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeBlockCCControl(node : CCNode, parent : CCNode, propertyName : String, blockCCControlData : BlockCCControlData, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
    public function onHandlePropTypeCCBFile(node : CCNode, parent : CCNode, propertyName : String, ccbFilenode : Dynamic, ccbReader : CCBuilderReader) {
        ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName);
    }
	
	public static function ASSERT_FAIL_UNEXPECTED_PROPERTY(propertyName : String) {
		CCCommon.assert(false, "Unexpected property: '" + propertyName + "'!");
	}
	
	public static function ASSERT_FAIL_UNEXPECTED_PROPERTYTYPE(propertyName : String) {

		CCCommon.assert(false, "Unexpected property type: '" + propertyName + "'!");
	}
	
	public static function loader() : CCNodeLoader {
		return new CCNodeLoader();
	}
}

class BlockData {
	public var selMenuHander : Void -> Void;
	public var target : CCNode;
	public function new(selMenuHander : Void -> Void, target : CCNode) {
		this.selMenuHander = selMenuHander;
		this.target = target;
	}
}

class BlockCCControlData {
	public var selMenuHander : Void -> Void;
	public var target : CCNode;
	public var controlEvents : Dynamic;
	
	public function new(selMenuHander : Void -> Void, target : CCNode, controlEvents : Dynamic) {
		this.selMenuHander = selMenuHander;
		this.target = target;
		this.controlEvents = controlEvents;
	}
}