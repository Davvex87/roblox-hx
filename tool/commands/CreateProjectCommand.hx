package commands;

import utils.HaxeUtils;
import hx.files.Dir;
import hx.files.Path;

using utils.AnsiColors;
using StringTools;

/**
 * When ran, will create a new empty project ``or from a template`` to the target directory.
 * If the target directory already has files then it will throw.
 */
class CreateProjectCommand implements ICommand
{
	public var aliases:Array<String> = ["create"];
	public var description:String = "Creates a new project from an empty template";

	public function new() {}

	public static final projectManagementTools = ["Rojo"];

	public function run(arguments:Array<String>)
	{
		final templatesAvailable:Array<String> = [];
		final templatesDir = HaxeUtils.getLibraryDir("roblox-hx").join("template-projects").toDir();
		for (subDir in templatesDir.findDirs("*"))
		{
			templatesAvailable.push(subDir.path.filename);
		}

		var force:Bool = false;
		var location = Dir.getCWD().path;
		var template:Null<String> = null;
		var pmTool:Null<String> = null;
		while (arguments.length > 0)
		{
			var a = arguments.shift();
			switch (a)
			{
				case "--force", "-f":
					force = true;
				case "--template", "-t":
					template = arguments.shift();
				case "--pmtool", "-m":
					pmTool = arguments.shift();
				case "--path", "-p":
					location = Path.of(arguments.shift() ?? location.toString());
				case _ if (a != null && a is String):
					location = Path.of(a);
			}
		}

		var dir = location.toDir();
		if (Path.of(location.getAbsolutePath()).exists() && !dir.isEmpty() && !force)
			throw "Target directory is not empty";

		if (template == null)
		{
			Sys.println("Select a template to create the project from:");
			for (i in 0...templatesAvailable.length)
			{
				final projectPath = templatesDir.path.join(templatesAvailable[i]);
				var description:Null<String> = null;
				final readmeFile = projectPath.join("README.md");
				if (readmeFile.exists())
				{
					final lines = readmeFile.toFile().readAsString().split("\n");
					for (line in lines)
					{
						if (line.trim().length == 0)
							continue;
						if (line.startsWith("#"))
							continue;
						description = line.trim();
						break;
					}
				}
				Sys.println('  (${i + 1}) ${templatesAvailable[i]}${description != null ? ' - ${description}' : ''}');
			}
			Sys.println("  ( ) cancel");
			Sys.print("\n  > ");

			final selection = Std.parseInt(String.fromCharCode(Sys.getChar(true)));
			if (selection == null || selection < 1 || selection > templatesAvailable.length)
			{
				Sys.println("\nProject creation cancelled!".boldYellow());
				return;
			}

			template = templatesAvailable[selection - 1];
		}

		Sys.println('\nCreating project from template ${template} into ${location.toString()}'.boldBlue());

		final templateDir = templatesDir.path.join(template).toDir();
		templateDir.copyTo(location, [MERGE]);

		Sys.println("Project created!".boldGreen());

		if (pmTool == null)
		{
			Sys.println("Select which project management tool you'd like to use (optional):");
			for (i in 0...projectManagementTools.length)
			{
				Sys.println('  (${i + 1}) ${projectManagementTools[i]}');
			}
			Sys.println("  ( ) None");
			Sys.print("\n  > ");

			final selection = Std.parseInt(String.fromCharCode(Sys.getChar(true)));
			if (selection == null || selection < 1 || selection > projectManagementTools.length)
			{
				Sys.println("\nNo PM Tool selected!");
				pmTool = "None";
			}
			else
			{
				pmTool = projectManagementTools[selection - 1];
				Sys.println('\nSelected PM Tool: ${pmTool}');
			}
		}

		final readT = pmTool.toLowerCase().trim();

		var files = dir.findFiles("**/*");
		for (file in files)
		{
			var fname = file.path.filename;
			if (!fname.startsWith(".pmtool."))
				continue;

			var parts = fname.split('.');

			var tool = parts[2].toLowerCase().trim();
			var realName = parts.slice(3).join('.');

			if (tool == readT)
				file.moveTo(file.path.parent.join(realName));
			else
				file.delete();
		}
	}
}
