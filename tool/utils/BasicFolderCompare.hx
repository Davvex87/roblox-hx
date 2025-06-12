package utils;

import sys.io.File;
import sys.FileSystem;

class BasicFolderCompare
{
	public static function foldersDiffer(pathA:String, pathB:String):Bool
	{
		var filesA = getFileMap(pathA);
		var filesB = getFileMap(pathB);

		for (path in filesA.keys())
		{
			if (!filesB.exists(path))
				return true;

			var a = filesA.get(path);
			var b = filesB.get(path);
			if (a.size != b.size)
				return true;
			if (a.hash != b.hash)
				return true;

			filesB.remove(path);
		}

		for (k => v in filesB)
			return true;

		return false;
	}

	static function getFileMap(base:String):Map<String, {size:Int, hash:String}>
	{
		var map = new Map();
		addFilesRecursive(base, "", map);
		return map;
	}

	static function addFilesRecursive(base:String, sub:String, map:Map<String, {size:Int, hash:String}>)
	{
		var fullPath = base + (sub == "" ? "" : "/" + sub);
		for (name in FileSystem.readDirectory(fullPath))
		{
			var relPath = sub == "" ? name : sub + "/" + name;
			var absPath = base + "/" + relPath;
			if (FileSystem.isDirectory(absPath))
			{
				addFilesRecursive(base, relPath, map);
			}
			else
			{
				var size = FileSystem.stat(absPath).size;
				var hash = fastHash(File.getBytes(absPath));
				map.set(relPath, {size: size, hash: hash});
			}
		}
	}

	static function fastHash(bytes:haxe.io.Bytes):String
	{
		var hash = 0x811c9dc5;
		for (i in 0...bytes.length)
		{
			hash ^= bytes.get(i);
			hash *= 0x01000193;
			hash &= 0xffffffff;
		}
		return StringTools.hex(hash, 8);
	}
}
