package vision.formats._internal.images.webp;

// Adapted from golang.org/x/image/vp8, copyright The Go Authors. See VP8-LICENSE.

@:noCompletion
class Vp8Prediction {
	static inline function clip8(value:Int):Int return value < 0 ? 0 : value > 255 ? 255 : value;

	public static function predict4(mode:Int, workspace:Array<Array<Int>>, y:Int, x:Int):Void {
		switch mode {
			case 0: predFunc4DC(workspace, y, x);
			case 1: predFunc4TM(workspace, y, x);
			case 2: predFunc4VE(workspace, y, x);
			case 3: predFunc4HE(workspace, y, x);
			case 4: predFunc4RD(workspace, y, x);
			case 5: predFunc4VR(workspace, y, x);
			case 6: predFunc4LD(workspace, y, x);
			case 7: predFunc4VL(workspace, y, x);
			case 8: predFunc4HD(workspace, y, x);
			case 9: predFunc4HU(workspace, y, x);
			default: throw WebpContainer.invalid("Invalid VP8 prediction mode.");
		}
	}

	public static function predict8(mode:Int, workspace:Array<Array<Int>>, y:Int, x:Int):Void {
		switch mode {
			case 0: predFunc8DC(workspace, y, x);
			case 1: predFunc8TM(workspace, y, x);
			case 2: predFunc8VE(workspace, y, x);
			case 3: predFunc8HE(workspace, y, x);
			case 10: predFunc8DCTop(workspace, y, x);
			case 11: predFunc8DCLeft(workspace, y, x);
			case 12: predFunc8DCTopLeft(workspace, y, x);
			default: throw WebpContainer.invalid("Invalid VP8 prediction mode.");
		}
	}

	public static function predict16(mode:Int, workspace:Array<Array<Int>>, y:Int, x:Int):Void {
		switch mode {
			case 0: predFunc16DC(workspace, y, x);
			case 1: predFunc16TM(workspace, y, x);
			case 2: predFunc16VE(workspace, y, x);
			case 3: predFunc16HE(workspace, y, x);
			case 10: predFunc16DCTop(workspace, y, x);
			case 11: predFunc16DCLeft(workspace, y, x);
			case 12: predFunc16DCTopLeft(workspace, y, x);
			default: throw WebpContainer.invalid("Invalid VP8 prediction mode.");
		}
	}

