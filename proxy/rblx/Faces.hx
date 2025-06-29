package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Faces")
abstract Faces(FacesData) {}

@:native("Faces")
private extern class FacesData
{
	/**
	 * Returns a Faces with the corresponding face of each passed Enum.NormalId as true.
	 */
	public extern function new(...normalIds:NormalId);

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
