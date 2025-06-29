package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("ColorSequenceKeypoint")
abstract ColorSequenceKeypoint(ColorSequenceKeypointData) {}

@:native("ColorSequenceKeypoint")
private extern class ColorSequenceKeypointData
{
	/**
	 * Returns a ColorSequenceKeypoint from the given time and color.
	 */
	public extern function new(time:Float, color:Color3);

	/**
	 * The relative time at which the keypoint is located.
	 */
	@:native("Time")
	public extern var time:Float;

	/**
	 * The Color3 value of the keypoint.
	 */
	@:native("Value")
	public extern var value:Color3;
}
