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

inline function boundChannel(f:Float):Int {
	var i = Std.int(f);
	if (i > 0xFF) i = 0xFF;
	if (i < 0) i = 0;
	return i;
}

inline function colBlendFunc(x1:Float, x2:Float, a3:Float, a2:Float):Int
	return Std.int(255 * (x1 * a3 + x2 * a2));

inline function alphaBlendFunc(a3:Float, a2:Float):Int
	return Std.int(255 * (a3 + a2));

inline function channelFloat(color:Int):Float
	return (color == 0) ? 0. : color / 255;
