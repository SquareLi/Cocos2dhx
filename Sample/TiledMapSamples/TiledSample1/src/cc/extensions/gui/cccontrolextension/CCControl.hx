package cc.extensions.gui.cccontrolextension;

import cc.basenodes.CCNode;
import cc.platform.CCTypes;
import cc.touchdispatcher.CCPointer;
import flambe.math.Point;
import cc.cocoa.CCGeometry;
import flambe.math.Rectangle;
import cc.CCScheduler;
import cc.layersscenestransitionsnodes.CCLayerRGBA
/**
 * ...
 * @author Ang Li
 */
 
class CCControl extends CCLayerRGBA
{
	/** Number of kinds of control event. */
	public static var CONTROL_EVENT_TOTAL_NUMBER : Int = 9;

	/** Kinds of possible events for the control objects. */
	public static var CONTROL_EVENT_TOUCH_DOWN : Int = 1 << 0;    // A touch-down event in the control.
	public static var CONTROL_EVENT_TOUCH_DRAG_INSIDE : Int = 1 << 1;    // An event where a finger is dragged inside the bounds of the control.
	public static var CONTROL_EVENT_TOUCH_DRAG_OUTSIDE : Int = 1 << 2;    // An event where a finger is dragged just outside the bounds of the control.
	public static var CONTROL_EVENT_TOUCH_DRAG_ENTER : Int = 1 << 3;    // An event where a finger is dragged into the bounds of the control.
	public static var CONTROL_EVENT_TOUCH_DRAG_EXIT : Int = 1 << 4;    // An event where a finger is dragged from within a control to outside its bounds.
	public static var CONTROL_EVENT_TOUCH_UP_INSIDE : Int = 1 << 5;    // A touch-up event in the control where the finger is inside the bounds of the control.
	public static var CONTROL_EVENT_TOUCH_UP_OUTSIDE : Int = 1 << 6;    // A touch-up event in the control where the finger is outside the bounds of the control.
	public static var CONTROL_EVENT_TOUCH_CANCEL : Int = 1 << 7;    // A system event canceling the current touches for the control.
	public static var CONTROL_EVENT_VALUECHANGED : Int = 1 << 8;    // A touch dragging or otherwise manipulating a control; causing it to emit a series of different values.

	/** The possible state for a control.  */
	public static var CONTROL_STATE_NORMAL : Int = 1 << 0; // The normal; or default state of a control梩hat is; enabled but neither selected nor highlighted.
	public static var CONTROL_STATE_HIGHLIGHTED : Int = 1 << 1; // Highlighted state of a control. A control enters this state when a touch down; drag inside or drag enter is performed. You can retrieve and set this value through the highlighted property.
	public static var CONTROL_STATE_DISABLED : Int = 1 << 2; // Disabled state of a control. This state indicates that the control is currently disabled. You can retrieve and set this value through the enabled property.
	public static var CONTROL_STATE_SELECTED : Int = 1 << 3;  // Selected state of a control. This state indicates that the control is currently selected. You can retrieve and set this value through the selected property.
	public static var CONTROL_STATE_INITIAL : Int = 1 << 3;
	
	var _isOpacityModifyRGB : Bool = false;
	var _hasVisibleParents : Bool = false;
	
	/** The current control state constant. */
	var _state : Int;
	
	var _enabled : Bool = false;
    var _selected : Bool = false;
    var _highlighted : Bool = false;

    var _dispatchTable : Map<String, Array<CCInvocation>> = null;
	var _color : CCColor3B;
	
	override public function isOpacityModifyRGB() : Bool{
        return this._isOpacityModifyRGB;
    }
	
    override public function setOpacityModifyRGB(opacityModifyRGB : Bool) {
        this._isOpacityModifyRGB = opacityModifyRGB;

        var children = this.getChildren();
        for (i in 0...children.length) {
            var selNode : CCControl = cast (children[i], CCControl);
            if ((selNode != null) && selNode.RGBAProtocol)
                selNode.setOpacityModifyRGB(opacityModifyRGB);
        }
    }

    
    public function getState() : Int {
        return this._state;
    }
	
    /**
     * Tells whether the control is enabled
     * @param {Boolean} enabled
     */
    public function setEnabled(enabled : Bool) {
        this._enabled = enabled;
        this._state = enabled ? CONTROL_STATE_NORMAL : CONTROL_STATE_DISABLED;

        this.needsLayout();
    }
	
    public function isEnabled() : Bool {
        return this._enabled;
    }

    /**
     * A Boolean value that determines the control selected state.
     * @param {Boolean} selected
     */
    public function setSelected:(selected : Bool) {
        this._selected = selected;
        this.needsLayout();
    }
	
