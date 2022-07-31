(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	this.r = new RegExp(r,opt.split("u").join(""));
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) {
			this.r.lastIndex = 0;
		}
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) {
			return this.r.m[n];
		} else {
			throw haxe_Exception.thrown("EReg::matched");
		}
	}
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.now = function() {
	return Date.now();
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var image = vision_ds_Image._new(250,250,0);
	vision_ds_Image.drawLine(image,12,53,54,15,12386818);
	vision_ds_Image.drawLine(image,56,248,181,95,853);
	vision_ds_Image.drawLine(image,110,15,121,131,3273472);
	vision_ds_Image.drawLine(image,248,53,15,231,16777215);
	vision_ds_Image.drawRect(image,34,12,33,53,15793990);
	vision_ds_Image.fillRect(image,12,53,33,53,16777215);
	vision_ds_Image.drawCircle(image,100,100,50,3967342);
	vision_ds_Image.drawCircle(image,100,100,30,16711892);
	vision_ds_Image.drawCircle(image,200,200,40,16776960);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(200,200),16776960);
	vision_ds_Image.drawCircle(image,180,190,5,9127187);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(180,190),9127187);
	vision_ds_Image.drawCircle(image,220,190,5,9127187);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(220,190),9127187);
	vision_ds_Image.drawCircle(image,200,225,8,9127187);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(200,225),9127187);
	Main.printIm(image);
	var start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.blackAndWhite(vision_ds_Image.clone(image)));
	var end = HxOverrides.now() / 1000;
	haxe_Log.trace("Black and white took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 45, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.grayscale(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Grayscale took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 49, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Sobel edge detection took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 53, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var hough = vision_algorithms_Hough.toHoughSpace(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
	Main.printIm(hough.image);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Hough transform took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 58, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Perwitt edge detection took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 62, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.nearestNeighborBlur(vision_ds_Image.clone(image),1));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Nearest neighbor blur took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 66, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.contrast(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Contrast took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 70, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_Vision.gaussianBlur(vision_ds_Image.clone(image),2,15));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Gaussian blur took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 74, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printIm(vision_ds_Image.clone(image));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Image Cloning took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 78, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var canny = vision_Vision.cannyEdgeDetection(vision_ds_Image.clone(image));
	Main.printIm(canny);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Canny edge detection took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 83, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var lines = vision_Vision.simpleLine2DDetection(vision_ds_Image.clone(image),3,30);
	var newI = vision_ds_Image.clone(image);
	var _g = 0;
	while(_g < lines.length) {
		var l = lines[_g];
		++_g;
		vision_ds_Image.drawLineSegment2D(newI,l,65493);
	}
	Main.printIm(newI);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Simple line detection took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 92, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var lines = vision_Vision.houghLine2DDetection(vision_ds_Image.clone(image));
	var _g = 0;
	while(_g < lines.length) {
		var l = lines[_g];
		++_g;
		vision_ds_Image.drawRay2D(image,l,65493);
	}
	Main.printIm(image);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Hough line detection took: " + vision_tools_MathUtils.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 100, className : "Main", methodName : "main"});
};
Main.printIm = function(image) {
	var c = window.document.createElement("canvas");
	c.width = vision_ds_Image.get_width(image);
	c.height = vision_ds_Image.get_height(image);
	var ctx = c.getContext("2d",null);
	var imageData = ctx.getImageData(0,0,vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var data = imageData.data;
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var i = (y * vision_ds_Image.get_width(image) + x) * 4;
			data[i] = vision_ds_Image.getPixel(image,x,y) >> 16 & 255;
			data[i + 1] = vision_ds_Image.getPixel(image,x,y) >> 8 & 255;
			data[i + 2] = vision_ds_Image.getPixel(image,x,y) & 255;
			data[i + 3] = 255;
		}
	}
	ctx.putImageData(imageData,0,0);
	c.style.padding = "10px";
	window.document.body.appendChild(c);
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,r,l - r);
	} else {
		return s;
	}
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,0,l - r);
	} else {
		return s;
	}
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	while(true) {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
		if(!(n > 0)) {
			break;
		}
	}
	if(digits != null) {
		while(s.length < digits) s = "0" + s;
	}
	return s;
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	get_native: function() {
		return this.__nativeException;
	}
});
var haxe_Log = function() { };
haxe_Log.__name__ = true;
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
});
var haxe_ds_ObjectMap = function() {
	this.h = { __keys__ : { }};
};
haxe_ds_ObjectMap.__name__ = true;
haxe_ds_ObjectMap.prototype = {
	set: function(key,value) {
		var id = key.__id__;
		if(id == null) {
			id = (key.__id__ = $global.$haxeUID++);
		}
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,get: function(key) {
		return this.h[key.__id__];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) {
			a.push(this.h.__keys__[key]);
		}
		}
		return new haxe_iterators_ArrayIterator(a);
	}
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var vision_Vision = function() { };
vision_Vision.__name__ = true;
vision_Vision.grayscale = function(image) {
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var j = _g2++;
			var pixel = vision_ds_Image.getPixel(image,i,j);
			var gray = ((pixel >> 16 & 255) + (pixel >> 8 & 255) + (pixel & 255)) / 3 | 0;
			var color = vision_ds_Color._new();
			var Alpha = 255;
			if(Alpha == null) {
				Alpha = 255;
			}
			color &= -16711681;
			color |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 16;
			color &= -65281;
			color |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 8;
			color &= -256;
			color |= gray > 255 ? 255 : gray < 0 ? 0 : gray;
			color &= 16777215;
			color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
			vision_ds_Image.setPixel(image,i,j,color);
		}
	}
	return image;
};
vision_Vision.invert = function(image) {
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var j = _g2++;
			var pixel = vision_ds_Image.getPixel(image,i,j);
			var Red = 255 - (pixel >> 16 & 255);
			var Green = 255 - (pixel >> 8 & 255);
			var Blue = 255 - (pixel & 255);
			var color = vision_ds_Color._new();
			var Alpha = 255;
			if(Alpha == null) {
				Alpha = 255;
			}
			color &= -16711681;
			color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
			color &= -65281;
			color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
			color &= -256;
			color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
			color &= 16777215;
			color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
			vision_ds_Image.setPixel(image,i,j,color);
		}
	}
	return image;
};
vision_Vision.blackAndWhite = function(image,threshold) {
	if(threshold == null) {
		threshold = 64;
	}
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var j = _g2++;
			var pixel = vision_ds_Image.getPixel(image,i,j);
			var average = ((pixel >> 16 & 255) + (pixel >> 8 & 255) + (pixel & 255)) / 3;
			if(average > threshold) {
				vision_ds_Image.setPixel(image,i,j,-1);
			} else {
				vision_ds_Image.setPixel(image,i,j,vision_ds_Color._new(0));
			}
		}
	}
	return image;
};
vision_Vision.contrast = function(image) {
	var getContrasted = function(color) {
		var red = (color >> 16 & 255) > 127 ? 255 : 0;
		var green = (color >> 8 & 255) > 127 ? 255 : 0;
		var blue = (color & 255) > 127 ? 255 : 0;
		var color = vision_ds_Color._new();
		var Alpha = 255;
		if(Alpha == null) {
			Alpha = 255;
		}
		color &= -16711681;
		color |= (red > 255 ? 255 : red < 0 ? 0 : red) << 16;
		color &= -65281;
		color |= (green > 255 ? 255 : green < 0 ? 0 : green) << 8;
		color &= -256;
		color |= blue > 255 ? 255 : blue < 0 ? 0 : blue;
		color &= 16777215;
		color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
		return color;
	};
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var pixel = vision_ds_Image.getPixel(image,x,y);
			var contrasted = getContrasted(pixel);
			vision_ds_Image.setPixel(image,x,y,contrasted);
		}
	}
	return image;
};
vision_Vision.houghLine2DDetection = function(image,threshold,minLineLength,minLineGap,maxLineGap) {
	if(maxLineGap == null) {
		maxLineGap = 10;
	}
	if(minLineGap == null) {
		minLineGap = 2;
	}
	if(minLineLength == null) {
		minLineLength = 30;
	}
	if(threshold == null) {
		threshold = 100;
	}
	var edges = vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image),threshold);
	var houghSpace = vision_algorithms_Hough.toHoughSpace(edges);
	var accumulator = houghSpace.accumulator;
	var values = [];
	var map = accumulator;
	var vals_map = map;
	var vals_keys = map.keys();
	while(vals_keys.hasNext()) {
		var key = vals_keys.next();
		var vals = { value : vals_map.get(key), key : key};
		if(vals.value > minLineLength) {
			values.push(vals);
		}
	}
	haxe_Log.trace(values,{ fileName : "src/vision/Vision.hx", lineNumber : 133, className : "vision.Vision", methodName : "houghLine2DDetection"});
	return [];
};
vision_Vision.sobelEdgeDetection = function(image,threshold) {
	if(threshold == null) {
		threshold = 100;
	}
	var edges = vision_ds_Image.get_width(image);
	var edges1 = vision_ds_Image.get_height(image);
	var color = vision_ds_Color._new();
	var Alpha = 255;
	if(Alpha == null) {
		Alpha = 255;
	}
	color &= -16711681;
	color |= 0;
	color &= -65281;
	color |= 0;
	color &= -256;
	color |= 0;
	color &= 16777215;
	color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
	var edges2 = vision_ds_Image._new(edges,edges1,color);
	var blacknwhite = vision_Vision.grayscale(vision_ds_Image.clone(image));
	var _g = 1;
	var _g1 = vision_ds_Image.get_width(blacknwhite) - 1;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_height(blacknwhite) - 1;
		while(_g2 < _g3) {
			var y = _g2++;
			var neighbors_0 = vision_ds_Image.getPixel(blacknwhite,x - 1,y - 1);
			var neighbors_1 = vision_ds_Image.getPixel(blacknwhite,x,y - 1);
			var neighbors_2 = vision_ds_Image.getPixel(blacknwhite,x + 1,y - 1);
			var neighbors_3 = vision_ds_Image.getPixel(blacknwhite,x - 1,y);
			var neighbors_4 = vision_ds_Image.getPixel(blacknwhite,x,y);
			var neighbors_5 = vision_ds_Image.getPixel(blacknwhite,x + 1,y);
			var neighbors_6 = vision_ds_Image.getPixel(blacknwhite,x - 1,y + 1);
			var neighbors_7 = vision_ds_Image.getPixel(blacknwhite,x,y + 1);
			var neighbors_8 = vision_ds_Image.getPixel(blacknwhite,x + 1,y + 1);
			var sobelCalculationIterationLTR = (neighbors_0 >> 16 & 255) * -3 + (neighbors_3 >> 16 & 255) * -10 + (neighbors_6 >> 16 & 255) * -3 + (neighbors_2 >> 16 & 255) * 3 + (neighbors_5 >> 16 & 255) * 10 + (neighbors_8 >> 16 & 255) * 3;
			if(Math.abs(sobelCalculationIterationLTR) > threshold) {
				var color = vision_ds_Color._new();
				var Alpha = 255;
				if(Alpha == null) {
					Alpha = 255;
				}
				color &= -16711681;
				color |= 16711680;
				color &= -65281;
				color |= 65280;
				color &= -256;
				color |= 255;
				color &= 16777215;
				color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
				vision_ds_Image.setPixel(edges2,x,y,color);
				continue;
			}
			var sobelCalculationIterationTTB = (neighbors_0 >> 16 & 255) * -3 + (neighbors_1 >> 16 & 255) * -10 + (neighbors_2 >> 16 & 255) * -3 + (neighbors_6 >> 16 & 255) * 3 + (neighbors_7 >> 16 & 255) * 10 + (neighbors_8 >> 16 & 255) * 3;
			if(Math.abs(sobelCalculationIterationTTB) > threshold) {
				var color1 = vision_ds_Color._new();
				var Alpha1 = 255;
				if(Alpha1 == null) {
					Alpha1 = 255;
				}
				color1 &= -16711681;
				color1 |= 16711680;
				color1 &= -65281;
				color1 |= 65280;
				color1 &= -256;
				color1 |= 255;
				color1 &= 16777215;
				color1 |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
				vision_ds_Image.setPixel(edges2,x,y,color1);
				continue;
			}
		}
	}
	var intermediate = vision_ds_Image.clone(edges2);
	var _g = 1;
	var _g1 = vision_ds_Image.get_width(intermediate) - 1;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_height(intermediate) - 1;
		while(_g2 < _g3) {
			var y = _g2++;
			if((vision_ds_Image.getPixel(edges2,x,y) >> 16 & 255) == 0) {
				var candidate = false;
				var X = false;
				var Y = false;
				if((vision_ds_Image.getPixel(image,x + 1,y) >> 16 & 255) == 255 && (vision_ds_Image.getPixel(image,x - 1,y) >> 16 & 255) == 255) {
					candidate = true;
					X = true;
				}
				if((vision_ds_Image.getPixel(image,x,y + 1) >> 16 & 255) == 255 && (vision_ds_Image.getPixel(image,x,y - 1) >> 16 & 255) == 255) {
					candidate = true;
					Y = true;
				}
				if(candidate) {
					var color = vision_ds_Color._new();
					var Alpha = 255;
					if(Alpha == null) {
						Alpha = 255;
					}
					color &= -16711681;
					color |= 16711680;
					color &= -65281;
					color |= 65280;
					color &= -256;
					color |= 255;
					color &= 16777215;
					color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
					vision_ds_Image.setPixel(intermediate,x,y,color);
					if(X) {
						var color1 = vision_ds_Color._new();
						var Alpha1 = 255;
						if(Alpha1 == null) {
							Alpha1 = 255;
						}
						color1 &= -16711681;
						color1 |= 0;
						color1 &= -65281;
						color1 |= 0;
						color1 &= -256;
						color1 |= 0;
						color1 &= 16777215;
						color1 |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
						vision_ds_Image.setPixel(intermediate,x + 1,y,color1);
						var color2 = vision_ds_Color._new();
						var Alpha2 = 255;
						if(Alpha2 == null) {
							Alpha2 = 255;
						}
						color2 &= -16711681;
						color2 |= 0;
						color2 &= -65281;
						color2 |= 0;
						color2 &= -256;
						color2 |= 0;
						color2 &= 16777215;
						color2 |= (Alpha2 > 255 ? 255 : Alpha2 < 0 ? 0 : Alpha2) << 24;
						vision_ds_Image.setPixel(intermediate,x - 1,y,color2);
					}
					if(Y) {
						var color3 = vision_ds_Color._new();
						var Alpha3 = 255;
						if(Alpha3 == null) {
							Alpha3 = 255;
						}
						color3 &= -16711681;
						color3 |= 0;
						color3 &= -65281;
						color3 |= 0;
						color3 &= -256;
						color3 |= 0;
						color3 &= 16777215;
						color3 |= (Alpha3 > 255 ? 255 : Alpha3 < 0 ? 0 : Alpha3) << 24;
						vision_ds_Image.setPixel(intermediate,x,y + 1,color3);
						var color4 = vision_ds_Color._new();
						var Alpha4 = 255;
						if(Alpha4 == null) {
							Alpha4 = 255;
						}
						color4 &= -16711681;
						color4 |= 0;
						color4 &= -65281;
						color4 |= 0;
						color4 &= -256;
						color4 |= 0;
						color4 &= 16777215;
						color4 |= (Alpha4 > 255 ? 255 : Alpha4 < 0 ? 0 : Alpha4) << 24;
						vision_ds_Image.setPixel(intermediate,x,y - 1,color4);
					}
				}
			}
		}
	}
	return intermediate;
};
vision_Vision.perwittEdgeDetection = function(image,threshold) {
	if(threshold == null) {
		threshold = 100;
	}
	var edges = vision_ds_Image.get_width(image);
	var edges1 = vision_ds_Image.get_height(image);
	var color = vision_ds_Color._new();
	var Alpha = 255;
	if(Alpha == null) {
		Alpha = 255;
	}
	color &= -16711681;
	color |= 0;
	color &= -65281;
	color |= 0;
	color &= -256;
	color |= 0;
	color &= 16777215;
	color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
	var edges2 = vision_ds_Image._new(edges,edges1,color);
	var blacknwhite = vision_Vision.grayscale(vision_ds_Image.clone(image));
	var _g = 1;
	var _g1 = vision_ds_Image.get_width(blacknwhite) - 1;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_height(blacknwhite) - 1;
		while(_g2 < _g3) {
			var y = _g2++;
			var neighbors_0 = vision_ds_Image.getPixel(blacknwhite,x - 1,y - 1);
			var neighbors_1 = vision_ds_Image.getPixel(blacknwhite,x,y - 1);
			var neighbors_2 = vision_ds_Image.getPixel(blacknwhite,x + 1,y - 1);
			var neighbors_3 = vision_ds_Image.getPixel(blacknwhite,x - 1,y);
			var neighbors_4 = vision_ds_Image.getPixel(blacknwhite,x,y);
			var neighbors_5 = vision_ds_Image.getPixel(blacknwhite,x + 1,y);
			var neighbors_6 = vision_ds_Image.getPixel(blacknwhite,x - 1,y + 1);
			var neighbors_7 = vision_ds_Image.getPixel(blacknwhite,x,y + 1);
			var neighbors_8 = vision_ds_Image.getPixel(blacknwhite,x + 1,y + 1);
			var perwittCalculationIterationLTR = (neighbors_0 >> 16 & 255) * -1 + (neighbors_3 >> 16 & 255) * -1 + (neighbors_6 >> 16 & 255) * -1 + (neighbors_2 >> 16 & 255) + (neighbors_5 >> 16 & 255) + (neighbors_8 >> 16 & 255);
			if(Math.abs(perwittCalculationIterationLTR) > threshold) {
				var color = vision_ds_Color._new();
				var Alpha = 255;
				if(Alpha == null) {
					Alpha = 255;
				}
				color &= -16711681;
				color |= 16711680;
				color &= -65281;
				color |= 65280;
				color &= -256;
				color |= 255;
				color &= 16777215;
				color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
				vision_ds_Image.setPixel(edges2,x,y,color);
				continue;
			}
			var perwittCalculationIterationTTB = (neighbors_0 >> 16 & 255) * -1 + (neighbors_1 >> 16 & 255) * -1 + (neighbors_2 >> 16 & 255) * -1 + (neighbors_6 >> 16 & 255) + (neighbors_7 >> 16 & 255) + (neighbors_8 >> 16 & 255);
			if(Math.abs(perwittCalculationIterationTTB) > threshold) {
				var color1 = vision_ds_Color._new();
				var Alpha1 = 255;
				if(Alpha1 == null) {
					Alpha1 = 255;
				}
				color1 &= -16711681;
				color1 |= 16711680;
				color1 &= -65281;
				color1 |= 65280;
				color1 &= -256;
				color1 |= 255;
				color1 &= 16777215;
				color1 |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
				vision_ds_Image.setPixel(edges2,x,y,color1);
				continue;
			}
		}
	}
	return edges2;
};
vision_Vision.nearestNeighborBlur = function(image,iterations) {
	if(iterations == null) {
		iterations = 1;
	}
	var blurredImage = vision_ds_Image.clone(image);
	var imageClone = vision_ds_Image.clone(image);
	var _g = 0;
	var _g1 = iterations;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_width(blurredImage) - 1;
		while(_g2 < _g3) {
			var x = _g2++;
			var _g4 = 1;
			var _g5 = vision_ds_Image.get_height(blurredImage) - 1;
			while(_g4 < _g5) {
				var y = _g4++;
				var neighbors_0 = vision_ds_Image.getPixel(imageClone,x - 1,y - 1);
				var neighbors_1 = vision_ds_Image.getPixel(imageClone,x,y - 1);
				var neighbors_2 = vision_ds_Image.getPixel(imageClone,x + 1,y - 1);
				var neighbors_3 = vision_ds_Image.getPixel(imageClone,x - 1,y);
				var neighbors_4 = vision_ds_Image.getPixel(imageClone,x,y);
				var neighbors_5 = vision_ds_Image.getPixel(imageClone,x + 1,y);
				var neighbors_6 = vision_ds_Image.getPixel(imageClone,x - 1,y + 1);
				var neighbors_7 = vision_ds_Image.getPixel(imageClone,x,y + 1);
				var neighbors_8 = vision_ds_Image.getPixel(imageClone,x + 1,y + 1);
				var averageRed = ((neighbors_0 >> 16 & 255) + (neighbors_1 >> 16 & 255) + (neighbors_2 >> 16 & 255) + (neighbors_3 >> 16 & 255) + (neighbors_4 >> 16 & 255) + (neighbors_5 >> 16 & 255) + (neighbors_6 >> 16 & 255) + (neighbors_7 >> 16 & 255) + (neighbors_8 >> 16 & 255)) / 9;
				var averageGreen = ((neighbors_0 >> 8 & 255) + (neighbors_1 >> 8 & 255) + (neighbors_2 >> 8 & 255) + (neighbors_3 >> 8 & 255) + (neighbors_4 >> 8 & 255) + (neighbors_5 >> 8 & 255) + (neighbors_6 >> 8 & 255) + (neighbors_7 >> 8 & 255) + (neighbors_8 >> 8 & 255)) / 9;
				var averageBlue = ((neighbors_0 & 255) + (neighbors_1 & 255) + (neighbors_2 & 255) + (neighbors_3 & 255) + (neighbors_4 & 255) + (neighbors_5 & 255) + (neighbors_6 & 255) + (neighbors_7 & 255) + (neighbors_8 & 255)) / 9;
				var Red = averageRed | 0;
				var Green = averageGreen | 0;
				var Blue = averageBlue | 0;
				var color = vision_ds_Color._new();
				var Alpha = 255;
				if(Alpha == null) {
					Alpha = 255;
				}
				color &= -16711681;
				color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
				color &= -65281;
				color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
				color &= -256;
				color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
				color &= 16777215;
				color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
				vision_ds_Image.setPixel(blurredImage,x,y,color);
			}
		}
		imageClone = vision_ds_Image.clone(blurredImage);
	}
	return blurredImage;
};
vision_Vision.gaussianBlur = function(image,sigma,kernalSize) {
	if(kernalSize == null) {
		kernalSize = 5;
	}
	if(sigma == null) {
		sigma = 1;
	}
	var kernal = vision_algorithms_Gaussian.createKernalOfSize(kernalSize,sigma);
	var blurredImage = vision_ds_Image.clone(image);
	var getNeighbors = function(x,y) {
		var neighbors = [];
		var _g = 0;
		var _g1 = kernalSize + 1;
		while(_g < _g1) {
			var i = _g++;
			neighbors[i] = [];
		}
		var roundedDown = (kernalSize - 1) / 2 | 0;
		var _g = -roundedDown;
		var _g1 = roundedDown + 1;
		while(_g < _g1) {
			var X = _g++;
			var _g2 = -roundedDown;
			var _g3 = roundedDown + 1;
			while(_g2 < _g3) {
				var Y = _g2++;
				if(x + X < 0 || x + X >= vision_ds_Image.get_width(image) || y + Y < 0 || y + Y >= vision_ds_Image.get_height(image)) {
					neighbors[X + roundedDown].push(null);
					continue;
				}
				var getNeighbors = vision_ds_Image.getPixel(image,x + X,y + Y);
				neighbors[X + roundedDown].push(getNeighbors);
			}
		}
		return neighbors;
	};
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var neighbors = getNeighbors(x,y);
			var color = vision_ds_Color._new();
			var Alpha = 255;
			if(Alpha == null) {
				Alpha = 255;
			}
			color &= -16711681;
			color |= 0;
			color &= -65281;
			color |= 0;
			color &= -256;
			color |= 0;
			color &= 16777215;
			color |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
			var newColor = color;
			var _g4 = 0;
			var _g5 = kernalSize;
			while(_g4 < _g5) {
				var X = _g4++;
				var _g6 = 0;
				var _g7 = kernalSize;
				while(_g6 < _g7) {
					var Y = _g6++;
					if(neighbors[X][Y] == null) {
						continue;
					}
					var red = (neighbors[X][Y] >> 16 & 255) * kernal[X][Y];
					var green = (neighbors[X][Y] >> 8 & 255) * kernal[X][Y];
					var blue = (neighbors[X][Y] & 255) * kernal[X][Y];
					var Value = (newColor >> 16 & 255) + (red | 0);
					newColor &= -16711681;
					newColor |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
					var Value1 = (newColor >> 8 & 255) + (green | 0);
					newColor &= -65281;
					newColor |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
					var Value2 = (newColor & 255) + (blue | 0);
					newColor &= -256;
					newColor |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
				}
			}
			vision_ds_Image.setPixel(blurredImage,x,y,newColor);
		}
	}
	return blurredImage;
};
vision_Vision.cannyEdgeDetection = function(image,sigma,threshold,lowThreshold,highThreshold) {
	if(highThreshold == null) {
		highThreshold = 0.6;
	}
	if(lowThreshold == null) {
		lowThreshold = 0.4;
	}
	if(threshold == null) {
		threshold = 0.5;
	}
	if(sigma == null) {
		sigma = 1;
	}
	var blurred = vision_Vision.gaussianBlur(image,sigma);
	var grayed = vision_Vision.grayscale(blurred);
	var edges = vision_ds_Image._new(vision_ds_Image.get_width(blurred),vision_ds_Image.get_height(blurred),0);
	var getNeighbors = function(x,y) {
		var neighbors = [[],[],[]];
		var _g = -1;
		while(_g < 2) {
			var X = _g++;
			var _g1 = -1;
			while(_g1 < 2) {
				var Y = _g1++;
				if(x + X < 0 || x + X >= vision_ds_Image.get_width(grayed) || y + Y < 0 || y + Y >= vision_ds_Image.get_height(grayed)) {
					continue;
				}
				neighbors[X + 1][Y + 1] = vision_ds_Image.getPixel(grayed,x + X,y + Y);
			}
		}
		return neighbors;
	};
	var _g = 1;
	var _g1 = vision_ds_Image.get_width(blurred) - 1;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_height(blurred) - 1;
		while(_g2 < _g3) {
			var y = _g2++;
			var neighbors = getNeighbors(x,y);
			var gradient = ((neighbors[0][0] >> 16 & 255) / 255 * -1 + (neighbors[0][2] >> 16 & 255) / 255 + (neighbors[1][0] >> 16 & 255) / 255 * -2 + (neighbors[1][2] >> 16 & 255) / 255 * 2 + (neighbors[2][0] >> 16 & 255) / 255 * -1 + (neighbors[2][2] >> 16 & 255) / 255) / 9;
			if(gradient > threshold) {
				var color = vision_ds_Color._new();
				var Alpha = 1;
				if(Alpha == null) {
					Alpha = 1;
				}
				var Value = Math.round(gradient * 255);
				color &= -16711681;
				color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
				var Value1 = Math.round(gradient * 255);
				color &= -65281;
				color |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
				var Value2 = Math.round(gradient * 255);
				color &= -256;
				color |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
				var Value3 = Math.round(Alpha * 255);
				color &= 16777215;
				color |= (Value3 > 255 ? 255 : Value3 < 0 ? 0 : Value3) << 24;
				vision_ds_Image.setPixel(edges,x,y,color);
			}
			var gradient1 = ((neighbors[0][0] >> 16 & 255) / 255 * -1 + (neighbors[0][1] >> 16 & 255) / 255 * -2 + (neighbors[0][2] >> 16 & 255) / 255 * -1 + (neighbors[2][0] >> 16 & 255) / 255 + (neighbors[2][1] >> 16 & 255) / 255 * 2 + (neighbors[2][2] >> 16 & 255) / 255) / 9;
			if(gradient1 > threshold) {
				var color1 = vision_ds_Color._new();
				var Alpha1 = 1;
				if(Alpha1 == null) {
					Alpha1 = 1;
				}
				var Value4 = Math.round(gradient1 * 255);
				color1 &= -16711681;
				color1 |= (Value4 > 255 ? 255 : Value4 < 0 ? 0 : Value4) << 16;
				var Value5 = Math.round(gradient1 * 255);
				color1 &= -65281;
				color1 |= (Value5 > 255 ? 255 : Value5 < 0 ? 0 : Value5) << 8;
				var Value6 = Math.round(gradient1 * 255);
				color1 &= -256;
				color1 |= Value6 > 255 ? 255 : Value6 < 0 ? 0 : Value6;
				var Value7 = Math.round(Alpha1 * 255);
				color1 &= 16777215;
				color1 |= (Value7 > 255 ? 255 : Value7 < 0 ? 0 : Value7) << 24;
				vision_ds_Image.setPixel(edges,x,y,color1);
			}
		}
	}
	return edges;
};
vision_Vision.simpleLine2DDetection = function(image,minLineGap,minLineLength) {
	if(minLineLength == null) {
		minLineLength = 10;
	}
	if(minLineGap == null) {
		minLineGap = 2;
	}
	var lines = [];
	var edgeDetected = vision_Vision.blackAndWhite(vision_ds_Image.clone(image),1);
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var line = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,new vision_ds_Point2D(x,y),minLineGap,minLineLength);
			if(line != null) {
				lines.push(line);
			}
		}
	}
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var line = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,new vision_ds_Point2D(x,y),minLineGap,minLineLength,true);
			if(line != null) {
				lines.push(line);
			}
		}
	}
	var actualLines = [];
	var _g = 0;
	while(_g < lines.length) {
		var l = lines[_g];
		++_g;
		var coverage = vision_algorithms_SimpleLineDetector.lineCoveragePercentage(edgeDetected,l);
		if(coverage > 90) {
			actualLines.push(l);
		}
	}
	return actualLines;
};
var vision_algorithms_Gaussian = function() { };
vision_algorithms_Gaussian.__name__ = true;
vision_algorithms_Gaussian.create1x1Kernal = function(sigma) {
	return [[1]];
};
vision_algorithms_Gaussian.create3x3Kernal = function(sigma) {
	var r;
	var s = 2.0 * sigma * sigma;
	var kernal = [[],[],[],[]];
	var sum = 0.0;
	r = Math.sqrt(2);
	kernal[0][0] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[0][0];
	r = Math.sqrt(1);
	kernal[0][1] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[0][1];
	r = Math.sqrt(2);
	kernal[0][2] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[0][2];
	r = Math.sqrt(1);
	kernal[1][0] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[1][0];
	r = Math.sqrt(0);
	kernal[1][1] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[1][1];
	r = Math.sqrt(1);
	kernal[1][2] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[1][2];
	r = Math.sqrt(2);
	kernal[2][0] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[2][0];
	r = Math.sqrt(1);
	kernal[2][1] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[2][1];
	r = Math.sqrt(2);
	kernal[2][2] = Math.exp(-(r * r) / s) / (Math.PI * s);
	sum += kernal[2][2];
	kernal[0][0] /= sum;
	kernal[0][1] /= sum;
	kernal[0][2] /= sum;
	kernal[1][0] /= sum;
	kernal[1][1] /= sum;
	kernal[1][2] /= sum;
	kernal[2][0] /= sum;
	kernal[2][1] /= sum;
	kernal[2][2] /= sum;
	return kernal;
};
vision_algorithms_Gaussian.create5x5Kernal = function(sigma) {
	var r;
	var s = 2.0 * sigma * sigma;
	var kernal = [[],[],[],[],[],[]];
	var sum = 0.0;
	var _g = -2;
	while(_g < 3) {
		var x = _g++;
		var _g1 = -2;
		while(_g1 < 3) {
			var y = _g1++;
			r = Math.sqrt(x * x + y * y);
			kernal[x + 2][y + 2] = Math.exp(-(r * r) / s) / (Math.PI * s);
			sum += kernal[x + 2][y + 2];
		}
	}
	kernal[0][0] /= sum;
	kernal[0][1] /= sum;
	kernal[0][2] /= sum;
	kernal[0][3] /= sum;
	kernal[0][4] /= sum;
	kernal[1][0] /= sum;
	kernal[1][1] /= sum;
	kernal[1][2] /= sum;
	kernal[1][3] /= sum;
	kernal[1][4] /= sum;
	kernal[2][0] /= sum;
	kernal[2][1] /= sum;
	kernal[2][2] /= sum;
	kernal[2][3] /= sum;
	kernal[2][4] /= sum;
	kernal[3][0] /= sum;
	kernal[3][1] /= sum;
	kernal[3][2] /= sum;
	kernal[3][3] /= sum;
	kernal[3][4] /= sum;
	kernal[4][0] /= sum;
	kernal[4][1] /= sum;
	kernal[4][2] /= sum;
	kernal[4][3] /= sum;
	kernal[4][4] /= sum;
	return kernal;
};
vision_algorithms_Gaussian.create7x7Kernal = function(sigma) {
	var r;
	var s = 2.0 * sigma * sigma;
	var kernal = [[],[],[],[],[],[],[],[]];
	var sum = 0.0;
	var _g = -3;
	while(_g < 4) {
		var x = _g++;
		var _g1 = -3;
		while(_g1 < 4) {
			var y = _g1++;
			r = Math.sqrt(x * x + y * y);
			kernal[x + 3][y + 3] = Math.exp(-(r * r) / s) / (Math.PI * s);
			sum += kernal[x + 3][y + 3];
		}
	}
	kernal[0][0] /= sum;
	kernal[0][1] /= sum;
	kernal[0][2] /= sum;
	kernal[0][3] /= sum;
	kernal[0][4] /= sum;
	kernal[0][5] /= sum;
	kernal[0][6] /= sum;
	kernal[1][0] /= sum;
	kernal[1][1] /= sum;
	kernal[1][2] /= sum;
	kernal[1][3] /= sum;
	kernal[1][4] /= sum;
	kernal[1][5] /= sum;
	kernal[1][6] /= sum;
	kernal[2][0] /= sum;
	kernal[2][1] /= sum;
	kernal[2][2] /= sum;
	kernal[2][3] /= sum;
	kernal[2][4] /= sum;
	kernal[2][5] /= sum;
	kernal[2][6] /= sum;
	kernal[3][0] /= sum;
	kernal[3][1] /= sum;
	kernal[3][2] /= sum;
	kernal[3][3] /= sum;
	kernal[3][4] /= sum;
	kernal[3][5] /= sum;
	kernal[3][6] /= sum;
	kernal[4][0] /= sum;
	kernal[4][1] /= sum;
	kernal[4][2] /= sum;
	kernal[4][3] /= sum;
	kernal[4][4] /= sum;
	kernal[4][5] /= sum;
	kernal[4][6] /= sum;
	kernal[5][0] /= sum;
	kernal[5][1] /= sum;
	kernal[5][2] /= sum;
	kernal[5][3] /= sum;
	kernal[5][4] /= sum;
	kernal[5][5] /= sum;
	kernal[5][6] /= sum;
	kernal[6][0] /= sum;
	kernal[6][1] /= sum;
	kernal[6][2] /= sum;
	kernal[6][3] /= sum;
	kernal[6][4] /= sum;
	kernal[6][5] /= sum;
	kernal[6][6] /= sum;
	return kernal;
};
vision_algorithms_Gaussian.create9x9Kernal = function(sigma) {
	var r;
	var s = 2.0 * sigma * sigma;
	var kernal = [[],[],[],[],[],[],[],[],[],[]];
	var sum = 0.0;
	var _g = -4;
	while(_g < 5) {
		var x = _g++;
		var _g1 = -4;
		while(_g1 < 5) {
			var y = _g1++;
			r = Math.sqrt(x * x + y * y);
			kernal[x + 4][y + 4] = Math.exp(-(r * r) / s) / (Math.PI * s);
			sum += kernal[x + 4][y + 4];
		}
	}
	kernal[0][0] /= sum;
	kernal[0][1] /= sum;
	kernal[0][2] /= sum;
	kernal[0][3] /= sum;
	kernal[0][4] /= sum;
	kernal[0][5] /= sum;
	kernal[0][6] /= sum;
	kernal[0][7] /= sum;
	kernal[0][8] /= sum;
	kernal[1][0] /= sum;
	kernal[1][1] /= sum;
	kernal[1][2] /= sum;
	kernal[1][3] /= sum;
	kernal[1][4] /= sum;
	kernal[1][5] /= sum;
	kernal[1][6] /= sum;
	kernal[1][7] /= sum;
	kernal[1][8] /= sum;
	kernal[2][0] /= sum;
	kernal[2][1] /= sum;
	kernal[2][2] /= sum;
	kernal[2][3] /= sum;
	kernal[2][4] /= sum;
	kernal[2][5] /= sum;
	kernal[2][6] /= sum;
	kernal[2][7] /= sum;
	kernal[2][8] /= sum;
	kernal[3][0] /= sum;
	kernal[3][1] /= sum;
	kernal[3][2] /= sum;
	kernal[3][3] /= sum;
	kernal[3][4] /= sum;
	kernal[3][5] /= sum;
	kernal[3][6] /= sum;
	kernal[3][7] /= sum;
	kernal[3][8] /= sum;
	kernal[4][0] /= sum;
	kernal[4][1] /= sum;
	kernal[4][2] /= sum;
	kernal[4][3] /= sum;
	kernal[4][4] /= sum;
	kernal[4][5] /= sum;
	kernal[4][6] /= sum;
	kernal[4][7] /= sum;
	kernal[4][8] /= sum;
	kernal[5][0] /= sum;
	kernal[5][1] /= sum;
	kernal[5][2] /= sum;
	kernal[5][3] /= sum;
	kernal[5][4] /= sum;
	kernal[5][5] /= sum;
	kernal[5][6] /= sum;
	kernal[5][7] /= sum;
	kernal[5][8] /= sum;
	kernal[6][0] /= sum;
	kernal[6][1] /= sum;
	kernal[6][2] /= sum;
	kernal[6][3] /= sum;
	kernal[6][4] /= sum;
	kernal[6][5] /= sum;
	kernal[6][6] /= sum;
	kernal[6][7] /= sum;
	kernal[6][8] /= sum;
	kernal[7][0] /= sum;
	kernal[7][1] /= sum;
	kernal[7][2] /= sum;
	kernal[7][3] /= sum;
	kernal[7][4] /= sum;
	kernal[7][5] /= sum;
	kernal[7][6] /= sum;
	kernal[7][7] /= sum;
	kernal[7][8] /= sum;
	kernal[8][0] /= sum;
	kernal[8][1] /= sum;
	kernal[8][2] /= sum;
	kernal[8][3] /= sum;
	kernal[8][4] /= sum;
	kernal[8][5] /= sum;
	kernal[8][6] /= sum;
	kernal[8][7] /= sum;
	kernal[8][8] /= sum;
	return kernal;
};
vision_algorithms_Gaussian.createKernalOfSize = function(size,sigma) {
	if(size % 2 == 0 || size <= 0) {
		throw haxe_Exception.thrown(new vision_exceptions_InvalidGaussianKernalSize(size));
	}
	var r;
	var s = 2.0 * sigma * sigma;
	var sum = 0.;
	var kernal = [];
	var _g = 0;
	var _g1 = size;
	while(_g < _g1) {
		var i = _g++;
		kernal[i] = [];
	}
	var avg = (size - 1) / 2 | 0;
	var _g = -avg;
	var _g1 = avg + 1;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = -avg;
		var _g3 = avg + 1;
		while(_g2 < _g3) {
			var y = _g2++;
			r = Math.sqrt(x * x + y * y);
			kernal[x + avg][y + avg] = Math.exp(-(r * r) / s) / (Math.PI * s);
			sum += kernal[x + avg][y + avg];
		}
	}
	var _g = 0;
	var _g1 = size;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = size;
		while(_g2 < _g3) {
			var j = _g2++;
			kernal[i][j] /= sum;
		}
	}
	return kernal;
};
var vision_algorithms_Hough = function() { };
vision_algorithms_Hough.__name__ = true;
vision_algorithms_Hough.toHoughSpace = function(image) {
	var accum = new haxe_ds_ObjectMap();
	var rhoMax = Math.sqrt(vision_ds_Image.get_width(image) * vision_ds_Image.get_width(image) + vision_ds_Image.get_height(image) * vision_ds_Image.get_height(image));
	var houghSpace = vision_ds_Image._new(361,rhoMax | 0,16777215);
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var j = _g2++;
			if(Math.abs(vision_ds_Image.getPixel(image,i,j) >> 16 & 255) == 255) {
				var rho;
				var theta = 0.;
				var thetaIndex = 0;
				var x = i - (vision_ds_Image.get_width(image) / 2 | 0);
				var y = j - (vision_ds_Image.get_height(image) / 2 | 0);
				while(thetaIndex < 360) {
					rho = rhoMax + x * Math.cos(theta) + y * Math.sin(theta);
					rho /= 2;
					if(accum.h[[theta,rho].__id__] == null) {
						accum.set([theta,rho],0);
					} else {
						accum.set([theta,rho],accum.h[[theta,rho].__id__] + 1);
					}
					vision_ds_Image.setPixel(houghSpace,thetaIndex,rho | 0,vision_ds_Color.darken(vision_ds_Image.getPixel(houghSpace,thetaIndex,rho | 0),0.02));
					theta += Math.PI / 360;
					++thetaIndex;
				}
			}
		}
	}
	return new vision_ds_hough_HoughSpace(accum,houghSpace);
};
var vision_algorithms_SimpleLineDetector = function() { };
vision_algorithms_SimpleLineDetector.__name__ = true;
vision_algorithms_SimpleLineDetector.findLineFromPoint = function(image,point,minLineGap,minLineLength,preferTTB) {
	if(preferTTB == null) {
		preferTTB = false;
	}
	var startX = point.x;
	var startY = point.y;
	var yArr = preferTTB ? [0,1,2,3] : [0,-1,1,2,-2];
	var xArr = preferTTB ? [0,-1,1,2,-2] : [1,2,3,0];
	if(vision_ds_Image.image_array_read(image,point.x) == null || vision_ds_Image.image_array_read(image,point.x)[point.y] == null || vision_ds_Image.image_array_read(image,point.x)[point.y] == 0) {
		return null;
	}
	var prev = null;
	var prev2 = null;
	var expand = null;
	expand = function() {
		var _g = 0;
		while(_g < xArr.length) {
			var X = xArr[_g];
			++_g;
			var _g1 = 0;
			while(_g1 < yArr.length) {
				var Y = yArr[_g1];
				++_g1;
				if(X == 0 && Y == 0 || vision_ds_Image.image_array_read(image,point.x + X) == null || vision_ds_Image.image_array_read(image,point.x + X)[point.y + Y] == null) {
					continue;
				}
				if((vision_ds_Image.getPixel(image,point.x + X,point.y + Y) & 16777215) == 16777215) {
					point.x += X;
					point.y += Y;
					if(prev == null) {
						prev = new vision_ds_Point2D(point.x,point.y);
					} else {
						prev2 = new vision_ds_Point2D(prev.x,prev.y);
						prev = new vision_ds_Point2D(point.x,point.y);
					}
					if((preferTTB ? Y : X) == 0) {
						if(point.x == prev.x && point.y == prev.y || point.x == prev2.x && point.y == prev2.y) {
							return;
						}
						haxe_Log.trace(point,{ fileName : "src/vision/algorithms/SimpleLineDetector.hx", lineNumber : 41, className : "vision.algorithms.SimpleLineDetector", methodName : "findLineFromPoint", customParams : [prev,prev2]});
					}
					expand();
				}
			}
		}
	};
	expand();
	var line = new vision_ds_LineSegment2D(new vision_ds_Point2D(startX,startY),point);
	if(line.get_length() > minLineLength) {
		return line;
	}
	return null;
};
vision_algorithms_SimpleLineDetector.getDistanceFromPointToLine = function(line,pointX,pointY) {
	var a = line.end.y - line.start.y;
	var b = line.start.x - line.end.x;
	var c = a * line.start.x + b * line.start.y;
	var d = a * pointX + b * pointY - c;
	return Math.abs(d / Math.sqrt(a * a + b * b));
};
vision_algorithms_SimpleLineDetector.lineCoveragePercentage = function(image,line) {
	var coveredPixels = 0;
	var totalPixels = 0;
	var p1 = line.start;
	var p2 = line.end;
	var x1 = p1.x;
	var y1 = p1.y;
	var x2 = p2.x;
	var y2 = p2.y;
	var dx = Math.abs(x2 - x1);
	var dy = Math.abs(y2 - y1);
	var sx = x1 < x2 ? 1 : -1;
	var sy = y1 < y2 ? 1 : -1;
	var err = dx - dy;
	while(true) {
		if(vision_ds_Image.hasPixel(image,x1,y1)) {
			if((vision_ds_Image.getPixel(image,x1,y1) & 16777215) == 16777215) {
				++coveredPixels;
			}
		}
		++totalPixels;
		if(x1 == x2 && y1 == y2) {
			break;
		}
		var e2 = 2 * err;
		if(e2 > -dy) {
			err -= dy;
			x1 += sx;
		}
		if(e2 < dx) {
			err += dx;
			y1 += sy;
		}
	}
	return coveredPixels / totalPixels * 100;
};
var vision_ds_Color = {};
vision_ds_Color.fromInt = function(value) {
	return vision_ds_Color._new(value);
};
vision_ds_Color.fromRGBA = function(Red,Green,Blue,Alpha) {
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
	color &= -65281;
	color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
	color &= -256;
	color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	return color;
};
vision_ds_Color.fromRGBAFloat = function(Red,Green,Blue,Alpha) {
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 1;
	}
	var Value = Math.round(Red * 255);
	color &= -16711681;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
	var Value = Math.round(Green * 255);
	color &= -65281;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
	var Value = Math.round(Blue * 255);
	color &= -256;
	color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
	var Value = Math.round(Alpha1 * 255);
	color &= 16777215;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	return color;
};
vision_ds_Color.fromCMYK = function(Cyan,Magenta,Yellow,Black,Alpha) {
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 1;
	}
	var Value = (1 - Cyan) * (1 - Black);
	var Value1 = Math.round(Value * 255);
	color &= -16711681;
	color |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
	var Value = (1 - Magenta) * (1 - Black);
	var Value1 = Math.round(Value * 255);
	color &= -65281;
	color |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
	var Value = (1 - Yellow) * (1 - Black);
	var Value1 = Math.round(Value * 255);
	color &= -256;
	color |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
	var Value = Math.round(Alpha1 * 255);
	color &= 16777215;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	return color;
};
vision_ds_Color.fromHSB = function(Hue,Saturation,Brightness,Alpha) {
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var chroma = Brightness * Saturation;
	var match = Brightness - chroma;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return color;
};
vision_ds_Color.fromHSL = function(Hue,Saturation,Lightness,Alpha) {
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var chroma = (1 - Math.abs(2 * Lightness - 1)) * Saturation;
	var match = Lightness - chroma / 2;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		color &= -16711681;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		color &= -65281;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		color &= -256;
		color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		color &= 16777215;
		color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return color;
};
vision_ds_Color.fromString = function(str) {
	var result = null;
	str = StringTools.trim(str);
	if(vision_ds_Color.COLOR_REGEX.match(str)) {
		var hexColor = "0x" + vision_ds_Color.COLOR_REGEX.matched(2);
		result = vision_ds_Color._new(Std.parseInt(hexColor));
		if(hexColor.length == 8) {
			var Value = Math.round(255);
			result &= 16777215;
			result |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		}
	}
	return result;
};
vision_ds_Color.getHSBColorWheel = function(Alpha) {
	if(Alpha == null) {
		Alpha = 255;
	}
	var _g = [];
	var _g1 = 0;
	while(_g1 < 360) {
		var c = _g1++;
		_g.push(vision_ds_Color.fromHSB(c,1.0,1.0,Alpha));
	}
	return _g;
};
vision_ds_Color.interpolate = function(Color1,Color2,Factor) {
	if(Factor == null) {
		Factor = 0.5;
	}
	var r = ((Color2 >> 16 & 255) - (Color1 >> 16 & 255)) * Factor + (Color1 >> 16 & 255) | 0;
	var g = ((Color2 >> 8 & 255) - (Color1 >> 8 & 255)) * Factor + (Color1 >> 8 & 255) | 0;
	var b = ((Color2 & 255) - (Color1 & 255)) * Factor + (Color1 & 255) | 0;
	var a = ((Color2 >> 24 & 255) - (Color1 >> 24 & 255)) * Factor + (Color1 >> 24 & 255) | 0;
	var Alpha = a;
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (r > 255 ? 255 : r < 0 ? 0 : r) << 16;
	color &= -65281;
	color |= (g > 255 ? 255 : g < 0 ? 0 : g) << 8;
	color &= -256;
	color |= b > 255 ? 255 : b < 0 ? 0 : b;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	return color;
};
vision_ds_Color.gradient = function(Color1,Color2,Steps,Ease) {
	var output = [];
	if(Ease == null) {
		Ease = function(t) {
			return t;
		};
	}
	var _g = 0;
	var _g1 = Steps;
	while(_g < _g1) {
		var step = _g++;
		var Factor = Ease(step / (Steps - 1));
		if(Factor == null) {
			Factor = 0.5;
		}
		var r = ((Color2 >> 16 & 255) - (Color1 >> 16 & 255)) * Factor + (Color1 >> 16 & 255) | 0;
		var g = ((Color2 >> 8 & 255) - (Color1 >> 8 & 255)) * Factor + (Color1 >> 8 & 255) | 0;
		var b = ((Color2 & 255) - (Color1 & 255)) * Factor + (Color1 & 255) | 0;
		var a = ((Color2 >> 24 & 255) - (Color1 >> 24 & 255)) * Factor + (Color1 >> 24 & 255) | 0;
		var Alpha = a;
		if(Alpha == null) {
			Alpha = 255;
		}
		var color = vision_ds_Color._new();
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 255;
		}
		color &= -16711681;
		color |= (r > 255 ? 255 : r < 0 ? 0 : r) << 16;
		color &= -65281;
		color |= (g > 255 ? 255 : g < 0 ? 0 : g) << 8;
		color &= -256;
		color |= b > 255 ? 255 : b < 0 ? 0 : b;
		color &= 16777215;
		color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
		output[step] = color;
	}
	return output;
};
vision_ds_Color.multiply = function(lhs,rhs) {
	var Red = (lhs >> 16 & 255) / 255 * ((rhs >> 16 & 255) / 255);
	var Green = (lhs >> 8 & 255) / 255 * ((rhs >> 8 & 255) / 255);
	var Blue = (lhs & 255) / 255 * ((rhs & 255) / 255);
	var Alpha = (lhs >> 24 & 255) / 255 * ((rhs >> 24 & 255) / 255);
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 1;
	}
	var Value = Math.round(Red * 255);
	color &= -16711681;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
	var Value = Math.round(Green * 255);
	color &= -65281;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
	var Value = Math.round(Blue * 255);
	color &= -256;
	color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
	var Value = Math.round(Alpha1 * 255);
	color &= 16777215;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	return color;
};
vision_ds_Color.add = function(lhs,rhs) {
	var Red = (lhs >> 16 & 255) + (rhs >> 16 & 255);
	var Green = (lhs >> 8 & 255) + (rhs >> 8 & 255);
	var Blue = (lhs & 255) + (rhs & 255);
	var Alpha = (lhs >> 24 & 255) + (rhs >> 24 & 255);
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
	color &= -65281;
	color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
	color &= -256;
	color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	return color;
};
vision_ds_Color.subtract = function(lhs,rhs) {
	var Red = (lhs >> 16 & 255) - (rhs >> 16 & 255);
	var Green = (lhs >> 8 & 255) - (rhs >> 8 & 255);
	var Blue = (lhs & 255) - (rhs & 255);
	var Alpha = (lhs >> 24 & 255) - (rhs >> 24 & 255);
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
	color &= -65281;
	color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
	color &= -256;
	color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	return color;
};
vision_ds_Color.divide = function(lhs,rhs) {
	var Red = (lhs >> 16 & 255) / (rhs >> 16 & 255) | 0;
	var Green = (lhs >> 8 & 255) / (rhs >> 8 & 255) | 0;
	var Blue = (lhs & 255) / (rhs & 255) | 0;
	var Alpha = (lhs >> 24 & 255) / (rhs >> 24 & 255) | 0;
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
	color &= -65281;
	color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
	color &= -256;
	color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	return color;
};
vision_ds_Color.getComplementHarmony = function(this1) {
	return vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt((vision_ds_Color.get_hue(this1) | 0) + 180,0,350),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
};
vision_ds_Color.getAnalogousHarmony = function(this1,Threshold) {
	if(Threshold == null) {
		Threshold = 30;
	}
	var warmer = vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt((vision_ds_Color.get_hue(this1) | 0) - Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	var colder = vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt((vision_ds_Color.get_hue(this1) | 0) + Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	return { original : this1, warmer : warmer, colder : colder};
};
vision_ds_Color.getSplitComplementHarmony = function(this1,Threshold) {
	if(Threshold == null) {
		Threshold = 30;
	}
	var oppositeHue = vision_tools_MathUtils.wrapInt((vision_ds_Color.get_hue(this1) | 0) + 180,0,350);
	var warmer = vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt(oppositeHue - Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	var colder = vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt(oppositeHue + Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	return { original : this1, warmer : warmer, colder : colder};
};
vision_ds_Color.getTriadicHarmony = function(this1) {
	var triadic1 = vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt((vision_ds_Color.get_hue(this1) | 0) + 120,0,359),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	var triadic2 = vision_ds_Color.fromHSB(vision_tools_MathUtils.wrapInt((vision_ds_Color.get_hue(triadic1) | 0) + 120,0,359),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	return { color1 : this1, color2 : triadic1, color3 : triadic2};
};
vision_ds_Color.to24Bit = function(this1) {
	return this1 & 16777215;
};
vision_ds_Color.toHexString = function(this1,Alpha,Prefix) {
	if(Prefix == null) {
		Prefix = true;
	}
	if(Alpha == null) {
		Alpha = true;
	}
	var tmp = Alpha ? StringTools.hex(this1 >> 24 & 255,2) : "";
	return (Prefix ? "0x" : "") + tmp + StringTools.hex(this1 >> 16 & 255,2) + StringTools.hex(this1 >> 8 & 255,2) + StringTools.hex(this1 & 255,2);
};
vision_ds_Color.toWebString = function(this1) {
	var Alpha = false;
	var Prefix = false;
	if(Prefix == null) {
		Prefix = true;
	}
	if(Alpha == null) {
		Alpha = true;
	}
	var tmp = Alpha ? StringTools.hex(this1 >> 24 & 255,2) : "";
	return "#" + ((Prefix ? "0x" : "") + tmp + StringTools.hex(this1 >> 16 & 255,2) + StringTools.hex(this1 >> 8 & 255,2) + StringTools.hex(this1 & 255,2));
};
vision_ds_Color.darken = function(this1,Factor) {
	if(Factor == null) {
		Factor = 0.2;
	}
	Factor = vision_tools_MathUtils.boundFloat(Factor,0,1);
	var output = this1;
	var Value = (Math.max((output >> 16 & 255) / 255,Math.max((output >> 8 & 255) / 255,(output & 255) / 255)) + Math.min((output >> 16 & 255) / 255,Math.min((output >> 8 & 255) / 255,(output & 255) / 255))) / 2 * (1 - Factor);
	var Hue = vision_ds_Color.get_hue(output);
	var Alpha = (output >> 24 & 255) / 255;
	var chroma = (1 - Math.abs(2 * Value - 1)) * ((Math.max((output >> 16 & 255) / 255,Math.max((output >> 8 & 255) / 255,(output & 255) / 255)) - Math.min((output >> 16 & 255) / 255,Math.min((output >> 8 & 255) / 255,(output & 255) / 255))) / Math.max((output >> 16 & 255) / 255,Math.max((output >> 8 & 255) / 255,(output & 255) / 255)));
	var match = Value - chroma / 2;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return output;
};
vision_ds_Color.lighten = function(this1,Factor) {
	if(Factor == null) {
		Factor = 0.2;
	}
	Factor = vision_tools_MathUtils.boundFloat(Factor,0,1);
	var output = this1;
	var Value = (Math.max((output >> 16 & 255) / 255,Math.max((output >> 8 & 255) / 255,(output & 255) / 255)) + Math.min((output >> 16 & 255) / 255,Math.min((output >> 8 & 255) / 255,(output & 255) / 255))) / 2 + (1 - (Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) + Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / 2) * Factor;
	var Hue = vision_ds_Color.get_hue(output);
	var Alpha = (output >> 24 & 255) / 255;
	var chroma = (1 - Math.abs(2 * Value - 1)) * ((Math.max((output >> 16 & 255) / 255,Math.max((output >> 8 & 255) / 255,(output & 255) / 255)) - Math.min((output >> 16 & 255) / 255,Math.min((output >> 8 & 255) / 255,(output & 255) / 255))) / Math.max((output >> 16 & 255) / 255,Math.max((output >> 8 & 255) / 255,(output & 255) / 255)));
	var match = Value - chroma / 2;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		output &= -16711681;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		output &= -65281;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		output &= -256;
		output |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		output &= 16777215;
		output |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return output;
};
vision_ds_Color.invert = function(this1) {
	var oldAlpha = this1 >> 24 & 255;
	var lhs = 16777215;
	var Red = (lhs >> 16 & 255) - (this1 >> 16 & 255);
	var Green = (lhs >> 8 & 255) - (this1 >> 8 & 255);
	var Blue = (lhs & 255) - (this1 & 255);
	var Alpha = (lhs >> 24 & 255) - (this1 >> 24 & 255);
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
	color &= -65281;
	color |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
	color &= -256;
	color |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	var output = color;
	output &= 16777215;
	output |= (oldAlpha > 255 ? 255 : oldAlpha < 0 ? 0 : oldAlpha) << 24;
	return output;
};
vision_ds_Color.setRGBA = function(this1,Red,Green,Blue,Alpha) {
	if(Alpha == null) {
		Alpha = 255;
	}
	this1 &= -16711681;
	this1 |= (Red > 255 ? 255 : Red < 0 ? 0 : Red) << 16;
	this1 &= -65281;
	this1 |= (Green > 255 ? 255 : Green < 0 ? 0 : Green) << 8;
	this1 &= -256;
	this1 |= Blue > 255 ? 255 : Blue < 0 ? 0 : Blue;
	this1 &= 16777215;
	this1 |= (Alpha > 255 ? 255 : Alpha < 0 ? 0 : Alpha) << 24;
	return this1;
};
vision_ds_Color.setRGBAFloat = function(this1,Red,Green,Blue,Alpha) {
	if(Alpha == null) {
		Alpha = 1;
	}
	var Value = Math.round(Red * 255);
	this1 &= -16711681;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
	var Value = Math.round(Green * 255);
	this1 &= -65281;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
	var Value = Math.round(Blue * 255);
	this1 &= -256;
	this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
	var Value = Math.round(Alpha * 255);
	this1 &= 16777215;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	return this1;
};
vision_ds_Color.setCMYK = function(this1,Cyan,Magenta,Yellow,Black,Alpha) {
	if(Alpha == null) {
		Alpha = 1;
	}
	var Value = (1 - Cyan) * (1 - Black);
	var Value1 = Math.round(Value * 255);
	this1 &= -16711681;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
	var Value = (1 - Magenta) * (1 - Black);
	var Value1 = Math.round(Value * 255);
	this1 &= -65281;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
	var Value = (1 - Yellow) * (1 - Black);
	var Value1 = Math.round(Value * 255);
	this1 &= -256;
	this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
	var Value = Math.round(Alpha * 255);
	this1 &= 16777215;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	return this1;
};
vision_ds_Color.setHSB = function(this1,Hue,Saturation,Brightness,Alpha) {
	var chroma = Brightness * Saturation;
	var match = Brightness - chroma;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return this1;
};
vision_ds_Color.setHSL = function(this1,Hue,Saturation,Lightness,Alpha) {
	var chroma = (1 - Math.abs(2 * Lightness - 1)) * Saturation;
	var match = Lightness - chroma / 2;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return this1;
};
vision_ds_Color.setHSChromaMatch = function(this1,Hue,Saturation,Chroma,Match,Alpha) {
	Hue %= 360;
	var hueD = Hue / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + Match;
	Chroma += Match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Match * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Match * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Match * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Match * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Match * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
		var Value = Math.round(Match * 255);
		this1 &= -65281;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
		var Value = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
		var Value = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
		break;
	}
	return this1;
};
vision_ds_Color._new = function(Value) {
	if(Value == null) {
		Value = 0;
	}
	var this1 = Value;
	return this1;
};
vision_ds_Color.getThis = function(this1) {
	return this1;
};
vision_ds_Color.validate = function(this1) {
};
vision_ds_Color.get_red = function(this1) {
	return this1 >> 16 & 255;
};
vision_ds_Color.get_green = function(this1) {
	return this1 >> 8 & 255;
};
vision_ds_Color.get_blue = function(this1) {
	return this1 & 255;
};
vision_ds_Color.get_alpha = function(this1) {
	return this1 >> 24 & 255;
};
vision_ds_Color.get_redFloat = function(this1) {
	return (this1 >> 16 & 255) / 255;
};
vision_ds_Color.get_greenFloat = function(this1) {
	return (this1 >> 8 & 255) / 255;
};
vision_ds_Color.get_blueFloat = function(this1) {
	return (this1 & 255) / 255;
};
vision_ds_Color.get_alphaFloat = function(this1) {
	return (this1 >> 24 & 255) / 255;
};
vision_ds_Color.set_red = function(this1,Value) {
	this1 &= -16711681;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
	return Value;
};
vision_ds_Color.set_green = function(this1,Value) {
	this1 &= -65281;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
	return Value;
};
vision_ds_Color.set_blue = function(this1,Value) {
	this1 &= -256;
	this1 |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
	return Value;
};
vision_ds_Color.set_alpha = function(this1,Value) {
	this1 &= 16777215;
	this1 |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	return Value;
};
vision_ds_Color.set_redFloat = function(this1,Value) {
	var Value1 = Math.round(Value * 255);
	this1 &= -16711681;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
	return Value;
};
vision_ds_Color.set_greenFloat = function(this1,Value) {
	var Value1 = Math.round(Value * 255);
	this1 &= -65281;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
	return Value;
};
vision_ds_Color.set_blueFloat = function(this1,Value) {
	var Value1 = Math.round(Value * 255);
	this1 &= -256;
	this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
	return Value;
};
vision_ds_Color.set_alphaFloat = function(this1,Value) {
	var Value1 = Math.round(Value * 255);
	this1 &= 16777215;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
	return Value;
};
vision_ds_Color.get_cyan = function(this1) {
	return (1 - (this1 >> 16 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.get_magenta = function(this1) {
	return (1 - (this1 >> 8 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.get_yellow = function(this1) {
	return (1 - (this1 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.get_black = function(this1) {
	return 1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.set_cyan = function(this1,Value) {
	var Magenta = (1 - (this1 >> 8 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Yellow = (1 - (this1 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Black = 1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Alpha = (this1 >> 24 & 255) / 255;
	if(Alpha == null) {
		Alpha = 1;
	}
	var Value1 = (1 - Value) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -16711681;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 16;
	var Value1 = (1 - Magenta) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -65281;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 8;
	var Value1 = (1 - Yellow) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -256;
	this1 |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
	var Value1 = Math.round(Alpha * 255);
	this1 &= 16777215;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
	return Value;
};
vision_ds_Color.set_magenta = function(this1,Value) {
	var Yellow = (1 - (this1 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Black = 1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Alpha = (this1 >> 24 & 255) / 255;
	if(Alpha == null) {
		Alpha = 1;
	}
	var Value1 = (1 - (1 - (this1 >> 16 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -16711681;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 16;
	var Value1 = (1 - Value) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -65281;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 8;
	var Value1 = (1 - Yellow) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -256;
	this1 |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
	var Value1 = Math.round(Alpha * 255);
	this1 &= 16777215;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
	return Value;
};
vision_ds_Color.set_yellow = function(this1,Value) {
	var Magenta = (1 - (this1 >> 8 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Black = 1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Alpha = (this1 >> 24 & 255) / 255;
	if(Alpha == null) {
		Alpha = 1;
	}
	var Value1 = (1 - (1 - (this1 >> 16 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -16711681;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 16;
	var Value1 = (1 - Magenta) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -65281;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 8;
	var Value1 = (1 - Value) * (1 - Black);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -256;
	this1 |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
	var Value1 = Math.round(Alpha * 255);
	this1 &= 16777215;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
	return Value;
};
vision_ds_Color.set_black = function(this1,Value) {
	var Magenta = (1 - (this1 >> 8 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Yellow = (1 - (this1 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Alpha = (this1 >> 24 & 255) / 255;
	if(Alpha == null) {
		Alpha = 1;
	}
	var Value1 = (1 - (1 - (this1 >> 16 & 255) / 255 - (1 - Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) * (1 - Value);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -16711681;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 16;
	var Value1 = (1 - Magenta) * (1 - Value);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -65281;
	this1 |= (Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2) << 8;
	var Value1 = (1 - Yellow) * (1 - Value);
	var Value2 = Math.round(Value1 * 255);
	this1 &= -256;
	this1 |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
	var Value1 = Math.round(Alpha * 255);
	this1 &= 16777215;
	this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
	return Value;
};
vision_ds_Color.get_hue = function(this1) {
	var hueRad = Math.atan2(Math.sqrt(3) * ((this1 >> 8 & 255) / 255 - (this1 & 255) / 255),2 * ((this1 >> 16 & 255) / 255) - (this1 >> 8 & 255) / 255 - (this1 & 255) / 255);
	var hue = 0;
	if(hueRad != 0) {
		hue = 180 / Math.PI * Math.atan2(Math.sqrt(3) * ((this1 >> 8 & 255) / 255 - (this1 & 255) / 255),2 * ((this1 >> 16 & 255) / 255) - (this1 >> 8 & 255) / 255 - (this1 & 255) / 255);
	}
	if(hue < 0) {
		return hue + 360;
	} else {
		return hue;
	}
};
vision_ds_Color.get_brightness = function(this1) {
	return Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.get_saturation = function(this1) {
	return (Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.get_lightness = function(this1) {
	return (Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) + Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / 2;
};
vision_ds_Color.set_hue = function(this1,Value) {
	var Brightness = Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Alpha = (this1 >> 24 & 255) / 255;
	var chroma = Brightness * ((Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)));
	var match = Brightness - chroma;
	var Hue = Value;
	var Chroma = chroma;
	Hue %= 360;
	var hueD = Hue / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	}
	return Value;
};
vision_ds_Color.set_saturation = function(this1,Value) {
	var Hue = vision_ds_Color.get_hue(this1);
	var Brightness = Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
	var Alpha = (this1 >> 24 & 255) / 255;
	var chroma = Brightness * Value;
	var match = Brightness - chroma;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	}
	return Value;
};
vision_ds_Color.set_brightness = function(this1,Value) {
	var Hue = vision_ds_Color.get_hue(this1);
	var Alpha = (this1 >> 24 & 255) / 255;
	var chroma = Value * ((Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)));
	var match = Value - chroma;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	}
	return Value;
};
vision_ds_Color.set_lightness = function(this1,Value) {
	var Hue = vision_ds_Color.get_hue(this1);
	var Alpha = (this1 >> 24 & 255) / 255;
	var chroma = (1 - Math.abs(2 * Value - 1)) * ((Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)));
	var match = Value - chroma / 2;
	var Hue1 = Hue;
	var Chroma = chroma;
	Hue1 %= 360;
	var hueD = Hue1 / 60;
	var mid = Chroma * (1 - Math.abs(hueD % 2 - 1)) + match;
	Chroma += match;
	switch(hueD | 0) {
	case 0:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 1:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(match * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 2:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 3:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(match * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(mid * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 4:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(mid * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(Chroma * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	case 5:
		var Alpha1 = Alpha;
		if(Alpha1 == null) {
			Alpha1 = 1;
		}
		var Value1 = Math.round(Chroma * 255);
		this1 &= -16711681;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 16;
		var Value1 = Math.round(match * 255);
		this1 &= -65281;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
		var Value1 = Math.round(mid * 255);
		this1 &= -256;
		this1 |= Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1;
		var Value1 = Math.round(Alpha1 * 255);
		this1 &= 16777215;
		this1 |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 24;
		break;
	}
	return Value;
};
vision_ds_Color.set_rgb = function(this1,value) {
	this1 = this1 & -16777216 | value & 16777215;
	return value;
};
vision_ds_Color.get_rgb = function(this1) {
	return this1 & 16777215;
};
vision_ds_Color.maxColor = function(this1) {
	return Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.minColor = function(this1) {
	return Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255));
};
vision_ds_Color.boundChannel = function(this1,Value) {
	if(Value > 255) {
		return 255;
	} else if(Value < 0) {
		return 0;
	} else {
		return Value;
	}
};
vision_ds_Color.toString = function(this1) {
	var Alpha = false;
	var Prefix = false;
	if(Prefix == null) {
		Prefix = true;
	}
	if(Alpha == null) {
		Alpha = true;
	}
	var tmp = Alpha ? StringTools.hex(this1 >> 24 & 255,2) : "";
	return "<bg" + ("#" + ((Prefix ? "0x" : "") + tmp + StringTools.hex(this1 >> 16 & 255,2) + StringTools.hex(this1 >> 8 & 255,2) + StringTools.hex(this1 & 255,2))) + ">   </>";
};
vision_ds_Color.toInt = function(this1) {
	return this1;
};
vision_ds_Color.color_greater_than_color = function(lhs,rhs) {
	return lhs > rhs;
};
vision_ds_Color.color_greater_than_int = function(lhs,rhs) {
	return lhs > rhs;
};
vision_ds_Color.int_greater_than_color = function(lhs,rhs) {
	return lhs > rhs;
};
vision_ds_Color.color_greater_than_float = function(lhs,rhs) {
	return lhs > rhs;
};
vision_ds_Color.float_greater_than_color = function(lhs,rhs) {
	return lhs > rhs;
};
vision_ds_Color.color_greater_than_equal_color = function(lhs,rhs) {
	return lhs >= rhs;
};
vision_ds_Color.color_greater_than_equal_int = function(lhs,rhs) {
	return lhs >= rhs;
};
vision_ds_Color.int_greater_than_equal_color = function(lhs,rhs) {
	return lhs >= rhs;
};
vision_ds_Color.color_greater_than_equal_float = function(lhs,rhs) {
	return lhs >= rhs;
};
vision_ds_Color.float_greater_than_equal_color = function(lhs,rhs) {
	return lhs >= rhs;
};
vision_ds_Color.color_less_than_color = function(lhs,rhs) {
	return lhs < rhs;
};
vision_ds_Color.color_less_than_int = function(lhs,rhs) {
	return lhs < rhs;
};
vision_ds_Color.int_less_than_color = function(lhs,rhs) {
	return lhs < rhs;
};
vision_ds_Color.color_less_than_float = function(lhs,rhs) {
	return lhs < rhs;
};
vision_ds_Color.float_less_than_color = function(lhs,rhs) {
	return lhs < rhs;
};
vision_ds_Color.color_less_than_equal_color = function(lhs,rhs) {
	return lhs <= rhs;
};
vision_ds_Color.color_less_than_equal_int = function(lhs,rhs) {
	return lhs <= rhs;
};
vision_ds_Color.int_less_than_equal_color = function(lhs,rhs) {
	return lhs <= rhs;
};
vision_ds_Color.color_less_than_equal_float = function(lhs,rhs) {
	return lhs <= rhs;
};
vision_ds_Color.float_less_than_equal_color = function(lhs,rhs) {
	return lhs <= rhs;
};
vision_ds_Color.color_equal_color = function(lhs,rhs) {
	return lhs == rhs;
};
vision_ds_Color.color_equal_int = function(lhs,rhs) {
	return lhs == rhs;
};
vision_ds_Color.int_equal_color = function(lhs,rhs) {
	return lhs == rhs;
};
vision_ds_Color.color_equal_float = function(lhs,rhs) {
	return lhs == rhs;
};
vision_ds_Color.float_equal_color = function(lhs,rhs) {
	return lhs == rhs;
};
vision_ds_Color.color_not_equal_color = function(lhs,rhs) {
	return lhs != rhs;
};
vision_ds_Color.color_not_equal_int = function(lhs,rhs) {
	return lhs != rhs;
};
vision_ds_Color.int_not_equal_color = function(lhs,rhs) {
	return lhs != rhs;
};
vision_ds_Color.color_not_equal_float = function(lhs,rhs) {
	return lhs != rhs;
};
vision_ds_Color.float_not_equal_color = function(lhs,rhs) {
	return lhs != rhs;
};
vision_ds_Color.color_bitwise_and_color = function(lhs,rhs) {
	return lhs & rhs;
};
vision_ds_Color.color_bitwise_and_int = function(lhs,rhs) {
	return lhs & rhs;
};
vision_ds_Color.int_bitwise_and_color = function(lhs,rhs) {
	return lhs & rhs;
};
vision_ds_Color.color_bitwise_or_color = function(lhs,rhs) {
	return lhs | rhs;
};
vision_ds_Color.color_bitwise_or_int = function(lhs,rhs) {
	return lhs | rhs;
};
vision_ds_Color.int_bitwise_or_color = function(lhs,rhs) {
	return lhs | rhs;
};
vision_ds_Color.color_bitwise_xor_color = function(lhs,rhs) {
	return lhs ^ rhs;
};
vision_ds_Color.color_bitwise_xor_int = function(lhs,rhs) {
	return lhs ^ rhs;
};
vision_ds_Color.int_bitwise_xor_color = function(lhs,rhs) {
	return lhs ^ rhs;
};
vision_ds_Color.color_bitwise_left_shift_color = function(lhs,rhs) {
	return lhs << rhs;
};
vision_ds_Color.color_bitwise_left_shift_int = function(lhs,rhs) {
	return lhs << rhs;
};
vision_ds_Color.int_bitwise_left_shift_color = function(lhs,rhs) {
	return lhs << rhs;
};
vision_ds_Color.color_bitwise_right_shift_color = function(lhs,rhs) {
	return lhs >> rhs;
};
vision_ds_Color.color_bitwise_right_shift_int = function(lhs,rhs) {
	return lhs >> rhs;
};
vision_ds_Color.int_bitwise_right_shift_color = function(lhs,rhs) {
	return lhs >> rhs;
};
vision_ds_Color.color_bitwise_unsigned_right_shift_color = function(lhs,rhs) {
	return lhs >>> rhs;
};
vision_ds_Color.color_bitwise_unsigned_right_shift_int = function(lhs,rhs) {
	return lhs >>> rhs;
};
vision_ds_Color.int_bitwise_unsigned_right_shift_color = function(lhs,rhs) {
	return lhs >>> rhs;
};
var vision_ds_Image = {};
vision_ds_Image.get_width = function(this1) {
	return this1.length;
};
vision_ds_Image.get_height = function(this1) {
	return this1[0].length;
};
vision_ds_Image._new = function(width,height,color) {
	if(color == null) {
		color = 0;
	}
	var this1 = new Array(width);
	var this2 = this1;
	var _g = 0;
	var _g1 = this2.length;
	while(_g < _g1) {
		var i = _g++;
		var this1 = new Array(height);
		this2[i] = this1;
		var _g2 = 0;
		var _g3 = this2[i].length;
		while(_g2 < _g3) {
			var j = _g2++;
			var val = vision_ds_Color._new(color);
			this2[i][j] = val;
		}
	}
	return this2;
};
vision_ds_Image.getPixel = function(this1,x,y) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y)));
	}
	return this1[x][y];
};
vision_ds_Image.setPixel = function(this1,x,y,color) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y)));
	}
	this1[x][y] = color;
};
vision_ds_Image.hasPixel = function(this1,x,y) {
	if(x >= 0 && x < this1.length && y >= 0) {
		return y < this1[x].length;
	} else {
		return false;
	}
};
vision_ds_Image.copyPixel = function(this1,x,y,image) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y)));
	}
	var val = vision_ds_Image.image_array_read(image,x)[y];
	this1[x][y] = val;
	return this1[x][y];
};
vision_ds_Image.paintPixel = function(this1,x,y,color) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y)));
	}
	var Red = ((color >> 16 & 255) / 255 * ((color >> 24 & 255) / 255) + (vision_ds_Image.getPixel(this1,x,y) >> 16 & 255) / 255) / 2;
	var Green = ((color >> 8 & 255) / 255 * ((color >> 24 & 255) / 255) + (vision_ds_Image.getPixel(this1,x,y) >> 8 & 255) / 255) / 2;
	var Blue = ((color & 255) / 255 * ((color >> 24 & 255) / 255) + (vision_ds_Image.getPixel(this1,x,y) & 255) / 255) / 2;
	var Alpha = 1;
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 1;
	}
	var Value = Math.round(Red * 255);
	color &= -16711681;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
	var Value = Math.round(Green * 255);
	color &= -65281;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 8;
	var Value = Math.round(Blue * 255);
	color &= -256;
	color |= Value > 255 ? 255 : Value < 0 ? 0 : Value;
	var Value = Math.round(Alpha1 * 255);
	color &= 16777215;
	color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 24;
	var newColor = color;
	vision_ds_Image.setPixel(this1,x,y,newColor);
};
vision_ds_Image.fillRect = function(this1,x,y,width,height,color) {
	var _g = x;
	var _g1 = x + width;
	while(_g < _g1) {
		var X = _g++;
		var _g2 = y;
		var _g3 = y + height;
		while(_g2 < _g3) {
			var Y = _g2++;
			vision_ds_Image.setPixel(this1,X,Y,color);
		}
	}
};
vision_ds_Image.drawRect = function(this1,x,y,width,height,color) {
	vision_ds_Image.drawLine(this1,x,y,x + width,y,color);
	vision_ds_Image.drawLine(this1,x + width,y,x + width,y + height,color);
	vision_ds_Image.drawLine(this1,x + width,y + height,x,y + height,color);
	vision_ds_Image.drawLine(this1,x,y + height,x,y,color);
};
vision_ds_Image.getImagePortion = function(this1,rect) {
	var subImage = vision_ds_Image._new(rect.width,rect.height,0);
	var _g = rect.x;
	var _g1 = rect.x + rect.width;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = rect.y;
		var _g3 = rect.y + rect.height;
		while(_g2 < _g3) {
			var y = _g2++;
			vision_ds_Image.setPixel(subImage,x - rect.x,y - rect.y,vision_ds_Image.getPixel(this1,x,y));
		}
	}
	return subImage;
};
vision_ds_Image.setImagePortion = function(this1,rect,image) {
	if(rect.x < 0 || rect.x + rect.width > this1.length || rect.y < 0 || rect.y + rect.height > this1[0].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(rect.x,rect.y)));
	}
	var _g = rect.x;
	var _g1 = rect.x + rect.width;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = rect.y;
		var _g3 = rect.y + rect.height;
		while(_g2 < _g3) {
			var y = _g2++;
			vision_ds_Image.setPixel(this1,x,y,vision_ds_Image.getPixel(image,x - rect.x,y - rect.y));
		}
	}
};
vision_ds_Image.toString = function(this1) {
	var s = "\n";
	var _g = 0;
	var _g1 = this1.length;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = this1[i].length;
		while(_g2 < _g3) {
			var j = _g2++;
			s += vision_ds_Color.toString(this1[i][j]);
		}
		s += "\n";
	}
	return s;
};
vision_ds_Image.drawLine = function(this1,x1,y1,x2,y2,color) {
	var dx = Math.abs(x2 - x1);
	var dy = Math.abs(y2 - y1);
	var sx = x1 < x2 ? 1 : -1;
	var sy = y1 < y2 ? 1 : -1;
	var err = dx - dy;
	while(true) {
		vision_ds_Image.setPixel(this1,x1,y1,color);
		if(x1 == x2 && y1 == y2) {
			break;
		}
		var e2 = 2 * err;
		if(e2 > -dy) {
			err -= dy;
			x1 += sx;
		}
		if(e2 < dx) {
			err += dx;
			y1 += sy;
		}
	}
};
vision_ds_Image.drawRay2D = function(this1,line,color) {
	var p1 = line.getPointAtY(0);
	var p2 = line.getPointAtY(vision_ds_Image.get_height(this1) - 1);
	var x1 = p1.x;
	var y1 = p1.y;
	var x2 = p2.x;
	var y2 = p2.y;
	var dx = Math.abs(x2 - x1);
	var dy = Math.abs(y2 - y1);
	var sx = x1 < x2 ? 1 : -1;
	var sy = y1 < y2 ? 1 : -1;
	var err = dx - dy;
	while(true) {
		if(vision_ds_Image.hasPixel(this1,x1,y1)) {
			vision_ds_Image.setPixel(this1,x1,y1,color);
		}
		if(x1 == x2 && y1 == y2) {
			break;
		}
		var e2 = 2 * err;
		if(e2 > -dy) {
			err -= dy;
			x1 += sx;
		}
		if(e2 < dx) {
			err += dx;
			y1 += sy;
		}
	}
};
vision_ds_Image.drawLineSegment2D = function(this1,line,color) {
	var p1 = line.start;
	var p2 = line.end;
	var x1 = p1.x;
	var y1 = p1.y;
	var x2 = p2.x;
	var y2 = p2.y;
	var dx = Math.abs(x2 - x1);
	var dy = Math.abs(y2 - y1);
	var sx = x1 < x2 ? 1 : -1;
	var sy = y1 < y2 ? 1 : -1;
	var err = dx - dy;
	while(true) {
		if(vision_ds_Image.hasPixel(this1,x1,y1)) {
			vision_ds_Image.setPixel(this1,x1,y1,color);
		}
		if(x1 == x2 && y1 == y2) {
			break;
		}
		var e2 = 2 * err;
		if(e2 > -dy) {
			err -= dy;
			x1 += sx;
		}
		if(e2 < dx) {
			err += dx;
			y1 += sy;
		}
	}
};
vision_ds_Image.drawCircle = function(this1,X,Y,r,color) {
	var x = -r;
	var y = 0;
	var err = 2 - 2 * r;
	var startX = X;
	var startY = Y;
	while(true) {
		vision_ds_Image.setPixel(this1,X - x,Y + y,color);
		vision_ds_Image.setPixel(this1,X - y,Y - x,color);
		vision_ds_Image.setPixel(this1,X + x,Y - y,color);
		vision_ds_Image.setPixel(this1,X + y,Y + x,color);
		r = err;
		if(r <= y) {
			err += ++y * 2 + 1;
		}
		if(r > x || err > y) {
			err += ++x * 2 + 1;
		}
		if(!(x < 0)) {
			break;
		}
	}
};
vision_ds_Image.fillColor = function(this1,position,color) {
	var originalColor = vision_ds_Image.getPixel(this1,position.x,position.y);
	var expandFill = null;
	expandFill = function(x,y) {
		if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
			return;
		}
		if(vision_ds_Image.getPixel(this1,x,y) == color) {
			return;
		}
		if(vision_ds_Image.getPixel(this1,x,y) == originalColor) {
			vision_ds_Image.setPixel(this1,x,y,color);
			expandFill(x + 1,y);
			expandFill(x - 1,y);
			expandFill(x,y + 1);
			expandFill(x,y - 1);
		}
	};
	expandFill(position.x,position.y);
};
vision_ds_Image.clone = function(this1) {
	var clone = vision_ds_Image._new(vision_ds_Image.get_width(this1),vision_ds_Image.get_height(this1),0);
	var _g = 0;
	var _g1 = this1.length;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = this1[i].length;
		while(_g2 < _g3) {
			var j = _g2++;
			vision_ds_Image.setPixel(clone,i,j,this1[i][j]);
		}
	}
	return clone;
};
vision_ds_Image.image_array_read = function(this1,index) {
	return this1[index];
};
vision_ds_Image.image_array_write = function(this1,index,value) {
	this1[index] = value;
};
var vision_ds_LineSegment2D = function(start,end) {
	this.end = new vision_ds_Point2D(0,0);
	this.start = new vision_ds_Point2D(0,0);
	this.start.x = start.x;
	this.start.y = start.y;
	this.end.x = end.x;
	this.end.y = end.y;
};
vision_ds_LineSegment2D.__name__ = true;
vision_ds_LineSegment2D.fromPointAndAngle = function(point,angle) {
	var x = point.x;
	var y = point.y;
	var length = 1;
	var end = new vision_ds_Point2D(x + length * Math.cos(angle * (Math.PI / 180)) | 0,y + length * Math.sin(angle * (Math.PI / 180)) | 0);
	return new vision_ds_LineSegment2D(point,end);
};
vision_ds_LineSegment2D.prototype = {
	get_length: function() {
		return Math.sqrt(Math.pow(this.end.x - this.start.x,2) + Math.pow(this.end.y - this.start.y,2));
	}
	,toString: function() {
		return "\n (" + Std.string(this.start) + ".x, " + Std.string(this.start) + ".y) --> (" + Std.string(this.end) + ".x, " + Std.string(this.end) + ".y)";
	}
	,set_slope: function(value) {
		this["degrees"] = Math.atan(value) * 180 / Math.PI;
		this["radians"] = Math.atan(value);
		return this.slope = value;
	}
	,set_degrees: function(value) {
		this["slope"] = Math.tan(value * Math.PI / 180);
		this["radians"] = value * Math.PI / 180;
		return this.degrees = value;
	}
	,set_radians: function(value) {
		this["slope"] = Math.tan(value);
		this["degrees"] = value * 180 / Math.PI;
		return this.radians = value;
	}
};
var vision_ds_Point2D = function(x,y) {
	if(y == null) {
		y = 0;
	}
	if(x == null) {
		x = 0;
	}
	this.x = x;
	this.y = y;
};
vision_ds_Point2D.__name__ = true;
vision_ds_Point2D.prototype = {
	toString: function() {
		return "(" + this.x + ", " + this.y + ")";
	}
};
var vision_ds_Ray2D = function(point,m,degrees,radians) {
	this.point = point;
	if(m != null) {
		this.set_slope(m);
		this.set_degrees(Math.atan(m) * 180 / Math.PI);
		this.set_radians(Math.atan(m));
	} else if(degrees != null) {
		this.set_degrees(degrees);
		this.set_slope(Math.tan(degrees * Math.PI / 180));
		this.set_radians(degrees * Math.PI / 180);
	} else if(radians != null) {
		this.set_radians(radians);
		this.set_slope(Math.tan(radians));
		this.set_degrees(radians * 180 / Math.PI);
	}
};
vision_ds_Ray2D.__name__ = true;
vision_ds_Ray2D.from2Points = function(point1,point2) {
	var s = (point2.y - point1.y) / (point2.x - point1.x);
	return new vision_ds_Ray2D(point1,s);
};
vision_ds_Ray2D.prototype = {
	set_slope: function(value) {
		this.degrees = Math.atan(value) * 180 / Math.PI;
		this.radians = Math.atan(value);
		return this.slope = value;
	}
	,set_degrees: function(value) {
		this.slope = Math.tan(value * Math.PI / 180);
		this.radians = value * Math.PI / 180;
		return this.degrees = value;
	}
	,set_radians: function(value) {
		this.slope = Math.tan(value);
		this.degrees = value * 180 / Math.PI;
		return this.radians = value;
	}
	,get_yIntercept: function() {
		var px = this.point.x;
		var py = this.point.y;
		if(px > 0) {
			while(px > 0) {
				--px;
				py -= this.slope;
			}
		} else if(px < 0) {
			while(px < 0) {
				++px;
				py += this.slope;
			}
		}
		return py;
	}
	,get_xIntercept: function() {
		var px = this.point.x;
		var py = this.point.y;
		if(py > 0) {
			while(py > 0) {
				--py;
				px -= 1 / this.slope;
			}
		} else if(py < 0) {
			while(py < 0) {
				++py;
				px += 1 / this.slope;
			}
		}
		return px;
	}
	,getPointAtX: function(x) {
		return new vision_ds_Point2D(x,this.slope * x + this.get_yIntercept() | 0);
	}
	,getPointAtY: function(y) {
		return new vision_ds_Point2D(y / this.slope | 0,y);
	}
};
var vision_ds_hough_HoughSpace = function(accumulator,image) {
	this.accumulator = accumulator;
	this.image = image;
};
vision_ds_hough_HoughSpace.__name__ = true;
var vision_exceptions_VisionException = function(message,type) {
	throw "Exception - " + type + ":\n\n\t" + message + "\n";
};
vision_exceptions_VisionException.__name__ = true;
var vision_exceptions_InvalidGaussianKernalSize = function(size) {
	vision_exceptions_VisionException.call(this,"Creating a gaussian kernal of size " + size + " is not allowed. Is the kernal size even?","Invalid Gaussian Kernal Size");
};
vision_exceptions_InvalidGaussianKernalSize.__name__ = true;
vision_exceptions_InvalidGaussianKernalSize.__super__ = vision_exceptions_VisionException;
vision_exceptions_InvalidGaussianKernalSize.prototype = $extend(vision_exceptions_VisionException.prototype,{
});
var vision_exceptions_OutOfBounds = function(image,position) {
	vision_exceptions_VisionException.call(this,"pixel " + Std.string(position) + " is outside the bounds of the image (size: " + vision_ds_Image.get_width(image) + "x" + vision_ds_Image.get_height(image) + ", position: " + Std.string(position) + ")","Pixel Coordinates Out Of Bounds");
};
vision_exceptions_OutOfBounds.__name__ = true;
vision_exceptions_OutOfBounds.__super__ = vision_exceptions_VisionException;
vision_exceptions_OutOfBounds.prototype = $extend(vision_exceptions_VisionException.prototype,{
});
var vision_tools_MathUtils = function() { };
vision_tools_MathUtils.__name__ = true;
vision_tools_MathUtils.distanceFromPointToRay2D = function(point,line) {
	var cos = Math.cos(line.radians);
	var sin = Math.sin(line.radians);
	var x0 = line.point.x;
	var y0 = line.point.y;
	var x1 = point.x;
	var y1 = point.y;
	var numerator = (x0 - x1) * cos + (y0 - y1) * sin;
	var denominator = Math.sqrt(Math.pow(x0 - x1,2) + Math.pow(y0 - y1,2));
	var distance = numerator / denominator;
	return distance;
};
vision_tools_MathUtils.distanceFromPointToLineSegment2D = function(line,point) {
	var ch = (line.start.y - line.end.y) * point.x + (line.end.x - line.start.x) * point.y + (line.start.x * line.end.y - line.end.x * line.start.y);
	var del = Math.sqrt(Math.pow(line.end.x - line.start.x,2) + Math.pow(line.end.y - line.start.y,2));
	var d = ch / del;
	return d;
};
vision_tools_MathUtils.distanceBetweenlineSegments2D = function(line1,line2) {
	if(vision_tools_MathUtils.intersectionBetweenLineSegments2D(line1,line2) != null) {
		return 0;
	}
	var distance1 = vision_tools_MathUtils.distanceFromPointToLineSegment2D(line1,line2.start);
	var distance2 = vision_tools_MathUtils.distanceFromPointToLineSegment2D(line1,line2.end);
	var distance3 = vision_tools_MathUtils.distanceFromPointToLineSegment2D(line2,line1.start);
	var distance4 = vision_tools_MathUtils.distanceFromPointToLineSegment2D(line2,line1.end);
	var distance = vision_tools_MathUtils.min(distance1,distance2,distance3,distance4);
	return distance;
};
vision_tools_MathUtils.angleFromPointToLine = function(point,line) {
	var angle = Math.atan2(line.end.y - line.start.y,line.end.x - line.start.x);
	var angle2 = Math.atan2(point.y - line.start.y,point.x - line.start.x);
	return angle2 - angle;
};
vision_tools_MathUtils.angleFromPointToPoint = function(point1,point2) {
	var x = point2.x - point1.x;
	var y = point2.y - point1.y;
	return Math.atan2(y,x);
};
vision_tools_MathUtils.distanceBetweenPoints = function(point1,point2) {
	var x = point2.x - point1.x;
	var y = point2.y - point1.y;
	return Math.sqrt(x * x + y * y);
};
vision_tools_MathUtils.intersectionBetweenLineSegments2D = function(line1,line2) {
	var x1 = line1.start.x;
	var y1 = line1.start.y;
	var x2 = line1.end.x;
	var y2 = line1.end.y;
	var x3 = line2.start.x;
	var y3 = line2.start.y;
	var x4 = line2.end.x;
	var y4 = line2.end.y;
	var denominator = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
	if(x1 == x2 && y1 == y2 || x3 == x4 && y3 == y4) {
		return null;
	}
	if(denominator == 0) {
		return null;
	}
	var ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denominator;
	var ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denominator;
	if(ua < 0 || ua > 1 || ub < 0 || ub > 1) {
		return null;
	}
	var x = x1 + ua * (x2 - x1);
	var y = y1 + ua * (y2 - y1);
	return new vision_ds_Point2D(x | 0,y | 0);
};
vision_tools_MathUtils.wrapInt = function(value,min,max) {
	var range = max - min + 1;
	if(value < min) {
		value += range * ((min - value) / range + 1 | 0);
	}
	return min + (value - min) % range;
};
vision_tools_MathUtils.wrapFloat = function(value,min,max) {
	var range = max - min;
	if(value < min) {
		value += range * (min - value) / range + 1;
	}
	return min + (value - min) % range;
};
vision_tools_MathUtils.boundInt = function(value,min,max) {
	return Math.min(Math.max(value,min),max) | 0;
};
vision_tools_MathUtils.boundFloat = function(value,min,max) {
	return Math.min(Math.max(value,min),max);
};
vision_tools_MathUtils.degreesFromSlope = function(slope) {
	return Math.atan(slope) * 180 / Math.PI;
};
vision_tools_MathUtils.radiansFromSlope = function(slope) {
	return Math.atan(slope);
};
vision_tools_MathUtils.slopeFromDegrees = function(degrees) {
	return Math.tan(degrees * Math.PI / 180);
};
vision_tools_MathUtils.radiansFromDegrees = function(degrees) {
	return degrees * Math.PI / 180;
};
vision_tools_MathUtils.degreesFromRadians = function(radians) {
	return radians * 180 / Math.PI;
};
vision_tools_MathUtils.slopeFromRadians = function(radians) {
	return Math.tan(radians);
};
vision_tools_MathUtils.cotan = function(radians) {
	return 1 / Math.tan(radians);
};
vision_tools_MathUtils.cosec = function(radians) {
	return 1 / Math.sin(radians);
};
vision_tools_MathUtils.sec = function(radians) {
	return 1 / Math.cos(radians);
};
vision_tools_MathUtils.turnicate = function(num,numbersAfterDecimal) {
	var multiplier = Math.pow(10,numbersAfterDecimal);
	return Math.round(num * multiplier) / multiplier;
};
vision_tools_MathUtils.min = function() {
	var $l=arguments.length;
	var values = new Array($l>0?$l-0:0);
	for(var $i=0;$i<$l;++$i){values[$i-0]=arguments[$i];}
	var min = values[0];
	var _g = 0;
	var _g1 = values.length;
	while(_g < _g1) {
		var i = _g++;
		if(values[i] < min) {
			min = values[i];
		}
	}
	return min;
};
vision_tools_MathUtils.max = function() {
	var $l=arguments.length;
	var values = new Array($l>0?$l-0:0);
	for(var $i=0;$i<$l;++$i){values[$i-0]=arguments[$i];}
	var max = values[0];
	var _g = 0;
	var _g1 = values.length;
	while(_g < _g1) {
		var i = _g++;
		if(values[i] > max) {
			max = values[i];
		}
	}
	return max;
};
$global.$haxeUID |= 0;
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
haxe_ds_ObjectMap.count = 0;
js_Boot.__toStr = ({ }).toString;
vision_ds_Color.TRANSPARENT = 0;
vision_ds_Color.WHITE = 16777215;
vision_ds_Color.GRAY = 8421504;
vision_ds_Color.BLACK = 0;
vision_ds_Color.GREEN = 65280;
vision_ds_Color.YELLOW = 16776960;
vision_ds_Color.ORANGE = 16753920;
vision_ds_Color.RED = 16711680;
vision_ds_Color.PURPLE = 8388736;
vision_ds_Color.BLUE = 255;
vision_ds_Color.BROWN = 9127187;
vision_ds_Color.PINK = 16761035;
vision_ds_Color.MAGENTA = 16711935;
vision_ds_Color.CYAN = 65535;
vision_ds_Color.SILVER = 12632256;
vision_ds_Color.GOLD = 16766720;
vision_ds_Color.OLIVE = 8421376;
vision_ds_Color.MAROON = 8388608;
vision_ds_Color.NAVY = 128;
vision_ds_Color.TEAL = 32896;
vision_ds_Color.FUCHSIA = 16711935;
vision_ds_Color.AQUA = 65535;
vision_ds_Color.LIME = 3329330;
vision_ds_Color.ROYAL_BLUE = 4286945;
vision_ds_Color.COLOR_REGEX = new EReg("^(0x|#)(([A-F0-9]{2}){3,4})$","i");
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=main.js.map