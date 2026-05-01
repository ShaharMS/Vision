package;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.macro.ComplexTypeTools;

using Lambda;
using StringTools;
#end

/**
 * Macro-based function detector that extracts function signatures at compile-time.
 * Much more reliable than regex-based parsing - handles generics, nested types, 
 * function types, and complex type signatures correctly.
 */
class MacroDetector {
    #if macro
    /**
     * Extract all testable members from a class at compile-time.
     * Returns an array of TestableFunction describing each public method/field.
     */
    public static function detectClass(classPath:String):Array<TestableFunction> {
        var type:Type;
        try {
            type = Context.getType(classPath);
        } catch (e:Dynamic) {
            // Module doesn't define this type
            return [];
        }
        
        if (type == null) {
            return [];
        }
        
        var classType = switch (type) {
            case TInst(ref, _): ref.get();
            case TAbstract(ref, _): return detectAbstract(ref.get());
            case TEnum(_, _): return []; // Enums don't have testable methods
            case TType(_, _): return []; // Typedefs don't have testable methods
            default: 
                return [];
        }
        
        var results:Array<TestableFunction> = [];
        
        // Get the module path for imports
        var modulePath = classType.module;
        var className = classType.name;
        var pack = classType.pack.join(".");
        
        // Extract static fields
        for (field in classType.statics.get()) {
            var testable = extractTestableFromField(field, pack, className, true);
            if (testable != null) results.push(testable);
        }
        
        // Extract instance fields
        for (field in classType.fields.get()) {
            var testable = extractTestableFromField(field, pack, className, false);
            if (testable != null) results.push(testable);
        }
        
        // Extract constructor info
        var preferredInstanceExpression = getDefaultForType(className);
        if (usesStructuralDefault(className) && preferredInstanceExpression != "null") {
            for (r in results) {
                if (!r.isStatic) r.instanceExpression = preferredInstanceExpression;
            }
        } else if (classType.constructor != null) {
            var ctor = classType.constructor.get();
            var ctorParams = extractParamsFromType(ctor.type);
            for (r in results) {
                if (!r.isStatic) r.constructorParams = ctorParams;
            }
        } else {
            var instanceExpression = preferredInstanceExpression;
            if (instanceExpression != "null") {
                for (r in results) {
                    if (!r.isStatic) r.instanceExpression = instanceExpression;
                }
            }
        }
        
        return results;
    }

    static function usesStructuralDefault(className:String):Bool {
        return className == "Rectangle" || className == "ImageView" || className == "Histogram" || className == "Queue" || className == "QueueCell";
    }
    
    static function detectAbstract(abstractType:AbstractType):Array<TestableFunction> {
        var results:Array<TestableFunction> = [];
        var pack = abstractType.pack.join(".");
        var className = abstractType.name;
        var instanceExpression = getDefaultForType(className);
        
        // Abstract impl statics
        if (abstractType.impl != null) {
            for (field in abstractType.impl.get().statics.get()) {
                // Skip internal/generated fields
                if (field.name.startsWith("_")) continue;
                var testable = extractTestableFromAbstractField(field, pack, className, instanceExpression);
                if (testable != null) results.push(testable);
            }
        }
        
        return results;
    }
    
    static function extractTestableFromField(field:ClassField, pack:String, className:String, isStatic:Bool):TestableFunction {
        // Skip private, skip constructors (handled separately)
        if (!field.isPublic) return null;
        if (field.name == "new" || field.name == "_new") return null;
        
        var kind = switch (field.kind) {
            case FMethod(_): TKMethod;
            case FVar(read, write): 
                // Only include readable properties (getters)
                if (read == AccCall || read == AccNormal) TKProperty else return null;
        };
        var params = kind == TKMethod ? extractParamsFromType(field.type) : [];
        var returnType = kind == TKMethod ? extractReturnType(field.type) : typeToString(field.type);
        
        return {
            packageName: pack,
            className: className,
            name: field.name,
            isStatic: isStatic,
            kind: kind,
            params: params,
            returnType: returnType,
            constructorParams: [],
            instanceExpression: null
        };
    }

