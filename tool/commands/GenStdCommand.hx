package commands;

import modules.InstanceFactoryPatcher;
import utils.HaxeUtils;
import modules.StdInjector;
import modules.GlobalPatcher;
import modules.TablePatcher;
import modules.StringPatcher;
import hx.files.File;
import exceptions.CompilationException;
import sys.io.Process;
import utils.Resources;
import hx.files.Dir;
import hx.files.Path;

using StringTools;

/**
 * A command that, when ran, generates an Std.lua file used by the haxe runtime in lua.
 */
class GenStdCommand implements ICommand
{
	public var aliases:Array<String> = ["std", "generatestd"];
	public var description:String = "Generates the Std.lua file required by the HxRuntime.lua file.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		generateStdFile(Dir.getCWD().path);
	}

	/**
	 * Generates our Std.lua file at the specified path.
	 * @param outputPath 
	 */
	public static function generateStdFile(outputPath:Path)
	{
		// Create or append some resources to the temp folder
		Resources.appendCompilationResources();
		Resources.patchLibBuildParams();
		var haxeStd = Resources.appendStdLibrary();

		// Cache up some directories and paths for later use
		var tempPath:Path = Resources.getTempFolder();
		var tempDir:Dir = tempPath.toDir();
		var emptyFile:File = tempPath.join("Empty.hx").toFile();
		var outputFile:File = outputPath.join("Std.lua").toFile();

		// Push our custom std library path for roblox-hx
		Sys.putEnv("HAXE_STD_PATH", haxeStd.getAbsolutePath());

		tempDir.setCWD();
		emptyFile.writeString("package;");

		// Prepare the haxe compilation arguments
		var args:Array<String> = [
			'--lua ${outputFile.toString()}',
			'--dce no',
			// '-lib roblox-hx',
			'Empty',

			'haxe.Log',
			'haxe.Rest',
			'haxe.Constraints',
			'haxe.Json',
			'haxe.Template',
			'lua.TableTools'
		];

		// Run it
		var process = new Process('haxe ${args.join(" ")}');
		var code = process.exitCode();
		var output = process.stdout.readAll().toString();
		var err = process.stderr.readAll().toString();

		Sys.putEnv("HAXE_STD_PATH", null);
		process.close();
		if (code != 0)
			throw new CompilationException(err);

		// Store a list of all of the times compiled
		var compiledClasses:Array<String> = [];
		for (line in outputFile.readAsString('').split("\n"))
		{
			if (!line.endsWith(" = _hx_e()"))
				continue;

			if (line.startsWith("local "))
				line = line.substr(6);

			compiledClasses.push(line.substring(0, line.length - 10));
		}

		var fileStr = outputFile.readAsString("");

		// Patch the final output
		fileStr = StdInjector.inject(fileStr);
		fileStr = GlobalPatcher.patch(fileStr);
		fileStr = StringPatcher.patch(fileStr);
		fileStr = TablePatcher.patch(fileStr);
		fileStr = InstanceFactoryPatcher.patch(fileStr);

		fileStr += '\n\nreturn {${GenStdCommand.STD_LUA_FIELDS.join(", ")}, ${GenStdCommand.HAXE_STD_ABSTRACTS.join(", ")}, ${compiledClasses.join(", ")}}';

		// Save it with our patched version
		outputFile.writeString(fileStr);
	}

	private static final STD_LUA_FIELDS:Array<String> = [
		"_hx_hidden",
		"_hx_array_mt",
		"_hx_is_array",
		"_hx_tab_array",
		"_hx_print_class",
		"_hx_print_enum",
		"_hx_tostring",
		"_hx_obj_newindex",
		"_hx_obj_mt",
		"_hx_a",
		"_hx_e",
		"_hx_o",
		"_hx_new",
		"_hx_field_arr",
		"_hxClasses",
		"_hx_bind",
		"_hx_bit",
		"_hx_staticToInstance",
		"_hx_funcToField",
		"_hx_maxn",
		"_hx_print",
		"_hx_apply_self",
		"_hx_box_mr",
		"_hx_bit_clamp",
		"_hx_table",
		"_hx_bit_raw",
		"_hx_pcall_default",
		"_hx_pcall_break",
		"_hx_handle_error",
		"_hx_static_init",
	];
	private static final HAXE_STD_ABSTRACTS:Array<String> = ["Int", "Dynamic", "Float", "Bool", "Class", "Enum",];
}
