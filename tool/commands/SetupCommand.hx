package commands;

import haxe.Exception;
import hx.files.Path;
import hx.files.File;

/**
 * A command that, when ran, will add an executable script to the HAXEPATH environment variable for quick access to roblox-hx commands.
 * This command should be ran right uppon installing the library.
 */
class SetupCommand implements ICommand
{
	public var aliases:Array<String> = ["setup"];
	public var description:String = "Adds roblox-hx to the HAXEPATH environment directory";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		var hxpath = Sys.getEnv("HAXEPATH");
		if (hxpath == null)
			throw new Exception("HAXEPATH must be a set environment variable");

		var dir:Path = Path.of(hxpath);

		if (Sys.systemName() == "Windows")
		{
			File.of(dir.join("roblox-hx.bat")).writeString("@haxelib --global run roblox-hx %*", true);
		}
		else
		{
			File.of(dir.join("roblox-hx")).writeString("#!/bin/bash\nhaxelib --global run roblox-hx \"$@\"", true);
			var code = Sys.command('cd ${dir.normalize()} && chmod u+x roblox-hx');
			if (code != 0)
				throw "Failed to create unix executable for roblox-hx";
		}
	}
}
