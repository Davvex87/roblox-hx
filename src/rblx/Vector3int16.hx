package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Vector3int16")
extern abstract Vector3int16(Vecctor3int16Data)
{
	@:op(a + b)
	public inline function add(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function div(b:Vector3int16):Vector3int16
		return untyped __lua__("{0} / {1}", this, b);

	@:op(a * b)
	public inline function mulFloat(b:Float):Vector3int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function divFloat(b:Float):Vector3int16
		return untyped __lua__("{0} / {1}", this, b);
}

@:native("Vector3int16")
private extern class Vecctor3int16Data
{
	/**
	 * Returns a new Vector3int16 from the given x, y, and z components.
	 */
	public extern function new(x:Int, y:Int, z:Int);

	/**
	 * The x-coordinate of the Vector3int16.
	 */
	@:native("X")
	public extern var x:Int;

	/**
	 * The y-coordinate of the Vector3int16.
	 */
	@:native("Y")
	public extern var y:Int;

	/**
	 * The z-coordinate of the Vector3int16.
	 */
	@:native("Z")
	public extern var z:Int;
}
