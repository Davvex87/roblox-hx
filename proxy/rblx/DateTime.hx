package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("DateTime")
abstract DateTime(DateTimeData) {}

@:native("DateTime")
private extern class DateTimeData
{
	/**
	 * Returns a DateTime representing the current moment in time.
	 */
	public static extern function now():DateTime;

	/**
	 * Returns a DateTime representing the given Unix timestamp.
	 */
	public static extern function fromUnixTimestamp(unixTimestamp:Float):DateTime;

	/**
	 * Returns a DateTime representing the given Unix timestamp in milliseconds.
	 */
	public static extern function fromUnixTimestampMillis(unixTimestampMillis:Float):DateTime;

	/**
	 * Returns a new DateTime using the given units from a UTC time.
	 */
	public static extern function fromUniversalTime(year:Float, month:Float, day:Float, hour:Float, minute:Float, second:Float, millisecond:Float):DateTime;

	/**
	 * Returns a new DateTime using the given units from a local time.
	 */
	public static extern function fromLocalTime(year:Float, month:Float, day:Float, hour:Float, minute:Float, second:Float, millisecond:Float):DateTime;

	/**
	 * Returns a DateTime from an ISO 8601 date-time string (in UTC).
	 */
	public static extern function fromIsoDate(isoDate:String):DateTime;

	/**
	 * The number of seconds between January 1st, 1970 at 00:00 UTC (the Unix epoch).
	 */
	@:native("UnixTimestamp")
	public extern var unixTimestamp:Float;

	/**
	 * The number of milliseconds between January 1st, 1970 at 00:00 UTC (the Unix epoch).
	 */
	@:native("UnixTimestampMillis")
	public extern var unixTimestampMillis:Float;

	/**
	 * Returns the components of the DateTime in UTC.
	 */
	@:native("ToUniversalTime")
	public extern function toUniversalTime():Dictionary;

	/**
	 * Returns the components of the DateTime in local time.
	 */
	@:native("ToLocalTime")
	public extern function toLocalTime():Dictionary;

	/**
	 * Returns the DateTime as an ISO 8601 date-time string.
	 */
	@:native("ToIsoDate")
	public extern function toIsoDate():String;

	/**
	 * Returns the DateTime's value in UTC formatted into a string.
	 */
	@:native("FormatUniversalTime")
	public extern function formatUniversalTime(format:String, locale:String):String;

	/**
	 * Returns the DateTime object's value in local time formatted into a string.
	 */
	@:native("FormatLocalTime")
	public extern function formatLocalTime(format:String, locale:String):String;
}
