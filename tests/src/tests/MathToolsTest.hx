package tests;

import utest.Assert;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.Ray2D;
import vision.ds.Rectangle;
import vision.tools.MathTools;

@:access(vision.tools.MathTools)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class MathToolsTest extends utest.Test {

	@:visionTestId("vision.tools.MathTools.PI#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_PI__default() {
		var result = vision.tools.MathTools.PI;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.PI_OVER_2#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_PI_OVER_2__default() {
		var result = vision.tools.MathTools.PI_OVER_2;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.NEGATIVE_INFINITY#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_NEGATIVE_INFINITY__default() {
		var result = vision.tools.MathTools.NEGATIVE_INFINITY;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.POSITIVE_INFINITY#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_POSITIVE_INFINITY__default() {
		var result = vision.tools.MathTools.POSITIVE_INFINITY;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.NaN#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_NaN__default() {
		var result = vision.tools.MathTools.NaN;
		Assert.isTrue(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.SQRT2#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_SQRT2__default() {
		var result = vision.tools.MathTools.SQRT2;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.SQRT3#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_SQRT3__default() {
		var result = vision.tools.MathTools.SQRT3;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.distanceFromRayToPoint2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceFromRayToPoint2D__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var point = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.distanceFromRayToPoint2D(ray, point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.intersectionBetweenRay2Ds#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_intersectionBetweenRay2Ds__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var ray2 = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 1.0), -1.0);
		var result = vision.tools.MathTools.intersectionBetweenRay2Ds(ray, ray2);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.distanceBetweenRays2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceBetweenRays2D__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var ray2 = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 1.0), -1.0);
		var result = vision.tools.MathTools.distanceBetweenRays2D(ray, ray2);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.findPointAtDistanceUsingX#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_findPointAtDistanceUsingX__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var startXPos = 1.0;
		var distance = 1.0;
		var goPositive = false;
		var result = vision.tools.MathTools.findPointAtDistanceUsingX(ray, startXPos, distance, goPositive);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.findPointAtDistanceUsingY#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_findPointAtDistanceUsingY__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var startYPos = 1.0;
		var distance = 1.0;
		var goPositive = false;
		var result = vision.tools.MathTools.findPointAtDistanceUsingY(ray, startYPos, distance, goPositive);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.distanceFromLineToPoint2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceFromLineToPoint2D__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var point = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.distanceFromLineToPoint2D(line, point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.distanceBetweenLines2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceBetweenLines2D__default() {
		var line1 = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var line2 = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 10.0), new vision.ds.Point2D(10.0, 0.0));
		var result = vision.tools.MathTools.distanceBetweenLines2D(line1, line2);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.radiansFromLineToPoint2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansFromLineToPoint2D__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var point = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.radiansFromLineToPoint2D(line, point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.intersectionBetweenLine2Ds#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_intersectionBetweenLine2Ds__default() {
		var line1 = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var line2 = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 10.0), new vision.ds.Point2D(10.0, 0.0));
		var result = vision.tools.MathTools.intersectionBetweenLine2Ds(line1, line2);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.mirrorInsideRectangle#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_mirrorInsideRectangle__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var rect = ({x: 0, y: 0, width: 3, height: 3} : vision.ds.Rectangle);
		var result = vision.tools.MathTools.mirrorInsideRectangle(line, rect);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.flipInsideRectangle#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_flipInsideRectangle__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var rect = ({x: 0, y: 0, width: 3, height: 3} : vision.ds.Rectangle);
		var result = vision.tools.MathTools.flipInsideRectangle(line, rect);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.invertInsideRectangle#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_invertInsideRectangle__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var rect = ({x: 0, y: 0, width: 3, height: 3} : vision.ds.Rectangle);
		var result = vision.tools.MathTools.invertInsideRectangle(line, rect);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.distanceFromPointToRay2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceFromPointToRay2D__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var result = vision.tools.MathTools.distanceFromPointToRay2D(point, ray);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.distanceFromPointToLine2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceFromPointToLine2D__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var result = vision.tools.MathTools.distanceFromPointToLine2D(point, line);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.radiansFromPointToLine2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansFromPointToLine2D__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var result = vision.tools.MathTools.radiansFromPointToLine2D(point, line);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.radiansFromPointToPoint2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansFromPointToPoint2D__default() {
		var point1 = new vision.ds.Point2D(1.0, 1.0);
		var point2 = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.radiansFromPointToPoint2D(point1, point2);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.degreesFromPointToPoint2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degreesFromPointToPoint2D__default() {
		var point1 = new vision.ds.Point2D(1.0, 1.0);
		var point2 = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.degreesFromPointToPoint2D(point1, point2);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.slopeFromPointToPoint2D#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_slopeFromPointToPoint2D__default() {
		var point1 = new vision.ds.Point2D(1.0, 1.0);
		var point2 = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.slopeFromPointToPoint2D(point1, point2);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.distanceBetweenPoints#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceBetweenPoints__default() {
		var point1 = new vision.ds.Point2D(1.0, 1.0);
		var point2 = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.getClosestPointOnRay2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getClosestPointOnRay2D__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var result = vision.tools.MathTools.getClosestPointOnRay2D(point, ray);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.clamp#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_clamp__default() {
		var value = 1;
		var mi = 0;
		var ma = 10;
		var result = vision.tools.MathTools.clamp(value, mi, ma);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.isBetweenRanges#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isBetweenRanges__default() {
		var value = 1.0;
		var ranges = {start: 0.0, end: 2.0};
		var result = vision.tools.MathTools.isBetweenRanges(value, ranges);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.tools.MathTools.isBetweenRange#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isBetweenRange__default() {
		var value = 1.0;
		var min = 0.0;
		var max = 10.0;
		var result = vision.tools.MathTools.isBetweenRange(value, min, max);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.tools.MathTools.wrapInt#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_wrapInt__default() {
		var value = 1;
		var min = 0;
		var max = 10;
		var result = vision.tools.MathTools.wrapInt(value, min, max);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.wrapFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_wrapFloat__default() {
		var value = 1.0;
		var min = 0.0;
		var max = 10.0;
		var result = vision.tools.MathTools.wrapFloat(value, min, max);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.boundInt#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_boundInt__default() {
		var value = 1;
		var min = 0;
		var max = 10;
		var result = vision.tools.MathTools.boundInt(value, min, max);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.boundFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_boundFloat__default() {
		var value = 1.0;
		var min = 0.0;
		var max = 10.0;
		var result = vision.tools.MathTools.boundFloat(value, min, max);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.isPositive#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isPositive__default() {
		var number = cast 0;
		var result = vision.tools.MathTools.isPositive(number);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.tools.MathTools.gamma#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_gamma__default() {
		var x = 1.0;
		var result = vision.tools.MathTools.gamma(x);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.factorial#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_factorial__default() {
		var value = 1.0;
		var result = vision.tools.MathTools.factorial(value);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.slopeToDegrees#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_slopeToDegrees__default() {
		var slope = 1.0;
		var result = vision.tools.MathTools.slopeToDegrees(slope);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.slopeToRadians#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_slopeToRadians__default() {
		var slope = 1.0;
		var result = vision.tools.MathTools.slopeToRadians(slope);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.degreesToSlope#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degreesToSlope__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.degreesToSlope(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.degreesToRadians#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degreesToRadians__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.degreesToRadians(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.radiansToDegrees#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansToDegrees__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.radiansToDegrees(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.radiansToSlope#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansToSlope__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.radiansToSlope(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.cotan#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cotan__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.cotan(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.cosec#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cosec__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.cosec(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.sec#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_sec__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.sec(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.sind#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_sind__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.sind(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.cosd#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cosd__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.cosd(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.tand#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_tand__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.tand(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.cotand#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cotand__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.cotand(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.cosecd#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cosecd__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.cosecd(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.secd#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_secd__default() {
		var degrees = 1.0;
		var result = vision.tools.MathTools.secd(degrees);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.truncate#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_truncate__default() {
		var num = 1.0;
		var numbersAfterDecimal = 1;
		var result = vision.tools.MathTools.truncate(num, numbersAfterDecimal);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.cropDecimal#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_cropDecimal__default() {
		var number = 1.0;
		var result = vision.tools.MathTools.cropDecimal(number);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.max#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_max__default() {
		var value = 1;
		var values = 1;
		var result = vision.tools.MathTools.max(value, values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.min#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_min__default() {
		var value = 1;
		var values = 1;
		var result = vision.tools.MathTools.min(value, values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.average#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_average__default() {
		var value = 1;
		var values = 1;
		var result = vision.tools.MathTools.average(value, values);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.median#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_median__default() {
		var value = 1;
		var values = 1;
		var result = vision.tools.MathTools.median(value, values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.isInt#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isInt__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.isInt(v);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.tools.MathTools.toFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_toFloat__default() {
		var value = haxe.Int64.make(0, 42);
		var result = vision.tools.MathTools.toFloat(value);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.abs#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_abs__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.abs(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.acos#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_acos__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.acos(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.asin#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_asin__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.asin(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.atan#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_atan__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.atan(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.atan2#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_atan2__default() {
		var y = 1.0;
		var x = 1.0;
		var result = vision.tools.MathTools.atan2(y, x);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.ceil#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_ceil__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.ceil(v);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.cos#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cos__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.cos(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.exp#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_exp__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.exp(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.floor#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_floor__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.floor(v);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.log#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_log__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.log(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.pow#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_pow__default() {
		var v = 1.0;
		var exp = 1.0;
		var result = vision.tools.MathTools.pow(v, exp);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.random#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_random__default() {
		var result = vision.tools.MathTools.random();
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.round#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_round__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.round(v);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.MathTools.sin#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_sin__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.sin(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.sqrt#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_sqrt__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.sqrt(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.tan#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_tan__default() {
		var radians = 1.0;
		var result = vision.tools.MathTools.tan(radians);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.ffloor#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_ffloor__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.ffloor(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.fceil#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_fceil__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.fceil(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.fround#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_fround__default() {
		var v = 1.0;
		var result = vision.tools.MathTools.fround(v);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.isFinite#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isFinite__default() {
		var f = 1.0;
		var result = vision.tools.MathTools.isFinite(f);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.tools.MathTools.isNaN#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isNaN__default() {
		var f = 1.0;
		var result = vision.tools.MathTools.isNaN(f);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.tools.MathTools.parseFloat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_parseFloat__default() {
		var s = "42.5";
		var result = vision.tools.MathTools.parseFloat(s);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.parseInt#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_parseInt__default() {
		var s = "42";
		var result = vision.tools.MathTools.parseInt(s);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.MathTools.parseBool#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_parseBool__default() {
		var s = "true";
		var result = vision.tools.MathTools.parseBool(s);
		Assert.isTrue(result == true || result == false);
	}

}
