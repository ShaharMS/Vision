package vision.helpers;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

class InlineProtectionMacro {
    public static function build():Array<Field> {
        if (Context.defined("vision_disable_inline_protection")) {
            return null;
        }
        var isTarget = Context.defined("java") || Context.defined("jvm") || Context.defined("lua");
        if (!isTarget) {
            return null;
        }

        var fields = Context.getBuildFields();
        for (field in fields) {
            var access = field.access;
            if (access == null) {
                continue;
            }
            var hasInline = false;
            for (entry in access) {
                if (entry == AInline) {
                    hasInline = true;
                    break;
                }
            }
            if (!hasInline) {
                continue;
            }
            var filtered:Array<Access> = [];
            for (entry in access) {
                if (entry != AInline) {
                    filtered.push(entry);
                }
            }
            field.access = filtered;
        }
        return fields;
    }
}
#end
