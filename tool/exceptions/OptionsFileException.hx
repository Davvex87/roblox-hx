package exceptions;

import haxe.exceptions.PosException;
import haxe.Exception;
import haxe.PosInfos;

class OptionsFileException extends PosException
{
	public final argument:String;

	public function new(argument:String, ?previous:Exception, ?pos:PosInfos):Void {
		super('Invalid options file input stream: "$argument"', previous, pos);
		this.argument = argument;
	}
}