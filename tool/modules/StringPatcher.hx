package modules;

using StringTools;

class StringPatcher
{
	public static function patch(file:String):String
	{
		file = file.replace("__lua_lib_luautf8_Utf8.len", "#");
		return file;
	}
}
