/*
	MIT License
	Copyright (c) 2022 Nanjizal ( Justin L Mills )
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
 */

package vision.helpers.pixelTriangle.pixelPlus;

/**
	Allows injection of Bytes data directly into the Image and direct extraction
**/
@:access(vision.ds.Image.OFFSET)
final imageOff = vision.ds.Image.OFFSET;

inline function imageLen(image:vision.ds.Image):Int
	return image.width * image.height * 4;

inline function injectBytesInImage(bytes:haxe.io.Bytes, image:vision.ds.Image)
	image.underlying.blit(imageOff, bytes, 0, imageLen(image));

inline function extractBytesFromImage(image:vision.ds.Image):haxe.io.Bytes {
	var out = haxe.io.Bytes.alloc(imageLen(image));
	out.blit(0, image.underlying, imageOff, imageLen(image));
	return out;
}