    static function extractTestableFromAbstractField(field:ClassField, pack:String, className:String, instanceExpression:String):TestableFunction {
        if (!field.isPublic) return null;
        if (field.name == "new" || field.name == "_new") return null;

        var kind = switch (field.kind) {
            case FMethod(_): TKMethod;
            case FVar(read, write):
                if (read == AccCall || read == AccNormal) TKProperty else return null;
        };

        var params = kind == TKMethod ? extractParamsFromType(field.type) : [];
        var instanceMember = kind == TKProperty || (params.length > 0 && params[0].name == "this");
        if (instanceMember && params.length > 0 && params[0].name == "this") {
            params = params.slice(1);
        }

        return {
            packageName: pack,
            className: className,
            name: field.name,
            isStatic: !instanceMember,
            kind: kind,
            params: params,
            returnType: kind == TKMethod ? extractReturnType(field.type) : typeToString(field.type),
            constructorParams: [],
            instanceExpression: instanceMember ? instanceExpression : null
        };
    }
    
    static function extractParamsFromType(type:Type):Array<ParamInfo> {
        return switch (type) {
            case TFun(args, _):
                [for (arg in args) {
                    name: arg.name,
                    type: typeToString(arg.t),
                    optional: arg.opt
                }];
            case TLazy(f): extractParamsFromType(f());
            default: [];
        };
    }
    
    static function extractReturnType(type:Type):String {
        return switch (type) {
            case TFun(_, ret): typeToString(ret);
            case TLazy(f): extractReturnType(f());
            default: typeToString(type);
        };
    }
    
    static function typeToString(type:Type):String {
        return switch (type) {
            case TInst(ref, params):
                var name = ref.get().name;
                if (params.length > 0) {
                    name + "<" + params.map(p -> typeToString(p)).join(", ") + ">";
                } else name;
                
            case TAbstract(ref, params):
                var name = ref.get().name;
                if (params.length > 0) {
                    name + "<" + params.map(p -> typeToString(p)).join(", ") + ">";
                } else name;
                
            case TEnum(ref, params):
                var name = ref.get().name;
                if (params.length > 0) {
                    name + "<" + params.map(p -> typeToString(p)).join(", ") + ">";
                } else name;
                
            case TFun(args, ret):
                var argStr = args.map(a -> typeToString(a.t)).join(", ");
                '($argStr) -> ${typeToString(ret)}';
                
            case TAnonymous(ref):
                var fields = ref.get().fields;
                var fieldStrs = [for (f in fields) '${f.name}: ${typeToString(f.type)}'];
                '{${fieldStrs.join(", ")}}';
                
            case TDynamic(t):
                t == null ? "Dynamic" : 'Dynamic<${typeToString(t)}>';
                
            case TMono(ref):
                var t = ref.get();
                t == null ? "Unknown" : typeToString(t);
                
            case TLazy(f): typeToString(f());
            case TType(ref, params): 
                var name = ref.get().name;
                if (params.length > 0) {
                    name + "<" + params.map(p -> typeToString(p)).join(", ") + ">";
                } else name;
            default: "Dynamic";
        };
    }
    
