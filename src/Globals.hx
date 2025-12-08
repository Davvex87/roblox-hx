package;

import haxe.Constraints.IMap;
import rblx.*;
import rblx.instances.*;
import rblx.services.*;

@:native("")
extern class Globals
{
	/**
		Returns the amount of time in seconds that the current instance of Roblox has been running for.
	**/
	@:native("elapsedTime")
	static function elapsedTime():Float;

	/**
		Refers to the PluginManager, a deprecated singleton that was previously required to create plugins.
	**/
	@:deprecated
	@:native("PluginManager")
	static function pluginManager():PluginManager;

	/**
		Returns the GlobalSettings object, which can be used to access settings objects that configure Roblox Studio's behavior.
	**/
	@:native("settings")
	static function settings():GlobalSettings;

	/**
		Returns the amount of time in seconds since the Unix epoch according to this device's time.
	**/
	@:native("tick")
	static function tick():Float;

	/**
		Returns the amount of time in seconds that has elapsed since the current game instance started running.
	**/
	@:native("time")
	static function time():Float;

	/**
		Returns the type of the given object as a string, also supporting Roblox-specific types (e.g. Vector3).
	**/
	@:native("typeof")
	static function typeof(object:Variant):String;

	/**
		Returns the UserSettings object, which is used to read information from the current user's game menu settings.
	**/
	@:native("UserSettings")
	static function userSettings():UserSettings;

	/**
		Returns the current version of Roblox as a string, which includes the generation, version, patch and commit.
	**/
	@:native("version")
	static function version():String;

	/**
		Behaves similarly to print, except with more distinct formatting (yellow);
		intended for messages which describe potential problems.
	**/
	@:native("warn")
	static function warn(params:Tuple):Void;

	/**
		Contains all Enum objects.
	**/
	@:native("Enum")
	static var Enum:Dynamic;

	/**
		Refers to the DataModel singleton, the root instance of a place's hierarchy.
	**/
	@:native("game")
	static var game:DataModel;

	/**
		Refers to a Plugin singleton when the code is run in the context of a Studio plugin.
	**/
	@:native("plugin")
	static var plugin:Plugin;

	/**
		A table shared between all code running at the same execution context level.
	**/
	@:native("shared")
	static var shared:IMap<Dynamic, Dynamic>;

	/**
		A reference to the LuaSourceContainer object (Script, LocalScript, or ModuleScript) that is executing this code.
	**/
	@:native("script")
	static var script:LuaSourceContainer;

	/**
		A reference to the Workspace service, which contains all of the physical components of a place.
	**/
	@:native("workspace")
	static var workspace:Workspace;
}
