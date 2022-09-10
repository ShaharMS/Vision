(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.remove = function(a,obj) {
	var i = a.indexOf(obj);
	if(i == -1) {
		return false;
	}
	a.splice(i,1);
	return true;
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
	console.log("src/Main.hx:51:","Black and white took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.grayscale(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:55:","Grayscale took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.sobelEdgeDetection(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:59:","Sobel edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	var hough = vision_algorithms_Hough.toHoughSpace(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
	Main.printImage(hough.image);
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:64:","Hough transform took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.perwittEdgeDetection(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:68:","Perwitt edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.nearestNeighborBlur(vision_ds_Image.clone(image),1));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:72:","Nearest neighbor blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.contrast(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:76:","Contrast took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_Vision.gaussianBlur(vision_ds_Image.clone(image),2,15));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:80:","Gaussian blur took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_ds_Image.clone(image));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:84:","Image Cloning took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_ds_Image.mirror(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:88:","Image Mirroring took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_ds_Image.flip(vision_ds_Image.clone(image)));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:92:","Image Flipping took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	Main.printImage(vision_ds_Image.flip(vision_ds_Image.mirror(vision_ds_Image.clone(image))));
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:96:","Image Mirroring & Flipping took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	start = HxOverrides.now() / 1000;
	var canny = vision_Vision.cannyEdgeDetection(vision_ds_Image.clone(image));
	Main.printImage(canny);
	end = HxOverrides.now() / 1000;
	console.log("src/Main.hx:101:","Canny edge detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
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
	console.log("src/Main.hx:110:","Simple line detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
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
	console.log("src/Main.hx:118:","Hough line detection took: " + vision_tools_MathTools.turnicate(end - start,4) + " seconds");
	console.log("src/Main.hx:120:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).getPointAtX(8));
	console.log("src/Main.hx:121:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).slope);
	console.log("src/Main.hx:122:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).degrees);
	console.log("src/Main.hx:123:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).radians);
	console.log("src/Main.hx:124:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).getPointAtY(8));
	console.log("src/Main.hx:125:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).get_yIntercept());
	console.log("src/Main.hx:126:",new vision_ds_Ray2D(new vision_ds_Point2D(0,0),1).get_xIntercept());
	var queue = new vision_ds_Queue();
	queue.enqueue(0);
	queue.enqueue(1);
	queue.enqueue(2);
	queue.enqueue(3);
	console.log("src/Main.hx:132:",queue);
	console.log("src/Main.hx:133:",queue.dequeue());
	console.log("src/Main.hx:134:",queue.dequeue());
	console.log("src/Main.hx:135:",queue.dequeue());
	console.log("src/Main.hx:136:",queue);
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
	var rhoMax = Math.sqrt(vision_ds_Image.get_width(image) * vision_ds_Image.get_width(image) + vision_ds_Image.get_height(image) * vision_ds_Image.get_height(image));
	var accum = vision_ds_hough_HoughAccumulator._new(rhoMax | 0);
	var houghSpace = vision_ds_Image._new(181,rhoMax | 0,16777215);
	var maximas = [];
	var rays = [];
	var checkMaxima = function() {
		var max = 0;
		var bestRho = 0.;
		var bestTheta = 0;
		var _g = 0;
		while(_g < 360) {
			var i = _g++;
			if(vision_ds_hough_HoughAccumulator.array_get_theta_array(accum,i) == null) {
				continue;
			}
			var _g1 = 0;
			var _g2 = vision_ds_hough_HoughAccumulator.array_get_theta_array(accum,i).length;
			while(_g1 < _g2) {
				var j = _g1++;
				if(vision_ds_hough_HoughAccumulator.array_get_theta_array(accum,i)[j] > max) {
					max = vision_ds_hough_HoughAccumulator.array_get_theta_array(accum,i)[j];
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
vision_algorithms_SimpleLineDetector.findLineFromPoint = function(image,point,minLineGap,minLineLength) {
	var startX = vision_ds_IntPoint2D.get_x(point);
	var startY = vision_ds_IntPoint2D.get_y(point);
	var yArr = [0,1,-1,2,-2];
	var xArr = [0,1,-1,2,-2];
	var preferredDirection = vision_ds_IntPoint2D._new(0,0);
	if(vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point)) == null || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point))[vision_ds_IntPoint2D.get_y(point)] == null || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point))[vision_ds_IntPoint2D.get_y(point)] == 0) {
		return null;
	}
	var findPreference = function() {
		var _g = 0;
		while(_g < xArr.length) {
			var prefX = xArr[_g];
			++_g;
			var _g1 = 0;
			while(_g1 < yArr.length) {
				var prefY = yArr[_g1];
				++_g1;
				if(prefX == 0 && prefY == 0) {
					continue;
				}
				if(!vision_ds_Image.hasPixel(image,vision_ds_IntPoint2D.get_x(point) + prefX,vision_ds_IntPoint2D.get_y(point) + prefY)) {
					continue;
				}
				if((vision_ds_Image.getPixel(image,vision_ds_IntPoint2D.get_x(point) + prefX,vision_ds_IntPoint2D.get_y(point) + prefY) & 16777215) == 16777215) {
					preferredDirection = vision_ds_IntPoint2D._new(prefX,prefY);
				}
			}
		}
	};
	findPreference();
	var xs = xArr.slice();
	var ys = yArr.slice();
	HxOverrides.remove(xs,2);
	HxOverrides.remove(xs,-2);
	HxOverrides.remove(ys,2);
	HxOverrides.remove(ys,-2);
	if(vision_ds_IntPoint2D.get_x(preferredDirection) > 0) {
		HxOverrides.remove(xs,-1);
	} else if(vision_ds_IntPoint2D.get_x(preferredDirection) < 0) {
		HxOverrides.remove(xs,1);
	} else {
		HxOverrides.remove(xs,-1);
	}
	if(vision_ds_IntPoint2D.get_y(preferredDirection) > 0) {
		HxOverrides.remove(ys,-1);
	} else if(vision_ds_IntPoint2D.get_y(preferredDirection) < 0) {
		HxOverrides.remove(ys,1);
	} else {
		HxOverrides.remove(ys,-1);
	}
	var mightStop = false;
	var lValue = 0.;
	var lastValue = 0.;
	var expand = null;
	expand = function() {
		var X = vision_ds_IntPoint2D.get_x(preferredDirection);
		var Y = vision_ds_IntPoint2D.get_y(preferredDirection);
		if(vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point) + X) == null || vision_ds_Image.image_array_read(image,vision_ds_IntPoint2D.get_x(point) + X)[vision_ds_IntPoint2D.get_y(point) + Y] == null) {
			return;
		}
		if((vision_ds_Image.getPixel(image,vision_ds_IntPoint2D.get_x(point) + X,vision_ds_IntPoint2D.get_y(point) + Y) & 16777215) == 16777215) {
			var x = vision_ds_IntPoint2D.get_x(point) + X;
			var this1 = new haxe__$Int64__$_$_$Int64(x,vision_ds_IntPoint2D.get_y(point));
			point = this1;
			var y = vision_ds_IntPoint2D.get_y(point) + Y;
			var this1 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(point),y);
			point = this1;
			expand();
		} else {
			var _g = 0;
			while(_g < xs.length) {
				var x = xs[_g];
				++_g;
				var _g1 = 0;
				while(_g1 < ys.length) {
					var y = ys[_g1];
					++_g1;
					if(x == 0 && y == 0) {
						continue;
					}
					if(vision_ds_Image.hasPixel(image,vision_ds_IntPoint2D.get_x(point) + x,vision_ds_IntPoint2D.get_y(point) + y) && (vision_ds_Image.getPixel(image,vision_ds_IntPoint2D.get_x(point) + x,vision_ds_IntPoint2D.get_y(point) + y) & 16777215) == 16777215) {
						var x1 = vision_ds_IntPoint2D.get_x(point) + x;
						var this1 = new haxe__$Int64__$_$_$Int64(x1,vision_ds_IntPoint2D.get_y(point));
						point = this1;
						var y1 = vision_ds_IntPoint2D.get_y(point) + y;
						var this2 = new haxe__$Int64__$_$_$Int64(vision_ds_IntPoint2D.get_x(point),y1);
						point = this2;
						expand();
					}
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
vision_ds_Color._new = function(Value) {
	if(Value == null) {
		Value = 0;
	}
	var this1 = Value;
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
	console.log("src/vision/ds/Image.hx:252:","drawRay2D: point1: " + (p1 == null ? "null" : vision_ds_IntPoint2D.toString(p1)) + ", point2: " + (p2 == null ? "null" : vision_ds_IntPoint2D.toString(p2)));
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
	var x = radiusX - 1;
	var b = true;
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
		if(b) {
			++x;
			b = false;
		}
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
vision_ds_Image.mirror = function(this1) {
	this1.sort(function(e,f) {
		return 1;
	});
	return this1;
};
vision_ds_Image.flip = function(this1) {
	var _g = 0;
	var _g1 = vision_ds_Image.get_width(this1);
	while(_g < _g1) {
		var x = _g++;
		this1[x].sort(function(e,f) {
			return 1;
		});
	}
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
var vision_ds_LineSegment2D = function(start,end) {
	this.end = new vision_ds_Point2D(0,0);
	this.start = new vision_ds_Point2D(0,0);
	this.start.x = start.x;
	this.start.y = start.y;
	this.end.x = end.x;
	this.end.y = end.y;
};
vision_ds_LineSegment2D.__name__ = true;
vision_ds_LineSegment2D.prototype = {
	get_length: function() {
		return Math.sqrt(Math.pow(this.end.x - this.start.x,2) + Math.pow(this.end.y - this.start.y,2));
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
var vision_ds_Queue = function() {
	this.length = 0;
};
vision_ds_Queue.__name__ = true;
vision_ds_Queue.prototype = {
	dequeue: function() {
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
vision_ds_hough_HoughAccumulator.array_get_theta_array = function(this1,index) {
	return this1[index + vision_ds_hough_HoughAccumulator.get_rhoMax(this1)];
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