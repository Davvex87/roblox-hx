package;

import myGame.Test;

class Main
{
	static function main()
	{
		trace("Hello, world!");
		Test.main();

		var ob = new ClientTest("Bob", 12);
		ob.greet();
	}
}
