package utils;

enum abstract ExitCode(Int) from Int to Int
{
	var UNKNOWN = -1;
	var SUCCESS = 0;

	var HAXE_NOT_PRESENT = 1;
	var HAXE_VER_INCOMP = 2;
	var HAXELIB_NOT_PRESENT = 3;
	var LIBRARY_NOT_PRESENT = 4;
	var LIBRARY_VER_INCOMP = 5;

	var UNKNOWN_COMMAND = 6;
	var INVALID_COMMAND = 7;
}