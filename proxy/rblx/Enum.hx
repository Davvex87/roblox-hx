package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Enum")
abstract Enum(EnumData)
{
	public static function GetEnums():Array<Enum>
		return untyped __lua__("Enum:GetItems()");
}

private extern class EnumData
{
	/**
	 * Returns an array of all EnumItem options available for this enum.
	 */
	@:native("GetEnumItems")
	public extern function getEnumItems():Array<EnumItem>;

	/**
	 * Converts an enum name to an Enum.
	 */
	@:native("FromName")
	public extern function fromName(name:String):Null<Enum>;

	/**
	 * Converts an enum value to an Enum.
	 */
	@:native("FromValue")
	public extern function fromValue(value:Int):Null<Enum>;
}
