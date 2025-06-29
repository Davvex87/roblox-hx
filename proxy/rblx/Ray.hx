package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Ray")
abstract Ray(RayData) {}

@:native("Ray")
private extern class RayData
{
	/**
	 * Returns a Ray with the given Origin and Direction.
	 */
	public extern function new(Origin:Vector3, Direction:Vector3);

	/**
	 * The Ray with a normalized direction (the direction has a magnitude of 1).
	 */
	@:native("Unit")
	public extern var unit:Ray;

	/**
	 * The position of the origin.
	 */
	@:native("Origin")
	public extern var origin:Vector3;

	/**
	 * The direction vector of the Ray.
	 */
	@:native("Direction")
	public extern var direction:Vector3;

	/**
	 * Returns a Vector3 projected onto the ray so that it is within the Ray line of sight.
	 */
	@:native("ClosestPoint")
	public extern function closestPoint(point:Vector3):Vector3;

	/**
	 * Returns the distance between the given point and the closest point on the Ray.
	 */
	@:native("Distance")
	public extern function distance(point:Vector3):Float;
}
