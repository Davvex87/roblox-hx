package modules;

import hx.files.Path;
import hx.files.Dir;
import hx.files.File;

using StringTools;

class GlobalPatcher
{
	public static function patch(file:String):String
	{
		file = addLocalIfMissing(file);
		file = file.replace("local String = _hx_e()", "String = _hx_e()");

		file = file.replace("_hx_print(", "print(");
		file = file.replace("_G.math", "math");
		file = file.replace("_G.error", "error");
		file = file.replace("_G.select", "select");

		file = file.replace("local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw",
			"");
		// file = file.replace("lua.TableTools", "table");

		return file;
	}

	static function addLocalIfMissing(code:String):String
	{
		var lines = code.split("\n");
		var pattern = ~/^\s*(?!local\s)(.*\s=\s*_hx_e\(\)\s*)$/;

		for (i in 0...lines.length)
		{
			var line = lines[i];
			if (pattern.match(line))
				lines[i] = "local " + line;
		}

		return lines.join("\n");
	}
}
