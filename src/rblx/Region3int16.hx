package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Region3int16")
extern abstract Region3int16(Region3int16Data) {}

@:native("Region3int16")
private extern class Region3int16Data
{
	/**
	 * Returns a new Region3int16 from the provided boundaries.
	 */
	public extern function new(min:Vector3int16, max:Vector3int16);

	/**
	 * The lower bound of the Region3int16.
	 */
	@:native("Min")
	public extern var min:Vector3int16;

	/**
	 * The upper bound of the Region3int16.
	 */
	@:native("Max")
	public extern var max:Vector3int16;
}