    public function isSelected() : Bool {
        return this._selected;
    }

    /**
     *  A Boolean value that determines whether the control is highlighted.
     * @param {Boolean} highlighted
     */
    public function setHighlighted(highlighted : Bool) {
        this._highlighted = highlighted;
        this.needsLayout();
    }
	
    public function isHighlighted() : Bool {
        return this._highlighted;
    }

    public function hasVisibleParents() : Bool {
        var parent = this.getParent();
		
		var c : CCNode = parent;
		
		while (c != null) {
			if (!c.isVisible()) {
				return false;
			}
			c = c.getParent();
		}
    }

    public function new() {
        super();
        this._dispatchTable = {};
        this._color = CCTypes.white();
    }

	
    override public function init() : Bool{
		if (super.init()) {
            //this.setTouchEnabled(true);
            //m_bIsTouchEnabled=true;
            //Initialise instance variables
            this._state = CONTROL_STATE_NORMAL;
            this._enabled = true;
            this._selected = false;
            this._highlighted = false;

            //Set the touch dispatcher priority by default to 1
            this._defaultTouchPriority = 1;
            this.setTouchPriority(1);
            //Initialise the tables
            //this._dispatchTable = {};
            //dispatchTable.autorelease();
            //dispatchTable_ = [[NSMutableDictionary alloc] initWithCapacity:1];
            return true;
        } else
            return false;
    }

	//override public function registerWithTouchDispatcher() {
        //cc.registerTargetedDelegate(this.getTouchPriority(), true, this);
    //}
//
    /**
     * Sends action messages for the given control events.
     * which action messages are sent. See "CCControlEvent" for bitmask constants.
     * @param {Number} controlEvents A bitmask whose set flags specify the control events for
     */
    public function sendActionsForControlEvents(controlEvents : Int) {
        //For each control events
        for (i in 0...CONTROL_EVENT_TOTAL_NUMBER) {
            //If the given controlEvents bitmask contains the curent event
            if ((controlEvents & (1 << i))) {
                //Call invocations
                //<CCInvocation*>
                var invocationList = this._dispatchListforControlEvent(1 << i);
                for (j in 0...invocationList.length) {
                    invocationList[j].invoke(this);
                }
            }
        }
    },

    /**
     * <p>
     * Adds a target and action for a particular event (or events) to an internal                         <br/>
     * dispatch table.                                                                                    <br/>
     * The action message may optionally include the sender and the event as                              <br/>
     * parameters, in that order.                                                                         <br/>
     * When you call this method, target is not retained.
     * </p>
     * @param {Object} target The target object that is, the object to which the action message is sent. It cannot be nil. The target is not retained.
     * @param {function} action A selector identifying an action message. It cannot be NULL.
     * @param {Number} controlEvents A bitmask specifying the control events for which the action message is sent. See "CCControlEvent" for bitmask constants.
     */
		addTargetWithActionForControlEvents:function (target : CCNode, action : Void -> Void, controlEvents : Int) {
        //For each control events
        for (i 0...CONTROL_EVENT_TOTAL_NUMBER) {
            //If the given controlEvents bit mask contains the current event
            if ((controlEvents & (1 << i)))
                this._addTargetWithActionForControlEvent(target, action, 1 << i);
        }
    }

    /**
     * Removes a target and action for a particular event (or events) from an internal dispatch table.
     *
     * @param {Object} target The target object that is, the object to which the action message is sent. Pass nil to remove all targets paired with action and the specified control events.
     * @param {function} action A selector identifying an action message. Pass NULL to remove all action messages paired with target.
     * @param {Number} controlEvents A bitmask specifying the control events associated with target and action. See "CCControlEvent" for bitmask constants.
     */
    removeTargetWithActionForControlEvents:function (target : CCNode, action : Void -> Void, controlEvents : Int) {
        //For each control events
        for (i in 0...CONTROL_EVENT_TOTAL_NUMBER) {
            //If the given controlEvents bitmask contains the current event
            if ((controlEvents & (1 << i)))
                this.removeTargetWithActionForControlEvent(target, action, 1 << i);
        }
    }

    /**
     * Returns a point corresponding to the touh location converted into the
     * control space coordinates.
     * @param {cc.Touch} touch A CCTouch object that represents a touch.
     */
    public function getTouchLocation(touch : CCPointer ) : Point{
        var touchLocation = touch.getLocation();                      // Get the touch position
        return touchLocation;  // Convert to the node space of this class
    }

