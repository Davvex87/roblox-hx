package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import lua.Table;

@:forward
@:forward.new
@:forwardStatics
@:native("Axes")
abstract Axes(AxesClass) {}

@:native("Axes")
private extern class AxesClass
{
	/**
	 * Creates a new Axes using list of axes and/or faces. NormalIds (faces) are converted to the corresponding axes.
	 */
	public extern function new(...axes:NormalId);

	/**
	 * Whether the X axis is enabled.
	 */
	@:native("X")
	public extern var x:Bool;

	/**
	 * Whether the Y axis is enabled.
	 */
	@:native("Y")
	public extern var y:Bool;

	/**
	 * Whether the Z axis is enabled.
	 */
	@:native("Z")
	public extern var z:Bool;

	/**
	 * Whether the top face is included.
	 */
	@:native("Top")
	public extern var top:Bool;

	/**
	 * Whether the bottom face is included.
	 */
	@:native("Bottom")
	public extern var bottom:Bool;

	/**
	 * Whether the left face is included.
	 */
	@:native("Left")
	public extern var left:Bool;

	/**
	 * Whether the right face is included.
	 */
	@:native("Right")
	public extern var right:Bool;

	/**
	 * Whether the back face is included.
	 */
	@:native("Back")
	public extern var back:Bool;

	/**
	 * Whether the front face is included.
	 */
	@:native("Front")
	public extern var front:Bool;
}
