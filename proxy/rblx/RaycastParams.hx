package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import haxe.extern.EitherType;

@:forward
@:forward.new
@:forwardStatics
@:native("RaycastParams")
abstract RaycastParams(RaycastParamsData) {}

@:native("RaycastParams")
private extern class RaycastParamsData
{
	/**
	 * Returns a blank RaycastParams.
	 */
	public extern function new();

	/**
	 * An array of objects whose descendants are used in filtering raycasting candidates.
	 */
	@:native("FilterDescendantsInstances")
	public extern var filterDescendantsInstances:Array<Object>;

	/**
	 * Determines how the FilterDescendantsInstances array is used.
	 */
	@:native("FilterType")
	public extern var filterType:RaycastFilterType;

	/**
	 * Determines whether the water material is considered when raycasting against Terrain.
	 */
	@:native("IgnoreWater")
	public extern var ignoreWater:Bool;

	/**
	 * The collision group used for the operation.
	 */
	@:native("CollisionGroup")
	public extern var collisionGroup:String;

	/**
	 * Determines whether the raycast operation considers a part's CanCollide property value over its CanQuery value.
	 */
	@:native("RespectCanCollide")
	public extern var respectCanCollide:Bool;

	/**
	 * When enabled, the query will ignore all part collision properties and perform a brute-force check on every part.
	 */
	@:native("BruteForceAllSlow")
	public extern var bruteForceAllSlow:Bool;

	/**
	 * Adds the instances provided to FilterDescendantsInstances.
	 */
	@:native("AddToFilter")
	public extern function addToFilter(instances:EitherType<Instance, Array<Instance>>):Void;
}
