package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Rect")
extern abstract Rect(RectData) {}

@:native("Rect")
private extern class RectData
{
	/**
	 * Returns a new Rect with zero Vector2 positions.
	 */
	@:native("new")
	public static extern function zero():Rect;

	/**
	 * Returns a new Rect from the given Vector2 positions.
	 */
	@:native("new")
	public static extern function fromVectors(min:Vector2, max:Vector2):Rect;

	/**
	 * Returns a new Rect using the first and last two arguments as coordinates for corners.
	 */
	public extern function new(minX:Float, minY:Float, maxX:Float, maxY:Float);

	/**
	 * The width of the Rect.
	 */
	@:native("Width")
	public extern var width:Float;

	/**
	 * The height of the Rect.
	 */
	@:native("Height")
	public extern var height:Float;

	/**
	 * The coordinates of the top-left corner.
	 */
	@:native("Min")
	public extern var min:Vector2;

	/**
	 * The coordinates of the bottom-right corner.
	 */
	@:native("Max")
	public extern var max:Vector2;
}
