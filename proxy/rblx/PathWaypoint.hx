package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("PathWaypoint")
abstract PathWaypoint(PathWaypointData) {}

@:native("PathWaypoint")
private extern class PathWaypointData
{
	/**
	 * Returns a PathWaypoint object from the given Vector3 position, PathWaypointAction action, and optional string label.
	 */
	public extern function new(position:Vector3, action:PathWaypointAction, label:String);

	/**
	 * The action to perform at this waypoint.
	 */
	@:native("Action")
	public extern var action:PathWaypointAction;

	/**
	 * The 3D position of this waypoint.
	 */
	@:native("Position")
	public extern var position:Vector3;

	/**
	 * The name of the navigation area that generates this waypoint.
	 */
	@:native("Label")
	public extern var label:String;
}
