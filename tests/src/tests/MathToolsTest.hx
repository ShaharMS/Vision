package tests;

import haxe.Int64;
import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.Ray2D;
import vision.ds.Rectangle;
import vision.tools.MathTools;

@:access(vision.tools.MathTools)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class MathToolsTest extends utest.Test {
	function assertPoint(point:Point2D, expectedX:Float, expectedY:Float):Void {
		ApproxAssertions.equalsFloat(expectedX, point.x);
		ApproxAssertions.equalsFloat(expectedY, point.y);
	}

	function diagonalRay(?yOffset:Float = 0):Ray2D {
		return new Ray2D(new Point2D(0, yOffset), 1);
	}

	function horizontalLine(y:Float):Line2D {
		return new Line2D(new Point2D(0, y), new Point2D(4, y));
	}

	@:visionTestId("vision.tools.MathTools.PI#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_PI__default() {
		ApproxAssertions.equalsFloat(Math.PI, MathTools.PI);
	}

	@:visionTestId("vision.tools.MathTools.PI_OVER_2#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_PI_OVER_2__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, MathTools.PI_OVER_2);
	}

	@:visionTestId("vision.tools.MathTools.NEGATIVE_INFINITY#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_NEGATIVE_INFINITY__default() {
		Assert.isFalse(Math.isFinite(MathTools.NEGATIVE_INFINITY));
		Assert.isTrue(MathTools.NEGATIVE_INFINITY < 0);
	}

	@:visionTestId("vision.tools.MathTools.POSITIVE_INFINITY#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_POSITIVE_INFINITY__default() {
		Assert.isFalse(Math.isFinite(MathTools.POSITIVE_INFINITY));
		Assert.isTrue(MathTools.POSITIVE_INFINITY > 0);
	}

	@:visionTestId("vision.tools.MathTools.NaN#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_NaN__default() {
		Assert.isTrue(Math.isNaN(MathTools.NaN));
	}

	@:visionTestId("vision.tools.MathTools.SQRT2#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_SQRT2__default() {
		ApproxAssertions.equalsFloat(Math.sqrt(2), MathTools.SQRT2);
	}

	@:visionTestId("vision.tools.MathTools.SQRT3#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_SQRT3__default() {
		ApproxAssertions.equalsFloat(Math.sqrt(3), MathTools.SQRT3);
	}

	@:visionTestId("vision.tools.MathTools.distanceFromRayToPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceFromRayToPoint2D__default() {
		ApproxAssertions.equalsFloat(5, MathTools.distanceFromRayToPoint2D(new Ray2D(new Point2D(0, 0), 0), new Point2D(0, 5)));
	}

	@:visionTestId("vision.tools.MathTools.intersectionBetweenRay2Ds#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_intersectionBetweenRay2Ds__default() {
		assertPoint(MathTools.intersectionBetweenRay2Ds(diagonalRay(), new Ray2D(new Point2D(0, 2), -1)), 1, 1);
	}

	@:visionTestId("vision.tools.MathTools.distanceBetweenRays2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceBetweenRays2D__default() {
		ApproxAssertions.equalsFloat(MathTools.SQRT2, MathTools.distanceBetweenRays2D(diagonalRay(), diagonalRay(2)));
	}

	@:visionTestId("vision.tools.MathTools.findPointAtDistanceUsingX#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_findPointAtDistanceUsingX__default() {
		assertPoint(MathTools.findPointAtDistanceUsingX(diagonalRay(), 1, MathTools.SQRT2, false), 0, 0);
	}

	@:visionTestId("vision.tools.MathTools.findPointAtDistanceUsingY#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_findPointAtDistanceUsingY__default() {
		assertPoint(MathTools.findPointAtDistanceUsingY(diagonalRay(), 1, MathTools.SQRT2, false), 0, 0);
	}

	@:visionTestId("vision.tools.MathTools.distanceFromLineToPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceFromLineToPoint2D__default() {
		ApproxAssertions.equalsFloat(3, MathTools.distanceFromLineToPoint2D(horizontalLine(0), new Point2D(0, 3)));
	}

	@:visionTestId("vision.tools.MathTools.distanceBetweenLines2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceBetweenLines2D__default() {
		ApproxAssertions.equalsFloat(MathTools.SQRT2, MathTools.distanceBetweenLines2D(new Line2D(new Point2D(0, 0), new Point2D(4, 4)), new Line2D(new Point2D(4, 6), new Point2D(0, 2))));
	}

	@:visionTestId("vision.tools.MathTools.radiansFromLineToPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansFromLineToPoint2D__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, MathTools.radiansFromLineToPoint2D(horizontalLine(0), new Point2D(0, 1)));
	}

	@:visionTestId("vision.tools.MathTools.intersectionBetweenLine2Ds#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_intersectionBetweenLine2Ds__default() {
		assertPoint(MathTools.intersectionBetweenLine2Ds(new Line2D(new Point2D(0, 0), new Point2D(4, 4)), new Line2D(new Point2D(0, 4), new Point2D(4, 0))), 2, 2);
	}

	@:visionTestId("vision.tools.MathTools.mirrorInsideRectangle#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_mirrorInsideRectangle__default() {
		var line = new Line2D(new Point2D(1, 2), new Point2D(3, 4));
		var rect:Rectangle = {x: 0, y: 0, width: 10, height: 10};
		var result = MathTools.mirrorInsideRectangle(line, rect);
		assertPoint(result.start, 9, 2);
		assertPoint(result.end, 7, 4);
	}

	@:visionTestId("vision.tools.MathTools.flipInsideRectangle#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flipInsideRectangle__default() {
		var line = new Line2D(new Point2D(1, 2), new Point2D(3, 4));
		var rect:Rectangle = {x: 0, y: 0, width: 10, height: 10};
		var result = MathTools.flipInsideRectangle(line, rect);
		assertPoint(result.start, 1, 8);
		assertPoint(result.end, 3, 6);
	}

	@:visionTestId("vision.tools.MathTools.invertInsideRectangle#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_invertInsideRectangle__default() {
		var line = new Line2D(new Point2D(1, 2), new Point2D(3, 4));
		var rect:Rectangle = {x: 0, y: 0, width: 10, height: 10};
		var result = MathTools.invertInsideRectangle(line, rect);
		assertPoint(result.start, 9, 8);
		assertPoint(result.end, 7, 6);
	}

	@:visionTestId("vision.tools.MathTools.distanceFromPointToRay2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceFromPointToRay2D__default() {
		ApproxAssertions.equalsFloat(5, MathTools.distanceFromPointToRay2D(new Point2D(0, 5), new Ray2D(new Point2D(0, 0), 0)));
	}

	@:visionTestId("vision.tools.MathTools.distanceFromPointToLine2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceFromPointToLine2D__default() {
		ApproxAssertions.equalsFloat(3, MathTools.distanceFromPointToLine2D(new Point2D(0, 3), horizontalLine(0)));
	}

	@:visionTestId("vision.tools.MathTools.radiansFromPointToLine2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansFromPointToLine2D__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, MathTools.radiansFromPointToLine2D(new Point2D(0, 1), horizontalLine(0)));
	}

	@:visionTestId("vision.tools.MathTools.radiansFromPointToPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansFromPointToPoint2D__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, MathTools.radiansFromPointToPoint2D(new Point2D(0, 0), new Point2D(0, 1)));
	}

	@:visionTestId("vision.tools.MathTools.degreesFromPointToPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degreesFromPointToPoint2D__default() {
		ApproxAssertions.equalsFloat(90, MathTools.degreesFromPointToPoint2D(new Point2D(0, 0), new Point2D(0, 1)));
	}

	@:visionTestId("vision.tools.MathTools.slopeFromPointToPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_slopeFromPointToPoint2D__default() {
		ApproxAssertions.equalsFloat(1, MathTools.slopeFromPointToPoint2D(new Point2D(0, 0), new Point2D(1, 1)));
	}

	@:visionTestId("vision.tools.MathTools.distanceBetweenPoints#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceBetweenPoints__default() {
		ApproxAssertions.equalsFloat(5, MathTools.distanceBetweenPoints(new Point2D(0, 0), new Point2D(3, 4)));
	}

	@:visionTestId("vision.tools.MathTools.getClosestPointOnRay2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getClosestPointOnRay2D__default() {
		assertPoint(MathTools.getClosestPointOnRay2D(new Point2D(2, 3), diagonalRay()), 2.5, 2.5);
	}

	@:visionTestId("vision.tools.MathTools.clamp#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_clamp__default() {
		Assert.equals(10, MathTools.clamp(15, 0, 10));
	}

	@:visionTestId("vision.tools.MathTools.isBetweenRanges#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_isBetweenRanges__default() {
		Assert.isTrue(MathTools.isBetweenRanges(3, {start: 0, end: 2}));
	}

	@:visionTestId("vision.tools.MathTools.isBetweenRange#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_isBetweenRange__default() {
		Assert.isTrue(MathTools.isBetweenRange(11, 0, 10));
	}

	@:visionTestId("vision.tools.MathTools.wrapInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_wrapInt__default() {
		Assert.equals(1, MathTools.wrapInt(12, 0, 10));
	}

	@:visionTestId("vision.tools.MathTools.wrapFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_wrapFloat__default() {
		ApproxAssertions.equalsFloat(2.5, MathTools.wrapFloat(12.5, 0, 10));
	}

	@:visionTestId("vision.tools.MathTools.boundInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_boundInt__default() {
		Assert.equals(10, MathTools.boundInt(12, 0, 10));
	}

	@:visionTestId("vision.tools.MathTools.boundFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_boundFloat__default() {
		ApproxAssertions.equalsFloat(0, MathTools.boundFloat(-1.5, 0, 10));
	}

	@:visionTestId("vision.tools.MathTools.isPositive#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_isPositive__default() {
		Assert.isTrue(MathTools.isPositive(5));
	}

	@:visionTestId("vision.tools.MathTools.gamma#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_gamma__default() {
		ApproxAssertions.equalsFloat(1, MathTools.gamma(1));
	}

	@:visionTestId("vision.tools.MathTools.factorial#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_factorial__default() {
		ApproxAssertions.equalsFloat(120, MathTools.factorial(5));
	}

	@:visionTestId("vision.tools.MathTools.slopeToDegrees#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_slopeToDegrees__default() {
		ApproxAssertions.equalsFloat(45, MathTools.slopeToDegrees(1));
	}

	@:visionTestId("vision.tools.MathTools.slopeToRadians#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_slopeToRadians__default() {
		ApproxAssertions.equalsFloat(Math.PI / 4, MathTools.slopeToRadians(1));
	}

	@:visionTestId("vision.tools.MathTools.degreesToSlope#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degreesToSlope__default() {
		ApproxAssertions.equalsFloat(1, MathTools.degreesToSlope(45));
	}

	@:visionTestId("vision.tools.MathTools.degreesToRadians#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degreesToRadians__default() {
		ApproxAssertions.equalsFloat(Math.PI, MathTools.degreesToRadians(180));
	}

	@:visionTestId("vision.tools.MathTools.radiansToDegrees#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansToDegrees__default() {
		ApproxAssertions.equalsFloat(90, MathTools.radiansToDegrees(Math.PI / 2));
	}

	@:visionTestId("vision.tools.MathTools.radiansToSlope#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansToSlope__default() {
		ApproxAssertions.equalsFloat(1, MathTools.radiansToSlope(Math.PI / 4));
	}

	@:visionTestId("vision.tools.MathTools.cotan#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cotan__default() {
		ApproxAssertions.equalsFloat(1, MathTools.cotan(Math.PI / 4));
	}

	@:visionTestId("vision.tools.MathTools.cosec#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cosec__default() {
		ApproxAssertions.equalsFloat(1, MathTools.cosec(Math.PI / 2));
	}

	@:visionTestId("vision.tools.MathTools.sec#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_sec__default() {
		ApproxAssertions.equalsFloat(1, MathTools.sec(0));
	}

	@:visionTestId("vision.tools.MathTools.sind#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_sind__default() {
		ApproxAssertions.equalsFloat(0.5, MathTools.sind(30));
	}

	@:visionTestId("vision.tools.MathTools.cosd#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cosd__default() {
		ApproxAssertions.equalsFloat(0.5, MathTools.cosd(60));
	}

	@:visionTestId("vision.tools.MathTools.tand#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_tand__default() {
		ApproxAssertions.equalsFloat(1, MathTools.tand(45));
	}

	@:visionTestId("vision.tools.MathTools.cotand#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cotand__default() {
		ApproxAssertions.equalsFloat(1, MathTools.cotand(45));
	}

	@:visionTestId("vision.tools.MathTools.cosecd#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cosecd__default() {
		ApproxAssertions.equalsFloat(1, MathTools.cosecd(90));
	}

	@:visionTestId("vision.tools.MathTools.secd#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_secd__default() {
		ApproxAssertions.equalsFloat(2, MathTools.secd(60));
	}

	@:visionTestId("vision.tools.MathTools.truncate#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_truncate__default() {
		ApproxAssertions.equalsFloat(1.24, MathTools.truncate(1.239, 2));
	}

	@:visionTestId("vision.tools.MathTools.cropDecimal#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cropDecimal__default() {
		Assert.equals(-1, MathTools.cropDecimal(-1.8));
	}

	@:visionTestId("vision.tools.MathTools.max#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_max__default() {
		Assert.equals(5, MathTools.max(1, 5, 3));
	}

	@:visionTestId("vision.tools.MathTools.min#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_min__default() {
		Assert.equals(1, MathTools.min(5, 1, 3));
	}

	@:visionTestId("vision.tools.MathTools.average#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_average__default() {
		ApproxAssertions.equalsFloat(2, MathTools.average(1, 2, 3));
	}

	@:visionTestId("vision.tools.MathTools.median#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_median__default() {
		Assert.equals(3, MathTools.median(4, 1, 3, 2));
	}

	@:visionTestId("vision.tools.MathTools.isInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_isInt__default() {
		Assert.isTrue(MathTools.isInt(2.0));
	}

	@:visionTestId("vision.tools.MathTools.toFloat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toFloat__default() {
		ApproxAssertions.equalsFloat(42, MathTools.toFloat(Int64.make(0, 42)));
	}

	@:visionTestId("vision.tools.MathTools.abs#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_abs__default() {
		ApproxAssertions.equalsFloat(2, MathTools.abs(-2));
	}

	@:visionTestId("vision.tools.MathTools.acos#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_acos__default() {
		ApproxAssertions.equalsFloat(0, MathTools.acos(1));
	}

	@:visionTestId("vision.tools.MathTools.asin#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_asin__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, MathTools.asin(1));
	}

	@:visionTestId("vision.tools.MathTools.atan#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_atan__default() {
		ApproxAssertions.equalsFloat(Math.PI / 4, MathTools.atan(1));
	}

	@:visionTestId("vision.tools.MathTools.atan2#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_atan2__default() {
		ApproxAssertions.equalsFloat(Math.PI / 4, MathTools.atan2(1, 1));
	}

	@:visionTestId("vision.tools.MathTools.ceil#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_ceil__default() {
		Assert.equals(2, MathTools.ceil(1.2));
	}

	@:visionTestId("vision.tools.MathTools.cos#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_cos__default() {
		ApproxAssertions.equalsFloat(-1, MathTools.cos(Math.PI));
	}

	@:visionTestId("vision.tools.MathTools.exp#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_exp__default() {
		ApproxAssertions.equalsFloat(Math.exp(1), MathTools.exp(1));
	}

	@:visionTestId("vision.tools.MathTools.floor#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_floor__default() {
		Assert.equals(1, MathTools.floor(1.8));
	}

	@:visionTestId("vision.tools.MathTools.log#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_log__default() {
		ApproxAssertions.equalsFloat(0, MathTools.log(1));
	}

	@:visionTestId("vision.tools.MathTools.pow#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_pow__default() {
		ApproxAssertions.equalsFloat(8, MathTools.pow(2, 3));
	}

	@:visionTestId("vision.tools.MathTools.random#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_random__default() {
		var value = MathTools.random();
		Assert.isTrue(value >= 0);
		Assert.isTrue(value < 1);
	}

	@:visionTestId("vision.tools.MathTools.round#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_round__default() {
		Assert.equals(2, MathTools.round(1.5));
	}

	@:visionTestId("vision.tools.MathTools.sin#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_sin__default() {
		ApproxAssertions.equalsFloat(1, MathTools.sin(Math.PI / 2));
	}

	@:visionTestId("vision.tools.MathTools.sqrt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_sqrt__default() {
		ApproxAssertions.equalsFloat(3, MathTools.sqrt(9));
	}

	@:visionTestId("vision.tools.MathTools.tan#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_tan__default() {
		ApproxAssertions.equalsFloat(1, MathTools.tan(Math.PI / 4));
	}

	@:visionTestId("vision.tools.MathTools.ffloor#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_ffloor__default() {
		ApproxAssertions.equalsFloat(1, MathTools.ffloor(1.8));
	}

	@:visionTestId("vision.tools.MathTools.fceil#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fceil__default() {
		ApproxAssertions.equalsFloat(2, MathTools.fceil(1.2));
	}

	@:visionTestId("vision.tools.MathTools.fround#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fround__default() {
		ApproxAssertions.equalsFloat(2, MathTools.fround(1.5));
	}
}
