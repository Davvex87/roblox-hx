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

/**
	Operating System Facilities.
**/
@:native("os")
extern class Os {
	/**
		Returns an approximation of the amount in seconds of CPU time used by the
		program.
	**/
	static function clock():Float;

	@:overload(function(format:String, time:Time):DateType {})
	@:overload(function(format:String):DateType {})
	static function date():DateType;

	/**
		Returns the number of seconds from time `t1` to time `t2`.
		In POSIX, Windows, and some other systems, this value is exactly `t2-t1`.
	**/
	static function difftime(t2:Time, t1:Time):Float;

	/**
		Returns the current time when called without arguments, or a time
		representing the date and time specified by the given table.

		The returned value is a number, whose meaning depends on your system.
		In POSIX, Windows, and some other systems, this number counts the number
		of seconds since some given start time (the "epoch").
		In other systems, the meaning is not specified, and the number returned
		by time can be used only as an argument to date and difftime.
	**/
	static function time(?arg:TimeParam):Time;
}

/**
	A typedef that matches the date parameter `Os.time()` will accept.
**/
typedef TimeParam = {
	year:Int,
	month:Int,
	day:Int,
	?hour:Int,
	?min:Int,
	?sec:Int,
	?isdst:Bool
}

/**
	A typedef that describes the output of `Os.date()`.
**/
typedef DateType = {
	hour:Int,
	min:Int,
	sec:Int,
	isdst:Bool,
	year:Int,
	month:Int,
	wday:Int,
	yday:Int,
	day:Int,
}