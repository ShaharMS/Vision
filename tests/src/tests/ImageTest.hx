package tests;

import tests.support.ApproxAssertions;
import tests.support.CollectionAssertions;
import tests.support.ExceptionAssertions;
import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import utest.Assert;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageView;
import vision.ds.ImageViewShape;
import vision.ds.Point2D;
import vision.ds.Rectangle;

@:access(vision.ds.Image)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageTest extends utest.Test {
function createImage(width:Int = 4, height:Int = 4):Image {
return ManualFixtures.coordinateImage(width, height);
}

function createView():ImageView {
return ManualFixtures.rectangleView(1, 1, 2, 1, ImageViewShape.RECTANGLE);
}

function overlayColor():Color {
return Color.fromRGBA(255, 255, 255, 128);
}

@:visionTestId("vision.ds.Image.underlying#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_underlying__default() {
var instance = new Image(2, 3, 0x11223344);
Assert.isTrue(instance.underlying.length > instance.exportToBytes().length);
Assert.equals(24, instance.exportToBytes().length);
}

@:visionTestId("vision.ds.Image.width#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_width__default() {
Assert.equals(5, ManualFixtures.oddSizedImage().width);
}

@:visionTestId("vision.ds.Image.height#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_height__default() {
Assert.equals(3, ManualFixtures.oddSizedImage().height);
}

@:visionTestId("vision.ds.Image.view#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_view__default() {
ImageAssertions.viewEquals({x: 0, y: 0, width: 0, height: 0, shape: ImageViewShape.RECTANGLE}, createImage().view);
}

@:visionTestId("vision.ds.Image.getPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_getPixel__default() {
ImageAssertions.pixelEquals(createImage(3, 3), 2, 1, ManualFixtures.coordinateColor(2, 1));
}

@:visionTestId("vision.ds.Image.getPixel#outOfBounds")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_getPixel__outOfBounds() {
var instance = createImage(3, 3);
ExceptionAssertions.throwsType(() -> instance.getPixel(-1, 0), vision.exceptions.OutOfBounds);
}

@:visionTestId("vision.ds.Image.getSafePixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_getSafePixel__default() {
var instance = createImage(3, 3);
ImageAssertions.colorEquals(ManualFixtures.coordinateColor(0, 2), instance.getSafePixel(-4, 9));
}

@:visionTestId("vision.ds.Image.getFloatingPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_getFloatingPixel__default() {
var result = ManualFixtures.interpolationImage().getFloatingPixel(0.5, 0.5);
ImageAssertions.colorApproxEquals(Color.fromRGBA(63, 63, 63, 255), result);
}

@:visionTestId("vision.ds.Image.setPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_setPixel__default() {
var instance = createImage();
var color = Color.fromRGBA(200, 10, 20, 255);
instance.setPixel(1, 2, color);
ImageAssertions.pixelEquals(instance, 1, 2, color);
}

@:visionTestId("vision.ds.Image.setSafePixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_setSafePixel__default() {
var instance = createImage(3, 3);
var color = Color.fromRGBA(10, 20, 30, 255);
instance.setSafePixel(-5, 7, color);
ImageAssertions.pixelEquals(instance, 0, 2, color);
}

@:visionTestId("vision.ds.Image.setFloatingPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_setFloatingPixel__default() {
var instance = new Image(2, 2, 0x00000000);
instance.setFloatingPixel(0.5, 0.5, 0xFFFFFFFF);
ImageAssertions.pixelApproxEquals(instance, 0, 0, Color.fromRGBA(127, 127, 127, 255));
ImageAssertions.pixelApproxEquals(instance, 1, 1, Color.fromRGBA(127, 127, 127, 255));
}

@:visionTestId("vision.ds.Image.paintPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_paintPixel__default() {
var instance = new Image(1, 1, 0xFF000000);
instance.paintPixel(0, 0, overlayColor());
ImageAssertions.pixelApproxEquals(instance, 0, 0, Color.fromRGBA(128, 128, 128, 255), 2);
}

@:visionTestId("vision.ds.Image.paintFloatingPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_paintFloatingPixel__default() {
var instance = new Image(2, 2, 0xFF000000);
instance.paintFloatingPixel(0.5, 0.5, 0xFFFFFFFF);
ImageAssertions.pixelApproxEquals(instance, 0, 0, Color.fromRGBA(127, 127, 127, 255), 2);
}

@:visionTestId("vision.ds.Image.paintSafePixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_paintSafePixel__default() {
var instance = new Image(3, 3, 0xFF000000);
instance.paintSafePixel(-1, 8, 0xFFFFFFFF);
ImageAssertions.pixelEquals(instance, 0, 2, 0xFFFFFFFF);
}

@:visionTestId("vision.ds.Image.hasPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_hasPixel__default() {
var instance = createImage(3, 3);
Assert.isTrue(instance.hasPixel(2, 2));
Assert.isFalse(instance.hasPixel(3, 2));
}

@:visionTestId("vision.ds.Image.movePixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_movePixel__default() {
var instance = createImage(3, 3);
var original = instance.getPixel(0, 0);
instance.movePixel(0, 0, 2, 1, 0x00000000);
ImageAssertions.pixelEquals(instance, 2, 1, original);
ImageAssertions.pixelEquals(instance, 0, 0, 0x00000000);
}

@:visionTestId("vision.ds.Image.moveSafePixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_moveSafePixel__default() {
var instance = createImage(3, 3);
var original = instance.getPixel(0, 0);
instance.moveSafePixel(0, 0, 10, 10, 0x00000000);
ImageAssertions.pixelEquals(instance, 2, 2, original);
ImageAssertions.pixelEquals(instance, 0, 0, 0x00000000);
}

@:visionTestId("vision.ds.Image.moveFloatingPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_moveFloatingPixel__default() {
var instance = createImage(2, 2);
var original = instance.getPixel(0, 0);
instance.moveFloatingPixel(0.0, 0.0, 1.0, 1.0, 0x00000000);
ImageAssertions.pixelEquals(instance, 1, 1, original);
ImageAssertions.pixelEquals(instance, 0, 0, 0x00000000);
}

@:visionTestId("vision.ds.Image.moveUnsafePixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_moveUnsafePixel__default() {
var instance = createImage(3, 3);
var original = instance.getPixel(1, 1);
instance.moveUnsafePixel(1, 1, 2, 0, 0x00000000);
ImageAssertions.pixelEquals(instance, 2, 0, original);
ImageAssertions.pixelEquals(instance, 1, 1, 0x00000000);
}

@:visionTestId("vision.ds.Image.copyPixelFrom#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_copyPixelFrom__default() {
var source = ManualFixtures.tinyCheckerboardImage();
var instance = createImage(4, 4);
var result = instance.copyPixelFrom(source, 1, 1);
ImageAssertions.colorEquals(source.getPixel(1, 1), result);
ImageAssertions.pixelEquals(instance, 1, 1, source.getPixel(1, 1));
}

@:visionTestId("vision.ds.Image.copyPixelTo#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_copyPixelTo__default() {
var destination = new Image(2, 2, 0x00000000);
var instance = createImage(2, 2);
var result = instance.copyPixelTo(destination, 1, 0);
ImageAssertions.colorEquals(instance.getPixel(1, 0), result);
ImageAssertions.pixelEquals(destination, 1, 0, instance.getPixel(1, 0));
}

@:visionTestId("vision.ds.Image.copyImageFrom#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_copyImageFrom__default() {
var source = ManualFixtures.tinyCheckerboardImage();
var instance = createImage(4, 4);
instance.setView(createView());
instance.copyImageFrom(source);
ImageAssertions.hasDimensions(instance, source.width, source.height);
ImageAssertions.pixelEquals(instance, 0, 0, source.getPixel(0, 0));
ImageAssertions.viewEquals(createView(), instance.getView());
}

@:visionTestId("vision.ds.Image.getImagePortion#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_getImagePortion__default() {
var rect:Rectangle = {x: 1, y: 1, width: 2, height: 2};
var result = createImage(4, 4).getImagePortion(rect);
ImageAssertions.hasDimensions(result, 2, 2);
ImageAssertions.pixelEquals(result, 0, 0, ManualFixtures.coordinateColor(1, 1));
ImageAssertions.pixelEquals(result, 1, 1, ManualFixtures.coordinateColor(2, 2));
}

@:visionTestId("vision.ds.Image.setImagePortion#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_setImagePortion__default() {
var rect:Rectangle = {x: 1, y: 1, width: 2, height: 2};
var portion = ManualFixtures.tinyCheckerboardImage();
var instance = createImage(4, 4);
instance.setImagePortion(rect, portion);
ImageAssertions.pixelEquals(instance, 1, 1, portion.getPixel(0, 0));
ImageAssertions.pixelEquals(instance, 2, 2, portion.getPixel(1, 1));
}

@:visionTestId("vision.ds.Image.clone#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_clone__default() {
var instance = createImage(3, 3);
var clone = instance.clone();
instance.setPixel(0, 0, 0xFFFFFFFF);
ImageAssertions.pixelEquals(clone, 0, 0, ManualFixtures.coordinateColor(0, 0));
Assert.isFalse(instance.underlying == clone.underlying);
}

@:visionTestId("vision.ds.Image.mirror#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_mirror__default() {
var instance = createImage(4, 3);
instance.mirror();
ImageAssertions.pixelEquals(instance, 0, 1, ManualFixtures.coordinateColor(3, 1));
ImageAssertions.pixelEquals(instance, 3, 1, ManualFixtures.coordinateColor(0, 1));
}

@:visionTestId("vision.ds.Image.flip#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_flip__default() {
var instance = createImage(3, 4);
instance.flip();
ImageAssertions.pixelEquals(instance, 1, 0, ManualFixtures.coordinateColor(1, 3));
ImageAssertions.pixelEquals(instance, 1, 3, ManualFixtures.coordinateColor(1, 0));
}

@:visionTestId("vision.ds.Image.stamp#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_stamp__default() {
		var instance = new Image(5, 5, 0xFF000000);
var image = ManualFixtures.tinyCheckerboardImage();
instance.stamp(1, 1, image);
ImageAssertions.pixelEquals(instance, 1, 1, image.getPixel(0, 0));
		ImageAssertions.pixelEquals(instance, 4, 4, image.getPixel(3, 3));
}

@:visionTestId("vision.ds.Image.resize#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_resize__default() {
var instance = createImage(2, 2);
instance.resize(4, 4, vision.ds.ImageResizeAlgorithm.NearestNeighbor);
ImageAssertions.hasDimensions(instance, 4, 4);
ImageAssertions.pixelEquals(instance, 0, 0, ManualFixtures.coordinateColor(0, 0));
ImageAssertions.pixelEquals(instance, 3, 3, ManualFixtures.coordinateColor(1, 1));
}

@:visionTestId("vision.ds.Image.rotate#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_rotate__default() {
var instance = createImage(3, 3);
instance.rotate(0, true, false);
ImageAssertions.hasDimensions(instance, 3, 3);
ImageAssertions.pixelEquals(instance, 2, 1, ManualFixtures.coordinateColor(2, 1));
}

@:visionTestId("vision.ds.Image.forEachPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_forEachPixel__default() {
var visited = [];
createImage(2, 2).forEachPixel((x, y, color) -> visited.push('${x},${y}:${color.toInt()}'));
CollectionAssertions.values([
'0,0:${ManualFixtures.coordinateColor(0, 0).toInt()}',
'0,1:${ManualFixtures.coordinateColor(0, 1).toInt()}',
'1,0:${ManualFixtures.coordinateColor(1, 0).toInt()}',
'1,1:${ManualFixtures.coordinateColor(1, 1).toInt()}',
], visited);
}

@:visionTestId("vision.ds.Image.forEachPixelInView#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_forEachPixelInView__default() {
var instance = createImage(4, 4);
instance.setView(createView());
var visited = [];
instance.forEachPixelInView((x, y, color) -> visited.push('$x,$y'));
CollectionAssertions.values(['1,1', '2,1'], visited);
}

@:visionTestId("vision.ds.Image.iterator#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_iterator__default() {
var count = 0;
for (_ in createImage(3, 2).iterator()) {
count++;
}
Assert.equals(6, count);
}

@:visionTestId("vision.ds.Image.center#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_center__default() {
var center = createImage(4, 3).center();
ApproxAssertions.equalsFloat(2, center.x);
ApproxAssertions.equalsFloat(1.5, center.y);
}

@:visionTestId("vision.ds.Image.pixelToRelative#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_pixelToRelative__default() {
var result = createImage(4, 4).pixelToRelative(new Point2D(2, 1));
ApproxAssertions.equalsFloat(0.5, result.x);
ApproxAssertions.equalsFloat(0.25, result.y);
}

@:visionTestId("vision.ds.Image.relativeToPixel#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_relativeToPixel__default() {
var result = createImage(4, 4).relativeToPixel(new Point2D(0.5, 0.25));
ApproxAssertions.equalsFloat(2, result.x);
ApproxAssertions.equalsFloat(1, result.y);
}

@:visionTestId("vision.ds.Image.hasView#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_hasView__default() {
var instance = createImage(4, 4);
Assert.isFalse(instance.hasView());
instance.setView(createView());
Assert.isTrue(instance.hasView());
}

@:visionTestId("vision.ds.Image.setView#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_setView__default() {
var instance = createImage(4, 4);
instance.setView(createView());
ImageAssertions.viewEquals(createView(), instance.getView());
}

@:visionTestId("vision.ds.Image.getView#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_getView__default() {
var instance = createImage(4, 4);
instance.setView(createView());
ImageAssertions.viewEquals(createView(), instance.getView());
}

@:visionTestId("vision.ds.Image.removeView#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_removeView__default() {
var instance = createImage(4, 4);
instance.setView(createView());
instance.removeView();
Assert.isFalse(instance.hasView());
ImageAssertions.viewEquals({x: 0, y: 0, width: 0, height: 0, shape: ImageViewShape.RECTANGLE}, instance.getView());
}

@:visionTestId("vision.ds.Image.copyViewFrom#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_copyViewFrom__default() {
var from = createImage(4, 4);
from.setView(createView());
var instance = createImage(4, 4);
instance.copyViewFrom(from);
ImageAssertions.viewEquals(createView(), instance.getView());
}

@:visionTestId("vision.ds.Image.hasPixelInView#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_hasPixelInView__default() {
var instance = createImage(4, 4);
instance.setView(createView());
Assert.isTrue(instance.hasPixelInView(1, 1));
Assert.isTrue(instance.hasPixelInView(2, 1));
Assert.isFalse(instance.hasPixelInView(0, 0));
Assert.isFalse(instance.hasPixelInView(3, 3));
}

@:visionTestId("vision.ds.Image.from2DArray#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_from2DArray__default() {
var array = [
[Color.fromRGBA(1, 2, 3, 255), Color.fromRGBA(4, 5, 6, 255)],
[Color.fromRGBA(7, 8, 9, 255), Color.fromRGBA(10, 11, 12, 255)],
];
var result = Image.from2DArray(array);
ImageAssertions.hasDimensions(result, 2, 2);
ImageAssertions.pixelEquals(result, 1, 1, array[1][1]);
}

@:visionTestId("vision.ds.Image.to2DArray#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_to2DArray__default() {
var result = createImage(2, 2).to2DArray();
Assert.equals(2, result.length);
ImageAssertions.colorEquals(ManualFixtures.coordinateColor(0, 0), result[0][0]);
ImageAssertions.colorEquals(ManualFixtures.coordinateColor(1, 1), result[1][1]);
}

@:visionTestId("vision.ds.Image.toArray#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_toArray__default() {
var result = createImage(2, 2).toArray();
Assert.equals(4, result.length);
ImageAssertions.colorEquals(ManualFixtures.coordinateColor(0, 0), result[0]);
ImageAssertions.colorEquals(ManualFixtures.coordinateColor(1, 1), result[3]);
}

@:visionTestId("vision.ds.Image.loadFromBytes#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_loadFromBytes__default() {
		var bytes = new ByteArray(16);
		var values = [
			255, 1, 2, 3,
			255, 4, 5, 6,
			255, 7, 8, 9,
			255, 10, 11, 12,
		];
		for (index in 0...values.length) {
			bytes[index] = values[index];
		}
var result = Image.loadFromBytes(bytes, 2, 2);
ImageAssertions.hasDimensions(result, 2, 2);
ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(1, 2, 3, 255));
ImageAssertions.pixelEquals(result, 1, 1, Color.fromRGBA(10, 11, 12, 255));
}

@:visionTestId("vision.ds.Image.exportToBytes#default")
@:visionMaturity("semantic")
@:visionLifecycle("active")
function test_exportToBytes__default() {
CollectionAssertions.bytes([
255, 15, 25, 10,
255, 55, 25, 30,
255, 15, 75, 30,
255, 55, 75, 50,
], createImage(2, 2).exportToBytes());
}
}
