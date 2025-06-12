package commands;

/**
 * Command classes should implement this interface.
 */
interface ICommand
{
	/**
	 * An array containing all possible string combinations which will trigger the command to be ran.
	 */
	public var aliases:Array<String>;

	/**
	 * The description of the command, basically what it does.
	 */
	public var description:String;

	/**
	 * <b>OVERRIDE ME!</b>
	 * The function to run when the command is chosen by the user.
	 * @param arguments 
	 */
	public function run(arguments:Array<String>):Void;
}
