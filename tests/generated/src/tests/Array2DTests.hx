package tests;

import vision.ds.IntPoint2D;
import TestResult;
import TestStatus;

import vision.ds.Array2D;
import haxe.iterators.ArrayIterator;

@:access(vision.ds.Array2D)
class Array2DTests {
    public static function vision_ds_Array2D__length__ShouldWork():TestResult {
        try {
            var width = 5;
			var height = 6;
			var fillWith = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            var result = object.length;
        
            return {
                testName: "vision.ds.Array2D#length",
                returned: result,
                expected: 30,
                status: TestStatus.of(result == 30)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#length",
                returned: e,
                expected: 30,
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__get_Int_Int_T__ShouldWork():TestResult {
        try { 
            var width = 3;
			var height = 3;
			var fillWith = 3;
			
            var x = 1;
			var y = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            var result = object.get(x, y);
            
            return {
                testName: "vision.ds.Array2D#get",
                returned: result,
                expected: 3,
                status: TestStatus.of(result == 3)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#get",
                returned: e,
                expected: 3,
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__set__ShouldWork():TestResult {
        try { 
            var width = 1;
			var height = 2;
			var fillWith = 0;
			
            var x = 0;
			var y = 0;
			var val = 6;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            object.set(x, y, val);
            
            if (object.get(x, y) != val) throw 'Array2D#set failed - expected $val at ($x, $y), got ${object.get(x, y)}';

            return {
                testName: "vision.ds.Array2D#set",
                returned: null,
                expected: null,
                status: Success
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#set",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__setMultiple__ShouldWork():TestResult {
        try { 
            var width = 2;
			var height = 2;
			var fillWith = 0;
			
            var points:Array<IntPoint2D> = [{x: 0, y: 1}, {x: 1, y: 0}];
			var val = 6;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            object.setMultiple(points, val);

            for (index in points) if (object.get(index.x, index.y) != val) throw 'Array2D#setMultiple failed - expected $val at (${index.x}, ${index.y}), got ${object.get(index.x, index.y)}';
            
            return {
                testName: "vision.ds.Array2D#setMultiple",
                returned: null,
                expected: null,
                status: Success
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#setMultiple",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__row_Int_ArrayT__ShouldWork():TestResult {
        try { 
            var width = 4;
			var height = 4;
			var fillWith = 3;
			
            var y = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            
            object.set(0, y, 1);
            object.set(1, y, 2);
            object.set(2, y, 3);
            object.set(3, y, 4);

            var result = object.row(y);
            
            return {
                testName: "vision.ds.Array2D#row",
                returned: result,
                expected: [1, 2, 3, 4],
                status: TestStatus.of(result, [1, 2, 3, 4])
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#row",
                returned: e,
                expected: [1, 2, 3, 4],
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__column_Int_ArrayT__ShouldWork():TestResult {
        try { 
            var width = 4;
			var height = 4;
			var fillWith = 2;
			
            var x = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            
            object.set(x, 0, 1);
            object.set(x, 1, 2);
            object.set(x, 2, 3);
            object.set(x, 3, 4);

            var result = object.column(x);
            
            return {
                testName: "vision.ds.Array2D#column",
                returned: result,
                expected: [1, 2, 3, 4],
                status: TestStatus.of(result, [1, 2, 3, 4])
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#column",
                returned: e,
                expected: [1, 2, 3, 4],
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__iterator__ArrayIteratorT__ShouldWork():TestResult {
        try { 
            var width = 2;
			var height = 2;
			var fillWith = 1;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
            
            object.set(0, 1, 2);
            object.set(1, 0, 3);
            object.set(1, 1, 4);

            var result = object.iterator();
            
            for (i in 1...5) {
                var value = result.next();
                if (value != i) throw 'Array2D#iterator failed - expected $i, got $value';
            }
            
            return {
                testName: "vision.ds.Array2D#iterator",
                returned: result,
                expected: [1, 2, 3, 4].iterator(),
                status: Success
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#iterator",
                returned: e,
                expected: [1, 2, 3, 4].iterator(),
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__fill_T_Array2DT__ShouldWork():TestResult {
        try { 
            var width = 5;
			var height = 5;
			var fillWith = 0;
			
            var value = 5;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            var result = object.fill(value);
            
            return {
                testName: "vision.ds.Array2D#fill",
                returned: result,
                expected: new Array2D(5, 5, 5),
                status: TestStatus.of(object.inner, new Array2D(5, 5, 5).inner)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#fill",
                returned: e,
                expected: new Array2D(5, 5, 5),
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__clone__Array2DT__ShouldWork():TestResult {
        try { 
            var width = 3;
			var height = 3;
			var fillWith = 3;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
            var result = object.clone();
            
            return {
                testName: "vision.ds.Array2D#clone",
                returned: result,
                expected: new Array2D(3, 3, 3),
                status: TestStatus.of(object.inner, new Array2D(width, height, fillWith).inner)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#clone",
                returned: e,
                expected: new Array2D(3, 3, 3),
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__toString__String__ShouldWork():TestResult {
        try { 
            var width = 6;
			var height = 6;
			var fillWith = 6;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
            var result = object.toString();
            
            return {
                testName: "vision.ds.Array2D#toString",
                returned: result,
                expected: "\n[[6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6]]",
                status: TestStatus.of(result == "\n[[6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6]]")
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#toString",
                returned: e,
                expected: "\n[[6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6],\n [6, 6, 6, 6, 6, 6]]",
                status: Failure
            }
        }
    }

    public static function vision_ds_Array2D__to2DArray__ArrayArrayT__ShouldWork():TestResult {
        try { 
            var width = 6;
			var height = 6;
			var fillWith = 6;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
            var result = object.to2DArray();
            
            return {
                testName: "vision.ds.Array2D#to2DArray",
                returned: result,
                expected: [[6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6]],
                status: TestStatus.of(result, [[6, 6, 6, 6, 6, 6], [6, 6, 6, 6, 6, 6], [6, 6, 6, 6, 6, 6], [6, 6, 6, 6, 6, 6], [6, 6, 6, 6, 6, 6], [6, 6, 6, 6, 6, 6]])   
            }
        } catch (e) {
            return {
                testName: "vision.ds.Array2D#to2DArray",
                returned: e,
                expected: [[6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6],
 [6, 6, 6, 6, 6, 6]],
                status: Failure
            }
        }
    }


}