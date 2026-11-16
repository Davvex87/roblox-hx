package robloxhx.macros;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

class WhichIsAMacro
{
	public static function build():Array<Field>
	{
		var fields = Context.getBuildFields();
		for (field in fields)
		{
			switch (field.kind)
			{
				case FFun(fn) if (fn.expr != null):
					fn.expr = rewrite(fn.expr);
				case FVar(t, e) if (e != null):
					field.kind = FVar(t, rewrite(e));
				case FProp(get, set, t, e) if (e != null):
					field.kind = FProp(get, set, t, rewrite(e));
				case _:
			}
		}
		return fields;
	}

	static function rewrite(e:Expr):Expr
	{
		e = ExprTools.map(e, rewrite);
		switch (e.expr)
		{
			case ECall({
				expr: EField(_, method = 'findFirstChildWhichIsA' | 'findFirstAncestorWhichIsA' | 'findFirstChildOfClass' | 'findFirstAncestorOfClass', _)
			}, args) if (args.length >= 1):
				switch (args[0].expr)
				{
					case EConst(CString(name, _)):
						if (!exists(name))
						{
							Context.warning('$method("$name"): no class named "$name" in rblx.instances, result stays Instance', args[0].pos);
							return e;
						}
						var type = TPath({pack: ['rblx', 'instances'], name: name});
						return macro @:pos(e.pos) (cast $e : $type);
					case _:
				}
			case _:
		}
		return e;
	}

	public static function exists(name:String):Bool
	{
		try
		{
			Context.getModule('rblx.instances.' + name);
			return true;
		}
		catch (_)
			return false;
	}
}
#end
