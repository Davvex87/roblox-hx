package exceptions;

import haxe.exceptions.PosException;
import haxe.Exception;
import haxe.PosInfos;

class ProjectCreationException extends PosException
{
	public final argument:String;

	public function new(argument:String, ?previous:Exception, ?pos:PosInfos):Void
	{
		super('Project creation error: "$argument"', previous, pos);
		this.argument = argument;
	}
}
