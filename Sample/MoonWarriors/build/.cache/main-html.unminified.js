(function () { "use strict";
var $estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,__class__: EReg
}
var HxOverrides = function() { }
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var Lambda = function() { }
Lambda.__name__ = true;
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
var IMap = function() { }
IMap.__name__ = true;
var Reflect = function() { }
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
var Std = function() { }
Std.__name__ = true;
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	addSub: function(s,pos,len) {
		this.b += len == null?HxOverrides.substr(s,pos,null):HxOverrides.substr(s,pos,len);
	}
	,__class__: StringBuf
}
var StringTools = function() { }
StringTools.__name__ = true;
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
var XmlType = { __ename__ : true, __constructs__ : [] }
var Xml = function() {
};
Xml.__name__ = true;
Xml.parse = function(str) {
	return haxe.xml.Parser.parse(str);
}
Xml.createElement = function(name) {
	var r = new Xml();
	r.nodeType = Xml.Element;
	r._children = new Array();
	r._attributes = new haxe.ds.StringMap();
	r.set_nodeName(name);
	return r;
}
Xml.createPCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.PCData;
	r.set_nodeValue(data);
	return r;
}
Xml.createCData = function(data) {
	var r = new Xml();
	r.nodeType = Xml.CData;
	r.set_nodeValue(data);
	return r;
}
Xml.createComment = function(data) {
	var r = new Xml();
	r.nodeType = Xml.Comment;
	r.set_nodeValue(data);
	return r;
}
Xml.createDocType = function(data) {
	var r = new Xml();
	r.nodeType = Xml.DocType;
	r.set_nodeValue(data);
	return r;
}
Xml.createProcessingInstruction = function(data) {
	var r = new Xml();
	r.nodeType = Xml.ProcessingInstruction;
	r.set_nodeValue(data);
	return r;
}
Xml.createDocument = function() {
	var r = new Xml();
	r.nodeType = Xml.Document;
	r._children = new Array();
	return r;
}
Xml.prototype = {
	addChild: function(x) {
		if(this._children == null) throw "bad nodetype";
		if(x._parent != null) HxOverrides.remove(x._parent._children,x);
		x._parent = this;
		this._children.push(x);
	}
	,firstElement: function() {
		if(this._children == null) throw "bad nodetype";
		var cur = 0;
		var l = this._children.length;
		while(cur < l) {
			var n = this._children[cur];
			if(n.nodeType == Xml.Element) return n;
			cur++;
		}
		return null;
	}
	,firstChild: function() {
		if(this._children == null) throw "bad nodetype";
		return this._children[0];
	}
	,elements: function() {
		if(this._children == null) throw "bad nodetype";
		return { cur : 0, x : this._children, hasNext : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				if(this.x[k].nodeType == Xml.Element) break;
				k += 1;
			}
			this.cur = k;
			return k < l;
		}, next : function() {
			var k = this.cur;
			var l = this.x.length;
			while(k < l) {
				var n = this.x[k];
				k += 1;
				if(n.nodeType == Xml.Element) {
					this.cur = k;
					return n;
				}
			}
			return null;
		}};
	}
	,exists: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.exists(att);
	}
	,set: function(att,value) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		this._attributes.set(att,value);
	}
	,get: function(att) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._attributes.get(att);
	}
	,set_nodeValue: function(v) {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue = v;
	}
	,get_nodeValue: function() {
		if(this.nodeType == Xml.Element || this.nodeType == Xml.Document) throw "bad nodeType";
		return this._nodeValue;
	}
	,set_nodeName: function(n) {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName = n;
	}
	,get_nodeName: function() {
		if(this.nodeType != Xml.Element) throw "bad nodeType";
		return this._nodeName;
	}
	,__class__: Xml
}
var flambe = {}
flambe.util = {}
flambe.util.Disposable = function() { }
flambe.util.Disposable.__name__ = true;
flambe.util.Disposable.prototype = {
	__class__: flambe.util.Disposable
}
flambe.Component = function() { }
flambe.Component.__name__ = true;
flambe.Component.__interfaces__ = [flambe.util.Disposable];
flambe.Component.prototype = {
	init: function(owner,next) {
		this.owner = owner;
		this.next = next;
	}
	,get_name: function() {
		return null;
	}
	,dispose: function() {
		if(this.owner != null) this.owner.remove(this);
	}
	,onUpdate: function(dt) {
	}
	,onRemoved: function() {
	}
	,onAdded: function() {
	}
	,__class__: flambe.Component
}
var cc = {}
cc.CCComponent = function(node) {
	this._node = node;
};
cc.CCComponent.__name__ = true;
cc.CCComponent.__super__ = flambe.Component;
cc.CCComponent.prototype = $extend(flambe.Component.prototype,{
	onRemoved: function() {
		flambe.Component.prototype.onRemoved.call(this);
		this._node.onExit();
	}
	,onUpdate: function(dt) {
		flambe.Component.prototype.onUpdate.call(this,dt);
		this._node.update(dt);
	}
	,onAdded: function() {
		flambe.Component.prototype.onAdded.call(this);
		this._node.onEnter();
	}
	,get_name: function() {
		return "CCComponent_4";
	}
	,__class__: cc.CCComponent
});
cc.CCDirector = function() {
	this._actionManager = null;
	this._scheduler = null;
	this._projectionDelegate = null;
	this._scenesStack = null;
	this._winSizeInPoints = null;
	this._contentScaleFactor = 0.0;
	this._projection = 0.0;
	this._oldAnimationInterval = 0.0;
	this._animationInterval = 0.0;
};
cc.CCDirector.__name__ = true;
cc.CCDirector.getInstance = function() {
	if(cc.CCDirector.firstUseDirector) {
		cc.CCDirector.firstUseDirector = false;
		cc.CCDirector.s_SharedDirector = new cc.CCDirector();
		cc.CCDirector.s_SharedDirector.init();
	}
	return cc.CCDirector.s_SharedDirector;
}
cc.CCDirector.prototype = {
	getPointerDispatcher: function() {
		return this._pointerDispatcher;
	}
	,getActionManager: function() {
		return this._actionManager;
	}
	,runWithScene: function(scene) {
		this.director.pushScene(scene.getEntity());
	}
	,replaceScene: function(scene) {
		this.popScene();
		if(js.Boot.__instanceof(scene,cc.layersscenestransitionsnodes.CCTransitionScene)) {
			var s = js.Boot.__cast(scene , cc.layersscenestransitionsnodes.CCTransitionScene);
			this.director.pushScene(s.getInScene().entity);
		} else this.director.pushScene(scene.entity);
		this.length++;
	}
	,popScene: function() {
		this.director.popScene();
		this.length--;
	}
	,getWinSize: function() {
		return this._winSizeInPoints;
	}
	,init: function() {
		this._oldAnimationInterval = this._animationInterval = 1.0 / cc.CCDirector.defaultFPS;
		this._scenesStack = new Array();
		this._projection = cc.CCDirector.DIRECTOR_PROJECTION_DEFAULT;
		this._projectionDelegate = null;
		this._contentScaleFactor = 1.0;
		this._scheduler = new cc.CCScheduler();
		this._actionManager = new cc.action.CCActionManager();
		this._winSizeInPoints = new cc.cocoa.CCSize(flambe.System._platform.getStage().get_width(),flambe.System._platform.getStage().get_height());
		this._pointerDispatcher = new cc.touchdispatcher.CCPointerDispatcher();
		this._keyboardDispatcher = cc.keyboarddispatcher.CCKeyboardDispatcher.getInstance();
		this.length = 0;
		this.director = new flambe.scene.Director();
		flambe.System.root.add(this.director);
	}
	,__class__: cc.CCDirector
}
cc.CCLoader = function() { }
cc.CCLoader.__name__ = true;
cc.CCScheduler = function() {
};
cc.CCScheduler.__name__ = true;
cc.CCScheduler.ArrayRemoveObject_sample_Enemy = function(arr,delObj) {
	HxOverrides.remove(arr,delObj);
}
cc.CCScheduler.ArrayRemoveObject_cc_touchdispatcher_CCPointerHandler = function(arr,delObj) {
	HxOverrides.remove(arr,delObj);
}
cc.CCScheduler.ArrayAppendObjectToIndex_cc_touchdispatcher_CCPointerHandler = function(arr,addObj,index) {
	var part1 = arr.splice(0,index);
	var part2 = arr.slice(index);
	part1.push(addObj);
	arr = part1.concat(part2);
	return arr;
}
cc.CCScheduler.prototype = {
	__class__: cc.CCScheduler
}
cc.action = {}
cc.action.CCAction = function() {
	this._tag = cc.action.CCAction.ACTION_TAG_INVALID;
};
cc.action.CCAction.__name__ = true;
cc.action.CCAction.create = function() {
	return new cc.action.CCAction();
}
cc.action.CCAction.prototype = {
	setAnimation: function(animation) {
		this._animation = animation;
	}
	,setTag: function(tag) {
		this._tag = tag;
	}
	,getTag: function() {
		return this._tag;
	}
	,update: function(time) {
	}
	,step: function(dt) {
		null;
	}
	,stop: function() {
		this._target = null;
	}
	,startWithTarget: function(target) {
		this._originalTarget = target;
		this._target = target;
	}
	,isDone: function() {
		return true;
	}
	,__class__: cc.action.CCAction
}
cc.action.CCFiniteTimeAction = function() {
	this._duration = 0;
	cc.action.CCAction.call(this);
	this._duration = 0;
};
cc.action.CCFiniteTimeAction.__name__ = true;
cc.action.CCFiniteTimeAction.__super__ = cc.action.CCAction;
cc.action.CCFiniteTimeAction.prototype = $extend(cc.action.CCAction.prototype,{
	stop: function() {
		cc.action.CCAction.prototype.stop.call(this);
	}
	,update: function(time) {
		cc.action.CCAction.prototype.update.call(this,time);
	}
	,getDuration: function() {
		return this._duration;
	}
	,__class__: cc.action.CCFiniteTimeAction
});
cc.action.CCActionInterval = function() {
	cc.action.CCFiniteTimeAction.call(this);
	this._elapsed = 0;
	this._firstTick = false;
};
cc.action.CCActionInterval.__name__ = true;
cc.action.CCActionInterval.__super__ = cc.action.CCFiniteTimeAction;
cc.action.CCActionInterval.prototype = $extend(cc.action.CCFiniteTimeAction.prototype,{
	startWithTarget: function(target) {
		cc.action.CCFiniteTimeAction.prototype.startWithTarget.call(this,target);
		this._elapsed = 0;
		this._firstTick = true;
	}
	,stop: function() {
		cc.action.CCFiniteTimeAction.prototype.stop.call(this);
	}
	,update: function(time) {
		cc.action.CCFiniteTimeAction.prototype.update.call(this,time);
	}
	,step: function(dt) {
		if(this._firstTick) {
			this._firstTick = false;
			this._elapsed = 0;
		} else this._elapsed += dt;
		if(this._duration < 0.0000001192092896) this._duration = 0.0000001192092896;
		var t = this._elapsed / this._duration;
		if(1 < t) t = 1;
		if(t < 0) t = 0;
		this.update(t);
	}
	,isDone: function() {
		return this._elapsed >= this._duration;
	}
	,initWithDuration: function(d) {
		this._duration = d;
		this._elapsed = 0;
		this._firstTick = true;
		return true;
	}
	,getElapsed: function() {
		return this._elapsed;
	}
	,__class__: cc.action.CCActionInterval
});
cc.action.CCActionEase = function() {
	cc.action.CCActionInterval.call(this);
};
cc.action.CCActionEase.__name__ = true;
cc.action.CCActionEase.create = function(action) {
	var ret = new cc.action.CCActionEase();
	if(ret != null) ret.initWithAction(action);
	return ret;
}
cc.action.CCActionEase.__super__ = cc.action.CCActionInterval;
cc.action.CCActionEase.prototype = $extend(cc.action.CCActionInterval.prototype,{
	update: function(time) {
		this._other.update(time);
	}
	,stop: function() {
		this._other.stop();
		cc.action.CCActionInterval.prototype.stop.call(this);
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._other.startWithTarget(this._target);
	}
	,initWithAction: function(action) {
		cc.platform.CCCommon.assert(action != null,"");
		if(this.initWithDuration(action.getDuration())) {
			this._other = action;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCActionEase
});
cc.action.CCEaseExponentialOut = function() {
	cc.action.CCActionEase.call(this);
};
cc.action.CCEaseExponentialOut.__name__ = true;
cc.action.CCEaseExponentialOut.create = function(action) {
	var ret = new cc.action.CCEaseExponentialOut();
	if(ret != null) ret.initWithAction(action);
	return ret;
}
cc.action.CCEaseExponentialOut.__super__ = cc.action.CCActionEase;
cc.action.CCEaseExponentialOut.prototype = $extend(cc.action.CCActionEase.prototype,{
	update: function(time) {
		this._other.update(time == 1?1:-Math.pow(2,10 * time) + 1);
	}
	,__class__: cc.action.CCEaseExponentialOut
});
cc.action.CCEaseSineOut = function() {
	cc.action.CCActionEase.call(this);
};
cc.action.CCEaseSineOut.__name__ = true;
cc.action.CCEaseSineOut.create = function(action) {
	var ret = new cc.action.CCEaseSineOut();
	if(ret != null) ret.initWithAction(action);
	return ret;
}
cc.action.CCEaseSineOut.__super__ = cc.action.CCActionEase;
cc.action.CCEaseSineOut.prototype = $extend(cc.action.CCActionEase.prototype,{
	update: function(time) {
		this._other.update(Math.sin(time * Math.PI / 2));
	}
	,__class__: cc.action.CCEaseSineOut
});
cc.action.CCActionInstant = function() {
	cc.action.CCFiniteTimeAction.call(this);
};
cc.action.CCActionInstant.__name__ = true;
cc.action.CCActionInstant.__super__ = cc.action.CCFiniteTimeAction;
cc.action.CCActionInstant.prototype = $extend(cc.action.CCFiniteTimeAction.prototype,{
	update: function(time) {
	}
	,step: function(dt) {
		this.update(1);
	}
	,isDone: function() {
		return true;
	}
	,__class__: cc.action.CCActionInstant
});
cc.action.CCCallFunc = function() {
	cc.action.CCActionInstant.call(this);
};
cc.action.CCCallFunc.__name__ = true;
cc.action.CCCallFunc.create = function(selector,selectorTarget,data) {
	var ret = new cc.action.CCCallFunc();
	if(ret != null) {
		ret._callFunc = selector;
		return ret;
	}
	return null;
}
cc.action.CCCallFunc.__super__ = cc.action.CCActionInstant;
cc.action.CCCallFunc.prototype = $extend(cc.action.CCActionInstant.prototype,{
	update: function(time) {
		this.execute();
	}
	,execute: function() {
		if(this._callFunc != null) {
			this._callFunc();
			return;
		}
		if(this._callFuncWithParams != null) {
			this._callFuncWithParams(this._data);
			return;
		}
	}
	,__class__: cc.action.CCCallFunc
});
cc.action.CCSequence = function() {
	cc.action.CCActionInterval.call(this);
	this._actions = new Array();
};
cc.action.CCSequence.__name__ = true;
cc.action.CCSequence.create = function(tempArray) {
	var paraArray = tempArray;
	var prev = paraArray[0];
	var ret = null;
	var _g1 = 1, _g = paraArray.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(paraArray[i] != null) {
			prev = cc.action.CCSequence._actionOneTwo(prev,paraArray[i]);
			ret = js.Boot.__cast(prev , cc.action.CCSequence);
		}
	}
	return ret;
}
cc.action.CCSequence._actionOneTwo = function(actionOne,actionTwo) {
	var sequence = new cc.action.CCSequence();
	sequence.initOneTwo(actionOne,actionTwo);
	return sequence;
}
cc.action.CCSequence.__super__ = cc.action.CCActionInterval;
cc.action.CCSequence.prototype = $extend(cc.action.CCActionInterval.prototype,{
	update: function(time) {
		cc.action.CCActionInterval.prototype.update.call(this,time);
		var new_t = 0;
		var found = 0;
		if(time < this._split) new_t = this._split != 0?time / this._split:1; else {
			found = 1;
			new_t = this._split == 1?1:(time - this._split) / (1 - this._split);
			if(this._last == -1) {
				this._actions[0].startWithTarget(this._target);
				this._actions[0].update(1);
				this._actions[0].stop();
			}
			if(this._last == 0) {
				this._actions[0].update(1);
				this._actions[0].stop();
			}
		}
		if(this._last == found && this._actions[found].isDone()) return;
		if(this._last != found) this._actions[found].startWithTarget(this._target);
		this._actions[found].update(new_t);
		this._last = found;
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._split = this._actions[0].getDuration() / this._duration;
		this._last = -1;
	}
	,initOneTwo: function(actionOne,actionTwo) {
		var one = actionOne.getDuration();
		var two = actionTwo.getDuration();
		var d = actionOne.getDuration() + actionTwo.getDuration();
		this.initWithDuration(d);
		this._actions[0] = actionOne;
		this._actions[1] = actionTwo;
		return true;
	}
	,__class__: cc.action.CCSequence
});
cc.action.CCRepeatForever = function() {
	cc.action.CCActionInterval.call(this);
};
cc.action.CCRepeatForever.__name__ = true;
cc.action.CCRepeatForever.create = function(action) {
	var ret = new cc.action.CCRepeatForever();
	if(ret != null && ret.initWithAction(action)) return ret;
	return null;
}
cc.action.CCRepeatForever.__super__ = cc.action.CCActionInterval;
cc.action.CCRepeatForever.prototype = $extend(cc.action.CCActionInterval.prototype,{
	isDone: function() {
		return false;
	}
	,step: function(dt) {
		this._innerAction.step(dt);
		if(this._innerAction.isDone()) {
			this._innerAction.startWithTarget(this._target);
			this._innerAction.step(this._innerAction.getElapsed() - this._innerAction.getDuration());
		}
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._innerAction.startWithTarget(target);
	}
	,initWithAction: function(action) {
		this._innerAction = action;
		return true;
	}
	,__class__: cc.action.CCRepeatForever
});
cc.action.CCAnimate = function() {
	this.timer = 0;
	cc.action.CCActionInterval.call(this);
};
cc.action.CCAnimate.__name__ = true;
cc.action.CCAnimate.create = function(animation) {
	var animate = new cc.action.CCAnimate();
	animate.initWithAnimation(animation);
	return animate;
}
cc.action.CCAnimate.__super__ = cc.action.CCActionInterval;
cc.action.CCAnimate.prototype = $extend(cc.action.CCActionInterval.prototype,{
	stop: function() {
		if(this._animation.getRestoreOriginalFrame() && this._target != null) {
			var t = js.Boot.__cast(this._target , cc.spritenodes.CCSprite);
			t.setDisplayFrame(this._origFrame);
		}
		cc.action.CCActionInterval.prototype.stop.call(this);
	}
	,update: function(time) {
		if(time < 1.0) {
			time *= this._animation.getLoops();
			var loopNumber = time;
			if(loopNumber > this._excutedLoops) {
				this._nextFrame = 0;
				this._excutedLoops++;
			}
			this.timer = time % 1.0;
		}
		var frames = this._animation.getFrames();
		var numberOfFrames = frames.length;
		var _g = this._nextFrame;
		while(_g < numberOfFrames) {
			var i = _g++;
			if(this._splitTimes[i] < time) {
				var t = js.Boot.__cast(this._target , cc.spritenodes.CCSprite);
				t.setDisplayFrame(frames[i].getSpriteFrame());
				this._nextFrame = i + 1;
				break;
			}
		}
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		if(this._animation.getRestoreOriginalFrame()) {
			var t = js.Boot.__cast(target , cc.spritenodes.CCSprite);
			this._origFrame = t.displayFrame();
		}
		this._nextFrame = 0;
		this._excutedLoops = 0;
	}
	,initWithAnimation: function(animation) {
		var singleDuration = animation.getDuration();
		this.initWithDuration(singleDuration * animation.getLoops());
		this._nextFrame = 0;
		this.setAnimation(animation);
		this._origFrame = this._animation.getFrames()[0].getSpriteFrame();
		this._excutedLoops = 0;
		this._splitTimes = new Array();
		var accumUnitsOfTime = 0;
		var newwUnitOfTimeValue = singleDuration / animation.getTotalDelayUnits();
		var frames = animation.getFrames();
		var _g = 0;
		while(_g < frames.length) {
			var f = frames[_g];
			++_g;
			var frame = f;
			var value = accumUnitsOfTime * newwUnitOfTimeValue / singleDuration;
			accumUnitsOfTime += frame.getDelayUnits();
			this._splitTimes.push(value);
		}
		this._delatPerUnit = this._animation.getDelayPerUnit();
		return true;
	}
	,__class__: cc.action.CCAnimate
});
cc.action.CCRotateBy = function() {
	this._angle = 0;
	cc.action.CCActionInterval.call(this);
};
cc.action.CCRotateBy.__name__ = true;
cc.action.CCRotateBy.create = function(duration,deltaAngle) {
	var rotateBy = new cc.action.CCRotateBy();
	rotateBy.initWithDurationRotateBy(duration,deltaAngle);
	return rotateBy;
}
cc.action.CCRotateBy.__super__ = cc.action.CCActionInterval;
cc.action.CCRotateBy.prototype = $extend(cc.action.CCActionInterval.prototype,{
	startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._target.getSprite().rotation.animateBy(this._angle,this._duration,this._ease);
	}
	,initWithDurationRotateBy: function(duration,deltaAngle) {
		if(cc.action.CCActionInterval.prototype.initWithDuration.call(this,duration)) {
			this._angle = deltaAngle;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCRotateBy
});
cc.action.CCMoveTo = function() {
	this._isMoveTo = true;
	cc.action.CCActionInterval.call(this);
	this._endPosition = new flambe.math.Point(0,0);
	this._startPosition = new flambe.math.Point(0,0);
	this._delta = new flambe.math.Point(0,0);
	this._previousPosition = new flambe.math.Point(0,0);
};
cc.action.CCMoveTo.__name__ = true;
cc.action.CCMoveTo.create = function(duration,position) {
	var moveTo = new cc.action.CCMoveTo();
	moveTo.initWithDurationMoveTo(duration,position);
	return moveTo;
}
cc.action.CCMoveTo.__super__ = cc.action.CCActionInterval;
cc.action.CCMoveTo.prototype = $extend(cc.action.CCActionInterval.prototype,{
	update: function(time) {
		if(this._target != null) {
			var currentPos = this._target.getPosition();
			var diff = cc.support.CCPointExtension.pSub(currentPos,this._previousPosition);
			this._startPosition = cc.support.CCPointExtension.pAdd(this._startPosition,diff);
			var newPos = new flambe.math.Point(this._startPosition.x + this._delta.x * time,this._startPosition.y + this._delta.y * time);
			this._target.setPosition(newPos.x,newPos.y);
			this._previousPosition = newPos;
		}
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		if(this._target.getSprite() == null) return;
		this._previousPosition = this._startPosition = target.getPosition();
		this._delta = cc.support.CCPointExtension.pSub(this._endPosition,this._startPosition);
	}
	,initWithDurationMoveTo: function(duration,position) {
		if(cc.action.CCActionInterval.prototype.initWithDuration.call(this,duration)) {
			this._endPosition = position;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCMoveTo
});
cc.action.CCMoveBy = function() {
	cc.action.CCMoveTo.call(this);
};
cc.action.CCMoveBy.__name__ = true;
cc.action.CCMoveBy.create = function(duration,position) {
	var moveBy = new cc.action.CCMoveBy();
	moveBy.initWithDurationMoveBy(duration,position);
	return moveBy;
}
cc.action.CCMoveBy.__super__ = cc.action.CCMoveTo;
cc.action.CCMoveBy.prototype = $extend(cc.action.CCMoveTo.prototype,{
	startWithTarget: function(target) {
		var temp = this._delta;
		cc.action.CCMoveTo.prototype.startWithTarget.call(this,target);
		if(this._target.getSprite() == null) return;
		this._delta = temp;
	}
	,initWithDurationMoveBy: function(duration,position) {
		if(cc.action.CCMoveTo.prototype.initWithDurationMoveTo.call(this,duration,position)) {
			this._delta = position;
			this._isMoveTo = false;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCMoveBy
});
cc.action.CCScaleTo = function() {
	cc.action.CCActionInterval.call(this);
	this._scaleX = 1;
	this._scaleY = 1;
	this._startScaleX = 1;
	this._startScaleY = 1;
	this._endScaleX = 0;
	this._endScaleY = 0;
	this._deltaX = 0;
	this._deltaY = 0;
};
cc.action.CCScaleTo.__name__ = true;
cc.action.CCScaleTo.create = function(duration,sx,sy) {
	var scaleTo = new cc.action.CCScaleTo();
	if(sy == null) scaleTo.initWithDurationScaleTo(duration,sx); else scaleTo.initWithDurationScaleTo(duration,sx,sy);
	return scaleTo;
}
cc.action.CCScaleTo.__super__ = cc.action.CCActionInterval;
cc.action.CCScaleTo.prototype = $extend(cc.action.CCActionInterval.prototype,{
	update: function(time) {
		if(this._target != null) this._target.setScale(this._startScaleX + this._deltaX * time,this._startScaleY + this._deltaY * time);
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._startScaleX = target.getScaleX();
		this._startScaleY = target.getScaleY();
		this._deltaX = this._endScaleX - this._startScaleX;
		this._deltaY = this._endScaleY - this._startScaleY;
	}
	,initWithDurationScaleTo: function(duration,sx,sy) {
		if(cc.action.CCActionInterval.prototype.initWithDuration.call(this,duration)) {
			this._endScaleX = sx;
			this._endScaleY = sy != null?sy:sx;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCScaleTo
});
cc.action.CCScaleBy = function() {
	cc.action.CCScaleTo.call(this);
};
cc.action.CCScaleBy.__name__ = true;
cc.action.CCScaleBy.create = function(duration,sx,sy) {
	var scaleBy = new cc.action.CCScaleBy();
	if(sy == null) scaleBy.initWithDurationScaleTo(duration,sx); else scaleBy.initWithDurationScaleTo(duration,sx,sy);
	return scaleBy;
}
cc.action.CCScaleBy.__super__ = cc.action.CCScaleTo;
cc.action.CCScaleBy.prototype = $extend(cc.action.CCScaleTo.prototype,{
	startWithTarget: function(target) {
		cc.action.CCScaleTo.prototype.startWithTarget.call(this,target);
		this._deltaX = this._startScaleX * this._endScaleX - this._startScaleX;
		this._deltaY = this._startScaleY * this._endScaleY - this._startScaleY;
	}
	,__class__: cc.action.CCScaleBy
});
cc.action.CCBlink = function() {
	this._times = 0;
	cc.action.CCActionInterval.call(this);
};
cc.action.CCBlink.__name__ = true;
cc.action.CCBlink.create = function(duration,blinks) {
	var blink = new cc.action.CCBlink();
	blink.initWithDurationBlink(duration,blinks);
	return blink;
}
cc.action.CCBlink.__super__ = cc.action.CCActionInterval;
cc.action.CCBlink.prototype = $extend(cc.action.CCActionInterval.prototype,{
	stop: function() {
		this._target.setVisible(this._originalState);
		cc.action.CCActionInterval.prototype.stop.call(this);
	}
	,startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._originalState = target.isVisible();
	}
	,update: function(time) {
		if(this._target != null && !this.isDone()) {
			var slice = 1.0 / this._times;
			var m = time % slice;
			this._target.setVisible(m > slice / 2?true:false);
		}
	}
	,initWithDurationBlink: function(duration,blinks) {
		if(cc.action.CCActionInterval.prototype.initWithDuration.call(this,duration)) {
			this._times = blinks;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCBlink
});
cc.action.CCFadeOut = function() {
	cc.action.CCActionInterval.call(this);
};
cc.action.CCFadeOut.__name__ = true;
cc.action.CCFadeOut.create = function(d) {
	var action = new cc.action.CCFadeOut();
	action.initWithDuration(d);
	return action;
}
cc.action.CCFadeOut.__super__ = cc.action.CCActionInterval;
cc.action.CCFadeOut.prototype = $extend(cc.action.CCActionInterval.prototype,{
	update: function(time) {
		this._target.setOpacity(255 * (1 - time) | 0);
	}
	,__class__: cc.action.CCFadeOut
});
cc.action.CCFadeTo = function() {
	this._fromOpacity = 0;
	this._toOpacity = 0;
	cc.action.CCActionInterval.call(this);
};
cc.action.CCFadeTo.__name__ = true;
cc.action.CCFadeTo.create = function(duration,opacity) {
	var fadeTo = new cc.action.CCFadeTo();
	fadeTo.initWithDurationFadeTo(duration,opacity);
	return fadeTo;
}
cc.action.CCFadeTo.__super__ = cc.action.CCActionInterval;
cc.action.CCFadeTo.prototype = $extend(cc.action.CCActionInterval.prototype,{
	startWithTarget: function(target) {
		cc.action.CCActionInterval.prototype.startWithTarget.call(this,target);
		this._fromOpacity = target.getOpacity();
	}
	,update: function(time) {
		if(this._target != null) this._target.setOpacity(this._fromOpacity + (this._toOpacity - this._fromOpacity) * time | 0);
	}
	,initWithDurationFadeTo: function(duration,opacity) {
		if(cc.action.CCActionInterval.prototype.initWithDuration.call(this,duration)) {
			this._toOpacity = opacity;
			return true;
		}
		return false;
	}
	,__class__: cc.action.CCFadeTo
});
cc.action.CCDelayTime = function() {
	cc.action.CCActionInterval.call(this);
};
cc.action.CCDelayTime.__name__ = true;
cc.action.CCDelayTime.create = function(duration) {
	var action = new cc.action.CCDelayTime();
	action.initWithDuration(duration);
	return action;
}
cc.action.CCDelayTime.__super__ = cc.action.CCActionInterval;
cc.action.CCDelayTime.prototype = $extend(cc.action.CCActionInterval.prototype,{
	update: function(time) {
	}
	,__class__: cc.action.CCDelayTime
});
cc.action.CCActionManager = function() {
	this._targets = new Array();
};
cc.action.CCActionManager.__name__ = true;
cc.action.CCActionManager.prototype = {
	__class__: cc.action.CCActionManager
}
cc.action.MapElement = function() { }
cc.action.MapElement.__name__ = true;
cc.basenodes = {}
cc.basenodes.CCNode = function() {
	this._hasSetPosition = false;
	this.isOriginTopLeft = true;
	this._initializedNode = false;
	this._ignoreAnchorPointForPosition = false;
	this._running = false;
	this._visible = true;
	this._scaleY = 1;
	this._scaleX = 1;
	this._rotation = 0;
	this._zOrder = 0;
	this.init();
};
cc.basenodes.CCNode.__name__ = true;
cc.basenodes.CCNode.prototype = {
	getSprite: function() {
		return this.sprite;
	}
	,getEntity: function() {
		return this.entity;
	}
	,unscheduleAllCallbacks: function() {
		this.cbUpdate = [];
	}
	,schedule: function(callback_fn,interval,repeat,delay) {
		this.cbUpdate.push(new cc.basenodes.CbClass(callback_fn,interval));
	}
	,update: function(dt) {
		var _g = 0, _g1 = this.cbUpdate;
		while(_g < _g1.length) {
			var c = _g1[_g];
			++_g;
			if(c.curTimer <= 0) {
				c.fun();
				c.curTimer = c.interval;
			}
			c.curTimer -= dt;
		}
		var temp = new Array();
		var _g = 0, _g1 = this.actions;
		while(_g < _g1.length) {
			var a = _g1[_g];
			++_g;
			if(a != null) a.step(dt);
			if(a.isDone()) temp.push(a);
		}
		if(temp != null) {
			var _g = 0;
			while(_g < temp.length) {
				var t = temp[_g];
				++_g;
				HxOverrides.remove(this.actions,t);
			}
		}
	}
	,getOpacity: function() {
		return 0;
	}
	,setOpacity: function(o) {
	}
	,getActionByTag: function(tag) {
		var _g = 0, _g1 = this.actions;
		while(_g < _g1.length) {
			var a = _g1[_g];
			++_g;
			if(a.getTag() == tag) return a;
		}
		return null;
	}
	,stopActionByTag: function(tag) {
		var tmp = cc.action.CCAction.create();
		var _g = 0, _g1 = this.actions;
		while(_g < _g1.length) {
			var a = _g1[_g];
			++_g;
			if(a.getTag() == tag) {
				tmp = a;
				break;
			}
		}
		HxOverrides.remove(this.actions,tmp);
	}
	,stopAction: function(action) {
		HxOverrides.remove(this.actions,action);
	}
	,runAction: function(action) {
		var _g = 0, _g1 = this.actions;
		while(_g < _g1.length) {
			var a = _g1[_g];
			++_g;
			if(a == action) return this.action;
		}
		this.actions.push(action);
		action.startWithTarget(this);
		return action;
	}
	,onExit: function() {
		this._running = false;
		if(this._children != null) {
			var _g = 0, _g1 = this._children;
			while(_g < _g1.length) {
				var c = _g1[_g];
				++_g;
				c.onExit();
			}
		}
	}
	,onEnter: function() {
		this._running = true;
	}
	,_detachChild: function(child,doCleanup) {
		HxOverrides.remove(this._children,child);
		this.entity.removeChild(child.getEntity());
		child.onExit();
		child._parent = null;
		if(doCleanup) child.cleanup();
	}
	,removeChild: function(child,cleanup) {
		if(cleanup == null) cleanup = true;
		if(this._children == null) return;
		this._detachChild(child,cleanup);
	}
	,removeFromParentAndCleanup: function() {
		this.removeFromParent(true);
	}
	,removeFromParent: function(cleanup) {
		if(this._parent != null) this._parent.removeChild(this,cleanup);
	}
	,addChild: function(child,zOrder,tag) {
		if(child == this) return;
		cc.platform.CCCommon.assert(child != null,"Argument must be non-nil");
		if(child._parent != null) {
			cc.platform.CCCommon.assert(child._parent == null,"child already added. It can't be added again");
			return;
		}
		var tempTag = 0;
		if(tag == null) tag = child.getTag(); else tempTag = tag;
		child._tag = tempTag;
		child.setParent(this);
		this.entity.addChild(child.entity,true,zOrder);
		child._zOrder = zOrder;
		this._children.push(child);
	}
	,cleanup: function() {
		this.unscheduleAllCallbacks();
		this.entity.dispose();
	}
	,getTag: function() {
		return this._tag;
	}
	,isIgnoreAnchorPointForPosition: function() {
		return this._ignoreAnchorPointForPosition;
	}
	,setParent: function(v) {
		this._parent = v;
	}
	,getParent: function() {
		return this._parent;
	}
	,setContentSize: function(size) {
		this._contentSize = new cc.cocoa.CCSize(size.width,size.height);
	}
	,getContentSize: function() {
		return this._contentSize;
	}
	,setCenterAnchor: function() {
		this.setAnchorPoint(new flambe.math.Point(0.5,0.5));
	}
	,setAnchorPoint: function(point) {
		if(this.isIgnoreAnchorPointForPosition()) return;
		this._anchorPoint = new flambe.math.Point(point.x,point.y);
		var width = this.sprite.getNaturalWidth();
		var height = this.sprite.getNaturalHeight();
		if(this.isOriginTopLeft) this.sprite.setAnchor(this._anchorPoint.x * width,this._anchorPoint.y * height); else this.sprite.setAnchor(this._anchorPoint.x * width,(1 - this._anchorPoint.y) * height);
	}
	,getAnchorPoint: function() {
		return new flambe.math.Point(this._anchorPoint.x,this._anchorPoint.y);
	}
	,setVisible: function(v) {
		this._visible = v;
		this.sprite.set_visible(v);
	}
	,isVisible: function() {
		return this._visible;
	}
	,getChildren: function() {
		if(this._children == null) this._children = new Array();
		return this._children;
	}
	,getPosition: function() {
		return new flambe.math.Point(this._position.x,this._position.y);
	}
	,setPosition: function(xValue,yValue) {
		this._position = new flambe.math.Point(xValue,yValue);
		this.sprite.x.set__(this._position.x);
		this.sprite.y.set__(this._position.y);
		this._hasSetPosition = true;
	}
	,getScaleY: function() {
		return this._scaleY;
	}
	,getScaleX: function() {
		return this._scaleX;
	}
	,setScale: function(scale,scaleY) {
		this._scaleX = scale;
		if(scaleY == null) {
			this._scaleY = scale;
			this.sprite.setScale(scale);
		} else {
			this._scaleY = scaleY;
			this.sprite.setScaleXY(this._scaleX,this._scaleY);
		}
	}
	,getScale: function() {
		cc.platform.CCCommon.assert(this._scaleX == this._scaleY,"cc.Node#scale. ScaleX != ScaleY. Don't know which one to return");
		return this._scaleX;
	}
	,setRotation: function(newRotation) {
		if(this._rotation == newRotation) return;
		this._rotation = newRotation;
		if(this.sprite != null) this.sprite.rotation.set__(this._rotation);
	}
	,init: function() {
		if(this._initializedNode == false) this._initNode();
		return true;
	}
	,_initNode: function() {
		if(cc.platform.CCConfig.NODE_TRANSFORM_USING_AFFINE_MATRIX == 1) this._transformGLDirty = true;
		this._position = new flambe.math.Point(0,0);
		this._anchorPoint = new flambe.math.Point(0,0);
		this._anchorPointInPoints = new flambe.math.Point(0,0);
		this._contentSize = new cc.cocoa.CCSize();
		var director = cc.CCDirector.getInstance();
		this._initializedNode = true;
		this._scaleX = 1;
		this._scaleY = 1;
		this._children = new Array();
		this._contentSize = new cc.cocoa.CCSize(director.getWinSize().width,director.getWinSize().height);
		this.entity = new flambe.Entity();
		this.sprite = new flambe.display.Sprite();
		this.cbUpdate = new Array();
		this.actions = new Array();
	}
	,__class__: cc.basenodes.CCNode
}
cc.basenodes.CbClass = function(fn,interval) {
	this.fun = fn;
	this.interval = interval;
	this.curTimer = 0;
};
cc.basenodes.CbClass.__name__ = true;
cc.basenodes.CbClass.prototype = {
	__class__: cc.basenodes.CbClass
}
cc.cocoa = {}
cc.cocoa.CCGeometry = function() { }
cc.cocoa.CCGeometry.__name__ = true;
cc.cocoa.CCGeometry.p = function(x,y) {
	return new flambe.math.Point(x,y);
}
cc.cocoa.CCGeometry.sizeZero = function() {
	return new cc.cocoa.CCSize(0,0);
}
cc.cocoa.CCGeometry.rectZero = function() {
	return new flambe.math.Rectangle(0,0,0,0);
}
cc.cocoa.CCGeometry.rectGetMaxX = function(rect) {
	return rect.x + rect.width;
}
cc.cocoa.CCGeometry.rectGetMinX = function(rect) {
	return rect.x;
}
cc.cocoa.CCGeometry.rectGetMaxY = function(rect) {
	return rect.y + rect.height;
}
cc.cocoa.CCGeometry.rectGetMinY = function(rect) {
	return rect.y;
}
cc.cocoa.CCGeometry.rectIntersectsRect = function(rectA,rectB) {
	return !(cc.cocoa.CCGeometry.rectGetMaxX(rectA) < cc.cocoa.CCGeometry.rectGetMinX(rectB) || cc.cocoa.CCGeometry.rectGetMaxX(rectB) < cc.cocoa.CCGeometry.rectGetMinX(rectA) || cc.cocoa.CCGeometry.rectGetMaxY(rectA) < cc.cocoa.CCGeometry.rectGetMinY(rectB) || cc.cocoa.CCGeometry.rectGetMaxY(rectB) < cc.cocoa.CCGeometry.rectGetMinY(rectA));
}
cc.cocoa.CCSize = function(width,height) {
	if(height == null) height = 0;
	if(width == null) width = 0;
	this.width = width;
	this.height = height;
};
cc.cocoa.CCSize.__name__ = true;
cc.cocoa.CCSize.prototype = {
	__class__: cc.cocoa.CCSize
}
cc.denshion = {}
cc.denshion.CCAudioEngine = function() {
	this._pack = cc.CCLoader.pack;
	this.set__effectVolume(1);
	this.set__musicVolume(1);
	this._effectList = new haxe.ds.StringMap();
	this._musicList = new haxe.ds.StringMap();
};
cc.denshion.CCAudioEngine.__name__ = true;
cc.denshion.CCAudioEngine.getInstance = function() {
	if(cc.denshion.CCAudioEngine._instance == null) {
		cc.denshion.CCAudioEngine._instance = new cc.denshion.CCAudioEngine();
		cc.denshion.CCAudioEngine._instance.init();
	}
	return cc.denshion.CCAudioEngine._instance;
}
cc.denshion.CCAudioEngine.prototype = {
	set__musicVolume: function(volume) {
		if(volume <= 0) volume = 0; else if(volume > 1) volume = 1;
		return this._musicVolume = volume;
	}
	,set__effectVolume: function(volume) {
		if(volume <= 0) volume = 0; else if(volume > 1) volume = 1;
		return this._effectVolume = volume;
	}
	,playMusic: function(path,loop) {
		if(loop == null) loop = false;
		var music = this._pack.getSound(path);
		if(this._playingMusic != null) {
			this._playingMusic.set_paused(true);
			this._playingMusic.dispose();
		}
		this._cacheMusic = music;
		if(loop) this._playingMusic = music.loop(this.get__musicVolume()); else this._playingMusic = music.play(this.get__musicVolume());
		this._isMusicLoop = loop;
		this._isMusicPlaying = true;
	}
	,playEffect: function(path,loop) {
		if(loop == null) loop = false;
		var sound = this._pack.getSound(path);
		if(this._effectList.exists(path)) {
			var tempPlayback = this._effectList.get(path);
			tempPlayback.dispose();
		}
		if(loop) this._effectList.set(path,sound.loop(this.get__effectVolume())); else this._effectList.set(path,sound.play(this.get__effectVolume()));
	}
	,init: function() {
	}
	,get__musicVolume: function() {
		return this._musicVolume;
	}
	,get__effectVolume: function() {
		return this._effectVolume;
	}
	,__class__: cc.denshion.CCAudioEngine
}
cc.keyboarddispatcher = {}
cc.keyboarddispatcher.CCKeyboardDelegate = function() { }
cc.keyboarddispatcher.CCKeyboardDelegate.__name__ = true;
cc.keyboarddispatcher.CCKeyboardDelegate.prototype = {
	__class__: cc.keyboarddispatcher.CCKeyboardDelegate
}
cc.keyboarddispatcher.CCKeyboardHandler = function() {
};
cc.keyboarddispatcher.CCKeyboardHandler.__name__ = true;
cc.keyboarddispatcher.CCKeyboardHandler.create = function(delegate) {
	var handler = new cc.keyboarddispatcher.CCKeyboardHandler();
	handler.initWithDelegate(delegate);
	return handler;
}
cc.keyboarddispatcher.CCKeyboardHandler.prototype = {
	initWithDelegate: function(delegate) {
		cc.platform.CCCommon.assert(delegate != null,"It's a wrong delegate!");
		this._delegate = delegate;
		return true;
	}
	,getDelegate: function() {
		return this._delegate;
	}
	,__class__: cc.keyboarddispatcher.CCKeyboardHandler
}
cc.keyboarddispatcher.CCKeyboardDispatcher = function() {
	this._toRemove = false;
	this._toAdd = false;
	this._locked = false;
	this._handlersToAdd = new Array();
	this._handlersToRemove = new Array();
	this._delegates = new Array();
};
cc.keyboarddispatcher.CCKeyboardDispatcher.__name__ = true;
cc.keyboarddispatcher.CCKeyboardDispatcher.getInstance = function() {
	if(cc.keyboarddispatcher.CCKeyboardDispatcher.keyboardDispatcher == null) {
		cc.keyboarddispatcher.CCKeyboardDispatcher.keyboardDispatcher = new cc.keyboarddispatcher.CCKeyboardDispatcher();
		flambe.System._platform.getKeyboard().up.connect(function(event) {
			cc.keyboarddispatcher.CCKeyboardDispatcher.keyboardDispatcher.displatchKeyboardMSG(event,false);
		});
		flambe.System._platform.getKeyboard().down.connect(function(event) {
			cc.keyboarddispatcher.CCKeyboardDispatcher.keyboardDispatcher.displatchKeyboardMSG(event,true);
		});
	}
	return cc.keyboarddispatcher.CCKeyboardDispatcher.keyboardDispatcher;
}
cc.keyboarddispatcher.CCKeyboardDispatcher.prototype = {
	displatchKeyboardMSG: function(event,keydown) {
		this._locked = true;
		var i = 0;
		if(keydown && event != null) {
			var _g = 0, _g1 = this._delegates;
			while(_g < _g1.length) {
				var d = _g1[_g];
				++_g;
				d.getDelegate().onKeyDown(event);
			}
		} else if(!keydown && event != null) {
			var _g = 0, _g1 = this._delegates;
			while(_g < _g1.length) {
				var d = _g1[_g];
				++_g;
				d.getDelegate().onKeyUp(event);
			}
		}
		this._locked = false;
		if(this._toRemove) {
			this._toRemove = false;
			var _g = 0, _g1 = this._handlersToRemove;
			while(_g < _g1.length) {
				var h = _g1[_g];
				++_g;
				this.forceRemoveDelegate(h);
			}
			this._handlersToRemove = [];
		}
		if(this._toAdd) {
			this._toAdd = false;
			var _g = 0, _g1 = this._handlersToAdd;
			while(_g < _g1.length) {
				var h = _g1[_g];
				++_g;
				this.forceAddDelegate(h);
			}
			this._handlersToAdd = [];
		}
		return true;
	}
	,forceRemoveDelegate: function(delegate) {
		var remove = null;
		var _g = 0, _g1 = this._delegates;
		while(_g < _g1.length) {
			var d = _g1[_g];
			++_g;
			if(d.getDelegate() == delegate) {
				remove = d;
				break;
			}
		}
		if(remove != null) HxOverrides.remove(this._delegates,remove);
	}
	,forceAddDelegate: function(delegate) {
		var handler = cc.keyboarddispatcher.CCKeyboardHandler.create(delegate);
		if(handler != null) {
			var _g = 0, _g1 = this._delegates;
			while(_g < _g1.length) {
				var d = _g1[_g];
				++_g;
				if(d.getDelegate() == handler.getDelegate()) return;
			}
			this._delegates.push(handler);
		}
	}
	,__class__: cc.keyboarddispatcher.CCKeyboardDispatcher
}
cc.labelnodes = {}
cc.labelnodes.CCLabelBMFont = function() {
	this._initialString = "";
	this._string = "";
	cc.basenodes.CCNode.call(this);
	this._imageOffset = new flambe.math.Point(0,0);
};
cc.labelnodes.CCLabelBMFont.__name__ = true;
cc.labelnodes.CCLabelBMFont.create = function(str,fntFile,width,alignment,imageOffset) {
	var ret = new cc.labelnodes.CCLabelBMFont();
	if(str == null && fntFile == null && width == null && alignment == null && imageOffset == null) {
		if(ret != null) return ret;
		return null;
	}
	if(imageOffset == null) imageOffset = new flambe.math.Point(0,0);
	ret.initWithString(str,fntFile,width,alignment,imageOffset);
	return ret;
}
cc.labelnodes.CCLabelBMFont.__super__ = cc.basenodes.CCNode;
cc.labelnodes.CCLabelBMFont.prototype = $extend(cc.basenodes.CCNode.prototype,{
	setString: function(newString,fromUpdate) {
		if(fromUpdate == null) fromUpdate = false;
		if(this._string != newString) {
			this._string = newString;
			this._initialString = newString;
			this.updateString(fromUpdate);
		}
	}
	,updateString: function(fromUpdate) {
		if(!fromUpdate) {
			this._spriteText.set_text(this._string);
			this._contentSize.width = this._spriteText.getNaturalWidth();
			this._contentSize.height = this._spriteText.getNaturalHeight();
			this.setAnchorPoint(this._anchorPoint);
		}
	}
	,getAlign: function(a) {
		var ret = flambe.display.TextAlign.Left;
		switch(a) {
		case 0:
			ret = flambe.display.TextAlign.Left;
			break;
		case 1:
			ret = flambe.display.TextAlign.Center;
			break;
		case 2:
			ret = flambe.display.TextAlign.Right;
			break;
		}
		return ret;
	}
	,initWithString: function(str,fntFile,width,alignment,imageOffset) {
		if(imageOffset == null) imageOffset = new flambe.math.Point(0,0);
		var theString = str;
		this._initialString = str;
		if(fntFile != null) {
			this._font = new flambe.display.Font(cc.CCLoader.pack,fntFile);
			this.sprite = new flambe.display.TextSprite(this._font,theString);
			this._spriteText = js.Boot.__cast(this.sprite , flambe.display.TextSprite);
			if(alignment != null) this._spriteText.set_align(this.getAlign(alignment));
			if(width != null) this._spriteText.wrapWidth.set__(width);
			this._contentSize.width = this.sprite.getNaturalWidth();
			this._contentSize.height = this.sprite.getNaturalHeight();
		}
		this._imageOffset = imageOffset;
		this.component = new cc.CCComponent(this);
		this.entity.add(this.sprite);
		this.entity.add(this.component);
		return true;
	}
	,setOpacity: function(v) {
		this._opacity = v;
		this.sprite.alpha.set__(this._opacity / 255.0);
		if(this._children != null) {
			var _g1 = 0, _g = this._children.length;
			while(_g1 < _g) {
				var i = _g1++;
				var node = js.Boot.__cast(this._children[i] , cc.labelnodes.CCLabelBMFont);
				if(node != null) node.setOpacity(this._opacity);
			}
		}
	}
	,getOpacity: function() {
		return this._opacity;
	}
	,__class__: cc.labelnodes.CCLabelBMFont
});
cc.touchdispatcher = {}
cc.touchdispatcher.CCPointerEventDelegate = function() { }
cc.touchdispatcher.CCPointerEventDelegate.__name__ = true;
cc.touchdispatcher.CCPointerEventDelegate.prototype = {
	__class__: cc.touchdispatcher.CCPointerEventDelegate
}
cc.layersscenestransitionsnodes = {}
cc.layersscenestransitionsnodes.CCLayer = function() {
	this._pointerPriority = 0;
	this._isPointerEnabled = false;
	cc.basenodes.CCNode.call(this);
};
cc.layersscenestransitionsnodes.CCLayer.__name__ = true;
cc.layersscenestransitionsnodes.CCLayer.__interfaces__ = [cc.keyboarddispatcher.CCKeyboardDelegate,cc.touchdispatcher.CCPointerEventDelegate];
cc.layersscenestransitionsnodes.CCLayer.__super__ = cc.basenodes.CCNode;
cc.layersscenestransitionsnodes.CCLayer.prototype = $extend(cc.basenodes.CCNode.prototype,{
	onKeyUp: function(event) {
	}
	,onKeyDown: function(event) {
	}
	,onPointerUp: function(event) {
		return false;
	}
	,onPointerMoved: function(event) {
		return false;
	}
	,onPointerDragged: function(event) {
		return false;
	}
	,onPointerDown: function(event) {
		return false;
	}
	,onExit: function() {
		var director = cc.CCDirector.getInstance();
		if(this._isPointerEnabled) {
		}
		director.getPointerDispatcher().removePointerDelegate(this);
		cc.basenodes.CCNode.prototype.onExit.call(this);
	}
	,onEnter: function() {
		var director = cc.CCDirector.getInstance();
		if(this._isPointerEnabled = true) this.registerWithTouchDispatcher();
		cc.basenodes.CCNode.prototype.onEnter.call(this);
	}
	,registerWithTouchDispatcher: function() {
		cc.CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this,this._pointerPriority);
	}
	,init: function() {
		cc.basenodes.CCNode.prototype.init.call(this);
		this._initLayer();
		return true;
	}
	,addComponent: function() {
		if(this.component == null) {
			this.component = new cc.CCComponent(this);
			this.entity.add(this.component);
			if(!(this.entity._compMap.Sprite_2 != null)) this.entity.add(this.sprite);
		}
	}
	,_initLayer: function() {
		this.setAnchorPoint(new flambe.math.Point(0,0));
		this._ignoreAnchorPointForPosition = true;
		var director = cc.CCDirector.getInstance();
		this.setContentSize(director.getWinSize());
		this._isPointerEnabled = false;
		this._pointerPriority = 0;
		this.addComponent();
	}
	,__class__: cc.layersscenestransitionsnodes.CCLayer
});
cc.layersscenestransitionsnodes.CCScene = function() {
	cc.basenodes.CCNode.call(this);
};
cc.layersscenestransitionsnodes.CCScene.__name__ = true;
cc.layersscenestransitionsnodes.CCScene.create = function() {
	return new cc.layersscenestransitionsnodes.CCScene();
}
cc.layersscenestransitionsnodes.CCScene.__super__ = cc.basenodes.CCNode;
cc.layersscenestransitionsnodes.CCScene.prototype = $extend(cc.basenodes.CCNode.prototype,{
	init: function() {
		cc.basenodes.CCNode.prototype.init.call(this);
		this.setAnchorPoint(new flambe.math.Point(0,0));
		this.setContentSize(cc.CCDirector.getInstance().getWinSize());
		return true;
	}
	,__class__: cc.layersscenestransitionsnodes.CCScene
});
cc.layersscenestransitionsnodes.CCTransitionScene = function() {
	cc.layersscenestransitionsnodes.CCScene.call(this);
};
cc.layersscenestransitionsnodes.CCTransitionScene.__name__ = true;
cc.layersscenestransitionsnodes.CCTransitionScene.create = function(t,scene) {
	var ret = new cc.layersscenestransitionsnodes.CCTransitionScene();
	if(ret != null && ret.initWithDuration(t,scene)) return ret;
	return null;
}
cc.layersscenestransitionsnodes.CCTransitionScene.__super__ = cc.layersscenestransitionsnodes.CCScene;
cc.layersscenestransitionsnodes.CCTransitionScene.prototype = $extend(cc.layersscenestransitionsnodes.CCScene.prototype,{
	getInScene: function() {
		return this._inScene;
	}
	,initWithDuration: function(t,scene) {
		if(this.init()) {
			this._duration = t;
			this.setPosition(0,0);
			this._inScene = scene;
			return true;
		} else return false;
	}
	,__class__: cc.layersscenestransitionsnodes.CCTransitionScene
});
cc.layersscenestransitionsnodes.CCTransitionFade = function() {
	cc.layersscenestransitionsnodes.CCTransitionScene.call(this);
};
cc.layersscenestransitionsnodes.CCTransitionFade.__name__ = true;
cc.layersscenestransitionsnodes.CCTransitionFade.create = function(t,scene,color) {
	var ret = new cc.layersscenestransitionsnodes.CCTransitionFade();
	ret.initWithDuration(t,scene);
	return ret;
}
cc.layersscenestransitionsnodes.CCTransitionFade.__super__ = cc.layersscenestransitionsnodes.CCTransitionScene;
cc.layersscenestransitionsnodes.CCTransitionFade.prototype = $extend(cc.layersscenestransitionsnodes.CCTransitionScene.prototype,{
	initWithDuration: function(t,scene) {
		cc.layersscenestransitionsnodes.CCTransitionScene.prototype.initWithDuration.call(this,t,scene);
		this.transition = new flambe.scene.FadeTransition(t);
		return true;
	}
	,__class__: cc.layersscenestransitionsnodes.CCTransitionFade
});
cc.menunodes = {}
cc.menunodes.CCMenu = function() {
	this._enabled = false;
	this._state = -1;
	cc.layersscenestransitionsnodes.CCLayer.call(this);
	this.setContentSize(new cc.cocoa.CCSize(0,0));
};
cc.menunodes.CCMenu.__name__ = true;
cc.menunodes.CCMenu.create = function(args) {
	var ret = new cc.menunodes.CCMenu();
	if(args == null) {
		ret.initWithItems(null);
		return ret;
	}
	if(args.length == 0) ret.initWithItems(null);
	ret.initWithArray(args);
	return ret;
}
cc.menunodes.CCMenu.__super__ = cc.layersscenestransitionsnodes.CCLayer;
cc.menunodes.CCMenu.prototype = $extend(cc.layersscenestransitionsnodes.CCLayer.prototype,{
	_itemForTouch: function(touch) {
		var touchLocation = touch.getLocation();
		if(this._children != null && this._children.length > 0) {
			var _g1 = 0, _g = this._children.length;
			while(_g1 < _g) {
				var i = _g1++;
				var child = js.Boot.__cast(this._children[i] , cc.menunodes.CCMenuItem);
				if(child.isVisible() && child.isEnabled()) {
					var r = child.rect();
					var temp = null;
					var isContain = false;
					var tempNode = child.getCurrentNode();
					if(tempNode != null) isContain = tempNode.getSprite().contains(touch.getLocation().x,touch.getLocation().y);
					if(isContain) return child;
				}
			}
		}
		return null;
	}
	,onExit: function() {
		if(this._state == cc.menunodes.CCMenu.MENU_STATE_TRACKING_TOUCH) {
			this._selectedItem.unselected();
			this._state = cc.menunodes.CCMenu.MENU_STATE_WAITING;
			this._selectedItem = null;
		}
		cc.layersscenestransitionsnodes.CCLayer.prototype.onExit.call(this);
	}
	,onPointerMoved: function(event) {
		return true;
	}
	,onPointerDragged: function(event) {
		if(!this._enabled) return true;
		var currentItem = this._itemForTouch(event);
		if(currentItem != this._selectedItem) {
			if(this._selectedItem != null) this._selectedItem.unselected();
			this._selectedItem = currentItem;
			if(this._selectedItem != null) this._selectedItem.selected();
		}
		return true;
	}
	,onPointerUp: function(event) {
		if(!this._enabled) return true;
		if(this._selectedItem != null) {
			this._selectedItem.unselected();
			this._selectedItem.activate();
		}
		this._state = cc.menunodes.CCMenu.MENU_STATE_WAITING;
		return true;
	}
	,onPointerDown: function(event) {
		if(this._state != cc.menunodes.CCMenu.MENU_STATE_WAITING || !this._visible || !this._enabled) return true;
		var c = this._parent;
		while(c != null) {
			if(!c.isVisible()) return false;
			c = c.getParent();
		}
		this._selectedItem = this._itemForTouch(event);
		if(this._selectedItem == null) {
		}
		if(this._selectedItem != null) {
			this._state = cc.menunodes.CCMenu.MENU_STATE_TRACKING_TOUCH;
			this._selectedItem.selected();
			return true;
		}
		return false;
	}
	,registerWithTouchDispatcher: function() {
		cc.CCDirector.getInstance().getPointerDispatcher().addPointerDelegate(this,cc.menunodes.CCMenu.MENU_HANDLER_PRIORITY);
	}
	,alignVerticallyWithPadding: function(padding) {
		var height = padding;
		if(this._children != null && this._children.length > 0) {
			var _g1 = 0, _g = this._children.length;
			while(_g1 < _g) {
				var i = _g1++;
				this._children[i].setPosition(0,height);
				height += this._children[i].getContentSize().height * this._children[i].getScaleY() + padding;
			}
		}
	}
	,addChild: function(child,zOrder,tag) {
		cc.platform.CCCommon.assert(js.Boot.__instanceof(child,cc.menunodes.CCMenuItem),"Menu only supports MenuItem objects as children");
		cc.layersscenestransitionsnodes.CCLayer.prototype.addChild.call(this,child,zOrder,tag);
	}
	,initWithArray: function(arrayOfItems) {
		this._enabled = true;
		var winSize = cc.CCDirector.getInstance().getWinSize();
		if(arrayOfItems != null) {
			var _g1 = 0, _g = arrayOfItems.length;
			while(_g1 < _g) {
				var i = _g1++;
				this.addChild(arrayOfItems[i],i);
				arrayOfItems[i].setPosition(0,0);
			}
		}
		this._selectedItem = null;
		this._state = cc.menunodes.CCMenu.MENU_STATE_WAITING;
		return true;
		return false;
	}
	,initWithItems: function(args) {
		var pArray = new Array();
		if(args != null) {
			var _g1 = 0, _g = args.length;
			while(_g1 < _g) {
				var i = _g1++;
				pArray.push(args[i]);
			}
		}
		return this.initWithArray(pArray);
	}
	,__class__: cc.menunodes.CCMenu
});
cc.menunodes.CCMenuItem = function() {
	this._isEnabled = false;
	this._isSelected = false;
	cc.basenodes.CCNode.call(this);
	this.sprite = new flambe.display.Sprite();
	this.entity.add(this.sprite);
	this.component = new cc.CCComponent(this);
	this.entity.add(this.component);
};
cc.menunodes.CCMenuItem.__name__ = true;
cc.menunodes.CCMenuItem.__super__ = cc.basenodes.CCNode;
cc.menunodes.CCMenuItem.prototype = $extend(cc.basenodes.CCNode.prototype,{
	getCurrentNode: function() {
		return null;
	}
	,activate: function() {
		if(this._isEnabled && this._selector != null) this._selector.apply(this._listener,[]);
	}
	,unselected: function() {
		this._isSelected = false;
	}
	,selected: function() {
		this._isSelected = true;
	}
	,rect: function() {
		var locPosition = this._position;
		var locContentSize = this._contentSize;
		var locAnchorPoint = this._anchorPoint;
		var ret = new flambe.math.Rectangle(locPosition.x,locPosition.y,locContentSize.width,locContentSize.height);
		return ret;
	}
	,initWithCallback: function(selector,rec) {
		this._listener = rec;
		this._selector = selector;
		this._isEnabled = true;
		this._isSelected = false;
		return true;
	}
	,isEnabled: function() {
		return this._isEnabled;
	}
	,__class__: cc.menunodes.CCMenuItem
});
cc.menunodes.CCMenuItemLabel = function() {
	this._originalScale = 0;
	cc.menunodes.CCMenuItem.call(this);
};
cc.menunodes.CCMenuItemLabel.__name__ = true;
cc.menunodes.CCMenuItemLabel.create = function(label,selector,target) {
	var ret = new cc.menunodes.CCMenuItemLabel();
	ret.initWithLabel(label,selector,target);
	return ret;
}
cc.menunodes.CCMenuItemLabel.__super__ = cc.menunodes.CCMenuItem;
cc.menunodes.CCMenuItemLabel.prototype = $extend(cc.menunodes.CCMenuItem.prototype,{
	getCurrentNode: function() {
		return this._label;
	}
	,unselected: function() {
		if(this._isEnabled) {
			cc.menunodes.CCMenuItem.prototype.unselected.call(this);
			this.stopActionByTag(cc.menunodes.CCMenuItem.ZOOM_ACTION_TAG);
			var zoomAction = cc.action.CCScaleTo.create(0.1,this._originalScale);
			zoomAction.setTag(cc.menunodes.CCMenuItem.ZOOM_ACTION_TAG);
			this.runAction(zoomAction);
		}
	}
	,selected: function() {
		if(this._isEnabled) {
			cc.menunodes.CCMenuItem.prototype.selected.call(this);
			var action = this.getActionByTag(cc.menunodes.CCMenuItem.ZOOM_ACTION_TAG);
			if(action != null) this.stopAction(action); else this._originalScale = this.getScale();
			var zoomAction = cc.action.CCScaleTo.create(0.1,this._originalScale * 1.2);
			zoomAction.setTag(cc.menunodes.CCMenuItem.ZOOM_ACTION_TAG);
			this._label.runAction(zoomAction);
		}
	}
	,activate: function() {
		if(this._isEnabled) {
			this.setScale(this._originalScale);
			cc.menunodes.CCMenuItem.prototype.activate.call(this);
		}
	}
	,initWithLabel: function(label,selector,target) {
		this.initWithCallback(selector,target);
		this._originalScale = 1;
		this.setLabel(label);
		return true;
	}
	,getOpacity: function() {
		return this._label.getOpacity();
	}
	,setOpacity: function(opacity) {
		this._label.setOpacity(opacity);
	}
	,setLabel: function(label) {
		if(label != null) {
			this.addChild(label);
			this.setContentSize(label.getContentSize());
		}
		if(this._label != null) this.removeChild(this._label,true);
		this._label = label;
	}
	,__class__: cc.menunodes.CCMenuItemLabel
});
cc.menunodes.CCMenuItemSprite = function() {
	cc.menunodes.CCMenuItem.call(this);
};
cc.menunodes.CCMenuItemSprite.__name__ = true;
cc.menunodes.CCMenuItemSprite.create = function(normalSprite,selectedSprite,three,four,five) {
	var ret = new cc.menunodes.CCMenuItemSprite();
	ret.initWithNormalSprite(normalSprite,selectedSprite,three,four,five);
	return ret;
}
cc.menunodes.CCMenuItemSprite.__super__ = cc.menunodes.CCMenuItem;
cc.menunodes.CCMenuItemSprite.prototype = $extend(cc.menunodes.CCMenuItem.prototype,{
	getCurrentNode: function() {
		return this._currentImage;
	}
	,_updateImagesVisibility: function() {
		if(this._isEnabled) {
			if(this._normalImage != null) this._normalImage.setVisible(true);
			if(this._selectedImage != null) this._selectedImage.setVisible(false);
			if(this._disabledImage != null) this._disabledImage.setVisible(false);
			this._currentImage = this._normalImage;
		} else if(this._disabledImage != null) {
			if(this._normalImage != null) this._normalImage.setVisible(false);
			if(this._selectedImage != null) this._selectedImage.setVisible(false);
			if(this._disabledImage != null) this._disabledImage.setVisible(true);
			this._currentImage = this._disabledImage;
		} else {
			if(this._normalImage != null) this._normalImage.setVisible(true);
			if(this._selectedImage != null) this._selectedImage.setVisible(false);
			if(this._disabledImage != null) this._disabledImage.setVisible(false);
			this._currentImage = this._normalImage;
		}
	}
	,setAnchorPoint: function(point) {
		cc.menunodes.CCMenuItem.prototype.setAnchorPoint.call(this,point);
		if(this._normalImage != null) this._normalImage.setAnchorPoint(point);
		if(this._disabledImage != null) this._disabledImage.setAnchorPoint(point);
		if(this._selectedImage != null) this._selectedImage.setAnchorPoint(point);
	}
	,unselected: function() {
		cc.menunodes.CCMenuItem.prototype.unselected.call(this);
		if(this._normalImage != null) {
			this._normalImage.setVisible(true);
			this._currentImage = this._normalImage;
			if(this._selectedImage != null) this._selectedImage.setVisible(false);
			if(this._disabledImage != null) this._disabledImage.setVisible(false);
		}
	}
	,selected: function() {
		cc.menunodes.CCMenuItem.prototype.selected.call(this);
		if(this._normalImage != null) {
			if(this._disabledImage != null) this._disabledImage.setVisible(false);
			if(this._selectedImage != null) {
				this._normalImage.setVisible(false);
				this._selectedImage.setVisible(true);
				this._currentImage = this._selectedImage;
			} else {
				this._normalImage.setVisible(true);
				this._currentImage = this._selectedImage;
			}
		}
	}
	,getOpacity: function() {
		return this._normalImage.getOpacity();
	}
	,setOpacity: function(opacity) {
		this._normalImage.setOpacity(opacity);
		if(this._selectedImage != null) this._selectedImage.setOpacity(opacity);
		if(this._disabledImage != null) this._disabledImage.setOpacity(opacity);
	}
	,initWithNormalSprite: function(normalSprite,selectedSprite,disabledSprite,selector,target) {
		this.initWithCallback(selector,target);
		this.setNormalImage(normalSprite);
		this.setSelectedImage(selectedSprite);
		this.setDisabledImage(disabledSprite);
		if(this._normalImage != null) this.setContentSize(this._normalImage.getContentSize());
		return true;
	}
	,setDisabledImage: function(disabledImage) {
		if(this._disabledImage == disabledImage) return;
		if(disabledImage != null) this.addChild(disabledImage,0,cc.menunodes.CCMenuItem.DISABLE_TAG);
		if(this._disabledImage != null) this.removeChild(this._disabledImage,true);
		this._disabledImage = disabledImage;
		this._disabledImage.isOriginTopLeft = this.isOriginTopLeft;
		this._disabledImage.setAnchorPoint(this.getAnchorPoint());
		this._updateImagesVisibility();
	}
	,setSelectedImage: function(selectedImage) {
		if(this._selectedImage == selectedImage) return;
		if(selectedImage != null) this.addChild(selectedImage,0,cc.menunodes.CCMenuItem.SELECTED_TAG);
		if(this._selectedImage != null) this.removeChild(this._selectedImage,true);
		this._selectedImage = selectedImage;
		this._selectedImage.isOriginTopLeft = this.isOriginTopLeft;
		this._selectedImage.setAnchorPoint(this.getAnchorPoint());
		this._updateImagesVisibility();
	}
	,setNormalImage: function(normalImage) {
		if(this._normalImage == normalImage) return;
		if(normalImage != null) this.addChild(normalImage,0,cc.menunodes.CCMenuItem.NORMAL_TAG);
		if(this._normalImage != null) this.removeChild(this._normalImage,true);
		this._normalImage = normalImage;
		this.setContentSize(this._normalImage.getContentSize());
		this._normalImage.isOriginTopLeft = this.isOriginTopLeft;
		this._normalImage.setAnchorPoint(this.getAnchorPoint());
		this._updateImagesVisibility();
	}
	,__class__: cc.menunodes.CCMenuItemSprite
});
cc.menunodes.CCMenuItemImage = function() {
	cc.menunodes.CCMenuItemSprite.call(this);
};
cc.menunodes.CCMenuItemImage.__name__ = true;
cc.menunodes.CCMenuItemImage.create = function(normalImage,selectedImage,three,four,five) {
	var ret = new cc.menunodes.CCMenuItemImage();
	if(ret.initWithNormalImage(normalImage,selectedImage,three,four,five)) return ret;
	return null;
}
cc.menunodes.CCMenuItemImage.__super__ = cc.menunodes.CCMenuItemSprite;
cc.menunodes.CCMenuItemImage.prototype = $extend(cc.menunodes.CCMenuItemSprite.prototype,{
	initWithNormalImage: function(normalImage,selectedImage,disabledImage,selector,target) {
		var normalSprite = null;
		var selectedSprite = null;
		var disabledSprite = null;
		if(normalImage != null) normalSprite = cc.spritenodes.CCSprite.create(normalImage);
		if(selectedImage != null) selectedSprite = cc.spritenodes.CCSprite.create(selectedImage);
		if(disabledImage != null) disabledSprite = cc.spritenodes.CCSprite.create(disabledImage);
		return this.initWithNormalSprite(normalSprite,selectedSprite,disabledSprite,selector,target);
	}
	,__class__: cc.menunodes.CCMenuItemImage
});
cc.platform = {}
cc.platform.CCBase64 = function() { }
cc.platform.CCBase64.__name__ = true;
cc.platform.CCBase64.decode = function(input) {
	input = StringTools.ltrim(input);
	input = StringTools.rtrim(input);
	var output = [];
	var enc1;
	var enc2;
	var enc3;
	var enc4;
	var i = 0;
	var chr1;
	var chr2;
	var chr3;
	while(i < input.length) {
		enc1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".indexOf(input.charAt(i++));
		enc2 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".indexOf(input.charAt(i++));
		enc3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".indexOf(input.charAt(i++));
		enc4 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".indexOf(input.charAt(i++));
		chr1 = enc1 << 2 | enc2 >> 4;
		chr2 = (enc2 & 15) << 4 | enc3 >> 2;
		chr3 = (enc3 & 3) << 6 | enc4;
		output.push(String.fromCharCode(chr1));
		if(enc3 != 64) output.push(String.fromCharCode(chr2));
		if(enc4 != 64) output.push(String.fromCharCode(chr3));
	}
	var o = output.join("");
	var count = 0;
	var _g = 0;
	while(_g < output.length) {
		var i1 = output[_g];
		++_g;
		var x = HxOverrides.cca(i1,0);
		if(x != 0) {
		}
		count++;
	}
	return o;
}
cc.platform.CCBase64.decodeAsArray = function(input,lineWidth,bytes) {
	if(bytes == null) bytes = 4;
	var dec = cc.platform.CCBase64.decode(input);
	var ar = [];
	var len = dec.length / bytes | 0;
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		ar[i] = 0;
		var j = bytes - 1;
		while(j >= 0) {
			var t = HxOverrides.cca(dec,i * bytes + j) << j * 8;
			ar[i] += t;
			j--;
		}
	}
	return ar;
}
cc.platform.CCBase64.decodeAsOneArray = function(input,lineWidth,bytes) {
	if(bytes == null) bytes = 4;
	var dec = cc.platform.CCBase64.decode(input);
	var ar = [];
	var len = dec.length / bytes | 0;
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		ar[i] = 0;
		var j = bytes - 1;
		while(j >= 0) {
			var t = HxOverrides.cca(dec,i * bytes + j) << j * 8;
			ar[i] += t;
			j--;
		}
	}
	return ar;
}
cc.platform.CCBase64.decodeAsArrayBytes = function($byte,lineWidth,bytes) {
	if(bytes == null) bytes = 4;
	var ar = [];
	var len = $byte.length / bytes | 0;
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		ar[i] = 0;
		var j = bytes - 1;
		while(j >= 0) {
			var t = $byte.b[i * bytes + j] << j * 8;
			ar[i] += t;
			j--;
		}
	}
	return ar;
}
cc.platform.CCBase64.unzip = function(input,lineWidth) {
	var tempString1 = cc.platform.CCBase64.decode(input);
	var arr = cc.platform.CCBase64.decodeAsOneArray(input,0,1);
	var b = haxe.io.Bytes.ofData(arr);
	var bytes = haxe.zip.InflateImpl.run(new haxe.io.BytesInput(b));
	var ret = cc.platform.CCBase64.decodeAsArrayBytes(bytes,lineWidth);
	return ret;
}
cc.platform.CCCommon = function() { }
cc.platform.CCCommon.__name__ = true;
cc.platform.CCCommon.log = function(message) {
}
cc.platform.CCCommon.assert = function(cond,message) {
	if(!cond) throw message;
}
flambe.math = {}
flambe.math.Point = function(x,y) {
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.x = x;
	this.y = y;
};
flambe.math.Point.__name__ = true;
flambe.math.Point.prototype = {
	__class__: flambe.math.Point
}
cc.platform.CCConfig = function() { }
cc.platform.CCConfig.__name__ = true;
cc.platform.CCFileUtils = function() {
	this.rootDict = new Array();
};
cc.platform.CCFileUtils.__name__ = true;
cc.platform.CCFileUtils.getInstance = function() {
	if(cc.platform.CCFileUtils.s_SharedFileUtils == null) cc.platform.CCFileUtils.s_SharedFileUtils = new cc.platform.CCFileUtils();
	return cc.platform.CCFileUtils.s_SharedFileUtils;
}
cc.platform.CCFileUtils.prototype = {
	dictionaryWithContentsOfFile: function(fileName) {
		var parser = cc.platform.CCSAXParser.getInstance();
		this.rootDict = parser.parse(fileName);
		return this.rootDict;
	}
	,__class__: cc.platform.CCFileUtils
}
cc.platform.CCGZip = function(data) {
	this.len = 0;
	this.treepos = 0;
	this.data = data;
	this.debug = false;
	this.gpflags = 0;
	this.files = 0;
	this.unzipped = [];
	this.buf32k = new Array();
	this.bIdx = 0;
	this.modeZIP = false;
	this.bytepos = 0;
	this.bb = 1;
	this.bits = 0;
	this.nameBuf = [];
	this.fileout = new Array();
	this.literalTree = new Array();
	this.literalTree[cc.platform.CCGZip.LITERALS - 1] = new cc.platform.HufNode();
	this.distanceTree = new Array();
	this.distanceTree[31] = new cc.platform.HufNode();
	this.treepos = 0;
	this.Places = null;
	this.len = 0;
	this.fpos = new Array();
	this.fpos[16] = 0;
	this.fpos[0] = 0;
	this.flens = new Array();
	this.fmax = 0;
};
cc.platform.CCGZip.__name__ = true;
cc.platform.CCGZip.gunzip = function(data) {
	var gzip = new cc.platform.CCGZip(data);
	return gzip.gunzipLocal();
}
cc.platform.CCGZip.prototype = {
	skipdir: function() {
		var tmp = [];
		var compSize, size, os, i, c;
		if((this.gpflags & 8) != 0) {
			tmp[0] = this.readByte();
			tmp[1] = this.readByte();
			tmp[2] = this.readByte();
			tmp[3] = this.readByte();
			compSize = this.readByte();
			compSize |= this.readByte() << 8;
			compSize |= this.readByte() << 16;
			compSize |= this.readByte() << 24;
			size = this.readByte();
			size |= this.readByte() << 8;
			size |= this.readByte() << 16;
			size |= this.readByte() << 24;
		}
		if(this.modeZIP) this.nextFile();
		tmp[0] = this.readByte();
		if(tmp[0] != 8) return 0;
		this.gpflags = this.readByte();
		this.readByte();
		this.readByte();
		this.readByte();
		this.readByte();
		this.readByte();
		os = this.readByte();
		if((this.gpflags & 4) != 0) {
			tmp[0] = this.readByte();
			tmp[2] = this.readByte();
			this.len = tmp[0] + 256 * tmp[1];
			var _g1 = 0, _g = this.len;
			while(_g1 < _g) {
				var i1 = _g1++;
				this.readByte();
			}
		}
		if((this.gpflags & 8) != 0) {
			i = 0;
			this.nameBuf = [];
			while((c = this.readByte()) != 0) {
				if(String.fromCharCode(c) == "7" || String.fromCharCode(c) == ":") i = 0;
				if(i < cc.platform.CCGZip.NAMEMAX - 1) this.nameBuf[i++] = String.fromCharCode(c);
			}
		}
		if((this.gpflags & 2) != 0) {
			this.readByte();
			this.readByte();
		}
		this.deflateLoop();
		size = this.readByte();
		size |= this.readByte() << 8;
		size |= this.readByte() << 16;
		size |= this.readByte() << 24;
		if(this.modeZIP) this.nextFile();
		return 0;
	}
	,nextFile: function() {
		this.outputArr = [];
		this.modeZIP = false;
		var tmp = [];
		tmp[0] = this.readByte();
		tmp[1] = this.readByte();
		if(tmp[0] == 120 && tmp[1] == 218) {
			this.deflateLoop();
			this.unzipped[this.files] = [this.outputArr.join(""),"geonext.gxt"];
			this.files++;
		}
		if(tmp[0] == 31 && tmp[1] == 139) {
			this.skipdir();
			this.unzipped[this.files] = [this.outputArr.join(""),"file"];
			this.files++;
		}
		if(tmp[0] == 80 && tmp[1] == 75) {
			this.modeZIP = true;
			tmp[2] = this.readByte();
			tmp[3] = this.readByte();
			if(tmp[2] == 3 && tmp[3] == 4) {
				tmp[0] = this.readByte();
				tmp[1] = this.readByte();
				this.gpflags = this.readByte();
				this.gpflags |= this.readByte() << 8;
				var method = this.readByte();
				method |= this.readByte() << 8;
				this.readByte();
				this.readByte();
				this.readByte();
				this.readByte();
				var compSize = this.readByte();
				compSize |= this.readByte() << 8;
				compSize |= this.readByte() << 16;
				compSize |= this.readByte() << 24;
				var size = this.readByte();
				size |= this.readByte() << 8;
				size |= this.readByte() << 16;
				size |= this.readByte() << 24;
				var filelen = this.readByte();
				filelen |= this.readByte() << 8;
				var extralen = this.readByte();
				extralen |= this.readByte() << 8;
				var i = 0;
				this.nameBuf = [];
				var c;
				while(filelen-- != 0) {
					c = this.readByte();
					if(String.fromCharCode(c) == "/" || String.fromCharCode(c) == ":") i = 0; else if(i < cc.platform.CCGZip.NAMEMAX - 1) this.nameBuf[i++] = String.fromCharCode(c);
				}
				if(this.fileout == null) this.fileout = this.nameBuf;
				i = 0;
				while(i < extralen) {
					c = this.readByte();
					i++;
				}
				if(method == 8) {
					this.deflateLoop();
					this.unzipped[this.files] = [this.outputArr.join(""),this.nameBuf.join("")];
					this.files++;
				}
				this.skipdir();
			}
		}
	}
	,deflateLoop: function() {
		var last, c, type, len = 0, i;
		do {
			last = this.readBit();
			type = this.readBits(2);
			if(type == 0) {
				var blockLen, cSum = 0;
				this.byteAlign();
				blockLen = this.readByte();
				blockLen |= this.readByte() << 8;
				cSum = this.readByte();
				cSum |= this.readByte() << 8;
				if(((blockLen ^ ~cSum) & 65535) != 0) throw "BlockLen checksum mismatch\n";
				while(blockLen-- != 0) {
					c = this.readByte();
					this.addBuffer(c);
				}
			} else if(type == 1) {
				var j;
				while(true) {
					j = cc.platform.CCGZip.bitReverse[this.readBits(7)] >> 1;
					if(j > 23) {
						j = j << 1 | this.readBit();
						if(j > 199) {
							j -= 128;
							j = j << 1 | this.readBit();
						} else {
							j -= 48;
							if(j > 143) j = j + 136;
						}
					} else j += 256;
					if(j < 256) this.addBuffer(j); else if(j == 256) break; else {
						var len1, dist;
						j -= 257;
						len1 = this.readBits(cc.platform.CCGZip.cplext[j]) + cc.platform.CCGZip.cplens[j];
						j = cc.platform.CCGZip.bitReverse[this.readBits(5)] >> 3;
						if(cc.platform.CCGZip.cpdext[j] > 8) {
							dist = this.readBits(8);
							dist |= this.readBits(cc.platform.CCGZip.cpdext[j] - 8) << 8;
						} else dist = this.readBits(cc.platform.CCGZip.cpdext[j]);
						dist += cc.platform.CCGZip.cpdist[j];
						var _g = 0;
						while(_g < len1) {
							var j1 = _g++;
							var c1 = this.buf32k[this.bIdx - dist & 32767];
							this.addBuffer(c1);
						}
					}
				}
			} else if(type == 2) {
				var j, n, literalCodes, distCodes, lenCodes;
				var ll = new Array();
				literalCodes = 257 + this.readBits(5);
				distCodes = 1 + this.readBits(5);
				lenCodes = 4 + this.readBits(4);
				var _g = 0;
				while(_g < 19) {
					var j1 = _g++;
					ll[j1] = 0;
				}
				var _g = 0;
				while(_g < lenCodes) {
					var j1 = _g++;
					ll[cc.platform.CCGZip.border[j1]] = this.readBits(3);
				}
				len = this.distanceTree.length;
				var _g = 0;
				while(_g < len) {
					var i1 = _g++;
					this.distanceTree[i1] = new cc.platform.HufNode();
				}
				if(this.createTree(this.distanceTree,19,ll,0) != 0) {
					this.flushBuffer();
					return 1;
				}
				n = literalCodes + distCodes;
				i = 0;
				var z = -1;
				while(i < n) {
					z++;
					j = this.decodeValue(this.distanceTree);
					if(j < 16) ll[i++] = j; else if(j == 16) {
						var l;
						j = 3 + this.readBits(2);
						if(i + j > n) {
							this.flushBuffer();
							return 1;
						}
						l = i != 0?ll[i - 1]:0;
						while(j-- != 0) ll[i++] = l;
					} else {
						if(j == 17) j = 3 + this.readBits(3); else j = 11 + this.readBits(7);
						if(i + j > n) {
							this.flushBuffer();
							return 1;
						}
						while(j-- != 0) ll[i++] = 0;
					}
				}
				len = this.literalTree.length;
				var _g = 0;
				while(_g < len) {
					var i1 = _g++;
					this.literalTree[i1] = new cc.platform.HufNode();
				}
				if(this.createTree(this.literalTree,literalCodes,ll,0) != 0) {
					this.flushBuffer();
					return 1;
				}
				len = this.literalTree.length;
				var _g = 0;
				while(_g < len) {
					var i1 = _g++;
					this.distanceTree[i1] = new cc.platform.HufNode();
				}
				var ll2 = new Array();
				var _g1 = literalCodes, _g = ll.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					ll2[i1 - literalCodes] = ll[i1];
				}
				if(this.createTree(this.distanceTree,distCodes,ll2,0) != 0) {
					this.flushBuffer();
					return 1;
				}
				while(true) {
					j = this.decodeValue(this.literalTree);
					if(j >= 256) {
						var len1, dist;
						j -= 256;
						if(j == 0) break;
						j--;
						len1 = this.readBits(cc.platform.CCGZip.cplext[j]) + cc.platform.CCGZip.cplens[j];
						j = this.decodeValue(this.distanceTree);
						if(cc.platform.CCGZip.cpdext[j] > 8) {
							dist = this.readBits(8);
							dist |= this.readBits(cc.platform.CCGZip.cpdext[j] - 8) << 8;
						} else dist = this.readBits(cc.platform.CCGZip.cpdext[j]);
						dist += cc.platform.CCGZip.cpdist[j];
						while(len1-- != 0) {
							var c1 = this.buf32k[this.bIdx - dist & 32767];
							this.addBuffer(c1);
						}
					} else this.addBuffer(j);
				}
			}
		} while(last == 0);
		this.flushBuffer();
		this.byteAlign();
		return 0;
	}
	,decodeValue: function(currentTree) {
		var len = 0;
		var xtreepos = 0;
		var X = currentTree[xtreepos];
		var b = 0;
		while(true) {
			b = this.readBit();
			if(b != 0) {
				if((X.b1 & 32768) == 0) return X.b1;
				X = X.jump;
				len = currentTree.length;
				var _g = 0;
				while(_g < len) {
					var i = _g++;
					if(currentTree[i] == X) {
						xtreepos = i;
						break;
					}
				}
			} else {
				if((X.b0 & 32768) == 0) return X.b0;
				xtreepos++;
				X = currentTree[xtreepos];
			}
		}
		return -1;
	}
	,createTree: function(currentTree,numval,lengths,show) {
		this.Places = currentTree;
		this.treepos = 0;
		this.flens = lengths;
		this.fmax = numval;
		var _g = 0;
		while(_g < 17) {
			var i = _g++;
			this.fpos[i] = 0;
		}
		this.len = 0;
		if(this.rec() != 0) return -1;
		return 0;
	}
	,rec: function() {
		var curplace = this.Places[this.treepos];
		var tmp;
		if(this.len == 17) return -1;
		this.treepos++;
		this.len++;
		tmp = this.isPat();
		if(tmp >= 0) curplace.b0 = tmp; else {
			curplace.b0 = 32768;
			if(this.rec() != 0) return -1;
		}
		tmp = this.isPat();
		if(tmp >= 0) {
			curplace.b1 = tmp;
			curplace.jump = null;
		} else {
			curplace.b1 = 32768;
			curplace.jump = this.Places[this.treepos];
			curplace.jumppos = this.treepos;
			if(this.rec() != 0) return -1;
		}
		this.len--;
		return 0;
	}
	,isPat: function() {
		while(true) {
			if(this.fpos[this.len] >= this.fmax) return -1;
			if(this.flens[this.fpos[this.len]] == this.len) return this.fpos[this.len]++;
			this.fpos[this.len]++;
		}
	}
	,addBuffer: function(a) {
		this.buf32k[this.bIdx++] = a;
		this.outputArr.push(String.fromCharCode(a));
		if(this.bIdx == 32768) this.bIdx = 0;
	}
	,flushBuffer: function() {
		this.bIdx = 0;
	}
	,readBits: function(a) {
		var res = 0;
		var i = a;
		while(i != 0) {
			res = res << 1 | this.readBit();
			i--;
		}
		if(a != 0) res = cc.platform.CCGZip.bitReverse[res] >> 8 - a;
		return res;
	}
	,readBit: function() {
		this.bits++;
		var carry = this.bb & 1;
		this.bb >>= 1;
		if(this.bb == 0) {
			this.bb = this.readByte();
			carry = this.bb & 1;
			this.bb = this.bb >> 1 | 128;
		}
		return carry;
	}
	,byteAlign: function() {
		this.bb = 1;
	}
	,readByte: function() {
		this.bits += 8;
		if(this.bytepos < this.data.length) return HxOverrides.cca(this.data,this.bytepos++); else return -1;
	}
	,gunzipLocal: function() {
		this.outputArr = new Array();
		this.nextFile();
		return this.unzipped[0][0];
	}
	,__class__: cc.platform.CCGZip
}
cc.platform.HufNode = function() {
	this.jumppos = -1;
	this.b1 = 0;
	this.b0 = 0;
};
cc.platform.HufNode.__name__ = true;
cc.platform.HufNode.prototype = {
	__class__: cc.platform.HufNode
}
cc.platform.CCPlistEntry = function(entry) {
	if(entry == null) return;
	this.name = entry.name;
	this.x = entry.x;
	this.y = entry.y;
	this.width = entry.width;
	this.height = entry.height;
	this.sourceColorX = entry.sourceColorX;
	this.sourceColorY = entry.sourceColorY;
	this.rotated = entry.rotated;
};
cc.platform.CCPlistEntry.__name__ = true;
cc.platform.CCPlistEntry.prototype = {
	__class__: cc.platform.CCPlistEntry
}
cc.platform.CCSAXParser = function() {
	this.plist = new Array();
};
cc.platform.CCSAXParser.__name__ = true;
cc.platform.CCSAXParser.getInstance = function() {
	if(cc.platform.CCSAXParser._instance == null) cc.platform.CCSAXParser._instance = new cc.platform.CCSAXParser();
	return cc.platform.CCSAXParser._instance;
}
cc.platform.CCSAXParser.prototype = {
	parseString: function(str) {
		var ret = new Array();
		var index;
		var temp;
		var buf = new StringBuf();
		var _g1 = 0, _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(str.charAt(i) != "{" && str.charAt(i) != "}") buf.addSub(str.charAt(i),0,null);
		}
		var newString = buf.b;
		var _g = 0, _g1 = newString.split(",");
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			ret.push(Std.parseFloat(i));
		}
		return ret;
	}
	,parse: function(textxml) {
		this.xmlDoc = Xml.parse(cc.CCLoader.pack.getFile(textxml).toString());
		var index = 0;
		var $it0 = this.xmlDoc.firstElement().firstElement().elements();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x.firstChild().get_nodeValue() == "frames") index = 1; else if(x.get_nodeName() == "dict" && index == 1) this.frames = x; else if(x.firstChild().get_nodeValue() == "metadata") index = 2; else if(x.get_nodeName() == "dict" && index == 2) this.metadata = x;
		}
		index = 1;
		var tempEntry = new cc.platform.CCPlistEntry();
		var tempKey = "";
		var $it1 = this.frames.elements();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(x.get_nodeName() == "key" && index == 1) {
				tempEntry.name = x.firstChild().get_nodeValue();
				index = 2;
			} else if(x.get_nodeName() == "dict" && index == 2) {
				index = 1;
				var $it2 = x.elements();
				while( $it2.hasNext() ) {
					var info = $it2.next();
					if(info.get_nodeName() == "key") tempKey = info.firstChild().get_nodeValue(); else switch(tempKey) {
					case "frame":
						var s = this.parseString(info.firstChild().get_nodeValue());
						tempEntry.x = s[0];
						tempEntry.y = s[1];
						tempEntry.width = s[2];
						tempEntry.height = s[3];
						break;
					case "sourceColorRect":
						var s = this.parseString(info.firstChild().get_nodeValue());
						tempEntry.sourceColorX = s[0];
						tempEntry.sourceColorY = s[1];
						break;
					case "rotated":
						if(info.get_nodeName() == "true") tempEntry.rotated = true; else tempEntry.rotated = false;
						break;
					}
				}
				this.plist.push(new cc.platform.CCPlistEntry(tempEntry));
			}
		}
		return this.plist;
	}
	,__class__: cc.platform.CCSAXParser
}
cc.platform.CCTypes = function() { }
cc.platform.CCTypes.__name__ = true;
cc.platform.CCTypes.white = function() {
	return new cc.platform.CCColor3B(255,255,255);
}
cc.platform.CCTypes.V3F_C4B_T2F_QuadZero = function() {
	return new cc.platform.CCV3F_C4B_T2F_Quad(new cc.platform.CCV3F_C4B_T2F(new cc.platform.CCVertex3F(0,0,0),new cc.platform.CCColor4B(0,0,0,1),new cc.platform.CCTex2F(0,0)),new cc.platform.CCV3F_C4B_T2F(new cc.platform.CCVertex3F(0,0,0),new cc.platform.CCColor4B(0,0,0,1),new cc.platform.CCTex2F(0,0)),new cc.platform.CCV3F_C4B_T2F(new cc.platform.CCVertex3F(0,0,0),new cc.platform.CCColor4B(0,0,0,1),new cc.platform.CCTex2F(0,0)),new cc.platform.CCV3F_C4B_T2F(new cc.platform.CCVertex3F(0,0,0),new cc.platform.CCColor4B(0,0,0,1),new cc.platform.CCTex2F(0,0)));
}
cc.platform.CCTypes.convertColor3BtoHexString = function(clr) {
	var ret = (clr.r & 255) << 16 | (clr.g & 255) << 8 | clr.b & 255;
	var s = StringTools.hex(ret);
	return "0x" + s;
}
cc.platform.CCColor3B = function(r,g,b) {
	this.r = r;
	this.g = g;
	this.b = b;
	this.color = Std.parseInt(cc.platform.CCTypes.convertColor3BtoHexString(this));
};
cc.platform.CCColor3B.__name__ = true;
cc.platform.CCColor3B.white = function() {
	return new cc.platform.CCColor3B(255,255,255);
}
cc.platform.CCColor3B.prototype = {
	__class__: cc.platform.CCColor3B
}
cc.platform.CCColor4B = function(r,g,b,alpha) {
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = alpha;
	this.color = Std.parseInt(cc.platform.CCTypes.convertColor3BtoHexString(new cc.platform.CCColor3B(r,g,b)));
};
cc.platform.CCColor4B.__name__ = true;
cc.platform.CCColor4B.prototype = {
	__class__: cc.platform.CCColor4B
}
cc.platform.CCVertex3F = function(x1,y1,z1) {
	this.x = x1;
	this.y = y1;
	this.z = z1;
};
cc.platform.CCVertex3F.__name__ = true;
cc.platform.CCVertex3F.prototype = {
	__class__: cc.platform.CCVertex3F
}
cc.platform.CCTex2F = function(u1,v1) {
	this.u = u1;
	this.v = v1;
};
cc.platform.CCTex2F.__name__ = true;
cc.platform.CCTex2F.prototype = {
	__class__: cc.platform.CCTex2F
}
cc.platform.CCV3F_C4B_T2F = function(vertices1,colors1,texCoords1) {
	this.vertices = vertices1;
	this.colors = colors1;
	this.texCoords = texCoords1;
};
cc.platform.CCV3F_C4B_T2F.__name__ = true;
cc.platform.CCV3F_C4B_T2F.prototype = {
	__class__: cc.platform.CCV3F_C4B_T2F
}
cc.platform.CCV3F_C4B_T2F_Quad = function(bl1,br1,tl1,tr1) {
	this.bl = bl1;
	this.br = br1;
	this.tl = tl1;
	this.tr = tr1;
};
cc.platform.CCV3F_C4B_T2F_Quad.__name__ = true;
cc.platform.CCV3F_C4B_T2F_Quad.prototype = {
	__class__: cc.platform.CCV3F_C4B_T2F_Quad
}
cc.platform.CCZipUtils = function() { }
cc.platform.CCZipUtils.__name__ = true;
cc.platform.CCZipUtils.unzipBase64 = function(input) {
	var tmpInput = cc.platform.CCBase64.decode(input);
	return cc.platform.CCGZip.gunzip(tmpInput);
}
cc.platform.CCZipUtils.unzipBase64AsArray = function(input,lineWidth,bytes) {
	if(bytes == null) bytes = 1;
	var dec = cc.platform.CCZipUtils.unzipBase64(input);
	var ar = [];
	var len = dec.length / bytes | 0;
	var _g = 0;
	while(_g < len) {
		var i = _g++;
		ar[i] = 0;
		var j = bytes - 1;
		while(j >= 0) {
			var t = HxOverrides.cca(dec,i * bytes + j) << j * 8;
			ar[i] += t;
			j--;
		}
	}
	return ar;
}
cc.spritenodes = {}
cc.spritenodes.CCAnimation = function() {
	this._frames = new Array();
	this._restoreOriginalFrame = true;
	this._loops = 0;
	this._duration = 0;
	this._delayPerUnit = 0;
	this._totalDelayUnits = 0;
};
cc.spritenodes.CCAnimation.__name__ = true;
cc.spritenodes.CCAnimation.createWithAnimationFrames = function(arrayOfAnimationFramesNames,delayPerUnit,loops) {
	var animation = new cc.spritenodes.CCAnimation();
	if(loops == null) animation.initWithSpriteFrames(arrayOfAnimationFramesNames,delayPerUnit);
	return animation;
}
cc.spritenodes.CCAnimation.prototype = {
	initWithSpriteFrames: function(frames,delay) {
		this._loops = 1;
		this._delayPerUnit = delay;
		var tempFrames = new Array();
		this.setFrames(tempFrames);
		if(frames != null) {
			var _g = 0;
			while(_g < frames.length) {
				var f = frames[_g];
				++_g;
				var frame = f;
				var animFrame = new cc.spritenodes.CCAnimationFrame();
				animFrame.initWithSpriteFrame(frame,1,null);
				this._frames.push(animFrame);
				this._totalDelayUnits++;
			}
		}
		return true;
	}
	,getTotalDelayUnits: function() {
		return this._totalDelayUnits;
	}
	,getDelayPerUnit: function() {
		return this._delayPerUnit;
	}
	,getDuration: function() {
		return this._totalDelayUnits * this._delayPerUnit;
	}
	,getRestoreOriginalFrame: function() {
		return this._restoreOriginalFrame;
	}
	,getLoops: function() {
		return this._loops;
	}
	,setFrames: function(frames) {
		this._frames = frames;
	}
	,getFrames: function() {
		return this._frames;
	}
	,__class__: cc.spritenodes.CCAnimation
}
cc.spritenodes.CCAnimationFrame = function() {
	this._delayPerUnit = 0;
};
cc.spritenodes.CCAnimationFrame.__name__ = true;
cc.spritenodes.CCAnimationFrame.prototype = {
	setUserInfo: function(userInfo) {
		this._userInfo = userInfo;
	}
	,setDelayUnits: function(delayUnits) {
		this._delayPerUnit = delayUnits;
	}
	,getDelayUnits: function() {
		return this._delayPerUnit;
	}
	,setSpriteFrame: function(spriteFrame) {
		this._spriteFrame = spriteFrame;
	}
	,getSpriteFrame: function() {
		return this._spriteFrame;
	}
	,initWithSpriteFrame: function(spriteFrame,delayUnits,userInfo) {
		this.setSpriteFrame(spriteFrame);
		this.setDelayUnits(delayUnits);
		this.setUserInfo(userInfo);
		return true;
	}
	,__class__: cc.spritenodes.CCAnimationFrame
}
cc.spritenodes.CCAnimationCache = function() {
};
cc.spritenodes.CCAnimationCache.__name__ = true;
cc.spritenodes.CCAnimationCache.getInstance = function() {
	if(cc.spritenodes.CCAnimationCache.s_sharedAnimationCache == null) {
		cc.spritenodes.CCAnimationCache.s_sharedAnimationCache = new cc.spritenodes.CCAnimationCache();
		cc.spritenodes.CCAnimationCache.s_sharedAnimationCache.init();
	}
	return cc.spritenodes.CCAnimationCache.s_sharedAnimationCache;
}
cc.spritenodes.CCAnimationCache.prototype = {
	init: function() {
		this._animations = new haxe.ds.StringMap();
		return true;
	}
	,getAnimation: function(name) {
		if(this._animations.exists(name)) return this._animations.get(name);
		return null;
	}
	,addAnimation: function(animation,name) {
		this._animations.set(name,animation);
	}
	,__class__: cc.spritenodes.CCAnimationCache
}
cc.spritenodes.CCSprite = function() {
	this.isTiledMap = false;
	this._isAdded = false;
	this._opacity = 255;
	cc.basenodes.CCNode.call(this);
	this._color = cc.platform.CCColor3B.white();
	this._offsetPosition = new flambe.math.Point(0,0);
	this._unflippedOffsetPositionFromCenter = cc.cocoa.CCGeometry.p(0,0);
	this._shouldBeHidden = false;
};
cc.spritenodes.CCSprite.__name__ = true;
cc.spritenodes.CCSprite.createWithTexture = function(texture,rect,isTiledMap) {
	if(isTiledMap == null) isTiledMap = false;
	var sprite = new cc.spritenodes.CCSprite();
	sprite.isTiledMap = isTiledMap;
	if(rect == null) sprite.initWithTexture(texture); else sprite.initWithTexture(texture,rect);
	return sprite;
}
cc.spritenodes.CCSprite.create = function(fileName,rect) {
	var sprite = new cc.spritenodes.CCSprite();
	if(fileName == null) {
		if(sprite.init()) return sprite;
	} else if(rect == null) {
		sprite.init();
		sprite.initWithFile(fileName);
	} else {
		sprite.init();
		sprite.initWithFile(fileName,rect);
	}
	return sprite;
}
cc.spritenodes.CCSprite.__super__ = cc.basenodes.CCNode;
cc.spritenodes.CCSprite.prototype = $extend(cc.basenodes.CCNode.prototype,{
	update: function(dt) {
		cc.basenodes.CCNode.prototype.update.call(this,dt);
	}
	,displayFrame: function() {
		if(js.Boot.__instanceof(this.sprite,cc.spritenodes.CCSpriteSheet)) {
			var s = js.Boot.__cast(this.sprite , cc.spritenodes.CCSpriteSheet);
			return s.getCurrentFrame();
		}
		return null;
	}
	,setDisplayFrame: function(newFrame) {
		if(js.Boot.__instanceof(this.sprite,cc.spritenodes.CCSpriteSheet)) {
			var s = js.Boot.__cast(this.sprite , cc.spritenodes.CCSpriteSheet);
			s.updateFrame(newFrame);
		} else {
			var x = this.sprite.x._value;
			var y = this.sprite.y._value;
			var scaleX = this.sprite.scaleX._value;
			var scaleY = this.sprite.scaleY._value;
			var anchorX = this._anchorPoint.x;
			var anchorY = this._anchorPoint.y;
			this.sprite = new cc.spritenodes.CCSpriteSheet();
			var s = js.Boot.__cast(this.sprite , cc.spritenodes.CCSpriteSheet);
			s.updateFrame(newFrame);
			this.setAnchorPoint(new flambe.math.Point(anchorX,anchorY));
			this.setPosition(x,y);
			this.setScale(scaleX,scaleY);
			if(!this._isAdded) {
				this.entity.add(s);
				this.component = new cc.CCComponent(this);
				this.entity.add(this.component);
				this._contentSize = new cc.cocoa.CCSize(newFrame.getRect().width,newFrame.getRect().height);
				this._isAdded = true;
			}
		}
		this._rectRotated = newFrame.isRotated();
		var pNewTexture = newFrame.getTexture();
		if(pNewTexture != this._texture) this.setTexture(pNewTexture);
		this.setTextureRect(newFrame.getRect(),this._rectRotated,newFrame.getOriginalSize());
	}
	,setTexture: function(texture) {
		this._texture = texture;
	}
	,setTextureRect: function(rect,rotated,untrimmedSize) {
	}
	,initWithSpriteFrameName: function(spriteFrameName) {
		var frame = cc.spritenodes.CCSpriteFrameCache.getInstance().getSpriteFrame(spriteFrameName);
		return this.initWithSpriteFrame(frame);
	}
	,initWithSpriteFrame: function(spriteFrame) {
		this._position.x = spriteFrame.getOffset().x;
		this._position.y = spriteFrame.getOffset().y;
		var ret = this.initWithTexture(spriteFrame.getTexture(),spriteFrame.getRect(),spriteFrame.isRotated());
		return ret;
	}
	,initWithFile: function(fileName,rect) {
		var pack = cc.CCLoader.pack;
		var t = pack.getTexture(fileName);
		var texture = cc.texture.CCTextureCache.getInstance().addImage(fileName);
		if(rect == null) {
			this.sprite = new flambe.display.ImageSprite(t);
			this.setAnchorPoint(this.getAnchorPoint());
			this._contentSize = new cc.cocoa.CCSize(this.sprite.getNaturalWidth(),this.sprite.getNaturalHeight());
			this.entity.add(this.sprite);
			this.component = new cc.CCComponent(this);
			this.entity.add(this.component);
		} else this.initWithTexture(texture,rect);
	}
	,initWithTexture: function(texture,rect,rotated) {
		if(rotated == null) rotated = false;
		if(rect == null) {
			rect = new flambe.math.Rectangle(0,0,0,0);
			rect.width = texture.getPixelsWide();
			rect.height = texture.getPixelsHigh();
			this.sprite = new flambe.display.ImageSprite(texture.getTexture());
			this.setAnchorPoint(this.getAnchorPoint());
			this._contentSize = new cc.cocoa.CCSize(this.sprite.getNaturalWidth(),this.sprite.getNaturalHeight());
			this.entity.add(this.sprite);
			this.component = new cc.CCComponent(this);
			this.entity.add(this.component);
		} else {
			this.sprite = new cc.spritenodes.CCSpriteSheet(this.isTiledMap);
			var s = js.Boot.__cast(this.sprite , cc.spritenodes.CCSpriteSheet);
			var f = cc.spritenodes.CCSpriteFrame.createWithTexture(texture,rect,rotated,this._position,new cc.cocoa.CCSize());
			s.updateFrame(f);
			this.entity.add(s);
			this.component = new cc.CCComponent(this);
			this.entity.add(this.component);
			this._contentSize = new cc.cocoa.CCSize(rect.width,rect.height);
			this._isAdded = true;
			this.setAnchorPoint(this.getAnchorPoint());
		}
		this.setTexture(texture);
		this.setTextureRect(rect,rotated,new cc.cocoa.CCSize(rect.width,rect.height));
		return true;
	}
	,init: function() {
		cc.basenodes.CCNode.prototype.init.call(this);
		this._dirty = this._recursiveDirty = false;
		this._opacityModifyRGB = true;
		this._opacity = 1;
		this._color = cc.platform.CCTypes.white();
		this._colorUnmodified = cc.platform.CCTypes.white();
		this._flipX = this._flipY = false;
		this.setAnchorPoint(new flambe.math.Point(0.5,0.5));
		this._offsetPosition = new flambe.math.Point(0,0);
		this._hasChildren = false;
		var tmpColor = new cc.platform.CCColor4B(255,255,255,1);
		this._quad = cc.platform.CCTypes.V3F_C4B_T2F_QuadZero();
		this._quad.bl.colors = tmpColor;
		this._quad.br.colors = tmpColor;
		this._quad.tl.colors = tmpColor;
		this._quad.tr.colors = tmpColor;
		this.setTextureRect(cc.cocoa.CCGeometry.rectZero(),false,cc.cocoa.CCGeometry.sizeZero());
		return true;
	}
	,setOpacity: function(opacity) {
		this._opacity = opacity;
		this.sprite.alpha.set__(opacity / 255);
	}
	,getOpacity: function() {
		return this._opacity;
	}
	,setBlendFunc: function(blend) {
		this._blendFunc = blend;
		this.sprite.blendMode = blend;
	}
	,__class__: cc.spritenodes.CCSprite
});
cc.spritenodes.CCSpriteBatchNode = function() {
	cc.basenodes.CCNode.call(this);
	this.entity.add(this.sprite);
};
cc.spritenodes.CCSpriteBatchNode.__name__ = true;
cc.spritenodes.CCSpriteBatchNode.__super__ = cc.basenodes.CCNode;
cc.spritenodes.CCSpriteBatchNode.prototype = $extend(cc.basenodes.CCNode.prototype,{
	initWithTexture: function(tex,capacity) {
		this._originalTexture = tex;
		this._texture = tex;
		return true;
	}
	,__class__: cc.spritenodes.CCSpriteBatchNode
});
cc.spritenodes.CCSpriteFrame = function() {
	this._offset = new flambe.math.Point(0,0);
	this._offsetInPixels = new flambe.math.Point(0,0);
	this._originalSize = new cc.cocoa.CCSize(0,0);
	this._rectInPixels = new flambe.math.Rectangle(0,0,0,0);
	this._rect = new flambe.math.Rectangle(0,0,0,0);
	this._originalSizeInPixels = new cc.cocoa.CCSize(0,0);
	this._textureFilname = "";
};
cc.spritenodes.CCSpriteFrame.__name__ = true;
cc.spritenodes.CCSpriteFrame.createWithTexture = function(texture,rect,rotated,offset,originalSize) {
	var spriteFrame = new cc.spritenodes.CCSpriteFrame();
	spriteFrame.initWithTexture(texture,rect,rotated,offset,originalSize);
	return spriteFrame;
}
cc.spritenodes.CCSpriteFrame.prototype = {
	initWithTexture: function(texture,rect,rotated,offset,originalSize) {
		this._texture = texture;
		this._rectInPixels = rect;
		this._rect = rect;
		this._offsetInPixels = offset;
		this._offset = offset;
		this._originalSizeInPixels = originalSize;
		this._originalSize = originalSize;
		this._rotated = rotated;
		return true;
	}
	,getOffset: function() {
		return new flambe.math.Point(this._offset.x,this._offset.y);
	}
	,getTexture: function() {
		if(this._texture != null) return this._texture;
		return null;
	}
	,getOriginalSize: function() {
		return new cc.cocoa.CCSize(this._originalSize.width,this._originalSize.height);
	}
	,getRect: function() {
		return this._rect;
	}
	,isRotated: function() {
		return this._rotated;
	}
	,__class__: cc.spritenodes.CCSpriteFrame
}
cc.spritenodes.CCSpriteFrameCache = function() {
	this._spriteFrames = new haxe.ds.StringMap();
};
cc.spritenodes.CCSpriteFrameCache.__name__ = true;
cc.spritenodes.CCSpriteFrameCache.getInstance = function() {
	if(cc.spritenodes.CCSpriteFrameCache.s_sharedSpriteFrameCache == null) cc.spritenodes.CCSpriteFrameCache.s_sharedSpriteFrameCache = new cc.spritenodes.CCSpriteFrameCache();
	return cc.spritenodes.CCSpriteFrameCache.s_sharedSpriteFrameCache;
}
cc.spritenodes.CCSpriteFrameCache.prototype = {
	getSpriteFrame: function(name) {
		if(this._spriteFrames.exists(name)) return this._spriteFrames.get(name); else return null;
	}
	,addSpriteFrames: function(plist,texture) {
		var dict = cc.platform.CCFileUtils.getInstance().dictionaryWithContentsOfFile(plist);
		var t = new cc.texture.CCTexture2D();
		if(texture == null) {
			var name = plist.split(".pli")[0];
			t.setTexture(cc.CCLoader.pack.getTexture(name));
			texture = t;
		}
		this._addSpriteFramesWithDictionary(dict,t);
	}
	,_addSpriteFramesWithDictionary: function(dict,texture) {
		var _g = 0;
		while(_g < dict.length) {
			var p = dict[_g];
			++_g;
			var rect = new flambe.math.Rectangle(p.x,p.y,p.width,p.height);
			var rotated = p.rotated;
			var offset = new flambe.math.Point(p.sourceColorX,p.sourceColorY);
			var size = new cc.cocoa.CCSize(0,0);
			var frame = cc.spritenodes.CCSpriteFrame.createWithTexture(texture,rect,rotated,offset,size);
			this._spriteFrames.set(p.name,frame);
		}
	}
	,__class__: cc.spritenodes.CCSpriteFrameCache
}
flambe.display = {}
flambe.display.Sprite = function() {
	this._parentViewMatrixUpdateCount = 0;
	this._viewMatrixUpdateCount = 0;
	this._viewMatrix = null;
	this.scissor = null;
	this.blendMode = null;
	var _g = this;
	this._flags = 75;
	this._localMatrix = new flambe.math.Matrix();
	var dirtyMatrix = function(_,_1) {
		_g._flags = _g._flags | 12;
	};
	this.x = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.y = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.rotation = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.scaleX = new flambe.animation.AnimatedFloat(1,dirtyMatrix);
	this.scaleY = new flambe.animation.AnimatedFloat(1,dirtyMatrix);
	this.anchorX = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.anchorY = new flambe.animation.AnimatedFloat(0,dirtyMatrix);
	this.alpha = new flambe.animation.AnimatedFloat(1);
};
flambe.display.Sprite.__name__ = true;
flambe.display.Sprite.hitTest = function(entity,x,y) {
	var sprite = entity._compMap.Sprite_2;
	if(sprite != null) {
		if(!((sprite._flags & 3) == 3)) return null;
		if(sprite.getLocalMatrix().inverseTransform(x,y,flambe.display.Sprite._scratchPoint)) {
			x = flambe.display.Sprite._scratchPoint.x;
			y = flambe.display.Sprite._scratchPoint.y;
		}
		var scissor = sprite.scissor;
		if(scissor != null && !scissor.contains(x,y)) return null;
	}
	var result = flambe.display.Sprite.hitTestBackwards(entity.firstChild,x,y);
	if(result != null) return result;
	return sprite != null && sprite.containsLocal(x,y)?sprite:null;
}
flambe.display.Sprite.render = function(entity,g) {
	var sprite = entity._compMap.Sprite_2;
	if(sprite != null) {
		var alpha = sprite.alpha._value;
		if(!((sprite._flags & 1) != 0) || alpha <= 0) return;
		g.save();
		if(alpha < 1) g.multiplyAlpha(alpha);
		if(sprite.blendMode != null) g.setBlendMode(sprite.blendMode);
		var matrix = sprite.getLocalMatrix();
		var m02 = matrix.m02;
		var m12 = matrix.m12;
		if((sprite._flags & 64) != 0) {
			m02 = Math.round(m02);
			m12 = Math.round(m12);
		}
		g.transform(matrix.m00,matrix.m10,matrix.m01,matrix.m11,m02,m12);
		var scissor = sprite.scissor;
		if(scissor != null) g.applyScissor(scissor.x,scissor.y,scissor.width,scissor.height);
		sprite.draw(g);
	}
	var director = entity._compMap.Director_5;
	if(director != null) {
		var scenes = director.occludedScenes;
		var _g = 0;
		while(_g < scenes.length) {
			var scene = scenes[_g];
			++_g;
			flambe.display.Sprite.render(scene,g);
		}
	}
	var p = entity.firstChild;
	while(p != null) {
		var next = p.next;
		flambe.display.Sprite.render(p,g);
		p = next;
	}
	if(sprite != null) g.restore();
}
flambe.display.Sprite.hitTestBackwards = function(entity,x,y) {
	if(entity != null) {
		var result = flambe.display.Sprite.hitTestBackwards(entity.next,x,y);
		return result != null?result:flambe.display.Sprite.hitTest(entity,x,y);
	}
	return null;
}
flambe.display.Sprite.__super__ = flambe.Component;
flambe.display.Sprite.prototype = $extend(flambe.Component.prototype,{
	set_visible: function(visible) {
		this._flags = flambe.util.BitSets.set(this._flags,1,visible);
		return visible;
	}
	,getParentSprite: function() {
		if(this.owner == null) return null;
		var entity = this.owner.parent;
		while(entity != null) {
			var sprite = entity._compMap.Sprite_2;
			if(sprite != null) return sprite;
			entity = entity.parent;
		}
		return null;
	}
	,isViewMatrixDirty: function() {
		if((this._flags & 8) != 0) return true;
		var parentSprite = this.getParentSprite();
		if(parentSprite == null) return false;
		return this._parentViewMatrixUpdateCount != parentSprite._viewMatrixUpdateCount || parentSprite.isViewMatrixDirty();
	}
	,draw: function(g) {
	}
	,onUpdate: function(dt) {
		this.x.update(dt);
		this.y.update(dt);
		this.rotation.update(dt);
		this.scaleX.update(dt);
		this.scaleY.update(dt);
		this.alpha.update(dt);
		this.anchorX.update(dt);
		this.anchorY.update(dt);
	}
	,setScaleXY: function(scaleX,scaleY) {
		this.scaleX.set__(scaleX);
		this.scaleY.set__(scaleY);
		return this;
	}
	,setScale: function(scale) {
		this.scaleX.set__(scale);
		this.scaleY.set__(scale);
		return this;
	}
	,setAnchor: function(x,y) {
		this.anchorX.set__(x);
		this.anchorY.set__(y);
		return this;
	}
	,getViewMatrix: function() {
		if(this.isViewMatrixDirty()) {
			var parentSprite = this.getParentSprite();
			this._viewMatrix = parentSprite != null?flambe.math.Matrix.multiply(parentSprite.getViewMatrix(),this.getLocalMatrix(),this._viewMatrix):this.getLocalMatrix().clone(this._viewMatrix);
			this._flags = this._flags & -9;
			if(parentSprite != null) this._parentViewMatrixUpdateCount = parentSprite._viewMatrixUpdateCount;
			++this._viewMatrixUpdateCount;
		}
		return this._viewMatrix;
	}
	,getLocalMatrix: function() {
		if((this._flags & 4) != 0) {
			this._flags = this._flags & -5;
			this._localMatrix.compose(this.x._value,this.y._value,this.scaleX._value,this.scaleY._value,this.rotation._value * 3.141592653589793 / 180);
			this._localMatrix.translate(-this.anchorX._value,-this.anchorY._value);
		}
		return this._localMatrix;
	}
	,containsLocal: function(localX,localY) {
		return localX >= 0 && localX < this.getNaturalWidth() && localY >= 0 && localY < this.getNaturalHeight();
	}
	,contains: function(viewX,viewY) {
		var a = this.getViewMatrix().inverseTransform(viewX,viewY,flambe.display.Sprite._scratchPoint);
		var b = this.containsLocal(flambe.display.Sprite._scratchPoint.x,flambe.display.Sprite._scratchPoint.y);
		return a && b;
	}
	,getNaturalHeight: function() {
		return 0;
	}
	,getNaturalWidth: function() {
		return 0;
	}
	,get_name: function() {
		return "Sprite_2";
	}
	,__class__: flambe.display.Sprite
});
cc.spritenodes.CCSpriteSheet = function(isTiledMap) {
	if(isTiledMap == null) isTiledMap = false;
	flambe.display.Sprite.call(this);
	this.isTiledMap = isTiledMap;
	this._actionManager = cc.CCDirector.getInstance().getActionManager();
};
cc.spritenodes.CCSpriteSheet.__name__ = true;
cc.spritenodes.CCSpriteSheet.__super__ = flambe.display.Sprite;
cc.spritenodes.CCSpriteSheet.prototype = $extend(flambe.display.Sprite.prototype,{
	getNaturalWidth: function() {
		if(this.frame == null) return 0;
		return this.frame.getRect().width;
	}
	,getNaturalHeight: function() {
		if(this.frame == null) return 0;
		return this.frame.getRect().height;
	}
	,onUpdate: function(dt) {
		flambe.display.Sprite.prototype.onUpdate.call(this,dt);
	}
	,getCurrentFrame: function() {
		return this.frame;
	}
	,draw: function(g) {
		this.g = g;
		if(this.frame.isRotated()) {
			g.translate(this.frame.getOffset().x,this.frame.getOffset().y + this.frame.getRect().height);
			g.rotate(-90);
			g.drawSubImage(this.frame.getTexture().getTexture(),0,0,this.frame.getRect().x,this.frame.getRect().y,this.frame.getRect().height,this.frame.getRect().width);
		} else if(this.isTiledMap) {
			var t = new flambe.math.Rectangle(this.x._value,this.y._value,this.frame.getRect().width,this.frame.getRect().height);
			if(cc.cocoa.CCGeometry.rectIntersectsRect(t,cc.tilemapparallaxnodes.CCTMXTiledMap.viewPort)) {
				g.translate(this.frame.getOffset().x,this.frame.getOffset().y);
				g.drawSubImage(this.frame.getTexture().getTexture(),0,0,this.frame.getRect().x,this.frame.getRect().y,this.frame.getRect().width,this.frame.getRect().height);
			} else {
			}
		} else {
			g.translate(this.frame.getOffset().x,this.frame.getOffset().y);
			g.drawSubImage(this.frame.getTexture().getTexture(),0,0,this.frame.getRect().x,this.frame.getRect().y,this.frame.getRect().width,this.frame.getRect().height);
		}
	}
	,updateFrame: function(frame) {
		this.frame = frame;
	}
	,__class__: cc.spritenodes.CCSpriteSheet
});
cc.support = {}
cc.support.CCPointExtension = function() { }
cc.support.CCPointExtension.__name__ = true;
cc.support.CCPointExtension.pAdd = function(v1,v2) {
	return new flambe.math.Point(v1.x + v2.x,v1.y + v2.y);
}
cc.support.CCPointExtension.pSub = function(v1,v2) {
	return new flambe.math.Point(v1.x - v2.x,v1.y - v2.y);
}
cc.texture = {}
cc.texture.CCTexture2D = function() {
	this._contentSize = new cc.cocoa.CCSize();
};
cc.texture.CCTexture2D.__name__ = true;
cc.texture.CCTexture2D.prototype = {
	getPixelsHigh: function() {
		return this._texture.get_height();
	}
	,getPixelsWide: function() {
		return this._texture.get_width();
	}
	,setTexture: function(t) {
		this._texture = t;
		this._contentSize.width = Std.parseFloat(Std.string(this._texture.get_width()));
		this._contentSize.height = Std.parseFloat(Std.string(this._texture.get_height()));
	}
	,getTexture: function() {
		return this._texture;
	}
	,__class__: cc.texture.CCTexture2D
}
cc.texture.CCTextureCache = function() {
};
cc.texture.CCTextureCache.__name__ = true;
cc.texture.CCTextureCache.getInstance = function() {
	if(cc.texture.CCTextureCache.g_sharedTextureCache == null) cc.texture.CCTextureCache.g_sharedTextureCache = new cc.texture.CCTextureCache();
	return cc.texture.CCTextureCache.g_sharedTextureCache;
}
cc.texture.CCTextureCache.prototype = {
	addImage: function(path) {
		var pack = cc.CCLoader.pack;
		var ret = new cc.texture.CCTexture2D();
		ret.setTexture(pack.getTexture(path));
		return ret;
	}
	,__class__: cc.texture.CCTextureCache
}
cc.tilemapparallaxnodes = {}
cc.tilemapparallaxnodes.CCTMXLayer = function() {
	this._layerInfo = null;
	this._mapInfo = null;
	cc.spritenodes.CCSpriteBatchNode.call(this);
	this._children = [];
	this._layerSize = new cc.cocoa.CCSize();
	this._mapTileSize = new cc.cocoa.CCSize();
	this._opacity = 255;
	this._layerName = "";
	this._tiles = new Array();
	this._properties = new haxe.ds.StringMap();
	this._useAutomaticVertexZ = false;
};
cc.tilemapparallaxnodes.CCTMXLayer.__name__ = true;
cc.tilemapparallaxnodes.CCTMXLayer.create = function(tilesetInfo,layerInfo,mapInfo) {
	var ret = new cc.tilemapparallaxnodes.CCTMXLayer();
	if(ret.initWithTilesetInfo(tilesetInfo,layerInfo,mapInfo)) return ret;
	return null;
}
cc.tilemapparallaxnodes.CCTMXLayer.__super__ = cc.spritenodes.CCSpriteBatchNode;
cc.tilemapparallaxnodes.CCTMXLayer.prototype = $extend(cc.spritenodes.CCSpriteBatchNode.prototype,{
	_parseInternalProperties: function() {
		var vertexz = this.getProperty("cc_vertexz");
		if(vertexz != null) {
			if(vertexz == "automatic") this._useAutomaticVertexZ = true; else this._vertexZvalue = Std.parseInt(vertexz);
		}
	}
	,getProperty: function(propertyName) {
		return this._properties.get(propertyName);
	}
	,_vertexZForPos: function(row,col) {
		var ret = 0;
		var maxVal = 0;
		if(this._useAutomaticVertexZ) {
			var _g = this;
			switch(_g._layerOrientation) {
			case cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ISO:
				ret = row + col;
				break;
			case cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ORTHO:
				ret = row;
				break;
			default:
				null;
			}
		} else ret = this._vertexZvalue;
		return ret;
	}
	,setupTiles: function() {
		var count = 0;
		var _g1 = 0, _g = this._layerInfo._layerSize.height | 0;
		while(_g1 < _g) {
			var row = _g1++;
			var _g3 = 0, _g2 = this._layerInfo._layerSize.width | 0;
			while(_g3 < _g2) {
				var col = _g3++;
				var gid = this._layerInfo._tiles[col + row * this._layerInfo._layerSize.width | 0];
				if(gid == 0) continue; else {
					var o = this._layerOrientation;
					var x = 0;
					var y = 0;
					if(o == cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ORTHO) {
						x = col * this._mapTileSize.width;
						y = row * this._mapTileSize.height;
					} else if(o == cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ISO) {
						x = this._mapTileSize.width / 2 * (this._layerSize.height + col - row);
						y = this._mapTileSize.height / 2 * (row + col + 2) - this._tileSet._tileSize.height;
					}
					var rect = this._tileSet.rectForGID(gid);
					var sprite = cc.spritenodes.CCSprite.createWithTexture(this._texture,rect,cc.tilemapparallaxnodes.CCTMXTiledMap.useViewPort);
					sprite.setAnchorPoint(new flambe.math.Point(0,0));
					sprite.setPosition(x,y);
					sprite.setOpacity(this._opacity);
					this.addChild(sprite,this._vertexZForPos(row,col));
				}
			}
		}
	}
	,initWithTilesetInfo: function(tilesetInfo,layerInfo,mapInfo) {
		var size = layerInfo._layerSize;
		var totalNumberOfTiles = size.width * size.height | 0;
		this._mapInfo = mapInfo;
		this._layerInfo = layerInfo;
		var capacity = totalNumberOfTiles * 0.35 + 1 | 0;
		var texture = null;
		if(tilesetInfo != null) texture = cc.texture.CCTextureCache.getInstance().addImage(tilesetInfo.sourceImage);
		if(this.initWithTexture(texture,capacity)) {
			this.setContentSize(new cc.cocoa.CCSize(this.sprite.getNaturalWidth(),this.sprite.getNaturalHeight()));
			this._layerSize = layerInfo._layerSize;
			this._layerName = layerInfo.name;
			this._tiles = layerInfo._tiles;
			this._minGID = layerInfo._minGID;
			this._maxGID = layerInfo._maxGID;
			this.setProperties(layerInfo.getProperties());
			this._opacity = layerInfo._opacity;
			this._parseInternalProperties();
			this._tileSet = tilesetInfo;
			this._mapTileSize = mapInfo.getTileSize();
			this._layerOrientation = mapInfo.getOrientation();
			this._vertexZvalue = 0;
			return true;
		}
		return false;
	}
	,setProperties: function(v) {
		this._properties = v;
	}
	,__class__: cc.tilemapparallaxnodes.CCTMXLayer
});
cc.tilemapparallaxnodes.CCTMXObject = function(name,x,y,type,width,height) {
	this.name = name;
	this.x = x;
	this.y = y;
	this.height = height;
	this.width = width;
	this.type = type;
	this.properties = new haxe.ds.StringMap();
};
cc.tilemapparallaxnodes.CCTMXObject.__name__ = true;
cc.tilemapparallaxnodes.CCTMXObject.prototype = {
	__class__: cc.tilemapparallaxnodes.CCTMXObject
}
cc.tilemapparallaxnodes.CCTMXObjectGroup = function() {
	this._groupName = "";
	this._properties = new haxe.ds.StringMap();
	this._objects = new Array();
};
cc.tilemapparallaxnodes.CCTMXObjectGroup.__name__ = true;
cc.tilemapparallaxnodes.CCTMXObjectGroup.prototype = {
	setObjects: function(object) {
		this._objects.push(object);
	}
	,setGroupName: function(s) {
		this._groupName = s;
	}
	,setPositionOffset: function(v) {
		this._positionOffset = v;
	}
	,__class__: cc.tilemapparallaxnodes.CCTMXObjectGroup
}
flambe.math.Rectangle = function(x,y,width,height) {
	if(height == null) height = 0;
	if(width == null) width = 0;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.set(x,y,width,height);
};
flambe.math.Rectangle.__name__ = true;
flambe.math.Rectangle.prototype = {
	equals: function(other) {
		return this.x == other.x && this.y == other.y && this.width == other.width && this.height == other.height;
	}
	,clone: function(result) {
		if(result == null) result = new flambe.math.Rectangle();
		result.set(this.x,this.y,this.width,this.height);
		return result;
	}
	,contains: function(x,y) {
		x -= this.x;
		if(this.width >= 0) {
			if(x < 0 || x > this.width) return false;
		} else if(x > 0 || x < this.width) return false;
		y -= this.y;
		if(this.height >= 0) {
			if(y < 0 || y > this.height) return false;
		} else if(y > 0 || y < this.height) return false;
		return true;
	}
	,set: function(x,y,width,height) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	,__class__: flambe.math.Rectangle
}
cc.tilemapparallaxnodes.CCTMXTiledMap = function() {
	cc.spritenodes.CCSprite.call(this);
	this._mapOrientation = 0;
	this._mapSize = new cc.cocoa.CCSize();
	this._tileSize = new cc.cocoa.CCSize();
	this._objectGroups = new Array();
	this._TMXLayers = new Array();
};
cc.tilemapparallaxnodes.CCTMXTiledMap.__name__ = true;
cc.tilemapparallaxnodes.CCTMXTiledMap.create = function(tmxFile,resourcePath) {
	var ret = new cc.tilemapparallaxnodes.CCTMXTiledMap();
	if(ret.initWithTMXFile(tmxFile,resourcePath)) return ret;
	return null;
}
cc.tilemapparallaxnodes.CCTMXTiledMap.__super__ = cc.spritenodes.CCSprite;
cc.tilemapparallaxnodes.CCTMXTiledMap.prototype = $extend(cc.spritenodes.CCSprite.prototype,{
	_tilesetForLayer: function(layerInfo,mapInfo) {
		var size = layerInfo._layerSize;
		var tilesets = mapInfo.getTilesets();
		if(tilesets != null) {
			var i = tilesets.length - 1;
			while(i >= 0) {
				var tileset = tilesets[i];
				if(tileset != null) {
					var _g1 = 0, _g = size.height | 0;
					while(_g1 < _g) {
						var y = _g1++;
						var _g3 = 0, _g2 = size.width | 0;
						while(_g3 < _g2) {
							var x = _g3++;
							var gid = layerInfo._tiles[(y * size.width | 0) + x];
							if(gid != 0) {
								if((gid & cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_FLIPPED_MASK) >>> 0 >= tileset.firstGid) return tileset;
							}
						}
					}
				}
				i--;
			}
		}
		return null;
	}
	,_parseLayer: function(layerInfo,mapInfo) {
		var tileset = this._tilesetForLayer(layerInfo,mapInfo);
		var layer = cc.tilemapparallaxnodes.CCTMXLayer.create(tileset,layerInfo,mapInfo);
		layer.setupTiles();
		return layer;
	}
	,_buildWithMapInfo: function(mapInfo) {
		this._mapSize = mapInfo.getMapSize();
		this._tileSize = mapInfo.getTileSize();
		this._mapOrientation = mapInfo.getOrientation();
		this._objectGroups = mapInfo.getObjectGroups();
		this._properties = mapInfo.getProperties();
		this._tileProperties = mapInfo.getTileProperties();
		var idx = 0;
		var layers = mapInfo.getLayers();
		if(layers != null) {
			var _g = 0;
			while(_g < layers.length) {
				var l = layers[_g];
				++_g;
				var child = this._parseLayer(l,mapInfo);
				child.setAnchorPoint(new flambe.math.Point(0,0));
				child.setPosition(0,0);
				this.addChild(child,idx,idx);
				idx++;
				var childSize = child.getContentSize();
				var currentSize = this.getContentSize();
				currentSize.width = Math.max(currentSize.width,childSize.width);
				currentSize.height = Math.max(currentSize.height,childSize.height);
				this.setContentSize(currentSize);
			}
		}
	}
	,initWithTMXFile: function(tmxFile,resourcePath) {
		cc.platform.CCCommon.assert(tmxFile != null && tmxFile.length > 0,"TMXTiledMap: tmx file should not be nil");
		this.setContentSize(new cc.cocoa.CCSize(0,0));
		var mapInfo = cc.tilemapparallaxnodes.CCTMXMapInfo.create(tmxFile,resourcePath);
		var _g = 0, _g1 = mapInfo.getLayers();
		while(_g < _g1.length) {
			var l = _g1[_g];
			++_g;
		}
		if(mapInfo == null) return false;
		cc.platform.CCCommon.assert(mapInfo.getTilesets().length != 0,"TMXTiledMap: Map not found. Please check the filename.");
		this._buildWithMapInfo(mapInfo);
		return true;
	}
	,__class__: cc.tilemapparallaxnodes.CCTMXTiledMap
});
cc.tilemapparallaxnodes.CCTMXXMLParser = function() { }
cc.tilemapparallaxnodes.CCTMXXMLParser.__name__ = true;
cc.tilemapparallaxnodes.CCTMXLayerInfo = function() {
	this._maxGID = 0;
	this._minGID = 100000;
	this.name = "";
	this.offset = new flambe.math.Point();
	this._properties = new haxe.ds.StringMap();
	this._tiles = new Array();
};
cc.tilemapparallaxnodes.CCTMXLayerInfo.__name__ = true;
cc.tilemapparallaxnodes.CCTMXLayerInfo.prototype = {
	setProperties: function(name,value) {
		this._properties.set(name,value);
	}
	,getProperties: function() {
		return this._properties;
	}
	,__class__: cc.tilemapparallaxnodes.CCTMXLayerInfo
}
cc.tilemapparallaxnodes.CCTMXTilesetInfo = function() {
	this.firstGid = 0;
	this.name = "";
	this._tileSize = new cc.cocoa.CCSize();
};
cc.tilemapparallaxnodes.CCTMXTilesetInfo.__name__ = true;
cc.tilemapparallaxnodes.CCTMXTilesetInfo.prototype = {
	rectForGID: function(gid) {
		var rect = new flambe.math.Rectangle();
		rect.width = this._tileSize.width;
		rect.height = this._tileSize.height;
		gid = gid - this.firstGid;
		var max_x = (this.imageSize.width - this.margin * 2 + this.spacing) / (this._tileSize.width + this.spacing);
		rect.x = gid % max_x * (this._tileSize.width + this.spacing) + this.margin;
		rect.y = (gid / max_x | 0) * (this._tileSize.height + this.spacing) + this.margin;
		return rect;
	}
	,__class__: cc.tilemapparallaxnodes.CCTMXTilesetInfo
}
cc.tilemapparallaxnodes.CCTMXMapInfo = function() {
	this._storingCharacters = false;
	this._tileProperties = new haxe.ds.IntMap();
	this._properties = new Array();
	this.pack = cc.CCLoader.pack;
};
cc.tilemapparallaxnodes.CCTMXMapInfo.__name__ = true;
cc.tilemapparallaxnodes.CCTMXMapInfo.csvToArray = function(input) {
	var result = new Array();
	var rows = input.split("\n");
	var row;
	var _g = 0;
	while(_g < rows.length) {
		var row1 = rows[_g];
		++_g;
		if(row1 == "") continue;
		var resultRow = new Array();
		var entries = row1.split(",");
		var entry;
		var _g1 = 0;
		while(_g1 < entries.length) {
			var entry1 = entries[_g1];
			++_g1;
			var t = Std.parseInt(entry1);
			if(t != null) result.push(t);
		}
	}
	return result;
}
cc.tilemapparallaxnodes.CCTMXMapInfo.create = function(tmxFile,resourcePath) {
	var ret = new cc.tilemapparallaxnodes.CCTMXMapInfo();
	ret.initWithTMXFile(tmxFile,resourcePath);
	return ret;
}
cc.tilemapparallaxnodes.CCTMXMapInfo.prototype = {
	_initernalInit: function(tmxFileName,resourcePath) {
		this._tileSets = new Array();
		this._layers = new Array();
		this._TMXFileName = tmxFileName;
		if(resourcePath != null) this._resources = resourcePath;
		this._objectGroups = new Array();
		this._currentString = "";
		this._storingCharacters = false;
		this._layerAttribs = cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_LAYER_ATTRIB_NONE;
		this._parentElement = cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_PROPERTY_NONE;
	}
	,getTileProperties: function() {
		return this._tileProperties;
	}
	,loadObjectGroup: function(xml) {
		var objectGroup = new cc.tilemapparallaxnodes.CCTMXObjectGroup();
		objectGroup.setGroupName(xml.get("name"));
		var x;
		var y;
		var xStr = xml.get("x");
		var yStr = xml.get("y");
		if(xStr == null) x = 0; else x = Std.parseFloat(xStr);
		if(yStr == null) y = 0; else y = Std.parseFloat(yStr);
		objectGroup.setPositionOffset(new flambe.math.Point(x * this.getTileSize().width,y * this.getTileSize().height));
		var $it0 = xml.elements();
		while( $it0.hasNext() ) {
			var elem = $it0.next();
			var object = new cc.tilemapparallaxnodes.CCTMXObject();
			var _g = elem.get_nodeName();
			switch(_g) {
			case "object":
				object.name = elem.get("name");
				object.type = elem.get("type");
				object.x = Std.parseInt(elem.get("x"));
				object.y = Std.parseInt(elem.get("y"));
				object.width = Std.parseInt(elem.get("width"));
				object.height = Std.parseInt(elem.get("height"));
				break;
			case "properties":
				object.properties.set(elem.get("name"),elem.get("value"));
				break;
			}
			objectGroup.setObjects(object);
		}
		this.setObjectGroups(objectGroup);
	}
	,loadLayerPros: function(xml,layer) {
		var $it0 = xml.elements();
		while( $it0.hasNext() ) {
			var elem = $it0.next();
			layer.setProperties(elem.get("name"),elem.get("value"));
		}
	}
	,loadData: function(xml,layer) {
		var encoding = xml.get("encoding");
		var compression = xml.get("compression");
		if(compression == null) compression = "";
		var isCompression = false;
		switch(compression) {
		case "gzip":
			layer._tiles = cc.platform.CCZipUtils.unzipBase64AsArray(xml.firstChild().get_nodeValue(),layer._layerSize.width | 0,4);
			break;
		case "zlib":
			layer._tiles = cc.platform.CCBase64.unzip(xml.firstChild().get_nodeValue(),layer._layerSize.width | 0);
			break;
		case "":
			if(encoding == "base64") layer._tiles = cc.platform.CCBase64.decodeAsArray(xml.firstChild().get_nodeValue(),layer._layerSize.width | 0); else if(encoding == "csv") layer._tiles = cc.tilemapparallaxnodes.CCTMXMapInfo.csvToArray(xml.firstChild().get_nodeValue()); else {
				var indexX = 0;
				var indexY = 0;
				var widthMap = this._mapSize.width;
				var heightMap = this._mapSize.height;
				var tilesRow = new Array();
				var $it0 = xml.elements();
				while( $it0.hasNext() ) {
					var elem = $it0.next();
					var _g = elem.get_nodeName();
					switch(_g) {
					case "tile":
						layer._tiles.push(Std.parseInt(elem.get("gid")));
						break;
					default:
						null;
					}
				}
			}
			break;
		default:
			null;
		}
	}
	,loadLayer: function(elem) {
		var layer = new cc.tilemapparallaxnodes.CCTMXLayerInfo();
		layer.name = elem.get("name");
		var layerSize = new cc.cocoa.CCSize();
		layerSize.width = Std.parseFloat(elem.get("width"));
		layerSize.height = Std.parseFloat(elem.get("height"));
		layer._layerSize = layerSize;
		var visible = elem.get("visible");
		if(visible == "0") layer.visible = false; else layer.visible = true;
		var opacity = elem.get("opacity");
		if(opacity == null) opacity = "1";
		layer._opacity = Std.parseInt(Std.string(255 * Std.parseFloat(opacity)));
		var x = elem.get("x");
		var y = elem.get("y");
		if(x == null) x = "0";
		if(y == null) y = "0";
		layer.offset = new flambe.math.Point(Std.parseFloat(x),Std.parseFloat(y));
		var nodeValue = "";
		var $it0 = elem.elements();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			var _g = e.get_nodeName();
			switch(_g) {
			case "data":
				this.loadData(e,layer);
				break;
			case "properties":
				this.loadLayerPros(e,layer);
				break;
			}
		}
		this.setLayers(layer);
	}
	,loadTileset: function(elem) {
		var tileset = new cc.tilemapparallaxnodes.CCTMXTilesetInfo();
		tileset.name = elem.get("name");
		tileset.firstGid = Std.parseInt(elem.get("firstgid"));
		var marginStr = elem.get("margin");
		if(marginStr == null) marginStr = "0";
		var spacingStr = elem.get("spacing");
		if(spacingStr == null) spacingStr = "0";
		tileset.margin = Std.parseInt(marginStr);
		tileset.spacing = Std.parseInt(spacingStr);
		var tilesetSize = new cc.cocoa.CCSize();
		tilesetSize.width = Std.parseFloat(elem.get("tilewidth"));
		tilesetSize.height = Std.parseFloat(elem.get("tileheight"));
		tileset._tileSize = tilesetSize;
		var $it0 = elem.elements();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			var _g = e.get_nodeName();
			switch(_g) {
			case "image":
				var imgSource = e.get("source");
				imgSource = imgSource.split(".")[0];
				if(imgSource != null) {
					if(this._resources != null) imgSource = this._resources + "/" + imgSource; else {
					}
				}
				tileset.sourceImage = imgSource;
				tileset.texture = this.pack.getTexture(tileset.sourceImage);
				tileset.sourceImageWidth = Std.parseFloat(e.get("width"));
				tileset.sourceImageHeight = Std.parseFloat(e.get("height"));
				tileset.imageSize = new cc.cocoa.CCSize(tileset.sourceImageWidth,tileset.sourceImageHeight);
				this.setTilesets(tileset);
				break;
			case "tile":
				var info = this._tileSets[0];
				var id = Std.parseInt(e.get("id"));
				if(id == null) id = 0;
				this.setParentGID(info.firstGid + id);
				var dict = new haxe.ds.StringMap();
				var $it1 = e.elements();
				while( $it1.hasNext() ) {
					var p = $it1.next();
					var _g1 = p.get_nodeName();
					switch(_g1) {
					case "properties":
						var name = p.get("name");
						var value = p.get("value");
						dict.set(name,value);
						break;
					}
				}
				this._tileProperties.set(this.getParentGID(),dict);
				break;
			default:
				null;
			}
		}
	}
	,loadProperties: function(elem) {
		var $it0 = elem.elements();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			var _g = e.get_nodeName();
			switch(_g) {
			case "property":
				var map = new haxe.ds.StringMap();
				var v = e.get("value");
				map.set(e.get("name"),v);
				v;
				this.setProperties(map);
				break;
			default:
				null;
			}
		}
	}
	,parseXMLFile: function(tmxFile) {
		var map = Xml.parse(cc.CCLoader.pack.getFile(tmxFile).toString()).firstElement();
		var version = map.get("version");
		var orientationStd = map.get("orientation");
		var mapSize = new cc.cocoa.CCSize();
		mapSize.width = Std.parseFloat(map.get("width"));
		mapSize.height = Std.parseFloat(map.get("height"));
		this.setMapSize(mapSize);
		mapSize = new cc.cocoa.CCSize();
		mapSize.width = Std.parseFloat(map.get("tilewidth"));
		mapSize.height = Std.parseFloat(map.get("tileheight"));
		this.setTileSize(mapSize);
		switch(orientationStd) {
		case "orthogonal":
			this.setOrientation(cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ORTHO);
			break;
		case "isometric":
			this.setOrientation(cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ISO);
			break;
		case "hexagonal":
			this.setOrientation(cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_HEX);
			break;
		default:
			cc.platform.CCCommon.log("cocos2d: TMXFomat: Unsupported orientation:" + this.getOrientation());
		}
		var $it0 = map.elements();
		while( $it0.hasNext() ) {
			var elem = $it0.next();
			var _g = elem.get_nodeName();
			switch(_g) {
			case "tileset":
				this.loadTileset(elem);
				break;
			case "layer":
				this.loadLayer(elem);
				break;
			case "objectgroup":
				this.loadObjectGroup(elem);
				break;
			case "properties":
				this.loadProperties(elem);
				break;
			}
		}
	}
	,initWithTMXFile: function(tmxFile,resourcePath) {
		this._initernalInit(tmxFile,resourcePath);
		return this.parseXMLFile(this._TMXFileName);
	}
	,setProperties: function(v) {
		this._properties.push(v);
	}
	,getProperties: function() {
		return this._properties;
	}
	,setParentGID: function(v) {
		this._parentGID = v;
	}
	,getParentGID: function() {
		return this._parentGID;
	}
	,setObjectGroups: function(v) {
		this._objectGroups.push(v);
	}
	,getObjectGroups: function() {
		return this._objectGroups;
	}
	,setTilesets: function(v) {
		this._tileSets.push(v);
	}
	,getTilesets: function() {
		return this._tileSets;
	}
	,setLayers: function(v) {
		this._layers.push(v);
	}
	,getLayers: function() {
		return this._layers;
	}
	,setTileSize: function(v) {
		this._tileSize = v;
	}
	,getTileSize: function() {
		return this._tileSize;
	}
	,setMapSize: function(v) {
		this._mapSize = v;
	}
	,getMapSize: function() {
		return this._mapSize;
	}
	,setOrientation: function(v) {
		this._orientation = v;
	}
	,getOrientation: function() {
		return this._orientation;
	}
	,__class__: cc.tilemapparallaxnodes.CCTMXMapInfo
}
cc.touchdispatcher.CCPointer = function(x,y,id) {
	if(id == null) id = 0;
	this._point = new flambe.math.Point(x,y);
	this._prevPoint = new flambe.math.Point(0,0);
	this._id = id;
};
cc.touchdispatcher.CCPointer.__name__ = true;
cc.touchdispatcher.CCPointer.prototype = {
	_setPrevPoint: function(x,y) {
		this._prevPoint = new flambe.math.Point(x,y);
	}
	,getLocation: function() {
		return this._point;
	}
	,__class__: cc.touchdispatcher.CCPointer
}
cc.touchdispatcher.CCPointerDispatcher = function() {
	this._dispatchEvents = true;
	this._pointerPressed = false;
	this._pointerDelegateHandlers = new Array();
	cc.touchdispatcher.CCPointerDispatcher._registerPointerEvent();
};
cc.touchdispatcher.CCPointerDispatcher.__name__ = true;
cc.touchdispatcher.CCPointerDispatcher.getPointerByEvent = function(event) {
	var tx = event.viewX;
	var ty = event.viewY;
	var pointer = new cc.touchdispatcher.CCPointer(tx,ty);
	pointer._setPrevPoint(cc.touchdispatcher.CCPointerDispatcher._prePoint.x,cc.touchdispatcher.CCPointerDispatcher._prePoint.y);
	cc.touchdispatcher.CCPointerDispatcher._prePoint.x = tx;
	cc.touchdispatcher.CCPointerDispatcher._prePoint.y = ty;
	return pointer;
}
cc.touchdispatcher.CCPointerDispatcher._registerPointerEvent = function() {
	flambe.System._platform.getPointer().down.connect(function(event) {
		cc.CCDirector.getInstance().getPointerDispatcher()._setPointerPressed(true);
		cc.CCDirector.getInstance().getPointerDispatcher().pointerHandle(cc.touchdispatcher.CCPointerDispatcher.getPointerByEvent(event),event,cc.touchdispatcher.CCPointerDispatcher.POINTER_DOWN);
	});
	flambe.System._platform.getPointer().up.connect(function(event) {
		cc.CCDirector.getInstance().getPointerDispatcher()._setPointerPressed(false);
		cc.CCDirector.getInstance().getPointerDispatcher().pointerHandle(cc.touchdispatcher.CCPointerDispatcher.getPointerByEvent(event),event,cc.touchdispatcher.CCPointerDispatcher.POINTER_UP);
	});
	flambe.System._platform.getPointer().move.connect(function(event) {
		cc.CCDirector.getInstance().getPointerDispatcher().pointerHandle(cc.touchdispatcher.CCPointerDispatcher.getPointerByEvent(event),event,cc.touchdispatcher.CCPointerDispatcher.POINTER_MOVED);
	});
}
cc.touchdispatcher.CCPointerDispatcher.prototype = {
	pointerHandle: function(pointerObj,event,index) {
		var a = 0;
		var b = 3;
		var c = 1;
		var b1 = false;
		var _g = 0, _g1 = this._pointerDelegateHandlers;
		while(_g < _g1.length) {
			var h = _g1[_g];
			++_g;
			switch(index) {
			case 0:
				Reflect.field(h.getDelegate(),"onPointerDown").apply(h.getDelegate(),[pointerObj]);
				break;
			case 3:
				Reflect.field(h.getDelegate(),"onPointerUp").apply(h.getDelegate(),[pointerObj]);
				break;
			case 1:
				if(this._pointerPressed) Reflect.field(h.getDelegate(),"onPointerDragged").apply(h.getDelegate(),[pointerObj]); else if(Reflect.field(h.getDelegate(),"onPointerMoved") == null) null; else Reflect.field(h.getDelegate(),"onPointerMoved").apply(h.getDelegate(),[pointerObj]);
				break;
			}
			if(b1) return;
		}
	}
	,removePointerDelegate: function(delegate) {
		if(delegate == null) return;
		var _g1 = 0, _g = this._pointerDelegateHandlers.length;
		while(_g1 < _g) {
			var i = _g1++;
			var handler = this._pointerDelegateHandlers[i];
			if(handler != null && handler.getDelegate() == delegate) {
				cc.CCScheduler.ArrayRemoveObject_cc_touchdispatcher_CCPointerHandler(this._pointerDelegateHandlers,handler);
				break;
			}
		}
	}
	,forceAddHandler: function(handler,array) {
		var u = 0;
		var _g1 = 0, _g = array.length;
		while(_g1 < _g) {
			var i = _g1++;
			var h = array[i];
			if(h != null) {
				if(h.getPriority() < handler.getPriority()) ++u;
			}
			if(h.getDelegate() == handler.getDelegate()) return array;
		}
		return cc.CCScheduler.ArrayAppendObjectToIndex_cc_touchdispatcher_CCPointerHandler(array,handler,u);
	}
	,addPointerDelegate: function(delegate,priority) {
		var handler = cc.touchdispatcher.CCPointerHandler.create(delegate,priority);
		this._pointerDelegateHandlers = this.forceAddHandler(handler,this._pointerDelegateHandlers);
	}
	,_setPointerPressed: function(pressed) {
		this._pointerPressed = pressed;
	}
	,__class__: cc.touchdispatcher.CCPointerDispatcher
}
cc.touchdispatcher.CCPointerHandler = function() {
	this._priority = 0;
};
cc.touchdispatcher.CCPointerHandler.__name__ = true;
cc.touchdispatcher.CCPointerHandler.create = function(delegate,priority) {
	var handler = new cc.touchdispatcher.CCPointerHandler();
	handler.initWithDelegate(delegate,priority);
	return handler;
}
cc.touchdispatcher.CCPointerHandler.prototype = {
	initWithDelegate: function(delegate,priority) {
		this._delegate = delegate;
		this._priority = priority;
		this._claimedPointers = new Array();
	}
	,getPriority: function() {
		return this._priority;
	}
	,getDelegate: function() {
		return this._delegate;
	}
	,__class__: cc.touchdispatcher.CCPointerHandler
}
flambe.Entity = function() {
	this.zOrder = 0;
	this.firstComponent = null;
	this.next = null;
	this.firstChild = null;
	this.parent = null;
	this._compMap = { };
};
flambe.Entity.__name__ = true;
flambe.Entity.__interfaces__ = [flambe.util.Disposable];
flambe.Entity.prototype = {
	dispose: function() {
		if(this.parent != null) this.parent.removeChild(this);
		while(this.firstComponent != null) this.firstComponent.dispose();
		this.disposeChildren();
	}
	,disposeChildren: function() {
		while(this.firstChild != null) this.firstChild.dispose();
	}
	,removeChild: function(entity) {
		var prev = null, p = this.firstChild;
		while(p != null) {
			var next = p.next;
			if(p == entity) {
				if(prev == null) this.firstChild = next; else prev.next = next;
				p.parent = null;
				p.next = null;
				return;
			}
			prev = p;
			p = next;
		}
	}
	,addChild: function(entity,append,zOrder) {
		if(append == null) append = true;
		if(entity.parent != null) entity.parent.removeChild(entity);
		entity.parent = this;
		if(append) {
			var tail = null, p = this.firstChild;
			while(p != null) {
				tail = p;
				p = p.next;
			}
			if(tail != null) {
				if(zOrder == null) zOrder = tail.zOrder;
				if(tail.zOrder <= zOrder) tail.next = entity; else {
					var p1 = this.firstChild;
					var pre = null;
					while(p1 != null) if(p1.zOrder > zOrder) {
						if(pre != null) {
							pre.next = entity;
							entity.next = p1;
						} else {
							entity.next = this.firstChild;
							this.firstChild = entity;
						}
						break;
					} else {
						pre = p1;
						p1 = p1.next;
					}
				}
			} else {
				this.firstChild = entity;
				if(zOrder == null) zOrder = 0;
			}
		} else {
			if(this.firstChild == null) zOrder = 0; else zOrder = this.firstChild.zOrder - 1;
			entity.next = this.firstChild;
			this.firstChild = entity;
		}
		entity.zOrder = zOrder;
		return this;
	}
	,remove: function(component) {
		var prev = null, p = this.firstComponent;
		while(p != null) {
			var next = p.next;
			if(p == component) {
				if(prev == null) this.firstComponent = next; else prev.init(this,next);
				delete(this._compMap[p.get_name()]);
				p.onRemoved();
				p.init(null,null);
				return true;
			}
			prev = p;
			p = next;
		}
		return false;
	}
	,add: function(component) {
		if(component.owner != null) component.owner.remove(component);
		var name = component.get_name();
		var prev = this._compMap[name];
		if(prev != null) this.remove(prev);
		this._compMap[name] = component;
		var tail = null, p = this.firstComponent;
		while(p != null) {
			tail = p;
			p = p.next;
		}
		if(tail != null) tail.next = component; else this.firstComponent = component;
		component.init(this,null);
		component.onAdded();
		return this;
	}
	,__class__: flambe.Entity
}
flambe.platform = {}
flambe.platform.Platform = function() { }
flambe.platform.Platform.__name__ = true;
flambe.platform.Platform.prototype = {
	__class__: flambe.platform.Platform
}
flambe.platform.html = {}
flambe.platform.html.HtmlPlatform = function() {
};
flambe.platform.html.HtmlPlatform.__name__ = true;
flambe.platform.html.HtmlPlatform.__interfaces__ = [flambe.platform.Platform];
flambe.platform.html.HtmlPlatform.prototype = {
	createRenderer: function(canvas) {
		try {
			var gl = js.html._CanvasElement.CanvasUtil.getContextWebGL(canvas,{ alpha : false, depth : false});
			if(gl != null) {
				if(flambe.platform.html.HtmlUtil.detectSlowDriver(gl)) null; else return new flambe.platform.html.WebGLRenderer(this._stage,gl);
			}
		} catch( _ ) {
		}
		return new flambe.platform.html.CanvasRenderer(canvas);
		return null;
	}
	,getY: function(event,bounds) {
		return this._stage.scaleFactor * (event.clientY - bounds.top);
	}
	,getX: function(event,bounds) {
		return this._stage.scaleFactor * (event.clientX - bounds.left);
	}
	,getRenderer: function() {
		return this._renderer;
	}
	,getKeyboard: function() {
		var _g = this;
		if(this._keyboard == null) {
			this._keyboard = new flambe.platform.BasicKeyboard();
			var onKey = function(event) {
				switch(event.type) {
				case "keydown":
					if(_g._keyboard.submitDown(event.keyCode)) event.preventDefault();
					break;
				case "keyup":
					_g._keyboard.submitUp(event.keyCode);
					break;
				}
			};
			this._canvas.addEventListener("keydown",onKey,false);
			this._canvas.addEventListener("keyup",onKey,false);
		}
		return this._keyboard;
	}
	,getPointer: function() {
		return this._pointer;
	}
	,update: function(now) {
		var dt = (now - this._lastUpdate) / 1000;
		this._lastUpdate = now;
		if(flambe.System.hidden._value) return;
		if(this._skipFrame) {
			this._skipFrame = false;
			return;
		}
		this.mainLoop.update(dt);
		this.mainLoop.render(this._renderer);
	}
	,getStage: function() {
		return this._stage;
	}
	,loadAssetPack: function(manifest) {
		return new flambe.platform.html.HtmlAssetPackLoader(this,manifest).promise;
	}
	,init: function() {
		var _g = this;
		flambe.platform.html.HtmlUtil.fixAndroidMath();
		var canvas = null;
		try {
			canvas = js.Browser.window.flambe.canvas;
		} catch( error ) {
		}
		canvas.setAttribute("tabindex","0");
		canvas.style.outlineStyle = "none";
		canvas.setAttribute("moz-opaque","true");
		this._stage = new flambe.platform.html.HtmlStage(canvas);
		this._pointer = new flambe.platform.BasicPointer();
		this._mouse = new flambe.platform.html.HtmlMouse(this._pointer,canvas);
		this._renderer = this.createRenderer(canvas);
		this.mainLoop = new flambe.platform.MainLoop();
		this._canvas = canvas;
		this._container = canvas.parentElement;
		this._container.style.overflow = "hidden";
		this._container.style.position = "relative";
		this._container.style.msTouchAction = "none";
		var lastTouchTime = 0;
		var onMouse = function(event) {
			if(event.timeStamp - lastTouchTime < 1000) return;
			var bounds = canvas.getBoundingClientRect();
			var x = _g.getX(event,bounds);
			var y = _g.getY(event,bounds);
			switch(event.type) {
			case "mousedown":
				if(event.target == canvas) {
					event.preventDefault();
					_g._mouse.submitDown(x,y,event.button);
					canvas.focus();
				}
				break;
			case "mousemove":
				_g._mouse.submitMove(x,y);
				break;
			case "mouseup":
				_g._mouse.submitUp(x,y,event.button);
				break;
			case "mousewheel":case "DOMMouseScroll":
				var velocity = event.type == "mousewheel"?event.wheelDelta / 40:-event.detail;
				if(_g._mouse.submitScroll(x,y,velocity)) event.preventDefault();
				break;
			}
		};
		js.Browser.window.addEventListener("mousedown",onMouse,false);
		js.Browser.window.addEventListener("mousemove",onMouse,false);
		js.Browser.window.addEventListener("mouseup",onMouse,false);
		canvas.addEventListener("mousewheel",onMouse,false);
		canvas.addEventListener("DOMMouseScroll",onMouse,false);
		var standardTouch = typeof(js.Browser.window.ontouchstart) != "undefined";
		var msTouch = 'msMaxTouchPoints' in window.navigator && (window.navigator.msMaxTouchPoints > 1);
		if(standardTouch || msTouch) {
			var basicTouch = new flambe.platform.BasicTouch(this._pointer,standardTouch?4:js.Browser.navigator.msMaxTouchPoints);
			this._touch = basicTouch;
			var onTouch = function(event) {
				var changedTouches = standardTouch?event.changedTouches:[event];
				var bounds = event.target.getBoundingClientRect();
				lastTouchTime = event.timeStamp;
				switch(event.type) {
				case "touchstart":case "MSPointerDown":
					event.preventDefault();
					if(flambe.platform.html.HtmlUtil.SHOULD_HIDE_MOBILE_BROWSER) flambe.platform.html.HtmlUtil.hideMobileBrowser();
					var _g1 = 0;
					while(_g1 < changedTouches.length) {
						var touch = changedTouches[_g1];
						++_g1;
						var x = _g.getX(touch,bounds);
						var y = _g.getY(touch,bounds);
						var id = (standardTouch?touch.identifier:touch.pointerId) | 0;
						basicTouch.submitDown(id,x,y);
					}
					break;
				case "touchmove":case "MSPointerMove":
					event.preventDefault();
					var _g1 = 0;
					while(_g1 < changedTouches.length) {
						var touch = changedTouches[_g1];
						++_g1;
						var x = _g.getX(touch,bounds);
						var y = _g.getY(touch,bounds);
						var id = (standardTouch?touch.identifier:touch.pointerId) | 0;
						basicTouch.submitMove(id,x,y);
					}
					break;
				case "touchend":case "touchcancel":case "MSPointerUp":
					var _g1 = 0;
					while(_g1 < changedTouches.length) {
						var touch = changedTouches[_g1];
						++_g1;
						var x = _g.getX(touch,bounds);
						var y = _g.getY(touch,bounds);
						var id = (standardTouch?touch.identifier:touch.pointerId) | 0;
						basicTouch.submitUp(id,x,y);
					}
					break;
				}
			};
			if(standardTouch) {
				canvas.addEventListener("touchstart",onTouch,false);
				canvas.addEventListener("touchmove",onTouch,false);
				canvas.addEventListener("touchend",onTouch,false);
				canvas.addEventListener("touchcancel",onTouch,false);
			} else {
				canvas.addEventListener("MSPointerDown",onTouch,false);
				canvas.addEventListener("MSPointerMove",onTouch,false);
				canvas.addEventListener("MSPointerUp",onTouch,false);
			}
		} else this._touch = new flambe.platform.DummyTouch();
		var oldErrorHandler = js.Browser.window.onerror;
		js.Browser.window.onerror = function(message,url,line) {
			flambe.System.uncaughtError.emit1(message);
			return oldErrorHandler != null?oldErrorHandler(message,url,line):false;
		};
		var hiddenApi = flambe.platform.html.HtmlUtil.loadExtension("hidden",js.Browser.document);
		if(hiddenApi.value != null) {
			var onVisibilityChanged = function(_) {
				flambe.System.hidden.set__(Reflect.field(js.Browser.document,hiddenApi.field));
			};
			onVisibilityChanged(null);
			js.Browser.document.addEventListener(hiddenApi.prefix + "visibilitychange",onVisibilityChanged,false);
		} else {
			var onPageTransitionChange = function(event) {
				flambe.System.hidden.set__(event.type == "pagehide");
			};
			js.Browser.window.addEventListener("pageshow",onPageTransitionChange,false);
			js.Browser.window.addEventListener("pagehide",onPageTransitionChange,false);
		}
		flambe.System.hidden.get_changed().connect(function(hidden,_) {
			if(!hidden) _g._skipFrame = true;
		});
		this._skipFrame = false;
		this._lastUpdate = Date.now();
		var requestAnimationFrame = flambe.platform.html.HtmlUtil.loadExtension("requestAnimationFrame").value;
		if(requestAnimationFrame != null) {
			var performance = js.Browser.window.performance;
			var hasPerfNow = performance != null && flambe.platform.html.HtmlUtil.polyfill("now",performance);
			if(hasPerfNow) this._lastUpdate = performance.now(); else null;
			var updateFrame = null;
			updateFrame = function(now) {
				_g.update(hasPerfNow?performance.now():now);
				requestAnimationFrame(updateFrame,canvas);
			};
			requestAnimationFrame(updateFrame,canvas);
		} else js.Browser.window.setInterval(function() {
			_g.update(Date.now());
		},16);
		null;
	}
	,__class__: flambe.platform.html.HtmlPlatform
}
flambe.util.Value = function(value,listener) {
	this._value = value;
	if(listener != null) this._changed = new flambe.util.Signal2(listener);
};
flambe.util.Value.__name__ = true;
flambe.util.Value.prototype = {
	get_changed: function() {
		if(this._changed == null) this._changed = new flambe.util.Signal2();
		return this._changed;
	}
	,set__: function(newValue) {
		var oldValue = this._value;
		if(newValue != oldValue) {
			this._value = newValue;
			if(this._changed != null) this._changed.emit2(newValue,oldValue);
		}
		return newValue;
	}
	,watch: function(listener) {
		listener(this._value,this._value);
		return this.get_changed().connect(listener);
	}
	,__class__: flambe.util.Value
}
flambe.util.SignalConnection = function(signal,listener) {
	this._next = null;
	this._signal = signal;
	this._listener = listener;
	this.stayInList = true;
};
flambe.util.SignalConnection.__name__ = true;
flambe.util.SignalConnection.__interfaces__ = [flambe.util.Disposable];
flambe.util.SignalConnection.prototype = {
	dispose: function() {
		if(this._signal != null) {
			this._signal.disconnect(this);
			this._signal = null;
		}
	}
	,once: function() {
		this.stayInList = false;
		return this;
	}
	,__class__: flambe.util.SignalConnection
}
flambe.util.SignalBase = function(listener) {
	this._head = listener != null?new flambe.util.SignalConnection(this,listener):null;
	this._deferredTasks = null;
};
flambe.util.SignalBase.__name__ = true;
flambe.util.SignalBase.prototype = {
	listRemove: function(conn) {
		var prev = null, p = this._head;
		while(p != null) {
			if(p == conn) {
				var next = p._next;
				if(prev == null) this._head = next; else prev._next = next;
				return;
			}
			prev = p;
			p = p._next;
		}
	}
	,listAdd: function(conn,prioritize) {
		if(prioritize) {
			conn._next = this._head;
			this._head = conn;
		} else {
			var tail = null, p = this._head;
			while(p != null) {
				tail = p;
				p = p._next;
			}
			if(tail != null) tail._next = conn; else this._head = conn;
		}
	}
	,didEmit: function(head) {
		this._head = head;
		while(this._deferredTasks != null) {
			this._deferredTasks.fn();
			this._deferredTasks = this._deferredTasks.next;
		}
	}
	,willEmit: function() {
		var snapshot = this._head;
		this._head = flambe.util.SignalBase.DISPATCHING_SENTINEL;
		return snapshot;
	}
	,defer: function(fn) {
		var tail = null, p = this._deferredTasks;
		while(p != null) {
			tail = p;
			p = p.next;
		}
		var task = new flambe.util._SignalBase.Task(fn);
		if(tail != null) tail.next = task; else this._deferredTasks = task;
	}
	,emit2: function(arg1,arg2) {
		var head = this.willEmit();
		var p = head;
		while(p != null) {
			p._listener(arg1,arg2);
			if(!p.stayInList) p.dispose();
			p = p._next;
		}
		this.didEmit(head);
	}
	,emit1: function(arg1) {
		var head = this.willEmit();
		var p = head;
		while(p != null) {
			p._listener(arg1);
			if(!p.stayInList) p.dispose();
			p = p._next;
		}
		this.didEmit(head);
	}
	,emit0: function() {
		var head = this.willEmit();
		var p = head;
		while(p != null) {
			p._listener();
			if(!p.stayInList) p.dispose();
			p = p._next;
		}
		this.didEmit(head);
	}
	,disconnect: function(conn) {
		var _g = this;
		if(this._head == flambe.util.SignalBase.DISPATCHING_SENTINEL) this.defer(function() {
			_g.listRemove(conn);
		}); else this.listRemove(conn);
	}
	,connectImpl: function(listener,prioritize) {
		var _g = this;
		var conn = new flambe.util.SignalConnection(this,listener);
		if(this._head == flambe.util.SignalBase.DISPATCHING_SENTINEL) this.defer(function() {
			_g.listAdd(conn,prioritize);
		}); else this.listAdd(conn,prioritize);
		return conn;
	}
	,__class__: flambe.util.SignalBase
}
flambe.util.Signal2 = function(listener) {
	flambe.util.SignalBase.call(this,listener);
};
flambe.util.Signal2.__name__ = true;
flambe.util.Signal2.__super__ = flambe.util.SignalBase;
flambe.util.Signal2.prototype = $extend(flambe.util.SignalBase.prototype,{
	connect: function(listener,prioritize) {
		if(prioritize == null) prioritize = false;
		return this.connectImpl(listener,prioritize);
	}
	,__class__: flambe.util.Signal2
});
flambe.util.Signal1 = function(listener) {
	flambe.util.SignalBase.call(this,listener);
};
flambe.util.Signal1.__name__ = true;
flambe.util.Signal1.__super__ = flambe.util.SignalBase;
flambe.util.Signal1.prototype = $extend(flambe.util.SignalBase.prototype,{
	connect: function(listener,prioritize) {
		if(prioritize == null) prioritize = false;
		return this.connectImpl(listener,prioritize);
	}
	,__class__: flambe.util.Signal1
});
flambe.animation = {}
flambe.animation.AnimatedFloat = function(value,listener) {
	flambe.util.Value.call(this,value,listener);
};
flambe.animation.AnimatedFloat.__name__ = true;
flambe.animation.AnimatedFloat.__super__ = flambe.util.Value;
flambe.animation.AnimatedFloat.prototype = $extend(flambe.util.Value.prototype,{
	set_behavior: function(behavior) {
		this._behavior = behavior;
		this.update(0);
		return behavior;
	}
	,animateBy: function(by,seconds,easing) {
		this.set_behavior(new flambe.animation.Tween(this._value,this._value + by,seconds,easing));
	}
	,update: function(dt) {
		if(this._behavior != null) {
			flambe.util.Value.prototype.set__.call(this,this._behavior.update(dt));
			if(this._behavior.isComplete()) this._behavior = null;
		}
	}
	,set__: function(value) {
		this._behavior = null;
		return flambe.util.Value.prototype.set__.call(this,value);
	}
	,__class__: flambe.animation.AnimatedFloat
});
flambe.System = function() { }
flambe.System.__name__ = true;
flambe.System.init = function() {
	if(!flambe.System._calledInit) {
		flambe.System._platform.init();
		flambe.System._calledInit = true;
	}
}
flambe.SpeedAdjuster = function() {
	this._realDt = 0;
};
flambe.SpeedAdjuster.__name__ = true;
flambe.SpeedAdjuster.__super__ = flambe.Component;
flambe.SpeedAdjuster.prototype = $extend(flambe.Component.prototype,{
	onUpdate: function(dt) {
		if(this._realDt > 0) {
			dt = this._realDt;
			this._realDt = 0;
		}
		this.scale.update(dt);
	}
	,get_name: function() {
		return "SpeedAdjuster_6";
	}
	,__class__: flambe.SpeedAdjuster
});
flambe.animation.Behavior = function() { }
flambe.animation.Behavior.__name__ = true;
flambe.animation.Behavior.prototype = {
	__class__: flambe.animation.Behavior
}
flambe.animation.Ease = function() { }
flambe.animation.Ease.__name__ = true;
flambe.animation.Ease.linear = function(t) {
	return t;
}
flambe.animation.Tween = function(from,to,seconds,easing) {
	this._from = from;
	this._to = to;
	this._duration = seconds;
	this.elapsed = 0;
	this._easing = easing != null?easing:flambe.animation.Ease.linear;
};
flambe.animation.Tween.__name__ = true;
flambe.animation.Tween.__interfaces__ = [flambe.animation.Behavior];
flambe.animation.Tween.prototype = {
	isComplete: function() {
		return this.elapsed >= this._duration;
	}
	,update: function(dt) {
		this.elapsed += dt;
		if(this.elapsed >= this._duration) return this._to; else return this._from + (this._to - this._from) * this._easing(this.elapsed / this._duration);
	}
	,__class__: flambe.animation.Tween
}
flambe.asset = {}
flambe.asset.Asset = function() { }
flambe.asset.Asset.__name__ = true;
flambe.asset.Asset.__interfaces__ = [flambe.util.Disposable];
flambe.asset.Asset.prototype = {
	__class__: flambe.asset.Asset
}
flambe.asset.AssetFormat = { __ename__ : true, __constructs__ : ["WEBP","JXR","PNG","JPG","GIF","DDS","PVR","PKM","MP3","M4A","OPUS","OGG","WAV","Data"] }
flambe.asset.AssetFormat.WEBP = ["WEBP",0];
flambe.asset.AssetFormat.WEBP.toString = $estr;
flambe.asset.AssetFormat.WEBP.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.JXR = ["JXR",1];
flambe.asset.AssetFormat.JXR.toString = $estr;
flambe.asset.AssetFormat.JXR.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.PNG = ["PNG",2];
flambe.asset.AssetFormat.PNG.toString = $estr;
flambe.asset.AssetFormat.PNG.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.JPG = ["JPG",3];
flambe.asset.AssetFormat.JPG.toString = $estr;
flambe.asset.AssetFormat.JPG.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.GIF = ["GIF",4];
flambe.asset.AssetFormat.GIF.toString = $estr;
flambe.asset.AssetFormat.GIF.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.DDS = ["DDS",5];
flambe.asset.AssetFormat.DDS.toString = $estr;
flambe.asset.AssetFormat.DDS.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.PVR = ["PVR",6];
flambe.asset.AssetFormat.PVR.toString = $estr;
flambe.asset.AssetFormat.PVR.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.PKM = ["PKM",7];
flambe.asset.AssetFormat.PKM.toString = $estr;
flambe.asset.AssetFormat.PKM.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.MP3 = ["MP3",8];
flambe.asset.AssetFormat.MP3.toString = $estr;
flambe.asset.AssetFormat.MP3.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.M4A = ["M4A",9];
flambe.asset.AssetFormat.M4A.toString = $estr;
flambe.asset.AssetFormat.M4A.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.OPUS = ["OPUS",10];
flambe.asset.AssetFormat.OPUS.toString = $estr;
flambe.asset.AssetFormat.OPUS.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.OGG = ["OGG",11];
flambe.asset.AssetFormat.OGG.toString = $estr;
flambe.asset.AssetFormat.OGG.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.WAV = ["WAV",12];
flambe.asset.AssetFormat.WAV.toString = $estr;
flambe.asset.AssetFormat.WAV.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetFormat.Data = ["Data",13];
flambe.asset.AssetFormat.Data.toString = $estr;
flambe.asset.AssetFormat.Data.__enum__ = flambe.asset.AssetFormat;
flambe.asset.AssetEntry = function(name,url,format,bytes) {
	this.name = name;
	this.url = url;
	this.format = format;
	this.bytes = bytes;
};
flambe.asset.AssetEntry.__name__ = true;
flambe.asset.AssetEntry.prototype = {
	__class__: flambe.asset.AssetEntry
}
flambe.asset.AssetPack = function() { }
flambe.asset.AssetPack.__name__ = true;
flambe.asset.AssetPack.__interfaces__ = [flambe.util.Disposable];
flambe.asset.AssetPack.prototype = {
	__class__: flambe.asset.AssetPack
}
flambe.asset.File = function() { }
flambe.asset.File.__name__ = true;
flambe.asset.File.__interfaces__ = [flambe.asset.Asset];
flambe.asset.File.prototype = {
	__class__: flambe.asset.File
}
var js = {}
js.Browser = function() { }
js.Browser.__name__ = true;
flambe.asset.Manifest = function() {
	this._entries = [];
};
flambe.asset.Manifest.__name__ = true;
flambe.asset.Manifest.build = function(packName,required) {
	if(required == null) required = true;
	var packData = Reflect.field(haxe.rtti.Meta.getType(flambe.asset.Manifest).assets[0],packName);
	if(packData == null) {
		if(required) throw flambe.util.Strings.withFields("Missing asset pack",["name",packName]);
		return null;
	}
	var manifest = new flambe.asset.Manifest();
	manifest.set_relativeBasePath("assets");
	var _g = 0;
	while(_g < packData.length) {
		var asset = packData[_g];
		++_g;
		var name = asset.name;
		var path = packName + "/" + name + "?v=" + Std.string(asset.md5);
		var format = flambe.asset.Manifest.inferFormat(name);
		if(format != flambe.asset.AssetFormat.Data) name = flambe.util.Strings.removeFileExtension(name);
		manifest.add(name,path,asset.bytes,format);
	}
	return manifest;
}
flambe.asset.Manifest.inferFormat = function(url) {
	var extension = flambe.util.Strings.getUrlExtension(url);
	if(extension != null) {
		var _g = extension.toLowerCase();
		switch(_g) {
		case "gif":
			return flambe.asset.AssetFormat.GIF;
		case "jpg":case "jpeg":
			return flambe.asset.AssetFormat.JPG;
		case "jxr":case "wdp":
			return flambe.asset.AssetFormat.JXR;
		case "png":
			return flambe.asset.AssetFormat.PNG;
		case "webp":
			return flambe.asset.AssetFormat.WEBP;
		case "dds":
			return flambe.asset.AssetFormat.DDS;
		case "pvr":
			return flambe.asset.AssetFormat.PVR;
		case "pkm":
			return flambe.asset.AssetFormat.PKM;
		case "m4a":
			return flambe.asset.AssetFormat.M4A;
		case "mp3":
			return flambe.asset.AssetFormat.MP3;
		case "ogg":
			return flambe.asset.AssetFormat.OGG;
		case "opus":
			return flambe.asset.AssetFormat.OPUS;
		case "wav":
			return flambe.asset.AssetFormat.WAV;
		}
	} else null;
	return flambe.asset.AssetFormat.Data;
}
flambe.asset.Manifest.prototype = {
	get_externalBasePath: function() {
		return this._externalBasePath;
	}
	,set_relativeBasePath: function(basePath) {
		this._relativeBasePath = basePath;
		if(basePath != null) null;
		return basePath;
	}
	,get_relativeBasePath: function() {
		return this._relativeBasePath;
	}
	,getFullURL: function(entry) {
		var restricted = this.get_externalBasePath() != null && flambe.asset.Manifest._supportsCrossOrigin?this.get_externalBasePath():this.get_relativeBasePath();
		var unrestricted = this.get_externalBasePath() != null?this.get_externalBasePath():this.get_relativeBasePath();
		var base = unrestricted;
		if(entry.format == flambe.asset.AssetFormat.Data) base = restricted;
		return base != null?flambe.util.Strings.joinPath(base,entry.url):entry.url;
	}
	,iterator: function() {
		return HxOverrides.iter(this._entries);
	}
	,add: function(name,url,bytes,format) {
		if(bytes == null) bytes = 0;
		if(format == null) format = flambe.asset.Manifest.inferFormat(url);
		var entry = new flambe.asset.AssetEntry(name,url,format,bytes);
		this._entries.push(entry);
		return entry;
	}
	,__class__: flambe.asset.Manifest
}
flambe.display.BlendMode = { __ename__ : true, __constructs__ : ["Normal","Add","Mask","Copy"] }
flambe.display.BlendMode.Normal = ["Normal",0];
flambe.display.BlendMode.Normal.toString = $estr;
flambe.display.BlendMode.Normal.__enum__ = flambe.display.BlendMode;
flambe.display.BlendMode.Add = ["Add",1];
flambe.display.BlendMode.Add.toString = $estr;
flambe.display.BlendMode.Add.__enum__ = flambe.display.BlendMode;
flambe.display.BlendMode.Mask = ["Mask",2];
flambe.display.BlendMode.Mask.toString = $estr;
flambe.display.BlendMode.Mask.__enum__ = flambe.display.BlendMode;
flambe.display.BlendMode.Copy = ["Copy",3];
flambe.display.BlendMode.Copy.toString = $estr;
flambe.display.BlendMode.Copy.__enum__ = flambe.display.BlendMode;
flambe.display.Glyph = function(charCode) {
	this._kernings = null;
	this.xAdvance = 0;
	this.yOffset = 0;
	this.xOffset = 0;
	this.page = null;
	this.height = 0;
	this.width = 0;
	this.y = 0;
	this.x = 0;
	this.charCode = charCode;
};
flambe.display.Glyph.__name__ = true;
flambe.display.Glyph.prototype = {
	setKerning: function(nextCharCode,amount) {
		if(this._kernings == null) this._kernings = new haxe.ds.IntMap();
		this._kernings.set(nextCharCode,amount);
	}
	,getKerning: function(nextCharCode) {
		return this._kernings != null?this._kernings.get(nextCharCode) | 0:0;
	}
	,draw: function(g,destX,destY) {
		if(this.width > 0) g.drawSubImage(this.page,destX + this.xOffset,destY + this.yOffset,this.x,this.y,this.width,this.height);
	}
	,__class__: flambe.display.Glyph
}
flambe.display.Font = function(pack,name) {
	this.name = name;
	this._pack = pack;
	this.reload();
};
flambe.display.Font.__name__ = true;
flambe.display.Font.prototype = {
	reload: function() {
		this._glyphs = new haxe.ds.IntMap();
		this._glyphs.set(flambe.display.Font.NEWLINE.charCode,flambe.display.Font.NEWLINE);
		var parser = new flambe.display._Font.ConfigParser(this._pack.getFile(this.name + ".fnt").toString());
		var pages = new haxe.ds.IntMap();
		var idx = this.name.lastIndexOf("/");
		var basePath = idx >= 0?HxOverrides.substr(this.name,0,idx + 1):"";
		var $it0 = parser.keywords();
		while( $it0.hasNext() ) {
			var keyword = $it0.next();
			switch(keyword) {
			case "info":
				var $it1 = parser.pairs();
				while( $it1.hasNext() ) {
					var pair = $it1.next();
					switch(pair.key) {
					case "size":
						this.size = pair.getInt();
						break;
					}
				}
				break;
			case "page":
				var pageId = 0;
				var file = null;
				var $it2 = parser.pairs();
				while( $it2.hasNext() ) {
					var pair = $it2.next();
					switch(pair.key) {
					case "id":
						pageId = pair.getInt();
						break;
					case "file":
						file = pair.getString();
						break;
					}
				}
				pages.set(pageId,this._pack.getTexture(basePath + flambe.util.Strings.removeFileExtension(file)));
				break;
			case "char":
				var glyph = null;
				var $it3 = parser.pairs();
				while( $it3.hasNext() ) {
					var pair = $it3.next();
					switch(pair.key) {
					case "id":
						glyph = new flambe.display.Glyph(pair.getInt());
						break;
					case "x":
						glyph.x = pair.getInt();
						break;
					case "y":
						glyph.y = pair.getInt();
						break;
					case "width":
						glyph.width = pair.getInt();
						break;
					case "height":
						glyph.height = pair.getInt();
						break;
					case "page":
						glyph.page = pages.get(pair.getInt());
						break;
					case "xoffset":
						glyph.xOffset = pair.getInt();
						break;
					case "yoffset":
						glyph.yOffset = pair.getInt();
						break;
					case "xadvance":
						glyph.xAdvance = pair.getInt();
						break;
					}
				}
				this._glyphs.set(glyph.charCode,glyph);
				break;
			case "kerning":
				var first = null;
				var second = -1;
				var $it4 = parser.pairs();
				while( $it4.hasNext() ) {
					var pair = $it4.next();
					switch(pair.key) {
					case "first":
						first = this._glyphs.get(pair.getInt());
						break;
					case "second":
						second = pair.getInt();
						break;
					case "amount":
						first.setKerning(second,pair.getInt());
						break;
					}
				}
				break;
			}
		}
	}
	,layoutText: function(text,align,wrapWidth) {
		if(wrapWidth == null) wrapWidth = 0;
		if(align == null) align = flambe.display.TextAlign.Left;
		return new flambe.display.TextLayout(this,text,align,wrapWidth);
	}
	,__class__: flambe.display.Font
}
flambe.display.TextAlign = { __ename__ : true, __constructs__ : ["Left","Center","Right"] }
flambe.display.TextAlign.Left = ["Left",0];
flambe.display.TextAlign.Left.toString = $estr;
flambe.display.TextAlign.Left.__enum__ = flambe.display.TextAlign;
flambe.display.TextAlign.Center = ["Center",1];
flambe.display.TextAlign.Center.toString = $estr;
flambe.display.TextAlign.Center.__enum__ = flambe.display.TextAlign;
flambe.display.TextAlign.Right = ["Right",2];
flambe.display.TextAlign.Right.toString = $estr;
flambe.display.TextAlign.Right.__enum__ = flambe.display.TextAlign;
flambe.display.TextLayout = function(font,text,align,wrapWidth) {
	this.lines = 0;
	var _g = this;
	this._font = font;
	this._glyphs = [];
	this._offsets = [];
	this.bounds = new flambe.math.Rectangle();
	var lineWidths = [];
	var ll = text.length;
	var _g1 = 0;
	while(_g1 < ll) {
		var ii = _g1++;
		var charCode = text.charCodeAt(ii);
		var glyph = font._glyphs.get(charCode);
		if(glyph != null) this._glyphs.push(glyph); else null;
	}
	var lastSpaceIdx = -1;
	var lineWidth = 0.0;
	var lineHeight = 0.0;
	var newline = font._glyphs.get(10);
	var addLine = function() {
		_g.bounds.width = flambe.math.FMath.max(_g.bounds.width,lineWidth);
		_g.bounds.height += lineHeight;
		lineWidths[_g.lines] = lineWidth;
		lineWidth = 0;
		lineHeight = 0;
		++_g.lines;
	};
	var ii = 0;
	while(ii < this._glyphs.length) {
		var glyph = this._glyphs[ii];
		this._offsets[ii] = lineWidth;
		var wordWrap = wrapWidth > 0 && lineWidth + glyph.width > wrapWidth;
		if(wordWrap || glyph == newline) {
			if(wordWrap) {
				if(lastSpaceIdx >= 0) {
					this._glyphs[lastSpaceIdx] = newline;
					lineWidth = this._offsets[lastSpaceIdx];
					ii = lastSpaceIdx;
				} else this._glyphs.splice(ii,0,newline);
			}
			lastSpaceIdx = -1;
			lineHeight = font.size;
			addLine();
		} else {
			if(glyph.charCode == 32) lastSpaceIdx = ii;
			lineWidth += glyph.xAdvance;
			lineHeight = flambe.math.FMath.max(lineHeight,glyph.height + glyph.yOffset);
			if(ii + 1 < this._glyphs.length) {
				var nextGlyph = this._glyphs[ii + 1];
				lineWidth += glyph.getKerning(nextGlyph.charCode);
			}
		}
		++ii;
	}
	addLine();
	var lineY = 0.0;
	var alignOffset = flambe.display.TextLayout.getAlignOffset(align,lineWidths[0],wrapWidth);
	var top = 1.79769313486231e+308;
	var bottom = -1.79769313486231e+308;
	var line = 0;
	var ii1 = 0;
	var ll1 = this._glyphs.length;
	while(ii1 < ll1) {
		var glyph = this._glyphs[ii1];
		if(glyph.charCode == 10) {
			lineY += font.size;
			++line;
			alignOffset = flambe.display.TextLayout.getAlignOffset(align,lineWidths[line],wrapWidth);
		}
		this._offsets[ii1] += alignOffset;
		var glyphY = lineY + glyph.yOffset;
		top = top < glyphY?top:glyphY;
		bottom = flambe.math.FMath.max(bottom,glyphY + glyph.height);
		++ii1;
	}
	this.bounds.x = flambe.display.TextLayout.getAlignOffset(align,this.bounds.width,wrapWidth);
	this.bounds.y = top;
	this.bounds.height = bottom - top;
};
flambe.display.TextLayout.__name__ = true;
flambe.display.TextLayout.getAlignOffset = function(align,lineWidth,totalWidth) {
	switch( (align)[1] ) {
	case 0:
		return 0;
	case 2:
		return totalWidth - lineWidth;
	case 1:
		return (totalWidth - lineWidth) / 2;
	}
}
flambe.display.TextLayout.prototype = {
	draw: function(g,align) {
		var y = 0.0;
		var ii = 0;
		var ll = this._glyphs.length;
		while(ii < ll) {
			var glyph = this._glyphs[ii];
			if(glyph.charCode == 10) y += this._font.size; else {
				var x = this._offsets[ii];
				glyph.draw(g,x,y);
			}
			++ii;
		}
	}
	,__class__: flambe.display.TextLayout
}
flambe.display._Font = {}
flambe.display._Font.ConfigParser = function(config) {
	this._configText = config;
	this._keywordPattern = new EReg("([a-z]+)(.*)","");
	this._pairPattern = new EReg("([a-z]+)=(\"[^\"]*\"|[^\\s]+)","");
};
flambe.display._Font.ConfigParser.__name__ = true;
flambe.display._Font.ConfigParser.advance = function(text,expr) {
	var m = expr.matchedPos();
	return HxOverrides.substr(text,m.pos + m.len,text.length);
}
flambe.display._Font.ConfigParser.prototype = {
	pairs: function() {
		var _g = this;
		var text = this._pairText;
		return { next : function() {
			text = flambe.display._Font.ConfigParser.advance(text,_g._pairPattern);
			return new flambe.display._Font.ConfigPair(_g._pairPattern.matched(1),_g._pairPattern.matched(2));
		}, hasNext : function() {
			return _g._pairPattern.match(text);
		}};
	}
	,keywords: function() {
		var _g = this;
		var text = this._configText;
		return { next : function() {
			text = flambe.display._Font.ConfigParser.advance(text,_g._keywordPattern);
			_g._pairText = _g._keywordPattern.matched(2);
			return _g._keywordPattern.matched(1);
		}, hasNext : function() {
			return _g._keywordPattern.match(text);
		}};
	}
	,__class__: flambe.display._Font.ConfigParser
}
flambe.display._Font.ConfigPair = function(key,value) {
	this.key = key;
	this._value = value;
};
flambe.display._Font.ConfigPair.__name__ = true;
flambe.display._Font.ConfigPair.prototype = {
	getString: function() {
		if(this._value.charCodeAt(0) != 34) return null;
		return HxOverrides.substr(this._value,1,this._value.length - 2);
	}
	,getInt: function() {
		return Std.parseInt(this._value);
	}
	,__class__: flambe.display._Font.ConfigPair
}
flambe.display.Graphics = function() { }
flambe.display.Graphics.__name__ = true;
flambe.display.Graphics.prototype = {
	__class__: flambe.display.Graphics
}
flambe.display.ImageSprite = function(texture) {
	flambe.display.Sprite.call(this);
	this.texture = texture;
};
flambe.display.ImageSprite.__name__ = true;
flambe.display.ImageSprite.__super__ = flambe.display.Sprite;
flambe.display.ImageSprite.prototype = $extend(flambe.display.Sprite.prototype,{
	getNaturalHeight: function() {
		return this.texture.get_height();
	}
	,getNaturalWidth: function() {
		return this.texture.get_width();
	}
	,draw: function(g) {
		g.drawImage(this.texture,0,0);
	}
	,__class__: flambe.display.ImageSprite
});
flambe.display.Orientation = { __ename__ : true, __constructs__ : ["Portrait","Landscape"] }
flambe.display.Orientation.Portrait = ["Portrait",0];
flambe.display.Orientation.Portrait.toString = $estr;
flambe.display.Orientation.Portrait.__enum__ = flambe.display.Orientation;
flambe.display.Orientation.Landscape = ["Landscape",1];
flambe.display.Orientation.Landscape.toString = $estr;
flambe.display.Orientation.Landscape.__enum__ = flambe.display.Orientation;
flambe.display.TextSprite = function(font,text) {
	if(text == null) text = "";
	this._layout = null;
	var _g = this;
	flambe.display.Sprite.call(this);
	this._font = font;
	this._text = text;
	this._align = flambe.display.TextAlign.Left;
	this._flags = this._flags | 32;
	this.wrapWidth = new flambe.animation.AnimatedFloat(0,function(_,_1) {
		_g._flags = _g._flags | 32;
	});
};
flambe.display.TextSprite.__name__ = true;
flambe.display.TextSprite.__super__ = flambe.display.Sprite;
flambe.display.TextSprite.prototype = $extend(flambe.display.Sprite.prototype,{
	onUpdate: function(dt) {
		flambe.display.Sprite.prototype.onUpdate.call(this,dt);
		this.wrapWidth.update(dt);
	}
	,updateLayout: function() {
		if((this._flags & 32) != 0) {
			this._flags = this._flags & -33;
			this._layout = this._font.layoutText(this._text,this._align,this.wrapWidth._value);
		}
	}
	,set_align: function(align) {
		if(align != this._align) {
			this._align = align;
			this._flags = this._flags | 32;
		}
		return align;
	}
	,set_text: function(text) {
		if(text != this._text) {
			this._text = text;
			this._flags = this._flags | 32;
		}
		return text;
	}
	,containsLocal: function(localX,localY) {
		this.updateLayout();
		return this._layout.bounds.contains(localX,localY);
	}
	,getNaturalHeight: function() {
		this.updateLayout();
		return this._layout.lines * this._font.size;
	}
	,getNaturalWidth: function() {
		this.updateLayout();
		return this.wrapWidth._value > 0?this.wrapWidth._value:this._layout.bounds.width;
	}
	,draw: function(g) {
		this.updateLayout();
		this._layout.draw(g,this._align);
	}
	,__class__: flambe.display.TextSprite
});
flambe.display.Texture = function() { }
flambe.display.Texture.__name__ = true;
flambe.display.Texture.__interfaces__ = [flambe.asset.Asset];
flambe.display.Texture.prototype = {
	__class__: flambe.display.Texture
}
flambe.input = {}
flambe.input.Key = { __ename__ : true, __constructs__ : ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","Number0","Number1","Number2","Number3","Number4","Number5","Number6","Number7","Number8","Number9","Numpad0","Numpad1","Numpad2","Numpad3","Numpad4","Numpad5","Numpad6","Numpad7","Numpad8","Numpad9","NumpadAdd","NumpadDecimal","NumpadDivide","NumpadEnter","NumpadMultiply","NumpadSubtract","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","Left","Up","Right","Down","Alt","Backquote","Backslash","Backspace","CapsLock","Comma","Command","Control","Delete","End","Enter","Equals","Escape","Home","Insert","LeftBracket","Minus","PageDown","PageUp","Period","Quote","RightBracket","Semicolon","Shift","Slash","Space","Tab","Menu","Search","Unknown"] }
flambe.input.Key.A = ["A",0];
flambe.input.Key.A.toString = $estr;
flambe.input.Key.A.__enum__ = flambe.input.Key;
flambe.input.Key.B = ["B",1];
flambe.input.Key.B.toString = $estr;
flambe.input.Key.B.__enum__ = flambe.input.Key;
flambe.input.Key.C = ["C",2];
flambe.input.Key.C.toString = $estr;
flambe.input.Key.C.__enum__ = flambe.input.Key;
flambe.input.Key.D = ["D",3];
flambe.input.Key.D.toString = $estr;
flambe.input.Key.D.__enum__ = flambe.input.Key;
flambe.input.Key.E = ["E",4];
flambe.input.Key.E.toString = $estr;
flambe.input.Key.E.__enum__ = flambe.input.Key;
flambe.input.Key.F = ["F",5];
flambe.input.Key.F.toString = $estr;
flambe.input.Key.F.__enum__ = flambe.input.Key;
flambe.input.Key.G = ["G",6];
flambe.input.Key.G.toString = $estr;
flambe.input.Key.G.__enum__ = flambe.input.Key;
flambe.input.Key.H = ["H",7];
flambe.input.Key.H.toString = $estr;
flambe.input.Key.H.__enum__ = flambe.input.Key;
flambe.input.Key.I = ["I",8];
flambe.input.Key.I.toString = $estr;
flambe.input.Key.I.__enum__ = flambe.input.Key;
flambe.input.Key.J = ["J",9];
flambe.input.Key.J.toString = $estr;
flambe.input.Key.J.__enum__ = flambe.input.Key;
flambe.input.Key.K = ["K",10];
flambe.input.Key.K.toString = $estr;
flambe.input.Key.K.__enum__ = flambe.input.Key;
flambe.input.Key.L = ["L",11];
flambe.input.Key.L.toString = $estr;
flambe.input.Key.L.__enum__ = flambe.input.Key;
flambe.input.Key.M = ["M",12];
flambe.input.Key.M.toString = $estr;
flambe.input.Key.M.__enum__ = flambe.input.Key;
flambe.input.Key.N = ["N",13];
flambe.input.Key.N.toString = $estr;
flambe.input.Key.N.__enum__ = flambe.input.Key;
flambe.input.Key.O = ["O",14];
flambe.input.Key.O.toString = $estr;
flambe.input.Key.O.__enum__ = flambe.input.Key;
flambe.input.Key.P = ["P",15];
flambe.input.Key.P.toString = $estr;
flambe.input.Key.P.__enum__ = flambe.input.Key;
flambe.input.Key.Q = ["Q",16];
flambe.input.Key.Q.toString = $estr;
flambe.input.Key.Q.__enum__ = flambe.input.Key;
flambe.input.Key.R = ["R",17];
flambe.input.Key.R.toString = $estr;
flambe.input.Key.R.__enum__ = flambe.input.Key;
flambe.input.Key.S = ["S",18];
flambe.input.Key.S.toString = $estr;
flambe.input.Key.S.__enum__ = flambe.input.Key;
flambe.input.Key.T = ["T",19];
flambe.input.Key.T.toString = $estr;
flambe.input.Key.T.__enum__ = flambe.input.Key;
flambe.input.Key.U = ["U",20];
flambe.input.Key.U.toString = $estr;
flambe.input.Key.U.__enum__ = flambe.input.Key;
flambe.input.Key.V = ["V",21];
flambe.input.Key.V.toString = $estr;
flambe.input.Key.V.__enum__ = flambe.input.Key;
flambe.input.Key.W = ["W",22];
flambe.input.Key.W.toString = $estr;
flambe.input.Key.W.__enum__ = flambe.input.Key;
flambe.input.Key.X = ["X",23];
flambe.input.Key.X.toString = $estr;
flambe.input.Key.X.__enum__ = flambe.input.Key;
flambe.input.Key.Y = ["Y",24];
flambe.input.Key.Y.toString = $estr;
flambe.input.Key.Y.__enum__ = flambe.input.Key;
flambe.input.Key.Z = ["Z",25];
flambe.input.Key.Z.toString = $estr;
flambe.input.Key.Z.__enum__ = flambe.input.Key;
flambe.input.Key.Number0 = ["Number0",26];
flambe.input.Key.Number0.toString = $estr;
flambe.input.Key.Number0.__enum__ = flambe.input.Key;
flambe.input.Key.Number1 = ["Number1",27];
flambe.input.Key.Number1.toString = $estr;
flambe.input.Key.Number1.__enum__ = flambe.input.Key;
flambe.input.Key.Number2 = ["Number2",28];
flambe.input.Key.Number2.toString = $estr;
flambe.input.Key.Number2.__enum__ = flambe.input.Key;
flambe.input.Key.Number3 = ["Number3",29];
flambe.input.Key.Number3.toString = $estr;
flambe.input.Key.Number3.__enum__ = flambe.input.Key;
flambe.input.Key.Number4 = ["Number4",30];
flambe.input.Key.Number4.toString = $estr;
flambe.input.Key.Number4.__enum__ = flambe.input.Key;
flambe.input.Key.Number5 = ["Number5",31];
flambe.input.Key.Number5.toString = $estr;
flambe.input.Key.Number5.__enum__ = flambe.input.Key;
flambe.input.Key.Number6 = ["Number6",32];
flambe.input.Key.Number6.toString = $estr;
flambe.input.Key.Number6.__enum__ = flambe.input.Key;
flambe.input.Key.Number7 = ["Number7",33];
flambe.input.Key.Number7.toString = $estr;
flambe.input.Key.Number7.__enum__ = flambe.input.Key;
flambe.input.Key.Number8 = ["Number8",34];
flambe.input.Key.Number8.toString = $estr;
flambe.input.Key.Number8.__enum__ = flambe.input.Key;
flambe.input.Key.Number9 = ["Number9",35];
flambe.input.Key.Number9.toString = $estr;
flambe.input.Key.Number9.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad0 = ["Numpad0",36];
flambe.input.Key.Numpad0.toString = $estr;
flambe.input.Key.Numpad0.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad1 = ["Numpad1",37];
flambe.input.Key.Numpad1.toString = $estr;
flambe.input.Key.Numpad1.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad2 = ["Numpad2",38];
flambe.input.Key.Numpad2.toString = $estr;
flambe.input.Key.Numpad2.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad3 = ["Numpad3",39];
flambe.input.Key.Numpad3.toString = $estr;
flambe.input.Key.Numpad3.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad4 = ["Numpad4",40];
flambe.input.Key.Numpad4.toString = $estr;
flambe.input.Key.Numpad4.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad5 = ["Numpad5",41];
flambe.input.Key.Numpad5.toString = $estr;
flambe.input.Key.Numpad5.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad6 = ["Numpad6",42];
flambe.input.Key.Numpad6.toString = $estr;
flambe.input.Key.Numpad6.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad7 = ["Numpad7",43];
flambe.input.Key.Numpad7.toString = $estr;
flambe.input.Key.Numpad7.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad8 = ["Numpad8",44];
flambe.input.Key.Numpad8.toString = $estr;
flambe.input.Key.Numpad8.__enum__ = flambe.input.Key;
flambe.input.Key.Numpad9 = ["Numpad9",45];
flambe.input.Key.Numpad9.toString = $estr;
flambe.input.Key.Numpad9.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadAdd = ["NumpadAdd",46];
flambe.input.Key.NumpadAdd.toString = $estr;
flambe.input.Key.NumpadAdd.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadDecimal = ["NumpadDecimal",47];
flambe.input.Key.NumpadDecimal.toString = $estr;
flambe.input.Key.NumpadDecimal.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadDivide = ["NumpadDivide",48];
flambe.input.Key.NumpadDivide.toString = $estr;
flambe.input.Key.NumpadDivide.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadEnter = ["NumpadEnter",49];
flambe.input.Key.NumpadEnter.toString = $estr;
flambe.input.Key.NumpadEnter.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadMultiply = ["NumpadMultiply",50];
flambe.input.Key.NumpadMultiply.toString = $estr;
flambe.input.Key.NumpadMultiply.__enum__ = flambe.input.Key;
flambe.input.Key.NumpadSubtract = ["NumpadSubtract",51];
flambe.input.Key.NumpadSubtract.toString = $estr;
flambe.input.Key.NumpadSubtract.__enum__ = flambe.input.Key;
flambe.input.Key.F1 = ["F1",52];
flambe.input.Key.F1.toString = $estr;
flambe.input.Key.F1.__enum__ = flambe.input.Key;
flambe.input.Key.F2 = ["F2",53];
flambe.input.Key.F2.toString = $estr;
flambe.input.Key.F2.__enum__ = flambe.input.Key;
flambe.input.Key.F3 = ["F3",54];
flambe.input.Key.F3.toString = $estr;
flambe.input.Key.F3.__enum__ = flambe.input.Key;
flambe.input.Key.F4 = ["F4",55];
flambe.input.Key.F4.toString = $estr;
flambe.input.Key.F4.__enum__ = flambe.input.Key;
flambe.input.Key.F5 = ["F5",56];
flambe.input.Key.F5.toString = $estr;
flambe.input.Key.F5.__enum__ = flambe.input.Key;
flambe.input.Key.F6 = ["F6",57];
flambe.input.Key.F6.toString = $estr;
flambe.input.Key.F6.__enum__ = flambe.input.Key;
flambe.input.Key.F7 = ["F7",58];
flambe.input.Key.F7.toString = $estr;
flambe.input.Key.F7.__enum__ = flambe.input.Key;
flambe.input.Key.F8 = ["F8",59];
flambe.input.Key.F8.toString = $estr;
flambe.input.Key.F8.__enum__ = flambe.input.Key;
flambe.input.Key.F9 = ["F9",60];
flambe.input.Key.F9.toString = $estr;
flambe.input.Key.F9.__enum__ = flambe.input.Key;
flambe.input.Key.F10 = ["F10",61];
flambe.input.Key.F10.toString = $estr;
flambe.input.Key.F10.__enum__ = flambe.input.Key;
flambe.input.Key.F11 = ["F11",62];
flambe.input.Key.F11.toString = $estr;
flambe.input.Key.F11.__enum__ = flambe.input.Key;
flambe.input.Key.F12 = ["F12",63];
flambe.input.Key.F12.toString = $estr;
flambe.input.Key.F12.__enum__ = flambe.input.Key;
flambe.input.Key.F13 = ["F13",64];
flambe.input.Key.F13.toString = $estr;
flambe.input.Key.F13.__enum__ = flambe.input.Key;
flambe.input.Key.F14 = ["F14",65];
flambe.input.Key.F14.toString = $estr;
flambe.input.Key.F14.__enum__ = flambe.input.Key;
flambe.input.Key.F15 = ["F15",66];
flambe.input.Key.F15.toString = $estr;
flambe.input.Key.F15.__enum__ = flambe.input.Key;
flambe.input.Key.Left = ["Left",67];
flambe.input.Key.Left.toString = $estr;
flambe.input.Key.Left.__enum__ = flambe.input.Key;
flambe.input.Key.Up = ["Up",68];
flambe.input.Key.Up.toString = $estr;
flambe.input.Key.Up.__enum__ = flambe.input.Key;
flambe.input.Key.Right = ["Right",69];
flambe.input.Key.Right.toString = $estr;
flambe.input.Key.Right.__enum__ = flambe.input.Key;
flambe.input.Key.Down = ["Down",70];
flambe.input.Key.Down.toString = $estr;
flambe.input.Key.Down.__enum__ = flambe.input.Key;
flambe.input.Key.Alt = ["Alt",71];
flambe.input.Key.Alt.toString = $estr;
flambe.input.Key.Alt.__enum__ = flambe.input.Key;
flambe.input.Key.Backquote = ["Backquote",72];
flambe.input.Key.Backquote.toString = $estr;
flambe.input.Key.Backquote.__enum__ = flambe.input.Key;
flambe.input.Key.Backslash = ["Backslash",73];
flambe.input.Key.Backslash.toString = $estr;
flambe.input.Key.Backslash.__enum__ = flambe.input.Key;
flambe.input.Key.Backspace = ["Backspace",74];
flambe.input.Key.Backspace.toString = $estr;
flambe.input.Key.Backspace.__enum__ = flambe.input.Key;
flambe.input.Key.CapsLock = ["CapsLock",75];
flambe.input.Key.CapsLock.toString = $estr;
flambe.input.Key.CapsLock.__enum__ = flambe.input.Key;
flambe.input.Key.Comma = ["Comma",76];
flambe.input.Key.Comma.toString = $estr;
flambe.input.Key.Comma.__enum__ = flambe.input.Key;
flambe.input.Key.Command = ["Command",77];
flambe.input.Key.Command.toString = $estr;
flambe.input.Key.Command.__enum__ = flambe.input.Key;
flambe.input.Key.Control = ["Control",78];
flambe.input.Key.Control.toString = $estr;
flambe.input.Key.Control.__enum__ = flambe.input.Key;
flambe.input.Key.Delete = ["Delete",79];
flambe.input.Key.Delete.toString = $estr;
flambe.input.Key.Delete.__enum__ = flambe.input.Key;
flambe.input.Key.End = ["End",80];
flambe.input.Key.End.toString = $estr;
flambe.input.Key.End.__enum__ = flambe.input.Key;
flambe.input.Key.Enter = ["Enter",81];
flambe.input.Key.Enter.toString = $estr;
flambe.input.Key.Enter.__enum__ = flambe.input.Key;
flambe.input.Key.Equals = ["Equals",82];
flambe.input.Key.Equals.toString = $estr;
flambe.input.Key.Equals.__enum__ = flambe.input.Key;
flambe.input.Key.Escape = ["Escape",83];
flambe.input.Key.Escape.toString = $estr;
flambe.input.Key.Escape.__enum__ = flambe.input.Key;
flambe.input.Key.Home = ["Home",84];
flambe.input.Key.Home.toString = $estr;
flambe.input.Key.Home.__enum__ = flambe.input.Key;
flambe.input.Key.Insert = ["Insert",85];
flambe.input.Key.Insert.toString = $estr;
flambe.input.Key.Insert.__enum__ = flambe.input.Key;
flambe.input.Key.LeftBracket = ["LeftBracket",86];
flambe.input.Key.LeftBracket.toString = $estr;
flambe.input.Key.LeftBracket.__enum__ = flambe.input.Key;
flambe.input.Key.Minus = ["Minus",87];
flambe.input.Key.Minus.toString = $estr;
flambe.input.Key.Minus.__enum__ = flambe.input.Key;
flambe.input.Key.PageDown = ["PageDown",88];
flambe.input.Key.PageDown.toString = $estr;
flambe.input.Key.PageDown.__enum__ = flambe.input.Key;
flambe.input.Key.PageUp = ["PageUp",89];
flambe.input.Key.PageUp.toString = $estr;
flambe.input.Key.PageUp.__enum__ = flambe.input.Key;
flambe.input.Key.Period = ["Period",90];
flambe.input.Key.Period.toString = $estr;
flambe.input.Key.Period.__enum__ = flambe.input.Key;
flambe.input.Key.Quote = ["Quote",91];
flambe.input.Key.Quote.toString = $estr;
flambe.input.Key.Quote.__enum__ = flambe.input.Key;
flambe.input.Key.RightBracket = ["RightBracket",92];
flambe.input.Key.RightBracket.toString = $estr;
flambe.input.Key.RightBracket.__enum__ = flambe.input.Key;
flambe.input.Key.Semicolon = ["Semicolon",93];
flambe.input.Key.Semicolon.toString = $estr;
flambe.input.Key.Semicolon.__enum__ = flambe.input.Key;
flambe.input.Key.Shift = ["Shift",94];
flambe.input.Key.Shift.toString = $estr;
flambe.input.Key.Shift.__enum__ = flambe.input.Key;
flambe.input.Key.Slash = ["Slash",95];
flambe.input.Key.Slash.toString = $estr;
flambe.input.Key.Slash.__enum__ = flambe.input.Key;
flambe.input.Key.Space = ["Space",96];
flambe.input.Key.Space.toString = $estr;
flambe.input.Key.Space.__enum__ = flambe.input.Key;
flambe.input.Key.Tab = ["Tab",97];
flambe.input.Key.Tab.toString = $estr;
flambe.input.Key.Tab.__enum__ = flambe.input.Key;
flambe.input.Key.Menu = ["Menu",98];
flambe.input.Key.Menu.toString = $estr;
flambe.input.Key.Menu.__enum__ = flambe.input.Key;
flambe.input.Key.Search = ["Search",99];
flambe.input.Key.Search.toString = $estr;
flambe.input.Key.Search.__enum__ = flambe.input.Key;
flambe.input.Key.Unknown = function(keyCode) { var $x = ["Unknown",100,keyCode]; $x.__enum__ = flambe.input.Key; $x.toString = $estr; return $x; }
flambe.input.KeyboardEvent = function() {
	this.init(0,null);
};
flambe.input.KeyboardEvent.__name__ = true;
flambe.input.KeyboardEvent.prototype = {
	init: function(id,key) {
		this.id = id;
		this.key = key;
	}
	,__class__: flambe.input.KeyboardEvent
}
flambe.input.MouseButton = { __ename__ : true, __constructs__ : ["Left","Middle","Right","Unknown"] }
flambe.input.MouseButton.Left = ["Left",0];
flambe.input.MouseButton.Left.toString = $estr;
flambe.input.MouseButton.Left.__enum__ = flambe.input.MouseButton;
flambe.input.MouseButton.Middle = ["Middle",1];
flambe.input.MouseButton.Middle.toString = $estr;
flambe.input.MouseButton.Middle.__enum__ = flambe.input.MouseButton;
flambe.input.MouseButton.Right = ["Right",2];
flambe.input.MouseButton.Right.toString = $estr;
flambe.input.MouseButton.Right.__enum__ = flambe.input.MouseButton;
flambe.input.MouseButton.Unknown = function(buttonCode) { var $x = ["Unknown",3,buttonCode]; $x.__enum__ = flambe.input.MouseButton; $x.toString = $estr; return $x; }
flambe.input.MouseCursor = { __ename__ : true, __constructs__ : ["Default","Button","None"] }
flambe.input.MouseCursor.Default = ["Default",0];
flambe.input.MouseCursor.Default.toString = $estr;
flambe.input.MouseCursor.Default.__enum__ = flambe.input.MouseCursor;
flambe.input.MouseCursor.Button = ["Button",1];
flambe.input.MouseCursor.Button.toString = $estr;
flambe.input.MouseCursor.Button.__enum__ = flambe.input.MouseCursor;
flambe.input.MouseCursor.None = ["None",2];
flambe.input.MouseCursor.None.toString = $estr;
flambe.input.MouseCursor.None.__enum__ = flambe.input.MouseCursor;
flambe.input.MouseEvent = function() {
	this.init(0,0,0,null);
};
flambe.input.MouseEvent.__name__ = true;
flambe.input.MouseEvent.prototype = {
	init: function(id,viewX,viewY,button) {
		this.id = id;
		this.viewX = viewX;
		this.viewY = viewY;
		this.button = button;
	}
	,__class__: flambe.input.MouseEvent
}
flambe.input.EventSource = { __ename__ : true, __constructs__ : ["Mouse","Touch"] }
flambe.input.EventSource.Mouse = function(event) { var $x = ["Mouse",0,event]; $x.__enum__ = flambe.input.EventSource; $x.toString = $estr; return $x; }
flambe.input.EventSource.Touch = function(point) { var $x = ["Touch",1,point]; $x.__enum__ = flambe.input.EventSource; $x.toString = $estr; return $x; }
flambe.input.PointerEvent = function() {
	this.init(0,0,0,null,null);
};
flambe.input.PointerEvent.__name__ = true;
flambe.input.PointerEvent.prototype = {
	init: function(id,viewX,viewY,hit,source) {
		this.id = id;
		this.viewX = viewX;
		this.viewY = viewY;
		this.hit = hit;
		this.source = source;
		this._stopped = false;
	}
	,__class__: flambe.input.PointerEvent
}
flambe.input.TouchPoint = function(id) {
	this.id = id;
	this._source = flambe.input.EventSource.Touch(this);
};
flambe.input.TouchPoint.__name__ = true;
flambe.input.TouchPoint.prototype = {
	init: function(viewX,viewY) {
		this.viewX = viewX;
		this.viewY = viewY;
	}
	,__class__: flambe.input.TouchPoint
}
flambe.math.FMath = function() { }
flambe.math.FMath.__name__ = true;
flambe.math.FMath.max = function(a,b) {
	return a > b?a:b;
}
flambe.math.FMath.min = function(a,b) {
	return a < b?a:b;
}
flambe.math.Matrix = function() {
	this.identity();
};
flambe.math.Matrix.__name__ = true;
flambe.math.Matrix.multiply = function(lhs,rhs,result) {
	if(result == null) result = new flambe.math.Matrix();
	var a = lhs.m00 * rhs.m00 + lhs.m01 * rhs.m10;
	var b = lhs.m00 * rhs.m01 + lhs.m01 * rhs.m11;
	var c = lhs.m00 * rhs.m02 + lhs.m01 * rhs.m12 + lhs.m02;
	result.m00 = a;
	result.m01 = b;
	result.m02 = c;
	a = lhs.m10 * rhs.m00 + lhs.m11 * rhs.m10;
	b = lhs.m10 * rhs.m01 + lhs.m11 * rhs.m11;
	c = lhs.m10 * rhs.m02 + lhs.m11 * rhs.m12 + lhs.m12;
	result.m10 = a;
	result.m11 = b;
	result.m12 = c;
	return result;
}
flambe.math.Matrix.prototype = {
	clone: function(result) {
		if(result == null) result = new flambe.math.Matrix();
		result.set(this.m00,this.m10,this.m01,this.m11,this.m02,this.m12);
		return result;
	}
	,inverseTransform: function(x,y,result) {
		var det = this.determinant();
		if(det == 0) return false;
		x -= this.m02;
		y -= this.m12;
		result.x = (x * this.m11 - y * this.m01) / det;
		result.y = (y * this.m00 - x * this.m10) / det;
		return true;
	}
	,determinant: function() {
		return this.m00 * this.m11 - this.m01 * this.m10;
	}
	,transformArray: function(points,length,result) {
		var ii = 0;
		while(ii < length) {
			var x = points[ii], y = points[ii + 1];
			result[ii++] = x * this.m00 + y * this.m01 + this.m02;
			result[ii++] = x * this.m10 + y * this.m11 + this.m12;
		}
	}
	,invert: function() {
		var det = this.determinant();
		if(det == 0) return false;
		this.set(this.m11 / det,-this.m01 / det,-this.m10 / det,this.m00 / det,(this.m01 * this.m12 - this.m11 * this.m02) / det,(this.m10 * this.m02 - this.m00 * this.m12) / det);
		return true;
	}
	,translate: function(x,y) {
		this.m02 += this.m00 * x + this.m01 * y;
		this.m12 += this.m11 * y + this.m10 * x;
	}
	,compose: function(x,y,scaleX,scaleY,rotation) {
		var sin = Math.sin(rotation);
		var cos = Math.cos(rotation);
		this.set(cos * scaleX,sin * scaleX,-sin * scaleY,cos * scaleY,x,y);
	}
	,identity: function() {
		this.set(1,0,0,1,0,0);
	}
	,set: function(m00,m10,m01,m11,m02,m12) {
		this.m00 = m00;
		this.m01 = m01;
		this.m02 = m02;
		this.m10 = m10;
		this.m11 = m11;
		this.m12 = m12;
	}
	,__class__: flambe.math.Matrix
}
flambe.platform.BasicAsset = function() {
	this._disposed = false;
};
flambe.platform.BasicAsset.__name__ = true;
flambe.platform.BasicAsset.__interfaces__ = [flambe.asset.Asset];
flambe.platform.BasicAsset.prototype = {
	onDisposed: function() {
		null;
	}
	,dispose: function() {
		if(!this._disposed) {
			this._disposed = true;
			this.onDisposed();
		}
	}
	,__class__: flambe.platform.BasicAsset
}
flambe.platform.BasicAssetPackLoader = function(platform,manifest) {
	var _g = this;
	this.manifest = manifest;
	this._platform = platform;
	this.promise = new flambe.util.Promise();
	this._bytesLoaded = new haxe.ds.StringMap();
	this._pack = new flambe.platform._BasicAssetPackLoader.BasicAssetPack(manifest,this);
	var entries = Lambda.array(manifest);
	if(entries.length == 0) this.handleSuccess(); else {
		var groups = new haxe.ds.StringMap();
		var _g1 = 0;
		while(_g1 < entries.length) {
			var entry = entries[_g1];
			++_g1;
			var group = groups.get(entry.name);
			if(group == null) {
				group = [];
				groups.set(entry.name,group);
			}
			group.push(entry);
		}
		this._assetsRemaining = Lambda.count(groups);
		var $it0 = (((function() {
			return function(_e) {
				return (function() {
					return function() {
						return _e.iterator();
					};
				})();
			};
		})())(groups))();
		while( $it0.hasNext() ) {
			var group = $it0.next();
			var group1 = [group];
			this.pickBestEntry(group1[0],(function(group1) {
				return function(bestEntry) {
					if(bestEntry != null) {
						var url = manifest.getFullURL(bestEntry);
						try {
							_g.loadEntry(url,bestEntry);
						} catch( error ) {
							_g.handleError(bestEntry,"Unexpected error: " + Std.string(error));
						}
						var _g1 = _g.promise;
						_g1.set_total(_g1._total + bestEntry.bytes);
					} else {
						var badEntry = group1[0][0];
						if(flambe.platform.BasicAssetPackLoader.isAudio(badEntry.format)) _g.handleLoad(badEntry,flambe.platform.DummySound.getInstance()); else _g.handleError(badEntry,"Could not find a supported format to load");
					}
				};
			})(group1));
		}
	}
};
flambe.platform.BasicAssetPackLoader.__name__ = true;
flambe.platform.BasicAssetPackLoader.isAudio = function(format) {
	switch( (format)[1] ) {
	case 8:
	case 9:
	case 10:
	case 11:
	case 12:
		return true;
	default:
		return false;
	}
}
flambe.platform.BasicAssetPackLoader.prototype = {
	handleTextureError: function(entry) {
		this.handleError(entry,"Failed to create texture. Is the GPU context unavailable?");
	}
	,handleError: function(entry,message) {
		this.promise.error.emit1(flambe.util.Strings.withFields(message,["url",entry.url]));
	}
	,handleSuccess: function() {
		this.promise.set_result(this._pack);
	}
	,handleProgress: function(entry,bytesLoaded) {
		this._bytesLoaded.set(entry.name,bytesLoaded);
		var bytesTotal = 0;
		var $it0 = ((function(_e) {
			return function() {
				return _e.iterator();
			};
		})(this._bytesLoaded))();
		while( $it0.hasNext() ) {
			var bytes = $it0.next();
			bytesTotal += bytes;
		}
		this.promise.set_progress(bytesTotal);
	}
	,handleLoad: function(entry,asset) {
		if(this._pack.disposed) return;
		this.handleProgress(entry,entry.bytes);
		var map;
		switch( (entry.format)[1] ) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			map = this._pack.textures;
			break;
		case 8:
		case 9:
		case 10:
		case 11:
		case 12:
			map = this._pack.sounds;
			break;
		case 13:
			map = this._pack.files;
			break;
		}
		map.set(entry.name,asset);
		this._assetsRemaining -= 1;
		if(this._assetsRemaining == 0) this.handleSuccess();
	}
	,getAssetFormats: function(fn) {
		null;
	}
	,loadEntry: function(url,entry) {
		null;
	}
	,pickBestEntry: function(entries,fn) {
		var onFormatsAvailable = function(formats) {
			var _g = 0;
			while(_g < formats.length) {
				var format = formats[_g];
				++_g;
				var _g1 = 0;
				while(_g1 < entries.length) {
					var entry = entries[_g1];
					++_g1;
					if(entry.format == format) {
						fn(entry);
						return;
					}
				}
			}
			fn(null);
		};
		this.getAssetFormats(onFormatsAvailable);
	}
	,onDisposed: function() {
	}
	,__class__: flambe.platform.BasicAssetPackLoader
}
flambe.platform._BasicAssetPackLoader = {}
flambe.platform._BasicAssetPackLoader.BasicAssetPack = function(manifest,loader) {
	this.disposed = false;
	this._manifest = manifest;
	this.loader = loader;
	this.textures = new haxe.ds.StringMap();
	this.sounds = new haxe.ds.StringMap();
	this.files = new haxe.ds.StringMap();
};
flambe.platform._BasicAssetPackLoader.BasicAssetPack.__name__ = true;
flambe.platform._BasicAssetPackLoader.BasicAssetPack.__interfaces__ = [flambe.asset.AssetPack];
flambe.platform._BasicAssetPackLoader.BasicAssetPack.prototype = {
	dispose: function() {
		if(!this.disposed) {
			this.disposed = true;
			var $it0 = ((function(_e) {
				return function() {
					return _e.iterator();
				};
			})(this.textures))();
			while( $it0.hasNext() ) {
				var texture = $it0.next();
				texture.dispose();
			}
			this.textures = null;
			var $it1 = ((function(_e1) {
				return function() {
					return _e1.iterator();
				};
			})(this.sounds))();
			while( $it1.hasNext() ) {
				var sound = $it1.next();
				sound.dispose();
			}
			this.sounds = null;
			var $it2 = ((function(_e2) {
				return function() {
					return _e2.iterator();
				};
			})(this.files))();
			while( $it2.hasNext() ) {
				var file = $it2.next();
				file.dispose();
			}
			this.files = null;
			this.loader.onDisposed();
		}
	}
	,getFile: function(name,required) {
		if(required == null) required = true;
		var file = this.files.get(name);
		if(file == null && required) throw flambe.util.Strings.withFields("Missing file",["name",name]);
		return file;
	}
	,getSound: function(name,required) {
		if(required == null) required = true;
		var sound = this.sounds.get(name);
		if(sound == null && required) throw flambe.util.Strings.withFields("Missing sound",["name",name]);
		return sound;
	}
	,getTexture: function(name,required) {
		if(required == null) required = true;
		var texture = this.textures.get(name);
		if(texture == null && required) throw flambe.util.Strings.withFields("Missing texture",["name",name]);
		return texture;
	}
	,__class__: flambe.platform._BasicAssetPackLoader.BasicAssetPack
}
flambe.platform.BasicFile = function(content) {
	flambe.platform.BasicAsset.call(this);
	this._content = content;
};
flambe.platform.BasicFile.__name__ = true;
flambe.platform.BasicFile.__interfaces__ = [flambe.asset.File];
flambe.platform.BasicFile.__super__ = flambe.platform.BasicAsset;
flambe.platform.BasicFile.prototype = $extend(flambe.platform.BasicAsset.prototype,{
	onDisposed: function() {
		this._content = null;
	}
	,toString: function() {
		return this._content;
	}
	,__class__: flambe.platform.BasicFile
});
flambe.subsystem = {}
flambe.subsystem.KeyboardSystem = function() { }
flambe.subsystem.KeyboardSystem.__name__ = true;
flambe.subsystem.KeyboardSystem.prototype = {
	__class__: flambe.subsystem.KeyboardSystem
}
flambe.platform.BasicKeyboard = function() {
	this.down = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
	this.backButton = new flambe.util.Signal0();
	this._keyStates = new haxe.ds.IntMap();
};
flambe.platform.BasicKeyboard.__name__ = true;
flambe.platform.BasicKeyboard.__interfaces__ = [flambe.subsystem.KeyboardSystem];
flambe.platform.BasicKeyboard.prototype = {
	submitUp: function(keyCode) {
		if(this._keyStates.exists(keyCode)) {
			this._keyStates.remove(keyCode);
			flambe.platform.BasicKeyboard._sharedEvent.init(flambe.platform.BasicKeyboard._sharedEvent.id + 1,flambe.platform.KeyCodes.toKey(keyCode));
			this.up.emit1(flambe.platform.BasicKeyboard._sharedEvent);
		}
	}
	,submitDown: function(keyCode) {
		if(keyCode == 16777238) {
			if(this.backButton._head != null) {
				this.backButton.emit0();
				return true;
			}
			return false;
		}
		if(!this._keyStates.exists(keyCode)) {
			this._keyStates.set(keyCode,true);
			flambe.platform.BasicKeyboard._sharedEvent.init(flambe.platform.BasicKeyboard._sharedEvent.id + 1,flambe.platform.KeyCodes.toKey(keyCode));
			this.down.emit1(flambe.platform.BasicKeyboard._sharedEvent);
		}
		return true;
	}
	,__class__: flambe.platform.BasicKeyboard
}
flambe.subsystem.MouseSystem = function() { }
flambe.subsystem.MouseSystem.__name__ = true;
flambe.platform.BasicMouse = function(pointer) {
	this._pointer = pointer;
	this._source = flambe.input.EventSource.Mouse(flambe.platform.BasicMouse._sharedEvent);
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
	this.scroll = new flambe.util.Signal1();
	this._x = 0;
	this._y = 0;
	this._cursor = flambe.input.MouseCursor.Default;
	this._buttonStates = new haxe.ds.IntMap();
};
flambe.platform.BasicMouse.__name__ = true;
flambe.platform.BasicMouse.__interfaces__ = [flambe.subsystem.MouseSystem];
flambe.platform.BasicMouse.prototype = {
	prepare: function(viewX,viewY,button) {
		this._x = viewX;
		this._y = viewY;
		flambe.platform.BasicMouse._sharedEvent.init(flambe.platform.BasicMouse._sharedEvent.id + 1,viewX,viewY,button);
	}
	,submitScroll: function(viewX,viewY,velocity) {
		this._x = viewX;
		this._y = viewY;
		if(!(this.scroll._head != null)) return false;
		this.scroll.emit1(velocity);
		return true;
	}
	,submitUp: function(viewX,viewY,buttonCode) {
		if(this._buttonStates.exists(buttonCode)) {
			this._buttonStates.remove(buttonCode);
			this.prepare(viewX,viewY,flambe.platform.MouseCodes.toButton(buttonCode));
			this._pointer.submitUp(viewX,viewY,this._source);
			this.up.emit1(flambe.platform.BasicMouse._sharedEvent);
		}
	}
	,submitMove: function(viewX,viewY) {
		this.prepare(viewX,viewY,null);
		this._pointer.submitMove(viewX,viewY,this._source);
		this.move.emit1(flambe.platform.BasicMouse._sharedEvent);
	}
	,submitDown: function(viewX,viewY,buttonCode) {
		if(!this._buttonStates.exists(buttonCode)) {
			this._buttonStates.set(buttonCode,true);
			this.prepare(viewX,viewY,flambe.platform.MouseCodes.toButton(buttonCode));
			this._pointer.submitDown(viewX,viewY,this._source);
			this.down.emit1(flambe.platform.BasicMouse._sharedEvent);
		}
	}
	,__class__: flambe.platform.BasicMouse
}
flambe.subsystem.PointerSystem = function() { }
flambe.subsystem.PointerSystem.__name__ = true;
flambe.subsystem.PointerSystem.prototype = {
	__class__: flambe.subsystem.PointerSystem
}
flambe.platform.BasicPointer = function(x,y,isDown) {
	if(isDown == null) isDown = false;
	if(y == null) y = 0;
	if(x == null) x = 0;
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
	this._x = x;
	this._y = y;
	this._isDown = isDown;
};
flambe.platform.BasicPointer.__name__ = true;
flambe.platform.BasicPointer.__interfaces__ = [flambe.subsystem.PointerSystem];
flambe.platform.BasicPointer.prototype = {
	prepare: function(viewX,viewY,hit,source) {
		this._x = viewX;
		this._y = viewY;
		flambe.platform.BasicPointer._sharedEvent.init(flambe.platform.BasicPointer._sharedEvent.id + 1,viewX,viewY,hit,source);
	}
	,submitUp: function(viewX,viewY,source) {
		if(!this._isDown) return;
		this._isDown = false;
		var chain = [];
		var hit = flambe.display.Sprite.hitTest(flambe.System.root,viewX,viewY);
		if(hit != null) {
			var entity = hit.owner;
			do {
				var sprite = entity._compMap.Sprite_2;
				if(sprite != null) chain.push(sprite);
				entity = entity.parent;
			} while(entity != null);
		}
		this.prepare(viewX,viewY,hit,source);
		var _g = 0;
		while(_g < chain.length) {
			var sprite = chain[_g];
			++_g;
			var signal = sprite._pointerUp;
			if(signal != null) {
				signal.emit1(flambe.platform.BasicPointer._sharedEvent);
				if(flambe.platform.BasicPointer._sharedEvent._stopped) return;
			}
		}
		this.up.emit1(flambe.platform.BasicPointer._sharedEvent);
	}
	,submitMove: function(viewX,viewY,source) {
		var chain = [];
		var hit = flambe.display.Sprite.hitTest(flambe.System.root,viewX,viewY);
		if(hit != null) {
			var entity = hit.owner;
			do {
				var sprite = entity._compMap.Sprite_2;
				if(sprite != null) chain.push(sprite);
				entity = entity.parent;
			} while(entity != null);
		}
		this.prepare(viewX,viewY,hit,source);
		var _g = 0;
		while(_g < chain.length) {
			var sprite = chain[_g];
			++_g;
			var signal = sprite._pointerMove;
			if(signal != null) {
				signal.emit1(flambe.platform.BasicPointer._sharedEvent);
				if(flambe.platform.BasicPointer._sharedEvent._stopped) return;
			}
		}
		this.move.emit1(flambe.platform.BasicPointer._sharedEvent);
	}
	,submitDown: function(viewX,viewY,source) {
		if(this._isDown) return;
		this._isDown = true;
		var chain = [];
		var hit = flambe.display.Sprite.hitTest(flambe.System.root,viewX,viewY);
		if(hit != null) {
			var entity = hit.owner;
			do {
				var sprite = entity._compMap.Sprite_2;
				if(sprite != null) chain.push(sprite);
				entity = entity.parent;
			} while(entity != null);
		}
		this.prepare(viewX,viewY,hit,source);
		var _g = 0;
		while(_g < chain.length) {
			var sprite = chain[_g];
			++_g;
			var signal = sprite._pointerDown;
			if(signal != null) {
				signal.emit1(flambe.platform.BasicPointer._sharedEvent);
				if(flambe.platform.BasicPointer._sharedEvent._stopped) return;
			}
		}
		this.down.emit1(flambe.platform.BasicPointer._sharedEvent);
	}
	,__class__: flambe.platform.BasicPointer
}
flambe.subsystem.TouchSystem = function() { }
flambe.subsystem.TouchSystem.__name__ = true;
flambe.platform.BasicTouch = function(pointer,maxPoints) {
	if(maxPoints == null) maxPoints = 4;
	this._pointer = pointer;
	this._maxPoints = maxPoints;
	this._pointMap = new haxe.ds.IntMap();
	this._points = [];
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
};
flambe.platform.BasicTouch.__name__ = true;
flambe.platform.BasicTouch.__interfaces__ = [flambe.subsystem.TouchSystem];
flambe.platform.BasicTouch.prototype = {
	submitUp: function(id,viewX,viewY) {
		var point = this._pointMap.get(id);
		if(point != null) {
			point.init(viewX,viewY);
			this._pointMap.remove(id);
			HxOverrides.remove(this._points,point);
			if(this._pointerTouch == point) {
				this._pointerTouch = null;
				this._pointer.submitUp(viewX,viewY,point._source);
			}
			this.up.emit1(point);
		}
	}
	,submitMove: function(id,viewX,viewY) {
		var point = this._pointMap.get(id);
		if(point != null) {
			point.init(viewX,viewY);
			if(this._pointerTouch == point) this._pointer.submitMove(viewX,viewY,point._source);
			this.move.emit1(point);
		}
	}
	,submitDown: function(id,viewX,viewY) {
		if(!this._pointMap.exists(id)) {
			var point = new flambe.input.TouchPoint(id);
			point.init(viewX,viewY);
			this._pointMap.set(id,point);
			this._points.push(point);
			if(this._pointerTouch == null) {
				this._pointerTouch = point;
				this._pointer.submitDown(viewX,viewY,point._source);
			}
			this.down.emit1(point);
		}
	}
	,__class__: flambe.platform.BasicTouch
}
flambe.sound = {}
flambe.sound.Sound = function() { }
flambe.sound.Sound.__name__ = true;
flambe.sound.Sound.__interfaces__ = [flambe.asset.Asset];
flambe.sound.Sound.prototype = {
	__class__: flambe.sound.Sound
}
flambe.platform.DummySound = function() {
	flambe.platform.BasicAsset.call(this);
	this._playback = new flambe.platform.DummyPlayback(this);
};
flambe.platform.DummySound.__name__ = true;
flambe.platform.DummySound.__interfaces__ = [flambe.sound.Sound];
flambe.platform.DummySound.getInstance = function() {
	if(flambe.platform.DummySound._instance == null) flambe.platform.DummySound._instance = new flambe.platform.DummySound();
	return flambe.platform.DummySound._instance;
}
flambe.platform.DummySound.__super__ = flambe.platform.BasicAsset;
flambe.platform.DummySound.prototype = $extend(flambe.platform.BasicAsset.prototype,{
	loop: function(volume) {
		if(volume == null) volume = 1.0;
		return this._playback;
	}
	,play: function(volume) {
		if(volume == null) volume = 1.0;
		return this._playback;
	}
	,__class__: flambe.platform.DummySound
});
flambe.sound.Playback = function() { }
flambe.sound.Playback.__name__ = true;
flambe.sound.Playback.__interfaces__ = [flambe.util.Disposable];
flambe.sound.Playback.prototype = {
	__class__: flambe.sound.Playback
}
flambe.platform.DummyPlayback = function(sound) {
	this._sound = sound;
	this.volume = new flambe.animation.AnimatedFloat(0);
};
flambe.platform.DummyPlayback.__name__ = true;
flambe.platform.DummyPlayback.__interfaces__ = [flambe.sound.Playback];
flambe.platform.DummyPlayback.prototype = {
	dispose: function() {
	}
	,set_paused: function(paused) {
		return true;
	}
	,__class__: flambe.platform.DummyPlayback
}
flambe.platform.DummyTouch = function() {
	this.down = new flambe.util.Signal1();
	this.move = new flambe.util.Signal1();
	this.up = new flambe.util.Signal1();
};
flambe.platform.DummyTouch.__name__ = true;
flambe.platform.DummyTouch.__interfaces__ = [flambe.subsystem.TouchSystem];
flambe.platform.DummyTouch.prototype = {
	__class__: flambe.platform.DummyTouch
}
flambe.platform.EventGroup = function() {
	this._entries = [];
};
flambe.platform.EventGroup.__name__ = true;
flambe.platform.EventGroup.__interfaces__ = [flambe.util.Disposable];
flambe.platform.EventGroup.prototype = {
	dispose: function() {
		var _g = 0, _g1 = this._entries;
		while(_g < _g1.length) {
			var entry = _g1[_g];
			++_g;
			entry.dispatcher.removeEventListener(entry.type,entry.listener,false);
		}
		this._entries = [];
	}
	,addDisposingListener: function(dispatcher,type,listener) {
		var _g = this;
		this.addListener(dispatcher,type,function(event) {
			_g.dispose();
			listener(event);
		});
	}
	,addListener: function(dispatcher,type,listener) {
		dispatcher.addEventListener(type,listener,false);
		this._entries.push(new flambe.platform._EventGroup.Entry(dispatcher,type,listener));
	}
	,__class__: flambe.platform.EventGroup
}
flambe.platform._EventGroup = {}
flambe.platform._EventGroup.Entry = function(dispatcher,type,listener) {
	this.dispatcher = dispatcher;
	this.type = type;
	this.listener = listener;
};
flambe.platform._EventGroup.Entry.__name__ = true;
flambe.platform._EventGroup.Entry.prototype = {
	__class__: flambe.platform._EventGroup.Entry
}
flambe.platform.InternalGraphics = function() { }
flambe.platform.InternalGraphics.__name__ = true;
flambe.platform.InternalGraphics.__interfaces__ = [flambe.display.Graphics];
flambe.platform.InternalGraphics.prototype = {
	__class__: flambe.platform.InternalGraphics
}
flambe.platform.KeyCodes = function() { }
flambe.platform.KeyCodes.__name__ = true;
flambe.platform.KeyCodes.toKey = function(keyCode) {
	switch(keyCode) {
	case 65:
		return flambe.input.Key.A;
	case 66:
		return flambe.input.Key.B;
	case 67:
		return flambe.input.Key.C;
	case 68:
		return flambe.input.Key.D;
	case 69:
		return flambe.input.Key.E;
	case 70:
		return flambe.input.Key.F;
	case 71:
		return flambe.input.Key.G;
	case 72:
		return flambe.input.Key.H;
	case 73:
		return flambe.input.Key.I;
	case 74:
		return flambe.input.Key.J;
	case 75:
		return flambe.input.Key.K;
	case 76:
		return flambe.input.Key.L;
	case 77:
		return flambe.input.Key.M;
	case 78:
		return flambe.input.Key.N;
	case 79:
		return flambe.input.Key.O;
	case 80:
		return flambe.input.Key.P;
	case 81:
		return flambe.input.Key.Q;
	case 82:
		return flambe.input.Key.R;
	case 83:
		return flambe.input.Key.S;
	case 84:
		return flambe.input.Key.T;
	case 85:
		return flambe.input.Key.U;
	case 86:
		return flambe.input.Key.V;
	case 87:
		return flambe.input.Key.W;
	case 88:
		return flambe.input.Key.X;
	case 89:
		return flambe.input.Key.Y;
	case 90:
		return flambe.input.Key.Z;
	case 48:
		return flambe.input.Key.Number0;
	case 49:
		return flambe.input.Key.Number1;
	case 50:
		return flambe.input.Key.Number2;
	case 51:
		return flambe.input.Key.Number3;
	case 52:
		return flambe.input.Key.Number4;
	case 53:
		return flambe.input.Key.Number5;
	case 54:
		return flambe.input.Key.Number6;
	case 55:
		return flambe.input.Key.Number7;
	case 56:
		return flambe.input.Key.Number8;
	case 57:
		return flambe.input.Key.Number9;
	case 96:
		return flambe.input.Key.Numpad0;
	case 97:
		return flambe.input.Key.Numpad1;
	case 98:
		return flambe.input.Key.Numpad2;
	case 99:
		return flambe.input.Key.Numpad3;
	case 100:
		return flambe.input.Key.Numpad4;
	case 101:
		return flambe.input.Key.Numpad5;
	case 102:
		return flambe.input.Key.Numpad6;
	case 103:
		return flambe.input.Key.Numpad7;
	case 104:
		return flambe.input.Key.Numpad8;
	case 105:
		return flambe.input.Key.Numpad9;
	case 107:
		return flambe.input.Key.NumpadAdd;
	case 110:
		return flambe.input.Key.NumpadDecimal;
	case 111:
		return flambe.input.Key.NumpadDivide;
	case 108:
		return flambe.input.Key.NumpadEnter;
	case 106:
		return flambe.input.Key.NumpadMultiply;
	case 109:
		return flambe.input.Key.NumpadSubtract;
	case 112:
		return flambe.input.Key.F1;
	case 113:
		return flambe.input.Key.F2;
	case 114:
		return flambe.input.Key.F3;
	case 115:
		return flambe.input.Key.F4;
	case 116:
		return flambe.input.Key.F5;
	case 117:
		return flambe.input.Key.F6;
	case 118:
		return flambe.input.Key.F7;
	case 119:
		return flambe.input.Key.F8;
	case 120:
		return flambe.input.Key.F9;
	case 121:
		return flambe.input.Key.F10;
	case 122:
		return flambe.input.Key.F11;
	case 123:
		return flambe.input.Key.F12;
	case 37:
		return flambe.input.Key.Left;
	case 38:
		return flambe.input.Key.Up;
	case 39:
		return flambe.input.Key.Right;
	case 40:
		return flambe.input.Key.Down;
	case 18:
		return flambe.input.Key.Alt;
	case 192:
		return flambe.input.Key.Backquote;
	case 220:
		return flambe.input.Key.Backslash;
	case 8:
		return flambe.input.Key.Backspace;
	case 20:
		return flambe.input.Key.CapsLock;
	case 188:
		return flambe.input.Key.Comma;
	case 15:
		return flambe.input.Key.Command;
	case 17:
		return flambe.input.Key.Control;
	case 46:
		return flambe.input.Key.Delete;
	case 35:
		return flambe.input.Key.End;
	case 13:
		return flambe.input.Key.Enter;
	case 187:
		return flambe.input.Key.Equals;
	case 27:
		return flambe.input.Key.Escape;
	case 36:
		return flambe.input.Key.Home;
	case 45:
		return flambe.input.Key.Insert;
	case 219:
		return flambe.input.Key.LeftBracket;
	case 189:
		return flambe.input.Key.Minus;
	case 34:
		return flambe.input.Key.PageDown;
	case 33:
		return flambe.input.Key.PageUp;
	case 190:
		return flambe.input.Key.Period;
	case 222:
		return flambe.input.Key.Quote;
	case 221:
		return flambe.input.Key.RightBracket;
	case 186:
		return flambe.input.Key.Semicolon;
	case 16:
		return flambe.input.Key.Shift;
	case 191:
		return flambe.input.Key.Slash;
	case 32:
		return flambe.input.Key.Space;
	case 9:
		return flambe.input.Key.Tab;
	case 16777234:
		return flambe.input.Key.Menu;
	case 16777247:
		return flambe.input.Key.Search;
	}
	return flambe.input.Key.Unknown(keyCode);
}
flambe.platform.MainLoop = function() {
	this._tickables = [];
};
flambe.platform.MainLoop.__name__ = true;
flambe.platform.MainLoop.updateEntity = function(entity,dt) {
	var speed = entity._compMap.SpeedAdjuster_6;
	if(speed != null) {
		speed._realDt = dt;
		dt *= speed.scale._value;
		if(dt <= 0) {
			speed.onUpdate(dt);
			return;
		}
	}
	var p = entity.firstComponent;
	while(p != null) {
		var next = p.next;
		p.onUpdate(dt);
		p = next;
	}
	var p1 = entity.firstChild;
	while(p1 != null) {
		var next = p1.next;
		flambe.platform.MainLoop.updateEntity(p1,dt);
		p1 = next;
	}
}
flambe.platform.MainLoop.prototype = {
	addTickable: function(t) {
		this._tickables.push(t);
	}
	,render: function(renderer) {
		var graphics = renderer.graphics;
		if(graphics != null) {
			renderer.willRender();
			flambe.display.Sprite.render(flambe.System.root,graphics);
			renderer.didRender();
		}
	}
	,update: function(dt) {
		if(dt <= 0) return;
		if(dt > 1) dt = 1;
		var ii = 0;
		while(ii < this._tickables.length) {
			var t = this._tickables[ii];
			if(t == null || t.update(dt)) this._tickables.splice(ii,1); else ++ii;
		}
		flambe.System.volume.update(dt);
		flambe.platform.MainLoop.updateEntity(flambe.System.root,dt);
	}
	,__class__: flambe.platform.MainLoop
}
flambe.platform.MouseCodes = function() { }
flambe.platform.MouseCodes.__name__ = true;
flambe.platform.MouseCodes.toButton = function(buttonCode) {
	switch(buttonCode) {
	case 0:
		return flambe.input.MouseButton.Left;
	case 1:
		return flambe.input.MouseButton.Middle;
	case 2:
		return flambe.input.MouseButton.Right;
	}
	return flambe.input.MouseButton.Unknown(buttonCode);
}
flambe.platform.Renderer = function() { }
flambe.platform.Renderer.__name__ = true;
flambe.platform.Renderer.prototype = {
	__class__: flambe.platform.Renderer
}
flambe.platform.Tickable = function() { }
flambe.platform.Tickable.__name__ = true;
flambe.platform.Tickable.prototype = {
	__class__: flambe.platform.Tickable
}
flambe.platform.html.CanvasGraphics = function(canvas) {
	this._firstDraw = false;
	this._canvasCtx = canvas.getContext("2d");
};
flambe.platform.html.CanvasGraphics.__name__ = true;
flambe.platform.html.CanvasGraphics.__interfaces__ = [flambe.platform.InternalGraphics];
flambe.platform.html.CanvasGraphics.prototype = {
	onResize: function(width,height) {
	}
	,didRender: function() {
	}
	,willRender: function() {
		this._firstDraw = true;
	}
	,applyScissor: function(x,y,width,height) {
		this._canvasCtx.beginPath();
		this._canvasCtx.rect(x | 0,y | 0,width | 0,height | 0);
		this._canvasCtx.clip();
	}
	,setBlendMode: function(blendMode) {
		var op;
		switch( (blendMode)[1] ) {
		case 0:
			op = "source-over";
			break;
		case 1:
			op = "lighter";
			break;
		case 2:
			op = "destination-in";
			break;
		case 3:
			op = "copy";
			break;
		}
		this._canvasCtx.globalCompositeOperation = op;
	}
	,multiplyAlpha: function(factor) {
		this._canvasCtx.globalAlpha *= factor;
	}
	,drawSubImage: function(texture,destX,destY,sourceX,sourceY,sourceW,sourceH) {
		if(this._firstDraw) {
			this._firstDraw = false;
			this._canvasCtx.globalCompositeOperation = "copy";
			this.drawSubImage(texture,destX,destY,sourceX,sourceY,sourceW,sourceH);
			this._canvasCtx.globalCompositeOperation = "source-over";
			return;
		}
		var texture1 = texture;
		this._canvasCtx.drawImage(texture1.image,sourceX | 0,sourceY | 0,sourceW | 0,sourceH | 0,destX | 0,destY | 0,sourceW | 0,sourceH | 0);
	}
	,drawImage: function(texture,x,y) {
		if(this._firstDraw) {
			this._firstDraw = false;
			this._canvasCtx.globalCompositeOperation = "copy";
			this.drawImage(texture,x,y);
			this._canvasCtx.globalCompositeOperation = "source-over";
			return;
		}
		var texture1 = texture;
		this._canvasCtx.drawImage(texture1.image,x | 0,y | 0);
	}
	,restore: function() {
		this._canvasCtx.restore();
	}
	,transform: function(m00,m10,m01,m11,m02,m12) {
		this._canvasCtx.transform(m00,m10,m01,m11,m02,m12);
	}
	,rotate: function(rotation) {
		this._canvasCtx.rotate(rotation * 3.141592653589793 / 180);
	}
	,translate: function(x,y) {
		this._canvasCtx.translate(x | 0,y | 0);
	}
	,save: function() {
		this._canvasCtx.save();
	}
	,__class__: flambe.platform.html.CanvasGraphics
}
flambe.platform.html.CanvasRenderer = function(canvas) {
	this.graphics = new flambe.platform.html.CanvasGraphics(canvas);
	flambe.System.hasGPU.set__(true);
};
flambe.platform.html.CanvasRenderer.__name__ = true;
flambe.platform.html.CanvasRenderer.__interfaces__ = [flambe.platform.Renderer];
flambe.platform.html.CanvasRenderer.prototype = {
	didRender: function() {
		this.graphics.didRender();
	}
	,willRender: function() {
		this.graphics.willRender();
	}
	,createCompressedTexture: function(format,data) {
		return null;
	}
	,getCompressedTextureFormats: function() {
		return [];
	}
	,createTexture: function(image) {
		return new flambe.platform.html.CanvasTexture(flambe.platform.html.CanvasRenderer.CANVAS_TEXTURES?flambe.platform.html.HtmlUtil.createCanvas(image):image);
	}
	,__class__: flambe.platform.html.CanvasRenderer
}
flambe.platform.html.CanvasTexture = function(image) {
	this._graphics = null;
	this.pattern = null;
	flambe.platform.BasicAsset.call(this);
	this.image = image;
};
flambe.platform.html.CanvasTexture.__name__ = true;
flambe.platform.html.CanvasTexture.__interfaces__ = [flambe.display.Texture];
flambe.platform.html.CanvasTexture.__super__ = flambe.platform.BasicAsset;
flambe.platform.html.CanvasTexture.prototype = $extend(flambe.platform.BasicAsset.prototype,{
	onDisposed: function() {
		this.image = null;
		this.pattern = null;
		this._graphics = null;
	}
	,get_height: function() {
		return this.image.height;
	}
	,get_width: function() {
		return this.image.width;
	}
	,__class__: flambe.platform.html.CanvasTexture
});
flambe.platform.html.HtmlAssetPackLoader = function(platform,manifest) {
	flambe.platform.BasicAssetPackLoader.call(this,platform,manifest);
};
flambe.platform.html.HtmlAssetPackLoader.__name__ = true;
flambe.platform.html.HtmlAssetPackLoader.detectImageFormats = function(fn) {
	var formats = [flambe.asset.AssetFormat.PNG,flambe.asset.AssetFormat.JPG,flambe.asset.AssetFormat.GIF];
	var formatTests = 2;
	var checkRemaining = function() {
		--formatTests;
		if(formatTests == 0) fn(formats);
	};
	var webp = js.Browser.document.createElement("img");
	webp.onload = webp.onerror = function(_) {
		if(webp.width == 1) formats.unshift(flambe.asset.AssetFormat.WEBP);
		checkRemaining();
	};
	webp.src = "data:image/webp;base64,UklGRhoAAABXRUJQVlA4TA0AAAAvAAAAEAcQERGIiP4HAA==";
	var jxr = js.Browser.document.createElement("img");
	jxr.onload = jxr.onerror = function(_) {
		if(jxr.width == 1) formats.unshift(flambe.asset.AssetFormat.JXR);
		checkRemaining();
	};
	jxr.src = "data:image/vnd.ms-photo;base64,SUm8AQgAAAAFAAG8AQAQAAAASgAAAIC8BAABAAAAAQAAAIG8BAABAAAAAQAAAMC8BAABAAAAWgAAAMG8BAABAAAAHwAAAAAAAAAkw91vA07+S7GFPXd2jckNV01QSE9UTwAZAYBxAAAAABP/gAAEb/8AAQAAAQAAAA==";
}
flambe.platform.html.HtmlAssetPackLoader.detectAudioFormats = function() {
	var audio = js.Browser.document.createElement("audio");
	if(audio == null || $bind(audio,audio.canPlayType) == null) return [];
	var blacklist = new EReg("\\b(iPhone|iPod|iPad|Android)\\b","");
	var userAgent = js.Browser.window.navigator.userAgent;
	if(!flambe.platform.html.WebAudioSound.get_supported() && blacklist.match(userAgent)) return [];
	var types = [{ format : flambe.asset.AssetFormat.M4A, mimeType : "audio/mp4; codecs=mp4a"},{ format : flambe.asset.AssetFormat.MP3, mimeType : "audio/mpeg"},{ format : flambe.asset.AssetFormat.OPUS, mimeType : "audio/ogg; codecs=opus"},{ format : flambe.asset.AssetFormat.OGG, mimeType : "audio/ogg; codecs=vorbis"},{ format : flambe.asset.AssetFormat.WAV, mimeType : "audio/wav"}];
	var result = [];
	var _g = 0;
	while(_g < types.length) {
		var type = types[_g];
		++_g;
		var canPlayType = "";
		try {
			canPlayType = audio.canPlayType(type.mimeType);
		} catch( _ ) {
		}
		if(canPlayType != "") result.push(type.format);
	}
	return result;
}
flambe.platform.html.HtmlAssetPackLoader.supportsBlob = function() {
	if(flambe.platform.html.HtmlAssetPackLoader._detectBlobSupport) {
		flambe.platform.html.HtmlAssetPackLoader._detectBlobSupport = false;
		var xhr = new XMLHttpRequest();
		xhr.open("GET",".",true);
		xhr.responseType = "blob";
		if(xhr.responseType != "blob") return false;
		flambe.platform.html.HtmlAssetPackLoader._URL = flambe.platform.html.HtmlUtil.loadExtension("URL").value;
	}
	return flambe.platform.html.HtmlAssetPackLoader._URL != null && flambe.platform.html.HtmlAssetPackLoader._URL.createObjectURL != null;
}
flambe.platform.html.HtmlAssetPackLoader.__super__ = flambe.platform.BasicAssetPackLoader;
flambe.platform.html.HtmlAssetPackLoader.prototype = $extend(flambe.platform.BasicAssetPackLoader.prototype,{
	download: function(url,entry,responseType,onLoad) {
		var _g = this;
		var xhr = new XMLHttpRequest();
		var lastActivity = 0.0;
		var start = function() {
			lastActivity = Date.now();
			xhr.open("GET",url,true);
			xhr.responseType = responseType;
			if(xhr.responseType == "") xhr.responseType = "arraybuffer";
			xhr.send();
		};
		var interval = 0;
		if(typeof(xhr.onprogress) != "undefined") {
			var attempts = 4;
			xhr.onprogress = function(event) {
				lastActivity = Date.now();
				_g.handleProgress(entry,event.loaded);
			};
			interval = js.Browser.window.setInterval(function() {
				if(xhr.readyState >= 1 && Date.now() - lastActivity > 5000) {
					xhr.abort();
					--attempts;
					if(attempts > 0) start(); else {
						js.Browser.window.clearInterval(interval);
						_g.handleError(entry,"Request timed out");
					}
				}
			},1000);
		}
		xhr.onload = function(_) {
			js.Browser.window.clearInterval(interval);
			var response = xhr.response;
			if(response == null) response = xhr.responseText; else if(responseType == "blob" && xhr.responseType == "arraybuffer") response = new Blob([xhr.response]);
			onLoad(response);
		};
		xhr.onerror = function(_) {
			js.Browser.window.clearInterval(interval);
			_g.handleError(entry,"Failed to load asset: error #" + xhr.status);
		};
		start();
		return xhr;
	}
	,getAssetFormats: function(fn) {
		var _g = this;
		if(flambe.platform.html.HtmlAssetPackLoader._supportedFormats == null) {
			flambe.platform.html.HtmlAssetPackLoader._supportedFormats = new flambe.util.Promise();
			flambe.platform.html.HtmlAssetPackLoader.detectImageFormats(function(imageFormats) {
				flambe.platform.html.HtmlAssetPackLoader._supportedFormats.set_result(_g._platform.getRenderer().getCompressedTextureFormats().concat(imageFormats).concat(flambe.platform.html.HtmlAssetPackLoader.detectAudioFormats()).concat([flambe.asset.AssetFormat.Data]));
			});
		}
		flambe.platform.html.HtmlAssetPackLoader._supportedFormats.get(fn);
	}
	,loadEntry: function(url,entry) {
		var _g = this;
		switch( (entry.format)[1] ) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
			var image = js.Browser.document.createElement("img");
			var events = new flambe.platform.EventGroup();
			events.addDisposingListener(image,"load",function(_) {
				if(flambe.platform.html.HtmlAssetPackLoader.supportsBlob()) flambe.platform.html.HtmlAssetPackLoader._URL.revokeObjectURL(image.src);
				var texture = _g._platform.getRenderer().createTexture(image);
				if(texture != null) _g.handleLoad(entry,texture); else _g.handleTextureError(entry);
			});
			events.addDisposingListener(image,"error",function(_) {
				_g.handleError(entry,"Failed to load image");
			});
			if(flambe.platform.html.HtmlAssetPackLoader.supportsBlob()) this.download(url,entry,"blob",function(blob) {
				image.src = flambe.platform.html.HtmlAssetPackLoader._URL.createObjectURL(blob);
			}); else image.src = url;
			break;
		case 5:
		case 6:
		case 7:
			this.download(url,entry,"arraybuffer",function(buffer) {
				var texture = _g._platform.getRenderer().createCompressedTexture(entry.format,null);
				if(texture != null) _g.handleLoad(entry,texture); else _g.handleTextureError(entry);
			});
			break;
		case 8:
		case 9:
		case 10:
		case 11:
		case 12:
			if(flambe.platform.html.WebAudioSound.get_supported()) this.download(url,entry,"arraybuffer",function(buffer) {
				flambe.platform.html.WebAudioSound.ctx.decodeAudioData(buffer,function(decoded) {
					_g.handleLoad(entry,new flambe.platform.html.WebAudioSound(decoded));
				},function() {
					_g.handleLoad(entry,flambe.platform.DummySound.getInstance());
				});
			}); else {
				var audio = js.Browser.document.createElement("audio");
				audio.preload = "auto";
				var ref = ++flambe.platform.html.HtmlAssetPackLoader._mediaRefCount;
				if(flambe.platform.html.HtmlAssetPackLoader._mediaElements == null) flambe.platform.html.HtmlAssetPackLoader._mediaElements = new haxe.ds.IntMap();
				flambe.platform.html.HtmlAssetPackLoader._mediaElements.set(ref,audio);
				var events = new flambe.platform.EventGroup();
				events.addDisposingListener(audio,"canplaythrough",function(_) {
					flambe.platform.html.HtmlAssetPackLoader._mediaElements.remove(ref);
					_g.handleLoad(entry,new flambe.platform.html.HtmlSound(audio));
				});
				events.addDisposingListener(audio,"error",function(_) {
					flambe.platform.html.HtmlAssetPackLoader._mediaElements.remove(ref);
					var code = audio.error.code;
					if(code == 3 || code == 4) _g.handleLoad(entry,flambe.platform.DummySound.getInstance()); else _g.handleError(entry,"Failed to load audio: " + audio.error.code);
				});
				events.addListener(audio,"progress",function(_) {
					if(audio.buffered.length > 0 && audio.duration > 0) {
						var progress = audio.buffered.end(0) / audio.duration;
						_g.handleProgress(entry,progress * entry.bytes | 0);
					}
				});
				audio.src = url;
				audio.load();
			}
			break;
		case 13:
			this.download(url,entry,"text",function(text) {
				_g.handleLoad(entry,new flambe.platform.BasicFile(text));
			});
			break;
		}
	}
	,__class__: flambe.platform.html.HtmlAssetPackLoader
});
flambe.platform.html.HtmlMouse = function(pointer,canvas) {
	flambe.platform.BasicMouse.call(this,pointer);
	this._canvas = canvas;
};
flambe.platform.html.HtmlMouse.__name__ = true;
flambe.platform.html.HtmlMouse.__super__ = flambe.platform.BasicMouse;
flambe.platform.html.HtmlMouse.prototype = $extend(flambe.platform.BasicMouse.prototype,{
	__class__: flambe.platform.html.HtmlMouse
});
flambe.platform.html.HtmlSound = function(audioElement) {
	flambe.platform.BasicAsset.call(this);
	this.audioElement = audioElement;
};
flambe.platform.html.HtmlSound.__name__ = true;
flambe.platform.html.HtmlSound.__interfaces__ = [flambe.sound.Sound];
flambe.platform.html.HtmlSound.__super__ = flambe.platform.BasicAsset;
flambe.platform.html.HtmlSound.prototype = $extend(flambe.platform.BasicAsset.prototype,{
	onDisposed: function() {
		this.audioElement = null;
	}
	,loop: function(volume) {
		if(volume == null) volume = 1.0;
		return new flambe.platform.html._HtmlSound.HtmlPlayback(this,volume,true);
	}
	,play: function(volume) {
		if(volume == null) volume = 1.0;
		return new flambe.platform.html._HtmlSound.HtmlPlayback(this,volume,false);
	}
	,__class__: flambe.platform.html.HtmlSound
});
flambe.platform.html._HtmlSound = {}
flambe.platform.html._HtmlSound.HtmlPlayback = function(sound,volume,loop) {
	var _g = this;
	this._sound = sound;
	this._tickableAdded = false;
	this._clonedElement = js.Browser.document.createElement("audio");
	this._clonedElement.loop = loop;
	this._clonedElement.src = sound.audioElement.src;
	this.volume = new flambe.animation.AnimatedFloat(volume,function(_,_1) {
		_g.updateVolume();
	});
	this.updateVolume();
	this.playAudio();
	if(flambe.System.hidden._value) this.set_paused(true);
};
flambe.platform.html._HtmlSound.HtmlPlayback.__name__ = true;
flambe.platform.html._HtmlSound.HtmlPlayback.__interfaces__ = [flambe.platform.Tickable,flambe.sound.Playback];
flambe.platform.html._HtmlSound.HtmlPlayback.prototype = {
	updateVolume: function() {
		this._clonedElement.volume = flambe.System.volume._value * this.volume._value;
	}
	,playAudio: function() {
		var _g = this;
		this._clonedElement.play();
		if(!this._tickableAdded) {
			flambe.platform.html.HtmlPlatform.instance.mainLoop.addTickable(this);
			this._tickableAdded = true;
			this._volumeBinding = flambe.System.volume.get_changed().connect(function(_,_1) {
				_g.updateVolume();
			});
			this._hideBinding = flambe.System.hidden.get_changed().connect(function(hidden,_) {
				if(hidden) {
					_g._wasPaused = _g._clonedElement.paused;
					_g.set_paused(true);
				} else _g.set_paused(_g._wasPaused);
			});
		}
	}
	,dispose: function() {
		this.set_paused(true);
	}
	,update: function(dt) {
		this.volume.update(dt);
		if(this._clonedElement.ended || this._clonedElement.paused) {
			this._tickableAdded = false;
			this._volumeBinding.dispose();
			this._hideBinding.dispose();
			return true;
		}
		return false;
	}
	,set_paused: function(paused) {
		if(this._clonedElement.paused != paused) {
			if(paused) this._clonedElement.pause(); else this.playAudio();
		}
		return paused;
	}
	,__class__: flambe.platform.html._HtmlSound.HtmlPlayback
}
flambe.subsystem.StageSystem = function() { }
flambe.subsystem.StageSystem.__name__ = true;
flambe.subsystem.StageSystem.prototype = {
	__class__: flambe.subsystem.StageSystem
}
flambe.platform.html.HtmlStage = function(canvas) {
	var _g = this;
	this._canvas = canvas;
	this.resize = new flambe.util.Signal0();
	this.scaleFactor = flambe.platform.html.HtmlStage.computeScaleFactor();
	if(this.scaleFactor != 1) {
		flambe.platform.html.HtmlUtil.setVendorStyle(this._canvas,"transform-origin","top left");
		flambe.platform.html.HtmlUtil.setVendorStyle(this._canvas,"transform","scale(" + 1 / this.scaleFactor + ")");
	}
	if(flambe.platform.html.HtmlUtil.SHOULD_HIDE_MOBILE_BROWSER) {
		js.Browser.window.addEventListener("orientationchange",function(_) {
			flambe.platform.html.HtmlUtil.callLater($bind(_g,_g.hideMobileBrowser),200);
		},false);
		this.hideMobileBrowser();
	}
	js.Browser.window.addEventListener("resize",$bind(this,this.onWindowResize),false);
	this.onWindowResize(null);
	this.orientation = new flambe.util.Value(null);
	if(js.Browser.window.orientation != null) {
		js.Browser.window.addEventListener("orientationchange",$bind(this,this.onOrientationChange),false);
		this.onOrientationChange(null);
	}
	this.fullscreen = new flambe.util.Value(false);
	flambe.platform.html.HtmlUtil.addVendorListener(js.Browser.document,"fullscreenchange",function(_) {
		_g.updateFullscreen();
	},false);
	this.updateFullscreen();
};
flambe.platform.html.HtmlStage.__name__ = true;
flambe.platform.html.HtmlStage.__interfaces__ = [flambe.subsystem.StageSystem];
flambe.platform.html.HtmlStage.computeScaleFactor = function() {
	return 1;
}
flambe.platform.html.HtmlStage.prototype = {
	updateFullscreen: function() {
		var state = flambe.platform.html.HtmlUtil.loadFirstExtension(["fullscreen","fullScreen","isFullScreen"],js.Browser.document).value;
		this.fullscreen.set__(state == true);
	}
	,onOrientationChange: function(_) {
		var value = flambe.platform.html.HtmlUtil.orientation(js.Browser.window.orientation);
		this.orientation.set__(value);
	}
	,hideMobileBrowser: function() {
		var _g = this;
		var mobileAddressBar = 100;
		var htmlStyle = js.Browser.document.documentElement.style;
		htmlStyle.height = js.Browser.window.innerHeight + mobileAddressBar + "px";
		htmlStyle.width = js.Browser.window.innerWidth + "px";
		htmlStyle.overflow = "visible";
		flambe.platform.html.HtmlUtil.callLater(function() {
			flambe.platform.html.HtmlUtil.hideMobileBrowser();
			flambe.platform.html.HtmlUtil.callLater(function() {
				htmlStyle.height = js.Browser.window.innerHeight + "px";
				_g.onWindowResize(null);
			},100);
		});
	}
	,resizeCanvas: function(width,height) {
		var scaledWidth = this.scaleFactor * width;
		var scaledHeight = this.scaleFactor * height;
		if(this._canvas.width == scaledWidth && this._canvas.height == scaledHeight) return false;
		this._canvas.width = scaledWidth | 0;
		this._canvas.height = scaledHeight | 0;
		this.resize.emit0();
		return true;
	}
	,onWindowResize: function(_) {
		var container = this._canvas.parentElement;
		var rect = container.getBoundingClientRect();
		this.resizeCanvas(rect.width,rect.height);
	}
	,get_height: function() {
		return this._canvas.height;
	}
	,get_width: function() {
		return this._canvas.width;
	}
	,__class__: flambe.platform.html.HtmlStage
}
flambe.platform.html.HtmlUtil = function() { }
flambe.platform.html.HtmlUtil.__name__ = true;
flambe.platform.html.HtmlUtil.callLater = function(func,delay) {
	if(delay == null) delay = 0;
	js.Browser.window.setTimeout(func,delay);
}
flambe.platform.html.HtmlUtil.hideMobileBrowser = function() {
	js.Browser.window.scrollTo(1,0);
}
flambe.platform.html.HtmlUtil.loadExtension = function(name,obj) {
	if(obj == null) obj = js.Browser.window;
	var extension = Reflect.field(obj,name);
	if(extension != null) return { prefix : "", field : name, value : extension};
	var capitalized = name.charAt(0).toUpperCase() + HxOverrides.substr(name,1,null);
	var _g = 0, _g1 = flambe.platform.html.HtmlUtil.VENDOR_PREFIXES;
	while(_g < _g1.length) {
		var prefix = _g1[_g];
		++_g;
		var field = prefix + capitalized;
		var extension1 = Reflect.field(obj,field);
		if(extension1 != null) return { prefix : prefix, field : field, value : extension1};
	}
	return { prefix : null, field : null, value : null};
}
flambe.platform.html.HtmlUtil.loadFirstExtension = function(names,obj) {
	var _g = 0;
	while(_g < names.length) {
		var name = names[_g];
		++_g;
		var extension = flambe.platform.html.HtmlUtil.loadExtension(name,obj);
		if(extension.field != null) return extension;
	}
	return { prefix : null, field : null, value : null};
}
flambe.platform.html.HtmlUtil.polyfill = function(name,obj) {
	if(obj == null) obj = js.Browser.window;
	var value = flambe.platform.html.HtmlUtil.loadExtension(name,obj).value;
	if(value == null) return false;
	obj[name] = value;
	return true;
}
flambe.platform.html.HtmlUtil.setVendorStyle = function(element,name,value) {
	var style = element.style;
	var _g = 0, _g1 = flambe.platform.html.HtmlUtil.VENDOR_PREFIXES;
	while(_g < _g1.length) {
		var prefix = _g1[_g];
		++_g;
		style.setProperty("-" + prefix + "-" + name,value);
	}
	style.setProperty(name,value);
}
flambe.platform.html.HtmlUtil.addVendorListener = function(dispatcher,type,listener,useCapture) {
	var _g = 0, _g1 = flambe.platform.html.HtmlUtil.VENDOR_PREFIXES;
	while(_g < _g1.length) {
		var prefix = _g1[_g];
		++_g;
		dispatcher.addEventListener(prefix + type,listener,useCapture);
	}
	dispatcher.addEventListener(type,listener,useCapture);
}
flambe.platform.html.HtmlUtil.orientation = function(angle) {
	switch(angle) {
	case -90:case 90:
		return flambe.display.Orientation.Landscape;
	default:
		return flambe.display.Orientation.Portrait;
	}
}
flambe.platform.html.HtmlUtil.createEmptyCanvas = function(width,height) {
	var canvas = js.Browser.document.createElement("canvas");
	canvas.width = width;
	canvas.height = height;
	return canvas;
}
flambe.platform.html.HtmlUtil.createCanvas = function(source) {
	var canvas = flambe.platform.html.HtmlUtil.createEmptyCanvas(source.width,source.height);
	var ctx = canvas.getContext("2d");
	ctx.save();
	ctx.globalCompositeOperation = "copy";
	ctx.drawImage(source,0,0);
	ctx.restore();
	return canvas;
}
flambe.platform.html.HtmlUtil.detectSlowDriver = function(gl) {
	var windows = js.Browser.navigator.platform.indexOf("Win") >= 0;
	if(windows) {
		var chrome = js.Browser.window.chrome != null;
		if(chrome) {
			var _g = 0, _g1 = gl.getSupportedExtensions();
			while(_g < _g1.length) {
				var ext = _g1[_g];
				++_g;
				if(ext.indexOf("WEBGL_compressed_texture") >= 0) return false;
			}
			return true;
		}
	}
	return false;
}
flambe.platform.html.HtmlUtil.fixAndroidMath = function() {
	if(js.Browser.navigator.userAgent.indexOf("Linux; U; Android 4") >= 0) {
		var sin = Math.sin, cos = Math.cos;
		Math.sin = function(x) {
			return x == 0?0:sin(x);
		};
		Math.cos = function(x) {
			return x == 0?1:cos(x);
		};
	}
}
flambe.platform.html.WebAudioSound = function(buffer) {
	flambe.platform.BasicAsset.call(this);
	this.buffer = buffer;
};
flambe.platform.html.WebAudioSound.__name__ = true;
flambe.platform.html.WebAudioSound.__interfaces__ = [flambe.sound.Sound];
flambe.platform.html.WebAudioSound.get_supported = function() {
	if(flambe.platform.html.WebAudioSound._detectSupport) {
		flambe.platform.html.WebAudioSound._detectSupport = false;
		var AudioContext = flambe.platform.html.HtmlUtil.loadExtension("AudioContext").value;
		if(AudioContext != null) {
			flambe.platform.html.WebAudioSound.ctx = new AudioContext();
			flambe.platform.html.WebAudioSound.gain = flambe.platform.html.WebAudioSound.ctx.createGainNode();
			flambe.platform.html.WebAudioSound.gain.connect(flambe.platform.html.WebAudioSound.ctx.destination);
			flambe.System.volume.watch(function(volume,_) {
				flambe.platform.html.WebAudioSound.gain.gain.value = volume;
			});
		}
	}
	return flambe.platform.html.WebAudioSound.ctx != null;
}
flambe.platform.html.WebAudioSound.__super__ = flambe.platform.BasicAsset;
flambe.platform.html.WebAudioSound.prototype = $extend(flambe.platform.BasicAsset.prototype,{
	onDisposed: function() {
		this.buffer = null;
	}
	,get_duration: function() {
		return this.buffer.duration;
	}
	,loop: function(volume) {
		if(volume == null) volume = 1.0;
		return new flambe.platform.html._WebAudioSound.WebAudioPlayback(this,volume,true);
	}
	,play: function(volume) {
		if(volume == null) volume = 1.0;
		return new flambe.platform.html._WebAudioSound.WebAudioPlayback(this,volume,false);
	}
	,__class__: flambe.platform.html.WebAudioSound
});
flambe.platform.html._WebAudioSound = {}
flambe.platform.html._WebAudioSound.WebAudioPlayback = function(sound,volume,loop) {
	var _g = this;
	this._sound = sound;
	this._head = flambe.platform.html.WebAudioSound.gain;
	this._sourceNode = flambe.platform.html.WebAudioSound.ctx.createBufferSource();
	this._sourceNode.buffer = sound.buffer;
	this._sourceNode.loop = loop;
	this._sourceNode.noteOn(0);
	this.playAudio();
	this.volume = new flambe.animation.AnimatedFloat(volume,function(v,_) {
		_g.setVolume(v);
	});
	if(volume != 1) this.setVolume(volume);
	if(flambe.System.hidden._value) this.set_paused(true);
};
flambe.platform.html._WebAudioSound.WebAudioPlayback.__name__ = true;
flambe.platform.html._WebAudioSound.WebAudioPlayback.__interfaces__ = [flambe.platform.Tickable,flambe.sound.Playback];
flambe.platform.html._WebAudioSound.WebAudioPlayback.prototype = {
	playAudio: function() {
		var _g = this;
		this._sourceNode.connect(this._head);
		this._startedAt = flambe.platform.html.WebAudioSound.ctx.currentTime;
		this._pausedAt = -1;
		if(!this._tickableAdded) {
			flambe.platform.html.HtmlPlatform.instance.mainLoop.addTickable(this);
			this._tickableAdded = true;
			this._hideBinding = flambe.System.hidden.get_changed().connect(function(hidden,_) {
				if(hidden) {
					_g._wasPaused = _g._pausedAt >= 0;
					_g.set_paused(true);
				} else _g.set_paused(_g._wasPaused);
			});
		}
	}
	,insertNode: function(head) {
		if(!(this._pausedAt >= 0)) {
			this._sourceNode.disconnect();
			this._sourceNode.connect(head);
		}
		head.connect(this._head);
		this._head = head;
	}
	,setVolume: function(volume) {
		if(this._gainNode == null) {
			this._gainNode = flambe.platform.html.WebAudioSound.ctx.createGainNode();
			this.insertNode(this._gainNode);
		}
		this._gainNode.gain.value = volume;
	}
	,dispose: function() {
		this.set_paused(true);
	}
	,update: function(dt) {
		this.volume.update(dt);
		if(this._sourceNode.playbackState == 3 || this._pausedAt >= 0) {
			this._tickableAdded = false;
			this._hideBinding.dispose();
			return true;
		}
		return false;
	}
	,get_position: function() {
		if(this._sourceNode.playbackState == 3) return this._sound.get_duration(); else if(this._pausedAt >= 0) return this._pausedAt; else {
			var elapsed = flambe.platform.html.WebAudioSound.ctx.currentTime - this._startedAt;
			return elapsed % this._sound.get_duration();
		}
	}
	,set_paused: function(paused) {
		if(paused != this._pausedAt >= 0) {
			if(paused) {
				this._sourceNode.disconnect();
				this._pausedAt = this.get_position();
			} else this.playAudio();
		}
		return paused;
	}
	,__class__: flambe.platform.html._WebAudioSound.WebAudioPlayback
}
flambe.platform.html.WebGLBatcher = function(gl) {
	this._backbufferHeight = 0;
	this._backbufferWidth = 0;
	this._dataOffset = 0;
	this._maxQuads = 0;
	this._quads = 0;
	this._pendingSetScissor = false;
	this._currentRenderTarget = null;
	this._currentTexture = null;
	this._currentShader = null;
	this._currentBlendMode = null;
	this._lastScissor = null;
	this._lastTexture = null;
	this._lastShader = null;
	this._lastRenderTarget = null;
	this._lastBlendMode = null;
	this._gl = gl;
	gl.clearColor(0,0,0,1);
	gl.enable(3042);
	gl.pixelStorei(37441,1);
	this._vertexBuffer = gl.createBuffer();
	gl.bindBuffer(34962,this._vertexBuffer);
	this._quadIndexBuffer = gl.createBuffer();
	gl.bindBuffer(34963,this._quadIndexBuffer);
	this._drawImageShader = new flambe.platform.shader.DrawImageGL(gl);
	this._drawPatternShader = new flambe.platform.shader.DrawPatternGL(gl);
	this._fillRectShader = new flambe.platform.shader.FillRectGL(gl);
	this.resize(16);
};
flambe.platform.html.WebGLBatcher.__name__ = true;
flambe.platform.html.WebGLBatcher.prototype = {
	resize: function(maxQuads) {
		this.flush();
		if(maxQuads > 1024) return;
		this._maxQuads = maxQuads;
		this.data = new Float32Array(maxQuads * 4 * 6);
		this._gl.bufferData(34962,this.data.length * 4,35040);
		var indices = new Uint16Array(6 * maxQuads);
		var _g = 0;
		while(_g < maxQuads) {
			var ii = _g++;
			indices[ii * 6] = ii * 4;
			indices[ii * 6 + 1] = ii * 4 + 1;
			indices[ii * 6 + 2] = ii * 4 + 2;
			indices[ii * 6 + 3] = ii * 4 + 2;
			indices[ii * 6 + 4] = ii * 4 + 3;
			indices[ii * 6 + 5] = ii * 4;
		}
		this._gl.bufferData(34963,indices,35044);
	}
	,flush: function() {
		if(this._quads < 1) return;
		if(this._lastRenderTarget != this._currentRenderTarget) {
			if(this._lastRenderTarget != null) {
				this._gl.bindFramebuffer(36160,this._lastRenderTarget.framebuffer);
				this._gl.viewport(0,0,this._lastRenderTarget._width,this._lastRenderTarget._height);
			} else {
				this._gl.bindFramebuffer(36160,null);
				this._gl.viewport(0,0,this._backbufferWidth,this._backbufferHeight);
			}
			this._currentRenderTarget = this._lastRenderTarget;
		}
		if(this._lastBlendMode != this._currentBlendMode) {
			var _g = this;
			switch( (_g._lastBlendMode)[1] ) {
			case 0:
				this._gl.blendFunc(1,771);
				break;
			case 1:
				this._gl.blendFunc(1,1);
				break;
			case 2:
				this._gl.blendFunc(0,770);
				break;
			case 3:
				this._gl.blendFunc(1,0);
				break;
			}
			this._currentBlendMode = this._lastBlendMode;
		}
		if(this._pendingSetScissor) {
			if(this._lastScissor != null) {
				this._gl.enable(3089);
				this._gl.scissor(this._lastScissor.x | 0,this._lastScissor.y | 0,this._lastScissor.width | 0,this._lastScissor.height | 0);
			} else this._gl.disable(3089);
			this._pendingSetScissor = false;
		}
		if(this._lastTexture != this._currentTexture) {
			this._gl.bindTexture(3553,this._lastTexture.nativeTexture);
			this._currentTexture = this._lastTexture;
		}
		if(this._lastShader != this._currentShader) {
			this._lastShader.useProgram();
			this._lastShader.prepare();
			this._currentShader = this._lastShader;
		}
		if(this._lastShader == this._drawPatternShader) this._drawPatternShader.setMaxUV(this._lastTexture.maxU,this._lastTexture.maxV);
		this._gl.bufferData(34962,this.data.subarray(0,this._dataOffset),35040);
		this._gl.drawElements(4,6 * this._quads,5123,0);
		this._quads = 0;
		this._dataOffset = 0;
	}
	,prepareQuad: function(elementsPerVertex,renderTarget,blendMode,scissor,shader) {
		if(renderTarget != this._lastRenderTarget) {
			this.flush();
			this._lastRenderTarget = renderTarget;
		}
		if(blendMode != this._lastBlendMode) {
			this.flush();
			this._lastBlendMode = blendMode;
		}
		if(shader != this._lastShader) {
			this.flush();
			this._lastShader = shader;
		}
		if(scissor != null || this._lastScissor != null) {
			if(scissor == null || this._lastScissor == null || !this._lastScissor.equals(scissor)) {
				this.flush();
				this._lastScissor = scissor != null?scissor.clone(this._lastScissor):null;
				this._pendingSetScissor = true;
			}
		}
		if(this._quads >= this._maxQuads) this.resize(2 * this._maxQuads);
		++this._quads;
		var offset = this._dataOffset;
		this._dataOffset += 4 * elementsPerVertex;
		return offset;
	}
	,prepareDrawImage: function(renderTarget,blendMode,scissor,texture) {
		if(texture != this._lastTexture) {
			this.flush();
			this._lastTexture = texture;
		}
		return this.prepareQuad(5,renderTarget,blendMode,scissor,this._drawImageShader);
	}
	,deleteFramebuffer: function(texture) {
		if(texture == this._lastRenderTarget) {
			this.flush();
			this._lastRenderTarget = null;
			this._currentRenderTarget = null;
		}
		this._gl.deleteFramebuffer(texture.framebuffer);
	}
	,deleteTexture: function(texture) {
		if(texture == this._lastTexture) {
			this.flush();
			this._lastTexture = null;
			this._currentTexture = null;
		}
		this._gl.deleteTexture(texture.nativeTexture);
	}
	,bindTexture: function(texture) {
		this.flush();
		this._lastTexture = null;
		this._currentTexture = null;
		this._gl.bindTexture(3553,texture);
	}
	,didRender: function() {
		this.flush();
	}
	,willRender: function() {
	}
	,resizeBackbuffer: function(width,height) {
		this._gl.viewport(0,0,width,height);
		this._backbufferWidth = width;
		this._backbufferHeight = height;
	}
	,__class__: flambe.platform.html.WebGLBatcher
}
flambe.platform.html.WebGLGraphics = function(batcher,renderTarget) {
	this._stateList = null;
	this._inverseProjection = null;
	if(flambe.platform.html.WebGLGraphics._scratchQuadArray == null) flambe.platform.html.WebGLGraphics._scratchQuadArray = new Float32Array(8);
	this._batcher = batcher;
	this._renderTarget = renderTarget;
};
flambe.platform.html.WebGLGraphics.__name__ = true;
flambe.platform.html.WebGLGraphics.__interfaces__ = [flambe.platform.InternalGraphics];
flambe.platform.html.WebGLGraphics.prototype = {
	transformQuad: function(x,y,width,height) {
		var x2 = x + width;
		var y2 = y + height;
		var pos = flambe.platform.html.WebGLGraphics._scratchQuadArray;
		pos[0] = x;
		pos[1] = y;
		pos[2] = x2;
		pos[3] = y;
		pos[4] = x2;
		pos[5] = y2;
		pos[6] = x;
		pos[7] = y2;
		this._stateList.matrix.transformArray(pos,8,pos);
		return pos;
	}
	,onResize: function(width,height) {
		this._stateList = new flambe.platform.html._WebGLGraphics.DrawingState();
		var flip = this._renderTarget != null?-1:1;
		this._stateList.matrix.set(2 / width,0,0,flip * -2 / height,-1,flip);
		this._inverseProjection = new flambe.math.Matrix();
		this._inverseProjection.set(2 / width,0,0,2 / height,-1,-1);
		this._inverseProjection.invert();
	}
	,didRender: function() {
		this._batcher.didRender();
	}
	,willRender: function() {
		this._batcher.willRender();
	}
	,applyScissor: function(x,y,width,height) {
		var state = this._stateList;
		var rect = flambe.platform.html.WebGLGraphics._scratchQuadArray;
		rect[0] = x;
		rect[1] = y;
		rect[2] = x + width;
		rect[3] = y + height;
		state.matrix.transformArray(rect,4,rect);
		this._inverseProjection.transformArray(rect,4,rect);
		x = rect[0];
		y = rect[1];
		width = rect[2] - x;
		height = rect[3] - y;
		if(width < 0) {
			x += width;
			width = -width;
		}
		if(height < 0) {
			y += height;
			height = -height;
		}
		state.applyScissor(x,y,width,height);
	}
	,setBlendMode: function(blendMode) {
		this._stateList.blendMode = blendMode;
	}
	,multiplyAlpha: function(factor) {
		this._stateList.alpha *= factor;
	}
	,drawSubImage: function(texture,destX,destY,sourceX,sourceY,sourceW,sourceH) {
		var state = this._stateList;
		var texture1 = texture;
		var pos = this.transformQuad(destX,destY,sourceW,sourceH);
		var w = texture1._width;
		var h = texture1._height;
		var u1 = texture1.maxU * sourceX / w;
		var v1 = texture1.maxV * sourceY / h;
		var u2 = texture1.maxU * (sourceX + sourceW) / w;
		var v2 = texture1.maxV * (sourceY + sourceH) / h;
		var alpha = state.alpha;
		var offset = this._batcher.prepareDrawImage(this._renderTarget,state.blendMode,state.scissor,texture1);
		var data = this._batcher.data;
		data[offset] = pos[0];
		data[++offset] = pos[1];
		data[++offset] = u1;
		data[++offset] = v1;
		data[++offset] = alpha;
		data[++offset] = pos[2];
		data[++offset] = pos[3];
		data[++offset] = u2;
		data[++offset] = v1;
		data[++offset] = alpha;
		data[++offset] = pos[4];
		data[++offset] = pos[5];
		data[++offset] = u2;
		data[++offset] = v2;
		data[++offset] = alpha;
		data[++offset] = pos[6];
		data[++offset] = pos[7];
		data[++offset] = u1;
		data[++offset] = v2;
		data[++offset] = alpha;
	}
	,drawImage: function(texture,x,y) {
		this.drawSubImage(texture,x,y,0,0,texture.get_width(),texture.get_height());
	}
	,restore: function() {
		this._stateList = this._stateList.prev;
	}
	,transform: function(m00,m10,m01,m11,m02,m12) {
		var state = this._stateList;
		flambe.platform.html.WebGLGraphics._scratchMatrix.set(m00,m10,m01,m11,m02,m12);
		flambe.math.Matrix.multiply(state.matrix,flambe.platform.html.WebGLGraphics._scratchMatrix,state.matrix);
	}
	,rotate: function(rotation) {
		var matrix = this._stateList.matrix;
		rotation = rotation * 3.141592653589793 / 180;
		var sin = Math.sin(rotation);
		var cos = Math.cos(rotation);
		var m00 = matrix.m00;
		var m10 = matrix.m10;
		var m01 = matrix.m01;
		var m11 = matrix.m11;
		matrix.m00 = m00 * cos + m01 * sin;
		matrix.m10 = m10 * cos + m11 * sin;
		matrix.m01 = m01 * cos - m00 * sin;
		matrix.m11 = m11 * cos - m10 * sin;
	}
	,translate: function(x,y) {
		var matrix = this._stateList.matrix;
		matrix.m02 += matrix.m00 * x + matrix.m01 * y;
		matrix.m12 += matrix.m10 * x + matrix.m11 * y;
	}
	,save: function() {
		var current = this._stateList;
		var state = this._stateList.next;
		if(state == null) {
			state = new flambe.platform.html._WebGLGraphics.DrawingState();
			state.prev = current;
			current.next = state;
		}
		current.matrix.clone(state.matrix);
		state.alpha = current.alpha;
		state.blendMode = current.blendMode;
		state.scissor = current.scissor != null?current.scissor.clone(state.scissor):null;
		this._stateList = state;
	}
	,__class__: flambe.platform.html.WebGLGraphics
}
flambe.platform.html._WebGLGraphics = {}
flambe.platform.html._WebGLGraphics.DrawingState = function() {
	this.next = null;
	this.prev = null;
	this.scissor = null;
	this.matrix = new flambe.math.Matrix();
	this.alpha = 1;
	this.blendMode = flambe.display.BlendMode.Normal;
};
flambe.platform.html._WebGLGraphics.DrawingState.__name__ = true;
flambe.platform.html._WebGLGraphics.DrawingState.prototype = {
	applyScissor: function(x,y,width,height) {
		if(this.scissor != null) {
			var x1 = flambe.math.FMath.max(this.scissor.x,x);
			var y1 = flambe.math.FMath.max(this.scissor.y,y);
			var x2 = flambe.math.FMath.min(this.scissor.x + this.scissor.width,x + width);
			var y2 = flambe.math.FMath.min(this.scissor.y + this.scissor.height,y + height);
			x = x1;
			y = y1;
			width = x2 - x1;
			height = y2 - y1;
		} else this.scissor = new flambe.math.Rectangle();
		this.scissor.set(Math.round(x),Math.round(y),Math.round(width),Math.round(height));
	}
	,__class__: flambe.platform.html._WebGLGraphics.DrawingState
}
flambe.platform.html.WebGLRenderer = function(stage,gl) {
	var _g = this;
	this.gl = gl;
	gl.canvas.addEventListener("webglcontextlost",function(event) {
		event.preventDefault();
		flambe.System.hasGPU.set__(false);
	},false);
	gl.canvas.addEventListener("webglcontextrestore",function(event) {
		_g.init();
	},false);
	stage.resize.connect($bind(this,this.onResize));
	this.init();
};
flambe.platform.html.WebGLRenderer.__name__ = true;
flambe.platform.html.WebGLRenderer.__interfaces__ = [flambe.platform.Renderer];
flambe.platform.html.WebGLRenderer.prototype = {
	init: function() {
		this.batcher = new flambe.platform.html.WebGLBatcher(this.gl);
		this.graphics = new flambe.platform.html.WebGLGraphics(this.batcher,null);
		this.onResize();
		flambe.System.hasGPU.set__(true);
	}
	,onResize: function() {
		var width = this.gl.canvas.width, height = this.gl.canvas.height;
		this.batcher.resizeBackbuffer(width,height);
		this.graphics.onResize(width,height);
	}
	,didRender: function() {
		this.graphics.didRender();
	}
	,willRender: function() {
		this.graphics.willRender();
	}
	,createCompressedTexture: function(format,data) {
		if(this.gl.isContextLost()) return null;
		return null;
	}
	,getCompressedTextureFormats: function() {
		return [];
	}
	,createTexture: function(image) {
		if(this.gl.isContextLost()) return null;
		var texture = new flambe.platform.html.WebGLTexture(this,image.width,image.height);
		texture.uploadImageData(image);
		return texture;
	}
	,__class__: flambe.platform.html.WebGLRenderer
}
flambe.platform.html.WebGLTexture = function(renderer,width,height) {
	this._graphics = null;
	this.framebuffer = null;
	flambe.platform.BasicAsset.call(this);
	this._renderer = renderer;
	this._width = width;
	this._height = height;
	this._widthPow2 = flambe.platform.html.WebGLTexture.nextPowerOfTwo(width);
	this._heightPow2 = flambe.platform.html.WebGLTexture.nextPowerOfTwo(height);
	this.maxU = width / this._widthPow2;
	this.maxV = height / this._heightPow2;
	var gl = renderer.gl;
	this.nativeTexture = gl.createTexture();
	renderer.batcher.bindTexture(this.nativeTexture);
	gl.texParameteri(3553,10242,33071);
	gl.texParameteri(3553,10243,33071);
	gl.texParameteri(3553,10240,9729);
	gl.texParameteri(3553,10241,9728);
};
flambe.platform.html.WebGLTexture.__name__ = true;
flambe.platform.html.WebGLTexture.__interfaces__ = [flambe.display.Texture];
flambe.platform.html.WebGLTexture.nextPowerOfTwo = function(n) {
	var p = 1;
	while(p < n) p <<= 1;
	return p;
}
flambe.platform.html.WebGLTexture.drawBorder = function(canvas,width,height) {
	var ctx = canvas.getContext("2d");
	ctx.drawImage(canvas,width - 1,0,1,height,width,0,1,height);
	ctx.drawImage(canvas,0,height - 1,width,1,0,height,width,1);
}
flambe.platform.html.WebGLTexture.__super__ = flambe.platform.BasicAsset;
flambe.platform.html.WebGLTexture.prototype = $extend(flambe.platform.BasicAsset.prototype,{
	get_height: function() {
		return this._height;
	}
	,get_width: function() {
		return this._width;
	}
	,onDisposed: function() {
		var batcher = this._renderer.batcher;
		batcher.deleteTexture(this);
		if(this.framebuffer != null) batcher.deleteFramebuffer(this);
		this.nativeTexture = null;
		this.framebuffer = null;
		this._graphics = null;
	}
	,uploadImageData: function(image) {
		if(this._widthPow2 != image.width || this._heightPow2 != image.height) {
			var resized = flambe.platform.html.HtmlUtil.createEmptyCanvas(this._widthPow2,this._heightPow2);
			resized.getContext("2d").drawImage(image,0,0);
			flambe.platform.html.WebGLTexture.drawBorder(resized,image.width,image.height);
			image = resized;
		}
		this._renderer.batcher.bindTexture(this.nativeTexture);
		var gl = this._renderer.gl;
		gl.texImage2D(3553,0,6408,6408,5121,image);
	}
	,__class__: flambe.platform.html.WebGLTexture
});
flambe.platform.shader = {}
flambe.platform.shader.ShaderGL = function(gl,vertSource,fragSource) {
	fragSource = ["#ifdef GL_ES","precision mediump float;","#endif"].join("\n") + "\n" + fragSource;
	this._gl = gl;
	this._program = gl.createProgram();
	gl.attachShader(this._program,flambe.platform.shader.ShaderGL.createShader(gl,35633,vertSource));
	gl.attachShader(this._program,flambe.platform.shader.ShaderGL.createShader(gl,35632,fragSource));
	gl.linkProgram(this._program);
	gl.useProgram(this._program);
};
flambe.platform.shader.ShaderGL.__name__ = true;
flambe.platform.shader.ShaderGL.createShader = function(gl,type,source) {
	var shader = gl.createShader(type);
	gl.shaderSource(shader,source);
	gl.compileShader(shader);
	return shader;
}
flambe.platform.shader.ShaderGL.prototype = {
	getUniformLocation: function(name) {
		var loc = this._gl.getUniformLocation(this._program,name);
		return loc;
	}
	,getAttribLocation: function(name) {
		var loc = this._gl.getAttribLocation(this._program,name);
		return loc;
	}
	,prepare: function() {
		null;
	}
	,useProgram: function() {
		this._gl.useProgram(this._program);
	}
	,__class__: flambe.platform.shader.ShaderGL
}
flambe.platform.shader.DrawImageGL = function(gl) {
	flambe.platform.shader.ShaderGL.call(this,gl,["attribute highp vec2 a_pos;","attribute mediump vec2 a_uv;","attribute lowp float a_alpha;","varying mediump vec2 v_uv;","varying lowp float v_alpha;","void main (void) {","v_uv = a_uv;","v_alpha = a_alpha;","gl_Position = vec4(a_pos, 0, 1);","}"].join("\n"),["varying mediump vec2 v_uv;","varying lowp float v_alpha;","uniform lowp sampler2D u_texture;","void main (void) {","gl_FragColor = texture2D(u_texture, v_uv) * v_alpha;","}"].join("\n"));
	this.a_pos = this.getAttribLocation("a_pos");
	this.a_uv = this.getAttribLocation("a_uv");
	this.a_alpha = this.getAttribLocation("a_alpha");
	this.u_texture = this.getUniformLocation("u_texture");
	this.setTexture(0);
};
flambe.platform.shader.DrawImageGL.__name__ = true;
flambe.platform.shader.DrawImageGL.__super__ = flambe.platform.shader.ShaderGL;
flambe.platform.shader.DrawImageGL.prototype = $extend(flambe.platform.shader.ShaderGL.prototype,{
	prepare: function() {
		this._gl.enableVertexAttribArray(this.a_pos);
		this._gl.enableVertexAttribArray(this.a_uv);
		this._gl.enableVertexAttribArray(this.a_alpha);
		var bytesPerFloat = 4;
		var stride = 5 * bytesPerFloat;
		this._gl.vertexAttribPointer(this.a_pos,2,5126,false,stride,0 * bytesPerFloat);
		this._gl.vertexAttribPointer(this.a_uv,2,5126,false,stride,2 * bytesPerFloat);
		this._gl.vertexAttribPointer(this.a_alpha,1,5126,false,stride,4 * bytesPerFloat);
	}
	,setTexture: function(unit) {
		this._gl.uniform1i(this.u_texture,unit);
	}
	,__class__: flambe.platform.shader.DrawImageGL
});
flambe.platform.shader.DrawPatternGL = function(gl) {
	flambe.platform.shader.ShaderGL.call(this,gl,["attribute highp vec2 a_pos;","attribute mediump vec2 a_uv;","attribute lowp float a_alpha;","varying mediump vec2 v_uv;","varying lowp float v_alpha;","void main (void) {","v_uv = a_uv;","v_alpha = a_alpha;","gl_Position = vec4(a_pos, 0, 1);","}"].join("\n"),["varying mediump vec2 v_uv;","varying lowp float v_alpha;","uniform lowp sampler2D u_texture;","uniform mediump vec2 u_maxUV;","void main (void) {","gl_FragColor = texture2D(u_texture, mod(v_uv, u_maxUV)) * v_alpha;","}"].join("\n"));
	this.a_pos = this.getAttribLocation("a_pos");
	this.a_uv = this.getAttribLocation("a_uv");
	this.a_alpha = this.getAttribLocation("a_alpha");
	this.u_texture = this.getUniformLocation("u_texture");
	this.u_maxUV = this.getUniformLocation("u_maxUV");
	this.setTexture(0);
};
flambe.platform.shader.DrawPatternGL.__name__ = true;
flambe.platform.shader.DrawPatternGL.__super__ = flambe.platform.shader.ShaderGL;
flambe.platform.shader.DrawPatternGL.prototype = $extend(flambe.platform.shader.ShaderGL.prototype,{
	prepare: function() {
		this._gl.enableVertexAttribArray(this.a_pos);
		this._gl.enableVertexAttribArray(this.a_uv);
		this._gl.enableVertexAttribArray(this.a_alpha);
		var bytesPerFloat = 4;
		var stride = 5 * bytesPerFloat;
		this._gl.vertexAttribPointer(this.a_pos,2,5126,false,stride,0 * bytesPerFloat);
		this._gl.vertexAttribPointer(this.a_uv,2,5126,false,stride,2 * bytesPerFloat);
		this._gl.vertexAttribPointer(this.a_alpha,1,5126,false,stride,4 * bytesPerFloat);
	}
	,setMaxUV: function(maxU,maxV) {
		this._gl.uniform2f(this.u_maxUV,maxU,maxV);
	}
	,setTexture: function(unit) {
		this._gl.uniform1i(this.u_texture,unit);
	}
	,__class__: flambe.platform.shader.DrawPatternGL
});
flambe.platform.shader.FillRectGL = function(gl) {
	flambe.platform.shader.ShaderGL.call(this,gl,["attribute highp vec2 a_pos;","attribute lowp vec3 a_rgb;","attribute lowp float a_alpha;","varying lowp vec4 v_color;","void main (void) {","v_color = vec4(a_rgb*a_alpha, a_alpha);","gl_Position = vec4(a_pos, 0, 1);","}"].join("\n"),["varying lowp vec4 v_color;","void main (void) {","gl_FragColor = v_color;","}"].join("\n"));
	this.a_pos = this.getAttribLocation("a_pos");
	this.a_rgb = this.getAttribLocation("a_rgb");
	this.a_alpha = this.getAttribLocation("a_alpha");
};
flambe.platform.shader.FillRectGL.__name__ = true;
flambe.platform.shader.FillRectGL.__super__ = flambe.platform.shader.ShaderGL;
flambe.platform.shader.FillRectGL.prototype = $extend(flambe.platform.shader.ShaderGL.prototype,{
	prepare: function() {
		this._gl.enableVertexAttribArray(this.a_pos);
		this._gl.enableVertexAttribArray(this.a_rgb);
		this._gl.enableVertexAttribArray(this.a_alpha);
		var bytesPerFloat = 4;
		var stride = 6 * bytesPerFloat;
		this._gl.vertexAttribPointer(this.a_pos,2,5126,false,stride,0 * bytesPerFloat);
		this._gl.vertexAttribPointer(this.a_rgb,3,5126,false,stride,2 * bytesPerFloat);
		this._gl.vertexAttribPointer(this.a_alpha,1,5126,false,stride,5 * bytesPerFloat);
	}
	,__class__: flambe.platform.shader.FillRectGL
});
flambe.scene = {}
flambe.scene.Director = function() {
	this._transitor = null;
	this.scenes = [];
	this.occludedScenes = [];
	this._root = new flambe.Entity();
};
flambe.scene.Director.__name__ = true;
flambe.scene.Director.__super__ = flambe.Component;
flambe.scene.Director.prototype = $extend(flambe.Component.prototype,{
	playTransition: function(from,to,transition,onComplete) {
		this.completeTransition();
		this.add(to);
		if(transition != null) {
			this.occludedScenes.push(from);
			this._transitor = new flambe.scene._Director.Transitor(from,to,transition,onComplete);
			this._transitor.init(this);
		} else {
			onComplete();
			this.invalidateVisibility();
		}
	}
	,completeTransition: function() {
		if(this._transitor != null) {
			this._transitor.complete();
			this._transitor = null;
			this.invalidateVisibility();
		}
	}
	,invalidateVisibility: function() {
		var ii = this.scenes.length;
		while(ii > 0) {
			var scene = this.scenes[--ii];
			var comp = scene._compMap.Scene_3;
			if(comp == null || comp.opaque) break;
		}
		this.occludedScenes = this.scenes.length > 0?this.scenes.slice(ii,this.scenes.length - 1):[];
		var scene = this.get_topScene();
		if(scene != null) this.show(scene);
	}
	,show: function(scene) {
		var events = scene._compMap.Scene_3;
		if(events != null) events.shown.emit0();
	}
	,hideAndDispose: function(scene) {
		this.hide(scene);
		scene.dispose();
	}
	,hide: function(scene) {
		var events = scene._compMap.Scene_3;
		if(events != null) events.hidden.emit0();
	}
	,add: function(scene) {
		var oldTop = this.get_topScene();
		if(oldTop != null) this._root.removeChild(oldTop);
		HxOverrides.remove(this.scenes,scene);
		this.scenes.push(scene);
		this._root.addChild(scene);
	}
	,get_topScene: function() {
		var ll = this.scenes.length;
		return ll > 0?this.scenes[ll - 1]:null;
	}
	,onUpdate: function(dt) {
		if(this._transitor != null && this._transitor.update(dt)) this.completeTransition();
	}
	,onRemoved: function() {
		this.completeTransition();
		var _g = 0, _g1 = this.scenes;
		while(_g < _g1.length) {
			var scene = _g1[_g];
			++_g;
			scene.dispose();
		}
		this.scenes = [];
		this.occludedScenes = [];
		this._root.dispose();
	}
	,onAdded: function() {
		this.owner.addChild(this._root);
	}
	,popScene: function(transition) {
		var _g = this;
		this.completeTransition();
		var oldTop = this.get_topScene();
		if(oldTop != null) {
			this.scenes.pop();
			var newTop = this.get_topScene();
			if(newTop != null) this.playTransition(oldTop,newTop,transition,function() {
				_g.hideAndDispose(oldTop);
			}); else {
				this.hideAndDispose(oldTop);
				this.invalidateVisibility();
			}
		}
	}
	,pushScene: function(scene,transition) {
		var _g = this;
		this.completeTransition();
		var oldTop = this.get_topScene();
		if(oldTop != null) this.playTransition(oldTop,scene,transition,function() {
			_g.hide(oldTop);
		}); else {
			this.add(scene);
			this.invalidateVisibility();
		}
	}
	,get_name: function() {
		return "Director_5";
	}
	,__class__: flambe.scene.Director
});
flambe.scene._Director = {}
flambe.scene._Director.Transitor = function(from,to,transition,onComplete) {
	this._from = from;
	this._to = to;
	this._transition = transition;
	this._onComplete = onComplete;
};
flambe.scene._Director.Transitor.__name__ = true;
flambe.scene._Director.Transitor.prototype = {
	complete: function() {
		this._transition.complete();
		this._onComplete();
	}
	,update: function(dt) {
		return this._transition.update(dt);
	}
	,init: function(director) {
		this._transition.init(director,this._from,this._to);
	}
	,__class__: flambe.scene._Director.Transitor
}
flambe.scene.Transition = function() { }
flambe.scene.Transition.__name__ = true;
flambe.scene.Transition.prototype = {
	complete: function() {
	}
	,update: function(dt) {
		return true;
	}
	,init: function(director,from,to) {
		this._director = director;
		this._from = from;
		this._to = to;
	}
	,__class__: flambe.scene.Transition
}
flambe.scene.TweenTransition = function(duration,ease) {
	this._duration = duration;
	this._ease = ease != null?ease:flambe.animation.Ease.linear;
};
flambe.scene.TweenTransition.__name__ = true;
flambe.scene.TweenTransition.__super__ = flambe.scene.Transition;
flambe.scene.TweenTransition.prototype = $extend(flambe.scene.Transition.prototype,{
	interp: function(from,to) {
		return from + (to - from) * this._ease(this._elapsed / this._duration);
	}
	,update: function(dt) {
		this._elapsed += dt;
		return this._elapsed >= this._duration;
	}
	,init: function(director,from,to) {
		flambe.scene.Transition.prototype.init.call(this,director,from,to);
		this._elapsed = 0;
	}
	,__class__: flambe.scene.TweenTransition
});
flambe.scene.FadeTransition = function(duration,ease) {
	flambe.scene.TweenTransition.call(this,duration,ease);
};
flambe.scene.FadeTransition.__name__ = true;
flambe.scene.FadeTransition.__super__ = flambe.scene.TweenTransition;
flambe.scene.FadeTransition.prototype = $extend(flambe.scene.TweenTransition.prototype,{
	complete: function() {
		this._to._compMap.Sprite_2.alpha.set__(1);
	}
	,update: function(dt) {
		var done = flambe.scene.TweenTransition.prototype.update.call(this,dt);
		this._to._compMap.Sprite_2.alpha.set__(this.interp(0,1));
		return done;
	}
	,init: function(director,from,to) {
		flambe.scene.TweenTransition.prototype.init.call(this,director,from,to);
		var sprite = this._to._compMap.Sprite_2;
		if(sprite == null) this._to.add(sprite = new flambe.display.Sprite());
		sprite.alpha.set__(0);
	}
	,__class__: flambe.scene.FadeTransition
});
flambe.scene.Scene = function() { }
flambe.scene.Scene.__name__ = true;
flambe.scene.Scene.__super__ = flambe.Component;
flambe.scene.Scene.prototype = $extend(flambe.Component.prototype,{
	get_name: function() {
		return "Scene_3";
	}
	,__class__: flambe.scene.Scene
});
flambe.util.BitSets = function() { }
flambe.util.BitSets.__name__ = true;
flambe.util.BitSets.set = function(bits,mask,enabled) {
	return enabled?bits | mask:bits & ~mask;
}
flambe.util.Promise = function() {
	this.success = new flambe.util.Signal1();
	this.error = new flambe.util.Signal1();
	this.progressChanged = new flambe.util.Signal0();
	this.hasResult = false;
	this._progress = 0;
	this._total = 0;
};
flambe.util.Promise.__name__ = true;
flambe.util.Promise.prototype = {
	set_total: function(total) {
		if(this._total != total) {
			this._total = total;
			this.progressChanged.emit0();
		}
		return total;
	}
	,set_progress: function(progress) {
		if(this._progress != progress) {
			this._progress = progress;
			this.progressChanged.emit0();
		}
		return progress;
	}
	,get: function(fn) {
		if(this.hasResult) {
			fn(this._result);
			return null;
		}
		return this.success.connect(fn).once();
	}
	,set_result: function(result) {
		if(this.hasResult) throw "Promise result already assigned";
		this._result = result;
		this.hasResult = true;
		this.success.emit1(result);
		return result;
	}
	,__class__: flambe.util.Promise
}
flambe.util.Signal0 = function(listener) {
	flambe.util.SignalBase.call(this,listener);
};
flambe.util.Signal0.__name__ = true;
flambe.util.Signal0.__super__ = flambe.util.SignalBase;
flambe.util.Signal0.prototype = $extend(flambe.util.SignalBase.prototype,{
	connect: function(listener,prioritize) {
		if(prioritize == null) prioritize = false;
		return this.connectImpl(listener,prioritize);
	}
	,__class__: flambe.util.Signal0
});
flambe.util._SignalBase = {}
flambe.util._SignalBase.Task = function(fn) {
	this.next = null;
	this.fn = fn;
};
flambe.util._SignalBase.Task.__name__ = true;
flambe.util._SignalBase.Task.prototype = {
	__class__: flambe.util._SignalBase.Task
}
flambe.util.Strings = function() { }
flambe.util.Strings.__name__ = true;
flambe.util.Strings.getFileExtension = function(fileName) {
	var dot = fileName.lastIndexOf(".");
	return dot > 0?HxOverrides.substr(fileName,dot + 1,null):null;
}
flambe.util.Strings.removeFileExtension = function(fileName) {
	var dot = fileName.lastIndexOf(".");
	return dot > 0?HxOverrides.substr(fileName,0,dot):fileName;
}
flambe.util.Strings.getUrlExtension = function(url) {
	var question = url.lastIndexOf("?");
	if(question >= 0) url = HxOverrides.substr(url,0,question);
	var slash = url.lastIndexOf("/");
	if(slash >= 0) url = HxOverrides.substr(url,slash + 1,null);
	return flambe.util.Strings.getFileExtension(url);
}
flambe.util.Strings.joinPath = function(base,relative) {
	if(base.charCodeAt(base.length - 1) != 47) base += "/";
	return base + relative;
}
flambe.util.Strings.withFields = function(message,fields) {
	var ll = fields.length;
	if(ll > 0) {
		message += message.length > 0?" [":"[";
		var ii = 0;
		while(ii < ll) {
			if(ii > 0) message += ", ";
			var name = fields[ii];
			var value = fields[ii + 1];
			if(js.Boot.__instanceof(value,Error)) {
				var stack = value.stack;
				if(stack != null) value = stack;
			}
			message += name + "=" + Std.string(value);
			ii += 2;
		}
		message += "]";
	}
	return message;
}
var haxe = {}
haxe.crypto = {}
haxe.crypto.Adler32 = function() {
	this.a1 = 1;
	this.a2 = 0;
};
haxe.crypto.Adler32.__name__ = true;
haxe.crypto.Adler32.read = function(i) {
	var a = new haxe.crypto.Adler32();
	var a2a = i.readByte();
	var a2b = i.readByte();
	var a1a = i.readByte();
	var a1b = i.readByte();
	a.a1 = a1a << 8 | a1b;
	a.a2 = a2a << 8 | a2b;
	return a;
}
haxe.crypto.Adler32.prototype = {
	equals: function(a) {
		return a.a1 == this.a1 && a.a2 == this.a2;
	}
	,update: function(b,pos,len) {
		var a1 = this.a1, a2 = this.a2;
		var _g1 = pos, _g = pos + len;
		while(_g1 < _g) {
			var p = _g1++;
			var c = b.b[p];
			a1 = (a1 + c) % 65521;
			a2 = (a2 + a1) % 65521;
		}
		this.a1 = a1;
		this.a2 = a2;
	}
	,__class__: haxe.crypto.Adler32
}
haxe.ds = {}
haxe.ds.IntMap = function() {
	this.h = { };
};
haxe.ds.IntMap.__name__ = true;
haxe.ds.IntMap.__interfaces__ = [IMap];
haxe.ds.IntMap.prototype = {
	remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,__class__: haxe.ds.IntMap
}
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,__class__: haxe.ds.StringMap
}
haxe.io = {}
haxe.io.Bytes = function(length,b) {
	this.length = length;
	this.b = b;
};
haxe.io.Bytes.__name__ = true;
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.prototype = {
	blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		if(b1 == b2 && pos > srcpos) {
			var i = len;
			while(i > 0) {
				i--;
				b1[i + pos] = b2[i + srcpos];
			}
			return;
		}
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b1[i + pos] = b2[i + srcpos];
		}
	}
	,__class__: haxe.io.Bytes
}
haxe.io.BytesBuffer = function() {
	this.b = new Array();
};
haxe.io.BytesBuffer.__name__ = true;
haxe.io.BytesBuffer.prototype = {
	getBytes: function() {
		var bytes = new haxe.io.Bytes(this.b.length,this.b);
		this.b = null;
		return bytes;
	}
	,addBytes: function(src,pos,len) {
		if(pos < 0 || len < 0 || pos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		var _g1 = pos, _g = pos + len;
		while(_g1 < _g) {
			var i = _g1++;
			this.b.push(b2[i]);
		}
	}
	,__class__: haxe.io.BytesBuffer
}
haxe.io.Input = function() { }
haxe.io.Input.__name__ = true;
haxe.io.Input.prototype = {
	readUInt16: function() {
		var ch1 = this.readByte();
		var ch2 = this.readByte();
		return this.bigEndian?ch2 | ch1 << 8:ch1 | ch2 << 8;
	}
	,read: function(nbytes) {
		var s = haxe.io.Bytes.alloc(nbytes);
		var p = 0;
		while(nbytes > 0) {
			var k = this.readBytes(s,p,nbytes);
			if(k == 0) throw haxe.io.Error.Blocked;
			p += k;
			nbytes -= k;
		}
		return s;
	}
	,readBytes: function(s,pos,len) {
		var k = len;
		var b = s.b;
		if(pos < 0 || len < 0 || pos + len > s.length) throw haxe.io.Error.OutsideBounds;
		while(k > 0) {
			b[pos] = this.readByte();
			pos++;
			k--;
		}
		return len;
	}
	,readByte: function() {
		return (function($this) {
			var $r;
			throw "Not implemented";
			return $r;
		}(this));
	}
	,__class__: haxe.io.Input
}
haxe.io.BytesInput = function(b,pos,len) {
	if(pos == null) pos = 0;
	if(len == null) len = b.length - pos;
	if(pos < 0 || len < 0 || pos + len > b.length) throw haxe.io.Error.OutsideBounds;
	this.b = b.b;
	this.pos = pos;
	this.len = len;
};
haxe.io.BytesInput.__name__ = true;
haxe.io.BytesInput.__super__ = haxe.io.Input;
haxe.io.BytesInput.prototype = $extend(haxe.io.Input.prototype,{
	readBytes: function(buf,pos,len) {
		if(pos < 0 || len < 0 || pos + len > buf.length) throw haxe.io.Error.OutsideBounds;
		if(this.len == 0 && len > 0) throw new haxe.io.Eof();
		if(this.len < len) len = this.len;
		var b1 = this.b;
		var b2 = buf.b;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b2[pos + i] = b1[this.pos + i];
		}
		this.pos += len;
		this.len -= len;
		return len;
	}
	,readByte: function() {
		if(this.len == 0) throw new haxe.io.Eof();
		this.len--;
		return this.b[this.pos++];
	}
	,__class__: haxe.io.BytesInput
});
haxe.io.Eof = function() {
};
haxe.io.Eof.__name__ = true;
haxe.io.Eof.prototype = {
	toString: function() {
		return "Eof";
	}
	,__class__: haxe.io.Eof
}
haxe.io.Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
haxe.rtti = {}
haxe.rtti.Meta = function() { }
haxe.rtti.Meta.__name__ = true;
haxe.rtti.Meta.getType = function(t) {
	var meta = t.__meta__;
	return meta == null || meta.obj == null?{ }:meta.obj;
}
haxe.xml = {}
haxe.xml.Parser = function() { }
haxe.xml.Parser.__name__ = true;
haxe.xml.Parser.parse = function(str) {
	var doc = Xml.createDocument();
	haxe.xml.Parser.doParse(str,0,doc);
	return doc;
}
haxe.xml.Parser.doParse = function(str,p,parent) {
	if(p == null) p = 0;
	var xml = null;
	var state = 1;
	var next = 1;
	var aname = null;
	var start = 0;
	var nsubs = 0;
	var nbrackets = 0;
	var c = str.charCodeAt(p);
	var buf = new StringBuf();
	while(!(c != c)) {
		switch(state) {
		case 0:
			switch(c) {
			case 10:case 13:case 9:case 32:
				break;
			default:
				state = next;
				continue;
			}
			break;
		case 1:
			switch(c) {
			case 60:
				state = 0;
				next = 2;
				break;
			default:
				start = p;
				state = 13;
				continue;
			}
			break;
		case 13:
			if(c == 60) {
				var child = Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start));
				buf = new StringBuf();
				parent.addChild(child);
				nsubs++;
				state = 0;
				next = 2;
			} else if(c == 38) {
				buf.addSub(str,start,p - start);
				state = 18;
				next = 13;
				start = p + 1;
			}
			break;
		case 17:
			if(c == 93 && str.charCodeAt(p + 1) == 93 && str.charCodeAt(p + 2) == 62) {
				var child = Xml.createCData(HxOverrides.substr(str,start,p - start));
				parent.addChild(child);
				nsubs++;
				p += 2;
				state = 1;
			}
			break;
		case 2:
			switch(c) {
			case 33:
				if(str.charCodeAt(p + 1) == 91) {
					p += 2;
					if(HxOverrides.substr(str,p,6).toUpperCase() != "CDATA[") throw "Expected <![CDATA[";
					p += 5;
					state = 17;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) == 68 || str.charCodeAt(p + 1) == 100) {
					if(HxOverrides.substr(str,p + 2,6).toUpperCase() != "OCTYPE") throw "Expected <!DOCTYPE";
					p += 8;
					state = 16;
					start = p + 1;
				} else if(str.charCodeAt(p + 1) != 45 || str.charCodeAt(p + 2) != 45) throw "Expected <!--"; else {
					p += 2;
					state = 15;
					start = p + 1;
				}
				break;
			case 63:
				state = 14;
				start = p;
				break;
			case 47:
				if(parent == null) throw "Expected node name";
				start = p + 1;
				state = 0;
				next = 10;
				break;
			default:
				state = 3;
				start = p;
				continue;
			}
			break;
		case 3:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(p == start) throw "Expected node name";
				xml = Xml.createElement(HxOverrides.substr(str,start,p - start));
				parent.addChild(xml);
				state = 0;
				next = 4;
				continue;
			}
			break;
		case 4:
			switch(c) {
			case 47:
				state = 11;
				nsubs++;
				break;
			case 62:
				state = 9;
				nsubs++;
				break;
			default:
				state = 5;
				start = p;
				continue;
			}
			break;
		case 5:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				var tmp;
				if(start == p) throw "Expected attribute name";
				tmp = HxOverrides.substr(str,start,p - start);
				aname = tmp;
				if(xml.exists(aname)) throw "Duplicate attribute";
				state = 0;
				next = 6;
				continue;
			}
			break;
		case 6:
			switch(c) {
			case 61:
				state = 0;
				next = 7;
				break;
			default:
				throw "Expected =";
			}
			break;
		case 7:
			switch(c) {
			case 34:case 39:
				state = 8;
				start = p;
				break;
			default:
				throw "Expected \"";
			}
			break;
		case 8:
			if(c == str.charCodeAt(start)) {
				var val = HxOverrides.substr(str,start + 1,p - start - 1);
				xml.set(aname,val);
				state = 0;
				next = 4;
			}
			break;
		case 9:
			p = haxe.xml.Parser.doParse(str,p,xml);
			start = p;
			state = 1;
			break;
		case 11:
			switch(c) {
			case 62:
				state = 1;
				break;
			default:
				throw "Expected >";
			}
			break;
		case 12:
			switch(c) {
			case 62:
				if(nsubs == 0) parent.addChild(Xml.createPCData(""));
				return p;
			default:
				throw "Expected >";
			}
			break;
		case 10:
			if(!(c >= 97 && c <= 122 || c >= 65 && c <= 90 || c >= 48 && c <= 57 || c == 58 || c == 46 || c == 95 || c == 45)) {
				if(start == p) throw "Expected node name";
				var v = HxOverrides.substr(str,start,p - start);
				if(v != parent.get_nodeName()) throw "Expected </" + parent.get_nodeName() + ">";
				state = 0;
				next = 12;
				continue;
			}
			break;
		case 15:
			if(c == 45 && str.charCodeAt(p + 1) == 45 && str.charCodeAt(p + 2) == 62) {
				parent.addChild(Xml.createComment(HxOverrides.substr(str,start,p - start)));
				p += 2;
				state = 1;
			}
			break;
		case 16:
			if(c == 91) nbrackets++; else if(c == 93) nbrackets--; else if(c == 62 && nbrackets == 0) {
				parent.addChild(Xml.createDocType(HxOverrides.substr(str,start,p - start)));
				state = 1;
			}
			break;
		case 14:
			if(c == 63 && str.charCodeAt(p + 1) == 62) {
				p++;
				var str1 = HxOverrides.substr(str,start + 1,p - start - 2);
				parent.addChild(Xml.createProcessingInstruction(str1));
				state = 1;
			}
			break;
		case 18:
			if(c == 59) {
				var s = HxOverrides.substr(str,start,p - start);
				if(s.charCodeAt(0) == 35) {
					var i = s.charCodeAt(1) == 120?Std.parseInt("0" + HxOverrides.substr(s,1,s.length - 1)):Std.parseInt(HxOverrides.substr(s,1,s.length - 1));
					buf.b += Std.string(String.fromCharCode(i));
				} else if(!haxe.xml.Parser.escapes.exists(s)) buf.b += Std.string("&" + s + ";"); else buf.b += Std.string(haxe.xml.Parser.escapes.get(s));
				start = p + 1;
				state = next;
			}
			break;
		}
		c = str.charCodeAt(++p);
	}
	if(state == 1) {
		start = p;
		state = 13;
	}
	if(state == 13) {
		if(p != start || nsubs == 0) parent.addChild(Xml.createPCData(buf.b + HxOverrides.substr(str,start,p - start)));
		return p;
	}
	throw "Unexpected end";
}
haxe.zip = {}
haxe.zip.Huffman = { __ename__ : true, __constructs__ : ["Found","NeedBit","NeedBits"] }
haxe.zip.Huffman.Found = function(i) { var $x = ["Found",0,i]; $x.__enum__ = haxe.zip.Huffman; $x.toString = $estr; return $x; }
haxe.zip.Huffman.NeedBit = function(left,right) { var $x = ["NeedBit",1,left,right]; $x.__enum__ = haxe.zip.Huffman; $x.toString = $estr; return $x; }
haxe.zip.Huffman.NeedBits = function(n,table) { var $x = ["NeedBits",2,n,table]; $x.__enum__ = haxe.zip.Huffman; $x.toString = $estr; return $x; }
haxe.zip.HuffTools = function() {
};
haxe.zip.HuffTools.__name__ = true;
haxe.zip.HuffTools.prototype = {
	make: function(lengths,pos,nlengths,maxbits) {
		var counts = new Array();
		var tmp = new Array();
		if(maxbits > 32) throw "Invalid huffman";
		var _g = 0;
		while(_g < maxbits) {
			var i = _g++;
			counts.push(0);
			tmp.push(0);
		}
		var _g = 0;
		while(_g < nlengths) {
			var i = _g++;
			var p = lengths[i + pos];
			if(p >= maxbits) throw "Invalid huffman";
			counts[p]++;
		}
		var code = 0;
		var _g1 = 1, _g = maxbits - 1;
		while(_g1 < _g) {
			var i = _g1++;
			code = code + counts[i] << 1;
			tmp[i] = code;
		}
		var bits = new haxe.ds.IntMap();
		var _g = 0;
		while(_g < nlengths) {
			var i = _g++;
			var l = lengths[i + pos];
			if(l != 0) {
				var n = tmp[l - 1];
				tmp[l - 1] = n + 1;
				bits.set(n << 5 | l,i);
			}
		}
		return this.treeCompress(haxe.zip.Huffman.NeedBit(this.treeMake(bits,maxbits,0,1),this.treeMake(bits,maxbits,1,1)));
	}
	,treeMake: function(bits,maxbits,v,len) {
		if(len > maxbits) throw "Invalid huffman";
		var idx = v << 5 | len;
		if(bits.exists(idx)) return haxe.zip.Huffman.Found(bits.get(idx));
		v <<= 1;
		len += 1;
		return haxe.zip.Huffman.NeedBit(this.treeMake(bits,maxbits,v,len),this.treeMake(bits,maxbits,v | 1,len));
	}
	,treeWalk: function(table,p,cd,d,t) {
		var $e = (t);
		switch( $e[1] ) {
		case 1:
			var b = $e[3], a = $e[2];
			if(d > 0) {
				this.treeWalk(table,p,cd + 1,d - 1,a);
				this.treeWalk(table,p | 1 << cd,cd + 1,d - 1,b);
			} else table[p] = this.treeCompress(t);
			break;
		default:
			table[p] = this.treeCompress(t);
		}
	}
	,treeCompress: function(t) {
		var d = this.treeDepth(t);
		if(d == 0) return t;
		if(d == 1) return (function($this) {
			var $r;
			var $e = (t);
			switch( $e[1] ) {
			case 1:
				var b = $e[3], a = $e[2];
				$r = haxe.zip.Huffman.NeedBit($this.treeCompress(a),$this.treeCompress(b));
				break;
			default:
				$r = (function($this) {
					var $r;
					throw "assert";
					return $r;
				}($this));
			}
			return $r;
		}(this));
		var size = 1 << d;
		var table = new Array();
		var _g = 0;
		while(_g < size) {
			var i = _g++;
			table.push(haxe.zip.Huffman.Found(-1));
		}
		this.treeWalk(table,0,0,d,t);
		return haxe.zip.Huffman.NeedBits(d,table);
	}
	,treeDepth: function(t) {
		return (function($this) {
			var $r;
			var $e = (t);
			switch( $e[1] ) {
			case 0:
				$r = 0;
				break;
			case 2:
				$r = (function($this) {
					var $r;
					throw "assert";
					return $r;
				}($this));
				break;
			case 1:
				var b = $e[3], a = $e[2];
				$r = (function($this) {
					var $r;
					var da = $this.treeDepth(a);
					var db = $this.treeDepth(b);
					$r = 1 + (da < db?da:db);
					return $r;
				}($this));
				break;
			}
			return $r;
		}(this));
	}
	,__class__: haxe.zip.HuffTools
}
haxe.zip._InflateImpl = {}
haxe.zip._InflateImpl.Window = function(hasCrc) {
	this.buffer = haxe.io.Bytes.alloc(65536);
	this.pos = 0;
	if(hasCrc) this.crc = new haxe.crypto.Adler32();
};
haxe.zip._InflateImpl.Window.__name__ = true;
haxe.zip._InflateImpl.Window.prototype = {
	checksum: function() {
		if(this.crc != null) this.crc.update(this.buffer,0,this.pos);
		return this.crc;
	}
	,available: function() {
		return this.pos;
	}
	,getLastChar: function() {
		return this.buffer.b[this.pos - 1];
	}
	,addByte: function(c) {
		if(this.pos == 65536) this.slide();
		this.buffer.b[this.pos] = c & 255;
		this.pos++;
	}
	,addBytes: function(b,p,len) {
		if(this.pos + len > 65536) this.slide();
		this.buffer.blit(this.pos,b,p,len);
		this.pos += len;
	}
	,slide: function() {
		if(this.crc != null) this.crc.update(this.buffer,0,32768);
		var b = haxe.io.Bytes.alloc(65536);
		this.pos -= 32768;
		b.blit(0,this.buffer,32768,this.pos);
		this.buffer = b;
	}
	,__class__: haxe.zip._InflateImpl.Window
}
haxe.zip._InflateImpl.State = { __ename__ : true, __constructs__ : ["Head","Block","CData","Flat","Crc","Dist","DistOne","Done"] }
haxe.zip._InflateImpl.State.Head = ["Head",0];
haxe.zip._InflateImpl.State.Head.toString = $estr;
haxe.zip._InflateImpl.State.Head.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.Block = ["Block",1];
haxe.zip._InflateImpl.State.Block.toString = $estr;
haxe.zip._InflateImpl.State.Block.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.CData = ["CData",2];
haxe.zip._InflateImpl.State.CData.toString = $estr;
haxe.zip._InflateImpl.State.CData.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.Flat = ["Flat",3];
haxe.zip._InflateImpl.State.Flat.toString = $estr;
haxe.zip._InflateImpl.State.Flat.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.Crc = ["Crc",4];
haxe.zip._InflateImpl.State.Crc.toString = $estr;
haxe.zip._InflateImpl.State.Crc.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.Dist = ["Dist",5];
haxe.zip._InflateImpl.State.Dist.toString = $estr;
haxe.zip._InflateImpl.State.Dist.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.DistOne = ["DistOne",6];
haxe.zip._InflateImpl.State.DistOne.toString = $estr;
haxe.zip._InflateImpl.State.DistOne.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip._InflateImpl.State.Done = ["Done",7];
haxe.zip._InflateImpl.State.Done.toString = $estr;
haxe.zip._InflateImpl.State.Done.__enum__ = haxe.zip._InflateImpl.State;
haxe.zip.InflateImpl = function(i,header,crc) {
	if(crc == null) crc = true;
	if(header == null) header = true;
	this["final"] = false;
	this.htools = new haxe.zip.HuffTools();
	this.huffman = this.buildFixedHuffman();
	this.huffdist = null;
	this.len = 0;
	this.dist = 0;
	this.state = header?haxe.zip._InflateImpl.State.Head:haxe.zip._InflateImpl.State.Block;
	this.input = i;
	this.bits = 0;
	this.nbits = 0;
	this.needed = 0;
	this.output = null;
	this.outpos = 0;
	this.lengths = new Array();
	var _g = 0;
	while(_g < 19) {
		var i1 = _g++;
		this.lengths.push(-1);
	}
	this.window = new haxe.zip._InflateImpl.Window(crc);
};
haxe.zip.InflateImpl.__name__ = true;
haxe.zip.InflateImpl.run = function(i,bufsize) {
	if(bufsize == null) bufsize = 65536;
	var buf = haxe.io.Bytes.alloc(bufsize);
	var output = new haxe.io.BytesBuffer();
	var inflate = new haxe.zip.InflateImpl(i);
	while(true) {
		var len = inflate.readBytes(buf,0,bufsize);
		output.addBytes(buf,0,len);
		if(len < bufsize) break;
	}
	return output.getBytes();
}
haxe.zip.InflateImpl.prototype = {
	inflateLoop: function() {
		var _g = this;
		switch( (_g.state)[1] ) {
		case 0:
			var cmf = this.input.readByte();
			var cm = cmf & 15;
			var cinfo = cmf >> 4;
			if(cm != 8 || cinfo != 7) throw "Invalid data";
			var flg = this.input.readByte();
			var fdict = (flg & 32) != 0;
			if(((cmf << 8) + flg) % 31 != 0) throw "Invalid data";
			if(fdict) throw "Unsupported dictionary";
			this.state = haxe.zip._InflateImpl.State.Block;
			return true;
		case 4:
			var calc = this.window.checksum();
			if(calc == null) {
				this.state = haxe.zip._InflateImpl.State.Done;
				return true;
			}
			var crc = haxe.crypto.Adler32.read(this.input);
			if(!calc.equals(crc)) throw "Invalid CRC";
			this.state = haxe.zip._InflateImpl.State.Done;
			return true;
		case 7:
			return false;
		case 1:
			this["final"] = this.getBit();
			var _g1 = this.getBits(2);
			switch(_g1) {
			case 0:
				this.len = this.input.readUInt16();
				var nlen = this.input.readUInt16();
				if(nlen != 65535 - this.len) throw "Invalid data";
				this.state = haxe.zip._InflateImpl.State.Flat;
				var r = this.inflateLoop();
				this.resetBits();
				return r;
			case 1:
				this.huffman = this.buildFixedHuffman();
				this.huffdist = null;
				this.state = haxe.zip._InflateImpl.State.CData;
				return true;
			case 2:
				var hlit = this.getBits(5) + 257;
				var hdist = this.getBits(5) + 1;
				var hclen = this.getBits(4) + 4;
				var _g2 = 0;
				while(_g2 < hclen) {
					var i = _g2++;
					this.lengths[haxe.zip.InflateImpl.CODE_LENGTHS_POS[i]] = this.getBits(3);
				}
				var _g2 = hclen;
				while(_g2 < 19) {
					var i = _g2++;
					this.lengths[haxe.zip.InflateImpl.CODE_LENGTHS_POS[i]] = 0;
				}
				this.huffman = this.htools.make(this.lengths,0,19,8);
				var lengths = new Array();
				var _g3 = 0, _g2 = hlit + hdist;
				while(_g3 < _g2) {
					var i = _g3++;
					lengths.push(0);
				}
				this.inflateLengths(lengths,hlit + hdist);
				this.huffdist = this.htools.make(lengths,hlit,hdist,16);
				this.huffman = this.htools.make(lengths,0,hlit,16);
				this.state = haxe.zip._InflateImpl.State.CData;
				return true;
			default:
				throw "Invalid data";
			}
			break;
		case 3:
			var rlen = this.len < this.needed?this.len:this.needed;
			var bytes = this.input.read(rlen);
			this.len -= rlen;
			this.addBytes(bytes,0,rlen);
			if(this.len == 0) this.state = this["final"]?haxe.zip._InflateImpl.State.Crc:haxe.zip._InflateImpl.State.Block;
			return this.needed > 0;
		case 6:
			var rlen = this.len < this.needed?this.len:this.needed;
			this.addDistOne(rlen);
			this.len -= rlen;
			if(this.len == 0) this.state = haxe.zip._InflateImpl.State.CData;
			return this.needed > 0;
		case 5:
			while(this.len > 0 && this.needed > 0) {
				var rdist = this.len < this.dist?this.len:this.dist;
				var rlen = this.needed < rdist?this.needed:rdist;
				this.addDist(this.dist,rlen);
				this.len -= rlen;
			}
			if(this.len == 0) this.state = haxe.zip._InflateImpl.State.CData;
			return this.needed > 0;
		case 2:
			var n = this.applyHuffman(this.huffman);
			if(n < 256) {
				this.addByte(n);
				return this.needed > 0;
			} else if(n == 256) {
				this.state = this["final"]?haxe.zip._InflateImpl.State.Crc:haxe.zip._InflateImpl.State.Block;
				return true;
			} else {
				n -= 257;
				var extra_bits = haxe.zip.InflateImpl.LEN_EXTRA_BITS_TBL[n];
				if(extra_bits == -1) throw "Invalid data";
				this.len = haxe.zip.InflateImpl.LEN_BASE_VAL_TBL[n] + this.getBits(extra_bits);
				var dist_code = this.huffdist == null?this.getRevBits(5):this.applyHuffman(this.huffdist);
				extra_bits = haxe.zip.InflateImpl.DIST_EXTRA_BITS_TBL[dist_code];
				if(extra_bits == -1) throw "Invalid data";
				this.dist = haxe.zip.InflateImpl.DIST_BASE_VAL_TBL[dist_code] + this.getBits(extra_bits);
				if(this.dist > this.window.available()) throw "Invalid data";
				this.state = this.dist == 1?haxe.zip._InflateImpl.State.DistOne:haxe.zip._InflateImpl.State.Dist;
				return true;
			}
			break;
		}
	}
	,inflateLengths: function(a,max) {
		var i = 0;
		var prev = 0;
		while(i < max) {
			var n = this.applyHuffman(this.huffman);
			switch(n) {
			case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:case 10:case 11:case 12:case 13:case 14:case 15:
				prev = n;
				a[i] = n;
				i++;
				break;
			case 16:
				var end = i + 3 + this.getBits(2);
				if(end > max) throw "Invalid data";
				while(i < end) {
					a[i] = prev;
					i++;
				}
				break;
			case 17:
				i += 3 + this.getBits(3);
				if(i > max) throw "Invalid data";
				break;
			case 18:
				i += 11 + this.getBits(7);
				if(i > max) throw "Invalid data";
				break;
			default:
				throw "Invalid data";
			}
		}
	}
	,applyHuffman: function(h) {
		return (function($this) {
			var $r;
			var $e = (h);
			switch( $e[1] ) {
			case 0:
				var n = $e[2];
				$r = n;
				break;
			case 1:
				var b = $e[3], a = $e[2];
				$r = $this.applyHuffman($this.getBit()?b:a);
				break;
			case 2:
				var tbl = $e[3], n = $e[2];
				$r = $this.applyHuffman(tbl[$this.getBits(n)]);
				break;
			}
			return $r;
		}(this));
	}
	,addDist: function(d,len) {
		this.addBytes(this.window.buffer,this.window.pos - d,len);
	}
	,addDistOne: function(n) {
		var c = this.window.getLastChar();
		var _g = 0;
		while(_g < n) {
			var i = _g++;
			this.addByte(c);
		}
	}
	,addByte: function(b) {
		this.window.addByte(b);
		this.output.b[this.outpos] = b & 255;
		this.needed--;
		this.outpos++;
	}
	,addBytes: function(b,p,len) {
		this.window.addBytes(b,p,len);
		this.output.blit(this.outpos,b,p,len);
		this.needed -= len;
		this.outpos += len;
	}
	,resetBits: function() {
		this.bits = 0;
		this.nbits = 0;
	}
	,getRevBits: function(n) {
		return n == 0?0:this.getBit()?1 << n - 1 | this.getRevBits(n - 1):this.getRevBits(n - 1);
	}
	,getBit: function() {
		if(this.nbits == 0) {
			this.nbits = 8;
			this.bits = this.input.readByte();
		}
		var b = (this.bits & 1) == 1;
		this.nbits--;
		this.bits >>= 1;
		return b;
	}
	,getBits: function(n) {
		while(this.nbits < n) {
			this.bits |= this.input.readByte() << this.nbits;
			this.nbits += 8;
		}
		var b = this.bits & (1 << n) - 1;
		this.nbits -= n;
		this.bits >>= n;
		return b;
	}
	,readBytes: function(b,pos,len) {
		this.needed = len;
		this.outpos = pos;
		this.output = b;
		if(len > 0) while(this.inflateLoop()) {
		}
		return len - this.needed;
	}
	,buildFixedHuffman: function() {
		if(haxe.zip.InflateImpl.FIXED_HUFFMAN != null) return haxe.zip.InflateImpl.FIXED_HUFFMAN;
		var a = new Array();
		var _g = 0;
		while(_g < 288) {
			var n = _g++;
			a.push(n <= 143?8:n <= 255?9:n <= 279?7:8);
		}
		haxe.zip.InflateImpl.FIXED_HUFFMAN = this.htools.make(a,0,288,10);
		return haxe.zip.InflateImpl.FIXED_HUFFMAN;
	}
	,__class__: haxe.zip.InflateImpl
}
js.Boot = function() { }
js.Boot.__name__ = true;
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					if(cl == Array) return o.__enum__ == null;
					return true;
				}
				if(js.Boot.__interfLoop(o.__class__,cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.html = {}
js.html._CanvasElement = {}
js.html._CanvasElement.CanvasUtil = function() { }
js.html._CanvasElement.CanvasUtil.__name__ = true;
js.html._CanvasElement.CanvasUtil.getContextWebGL = function(canvas,attribs) {
	var _g = 0, _g1 = ["webgl","experimental-webgl"];
	while(_g < _g1.length) {
		var name = _g1[_g];
		++_g;
		var ctx = canvas.getContext(name,attribs);
		if(ctx != null) return ctx;
	}
	return null;
}
var sample = {}
sample.AboutLayer = function() {
	cc.layersscenestransitionsnodes.CCLayer.call(this);
};
sample.AboutLayer.__name__ = true;
sample.AboutLayer.create = function() {
	var sg = new sample.AboutLayer();
	if(sg != null) return sg;
	return null;
}
sample.AboutLayer.__super__ = cc.layersscenestransitionsnodes.CCLayer;
sample.AboutLayer.prototype = $extend(cc.layersscenestransitionsnodes.CCLayer.prototype,{
	backCallback: function() {
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.SysMenu.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,init: function() {
		var bRet = false;
		if(cc.layersscenestransitionsnodes.CCLayer.prototype.init.call(this)) {
			var sp = cc.spritenodes.CCSprite.create("Sample/loading");
			sp.setAnchorPoint(new flambe.math.Point(0,0));
			this.addChild(sp,0,1);
			var cacheImage = cc.texture.CCTextureCache.getInstance().addImage("Sample/menuTitle");
			var title = cc.spritenodes.CCSprite.createWithTexture(cacheImage,new flambe.math.Rectangle(0,36,100,34));
			if(title == null) null;
			title.setPosition(160,60);
			this.addChild(title);
			var label = cc.labelnodes.CCLabelBMFont.create("GoBack","Sample/arial-14");
			var back = cc.menunodes.CCMenuItemLabel.create(label,$bind(this,this.backCallback),this);
			var menu = cc.menunodes.CCMenu.create([back]);
			menu.alignVerticallyWithPadding(0);
			menu.setPosition(134,300);
			this.addChild(menu);
			bRet = true;
		}
		return bRet;
	}
	,__class__: sample.AboutLayer
});
sample.Bullet = function(bulletSpeed,weaponType,attackMode) {
	this.zOrder = 3000;
	this.hp = 1;
	this.active = true;
	cc.spritenodes.CCSprite.call(this);
	attackMode = sample.config.ENEMY_ATTACK_MODE.NORMAL;
	this.parentType = sample.config.BULLET_TYPE.PLAYER;
	this.yVelocity = bulletSpeed;
	this.xVelocity = 0;
	this.attackMoke = attackMode;
	if(weaponType == "W2.png") this.initWithFile("Sample/w2"); else this.initWithFile("Sample/bullet1");
};
sample.Bullet.__name__ = true;
sample.Bullet.__super__ = cc.spritenodes.CCSprite;
sample.Bullet.prototype = $extend(cc.spritenodes.CCSprite.prototype,{
	collideRect: function() {
		var p = this.getPosition();
		return new flambe.math.Rectangle(p.x - 3,p.y - 3,6,6);
	}
	,hurt: function() {
		this.hp--;
	}
	,destroy: function() {
		var explode = cc.spritenodes.CCSprite.create("Sample/hit");
		explode.setPosition(this.getPosition().x,this.getPosition().y + 20);
		this.setRotation(Math.random() * 360);
		explode.setScale(0.75);
		this.getParent().addChild(explode);
		HxOverrides.remove(sample.config.GameConfig.ENEMY_BULLETS,this);
		HxOverrides.remove(sample.config.GameConfig.PLAYER_BULLETS,this);
		this.removeFromParent(true);
		var removeExplode = cc.action.CCCallFunc.create($bind(explode,explode.removeFromParentAndCleanup),explode);
		explode.runAction(cc.action.CCScaleBy.create(0.3,2,2));
		explode.runAction(cc.action.CCSequence.create([cc.action.CCFadeOut.create(0.3),removeExplode]));
	}
	,update: function(dt) {
		cc.spritenodes.CCSprite.prototype.update.call(this,dt);
		var p = this.getPosition();
		p.x -= this.xVelocity * dt;
		p.y -= this.yVelocity * dt;
		this.setPosition(p.x,p.y);
		if(p.y < -100 || p.y > 600 || !this.active) this.destroy();
		if(this.hp <= 0) this.active = false;
	}
	,__class__: sample.Bullet
});
sample.Effect = function() { }
sample.Effect.__name__ = true;
sample.Effect.flareEffect = function(parent,target,cb) {
	sample.Effect._parent = parent;
	sample.Effect._target = target;
	var flare = cc.spritenodes.CCSprite.create("Sample/flare");
	flare.setBlendFunc(flambe.display.BlendMode.Add);
	parent.addChild(flare,10);
	flare.setOpacity(255);
	flare.setPosition(-30,183);
	flare.setRotation(-120);
	flare.setScale(0.2);
	flare.setCenterAnchor();
	var opacityAnim = cc.action.CCFadeTo.create(0.5,255);
	var opacDim = cc.action.CCFadeTo.create(1,0);
	var biggeAnim = cc.action.CCScaleBy.create(0.7,1.2,1.2);
	var biggerEase = cc.action.CCEaseSineOut.create(biggeAnim);
	var moveAnim = cc.action.CCMoveBy.create(0.5,new flambe.math.Point(328,0));
	var easeMove = cc.action.CCEaseSineOut.create(moveAnim);
	var rotateAnim = cc.action.CCRotateBy.create(2.5,90);
	var rotateEase = cc.action.CCEaseExponentialOut.create(rotateAnim);
	var bigger = cc.action.CCScaleTo.create(0.5,1);
	var onComplete = cc.action.CCCallFunc.create(cb,target);
	var killflare = cc.action.CCCallFunc.create(function() {
		parent.removeChild(target,true);
	},flare);
	flare.runAction(cc.action.CCSequence.create([opacityAnim,biggerEase,opacDim,killflare,onComplete]));
	flare.runAction(moveAnim);
	flare.runAction(rotateEase);
	flare.runAction(bigger);
}
sample.Effect.spark = function(ccpoint,parent,scale,duration) {
	sample.Effect._parent = parent;
	if(scale == null) scale = 0.3;
	if(duration == null) duration = 0.5;
	var one = cc.spritenodes.CCSprite.create("Sample/explode1");
	var two = cc.spritenodes.CCSprite.create("Sample/explode2");
	var three = cc.spritenodes.CCSprite.create("Sample/explode3");
	one.setBlendFunc(flambe.display.BlendMode.Add);
	two.setBlendFunc(flambe.display.BlendMode.Add);
	three.setBlendFunc(flambe.display.BlendMode.Add);
	one.setPosition(ccpoint.x,ccpoint.y);
	two.setPosition(ccpoint.x,ccpoint.y);
	three.setPosition(ccpoint.x,ccpoint.y);
	parent.addChild(one);
	parent.addChild(two);
	parent.addChild(three);
	one.setScale(scale);
	two.setScale(scale);
	three.setScale(scale);
	one.setCenterAnchor();
	two.setCenterAnchor();
	three.setCenterAnchor();
	three.setRotation(Math.random() * 360);
	var left = cc.action.CCRotateBy.create(duration,-45);
	var right = cc.action.CCRotateBy.create(duration,45);
	var scaleBy1 = cc.action.CCScaleBy.create(duration,3,3);
	var scaleBy2 = cc.action.CCScaleBy.create(duration,3,3);
	var scaleBy3 = cc.action.CCScaleBy.create(duration,3,3);
	var fadeOut1 = cc.action.CCFadeOut.create(duration);
	var fadeOut2 = cc.action.CCFadeOut.create(duration);
	var fadeOut3 = cc.action.CCFadeOut.create(duration);
	one.runAction(left);
	two.runAction(right);
	one.runAction(scaleBy1);
	two.runAction(scaleBy2);
	three.runAction(scaleBy3);
	one.runAction(cc.action.CCSequence.create([fadeOut1,cc.action.CCCallFunc.create($bind(one,one.removeFromParentAndCleanup),one)]));
	two.runAction(cc.action.CCSequence.create([fadeOut2,cc.action.CCCallFunc.create($bind(two,two.removeFromParentAndCleanup),two)]));
	three.runAction(cc.action.CCSequence.create([fadeOut3,cc.action.CCCallFunc.create($bind(three,three.removeFromParentAndCleanup),three)]));
}
sample.Enemy = function(enemyType) {
	this._timeTick = 0;
	this.zOrder = 3000;
	this.scoreValue = 200;
	this.hp = 15;
	this.bulletSpeed = -200;
	this.active = true;
	cc.spritenodes.CCSprite.call(this);
	this.moveType = enemyType.moveType;
	this.hp = enemyType.HP;
	this.scoreValue = enemyType.scoreValue;
	this.attackMode = enemyType.attackMode;
	this.initWithSpriteFrameName(enemyType.textureName);
	this.delayTime = 1 + 1.2 * Math.random();
	this.schedule($bind(this,this.shoot),this.delayTime);
};
sample.Enemy.__name__ = true;
sample.Enemy.sharedEnemy = function() {
	cc.spritenodes.CCSpriteFrameCache.getInstance().addSpriteFrames("Sample/Enemy.plist");
}
sample.Enemy.__super__ = cc.spritenodes.CCSprite;
sample.Enemy.prototype = $extend(cc.spritenodes.CCSprite.prototype,{
	collideRect: function() {
		var a = this.getContentSize();
		var p = this.getPosition();
		return new flambe.math.Rectangle(p.x,p.y - a.height / 4,a.width,a.height / 2);
	}
	,hurt: function() {
		this.hp--;
	}
	,shoot: function() {
		var p = this.getPosition();
		var b = new sample.Bullet(this.bulletSpeed,"W2.png",this.attackMode);
		sample.config.GameConfig.ENEMY_BULLETS.push(b);
		this.getParent().addChild(b,b.zOrder,sample.config.UNIT_TAG.ENEMY_BULLET);
		b.setPosition(p.x,p.y - this.getContentSize().height * 0.2);
	}
	,destroy: function() {
		sample.config.GameConfig.SCORE += this.scoreValue;
		var a = new sample.Explosion();
		a.setPosition(this.getPosition().x - 38,this.getPosition().y - 45);
		this.getParent().addChild(a);
		sample.Effect.spark(new flambe.math.Point(this.getPosition().x + 20,this.getPosition().y),this.getParent(),1.2,0.7);
		cc.CCScheduler.ArrayRemoveObject_sample_Enemy(sample.config.GameConfig.ENEMIES,this);
		this.removeFromParent(true);
	}
	,update: function(dt) {
		cc.spritenodes.CCSprite.prototype.update.call(this,dt);
		var p = this.getPosition();
		if(this.hp <= 0 || p.x < 0 || p.x > sample.GameLayer.winSize.width || p.y < -50 || p.y > 600) {
			this.active = false;
			this.destroy();
		}
		this._timeTick += dt;
		if(this._timeTick > 0.1) this._timeTick = 0;
	}
	,__class__: sample.Enemy
});
sample.Explosion = function() {
	cc.spritenodes.CCSprite.call(this);
	var pFrame = cc.spritenodes.CCSpriteFrameCache.getInstance().getSpriteFrame("explosion_01.png");
	this.initWithSpriteFrame(pFrame);
	var cs = this.getContentSize();
	this.tmpHeight = cs.height;
	this.tmpWidth = cs.width;
	var animation = cc.spritenodes.CCAnimationCache.getInstance().getAnimation("Explosion");
	this.runAction(cc.action.CCSequence.create([cc.action.CCAnimate.create(animation),cc.action.CCCallFunc.create($bind(this,this.destroy),this)]));
};
sample.Explosion.__name__ = true;
sample.Explosion.sharedExplosion = function() {
	cc.spritenodes.CCSpriteFrameCache.getInstance().addSpriteFrames("Sample/explosion.plist");
	var str = "";
	var animFrames = new Array();
	var _g = 1;
	while(_g < 35) {
		var i = _g++;
		str = "explosion_" + (i < 10?"0" + Std.string(i):Std.string(i)) + ".png";
		var frame = cc.spritenodes.CCSpriteFrameCache.getInstance().getSpriteFrame(str);
		animFrames.push(frame);
	}
	var animation = cc.spritenodes.CCAnimation.createWithAnimationFrames(animFrames,0.04);
	cc.spritenodes.CCAnimationCache.getInstance().addAnimation(animation,"Explosion");
}
sample.Explosion.__super__ = cc.spritenodes.CCSprite;
sample.Explosion.prototype = $extend(cc.spritenodes.CCSprite.prototype,{
	destroy: function() {
		this.getParent().removeChild(this,true);
	}
	,__class__: sample.Explosion
});
sample.GameLayer = function() {
	this._backgroundSpeed = -192;
	this._tmpScore = 0;
	this._time = 0;
	cc.layersscenestransitionsnodes.CCLayer.call(this);
};
sample.GameLayer.__name__ = true;
sample.GameLayer.create = function() {
	var sg = new sample.GameLayer();
	if(sg != null) return sg;
	return null;
}
sample.GameLayer.__super__ = cc.layersscenestransitionsnodes.CCLayer;
sample.GameLayer.prototype = $extend(cc.layersscenestransitionsnodes.CCLayer.prototype,{
	onMainMenu: function() {
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.SysMenu.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,onGameOver: function() {
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.GameOver.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,movingBackground: function() {
		this._backSky.runAction(cc.action.CCMoveBy.create(3,new flambe.math.Point(0,this._backgroundSpeed)));
		this._backSkyHeight = this._backSkyHeight + this._backgroundSpeed;
		if(this._backSkyHeight <= sample.GameLayer.winSize.height) {
			if(!this._isBackSkyReload) {
				this._backSkyRe = cc.spritenodes.CCSprite.create("Sample/bg01");
				this._backSkyRe.setAnchorPoint(new flambe.math.Point(0,0));
				this.addChild(this._backSkyRe,-10);
				this._backSkyRe.setPosition(0,sample.GameLayer.winSize.height);
				this._isBackSkyReload = true;
				if(this._temp != null) this.removeChild(this._temp,false);
			}
			this._backSkyRe.runAction(cc.action.CCMoveBy.create(3,new flambe.math.Point(0,this._backgroundSpeed)));
		}
		if(this._backSkyHeight <= 0) {
			this._backSkyHeight = this._backSky.getContentSize().height;
			this._temp = this._backSky;
			this._backSky = this._backSkyRe;
			this._backSkyRe = null;
			this._isBackSkyReload = false;
		}
	}
	,initBackground: function() {
		this._backSky = cc.spritenodes.CCSprite.create("Sample/bg01");
		this._backSky.setAnchorPoint(new flambe.math.Point(0,0));
		this._backSkyHeight = this._backSky.getContentSize().height;
		this.addChild(this._backSky,-10);
		sample.GameLayer.winSize = this._backSky.getContentSize();
		this.schedule($bind(this,this.movingBackground),3);
	}
	,collide: function(a,b) {
		if(cc.cocoa.CCGeometry.rectIntersectsRect(a,b)) return true; else return false;
	}
	,updateUI: function() {
		if(this._tmpScore < sample.config.GameConfig.SCORE) this._tmpScore += 5;
		this._lbLife.setString(Std.string(sample.config.GameConfig.LIFE));
		this.lbScore.setString("Score: " + this._tmpScore);
	}
	,checkIsReborn: function() {
		if(sample.config.GameConfig.LIFE > 0 && !this._ship.active) {
			this._ship = new sample.Ship();
			this.addChild(this._ship,this._ship.zOrder,sample.config.UNIT_TAG.PLAYER);
		} else if(sample.config.GameConfig.LIFE <= 0 && this._ship != null && !this._ship.active) {
			this.runAction(cc.action.CCSequence.create([cc.action.CCDelayTime.create(0.2),cc.action.CCCallFunc.create($bind(this,this.onGameOver),this)]));
			this._ship = null;
		}
	}
	,removeInactiveUnit: function(dt) {
		var enemy;
		var bullet;
		var layerChilren = this.getChildren();
		if(this._ship != null && !this._ship.active) this._ship.destroy();
	}
	,checkIsCollide: function() {
		var selChild;
		var bulletChild;
		var pb = new Array();
		var eb = new Array();
		var e = new Array();
		var pbh = new Array();
		var ebh = new Array();
		var eh = new Array();
		var _g1 = 0, _g = sample.config.GameConfig.ENEMIES.length;
		while(_g1 < _g) {
			var i = _g1++;
			selChild = sample.config.GameConfig.ENEMIES[i];
			var _g3 = 0, _g2 = sample.config.GameConfig.PLAYER_BULLETS.length;
			while(_g3 < _g2) {
				var j = _g3++;
				bulletChild = sample.config.GameConfig.PLAYER_BULLETS[j];
				if(bulletChild != null) {
					if(this.collide(selChild.collideRect(),bulletChild.collideRect())) {
						pbh.push(j);
						eh.push(i);
					} else {
					}
				}
			}
			if(this._ship != null) {
				if(this.collide(selChild.collideRect(),this._ship.collideRect())) {
					if(this._ship.active) {
						selChild.hurt();
						this._ship.hurt();
					}
				}
			}
		}
		var _g = 0;
		while(_g < pbh.length) {
			var i = pbh[_g];
			++_g;
			sample.config.GameConfig.PLAYER_BULLETS[i].hurt();
		}
		pbh = [];
		pb = [];
		var _g = 0;
		while(_g < eh.length) {
			var i = eh[_g];
			++_g;
			sample.config.GameConfig.ENEMIES[i].hurt();
		}
		eh = [];
		var enemyBullet;
		var _g1 = 0, _g = sample.config.GameConfig.ENEMY_BULLETS.length;
		while(_g1 < _g) {
			var i = _g1++;
			enemyBullet = sample.config.GameConfig.ENEMY_BULLETS[i];
			if(enemyBullet != null) {
				if(this._ship != null && this.collide(enemyBullet.collideRect(),this._ship.collideRect())) {
					if(this._ship.active) {
						eb.push(i);
						this._ship.hurt();
					}
				}
			}
		}
		var _g = 0;
		while(_g < eb.length) {
			var i = eb[_g];
			++_g;
			if(sample.config.GameConfig.ENEMY_BULLETS[i] != null) sample.config.GameConfig.ENEMY_BULLETS[i].hurt();
		}
	}
	,update: function(dt) {
		cc.layersscenestransitionsnodes.CCLayer.prototype.update.call(this,dt);
		this.checkIsCollide();
		this.removeInactiveUnit(dt);
		this.checkIsReborn();
		this.updateUI();
	}
	,processEvent: function(event) {
		if(this._state == sample.GameLayer.STATE_PLAYING && this._ship != null) this._ship.setPosition(event.getLocation().x,event.getLocation().y);
	}
	,onPointerDragged: function(event) {
		this.processEvent(event);
		return true;
	}
	,onPointerMoved: function(event) {
		this.processEvent(event);
		return true;
	}
	,scoreCounter: function() {
		if(this._state == sample.GameLayer.STATE_PLAYING) {
			this._time++;
			var minute = this._time / 60 | 0;
			var second = this._time % 60;
			var minuteStr = minute > 9?Std.string(minute):"0" + Std.string(minute);
			var secondStr = second > 9?Std.string(second):"0" + Std.string(second);
			var curTimeStr = minute + ":" + second;
			this._levelManager.loadLevelResource(this._time);
		}
	}
	,init: function() {
		var bRet = false;
		this.registerWithTouchDispatcher();
		if(cc.layersscenestransitionsnodes.CCLayer.prototype.init.call(this)) {
			sample.config.GameConfig.ENEMIES = [];
			sample.config.GameConfig.ENEMY_BULLETS = [];
			sample.config.GameConfig.PLAYER_BULLETS = [];
			sample.config.GameConfig.SCORE = 0;
			sample.config.GameConfig.LIFE = 4;
			this._state = sample.GameLayer.STATE_PLAYING;
			sample.Explosion.sharedExplosion();
			sample.Enemy.sharedEnemy();
			this._levelManager = new sample.LevelManager(this);
			sample.GameLayer.winSize = cc.CCDirector.getInstance().getWinSize();
			this._state = sample.GameLayer.STATE_PLAYING;
			this._beginPos = new flambe.math.Point(0,0);
			this._isBackSkyReload = false;
			this.initBackground();
			this.screenRect = new flambe.math.Rectangle(0,0,sample.GameLayer.winSize.width,sample.GameLayer.winSize.height);
			this.lbScore = cc.labelnodes.CCLabelBMFont.create("Score: 0","Sample/arial-14");
			this.addChild(this.lbScore,4000);
			this.lbScore.setPosition(240,0);
			var shipTexture = cc.texture.CCTextureCache.getInstance().addImage("Sample/ship01");
			var life = cc.spritenodes.CCSprite.createWithTexture(shipTexture,new flambe.math.Rectangle(0,0,60,38));
			life.setScale(0.6);
			life.setPosition(0,0);
			this.addChild(life,4000,5);
			this._lbLife = cc.labelnodes.CCLabelBMFont.create("0","Sample/arial-14");
			this._lbLife.setPosition(40,0);
			this.addChild(this._lbLife,4000);
			this._ship = new sample.Ship();
			this.addChild(this._ship,this._ship.zOrder,sample.config.UNIT_TAG.PLAYER);
			var mainMenuButton = cc.labelnodes.CCLabelBMFont.create("Main Menu","Sample/arial-14");
			var mainMenuItem = cc.menunodes.CCMenuItemLabel.create(mainMenuButton,$bind(this,this.onMainMenu),this);
			var menu = cc.menunodes.CCMenu.create([mainMenuItem]);
			menu.setPosition(240,450);
			this.addChild(menu,4000);
			this.schedule($bind(this,this.scoreCounter),1);
		}
		return true;
	}
	,__class__: sample.GameLayer
});
sample.GameOver = function() {
	cc.layersscenestransitionsnodes.CCLayer.call(this);
};
sample.GameOver.__name__ = true;
sample.GameOver.create = function() {
	var sg = new sample.GameOver();
	if(sg != null) return sg;
	return null;
}
sample.GameOver.__super__ = cc.layersscenestransitionsnodes.CCLayer;
sample.GameOver.prototype = $extend(cc.layersscenestransitionsnodes.CCLayer.prototype,{
	onPlayAgain: function() {
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.GameLayer.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,init: function() {
		var _g = this;
		var bRet = false;
		if(cc.layersscenestransitionsnodes.CCLayer.prototype.init.call(this)) {
			var sp = cc.spritenodes.CCSprite.create("Sample/loading");
			sp.setAnchorPoint(new flambe.math.Point(0,0));
			this.addChild(sp,0,1);
			var logo = cc.spritenodes.CCSprite.create("Sample/gameOver");
			logo.setAnchorPoint(new flambe.math.Point(0,0));
			logo.setPosition(0,80);
			this.addChild(logo,10,1);
			var playAgainNormal = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(378,0,126,33));
			var playAgainSelected = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(378,33,126,33));
			var playAgainDisabled = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(378,66,126,33));
			var cocos2dhtml5 = cc.spritenodes.CCSprite.create("Sample/cocos2d-html5");
			cocos2dhtml5.setCenterAnchor();
			cocos2dhtml5.setPosition(160,380);
			this.addChild(cocos2dhtml5,10);
			var playAgain = cc.menunodes.CCMenuItemSprite.create(playAgainNormal,playAgainSelected,playAgainDisabled,function() {
				sample.Effect.flareEffect(_g,_g,$bind(_g,_g.onPlayAgain));
			},this);
			var menu = cc.menunodes.CCMenu.create([playAgain]);
			this.addChild(menu,1,2);
			menu.setPosition(97,250);
			var lbScore = cc.labelnodes.CCLabelBMFont.create("Your Score:" + sample.config.GameConfig.SCORE,"Sample/arial-14");
			lbScore.setScale(2);
			lbScore.setCenterAnchor();
			lbScore.setPosition(160,200);
			this.addChild(lbScore,10);
			if(sample.config.GameConfig.SOUND) cc.denshion.CCAudioEngine.getInstance().playMusic("Sample/Music/mainMainMusic");
			bRet = true;
		}
		return bRet;
	}
	,__class__: sample.GameOver
});
sample.LevelManager = function(gameLayer) {
	if(gameLayer == null) throw "gameLayer must be non-nil";
	this._currentLevel = sample.config.Level.initLevel1();
	this._gameLayer = gameLayer;
	this.setLevel(this._currentLevel);
	sample.config.EnemyType.create();
};
sample.LevelManager.__name__ = true;
sample.LevelManager.prototype = {
	addEnemyToGameLayer: function(enemytype) {
		if(this._gameLayer._ship == null) return;
		var addEnemy = new sample.Enemy(sample.config.EnemyType.ENEMY_TYPE_LIST[enemytype]);
		var enemypos = new flambe.math.Point(Math.random() * sample.GameLayer.winSize.width,0);
		var enemycs = addEnemy.getContentSize();
		addEnemy.setPosition(enemypos.x,enemypos.y);
		var offset;
		var tmpAction = cc.action.CCAction.create();
		var a0;
		var a1;
		switch(addEnemy.moveType) {
		case sample.config.ENEMY_MOVE_TYPE.ATTACK:
			offset = this._gameLayer._ship.getPosition();
			tmpAction = cc.action.CCMoveTo.create(1,offset);
			break;
		case sample.config.ENEMY_MOVE_TYPE.VERTICAL:
			offset = new flambe.math.Point(0,sample.GameLayer.winSize.height + enemycs.height);
			tmpAction = cc.action.CCMoveBy.create(4,offset);
			break;
		case sample.config.ENEMY_MOVE_TYPE.HORIZONTAL:
			offset = new flambe.math.Point(0,sample.GameLayer.winSize.height + enemycs.height);
			tmpAction = cc.action.CCMoveBy.create(4,offset);
			break;
		case sample.config.ENEMY_MOVE_TYPE.OVERLAP:
			var newX = enemypos.x <= sample.GameLayer.winSize.width / 2?320:-320;
			a0 = cc.action.CCMoveBy.create(4,new flambe.math.Point(newX,240));
			a1 = cc.action.CCMoveBy.create(4,new flambe.math.Point(-newX,320));
			tmpAction = cc.action.CCSequence.create([a0,a1]);
			break;
		}
		this._gameLayer.addChild(addEnemy,addEnemy.zOrder,sample.config.UNIT_TAG.ENEMY);
		sample.config.GameConfig.ENEMIES.push(addEnemy);
		if(js.Boot.__instanceof(tmpAction,cc.action.CCSequence)) {
			var s = js.Boot.__cast(tmpAction , cc.action.CCSequence);
			addEnemy.runAction(s);
		} else if(js.Boot.__instanceof(tmpAction,cc.action.CCMoveTo)) {
			var s = js.Boot.__cast(tmpAction , cc.action.CCMoveTo);
			addEnemy.runAction(s);
		} else if(js.Boot.__instanceof(tmpAction,cc.action.CCMoveBy)) {
			var se = js.Boot.__cast(tmpAction , cc.action.CCMoveBy);
			addEnemy.runAction(se);
		}
	}
	,loadLevelResource: function(deltaTime) {
		var _g1 = 0, _g = this._currentLevel.enemies.length;
		while(_g1 < _g) {
			var i = _g1++;
			var selEnemy = this._currentLevel.enemies[i];
			if(selEnemy != null) {
				if(selEnemy.showType == "Once") {
				} else if(selEnemy.showType == "Repeate") {
					if(deltaTime % Std.parseInt(selEnemy.showTime) == 0) {
						var _g3 = 0, _g2 = selEnemy.types.length;
						while(_g3 < _g2) {
							var rIndex = _g3++;
							this.addEnemyToGameLayer(selEnemy.types[rIndex]);
						}
					}
				}
			}
		}
	}
	,_minuteToSecond: function(minuteStr) {
		if(minuteStr == null) return "0";
		var mins = minuteStr.split(":");
		if(mins.length == 1) return Std.string(Std.parseInt(mins[0])); else return Std.string(Std.parseInt(mins[0]) * 60 + Std.parseInt(mins[1]));
		return minuteStr;
	}
	,setLevel: function(level) {
		var _g1 = 0, _g = level.enemies.length;
		while(_g1 < _g) {
			var i = _g1++;
			this._currentLevel.enemies[i].showTime = this._minuteToSecond(this._currentLevel.enemies[i].showTime);
		}
	}
	,__class__: sample.LevelManager
}
sample.Main = function() { }
sample.Main.__name__ = true;
sample.Main.main = function() {
	flambe.System.init();
	var manifest = flambe.asset.Manifest.build("bootstrap");
	var loader = flambe.System._platform.loadAssetPack(manifest);
	loader.get(sample.Main.onSuccess);
}
sample.Main.onSuccess = function(pack) {
	cc.CCLoader.pack = pack;
	var director = cc.CCDirector.getInstance();
	director.runWithScene(sample.SysMenu.scene());
}
sample.SettingsLayer = function() {
	cc.layersscenestransitionsnodes.CCLayer.call(this);
};
sample.SettingsLayer.__name__ = true;
sample.SettingsLayer.create = function() {
	var sg = new sample.SettingsLayer();
	if(sg != null) return sg;
	return null;
}
sample.SettingsLayer.__super__ = cc.layersscenestransitionsnodes.CCLayer;
sample.SettingsLayer.prototype = $extend(cc.layersscenestransitionsnodes.CCLayer.prototype,{
	backCallback: function() {
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.SysMenu.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,init: function() {
		var bRet = false;
		if(cc.layersscenestransitionsnodes.CCLayer.prototype.init.call(this)) {
			var sp = cc.spritenodes.CCSprite.create("Sample/loading");
			sp.setAnchorPoint(new flambe.math.Point(0,0));
			this.addChild(sp,0,1);
			var cacheImage = cc.texture.CCTextureCache.getInstance().addImage("Sample/menuTitle");
			var title = cc.spritenodes.CCSprite.createWithTexture(cacheImage,new flambe.math.Rectangle(0,0,134,34));
			title.setCenterAnchor();
			title.setPosition(160,60);
			this.addChild(title);
			var label = cc.labelnodes.CCLabelBMFont.create("GoBack","Sample/arial-14");
			var back = cc.menunodes.CCMenuItemLabel.create(label,$bind(this,this.backCallback),this);
			var menu = cc.menunodes.CCMenu.create([back]);
			menu.setPosition(134,360);
			this.addChild(menu);
			bRet = true;
		}
		return bRet;
	}
	,__class__: sample.SettingsLayer
});
sample.Ship = function() {
	this.zOrder = 3000;
	this.canBeAttack = true;
	this.hp = 5;
	this.bulletSpeed = 900;
	var _g = this;
	cc.spritenodes.CCSprite.call(this);
	this.appearPosition = new flambe.math.Point(160,440);
	var shipTexture = cc.texture.CCTextureCache.getInstance().addImage("Sample/ship01");
	this.initWithTexture(shipTexture,new flambe.math.Rectangle(0,0,60,38));
	this.setPosition(this.appearPosition.x,this.appearPosition.y);
	this.active = true;
	var frame0 = cc.spritenodes.CCSpriteFrame.createWithTexture(shipTexture,new flambe.math.Rectangle(0,0,60,38),false,new flambe.math.Point(0,0),new cc.cocoa.CCSize());
	var frame1 = cc.spritenodes.CCSpriteFrame.createWithTexture(shipTexture,new flambe.math.Rectangle(60,0,60,38),false,new flambe.math.Point(0,0),new cc.cocoa.CCSize());
	var animFrames = new Array();
	animFrames.push(frame0);
	animFrames.push(frame1);
	var animation = cc.spritenodes.CCAnimation.createWithAnimationFrames(animFrames,0.1);
	var animate = cc.action.CCAnimate.create(animation);
	this.runAction(cc.action.CCRepeatForever.create(animate));
	this.schedule($bind(this,this.shoot),1 / 6);
	this.canBeAttack = false;
	var ghostSprite = cc.spritenodes.CCSprite.createWithTexture(shipTexture,new flambe.math.Rectangle(0,45,60,38));
	ghostSprite.setCenterAnchor();
	ghostSprite.setScale(8);
	ghostSprite.setPosition(30,24);
	this.addChild(ghostSprite,3000,99999);
	ghostSprite.runAction(cc.action.CCSequence.create([cc.action.CCScaleTo.create(0.5,1,1),cc.action.CCCallFunc.create(function() {
		_g.removeChild(ghostSprite,true);
	},this)]));
	var blinks = cc.action.CCBlink.create(3,9);
	var makeBeAttack = cc.action.CCCallFunc.create(function() {
		_g.canBeAttack = true;
		_g.setVisible(true);
	},this);
	this.runAction(cc.action.CCSequence.create([cc.action.CCDelayTime.create(0.5),blinks,makeBeAttack]));
};
sample.Ship.__name__ = true;
sample.Ship.__super__ = cc.spritenodes.CCSprite;
sample.Ship.prototype = $extend(cc.spritenodes.CCSprite.prototype,{
	collideRect: function() {
		var p = this.getPosition();
		var a = this.getContentSize();
		var r = new flambe.math.Rectangle(p.x,p.y,a.width,a.height);
		return r;
	}
	,hurt: function() {
		if(this.canBeAttack) this.hp--;
	}
	,destroy: function() {
		sample.config.GameConfig.LIFE--;
		var p = this.getPosition();
		var myParent = this.getParent();
		var e = new sample.Explosion();
		myParent.removeChild(this,true);
		e.setPosition(p.x,p.y);
		if(sample.config.GameConfig.SOUND) cc.denshion.CCAudioEngine.getInstance().playEffect("Sample/Music/shipDestroyEffect");
	}
	,shoot: function() {
		var offset = 13;
		var cs = this.getContentSize();
		var a = new sample.Bullet(this.bulletSpeed,"W1.png",sample.config.ENEMY_ATTACK_MODE.NORMAL);
		var p = this.getPosition();
		sample.config.GameConfig.PLAYER_BULLETS.push(a);
		a.setPosition(p.x + offset,p.y - 10 + this.getContentSize().height * 0.3);
		this.getParent().addChild(a);
		var b = new sample.Bullet(this.bulletSpeed,"W1.png",sample.config.ENEMY_ATTACK_MODE.NORMAL);
		b.setPosition(p.x + 3 * offset,p.y - 10 + this.getContentSize().height * 0.3);
		this.getParent().addChild(b);
		sample.config.GameConfig.PLAYER_BULLETS.push(b);
	}
	,update: function(dt) {
		cc.spritenodes.CCSprite.prototype.update.call(this,dt);
		if(this.hp <= 0) this.active = false;
	}
	,__class__: sample.Ship
});
sample.SysMenu = function() {
	cc.layersscenestransitionsnodes.CCLayer.call(this);
};
sample.SysMenu.__name__ = true;
sample.SysMenu.create = function() {
	var sg = new sample.SysMenu();
	if(sg != null) return sg;
	return null;
}
sample.SysMenu.scene = function() {
	var scene = cc.layersscenestransitionsnodes.CCScene.create();
	var layer = sample.SysMenu.create();
	scene.addChild(layer);
	return scene;
}
sample.SysMenu.__super__ = cc.layersscenestransitionsnodes.CCLayer;
sample.SysMenu.prototype = $extend(cc.layersscenestransitionsnodes.CCLayer.prototype,{
	onButtonEffect: function() {
		if(sample.config.GameConfig.SOUND) cc.denshion.CCAudioEngine.getInstance().playEffect("Sample/Music/buttonEffect");
	}
	,onAbout: function() {
		this.onButtonEffect();
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.AboutLayer.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,onSettings: function() {
		this.onButtonEffect();
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.SettingsLayer.create());
		cc.CCDirector.getInstance().replaceScene(scene);
	}
	,onNewGame: function() {
		var scene = cc.layersscenestransitionsnodes.CCScene.create();
		scene.addChild(sample.GameLayer.create());
		cc.CCDirector.getInstance().replaceScene(cc.layersscenestransitionsnodes.CCTransitionFade.create(1.2,scene));
	}
	,init: function() {
		var _g = this;
		var bRet = false;
		if(cc.layersscenestransitionsnodes.CCLayer.prototype.init.call(this)) {
			this.winSize = cc.CCDirector.getInstance().getWinSize();
			sample.GameLayer.winSize = this.winSize;
			var logo = cc.spritenodes.CCSprite.create("Sample/logo");
			logo.setAnchorPoint(new flambe.math.Point(0,0));
			logo.setPosition(0,100);
			this.addChild(logo,10,2);
			var sp = cc.spritenodes.CCSprite.create("Sample/loading");
			sp.setAnchorPoint(new flambe.math.Point(0,0));
			this.addChild(sp,1,1);
			var newGameNormal = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(0,0,126,33));
			var newGameSelected = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(0,33,126,33));
			var newGameDisabled = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(0,66,126,33));
			var gameSettingsNormal = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(126,0,126,33));
			var gameSettingsSelected = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(126,33,126,33));
			var gameSettingsDisabled = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(126,66,126,33));
			var aboutNormal = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(252,0,126,33));
			var aboutSelected = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(252,33,126,33));
			var aboutDisabled = cc.spritenodes.CCSprite.create("Sample/menu",new flambe.math.Rectangle(252,66,126,33));
			var newGame = cc.menunodes.CCMenuItemSprite.create(newGameNormal,newGameSelected,newGameDisabled,function() {
				_g.onButtonEffect();
				sample.Effect.flareEffect(_g,_g,$bind(_g,_g.onNewGame));
			},this);
			var gameSettings = cc.menunodes.CCMenuItemSprite.create(gameSettingsNormal,gameSettingsSelected,gameSettingsDisabled,$bind(this,this.onSettings),this);
			var about = cc.menunodes.CCMenuItemSprite.create(aboutNormal,aboutSelected,aboutDisabled,$bind(this,this.onAbout),this);
			var _menu = cc.menunodes.CCMenu.create([newGame,gameSettings,about]);
			_menu.alignVerticallyWithPadding(10);
			_menu.setCenterAnchor();
			_menu.setPosition(97,250);
			this.addChild(_menu,6,2);
			bRet = true;
			if(sample.config.GameConfig.SOUND) {
				cc.denshion.CCAudioEngine.getInstance().set__musicVolume(0.7);
				cc.denshion.CCAudioEngine.getInstance().playMusic("Sample/Music/mainMainMusic",true);
			}
		}
		return bRet;
	}
	,__class__: sample.SysMenu
});
sample.config = {}
sample.config.EnemyType = function(type,textureName,bulletType,hp,moveType,attackMode,scoreValue) {
	this.HP = 1;
	this.type = 0;
	this.type = type;
	this.textureName = textureName;
	this.bulletType = bulletType;
	this.HP = hp;
	this.moveType = moveType;
	this.attackMode = attackMode;
	this.scoreValue = scoreValue;
};
sample.config.EnemyType.__name__ = true;
sample.config.EnemyType.create = function() {
	if(sample.config.EnemyType.ENEMY_TYPE_LIST == null) {
		sample.config.EnemyType.ENEMY_TYPE_LIST = new Array();
		var type0 = new sample.config.EnemyType(0,"E0.png","W2.png",1,sample.config.ENEMY_MOVE_TYPE.ATTACK,sample.config.ENEMY_ATTACK_MODE.NORMAL,15);
		var type1 = new sample.config.EnemyType(1,"E1.png","W2.png",2,sample.config.ENEMY_MOVE_TYPE.ATTACK,sample.config.ENEMY_ATTACK_MODE.NORMAL,40);
		var type2 = new sample.config.EnemyType(2,"E2.png","W2.png",4,sample.config.ENEMY_MOVE_TYPE.HORIZONTAL,sample.config.ENEMY_ATTACK_MODE.TSUIHIKIDAN,60);
		var type3 = new sample.config.EnemyType(3,"E3.png","W2.png",6,sample.config.ENEMY_MOVE_TYPE.OVERLAP,sample.config.ENEMY_ATTACK_MODE.NORMAL,80);
		var type4 = new sample.config.EnemyType(4,"E4.png","W2.png",10,sample.config.ENEMY_MOVE_TYPE.HORIZONTAL,sample.config.ENEMY_ATTACK_MODE.TSUIHIKIDAN,150);
		var type5 = new sample.config.EnemyType(5,"E5.png","W2.png",20,sample.config.ENEMY_MOVE_TYPE.HORIZONTAL,sample.config.ENEMY_ATTACK_MODE.NORMAL,200);
		sample.config.EnemyType.ENEMY_TYPE_LIST = [type0,type1,type2,type3,type4,type5];
	}
	return sample.config.EnemyType.ENEMY_TYPE_LIST;
}
sample.config.EnemyType.prototype = {
	__class__: sample.config.EnemyType
}
sample.config.GameConfig = function() { }
sample.config.GameConfig.__name__ = true;
sample.config.ENEMY_MOVE_TYPE = function() { }
sample.config.ENEMY_MOVE_TYPE.__name__ = true;
sample.config.BULLET_TYPE = function() { }
sample.config.BULLET_TYPE.__name__ = true;
sample.config.UNIT_TAG = function() { }
sample.config.UNIT_TAG.__name__ = true;
sample.config.ENEMY_ATTACK_MODE = function() { }
sample.config.ENEMY_ATTACK_MODE.__name__ = true;
sample.config.Level = function() {
};
sample.config.Level.__name__ = true;
sample.config.Level.initLevel1 = function() {
	var level1 = new sample.config.Level();
	level1.enemies = new Array();
	var e = new sample.config.Entry();
	e.showType = "Repeate";
	e.showTime = "00:02";
	e.types = [0,1,2];
	level1.enemies.push(e);
	var e1 = new sample.config.Entry();
	e1.showType = "Repeate";
	e1.showTime = "00:05";
	e1.types = [3,4,5];
	level1.enemies.push(e1);
	return level1;
}
sample.config.Level.prototype = {
	__class__: sample.config.Level
}
sample.config.Entry = function() {
};
sample.config.Entry.__name__ = true;
sample.config.Entry.prototype = {
	__class__: sample.config.Entry
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.prototype.__class__ = Array;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = ["Date"];
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
Xml.Element = "element";
Xml.PCData = "pcdata";
Xml.CData = "cdata";
Xml.Comment = "comment";
Xml.DocType = "doctype";
Xml.ProcessingInstruction = "processingInstruction";
Xml.Document = "document";
cc.CCDirector.DIRECTOR_PROJECTION_3D = 1;
cc.CCDirector.DIRECTOR_PROJECTION_DEFAULT = cc.CCDirector.DIRECTOR_PROJECTION_3D;
cc.CCDirector.defaultFPS = 60;
cc.CCDirector.firstUseDirector = true;
cc.action.CCAction.ACTION_TAG_INVALID = -1;
cc.menunodes.CCMenu.MENU_STATE_WAITING = 0;
cc.menunodes.CCMenu.MENU_STATE_TRACKING_TOUCH = 1;
cc.menunodes.CCMenu.MENU_HANDLER_PRIORITY = -128;
cc.menunodes.CCMenuItem.ZOOM_ACTION_TAG = -1061138430;
cc.menunodes.CCMenuItem.NORMAL_TAG = 8801;
cc.menunodes.CCMenuItem.SELECTED_TAG = 8802;
cc.menunodes.CCMenuItem.DISABLE_TAG = 8803;
cc.platform.CCConfig.NODE_TRANSFORM_USING_AFFINE_MATRIX = 1;
cc.platform.CCGZip.LITERALS = 288;
cc.platform.CCGZip.NAMEMAX = 256;
cc.platform.CCGZip.bitReverse = [0,128,64,192,32,160,96,224,16,144,80,208,48,176,112,240,8,136,72,200,40,168,104,232,24,152,88,216,56,184,120,248,4,132,68,196,36,164,100,228,20,148,84,212,52,180,116,244,12,140,76,204,44,172,108,236,28,156,92,220,60,188,124,252,2,130,66,194,34,162,98,226,18,146,82,210,50,178,114,242,10,138,74,202,42,170,106,234,26,154,90,218,58,186,122,250,6,134,70,198,38,166,102,230,22,150,86,214,54,182,118,246,14,142,78,206,46,174,110,238,30,158,94,222,62,190,126,254,1,129,65,193,33,161,97,225,17,145,81,209,49,177,113,241,9,137,73,201,41,169,105,233,25,153,89,217,57,185,121,249,5,133,69,197,37,165,101,229,21,149,85,213,53,181,117,245,13,141,77,205,45,173,109,237,29,157,93,221,61,189,125,253,3,131,67,195,35,163,99,227,19,147,83,211,51,179,115,243,11,139,75,203,43,171,107,235,27,155,91,219,59,187,123,251,7,135,71,199,39,167,103,231,23,151,87,215,55,183,119,247,15,143,79,207,47,175,111,239,31,159,95,223,63,191,127,255];
cc.platform.CCGZip.cplens = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258,0,0];
cc.platform.CCGZip.cplext = [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,99,99];
cc.platform.CCGZip.cpdist = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577];
cc.platform.CCGZip.cpdext = [0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13];
cc.platform.CCGZip.border = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];
flambe.display.Sprite._scratchPoint = new flambe.math.Point();
cc.tilemapparallaxnodes.CCTMXTiledMap.useViewPort = false;
cc.tilemapparallaxnodes.CCTMXTiledMap.viewPort = new flambe.math.Rectangle();
cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ORTHO = 0;
cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_HEX = 1;
cc.tilemapparallaxnodes.CCTMXTiledMap.TMX_ORIENTATION_ISO = 2;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_LAYER_ATTRIB_NONE = 1;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_PROPERTY_NONE = 0;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_HORIZONTAL_FLAG = -2147483648;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_VERTICAL_FLAG = 1073741824;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_DIAGONAL_FLAG = 536870912;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_FLIPPED_ALL = (cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_HORIZONTAL_FLAG | cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_VERTICAL_FLAG | cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_DIAGONAL_FLAG) >>> 0;
cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_FLIPPED_MASK = ~cc.tilemapparallaxnodes.CCTMXXMLParser.TMX_TILE_FLIPPED_ALL >>> 0;
cc.touchdispatcher.CCPointerDispatcher.POINTER_DOWN = 0;
cc.touchdispatcher.CCPointerDispatcher.POINTER_UP = 3;
cc.touchdispatcher.CCPointerDispatcher.POINTER_MOVED = 1;
cc.touchdispatcher.CCPointerDispatcher._prePoint = new flambe.math.Point(0,0);
flambe.platform.html.HtmlPlatform.instance = new flambe.platform.html.HtmlPlatform();
flambe.util.SignalBase.DISPATCHING_SENTINEL = new flambe.util.SignalConnection(null,null);
flambe.System.root = new flambe.Entity();
flambe.System.uncaughtError = new flambe.util.Signal1();
flambe.System.hidden = new flambe.util.Value(false);
flambe.System.hasGPU = new flambe.util.Value(false);
flambe.System.volume = new flambe.animation.AnimatedFloat(1);
flambe.System._platform = flambe.platform.html.HtmlPlatform.instance;
flambe.System._calledInit = false;
js.Browser.window = typeof window != "undefined" ? window : null;
js.Browser.document = typeof window != "undefined" ? window.document : null;
js.Browser.navigator = typeof window != "undefined" ? window.navigator : null;
flambe.asset.Manifest.__meta__ = { obj : { assets : [{ bootstrap : [{ bytes : 12553, md5 : "1a9b75c3ed8979ef2312847a1c19257d", name : "Sample/arial-14.fnt"},{ bytes : 39873, md5 : "16567b2fa767e5bcff4769cebad114d4", name : "Sample/arial-14.png"},{ bytes : 17484, md5 : "27a583b25df2374ec6fd50de337ffd9c", name : "Sample/bg01.jpg"},{ bytes : 1648, md5 : "2cb6a4efa13957d4ffc32ec3fdc90f0f", name : "Sample/bullet.plist"},{ bytes : 1443, md5 : "cc8a4fa8101e0f5f57858ed22bfe6a89", name : "Sample/bullet.png"},{ bytes : 1058, md5 : "46f2e95b40000d30b4346687271764e0", name : "Sample/bullet1.png"},{ bytes : 16572, md5 : "500057c6bacfcc1e7746a35f1417dd27", name : "Sample/cocos2d-html5.png"},{ bytes : 3472, md5 : "83b824a8c17fd3ea07f17275788941fc", name : "Sample/Enemy.plist"},{ bytes : 25623, md5 : "eaeb5bccd45c830d9030973393416d5b", name : "Sample/Enemy.png"},{ bytes : 2143, md5 : "a802dec71fb2e009cd56fe7f38a51b8f", name : "Sample/explode1.jpg"},{ bytes : 2630, md5 : "3718d50faae859ba3c8ba6dc03ae4818", name : "Sample/explode2.jpg"},{ bytes : 2521, md5 : "f439bc5b5b622959369da1e26d6eb40e", name : "Sample/explode3.jpg"},{ bytes : 17282, md5 : "aa9d033c41db323849a5cc87b1e0fa48", name : "Sample/explosion.plist"},{ bytes : 207311, md5 : "5a37504f335b0bdfb6b0711c08f72d5f", name : "Sample/explosion.png"},{ bytes : 25365, md5 : "93bb3e71fa0a75066682ca370c935d3f", name : "Sample/flare.jpg"},{ bytes : 29415, md5 : "de21d28bdfa2121420892224b03e1376", name : "Sample/gameOver.png"},{ bytes : 2755, md5 : "592f9ea85bc45eb962e1fd903c1e2af6", name : "Sample/hit.png"},{ bytes : 165747, md5 : "ec3a961a645c5b94c3b39572532aa43c", name : "Sample/loading.png"},{ bytes : 60102, md5 : "1fad9922cf63e6d6811af200bc583f2c", name : "Sample/logo.png"},{ bytes : 24742, md5 : "be7bf63e07c09816b4f317f27a4c02a4", name : "Sample/menu.png"},{ bytes : 14805, md5 : "a90c9b20e3b1a97c93a3a03c01ff2c8e", name : "Sample/menuTitle.png"},{ bytes : 2023932, md5 : "600be0100f2f3f1abe91bc52fc502c0e", name : "Sample/Music/bgMusic.mp3"},{ bytes : 863372, md5 : "b164e5493f577973eefa8ad0a15e109f", name : "Sample/Music/bgMusic.ogg"},{ bytes : 8535, md5 : "ba4412bd2f1b47d1e5a3f779aa90bfaa", name : "Sample/Music/buttonEffect.mp3"},{ bytes : 14800, md5 : "8a0e4ba979bbcd58c4eec535410c0767", name : "Sample/Music/buttonEffect.ogg"},{ bytes : 3959, md5 : "7bd9f62227e4db2a5562a6d4c4070905", name : "Sample/Music/explodeEffect.mp3"},{ bytes : 8701, md5 : "5897e7553e456c6e9b44c7c062b48f0e", name : "Sample/Music/explodeEffect.ogg"},{ bytes : 2191, md5 : "172ef539027ec8415de9fc68ed524441", name : "Sample/Music/fireEffect.mp3"},{ bytes : 6998, md5 : "234b197ac92b8812f27f7a53db5352f1", name : "Sample/Music/fireEffect.ogg"},{ bytes : 765708, md5 : "4d42b47e45ef26d03421bf48b0860d4a", name : "Sample/Music/mainMainMusic.mp3"},{ bytes : 364578, md5 : "7921d9da8a3d6a2cb7c8e746f7000e5a", name : "Sample/Music/mainMainMusic.ogg"},{ bytes : 23199, md5 : "cb925f4ab255e4ca8189b0e1f7c0372e", name : "Sample/Music/shipDestroyEffect.mp3"},{ bytes : 28723, md5 : "4da7c6b473f45104684e7a6128d45f69", name : "Sample/Music/shipDestroyEffect.ogg"},{ bytes : 11411, md5 : "d61385eeb0342fb4f7e90ab455a9e019", name : "Sample/ship01.png"},{ bytes : 583, md5 : "ca1b2fba5e61b2bfe2b73974d6079240", name : "Sample/w2.png"}]}]}};
flambe.asset.Manifest._supportsCrossOrigin = (function() {
	var blacklist = new EReg("\\b(Android)\\b","");
	if(blacklist.match(js.Browser.window.navigator.userAgent)) return false;
	var xhr = new XMLHttpRequest();
	return xhr.withCredentials != null;
})();
flambe.display.Font.NEWLINE = new flambe.display.Glyph(10);
flambe.platform.BasicKeyboard._sharedEvent = new flambe.input.KeyboardEvent();
flambe.platform.BasicMouse._sharedEvent = new flambe.input.MouseEvent();
flambe.platform.BasicPointer._sharedEvent = new flambe.input.PointerEvent();
flambe.platform.html.CanvasRenderer.CANVAS_TEXTURES = (function() {
	var pattern = new EReg("(iPhone|iPod|iPad)","");
	return pattern.match(js.Browser.window.navigator.userAgent);
})();
flambe.platform.html.HtmlAssetPackLoader._mediaRefCount = 0;
flambe.platform.html.HtmlAssetPackLoader._detectBlobSupport = true;
flambe.platform.html.HtmlUtil.VENDOR_PREFIXES = ["webkit","moz","ms","o","khtml"];
flambe.platform.html.HtmlUtil.SHOULD_HIDE_MOBILE_BROWSER = js.Browser.window.top == js.Browser.window && new EReg("Mobile(/.*)? Safari","").match(js.Browser.navigator.userAgent);
flambe.platform.html.WebAudioSound._detectSupport = true;
flambe.platform.html.WebGLGraphics._scratchMatrix = new flambe.math.Matrix();
haxe.xml.Parser.escapes = (function($this) {
	var $r;
	var h = new haxe.ds.StringMap();
	h.set("lt","<");
	h.set("gt",">");
	h.set("amp","&");
	h.set("quot","\"");
	h.set("apos","'");
	h.set("nbsp",String.fromCharCode(160));
	$r = h;
	return $r;
}(this));
haxe.zip.InflateImpl.LEN_EXTRA_BITS_TBL = [0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,-1,-1];
haxe.zip.InflateImpl.LEN_BASE_VAL_TBL = [3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258];
haxe.zip.InflateImpl.DIST_EXTRA_BITS_TBL = [0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,-1,-1];
haxe.zip.InflateImpl.DIST_BASE_VAL_TBL = [1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577];
haxe.zip.InflateImpl.CODE_LENGTHS_POS = [16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];
sample.GameLayer.STATE_PLAYING = 0;
sample.config.GameConfig.LIFE = 1;
sample.config.GameConfig.SCORE = 0;
sample.config.GameConfig.SOUND = true;
sample.config.GameConfig.ENEMIES = new Array();
sample.config.GameConfig.ENEMY_BULLETS = new Array();
sample.config.GameConfig.PLAYER_BULLETS = new Array();
sample.config.ENEMY_MOVE_TYPE.ATTACK = 0;
sample.config.ENEMY_MOVE_TYPE.VERTICAL = 1;
sample.config.ENEMY_MOVE_TYPE.HORIZONTAL = 2;
sample.config.ENEMY_MOVE_TYPE.OVERLAP = 3;
sample.config.BULLET_TYPE.PLAYER = 1;
sample.config.UNIT_TAG.ENEMY_BULLET = 900;
sample.config.UNIT_TAG.ENEMY = 1000;
sample.config.UNIT_TAG.PLAYER = 1000;
sample.config.ENEMY_ATTACK_MODE.NORMAL = 1;
sample.config.ENEMY_ATTACK_MODE.TSUIHIKIDAN = 2;
sample.Main.main();
})();
