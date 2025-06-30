package;

import json2object.JsonParser;
import hx.files.File;
import hx.files.Path;
import exceptions.OptionsFileException;
import haxe.io.Path as HaxePath;

typedef CompilerOptions =
{
	@:optional
	var sourceFolder:String;

	@:default("out") @:optional
	var outputFolder:String;

	@:optional
	var entryPoint:String;

	@:default(new Array<String>()) @:optional
	var subprograms:Array<String>;

	@:optional
	var rojoSupport:Bool;

	@:default(true) @:optional
	var copyNonSourceFiles:Bool;

	@:optional
	var clientPackages:Array<String>;

	@:optional @:jignored var _filePath:String;
}

/**
 * Loads a roblox-hx compiler options .json file from the specified path and correctly parsed it into a typed structure.
 * @param path The path of the .json file
 */
function buildOptionsFromFile(path:String)
{
	var p:Path = Path.of(path);

	if (!p.isFile())
		throw new OptionsFileException("Expected file, got directory");

	var file:File = p.toFile();
	var document:Null<String> = file.readAsString();

	if (document == null)
		throw new OptionsFileException("File read stream error");

	var parser = new JsonParser<CompilerOptions>();
	var opts:CompilerOptions = parser.fromJson(document, p.filename);

	// This just makes sure that the source and output folders are always representing the absolute path, not the relative path
	if (opts.sourceFolder != null)
		opts.sourceFolder = HaxePath.normalize(HaxePath.join([p.parent.getAbsolutePath(), opts.sourceFolder]));

	opts.outputFolder = HaxePath.normalize(HaxePath.join([p.parent.getAbsolutePath(), opts.outputFolder]));
	opts._filePath = path;

	return opts;
}
