package;

import haxe.display.Display.Package;
import js.html.Document;
import js.Browser;
import vision.algorithms.HoughTransform;
import vision.Vision;
import vision.ds.Image;

class Main {
	static function main() {
		//var image = new Image(300, 300, 0x000000);
		////randomaly draw some lines
		//image.drawLine(1, 242, 1, 45, 0xff0000);
		//image.drawLine(154, 2, 133, 245, 0xff0000);
		//image.drawLine(112, 11, 149, 291, 0xff0000);
		//image.drawLine(1, 219, 250, 249, 0xff0000);
		//image.drawLine(143, 123, 13, 239, 0xff0000);
		//image.drawLine(134, 41, 164, 246, 0xff0000);
		//printIm(image);
		////Console.log(image);
		//var accum = HoughTransform.generateTransformed(image);
		//printIm(accum);
		#if js
		HoughTransform.jsExample();
		#end
	}

	static function printIm(image:Image) {
		#if js
		var c = Browser.document.createCanvasElement();
		c.width = image.width;
		c.height = image.height;
		var ctx = c.getContext2d();
		var imageData = ctx.getImageData(0, 0, image.width, image.height);
		var data = imageData.data;
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = (y * image.width + x) * 4;
				data[i] = image.getPixel(x, y).red;
				data[i + 1] = image.getPixel(x, y).green;
				data[i + 2] = image.getPixel(x, y).blue;
				data[i + 3] = 255;
			}
		}
		ctx.putImageData(imageData, 0, 0);
		c.style.padding = "10px";
		Browser.document.body.appendChild(c);
		#end
	}
}
