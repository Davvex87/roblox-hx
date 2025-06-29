package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Secret")
abstract Secret(SecretData) {}

@:native("Secret")
private extern class SecretData
{
	/**
	 * Prepends a string to the secret content.
	 */
	@:native("AddPrefix")
	public extern function addPrefix(prefix:String):Secret;

	/**
	 * Appends a string to the secret content.
	 */
	@:native("AddSuffix")
	public extern function addSuffix(suffix:String):Secret;
}
