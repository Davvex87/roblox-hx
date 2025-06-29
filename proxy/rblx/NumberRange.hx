package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("NumberRange")
abstract NumberRange(NumberRangeData) {}

@:native("NumberRange")
private extern class NumberRangeData
{
	/**
	 * Returns a new NumberRange with the minimum and maximum set to the value.
	 */
	@:native("new")
	public static extern function fromValue(value:Float):NumberRange;

	/**
	 * Returns a new NumberRange with the provided minimum and maximum.
	 */
	public extern function new(minimum:Float, maximum:Float);

	/**
	 * The minimum value of the NumberRange.
	 */
	@:native("Min")
	public extern var min:Float;

	/**
	 * The maximum value of the NumberRange.
	 */
	@:native("Max")
	public extern var max:Float;
}
