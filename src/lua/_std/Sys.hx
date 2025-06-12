/*
 * Copyright (C)2005-2019 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

import lua.Boot;
import lua.Io;
import lua.Lua;
import sys.io.FileInput;
import sys.io.FileOutput;

@:coreApi
class Sys {
	static var _system_name:String;

	public static inline function print(v:Dynamic):Void {
		return lua.Lib.print(v);
	}

	public static inline function println(v:Dynamic):Void {
		return lua.Lib.println(v);
	}

	public inline static function args():Array<String>
		return [];

	@:deprecated
	public static function command(cmd:String, ?args:Array<String>):Int
		return -1;

	public inline static function cpuTime():Float
		return lua.Os.clock();

	@:deprecated
	public inline static function exit(code:Int):Void {}

	@:deprecated
	public inline static function getChar(echo:Bool):Int 
		return 0;

	@:deprecated
	static function getSystemName():String
		return lua.Boot.systemName();

	@:deprecated
	public static function systemName():String {
		if (_system_name == null)
			_system_name = getSystemName();
		return _system_name;
	}

	@:deprecated
	public static function environment():Map<String, String> {return [];}

	@:deprecated("Use programPath instead") public static function executablePath():String
		return "";

	@:deprecated
	public inline static function programPath():String
		return "";
	@:deprecated
	public inline static function getCwd():String
		return "";

	@:deprecated
	public inline static function setCwd(s:String):Void {}

	@:deprecated
	public inline static function getEnv(s:String):String
		return "";

	@:deprecated
	public inline static function putEnv(s:String, v:Null<String>):Void {}

	@:deprecated
	public inline static function setTimeLocale(loc:String):Bool
		return false;

	//TODO: this
	public static function sleep(seconds:Float):Void {}

	public inline static function stderr():haxe.io.Output
		return @:privateAccess new FileOutput(Io.stderr);

	public inline static function stdin():haxe.io.Input
		return @:privateAccess new FileInput(Io.stdin);

	public inline static function stdout():haxe.io.Output
		return @:privateAccess new FileOutput(Io.stdout);

	public static function time():Float
		return Os.clock();
}
