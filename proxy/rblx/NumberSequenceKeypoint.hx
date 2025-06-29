package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("NumberSequenceKeypoint")
abstract NumberSequenceKeypoint(NumberSequenceKeypointData) {}

@:native("NumberSequenceKeypoint")
private extern class NumberSequenceKeypointData
{
	/**
	 * Returns a keypoint with the specified time, value, and envelope (optional).
	 */
	public extern function new(time:Float, value:Float, ?envelope:Float);

	/**
	 * The amount of variance allowed from the value.
	 */
	@:native("Envelope")
	public extern var envelope:Float;

	/**
	 * The relative time at which the keypoint is positioned.
	 */
	@:native("Time")
	public extern var time:Float;

	/**
	 * The base value of the keypoint.
	 */
	@:native("Value")
	public extern var value:Float;
}
