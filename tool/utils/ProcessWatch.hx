package utils;

import sys.io.Process;
import sys.thread.Thread;

using utils.AnsiColors;

class ProcessWatch
{
	public var process:Null<Process>;

	private var stdoutListeners:Array<String->Void> = [];
	private var stderrListeners:Array<String->Void> = [];
	private var stdoutThread:Thread = null;
	private var stderrThread:Thread = null;

	private var cmd:String;
	private var args:Null<Array<String>>;

	public function new(cmd:String, ?args:Array<String>)
	{
		this.cmd = cmd;
		this.args = args;
	}

	public function addOutputListener(f:String->Void):Void
	{
		stdoutListeners.push(f);
	}

	public function addErrorListener(f:String->Void):Void
	{
		stderrListeners.push(f);
	}

	public function addDefaultListeners():Void
	{
		final sysOut = Sys.stdout();
		final sysErr = Sys.stderr();
		addOutputListener(function(line:String)
		{
			sysOut.writeString(line + "\n");
		});
		addErrorListener(function(line:String)
		{
			sysErr.writeString(line.red() + "\n");
		});
	}

	public function start():Void
	{
		if (process != null)
			return;

		this.process = new Process(cmd, args);
		var proc = this.process;

		stdoutThread = Thread.create(function()
		{
			try
			{
				var line:String = null;
				while ((line = proc.stdout.readLine()) != null)
				{
					for (listener in stdoutListeners)
					{
						try
						{
							listener(line);
						}
						catch (_) {}
					}
					if (process == null)
						break;
				}
			}
			catch (_) {}
		});

		stderrThread = Thread.create(function()
		{
			try
			{
				var line:String = null;
				while ((line = proc.stderr.readLine()) != null)
				{
					for (listener in stderrListeners)
					{
						try
						{
							listener(line);
						}
						catch (_) {}
					}
					if (process == null)
						break;
				}
			}
			catch (_) {}
		});
	}

	public function waitExit():Int
	{
		if (process == null)
			start();
		var code:Int = process.exitCode();
		var proc = this.process;
		this.process = null;
		proc.close();
		return code;
	}
}
