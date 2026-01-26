package tests.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using StringTools;

class GoldenTestSkipper {
    public static function build():Array<Field> {
        var fields = Context.getBuildFields();
        var skipGolden = Context.defined("cs")
            || Context.defined("vision_skip_golden")
            || Context.defined("vision_no_network");

        if (!skipGolden) {
            return fields;
        }

        for (field in fields) {
            if (field.name.startsWith("test_golden_")) {
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
                if (meta == null) {
                    meta = [];
                    field.meta = meta;
                }
                meta.push({
                    name: "Ignored",
                    params: [macro "Golden tests skipped (network/CI)"],
                    pos: field.pos
                });
            }
        }
        return fields;
    }
}
#end
