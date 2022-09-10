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
	vision_ds_Image.fillColor(image,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(200,200)),16776960);
	vision_ds_Image.drawCircle(image,180,190,5,9127187);
	vision_ds_Image.fillColor(image,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(180,190)),9127187);
	vision_ds_Image.drawCircle(image,220,190,5,9127187);
	vision_ds_Image.fillColor(image,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(220,190)),9127187);
	vision_ds_Image.drawCircle(image,200,225,8,9127187);
	vision_ds_Image.fillColor(image,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(200,225)),9127187);
	vision_ds_Image.drawQuadraticBezier(image,new vision_ds_LineSegment2D(new vision_ds_Point2D(100,100),new vision_ds_Point2D(200,100)),vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(200,200)),1638655);
	vision_ds_Image.drawCubicBezier(image,new vision_ds_LineSegment2D(new vision_ds_Point2D(10,10),new vision_ds_Point2D(50,100)),vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(150,200)),vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(200,75)),16711680);
	vision_ds_Image.drawRay2D(image,new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1),65280);
	vision_ds_Image.drawEllipse(image,100,100,40,21,10485663);
	Main.printImage(image);
	var start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.blackAndWhite(vision_ds_Image.clone(image)));
	var end = HxOverrides.now() / 1000;
	haxe_Log.trace("Black and white took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 51, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.grayscale(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Grayscale took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 55, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Sobel edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 59, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var hough = vision_algorithms_Hough.toHoughSpace(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
	Main.printImage(hough.image);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Hough transform took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 64, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Perwitt edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 68, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.nearestNeighborBlur(vision_ds_Image.clone(image),1));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Nearest neighbor blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 72, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.contrast(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Contrast took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 76, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.gaussianBlur(vision_ds_Image.clone(image),2,15));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Gaussian blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 80, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_ds_Image.clone(image));
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Image Cloning took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 84, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var canny = vision_Vision.cannyEdgeDetection(vision_ds_Image.clone(image));
	Main.printImage(canny);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Canny edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 89, className : "Main", methodName : "main"});
	start = HxOverrides.now() / 1000;
	var lines = vision_Vision.simpleLineSegment2DDetection(vision_ds_Image.clone(image),3,30);
	var newI = vision_ds_Image.clone(image);
	var _g = 0;
	while(_g < lines.length) {
		var l = lines[_g];
		++_g;
		vision_ds_Image.drawLineSegment2D(newI,l,65493);
	}
	Main.printImage(newI);
	end = HxOverrides.now() / 1000;
	haxe_Log.trace("Simple line detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 98, className : "Main", methodName : "main"});
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
	haxe_Log.trace("Hough line detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds",{ fileName : "src/Main.hx", lineNumber : 106, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).getPointAtX(8),{ fileName : "src/Main.hx", lineNumber : 108, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).slope,{ fileName : "src/Main.hx", lineNumber : 109, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).degrees,{ fileName : "src/Main.hx", lineNumber : 110, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).radians,{ fileName : "src/Main.hx", lineNumber : 111, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).getPointAtY(8),{ fileName : "src/Main.hx", lineNumber : 112, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).get_yIntercept(),{ fileName : "src/Main.hx", lineNumber : 113, className : "Main", methodName : "main"});
	haxe_Log.trace(new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).get_xIntercept(),{ fileName : "src/Main.hx", lineNumber : 114, className : "Main", methodName : "main"});
	var queue = new vision_ds_Queue();
	queue.enqueue(0);
	queue.enqueue(1);
	queue.enqueue(2);
	queue.enqueue(3);
	haxe_Log.trace(queue,{ fileName : "src/Main.hx", lineNumber : 120, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.dequeue(),{ fileName : "src/Main.hx", lineNumber : 121, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.dequeue(),{ fileName : "src/Main.hx", lineNumber : 122, className : "Main", methodName : "main"});
	haxe_Log.trace(queue.dequeue(),{ fileName : "src/Main.hx", lineNumber : 123, className : "Main", methodName : "main"});
	haxe_Log.trace(queue,{ fileName : "src/Main.hx", lineNumber : 124, className : "Main", methodName : "main"});
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
var haxe_ds_List = function() {
	this.length = 0;
};
haxe_ds_List.__name__ = true;
haxe_ds_List.prototype = {
	push: function(item) {
		var x = new haxe_ds__$List_ListNode(item,this.h);
		this.h = x;
		if(this.q == null) {
			this.q = x;
		}
		this.length++;
	}
	,pop: function() {
		if(this.h == null) {
			return null;
		}
		var x = this.h.item;
		this.h = this.h.next;
		if(this.h == null) {
			this.q = null;
		}
		this.length--;
		return x;
	}
};
var haxe_ds__$List_ListNode = function(item,next) {
	this.item = item;
	this.next = next;
};
haxe_ds__$List_ListNode.__name__ = true;
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
vision_Vision.houghRay2DDetection = function(image,threshold,maxRayCount) {
	if(threshold == null) {
		threshold = 100;
	}
	var edges = vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image),threshold);
	var houghSpace = vision_algorithms_Hough.toHoughSpaceWithRays(edges,threshold,maxRayCount);
	haxe_Log.trace(houghSpace.rays,{ fileName : "src/vision/Vision.hx", lineNumber : 124, className : "vision.Vision", methodName : "houghRay2DDetection"});
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
vision_Vision.simpleLineSegment2DDetection = function(image,minLineGap,minLineLength) {
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
			var line = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength);
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
			var line = vision_algorithms_SimpleLineDetector.findLineFromPoint(edgeDetected,vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y)),minLineGap,minLineLength,true);
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
	var accum = [];
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
					if(accum[thetaIndex] == null) {
						accum[thetaIndex] = [];
					} else if(accum[thetaIndex][rho | 0] == null) {
						accum[thetaIndex][rho | 0] = 0;
					} else {
						accum[thetaIndex][rho | 0] += 1;
					}
					var Alpha = 0.01;
					if(Alpha == null) {
						Alpha = 1;
					}
					var color = vision_ds_Color._new();
					var Alpha1 = Alpha;
					if(Alpha1 == null) {
						Alpha1 = 1;
					}
					var Value = Math.round(0);
					color &= -16711681;
					color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
					var Value1 = Math.round(0);
					color &= -65281;
					color |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
					var Value2 = Math.round(0);
					color &= -256;
					color |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
					var Value3 = Math.round(Alpha1 * 255);
					color &= 16777215;
					color |= (Value3 > 255 ? 255 : Value3 < 0 ? 0 : Value3) << 24;
					vision_ds_Image.paintPixel(houghSpace,thetaIndex,rho | 0,color);
					theta += Math.PI / 360;
					++thetaIndex;
				}
			}
		}
	}
	return new vision_ds_hough_HoughSpace(accum,houghSpace);
};
vision_algorithms_Hough.toHoughSpaceWithRays = function(image,threshold,numLocalMaxima,maximaCheckLoop) {
	if(threshold == null) {
		threshold = 30;
	}
	var accum = [];
	var rhoMax = Math.sqrt(vision_ds_Image.get_width(image) * vision_ds_Image.get_width(image) + vision_ds_Image.get_height(image) * vision_ds_Image.get_height(image));
	var houghSpace = vision_ds_Image._new(361,rhoMax | 0,16777215);
	var maximas = [];
	var rays = [];
	var checkMaxima = function() {
		var max = 0;
		var bestRho = 0.;
		var bestTheta = 0;
		var _g = 0;
		while(_g < 360) {
			var i = _g++;
			if(accum[i] == null) {
				continue;
			}
			var _g1 = 0;
			var _g2 = accum[i].length;
			while(_g1 < _g2) {
				var j = _g1++;
				if(accum[i][j] > max) {
					max = accum[i][j];
					bestRho = j;
					bestTheta = i;
				}
			}
		}
		if(max > threshold) {
			bestRho *= 2;
			bestRho -= rhoMax;
			var localMax = new vision_ds_Point2D(bestTheta,bestRho);
			var _g = 0;
			while(_g < maximas.length) {
				var maxima = maximas[_g];
				++_g;
				if(maxima.x == localMax.x && maxima.y == localMax.y) {
					return;
				}
			}
			maximas.push(localMax);
			var x1 = bestRho / Math.cos(bestTheta * Math.PI / 180);
			var y1 = bestRho / Math.sin(bestTheta * Math.PI / 180);
			var m = Math.tan(bestTheta * Math.PI / 180);
			rays.push(new vision_ds_Ray2D(new vision_ds_Point2D(x1,y1),m));
		}
	};
	var loop = 0;
	if(maximaCheckLoop == null) {
		maximaCheckLoop = (vision_ds_Image.get_width(image) + vision_ds_Image.get_height(image)) / 20 | 0;
	}
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
				while(thetaIndex < 360) {
					var line1 = new vision_ds_Ray2D(new vision_ds_Point2D(x,y),null,thetaIndex);
					var line2 = new vision_ds_Ray2D(new vision_ds_Point2D(0,0),null,thetaIndex + 90);
					var rho1 = vision_tools_MathTools.distanceBetweenPoints(new vision_ds_Point2D(0,0),line1.intersect(line2));
					if(accum[thetaIndex] == null) {
						accum[thetaIndex] = [];
					} else if(accum[thetaIndex][rho1 | 0] == null) {
						accum[thetaIndex][rho1 | 0] = 0;
					} else {
						accum[thetaIndex][rho1 | 0] += 1;
					}
					var Alpha = 0.01;
					if(Alpha == null) {
						Alpha = 1;
					}
					var color = vision_ds_Color._new();
					var Alpha1 = Alpha;
					if(Alpha1 == null) {
						Alpha1 = 1;
					}
					var Value = Math.round(0);
					color &= -16711681;
					color |= (Value > 255 ? 255 : Value < 0 ? 0 : Value) << 16;
					var Value1 = Math.round(0);
					color &= -65281;
					color |= (Value1 > 255 ? 255 : Value1 < 0 ? 0 : Value1) << 8;
					var Value2 = Math.round(0);
					color &= -256;
					color |= Value2 > 255 ? 255 : Value2 < 0 ? 0 : Value2;
					var Value3 = Math.round(Alpha1 * 255);
					color &= 16777215;
					color |= (Value3 > 255 ? 255 : Value3 < 0 ? 0 : Value3) << 24;
					vision_ds_Image.paintPixel(houghSpace,thetaIndex,rho1 | 0,color);
					theta += Math.PI / 360;
					++thetaIndex;
				}
			}
			++loop;
			if(loop >= maximaCheckLoop && Math.abs(vision_ds_Image.getPixel(image,x,y) >> 16 & 255) == 255) {
				loop = 0;
				checkMaxima();
				loop = 0;
				if(numLocalMaxima != null) {
					if(maximas.length >= numLocalMaxima) {
						var space = new vision_ds_hough_HoughSpace(accum,houghSpace);
						space.rays = rays;
						space.maximums = maximas;
						return space;
					}
				}
			}
		}
	}
	var space = new vision_ds_hough_HoughSpace(accum,houghSpace);
	space.rays = rays;
	space.maximums = maximas;
	return space;
};
var vision_algorithms_SimpleLineDetector = function() { };
vision_algorithms_SimpleLineDetector.__name__ = true;
vision_algorithms_SimpleLineDetector.findLineFromPoint = function(image,point,minLineGap,minLineLength,preferTTB) {
	if(preferTTB == null) {
		preferTTB = false;
	}
	var startX = vision_ds_IntPoint2D.get_x(point);
	var startY = vision_ds_IntPoint2D.get_y(point);
	var yArr = preferTTB ? [0,1,2,3] : [0,-1,1,2,-2];
	var xArr = preferTTB ? [0,-1,1,2,-2] : [1,2,3,0];
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
						haxe_Log.trace(point,{ fileName : "src/vision/algorithms/SimpleLineDetector.hx", lineNumber : 42, className : "vision.algorithms.SimpleLineDetector", methodName : "findLineFromPoint", customParams : [prev,prev2]});
					}
					expand();
				}
			}
		}
	};
	expand();
	var line = new vision_ds_LineSegment2D(new vision_ds_Point2D(startX,startY),vision_ds_IntPoint2D.toPoint2D(point));
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
	return vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt((vision_ds_Color.get_hue(this1) | 0) + 180,0,350),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
};
vision_ds_Color.getAnalogousHarmony = function(this1,Threshold) {
	if(Threshold == null) {
		Threshold = 30;
	}
	var warmer = vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt((vision_ds_Color.get_hue(this1) | 0) - Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	var colder = vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt((vision_ds_Color.get_hue(this1) | 0) + Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	return { original : this1, warmer : warmer, colder : colder};
};
vision_ds_Color.getSplitComplementHarmony = function(this1,Threshold) {
	if(Threshold == null) {
		Threshold = 30;
	}
	var oppositeHue = vision_tools_MathTools.wrapInt((vision_ds_Color.get_hue(this1) | 0) + 180,0,350);
	var warmer = vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt(oppositeHue - Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	var colder = vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt(oppositeHue + Threshold,0,350),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	return { original : this1, warmer : warmer, colder : colder};
};
vision_ds_Color.getTriadicHarmony = function(this1) {
	var triadic1 = vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt((vision_ds_Color.get_hue(this1) | 0) + 120,0,359),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
	var triadic2 = vision_ds_Color.fromHSB(vision_tools_MathTools.wrapInt((vision_ds_Color.get_hue(triadic1) | 0) + 120,0,359),(Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)) - Math.min((this1 >> 16 & 255) / 255,Math.min((this1 >> 8 & 255) / 255,(this1 & 255) / 255))) / Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),Math.max((this1 >> 16 & 255) / 255,Math.max((this1 >> 8 & 255) / 255,(this1 & 255) / 255)),(this1 >> 24 & 255) / 255);
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
	Factor = vision_tools_MathTools.boundFloat(Factor,0,1);
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
	Factor = vision_tools_MathTools.boundFloat(Factor,0,1);
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
vision_ds_Image.copyPixel = function(this1,x,y,image) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw haxe_Exception.thrown(new vision_exceptions_OutOfBounds(this1,vision_ds_IntPoint2D.toPoint2D(vision_ds_IntPoint2D._new(x,y))));
	}
	var val = vision_ds_Image.image_array_read(image,x)[y];
	this1[x][y] = val;
	return this1[x][y];
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
	var p1 = vision_ds_IntPoint2D.fromPoint2D(line.getPointAtY(0));
	var p2 = vision_ds_IntPoint2D.fromPoint2D(line.getPointAtY(vision_ds_Image.get_height(this1) - 1));
	haxe_Log.trace("drawRay2D: point1: " + Std.string(p1) + ", point2: " + Std.string(p2),{ fileName : "src/vision/ds/Image.hx", lineNumber : 252, className : "vision.ds._Image.Image_Impl_", methodName : "drawRay2D"});
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
vision_ds_Image.drawLineSegment2D = function(this1,line,color) {
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
vision_ds_Image.drawQuadraticBezier = function(this1,line,control,color,accuracy) {
	if(accuracy == null) {
		accuracy = 1000;
	}
	var bezier = function(t,p0,p1,p2) {
		var t2 = t * t;
		var t3 = t2 * t;
		return vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(p0) * (1 - t) * (1 - t) + vision_ds_IntPoint2D.get_x(p1) * 2 * t * (1 - t) + vision_ds_IntPoint2D.get_x(p2) * t * t,vision_ds_IntPoint2D.get_y(p0) * (1 - t) * (1 - t) + vision_ds_IntPoint2D.get_y(p1) * 2 * t * (1 - t) + vision_ds_IntPoint2D.get_y(p2) * t * t));
	};
	var p0 = vision_ds_IntPoint2D.fromPoint2D(line.start);
	var p1 = vision_ds_IntPoint2D.fromPoint2D(line.end);
	var p2 = vision_ds_IntPoint2D.fromPoint2D(vision_ds_IntPoint2D.toPoint2D(control));
	var i = 0.;
	var step = 1 / accuracy;
	while(i <= 1) {
		var p = bezier(i,p0,p1,p2);
		if(vision_ds_Image.hasPixel(this1,vision_ds_IntPoint2D.get_x(p),vision_ds_IntPoint2D.get_y(p))) {
			vision_ds_Image.setPixel(this1,vision_ds_IntPoint2D.get_x(p),vision_ds_IntPoint2D.get_y(p),color);
		}
		i += step;
	}
};
vision_ds_Image.drawCubicBezier = function(this1,line,control1,control2,color,accuracy) {
	if(accuracy == null) {
		accuracy = 1000;
	}
	var bezier = function(t,p0,p1,p2,p3) {
		var cX = 3 * (vision_ds_IntPoint2D.get_x(p1) - vision_ds_IntPoint2D.get_x(p0));
		var bX = 3 * (vision_ds_IntPoint2D.get_x(p2) - vision_ds_IntPoint2D.get_x(p1)) - cX;
		var aX = vision_ds_IntPoint2D.get_x(p3) - vision_ds_IntPoint2D.get_x(p0) - cX - bX;
		var cY = 3 * (vision_ds_IntPoint2D.get_y(p1) - vision_ds_IntPoint2D.get_y(p0));
		var bY = 3 * (vision_ds_IntPoint2D.get_y(p2) - vision_ds_IntPoint2D.get_y(p1)) - cY;
		var aY = vision_ds_IntPoint2D.get_y(p3) - vision_ds_IntPoint2D.get_y(p0) - cY - bY;
		var x = aX * Math.pow(t,3) + bX * Math.pow(t,2) + cX * t + vision_ds_IntPoint2D.get_x(p0);
		var y = aY * Math.pow(t,3) + bY * Math.pow(t,2) + cY * t + vision_ds_IntPoint2D.get_y(p0);
		return vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(x,y));
	};
	var i = 0.;
	var step = 1 / accuracy;
	while(i < 1) {
		var p = bezier(i,vision_ds_IntPoint2D.fromPoint2D(line.start),vision_ds_IntPoint2D.fromPoint2D(line.end),control1,control2);
		if(vision_ds_Image.hasPixel(this1,vision_ds_IntPoint2D.get_x(p),vision_ds_IntPoint2D.get_y(p))) {
			vision_ds_Image.setPixel(this1,vision_ds_IntPoint2D.get_x(p),vision_ds_IntPoint2D.get_y(p),color);
		}
		i += step;
	}
};
vision_ds_Image.drawCircle = function(this1,X,Y,r,color) {
	var x = -r;
	var y = 0;
	var err = 2 - 2 * r;
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
vision_ds_Image.drawEllipse = function(this1,centerX,centerY,radiusX,radiusY,color) {
	var twoASquare = 2 * radiusX * radiusX;
	var twoBSquare = 2 * radiusY * radiusY;
	var x = radiusX;
	var y = 0;
	var xChange = radiusY * radiusY * (1 - 2 * radiusX);
	var yChange = radiusX * radiusX;
	var ellipseError = 0;
	var stoppingX = twoBSquare * radiusX;
	var stoppingY = 0;
	while(stoppingX >= stoppingY) {
		vision_ds_Image.setPixel(this1,centerX + x,centerY + y,color);
		vision_ds_Image.setPixel(this1,centerX - x,centerY + y,color);
		vision_ds_Image.setPixel(this1,centerX + x,centerY - y,color);
		vision_ds_Image.setPixel(this1,centerX - x,centerY - y,color);
		if(ellipseError <= 0) {
			++y;
			stoppingY += twoASquare;
			ellipseError += yChange;
			yChange += twoASquare;
		}
		if(ellipseError > 0) {
			--x;
			stoppingX -= twoBSquare;
			ellipseError += xChange;
			xChange += twoBSquare;
		}
	}
	ellipseError = radiusY * radiusY / 4 - radiusX * radiusX * (radiusY - 0.5);
	x = 0;
	y = radiusY;
	xChange = radiusY * radiusY;
	yChange = radiusX * radiusX * (1 - 2 * radiusY);
	stoppingX = 0;
	stoppingY = twoASquare * radiusY;
	while(stoppingX <= stoppingY) {
		vision_ds_Image.setPixel(this1,centerX + x,centerY + y,color);
		vision_ds_Image.setPixel(this1,centerX - x,centerY + y,color);
		vision_ds_Image.setPixel(this1,centerX + x,centerY - y,color);
		vision_ds_Image.setPixel(this1,centerX - x,centerY - y,color);
		if(ellipseError <= 0) {
			++x;
			stoppingX += twoBSquare;
			ellipseError += xChange;
			xChange += twoBSquare;
		}
		if(ellipseError > 0) {
			--y;
			stoppingY -= twoASquare;
			ellipseError += yChange;
			yChange += twoASquare;
		}
	}
};
vision_ds_Image.fillColorRecursive = function(this1,position,color) {
	var originalColor = vision_ds_Image.getPixel(this1,vision_ds_IntPoint2D.get_x(position),vision_ds_IntPoint2D.get_y(position));
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
	expandFill(vision_ds_IntPoint2D.get_x(position),vision_ds_IntPoint2D.get_y(position));
};
vision_ds_Image.fillColor = function(this1,position,color) {
	var queue = new haxe_ds_List();
	queue.push(vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(position),vision_ds_IntPoint2D.get_y(position))));
	var explored = [];
	var originalColor = vision_ds_Image.getPixel(this1,vision_ds_IntPoint2D.get_x(position),vision_ds_IntPoint2D.get_y(position));
	var fill = function(v) {
		var fill;
		if(vision_ds_Image.hasPixel(this1,vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v)) && vision_ds_Image.getPixel(this1,vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v)) == originalColor) {
			var this2 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v));
			fill = explored.indexOf(this2) == -1;
		} else {
			fill = false;
		}
		if(fill) {
			queue.push(vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v))));
			vision_ds_Image.setPixel(this1,vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v),color);
		}
	};
	while(queue.length > 0) {
		var v = queue.pop();
		var explored1 = explored;
		var this2 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v));
		explored1.push(this2);
		fill(vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(v) + 1,vision_ds_IntPoint2D.get_y(v))));
		fill(vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v) + 1)));
		fill(vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(v) - 1,vision_ds_IntPoint2D.get_y(v))));
		fill(vision_ds_IntPoint2D.fromPoint2D(new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(v),vision_ds_IntPoint2D.get_y(v) - 1)));
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
vision_ds_Image.image_array_read = function(this1,index) {
	return this1[index];
};
vision_ds_Image.image_array_write = function(this1,index,value) {
	this1[index] = value;
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
vision_ds_IntPoint2D.set_y = function(this1,y) {
	var this2 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(this1),y);
	this1 = this2;
	return y;
};
vision_ds_IntPoint2D.set_x = function(this1,x) {
	var this2 = new haxe__$Int64__$_$_$Int64(x,vision_ds_IntPoint2D.get_y(this1));
	this1 = this2;
	return x;
};
vision_ds_IntPoint2D.toPoint2D = function(this1) {
	return new vision_ds_Point2D(vision_ds_IntPoint2D.get_x(this1),vision_ds_IntPoint2D.get_y(this1));
};
vision_ds_IntPoint2D.fromPoint2D = function(p) {
	return vision_ds_IntPoint2D._new(p.x | 0,p.y | 0);
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
vision_ds_LineSegment2D.fromRay2D = function(ray) {
	var x = ray.point.x;
	var y = ray.point.y;
	var length = 1;
	var end = new vision_ds_Point2D(x + length * Math.cos(ray.radians) | 0,y + length * Math.sin(ray.radians) | 0);
	return new vision_ds_LineSegment2D(ray.point,end);
};
vision_ds_LineSegment2D.prototype = {
	get_length: function() {
		return Math.sqrt(Math.pow(this.end.x - this.start.x,2) + Math.pow(this.end.y - this.start.y,2));
	}
	,toString: function() {
		return "\n (" + Std.string(this.start) + ".x, " + Std.string(this.start) + ".y) --> (" + Std.string(this.end) + ".x, " + Std.string(this.end) + ".y)";
	}
	,set_slope: function(value) {
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
	,toRay2D: function() {
		return new vision_ds_Ray2D(this.start,this.slope);
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
var vision_ds_QueueCell = function(value,next,previous) {
	this.previous = previous;
	this.value = value;
	this.next = next;
};
vision_ds_QueueCell.__name__ = true;
vision_ds_QueueCell.prototype = {
	getValue: function() {
		return this.value;
	}
};
var vision_ds_Queue = function() {
	this.length = 0;
};
vision_ds_Queue.__name__ = true;
vision_ds_Queue.prototype = {
	iterator: function() {
		var l = this.first;
		return { hasNext : function() {
			return l != null;
		}, next : function() {
			var k = l;
			l = k.next;
			return k.value;
		}};
	}
	,dequeue: function() {
		var v = this.get_last().value;
		this.set_last(null);
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
	,has: function(value) {
		var processed = this.first;
		while(processed.next != null) {
			if(processed.value == value) {
				return true;
			}
			processed = processed.next;
		}
		return false;
	}
	,toString: function() {
		var s = "";
		var processed = this.first;
		while(processed.next != null) {
			s += "" + Std.string(processed.value) + " -> ";
			processed = processed.next;
		}
		s += "" + Std.string(processed.value);
		return s;
	}
	,get_last: function() {
		var processed = this.first;
		while(processed.next != null) processed = processed.next;
		return processed;
	}
	,set_last: function(value) {
		var processed = this.first;
		while(processed.next != null) processed = processed.next;
		processed = value;
		return value;
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
	,intersect: function(ray) {
		return vision_tools_MathTools.intersectionBetweenRays2D(this,ray);
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
var vision_tools_ImageTools = function() { };
vision_tools_ImageTools.__name__ = true;
vision_tools_ImageTools.loadFromFile = function(image,path) {
	var imgElement = window.document.createElement("img");
	imgElement.src = path;
	var canvas = window.document.createElement("canvas");
	canvas.getContext("2d",null).drawImage(imgElement,0,0);
	if(image == null) {
		image = vision_ds_Image._new(imgElement.width,imgElement.height);
	}
	var imageData = canvas.getContext("2d",null).getImageData(0,0,vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
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
			var Red = data[i];
			var Green = data[i + 1];
			var Blue = data[i + 2];
			var Alpha = data[i + 3];
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
			var color1 = color;
			vision_ds_Image.setPixel(image,x,y,color1);
		}
	}
	canvas.getContext("2d",null).putImageData(imageData,0,0);
	return image;
};
vision_tools_ImageTools.addToScreen = function(image,x,y,units) {
	var c = window.document.createElement("canvas");
	c.width = vision_ds_Image.get_width(image);
	c.height = vision_ds_Image.get_height(image);
	var ctx = c.getContext("2d",null);
	var imageData = ctx.getImageData(0,0,vision_ds_Image.get_width(image),vision_ds_Image.get_height(image));
	var data = imageData.data;
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(image);
	while(_g < _g1) {
		var x1 = _g++;
		var _g2 = 0;
		var _g3 = vision_ds_Image.get_height(image);
		while(_g2 < _g3) {
			var y1 = _g2++;
			var i = (y1 * vision_ds_Image.get_width(image) + x1) * 4;
			data[i] = vision_ds_Image.getPixel(image,x1,y1) >> 16 & 255;
			data[i + 1] = vision_ds_Image.getPixel(image,x1,y1) >> 8 & 255;
			data[i + 2] = vision_ds_Image.getPixel(image,x1,y1) & 255;
			data[i + 3] = 255;
		}
	}
	ctx.putImageData(imageData,0,0);
	c.style.position = "absolute";
	c.style.top = y + units.yUnits != null ? y + units.yUnits : y + "px";
	c.style.left = x + units.xUnits != null ? x + units.xUnits : x + "px";
	window.document.body.appendChild(c);
	return image;
};
var vision_tools_MathTools = function() { };
vision_tools_MathTools.__name__ = true;
vision_tools_MathTools.distanceFromPointToRay2D = function(point,line) {
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
vision_tools_MathTools.distanceFromPointToLineSegment2D = function(line,point) {
	var ch = (line.start.y - line.end.y) * point.x + (line.end.x - line.start.x) * point.y + (line.start.x * line.end.y - line.end.x * line.start.y);
	var del = Math.sqrt(Math.pow(line.end.x - line.start.x,2) + Math.pow(line.end.y - line.start.y,2));
	var d = ch / del;
	return d;
};
vision_tools_MathTools.distanceBetweenlineSegments2D = function(line1,line2) {
	if(vision_tools_MathTools.intersectionBetweenLineSegments2D(line1,line2) != null) {
		return 0;
	}
	var distance1 = vision_tools_MathTools.distanceFromPointToLineSegment2D(line1,line2.start);
	var distance2 = vision_tools_MathTools.distanceFromPointToLineSegment2D(line1,line2.end);
	var distance3 = vision_tools_MathTools.distanceFromPointToLineSegment2D(line2,line1.start);
	var distance4 = vision_tools_MathTools.distanceFromPointToLineSegment2D(line2,line1.end);
	var distance = vision_tools_MathTools.min(distance1,distance2,distance3,distance4);
	return distance;
};
vision_tools_MathTools.angleFromPointToLine = function(point,line) {
	var angle = Math.atan2(line.end.y - line.start.y,line.end.x - line.start.x);
	var angle2 = Math.atan2(point.y - line.start.y,point.x - line.start.x);
	return angle2 - angle;
};
vision_tools_MathTools.angleFromPointToPoint = function(point1,point2) {
	var x = point2.x - point1.x;
	var y = point2.y - point1.y;
	return Math.atan2(y,x);
};
vision_tools_MathTools.distanceBetweenPoints = function(point1,point2) {
	var x = point2.x - point1.x;
	var y = point2.y - point1.y;
	return Math.sqrt(x * x + y * y);
};
vision_tools_MathTools.intersectionBetweenLineSegments2D = function(line1,line2) {
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
vision_tools_MathTools.intersectionBetweenRays2D = function(ray,ray2) {
	var line1StartX = ray.point.x;
	var line1StartY = ray.point.y;
	var line1EndX = ray.point.x + Math.cos(ray.radians) * 1000;
	var line1EndY = ray.point.y + Math.sin(ray.radians) * 1000;
	var line2StartX = ray2.point.x;
	var line2StartY = ray2.point.y;
	var line2EndX = ray2.point.x + Math.cos(ray2.radians) * 1000;
	var line2EndY = ray2.point.y + Math.sin(ray2.radians) * 1000;
	var result = null;
	var denominator = (line2EndY - line2StartY) * (line1EndX - line1StartX) - (line2EndX - line2StartX) * (line1EndY - line1StartY);
	if(denominator == 0) {
		return result;
	}
	var a = line1StartY - line2StartY;
	var b = line1StartX - line2StartX;
	var numerator1 = (line2EndX - line2StartX) * a - (line2EndY - line2StartY) * b;
	var numerator2 = (line1EndX - line1StartX) * a - (line1EndY - line1StartY) * b;
	a = numerator1 / denominator;
	b = numerator2 / denominator;
	result = new vision_ds_Point2D();
	result.x = line1StartX + a * (line1EndX - line1StartX);
	result.y = line1StartY + a * (line1EndY - line1StartY);
	return result;
};
vision_tools_MathTools.wrapInt = function(value,min,max) {
	var range = max - min + 1;
	if(value < min) {
		value += range * ((min - value) / range + 1 | 0);
	}
	return min + (value - min) % range;
};
vision_tools_MathTools.wrapFloat = function(value,min,max) {
	var range = max - min;
	if(value < min) {
		value += range * (min - value) / range + 1;
	}
	return min + (value - min) % range;
};
vision_tools_MathTools.boundInt = function(value,min,max) {
	return Math.min(Math.max(value,min),max) | 0;
};
vision_tools_MathTools.boundFloat = function(value,min,max) {
	return Math.min(Math.max(value,min),max);
};
vision_tools_MathTools.slopeToDegrees = function(slope) {
	return Math.atan(slope) * 180 / Math.PI;
};
vision_tools_MathTools.slopeToRadians = function(slope) {
	return Math.atan(slope);
};
vision_tools_MathTools.degreesToSlope = function(degrees) {
	return Math.tan(degrees * vision_tools_MathTools.get_PI() / 180);
};
vision_tools_MathTools.degreesToRadians = function(degrees) {
	return degrees * Math.PI / 180;
};
vision_tools_MathTools.radiansToDegrees = function(radians) {
	return radians * 180 / Math.PI;
};
vision_tools_MathTools.radiansToSlope = function(radians) {
	return Math.tan(radians);
};
vision_tools_MathTools.cotan = function(radians) {
	return 1 / Math.tan(radians);
};
vision_tools_MathTools.cosec = function(radians) {
	return 1 / Math.sin(radians);
};
vision_tools_MathTools.sec = function(radians) {
	return 1 / Math.cos(radians);
};
vision_tools_MathTools.turnicate = function(num,numbersAfterDecimal) {
	var multiplier = Math.pow(10,numbersAfterDecimal);
	return Math.round(num * multiplier) / multiplier;
};
vision_tools_MathTools.min = function() {
	var $l=arguments.length;
	var values = new Array($l>0?$l-0:0);
	for(var $i=0;$i<$l;++$i){values[$i-0]=arguments[$i];}
	var min = values[0];
	var _g = 0;
	var _g1 = values.length;
	while(_g < _g1) {
		var i = _g++;
		if(values[i] == null) {
			continue;
		}
		if(values[i] < min) {
			min = values[i];
		}
	}
	return min;
};
vision_tools_MathTools.max = function() {
	var $l=arguments.length;
	var values = new Array($l>0?$l-0:0);
	for(var $i=0;$i<$l;++$i){values[$i-0]=arguments[$i];}
	var max = values[0];
	var _g = 0;
	var _g1 = values.length;
	while(_g < _g1) {
		var i = _g++;
		if(values[i] == null) {
			continue;
		}
		if(values[i] > max) {
			max = values[i];
		}
	}
	return max;
};
vision_tools_MathTools.verifyInt = function(v) {
	return v == (v | 0);
};
vision_tools_MathTools.get_NEGATIVE_INFINITY = function() {
	return -Infinity;
};
vision_tools_MathTools.get_POSITIVE_INFINITY = function() {
	return Infinity;
};
vision_tools_MathTools.get_NaN = function() {
	return NaN;
};
vision_tools_MathTools.get_PI = function() {
	return Math.PI;
};
vision_tools_MathTools.abs = function(v) {
	return Math.abs(v);
};
vision_tools_MathTools.acos = function(v) {
	return Math.acos(v);
};
vision_tools_MathTools.asin = function(v) {
	return Math.asin(v);
};
vision_tools_MathTools.atan = function(v) {
	return Math.atan(v);
};
vision_tools_MathTools.atan2 = function(y,x) {
	return Math.atan2(x,y);
};
vision_tools_MathTools.ceil = function(v) {
	return Math.ceil(v);
};
vision_tools_MathTools.cos = function(v) {
	return Math.cos(v);
};
vision_tools_MathTools.exp = function(v) {
	return Math.exp(v);
};
vision_tools_MathTools.floor = function(v) {
	return Math.floor(v);
};
vision_tools_MathTools.log = function(v) {
	return Math.log(v);
};
vision_tools_MathTools.pow = function(v,exp) {
	return Math.pow(v,exp);
};
vision_tools_MathTools.random = function() {
	return Math.random();
};
vision_tools_MathTools.round = function(v) {
	return Math.round(v);
};
vision_tools_MathTools.sin = function(v) {
	return Math.sin(v);
};
vision_tools_MathTools.sqrt = function(v) {
	return Math.sqrt(v);
};
vision_tools_MathTools.tan = function(v) {
	return Math.tan(v);
};
vision_tools_MathTools.ffloor = function(v) {
	return Math.floor(v);
};
vision_tools_MathTools.fceil = function(v) {
	return Math.ceil(v);
};
vision_tools_MathTools.fround = function(v) {
	return Math.round(v);
};
vision_tools_MathTools.isFinite = function(f) {
	return isFinite(f);
};
vision_tools_MathTools.isNaN = function(f) {
	return isNaN(f);
};
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
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
vision_tools_MathTools.PI_OVER_2 = Math.PI / 2;
Main.main();
})({});

//# sourceMappingURL=main.js.map