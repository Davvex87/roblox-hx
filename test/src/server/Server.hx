package server;

import rblx.instances.Tool;
import rblx.instances.Player;

class Server
{
	@:topLevelCall
	public static function main()
	{
		Services.players.playerAdded.connect(Server.onPlayerAdded);
	}

	private static function onPlayerAdded(player:Player):Void
	{
		trace("Player joined: " + player.name);

		// Give player a starting tool
		var tool:Tool = new Tool();
		tool.name = "Sword";
		tool.parent = player.findFirstChildWhichIsA("Backpack");
	}
}
