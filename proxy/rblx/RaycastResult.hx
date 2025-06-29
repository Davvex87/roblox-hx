package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("RaycastResult")
abstract RaycastResult(RaycastResultData) {}

@:native("RaycastResult")
private extern class RaycastResultData
{
	/**
	 * The distance between the ray origin and the intersection point.
	 */
	@:native("Distance")
	public extern var distance:Float;

	/**
	 * The BasePart or Terrain cell that the ray intersected.
	 */
	@:native("Instance")
	public extern var instance:BasePart;

	/**
	 * The Enum.Material at the intersection point.
	 */
	@:native("Material")
	public extern var material:Material;

	/**
	 * The world space point at which the intersection occurred.
	 */
	@:native("Position")
	public extern var position:Vector3;

	/**
	 * The normal vector of the intersected face.
	 */
	@:native("Normal")
	public extern var normal:Vector3;
}