    /**
     * Generate default value expression for a type.
     */
    public static function getDefaultForType(typeName:String):String {
        // Handle nullables and optionals
        if (typeName.startsWith("Null<")) {
            return "null";
        }
        
        return switch (typeName) {
            case "String": '""';
            case "Int": "0";
            case "UInt": "0";
            case "Int64": "haxe.Int64.make(0, 42)";
            case "Float": "0.0";
            case "Bool": "false";
            case "Void": "null";
            case "Dynamic": "null";
            
            // Function types
            case (_.contains("->") => true):
                var parts = typeName.split("->");
                var argCount = parts[0].trim().replace("(", "").replace(")", "").split(",").length;
                if (parts[0].trim() == "()" || parts[0].trim() == "") argCount = 0;
                var args = [for (i in 0...argCount) "_"].join(", ");
                '($args) -> ${getDefaultForReturn(parts[parts.length-1].trim())}';
            
            // Arrays and Maps
            case (_.startsWith("Array") => true): "[]";
            case (_.startsWith("Map") => true): "[]";
            case (_.startsWith("Vector") => true): "null";
            
            // Vision-specific types
            case "Image": "Factories.gradientImage(10, 10)";
            case "ImageFormat": "vision.ds.ImageFormat.PNG";
            case "PixelFormat": "vision.ds.PixelFormat.ARGB";
            case "CannyObject": "Factories.gradientImage(16, 16)";
            case "Color": "(0xFF336699 : vision.ds.Color)";
            case "Point2D": "new vision.ds.Point2D(0.0, 0.0)";
            case "IntPoint2D": "new vision.ds.IntPoint2D(0, 0)";
            case "Int16Point2D": "new vision.ds.Int16Point2D(0, 0)";
            case "UInt16Point2D": "new vision.ds.UInt16Point2D(0, 0)";
            case "Point3D": "new vision.ds.Point3D(0.0, 0.0, 0.0)";
            case "Line2D": "new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0))";
            case "Ray2D": "new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0)";
            case "Pixel": "new vision.ds.Pixel(0, 0, 0xFF000000)";
            case "ByteArray": "new vision.ds.ByteArray(100)";
            case "Histogram": "(function() { var histogram = new vision.ds.Histogram(); histogram.increment(1); histogram.increment(2); histogram.increment(2); return histogram; })()";
            case "Kernel2D": "vision.ds.Kernel2D.identity";
            case "Matrix2D": "vision.ds.Matrix2D.createFilled([1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0])";
            case "TransformationMatrix2D": "vision.ds.Matrix2D.IDENTITY()";
            case "Rectangle": "({x: 0, y: 0, width: 10, height: 10} : vision.ds.Rectangle)";
            case "ImageView": "({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView)";
            case "Array2D": "new vision.ds.Array2D<Float>(3, 3, 0.0)";
            case "Queue": "(function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })()";
            case "QueueCell": "new vision.ds.QueueCell(cast 1, new vision.ds.QueueCell(cast 2, null, null), new vision.ds.QueueCell(cast 0, null, null))";
            case "PointTransformationPair": 
                "new vision.ds.specifics.PointTransformationPair(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(1.0, 1.0))";
            case "ColorCluster":
                "new vision.ds.kmeans.ColorCluster(0xFF000000, [])";
            
            // Enums with common defaults
            case "ImageExpansionMode": "vision.ds.specifics.ImageExpansionMode.RESIZE";
            case "TransformationMatrixOrigination": "vision.ds.specifics.TransformationMatrixOrigination.CENTER";
            case "ColorChannel": "vision.ds.specifics.ColorChannel.RED";
            case "GaussianKernelSize": "vision.ds.gaussian.GaussianKernelSize.X5";
            
            // Generic parameter - try Int
            case "T": "cast 0";
            
            default: "null";
        };
    }
    
    static function getDefaultForReturn(returnType:String):String {
        return switch (returnType.trim()) {
            case "Void": "{}";
            case "Bool": "false";
            case "Int" | "UInt": "0";
            case "Float": "0.0";
            default: "null";
        };
    }
    #end
}

typedef TestableFunction = {
    packageName:String,
    className:String,
    name:String,
    isStatic:Bool,
    kind:TestableKind,
    params:Array<ParamInfo>,
    returnType:String,
    constructorParams:Array<ParamInfo>,
    ?instanceExpression:String
}

typedef ParamInfo = {
    name:String,
    type:String,
    optional:Bool
}

enum TestableKind {
    TKMethod;
    TKProperty;
}
