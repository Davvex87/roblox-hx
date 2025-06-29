package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Vector2int16")
abstract Vector2int16(Vecctor2int16Data)
{
	@:op(a + b)
	public inline function add(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function div(b:Vector2int16):Vector2int16
		return untyped __lua__("{0} / {1}", this, b);

	@:op(a * b)
	public inline function mulFloat(b:Float):Vector2int16
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function divFloat(b:Float):Vector2int16
		return untyped __lua__("{0} / {1}", this, b);
}

@:native("Vector2int16")
private extern class Vecctor2int16Data
{
	/**
	 * Returns a Vector2int16 from the given x and y components.
	 */
	public extern function new(x:Int, y:Int);

	/**
	 * The x-coordinate of the Vector2int16.
	 */
	@:native("X")
	public extern var x:Int;

	/**
	 * The y-coordinate of the Vector2int16.
	 */
	@:native("Y")
	public extern var y:Int;
}
