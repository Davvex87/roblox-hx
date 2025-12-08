package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("ColorSequence")
extern abstract ColorSequence(ColorSequenceData) {}

@:native("ColorSequence")
private extern class ColorSequenceData
{
	/**
	 * Returns a new ColorSequence from an array of ColorSequenceKeypoints.
	 * @param keypoints 
	 * @return ColorSequence
	 */
	public extern function new(keypoints:Array<ColorSequenceKeypoint>);

	/**
	 * Returns a new ColorSequence that is entirely the specified color.
	 * @param c 
	 * @return ColorSequence
	 */
	public static extern function fromColor3(c:Color3):ColorSequence;

	/**
	 * Returns a new ColorSequence with c0 as the start value and c1 as the end value.
	 * @param c0 
	 * @param c1 
	 * @return ColorSequence
	 */
	public static extern function gradient(c0:Color3, c1:Color3):ColorSequence;

	/**
	 * An array of ColorSequenceKeypoint values in ascending order.
	 */
	@:native("Keypoints")
	public extern var keypoints:Array<ColorSequenceKeypoint>;
}
