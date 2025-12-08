package rblx;

import haxe.extern.EitherType;
import haxe.Constraints.Function;

@:native("task")
extern class Task
{
	static function spawn(functionOrThread:EitherType<Function, Thread>, ...args:Dynamic):Thread;
	static function defer(functionOrThread:EitherType<Function, Thread>, ...args:Dynamic):Thread;
	static function delay(duration:Float, functionOrThread:EitherType<Function, Thread>, ...args:Dynamic):Thread;
	static function desynchronize():Void;
	static function synchronize():Void;
	static function wait(duration:Float):Float;
	static function cancel(thread:Thread):Void;
}
