package;

import myGame.pkg.OtherClass.Ahh;

// @:client("bruh", 5, {a: [1, 2, 3], b: {j: new Array<String>()}})
@:client
class ClientTest extends myGame.pkg.OtherClass
{
	public function new(name:String, value:Int)
	{
		super(name + "__", value * 3);
	}

	override public function greet():String
	{
		var t:Ahh = {
			name: "user " + this.name
		}
		return 'Well hi there, ${t.name}!';
	}
}
