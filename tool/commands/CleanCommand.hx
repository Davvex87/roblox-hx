package commands;

import hx.files.Path;

using utils.AnsiColors;

/**
 * When ran, clears out some rubbish left behind by the compiler.
 */
class CleanCommand implements ICommand
{
	public var aliases:Array<String> = ["cl", "clean"];
	public var description:String = "Cleans the target roblox-hx project, removing file locks and output files.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		var projectFile:Null<String> = arguments.shift();
		var isProjectFile:Bool = true;
		if (projectFile != null)
		{
			var p:Path = Path.of(projectFile);
			if (p.filenameExt != "hxml")
				isProjectFile = false;
		}
		else
			projectFile = "project.rhx.hxml";

		if (!isProjectFile)
			throw 'Unknown project file format. .hxml expected, got .${Path.of(projectFile).filenameExt}';

		var p:Path = Path.of(projectFile);
		if (!p.exists() || p.isDirectory())
			throw 'Project file not found or is a directory';

		var absPath = p.getAbsolutePath();
		var hxml:HXML = HXML.fromFile(absPath);

		var outputPath = Path.of(hxml.getDefine("output") ?? "out");
		if (outputPath.exists() && outputPath.isDirectory())
			outputPath.toDir().delete(true);

		Sys.println("Cleaned project!".boldBlue());
	}
}
