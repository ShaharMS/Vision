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
Console.printlnFormatted = function(s,outputStream) {
	if(outputStream == null) {
		outputStream = 0;
	}
	if(s == null) {
		s = "";
	}
	Console.printFormatted(s + "\n",outputStream);
};
Console.println = function(s,outputStream) {
	if(outputStream == null) {
		outputStream = 0;
	}
	if(s == null) {
		s = "";
	}
	Console.print(s + "\n",outputStream);
};
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
Console.stripFormatting = function(s) {
	return Console.format(s,2).formatted;
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
	vision_ds_Image.drawRect(image,12,53,33,53,16777215);
	vision_ds_Image.drawCircle(image,100,100,50,3967342);
	vision_ds_Image.drawCircle(image,100,100,30,16711892);
	vision_ds_Image.drawCircle(image,200,200,40,-256);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(200,200),-256);
	vision_ds_Image.drawCircle(image,180,190,5,-7650029);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(180,190),-7650029);
	vision_ds_Image.drawCircle(image,220,190,5,-7650029);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(220,190),-7650029);
	vision_ds_Image.drawCircle(image,200,225,8,-7650029);
	vision_ds_Image.fillColor(image,new vision_ds_Point2D(200,225),-7650029);
	Main.printIm(image);
	Main.printIm(vision_Vision.blackAndWhite(vision_ds_Image.clone(image)));
	Main.printIm(vision_Vision.grayscale(vision_ds_Image.clone(image)));
	Main.printIm(vision_Vision.detectEdgesSobel(vision_ds_Image.clone(image)));
	var hough = vision_algorithms_HoughTransform.toHoughSpace(vision_Vision.detectEdgesPerwitt(vision_ds_Image.clone(image)));
	Main.printIm(hough.image);
	Main.printIm(vision_Vision.invert(vision_ds_Image.clone(hough.image)));
	var l = vision_Vision.detectEdgesPerwitt(vision_ds_Image.clone(image));
	Main.printIm(l);
	Main.printIm(vision_Vision.nearestNeighborBlur(vision_ds_Image.clone(image),100));
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
	toString: function() {
		return this.get_message();
	}
	,get_message: function() {
		return this.message;
	}
	,get_native: function() {
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
vision_Vision.detectLinesHough = function(image,threshold,minLineLength,minLineGap,maxLineGap) {
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
	var edges = vision_Vision.detectEdgesPerwitt(image,threshold);
	var houghSpace = vision_algorithms_HoughTransform.toHoughSpace(edges);
	var accumulator = houghSpace.accumulator;
	var peaks = [];
	var s = Console.logPrefix + ("" + Std.string(accumulator));
	var outputStream = 0;
	if(outputStream == null) {
		outputStream = 0;
	}
	if(s == null) {
		s = "";
	}
	Console.printFormatted(s + "\n",outputStream);
	var _g = 0;
	var _g1 = accumulator.length;
	while(_g < _g1) {
		var i = _g++;
		var _g2 = 0;
		var _g3 = accumulator[i].length;
		while(_g2 < _g3) {
			var j = _g2++;
			if(accumulator[i][j] == null) {
				continue;
			}
			if(accumulator[i][j] > minLineLength) {
				haxe_Log.trace(accumulator[i][j],{ fileName : "src/vision/Vision.hx", lineNumber : 129, className : "vision.Vision", methodName : "detectLinesHough", customParams : [vision_ds_Image.get_width(image),vision_ds_Image.get_height(image),minLineLength,accumulator[i][j] - vision_ds_Image.get_width(image) - vision_ds_Image.get_height(image) - minLineLength]});
				peaks.push(new vision_ds_Point2D(i,j));
			}
		}
	}
	var lineSegments = [];
	var s = Console.logPrefix + ("" + Std.string(peaks));
	var outputStream = 0;
	if(outputStream == null) {
		outputStream = 0;
	}
	if(s == null) {
		s = "";
	}
	Console.printFormatted(s + "\n",outputStream);
	var _g = 0;
	var _g1 = peaks.length;
	while(_g < _g1) {
		var i = _g++;
		var peak = peaks[i];
		var theta = peak.x;
		var rho = peak.y;
		var lineSegment = vision_algorithms_HoughTransform.getLineSegments(houghSpace,edges,theta,rho,maxLineGap);
		lineSegments.concat(lineSegment);
	}
	return lineSegments;
};
vision_Vision.detectEdgesSobel = function(image,threshold) {
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
			var sobelCalculationIterationTTB = (neighbors_0 >> 16 & 255) * -1 + (neighbors_1 >> 16 & 255) * -1 + (neighbors_2 >> 16 & 255) * -1 + (neighbors_6 >> 16 & 255) + (neighbors_7 >> 16 & 255) + (neighbors_8 >> 16 & 255);
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
	return edges2;
};
vision_Vision.detectEdgesPerwitt = function(image,threshold) {
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
var vision_algorithms_HoughTransform = function() { };
vision_algorithms_HoughTransform.__name__ = true;
vision_algorithms_HoughTransform.toHoughSpace = function(image) {
	var start = HxOverrides.now() / 1000;
	var accum = [];
	var rhoMax = Math.sqrt(vision_ds_Image.get_width(image) * vision_ds_Image.get_width(image) + vision_ds_Image.get_height(image) * vision_ds_Image.get_height(image));
	var houghSpace = vision_ds_Image._new(361,rhoMax | 0,-1);
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
					rho = (rho | 0) >> 1;
					if(accum[thetaIndex] == null) {
						accum[thetaIndex] = [];
					}
					if(accum[thetaIndex][rho | 0] == null) {
						accum[thetaIndex][rho | 0] = 1;
					} else {
						var accum1 = accum[thetaIndex];
						accum1[rho | 0]++;
					}
					vision_ds_Image.setPixel(houghSpace,thetaIndex,rho | 0,vision_ds_Color.darken(vision_ds_Image.getPixel(houghSpace,thetaIndex,rho | 0),0.02));
					theta += Math.PI / 360;
					++thetaIndex;
				}
			}
		}
	}
	var end = HxOverrides.now() / 1000;
	haxe_Log.trace("Hough Transform took " + (end - start) + " seconds",{ fileName : "src/vision/algorithms/HoughTransform.hx", lineNumber : 84, className : "vision.algorithms.HoughTransform", methodName : "toHoughSpace"});
	return new vision_ds_hough_HoughSpace(accum,houghSpace);
};
vision_algorithms_HoughTransform.getLineSegments = function(houghspace,image,theta,rho,maxGap) {
	var x = rho * Math.cos(theta);
	var y = rho * Math.sin(theta);
	var slope;
	if(theta == Math.PI / 2 || theta == -Math.PI / 2) {
		slope = null;
	} else {
		slope = Math.tan(theta);
	}
	var point1 = null;
	var point2 = null;
	var lineGapCounter = 0;
	var segments = [];
	if(slope == null) {
		var X = x | 0;
		var _g = 0;
		var _g1 = vision_ds_Image.get_height(image);
		while(_g < _g1) {
			var Y = _g++;
			if(!vision_ds_Image.hasPixel(image,X,Y)) {
				continue;
			}
			if((vision_ds_Image.getPixel(image,X,Y) >> 16 & 255) == 255) {
				if(point1 == null) {
					point1 = new vision_ds_Point2D(X,Y);
				} else {
					point2 = new vision_ds_Point2D(X,Y);
				}
				lineGapCounter = 0;
			} else {
				++lineGapCounter;
				if(lineGapCounter > maxGap) {
					if(point1 != null && point2 != null) {
						segments.push(new vision_ds_LineSegment2D(point1,point2));
					}
					point1 = null;
					point2 = null;
					lineGapCounter = 0;
				}
			}
		}
	} else {
		while(x > 0) {
			y -= slope;
			--x;
		}
		var Y = y | 0;
		var _g = 0;
		var _g1 = vision_ds_Image.get_width(image);
		while(_g < _g1) {
			var X = _g++;
			if(!vision_ds_Image.hasPixel(image,X,Y)) {
				continue;
			}
			if((vision_ds_Image.getPixel(image,X,Y) >> 16 & 255) == 255) {
				if(point1 == null) {
					point1 = new vision_ds_Point2D(X,Y);
				} else {
					point2 = new vision_ds_Point2D(X,Y);
				}
				lineGapCounter = 0;
			} else {
				++lineGapCounter;
				if(lineGapCounter > maxGap) {
					if(point1 != null && point2 != null) {
						segments.push(new vision_ds_LineSegment2D(point1,point2));
					}
					point1 = null;
					point2 = null;
					lineGapCounter = 0;
				}
			}
			y += slope;
			Y = y | 0;
		}
	}
	return segments;
};
var vision_ds_Color = {};
vision_ds_Color.fromInt = function(value) {
	return vision_ds_Color._new(value);
};
vision_ds_Color.fromRGB = function(Red,Green,Blue,Alpha) {
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
vision_ds_Color.fromRGBFloat = function(Red,Green,Blue,Alpha) {
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
	var lhs = -1;
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
vision_ds_Color.setRGB = function(this1,Red,Green,Blue,Alpha) {
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
vision_ds_Color.setRGBFloat = function(this1,Red,Green,Blue,Alpha) {
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
		throw new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y));
	}
	return this1[x][y];
};
vision_ds_Image.setPixel = function(this1,x,y,color) {
	if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
		throw new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y));
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
		throw new vision_exceptions_OutOfBounds(this1,new vision_ds_Point2D(x,y));
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
vision_ds_Image.drawRect = function(this1,x,y,width,height,color) {
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
	var edgeDetector = vision_Vision.detectEdgesPerwitt(vision_ds_Image.clone(this1),1);
	var expandFill = null;
	expandFill = function(x,y) {
		if(x < 0 || x >= this1.length || y < 0 || y >= this1[x].length) {
			return;
		}
		if(vision_ds_Image.getPixel(this1,x,y) == color) {
			return;
		}
		if((vision_ds_Image.image_array_read(edgeDetector,x)[y] >> 16 & 255) == 255) {
			vision_ds_Image.setPixel(this1,x,y,color);
			vision_ds_Image.setPixel(this1,x + 1,y,color);
			vision_ds_Image.setPixel(this1,x - 1,y,color);
			vision_ds_Image.setPixel(this1,x,y + 1,color);
			vision_ds_Image.setPixel(this1,x,y - 1,color);
			return;
		}
		vision_ds_Image.setPixel(this1,x,y,color);
		expandFill(x + 1,y);
		expandFill(x - 1,y);
		expandFill(x,y + 1);
		expandFill(x,y - 1);
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
var vision_ds_Line2D = function(point,m,degrees,radians) {
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
vision_ds_Line2D.__name__ = true;
vision_ds_Line2D.from2Points = function(point1,point2) {
	var s = (point2.y - point1.y) / (point2.x - point1.x);
	return new vision_ds_Line2D(point1,s);
};
vision_ds_Line2D.prototype = {
	set_slope: function(value) {
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
	this.x = x;
	this.y = y;
};
vision_ds_Point2D.__name__ = true;
vision_ds_Point2D.prototype = {
	toString: function() {
		return "(" + this.x + ", " + this.y + ")";
	}
};
var vision_ds_hough_HoughSpace = function(accumulator,image) {
	this.accumulator = accumulator;
	this.image = image;
};
vision_ds_hough_HoughSpace.__name__ = true;
var vision_exceptions_OutOfBounds = function(image,position) {
	haxe_Exception.call(this,"Coordinate Out Of Bounds: pixel " + Std.string(position) + " is outside the bounds of the image (size: " + vision_ds_Image.get_width(image) + "x" + vision_ds_Image.get_height(image) + ")");
};
vision_exceptions_OutOfBounds.__name__ = true;
vision_exceptions_OutOfBounds.__super__ = haxe_Exception;
vision_exceptions_OutOfBounds.prototype = $extend(haxe_Exception.prototype,{
});
var vision_tools_MathUtils = function() { };
vision_tools_MathUtils.__name__ = true;
vision_tools_MathUtils.distanceFromPointToLine = function(point,line) {
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
vision_tools_MathUtils.intersectionBetweenLineSegments = function(line1,line2) {
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
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
Console.formatMode = Console.determineConsoleFormatMode();
Console.logPrefix = "<b,gray>><//> ";
Console.warnPrefix = "<b,yellow>><//> ";
Console.errorPrefix = "<b,red>></b> ";
Console.successPrefix = "<b,light_green>><//> ";
Console.debugPrefix = "<b,magenta>><//> ";
Console.argSeparator = " ";
Console.unicodeCompatibilityMode = 0;
Console.unicodeCompatibilityEnabled = false;
Console.formatTagPattern = new EReg("(\\\\)?<(/)?([^><{}\\s]*|{[^}<>]*})>","g");
FormatFlag.RESET = "reset";
FormatFlag.BOLD = "bold";
FormatFlag.ITALIC = "italic";
FormatFlag.DIM = "dim";
FormatFlag.UNDERLINE = "underline";
FormatFlag.BLINK = "blink";
FormatFlag.INVERT = "invert";
FormatFlag.HIDDEN = "hidden";
FormatFlag.BLACK = "black";
FormatFlag.RED = "red";
FormatFlag.GREEN = "green";
FormatFlag.YELLOW = "yellow";
FormatFlag.BLUE = "blue";
FormatFlag.MAGENTA = "magenta";
FormatFlag.CYAN = "cyan";
FormatFlag.WHITE = "white";
FormatFlag.LIGHT_BLACK = "light_black";
FormatFlag.LIGHT_RED = "light_red";
FormatFlag.LIGHT_GREEN = "light_green";
FormatFlag.LIGHT_YELLOW = "light_yellow";
FormatFlag.LIGHT_BLUE = "light_blue";
FormatFlag.LIGHT_MAGENTA = "light_magenta";
FormatFlag.LIGHT_CYAN = "light_cyan";
FormatFlag.LIGHT_WHITE = "light_white";
FormatFlag.BG_BLACK = "bg_black";
FormatFlag.BG_RED = "bg_red";
FormatFlag.BG_GREEN = "bg_green";
FormatFlag.BG_YELLOW = "bg_yellow";
FormatFlag.BG_BLUE = "bg_blue";
FormatFlag.BG_MAGENTA = "bg_magenta";
FormatFlag.BG_CYAN = "bg_cyan";
FormatFlag.BG_WHITE = "bg_white";
FormatFlag.BG_LIGHT_BLACK = "bg_light_black";
FormatFlag.BG_LIGHT_RED = "bg_light_red";
FormatFlag.BG_LIGHT_GREEN = "bg_light_green";
FormatFlag.BG_LIGHT_YELLOW = "bg_light_yellow";
FormatFlag.BG_LIGHT_BLUE = "bg_light_blue";
FormatFlag.BG_LIGHT_MAGENTA = "bg_light_magenta";
FormatFlag.BG_LIGHT_CYAN = "bg_light_cyan";
FormatFlag.BG_LIGHT_WHITE = "bg_light_white";
vision_ds_Color.TRANSPARENT = 0;
vision_ds_Color.WHITE = -1;
vision_ds_Color.GRAY = -8355712;
vision_ds_Color.BLACK = -16777216;
vision_ds_Color.GREEN = -16744448;
vision_ds_Color.LIME = -16711936;
vision_ds_Color.YELLOW = -256;
vision_ds_Color.ORANGE = -23296;
vision_ds_Color.RED = -65536;
vision_ds_Color.PURPLE = -8388480;
vision_ds_Color.BLUE = -16776961;
vision_ds_Color.BROWN = -7650029;
vision_ds_Color.PINK = -16181;
vision_ds_Color.MAGENTA = -65281;
vision_ds_Color.CYAN = -16711681;
vision_ds_Color.COLOR_REGEX = new EReg("^(0x|#)(([A-F0-9]{2}){3,4})$","i");
Main.main();
})({});

//# sourceMappingURL=main.js.map