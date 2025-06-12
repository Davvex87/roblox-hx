package;

import sys.FileSystem;
import haxe.ds.StringMap;
import haxe.macro.Expr;
import haxe.macro.Expr.Position;
import haxe.Json;
import haxe.io.Path;
import sys.io.FileOutput;
import sys.io.File;
import haxe.macro.Type.ClassType;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Type;

class LuaDepMacro
{
	public static var CALLBACK_ADDED:Bool = false;

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
		var saveFile = Path.join([Sys.getCwd(), "type_pkg-lock.json"]);
		var fileTypes:Dynamic<Array<{n:String, p:String}>> = {};

		if (FileSystem.exists(saveFile))
			fileTypes = Json.parse(File.getContent(saveFile));

		var fileOut:FileOutput = File.write(saveFile, false);

		function ensureMap(f:String):Array<{n:String, p:String}>
		{
			if (!Reflect.hasField(fileTypes, f))
				Reflect.setField(fileTypes, f, []);

			return Reflect.field(fileTypes, f);
		}

		function doTheThing(type:BaseType)
		{
			var file = FileSystem.absolutePath(Path.normalize(Context.getPosInfos(type.pos).file));

			var data = ensureMap(file);
			var n = type.name;
			var p = type.pack?.join(".") ?? "";

			for (d in data)
				if (d.n == n && d.p == p)
					return;

			data.push({
				n: type.name,
				p: type.pack.join(".")
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

		fileOut.writeString(Json.stringify(fileTypes, null, "\t"));
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
