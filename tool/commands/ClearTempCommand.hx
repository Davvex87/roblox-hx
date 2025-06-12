package commands;

import utils.Resources;

/**
 * A command class that, when ran, just clears the temp folder that roblox-hx creates.
 */
class ClearTempCommand implements ICommand
{
	public var aliases:Array<String> = ["ct", "cleartemp"];
	public var description:String = "Clears the temorary folder roblox-hx creates for compiling scripts.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		Resources.getTempFolder().join("rhcr").toDir().delete(true);
	}
}
