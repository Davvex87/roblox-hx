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

import lua.Table;
import lua.Lib;
// Note - lrexlib gives ascii-based offsets.  Use native string tools.
import lua.NativeStringTools.*;

@:coreApi
class EReg {
	var r:String;
	var global:Bool = false; // whether the regex is in global mode.
	var s:String; // the last matched string
	var m:Table<Int, Int>; // the [start:Int, end:Int, and submatches:String (matched groups)] as a single table.

	public function new(r:String, opt:String):Void {
		this.r = r;
	}

	public function match(s:String):Bool {
		return matchFromByte(s, 1);
	}

	inline function matchFromByte(s:String, offset:Int):Bool {
		if (s == null)
			return false;
		this.m = lua.Table.pack(/*find(r, s, offset)*/);
		this.s = s;
		return m[1] != null;
	}

	public function matched(n:Int):String {
		if (m[1] == null || n < 0)
			throw "EReg::matched";
		else if (n == 0) {
			var k = sub(s, m[1], m[2]).match;
			return k;
		} else if (Std.isOfType(m[3], lua.Table)) {
			var mn = 2 * (n - 1);
			if (Std.isOfType(untyped m[3][mn + 1], Bool))
				return null;
			return sub(s, untyped m[3][mn + 1], untyped m[3][mn + 2]).match;
		} else {
			throw "EReg:matched";
		}
	}

	public function matchedLeft():String {
		if (m[1] == null)
			throw "No string matched";
		return sub(s, 1, m[1] - 1).match;
	}

	public function matchedRight():String {
		if (m[1] == null)
			throw "No string matched";
		return sub(s, m[2] + 1).match;
	}

	public function matchedPos():{pos:Int, len:Int} {
		var left = matchedLeft();
		var matched = matched(0);
		if (m[1] == null)
			throw "No string matched";
		return {
			pos: left.length,
			len: matched.length
		}
	}

	public function matchSub(s:String, pos:Int, len:Int = -1):Bool {
		var ss = s.substr(0, len < 0 ? s.length : pos + len);

		//m = lua.Table.pack(find(r, ss, pos + 1));
		var b = m[1] != null;
		if (b) {
			this.s = s;
		}
		return b;
	}

	public function split(s:String):Array<String> {
		return r.split(s);
		/*
		if (global) {
			return Lib.fillArray(r.split(s));
		} else {
			// we can't use directly Rex.split because it's ignoring the 'g' flag
			var d = "#__delim__#";
			return Lib.fillArray(replace(s, d).split(d));
		}*/
	}

	public function replace(s:String, by:String):String {
		var chunks = by.split("$$");
		chunks = [for (chunk in chunks) gsub(r, "\\$(\\d)", "%%%1", 1)];
		by = chunks.join("$");
		return gsub(r, s, by, global ? null : 1);
	}

	public function map(s:String, f:EReg->String):String {
		var bytesOffset = 1;
		var buf = new StringBuf();
		do {
			if (bytesOffset > len(s)) {
				break;
			} else if (!matchFromByte(s, bytesOffset)) {
				buf.add(sub(s, bytesOffset).match);
				break;
			}
			var pos = m[1];
			var length = m[2] - m[1];
			buf.add(sub(s, bytesOffset, pos - 1).match);
			buf.add(f(this));
			if (length < 0) {
				var charBytes = len(sub(s, pos).match.charAt(0));
				buf.add(sub(s, pos, pos + charBytes - 1).match);
				bytesOffset = pos + charBytes;
			} else {
				bytesOffset = m[2] + 1;
			}
		} while (global);
		if (!global && bytesOffset > 1 && bytesOffset - 1 < len(s))
			buf.add(sub(s, bytesOffset).match);
		return buf.toString();
	}

	function map_old(s:String, f:EReg->String):String {
		var offset = 0;
		var buf = new StringBuf();
		do {
			if (offset >= s.length) {
				break;
			} else if (!matchSub(s, offset)) {
				buf.add(s.substr(offset));
				break;
			}
			var p = matchedPos();

			buf.add(s.substr(offset, p.pos - offset));
			buf.add(f(this));
			if (p.len == 0) {
				buf.add(s.substr(p.pos, 1));
				offset = p.pos + 1;
			} else
				offset = p.pos + p.len;
		} while (global);
		if (!global && offset > 0 && offset < s.length)
			buf.add(s.substr(offset));
		return buf.toString();
	}

	public static function escape(s:String):String {
		return escapeRegExpRe.map(s, function(r) return "\\" + r.matched(0));
	}

	static var escapeRegExpRe = ~/[\[\]{}()*+?.\\\^$|]/g;
}
