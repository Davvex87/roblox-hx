package utils;

import sys.io.Process;
import hx.files.Path;
import hx.files.Dir;
import haxe.Exception;

using StringTools;

class Resources
{
	public static function appendCompilationResources()
	{
		var libPath = HaxeUtils.getLibraryDir("roblox-hx");
		if (libPath == null)
			throw new Exception("Library roblox-hx is not installed");

		var tempPath:Path = getTempFolder();
		libPath.join("res").toDir().copyTo(tempPath.join("rhcr").join("res"), [OVERWRITE]);
		libPath.join("src")
			.join("lua")
			.toDir()
			.copyTo(tempPath.join("rhcr").join("lua"), [OVERWRITE]);
	}

	public static function appendStdLibrary():Path
	{
		var libPath = HaxeUtils.getLibraryDir("roblox-hx");
		if (libPath == null)
			throw new Exception("Library roblox-hx is not installed");

		var tempPath:Path = getTempFolder();
		var targetDir = tempPath.join("rhcr").join("std");
		var stdPath = getRobloxHxStdPath();

		// TODO: Replace this with a better folder diff compare function,
		//       the problem is that 2 folders are merged to create one...
		if (targetDir.exists())
			return targetDir;

		stdPath.toDir().copyTo(targetDir, [OVERWRITE]);

		libPath.join("src").toDir().copyTo(targetDir, [MERGE]);

		return targetDir;
	}

	public static function patchLibBuildParams()
	{
		var libPath = HaxeUtils.getLibraryDir("roblox-hx");
		if (libPath == null)
			throw new Exception("Library roblox-hx is not installed");

		var buildFile = libPath.join("extraParams.hxml").toFile();
		var contents = buildFile.readAsString();
		var lines = contents.split("\n");
		for (i in 0...lines.length)
		{
			if (lines[i].startsWith("-cp") || lines[i].startsWith("# AUTOGEN"))
			{
				lines[i] = "-cp " + libPath.join("proxy").getAbsolutePath();
				break;
			}
		}
		contents = lines.join("\n");
		buildFile.writeString(contents);
	}

	public static inline function getRobloxHxStdPath():Path
		return Path.of(Sys.getEnv("HAXEPATH")).join("std");

	public static function getTempFolder():Path
	{
		var process = new Process('echo %temp%');
		if (process.exitCode() != 0)
			throw new Exception("Unable to append resources to temp folder");

		var tempPath = process.stdout.readAll().toString();
		process.close();

		return Path.of(tempPath);
	}
}
