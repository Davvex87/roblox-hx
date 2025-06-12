local _hx_do_first_1, _hx_do_first_2, _hx_do_first_3, _hx_do_first_4, _hx_do_first_5;

local _hx_bit_raw = bit32
local _hx_bit = _hx_bit_raw

local function _hx_bit_clamp(v)
    if v <= 2147483647 and v >= -2147483648 then
        if v > 0 then return math.floor(v)
        else return math.ceil(v)
        end
    end
    if v > 2251798999999999 then v = v*2 end;
    if (v ~= v or math.abs(v) == math.huge) then return nil end
    return _hx_bit_raw.band(v, 2147483647 ) - math.abs(_hx_bit_raw.band(v, 2147483648))
end

local function _hx_funcToField(f)
  if type(f) == 'function' then
    return function(self,...)
      return f(...)
    end
  else
    return f
  end
end

local function _hx_handle_error(obj)
  local message = tostring(obj)
  if debug and debug.traceback then
    -- level 2 to skip _hx_handle_error
    message = debug.traceback(message, 2)
  end
  return setmetatable({}, { __tostring = function() return message end })
end

local function _hx_staticToInstance(tab)
  return setmetatable({}, {
    __index = function(t,k)
      if type(rawget(tab,k)) == 'function' then
    return function(self,...)
      return rawget(tab,k)(...)
    end
      else
    return rawget(tab,k)
      end
    end
  })
end

local _hx_hidden = {__id__=true, hx__closures=true, super=true, prototype=true, __ifields__=true, __class__=true, __properties__=true, __fields__=true, __name__=true}

local _hx_array_mt = {
    __newindex = function(t,k,v)
        local len = t.length
        t.length =  k >= len and (k + 1) or len
        rawset(t,k,v)
    end
}

local function _hx_is_array(o)
    return type(o) == "table"
        and o.__enum__ == nil
        and getmetatable(o) == _hx_array_mt
end


local _hx_tostring;

local function _hx_tab_array(tab, length)
    tab.length = length
    return setmetatable(tab, _hx_array_mt)
end

local function _hx_print_class(obj, depth)
    local first = true
    local result = ''
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            if first then
                first = false
            else
                result = result .. ', '
            end
            if _hx_hidden[k] == nil then
                result = result .. k .. ':' .. _hx_tostring(v, depth+1)
            end
        end
    end
    return '{ ' .. result .. ' }'
end

local function _hx_print_enum(o, depth)
    if o.length == 2 then
        return o[0]
    else
        local str = o[0] .. "("
        for i = 2, (o.length-1) do
            if i ~= 2 then
                str = str .. "," .. _hx_tostring(o[i], depth+1)
            else
                str = str .. _hx_tostring(o[i], depth+1)
            end
        end
        return str .. ")"
    end
end

_hx_tostring = function(obj, depth)
    if depth == nil then
        depth = 0
    elseif depth > 5 then
        return "<...>"
    end

    local tstr = type(obj)
    if tstr == "string" then return obj
    elseif tstr == "nil" then return "null"
    elseif tstr == "number" then
        if obj == math.huge then return "Infinity"
        elseif obj == -math.huge then return "-Infinity"
        elseif obj == 0 then return "0"
        elseif obj ~= obj then return "NaN"
        else return tostring(obj)
        end
    elseif tstr == "boolean" then return tostring(obj)
    elseif tstr == "userdata" then
        local mt = getmetatable(obj)
        if mt ~= nil and mt.__tostring ~= nil then
            return tostring(obj)
        else
            return "<userdata>"
        end
    elseif tstr == "function" then return "<function>"
    elseif tstr == "thread" then return "<thread>"
    elseif tstr == "table" then
        if obj.__enum__ ~= nil then
            return _hx_print_enum(obj, depth)
        elseif obj.toString ~= nil and not _hx_is_array(obj) then return obj:toString()
        elseif _hx_is_array(obj) then
            if obj.length > 5 then
                return "[...]"
            else
                local str = ""
                for i=0, (obj.length-1) do
                    if i == 0 then
                        str = str .. _hx_tostring(obj[i], depth+1)
                    else
                        str = str .. "," .. _hx_tostring(obj[i], depth+1)
                    end
                end
                return "[" .. str .. "]"
            end
        elseif obj.__class__ ~= nil then
            return _hx_print_class(obj, depth)
        else
            local buffer = {}
            local ref = obj
            if obj.__fields__ ~= nil then
                ref = obj.__fields__
            end
            for k,v in pairs(ref) do
                if _hx_hidden[k] == nil then
                    table.insert(buffer, _hx_tostring(k, depth+1) .. ' : ' .. _hx_tostring(obj[k], depth+1))
                end
            end

            return "{ " .. table.concat(buffer, ", ") .. " }"
        end
    else
        error("Unknown Lua type", 0)
        return ""
    end
end

--[[ -- Haxe does not appear to need to use this _hx_table thing, we can just use the regular lua table class itself
local _hx_table = {}
_hx_table.pack = table.pack
_hx_table.unpack = table.unpack or unpack
_hx_table.maxn = table.maxn
--]]

local function _hx_dyn_add(a,b)
  if (type(a) == 'string' or type(b) == 'string') then
    return _hx_tostring(a, 0).._hx_tostring(b, 0)
  else
    return a + b;
  end;
end;

local String;
local function _hx_wrap_if_string_field(o, fld)
  if type(o) == 'string' then
    if fld == 'length' then
      return string.len(o)
    else
      return String.prototype[fld]
    end
  else
    return o[fld]
  end
end

local function _hx_obj_newindex(t,k,v)
    t.__fields__[k] = true
    rawset(t,k,v)
end

local _hx_obj_mt = {__newindex=_hx_obj_newindex, __tostring=_hx_tostring}

local function _hx_a(...)
  local __fields__ = {};
  local ret = {__fields__ = __fields__};
  local max = select('#',...);
  local tab = {...};
  local cur = 1;
  while cur < max do
    local v = tab[cur];
    __fields__[v] = true;
    ret[v] = tab[cur+1];
    cur = cur + 2
  end
  return setmetatable(ret, _hx_obj_mt)
end

local function _hx_e()
  return setmetatable({__fields__ = {}}, _hx_obj_mt)
end

local function _hx_o(obj)
  return setmetatable(obj, _hx_obj_mt)
end

local function _hx_new(prototype)
  return setmetatable({__fields__ = {}}, {__newindex=_hx_obj_newindex, __index=prototype, __tostring=_hx_tostring})
end

local function _hx_field_arr(obj)
    local res = {}
    local idx = 0
    if obj.__fields__ ~= nil then
        obj = obj.__fields__
    end
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            res[idx] = k
            idx = idx + 1
        end
    end
    return _hx_tab_array(res, idx)
end

local function _hx_apply_self(self, f, ...)
  return self[f](self,...)
end

local function _hx_box_mr(x,nt)
    local res = _hx_o({__fields__={}})
    for i,v in ipairs(nt) do
      res[v] = x[i]
    end
    return res
end

local function _hx_bind(o,m)
  if m == nil then return nil end;
  local f;
  if o._hx__closures == nil then
    rawset(o, '_hx__closures', {});
  else
    f = o._hx__closures[m];
  end
  if (f == nil) then
    f = function(...) return m(o, ...) end;
    o._hx__closures[m] = f;
  end
  return f;
end

math.randomseed(os.time());

local _hxClasses = {}
local Int = _hx_e();
local Dynamic = _hx_e();
local Float = _hx_e();
local Bool = _hx_e();
local Class = _hx_e();
local Enum = _hx_e();