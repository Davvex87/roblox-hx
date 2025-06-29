package modules;

import haxe.Exception;
import utils.HaxeUtils;
import hx.files.Path;
import hx.files.Dir;
import hx.files.File;

using StringTools;

class InstanceFactoryPatcher
{
	public static function patch(file:String):String
	{
		var libPath = HaxeUtils.getLibraryDir("roblox-hx");
		if (libPath == null)
			throw new Exception("Library roblox-hx is not installed");

		var modules:Array<String> = [];
		var sourcePath = libPath.join("proxy").join("rblx");
		for (file in sourcePath.toDir().findFiles("**/*.hx"))
			modules.push(file.path.getAbsolutePath()
				.replace(sourcePath.getAbsolutePath(), "")
				.replace("/", ".")
				.replace("\\", ".")
				.replace(".hx", ""));

		for (mod in modules)
		{
			mod = 'rblx$mod';
			var s = mod.split(".");
			file = file.replace(mod, s[s.length - 1]);
		}

		var pattern = new EReg('([A-Za-z0-9_]+)\\s*\\.\\s*INSTANCE_FACTORY\\s*\\.\\s*CREATE_OBJ\\s*\\(\\s*([^()]*(?:\\([^()]*\\)[^()]*)*)\\s*\\)', 'g');

		file = pattern.map(file, function(re:EReg)
		{
			var className = re.matched(1);
			var params = re.matched(2);
			return params == "" ? 'Instance.new(\'$className\')' : 'Instance.new(\'$className\', $params)';
		});

		return file;
	}
}
