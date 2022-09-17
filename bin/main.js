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
	,matchedPos: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchSub: function(s,pos,len) {
		if(len == null) {
			len = -1;
		}
		if(this.r.global) {
			this.r.lastIndex = pos;
			this.r.m = this.r.exec(len < 0 ? s : HxOverrides.substr(s,0,pos + len));
			var b = this.r.m != null;
			if(b) {
				this.r.s = s;
			}
			return b;
		} else {
			var b = this.match(len < 0 ? HxOverrides.substr(s,pos,null) : HxOverrides.substr(s,pos,len));
			if(b) {
				this.r.s = s;
				this.r.m.index += pos;
			}
			return b;
		}
	}
	,map: function(s,f) {
		var offset = 0;
		var buf_b = "";
		while(true) {
			if(offset >= s.length) {
				break;
			} else if(!this.matchSub(s,offset)) {
				buf_b += Std.string(HxOverrides.substr(s,offset,null));
				break;
			}
			var p = this.matchedPos();
			buf_b += Std.string(HxOverrides.substr(s,offset,p.pos - offset));
			buf_b += Std.string(f(this));
			if(p.len == 0) {
				buf_b += Std.string(HxOverrides.substr(s,p.pos,1));
				offset = p.pos + 1;
			} else {
				offset = p.pos + p.len;
			}
			if(!this.r.global) {
				break;
			}
		}
		if(!this.r.global && offset > 0 && offset < s.length) {
			buf_b += Std.string(HxOverrides.substr(s,offset,null));
		}
		return buf_b;
	}
};
var Console = function() { };
Console.__name__ = true;
Console.format = function(s,formatMode) {
	s += "<//>";
	var activeFormatFlagStack = [];
	var groupedProceedingTags = [];
	var browserFormatArguments = [];
	var result = Console.formatTagPattern.map(s,function(e) {
		var escaped = e.matched(1) != null;
		if(escaped) {
			return e.matched(0);
		}
		var open = e.matched(2) == null;
		var tags = e.matched(3).split(",");
		if(!open && tags.length == 1) {
			if(tags[0] == "") {
				var last = activeFormatFlagStack[activeFormatFlagStack.length - 1];
				var i = activeFormatFlagStack.indexOf(last);
				if(i != -1) {
					var proceedingTags = groupedProceedingTags[i];
					activeFormatFlagStack.splice(i - proceedingTags,proceedingTags + 1);
					groupedProceedingTags.splice(i - proceedingTags,proceedingTags + 1);
				}
			} else if(FormatFlag.fromString(tags[0]) == "reset") {
				activeFormatFlagStack = [];
				groupedProceedingTags = [];
			} else {
				var flag = FormatFlag.fromString(tags[0]);
				if(flag != null) {
					var i = activeFormatFlagStack.indexOf(flag);
					if(i != -1) {
						var proceedingTags = groupedProceedingTags[i];
						activeFormatFlagStack.splice(i - proceedingTags,proceedingTags + 1);
						groupedProceedingTags.splice(i - proceedingTags,proceedingTags + 1);
					}
				}
			}
		} else {
			var proceedingTags = 0;
			var _g = 0;
			while(_g < tags.length) {
				var tag = tags[_g];
				++_g;
				var flag = FormatFlag.fromString(tag);
				if(flag == null) {
					return e.matched(0);
				}
				if(open) {
					activeFormatFlagStack.push(flag);
					groupedProceedingTags.push(proceedingTags);
					++proceedingTags;
				} else {
					var i = activeFormatFlagStack.indexOf(flag);
					if(i != -1) {
						var proceedingTags1 = groupedProceedingTags[i];
						activeFormatFlagStack.splice(i - proceedingTags1,proceedingTags1 + 1);
						groupedProceedingTags.splice(i - proceedingTags1,proceedingTags1 + 1);
					}
				}
			}
		}
		switch(formatMode) {
		case 0:
			if(open) {
				if(activeFormatFlagStack.length > 0) {
					var lastFlagCount = groupedProceedingTags[groupedProceedingTags.length - 1] + 1;
					var asciiFormatString = "";
					var _g = 0;
					var _g1 = lastFlagCount;
					while(_g < _g1) {
						var i = _g++;
						var idx = groupedProceedingTags.length - 1 - i;
						asciiFormatString += Console.getAsciiFormat(activeFormatFlagStack[idx]);
					}
					return asciiFormatString;
				} else {
					return "";
				}
			} else {
				var result = Console.getAsciiFormat("reset");
				var result1 = new Array(activeFormatFlagStack.length);
				var _g = 0;
				var _g1 = activeFormatFlagStack.length;
				while(_g < _g1) {
					var i = _g++;
					result1[i] = Console.getAsciiFormat(activeFormatFlagStack[i]);
				}
				var _g = [];
				var _g1 = 0;
				var _g2 = result1;
				while(_g1 < _g2.length) {
					var v = _g2[_g1];
					++_g1;
					if(v != null) {
						_g.push(v);
					}
				}
				return result + _g.join("");
			}
			break;
		case 1:
			var browserFormatArguments1 = browserFormatArguments;
			var result = new Array(activeFormatFlagStack.length);
			var _g = 0;
			var _g1 = activeFormatFlagStack.length;
			while(_g < _g1) {
				var i = _g++;
				result[i] = Console.getBrowserFormat(activeFormatFlagStack[i]);
			}
			var _g = [];
			var _g1 = 0;
			var _g2 = result;
			while(_g1 < _g2.length) {
				var v = _g2[_g1];
				++_g1;
				if(v != null) {
					_g.push(v);
				}
			}
			browserFormatArguments1.push(_g.join(";"));
			return "%c";
		case 2:
			return "";
		}
	});
	return { formatted : result, browserFormatArguments : browserFormatArguments};
};
Console.printFormatted = function(s,outputStream) {
	if(outputStream == null) {
		outputStream = 0;
	}
	if(s == null) {
		s = "";
	}
	var result = Console.format(s,Console.formatMode);
	if(Console.formatMode == 1) {
		var logArgs = [result.formatted].concat(result.browserFormatArguments);
		switch(outputStream) {
		case 1:
			console.warn.apply(console, logArgs);
			break;
		case 2:
			console.error.apply(console, logArgs);
			break;
		case 0:case 3:
			console.log.apply(console, logArgs);
			break;
		}
		return;
	}
	Console.print(result.formatted,outputStream);
};
Console.print = function(s,outputStream) {
	if(outputStream == null) {
		outputStream = 0;
	}
	if(s == null) {
		s = "";
	}
	if(Console.printIntercept != null) {
		var allowDefaultPrint = Console.printIntercept(s,outputStream);
		if(!allowDefaultPrint) {
			return;
		}
	}
	switch(outputStream) {
	case 1:
		console.warn(s);
		break;
	case 2:
		console.error(s);
		break;
	case 0:case 3:
		console.log(s);
		break;
	}
};
Console.getAsciiFormat = function(flag) {
	if(flag.charAt(0) == "#") {
		var hex = HxOverrides.substr(flag,1,null);
		var r = Std.parseInt("0x" + HxOverrides.substr(hex,0,2));
		var g = Std.parseInt("0x" + HxOverrides.substr(hex,2,2));
		var b = Std.parseInt("0x" + HxOverrides.substr(hex,4,2));
		return "\x1B[38;5;" + Console.rgbToAscii256(r,g,b) + "m";
	}
	if(HxOverrides.substr(flag,0,3) == "bg#") {
		var hex = HxOverrides.substr(flag,3,null);
		var r = Std.parseInt("0x" + HxOverrides.substr(hex,0,2));
		var g = Std.parseInt("0x" + HxOverrides.substr(hex,2,2));
		var b = Std.parseInt("0x" + HxOverrides.substr(hex,4,2));
		return "\x1B[48;5;" + Console.rgbToAscii256(r,g,b) + "m";
	}
	switch(flag) {
	case "bg_black":
		return "\x1B[48;5;" + 0 + "m";
	case "bg_blue":
		return "\x1B[48;5;" + 4 + "m";
	case "bg_cyan":
		return "\x1B[48;5;" + 6 + "m";
	case "bg_green":
		return "\x1B[48;5;" + 2 + "m";
	case "bg_light_black":
		return "\x1B[48;5;" + 8 + "m";
	case "bg_light_blue":
		return "\x1B[48;5;" + 12 + "m";
	case "bg_light_cyan":
		return "\x1B[48;5;" + 14 + "m";
	case "bg_light_green":
		return "\x1B[48;5;" + 10 + "m";
	case "bg_light_magenta":
		return "\x1B[48;5;" + 13 + "m";
	case "bg_light_red":
		return "\x1B[48;5;" + 9 + "m";
	case "bg_light_white":
		return "\x1B[48;5;" + 15 + "m";
	case "bg_light_yellow":
		return "\x1B[48;5;" + 11 + "m";
	case "bg_magenta":
		return "\x1B[48;5;" + 5 + "m";
	case "bg_red":
		return "\x1B[48;5;" + 1 + "m";
	case "bg_white":
		return "\x1B[48;5;" + 7 + "m";
	case "bg_yellow":
		return "\x1B[48;5;" + 3 + "m";
	case "black":
		return "\x1B[38;5;" + 0 + "m";
	case "blink":
		return "\x1B[5m";
	case "blue":
		return "\x1B[38;5;" + 4 + "m";
	case "bold":
		return "\x1B[1m";
	case "cyan":
		return "\x1B[38;5;" + 6 + "m";
	case "dim":
		return "\x1B[2m";
	case "green":
		return "\x1B[38;5;" + 2 + "m";
	case "hidden":
		return "\x1B[8m";
	case "invert":
		return "\x1B[7m";
	case "italic":
		return "\x1B[3m";
	case "light_black":
		return "\x1B[38;5;" + 8 + "m";
	case "light_blue":
		return "\x1B[38;5;" + 12 + "m";
	case "light_cyan":
		return "\x1B[38;5;" + 14 + "m";
	case "light_green":
		return "\x1B[38;5;" + 10 + "m";
	case "light_magenta":
		return "\x1B[38;5;" + 13 + "m";
	case "light_red":
		return "\x1B[38;5;" + 9 + "m";
	case "light_white":
		return "\x1B[38;5;" + 15 + "m";
	case "light_yellow":
		return "\x1B[38;5;" + 11 + "m";
	case "magenta":
		return "\x1B[38;5;" + 5 + "m";
	case "red":
		return "\x1B[38;5;" + 1 + "m";
	case "reset":
		return "\x1B[m";
	case "underline":
		return "\x1B[4m";
	case "white":
		return "\x1B[38;5;" + 7 + "m";
	case "yellow":
		return "\x1B[38;5;" + 3 + "m";
	default:
		return "";
	}
};
Console.rgbToAscii256 = function(r,g,b) {
	var nearIdx = function(c,set) {
		var delta = Infinity;
		var index = -1;
		var _g = 0;
		var _g1 = set.length;
		while(_g < _g1) {
			var i = _g++;
			var d = Math.abs(c - set[i]);
			if(d < delta) {
				delta = d;
				index = i;
			}
		}
		return index;
	};
	var colorSteps = [0,95,135,175,215,255];
	var ir = nearIdx(r,colorSteps);
	var ig = nearIdx(g,colorSteps);
	var ib = nearIdx(b,colorSteps);
	var ier = Math.abs(r - colorSteps[ir]);
	var ieg = Math.abs(g - colorSteps[ig]);
	var ieb = Math.abs(b - colorSteps[ib]);
	var averageColorError = ier + ieg + ieb;
	var jr = Math.round((r - 8) / 10);
	var jg = Math.round((g - 8) / 10);
	var jb = Math.round((b - 8) / 10);
	var jer = Math.abs(r - Math.max(Math.min(jr * 10 + 8,238),8));
	var jeg = Math.abs(g - Math.max(Math.min(jg * 10 + 8,238),8));
	var jeb = Math.abs(b - Math.max(Math.min(jb * 10 + 8,238),8));
	var averageGrayError = jer + jeg + jeb;
	if(averageGrayError < averageColorError && r == g && g == b) {
		var grayIndex = jr + 232;
		return grayIndex;
	} else {
		var colorIndex = 16 + ir * 36 + ig * 6 + ib;
		return colorIndex;
	}
};
Console.getBrowserFormat = function(flag) {
	if(flag.charAt(0) == "#") {
		return "color: " + flag;
	}
	if(HxOverrides.substr(flag,0,3) == "bg#") {
		return "background-color: " + HxOverrides.substr(flag,2,null);
	}
	if(flag.charAt(0) == "{") {
		return HxOverrides.substr(flag,1,flag.length - 2);
	}
	switch(flag) {
	case "bg_black":
		return "background-color: black";
	case "bg_blue":
		return "background-color: blue";
	case "bg_cyan":
		return "background-color: cyan";
	case "bg_green":
		return "background-color: green";
	case "bg_light_black":
		return "background-color: gray";
	case "bg_light_blue":
		return "background-color: lightBlue";
	case "bg_light_cyan":
		return "background-color: lightCyan";
	case "bg_light_green":
		return "background-color: lightGreen";
	case "bg_light_magenta":
		return "background-color: lightPink";
	case "bg_light_red":
		return "background-color: salmon";
	case "bg_light_white":
		return "background-color: white";
	case "bg_light_yellow":
		return "background-color: lightYellow";
	case "bg_magenta":
		return "background-color: magenta";
	case "bg_red":
		return "background-color: red";
	case "bg_white":
		return "background-color: whiteSmoke";
	case "bg_yellow":
		return "background-color: gold";
	case "black":
		return "color: black";
	case "blink":
		return "text-decoration: blink";
	case "blue":
		return "color: blue";
	case "bold":
		return "font-weight: bold";
	case "cyan":
		return "color: cyan";
	case "dim":
		return "color: gray";
	case "green":
		return "color: green";
	case "hidden":
		return "visibility: hidden; color: white";
	case "invert":
		return "-webkit-filter: invert(100%); filter: invert(100%)";
	case "italic":
		return "font-style: italic";
	case "light_black":
		return "color: gray";
	case "light_blue":
		return "color: lightBlue";
	case "light_cyan":
		return "color: lightCyan";
	case "light_green":
		return "color: lightGreen";
	case "light_magenta":
		return "color: lightPink";
	case "light_red":
		return "color: salmon";
	case "light_white":
		return "color: white";
	case "light_yellow":
		return "color: #ffed88";
	case "magenta":
		return "color: magenta";
	case "red":
		return "color: red";
	case "reset":
		return "";
	case "underline":
		return "text-decoration: underline";
	case "white":
		return "color: whiteSmoke";
	case "yellow":
		return "color: #f5ba00";
	default:
		return "";
	}
};
Console.determineConsoleFormatMode = function() {
	var hasWindowObject = typeof(window) != "undefined";
	if(hasWindowObject) {
		return 1;
	} else {
		var isTTY = (typeof process !== "undefined") && (process?.stdout?.isTTY === true);
		if(isTTY) {
			return 0;
		}
	}
	return 2;
};
var FormatFlag = {};
FormatFlag.fromString = function(str) {
	str = str.toLowerCase();
	if(str.charAt(0) == "#" || HxOverrides.substr(str,0,3) == "bg#") {
		var hIdx = str.indexOf("#");
		var hex = HxOverrides.substr(str,hIdx + 1,null);
		if(hex.length == 3) {
			var a = hex.split("");
			hex = [a[0],a[0],a[1],a[1],a[2],a[2]].join("");
		}
		if(new EReg("[^0-9a-f]","i").match(hex) || hex.length < 6) {
			return "";
		}
		var normalized = str.substring(0,hIdx) + "#" + hex;
		return normalized;
	}
	switch(str) {
	case "!":
		return "invert";
	case "/":
		return "reset";
	case "b":
		return "bold";
	case "bg_gray":
		return "bg_light_black";
	case "gray":
		return "light_black";
	case "i":
		return "italic";
	case "u":
		return "underline";
	default:
		return str;
	}
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
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
	var start;
	var end;
	vision_tools_ImageTools.loadFromFile(null,"https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG",function(i) {
		Main.printImage(i);
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
var vision_ds_Color = {};
vision_ds_Color._new = function(value) {
	if(value == null) {
		value = 0;
	}
	var this1 = value;
	return this1;
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
	return "<bg" + ("#" + ((Prefix ? "0x" : "") + tmp + StringTools.hex(this1 >> 16 & 255,2) + StringTools.hex(this1 >> 8 & 255,2) + StringTools.hex(this1 & 255,2))) + ">  </>";
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
var vision_exceptions_VisionException = function(message,type) {
	throw "Exception - " + type + ":\n\n\t" + message + "\n";
};
vision_exceptions_VisionException.__name__ = true;
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
		window.document.body.appendChild(canvas);
		haxe_Log.trace(imgElement.width,{ fileName : "src/vision/tools/ImageTools.hx", lineNumber : 73, className : "vision.tools.ImageTools", methodName : "loadFromFile", customParams : [imgElement.height,imgElement.naturalWidth,imgElement.naturalHeight]});
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
			if(x == 0) {
				var s = Console.logPrefix + ("" + vision_ds_Color.toString(vision_ds_Image.getPixel(image,0,y)));
				var outputStream = 0;
				if(outputStream == null) {
					outputStream = 0;
				}
				if(s == null) {
					s = "";
				}
				Console.printFormatted(s + "\n",outputStream);
			}
		}
		onComplete(image);
	};
};
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
Console.formatMode = Console.determineConsoleFormatMode();
Console.logPrefix = "<b,gray>><//> ";
Console.formatTagPattern = new EReg("(\\\\)?<(/)?([^><{}\\s]*|{[^}<>]*})>","g");
Main.main();
})({});

//# sourceMappingURL=main.js.map