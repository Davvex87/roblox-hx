package macros;

import hx.files.Dir;
import hx.files.File;
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import thx.semver.Version;

class CompileTimeMacro
{
	/**
	 * Returns the Haxe version used during compilation.
	 * @return Version
	 */
	public static macro function getHaxeVersion():Expr
	{
		var defines = Context.getDefines();
		var version = defines.get("haxe");
		return macro Version.stringToVersion($v{version});
	}

	/**
	 * Returns the library version which the neko script was compiled with.
	 * @return Version
	 */
	public static macro function getLibVersion():Expr
	{
		var data:Dynamic = Json.parse(File.of(Dir.getCWD().path.join("haxelib.json")).readAsString());
		return macro Version.stringToVersion($v{Reflect.field(data, "version")});
	}
}
