package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import lua.Table;

@:forward
@:forward.new
@:forwardStatics
@:native("Random")
abstract Random(RandomData) {}

@:native("Random")
private extern class RandomData
{
	/**
	 * Returns a new pseudorandom generator using an optional seed.
	 */
	public extern function new(seed:Float);

	/**
	 * Returns a pseudorandom integer uniformly distributed over [min, max].
	 */
	@:native("NextInteger")
	public extern function nextInteger(min:Int, max:Int):Int;

	/**
	 * Returns a pseudorandom number uniformly distributed over [min, max].
	 */
	@:native("NextNumber")
	public extern function nextNumber(?min:Float, ?max:Float):Float;

	/**
	 * Uniformly shuffles a table in-place.
	 */
	@:native("Shuffle")
	public extern function shuffle(tb:AnyTable):Void;

	/**
	 * Returns a unit vector with a pseudorandom direction.
	 */
	@:native("NextUnitVector")
	public extern function nextUnitVector():Vector3;

	/**
	 * Returns a new Random object with the same state as the original.
	 */
	@:native("Clone")
	public extern function clone():Random;
}
