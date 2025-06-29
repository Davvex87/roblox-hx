package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Path2DControlPoint")
abstract Path2DControlPoint(Path2DControlPointData) {}

@:native("Path2DControlPoint")
private extern class Path2DControlPointData
{
	/**
	 * Returns an empty Path2DControlPoint.
	 */
	public extern function new();

	/**
	 * Returns a Path2DControlPoint with only the position set.
	 */
	public static extern function fromUDim2(position:UDim2):Path2DControlPointData;

	/**
	 * Returns a Path2DControlPoint with the position, left tangent, and right tangent set.
	 */
	public static extern function fromPositionAndTagents(position:UDim2, leftTangent:UDim2, rightTangent:UDim2):Path2DControlPointData;

	/**
	 * The position of the Path2DControlPoint.
	 */
	@:native("Position")
	public extern var position:UDim2;

	/**
	 * The left tangent of the Path2DControlPoint.
	 */
	@:native("LeftTangent")
	public extern var leftTangent:UDim2;

	/**
	 * The right tangent of the Path2DControlPoint.
	 */
	@:native("RightTangent")
	public extern var rightTangent:UDim2;
}
