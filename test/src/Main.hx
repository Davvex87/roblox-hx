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

		var cf = new CFrame();
		trace(cf * CFrame.fromOrientation(0, Math.PI / 2, 0));
		print(CFrame.fromOrientation(0,0,0) * Vector3.one);

		var inst = new CustomInstance();
		trace(inst.getName());
		trace(inst);
	}
}

@:native("CustomInstance")
extern class CustomInstance
{
	@:nativeFunctionCode('Instance.new("CustomInstance")')
	public function new();
	public function getName():String;
}