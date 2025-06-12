package exceptions;

import haxe.exceptions.PosException;
import haxe.Exception;
import haxe.PosInfos;

class CompilationException extends PosException
{
	public final argument:String;

	public function new(argument:String, ?previous:Exception, ?pos:PosInfos):Void {
		super('File compilation error: "$argument"', previous, pos);
		this.argument = argument;
	}
}