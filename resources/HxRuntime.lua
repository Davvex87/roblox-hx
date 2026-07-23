local HxRuntime = {
	modules = {},
	loaded = {},
	classes = {},
	config = nil--CONFIG
}

local _modules = HxRuntime.modules
local _loaded = HxRuntime.loaded
local _classes = HxRuntime.classes
local _config = HxRuntime.config

local IsTable, IsMetatable, IsArray, IsObject, IsClass, IsInstance, IsInterface, IsEnum, IsEnumIndex

local function recurseGetInst(path, root)
    local spl = path:split('.')
    local current = root
    for _, v in spl do
        if current == game then
            current = current:GetService(v)
        else
            current = current:WaitForChild(v)
        end
    end
    return current
end

function HxRuntime.RegisterPackage(pkg, types)
	_modules[pkg] = types

	for _, t in pairs(types) do
		if t.__name__ then
			local p, m = pkg:match("^(.*)%.([^%.]+)$")
			if not p then
				p, m = "", pkg
			end
			if t.__name__ == m then
				_classes[pkg] = t
			else
				_classes[p .. "." .. "_" .. m .. "." .. t.__name__] = t
			end
		end
	end
end

function HxRuntime.ImportPackage(pkgName)
    if _loaded[pkgName] == nil then
        _loaded[pkgName] = true

        local spl = pkgName:split('.')
        local pkg = table.remove(spl, 1)

        local context = _config.packageContexts[pkg or '_']
        local justPush = false
        if context == nil then
            context = _config.packageContexts['_']
        end
        if context:sub(-1) == '#' then
            context = context:sub(1, -2)
            justPush = true
        end

        local path = nil
        if justPush then
            path = _config.contextPaths[context]..'.'..pkgName
        else
            path = _config.contextPaths[context]..'.'..table.concat(spl, '.')
        end

        local inst = path ~= nil and recurseGetInst(path, game)
        if inst == nil then
            error('Could not load module '..pkgName..'. Context: '..context)
        end

        require(inst)
    end
    return _modules[pkgName]
end

function HxRuntime.IsTable(o)
	return type(o) == "table"
end

function HxRuntime.IsMetatable(o)
	return type(o) == "table" and getmetatable(o) ~= nil
end

function HxRuntime.IsArray(o)
	if not IsTable(o) or IsMetatable(o) then
		return false
	end

	for k in pairs(o) do
		if type(k) ~= "number" then
			return false
		end
	end
	
	return true
end

function HxRuntime.IsObject(o)
	return not IsArray(o) and IsTable(o);
end

function HxRuntime.IsClass(o)
	return IsMetatable(o) and o.__index ~= nil and type(o.__name__) == "string"
end

function HxRuntime.IsInstance(o)
	return IsMetatable(o) and IsMetatable(o.__class__);
end

function HxRuntime.IsInterface(o)
	return IsMetatable(o) and  type(o.__interface__) == "table";
end

function HxRuntime.IsEnum(o)
return IsMetatable(o) and type(o.__fenum__) == "table";
end

function HxRuntime.IsEnumIndex(o)
return IsMetatable(o) and IsMetatable(o.__enum__);
end

function HxRuntime.BuildMultiReturn(n, ...)
	local v = {...}
	local t = {}
	for i = 1, #n do
		t[n[i]] = v[i];
	end
	return t;
end

IsTable, IsMetatable, IsArray, IsObject, IsClass, IsInstance, IsInterface, IsEnum, IsEnumIndex = HxRuntime.IsTable, HxRuntime.IsMetatable, HxRuntime.IsArray, HxRuntime.IsObject, HxRuntime.IsClass, HxRuntime.IsInstance, HxRuntime.IsInterface, HxRuntime.IsEnum, HxRuntime.IsEnumIndex

return {HxRuntime.ImportPackage, HxRuntime.RegisterPackage, HxRuntime}
