package vision.ds.specifics;

import vision.ds.Color;

@:structInit
class TextOptions {
	/** Font family or comma-separated fallback families. **/
	public var fontFamily:String = "sans-serif";
	/** Font size in pixels. **/
	public var size:Float = 16;
	/** Font weight from 1 to 1000. **/
	public var weight:Int = 400;
	public var italic:Bool = false;
	public var color:Color = Color.BLACK;
	/** Uses a right-to-left paragraph direction and anchors each line at its right edge. **/
	public var rightToLeft:Bool = false;
	/** Distance between line tops in pixels. Zero uses 1.25 times the font size. **/
	public var lineHeight:Float = 0;
}
