package myGame;

import myGame.pkg.OtherClass;

var myVar = OtherClass.e;

class Test
{
	public static function main()
	{
		trace("Hello, world!");

		var a:Int = 42;
		var b:Float = 3.14;
		var c:String = "Test";
		var d:Bool = true;

		trace("Int: " + a);
		trace("Float: " + b);
		trace("String: " + c);
		trace("Bool: " + d);

		var result = add(5, 10);
		trace("5 + 10 = " + result);

		var arr = [1, 2, 3];
		for (i in arr)
		{
			trace("Item: " + i);
		}

		bruhh();

		var oc = new OtherClass("Compiler", 21);

		trace(oc.greet());
		trace(oc.double());
		trace(OtherClass.staticMethod());
	}

	static function add(x:Int, y:Int):Int
		return x + y;
}
