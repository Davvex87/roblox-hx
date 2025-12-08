package myGame.pkg;

import Math;

class OtherClass
{
	public var name:String;
	public var value:Int;

	public static var e = 5;

	public function new(name:String, value:Int)
	{
		this.name = name;
		this.value = value;

		trace(OtherClass.e % 7);

		trace("YSESSSS");
	}

	public function greet():String
	{
		var t:Ahh = {
			name: this.name
		}
		return 'Hello, ${t.name}!';
	}

	public function double():Int
	{
		return Std.int(Math.abs(value * TheNumbers.TWO));
	}

	public static function staticMethod():String
	{
		return "I'm a static method!";
	}
}

function bruhh()
{
	var m = Custom("hii");
	trace('${(switch(m)
	{
		case Welcome:
			"Welcome";
		case Bye:
			"BYEBYE";
		case Custom(msg):
			msg;
	})} 4 + 5');
}

typedef Ahh =
{
	name:String
}

enum abstract TheNumbers(Int) from Int to Int
{
	var ONE = 1;
	var TWO = 2;
	var THREE = 3;
	var FOUR = 4;
	var FIVE = 5;
}

enum Msg
{
	Welcome;
	Bye;
	Custom(msg:String);
}
