package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

/**
 * The ``Vector3`` data type represents a vector in 3D space, typically used as a point in 3D space or the dimensions of a rectangular prism.
 * ``Vector3`` supports basic component-based arithmetic operations (sum, difference, product, and quotient) and these operations can be applied on the left or right hand side to either another ``Vector3`` or a number.
 * It also features methods for common vector operations, such as ``Cross()`` and ``Dot()``.
 * 
 * Alternatively to ``Vector3``, consider using the methods and properties of the ``vector`` library.
 * 
 * Some example usages of ``Vector3`` are the ``Position``, ``Rotation``, and ``Size`` of parts, for example:
 * 
 * ```haxe
 * var workspace = Game.getService("Workspace");
 * 
 * var part = workspace.findFIrstChild("Part");
 * part.position = part.position + new Vector3(5, 2, 10) // Move part by (5, 2, 10);
 * ```
 * ``Vector3`` is also commonly used when constructing more complex 3D data types such as ``CFrame``. Many of these data types' methods will use a ``Vector3`` within their parameters, such as ``CFrame.pointToObjectSpace()``.
 * 
 * [Open Documentation](https://https://create.roblox.com/docs/reference/engine/datatypes/Vector3)
 */
@:forward
@:forward.new
@:forwardStatics
@:native("Vector3")
extern abstract Vector3(Vector3Class)
{
	@:op(a + b)
	public inline function add(b:Vector3):Vector3
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function sub(b:Vector3):Vector3
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:Vector3):Vector3
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function div(b:Vector3):Vector3
		return untyped __lua__("{0} / {1}", this, b);

	@:op(a * b)
	public inline function mulFloat(b:Float):Vector3
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a / b)
	public inline function divFloat(b:Float):Vector3
		return untyped __lua__("{0} / {1}", this, b);
}

@:native("Vector3")
private extern class Vector3Class
{
	/**
	 * A Vector3 with a magnitude of zero.
	 */
	public static extern var zero:Vector3;

	/**
	 * A Vector3 with a value of 1 on every axis.
	 */
	public static extern var one:Vector3;

	/**
	 * A Vector3 with a value of 1 on the X axis.
	 */
	public static extern var xAxis:Vector3;

	/**
	 * A Vector3 with a value of 1 on the Y axis.
	 */
	public static extern var yAxis:Vector3;

	/**
	 * A Vector3 with a value of 1 on the Z axis.
	 */
	public static extern var zAxis:Vector3;

	/**
	 * The x-coordinate of the Vector3.
	 */
	@:native("X")
	public extern var x:Float;

	/**
	 * The y-coordinate of the Vector3.
	 */
	@:native("Y")
	public extern var y:Float;

	/**
	 * The z-coordinate of the Vector3.
	 */
	@:native("Z")
	public extern var z:Float;

	/**
	 * The length of the Vector3.
	 */
	@:native("Magnitude")
	public extern var magnitude:Float;

	/**
	 * A normalized copy of the Vector3 - one that has the same direction as the original but a magnitude of 1.
	 */
	@:native("Unit")
	public extern var unit:Vector3;

	/**
	 * Returns a new Vector3 using the given x, y, and z components.
	 */
	public extern function new(?x:Float, ?y:Float, ?z:Float);

	/**
	 * Returns a new vector from the absolute values of the original's components.
	 */
	@:native("Abs")
	public extern function abs():Vector3;

	/**
	 * Returns a new vector from the ceiling of the original's components.
	 */
	@:native("Ceil")
	public extern function ceil():Vector3;

	/**
	 * Returns a new vector from the floor of the original's components.
	 */
	@:native("Floor")
	public extern function floor():Vector3;

	/**
	 * Returns a new vector from the sign (-1, 0, or 1) of the original's components.
	 */
	@:native("Sign")
	public extern function sign():Vector3;

	/**
	 * Returns the cross product of the two vectors.
	 */
	@:native("Cross")
	public extern function cross(other:Vector3):Vector3;

	/**
	 * Returns the angle in radians between the two vectors. If you provide an axis, it determines the sign of the angle.
	 */
	@:native("Angle")
	public extern function angle(other:Vector3, axis:Vector3):Float;

	/**
	 * Returns a scalar dot product of the two vectors.
	 */
	@:native("Dot")
	public extern function dot(other:Vector3):Float;

	/**
	 * Returns true if the difference between the squared magnitude of the two vectors is within epsilon. epsilon is scaled relative to the magnitude, rather than an absolute epsilon.
	 */
	@:native("FuzzyEq")
	public extern function fuzzyEq(other:Vector3, epsilon:Float):Bool;

	/**
	 * Returns a Vector3 linearly interpolated between this Vector3 and the given goal by the given alpha.
	 */
	@:native("Lerp")
	public extern function lerp(goal:Vector3, alpha:Float):Vector3;

	/**
	 * Returns a Vector3 with each component as the highest among the respective components of both provided Vector3 objects.
	 */
	@:native("Max")
	public extern function max(vector:Vector3):Vector3;

	/**
	 * Returns a Vector3 with each component as the lowest among the respective components of both provided Vector3 objects.
	 */
	@:native("Min")
	public extern function min(vector:Vector3):Vector3;
}
