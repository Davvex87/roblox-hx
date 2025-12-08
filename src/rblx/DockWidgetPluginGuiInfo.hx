package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("DockWidgetPluginGuiInfo")
extern abstract DockWidgetPluginGuiInfo(DockWidgetPluginGuiInfoData) {}

@:native("DockWidgetPluginGuiInfo")
private extern class DockWidgetPluginGuiInfoData
{
	/**
	 * Returns a new DockWidgetPluginGuiInfo object.
	 * @param InitialDockState 
	 * @param InitialEnabled 
	 * @param InitialEnabledShouldOverrideRestore 
	 * @param FloatingXSize 
	 * @param FloatingYSize 
	 * @param MinWidth 
	 * @param MinHeight 
	 * @return
	 */
	public extern function new(InitialDockState:InitialDockState, InitialEnabled:Bool, InitialEnabledShouldOverrideRestore:Bool, FloatingXSize:Int,
		FloatingYSize:Int, MinWidth:Int, MinHeight:Int);

	/**
	 * The enabled state of the PluginGui if it does not have a saved state from a previous session.
	 */
	@:native("InitialEnabled")
	public extern var initialEnabled:Bool;

	/**
	 * If true, will override any saved enabled state with the InitialEnabled value.
	 */
	@:native("InitialEnabledShouldOverrideRestore")
	public extern var initialEnabledShouldOverrideRestore:Bool;

	/**
	 * The initial pixel width of the PluginGui when floating.
	 */
	@:native("FloatingXSize")
	public extern var floatingXSize:Int;

	/**
	 * The initial pixel height of the PluginGui when floating.
	 */
	@:native("FloatingYSize")
	public extern var floatingYSize:Int;

	/**
	 * The minimum pixel width of the PluginGui.
	 */
	@:native("MinWidth")
	public extern var minWidth:Int;

	/**
	 * The minimum pixel height of the PluginGui.
	 */
	@:native("MinHeight")
	public extern var minHeight:Int;
}
