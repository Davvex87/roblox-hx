package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Region3")
abstract Region3(Region3Data) {}

@:native("Region3")
private extern class Region3Data
{
	/**
	 * Returns a new Region3 using the provided vectors as boundaries.
	 */
	public extern function new(min:Vector3, max:Vector3);

	/**
	 * The center location and rotation of the Region3.
	 */
	@:native("CFrame")
	public extern var cFrame:CFrame;

	/**
	 * The 3D size of the Region3.
	 */
	@:native("Size")
	public extern var size:Vector3;

	/**
	 * Expands the Region3 to fit a grid based on the provided resolution.
	 */
	@:native("ExpandToGrid")
	public extern function expandToGrid(resolution:Int):Region3;
}
