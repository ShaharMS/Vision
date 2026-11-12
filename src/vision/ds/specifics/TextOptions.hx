package vision.ds.specifics;

import vision.ds.Color;
import vision.ds.TextFont;

@:structInit
class TextOptions {
	/** A font read by Vision. Selects the portable renderer on every target. **/
	public var font:Null<TextFont> = null;
	/** Uses standard ligatures from the portable font when available. **/
	public var ligatures:Bool = true;
	/** Browser font family or comma-separated fallback families. **/
	public var fontFamily:String = "sans-serif";
	/** Font size in pixels. **/
	public var size:Float = 16;
	/** Browser font weight from 1 to 1000. **/
	public var weight:Int = 400;
	/** Requests an italic browser face. **/
	public var italic:Bool = false;
	public var color:Color = Color.BLACK;
	/** Uses a right-to-left paragraph direction and anchors each line at its right edge. **/
	public var rightToLeft:Bool = false;
	/** Distance between line tops in pixels. Zero uses 1.25 times the font size. **/
	public var lineHeight:Float = 0;
}
