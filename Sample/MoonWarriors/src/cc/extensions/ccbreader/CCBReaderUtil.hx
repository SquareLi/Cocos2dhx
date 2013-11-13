package cc.extensions.ccbreader;
import cc.basenodes.CCNode;
/**
 * ...
 * @author
 */
class CCBReaderUtil
{

	public function new() 
	{
		
	}
	
}

class CCNodeLoaderListener {
	public function new() {
		
	}
	public functioin onNodeLoaded(node : CCNode, nodeLoader : CCNodeLoader){}
}

class CCBuilderSelectorResolver {
	public function onResolveCCBCCMenuItemSelector(target, selectorName : String){},
    public function onResolveCCBCCCallFuncSelector(target, selectorName : String){},
    public function onResolveCCBCCControlSelector(target,selectorName : String){}
}

class CCBuilderScriptOwnerProtocol {
	public function createNew() {
		
	}
}

class CCBuilderMemberVariableAssigner {
	/**
     * The callback function of assigning member variable.          <br/>
     * @note The member variable must be CCNode or its subclass.
     * @param {Object} target The custom class
     * @param {string} memberVariableName The name of the member variable.
     * @param {cc.Node} node The member variable.
     * @return {Boolean} Whether the assignment was successful.
     */
    public function onAssignCCBMemberVariable(target : Dynamic ,memberVariableName : String, node : CCNode) : Bool { return false;}

    /**
     * The callback function of assigning custom properties.
     * @note The member variable must be Integer, Float, Boolean or String.
     * @param {Object} target The custom class.
     * @param {string} memberVariableName The name of the member variable.
     * @param {*} value The value of the property.
     * @return {Boolean} Whether the assignment was successful.
     */
    public function onAssignCCBCustomProperty(target : Dynamic, memberVariableName : String, value : Dynamic) : Bool { return false; }
}