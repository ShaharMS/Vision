package vision.helpers;

import haxe.xml.Access;
using vision.helpers.SvgParser.Floatify;

enum SvgInstruction {
	Path(pathType:String);
	Circle(cx:Float, cy:Float, r:Float);
	Ellipse(cx:Float, cy:Float, rx:Float, ry:Float);
	Rect(x:Float, y:Float, width:Float, height:Float);
	Line(x1:Float, y1:Float, x2:Float, y2:Float);
	Polyline(points:Array<Float>);
	Polygon(points:Array<Float>);
	Text(x:Float, y:Float, text:String);
}

function parseSvg(svg:String):Array<SvgInstruction> {
	// parse the SVG string into an XML object
	var xml = new Access(Xml.parse(svg));

	// create an array to hold the SVG instructions
	var instructions = new Array<SvgInstruction>();

	// loop through the children of the SVG element
	for (child in xml.elements) {
		// get the name and attributes of the current element
		var name = child.name;
		var attrs = child.att;

		// create an SVG instruction based on the name and attributes of the element
		switch (name) {
			case "path": 
                var pathType = attrs.d;
				instructions.push(SvgInstruction.Path(pathType));
			case "circle": instructions.push(SvgInstruction.Circle(attrs.cx.f(), attrs.cy.f(), attrs.r.f()));
			case "ellipse": instructions.push(SvgInstruction.Ellipse(attrs.cx.f(), attrs.cy.f(), attrs.rx.f(), attrs.ry.f()));
		    case "rect": instructions.push(SvgInstruction.Rect(attrs.x.f(), attrs.y.f(), attrs.width.f(), attrs.height.f()));
		    case "line": instructions.push(SvgInstruction.Line(attrs.x1.f(), attrs.y1.f(), attrs.x2.f(), attrs.y2.f()));
		    case "polyline": instructions.push(SvgInstruction.Polyline(attrs.points.split(" ").map(x -> Std.parseFloat(x)).filter(x -> x != null)));
		    case "polygon": instructions.push(SvgInstruction.Polygon(attrs.points.split(" ").map(x -> Std.parseFloat(x)).filter(x -> x != null)));
		    case "text": instructions.push(SvgInstruction.Text(attrs.x.f(), attrs.y.f(), child.innerData));
	    }
    }
    return instructions;
}

class Floatify {
    public static function f(s:String):Float {
        return Std.parseFloat(s);
    }
}