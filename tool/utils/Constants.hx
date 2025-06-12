package utils;

import haxe.ds.StringMap;
import macros.CompileTimeMacro;
import thx.semver.Version;

class Constants
{
	public static final HAXE_COMPILER_VERSION:Version = CompileTimeMacro.getHaxeVersion();
	public static final ROBLOX_HX_VERSION:Version = CompileTimeMacro.getLibVersion();

	public static final MIN_HAXE_COMPILER_VERSION:Version = Version.stringToVersion("4.1.2"); // Versions prior to 4.1.2 contain weird lua bugs
}
