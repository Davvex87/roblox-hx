package modules;

using StringTools;

class TablePatcher
{
	public static function patch(file:String):String
	{
		file = file.replace("table.create()", "{}");
		file = file.replace("table.getn", "#");
		return file;
	}
}
