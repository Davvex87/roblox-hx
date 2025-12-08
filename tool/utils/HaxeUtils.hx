package utils;

import hx.files.Path;
import sys.io.Process;
import thx.semver.Version;

using StringTools;

class HaxeUtils
{
	public static var isWin(get, never):Bool;

	public static function getHaxeVersion():Null<Version>
	{
		try
		{
			var process = new Process("haxe", ["--version"]);
			if (process.exitCode() != 0)
				throw null;

			var output = process.stdout.readAll().toString().trim();
			process.close();

			return Version.stringToVersion(output);
		}
		catch (e:Dynamic) {}
		return null;
	}

	public static function getHaxelibVersion():Null<Version>
	{
		try
		{
			var process = new Process("haxelib --global version");
			if (process.exitCode() != 0)
				throw null;

			var output = process.stdout.readAll().toString().trim().split(" ")[0];
			process.close();

			return Version.stringToVersion(output);
		}
		catch (e:Dynamic) {}
		return null;
	}

	public static function getLibraryDir(lib:String):Null<Path>
	{
		try
		{
			var process = new Process('haxelib --global libpath ${lib}');
			if (process.exitCode() != 0)
				return null;

			var output = process.stdout.readAll().toString();
			process.close();

			return Path.of(output);
		}
		catch (e:Dynamic) {}
		return null;
	}

	public static function getLibraryVersion(lib:String):Null<Version>
	{
		// haxelib info takes absolutelly forever
		return (getLibraryDir(lib) != null) ? Version.stringToVersion("0.0.0-dev") : null;
		/*
			try
			{
				var process = new Process("haxelib", ["info", lib]);
				if (process.exitCode() != 0)
					throw null;

				var output = process.stdout.readAll().toString();
				process.close();

				var pos:Int = output.indexOf("Version: ");
				if (pos == -1)
					throw null;
				
				var version:String = output.substr(pos + 9, output.indexOf("\n", pos + 9)).trim();

				return Version.stringToVersion(version);
			}
			catch(e:Dynamic) {}
			return null; */
	}

	public static function getExecDir():Path
	{
		return Path.of(Sys.programPath()).parent;
	}

	static function get_isWin():Bool
		return Sys.systemName() == "Windows";
}
