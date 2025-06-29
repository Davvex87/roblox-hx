import haxe.io.Path;
import sys.FileSystem;
import haxe.Json;
import sys.io.FileOutput;
import sys.io.File;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;

class LuaModMacro
{
	public static var CALLBACK_ADDED:Bool = false;
	public static var MODS_PER_PKG:Dynamic<Dynamic> = {};

	public static macro function build():Expr
	{
		#if type_info
		if (!CALLBACK_ADDED)
		{
			CALLBACK_ADDED = true;
			Context.onGenerate(onGenerate, false);
		}
		#end

		return null;
	}

	static function onGenerate(types:Array<Type>)
	{
		var saveFile = Path.join([Sys.getCwd(), "pkg_list-lock.json"]);
		var pkgs:Dynamic<Dynamic> = {};

		if (FileSystem.exists(saveFile))
			pkgs = Json.parse(File.getContent(saveFile));

		var fileOut:FileOutput = File.write(saveFile, false);

		function ensureMap(f:String, ?o:Dynamic, ?a:Bool = false):Dynamic<Dynamic>
		{
			o ??= pkgs;
			if (!Reflect.hasField(o, f))
				Reflect.setField(o, f, a ? [] : {});

			return Reflect.field(o, f);
		}

		function doTheThing(type:BaseType)
		{
			var file = FileSystem.absolutePath(Path.normalize(Context.getPosInfos(type.pos).file));
			var pkg = type.pack.copy();

			var pkgObj:Dynamic<Dynamic> = null;
			var p;
			while (({p = pkg.shift(); p;}) != null)
				pkgObj = ensureMap(p, pkgObj);

			pkgObj = ensureMap("_MODULES", pkgObj, true);

			var arr:Array<{n:String, f:String}> = cast pkgObj;

			for (item in arr)
			{
				if (item.n == type.name && item.f == file)
					return;
			}

			arr.push({
				n: type.name,
				f: file
			});
		}

		for (type in types)
		{
			switch (type)
			{
				case TEnum(t, params):
					var t = t.get();
					if (isValidType(t))
						doTheThing(t);

				case TInst(t, params):
					var t = t.get();
					if (isValidType(t))
						doTheThing(t);

				case TType(t, params): // I guess we can ignore structures because haxe doesn't compile them???
					/*	var t = t.get();
						if (isValidType(t)) doTheThing(t); */

				case TAbstract(t, params):
					var t = t.get();
					if (isValidType(t))
						doTheThing(t);

				case TLazy(f):
					trace("lazy?");

				default:
					trace(type);
			}
		}

		fileOut.writeString(Json.stringify(pkgs, null, "\t"));
		fileOut.flush();
		fileOut.close();
	}

	static function isValidType(t:BaseType)
	{
		if (t.isExtern)
			return false;
		if (t.meta.has(':coreApi'))
			return false;

		if (StringTools.endsWith(t.name, "_Impl_"))
			return false;

		for (module in BLACKLISTED_MODULES)
			if (StringTools.startsWith(t.module, module))
				return false;

		for (typeName in BLACKLISTED_TYPES)
			if (t.name == typeName)
				return false;

		return true;
	}

	public static final BLACKLISTED_MODULES:Array<String> = [
		"cpp", "cs", "eval", "flash", "haxe", "hl", "java", "js", "jvm", "lua", "neko", "php", "python", "sys",
	];
	public static final BLACKLISTED_TYPES:Array<String> = [
		"Any",
		"Array",
		"Class",
		"Date",
		"DateTools",
		"Enum",
		"EnumValues",
		"EReg",
		"IntIterator",
		"Lambda",
		"List",
		"Map",
		"Math",
		"Reflect",
		"Std",
		"StdTypes",
		"String",
		"StringBuf",
		"StringTools",
		"Sys",
		"Type",
		"UInt",
		"UnicodeString",
		"Xml",
		"EnumValue",
		"Void",
		"Float",
		"Int",
		"Null",
		"Bool",
		"Dynamic",
	];
}
