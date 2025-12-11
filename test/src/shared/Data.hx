package shared;

class GameConfig
{
	public static final MAX_PLAYERS = 20;
	public static final SPAWN_POSITION = new Vector3(0, 5, 0);
	public static final GAME_DURATION = 300; // seconds

	public static function getWelcomeMessage():String
	{
		return "Welcome to the game!";
	}
}
