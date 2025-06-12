package commands;

/**
 * A command that, when ran, prints a list of all available commands for the user to execute.
 */
class HelpCommand implements ICommand
{
	public var aliases:Array<String> = ["h", "help"];
	public var description:String = "Shows a dense list of all available commands.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		RobloxHx.printCommands();
	}
}
