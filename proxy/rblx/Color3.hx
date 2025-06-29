package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import rblx.BrickColor;

@:forward
@:forward.new
@:forwardStatics
@:native("Color3")
@:privateAccess
abstract Color3(Color3Class)
{
	@:from
	public static inline function fromInt(value:Int):Color3
		return Color3Class.fromRGB((value >> 16) & 0xFF, (value >> 8) & 0xFF, value & 0xFF);

	@:to
	public inline function toInt():Int
	{
		return (Math.round(this.r * 255) << 16) | (Math.round(this.g * 255) << 8) | Math.round(this.b * 255);
	}

	@:from
	public static inline function fromBrickColor(color:BrickColor):Color3
		return color.color;

	@:to
	public inline function toBrickColor():BrickColor
		return BrickColor.fromColor3(cast this);
}

@:native("Color3")
private extern class Color3Class
{
	/**
	 * Returns a Color3 from given components within the range of 0 to 255.
	 */
	@:native("new")
	public static extern function fromRGB(red:Int, green:Int, blue:Int):Color3;

	/**
	 * Returns a Color3 from the given hue, saturation, and value components.
	 */
	@:native("new")
	public static extern function fromHSV(hue:Float, saturation:Float, value:Float):Color3;

	/**
	 * Returns a Color3 from a given hex value.
	 */
	@:native("new")
	public static extern function fromHex(hex:String):Color3;

	/**
	 * Returns a Color3 with the given red, green, and blue values.
	 */
	public extern function new(red:Float, green:Float, blue:Float);

	/**
	 * The red value of the color.
	 */
	@:native("R")
	public extern var r:Float;

	/**
	 * The green value of the color.
	 */
	@:native("G")
	public extern var g:Float;

	/**
	 * The blue value of the color.
	 */
	@:native("B")
	public extern var b:Float;

	/**
	 * Returns a Color3 interpolated between two colors.
	 */
	@:native("Lerp")
	public extern function lerp(color:Color3, alpha:Float):Color3;

	/**
	 * Returns the hue, saturation, and value of a Color3.
	 */
	@:native("ToHSV")
	public extern function toHSV():Color3ToHSVResult;

	/**
	 * Returns the hex code of a Color3.
	 */
	@:native("ToHex")
	public extern function toHex():String;
}

@:multiReturn
extern class Color3ToHSVResult
{
	var hue:Float;
	var saturation:Float;
	var value:Float;
}
