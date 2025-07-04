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

package lua;

import lua.Lua;
import haxe.SysTools;

@:dox(hide)
class Boot {
	// Used temporarily for bind()
	static var _:Dynamic;
	static var _fid = 0;

	static var Max_Int32 = 2147483647;
	static var Min_Int32 = -2147483648;

	// A max stack size to respect for unpack operations
	public static var MAXSTACKSIZE(default, null) = 1000;

	public static var platformBigEndian = false;

	static var hiddenFields:Table<String, Bool> = untyped __lua__("{__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true}");

	static function __unhtml(s:String)
		return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");

	/**
		Indicates if the given object is a class.
	**/
	static inline public function isClass(o:Dynamic):Bool {
		if (type(o) != "table")
			return false;
		else
			return untyped __define_feature__("lua.Boot.isClass", o.__name__);
	}

	/**
		Indicates if the given object is a enum.
	**/
	static inline public function isEnum(e:Dynamic):Bool {
		if (type(e) != "table")
			return false;
		else
			return untyped __define_feature__("lua.Boot.isEnum", e.__ename__);
	}

	/**
		Returns the class of a given object, and defines the getClass feature
		for the given class.
	**/
	static inline public function getClass(o:Dynamic):Class<Dynamic> {
		if (Std.isOfType(o, Array))
			return Array;
		else if (Std.isOfType(o, String))
			return String;
		else {
			var cl = untyped __define_feature__("lua.Boot.getClass", o.__class__);
			if (cl != null)
				return cl;
			else
				return null;
		}
	}

	/**
		Indicates if the given object is an instance of the given Type
	**/
	@:ifFeature("typed_catch")
	private static function __instanceof(o:Dynamic, cl:Dynamic) {
		if (cl == null)
			return false;

		switch (cl) {
			case Int:
				return (type(o) == "number" && clampInt32(o) == o);
			case Float:
				return type(o) == "number";
			case Bool:
				return type(o) == "boolean";
			case String:
				return type(o) == "string";
			case Thread:
				return type(o) == "thread";
			case UserData:
				return type(o) == "userdata";
			case Array:
				return isArray(o);
			case Table:
				return type(o) == "table";
			case Dynamic:
				return o != null;
			default:
				{
					if (o != null && type(o) == "table" && type(cl) == "table") {
						if (extendsOrImplements(getClass(o), cl))
							return true;
						// We've exhausted standard inheritance checks.  Check for simple Class/Enum eqauality
						// Also, do not use isClass/isEnum here, perform raw checks
						untyped __feature__("Class.*", if (cl == Class && o.__name__ != null) return true);
						untyped __feature__("Enum.*", if (cl == Enum && o.__ename__ != null) return true);
						// last chance, is it an enum instance?
						return o.__enum__ == cl;
					} else {
						return false;
					}
				}
		}
	}

	static function isArray(o:Dynamic):Bool {
		return type(o) == "table"
			&& untyped o.__enum__ == null && getmetatable(o) != null && getmetatable(o).__index == untyped Array.prototype;
	}

	/**
		Indicates if the given object inherits from the given class
	**/
	static function inheritsFrom(o:Dynamic, cl:Class<Dynamic>):Bool {
		while (getmetatable(o) != null && getmetatable(o).__index != null) {
			if (getmetatable(o).__index == untyped cl.prototype)
				return true;
			o = getmetatable(o).__index;
		}
		return false;
	}

	@:ifFeature("typed_cast")
	private static function __cast(o:Dynamic, t:Dynamic) {
		if (o == null || __instanceof(o, t))
			return o;
		else
			throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
	}


	/**
		Define an array from the given table
	**/
	public inline static function defArray<T>(tab:Table<Int, T>, ?length:Int):Array<T> {
		if (length == null) {
			length = Table.maxn(tab);
			if (length > 0) {
				var head = tab[1];
				Table.remove(tab, 1);
				tab[0] = head;
				return untyped _hx_tab_array(tab, length);
			} else {
				return [];
			}
		} else {
			return untyped _hx_tab_array(tab, length);
		}
	}

	/**
		Create a Haxe object from the given table structure
	**/
	public inline static function tableToObject<T>(t:Table<String, T>):Dynamic<T> {
		return untyped _hx_o(t);
	}

	/**
		Get Date object as string representation
	**/
	public static function dateStr(date:std.Date):String {
		var m = date.getMonth() + 1;
		var d = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (if (m < 10) "0" + m else "" + m) + "-" + (if (d < 10) "0" + d else "" + d) + " "
			+ (if (h < 10) "0" + h else "" + h) + ":" + (if (mi < 10) "0" + mi else "" + mi) + ":" + (if (s < 10) "0" + s else "" + s);
	}

	/**
		A 32 bit clamp function for numbers
	**/
	public inline static function clampInt32(x:Float) {
        return untyped _hx_bit_clamp(x);
	}

	/**
		Create a standard date object from a lua string representation
	**/
	public static function strDate(s:String):std.Date {
		switch (s.length) {
			case 8: // hh:mm:ss
				var k = s.split(":");
				return std.Date.fromTime(tonumber(k[0]) * 3600000. + tonumber(k[1]) * 60000. + tonumber(k[2]) * 1000.);
			case 10: // YYYY-MM-DD
				var k = s.split("-");
				return new std.Date(tonumber(k[0]), tonumber(k[1]) - 1, tonumber(k[2]), 0, 0, 0);
			case 19: // YYYY-MM-DD hh:mm:ss
				var k = s.split(" ");
				var y = k[0].split("-");
				var t = k[1].split(":");
				return new std.Date(tonumber(y[0]), tonumber(y[1]) - 1, tonumber(y[2]), tonumber(t[0]), tonumber(t[1]), tonumber(t[2]));
			default:
				throw "Invalid date format : " + s;
		}
	}

	/**
		Helper method to determine if class cl1 extends, implements, or otherwise equals cl2
	**/
	public static function extendsOrImplements(cl1:Class<Dynamic>, cl2:Class<Dynamic>):Bool {
		if (cl1 == null || cl2 == null)
			return false;
		else if (cl1 == cl2)
			return true;
		else if (untyped cl1.__interfaces__ != null) {
			var intf = untyped cl1.__interfaces__;
			for (i in 1...(Table.maxn(intf) + 1)) {
				// check each interface, including extended interfaces
				if (extendsOrImplements(intf[i], cl2))
					return true;
			}
		}
		// check standard inheritance
		return extendsOrImplements(untyped cl1.__super__, cl2);
	}

	@:deprecated
	public static function shellEscapeCmd(cmd:String, ?args:Array<String>) {
		return cmd;
	}

	
	@:deprecated
	public static function tempFile():String
		return "";

	@:deprecated
	static var os_patterns(get,default):Map<String,Array<String>> = [];
	@:deprecated
	static function get_os_patterns():Map<String,Array<String>> {
		return os_patterns;
	}

	@:deprecated
	public static function systemName():String
		return null;
}
