package vision.ds.haar;

import haxe.io.UInt8Array;
import haxe.io.Float32Array;

@:structInit
class IntegralImage {
    @:optional public var gray:UInt8Array;
    @:optional public var integral:Float32Array;
    @:optional public var squares:Float32Array;
    @:optional public var tilted:Float32Array;
}