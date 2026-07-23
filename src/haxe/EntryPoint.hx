package haxe;

import haxe.MainLoop;

/**
	If `haxe.MainLoop` is kept from DCE, then we will insert an `haxe.EntryPoint.run()` call just at then end of `main()`.
	This class can be redefined by custom frameworks so they can handle their own main loop logic.
**/
class EntryPoint
{
	static var pending = new Array<Void->Void>();
	public static var threadCount(default, null):Int = 0;

	/**
		Wakeup a sleeping `run()`
	**/
	public static function wakeup() {}

	public static function runInMainThread(f:Void->Void)
	{
		pending.push(f);
	}

	public static function addThread(f:Void->Void)
	{
		threadCount++;
		pending.push(function()
		{
			f();
			threadCount--;
		});
	}

	static function processEvents():Float
	{
		// flush all pending calls
		while (true)
		{
			var f = pending.shift();
			if (f == null)
				break;
			f();
		}
		var time = @:privateAccess MainLoop.tick();
		if (!MainLoop.hasEvents() && threadCount == 0)
			return -1;
		return time;
	}

	/**
		Start the main loop. Depending on the platform, this can return immediately or will only return when the application exits.
	**/
	@:keep public static function run() @:privateAccess {
		while (true)
		{
			var nextTick = processEvents();
			if (nextTick < 0)
				rblx.Task.wait(0);
			else
				rblx.Task.wait(nextTick);
		}
	}
}
