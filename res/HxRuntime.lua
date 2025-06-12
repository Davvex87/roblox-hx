---@class _G
local _G = _G
local hxrt = {
	_initialized = false;
}
_G._hx_runtime = hxrt

if hxrt._initialized then return _G._hx_runtime end


local STD
if _VERSION == "Luau" then
	STD = require("@self/Std")
else
	STD = require("Std")
end

local _hx_hidden, _hx_array_mt, _hx_is_array, _hx_tab_array, _hx_print_class, _hx_print_enum, _hx_tostring, _hx_obj_newindex, _hx_obj_mt, _hx_a, _hx_e, _hx_o, _hx_new, _hx_field_arr, _hxClasses, _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw, _hx_pcall_default, _hx_pcall_break, _hx_handle_error, _hx_static_init,
	Int, Dynamic, Float, Bool, Class, Enum,
	Array, Date, EReg, _, IntIterator, Lambda, Math, Reflect, String, Std, StringBuf, _, StringTools, ValueType, Type
	= table.unpack(STD)

hxrt._hx_hidden = _hx_hidden
hxrt._hx_array_mt = _hx_array_mt
hxrt._hx_is_array = _hx_is_array
hxrt._hx_tab_array = _hx_tab_array
hxrt._hx_print_class = _hx_print_class
hxrt._hx_print_enum = _hx_print_enum
hxrt._hx_tostring = _hx_tostring
hxrt._hx_obj_newindex = _hx_obj_newindex
hxrt._hx_obj_mt = _hx_obj_mt
hxrt._hx_a = _hx_a
hxrt._hx_e = _hx_e
hxrt._hx_o = _hx_o
hxrt._hx_new = _hx_new
hxrt._hx_field_arr = _hx_field_arr

hxrt._hx_bind = _hx_bind
hxrt._hx_bit = _hx_bit
hxrt._hx_staticToInstance = _hx_staticToInstance
hxrt._hx_funcToField = _hx_funcToField
hxrt._hx_maxn = _hx_maxn
hxrt._hx_print = _hx_print
hxrt._hx_apply_self = _hx_apply_self
hxrt._hx_box_mr = _hx_box_mr
hxrt._hx_bit_clamp = _hx_bit_clamp
hxrt._hx_table = _hx_table
hxrt._hx_bit_raw = _hx_bit_raw
hxrt._hx_pcall_default = _hx_pcall_default
hxrt._hx_pcall_break = _hx_pcall_break

hxrt.Int = Int
hxrt.Dynamic = Dynamic
hxrt.Float = Float
hxrt.Bool = Bool
hxrt.Class = Class
hxrt.Enum = Enum

local _hxStaticInits = {}
hxrt._hxStaticInits = _hxStaticInits

hxrt._hxClasses = _hxClasses
hxrt._hx_handle_error = _hx_handle_error
hxrt._hxModCount = 0


local __Type = _hxClasses["Type"]
function hxrt.import(p)
	return _hxClasses[p]
end

function hxrt._g_glob()
	return _hx_hidden, _hx_array_mt, _hx_is_array, _hx_tab_array, _hx_print_class, _hx_print_enum, _hx_tostring, _hx_obj_newindex, _hx_obj_mt, _hx_a, _hx_e, _hx_o, _hx_new, _hx_field_arr, _hxClasses, _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw, _hx_pcall_default, _hx_pcall_break, _hx_handle_error
end

function hxrt._g_prim()
	return Int, Dynamic, Float, Bool, Class, Enum
end

function hxrt._g_clss()
	return Array, Date, EReg, IntIterator, Lambda, Math, Reflect, String, Std, StringBuf, StringTools, ValueType, Type
end

function hxrt._p_stfn(fn)
	hxrt._hxModCount = hxrt._hxModCount + 1
	table.insert(_hxStaticInits, fn)
end

function hxrt._r_mcnt(n, fn)
	task.spawn(function()
		repeat
			task.wait()
		until hxrt._hxModCount >= n
		fn()
	end)
end

hxrt._initialized = true
return hxrt