package utils;

import haxe.Exception;
import sys.io.Process;
import hx.files.Path;

using StringTools;

class Resources
{
	public static function getLibLinkPath():Path
	{
		if (HaxeUtils.isWin)
			return Path.win(Sys.getEnv("HAXEPATH")).join("roblox-hx.bat");

		return Path.unix("/usr/local/bin/roblox-hx");
	}

	public static function libLinkExists():Bool
		return getLibLinkPath().exists();

	public static inline function getRobloxHxPath():Path
		return HaxeUtils.getLibraryDir("roblox-hx");

	public static function getTempFolder():Path
	{
		if (!HaxeUtils.isWin)
			return Path.unix("/tmp");

		var process = new Process('echo %temp%');
		if (process.exitCode() != 0)
			throw new Exception("Unable to append resources to temp folder");

		var tempPath = process.stdout.readAll().toString();
		process.close();

		return Path.of(tempPath);
	}
}
