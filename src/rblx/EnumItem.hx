package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
extern abstract EnumItem(EnumItemData) {}

private extern class EnumItemData
{
	/**
	 * The name of the EnumItem.
	 */
	@:native("Name")
	public extern var name:String;

	/**
	 * The integral value assigned to the EnumItem.
	 */
	@:native("Value")
	public extern var value:Int;

	/**
	 * A reference to the parent Enum of the EnumItem.
	 */
	@:native("EnumType")
	public extern var enumType:Enum;

	@:native("IsA")
	public extern function isA(name:String):Bool;
}