    /**
     * Returns a boolean value that indicates whether a touch is inside the bounds of the receiver. The given touch must be relative to the world.
     *
     * @param {cc.Touch} touch A cc.Touch object that represents a touch.
     * @return {Boolean} YES whether a touch is inside the receiver's rect.
     */
    public function isTouchInside(touch : CCPointer) : Bool{
        var touchLocation = touch.getLocation(); // Get the touch position
        // touchLocation = this.getParent().convertToNodeSpace(touchLocation);
	    return this.getBoundingBox().contains(touchLocation);
        //return cc.rectContainsPoint(this.getBoundingBox(), touchLocation);
    }

    /**
     * <p>
     * Returns an cc.Invocation object able to construct messages using a given                             <br/>
     * target-action pair. (The invocation may optionally include the sender and                            <br/>
     * the event as parameters, in that order)
     * </p>
     * @param {Object} target The target object.
     * @param {function} action A selector identifying an action message.
     * @param {Number} controlEvent A control events for which the action message is sent. See "CCControlEvent" for constants.
     *
     * @return {cc.Invocation} an CCInvocation object able to construct messages using a given target-action pair.
     */
    private function _invocationWithTargetAndActionForControlEvent:function (target : CCNode, action : Void -> Void, controlEvent : Int) {
        return null;
    }

    /**
     * Returns the cc.Invocation list for the given control event. If the list does not exist, it'll create an empty array before returning it.
     *
     * @param {Number} controlEvent A control events for which the action message is sent. See "CCControlEvent" for constants.
     * @return {cc.Invocation} the cc.Invocation list for the given control event.
     */
    private function _dispatchListforControlEvent(controlEvent : Int) : Array<CCInvocation>{
        var controlEventStr : String = Std.string(controlEvent);
        //If the invocation list does not exist for the  dispatch table, we create it
        if (!this._dispatchTable.exists(controlEvent))
            this._dispatchTable[controlEvent] = [];
        return this._dispatchTable[controlEvent];
    }

    /**
     * Adds a target and action for a particular event to an internal dispatch
     * table.
     * The action message may optionally include the sender and the event as
     * parameters, in that order.
     * When you call this method, target is not retained.
     *
     * @param target The target object that is, the object to which the action
     * message is sent. It cannot be nil. The target is not retained.
     * @param action A selector identifying an action message. It cannot be NULL.
     * @param controlEvent A control event for which the action message is sent.
     * See "CCControlEvent" for constants.
     */
    private function _addTargetWithActionForControlEvent(target : Dynamic, action : , controlEvent) {
        //Create the invocation object
        var invocation = new CCInvocation(target, action, controlEvent);

        //Add the invocation into the dispatch list for the given control event
        var eventInvocationList = this._dispatchListforControlEvent(controlEvent);
        eventInvocationList.push(invocation);
    }

    /**
     * Removes a target and action for a particular event from an internal dispatch table.
     *
     * @param {Object} target The target object that is, the object to which the action message is sent. Pass nil to remove all targets paired with action and the specified control events.
     * @param {function} action A selector identifying an action message. Pass NULL to remove all action messages paired with target.
     * @param {Number} controlEvent A control event for which the action message is sent. See "CCControlEvent" for constants.
     */
    private function removeTargetWithActionForControlEvent(target, action, controlEvent) {
        //Retrieve all invocations for the given control event
        //<CCInvocation*>
        var eventInvocationList : Array<CCInvocation> = this._dispatchListforControlEvent(controlEvent);

        //remove all invocations if the target and action are null
        //TODO: should the invocations be deleted, or just removed from the array? Won't that cause issues if you add a single invocation for multiple events?
        var bDeleteObjects : Bool = true;
        if (target == null && action == null) {
           // remove objects
            eventInvocationList = [];
        } else {
            //normally we would use a predicate, but this won't work here. Have to do it manually
            for (i in 0...eventInvocationList.length) {
                var invocation : CCInvocation = eventInvocationList[i];
                var shouldBeRemoved : Bool = true;
                if (target != null)
                    shouldBeRemoved = (target == invocation.getTarget());
                if (action != null)
                    shouldBeRemoved = (shouldBeRemoved && (action == invocation.getAction()));
                //Remove the corresponding invocation object
                if (shouldBeRemoved)
                    CCScheduler.ArrayRemoveObject(eventInvocationList, invocation);
            }
        }
    }

    /**
     * Updates the control layout using its current internal state.
     */
    public function needsLayout() {
    }
	
	public static function create() : CCControl{
		var retControl = new CCControl();
		if (retControl != null && retControl.init()) {
			return retControl;
		}
		return null;
	}
}
