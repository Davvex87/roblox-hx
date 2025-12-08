package;

import utils.Resources;
import haxe.Exception;
import commands.*;
import utils.Constants;
import thx.semver.Version;
import utils.HaxeUtils;

using utils.ExitCode;
using StringTools;
using utils.AnsiColors;

class RobloxHx
{
	/**
	 * Quick access to the arguments array.
	 */
	public static var ARGUMENTS = Sys.args();

	/**
	 * List of commands available to the end user, descriptions and parameters.
	 */
	public static var COMMANDS:Map<String, Array<ICommand>> = [
		"USAGE" => [new CompileCommand(), new CleanCommand(), new CreateProjectCommand()],
		"MISC" => [new HelpCommand(), new VersionCommand(), new SetupCommand(),],
	];

	static function main()
	{
		// Strip the last argument of the arguments array, neko adds the cwd dir path as the last item in the array for some reason, and Sys.getCwd just returns the .n script dir path instead? what
		// trace(ARGUMENTS);
		Sys.setCwd(ARGUMENTS.splice(-1, 1)[0]);

		// Exit out of the program if we do not meet some criteria
		testForStartupDependencies();

		// If we don't supply any real arguments, just display some cool information about the library
		if (ARGUMENTS.length == 0)
		{
			printHeaders();
			printCommands();
			return exit(0);
		}

		// Parse the arguments to run a command and catch errors
		var master = ARGUMENTS.shift();
		for (_ => arr in COMMANDS)
		{
			for (cmd in arr)
			{
				if (cmd.aliases.contains(master))
				{
					try
					{
						cmd.run(ARGUMENTS);
					}
					catch (e:Dynamic)
					{
						if (e is String)
							return exit(-2, e);
						else if (e is Exception)
							return exit(-1, e.details());
						else
							return exit(-1, Std.string(e));
					}

					return exit(SUCCESS);
				}
			}
		}

		return exit(UNKNOWN_COMMAND, 'Unknown command $master. Run "roblox-hx --help" for a full list of commands.');
	}

	/**
	 * Tests to see if we have everything installed and ready to go!
	 * If not then exit out of the program with an error code.
	 */
	static function testForStartupDependencies()
	{
		// Checks if haxe is installed and is of a valid version
		final haxeVer:Null<Version> = HaxeUtils.getHaxeVersion();
		if (haxeVer == null)
			return exit(HAXE_NOT_PRESENT,
				'Haxe is not installed. roblox-hx requires Haxe v${Constants.MIN_HAXE_COMPILER_VERSION} or higher (${Constants.HAXE_COMPILER_VERSION} recommended).');
		else if (haxeVer < Constants.MIN_HAXE_COMPILER_VERSION)
			return exit(HAXE_VER_INCOMP,
				'Incompatible Haxe version present (${haxeVer}). roblox-hx requires Haxe v${Constants.MIN_HAXE_COMPILER_VERSION} or higher (${Constants.HAXE_COMPILER_VERSION} recommended).');

		// Checks for haxelib, this should never fail since, well, without haxelib, how did we install and ran the roblox-hx script in the first place?
		final haxelibVer:Null<Version> = HaxeUtils.getHaxelibVersion();
		if (haxelibVer == null)
			return exit(HAXELIB_NOT_PRESENT, 'Haxelib is not installed. roblox-hx requires haxelib to access external libraries.');

		// Print out a little warning message in case the user still hasn't ran the ´setup´ command yet
		if (!Resources.libLinkExists() && ARGUMENTS[0] != "setup")
			Sys.println("│ roblox-hx is not installed in the HAXEPATH directory!\n│ > Please run `haxelib run roblox-hx setup` first.\n".boldYellow());

		// Prints out a little warning message if we are missing some installed libraries
		final missingLibraries:Array<String> = ["reflaxe", "reflaxe.lua"];
		var i = missingLibraries.length - 1;
		while (i >= 0)
		{
			if (HaxeUtils.getLibraryVersion("reflaxe") != null)
				missingLibraries.splice(i, 1);
			i--;
		}
		if (missingLibraries.length > 0)
			Sys.println('│ Missing libraries: ${missingLibraries.join(", ")}\n│ > Please install these first through haxelib.\n'.boldYellow());
	}

	/**
	 * Prints some cool information about the library
	 */
	public static function printHeaders()
	{
		Sys.println(['roblox-hx v${Constants.ROBLOX_HX_VERSION}',].join("\n"));
	}

	/**
	 * Prints a list of all available commands
	 */
	public static function printCommands()
	{
		var start:Bool = true;
		for (cat => arr in COMMANDS)
		{
			if (!start)
				Sys.println("");
			Sys.println('$cat: ');
			start = false;

			for (cmd in arr)
			{
				var aliasString:String = cmd.aliases.join(", ");
				var spaces:Int = 20 - aliasString.length;

				// Kind of messy this string interpolation expression, it basically just ensures that the command descriptions are always aligned at a target distance
				Sys.println('    ${aliasString}${{var s = ""; for (i in 0...spaces) s+=" "; s;}}${cmd.description}');
			}
		}
	}
}

/**
 * Exits the program with an error code and a message.
 * Also sends the output to the correct output window based on the error code.
 * @param code Code to exit the program. 0 means no errors
 * @param msg Additional message to print when the close
 */
function exit(code:Int, ?msg:String)
{
	if (msg != null)
		if (code == 0)
			Sys.println(msg);
		else if (code == -1)
			Sys.stderr()
				.writeString('An internal exception was thrown:\n$msg\n\nIf this issue persists, please report it here: https://github.com/Davvex87/roblox-hx/issues'.boldRed());
		else
			Sys.stderr().writeString(msg.boldRed());

	return Sys.exit(code);
}
