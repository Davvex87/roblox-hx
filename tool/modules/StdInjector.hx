package modules;

import hx.files.Path;

using StringTools;

class StdInjector
{
	public static function inject(file:String):String
	{
		var globals:String = Path.of(Sys.programPath())
			.parent.joinAll(["res", "_hx_globals.lua"])
			.toFile()
			.readAsString("");

		var lines = file.split("\n");

		if (1 < lines.length)
		{
			lines[1] = globals + lines[1];
		}

		return lines.join("\n");
	}
}
