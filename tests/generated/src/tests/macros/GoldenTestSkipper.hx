package tests.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using StringTools;

class GoldenTestSkipper {
    public static function build():Array<Field> {
        var fields = Context.getBuildFields();
        if (!Context.defined("cs")) {
            return fields;
        }

        for (field in fields) {
            if (field.name.startsWith("test_golden_")) {
                field.meta.push({
                    name: "Ignored",
                    params: [macro "CS target: golden image tests require external image IO"],
                    pos: field.pos
                });
            }
        }
        return fields;
    }
}
#end
