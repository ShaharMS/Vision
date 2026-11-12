package vision.formats._internal.images.avif.av1;

import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1Coefficients.Av1CoefficientClass;
import vision.formats._internal.images.avif.av1.Av1IntraPrediction.Av1IntraMode;
import vision.formats._internal.images.avif.av1.Av1InverseTransform.Av1TransformKernel;

/** Prediction and transform parameters of an intra coding block. **/
typedef Av1IntraBlock = {
	final skip:Bool;
	final lumaMode:Av1IntraMode;
	final chromaMode:Int;
	final lumaAngle:Int;
	final chromaAngle:Int;
	final alphaU:Int;
	final alphaV:Int;
	final filter:Int;
	final transformWidth:Int;
	final transformHeight:Int;
}

/** The pair of inverse transform kernels and its coefficient scan class. **/
typedef Av1IntraTransform = {
	final horizontal:Av1TransformKernel;
	final vertical:Av1TransformKernel;
	final scan:Av1CoefficientClass;
}

/** Reads intra prediction and transform modes for a key-frame tile. **/
@:noCompletion
class Av1IntraBlockReader {
	static final modeContext = [0, 1, 2, 3, 4, 4, 4, 4, 3, 0, 1, 2, 0];
	static final blockWidths = [4, 4, 8, 8, 8, 16, 16, 16, 32, 32, 32, 64, 64, 64, 128, 128, 4, 16, 8, 32, 16, 64];
	static final blockHeights = [4, 8, 4, 8, 16, 8, 16, 32, 16, 32, 64, 32, 64, 128, 64, 128, 16, 4, 32, 8, 64, 16];
	static final maxDepth = [0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 2, 2, 3, 3, 4, 4];
	static final chromaTransforms = [0, 1, 2, 0, 3, 1, 2, 2, 1, 3, 1, 2, 3, 0];
	static final fullTransformSet = [9, 0, 10, 11, 3, 1, 2];
	static final smallTransformSet = [9, 0, 3, 1, 2];
	static final filterDirections = [0, 1, 2, 6, 0];

	final symbols:Av1SymbolDecoder;
	final sequence:Av1SequenceHeader;
	final frame:Av1StillFrameHeader;
	final tileLeft:Int;
	final tileTop:Int;
	final above:Array<Av1IntraBlock> = [];
	final left:Array<Av1IntraBlock> = [];
	final skip = [[31671, 32768, 0], [16515, 32768, 0], [4576, 32768, 0]];
	final yMode = copy(Av1IntraBlockTables.yMode);
	final uvMode = copy(Av1IntraBlockTables.uvMode);
	final uvModeCfl = copy(Av1IntraBlockTables.uvModeCfl);
	final angle = copy(Av1IntraBlockTables.angle);
	final filter = copy(Av1IntraBlockTables.filter);
	final filterMode = Av1IntraBlockTables.filterMode[0].copy();
	final cflSign = Av1IntraBlockTables.cflSign[0].copy();
	final cflAlpha = copy(Av1IntraBlockTables.cflAlpha);
	final depth = [
		copy(Av1IntraBlockTables.depth8), copy(Av1IntraBlockTables.depth16),
		copy(Av1IntraBlockTables.depth32), copy(Av1IntraBlockTables.depth64)
	];
	final transform1 = copy(Av1IntraBlockTables.transform1);
	final transform2 = copy(Av1IntraBlockTables.transform2);

	public function new(symbols:Av1SymbolDecoder, sequence:Av1SequenceHeader, frame:Av1StillFrameHeader, tileLeft:Int, tileTop:Int) {
		this.symbols = symbols;
		this.sequence = sequence;
		this.frame = frame;
		this.tileLeft = tileLeft;
		this.tileTop = tileTop;
	}

