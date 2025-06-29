package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import haxe.Rest;
import rblx.Enum;

@:forward
@:forward.new
@:forwardStatics
@:native("CFrame")
abstract CFrame(CFrameClass)
{
	// TODO: Operators
	@:op(a + b)
	public inline function addVec3(b:Vector3):CFrame
		return untyped __lua__("{0} + {1}", this, b);

	@:op(a - b)
	public inline function subVec3(b:Vector3):CFrame
		return untyped __lua__("{0} - {1}", this, b);

	@:op(a * b)
	public inline function mul(b:CFrame):CFrame
		return untyped __lua__("{0} * {1}", this, b);

	@:op(a * b)
	public inline function mulVec3(b:Vector3):CFrame
		return untyped __lua__("{0} * {1}", this, b);
}

@:native("CFrame")
private extern class CFrameClass
{
	/**
	 * Returns a blank identity CFrame.
	 */
	public extern function new();

	/**
	 * Returns a CFrame with no rotation with the position of the provided Vector3.
	 */
	@:native("new")
	public static extern function fromPosition(pos:Vector3):CFrame;

	/**
	 * Returns a CFrame with the position of the first Vector3 and an orientation pointed toward the second.
	 */
	@:native("new")
	public static extern function fromPositionAndOrientation(pos:Vector3, lookAt:Vector3):CFrame;

	/**
	 * Returns a CFrame with a position comprised of the provided x, y, and z components.
	 */
	@:native("new")
	public static extern function fromXYZ(x:Float, y:Float, z:Float):CFrame;

	/**
	 * Returns a CFrame from position (x, y, z) and quaternion (qX, qY, qZ, qW).
	 */
	@:native("new")
	public static extern function fromPositionAndQuaternion(x:Float, y:Float, z:Float, qX:Float, qY:Float, qZ:Float, qW:Float):CFrame;

	/**
	 * Returns a CFrame from position (x, y, z) with an orientation specified by the rotation matrix.
	 */
	@:native("new")
	public static extern function fromPositionAndMatrix(x:Float, y:Float, z:Float, R00:Float, R01:Float, R02:Float, R10:Float, R11:Float, R12:Float,
		R20:Float, R21:Float, R22:Float):CFrame;

	/**
	 * Returns a CFrame with the position of the first Vector3 and an orientation pointed toward the second.
	 */
	public static extern function lookAt(at:Vector3, lookAt:Vector3, up:Vector3):CFrame;

	/**
	 * Returns a CFrame with the position of the first Vector3 and an orientation directed along the second.
	 */
	public static extern function lookAlong(at:Vector3, direction:Vector3, up:Vector3):CFrame;

	/**
	 * Returns a CFrame representing the orientation needed to rotate from the first Vector3 to the second, with the position set to zero.
	 */
	public static extern function fromRotationBetweenVectors(from:Vector3, to:Vector3):CFrame;

	/**
	 * Returns a rotated CFrame from angles rx, ry, and rz in radians. Rotations are applied in the optional Enum.RotationOrder with a default of XYZ.
	 */
	public static extern function fromEulerAngles(rx:Float, ry:Float, rz:Float, order:RotationOrder):CFrame;

	/**
	 * Returns a rotated CFrame from angles rx, ry, and rz in radians using Enum.RotationOrder.XYZ.
	 */
	public static extern function fromEulerAnglesXYZ(rx:Float, ry:Float, rz:Float):CFrame;

	/**
	 * Returns a rotated CFrame from angles rx, ry, and rz in radians using Enum.RotationOrder.YXZ.
	 */
	public static extern function fromEulerAnglesYXZ(rx:Float, ry:Float, rz:Float):CFrame;

	/**
	 * Equivalent to fromEulerAnglesXYZ().
	 */
	public static extern function Angles(rx:Float, ry:Float, rz:Float):CFrame;

	/**
	 * Equivalent to fromEulerAnglesYXZ().
	 */
	public static extern function fromOrientation(rx:Float, ry:Float, rz:Float):CFrame;

	/**
	 * Returns a rotated CFrame from a unit Vector3 and a rotation in radians.
	 */
	public static extern function fromAxisAngle(v:Vector3, r:Float):CFrame;

	/**
	 * Returns a CFrame from a translation and the columns of a rotation matrix.
	 */
	public static extern function fromMatrix(pos:Vector3, vX:Vector3, vY:Vector3, vZ:Vector3):CFrame;

	/**
	 * An identity CFrame with no translation or rotation.
	 */
	public extern var identity:CFrame;

	/**
	 * The 3D position of the CFrame.
	 */
	public extern var Position:Vector3;

	/**
	 * A copy of the CFrame with no translation.
	 */
	public extern var Rotation:CFrame;

	/**
	 * The X coordinate of the position.
	 */
	public extern var X:Float;

	/**
	 * The Y coordinate of the position.
	 */
	public extern var Y:Float;

	/**
	 * The Z coordinate of the position.
	 */
	public extern var Z:Float;

	/**
	 * The forward-direction component of the CFrame object's orientation, equivalent to the negated form of ZVector.
	 */
	public extern var LookVector:Vector3;

	/**
	 * The right-direction component of the CFrame object's orientation.
	 */
	public extern var RightVector:Vector3;

	/**
	 * The up-direction component of the CFrame object's orientation.
	 */
	public extern var UpVector:Vector3;

	/**
	 * Equivalent to RightVector.
	 */
	public extern var XVector:Vector3;

	/**
	 * Equivalent to UpVector.
	 */
	public extern var YVector:Vector3;

	/**
	 * The Z component of the CFrame object's orientation. Equivalent to the third column of the rotation matrix.
	 */
	public extern var ZVector:Vector3;

	/**
	 * Returns the inverse of the CFrame.
	 */
	public extern function Inverse():CFrame;

	/**
	 * Returns a CFrame interpolated between itself and goal by the fraction alpha.
	 */
	public extern function Lerp(goal:CFrame, alpha:Float):CFrame;

	/**
	 * Returns an orthonormalized copy of the CFrame.
	 */
	public extern function Orthonormalize():CFrame;

	/**
	 * Receives one or more CFrame objects and returns them transformed from object to world space.
	 */
	public extern function ToWorldSpace(...cframes:CFrame):Rest<CFrame>;

	/**
	 * Receives one or more CFrame objects and returns them transformed from world to object space.
	 */
	public extern function ToObjectSpace(...cframes:CFrame):Rest<CFrame>;

	/**
	 * Receives one or more Vector3 objects and returns them transformed from object to world space.
	 */
	public extern function PointToWorldSpace(...vector3s:Vector3):Rest<Vector3>;

	/**
	 * Receives one or more Vector3 objects and returns them transformed from world to object space.
	 */
	public extern function PointToObjectSpace(...vector3s:Vector3):Rest<Vector3>;

	/**
	 * Receives one or more Vector3 objects and returns them rotated from object to world space.
	 */
	public extern function VectorToWorldSpace(...vector3s:Vector3):Rest<Vector3>;

	/**
	 * Receives one or more Vector3 objects and returns them rotated from world to object space.
	 */
	public extern function VectorToObjectSpace(...vector3s:Vector3):Rest<Vector3>;

	/**
	 * Returns the values x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, and R22, where x y z represent the position of the CFrame and R00‑R22 represent its 3×3 rotation matrix.
	 */
	public extern function GetComponents():Rest<Float>;

	/**
	 * Returns approximate angles that could be used to generate the CFrame using the optional Enum.RotationOrder.
	 */
	public extern function ToEulerAngles(order:RotationOrder):CFrameEulerResult;

	/**
	 * Returns approximate angles that could be used to generate the CFrame using Enum.RotationOrder.XYZ.
	 */
	public extern function ToEulerAnglesXYZ():CFrameEulerResult;

	/**
	 * Returns approximate angles that could be used to generate the CFrame using Enum.RotationOrder.YXZ.
	 */
	public extern function ToEulerAnglesYXZ():CFrameEulerResult;

	/**
	 * Equivalent to CFrame:ToEulerAnglesYXZ().
	 */
	public extern function ToOrientation():CFrameEulerResult;

	/**
	 * Returns a tuple of a Vector3 and a number which represent the rotation of the CFrame in the axis-angle representation.
	 */
	public extern function ToAxisAngle():CFrameToAxisAngleResult;

	/**
	 * Equivalent to CFrame:GetComponents().
	 */
	public extern function components():Rest<Float>;

	/**
	 * Returns true if the other CFrame is sufficiently close to this CFrame in both position and rotation.
	 */
	public extern function FuzzyEq(other:CFrame, epsilon:Float):Bool;

	/**
	 * Returns the angle, in radians, between the orientation of one CFrame and another.
	 */
	public extern function AngleBetween(other:CFrame):Float;
}

@:multiReturn
extern class CFrameEulerResult
{
	var x:Float;
	var y:Float;
	var z:Float;
}

@:multiReturn
extern class CFrameToAxisAngleResult
{
	var pos:Vector3;
	var angle:Float;
}
