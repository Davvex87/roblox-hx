package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("RBXScriptSignal")
extern abstract RBXScriptSignal<T>(RBXScriptSignalData<T>) {}

@:native("RBXScriptSignal")
private extern class RBXScriptSignalData<T>
{
	/**
	 * Connects the given function to the event and returns an RBXScriptConnection that represents it.
	 */
	@:native("Connect")
	public extern function connect(func:T):RBXScriptConnection;

	/**
	 * Connects the given function to the event and returns an RBXScriptConnection that represents it.
	 */
	@:native("ConnectParallel")
	public extern function connectParallel(func:T):RBXScriptConnection;

	/**
	 * Connects the given function to the event (for a single invocation) and returns an RBXScriptConnection that represents it.
	 */
	@:native("Once")
	public extern function once(func:T):RBXScriptConnection;

	/**
	 * Yields the current thread until the signal fires and returns the arguments provided by the signal.
	 */
	@:native("Wait")
	public extern function wait():Variant;
}