	static function predFunc4DC(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (4);
		for (i in 0...4) {
			sum += (ybr[y-1][x+i]);
		}
		for (j in 0...4) {
			sum += (ybr[y+j][x-1]);
		}
		var avg = (sum >> 3);
		for (j in 0...4) {
			for (i in 0...4) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc4TM(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var delta0 = -(ybr[y-1][x-1]);
		for (j in 0...4) {
			var delta1 = delta0 + (ybr[y+j][x-1]);
			for (i in 0...4) {
				var delta2 = delta1 + (ybr[y-1][x+i]);
				ybr[y+j][x+i] = clip8(delta2);
			}
		}
	}

	static function predFunc4VE(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var a = (ybr[y-1][x-1]);
		var b = (ybr[y-1][x+0]);
		var c = (ybr[y-1][x+1]);
		var d = (ybr[y-1][x+2]);
		var e = (ybr[y-1][x+3]);
		var f = (ybr[y-1][x+4]);
		var abc = ((a + 2*b + c + 2) >> 2);
		var bcd = ((b + 2*c + d + 2) >> 2);
		var cde = ((c + 2*d + e + 2) >> 2);
		var def = ((d + 2*e + f + 2) >> 2);
		for (j in 0...4) {
			ybr[y+j][x+0] = abc;
			ybr[y+j][x+1] = bcd;
			ybr[y+j][x+2] = cde;
			ybr[y+j][x+3] = def;
		}
	}

	static function predFunc4HE(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var s = (ybr[y+3][x-1]);
		var r = (ybr[y+2][x-1]);
		var q = (ybr[y+1][x-1]);
		var p = (ybr[y+0][x-1]);
		var a = (ybr[y-1][x-1]);
		var ssr = ((s + 2*s + r + 2) >> 2);
		var srq = ((s + 2*r + q + 2) >> 2);
		var rqp = ((r + 2*q + p + 2) >> 2);
		var apq = ((a + 2*p + q + 2) >> 2);
		for (i in 0...4) {
			ybr[y+0][x+i] = apq;
			ybr[y+1][x+i] = rqp;
			ybr[y+2][x+i] = srq;
			ybr[y+3][x+i] = ssr;
		}
	}

	static function predFunc4RD(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var s = (ybr[y+3][x-1]);
		var r = (ybr[y+2][x-1]);
		var q = (ybr[y+1][x-1]);
		var p = (ybr[y+0][x-1]);
		var a = (ybr[y-1][x-1]);
		var b = (ybr[y-1][x+0]);
		var c = (ybr[y-1][x+1]);
		var d = (ybr[y-1][x+2]);
		var e = (ybr[y-1][x+3]);
		var srq = ((s + 2*r + q + 2) >> 2);
		var rqp = ((r + 2*q + p + 2) >> 2);
		var qpa = ((q + 2*p + a + 2) >> 2);
		var pab = ((p + 2*a + b + 2) >> 2);
		var abc = ((a + 2*b + c + 2) >> 2);
		var bcd = ((b + 2*c + d + 2) >> 2);
		var cde = ((c + 2*d + e + 2) >> 2);
		ybr[y+0][x+0] = pab;
		ybr[y+0][x+1] = abc;
		ybr[y+0][x+2] = bcd;
		ybr[y+0][x+3] = cde;
		ybr[y+1][x+0] = qpa;
		ybr[y+1][x+1] = pab;
		ybr[y+1][x+2] = abc;
		ybr[y+1][x+3] = bcd;
		ybr[y+2][x+0] = rqp;
		ybr[y+2][x+1] = qpa;
		ybr[y+2][x+2] = pab;
		ybr[y+2][x+3] = abc;
		ybr[y+3][x+0] = srq;
		ybr[y+3][x+1] = rqp;
		ybr[y+3][x+2] = qpa;
		ybr[y+3][x+3] = pab;
	}

	static function predFunc4VR(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var r = (ybr[y+2][x-1]);
		var q = (ybr[y+1][x-1]);
		var p = (ybr[y+0][x-1]);
		var a = (ybr[y-1][x-1]);
		var b = (ybr[y-1][x+0]);
		var c = (ybr[y-1][x+1]);
		var d = (ybr[y-1][x+2]);
		var e = (ybr[y-1][x+3]);
		var ab = ((a + b + 1) >> 1);
		var bc = ((b + c + 1) >> 1);
		var cd = ((c + d + 1) >> 1);
		var de = ((d + e + 1) >> 1);
		var rqp = ((r + 2*q + p + 2) >> 2);
		var qpa = ((q + 2*p + a + 2) >> 2);
		var pab = ((p + 2*a + b + 2) >> 2);
		var abc = ((a + 2*b + c + 2) >> 2);
		var bcd = ((b + 2*c + d + 2) >> 2);
		var cde = ((c + 2*d + e + 2) >> 2);
		ybr[y+0][x+0] = ab;
		ybr[y+0][x+1] = bc;
		ybr[y+0][x+2] = cd;
		ybr[y+0][x+3] = de;
		ybr[y+1][x+0] = pab;
		ybr[y+1][x+1] = abc;
		ybr[y+1][x+2] = bcd;
		ybr[y+1][x+3] = cde;
		ybr[y+2][x+0] = qpa;
		ybr[y+2][x+1] = ab;
		ybr[y+2][x+2] = bc;
		ybr[y+2][x+3] = cd;
		ybr[y+3][x+0] = rqp;
		ybr[y+3][x+1] = pab;
		ybr[y+3][x+2] = abc;
		ybr[y+3][x+3] = bcd;
	}

	static function predFunc4LD(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var a = (ybr[y-1][x+0]);
		var b = (ybr[y-1][x+1]);
		var c = (ybr[y-1][x+2]);
		var d = (ybr[y-1][x+3]);
		var e = (ybr[y-1][x+4]);
		var f = (ybr[y-1][x+5]);
		var g = (ybr[y-1][x+6]);
		var h = (ybr[y-1][x+7]);
		var abc = ((a + 2*b + c + 2) >> 2);
		var bcd = ((b + 2*c + d + 2) >> 2);
		var cde = ((c + 2*d + e + 2) >> 2);
		var def = ((d + 2*e + f + 2) >> 2);
		var efg = ((e + 2*f + g + 2) >> 2);
		var fgh = ((f + 2*g + h + 2) >> 2);
		var ghh = ((g + 2*h + h + 2) >> 2);
		ybr[y+0][x+0] = abc;
		ybr[y+0][x+1] = bcd;
		ybr[y+0][x+2] = cde;
		ybr[y+0][x+3] = def;
		ybr[y+1][x+0] = bcd;
		ybr[y+1][x+1] = cde;
		ybr[y+1][x+2] = def;
		ybr[y+1][x+3] = efg;
		ybr[y+2][x+0] = cde;
		ybr[y+2][x+1] = def;
		ybr[y+2][x+2] = efg;
		ybr[y+2][x+3] = fgh;
		ybr[y+3][x+0] = def;
		ybr[y+3][x+1] = efg;
		ybr[y+3][x+2] = fgh;
		ybr[y+3][x+3] = ghh;
	}

	static function predFunc4VL(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var a = (ybr[y-1][x+0]);
		var b = (ybr[y-1][x+1]);
		var c = (ybr[y-1][x+2]);
		var d = (ybr[y-1][x+3]);
		var e = (ybr[y-1][x+4]);
		var f = (ybr[y-1][x+5]);
		var g = (ybr[y-1][x+6]);
		var h = (ybr[y-1][x+7]);
		var ab = ((a + b + 1) >> 1);
		var bc = ((b + c + 1) >> 1);
		var cd = ((c + d + 1) >> 1);
		var de = ((d + e + 1) >> 1);
		var abc = ((a + 2*b + c + 2) >> 2);
		var bcd = ((b + 2*c + d + 2) >> 2);
		var cde = ((c + 2*d + e + 2) >> 2);
		var def = ((d + 2*e + f + 2) >> 2);
		var efg = ((e + 2*f + g + 2) >> 2);
		var fgh = ((f + 2*g + h + 2) >> 2);
		ybr[y+0][x+0] = ab;
		ybr[y+0][x+1] = bc;
		ybr[y+0][x+2] = cd;
		ybr[y+0][x+3] = de;
		ybr[y+1][x+0] = abc;
		ybr[y+1][x+1] = bcd;
		ybr[y+1][x+2] = cde;
		ybr[y+1][x+3] = def;
		ybr[y+2][x+0] = bc;
		ybr[y+2][x+1] = cd;
		ybr[y+2][x+2] = de;
		ybr[y+2][x+3] = efg;
		ybr[y+3][x+0] = bcd;
		ybr[y+3][x+1] = cde;
		ybr[y+3][x+2] = def;
		ybr[y+3][x+3] = fgh;
	}

	static function predFunc4HD(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var s = (ybr[y+3][x-1]);
		var r = (ybr[y+2][x-1]);
		var q = (ybr[y+1][x-1]);
		var p = (ybr[y+0][x-1]);
		var a = (ybr[y-1][x-1]);
		var b = (ybr[y-1][x+0]);
		var c = (ybr[y-1][x+1]);
		var d = (ybr[y-1][x+2]);
		var sr = ((s + r + 1) >> 1);
		var rq = ((r + q + 1) >> 1);
		var qp = ((q + p + 1) >> 1);
		var pa = ((p + a + 1) >> 1);
		var srq = ((s + 2*r + q + 2) >> 2);
		var rqp = ((r + 2*q + p + 2) >> 2);
		var qpa = ((q + 2*p + a + 2) >> 2);
		var pab = ((p + 2*a + b + 2) >> 2);
		var abc = ((a + 2*b + c + 2) >> 2);
		var bcd = ((b + 2*c + d + 2) >> 2);
		ybr[y+0][x+0] = pa;
		ybr[y+0][x+1] = pab;
		ybr[y+0][x+2] = abc;
		ybr[y+0][x+3] = bcd;
		ybr[y+1][x+0] = qp;
		ybr[y+1][x+1] = qpa;
		ybr[y+1][x+2] = pa;
		ybr[y+1][x+3] = pab;
		ybr[y+2][x+0] = rq;
		ybr[y+2][x+1] = rqp;
		ybr[y+2][x+2] = qp;
		ybr[y+2][x+3] = qpa;
		ybr[y+3][x+0] = sr;
		ybr[y+3][x+1] = srq;
		ybr[y+3][x+2] = rq;
		ybr[y+3][x+3] = rqp;
	}

	static function predFunc4HU(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var s = (ybr[y+3][x-1]);
		var r = (ybr[y+2][x-1]);
		var q = (ybr[y+1][x-1]);
		var p = (ybr[y+0][x-1]);
		var pq = ((p + q + 1) >> 1);
		var qr = ((q + r + 1) >> 1);
		var rs = ((r + s + 1) >> 1);
		var pqr = ((p + 2*q + r + 2) >> 2);
		var qrs = ((q + 2*r + s + 2) >> 2);
		var rss = ((r + 2*s + s + 2) >> 2);
		var sss = (s);
		ybr[y+0][x+0] = pq;
		ybr[y+0][x+1] = pqr;
		ybr[y+0][x+2] = qr;
		ybr[y+0][x+3] = qrs;
		ybr[y+1][x+0] = qr;
		ybr[y+1][x+1] = qrs;
		ybr[y+1][x+2] = rs;
		ybr[y+1][x+3] = rss;
		ybr[y+2][x+0] = rs;
		ybr[y+2][x+1] = rss;
		ybr[y+2][x+2] = sss;
		ybr[y+2][x+3] = sss;
		ybr[y+3][x+0] = sss;
		ybr[y+3][x+1] = sss;
		ybr[y+3][x+2] = sss;
		ybr[y+3][x+3] = sss;
	}

	static function predFunc8DC(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (8);
		for (i in 0...8) {
			sum += (ybr[y-1][x+i]);
		}
		for (j in 0...8) {
			sum += (ybr[y+j][x-1]);
		}
		var avg = (sum >> 4);
		for (j in 0...8) {
			for (i in 0...8) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc8TM(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var delta0 = -(ybr[y-1][x-1]);
		for (j in 0...8) {
			var delta1 = delta0 + (ybr[y+j][x-1]);
			for (i in 0...8) {
				var delta2 = delta1 + (ybr[y-1][x+i]);
				ybr[y+j][x+i] = clip8(delta2);
			}
		}
	}

	static function predFunc8VE(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		for (j in 0...8) {
			for (i in 0...8) {
				ybr[y+j][x+i] = ybr[y-1][x+i];
			}
		}
	}

	static function predFunc8HE(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		for (j in 0...8) {
			for (i in 0...8) {
				ybr[y+j][x+i] = ybr[y+j][x-1];
			}
		}
	}

	static function predFunc8DCTop(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (4);
		for (j in 0...8) {
			sum += (ybr[y+j][x-1]);
		}
		var avg = (sum >> 3);
		for (j in 0...8) {
			for (i in 0...8) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc8DCLeft(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (4);
		for (i in 0...8) {
			sum += (ybr[y-1][x+i]);
		}
		var avg = (sum >> 3);
		for (j in 0...8) {
			for (i in 0...8) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc8DCTopLeft(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		for (j in 0...8) {
			for (i in 0...8) {
				ybr[y+j][x+i] = 0x80;
			}
		}
	}

	static function predFunc16DC(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (16);
		for (i in 0...16) {
			sum += (ybr[y-1][x+i]);
		}
		for (j in 0...16) {
			sum += (ybr[y+j][x-1]);
		}
		var avg = (sum >> 5);
		for (j in 0...16) {
			for (i in 0...16) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc16TM(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var delta0 = -(ybr[y-1][x-1]);
		for (j in 0...16) {
			var delta1 = delta0 + (ybr[y+j][x-1]);
			for (i in 0...16) {
				var delta2 = delta1 + (ybr[y-1][x+i]);
				ybr[y+j][x+i] = clip8(delta2);
			}
		}
	}

	static function predFunc16VE(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		for (j in 0...16) {
			for (i in 0...16) {
				ybr[y+j][x+i] = ybr[y-1][x+i];
			}
		}
	}

	static function predFunc16HE(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		for (j in 0...16) {
			for (i in 0...16) {
				ybr[y+j][x+i] = ybr[y+j][x-1];
			}
		}
	}

	static function predFunc16DCTop(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (8);
		for (j in 0...16) {
			sum += (ybr[y+j][x-1]);
		}
		var avg = (sum >> 4);
		for (j in 0...16) {
			for (i in 0...16) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc16DCLeft(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		var sum = (8);
		for (i in 0...16) {
			sum += (ybr[y-1][x+i]);
		}
		var avg = (sum >> 4);
		for (j in 0...16) {
			for (i in 0...16) {
				ybr[y+j][x+i] = avg;
			}
		}
	}

	static function predFunc16DCTopLeft(ybr:Array<Array<Int>>, y:Int, x:Int):Void {
		for (j in 0...16) {
			for (i in 0...16) {
				ybr[y+j][x+i] = 0x80;
			}
		}
	}
}
