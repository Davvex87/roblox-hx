package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import haxe.extern.EitherType;

@:forward
@:forward.new
@:forwardStatics
@:native("OverlapParams")
extern abstract OverlapParams(OverlapParamsData) {}

@:native("OverlapParams")
private extern class OverlapParamsData
{
	/**
	 * Returns a blank OverlapParams object.
	 */
	public extern function new();

	/**
	 * An array of objects whose descendants is used in filtering candidates.
	 */
	@:native("FilterDescendantsInstances")
	public extern var filterDescendantsInstances:Array<Object>;

	/**
	 * Determines how the OverlapParams.FilterDescendantsInstances list is used.
	 */
	@:native("FilterType")
	public extern var filterType:RaycastFilterType;

	/**
	 * The maximum amount of parts to be returned by the query.
	 */
	@:native("MaxParts")
	public extern var maxParts:Int;

	/**
	 * The collision group used for the operation.
	 */
	@:native("CollisionGroup")
	public extern var collisionGroup:String;

	/**
	 * Determines whether the boundary-querying operation considers a part's BasePart.CanCollide property value over its BasePart CanQuery value.
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
