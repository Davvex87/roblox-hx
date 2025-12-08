package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Vector2")
extern abstract Vector2(Vector2Data)
{
	@:op(a + b)
	public inline function add(b:Vector2):Vector2
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:Vector2):Vector2
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:Vector2):Vector2
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function div(b:Vector2):Vector2
		return untyped __lua__("{0} / {1}", this, b);

	@:op(a * b)
	public inline function mulFloat(b:Float):Vector2
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function divFloat(b:Float):Vector2
		return untyped __lua__("{0} / {1}", this, b);
}

@:native("Vector2")
private extern class Vector2Data
{
	/**
	 * Returns a Vector2 from the given x and y components.
	 */
	public extern function new(x:Float, y:Float);

	/**
	 * A Vector2 with a magnitude of zero.
	 */
	public static extern var zero:Vector2;

	/**
	 * A Vector2 with a value of 1 on every axis.
	 */
	public static extern var one:Vector2;

	/**
	 * A Vector2 with a value of 1 on the X axis.
	 */
	public static extern var xAxis:Vector2;

	/**
	 * A Vector2 with a value of 1 on the y axis.
	 */
	public static extern var yAxis:Vector2;

	/**
	 * The x-coordinate of the Vector2.
	 */
	@:native("X")
	public extern var x:Float;

	/**
	 * The y-coordinate of the Vector2.
	 */
	@:native("Y")
	public extern var y:Float;

	/**
	 * The length of the Vector2.
	 */
	@:native("Magnitude")
	public extern var magnitude:Float;

	/**
	 * A normalized copy of the Vector2.
	 */
	@:native("Unit")
	public extern var unit:Vector2;

	/**
	 * Returns the cross product of the two vectors.
	 */
	@:native("Cross")
	public extern function cross(other:Vector2):Float;

	/**
	 * Returns a new vector from the absolute values of the original's components.
	 */
	@:native("Abs")
	public extern function abs():Vector2;

	/**
	 * Returns a new vector from the ceiling of the original's components.
	 */
	@:native("Ceil")
	public extern function ceil():Vector2;

	/**
	 * Returns a new vector from the floor of the original's components.
	 */
	@:native("Floor")
	public extern function floor():Vector2;

	/**
	 * Returns a new vector from the sign (-1, 0, or 1) of the original's components.
	 */
	@:native("Sign")
	public extern function sign():Vector2;

	/**
	 * Returns the angle in radians between the two vectors.
	 */
	@:native("Angle")
	public extern function angle(other:Vector2, isSigned:Bool):Float;

	/**
	 * Returns a scalar dot product of the two vectors.
	 */
	@:native("Dot")
	public extern function dot(v:Vector2):Float;

	/**
	 * Returns a Vector2 linearly interpolated between this Vector2 and the given goal by the given alpha.
	 */
	@:native("Lerp")
	public extern function lerp(v:Vector2, alpha:Float):Vector2;

	/**
	 * Returns a Vector2 with each component as the highest among the respective components of the provided Vector2 objects.
	 */
	@:native("Max")
	public extern function max(...others:Vector2):Vector2;

	/**
	 * Returns a Vector2 with each component as the lowest among the respective components of the provided Vector2 objects.
	 */
	@:native("Min")
	public extern function min(...others:Vector2):Vector2;

	/**
	 * Returns true if the X and Y components of the other Vector2 are within epsilon units of each corresponding component of this Vector2.
	 */
	@:native("FuzzyEq")
	public extern function fuzzyEq(other:Vector2, epsilon:Float):Bool;
}
