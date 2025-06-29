package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("UDim")
abstract UDim(UDimClass)
{
	@:op(a + b)
	public inline function add(b:UDim):UDim
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a - b)
	public inline function sub(b:UDim):UDim
		return untyped __lua__("{0} * {1}", this, b);
}

@:native("UDim")
private extern class UDimClass
{
	/**
	 * Returns a UDim from the given components.
	 */
	public extern function new(Scale:Float, Offset:Int);

	/**
	 * The relative scale component of the UDim.
	 */
	@:native("Scale")
	public extern var scale:Float;

	/**
	 * The absolute offset component of the UDim.
	 */
	@:native("Offset")
	public extern var offset:Int;
}
