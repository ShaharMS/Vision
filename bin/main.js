(function ($global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.now = function() {
	return Date.now();
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var start;
	var end;
	vision_tools_ImageTools.loadFromFile(null,"https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG",function(image) {
		Main.printImage(image);
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.sobelEdgeDiffOperator(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Sobel Filter took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 88, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.perwittEdgeDiffOperator(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Perwitt Filter took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 92, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Sobel edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 96, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		var hough = vision_algorithms_Hough.toHoughSpace(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
		Main.printImage(hough.image);
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Hough transform took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 101, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Perwitt edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 105, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		var canny = vision_Vision.cannyEdgeDetection(vision_ds_Image.clone(image));
		Main.printImage(canny);
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Canny edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 110, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.nearestNeighborBlur(vision_ds_Image.clone(image),1));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Nearest neighbor blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 114, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.GaussianBlur(9,10)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Gaussian blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 118, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		var lines = vision_Vision.simpleLine2DDetection(vision_ds_Image.clone(image),3,30);
		var newI = vision_ds_Image.clone(image);
		var _g = 0;
		while(_g < lines.length) {
			var l = lines[_g];
			++_g;
			vision_ds_Image.drawLine2D(newI,l,65493);
		}
		Main.printImage(newI);
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Simple line detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 139, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		var lines = vision_Vision.houghRay2DDetection(vision_ds_Image.clone(image));
		var _g = 0;
		while(_g < lines.length) {
			var l = lines[_g];
			++_g;
			vision_ds_Image.drawRay2D(image,l,65493);
		}
		Main.printImage(image);
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Hough line detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 147, className : "Main", methodName : "main"});
	});
};
Main.printImage = function(image) {
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
var haxe_Int32 = {};
haxe_Int32.ucompare = function(a,b) {
	if(a < 0) {
		if(b < 0) {
			return ~b - ~a | 0;
		} else {
			return 1;
		}
	}
	if(b < 0) {
		return -1;
	} else {
		return a - b | 0;
	}
};
var haxe_Int64 = {};
haxe_Int64.toString = function(this1) {
	var i = this1;
	var b_high = 0;
	var b_low = 0;
	if(i.high == b_high && i.low == b_low) {
		return "0";
	}
	var str = "";
	var neg = false;
	if(i.high < 0) {
		neg = true;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(0,10);
	var ten = this1;
	while(true) {
		var b_high = 0;
		var b_low = 0;
		if(!(i.high != b_high || i.low != b_low)) {
			break;
		}
		var r = haxe_Int64.divMod(i,ten);
		if(r.modulus.high < 0) {
			var x = r.modulus;
			var high = ~x.high;
			var low = ~x.low + 1 | 0;
			if(low == 0) {
				var ret = high++;
				high = high | 0;
			}
			var this_high = high;
			var this_low = low;
			str = this_low + str;
			var x1 = r.quotient;
			var high1 = ~x1.high;
			var low1 = ~x1.low + 1 | 0;
			if(low1 == 0) {
				var ret1 = high1++;
				high1 = high1 | 0;
			}
			var this1 = new haxe__$Int64__$_$_$Int64(high1,low1);
			i = this1;
		} else {
			str = r.modulus.low + str;
			i = r.quotient;
		}
	}
	if(neg) {
		str = "-" + str;
	}
	return str;
};
haxe_Int64.divMod = function(dividend,divisor) {
	if(divisor.high == 0) {
		switch(divisor.low) {
		case 0:
			throw haxe_Exception.thrown("divide by zero");
		case 1:
			var this1 = new haxe__$Int64__$_$_$Int64(dividend.high,dividend.low);
			var this2 = new haxe__$Int64__$_$_$Int64(0,0);
			return { quotient : this1, modulus : this2};
		}
	}
	var divSign = dividend.high < 0 != divisor.high < 0;
	var modulus;
	if(dividend.high < 0) {
		var high = ~dividend.high;
		var low = ~dividend.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		modulus = this1;
	} else {
		var this1 = new haxe__$Int64__$_$_$Int64(dividend.high,dividend.low);
		modulus = this1;
	}
	if(divisor.high < 0) {
		var high = ~divisor.high;
		var low = ~divisor.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		divisor = this1;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(0,0);
	var quotient = this1;
	var this1 = new haxe__$Int64__$_$_$Int64(0,1);
	var mask = this1;
	while(!(divisor.high < 0)) {
		var v = haxe_Int32.ucompare(divisor.high,modulus.high);
		var cmp = v != 0 ? v : haxe_Int32.ucompare(divisor.low,modulus.low);
		var b = 1;
		b &= 63;
		if(b == 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(divisor.high,divisor.low);
			divisor = this1;
		} else if(b < 32) {
			var this2 = new haxe__$Int64__$_$_$Int64(divisor.high << b | divisor.low >>> 32 - b,divisor.low << b);
			divisor = this2;
		} else {
			var this3 = new haxe__$Int64__$_$_$Int64(divisor.low << b - 32,0);
			divisor = this3;
		}
		var b1 = 1;
		b1 &= 63;
		if(b1 == 0) {
			var this4 = new haxe__$Int64__$_$_$Int64(mask.high,mask.low);
			mask = this4;
		} else if(b1 < 32) {
			var this5 = new haxe__$Int64__$_$_$Int64(mask.high << b1 | mask.low >>> 32 - b1,mask.low << b1);
			mask = this5;
		} else {
			var this6 = new haxe__$Int64__$_$_$Int64(mask.low << b1 - 32,0);
			mask = this6;
		}
		if(cmp >= 0) {
			break;
		}
	}
	while(true) {
		var b_high = 0;
		var b_low = 0;
		if(!(mask.high != b_high || mask.low != b_low)) {
			break;
		}
		var v = haxe_Int32.ucompare(modulus.high,divisor.high);
		if((v != 0 ? v : haxe_Int32.ucompare(modulus.low,divisor.low)) >= 0) {
			var this1 = new haxe__$Int64__$_$_$Int64(quotient.high | mask.high,quotient.low | mask.low);
			quotient = this1;
			var high = modulus.high - divisor.high | 0;
			var low = modulus.low - divisor.low | 0;
			if(haxe_Int32.ucompare(modulus.low,divisor.low) < 0) {
				var ret = high--;
				high = high | 0;
			}
			var this2 = new haxe__$Int64__$_$_$Int64(high,low);
			modulus = this2;
		}
		var b = 1;
		b &= 63;
		if(b == 0) {
			var this3 = new haxe__$Int64__$_$_$Int64(mask.high,mask.low);
			mask = this3;
		} else if(b < 32) {
			var this4 = new haxe__$Int64__$_$_$Int64(mask.high >>> b,mask.high << 32 - b | mask.low >>> b);
			mask = this4;
		} else {
			var this5 = new haxe__$Int64__$_$_$Int64(0,mask.high >>> b - 32);
			mask = this5;
		}
		var b1 = 1;
		b1 &= 63;
		if(b1 == 0) {
			var this6 = new haxe__$Int64__$_$_$Int64(divisor.high,divisor.low);
			divisor = this6;
		} else if(b1 < 32) {
			var this7 = new haxe__$Int64__$_$_$Int64(divisor.high >>> b1,divisor.high << 32 - b1 | divisor.low >>> b1);
			divisor = this7;
		} else {
			var this8 = new haxe__$Int64__$_$_$Int64(0,divisor.high >>> b1 - 32);
			divisor = this8;
		}
	}
	if(divSign) {
		var high = ~quotient.high;
		var low = ~quotient.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		quotient = this1;
	}
	if(dividend.high < 0) {
		var high = ~modulus.high;
		var low = ~modulus.low + 1 | 0;
		if(low == 0) {
			var ret = high++;
			high = high | 0;
		}
		var this1 = new haxe__$Int64__$_$_$Int64(high,low);
		modulus = this1;
	}
	return { quotient : quotient, modulus : modulus};
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = true;
haxe__$Int64__$_$_$Int64.prototype = {
	toString: function() {
		return haxe_Int64.toString(this);
	}
};
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
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
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
vision_Vision.convolve = function(image,kernal,denominator) {
	var matrix;
	switch(kernal._hx_index) {
	case 0:
		matrix = [[0,0,0],[0,1,0],[0,0,0]];
		break;
	case 1:
		matrix = [[1,1,1],[1,1,1],[1,1,1]];
		break;
	case 2:
		matrix = [[-1,-1,-1],[-1,4,-1],[-1,-1,-1]];
		break;
	case 3:
		matrix = [[-1,-1,-1],[-1,7,-1],[-1,-1,-1]];
		break;
	case 4:
		matrix = [[0,-1,0],[-1,5,-1],[0,-1,0]];
		break;
	case 5:
		matrix = [[1,4,6,4,1],[4,16,24,16,4],[6,24,-476,24,6],[4,16,24,16,4],[1,4,6,4,1]];
		break;
	case 6:
		var corner = kernal.corner;
		var edge = kernal.edge;
		var center = kernal.center;
		matrix = [[corner,edge,corner],[edge,center,edge],[corner,edge,corner]];
		break;
	case 7:
		var farCorner = kernal.farCorner;
		var farEdge = kernal.farEdge;
		var edge = kernal.edge;
		var midCorner = kernal.midCorner;
		var midEdge = kernal.midEdge;
		var center = kernal.center;
		matrix = [[farCorner,farEdge,edge,farEdge,farCorner],[farEdge,midCorner,midEdge,midCorner,farEdge],[edge,midEdge,center,midEdge,edge],[farEdge,midCorner,midEdge,midCorner,farEdge],[farCorner,farEdge,edge,farEdge,farCorner]];
		break;
	case 8:
		var kernal1 = kernal.kernal;
		matrix = kernal1;
		break;
	case 9:
		var size = kernal.size;
		var sigma = kernal.sigma;
		matrix = vision_algorithms_Gaussian.createKernalOfSize(size,sigma);
		break;
	}
	if(denominator == null) {
		switch(kernal._hx_index) {
		case 1:
			denominator = 9;
			break;
		case 5:
			denominator = 256;
			break;
		default:
			denominator = 1;
		}
	}
	var convolved = vision_ds_Image._new(vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var maxLength = -1;
	var items = 0;
	var _g = 0;
	while(_g < matrix.length) {
		var array = matrix[_g];
		++_g;
		if(array.length > maxLength) {
			maxLength = array.length;
		}
		items += array.length;
	}
	var flat = [];
	var _g = 0;
	while(_g < matrix.length) {
		var item = matrix[_g];
		++_g;
		flat = flat.concat(item);
	}
	var flatMatrix = flat;
	var denominator = 0.;
	var _g = 0;
	while(_g < flatMatrix.length) {
		var number = flatMatrix[_g];
		++_g;
		denominator += number;
	}
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var array = vision_tools_ImageTools.getNeighborsOfPixel(image,x,y,maxLength);
			var flat = [];
			var _g4 = 0;
			while(_g4 < array.length) {
				var item = array[_g4];
				++_g4;
				flat = flat.concat(item);
			}
			var neighbors = flat;
			var red = 0.;
			var green = 0.;
			var blue = 0.;
			var _g5 = 0;
			var _g6 = neighbors.length;
			while(_g5 < _g6) {
				var i = _g5++;
				red += flatMatrix[i] * (neighbors[i] >> 16 & 255);
				blue += flatMatrix[i] * (neighbors[i] & 255);
				green += flatMatrix[i] * (neighbors[i] >> 8 & 255);
			}
			red /= denominator;
			green /= denominator;
			blue /= denominator;
			var Red = red | 0;
			var Green = green | 0;
			var Blue = blue | 0;
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
			vision_ds_Image.setPixel(convolved,x,y,color);
		}
	}
	haxe_Log.trace(flatMatrix.length,{ fileName : "src/vision/Vision.hx", lineNumber : 283, className : "vision.Vision", methodName : "convolve"});
	image = convolved;
	return image;
};
vision_Vision.houghRay2DDetection = function(image,threshold,maxRayCount) {
	if(threshold == null) {
		threshold = 70;
	}
	var edges = vision_Vision.cannyEdgeDetection(vision_ds_Image.clone(image));
	var houghSpace = vision_algorithms_Hough.toHoughSpaceWithRays(edges,threshold,maxRayCount);
	return houghSpace.rays;
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
	var _g = 0;
	var _g1 = iterations;
	while(_g < _g1) {
		var i = _g++;
		vision_Vision.convolve(image,vision_ds_Kernal2D.BoxBlur);
	}
	return image;
};
vision_Vision.gaussianBlur = function(image,sigma,kernalSize) {
	if(kernalSize == null) {
		kernalSize = 5;
	}
	if(sigma == null) {
		sigma = 1;
	}
	return vision_Vision.convolve(image,vision_ds_Kernal2D.GaussianBlur(kernalSize,sigma));
};
vision_Vision.cannyEdgeDetection = function(image,sigma,initialKernalSize,lowThreshold,highThreshold) {
	if(highThreshold == null) {
		highThreshold = 0.2;
	}
	if(lowThreshold == null) {
		lowThreshold = 0.05;
	}
	if(initialKernalSize == null) {
		initialKernalSize = 5;
	}
	if(sigma == null) {
		sigma = 1;
	}
	var cannyObject = vision_ds_Image.clone(image);
	return vision_Vision.blackAndWhite(vision_algorithms_Canny.applyHysteresis(vision_algorithms_Canny.nonMaxSuppression(vision_algorithms_Canny.applySobelFilters(vision_algorithms_Canny.applyGaussian(vision_algorithms_Canny.grayscale(cannyObject),initialKernalSize,sigma))),highThreshold,lowThreshold),40);
};
vision_Vision.simpleLine2DDetection = function(image,minLineGap,minLineLength) {
	if(minLineLength == null) {
		minLineLength = 10;
	}
	if(minLineGap == null) {
		minLineGap = 2;
	}
	var lines = [];
	var edgeDetected = vision_Vision.cannyEdgeDetection(image,1,5,0.05,0.16);
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var line = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength);
			lines.push(line);
			var line2 = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,true);
			lines.push(line2);
			var line3 = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,false,true);
			lines.push(line3);
			var line4 = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,true,true);
			lines.push(line4);
		}
	}
	var actualLines = [];
	var _g = 0;
	while(_g < lines.length) {
		var l = lines[_g];
		++_g;
		if(l == null) {
			continue;
		}
		if(vision_algorithms_SimpleLineDetector.lineCoveragePercentage(edgeDetected,l) < 40) {
			continue;
		}
		actualLines.push(l);
	}
	var edgeDetected = vision_Vision.cannyEdgeDetection(vision_ds_Image.mirror(image));
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var line = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength);
			lines.push(line);
			var line2 = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,true);
			lines.push(line2);
			var line3 = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,false,true);
			lines.push(line3);
			var line4 = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,true,true);
			lines.push(line4);
		}
	}
	var _g = 0;
	while(_g < lines.length) {
		var l = lines[_g];
		++_g;
		if(l == null) {
			continue;
		}
		if(vision_algorithms_SimpleLineDetector.lineCoveragePercentage(edgeDetected,l) < 40) {
			continue;
		}
		actualLines.push(l.mirrorInsideRectangle({ x : 0, y : 0, width : vision_ds_Image.get_width(image), height : vision_ds_Image.get_height(image)}));
	}
	return actualLines;
};
vision_Vision.sobelEdgeDiffOperator = function(image) {
	return vision_algorithms_Sobel.convolveWithSobelOperator(vision_Vision.grayscale(vision_ds_Image.clone(image)));
};
vision_Vision.perwittEdgeDiffOperator = function(image) {
	return vision_algorithms_Perwitt.convolveWithPerwittOperator(vision_Vision.grayscale(vision_ds_Image.clone(image)));
};
var vision_algorithms_Canny = function() { };
vision_algorithms_Canny.__name__ = true;
vision_algorithms_Canny.grayscale = function(image) {
	return vision_Vision.grayscale(image);
};
vision_algorithms_Canny.applyGaussian = function(image,size,sigma) {
	return vision_Vision.gaussianBlur(image,sigma,size);
};
vision_algorithms_Canny.applySobelFilters = function(image) {
	return vision_Vision.sobelEdgeDiffOperator(image);
};
vision_algorithms_Canny.nonMaxSuppression = function(image) {
	var filtered = vision_ds_Image._new(vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			var n = vision_algorithms_Canny.getNeighbors(3,x,y,image);
			if(n[1][1] > n[0][1] && n[1][1] > n[2][1]) {
				vision_ds_Image.image_array_read(filtered,x)[y] = n[1][1];
			} else {
				vision_ds_Image.image_array_read(filtered,x)[y] = 0;
			}
			if(n[1][1] > n[0][2] && n[1][1] > n[2][0]) {
				vision_ds_Image.image_array_read(filtered,x)[y] = n[1][1];
			} else {
				vision_ds_Image.image_array_read(filtered,x)[y] = 0;
			}
			if(n[1][1] > n[1][0] && n[1][1] > n[1][2]) {
				vision_ds_Image.image_array_read(filtered,x)[y] = n[1][1];
			} else {
				vision_ds_Image.image_array_read(filtered,x)[y] = 0;
			}
			if(n[1][1] > n[0][0] && n[1][1] > n[2][2]) {
				vision_ds_Image.image_array_read(filtered,x)[y] = n[1][1];
			} else {
				vision_ds_Image.image_array_read(filtered,x)[y] = 0;
			}
		}
	}
	return filtered;
};
vision_algorithms_Canny.applyHysteresis = function(image,highThreshold,lowThreshold) {
	var copy = vision_ds_Image.clone(image);
	var isStrong = function(edge) {
		return (edge >> 16 & 255) / 255 > highThreshold;
	};
	var isCandidate = function(edge) {
		if((edge >> 16 & 255) / 255 <= highThreshold) {
			return (edge >> 16 & 255) / 255 >= lowThreshold;
		} else {
			return false;
		}
	};
	var isWeak = function(edge) {
		return (edge >> 16 & 255) / 255 < lowThreshold;
	};
	var traverseEdge = null;
	traverseEdge = function(x,y) {
		if(x == 0 || y == 0 || x == vision_ds_Image.get_width(image) - 1 || y == vision_ds_Image.get_height(image) - 1) {
			return;
		}
		if(isStrong(vision_ds_Image.image_array_read(copy,x)[y])) {
			var neighbors = vision_algorithms_Canny.getNeighbors(3,x,y,copy);
			if(isCandidate(neighbors[0][0])) {
				vision_ds_Image.image_array_read(copy,x - 1)[y - 1] = 16777215;
				traverseEdge(x - 1,y - 1);
			}
			if(isCandidate(neighbors[0][1])) {
				vision_ds_Image.image_array_read(copy,x - 1)[y - 1 + 1] = 16777215;
				traverseEdge(x - 1,y - 1 + 1);
			}
			if(isCandidate(neighbors[1][0])) {
				vision_ds_Image.image_array_read(copy,x - 1 + 1)[y - 1] = 16777215;
				traverseEdge(x - 1 + 1,y - 1);
			}
			if(isCandidate(neighbors[1][1])) {
				vision_ds_Image.image_array_read(copy,x - 1 + 1)[y - 1 + 1] = 16777215;
				traverseEdge(x - 1 + 1,y - 1 + 1);
			}
		}
	};
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			traverseEdge(x,y);
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
			if(!isStrong(vision_ds_Image.image_array_read(copy,x)[y])) {
				vision_ds_Image.image_array_read(copy,x)[y] = 0;
			}
		}
	}
	return copy;
};
vision_algorithms_Canny.getNeighbors = function(kernalSize,x,y,image) {
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
				neighbors[X + roundedDown].push(0);
				continue;
			}
			var tmp = vision_ds_Image.getPixel(image,x + X,y + Y);
			neighbors[X + roundedDown].push(tmp);
		}
	}
	return neighbors;
};
var vision_algorithms_Gaussian = function() { };
vision_algorithms_Gaussian.__name__ = true;
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
	var rhoMax = Math.sqrt(vision_ds_Image.get_width(image) * vision_ds_Image.get_width(image) + vision_ds_Image.get_height(image) * vision_ds_Image.get_height(image));
	var accum = vision_ds_hough_HoughAccumulator._new(rhoMax | 0);
	var houghSpace = vision_ds_Image._new(181,rhoMax | 0,16777215);
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			if(Math.abs(vision_ds_Image.getPixel(image,x,y) >> 16 & 255) == 255) {
				var rho;
				var theta = 0.;
				var thetaIndex = 0;
				while(thetaIndex < 180) {
					rho = x * Math.cos(theta) + y * Math.sin(theta);
					vision_ds_hough_HoughAccumulator.incrementCell(accum,rho,thetaIndex);
					var Alpha = 0.01;
					if(Alpha == null) {
						Alpha = 1;
					}
					var color = vision_ds_Color._new();
					var Alpha1 = Alpha;
					if(Alpha1 == null) {
						Alpha1 = 1;
					}
					var value = Math.round(0);
					color &= -16711681;
					color |= (value > 255 ? 255 : value < 0 ? 0 : value) << 16;
					var value1 = Math.round(0);
					color &= -65281;
					color |= (value1 > 255 ? 255 : value1 < 0 ? 0 : value1) << 8;
					var value2 = Math.round(0);
					color &= -256;
					color |= value2 > 255 ? 255 : value2 < 0 ? 0 : value2;
					var value3 = Math.round(Alpha1 * 255);
					color &= 16777215;
					color |= (value3 > 255 ? 255 : value3 < 0 ? 0 : value3) << 24;
					vision_ds_Image.paintPixel(houghSpace,thetaIndex,rho | 0,color);
					theta += Math.PI / 360;
					++thetaIndex;
				}
			}
		}
	}
	return new vision_ds_hough_HoughSpace(accum,houghSpace);
};
vision_algorithms_Hough.toHoughSpaceWithRays = function(image,threshold,numLocalMaxima) {
	if(threshold == null) {
		threshold = 35;
	}
	var space = vision_algorithms_Hough.toHoughSpace(image);
	var accum = space.accumulator;
	haxe_Log.trace(accum,{ fileName : "src/vision/algorithms/Hough.hx", lineNumber : 95, className : "vision.algorithms.Hough", methodName : "toHoughSpaceWithRays"});
	var maximas = [];
	var rays = [];
	var _g = vision_ds_hough_HoughAccumulator.cellIterator(accum,threshold);
	while(_g.current < _g.array.length) {
		var point = _g.array[_g.current++];
		var thetaDeg = vision_ds_IntPoint2D.get_y(point);
		vision_tools_MathTools.wrapInt(thetaDeg,-90,90);
		var rho = vision_ds_IntPoint2D.get_x(point);
		var tempRay = new vision_ds_Ray2D(new vision_ds_Point2D(0,0),null,thetaDeg);
		var p = tempRay.findPointWithDistance(0,rho);
		rays.push(new vision_ds_Ray2D(p,null,thetaDeg + 90));
	}
	haxe_Log.trace(rays,{ fileName : "src/vision/algorithms/Hough.hx", lineNumber : 109, className : "vision.algorithms.Hough", methodName : "toHoughSpaceWithRays"});
	space.rays = rays;
	space.maximums = maximas;
	return space;
};
var vision_algorithms_Perwitt = function() { };
vision_algorithms_Perwitt.__name__ = true;
vision_algorithms_Perwitt.convolveWithPerwittOperator = function(image) {
	var x = vision_ds_Image.get_width(image);
	var y = vision_ds_Image.get_height(image);
	var maxGval = 0;
	var edgeColors = [];
	var maxGradient = -1;
	var _g = 1;
	var _g1 = x - 1;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 1;
		var _g3 = y - 1;
		while(_g2 < _g3) {
			var j = _g2++;
			var val00 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i - 1,j - 1)) >> 16 & 255;
			var val01 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i - 1,j)) >> 16 & 255;
			var val02 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i - 1,j + 1)) >> 16 & 255;
			var val10 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i,j - 1)) >> 16 & 255;
			var val11 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i,j)) >> 16 & 255;
			var val12 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i,j + 1)) >> 16 & 255;
			var val20 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i + 1,j - 1)) >> 16 & 255;
			var val21 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i + 1,j)) >> 16 & 255;
			var val22 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i + 1,j + 1)) >> 16 & 255;
			var gx = -1 * val00 + 0 * val01 + val02 + (-2 * val10 + 0 * val11 + 2 * val12) + (-1 * val20 + 0 * val21 + val22);
			var gy = -1 * val00 + -2 * val01 + -1 * val02 + (0 * val10 + 0 * val11 + 0 * val12) + (val20 + 2 * val21 + val22);
			var gval = Math.sqrt(gx * gx + gy * gy);
			var g = gval | 0;
			if(maxGradient < g) {
				maxGradient = g;
			}
			if(edgeColors[i] == null) {
				edgeColors[i] = [];
			}
			edgeColors[i][j] = g;
		}
	}
	var scale = 255.0 / maxGradient;
	var edgeImage = vision_ds_Image._new(vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var _g = 1;
	var _g1 = x - 1;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 1;
		var _g3 = y - 1;
		while(_g2 < _g3) {
			var j = _g2++;
			var edgeColor = edgeColors[i][j];
			edgeColor = edgeColor * scale | 0;
			edgeColor = -16777216 | edgeColor << 16 | edgeColor << 8 | edgeColor;
			vision_ds_Image.setPixel(edgeImage,i,j,edgeColor);
		}
	}
	return edgeImage;
};
var vision_algorithms_SimpleLineDetector = function() { };
vision_algorithms_SimpleLineDetector.__name__ = true;
vision_algorithms_SimpleLineDetector.findLineFromPoint = function(image,point,minLineGap,minLineLength,preferTTB,preferRTL) {
	if(preferRTL == null) {
		preferRTL = false;
	}
	if(preferTTB == null) {
		preferTTB = false;
	}
	var startX = vision_ds_IntPoint2D.get_x(point);
	var startY = vision_ds_IntPoint2D.get_y(point);
	var yArr = preferTTB ? [0,1,2] : [0,-1,-2];
	var xArr = preferRTL ? [0,-1,-2] : [0,1,2];
	if(vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point)) == null || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point))[vision_ds_IntPoint2D.get_y(point)] == null || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point))[vision_ds_IntPoint2D.get_y(point)] == 0) {
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
				if(X == 0 && Y == 0 || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point) + X) == null || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point) + X)[vision_ds_IntPoint2D.get_y(point) + Y] == null) {
					continue;
				}
				if((vision_ds_Image.getPixel(image,vision_ds_IntPoint2D.get_x(point) + X,vision_ds_IntPoint2D.get_y(point) + Y) & 16777215) == 16777215) {
					var x = vision_ds_IntPoint2D.get_x(point) + X;
					var this1 = new haxe__$Int64__$_$_$Int64(x,vision_ds_IntPoint2D.get_y(point));
					point = this1;
					var y = vision_ds_IntPoint2D.get_y(point) + Y;
					var this2 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(point),y);
					point = this2;
					if(prev == null) {
						prev = new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(point),vision_ds_IntPoint2D.get_y(point));
					} else {
						prev2 = new vision_ds_Point2D(prev.x,prev.y);
						prev = new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(point),vision_ds_IntPoint2D.get_y(point));
					}
					if((preferTTB ? Y : X) == 0) {
						if(vision_ds_IntPoint2D.get_x(point) == prev.x && vision_ds_IntPoint2D.get_y(point) == prev.y || vision_ds_IntPoint2D.get_x(point) == prev2.x && vision_ds_IntPoint2D.get_y(point) == prev2.y) {
							return;
						}
						haxe_Log.trace(point == null ? "null" : vision_ds_IntPoint2D.toString(point),{ fileName : "src/vision/algorithms/SimpleLineDetector.hx", lineNumber : 42, className : "vision.algorithms.SimpleLineDetector", methodName : "findLineFromPoint", customParams : [prev,prev2]});
					}
					expand();
				}
			}
		}
	};
	expand();
	var line = new vision_ds_Line2D(new vision_ds_Point2D(startX,startY),vision_ds_IntPoint2D.toPoint2D(point));
	if(line.get_length() > minLineLength) {
		return line;
	}
	return null;
};
vision_algorithms_SimpleLineDetector.lineCoveragePercentage = function(image,line) {
	var coveredPixels = 0;
	var totalPixels = 0;
	if(line == null) {
		return 0;
	}
	var p1 = vision_ds_IntPoint2D.fromPoint2D(line.start);
	var p2 = vision_ds_IntPoint2D.fromPoint2D(line.end);
	var x1 = vision_ds_IntPoint2D.get_x(p1);
	var y1 = vision_ds_IntPoint2D.get_y(p1);
	var x2 = vision_ds_IntPoint2D.get_x(p2);
	var y2 = vision_ds_IntPoint2D.get_y(p2);
	var dx = Math.abs(x2 - x1);
	var dy = Math.abs(y2 - y1);
	var sx = x1 < x2 ? 1 : -1;
	var sy = y1 < y2 ? 1 : -1;
	var err = dx - dy;
	while(true) {
		if(vision_ds_Image.hasPixel(image,x1,y1)) {
			if((vision_ds_Image.getPixel(image,x1 | 0,y1 | 0) & 16777215) == 16777215) {
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
var vision_algorithms_Sobel = function() { };
vision_algorithms_Sobel.__name__ = true;
vision_algorithms_Sobel.convolveWithSobelOperator = function(image) {
	var edgeColors = [];
	var maxGradient = -1;
	var _g = 1;
	var _g1 = vision_ds_Image.get_width(image) - 1;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_height(image) - 1;
		while(_g2 < _g3) {
			var j = _g2++;
			var val00 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i - 1,j - 1)) >> 16 & 255;
			var val01 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i - 1,j)) >> 16 & 255;
			var val02 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i - 1,j + 1)) >> 16 & 255;
			var val10 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i,j - 1)) >> 16 & 255;
			var val11 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i,j)) >> 16 & 255;
			var val12 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i,j + 1)) >> 16 & 255;
			var val20 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i + 1,j - 1)) >> 16 & 255;
			var val21 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i + 1,j)) >> 16 & 255;
			var val22 = vision_tools_ImageTools.grayscalePixel(vision_ds_Image.getPixel(image,i + 1,j + 1)) >> 16 & 255;
			var gx = -3 * val00 + 0 * val01 + 3 * val02 + (-10 * val10 + 0 * val11 + 10 * val12) + (-3 * val20 + 0 * val21 + 3 * val22);
			var gy = -3 * val00 + -10 * val01 + -3 * val02 + (0 * val10 + 0 * val11 + 0 * val12) + (3 * val20 + 10 * val21 + 3 * val22);
			var gval = Math.sqrt(gx * gx + gy * gy);
			var g = gval | 0;
			if(maxGradient < g) {
				maxGradient = g;
			}
			if(edgeColors[i] == null) {
				edgeColors[i] = [];
			}
			edgeColors[i][j] = g;
		}
	}
	var scale = 255.0 / maxGradient;
	var edgeImage = vision_ds_Image._new(vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var _g = 1;
	var _g1 = vision_ds_Image.get_width(image) - 1;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 1;
		var _g3 = vision_ds_Image.get_height(image) - 1;
		while(_g2 < _g3) {
			var j = _g2++;
			var edgeColor = edgeColors[i][j];
			edgeColor = edgeColor * scale | 0;
			edgeColor = -16777216 | edgeColor << 16 | edgeColor << 8 | edgeColor;
			vision_ds_Image.setPixel(edgeImage,i,j,edgeColor);
		}
	}
	return edgeImage;
};
var vision_ds_Color = {};
vision_ds_Color._new = function(value) {
	if(value == null) {
		value = 0;
	}
	var this1 = value;
	return this1;
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
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,vision_ds_IntPoint2D.toPoint2D(vision_ds_IntPoint2D._new(x,y))));
	}
	return this1[x][y];
};
vision_ds_Image.setPixel = function(this1,x,y,color) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,vision_ds_IntPoint2D.toPoint2D(vision_ds_IntPoint2D._new(x,y))));
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
vision_ds_Image.paintPixel = function(this1,x,y,color) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,vision_ds_IntPoint2D.toPoint2D(vision_ds_IntPoint2D._new(x,y))));
	}
	var oldColor = this1[x][y];
	var Red = (color >> 16 & 255) / 255 * ((color >> 24 & 255) / 255) + (oldColor >> 16 & 255) / 255 * (1 - (color >> 24 & 255) / 255);
	var Green = (color >> 8 & 255) / 255 * ((color >> 24 & 255) / 255) + (oldColor >> 8 & 255) / 255 * (1 - (color >> 24 & 255) / 255);
	var Blue = (color & 255) / 255 * ((color >> 24 & 255) / 255) + (oldColor & 255) / 255 * (1 - (color >> 24 & 255) / 255);
	var Alpha = 1;
	if(Alpha == null) {
		Alpha = 1;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 1;
	}
	var value = Math.round(Red * 255);
	color &= -16711681;
	color |= (value > 255 ? 255 : value < 0 ? 0 : value) << 16;
	var value = Math.round(Green * 255);
	color &= -65281;
	color |= (value > 255 ? 255 : value < 0 ? 0 : value) << 8;
	var value = Math.round(Blue * 255);
	color &= -256;
	color |= value > 255 ? 255 : value < 0 ? 0 : value;
	var value = Math.round(Alpha1 * 255);
	color &= 16777215;
	color |= (value > 255 ? 255 : value < 0 ? 0 : value) << 24;
	var newColor = color;
	vision_ds_Image.setPixel(this1,x,y,newColor);
};
vision_ds_Image.drawRay2D = function(this1,line,color) {
	var p1 = vision_ds_IntPoint2D.fromPoint2D(line.getPointAtY(0));
	var p2 = vision_ds_IntPoint2D.fromPoint2D(line.getPointAtY(vision_ds_Image.get_height(this1) - 1));
	var x1 = vision_ds_IntPoint2D.get_x(p1);
	var y1 = vision_ds_IntPoint2D.get_y(p1);
	var x2 = vision_ds_IntPoint2D.get_x(p2);
	var y2 = vision_ds_IntPoint2D.get_y(p2);
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
vision_ds_Image.drawLine2D = function(this1,line,color) {
	var p1 = vision_ds_IntPoint2D.fromPoint2D(line.start);
	var p2 = vision_ds_IntPoint2D.fromPoint2D(line.end);
	var x1 = vision_ds_IntPoint2D.get_x(p1);
	var y1 = vision_ds_IntPoint2D.get_y(p1);
	var x2 = vision_ds_IntPoint2D.get_x(p2);
	var y2 = vision_ds_IntPoint2D.get_y(p2);
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
vision_ds_Image.mirror = function(this1) {
	this1.sort(function(e,f) {
		return 1;
	});
	return this1;
};
vision_ds_Image.image_array_read = function(this1,index) {
	return this1[index];
};
var vision_ds_IntPoint2D = {};
vision_ds_IntPoint2D._new = function(X,Y) {
	var this1 = new haxe__$Int64__$_$_$Int64(X,Y);
	var this2 = this1;
	return this2;
};
vision_ds_IntPoint2D.get_y = function(this1) {
	return this1.low;
};
vision_ds_IntPoint2D.get_x = function(this1) {
	return this1.high;
};
vision_ds_IntPoint2D.toPoint2D = function(this1) {
	return new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(this1),vision_ds_IntPoint2D.get_y(this1));
};
vision_ds_IntPoint2D.fromPoint2D = function(p) {
	return vision_ds_IntPoint2D._new(p.x | 0,p.y | 0);
};
vision_ds_IntPoint2D.toString = function(this1) {
	return "(" + vision_ds_IntPoint2D.get_x(this1) + ", " + vision_ds_IntPoint2D.get_y(this1) + ")";
};
var vision_ds_Kernal2D = $hxEnums["vision.ds.Kernal2D"] = { __ename__:true,__constructs__:null
	,Identity: {_hx_name:"Identity",_hx_index:0,__enum__:"vision.ds.Kernal2D",toString:$estr}
	,BoxBlur: {_hx_name:"BoxBlur",_hx_index:1,__enum__:"vision.ds.Kernal2D",toString:$estr}
	,RidgeDetection: {_hx_name:"RidgeDetection",_hx_index:2,__enum__:"vision.ds.Kernal2D",toString:$estr}
	,RidgeDetectionAggresive: {_hx_name:"RidgeDetectionAggresive",_hx_index:3,__enum__:"vision.ds.Kernal2D",toString:$estr}
	,Sharpen: {_hx_name:"Sharpen",_hx_index:4,__enum__:"vision.ds.Kernal2D",toString:$estr}
	,UnsharpMasking: {_hx_name:"UnsharpMasking",_hx_index:5,__enum__:"vision.ds.Kernal2D",toString:$estr}
	,Assemble3x3: ($_=function(corner,edge,center) { return {_hx_index:6,corner:corner,edge:edge,center:center,__enum__:"vision.ds.Kernal2D",toString:$estr}; },$_._hx_name="Assemble3x3",$_.__params__ = ["corner","edge","center"],$_)
	,Assemble5x5: ($_=function(farCorner,farEdge,edge,midCorner,midEdge,center) { return {_hx_index:7,farCorner:farCorner,farEdge:farEdge,edge:edge,midCorner:midCorner,midEdge:midEdge,center:center,__enum__:"vision.ds.Kernal2D",toString:$estr}; },$_._hx_name="Assemble5x5",$_.__params__ = ["farCorner","farEdge","edge","midCorner","midEdge","center"],$_)
	,Custom: ($_=function(kernal) { return {_hx_index:8,kernal:kernal,__enum__:"vision.ds.Kernal2D",toString:$estr}; },$_._hx_name="Custom",$_.__params__ = ["kernal"],$_)
	,GaussianBlur: ($_=function(size,sigma) { return {_hx_index:9,size:size,sigma:sigma,__enum__:"vision.ds.Kernal2D",toString:$estr}; },$_._hx_name="GaussianBlur",$_.__params__ = ["size","sigma"],$_)
};
vision_ds_Kernal2D.__constructs__ = [vision_ds_Kernal2D.Identity,vision_ds_Kernal2D.BoxBlur,vision_ds_Kernal2D.RidgeDetection,vision_ds_Kernal2D.RidgeDetectionAggresive,vision_ds_Kernal2D.Sharpen,vision_ds_Kernal2D.UnsharpMasking,vision_ds_Kernal2D.Assemble3x3,vision_ds_Kernal2D.Assemble5x5,vision_ds_Kernal2D.Custom,vision_ds_Kernal2D.GaussianBlur];
var vision_ds_Line2D = function(start,end) {
	this.end = new vision_ds_Point2D(0,0);
	this.start = new vision_ds_Point2D(0,0);
	this.start.x = start.x;
	this.start.y = start.y;
	this.end.x = end.x;
	this.end.y = end.y;
	this.set_radians(vision_tools_MathTools.radiansFromPointToPoint(start,end));
};
vision_ds_Line2D.__name__ = true;
vision_ds_Line2D.prototype = {
	get_length: function() {
		return Math.sqrt(Math.pow(this.end.x - this.start.x,2) + Math.pow(this.end.y - this.start.y,2));
	}
	,set_radians: function(value) {
		this.slope = Math.tan(value);
		this.degrees = value * 180 / vision_tools_MathTools.get_PI();
		return this.radians = value;
	}
	,mirrorInsideRectangle: function(rect) {
		var diffSX = this.start.x - rect.x;
		var diffEX = this.end.x - rect.x;
		this.start.x = rect.x + rect.width - diffSX;
		this.end.x = rect.x + rect.width - diffEX;
		return this;
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
		this.set_degrees(Math.atan(m) * 180 / vision_tools_MathTools.get_PI());
		this.set_radians(Math.atan(m));
	} else if(degrees != null) {
		this.set_degrees(degrees);
		this.set_slope(Math.tan(degrees * vision_tools_MathTools.get_PI() / 180));
		this.set_radians(degrees * vision_tools_MathTools.get_PI() / 180);
	} else if(radians != null) {
		this.set_radians(radians);
		this.set_slope(Math.tan(radians));
		this.set_degrees(radians * 180 / vision_tools_MathTools.get_PI());
	}
};
vision_ds_Ray2D.__name__ = true;
vision_ds_Ray2D.prototype = {
	set_slope: function(value) {
		this.degrees = Math.atan(value) * 180 / vision_tools_MathTools.get_PI();
		this.radians = Math.atan(value);
		return this.slope = value;
	}
	,set_degrees: function(value) {
		this.slope = Math.tan(value * vision_tools_MathTools.get_PI() / 180);
		this.radians = value * vision_tools_MathTools.get_PI() / 180;
		return this.degrees = value;
	}
	,set_radians: function(value) {
		this.slope = Math.tan(value);
		this.degrees = value * 180 / vision_tools_MathTools.get_PI();
		return this.radians = value;
	}
	,get_yIntercept: function() {
		var px = this.point.x;
		var py = this.point.y;
		if(px > 0) {
			return py - this.slope * px;
		}
		return py + this.slope * px;
	}
	,getPointAtX: function(x) {
		return new vision_ds_Point2D(x,this.slope * x + this.get_yIntercept());
	}
	,getPointAtY: function(y) {
		return new vision_ds_Point2D((y - this.get_yIntercept()) / this.slope,y);
	}
	,findPointWithDistance: function(startXPos,distance,goPositive) {
		if(goPositive == null) {
			goPositive = true;
		}
		distance = Math.abs(distance);
		var start = this.getPointAtX(startXPos);
		var step = vision_tools_MathTools.distanceBetweenPoints(this.getPointAtX(start.y + 1),start);
		var diff = distance / step;
		return this.getPointAtY(start.y + (goPositive ? diff : -diff));
	}
};
var vision_ds_hough_HoughAccumulator = {};
vision_ds_hough_HoughAccumulator.get_rhoMax = function(this1) {
	return this1.length / 2 | 0;
};
vision_ds_hough_HoughAccumulator._new = function(maxRho) {
	var this1 = [];
	var _g = [];
	var _g1 = 0;
	while(_g1 < 180) {
		var i = _g1++;
		_g.push(0);
	}
	var arrayOfZeros = _g;
	var _g = 0;
	var _g1 = maxRho * 2;
	while(_g < _g1) {
		var i = _g++;
		this1[i] = arrayOfZeros.slice();
	}
	return this1;
};
vision_ds_hough_HoughAccumulator.incrementCell = function(this1,rho,thetaIndex) {
	var this2 = this1[(rho | 0) + vision_ds_hough_HoughAccumulator.get_rhoMax(this1)];
	this2[thetaIndex]++;
};
vision_ds_hough_HoughAccumulator.getMaximas = function(this1,threshold) {
	var pointArray = [];
	var _g = 0;
	var _g1 = this1.length;
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = this1[x].length;
		while(_g2 < _g3) {
			var y = _g2++;
			if(this1[x][y] >= threshold) {
				pointArray.push(vision_ds_IntPoint2D._new(x - vision_ds_hough_HoughAccumulator.get_rhoMax(this1),y));
			}
		}
	}
	return pointArray;
};
vision_ds_hough_HoughAccumulator.cellIterator = function(this1,threshold) {
	if(threshold == null) {
		threshold = 0;
	}
	return new haxe_iterators_ArrayIterator(vision_ds_hough_HoughAccumulator.getMaximas(this1,threshold));
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
var vision_tools_ImageTools = function() { };
vision_tools_ImageTools.__name__ = true;
vision_tools_ImageTools.loadFromFile = function(image,path,onComplete) {
	var imgElement = window.document.createElement("img");
	imgElement.src = path;
	imgElement.crossOrigin = "Anonymus";
	imgElement.onload = function() {
		var canvas = window.document.createElement("canvas");
		canvas.width = imgElement.width;
		canvas.height = imgElement.height;
		canvas.getContext("2d",null).drawImage(imgElement,0,0);
		haxe_Log.trace(imgElement.width,{ fileName : "src/vision/tools/ImageTools.hx", lineNumber : 75, className : "vision.tools.ImageTools", methodName : "loadFromFile", customParams : [imgElement.height,imgElement.naturalWidth,imgElement.naturalHeight]});
		if(image == null) {
			image = vision_ds_Image._new(imgElement.width,imgElement.height);
		}
		var imageData = canvas.getContext("2d",null).getImageData(0,0,vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
		var i = 0;
		while(i < imageData.data.length) {
			var r = imageData.data[i];
			var g = imageData.data[i + 1];
			var b = imageData.data[i + 2];
			var a = imageData.data[i + 3];
			var x = Math.floor(i / 4 % imageData.width);
			var y = Math.floor(i / 4 / imageData.width);
			var image1 = image;
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
			vision_ds_Image.setPixel(image1,x,y,color);
			i += 4;
		}
		onComplete(image);
	};
};
vision_tools_ImageTools.getNeighborsOfPixel = function(image,x,y,radius) {
	var neighbors = [];
	var _g = 0;
	var _g1 = radius + 1;
	while(_g < _g1) {
		var i = _g++;
		neighbors[i] = [];
	}
	var roundedDown = (radius - 1) / 2 | 0;
	var _g = -roundedDown;
	var _g1 = roundedDown + 1;
	while(_g < _g1) {
		var X = _g++;
		var _g2 = -roundedDown;
		var _g3 = roundedDown + 1;
		while(_g2 < _g3) {
			var Y = _g2++;
			if(x + X < 0 || x + X >= vision_ds_Image.get_width(image) || y + Y < 0 || y + Y >= vision_ds_Image.get_height(image)) {
				var gettable = vision_ds_IntPoint2D._new(0,0);
				var ox = x + X;
				var oy = y + Y;
				if(ox < 0 && oy < 0) {
					var this1 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),0);
					gettable = this1;
					var x1 = 0;
					var this2 = new haxe__$Int64__$_$_$Int64(x1,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this2;
				} else if(ox < 0 && oy >= vision_ds_Image.get_height(image)) {
					var this3 = new haxe__$Int64__$_$_$Int64(0,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this3;
					var y1 = vision_ds_Image.get_height(image) - 1;
					var this4 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),y1);
					gettable = this4;
				} else if(ox >= vision_ds_Image.get_width(image) && oy < 0) {
					var x2 = vision_ds_Image.get_width(image) - 1;
					var this5 = new haxe__$Int64__$_$_$Int64(x2,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this5;
					var this6 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),0);
					gettable = this6;
				} else if(ox >= vision_ds_Image.get_width(image) && oy >= vision_ds_Image.get_height(image)) {
					var x3 = vision_ds_Image.get_width(image) - 1;
					var this7 = new haxe__$Int64__$_$_$Int64(x3,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this7;
					var y2 = vision_ds_Image.get_height(image) - 1;
					var this8 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),y2);
					gettable = this8;
				} else if(ox < 0) {
					var this9 = new haxe__$Int64__$_$_$Int64(0,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this9;
					var this10 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),oy);
					gettable = this10;
				} else if(oy < 0) {
					var this11 = new haxe__$Int64__$_$_$Int64(ox,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this11;
					var this12 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),0);
					gettable = this12;
				} else if(ox >= vision_ds_Image.get_width(image)) {
					var x4 = vision_ds_Image.get_width(image) - 1;
					var this13 = new haxe__$Int64__$_$_$Int64(x4,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this13;
					var this14 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),oy);
					gettable = this14;
				} else if(oy >= vision_ds_Image.get_height(image)) {
					var this15 = new haxe__$Int64__$_$_$Int64(ox,vision_ds_IntPoint2D.get_y(gettable));
					gettable = this15;
					var y3 = vision_ds_Image.get_height(image) - 1;
					var this16 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(gettable),y3);
					gettable = this16;
				}
				var tmp = vision_ds_Image.getPixel(image,vision_ds_IntPoint2D.get_x(gettable),vision_ds_IntPoint2D.get_y(gettable));
				neighbors[X + roundedDown].push(tmp);
				continue;
			}
			var tmp1 = vision_ds_Image.getPixel(image,x + X,y + Y);
			neighbors[X + roundedDown].push(tmp1);
		}
	}
	return neighbors;
};
vision_tools_ImageTools.grayscalePixel = function(pixel) {
	var gray = ((pixel >> 16 & 255) + (pixel >> 8 & 255) + (pixel & 255)) / 3 | 0;
	var Alpha = pixel >> 24 & 255;
	if(Alpha == null) {
		Alpha = 255;
	}
	var color = vision_ds_Color._new();
	var Alpha1 = Alpha;
	if(Alpha1 == null) {
		Alpha1 = 255;
	}
	color &= -16711681;
	color |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 16;
	color &= -65281;
	color |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 8;
	color &= -256;
	color |= gray > 255 ? 255 : gray < 0 ? 0 : gray;
	color &= 16777215;
	color |= (Alpha1 > 255 ? 255 : Alpha1 < 0 ? 0 : Alpha1) << 24;
	return color;
};
var vision_tools_MathTools = function() { };
vision_tools_MathTools.__name__ = true;
vision_tools_MathTools.radiansFromPointToPoint = function(point1,point2) {
	var x = point2.x - point1.x;
	var y = point2.y - point1.y;
	return Math.atan2(x,y);
};
vision_tools_MathTools.distanceBetweenPoints = function(point1,point2) {
	var x = point2.x - point1.x;
	var y = point2.y - point1.y;
	return Math.sqrt(x * x + y * y);
};
vision_tools_MathTools.wrapInt = function(value,min,max) {
	var range = max - min + 1;
	if(value < min) {
		value += range * ((min - value) / range + 1 | 0);
	}
	return min + (value - min) % range;
};
vision_tools_MathTools.turnicate = function(num,numbersAfterDecimal) {
	var multiplier = Math.pow(10,numbersAfterDecimal);
	return Math.round(num * multiplier) / multiplier;
};
vision_tools_MathTools.get_PI = function() {
	return Math.PI;
};
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
Main.main();
})({});

//# sourceMappingURL=main.js.map