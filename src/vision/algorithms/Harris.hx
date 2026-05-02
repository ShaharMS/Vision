package vision.algorithms;

import vision.ds.HarrisCorner2D;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.specifics.HarrisCornerOptions;
import vision.ds.specifics.HarrisResponseOptions;

class Harris {
	public static function createResponseMap(width:Int, height:Int):Matrix2D {
		var response = new Matrix2D(width, height);
		response.fill(0);
		return response;
	}

	public static function computeResponse(image:Image, ?options:HarrisResponseOptions):Matrix2D {
		resolveResponseOptions(options);
		return createResponseMap(image.width, image.height);
	}

	public static function detectCorners(image:Image, ?options:HarrisCornerOptions):Array<HarrisCorner2D> {
		var resolvedOptions = resolveCornerOptions(options);
		computeResponse(image, resolvedOptions);
		return [];
	}

	static inline function resolveResponseOptions(?options:HarrisResponseOptions):HarrisResponseOptions {
		return options == null ? new HarrisResponseOptions() : options;
	}

	static inline function resolveCornerOptions(?options:HarrisCornerOptions):HarrisCornerOptions {
		return options == null ? new HarrisCornerOptions() : options;
	}
}