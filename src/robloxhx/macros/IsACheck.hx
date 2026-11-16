package robloxhx.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;

using haxe.macro.TypedExprTools;

class IsACheck
{
	public static function init()
	{
		Context.onAfterTyping(types ->
		{
			for (t in types)
				switch (t)
				{
					case TClassDecl(_.get() => c):
						var all = c.fields.get().concat(c.statics.get());
						if (c.constructor != null)
							all.push(c.constructor.get());
						for (f in all)
						{
							var e = f.expr();
							if (e != null)
								check(e);
						}
					case _:
				}
		});
	}

	static function check(e:TypedExpr)
	{
		switch (e.expr)
		{
			case TCall({expr: TField(_, FInstance(_.get() => c, _, _.get() => cf))}, [arg = {expr: TConst(TString(s))}])
				if (cf.name == 'isA' && c.pack.join('.') == 'rblx.instances' && c.name == 'Object' && !WhichIsAMacro.exists(s)):
				Context.warning('isA("$s"): no class named "$s" in rblx.instances, so this is always false', arg.pos);
			case _:
		}
		e.iter(check);
	}
}
#end
