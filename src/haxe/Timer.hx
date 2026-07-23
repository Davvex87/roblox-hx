package haxe;

class Timer
{
	private var event:MainLoop.MainEvent;

	public function new(time_ms:Int)
	{
		var dt = time_ms / 1000;
		event = MainLoop.add(function()
		{
			@:privateAccess event.nextRun += dt;
			run();
		});
		event.delay(dt);
	}

	public function stop()
	{
		if (event != null)
		{
			event.stop();
			event = null;
		}
	}

	public dynamic function run() {}

	public static function delay(f:Void->Void, time_ms:Int)
	{
		var t = new Timer(time_ms);
		t.run = function()
		{
			t.stop();
			f();
		};
		return t;
	}

	public static function measure<T>(f:Void->T, ?pos:PosInfos):T
	{
		var t0 = stamp();
		var r = f();
		Log.trace((stamp() - t0) + "s", pos);
		return r;
	}

	public static inline function stamp():Float
	{
		return untyped __lua__("tick()");
	}
}
