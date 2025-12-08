package commands;

import utils.HaxeUtils;
import utils.Resources;
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
		final linkPath:Path = Resources.getLibLinkPath();

		if (HaxeUtils.isWin)
			File.of(linkPath).writeString("@haxelib --global run roblox-hx %*", true);
		else
		{
			final scriptPath = HaxeUtils.getLibraryDir("roblox-hx").join("roblox-hx");

			final linkStr = linkPath.getAbsolutePath();
			final scriptStr = scriptPath.getAbsolutePath();
			Sys.command("chmod", ["+x", scriptStr]);
			if (linkPath.exists())
				Sys.command("sudo", ["rm", linkStr]);
			Sys.command("sudo", ["ln", "-s", scriptStr, linkStr]);
		}
	}
}
