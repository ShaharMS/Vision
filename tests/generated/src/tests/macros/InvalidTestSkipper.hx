package tests.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using StringTools;

class InvalidTestSkipper {
    public static function build():Array<Field> {
        var fields = Context.getBuildFields();
        if (!Context.defined("vision_skip_invalid_tests")) {
            return fields;
        }

        for (field in fields) {
            var meta = field.meta;
            var hasIgnored = false;
            if (meta != null) {
                for (entry in meta) {
                    if (entry.name == "Ignored") {
                        hasIgnored = true;
                        break;
                    }
                }
            }
            if (hasIgnored) {
                continue;
            }
            if (field.name != null && field.name.startsWith("test_")) {
                if (meta == null) {
                    meta = [];
                    field.meta = meta;
                }
                meta.push({
                    name: "Ignored",
                    params: [macro "Invalid/placeholder test data in CI"],
                    pos: field.pos
                });
            }
        }

        return fields;
    }
}
#end
