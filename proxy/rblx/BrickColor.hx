package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import rblx.Color3;

@:forward
@:forward.new
@:forwardStatics
@:native("BrickColor")
abstract BrickColor(BrickColorClass)
{
	@:from
	public static inline function fromInt(value:Int):BrickColor
		return BrickColorClass.fromValue(value);

	@:to
	public inline function toInt():Int
	{
		return (Math.round(this.r * 255) << 16) | (Math.round(this.g * 255) << 8) | Math.round(this.b * 255);
	}

	@:from
	public static inline function fromColor3(color:Color3):BrickColor
		return BrickColorClass.fromColor3(color);

	@:to
	public inline function toColor3():Color3
		return this.color;
}

@:native("BrickColor")
private extern class BrickColorClass
{
	/**
	 * Constructs a BrickColor from its palette index.
	 */
	public static extern function palette(paletteValue:Int):BrickColor;

	/**
	 * Returns a random BrickColor.
	 */
	public static extern function random():BrickColor;

	/**
	 * Returns the "White" BrickColor.
	 */
	@:native("White")
	public static extern function white():BrickColor;

	/**
	 * Returns the "Medium stone grey" BrickColor.
	 */
	@:native("Gray")
	public static extern function gray():BrickColor;

	/**
	 * Returns the "Dark stone grey" BrickColor.
	 */
	@:native("DarkGray")
	public static extern function darkGray():BrickColor;

	/**
	 * Returns the "Black" BrickColor.
	 */
	@:native("Black")
	public static extern function black():BrickColor;

	/**
	 * Returns the "Bright Red" BrickColor.
	 */
	@:native("Red")
	public static extern function red():BrickColor;

	/**
	 * Returns the "Bright Yellow" BrickColor.
	 */
	@:native("Yellow")
	public static extern function yellow():BrickColor;

	/**
	 * Returns the "Dark Green" BrickColor.
	 */
	@:native("Green")
	public static extern function green():BrickColor;

	/**
	 * Returns the "Bright Blue" BrickColor.
	 */
	@:native("Blue")
	public static extern function blue():BrickColor;

	/**
	 * Constructs a BrickColor from its name.
	 */
	public extern function new(name:String);

	/**
	 * Constructs a BrickColor from its numerical index.
	 */
	@:native("new")
	public static extern function fromValue(val:Int):BrickColor;

	/**
	 * Constructs the closest BrickColor that can be matched to the specified RGB components, each between 0 and 1.
	 */
	@:native("new")
	public static extern function fromRGB(r:Float, g:Float, b:Float):BrickColor;

	/**
	 * Constructs the closest BrickColor that can be matched to the specified Color3.
	 */
	@:native("new")
	public static extern function fromColor3(color:Color3):BrickColor;

	/**
	 * The unique number that identifies the BrickColor.
	 */
	@:native("Number")
	public extern var number:Float;

	/**
	 * The red component of the BrickColor (between 0 and 1).
	 */
	public extern var r:Float;

	/**
	 * The green component of the BrickColor (between 0 and 1).
	 */
	public extern var g:Float;

	/**
	 * The blue component of the BrickColor (between 0 and 1).
	 */
	public extern var b:Float;

	/**
	 * The name associated with the BrickColor.
	 */
	@:native("Name")
	public extern var name:String;

	/**
	 * The Color3 associated with the BrickColor.
	 */
	@:native("Color")
	public extern var color:Color3;
}
