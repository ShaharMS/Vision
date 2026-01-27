package vision.helpers;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import StringTools;

class InlineProtectionMacro {
    public static function build():Array<Field> {
        if (Context.defined("vision_disable_inline_protection")) {
            return null;
        }
        var isTarget = Context.defined("java") || Context.defined("jvm") || Context.defined("lua");
        if (!isTarget) {
            return null;
        }
        if (!isVisionPackage()) {
            return null;
        }

        var isExternType = isExternLocalType();
        var isAbstractType = isAbstractLocalType();
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
            if (isExternType || hasExternAccess(access)) {
                continue;
            }
            if (isStaticInlineVar(field, access)) {
                continue;
            }
            if (shouldKeepInline(field, isAbstractType)) {
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

    private static function hasExternAccess(access:Array<Access>):Bool {
        for (entry in access) {
            if (entry == AExtern) {
                return true;
            }
        }
        return false;
    }

    private static function isVisionPackage():Bool {
        var localClass = Context.getLocalClass();
        if (localClass == null) {
            return false;
        }
        var pack = localClass.get().pack;
        return pack != null && pack.length > 0 && pack[0] == "vision";
    }

    private static function isExternLocalType():Bool {
        return switch (Context.getLocalType()) {
            case TInst(c, _): c.get().isExtern;
            case TEnum(e, _): e.get().isExtern;
            case TType(t, _): t.get().isExtern;
            case TAbstract(a, _): a.get().isExtern;
            case _: false;
        };
    }

    private static function isAbstractLocalType():Bool {
        return switch (Context.getLocalType()) {
            case TAbstract(_, _): true;
            case _: isAbstractImplClass();
        };
    }

    private static function isAbstractImplClass():Bool {
        var localClass = Context.getLocalClass();
        if (localClass == null) {
            return false;
        }
        var cls = localClass.get();
        if (cls.meta != null && cls.meta.has(":impl")) {
            return true;
        }
        var name = cls.name;
        return name != null && StringTools.endsWith(name, "_Impl_");
    }

    private static function shouldKeepInline(field:Field, isAbstractType:Bool):Bool {
        return isSetterField(field) || functionHasThisAssignment(field);
    }

    private static function isStaticInlineVar(field:Field, access:Array<Access>):Bool {
        var isStatic = false;
        for (entry in access) {
            if (entry == AStatic) {
                isStatic = true;
                break;
            }
        }
        return isStatic && switch (field.kind) {
            case FVar(_, _): true;
            case _: false;
        };
    }

    private static function isSetterField(field:Field):Bool {
        if (field.name != null) {
            if (StringTools.startsWith(field.name, "set_")) {
                return true;
            }
            if (field.name.indexOf("set_") != -1) {
                return true;
            }
            if (StringTools.startsWith(field.name, "set") && field.name.length > 3 && field.name.charAt(3).toUpperCase() == field.name.charAt(3)) {
                return true;
            }
        }
        return switch (field.kind) {
            case FProp(_, set, _, _): set != null && set != "null" && set != "never";
            case _: false;
        };
    }

    private static function functionHasThisAssignment(field:Field):Bool {
        return switch (field.kind) {
            case FFun(fn): exprHasThisAssignment(fn.expr);
            case FProp(_, _, _, expr): exprHasThisAssignment(expr);
            case FVar(_, _): false;
        };
    }

    private static function exprHasThisAssignment(expr:Expr):Bool {
        if (expr == null) {
            return false;
        }
        return switch (expr.expr) {
            case EBinop(op, e1, e2):
                ((op == OpAssign || isAssignOp(op)) && isThisExpr(e1)) || exprHasThisAssignment(e1) || exprHasThisAssignment(e2);
            case EUnop(op, _, e):
                exprHasThisAssignment(e);
            case EBlock(exprs):
                anyExprHasThisAssignment(exprs);
            case ECall(e, params):
                exprHasThisAssignment(e) || anyExprHasThisAssignment(params);
            case EArray(e1, e2):
                exprHasThisAssignment(e1) || exprHasThisAssignment(e2);
            case EArrayDecl(exprs):
                anyExprHasThisAssignment(exprs);
            case EObjectDecl(fields):
                anyExprHasThisAssignment([for (f in fields) f.expr]);
            case EField(e, _):
                exprHasThisAssignment(e);
            case EParenthesis(e):
                exprHasThisAssignment(e);
            case ECheckType(e, _):
                exprHasThisAssignment(e);
            case ECast(e, _):
                exprHasThisAssignment(e);
            case EMeta(_, e):
                exprHasThisAssignment(e);
            case EIf(cond, eif, eelse):
                exprHasThisAssignment(cond) || exprHasThisAssignment(eif) || exprHasThisAssignment(eelse);
            case EWhile(cond, body, _):
                exprHasThisAssignment(cond) || exprHasThisAssignment(body);
            case EFor(it, body):
                exprHasThisAssignment(it) || exprHasThisAssignment(body);
            case ESwitch(e, cases, def):
                exprHasThisAssignment(e)
                || anyExprHasThisAssignment([for (c in cases) c.expr])
                || anyExprHasThisAssignment([for (c in cases) if (c.guard != null) c.guard])
                || exprHasThisAssignment(def);
            case ETry(e, catches):
                exprHasThisAssignment(e) || anyExprHasThisAssignment([for (c in catches) c.expr]);
            case EReturn(e):
                exprHasThisAssignment(e);
            case EThrow(e):
                exprHasThisAssignment(e);
            case EFunction(_, _):
                false;
            case _: false;
        };
    }

    private static function anyExprHasThisAssignment(exprs:Array<Expr>):Bool {
        for (e in exprs) {
            if (exprHasThisAssignment(e)) {
                return true;
            }
        }
        return false;
    }

    private static function isAssignOp(op:Binop):Bool {
        return switch (op) {
            case OpAssignOp(_): true;
            case _: false;
        };
    }

    private static function isThisExpr(expr:Expr):Bool {
        if (expr == null) {
            return false;
        }
        return switch (expr.expr) {
            case EConst(CIdent("this")): true;
            case EParenthesis(e): isThisExpr(e);
            case EMeta(_, e): isThisExpr(e);
            case ECheckType(e, _): isThisExpr(e);
            case ECast(e, _): isThisExpr(e);
            case _: false;
        };
    }
}
#end
