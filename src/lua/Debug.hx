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
	Externs for the "debug" class for Haxe lua
**/
import haxe.Constraints.Function;
import lua.Table.AnyTable;

@:native("debug")
extern class Debug {
	/**
		Returns a string of undefined format that describes the current function call stack.
		@param message (optional) is appended at the beginning of the traceback.
		@param level (optional) tells at which level to start the traceback.
			   default is `1`, the function calling traceback.
	**/
	static function traceback(?thread:Thread, ?message:String, ?level:Int):String;

	/**
		Traverses the entire stack of current thread and returns a string containing the call stack of target level details.
		@param level 
		@param options
	**/
	static function info(?level:Int, options:String):AnyTable;

	/**
		Starts profiling for a label.
	**/
	static function profilebegin(label:String):Void;

	/**
		Stops profiling for the most recent label that debug.profilebegin() opened.
	**/
	static function profileend():Void;

	/**
		Returns the name of the current thread's active memory category.
	**/
	static function getmemorycategory():Void;

	/**
		Assigns a custom tag to the current thread's memory category.
	**/
	static function setmemorycategory(tag:String):String;

	/**
		Resets the tag assigned by debug.setmemorycategory() to the automatically assigned value (typically, the script name).
	**/
	static function resetmemorycategory():Void;

	/**
		Displays a table of native code size of individual functions and scripts.
	**/
	static function dumpcodesize():Void;

}