	/** Reads one block without segmentation, screen-content tools or block-level quantizer deltas. **/
	public function read(x:Int, y:Int, width:Int, height:Int, hasChroma:Bool, ?cdef:Av1Cdef):Av1IntraBlock {
		final aboveBlock = y > tileTop ? above[x - tileLeft] : null;
		final leftBlock = x > tileLeft ? left[y - tileTop] : null;
		final skipContext = (aboveBlock != null && aboveBlock.skip ? 1 : 0) + (leftBlock != null && leftBlock.skip ? 1 : 0);
		final skipped = symbols.readSymbol(skip[skipContext]) != 0;
		if (cdef != null) cdef.readBlock(symbols, x * 4, y * 4, width, height, skipped);
		final aboveMode = aboveBlock == null ? 0 : modeContext[aboveBlock.lumaMode];
		final leftMode = leftBlock == null ? 0 : modeContext[leftBlock.lumaMode];
		final lumaMode:Av1IntraMode = symbols.readSymbol(yMode[aboveMode * 5 + leftMode]);
		final block = blockIndex(width, height);
		final yAngle = readAngle(lumaMode, block >= 3);
		var chromaMode = 0;
		var alphaU = 0;
		var alphaV = 0;
		var uvAngle = 0;
		if (hasChroma) {
			final chromaWidth = max(4, width >> (sequence.subsamplingX ? 1 : 0));
			final chromaHeight = max(4, height >> (sequence.subsamplingY ? 1 : 0));
			final allowCfl = frame.lossless ? chromaWidth == 4 && chromaHeight == 4 : max(width, height) <= 32;
			chromaMode = symbols.readSymbol((allowCfl ? uvModeCfl : uvMode)[lumaMode]);
			if (chromaMode == 13) {
				final code = symbols.readSymbol(cflSign) + 1;
				final uSign = Std.int(code / 3);
				final vSign = code % 3;
				alphaU = readAlpha(uSign, vSign);
				alphaV = readAlpha(vSign, uSign);
			}
			uvAngle = readAngle(chromaMode, block >= 3);
		}
		final intraFilter = sequence.filterIntra && lumaMode == Dc && max(width, height) <= 32
			&& symbols.readSymbol(filter[block]) != 0 ? symbols.readSymbol(filterMode) : -1;
		var transformWidth = frame.lossless ? 4 : min(width, 64);
		var transformHeight = frame.lossless ? 4 : min(height, 64);
		if (!frame.lossless && block > 0 && frame.selectableTransform) {
			final context = (aboveBlock != null && aboveBlock.transformWidth >= transformWidth ? 1 : 0)
				+ (leftBlock != null && leftBlock.transformHeight >= transformHeight ? 1 : 0);
			final levels = symbols.readSymbol(depth[maxDepth[block] - 1][context]);
			for (_ in 0...levels) {
				final originalWidth = transformWidth;
				if (originalWidth >= transformHeight) transformWidth >>= 1;
				if (transformHeight >= originalWidth) transformHeight >>= 1;
			}
		}
		final result:Av1IntraBlock = {
			skip: skipped, lumaMode: lumaMode, chromaMode: chromaMode, lumaAngle: yAngle, chromaAngle: uvAngle,
			alphaU: alphaU, alphaV: alphaV, filter: intraFilter, transformWidth: transformWidth, transformHeight: transformHeight
		};
		for (column in x - tileLeft...x - tileLeft + (width >> 2)) above[column] = result;
		for (row in y - tileTop...y - tileTop + (height >> 2)) left[row] = result;
		return result;
	}

	/** Reads the luma transform symbol or derives chroma's transform from its mode. **/
	public function readTransform(block:Av1IntraBlock, plane:Int, width:Int, height:Int):Av1IntraTransform {
		var type = 0;
		if (!frame.lossless && max(width, height) < 32) {
			if (plane == 0 && frame.baseQuantizer > 0) {
				final direction = block.filter < 0 ? (block.lumaMode:Int) : filterDirections[block.filter];
				final smallSide = min(width, height);
				final size = smallSide == 4 ? 0 : smallSide == 8 ? 1 : 2;
				if (frame.reducedTransformSet || size == 2)
					type = smallTransformSet[symbols.readSymbol(transform2[size * 13 + direction])];
				else type = fullTransformSet[symbols.readSymbol(transform1[size * 13 + direction])];
			} else if (plane != 0) type = chromaTransforms[block.chromaMode];
		}
		return switch type {
			case 1: {horizontal: Dct, vertical: Adst, scan: TwoDimensional};
			case 2: {horizontal: Adst, vertical: Dct, scan: TwoDimensional};
			case 3: {horizontal: Adst, vertical: Adst, scan: TwoDimensional};
			case 9: {horizontal: Identity, vertical: Identity, scan: TwoDimensional};
			case 10: {horizontal: Identity, vertical: Dct, scan: Vertical};
			case 11: {horizontal: Dct, vertical: Identity, scan: Horizontal};
			default: {horizontal: Dct, vertical: Dct, scan: TwoDimensional};
		}
	}

	function readAngle(mode:Int, enabled:Bool):Int {
		return enabled && mode >= 1 && mode <= 8 ? symbols.readSymbol(angle[mode - 1]) - 3 : 0;
	}

	function readAlpha(sign:Int, otherSign:Int):Int {
		if (sign == 0) return 0;
		final magnitude = symbols.readSymbol(cflAlpha[(sign - 1) * 3 + otherSign]) + 1;
		return sign == 1 ? -magnitude : magnitude;
	}

	static function blockIndex(width:Int, height:Int):Int {
		for (i in 0...blockWidths.length) if (width == blockWidths[i] && height == blockHeights[i]) return i;
		throw new Av1BitstreamError("Invalid AV1 intra block size.");
	}

	static function copy(tables:Array<Array<Int>>):Array<Array<Int>> return [for (table in tables) table.copy()];
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
	static inline function max(a:Int, b:Int):Int return a > b ? a : b;
}
