package commands;

import utils.HaxeUtils;
import modules.GlobalPatcher;
import modules.TablePatcher;
import modules.StringPatcher;
import sys.io.FileInput;
import haxe.ds.StringMap;
import haxe.Json;
import utils.Resources;
import sys.io.Process;
import exceptions.CompilationException;
import hx.files.Dir;
import hx.files.File;
import CompilerOptions;
import hx.files.Path;
import haxe.io.Path as HxPath;
import sys.io.File as SysFile;

using StringTools;

/**
 * A command that, when ran, will compile the haxe source given a file, folder or compiler options .json file into luau.
 */
class CompileCommand implements ICommand
{
	public var aliases:Array<String> = ["c", "compile"];
	public var description:String = "Compiles a roblox-hx project or .hx file to luau.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		var optsOrFile:Null<String> = arguments.shift();
		var isProject:Bool = true;
		if (optsOrFile != null)
		{
			var p:Path = Path.of(optsOrFile);
			if (p.filenameExt != "json")
				isProject = false;
		}
		else
			optsOrFile = "compiler.rhx.json";

		if (isProject)
		{
			var p:Path = Path.of(optsOrFile);
			if (!p.exists() || p.isDirectory())
				throw new CompilationException("Project file not found or is a directory");

			var absPath = p.getAbsolutePath();
			var opts:CompilerOptions = buildOptionsFromFile(absPath);
			CompileCommand.compileMaster(opts, p);
		}
		else
		{
			var p:Path = Path.of(optsOrFile);
			var opt:CompilerOptions = {
				sourceFolder: HxPath.normalize(Sys.getCwd()),
				outputFolder: HxPath.normalize(Sys.getCwd()),

				_filePath: HxPath.normalize(Sys.getCwd())
			};

			// TODO: Maybe we could make a subargument system for each commands similar to the master commands one
			while (RobloxHx.ARGUMENTS.length > 0)
			{
				switch (RobloxHx.ARGUMENTS.shift())
				{
					case "--src" | "-s":
						opt.sourceFolder = Path.of(RobloxHx.ARGUMENTS.shift()).getAbsolutePath();
					case "--out" | "-o":
						opt.outputFolder = Path.of(RobloxHx.ARGUMENTS.shift()).getAbsolutePath();
					case p:
						if (!p.startsWith("-"))
							continue;
						Sys.println('Unknown parameter "$p", skipping...');
				}
			}

			Resources.appendCompilationResources();
			var haxeStd = Resources.appendStdLibrary();

			Sys.putEnv("HAXE_STD_PATH", haxeStd.getAbsolutePath());

			CompileCommand.compileFile(p, opt);

			Sys.putEnv("HAXE_STD_PATH", null);

			// ^^^ There's gotta be a better way to do this, right?
		}

