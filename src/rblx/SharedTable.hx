package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;
import lua.Table;
import haxe.extern.EitherType;

@:forward
@:forward.new
@:forwardStatics
@:native("SharedTable")
extern abstract SharedTable(SharedTableData)
{
	// TODO: array access to class
}

@:native("SharedTable")
private extern class SharedTableData
{
	/**
	 * Returns a new, empty SharedTable.
	 */
	public extern function new();

	/**
	 * Returns a new SharedTable containing elements equivalent to those in the provided Luau table.
	 * @param t 
	 * @return SharedTable
	 */
	@:native("new")
	public static extern function fromTable(t:AnyTable):SharedTable;

	/**
	 * Removes all of the elements from the SharedTable.
	 * @param st 
	 */
	public extern function clear(st:SharedTable):Void;

	/**
	 * Creates and returns a clone of the provided SharedTable.
	 * @param st 
	 * @param deep 
	 * @return SharedTable
	 */
	public extern function clone(st:SharedTable, ?deep:Bool):SharedTable;

	/**
	 * Creates and returns a frozen (read-only) clone of the provided SharedTable.
	 * @param st 
	 * @param deep 
	 * @return SharedTable
	 */
	public extern function cloneAndFreeze(st:SharedTable, ?deep:Bool):SharedTable;

	/**
	 * Adds delta to the value with the provided key and returns the original value.
	 * @param st 
	 * @param key 
	 * @param delta 
	 * @return Int
	 */
	public extern function increment(st:SharedTable, key:EitherType<String, Float>, delta:Float):Int;

	/**
	 * Returns true if the SharedTable is frozen (read-only).
	 * @param st 
	 * @return Bool
	 */
	public extern function isFrozen(st:SharedTable):Bool;

	/**
	 * Returns the number of elements stored in the SharedTable.
	 * @param st 
	 * @return Int
	 */
	public extern function size(st:SharedTable):Int;

	/**
	 * Updates the value with the provided key via the provided update function.
	 * @param st 
	 * @param key 
	 * @param f 
	 */
	public extern function update(st:SharedTable, key:EitherType<String, Float>, f:(v:EitherType<String, Float>) -> EitherType<String, Float>):Void;
}
