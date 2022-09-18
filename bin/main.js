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
		Main.printImage(vision_Vision.blackAndWhite(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Black and white took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 41, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.grayscale(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Grayscale took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 45, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.contrast(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Contrast took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 49, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_ds_Image.clone(image));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Image Cloning took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 53, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.Identity));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Identity Convolution took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 59, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.BoxBlur));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("BoxBlur Convolution took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 63, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.RidgeDetection));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Ridge Detection Convolution took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 67, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.RidgeDetectionAggresive));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Aggresive Ridge Detection Convolution took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 71, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.Sharpen));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Shaprening Convolution took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 75, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.convolve(vision_ds_Image.clone(image),vision_ds_Kernal2D.UnsharpMasking));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Unsharp Masking Convolution took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 79, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.deepfry(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Deepfrying took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 83, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.sobelEdgeDiffOperator(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Sobel Filter took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 88, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Sobel edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 92, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		var hough = vision_algorithms_Hough.toHoughSpace(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
		Main.printImage(hough.image);
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Hough transform took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 97, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Perwitt edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 101, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		var canny = vision_Vision.cannyEdgeDetection(vision_ds_Image.clone(image));
		Main.printImage(canny);
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Canny edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 106, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.nearestNeighborBlur(vision_ds_Image.clone(image),1));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Nearest neighbor blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 110, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_Vision.gaussianBlur(vision_ds_Image.clone(image),2,15));
		end = HxOverrides.now() / 1000;
		haxe_Log.trace("Gaussian blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 114, className : "Main", methodName : "main"});
		start = HxOverrides.now() / 1000;
		Main.printImage(vision_ds_Image.mirror(vision_ds_Image.clone(image)));
		end = HxOverrides.now() / 1000;
	});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).getPointAtX(8),{ fileName : "src/Main.hx", lineNumber : 176, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).slope,{ fileName : "src/Main.hx", lineNumber : 177, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).degrees,{ fileName : "src/Main.hx", lineNumber : 178, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).radians,{ fileName : "src/Main.hx", lineNumber : 179, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).getPointAtY(8),{ fileName : "src/Main.hx", lineNumber : 180, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).get_yIntercept(),{ fileName : "src/Main.hx", lineNumber : 181, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).get_xIntercept(),{ fileName : "src/Main.hx", lineNumber : 182, className : "Main", methodName : "main"});
	var queue = new vision_ds_Queue();
	queue.enqueue(0);
	queue.enqueue(1);
	queue.enqueue(2);
	queue.enqueue(3);
	haxe_Log.trace(queue.toString(),{ fileName : "src/Main.hx", lineNumber : 188, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.dequeue(),{ fileName : "src/Main.hx", lineNumber : 189, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.dequeue(),{ fileName : "src/Main.hx", lineNumber : 190, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.dequeue(),{ fileName : "src/Main.hx", lineNumber : 191, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.toString(),{ fileName : "src/Main.hx", lineNumber : 192, className : "Main", methodName : "main"});
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
vision_Vision.contrast = function(image) {
	return vision_Vision.convolve(image,vision_ds_Kernal2D.UnsharpMasking);
};
vision_Vision.sharpen = function(image) {
	return vision_Vision.convolve(image,vision_ds_Kernal2D.Sharpen);
};
vision_Vision.deepfry = function(image,iterations) {
	if(iterations == null) {
		iterations = 2;
	}
	var _g = 0;
	var _g1 = iterations;
	while(_g < _g1) {
		var i = _g++;
		image = vision_Vision.sharpen(image);
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
		matrix = [[-1,-1,-1],[-1,6,-1],[-1,-1,-1]];
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
	haxe_Log.trace(flatMatrix.length,{ fileName : "src/vision/Vision.hx", lineNumber : 218, className : "vision.Vision", methodName : "convolve"});
	image = convolved;
	return image;
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
					var value = (newColor >> 16 & 255) + (red | 0);
					newColor &= -16711681;
					newColor |= (value > 255 ? 255 : value < 0 ? 0 : value) << 16;
					var value1 = (newColor >> 8 & 255) + (green | 0);
					newColor &= -65281;
					newColor |= (value1 > 255 ? 255 : value1 < 0 ? 0 : value1) << 8;
					var value2 = (newColor & 255) + (blue | 0);
					newColor &= -256;
					newColor |= value2 > 255 ? 255 : value2 < 0 ? 0 : value2;
				}
			}
			vision_ds_Image.setPixel(blurredImage,x,y,newColor);
		}
	}
	return blurredImage;
};
vision_Vision.cannyEdgeDetection = function(image,sigma,initialKernalSize,lowThreshold,highThreshold) {
	if(highThreshold == null) {
		highThreshold = 0.6;
	}
	if(lowThreshold == null) {
		lowThreshold = 0.4;
	}
	if(initialKernalSize == null) {
		initialKernalSize = 5;
	}
	if(sigma == null) {
		sigma = 1;
	}
	var cannyObject = vision_ds_Image.clone(image);
	return vision_algorithms_Canny.applyHysteresis(vision_algorithms_Canny.nonMaxSuppression(vision_algorithms_Canny.applySobelFilters(vision_algorithms_Canny.applyGaussian(vision_algorithms_Canny.grayscale(cannyObject),initialKernalSize,sigma))),highThreshold,lowThreshold);
};
vision_Vision.sobelEdgeDiffOperator = function(image) {
	return vision_algorithms_Sobel.convolveWithSobelOperator(vision_Vision.grayscale(vision_ds_Image.clone(image)));
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
	var filtered = vision_ds_Image._new(vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var yFilter_0_0 = -3;
	var yFilter_0_1 = 0;
	var yFilter_0_2 = 3;
	var yFilter_1_0 = -10;
	var yFilter_1_1 = 0;
	var yFilter_1_2 = 10;
	var yFilter_2_0 = -3;
	var yFilter_2_1 = 0;
	var yFilter_2_2 = 3;
	var xFilter_0_0 = -3;
	var xFilter_0_1 = -10;
	var xFilter_0_2 = -3;
	var xFilter_1_0 = 0;
	var xFilter_1_1 = 0;
	var xFilter_1_2 = 0;
	var xFilter_2_0 = 3;
	var xFilter_2_1 = 10;
	var xFilter_2_2 = 3;
	var ghs = 0;
	var gvs = 0;
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			gvs = 0;
			ghs = gvs;
			var neighbors = vision_algorithms_Canny.getNeighbors(3,x,y,image);
			var lhs = yFilter_0_0;
			var rhs = neighbors[0][0] & 16777215;
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
			var value = Math.round(Red * 255);
			color &= -16711681;
			color |= (value > 255 ? 255 : value < 0 ? 0 : value) << 16;
			var value1 = Math.round(Green * 255);
			color &= -65281;
			color |= (value1 > 255 ? 255 : value1 < 0 ? 0 : value1) << 8;
			var value2 = Math.round(Blue * 255);
			color &= -256;
			color |= value2 > 255 ? 255 : value2 < 0 ? 0 : value2;
			var value3 = Math.round(Alpha1 * 255);
			color &= 16777215;
			color |= (value3 > 255 ? 255 : value3 < 0 ? 0 : value3) << 24;
			var rhs1 = color;
			var Red1 = (ghs >> 16 & 255) + (rhs1 >> 16 & 255);
			var Green1 = (ghs >> 8 & 255) + (rhs1 >> 8 & 255);
			var Blue1 = (ghs & 255) + (rhs1 & 255);
			var Alpha2 = (ghs >> 24 & 255) + (rhs1 >> 24 & 255);
			if(Alpha2 == null) {
				Alpha2 = 255;
			}
			var color1 = vision_ds_Color._new();
			var Alpha3 = Alpha2;
			if(Alpha3 == null) {
				Alpha3 = 255;
			}
			color1 &= -16711681;
			color1 |= (Red1 > 255 ? 255 : Red1 < 0 ? 0 : Red1) << 16;
			color1 &= -65281;
			color1 |= (Green1 > 255 ? 255 : Green1 < 0 ? 0 : Green1) << 8;
			color1 &= -256;
			color1 |= Blue1 > 255 ? 255 : Blue1 < 0 ? 0 : Blue1;
			color1 &= 16777215;
			color1 |= (Alpha3 > 255 ? 255 : Alpha3 < 0 ? 0 : Alpha3) << 24;
			ghs = color1;
			var lhs1 = xFilter_0_0;
			var rhs2 = neighbors[0][0] & 16777215;
			var Red2 = (lhs1 >> 16 & 255) / 255 * ((rhs2 >> 16 & 255) / 255);
			var Green2 = (lhs1 >> 8 & 255) / 255 * ((rhs2 >> 8 & 255) / 255);
			var Blue2 = (lhs1 & 255) / 255 * ((rhs2 & 255) / 255);
			var Alpha4 = (lhs1 >> 24 & 255) / 255 * ((rhs2 >> 24 & 255) / 255);
			if(Alpha4 == null) {
				Alpha4 = 1;
			}
			var color2 = vision_ds_Color._new();
			var Alpha5 = Alpha4;
			if(Alpha5 == null) {
				Alpha5 = 1;
			}
			var value4 = Math.round(Red2 * 255);
			color2 &= -16711681;
			color2 |= (value4 > 255 ? 255 : value4 < 0 ? 0 : value4) << 16;
			var value5 = Math.round(Green2 * 255);
			color2 &= -65281;
			color2 |= (value5 > 255 ? 255 : value5 < 0 ? 0 : value5) << 8;
			var value6 = Math.round(Blue2 * 255);
			color2 &= -256;
			color2 |= value6 > 255 ? 255 : value6 < 0 ? 0 : value6;
			var value7 = Math.round(Alpha5 * 255);
			color2 &= 16777215;
			color2 |= (value7 > 255 ? 255 : value7 < 0 ? 0 : value7) << 24;
			var rhs3 = color2;
			var Red3 = (gvs >> 16 & 255) + (rhs3 >> 16 & 255);
			var Green3 = (gvs >> 8 & 255) + (rhs3 >> 8 & 255);
			var Blue3 = (gvs & 255) + (rhs3 & 255);
			var Alpha6 = (gvs >> 24 & 255) + (rhs3 >> 24 & 255);
			if(Alpha6 == null) {
				Alpha6 = 255;
			}
			var color3 = vision_ds_Color._new();
			var Alpha7 = Alpha6;
			if(Alpha7 == null) {
				Alpha7 = 255;
			}
			color3 &= -16711681;
			color3 |= (Red3 > 255 ? 255 : Red3 < 0 ? 0 : Red3) << 16;
			color3 &= -65281;
			color3 |= (Green3 > 255 ? 255 : Green3 < 0 ? 0 : Green3) << 8;
			color3 &= -256;
			color3 |= Blue3 > 255 ? 255 : Blue3 < 0 ? 0 : Blue3;
			color3 &= 16777215;
			color3 |= (Alpha7 > 255 ? 255 : Alpha7 < 0 ? 0 : Alpha7) << 24;
			gvs = color3;
			var lhs2 = yFilter_0_1;
			var rhs4 = neighbors[0][1] & 16777215;
			var Red4 = (lhs2 >> 16 & 255) / 255 * ((rhs4 >> 16 & 255) / 255);
			var Green4 = (lhs2 >> 8 & 255) / 255 * ((rhs4 >> 8 & 255) / 255);
			var Blue4 = (lhs2 & 255) / 255 * ((rhs4 & 255) / 255);
			var Alpha8 = (lhs2 >> 24 & 255) / 255 * ((rhs4 >> 24 & 255) / 255);
			if(Alpha8 == null) {
				Alpha8 = 1;
			}
			var color4 = vision_ds_Color._new();
			var Alpha9 = Alpha8;
			if(Alpha9 == null) {
				Alpha9 = 1;
			}
			var value8 = Math.round(Red4 * 255);
			color4 &= -16711681;
			color4 |= (value8 > 255 ? 255 : value8 < 0 ? 0 : value8) << 16;
			var value9 = Math.round(Green4 * 255);
			color4 &= -65281;
			color4 |= (value9 > 255 ? 255 : value9 < 0 ? 0 : value9) << 8;
			var value10 = Math.round(Blue4 * 255);
			color4 &= -256;
			color4 |= value10 > 255 ? 255 : value10 < 0 ? 0 : value10;
			var value11 = Math.round(Alpha9 * 255);
			color4 &= 16777215;
			color4 |= (value11 > 255 ? 255 : value11 < 0 ? 0 : value11) << 24;
			var rhs5 = color4;
			var Red5 = (ghs >> 16 & 255) + (rhs5 >> 16 & 255);
			var Green5 = (ghs >> 8 & 255) + (rhs5 >> 8 & 255);
			var Blue5 = (ghs & 255) + (rhs5 & 255);
			var Alpha10 = (ghs >> 24 & 255) + (rhs5 >> 24 & 255);
			if(Alpha10 == null) {
				Alpha10 = 255;
			}
			var color5 = vision_ds_Color._new();
			var Alpha11 = Alpha10;
			if(Alpha11 == null) {
				Alpha11 = 255;
			}
			color5 &= -16711681;
			color5 |= (Red5 > 255 ? 255 : Red5 < 0 ? 0 : Red5) << 16;
			color5 &= -65281;
			color5 |= (Green5 > 255 ? 255 : Green5 < 0 ? 0 : Green5) << 8;
			color5 &= -256;
			color5 |= Blue5 > 255 ? 255 : Blue5 < 0 ? 0 : Blue5;
			color5 &= 16777215;
			color5 |= (Alpha11 > 255 ? 255 : Alpha11 < 0 ? 0 : Alpha11) << 24;
			ghs = color5;
			var lhs3 = xFilter_0_1;
			var rhs6 = neighbors[0][1] & 16777215;
			var Red6 = (lhs3 >> 16 & 255) / 255 * ((rhs6 >> 16 & 255) / 255);
			var Green6 = (lhs3 >> 8 & 255) / 255 * ((rhs6 >> 8 & 255) / 255);
			var Blue6 = (lhs3 & 255) / 255 * ((rhs6 & 255) / 255);
			var Alpha12 = (lhs3 >> 24 & 255) / 255 * ((rhs6 >> 24 & 255) / 255);
			if(Alpha12 == null) {
				Alpha12 = 1;
			}
			var color6 = vision_ds_Color._new();
			var Alpha13 = Alpha12;
			if(Alpha13 == null) {
				Alpha13 = 1;
			}
			var value12 = Math.round(Red6 * 255);
			color6 &= -16711681;
			color6 |= (value12 > 255 ? 255 : value12 < 0 ? 0 : value12) << 16;
			var value13 = Math.round(Green6 * 255);
			color6 &= -65281;
			color6 |= (value13 > 255 ? 255 : value13 < 0 ? 0 : value13) << 8;
			var value14 = Math.round(Blue6 * 255);
			color6 &= -256;
			color6 |= value14 > 255 ? 255 : value14 < 0 ? 0 : value14;
			var value15 = Math.round(Alpha13 * 255);
			color6 &= 16777215;
			color6 |= (value15 > 255 ? 255 : value15 < 0 ? 0 : value15) << 24;
			var rhs7 = color6;
			var Red7 = (gvs >> 16 & 255) + (rhs7 >> 16 & 255);
			var Green7 = (gvs >> 8 & 255) + (rhs7 >> 8 & 255);
			var Blue7 = (gvs & 255) + (rhs7 & 255);
			var Alpha14 = (gvs >> 24 & 255) + (rhs7 >> 24 & 255);
			if(Alpha14 == null) {
				Alpha14 = 255;
			}
			var color7 = vision_ds_Color._new();
			var Alpha15 = Alpha14;
			if(Alpha15 == null) {
				Alpha15 = 255;
			}
			color7 &= -16711681;
			color7 |= (Red7 > 255 ? 255 : Red7 < 0 ? 0 : Red7) << 16;
			color7 &= -65281;
			color7 |= (Green7 > 255 ? 255 : Green7 < 0 ? 0 : Green7) << 8;
			color7 &= -256;
			color7 |= Blue7 > 255 ? 255 : Blue7 < 0 ? 0 : Blue7;
			color7 &= 16777215;
			color7 |= (Alpha15 > 255 ? 255 : Alpha15 < 0 ? 0 : Alpha15) << 24;
			gvs = color7;
			var lhs4 = yFilter_1_0;
			var rhs8 = neighbors[1][0] & 16777215;
			var Red8 = (lhs4 >> 16 & 255) / 255 * ((rhs8 >> 16 & 255) / 255);
			var Green8 = (lhs4 >> 8 & 255) / 255 * ((rhs8 >> 8 & 255) / 255);
			var Blue8 = (lhs4 & 255) / 255 * ((rhs8 & 255) / 255);
			var Alpha16 = (lhs4 >> 24 & 255) / 255 * ((rhs8 >> 24 & 255) / 255);
			if(Alpha16 == null) {
				Alpha16 = 1;
			}
			var color8 = vision_ds_Color._new();
			var Alpha17 = Alpha16;
			if(Alpha17 == null) {
				Alpha17 = 1;
			}
			var value16 = Math.round(Red8 * 255);
			color8 &= -16711681;
			color8 |= (value16 > 255 ? 255 : value16 < 0 ? 0 : value16) << 16;
			var value17 = Math.round(Green8 * 255);
			color8 &= -65281;
			color8 |= (value17 > 255 ? 255 : value17 < 0 ? 0 : value17) << 8;
			var value18 = Math.round(Blue8 * 255);
			color8 &= -256;
			color8 |= value18 > 255 ? 255 : value18 < 0 ? 0 : value18;
			var value19 = Math.round(Alpha17 * 255);
			color8 &= 16777215;
			color8 |= (value19 > 255 ? 255 : value19 < 0 ? 0 : value19) << 24;
			var rhs9 = color8;
			var Red9 = (ghs >> 16 & 255) + (rhs9 >> 16 & 255);
			var Green9 = (ghs >> 8 & 255) + (rhs9 >> 8 & 255);
			var Blue9 = (ghs & 255) + (rhs9 & 255);
			var Alpha18 = (ghs >> 24 & 255) + (rhs9 >> 24 & 255);
			if(Alpha18 == null) {
				Alpha18 = 255;
			}
			var color9 = vision_ds_Color._new();
			var Alpha19 = Alpha18;
			if(Alpha19 == null) {
				Alpha19 = 255;
			}
			color9 &= -16711681;
			color9 |= (Red9 > 255 ? 255 : Red9 < 0 ? 0 : Red9) << 16;
			color9 &= -65281;
			color9 |= (Green9 > 255 ? 255 : Green9 < 0 ? 0 : Green9) << 8;
			color9 &= -256;
			color9 |= Blue9 > 255 ? 255 : Blue9 < 0 ? 0 : Blue9;
			color9 &= 16777215;
			color9 |= (Alpha19 > 255 ? 255 : Alpha19 < 0 ? 0 : Alpha19) << 24;
			ghs = color9;
			var lhs5 = xFilter_1_0;
			var rhs10 = neighbors[1][0] & 16777215;
			var Red10 = (lhs5 >> 16 & 255) / 255 * ((rhs10 >> 16 & 255) / 255);
			var Green10 = (lhs5 >> 8 & 255) / 255 * ((rhs10 >> 8 & 255) / 255);
			var Blue10 = (lhs5 & 255) / 255 * ((rhs10 & 255) / 255);
			var Alpha20 = (lhs5 >> 24 & 255) / 255 * ((rhs10 >> 24 & 255) / 255);
			if(Alpha20 == null) {
				Alpha20 = 1;
			}
			var color10 = vision_ds_Color._new();
			var Alpha21 = Alpha20;
			if(Alpha21 == null) {
				Alpha21 = 1;
			}
			var value20 = Math.round(Red10 * 255);
			color10 &= -16711681;
			color10 |= (value20 > 255 ? 255 : value20 < 0 ? 0 : value20) << 16;
			var value21 = Math.round(Green10 * 255);
			color10 &= -65281;
			color10 |= (value21 > 255 ? 255 : value21 < 0 ? 0 : value21) << 8;
			var value22 = Math.round(Blue10 * 255);
			color10 &= -256;
			color10 |= value22 > 255 ? 255 : value22 < 0 ? 0 : value22;
			var value23 = Math.round(Alpha21 * 255);
			color10 &= 16777215;
			color10 |= (value23 > 255 ? 255 : value23 < 0 ? 0 : value23) << 24;
			var rhs11 = color10;
			var Red11 = (gvs >> 16 & 255) + (rhs11 >> 16 & 255);
			var Green11 = (gvs >> 8 & 255) + (rhs11 >> 8 & 255);
			var Blue11 = (gvs & 255) + (rhs11 & 255);
			var Alpha22 = (gvs >> 24 & 255) + (rhs11 >> 24 & 255);
			if(Alpha22 == null) {
				Alpha22 = 255;
			}
			var color11 = vision_ds_Color._new();
			var Alpha23 = Alpha22;
			if(Alpha23 == null) {
				Alpha23 = 255;
			}
			color11 &= -16711681;
			color11 |= (Red11 > 255 ? 255 : Red11 < 0 ? 0 : Red11) << 16;
			color11 &= -65281;
			color11 |= (Green11 > 255 ? 255 : Green11 < 0 ? 0 : Green11) << 8;
			color11 &= -256;
			color11 |= Blue11 > 255 ? 255 : Blue11 < 0 ? 0 : Blue11;
			color11 &= 16777215;
			color11 |= (Alpha23 > 255 ? 255 : Alpha23 < 0 ? 0 : Alpha23) << 24;
			gvs = color11;
			var lhs6 = yFilter_1_1;
			var rhs12 = neighbors[1][1] & 16777215;
			var Red12 = (lhs6 >> 16 & 255) / 255 * ((rhs12 >> 16 & 255) / 255);
			var Green12 = (lhs6 >> 8 & 255) / 255 * ((rhs12 >> 8 & 255) / 255);
			var Blue12 = (lhs6 & 255) / 255 * ((rhs12 & 255) / 255);
			var Alpha24 = (lhs6 >> 24 & 255) / 255 * ((rhs12 >> 24 & 255) / 255);
			if(Alpha24 == null) {
				Alpha24 = 1;
			}
			var color12 = vision_ds_Color._new();
			var Alpha25 = Alpha24;
			if(Alpha25 == null) {
				Alpha25 = 1;
			}
			var value24 = Math.round(Red12 * 255);
			color12 &= -16711681;
			color12 |= (value24 > 255 ? 255 : value24 < 0 ? 0 : value24) << 16;
			var value25 = Math.round(Green12 * 255);
			color12 &= -65281;
			color12 |= (value25 > 255 ? 255 : value25 < 0 ? 0 : value25) << 8;
			var value26 = Math.round(Blue12 * 255);
			color12 &= -256;
			color12 |= value26 > 255 ? 255 : value26 < 0 ? 0 : value26;
			var value27 = Math.round(Alpha25 * 255);
			color12 &= 16777215;
			color12 |= (value27 > 255 ? 255 : value27 < 0 ? 0 : value27) << 24;
			var rhs13 = color12;
			var Red13 = (ghs >> 16 & 255) + (rhs13 >> 16 & 255);
			var Green13 = (ghs >> 8 & 255) + (rhs13 >> 8 & 255);
			var Blue13 = (ghs & 255) + (rhs13 & 255);
			var Alpha26 = (ghs >> 24 & 255) + (rhs13 >> 24 & 255);
			if(Alpha26 == null) {
				Alpha26 = 255;
			}
			var color13 = vision_ds_Color._new();
			var Alpha27 = Alpha26;
			if(Alpha27 == null) {
				Alpha27 = 255;
			}
			color13 &= -16711681;
			color13 |= (Red13 > 255 ? 255 : Red13 < 0 ? 0 : Red13) << 16;
			color13 &= -65281;
			color13 |= (Green13 > 255 ? 255 : Green13 < 0 ? 0 : Green13) << 8;
			color13 &= -256;
			color13 |= Blue13 > 255 ? 255 : Blue13 < 0 ? 0 : Blue13;
			color13 &= 16777215;
			color13 |= (Alpha27 > 255 ? 255 : Alpha27 < 0 ? 0 : Alpha27) << 24;
			ghs = color13;
			var lhs7 = xFilter_1_1;
			var rhs14 = neighbors[1][1] & 16777215;
			var Red14 = (lhs7 >> 16 & 255) / 255 * ((rhs14 >> 16 & 255) / 255);
			var Green14 = (lhs7 >> 8 & 255) / 255 * ((rhs14 >> 8 & 255) / 255);
			var Blue14 = (lhs7 & 255) / 255 * ((rhs14 & 255) / 255);
			var Alpha28 = (lhs7 >> 24 & 255) / 255 * ((rhs14 >> 24 & 255) / 255);
			if(Alpha28 == null) {
				Alpha28 = 1;
			}
			var color14 = vision_ds_Color._new();
			var Alpha29 = Alpha28;
			if(Alpha29 == null) {
				Alpha29 = 1;
			}
			var value28 = Math.round(Red14 * 255);
			color14 &= -16711681;
			color14 |= (value28 > 255 ? 255 : value28 < 0 ? 0 : value28) << 16;
			var value29 = Math.round(Green14 * 255);
			color14 &= -65281;
			color14 |= (value29 > 255 ? 255 : value29 < 0 ? 0 : value29) << 8;
			var value30 = Math.round(Blue14 * 255);
			color14 &= -256;
			color14 |= value30 > 255 ? 255 : value30 < 0 ? 0 : value30;
			var value31 = Math.round(Alpha29 * 255);
			color14 &= 16777215;
			color14 |= (value31 > 255 ? 255 : value31 < 0 ? 0 : value31) << 24;
			var rhs15 = color14;
			var Red15 = (gvs >> 16 & 255) + (rhs15 >> 16 & 255);
			var Green15 = (gvs >> 8 & 255) + (rhs15 >> 8 & 255);
			var Blue15 = (gvs & 255) + (rhs15 & 255);
			var Alpha30 = (gvs >> 24 & 255) + (rhs15 >> 24 & 255);
			if(Alpha30 == null) {
				Alpha30 = 255;
			}
			var color15 = vision_ds_Color._new();
			var Alpha31 = Alpha30;
			if(Alpha31 == null) {
				Alpha31 = 255;
			}
			color15 &= -16711681;
			color15 |= (Red15 > 255 ? 255 : Red15 < 0 ? 0 : Red15) << 16;
			color15 &= -65281;
			color15 |= (Green15 > 255 ? 255 : Green15 < 0 ? 0 : Green15) << 8;
			color15 &= -256;
			color15 |= Blue15 > 255 ? 255 : Blue15 < 0 ? 0 : Blue15;
			color15 &= 16777215;
			color15 |= (Alpha31 > 255 ? 255 : Alpha31 < 0 ? 0 : Alpha31) << 24;
			gvs = color15;
			var w = Math.sqrt(ghs * ghs + gvs * gvs) | 0;
			var c = vision_ds_Color._new(w);
			var gray = ((c >> 16 & 255) + (c >> 8 & 255) + (c & 255)) / 3 | 0;
			c &= -16711681;
			c |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 16;
			c &= -65281;
			c |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 8;
			c &= -256;
			c |= gray > 255 ? 255 : gray < 0 ? 0 : gray;
			c &= 16777215;
			c |= -16777216;
			c = c;
			vision_ds_Image.setPixel(filtered,x,y,c);
		}
	}
	return filtered;
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
vision_algorithms_Canny.applyHysteresis = function(image,ht,lt) {
	var copy = vision_ds_Image.clone(image);
	var isStrong = function(edge) {
		return (edge >> 16 & 255) / 255 > ht;
	};
	var isCandidate = function(edge) {
		if((edge >> 16 & 255) / 255 <= ht) {
			return (edge >> 16 & 255) / 255 >= lt;
		} else {
			return false;
		}
	};
	var isWeak = function(edge) {
		return (edge >> 16 & 255) / 255 < lt;
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
					vision_ds_hough_HoughAccumulator.incrementCell(accum,rho | 0,thetaIndex);
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
var vision_algorithms_Sobel = function() { };
vision_algorithms_Sobel.__name__ = true;
vision_algorithms_Sobel.convolveWithSobelOperator = function(image) {
	var filtered = vision_ds_Image._new(vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var yFilter_0_0 = -3;
	var yFilter_0_1 = 0;
	var yFilter_0_2 = 3;
	var yFilter_1_0 = -10;
	var yFilter_1_1 = 0;
	var yFilter_1_2 = 10;
	var yFilter_2_0 = -3;
	var yFilter_2_1 = 0;
	var yFilter_2_2 = 3;
	var xFilter_0_0 = -3;
	var xFilter_0_1 = -10;
	var xFilter_0_2 = -3;
	var xFilter_1_0 = 0;
	var xFilter_1_1 = 0;
	var xFilter_1_2 = 0;
	var xFilter_2_0 = 3;
	var xFilter_2_1 = 10;
	var xFilter_2_2 = 3;
	var ghs = 0.;
	var gvs = 0.;
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y = _g2++;
			gvs = 0;
			ghs = gvs;
			var neighbors = vision_algorithms_Sobel.getNeighbors(3,x,y,image);
			var lhs = yFilter_0_0;
			var rhs = neighbors[0][0] & 16777215;
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
			var value = Math.round(Red * 255);
			color &= -16711681;
			color |= (value > 255 ? 255 : value < 0 ? 0 : value) << 16;
			var value1 = Math.round(Green * 255);
			color &= -65281;
			color |= (value1 > 255 ? 255 : value1 < 0 ? 0 : value1) << 8;
			var value2 = Math.round(Blue * 255);
			color &= -256;
			color |= value2 > 255 ? 255 : value2 < 0 ? 0 : value2;
			var value3 = Math.round(Alpha1 * 255);
			color &= 16777215;
			color |= (value3 > 255 ? 255 : value3 < 0 ? 0 : value3) << 24;
			ghs += color;
			var lhs1 = xFilter_0_0;
			var rhs1 = neighbors[0][0] & 16777215;
			var Red1 = (lhs1 >> 16 & 255) / 255 * ((rhs1 >> 16 & 255) / 255);
			var Green1 = (lhs1 >> 8 & 255) / 255 * ((rhs1 >> 8 & 255) / 255);
			var Blue1 = (lhs1 & 255) / 255 * ((rhs1 & 255) / 255);
			var Alpha2 = (lhs1 >> 24 & 255) / 255 * ((rhs1 >> 24 & 255) / 255);
			if(Alpha2 == null) {
				Alpha2 = 1;
			}
			var color1 = vision_ds_Color._new();
			var Alpha3 = Alpha2;
			if(Alpha3 == null) {
				Alpha3 = 1;
			}
			var value4 = Math.round(Red1 * 255);
			color1 &= -16711681;
			color1 |= (value4 > 255 ? 255 : value4 < 0 ? 0 : value4) << 16;
			var value5 = Math.round(Green1 * 255);
			color1 &= -65281;
			color1 |= (value5 > 255 ? 255 : value5 < 0 ? 0 : value5) << 8;
			var value6 = Math.round(Blue1 * 255);
			color1 &= -256;
			color1 |= value6 > 255 ? 255 : value6 < 0 ? 0 : value6;
			var value7 = Math.round(Alpha3 * 255);
			color1 &= 16777215;
			color1 |= (value7 > 255 ? 255 : value7 < 0 ? 0 : value7) << 24;
			gvs += color1;
			var lhs2 = yFilter_0_1;
			var rhs2 = neighbors[0][1] & 16777215;
			var Red2 = (lhs2 >> 16 & 255) / 255 * ((rhs2 >> 16 & 255) / 255);
			var Green2 = (lhs2 >> 8 & 255) / 255 * ((rhs2 >> 8 & 255) / 255);
			var Blue2 = (lhs2 & 255) / 255 * ((rhs2 & 255) / 255);
			var Alpha4 = (lhs2 >> 24 & 255) / 255 * ((rhs2 >> 24 & 255) / 255);
			if(Alpha4 == null) {
				Alpha4 = 1;
			}
			var color2 = vision_ds_Color._new();
			var Alpha5 = Alpha4;
			if(Alpha5 == null) {
				Alpha5 = 1;
			}
			var value8 = Math.round(Red2 * 255);
			color2 &= -16711681;
			color2 |= (value8 > 255 ? 255 : value8 < 0 ? 0 : value8) << 16;
			var value9 = Math.round(Green2 * 255);
			color2 &= -65281;
			color2 |= (value9 > 255 ? 255 : value9 < 0 ? 0 : value9) << 8;
			var value10 = Math.round(Blue2 * 255);
			color2 &= -256;
			color2 |= value10 > 255 ? 255 : value10 < 0 ? 0 : value10;
			var value11 = Math.round(Alpha5 * 255);
			color2 &= 16777215;
			color2 |= (value11 > 255 ? 255 : value11 < 0 ? 0 : value11) << 24;
			ghs += color2;
			var lhs3 = xFilter_0_1;
			var rhs3 = neighbors[0][1] & 16777215;
			var Red3 = (lhs3 >> 16 & 255) / 255 * ((rhs3 >> 16 & 255) / 255);
			var Green3 = (lhs3 >> 8 & 255) / 255 * ((rhs3 >> 8 & 255) / 255);
			var Blue3 = (lhs3 & 255) / 255 * ((rhs3 & 255) / 255);
			var Alpha6 = (lhs3 >> 24 & 255) / 255 * ((rhs3 >> 24 & 255) / 255);
			if(Alpha6 == null) {
				Alpha6 = 1;
			}
			var color3 = vision_ds_Color._new();
			var Alpha7 = Alpha6;
			if(Alpha7 == null) {
				Alpha7 = 1;
			}
			var value12 = Math.round(Red3 * 255);
			color3 &= -16711681;
			color3 |= (value12 > 255 ? 255 : value12 < 0 ? 0 : value12) << 16;
			var value13 = Math.round(Green3 * 255);
			color3 &= -65281;
			color3 |= (value13 > 255 ? 255 : value13 < 0 ? 0 : value13) << 8;
			var value14 = Math.round(Blue3 * 255);
			color3 &= -256;
			color3 |= value14 > 255 ? 255 : value14 < 0 ? 0 : value14;
			var value15 = Math.round(Alpha7 * 255);
			color3 &= 16777215;
			color3 |= (value15 > 255 ? 255 : value15 < 0 ? 0 : value15) << 24;
			gvs += color3;
			var lhs4 = yFilter_1_0;
			var rhs4 = neighbors[1][0] & 16777215;
			var Red4 = (lhs4 >> 16 & 255) / 255 * ((rhs4 >> 16 & 255) / 255);
			var Green4 = (lhs4 >> 8 & 255) / 255 * ((rhs4 >> 8 & 255) / 255);
			var Blue4 = (lhs4 & 255) / 255 * ((rhs4 & 255) / 255);
			var Alpha8 = (lhs4 >> 24 & 255) / 255 * ((rhs4 >> 24 & 255) / 255);
			if(Alpha8 == null) {
				Alpha8 = 1;
			}
			var color4 = vision_ds_Color._new();
			var Alpha9 = Alpha8;
			if(Alpha9 == null) {
				Alpha9 = 1;
			}
			var value16 = Math.round(Red4 * 255);
			color4 &= -16711681;
			color4 |= (value16 > 255 ? 255 : value16 < 0 ? 0 : value16) << 16;
			var value17 = Math.round(Green4 * 255);
			color4 &= -65281;
			color4 |= (value17 > 255 ? 255 : value17 < 0 ? 0 : value17) << 8;
			var value18 = Math.round(Blue4 * 255);
			color4 &= -256;
			color4 |= value18 > 255 ? 255 : value18 < 0 ? 0 : value18;
			var value19 = Math.round(Alpha9 * 255);
			color4 &= 16777215;
			color4 |= (value19 > 255 ? 255 : value19 < 0 ? 0 : value19) << 24;
			ghs += color4;
			var lhs5 = xFilter_1_0;
			var rhs5 = neighbors[1][0] & 16777215;
			var Red5 = (lhs5 >> 16 & 255) / 255 * ((rhs5 >> 16 & 255) / 255);
			var Green5 = (lhs5 >> 8 & 255) / 255 * ((rhs5 >> 8 & 255) / 255);
			var Blue5 = (lhs5 & 255) / 255 * ((rhs5 & 255) / 255);
			var Alpha10 = (lhs5 >> 24 & 255) / 255 * ((rhs5 >> 24 & 255) / 255);
			if(Alpha10 == null) {
				Alpha10 = 1;
			}
			var color5 = vision_ds_Color._new();
			var Alpha11 = Alpha10;
			if(Alpha11 == null) {
				Alpha11 = 1;
			}
			var value20 = Math.round(Red5 * 255);
			color5 &= -16711681;
			color5 |= (value20 > 255 ? 255 : value20 < 0 ? 0 : value20) << 16;
			var value21 = Math.round(Green5 * 255);
			color5 &= -65281;
			color5 |= (value21 > 255 ? 255 : value21 < 0 ? 0 : value21) << 8;
			var value22 = Math.round(Blue5 * 255);
			color5 &= -256;
			color5 |= value22 > 255 ? 255 : value22 < 0 ? 0 : value22;
			var value23 = Math.round(Alpha11 * 255);
			color5 &= 16777215;
			color5 |= (value23 > 255 ? 255 : value23 < 0 ? 0 : value23) << 24;
			gvs += color5;
			var lhs6 = yFilter_1_1;
			var rhs6 = neighbors[1][1] & 16777215;
			var Red6 = (lhs6 >> 16 & 255) / 255 * ((rhs6 >> 16 & 255) / 255);
			var Green6 = (lhs6 >> 8 & 255) / 255 * ((rhs6 >> 8 & 255) / 255);
			var Blue6 = (lhs6 & 255) / 255 * ((rhs6 & 255) / 255);
			var Alpha12 = (lhs6 >> 24 & 255) / 255 * ((rhs6 >> 24 & 255) / 255);
			if(Alpha12 == null) {
				Alpha12 = 1;
			}
			var color6 = vision_ds_Color._new();
			var Alpha13 = Alpha12;
			if(Alpha13 == null) {
				Alpha13 = 1;
			}
			var value24 = Math.round(Red6 * 255);
			color6 &= -16711681;
			color6 |= (value24 > 255 ? 255 : value24 < 0 ? 0 : value24) << 16;
			var value25 = Math.round(Green6 * 255);
			color6 &= -65281;
			color6 |= (value25 > 255 ? 255 : value25 < 0 ? 0 : value25) << 8;
			var value26 = Math.round(Blue6 * 255);
			color6 &= -256;
			color6 |= value26 > 255 ? 255 : value26 < 0 ? 0 : value26;
			var value27 = Math.round(Alpha13 * 255);
			color6 &= 16777215;
			color6 |= (value27 > 255 ? 255 : value27 < 0 ? 0 : value27) << 24;
			ghs += color6;
			var lhs7 = xFilter_1_1;
			var rhs7 = neighbors[1][1] & 16777215;
			var Red7 = (lhs7 >> 16 & 255) / 255 * ((rhs7 >> 16 & 255) / 255);
			var Green7 = (lhs7 >> 8 & 255) / 255 * ((rhs7 >> 8 & 255) / 255);
			var Blue7 = (lhs7 & 255) / 255 * ((rhs7 & 255) / 255);
			var Alpha14 = (lhs7 >> 24 & 255) / 255 * ((rhs7 >> 24 & 255) / 255);
			if(Alpha14 == null) {
				Alpha14 = 1;
			}
			var color7 = vision_ds_Color._new();
			var Alpha15 = Alpha14;
			if(Alpha15 == null) {
				Alpha15 = 1;
			}
			var value28 = Math.round(Red7 * 255);
			color7 &= -16711681;
			color7 |= (value28 > 255 ? 255 : value28 < 0 ? 0 : value28) << 16;
			var value29 = Math.round(Green7 * 255);
			color7 &= -65281;
			color7 |= (value29 > 255 ? 255 : value29 < 0 ? 0 : value29) << 8;
			var value30 = Math.round(Blue7 * 255);
			color7 &= -256;
			color7 |= value30 > 255 ? 255 : value30 < 0 ? 0 : value30;
			var value31 = Math.round(Alpha15 * 255);
			color7 &= 16777215;
			color7 |= (value31 > 255 ? 255 : value31 < 0 ? 0 : value31) << 24;
			gvs += color7;
			var w = Math.sqrt(ghs * ghs + gvs * gvs) | 0;
			var c = vision_ds_Color._new(w);
			var gray = ((c >> 16 & 255) + (c >> 8 & 255) + (c & 255)) / 3 | 0;
			c &= -16711681;
			c |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 16;
			c &= -65281;
			c |= (gray > 255 ? 255 : gray < 0 ? 0 : gray) << 8;
			c &= -256;
			c |= gray > 255 ? 255 : gray < 0 ? 0 : gray;
			c &= 16777215;
			c |= -16777216;
			c = c;
			vision_ds_Image.setPixel(filtered,x,y,c);
		}
	}
	return filtered;
};
vision_algorithms_Sobel.getNeighbors = function(kernalSize,x,y,image) {
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
};
vision_ds_Kernal2D.__constructs__ = [vision_ds_Kernal2D.Identity,vision_ds_Kernal2D.BoxBlur,vision_ds_Kernal2D.RidgeDetection,vision_ds_Kernal2D.RidgeDetectionAggresive,vision_ds_Kernal2D.Sharpen,vision_ds_Kernal2D.UnsharpMasking,vision_ds_Kernal2D.Assemble3x3,vision_ds_Kernal2D.Assemble5x5,vision_ds_Kernal2D.Custom];
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
var vision_ds_QueueCell = function(value,next,previous) {
	this.previous = previous;
	this.value = value;
	this.next = next;
};
vision_ds_QueueCell.__name__ = true;
var vision_ds_Queue = function() {
	this.length = 0;
};
vision_ds_Queue.__name__ = true;
vision_ds_Queue.prototype = {
	dequeue: function() {
		var v = this.get_last().value;
		this.get_last().previous.next = null;
		this.length--;
		return v;
	}
	,enqueue: function(value) {
		if(this.first == null) {
			this.first = new vision_ds_QueueCell(value,null,null);
			this.length++;
			return value;
		}
		this.first.previous = new vision_ds_QueueCell(value,this.first,null);
		this.first = this.first.previous;
		this.length++;
		return value;
	}
	,toString: function() {
		var s = "[";
		var processed = this.first;
		while(processed.next != null) {
			s += "" + Std.string(processed.value) + " -> ";
			processed = processed.next;
		}
		s += "" + Std.string(processed.value) + "]";
		return s;
	}
	,get_last: function() {
		var processed = this.first;
		while(processed.next != null) processed = processed.next;
		return processed;
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
		this.set_slope(Math.tan(degrees * vision_tools_MathTools.get_PI() / 180));
		this.set_radians(degrees * Math.PI / 180);
	} else if(radians != null) {
		this.set_radians(radians);
		this.set_slope(Math.tan(radians));
		this.set_degrees(radians * 180 / Math.PI);
	}
};
vision_ds_Ray2D.__name__ = true;
vision_ds_Ray2D.prototype = {
	set_slope: function(value) {
		this.degrees = Math.atan(value) * 180 / Math.PI;
		this.radians = Math.atan(value);
		return this.slope = value;
	}
	,set_degrees: function(value) {
		this.slope = Math.tan(value * vision_tools_MathTools.get_PI() / 180);
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
			return py - this.slope * px;
		}
		return py + this.slope * px;
	}
	,get_xIntercept: function() {
		var px = this.point.x;
		var py = this.point.y;
		if(py > 0) {
			return (py - this.slope * px) / this.slope;
		}
		return (py + this.slope * px) / this.slope;
	}
	,getPointAtX: function(x) {
		return new vision_ds_Point2D(x,this.slope * x + this.get_yIntercept());
	}
	,getPointAtY: function(y) {
		return new vision_ds_Point2D((y - this.get_yIntercept()) / this.slope,y);
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
	var this2 = this1[rho + vision_ds_hough_HoughAccumulator.get_rhoMax(this1)];
	this2[thetaIndex]++;
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
		haxe_Log.trace(imgElement.width,{ fileName : "src/vision/tools/ImageTools.hx", lineNumber : 72, className : "vision.tools.ImageTools", methodName : "loadFromFile", customParams : [imgElement.height,imgElement.naturalWidth,imgElement.naturalHeight]});
		if(image == null) {
			image = vision_ds_Image._new(imgElement.width,imgElement.height);
		}
		var imageData = canvas.getContext("2d",null).getImageData(0,0,vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
		var data = imageData.data;
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
var vision_tools_MathTools = function() { };
vision_tools_MathTools.__name__ = true;
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