		Sys.println("Build successfull!");
	}

	/**
	 * Compile a program as master given some compiler options and the master program path.
	 * @param opts Options structure
	 * @param masterPath A path object representing the master program path
	 */
	public static function compileMaster(opts:CompilerOptions, masterPath:Path)
	{
		// First, we compile all available subprograms...
		if (opts.subprograms != null && opts.subprograms.length > 0)
		{
			for (sub in opts.subprograms)
			{
				var newOpts:CompilerOptions = buildOptionsFromFile(masterPath.join(sub).getAbsolutePath());
				compileProject(newOpts);
			}
		}

		// ...and only then we compile the master program

		if (opts.sourceFolder != null)
			compileProject(opts);

		Sys.println("Master build finished.");
	}

	/**
	 * Compile a program and it's haxe source files into lua given some compiler options
	 * @param opts Options structure
	 */
	public static function compileProject(opts:CompilerOptions)
	{
		var d = Dir.of(opts.sourceFolder);

		// Create or append resources to the temp folder for future use.
		Resources.appendCompilationResources();
		var haxeStd = Resources.appendStdLibrary();

		// Tell the haxe compiler to use this as our custom std path
		Sys.putEnv("HAXE_STD_PATH", haxeStd.getAbsolutePath());

		var haxeSourceFiles = d.findFiles("**/*.hx");

		// Generate export information .json files to help us determine what types to compile and what each type demands.
		for (file in haxeSourceFiles)
			generateFileExports(file.path, opts);

		// Get your export files and continuous read stream so that no other program can interfer.
		var typePkgFile:File = Dir.getCWD().path.join("type_pkg-lock.json").toFile();
		var typePkgReadStream:FileInput = SysFile.read(typePkgFile.path.getAbsolutePath());

		var pkgListFile:File = Dir.getCWD().path.join("pkg_list-lock.json").toFile();
		var pkgListReadStream:FileInput = SysFile.read(pkgListFile.path.getAbsolutePath());

		// Parse the files into semi-typed dynamic structures
		var typesByFile:FileTypes = Json.parse(typePkgReadStream.readAll().toString());
		var pkgList:PakagesList = Json.parse(pkgListReadStream.readAll().toString());

		// Attention: This counter does not represent the number of types present in the program,
		// it just represents the total number of source files which contains types.
		final totalSourceFileCount:Int = Reflect.fields(typesByFile).length;

		// Now that we have everything we need, we're ready to compile some .hx to .lua!
		for (file in haxeSourceFiles)
			compileFile(file.path, opts, typesByFile, pkgList);

		// If we specified an entry point in our options structure then add the __init__.lua file to the final output.
		// This is so that our program can actually run on its own without a third party activating it first.
		if (opts.entryPoint != null)
		{
			var robloxHxLibPath = HaxeUtils.getLibraryDir('roblox-hx');
			if (robloxHxLibPath == null)
				throw new CompilationException('Library "roblox-hx" not found. Try running "haxelib install roblox-hx"');

			// Read the template...
			var baseEntryScript:String = robloxHxLibPath.joinAll(["res", "__init__.lua"]).toFile().readAsString();

			// ...and replace some things with our custom data...
			baseEntryScript = baseEntryScript.replace("MODULE_NUMBER_COUNT", Std.string(totalSourceFileCount));
			baseEntryScript = baseEntryScript.replace("ENTRY_POINT_TYPE", opts.entryPoint);

			// ...and package them up!
			sys.io.File.saveContent(Path.of(opts.outputFolder).join("__init__.lua").getAbsolutePath(), baseEntryScript);
		}

		// Closes the read streams to tell the OS we're no longer using them
		typePkgReadStream.close();
		pkgListReadStream.close();

		// Reset the std environment variable
		Sys.putEnv("HAXE_STD_PATH", null);

		Sys.println("Program build finished.");
	}

	/**
	 * Compiles a haxe source file given some compiler options, a list of pre-cached files and packages.
	 * 
	 * **Not recomended for general use, please use ``compileProject`` instead!**
	 * 
	 * @param path The path to the haxe source file
	 * @param opts Options structure
	 * @param typesByFile The structure containing type info per module
	 * @param pkgList The structure containing package info per file
	 */
	public static function compileFile(path:Path, opts:CompilerOptions, ?typesByFile:FileTypes, ?pkgList:PakagesList)
	{
		typesByFile ??= {};
		pkgList ??= {};

		// Prepare some paths and directories
		var absPath = HxPath.normalize(path.normalize().getAbsolutePath());
		var file = path.filename;
		var fName = path.filenameStem;
		var relativeDir = Path.of(absPath.replace(opts.sourceFolder, "").replace(file, "")).normalize();
		var outputDir = Path.of(opts.outputFolder).join(relativeDir).normalize();
		var outputFile:File = Path.of(HxPath.join([outputDir.getAbsolutePath(), '${path.filenameStem}.lua'])).toFile();

		var tempFolder:Path = Resources.getTempFolder().join("rhcr");
		var luaFiles:Path = tempFolder.join("lua").join("_lua");

		// Define a list of .lua source files to include and exclude from compilation
		var fileIncludes = [];

		var fileExcludes = [
			'lua/_lua/_hx_anon.lua',
			'lua/_lua/_hx_apply_self.lua',
			'lua/_lua/_hx_bind.lua',
			'lua/_lua/_hx_bit.lua',
			'lua/_lua/_hx_bit_clamp.lua',
			'lua/_lua/_hx_box_mr.lua',
			'lua/_lua/_hx_classes.lua',
			'lua/_lua/_hx_dyn_add.lua',
			'lua/_lua/_hx_func_to_field.lua',
			'lua/_lua/_hx_handle_error.lua',
			'lua/_lua/_hx_luv.lua',
			'lua/_lua/_hx_print.lua',
			'lua/_lua/_hx_random_init.lua',
			'lua/_lua/_hx_static_to_instance.lua',
			'lua/_lua/_hx_tab_array.lua',
			'lua/_lua/_hx_table.lua',
			'lua/_lua/_hx_tostring.lua',
			'lua/_lua/_hx_wrap_if_string_field.lua'
		];

		var typeExcludes = [];
		// Get a list of times to exclude in compilation
		// This is so that only the types that belong to that file get compiled into said file
		var ex:Array<{n:String, p:String}> = getTypesToExclude(typesByFile, absPath);
		for (o in ex)
			typeExcludes.push('${o.p}.${o.n}');

		// Prepare the argument list
		var args = [
			"-cp",
			opts.sourceFolder,
			"--lua",
			outputFile.toString(),
			"--dce std",
			"-lib roblox-hx",

			HxPath.normalize(HxPath.join([relativeDir.toString(), fName])
				.replace("/", ".")
				.replace("\\", ".")
				.substr(1)),
		];

		// Push our includes and excludes
		for (file in fileIncludes)
			args.push("--macro includeFile('" + HxPath.normalize(file).replace("\\", '/') + "')");
		for (file in fileExcludes)
			args.push("--macro excludeFile('" + HxPath.normalize(file).replace("\\", '/') + "')");

		for (type in typeExcludes)
			args.push('--macro exclude(\'$type\')');

		// Compile and wait...
		var process = new Process('haxe ${args.join(" ")}');
		var code = process.exitCode();
		var output = process.stdout.readAll().toString();
		var err = process.stderr.readAll().toString();
		process.close();

		if (code != 0)
			throw new CompilationException(err);

		// Get a list of the names of each type which was compiled
		var compiledClasses:Array<String> = [];
		for (line in outputFile.readAsString('').split("\n"))
		{
			if (!line.endsWith(" = _hx_e()"))
				continue;

			if (line.startsWith("local "))
				line = line.substr(6);

			compiledClasses.push(line.substring(0, line.length - 10));
		}

		// Modify the output to import the types that we're using based on what we know so far
		var typeReplaceResult = modifyWithClassesInUse(outputFile.readAsString(""), typesByFile, pkgList);
		var typesInStr:Array<String> = typeReplaceResult.r;
		var fileStr:String = typeReplaceResult.i;

		// Patches some weird declarations that haxe likes to add which we do not care about
		fileStr = fileStr.replace("_hx_array_mt.__index = Array.prototype\n", "");
		fileStr = fileStr.replace("local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw\n",
			"");
		fileStr = fileStr.replace("local _hx_pcall_default = {};\n", "");
		fileStr = fileStr.replace("local _hx_pcall_break = {};\n\n", "");
		fileStr = fileStr.replace("\n\n\n\n_hx_static_init();\n", "");
		fileStr = fileStr.replace("_hx_array_mt.__index = __Array.prototype", "");

		// More patches to the output
		fileStr = GlobalPatcher.patch(fileStr);
		fileStr = StringPatcher.patch(fileStr);
		fileStr = TablePatcher.patch(fileStr);

		// Add the imports into the static initialization function from the function we called a while ago
		var typePkgStr = '';
		var typePkgImportStr = 'local _hx_static_init = function()';

		for (t in typesInStr)
		{
			if (compiledClasses.contains(t))
				continue;

			typePkgStr += '\nlocal __${t.replace('.', '_')};';
			typePkgImportStr += '\n  __${t.replace('.', '_')} = hxrt.import("${t}");';
		}

		fileStr = fileStr.replace("-- ADD PACKAGES HERE", typePkgStr);
		// Push
		fileStr = fileStr.replace("local _hx_static_init = function()", typePkgImportStr);

		// Add a function call to the haxe runtime lib to push our static init function
		fileStr += '\n\nhxrt._p_stfn(_hx_static_init);';

		// And finally, add a return table containing every time we defined in this class
		compiledClasses.insert(0, "_hx_static_init");
		fileStr += '\n\nreturn {${compiledClasses.join(", ")}}';

		// Write the changes to the file and we're done with this one
		outputFile.writeString(fileStr);
	}

	/**
	 * Generates type export information .json files that we'll need in order to successfully compile our haxe source files into lua files
	 * @param path The source path
	 * @param opts Options structure
	 */
	public static function generateFileExports(path:Path, opts:CompilerOptions)
	{
		// Prepare some directories and paths
		var absPath = HxPath.normalize(path.normalize().getAbsolutePath());
		var file = path.filename;
		var fName = path.filenameStem;
		var relativeDir = Path.of(absPath.replace(opts.sourceFolder, "").replace(file, "")).normalize();
		var outputDir = Path.of(opts.outputFolder).join(relativeDir).normalize();
		var outputFile:File = Path.of(HxPath.join([outputDir.getAbsolutePath(), '${path.filenameStem}.lua'])).toFile();

		// Build the compilation arguments
		var args = [
			"-cp",
			opts.sourceFolder,
			"--lua",
			outputFile.toString(),
			"--dce no",
			"-lib roblox-hx",
			"--no-output",
			"-D type_info",

			HxPath.normalize(HxPath.join([relativeDir.toString(), fName])
				.replace("/", ".")
				.replace("\\", ".")
				.substr(1)),
		];

		// Run our macros
		// This call does not generate any lua files
		var process = new Process('haxe ${args.join(" ")}');
		var code = process.exitCode();
		var output = process.stdout.readAll().toString();
		var err = process.stderr.readAll().toString();

		process.close();
		if (code != 0)
			throw new CompilationException(err);

		// We should now have our .json files filled with information about this haxe source file
	}

	/**
	 * Returns a list of types and their respective packages to exclude from compilation given the types we already know relative to the project and the source path.
	 * @param fileTypes Types structure
	 * @param fPath Source path
	 * @return Our exclusion list
	 */
	static function getTypesToExclude(fileTypes:FileTypes, fPath:String):Array<{n:String, p:String}>
	{
		var ex:Array<{n:String, p:String}> = [];
		var fs = Reflect.fields(fileTypes);
		for (fn in fs)
		{
			if (fn == fPath)
				continue;

			for (tpk in cast(Reflect.field(fileTypes, fn), Array<Dynamic>))
				ex.push(tpk);
		}

		return ex;
	}

	/**
	 * Modifies a lua output script with some stuff that will come in handy later on during compilation
	 * @param input The lua output, or in this case, input
	 * @param typesByFile The types we already know
	 * @param pkgList The packages we already know
	 */
	static function modifyWithClassesInUse(input:String, typesByFile:FileTypes, pkgList:PakagesList):{i:String, r:Array<String>}
	{
		var topLevelPackages:Array<String> = [];
		var topLevelModules:Array<String> = [];

		// Searches for top level types and adds them
		for (field in Reflect.fields(pkgList))
		{
			if (field == "_MODULES")
			{
				for (mod in cast(Reflect.field(pkgList, field), Array<Dynamic>))
					topLevelModules.push(mod.n);
				continue;
			}

			topLevelPackages.push(field);
		}

		var result = [];

		var allTypes:Array<String> = HAXE_STD_TYPES.copy();

		// Build all of the types and packages paths
		for (field in Reflect.fields(typesByFile))
		{
			var files:Array<{p:String, n:String}> = Reflect.field(typesByFile, field);
			for (def in files)
			{
				var t = '${def.p.length > 0 ? '${def.p}.' : ''}${def.n}';
				if (!allTypes.contains(t) && !topLevelModules.contains(t))
					allTypes.push(t);
			}
		}

		// Loop through all the types and packages...
		for (t in allTypes)
		{
			var found = false;
			var searchStart = 0;

			// ...and replace any finds of them with the correct definition, aka replacing periods with underscores
			while (true)
			{
				var index = input.indexOf(t, searchStart);
				if (index == -1)
					break;

				var charBefore = index > 0 ? input.charAt(index - 1) : '';
				var charAfterIndex = index + t.length;
				var charAfter = charAfterIndex < input.length ? input.charAt(charAfterIndex) : '';

				// ChatGPT, not me
				// I have absolutelly no idea how this works, it just does
				if ((charBefore == '' || !~/[a-zA-Z0-9"']/.match(charBefore)) && (charAfter == '' || !~/[a-zA-Z0-9"']/.match(charAfter)))
				{
					var newT = '__${t.replace(".", "_")}';
					input = input.substr(0, index) + newT + input.substr(index + t.length);
					searchStart = index + newT.length;
					found = true;
				}
				else
					searchStart = index + t.length;

				// I really need to learn about regx expressions, don't I ;-;
			}

			if (found)
				result.push(t);
		}

		return {i: input, r: result};
	}

	/**
	 * Just an array of the haxe std library with lua externs
	 */
	private static final HAXE_STD_TYPES:Array<String> = [
		"_EnumValue.EnumValue_Impl_",
		"haxe.SysTools",
		"haxe.StackItem",
		"haxe._CallStack.CallStack_Impl_",
		"haxe.IMap",
		"haxe.Exception",
		"haxe.Json",
		"haxe.Log",
		"haxe.NativeStackTrace",
		"haxe._Rest.Rest_Impl_",
		"haxe._Template.TemplateExpr",
		"haxe.iterators.ArrayIterator",
		"haxe.Template",
		"haxe.ValueException",
		"haxe.ds.BalancedTree",
		"haxe.ds.TreeNode",
		"haxe.ds.EnumValueMap",
		"haxe.ds.IntMap",
		"haxe.ds.List",
		"haxe.ds._List.ListNode",
		"haxe.ds._List.ListIterator",
		"haxe.ds._List.ListKeyValueIterator",
		"haxe.ds._Map.Map_Impl_",
		"haxe.ds.ObjectMap",
		"haxe.ds._ReadOnlyArray.ReadOnlyArray_Impl_",
		"haxe.ds.StringMap",
		"haxe.format.JsonParser",
		"haxe.format.JsonPrinter",
		"haxe.iterators.ArrayKeyValueIterator",
		"haxe.iterators.MapKeyValueIterator",
		"haxe.iterators.RestIterator",
		"haxe.iterators.RestKeyValueIterator",
		"haxe.iterators.StringIterator",
		"haxe.iterators.StringIteratorUnicode",
		"haxe.iterators.StringKeyValueIterator",
		"lua.Boot",
		"lua.Lib",
		"lua._Lua.Lua_Fields_",
		"lua.PairTools",
		"lua.Thread",
		"lua.UserData",
	];
}

typedef FileTypes = Dynamic<Array<{n:String, p:String}>>;
typedef PakagesList = Dynamic<Dynamic>;
