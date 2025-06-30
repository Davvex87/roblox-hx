package commands;

import hx.files.Dir;
import hx.files.File;
import CompilerOptions.buildOptionsFromFile;
import haxe.Exception;
import hx.files.Path;

/**
 * When ran, clears out some rubbish left behind by the compiler.
 */
class CleanCommand implements ICommand
{
	public var aliases:Array<String> = ["cl", "clean"];
	public var description:String = "Cleans the target roblox-hx project, removing package lock .json files and output files.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		var file:Null<String> = arguments.shift();
		var projOptFile:Path = null;

		if (file != null)
		{
			if (Path.of(file).isDirectory())
				projOptFile = Path.of(file).join("compiler.rhx.json");
			else
				projOptFile = Path.of(file);
		}

		if (projOptFile == null || !projOptFile.exists())
			projOptFile = Dir.getCWD().path.join("compiler.rhx.json");

		if (projOptFile == null || !projOptFile.exists())
			throw new Exception("Project file not found.");

		var opts = buildOptionsFromFile(projOptFile.getAbsolutePath());
		Dir.of(opts.outputFolder).delete(true);

		File.of(projOptFile.parent.join("pkg_list-lock.json")).delete();
		File.of(projOptFile.parent.join("type_pkg-lock.json")).delete();

		Sys.println("Cleaned project!");
	}
}
