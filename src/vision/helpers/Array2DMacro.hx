package vision.helpers;

#if (macro)
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
using haxe.macro.ExprTools;

class Array2DMacro {
	public static function build() {
		if (!Context.defined('vision_fancy_array_access')) return null;
		var fields = Context.getBuildFields();

		for (field in fields) {
			switch field.kind {
				case FFun(f): if (f.expr != null) {
						checkForFancyAccess(f.expr);
					}
				case _:
			}
		}
		return fields;
	}

	static function checkForFancyAccess(e:Expr) {
		switch e {
			case macro $a[[$row, $column]]: 
				var fancy = macro $a.get($row, $column);
				e.expr = fancy.expr;
			case macro $a[[$row, $column]] = $value: 
				var fancy = macro $a.set($row, $column, $value);
				e.expr = fancy.expr;
			case _: e.iter(checkForFancyAccess);
		}
	}
}
#end