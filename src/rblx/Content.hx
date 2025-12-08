package rblx;

import rblx.instances.*;
import rblx.enums.*;
import rblx.services.*;

@:forward
@:forward.new
@:forwardStatics
@:native("Content")
extern abstract Content(ContentData) {}

@:native("Content")
private extern class ContentData
{
	/**
	 * Returns a new Content with an asset URI string value referencing content external to the place.
	 * @param uri 
	 */
	public static extern function fromUri(uri:String):Content;

	/**
	 * Returns a new Content with a strong reference to an Object.
	 */
	public static extern function fromObject(object:Object):Content;

	/**
	 * An empty Content value with Content.SourceType of None.
	 */
	public extern var none:Content;

	/**
	 * The source type of the contained value.
	 */
	@:native("SourceType")
	public extern var sourceType:ContentSourceType;

	/**
	 * A URI string if Content.SourceType is Uri, otherwise nil.
	 */
	@:native("Uri")
	public extern var uri:Null<String>;

	/**
	 * A reference to a non-nil Object if Content.SourceType is Object, otherwise nil.
	 */
	@:native("Object")
	public extern var object:Null<Int>;
}
