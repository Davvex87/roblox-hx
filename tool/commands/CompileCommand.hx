package commands;

import utils.json.Json2Lua;
import haxe.Exception;
import sys.FileSystem;
import haxe.Resource;
import utils.Resources;
import hx.files.File;
import haxe.Json;
import utils.ProcessWatch;
import hx.files.Dir;
import hx.files.Path;

using StringTools;
using utils.AnsiColors;

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
		var rootPath = Path.of(absPath).parent;
		var hxml:HXML = HXML.fromFile(absPath);
		var conf:ProjectConfig = Json.parse(rootPath.join("config.rhx.json").toFile().readAsString());
		CompileCommand.compileProject(hxml, conf, rootPath);

		Sys.println("Build successfull!".boldBlue());
	}

	/**
	 * Compile a program and it's haxe source files into lua given some compiler options
	 * @param hxml Project hxml configuration
	 * @param conf Project structure configuration
	 * @param masterPath A path object representing the master program path
	 */
	public static function compileProject(hxml:HXML, conf:ProjectConfig, masterPath:Path)
	{
		hxml.define("reflaxe_measure");
		final outputPath = Path.of(hxml.getDefine("lua-output"));
		final tempOutputPath = Resources.getTempFolder().join('rhx${Std.int(Math.random() * 999999)}');
		var hxmlEntries:Array<String> = cast hxml;
		for (str in hxmlEntries)
		{
			if (str.startsWith("-D lua-output="))
			{
				hxmlEntries.remove(str);
				break;
			}
		}
		hxml.define("lua-output", tempOutputPath);

		final haxeArgs:Array<String> = cast hxml;
		final haxeCommand = 'haxe ' + haxeArgs.join(" ");
		Sys.println("Run queue:".boldBlack());
		Sys.println(haxeCommand.boldBlack());

		final compileProcess = new ProcessWatch(haxeCommand);

		compileProcess.addDefaultListeners();
		var lastError:String = "";
		compileProcess.addErrorListener(l -> lastError = l);

		final compileCode = compileProcess.waitExit();

		if (compileCode != 0)
			throw lastError;

		Sys.println('Build finished with exit code $compileCode'.boldGreen());

		if (hxml.hasDefine("copy-non-source-files"))
		{
			final rootClassPath = hxml.getClassPaths(true)[0];
			var files = Dir.of(rootClassPath).findFiles("**/*").filter(f -> f.path.filenameExt != "hx");
			if (files.length > 0)
			{
				Sys.println('Copying ${files.length} non-source files...'.boldBlue());
				for (file in files)
				{
					var dir = tempOutputPath.join(file.path.getAbsolutePath().replace("\\", "/").replace(rootClassPath.replace("\\", "/"), ""));
					dir.parent.toDir().create();
					file.copyTo(dir, [OVERWRITE]);
				}

				Sys.println("Files copied!".boldBlue());
			}
			else
				Sys.println("No non-source files to copy.".boldYellow());
		}

		try
		{
			function fetchPkgContext(rootPackage:Null<String>):{context:String, justPush:Bool}
			{
				var justPush = false;
				var pkgContext:Null<String> = cast Reflect.field(conf.packageContexts, rootPackage ?? "_");
				if (pkgContext == null)
					pkgContext = Reflect.field(conf.packageContexts, "_");

				if (pkgContext.endsWith("#"))
				{
					justPush = true;
					pkgContext = pkgContext.substring(0, pkgContext.length - 1);
				}
				return {context: pkgContext, justPush: justPush};
			}
			function moveFile(p:Path, isFile:Bool)
			{
				final relativeStr = p.getAbsolutePath().replace("\\", "/").replace(tempOutputPath.getAbsolutePath().replace("\\", "/") + "/", "");
				final relativePath = if (isFile) File.of(relativeStr).path else Dir.of(relativeStr).path;
				var rootPackage = if (isFile) relativePath.root?.toString() else relativePath.toString().split("/")[0];

				final r = fetchPkgContext(rootPackage);
				var pkgContext = r.context;
				var justPush = r.justPush;

				if (pkgContext == null)
					pkgContext = Reflect.field(conf.packageContexts, "_");

				final contextPath = Reflect.field(conf.contextPaths, pkgContext);

				var finalPath:Path;
				if (isFile)
				{
					var path = Path.of(outputPath.getAbsolutePath()).join(pkgContext).join(relativePath);
					if (!FileSystem.exists(path.parent.getAbsolutePath()))
						FileSystem.createDirectory(path.parent.getAbsolutePath());
					File.of(p).copyTo(path, [OVERWRITE]);
				}
				else
				{
					if (justPush)
					{
						var path:Path = Path.of(outputPath.getAbsolutePath()).join(pkgContext).join(relativePath);
						Dir.of(p).copyTo(path, [MERGE]);
					}
					else
					{
						var path:Path = Path.of(outputPath.getAbsolutePath()).join(relativePath);
						if (!FileSystem.exists(path.getAbsolutePath()))
							FileSystem.createDirectory(path.getAbsolutePath());
						Dir.of(p).find("*", (f:File) ->
						{
							f.copyTo(path.join(f.path.filename), [OVERWRITE]);
						}, (d:Dir) ->
							{
								d.copyTo(path.join(d.path.filename), [OVERWRITE]);
							});
					}
				}
			}

			Dir.of(tempOutputPath).find("*", (f:File) -> moveFile(f.path, true), (d:Dir) -> moveFile(d.path, false));

			final r = fetchPkgContext("");
			var pkgContext = r.context;
			var wrapperPath = Path.of(outputPath.getAbsolutePath()).join(pkgContext).join("HxPkgWrapper.lua");
			final wrapperFile = File.of(wrapperPath);
			var wrapperContent = wrapperFile.readAsString();
			wrapperFile.writeString(wrapperContent.replace("nil--CONFIG", Json2Lua.print(conf)));
		}
		catch (e:Exception)
		{
			try
			{
				Dir.of(tempOutputPath).delete(true);
			}
			catch (e:Dynamic) {}
			throw new Exception(e.message, e);
		}

		Sys.println("Project compilation finished!".boldBlue());
	}
}
