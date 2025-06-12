package commands;

import utils.Constants;

/**
 * A command than just prints the version of the library which the script was compiled on, nothing too interesting to see here.
 */
class VersionCommand implements ICommand
{
	public var aliases:Array<String> = ["v", "version"];
	public var description:String = "Prints the current version of roblox-hx.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		Sys.println(Constants.ROBLOX_HX_VERSION.toString());
	}
}
