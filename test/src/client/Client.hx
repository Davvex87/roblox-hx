package client;

import rblx.instances.Part;

class Client
{
	@:topLevelCall
	public static function main()
	{
		var player = Services.players.localPlayer;
		trace("Hello, " + player.name + "!");

		// Create a part
		var part:Part = new Part();
		part.position = new Vector3(0, 10, 0);
		part.brickColor = BrickColor.red();
		part.parent = workspace;
	}
}
