package vision.ds.accelerate;

/** Header layout shared by Vision's packed image import and export paths. **/
@:noCompletion
class PixelStorage {
	public static inline final FIELD_BYTES = #if vision_higher_width_cap 4 #else 2 #end;
	public static inline final PIXEL_OFFSET = FIELD_BYTES * 5 + 1;
}
