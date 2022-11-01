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

package vision.helpers.pixelTriangle.iter;

/**
	Used for bounding box iteration, calculates lo...hi iterator from 3 values. 
**/
inline function boundIterator3(a:Float, b:Float, c:Float):IntIterator {
	return if (a > b) {
		if (a > c) { // a,b a,c
			((b > c) ? Math.floor(c) : Math.floor(b))...Math.ceil(a);
		} else { // c,a,b
			Math.floor(b)...Math.ceil(c);
		}
	} else {
		if (b > c) { // b,a, b,c
			((a > c) ? Math.floor(c) : Math.ceil(a))...Math.ceil(b);
		} else { // c,b,a
			Math.floor(a)...Math.ceil(c);
		}
	}
}
