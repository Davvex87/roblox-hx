package commands;

import exceptions.ProjectCreatingException.ProjectCreationException;
import hx.files.Dir;
import hx.files.Path;

/**
 * When ran, will create a new empty project ``or from a template (TBD)`` to the target directory.
 * If the target directory already has files then it will throw.
 */
class CreateProjectCommand implements ICommand
{
	public var aliases:Array<String> = ["create"];
	public var description:String = "Creates a new project from an empty template";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		var location = Path.of(arguments.shift() ?? Dir.getCWD().path.toString());
		var dir = location.toDir();
		if (!dir.isEmpty())
			throw new ProjectCreationException("Target directory is not empty");

		// TODO: Add the ability to select a template, and clean this up.
		//       Maybe we can make it fetch templates from another github repository?

		var sourceFolder = location.join("source").toDir();
		var configFile = location.join("compiler.rhx.json").toFile();
		var entryFile = sourceFolder.path.join("Main.hx").toFile();

		sourceFolder.create();
		configFile.writeString('{
	"sourceFolder": "source",
	"outputFolder": "output",
	"entryPoint": "Main"
}');

		entryFile.writeString('
package;

class Main
{
	static function main():Void
	{
		trace("Hello, world!");
	}
}');

		Sys.println("Empty project created!");
	}
}
