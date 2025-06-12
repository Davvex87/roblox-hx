package commands;

/**
 * TODO
 * A command that, when ran, will listen for changes within the file system on the source directory of a project and automatically compiles any changes until the script is stopped.
 * Useful for real time project sync with roblox studio and team create.
 */
class ListenCommand implements ICommand
{
	public var aliases:Array<String> = ["l", "listen"];
	public var description:String = "Listens for changes on the source folder of a roblox-hx project and auto compiles it.";

	public function new() {}

	public function run(arguments:Array<String>)
	{
		// TBD
	}

	public static function listenProject(optsOrFile:Null<String>)
	{
		Sys.println("TBD");
	}
}
