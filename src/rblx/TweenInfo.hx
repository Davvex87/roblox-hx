package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("TweenInfo")
extern abstract TweenInfo(TweenInfoData) {}

@:native("TweenInfo")
private extern class TweenInfoData
{
	/**
	 * Creates a new TweenInfo from the provided parameters.
	 */
	public extern function new(time:Float, easingStyle:EasingStyle, easingDirection:EasingDirection, repeatCount:Int, reverses:Bool, delayTime:Float);

	/**
	 * The direction in which the tween executes.
	 */
	@:native("EasingDirection")
	public extern var easingDirection:EasingDirection;

	/**
	 * Duration of the tween, in seconds.
	 */
	@:native("Time")
	public extern var time:Float;

	/**
	 * Time of delay until the tween begins, in seconds.
	 */
	@:native("DelayTime")
	public extern var delayTime:Float;

	/**
	 * Number of times the tween repeats.
	 */
	@:native("RepeatCount")
	public extern var repeatCount:Int;

	/**
	 * The style in which the tween executes.
	 */
	@:native("EasingStyle")
	public extern var easingStyle:EasingStyle;

	/**
	 * Whether or not the tween interpolates in reverse tween once the initial tween completes.
	 */
	@:native("Reverses")
	public extern var reverses:Bool;
}
