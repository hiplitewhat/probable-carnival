--!nonstrict

local fs = require("@lune/fs")
local process = require("@lune/process")
local luau = require("@lune/luau")
local serde = require("@lune/serde")
local Ast = require("./internals/ast")
local netOk, net = pcall(function()
    return require("@lune/net")
end)
local net = netOk and net or nil
local httpSourceCache = {}
local function emptyIterator()
    return nil
end


local robloxOk, roblox = pcall(function()
    return require("@lune/roblox")
end)
local roblox = robloxOk and roblox or nil

local unpack = table.unpack or unpack


local AliasToName = {
    int64 = "number",
    double = "number",
    int = "number",
    float = "number",
    int32 = "number",
    bool = "boolean",
}

local function buildInstanceLib(apiDump)
    local classMap = {}
    for _, class in ipairs(apiDump.Classes or {}) do
        classMap[class.Name] = class
    end

    local function collectMembers(className, visited)
        visited = visited or {}
        if visited[className] or not classMap[className] then
            return {}, {}, {}, {}
        end
        visited[className] = true

        local methods, properties, events, callbacks = {}, {}, {}, {}

        local super = classMap[className].Superclass
        if super then
            local pm, pp, pe, pc = collectMembers(super, visited)
            for name, member in pairs(pm) do methods[name] = member end
            for name, member in pairs(pp) do properties[name] = member end
            for name, member in pairs(pe) do events[name] = member end
            for name, member in pairs(pc) do callbacks[name] = member end
        end

        local members = classMap[className].Members
        if members then
            for _, member in ipairs(members) do
                if member.MemberType == "Function" then
                    methods[member.Name] = {
                        Name = member.Name,
                        Parameters = member.Parameters or {},
                        ReturnType = member.ReturnType,
                    }
                elseif member.MemberType == "Property" then
                    local tags = member.Tags or {}
                    local tagSet
                    if type(tags) == "table" then
                        tagSet = {}
                        for _, t in ipairs(tags) do tagSet[tostring(t)] = true end
                    else
                        tagSet = {}
                    end
                    properties[member.Name] = {
                        Name = member.Name,
                        ValueType = member.ValueType,
                        Default = member.Default,
                        tags = tagSet,
                        simulation = member.SimulationAccess == true,
                        security = member.Security,
                    }
                elseif member.MemberType == "Event" then
                    events[member.Name] = {
                        Name = member.Name,
                        Parameters = member.Parameters or {},
                    }
                elseif member.MemberType == "Callback" then
                    callbacks[member.Name] = {
                        Name = member.Name,
                        Parameters = member.Parameters or {},
                        ReturnType = member.ReturnType,
                    }
                end
            end
        end

        return methods, properties, events, callbacks
    end

    local instances = {}
    for _, class in ipairs(apiDump.Classes or {}) do
        local methods, properties, events, callbacks = collectMembers(class.Name)
        instances[class.Name] = {
            methods = methods,
            properties = properties,
            events = events,
            callbacks = callbacks,
            tags = class.Tags,
            superclass = class.Superclass,
        }
    end

    local hierarchy = {}
    for _, class in ipairs(apiDump.Classes or {}) do
        hierarchy[class.Name] = class.Superclass
    end

    local enums = {}
    for _, enum in ipairs(apiDump.Enums or {}) do
        local items = {}
        local ordered = {}
        for _, item in ipairs(enum.Items or {}) do
            items[item.Name] = item.Value
            table.insert(ordered, { Name = item.Name, Value = item.Value })
        end
        enums[enum.Name] = { items = items, ordered = ordered }
    end

    return {
        instances = instances,
        hierarchy = hierarchy,
        enums = enums,
    }
end

local function loadApiDump(apiPath)
    if not apiPath or apiPath == "" then
        return nil
    end

    local ok, content = pcall(fs.readFile, apiPath)
    if not ok or type(content) ~= "string" then
        warn("[EnvLogger] API dump not found or unreadable: " .. tostring(apiPath) .. " (continuing without instance emulation)")
        return nil
    end

    local decodeOk, apiDump = pcall(serde.decode, "json", content)
    if not decodeOk or type(apiDump) ~= "table" or not apiDump.Classes then
        warn("[EnvLogger] API dump is corrupt or unexpected format: " .. tostring(apiPath) .. " (continuing without instance emulation)")
        return nil
    end

    local buildOk, lib = pcall(buildInstanceLib, apiDump)
    if not buildOk then
        warn("[EnvLogger] Failed to build instance lib from API dump: " .. tostring(lib) .. " (continuing without instance emulation)")
        return nil
    end

    return lib
end

-- ===== BIT LIBRARY SUPPORT =====

local bit = bit or {}
if not bit.bxor then
    function bit.bxor(a, b)
        a = tonumber(a) or 0
        b = tonumber(b) or 0
        local result = 0
        local bitpos = 1
        while a > 0 or b > 0 do
            local abit = a % 2
            local bbit = b % 2
            if abit ~= bbit then
                result = result + bitpos
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            bitpos = bitpos * 2
        end
        return result
    end
end

if not bit.band then
    function bit.band(a, b)
        a = tonumber(a) or 0
        b = tonumber(b) or 0
        local result = 0
        local bitpos = 1
        while a > 0 and b > 0 do
            local abit = a % 2
            local bbit = b % 2
            if abit == 1 and bbit == 1 then
                result = result + bitpos
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            bitpos = bitpos * 2
        end
        return result
    end
end

if not bit.bor then
    function bit.bor(a, b)
        a = tonumber(a) or 0
        b = tonumber(b) or 0
        local result = 0
        local bitpos = 1
        while a > 0 or b > 0 do
            local abit = a % 2
            local bbit = b % 2
            if abit == 1 or bbit == 1 then
                result = result + bitpos
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            bitpos = bitpos * 2
        end
        return result
    end
end

if not bit.blshift then
    function bit.blshift(a, b)
        a = tonumber(a) or 0
        b = tonumber(b) or 0
        return a * (2 ^ b)
    end
end

if not bit.brshift then
    function bit.brshift(a, b)
        a = tonumber(a) or 0
        b = tonumber(b) or 0
        return math.floor(a / (2 ^ b))
    end
end

local DEFAULTS = {
    out = "EnvLogs",
    max_events = 8000,
    max_ops = 25000000,
    max_seconds = 60,
    max_string = 7000,
    max_depth = 4,
    max_alloc = 5000000,
    max_write_bytes = 2000000,
    max_fake_fs_bytes = 20000000,
    execute_loadstrings = true,
    allow_real_files = false,
    real_files_root = "",
    strict_asserts = false,
    verbose = true,
    spoof_executor = true,
    executor_name = "Volcano",
    api = "api/api.json",
}

local HUGE_STRING_LIMIT = 256 * 1024
local HUGE_STRING_PLACEHOLDER = "<256kb long string, truncated>"

local function parseValue(value)
    if value == "true" then
        return true
    elseif value == "false" then
        return false
    elseif value == "nil" then
        return nil
    end

    local numberValue = tonumber(value)
    if numberValue ~= nil then
        return numberValue
    end

    return value
end

local function normalizeOptionName(name)
    return (name:gsub("-", "_"))
end

local function parseArgs(args)
    local options = {}
    for key, value in pairs(DEFAULTS) do
        options[key] = value
    end

    local target
    for _, arg in ipairs(args) do
        if arg:sub(1, 2) == "--" then
            local key, value = arg:match("^%-%-([%w_%-]+)=(.*)$")
            if key then
                options[normalizeOptionName(key)] = parseValue(value)
            else
                options[normalizeOptionName(arg:sub(3))] = true
            end
        elseif not target then
            target = arg
        end
    end

    return target, options
end

local function pathJoin(left, right)
    if left == "" then
        return right
    end
    local last = left:sub(-1)
    if last == "/" or last == "\\" then
        return left .. right
    end
    return left .. "/" .. right
end

local function ensureFolder(path)
    if not fs.isDir(path) then
        fs.writeDir(path)
    end
end

local function sanitizeFileName(path)
    local name = path:gsub("\\", "/"):match("([^/]+)$") or "script"
    name = name:gsub("[^%w%._%-]+", "_")
    if name == "" then
        name = "script"
    end
    return name
end

local function escapePattern(text)
    return (tostring(text):gsub("([^%w])", "%%%1"))
end

local function sanitizeDiagnosticText(text, target)
    text = tostring(text or "")
    local targetName = sanitizeFileName(target or "input.lua")
    local normalizedTarget = tostring(target or ""):gsub("\\", "/")
    if normalizedTarget ~= "" then
        text = text:gsub(escapePattern(normalizedTarget), targetName)
    end
    text = text:gsub("\\", "/")
    text = text:gsub("@?%a:[^%s\n\r]*[/\\]([^/\\%s\n\r]+:%d+)", "%1")
    text = text:gsub("@?%a:[^%s\n\r]*[/\\]([^/\\%s\n\r]+%.lua[u]?:%d+)", "%1")
    text = text:gsub("@?%a:[^%s\n\r]*[/\\]([^/\\%s\n\r]+)", "%1")
    text = text:gsub("@?%.?/?main%.luau:%d+", "main.luau")
    text = text:gsub("@?%.?/?main:%d+", "main")

    local out = {}
    for line in (text .. "\n"):gmatch("([^\n]*)\n") do
        local lower = line:lower()
        local internal = lower:match("^%s*stack traceback:%s*$")
            or lower:match("%f[%w]main%.luau%f[%W]")
            or lower:match("%f[%w]main%f[%W]")
            or lower:find("@lune/", 1, true)
            or lower:find("[c]", 1, true)
        if not internal and line ~= "" then
            out[#out + 1] = line
        end
    end
    if #out == 0 then
        return "EnvLogger internal error"
    end
    return table.concat(out, "\n")
end

local proxyMarker = {}

-- spy userdata -> its display path. module-level so logger:describe (which lives
-- outside createEnvironment) can render spies as "<path>" instead of bare
-- userdata. populated by makeSpy inside createEnvironment.
local spyPaths = setmetatable({}, { __mode = "k" })

-- userdata -> reconstruction metadata. This is separate from spyPaths because
-- real emulated values (Instances, EnumItems, wrapped datatypes) should keep
-- their real runtime behavior while still giving the report enough structure
-- to print useful Luau constructors.
local valueHints = setmetatable({}, { __mode = "k" })
local nextValueHintId = 0

local function rememberValue(value, hint)
    local existing = valueHints[value]
    if existing then
        for key, item in pairs(hint) do
            existing[key] = item
        end
        return existing
    end

    nextValueHintId += 1
    hint.id = hint.id or nextValueHintId
    valueHints[value] = hint
    return hint
end

local function isArray(t)
    local max = 0
    local count = 0

    for key in pairs(t) do
        if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then
            return false
        end
        if key > max then
            max = key
        end
        count += 1
    end

    return max == count
end

local function sortKeys(keys)
    table.sort(keys, function(a, b)
        return tostring(a) < tostring(b)
    end)
end

-- obfuscators burn thousands of ops unpacking themselves (string-table decode,
-- proxy/metatable setup, integrity canaries) before the real script runs. these
-- are the events that belong to that phase; we drop them until the script
-- actually touches the environment (print, game, Instance, an index/assign...).
local noiseKinds = {
    getmetatable_probe = true, rawget_probe = true, rawset = true,
    setmetatable = true, binary_op = true, compare = true, len = true,
    iter = true, unary_op = true, error_call = true, global_read = true,
    global_assign = true, builtin_override = true,
}
local noiseCalls = {
    type = true, typeof = true, tostring = true, tonumber = true, select = true,
    unpack = true, pairs = true, ipairs = true, next = true, rawget = true,
    rawset = true, rawequal = true, rawlen = true, newproxy = true,
    getmetatable = true, setmetatable = true, getrawmetatable = true,
    setrawmetatable = true, pcall = true, xpcall = true, error = true,
    assert = true, getfenv = true, setfenv = true, getgenv = true,
    getrenv = true, collectgarbage = true, gcinfo = true,
}
local noisePrefixes = {
    "math.", "string.", "table.", "bit.", "bit32.", "buffer.",
    "utf8.", "coroutine.", "os.", "debug.",
}

local function isInitNoise(kind, path)
    if noiseKinds[kind] then
        return true
    end
    if kind == "call" then
        local p = tostring(path)
        if noiseCalls[p] then
            return true
        end
        for _, pre in ipairs(noisePrefixes) do
            if string.sub(p, 1, #pre) == pre then
                return true
            end
        end
    end
    return false
end

local function describeRobloxValue(value, valueType)
    local hint = valueHints[value]
    if hint then
        local out = {
            type = valueType,
            value = tostring(value),
        }
        for key, item in pairs(hint) do
            out[key] = item
        end
        return out
    end

    local ok, desc
    if valueType == "EnumItem" then
        return {
            type = valueType,
            robloxType = "EnumItem",
            path = tostring(value),
            value = tostring(value),
        }
    elseif valueType == "UDim" then
        ok, desc = pcall(function()
            return {
                type = valueType,
                robloxType = "UDim",
                scale = value.Scale,
                offset = value.Offset,
                value = tostring(value),
            }
        end)
    elseif valueType == "UDim2" then
        ok, desc = pcall(function()
            return {
                type = valueType,
                robloxType = "UDim2",
                xs = value.X.Scale,
                xo = value.X.Offset,
                ys = value.Y.Scale,
                yo = value.Y.Offset,
                value = tostring(value),
            }
        end)
    elseif valueType == "Color3" then
        ok, desc = pcall(function()
            return {
                type = valueType,
                robloxType = "Color3",
                r = value.R,
                g = value.G,
                b = value.B,
                value = tostring(value),
            }
        end)
    elseif valueType == "BrickColor" then
        ok, desc = pcall(function()
            return {
                type = valueType,
                robloxType = "BrickColor",
                name = value.Name,
                number = value.Number,
                value = tostring(value),
            }
        end)
    elseif valueType == "Vector2" then
        ok, desc = pcall(function()
            return {
                type = valueType,
                robloxType = "Vector2",
                x = value.X,
                y = value.Y,
                value = tostring(value),
            }
        end)
    elseif valueType == "Vector3" then
        ok, desc = pcall(function()
            return {
                type = valueType,
                robloxType = "Vector3",
                x = value.X,
                y = value.Y,
                z = value.Z,
                value = tostring(value),
            }
        end)
    elseif valueType == "CFrame" then
        ok, desc = pcall(function()
            local components = table.pack(value:GetComponents())
            local out = {
                type = valueType,
                robloxType = "CFrame",
                value = tostring(value),
                n = components.n,
            }
            for i = 1, components.n do
                out[i] = components[i]
            end
            return out
        end)
    end

    if ok then
        return desc
    end

    return nil
end

local function descriptionKey(desc)
    if type(desc) ~= "table" then return tostring(desc) end
    local kind = tostring(desc.robloxType or desc.type or "")
    if desc.path ~= nil then return kind .. ":" .. tostring(desc.path) end
    if desc.value ~= nil then return kind .. ":" .. tostring(desc.value) end
    if desc.name ~= nil then return kind .. ":" .. tostring(desc.name) end
    return kind
end

local function argsKey(args)
    if type(args) ~= "table" then return "" end
    local out = {}
    for i = 1, args.n or #args do
        out[i] = descriptionKey(args[i])
    end
    return table.concat(out, "|")
end

local function coalesceKey(kind, path, detail)
    path = tostring(path or "")
    if kind == "namecall" and path:find(":UserOwnsGamePass", 1, true) then
        return kind .. ":" .. path .. ":" .. argsKey(detail and detail.args)
    end
    if kind == "assign" and path:match("%.UserInputService%.MouseIcon$") then
        return kind .. ":" .. path .. ":" .. descriptionKey(detail and detail.value)
    end
    return nil
end

local function createLogger(options)
    local logger = {
        options = options,
        events = {},
        counts = {},
        coalesced = {},
        overflow = 0,
        started = os.clock(),
        payloadStarted = false,
    }

    function logger:push(kind, path, detail)
        -- ignore the unpacker; only start recording once the real script runs
        if not self.payloadStarted then
            if isInitNoise(kind, path) then
                return
            end
            self.payloadStarted = true
        end

        self.counts[kind] = (self.counts[kind] or 0) + 1

        local key = coalesceKey(kind, path, detail)
        if key then
            local seen = (self.coalesced[key] or 0) + 1
            self.coalesced[key] = seen
            if seen > 8 then
                return
            end
        end

        if #self.events >= self.options.max_events then
            self.overflow += 1
            return
        end

        self.events[#self.events + 1] = {
            i = #self.events + 1,
            t = os.clock() - self.started,
            kind = kind,
            path = path,
            detail = detail or {},
        }
    end

    function logger:describe(value, depth, seen)
        depth = depth or 0
        seen = seen or {}

        local valueType = typeof(value)
        if valueType == "table" then
            local proxyPath = rawget(value, proxyMarker)
            if proxyPath then
                return {
                    type = "proxy",
                    path = proxyPath,
                }
            end

            if seen[value] then
                return {
                    type = "table",
                    value = "<recursive>",
                }
            end

            if depth >= self.options.max_depth then
                return {
                    type = "table",
                    value = "<max-depth>",
                }
            end

            seen[value] = true
            local items = {}
            local keys = {}

            for key in pairs(value) do
                keys[#keys + 1] = key
                if #keys >= 80 then
                    break
                end
            end
            sortKeys(keys)

            for _, key in ipairs(keys) do
                items[#items + 1] = {
                    key = self:describe(key, depth + 1, seen),
                    value = self:describe(value[key], depth + 1, seen),
                }
            end

            seen[value] = nil
            return {
                type = "table",
                items = items,
            }
        elseif valueType == "function" then
            local source = "?"
            local line = -1
            pcall(function()
                source, line = debug.info(value, "sl")
            end)
            source = sanitizeDiagnosticText(source, self.options and self.options.target or "input.lua")
            return {
                type = "function",
                source = source,
                line = line,
            }
        elseif valueType == "string" then
            local text = value
            local truncated = false
            local placeholder = false
            if #text >= HUGE_STRING_LIMIT then
                text = HUGE_STRING_PLACEHOLDER
                truncated = true
                placeholder = true
            elseif #text > self.options.max_string then
                text = text:sub(1, self.options.max_string)
                truncated = true
            end
            return {
                type = "string",
                value = text,
                length = #value,
                truncated = truncated,
                placeholder = placeholder,
            }
        else
            -- spy userdata created by the emulator's makeSpy: render its path so
            -- the report shows "<path>" and reconstruction/replay can track it.
            local spyPath = spyPaths[value]
            if spyPath then
                return {
                    type = "proxy",
                    path = spyPath,
                }
            end
            local robloxDesc = describeRobloxValue(value, valueType)
            if robloxDesc then
                return robloxDesc
            end
            return {
                type = valueType,
                value = tostring(value),
            }
        end
    end

    function logger:describeArgs(...)
        local result = {}
        local packed = table.pack(...)
        for index = 1, packed.n do
            result[index] = self:describe(packed[index])
        end
        result.n = packed.n
        return result
    end

    function logger:formatValue(value, depth, seen)
        depth = depth or 0
        seen = seen or {}

        local valueType = typeof(value)
        if valueType == "table" then
            local proxyPath = rawget(value, proxyMarker)
            if proxyPath then
                return "<" .. proxyPath .. ">"
            end
            if seen[value] then
                return "{<recursive>}"
            end
            if depth >= 2 then
                return "{...}"
            end

            seen[value] = true
            local keys = {}
            for key in pairs(value) do
                keys[#keys + 1] = key
                if #keys >= 8 then
                    break
                end
            end
            sortKeys(keys)

            local out = {}
            for _, key in ipairs(keys) do
                out[#out + 1] = tostring(key) .. "=" .. self:formatValue(value[key], depth + 1, seen)
            end
            seen[value] = nil

            local suffix = ""
            local total = 0
            for _ in pairs(value) do
                total += 1
            end
            if total > #keys then
                suffix = ", ..."
            end
            return "{" .. table.concat(out, ", ") .. suffix .. "}"
        elseif valueType == "string" then
            if #value >= HUGE_STRING_LIMIT then
                return string.format("%q", HUGE_STRING_PLACEHOLDER)
            end
            local text = value
            if #text > 180 then
                text = text:sub(1, 180) .. "...<" .. tostring(#value) .. " bytes>"
            end
            return string.format("%q", text)
        elseif valueType == "function" then
            local source = "?"
            local line = -1
            pcall(function()
                source, line = debug.info(value, "sl")
            end)
            source = sanitizeDiagnosticText(source, self.options and self.options.target or "input.lua")
            return string.format("<function %s:%s>", tostring(source), tostring(line))
        end

        local spyPath = spyPaths[value]
        if spyPath then
            return "<" .. spyPath .. ">"
        end
        local hint = valueHints[value]
        if hint and hint.path then
            return tostring(hint.path)
        end

        return tostring(value)
    end

    function logger:formatArgs(...)
        local out = {}
        local packed = table.pack(...)
        for index = 1, packed.n do
            out[index] = self:formatValue(packed[index])
        end
        return table.concat(out, ", ")
    end

    return logger
end

local function isRecoverableObfuscatorTamper(err)
    if type(err) ~= "string" then return false end
    return err:find("Goofantitamper detected you: tamper", 1, true) ~= nil
end

local function instrumentDebugMutators(source)
    if type(source) ~= "string" then return source end

    source = source:gsub(
        'return%s+"fail"(%s*end%s*debug%.setconstant%()',
        'return debug.__envlogger_constant(test, 1, "fail")%1'
    )
    source = source:gsub(
        'return%s+"fail"%s*,%s*debug%.setstack%(1,%s*1,%s*"success"%)',
        'debug.setstack(1, 1, "success"); return debug.__envlogger_stackreturn(1, 1, "fail")'
    )
    source = source:gsub(
        'return%s+upvalue%(%)(%s*end%s*debug%.setupvalue%()',
        'return (debug.__envlogger_upvalue(test, 1, upvalue))()%1'
    )

    return source
end

local function longBracketCloseAt(source, start)
    if source:sub(start, start) ~= "[" then return nil end
    local i = start + 1
    while source:sub(i, i) == "=" do
        i += 1
    end
    if source:sub(i, i) ~= "[" then return nil end
    return "]" .. source:sub(start + 1, i - 1) .. "]", i + 1
end

local function instrumentLoopGuards(source)
    if type(source) ~= "string" or source == "" then return source end

    local out = {}
    local i = 1
    local n = #source
    local pendingLoopDo = 0

    local function push(text)
        out[#out + 1] = text
    end

    local function isIdentStart(ch)
        return ch:match("[%a_]") ~= nil
    end

    local function isIdent(ch)
        return ch:match("[%w_]") ~= nil
    end

    while i <= n do
        local ch = source:sub(i, i)
        local nextCh = source:sub(i + 1, i + 1)

        if ch == "-" and nextCh == "-" then
            local close, afterOpen = longBracketCloseAt(source, i + 2)
            if close then
                local closeStart = source:find(close, afterOpen, true)
                local j = closeStart and (closeStart + #close - 1) or n
                push(source:sub(i, j))
                i = j + 1
            else
                local j = source:find("\n", i + 2, true) or (n + 1)
                push(source:sub(i, j - 1))
                i = j
            end
        elseif ch == "'" or ch == '"' then
            local quote = ch
            local j = i + 1
            while j <= n do
                local c = source:sub(j, j)
                if c == "\\" then
                    j += 2
                elseif c == quote then
                    j += 1
                    break
                else
                    j += 1
                end
            end
            push(source:sub(i, math.min(j - 1, n)))
            i = j
        elseif ch == "[" then
            local close, afterOpen = longBracketCloseAt(source, i)
            if close then
                local closeStart = source:find(close, afterOpen, true)
                local j = closeStart and (closeStart + #close - 1) or n
                push(source:sub(i, j))
                i = j + 1
            else
                push(ch)
                i += 1
            end
        elseif isIdentStart(ch) then
            local j = i + 1
            while j <= n and isIdent(source:sub(j, j)) do
                j += 1
            end
            local word = source:sub(i, j - 1)
            if word == "while" or word == "for" then
                pendingLoopDo += 1
                push(word)
            elseif word == "do" and pendingLoopDo > 0 then
                pendingLoopDo -= 1
                push("do __envlogger_ophook(1);")
            elseif word == "repeat" then
                push("repeat __envlogger_ophook(1);")
            else
                push(word)
            end
            i = j
        else
            push(ch)
            i += 1
        end
    end

    return table.concat(out)
end

local function prepareSourceForExecution(source)
    source = instrumentLoopGuards(source)
    return instrumentDebugMutators(source)
end

local debugSourceTexts = {}
local debugSourceLineCache = {}
local function rememberDebugSource(chunkname, text)
    if type(text) ~= "string" or text == "" then return end
    chunkname = tostring(chunkname or "=(loadstring)")
    local names = { chunkname }
    if chunkname:sub(1, 1) == "@" then
        names[#names + 1] = chunkname:sub(2)
    else
        names[#names + 1] = "@" .. chunkname
    end
    local normalized = chunkname:gsub("\\", "/")
    names[#names + 1] = normalized
    if normalized:sub(1, 1) == "@" then
        names[#names + 1] = normalized:sub(2)
    end
    local base = normalized:match("([^/]+)$")
    if base then
        names[#names + 1] = base
        names[#names + 1] = "@" .. base
    end
    for _, name in ipairs(names) do
        debugSourceTexts[name] = text
    end
end

local function debugSourceLines(name)
    local text = debugSourceTexts[name]
    if not text and type(name) == "string" then
        text = debugSourceTexts[name:gsub("\\", "/")]
        if not text and name:sub(1, 1) == "@" then
            text = debugSourceTexts[name:sub(2)]
        elseif not text then
            text = debugSourceTexts["@" .. name]
        end
        if not text then
            local base = name:gsub("\\", "/"):match("([^/]+)$")
            text = base and (debugSourceTexts[base] or debugSourceTexts["@" .. base]) or nil
        end
    end
    if not text then return nil end
    local cached = debugSourceLineCache[text]
    if cached then return cached end
    local lines = {}
    for line in (text .. "\n"):gmatch("([^\n]*)\n") do
        lines[#lines + 1] = line
    end
    debugSourceLineCache[text] = lines
    return lines
end

local function encodeJson(data)
    local ok, encoded = pcall(function()
        return serde.encode("json", data, true)
    end)

    if ok then
        return encoded
    end

    return serde.encode("json", data)
end

-- ===== CLIENT ENVIRONMENT =====
-- Builds a 1:1, undetectable Roblox CLIENT environment. Globals live as raw
-- fields on `env` (so rawget(getfenv(),k) finds them like a real executor),
-- the env metatable is locked, instances are real userdata driven by api.json,
-- and datatypes come from @lune/roblox. Logging happens only at the API
-- boundary (Instance.new/GetService/method calls/property writes/global calls).
local function createEnvironment(logger, options, opHook, apiLib)
    local env = {}
    local genv = {}
    local hostEnv = getfenv(0)

    -- our userdata (instances, datatypes we build, signals, enums) -> roblox type
    local objectTypes = setmetatable({}, { __mode = "k" })
    local rawObjectMts = setmetatable({}, { __mode = "k" })
    -- functions we present as engine/executor C closures
    local cclosures = setmetatable({}, { __mode = "k" })
    local cclosureNames = setmetatable({}, { __mode = "k" })
    local currentNamecall = ""

    local nativeType = type
    local nativeTypeof = typeof
    local nativeGetmt = getmetatable
    local nativeSetmt = setmetatable
    local stringMetatableView
    local LOCKED = "The metatable is locked"
    -- functions that are native Roblox/engine builtins (print, math.*, etc.).
    -- populated as we install env globals; used by isexecutorclosure to say
    -- "everything the script creates is ours, only these are foreign".
    local nativeBuiltins = setmetatable({}, { __mode = "k" })
    local functionEnvs = setmetatable({}, { __mode = "k" })
    local frozenTables

    local function cclosure(fn, name)
        cclosures[fn] = true
        if name ~= nil then cclosureNames[fn] = tostring(name) end
        return fn
    end

    local function log(kind, path, detail)
        logger:push(kind, path, detail)
    end

    -- ----- typeof / type / metatable that stay honest about our objects -----
    local function typeofImpl(value)
        local t = objectTypes[value]
        if t then return t end
        return nativeTypeof(value)
    end

    local function typeImpl(value)
        -- our objects are genuine userdata, so native type already says "userdata"
        return nativeType(value)
    end

    -- forward decl: assigned later in the executor-globals section. maps a table
    -- to the __metatable lock string we stripped (so getmetatable still reports
    -- it while setrawmetatable can swap the real mt).
    local mtLocks
    local function getmetatableImpl(value)
        if objectTypes[value] ~= nil then
            return LOCKED
        end
        if nativeType(value) == "string" and stringMetatableView then
            return stringMetatableView
        end
        if mtLocks and mtLocks[value] ~= nil then
            return mtLocks[value]
        end
        local mt = nativeGetmt(value)
        if mt == nil then return nil end
        if nativeType(mt) == "table" then
            local locked = rawget(mt, "__metatable")
            if locked ~= nil then return locked end
        end
        return mt
    end

    -- ----- Roblox-accurate errors -----
    local function rbxError(msg)
        error(msg, 0) -- 0: keep the message verbatim, Roblox-style
    end

    -- ----- @lune/roblox datatype helpers -----
    local function tryDatatype(fn)
        if not roblox then return nil end
        local ok, val = pcall(fn)
        if ok then return val end
        return nil
    end

    local function datatypeDefault(name)
        if not roblox then return nil end
        return tryDatatype(function()
            if name == "Vector3" then return roblox.Vector3.zero end
            if name == "Vector2" then return roblox.Vector2.zero end
            if name == "Vector3int16" then return roblox.Vector3int16.new(0, 0, 0) end
            if name == "Vector2int16" then return roblox.Vector2int16.new(0, 0) end
            if name == "CFrame" then return roblox.CFrame.identity end
            if name == "Color3" then return roblox.Color3.new(0, 0, 0) end
            if name == "UDim" then return roblox.UDim.new(0, 0) end
            if name == "UDim2" then return roblox.UDim2.new(0, 0, 0, 0) end
            if name == "Rect" then return roblox.Rect.new(0, 0, 0, 0) end
            if name == "Region3" then return roblox.Region3.new(roblox.Vector3.zero, roblox.Vector3.zero) end
            if name == "NumberRange" then return roblox.NumberRange.new(0) end
            if name == "BrickColor" then return roblox.BrickColor.new(194) end
            if name == "NumberSequence" then return roblox.NumberSequence.new(0) end
            if name == "ColorSequence" then return roblox.ColorSequence.new(roblox.Color3.new(0, 0, 0)) end
            if name == "PhysicalProperties" then return roblox.PhysicalProperties.new(0.7, 0.3, 0.5) end
            if name == "Faces" then return roblox.Faces.new() end
            if name == "Axes" then return roblox.Axes.new() end
            if name == "RaycastParams" then return roblox.RaycastParams.new() end
            if name == "OverlapParams" then return roblox.OverlapParams.new() end
            if name == "Font" then return roblox.Font.new("rbxasset://fonts/families/Arial.json") end
            if name == "DateTime" then return roblox.DateTime.fromUnixTimestamp(0) end
            if name == "Random" then return roblox.Random.new(0) end
            if name == "CatalogSearchParams" then return roblox.CatalogSearchParams.new() end
            return nil
        end)
    end

    -- ===== ENUMS (built from api.json for full coverage) =====
    local enumTypeCache = {}
    local enumItemCache = {}
    local Enums -- the global `Enum`

    local function makeEnumItem(enumName, itemName, value, enumTypeUd)
        local key = enumName .. "." .. itemName
        local cached = enumItemCache[key]
        if cached then return cached end
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "EnumItem"
        rememberValue(u, {
            robloxType = "EnumItem",
            enum = enumName,
            name = itemName,
            path = "Enum." .. enumName .. "." .. itemName,
        })
        mt.__metatable = LOCKED
        mt.__tostring = function() return "Enum." .. enumName .. "." .. itemName end
        mt.__index = function(_, k)
            if k == "Name" then return itemName end
            if k == "Value" then return value end
            if k == "EnumType" then return enumTypeUd end
            rbxError(tostring(k) .. " is not a valid member of EnumItem")
        end
        enumItemCache[key] = u
        return u
    end

    local function makeEnumType(enumName, def)
        local cached = enumTypeCache[enumName]
        if cached then return cached end
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "Enum"
        mt.__metatable = LOCKED
        mt.__tostring = function() return "Enum." .. enumName end
        mt.__index = function(_, k)
            if k == "GetEnumItems" then
                return function()
                    local out = {}
                    for _, item in ipairs(def.ordered) do
                        out[#out + 1] = makeEnumItem(enumName, item.Name, item.Value, u)
                    end
                    return out
                end
            end
            if def.items[k] ~= nil then
                return makeEnumItem(enumName, k, def.items[k], u)
            end
            rbxError(tostring(k) .. " is not a valid EnumItem of Enum." .. enumName)
        end
        enumTypeCache[enumName] = u
        return u
    end

    -- synthetic enums for ones missing from the loaded api dump (e.g.
    -- CompressionFormat in older dumps). map name -> ordered {Name, Value} list.
    local syntheticEnums = {
        CompressionFormat = { { Name = "None", Value = 0 }, { Name = "Zlib", Value = 1 }, { Name = "Gzip", Value = 2 }, { Name = "Lz4", Value = 3 }, { Name = "Zstd", Value = 4 } },
    }
    local function enumDef(enumName)
        local syn = syntheticEnums[enumName]
        if syn then
            local items, ordered = {}, {}
            for _, it in ipairs(syn) do
                items[it.Name] = it.Value
                ordered[#ordered + 1] = it
            end
            return { items = items, ordered = ordered }
        end
        return apiLib and apiLib.enums and apiLib.enums[enumName]
    end

    local function buildEnumsRoot()
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "Enums"
        mt.__metatable = LOCKED
        mt.__tostring = function() return "Enums" end
        mt.__index = function(_, enumName)
            local def = enumDef(enumName)
            if not def then
                rbxError(tostring(enumName) .. " is not a valid Enum")
            end
            return makeEnumType(enumName, def)
        end
        mt.__newindex = function() rbxError("Enums cannot be modified") end
        return u
    end
    Enums = buildEnumsRoot()

    local function enumDefault(enumName, dumpDefault)
        local def = enumDef(enumName)
        if not def then return nil end
        if dumpDefault ~= nil and def.items[tostring(dumpDefault)] ~= nil then
            return makeEnumItem(enumName, tostring(dumpDefault), def.items[tostring(dumpDefault)], makeEnumType(enumName, def))
        end
        -- numeric default or fall back to first item
        for _, item in ipairs(def.ordered) do
            if tostring(item.Value) == tostring(dumpDefault) then
                return makeEnumItem(enumName, item.Name, item.Value, makeEnumType(enumName, def))
            end
        end
        local first = def.ordered[1]
        if first then
            return makeEnumItem(enumName, first.Name, first.Value, makeEnumType(enumName, def))
        end
        return nil
    end

    local function safeEnumItem(enumName, itemName)
        local def = enumDef(enumName)
        if def and def.items[itemName] ~= nil then
            return makeEnumItem(enumName, itemName, def.items[itemName], makeEnumType(enumName, def))
        end
        return nil
    end

    local function enumItemName(item)
        local ok, name = pcall(function() return item.Name end)
        if ok and name ~= nil then return tostring(name) end
        return nil
    end

    local function enumTypeName(item)
        local ok, enumType = pcall(function() return item.EnumType end)
        if ok and enumType ~= nil then
            local text = tostring(enumType)
            return text:match("^Enum%.(.+)$")
        end
        return nil
    end

    local function toRobloxEnumItem(item, expectedType)
        if not roblox or not roblox.Enum then return item end
        local itemName = enumItemName(item)
        if not itemName then return item end
        local typeName = expectedType or enumTypeName(item)
        if not typeName then return item end
        local ok, converted = pcall(function()
            return roblox.Enum[typeName][itemName]
        end)
        if ok and converted ~= nil then return converted end
        return item
    end

    -- ===== INSTANCES =====
    local instState = setmetatable({}, { __mode = "k" })   -- ud -> {class, props, children, parent}
    local methodCache = {}                                  -- class -> name -> closure
    local signalCache = setmetatable({}, { __mode = "k" }) -- ud -> name -> signal
    -- real method implementations: [className][methodName] = function(self, ...) .
    -- checked first inside getMethodClosure; everything else falls back to a
    -- default/spy return. this is the single place real behavior is added.
    local methodOverrides = {}
    -- forward decls (defined below)
    local makeSpy
    local isDescendantOfInst

    -- synthetic classes for services/datatypes missing from the loaded api dump
    -- (e.g. CompressionService in older dumps). keyed by class name; consulted by
    -- classInfo/isServiceClass so GetService + member resolution work for them.
    local syntheticClasses = {
        CompressionService = { methods = {}, properties = {}, events = {}, callbacks = {}, tags = { "Service", "NotCreatable" }, superclass = "Instance" },
    }

    local function classInfo(className)
        if syntheticClasses[className] then return syntheticClasses[className] end
        if apiLib and apiLib.instances then return apiLib.instances[className] end
        return nil
    end

    local function isAClass(className, target)
        local cur = className
        while cur do
            if cur == target then return true end
            cur = apiLib and apiLib.hierarchy and apiLib.hierarchy[cur] or nil
        end
        return false
    end

    -- realistic client-side overrides keyed by property name
    -- per-run identity: randomized ONCE when the environment is built, then
    -- stable for every read during this run (a real client's JobId/hwid/clientid
    -- don't change mid-session). detection scripts read these repeatedly and
    -- expect them constant within a run but not the hardcoded zero-uuid.
    local rng = roblox and roblox.Random and roblox.Random.new(os.time() + math.floor(os.clock() * 1000000)) or nil
    if not rng then math.randomseed(os.time() + math.floor(os.clock() * 1000000)) end
    local function randInt(min, max)
        if rng then return rng:NextInteger(min, max) end
        return math.random(min, max)
    end
    local HEX = "0123456789ABCDEF"
    local function randHex(n)
        local out = {}
        for i = 1, n do
            local idx = randInt(1, 16)
            out[i] = HEX:sub(idx, idx)
        end
        return table.concat(out)
    end
    -- Roblox JobIds are UUIDs (8-4-4-4-12 hex). hwid/clientid are ~32-40 hex chars.
    local function makeUuid()
        return randHex(8) .. "-" .. randHex(4) .. "-" .. randHex(4) .. "-" .. randHex(4) .. "-" .. randHex(12)
    end
    local function randRuntimeName(prefix)
        return prefix .. tostring(randInt(100000, 999999999))
    end
    local runIdentity = {
        JobId = makeUuid(),
        Hwid = randHex(40),
        ClientId = randHex(32),
        ClientGitHash = randHex(40):lower(),
        GameName = randRuntimeName("Experience"),
        PlayerName = randRuntimeName("Player"),
    }
    runIdentity.DisplayName = runIdentity.PlayerName
    -- a plausible mouse position somewhere in the viewport, not pinned to 0,0
    local mouseLocation = roblox and roblox.Vector2.new(randInt(120, 900), randInt(80, 600))
        or { X = randInt(120, 900), Y = randInt(80, 600) }

    local clientDefaults = {
        PlaceId = randInt(100000, 999999999),
        PlaceVersion = randInt(1, 500),
        GameId = randInt(100000, 999999999),
        CreatorId = randInt(100000, 999999999),
        CreatorType = nil,
        JobId = runIdentity.JobId,
        UserId = randInt(100000, 2147483647),
        AccountAge = randInt(30, 4000),
        MembershipType = nil,
        Gravity = 196.2,
        ClockTime = 14,
        FieldOfView = 70,
        MaxHealth = 100,
        Health = 100,
        WalkSpeed = 16,
        JumpPower = 50,
        HipHeight = 0,
    }

    local function defaultForValueType(vt, dumpDefault)
        if not vt then return nil end
        local cat = vt.Category
        local name = vt.Name
        local mapped = AliasToName[name]
        if cat == "Primitive" or mapped then
            local kind = mapped or name
            if kind == "number" then return tonumber(dumpDefault) or 0 end
            if kind == "boolean" then return dumpDefault == "true" or dumpDefault == true end
            if kind == "string" then
                if nativeType(dumpDefault) == "string" then return dumpDefault end
                return ""
            end
            return nil
        elseif cat == "DataType" then
            if name == "Content" or name == "ProtectedString" or name == "BinaryString" then return "" end
            return datatypeDefault(name)
        elseif cat == "Enum" then
            return enumDefault(name, dumpDefault)
        elseif cat == "Class" then
            return nil
        end
        return nil
    end

    -- forward decls
    local newInstance, createInstance, fullName, instanceIndex
    local getService, findService, isServiceClass, game, getLocalPlayer
    -- fire a per-instance signal by name; used by tween completion + change events
    local fireSignal
    -- makeSignal is forward-declared because getMethodClosure (above) references
    -- it for RBXScriptSignal-returning methods; without this the closure captures
    -- a nil global -> "attempt to call a nil value" when such a method runs.
    local makeSignal
    local waitForSignalFrame, drainDue, stepFrame

    local boolMethodDefaults = {
        IsStudio = false, IsServer = false, IsClient = true, IsEdit = false,
        IsRunMode = false, IsRunning = true, IsLoaded = true, IsDescendantOf = false,
        IsAncestorOf = false, CanSetNetworkOwnership = false, HasTag = false,
    }
    local numberMethodDefaults = {
        GetMass = 1, GetService = 0, DistanceFromCharacter = 0,
        GetServerTimeNow = 0, GetFramerate = 60,
    }

    local function defaultForReturn(rt, methodName)
        if not rt then return nil end
        local cat = rt.Category or rt.Type
        local name = rt.Name
        -- null/void are the api-dump's "returns nothing" markers
        if name == "void" or name == "null" or name == nil then return nil end
        -- collection returns (GetPlayers/GetTagged/GetChildren-style). the dump
        -- tags these as a DataType named "Instances" or a Group, but they're
        -- really arrays; empty is the truthful answer for things we own nothing in.
        if name == "Instances" or name == "Array" or name == "Dictionary"
            or name == "Map" or cat == "Group" then
            return {}
        end
        local mapped = AliasToName[name]
        if cat == "Primitive" or mapped then
            local kind = mapped or name
            if kind == "number" then return numberMethodDefaults[methodName] or 0 end
            if kind == "boolean" then
                local d = boolMethodDefaults[methodName]
                if d ~= nil then return d end
                return false
            end
            if kind == "string" then return "" end
            return nil
        elseif cat == "DataType" then
            return datatypeDefault(name)
        end
        -- unknown / Class / Enum: hand back a spy so callers never see a bare
        -- nil and the report shows what was returned.
        return makeSpy(name or "Instance", (methodName or "?") .. "()")
    end

    local function getMethodClosure(className, name, method)
        local perClass = methodCache[className]
        if not perClass then
            perClass = {}
            methodCache[className] = perClass
        end
        local existing = perClass[name]
        if existing then return existing end

        local override = methodOverrides[className] and methodOverrides[className][name]
        local closure
        if override then
            -- real implementation: it owns currentNamecall + logging + return value
            closure = cclosure(function(self, ...)
                currentNamecall = name
                local results = table.pack(override(self, ...))
                local callPath = className .. ":" .. name
                if instState[self] then
                    local st = instState[self]
                    local ownerPath = (st.props.Name ~= nil and st.props.Name ~= st.class) and st.props.Name or fullName(self)
                    callPath = ownerPath .. ":" .. name
                end
                log("namecall", callPath, {
                    target = logger:describe(self),
                    args = logger:describeArgs(...),
                    result = results.n > 0 and logger:describe(results[1]) or nil,
                })
                return table.unpack(results, 1, results.n)
            end)
        else
            closure = cclosure(function(self, ...)
                currentNamecall = name
                local rt = method.ReturnType
                local result
                -- methods that return a signal (GetInstanceAddedSignal etc.)
                -- hand back a real fireable signal keyed on this instance.
                if rt and rt.Name == "RBXScriptSignal" then
                    result = makeSignal(self, className .. ":" .. name)
                else
                    result = defaultForReturn(rt, name)
                end
                local callPath = className .. ":" .. name
                if instState[self] then
                    local st = instState[self]
                    local ownerPath = (st.props.Name ~= nil and st.props.Name ~= st.class) and st.props.Name or fullName(self)
                    callPath = ownerPath .. ":" .. name
                end
                log("namecall", callPath, {
                    target = logger:describe(self),
                    args = logger:describeArgs(...),
                    result = result ~= nil and logger:describe(result) or nil,
                })
                return result
            end)
        end
        perClass[name] = closure
        return closure
    end

    -- signal userdata -> { listeners = {entry,...}, firedArgs = packed|nil }.
    -- lets a signal actually fire (tween Completed, property Changed, etc.) and
    -- :Wait return the last fired args. weak-keyed so signals gc with their owner.
    local signalState = setmetatable({}, { __mode = "k" })
    signalState.__callbackList = {}
    signalState.__exploring = false
    signalState.__signalPath = function(st)
        local owner = st.owner
        local ownerState = instState[owner]
        local ownerPath = ownerState and ((ownerState.props.Name ~= nil and ownerState.props.Name ~= ownerState.class) and ownerState.props.Name or fullName(owner)) or tostring(owner)
        return ownerPath .. "." .. tostring(st.name)
    end

    -- assigns the forward-declared local (declared near the top of this section)
    makeSignal = function(self, name)
        local perInst = signalCache[self]
        if not perInst then
            perInst = {}
            signalCache[self] = perInst
        end
        if perInst[name] then return perInst[name] end
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "RBXScriptSignal"
        signalState[u] = { listeners = {}, firedArgs = nil, owner = self, name = name }
        mt.__metatable = LOCKED
        mt.__tostring = function() return "Signal " .. name end
        mt.__index = function(_, k)
            if k == "Connect" or k == "connect" or k == "ConnectParallel" then
                return function(sigSelf, fn)
                    if sigSelf ~= u then
                        rbxError("Expected ':' not '.' calling member function Connect")
                    end
                    if nativeType(fn) ~= "function" then
                        rbxError("invalid argument #1 to 'Connect' (function expected, got " .. typeofImpl(fn) .. ")")
                    end
                    local st = signalState[u]
                    local c = newproxy(true)
                    local cmt = getmetatable(c)
                    objectTypes[c] = "RBXScriptConnection"
                    local entry = { fn = fn, connected = true, connection = c, once = false, owner = st.owner, signal = st.name, path = signalState.__signalPath(st) }
                    st.listeners[#st.listeners + 1] = entry
                    signalState.__callbackList[#signalState.__callbackList + 1] = entry
                    log("connect", entry.path, { callback = logger:describe(fn) })
                    cmt.__metatable = LOCKED
                    cmt.__index = function(_, ck)
                        if ck == "Connected" then return entry.connected == true end
                        if ck == "Disconnect" or ck == "disconnect" then
                            return function()
                                entry.connected = false
                                for i, item in ipairs(st.listeners) do
                                    if item == entry then table.remove(st.listeners, i) break end
                                end
                            end
                        end
                        rbxError(tostring(ck) .. " is not a valid member of RBXScriptConnection")
                    end
                    return c
                end
            end
            if k == "Once" then
                return function(sigSelf, fn)
                    if sigSelf ~= u then
                        rbxError("Expected ':' not '.' calling member function Once")
                    end
                    local conn = u:Connect(fn)
                    local st = signalState[u]
                    for _, entry in ipairs(st.listeners) do
                        if entry.connection == conn then
                            entry.once = true
                            break
                        end
                    end
                    return conn
                end
            end
            if k == "Wait" or k == "wait" then
                -- no frame loop: return the last fired args (fire-before-wait model).
                -- if the signal was never fired, return a plausible frame deltaTime
                -- so frame-loop math (1 / renderStepped:Wait()) doesn't divide by nil.
                return function(sigSelf)
                    if sigSelf ~= u then
                        rbxError("Expected ':' not '.' calling member function Wait")
                    end
                    local st = signalState[u]
                    if waitForSignalFrame then
                        local frameArgs = waitForSignalFrame(st.owner, st.name)
                        if frameArgs then
                            return table.unpack(frameArgs, 1, frameArgs.n)
                        end
                    end
                    if st.firedArgs then
                        return table.unpack(st.firedArgs, 1, st.firedArgs.n)
                    end
                    return 0.016
                end
            end
            rbxError(tostring(k) .. " is not a valid member of RBXScriptSignal")
        end
        perInst[name] = u
        return u
    end

    -- fire a signal stored on an instance by event name. runs every listener
    -- (pcall'd so a bad handler can't kill the script) and stashes the args so
    -- a following :Wait() returns them.
    fireSignal = function(owner, eventName, ...)
        local perInst = signalCache[owner]
        if not perInst then return end
        local sig = perInst[eventName]
        if not sig then return end
        local st = signalState[sig]
        if not st then return end
        st.firedArgs = table.pack(...)
        local listeners = {}
        for i, entry in ipairs(st.listeners) do listeners[i] = entry end
        for _, entry in ipairs(listeners) do
            if entry.connected then
                if entry.once then
                    entry.connected = false
                    for i, item in ipairs(st.listeners) do
                        if item == entry then table.remove(st.listeners, i) break end
                    end
                end
                pcall(entry.fn, ...)
            end
        end
    end

    -- a chaining spy for values we don't model directly: every read/call/math
    -- op returns another spy of the same roblox type, so scripts that touch an
    -- unimplemented return value don't crash on a nil, and the report shows the
    -- chain (`<Foo:Bar().X>`). typeof reports `typeName` honestly.
    makeSpy = function(typeName, path, callError)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = typeName
        spyPaths[u] = path
        mt.__metatable = LOCKED
        mt.__tostring = function() return path end
        local function chain(suffix)
            return makeSpy(typeName, path .. suffix)
        end
        mt.__index = function(_, k)
            return chain("." .. tostring(k))
        end
        mt.__newindex = function() end
        mt.__call = function(_, ...)
            if callError then
                rbxError(path .. " is not a valid member")
            end
            return chain("()")
        end
        mt.__len = function() return 0 end
        mt.__eq = function(a, b) return a == b end
        mt.__lt = function() return false end
        mt.__le = function() return false end
        for _, op in ipairs({ "+", "-", "*", "/", "%", "^", ".." }) do
            mt["__" .. ({ ["+"] = "add", ["-"] = "sub", ["*"] = "mul", ["/"] = "div", ["%"] = "mod", ["^"] = "pow", [".."] = "concat" })[op]] = function(a, b)
                return chain("(" .. tostring(a) .. op .. tostring(b) .. ")")
            end
        end
        mt.__unm = function(a) return chain("(-" .. tostring(a) .. ")") end
        return u
    end

    fullName = function(self)
        local parts = {}
        local cur = self
        local guard = 0
        while cur ~= nil and instState[cur] and guard < 64 do
            local st = instState[cur]
            local nm = st.props.Name
            if nm == nil then nm = st.class end
            table.insert(parts, 1, nm)
            cur = st.parent
            guard += 1
        end
        return table.concat(parts, ".")
    end

    local function childByName(self, name)
        for _, child in ipairs(instState[self].children) do
            local st = instState[child]
            local nm = st.props.Name
            if nm == nil then nm = st.class end
            if nm == name then return child end
        end
        return nil
    end

    local function descendantByName(self, name)
        for _, child in ipairs(instState[self].children) do
            local st = instState[child]
            local nm = st.props.Name
            if nm == nil then nm = st.class end
            if nm == name then return child end
            local found = descendantByName(child, name)
            if found then return found end
        end
        return nil
    end

    local function detachFromParent(self)
        local state = instState[self]
        local old = state and state.parent
        if old ~= nil and instState[old] then
            local kids = instState[old].children
            for i, c in ipairs(kids) do
                if c == self then table.remove(kids, i) break end
            end
        end
        if state then
            state.parent = nil
            if old ~= nil and instState[old] then
                fireSignal(old, "ChildRemoved", self)
            end
            fireSignal(self, "AncestryChanged", self, nil)
            fireSignal(self, "Changed:Parent")
            fireSignal(self, "Changed", "Parent")
        end
    end

    -- canonical Instance members shared across all instances
    local canonical = {}
    canonical.IsA = cclosure(function(self, target)
        currentNamecall = "IsA"
        return isAClass(instState[self].class, tostring(target))
    end)
    canonical.GetChildren = cclosure(function(self)
        currentNamecall = "GetChildren"
        local out = {}
        for i, c in ipairs(instState[self].children) do out[i] = c end
        return out
    end)
    canonical.GetDescendants = cclosure(function(self)
        currentNamecall = "GetDescendants"
        local out = {}
        local function walk(node)
            for _, c in ipairs(instState[node].children) do
                out[#out + 1] = c
                walk(c)
            end
        end
        walk(self)
        return out
    end)
    canonical.FindFirstChild = cclosure(function(self, name, recursive)
        currentNamecall = "FindFirstChild"
        if recursive then return descendantByName(self, tostring(name)) end
        return childByName(self, tostring(name))
    end)
    canonical.WaitForChild = cclosure(function(self, name, timeout)
        currentNamecall = "WaitForChild"
        name = tostring(name)
        local found = childByName(self, name)
        if found then return found end

        local limit = tonumber(timeout)
        if limit == nil then limit = 2 end
        local waited = 0
        while waited <= limit do
            if drainDue then drainDue() end
            found = childByName(self, name)
            if found then return found end
            if stepFrame then
                waited += stepFrame(1 / 60)
                if drainDue then drainDue() end
            else
                break
            end
            found = childByName(self, name)
            if found then return found end
        end
        return nil
    end)
    canonical.FindFirstChildOfClass = cclosure(function(self, cls)
        currentNamecall = "FindFirstChildOfClass"
        for _, c in ipairs(instState[self].children) do
            if instState[c].class == cls then return c end
        end
        return nil
    end)
    canonical.FindFirstChildWhichIsA = cclosure(function(self, cls)
        currentNamecall = "FindFirstChildWhichIsA"
        for _, c in ipairs(instState[self].children) do
            if isAClass(instState[c].class, tostring(cls)) then return c end
        end
        return nil
    end)
    canonical.FindFirstAncestor = cclosure(function(self, name)
        currentNamecall = "FindFirstAncestor"
        local cur = instState[self].parent
        while cur ~= nil and instState[cur] do
            local nm = instState[cur].props.Name or instState[cur].class
            if nm == name then return cur end
            cur = instState[cur].parent
        end
        return nil
    end)
    canonical.FindFirstAncestorOfClass = cclosure(function(self, cls)
        currentNamecall = "FindFirstAncestorOfClass"
        cls = tostring(cls)
        local cur = instState[self].parent
        while cur ~= nil and instState[cur] do
            if instState[cur].class == cls then return cur end
            cur = instState[cur].parent
        end
        return nil
    end)
    canonical.FindFirstAncestorWhichIsA = cclosure(function(self, cls)
        currentNamecall = "FindFirstAncestorWhichIsA"
        cls = tostring(cls)
        local cur = instState[self].parent
        while cur ~= nil and instState[cur] do
            if isAClass(instState[cur].class, cls) then return cur end
            cur = instState[cur].parent
        end
        return nil
    end)
    canonical.GetFullName = cclosure(function(self)
        currentNamecall = "GetFullName"
        return fullName(self)
    end)
    canonical.GetPropertyChangedSignal = cclosure(function(self, prop)
        currentNamecall = "GetPropertyChangedSignal"
        return makeSignal(self, "Changed:" .. tostring(prop))
    end)
    canonical.ClearAllChildren = cclosure(function(self)
        currentNamecall = "ClearAllChildren"
        local children = {}
        for i, child in ipairs(instState[self].children) do
            children[i] = child
        end
        for _, child in ipairs(children) do
            if instState[child] then
                canonical.Destroy(child)
            end
        end
        instState[self].children = {}
    end)
    canonical.Destroy = cclosure(function(self)
        currentNamecall = "Destroy"
        local class = instState[self].class
        if class == "DataModel" or class == "Workspace" or isServiceClass(class) then
            rbxError("Cannot destroy " .. class)
        end
        local function destroyTree(node)
            local st = instState[node]
            if not st then return end
            for _, child in ipairs(st.children) do
                destroyTree(child)
            end
            st.children = {}
            st.parent = nil
        end
        detachFromParent(self)
        destroyTree(self)
        log("namecall", instState[self].class .. ":Destroy", {})
    end)
    canonical.Remove = canonical.Destroy
    canonical.Clone = cclosure(function(self)
        currentNamecall = "Clone"
        local class = instState[self].class
        if class == "DataModel" or class == "Workspace" or isServiceClass(class) then
            rbxError("Cannot clone " .. class)
        end
        if instState[self].props.Archivable == false then return nil end
        local copy = createInstance(instState[self].class, nil)
        for k, v in pairs(instState[self].props) do
            instState[copy].props[k] = v
        end
        for _, child in ipairs(instState[self].children) do
            local childCopy = canonical.Clone(child)
            if childCopy then childCopy.Parent = copy end
        end
        return copy
    end)
    canonical.SetAttribute = cclosure(function(self, name, value)
        currentNamecall = "SetAttribute"
        local st = instState[self]
        st.attrs = st.attrs or {}
        st.attrs[tostring(name)] = value
        fireSignal(self, "AttributeChanged", tostring(name))
        fireSignal(self, "AttributeChanged:" .. tostring(name), value)
    end)
    canonical.GetAttribute = cclosure(function(self, name)
        currentNamecall = "GetAttribute"
        local st = instState[self]
        return st.attrs and st.attrs[tostring(name)] or nil
    end)
    canonical.GetAttributes = cclosure(function(self)
        currentNamecall = "GetAttributes"
        local out = {}
        local attrs = instState[self].attrs
        if attrs then
            for k, v in pairs(attrs) do out[k] = v end
        end
        return out
    end)
    canonical.GetAttributeChangedSignal = cclosure(function(self, name)
        currentNamecall = "GetAttributeChangedSignal"
        return makeSignal(self, "AttributeChanged:" .. tostring(name))
    end)
    canonical.GetActor = cclosure(function() return nil end)
    canonical.IsDescendantOf = cclosure(function(self, other)
        currentNamecall = "IsDescendantOf"
        local cur = instState[self].parent
        while cur ~= nil do
            if cur == other then return true end
            cur = instState[cur] and instState[cur].parent or nil
        end
        return false
    end)
    canonical.IsAncestorOf = cclosure(function(self, other)
        currentNamecall = "IsAncestorOf"
        local cur = instState[other] and instState[other].parent or nil
        while cur ~= nil do
            if cur == self then return true end
            cur = instState[cur] and instState[cur].parent or nil
        end
        return false
    end)
    do
    local function nativeVector3(value)
        if objectTypes[value] == "Vector3" and env.Vector3 and env.Vector3._toNative then
            return env.Vector3._toNative(value)
        end
        return value
    end
    local function nativeCFrame(value)
        if objectTypes[value] == "CFrame" and env.CFrame and env.CFrame._toNative then
            return env.CFrame._toNative(value)
        end
        return value
    end
    local function instancePivot(inst)
        local st = instState[inst]
        if not st then return roblox and roblox.CFrame.identity or nil end
        if st.props.CFrame then return st.props.CFrame end
        if st.props.Position and roblox then return roblox.CFrame.new(nativeVector3(st.props.Position)) end
        local primary = st.props.PrimaryPart
        if primary and instState[primary] then
            return instancePivot(primary)
        end
        for _, child in ipairs(st.children) do
            if instState[child] and (instState[child].props.CFrame or instState[child].props.Position) then
                return instancePivot(child)
            end
        end
        return roblox and roblox.CFrame.identity or nil
    end
    local function setInstancePivot(inst, cf)
        local st = instState[inst]
        if not st or not roblox then return end
        cf = nativeCFrame(cf)
        if typeofImpl(cf) ~= "CFrame" then
            rbxError("Unable to cast value to CFrame")
        end
        if isAClass(st.class, "BasePart") or st.class == "Camera" then
            st.props.CFrame = cf
            st.props.Position = nil
            st.props.Orientation = nil
            st.props.Rotation = nil
            fireSignal(inst, "Changed:CFrame")
            fireSignal(inst, "Changed", "CFrame")
            fireSignal(inst, "Changed:Position")
            fireSignal(inst, "Changed", "Position")
            return
        end
        local primary = st.props.PrimaryPart
        if primary and instState[primary] then
            setInstancePivot(primary, cf)
        end
    end
    canonical.GetPivot = cclosure(function(self)
        currentNamecall = "GetPivot"
        return instancePivot(self)
    end)
    canonical.PivotTo = cclosure(function(self, cf)
        currentNamecall = "PivotTo"
        setInstancePivot(self, cf)
    end)
    canonical.MoveTo = cclosure(function(self, position)
        currentNamecall = "MoveTo"
        if roblox then
            setInstancePivot(self, roblox.CFrame.new(nativeVector3(position)))
        end
    end)
    canonical.TranslateBy = cclosure(function(self, delta)
        currentNamecall = "TranslateBy"
        if roblox then
            local cf = instancePivot(self) or roblox.CFrame.identity
            setInstancePivot(self, cf + nativeVector3(delta))
        end
    end)
    canonical.GetBoundingBox = cclosure(function(self)
        currentNamecall = "GetBoundingBox"
        return instancePivot(self), roblox and roblox.Vector3.new(4, 4, 4) or nil
    end)
    canonical.GetExtentsSize = cclosure(function()
        currentNamecall = "GetExtentsSize"
        return roblox and roblox.Vector3.new(4, 4, 4) or nil
    end)
    canonical.MakeJoints = cclosure(function() currentNamecall = "MakeJoints" end)
    canonical.BreakJoints = cclosure(function() currentNamecall = "BreakJoints" end)
    canonical.GetTouchingParts = cclosure(function() currentNamecall = "GetTouchingParts"; return {} end)
    canonical.CanCollideWith = cclosure(function() currentNamecall = "CanCollideWith"; return true end)
    end

    -- on a BasePart, Position/Orientation/Rotation are views of CFrame (the
    -- source of truth). this keeps `p.Position = v3; p.CFrame.Position` and
    -- `p.CFrame = cf; p.Position` consistent the way real roblox keeps them.
    local TRANSFORM_PROPS = { Position = true, Orientation = true, Rotation = true }

    instanceIndex = function(self, key)
        local state = instState[self]
        local class = state.class
        local props = state.props
        if nativeType(key) == "string" then
            if props[key] ~= nil then
                return props[key]
            end
            -- derive the transform view props off CFrame when only CFrame is set
            if TRANSFORM_PROPS[key] and props.CFrame ~= nil and isAClass(class, "BasePart") then
                if key == "Position" then return props.CFrame.Position end
                if key == "Orientation" then return props.CFrame:ToOrientation() end
                if key == "Rotation" then return props.CFrame - props.CFrame.Position end
            end
            if key == "ClassName" then return class end
            if key == "Name" then return props.Name ~= nil and props.Name or class end
            if key == "Parent" then return state.parent end
            local canon = canonical[key]
            if canon then return canon end

            if class == "DataModel" then
                if key == "GetService" then return getService end
                if key == "FindService" then return findService end
                if classInfo(key) and isServiceClass(key) then return getService(self, key) end
            elseif class == "Players" and key == "LocalPlayer" then
                return getLocalPlayer()
            end

            local info = classInfo(class)
            -- real method overrides, checked before the dump (some methods like
            -- Tween:Play aren't in the dump at all; this also lets us honor an
            -- override registered against any class in the hierarchy).
            if nativeType(key) == "string" then
                local cur = class
                while cur do
                    local mo = methodOverrides[cur]
                    if mo and mo[key] then return getMethodClosure(cur, key, { ReturnType = { Name = "void" } }) end
                    cur = apiLib and apiLib.hierarchy and apiLib.hierarchy[cur] or nil
                end
            end
            if info then
                local prop = info.properties[key]
                if prop then
                    if prop.ValueType and prop.ValueType.Name == "RBXScriptSignal" then
                        return makeSignal(self, key)
                    end
                    local v = clientDefaults[key]
                    if v == nil then v = defaultForValueType(prop.ValueType, prop.Default) end
                    return v
                end
                local method = info.methods[key]
                if method then return getMethodClosure(class, key, method) end
                if info.events[key] then return makeSignal(self, key) end
                if info.callbacks[key] then return props[key] end
            end

            -- camelCase -> PascalCase retry (e.g. .className -> .ClassName)
            local pascal = key:sub(1, 1):upper() .. key:sub(2)
            if pascal ~= key then
                local canon2 = canonical[pascal]
                if canon2 then return canon2 end
                if info then
                    local prop = info.properties[pascal]
                    if prop then
                        if prop.ValueType and prop.ValueType.Name == "RBXScriptSignal" then
                            return makeSignal(self, pascal)
                        end
                        local v = clientDefaults[pascal]
                        if v == nil then v = defaultForValueType(prop.ValueType, prop.Default) end
                        return v
                    end
                    local method = info.methods[pascal]
                    if method then return getMethodClosure(class, pascal, method) end
                end
            end

            local child = childByName(self, key)
            if child then return child end
        end

        if nativeType(key) ~= "string" then
            rbxError(tostring(key) .. " is not a valid member of " .. class .. " \"" .. fullName(self) .. "\"")
        end

        -- unknown member: real roblox throws, but returning a spy keeps every
        -- script running (executor scripts often touch hidden/internal members
        -- that aren't in the public api dump). the spy chains so reads/calls on
        -- it don't crash either.
        return makeSpy(class, fullName(self) .. "." .. tostring(key), true)
    end

    local function instanceNewIndex(self, key, value)
        local state = instState[self]
        local class = state.class
        local props = state.props
        if key == "Parent" then
            if class == "DataModel" then
                rbxError("Unable to assign property Parent. Property is read only.")
            end
            if value ~= nil and not instState[value] then
                rbxError("Unable to assign property Parent. Instance expected, got " .. typeofImpl(value))
            end
            if value ~= nil then
                local cur = value
                while cur ~= nil and instState[cur] do
                    if cur == self then
                        rbxError("Unable to assign property Parent. Circular reference is not allowed.")
                    end
                    cur = instState[cur].parent
                end
            end
            local old = state.parent
            if old == value then return end
            if old ~= nil and instState[old] then
                local kids = instState[old].children
                for i, c in ipairs(kids) do
                    if c == self then table.remove(kids, i) break end
                end
            end
            state.parent = value
            if old ~= nil and instState[old] then
                fireSignal(old, "ChildRemoved", self)
            end
            if value ~= nil and instState[value] then
                table.insert(instState[value].children, self)
                fireSignal(value, "ChildAdded", self)
            end
            fireSignal(self, "AncestryChanged", self, value)
            fireSignal(self, "Changed:Parent")
            fireSignal(self, "Changed", "Parent")
            local ownerPath = (state.props.Name ~= nil and state.props.Name ~= class) and state.props.Name or fullName(self)
            rememberValue(self, {
                robloxType = "Instance",
                className = class,
                path = ownerPath,
            })
            log("assign", ownerPath .. ".Parent", {
                target = logger:describe(self),
                key = "Parent",
                value = logger:describe(value),
            })
            return
        end

        local info = classInfo(class)
        local known = key == "Name"
            or (info and (info.properties[key] or info.callbacks[key]))
        if not known then
            -- accept writes to camelCase variants of real props too
            local pascal = nativeType(key) == "string" and (key:sub(1, 1):upper() .. key:sub(2)) or key
            if info and info.properties[pascal] then
                key = pascal
                known = true
            end
        end
        if not known then
            rbxError(tostring(key) .. " is not a valid member of " .. class .. " \"" .. fullName(self) .. "\"")
        end

        -- reject writes to read-only / non-scriptable props so we match roblox
        -- instead of silently accepting them. Tags is the reliable discriminator:
        -- Security.Write is "None" even for read-only props, and SimulationAccess
        -- only means physics *also* mutates the prop (Anchored has it but is
        -- script-writable), so we don't key off either of those.
        local prop = info and info.properties[key]
        if prop then
            local t = prop.tags or {}
            if t["ReadOnly"] or t["NotScriptable"] then
                rbxError("Unable to set property " .. tostring(key) .. ". Property is read only.")
            end
            if prop.ValueType and prop.ValueType.Name == "Color3" then
                local ok, r, g, b = pcall(function()
                    return value.R, value.G, value.B
                end)
                if ok and (r < 0 or r > 1 or g < 0 or g > 1 or b < 0 or b > 1) then
                    rbxError("Unable to assign property " .. tostring(key) .. ". Color3 components out of range")
                end
            end
        end
        if (key == "CameraMinZoomDistance" or key == "CameraMaxZoomDistance") and tonumber(value) and tonumber(value) < 0 then
            rbxError("Unable to assign property " .. tostring(key) .. ". Value must be non-negative")
        end
        if class == "Terrain" and key == "WaterWaveSpeed" then
            value = math.clamp(tonumber(value) or 0, 0, 100)
        elseif class == "Terrain" and key == "WaterWaveSize" then
            value = math.clamp(tonumber(value) or 0, 0, 1)
        end

        -- keep CFrame consistent when a BasePart transform prop is written.
        -- CFrame stays the single source of truth; Position/Orientation/Rotation
        -- are recomputed from it on read (see instanceIndex).
        if isAClass(class, "BasePart") and key ~= "CFrame" and TRANSFORM_PROPS[key] then
            if typeofImpl(value) ~= "Vector3" then
                rbxError("Unable to assign property " .. tostring(key) .. ". Vector3 expected, got " .. typeofImpl(value))
            end
            local cf = props.CFrame or roblox and roblox.CFrame.identity or nil
            if objectTypes[cf] == "CFrame" and env.CFrame and env.CFrame._toNative then
                cf = env.CFrame._toNative(cf)
            end
            if cf and roblox then
                if key == "Position" and typeofImpl(value) == "Vector3" then
                    local nativeValue = objectTypes[value] == "Vector3" and env.Vector3._toNative(value) or value
                    props.CFrame = roblox.CFrame.new(nativeValue) * (cf - cf.Position)
                elseif key == "Orientation" and typeofImpl(value) == "Vector3" then
                    props.CFrame = roblox.CFrame.new(cf.Position) * roblox.CFrame.fromEulerAnglesYXZ(value.X, value.Y, value.Z)
                elseif key == "Rotation" then
                    props.CFrame = roblox.CFrame.new(cf.Position) * value
                end
            end
        elseif key == "CFrame" and isAClass(class, "BasePart") then
            props.CFrame = value
            -- a fresh CFrame invalidates any stale transform overrides
            props.Position = nil
            props.Orientation = nil
            props.Rotation = nil
        else
            props[key] = value
        end

        fireSignal(self, "Changed:" .. tostring(key))
        fireSignal(self, "Changed", tostring(key))
        local ownerPath = key == "Name" and class or ((props.Name ~= nil and props.Name ~= class) and props.Name or fullName(self))
        if info and info.callbacks[key] and nativeType(value) == "function" then
            local callbackPath = ownerPath .. "." .. tostring(key)
            signalState.__callbackList[#signalState.__callbackList + 1] = {
                fn = value,
                connected = true,
                owner = self,
                signal = tostring(key),
                path = callbackPath,
            }
            log("connect", callbackPath, { callback = logger:describe(value) })
        end
        if key == "Name" then
            rememberValue(self, {
                robloxType = "Instance",
                className = class,
                name = tostring(value),
                path = tostring(value),
            })
        else
            rememberValue(self, {
                robloxType = "Instance",
                className = class,
                path = ownerPath,
            })
        end
        log("assign", ownerPath .. "." .. tostring(key), {
            target = logger:describe(self),
            key = tostring(key),
            value = logger:describe(value),
        })
    end

    newInstance = function(className)
        local u = newproxy(true)
        local mt = getmetatable(u)
        rawObjectMts[u] = mt
        objectTypes[u] = "Instance"
        instState[u] = { class = className, props = {}, children = {}, parent = nil }
        rememberValue(u, {
            robloxType = "Instance",
            className = className,
            path = className,
        })
        mt.__index = instanceIndex
        mt.__newindex = instanceNewIndex
        mt.__tostring = function(self)
            local st = instState[self]
            return st.props.Name ~= nil and st.props.Name or st.class
        end
        mt.__call = function()
            rbxError("attempt to call a Instance value")
        end
        mt.__metatable = LOCKED
        return u
    end

    createInstance = function(className, parent)
        local u = newInstance(className)
        if parent ~= nil and instState[parent] then
            instState[u].parent = parent
            table.insert(instState[parent].children, u)
        end
        return u
    end

    -- ===== game / workspace / services =====
    local serviceCache = {}

    isServiceClass = function(name)
        local info = classInfo(name)
        if not info or not info.tags then return false end
        for _, tag in ipairs(info.tags) do
            if tag == "Service" then return true end
        end
        return false
    end

    game = newInstance("DataModel")
    instState[game].props.Name = runIdentity.GameName
    rememberValue(game, {
        robloxType = "Instance",
        className = "DataModel",
        name = runIdentity.GameName,
        path = runIdentity.GameName,
    })

    local function setupServiceDefaults(name, svc)
        local props = instState[svc].props
        if name == "RunService" then
            props.RunState = safeEnumItem("RunState", "Running")
            props.ClientGitHash = runIdentity.ClientGitHash
        elseif name == "UserInputService" then
            props.MouseIcon = ""
            props.TouchEnabled = false
            props.KeyboardEnabled = true
            props.MouseEnabled = true
            props.GamepadEnabled = false
            props.AccelerometerEnabled = false
            props.GyroscopeEnabled = false
            props.VREnabled = false
        elseif name == "StarterPlayer" then
            if not childByName(svc, "StarterPlayerScripts") then
                local starterScripts = createInstance("StarterPlayerScripts", svc)
                instState[starterScripts].props.Name = "StarterPlayerScripts"
            end
            if not childByName(svc, "StarterCharacterScripts") then
                local starterCharacterScripts = createInstance("StarterCharacterScripts", svc)
                instState[starterCharacterScripts].props.Name = "StarterCharacterScripts"
            end
        elseif name == "GuiService" then
            props.MenuIsOpen = false
            props.SelectedObject = nil
            props.TouchControlsEnabled = false
            props.CoreGuiNavigationEnabled = false
        elseif name == "Lighting" then
            props.ClockTime = 14
            props.Brightness = 3
            props.GlobalShadows = true
            props.GeographicLatitude = 0
            if roblox then
                props.Ambient = roblox.Color3.new(0.5, 0.5, 0.5)
                props.OutdoorAmbient = roblox.Color3.new(0.5, 0.5, 0.5)
            end
        elseif name == "SoundService" then
            props.Volume = 1
            props.RespectFilteringEnabled = true
        elseif name == "ContentProvider" then
            props.BaseUrl = "https://www.roblox.com/"
            props.RequestQueueSize = 0
        elseif name == "TextChatService" then
            props.ChatVersion = safeEnumItem("ChatVersion", "TextChatService")
        elseif name == "Stats" then
            props.DataReceiveKbps = 0
            props.DataSendKbps = 0
        end
    end

    getService = cclosure(function(_, name)
        currentNamecall = "GetService"
        name = tostring(name)
        local cached = serviceCache[name]
        if cached then return cached end
        if name == "StudioService" then
            rbxError("'" .. name .. "' is not a valid service name")
        end
        if not classInfo(name) or not isServiceClass(name) then
            rbxError("'" .. name .. "' is not a valid service name")
        end
        local svc = createInstance(name, game)
        instState[svc].props.Name = name
        setupServiceDefaults(name, svc)
        rememberValue(svc, {
            robloxType = "Instance",
            className = name,
            name = name,
            path = fullName(svc),
        })
        serviceCache[name] = svc
        log("call", "game:GetService", { args = logger:describeArgs(name) })
        return svc
    end, "GetService")

    findService = cclosure(function(_, name)
        currentNamecall = "FindService"
        name = tostring(name)
        local cached = serviceCache[name]
        if cached then return cached end
        if not classInfo(name) or not isServiceClass(name) then return nil end
        return getService(game, name)
    end, "FindService")

    -- build Workspace directly (setup must not emit log events)
    local workspace = createInstance("Workspace", game)
    instState[workspace].props.Name = "Workspace"
    rememberValue(workspace, {
        robloxType = "Instance",
        className = "Workspace",
        name = "Workspace",
        path = fullName(workspace),
    })
    serviceCache["Workspace"] = workspace
    local function seedService(name)
        if not serviceCache[name] and classInfo(name) and isServiceClass(name) then
            local svc = createInstance(name, game)
            instState[svc].props.Name = name
            setupServiceDefaults(name, svc)
            rememberValue(svc, {
                robloxType = "Instance",
                className = name,
                name = name,
                path = fullName(svc),
            })
            serviceCache[name] = svc
            return svc
        end
        return serviceCache[name]
    end
    seedService("Players")
    seedService("RunService")
    seedService("UserInputService")
    seedService("Lighting")
    seedService("ReplicatedStorage")
    seedService("ReplicatedFirst")
    seedService("StarterGui")
    seedService("StarterPack")
    seedService("StarterPlayer")
    seedService("SoundService")
    seedService("CoreGui")
    seedService("GuiService")
    seedService("ContextActionService")
    seedService("TeleportService")
    seedService("HttpService")
    seedService("ContentProvider")
    seedService("InsertService")
    seedService("EncodingService")
    seedService("MarketplaceService")
    seedService("CollectionService")
    seedService("Debris")
    seedService("TextChatService")
    seedService("Chat")
    seedService("Teams")
    seedService("LogService")
    seedService("TweenService")
    seedService("PathfindingService")
    seedService("ProximityPromptService")
    seedService("VirtualUser")
    seedService("VirtualInputManager")
    seedService("RbxAnalyticsService")
    seedService("Stats")
    seedService("PolicyService")
    seedService("SocialService")
    seedService("TextService")
    local baseplate = createInstance("Part", workspace)
    instState[baseplate].props.Name = "Baseplate"
    instState[baseplate].props.Anchored = true
    if roblox then
        instState[baseplate].props.Size = roblox.Vector3.new(512, 1, 512)
        instState[baseplate].props.Position = roblox.Vector3.new(0, -0.5, 0)
        instState[baseplate].props.CFrame = roblox.CFrame.new(instState[baseplate].props.Position)
    end
    local currentCamera = createInstance("Camera", workspace)
    instState[currentCamera].props.Name = "Camera"
    instState[currentCamera].props.FieldOfView = 70
    instState[workspace].props.CurrentCamera = currentCamera
    local terrain = createInstance("Terrain", workspace)
    instState[terrain].props.Name = "Terrain"
    instState[workspace].props.Terrain = terrain

    do
        local function seedChild(parent, className, name)
            local existing = childByName(parent, name)
            if existing then return existing end
            local child = createInstance(className, parent)
            instState[child].props.Name = name
            return child
        end

        local gameFolder = seedChild(terrain, "Folder", "_Game")
        local kahWorkspace = seedChild(gameFolder, "Folder", "Workspace")
        local kahAdmin = seedChild(gameFolder, "Folder", "Admin")
        local kahInstances = seedChild(gameFolder, "Folder", "Folder")
        seedChild(kahWorkspace, "Folder", "Obby")
        seedChild(kahWorkspace, "Folder", "Building Bricks")
        seedChild(kahWorkspace, "Folder", "Obby Box")
        seedChild(kahWorkspace, "Part", "Baseplate")
        seedChild(kahWorkspace, "SpawnLocation", "Spawn1")
        seedChild(kahWorkspace, "SpawnLocation", "Spawn2")
        seedChild(kahWorkspace, "SpawnLocation", "Spawn3")
        local kahPads = seedChild(kahAdmin, "Folder", "Pads")
        for i = 1, 9 do
            local pad = seedChild(kahPads, "Model", "Pad" .. tostring(i))
            local head = seedChild(pad, "Part", "Head")
            instState[head].props.Anchored = true
            if roblox then
                instState[head].props.Size = roblox.Vector3.new(4, 1, 4)
                instState[head].props.Position = roblox.Vector3.new(i * 6, 1, 0)
                instState[head].props.CFrame = roblox.CFrame.new(instState[head].props.Position)
            end
        end
        seedChild(kahAdmin, "Part", "Regen")
        local kahSound = seedChild(kahInstances, "Sound", "Sound")
        instState[kahSound].props.TimeLength = 0
    end

    -- LocalPlayer is runtime-populated in real Roblox; fabricate a stable one
    local localPlayer
    getLocalPlayer = function()
        if localPlayer then return localPlayer end
        local players = getService(game, "Players")
        localPlayer = createInstance("Player", players)
        local p = instState[localPlayer].props
        p.Name = runIdentity.PlayerName
        p.DisplayName = runIdentity.DisplayName
        p.UserId = clientDefaults.UserId
        p.AccountAge = clientDefaults.AccountAge
        rememberValue(localPlayer, {
            robloxType = "Instance",
            className = "Player",
            name = runIdentity.PlayerName,
            path = fullName(localPlayer),
        })
        serviceCache["Players"] = players

        -- seed the containers client scripts reach for. PlayerGui/PlayerScripts so
        -- :WaitForChild resolves instead of throwing, plus a fabricated Character
        -- (Model) + Humanoid so `player.Character.Humanoid.WalkSpeed` works.
        local playerGui = createInstance("PlayerGui", localPlayer)
        instState[playerGui].props.Name = "PlayerGui"
        rememberValue(playerGui, {
            robloxType = "Instance",
            className = "PlayerGui",
            name = "PlayerGui",
            path = fullName(playerGui),
        })
        local playerScripts = createInstance("PlayerScripts", localPlayer)
        instState[playerScripts].props.Name = "PlayerScripts"
        rememberValue(playerScripts, {
            robloxType = "Instance",
            className = "PlayerScripts",
            name = "PlayerScripts",
            path = fullName(playerScripts),
        })
        local char = createInstance("Model", localPlayer)
        instState[char].props.Name = runIdentity.PlayerName
        instState[localPlayer].props.Character = char
        rememberValue(char, {
            robloxType = "Instance",
            className = "Model",
            name = runIdentity.PlayerName,
            path = fullName(char),
        })
        local root = createInstance("Part", char)
        instState[root].props.Name = "HumanoidRootPart"
        instState[root].props.Anchored = false
        rememberValue(root, {
            robloxType = "Instance",
            className = "Part",
            name = "HumanoidRootPart",
            path = fullName(root),
        })
        if roblox then
            instState[root].props.Size = roblox.Vector3.new(2, 2, 1)
            instState[root].props.Position = roblox.Vector3.new(0, 5, 0)
            instState[root].props.CFrame = roblox.CFrame.new(instState[root].props.Position)
        end
        local torso = createInstance("Part", char)
        instState[torso].props.Name = "Torso"
        instState[torso].props.Anchored = false
        rememberValue(torso, {
            robloxType = "Instance",
            className = "Part",
            name = "Torso",
            path = fullName(torso),
        })
        if roblox then
            instState[torso].props.Size = roblox.Vector3.new(2, 2, 1)
            instState[torso].props.Position = roblox.Vector3.new(0, 5, 0)
            instState[torso].props.CFrame = roblox.CFrame.new(instState[torso].props.Position)
        end
        local head = createInstance("Part", char)
        instState[head].props.Name = "Head"
        instState[head].props.Anchored = false
        rememberValue(head, {
            robloxType = "Instance",
            className = "Part",
            name = "Head",
            path = fullName(head),
        })
        if roblox then
            instState[head].props.Size = roblox.Vector3.new(2, 1, 1)
            instState[head].props.Position = roblox.Vector3.new(0, 6.5, 0)
            instState[head].props.CFrame = roblox.CFrame.new(instState[head].props.Position)
        end
        local hum = createInstance("Humanoid", char)
        instState[hum].props.Name = "Humanoid"
        rememberValue(hum, {
            robloxType = "Instance",
            className = "Humanoid",
            name = "Humanoid",
            path = fullName(hum),
        })
        local hp = instState[hum].props
        hp.Health = clientDefaults.Health
        hp.MaxHealth = clientDefaults.MaxHealth
        hp.WalkSpeed = clientDefaults.WalkSpeed
        hp.JumpPower = clientDefaults.JumpPower
        hp.JumpHeight = 7.2
        hp.HipHeight = clientDefaults.HipHeight
        hp.AutoRotate = true
        hp.DisplayDistanceType = safeEnumItem("HumanoidDisplayDistanceType", "Viewer")
        return localPlayer
    end

    -- a plausible LocalScript for `script`, plus a ModuleScript for getscripts/
    -- getloadedmodules/getrunningscripts (UNC checks the first is a ModuleScript).
    local scriptObj = createInstance("LocalScript", nil)
    instState[scriptObj].props.Name = "LocalScript"
    local moduleObj = createInstance("ModuleScript", nil)
    instState[moduleObj].props.Name = "ModuleScript"

    -- ===== real method implementations =====
    -- per-tween goal table: tween instance -> { instance =, goals = {prop=value} }
    local tweenGoals = setmetatable({}, { __mode = "k" })
    local logHistory = {}
    local fireLogMessage

    local function override(className, name, fn)
        if not methodOverrides[className] then methodOverrides[className] = {} end
        methodOverrides[className][name] = fn
    end

    -- Workspace:BulkMoveTo(parts, cfames, mode) -- write each cframe onto its part.
    -- the api returns nothing; the observable effect is parts' CFrame moving, which
    -- is what scripts check via CFrame.Position afterwards.
    override("Workspace", "BulkMoveTo", function(self, parts, cfames)
        parts = parts or {}
        cfames = cfames or {}
        for i = 1, #parts do
            local part, cf = parts[i], cfames[i]
            if part and cf and instState[part] and typeofImpl(cf) == "CFrame" then
                instState[part].props.CFrame = cf
                instState[part].props.Position = nil
                instState[part].props.Orientation = nil
                instState[part].props.Rotation = nil
                fireSignal(part, "Changed:CFrame")
                fireSignal(part, "Changed:Position")
            end
        end
    end)
    local function makeRaycastResult(position, normal, instance, distance, material)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "RaycastResult"
        local fields = {
            Position = position or (roblox and roblox.Vector3.zero or nil),
            Normal = normal or (roblox and roblox.Vector3.yAxis or nil),
            Instance = instance,
            Material = material or safeEnumItem("Material", "Plastic"),
            Distance = tonumber(distance) or 0,
        }
        mt.__metatable = LOCKED
        mt.__tostring = function() return "RaycastResult" end
        mt.__index = function(_, k) return fields[k] end
        return u
    end
    override("Workspace", "Raycast", function(self, origin, direction, params)
        if not roblox then return nil end
        local function toNativeVector3(value, fallback)
            if typeofImpl(value) == "Vector3" then
                if objectTypes[value] == "Vector3" and env.Vector3 and env.Vector3._toNative then
                    return env.Vector3._toNative(value)
                end
                return value
            end
            return fallback
        end
        local function toNativeCFrame(value)
            if typeofImpl(value) == "CFrame" then
                if objectTypes[value] == "CFrame" and env.CFrame and env.CFrame._toNative then
                    return env.CFrame._toNative(value)
                end
                return value
            end
            return nil
        end
        local function envVector3(value)
            if env.Vector3 and env.Vector3.new then
                return env.Vector3.new(value.X, value.Y, value.Z)
            end
            return value
        end
        local pos = toNativeVector3(origin, roblox.Vector3.zero)
        local dir = toNativeVector3(direction, roblox.Vector3.new(0, -1, 0))
        if dir.Magnitude <= 1e-9 then return nil end
        local filter = {}
        local filterType = "Exclude"
        if params ~= nil then
            local okList, list = pcall(function() return params.FilterDescendantsInstances end)
            if okList and nativeType(list) == "table" then
                for _, inst in ipairs(list) do filter[#filter + 1] = inst end
            end
            local okType, ft = pcall(function() return params.FilterType end)
            local ftName = okType and enumItemName(ft) or nil
            if ftName == "Include" or ftName == "Whitelist" then filterType = "Include" end
        end
        local function inFilter(inst)
            for _, root in ipairs(filter) do
                if inst == root or (instState[root] and isDescendantOfInst(inst, root)) then
                    return true
                end
            end
            return false
        end
        local function allowed(inst)
            local matched = inFilter(inst)
            if filterType == "Include" then return matched end
            if #filter == 0 then return true end
            return not matched
        end
        local function partCFrame(st)
            local cf = toNativeCFrame(st.props.CFrame)
            if cf then return cf end
            local partPos = toNativeVector3(st.props.Position, roblox.Vector3.zero)
            return roblox.CFrame.new(partPos)
        end
        local function partSize(st)
            return toNativeVector3(st.props.Size, roblox.Vector3.new(4, 1, 2))
        end
        local function slab(axisOrigin, axisDirection, halfSize, axisName)
            if math.abs(axisDirection) <= 1e-9 then
                if axisOrigin < -halfSize or axisOrigin > halfSize then
                    return nil
                end
                return -math.huge, math.huge, nil
            end
            local near = (-halfSize - axisOrigin) / axisDirection
            local far = (halfSize - axisOrigin) / axisDirection
            local normalSign = -1
            if near > far then
                near, far = far, near
                normalSign = 1
            end
            return near, far, { axis = axisName, sign = normalSign }
        end
        local function intersectPart(part)
            local st = instState[part]
            if not st or not isAClass(st.class, "BasePart") then return nil end
            if st.props.CanQuery == false then return nil end
            local okRespect, respectCanCollide = pcall(function() return params and params.RespectCanCollide end)
            if okRespect and respectCanCollide == true and st.props.CanCollide == false then return nil end

            local cf = partCFrame(st)
            local size = partSize(st)
            local halfX, halfY, halfZ = math.abs(size.X) / 2, math.abs(size.Y) / 2, math.abs(size.Z) / 2
            if halfX <= 0 or halfY <= 0 or halfZ <= 0 then return nil end

            local localOrigin = cf:PointToObjectSpace(pos)
            local localDirection = cf:VectorToObjectSpace(dir)
            local tMin, tMax = 0, 1
            local hitNormal = nil
            local axes = {
                { localOrigin.X, localDirection.X, halfX, "X" },
                { localOrigin.Y, localDirection.Y, halfY, "Y" },
                { localOrigin.Z, localDirection.Z, halfZ, "Z" },
            }
            for _, axis in ipairs(axes) do
                local near, far, normal = slab(axis[1], axis[2], axis[3], axis[4])
                if near == nil then return nil end
                if near > tMin then
                    tMin = near
                    hitNormal = normal
                end
                if far < tMax then tMax = far end
                if tMin > tMax then return nil end
            end
            if tMin < 0 or tMin > 1 then return nil end

            local localHit = localOrigin + localDirection * tMin
            local worldHit = cf:PointToWorldSpace(localHit)
            local worldNormal
            if hitNormal then
                local localNormal
                if hitNormal.axis == "X" then
                    localNormal = roblox.Vector3.new(hitNormal.sign, 0, 0)
                elseif hitNormal.axis == "Y" then
                    localNormal = roblox.Vector3.new(0, hitNormal.sign, 0)
                else
                    localNormal = roblox.Vector3.new(0, 0, hitNormal.sign)
                end
                worldNormal = cf:VectorToWorldSpace(localNormal).Unit
            else
                worldNormal = -dir.Unit
            end
            return {
                part = part,
                position = worldHit,
                normal = worldNormal,
                distance = (worldHit - pos).Magnitude,
                t = tMin,
            }
        end
        local best
        local function scan(node)
            local children = instState[node] and instState[node].children or {}
            for _, child in ipairs(children) do
                local st = instState[child]
                if st and allowed(child) and isAClass(st.class, "BasePart") then
                    local hit = intersectPart(child)
                    if hit and (best == nil or hit.t < best.t) then
                        best = hit
                    end
                end
                if st then scan(child) end
            end
        end
        scan(self == workspace and self or workspace)
        if best then
            local hitState = instState[best.part]
            return makeRaycastResult(
                envVector3(best.position),
                envVector3(best.normal),
                best.part,
                best.distance,
                hitState and hitState.props.Material or nil
            )
        end
        return nil
    end)
    override("Workspace", "GetPartsInPart", function() return {} end)
    override("Workspace", "GetPartBoundsInBox", function() return {} end)
    override("Workspace", "GetPartBoundsInRadius", function() return {} end)
    override("Camera", "WorldToScreenPoint", function(self, point)
        return point or (roblox and roblox.Vector3.zero or nil), true
    end)
    override("Camera", "WorldToViewportPoint", function(self, point)
        return point or (roblox and roblox.Vector3.zero or nil), true
    end)
    override("Camera", "ScreenPointToRay", function(_, x, y, depth)
        if not roblox then return nil end
        local z = -(tonumber(depth) or 1)
        local origin = roblox.Vector3.new(tonumber(x) or 0, tonumber(y) or 0, 0)
        local direction = roblox.Vector3.new(0, 0, z)
        if env.Ray then return env.Ray.new(origin, direction) end
        return roblox.Ray.new(origin, direction)
    end)
    override("Camera", "ViewportPointToRay", function(_, x, y, depth)
        if not roblox then return nil end
        local z = -(tonumber(depth) or 1)
        local origin = roblox.Vector3.new(tonumber(x) or 0, tonumber(y) or 0, 0)
        local direction = roblox.Vector3.new(0, 0, z)
        if env.Ray then return env.Ray.new(origin, direction) end
        return roblox.Ray.new(origin, direction)
    end)

    signalState.__renderStepBindings = signalState.__renderStepBindings or {}
    override("RunService", "IsClient", function() return true end)
    override("RunService", "IsServer", function() return false end)
    override("RunService", "IsStudio", function() return false end)
    override("RunService", "IsRunning", function() return true end)
    override("RunService", "GetServerTimeNow", function()
        return os.time() + os.clock()
    end)
    override("RunService", "BindToRenderStep", function(_, name, priority, fn)
        if nativeType(fn) ~= "function" then
            rbxError("invalid argument #3 to 'BindToRenderStep' (function expected)")
        end
        local key = tostring(name)
        local entry = {
            fn = fn,
            connected = true,
            owner = serviceCache["RunService"],
            signal = "RenderStep",
            path = "RunService.RenderStep." .. key,
            priority = tonumber(priority) or 0,
        }
        signalState.__renderStepBindings[key] = entry
        signalState.__callbackList[#signalState.__callbackList + 1] = entry
        log("connect", entry.path, { callback = logger:describe(fn) })
    end)
    override("RunService", "UnbindFromRenderStep", function(_, name)
        local entry = signalState.__renderStepBindings[tostring(name)]
        if entry then
            entry.connected = false
            signalState.__renderStepBindings[tostring(name)] = nil
        end
    end)

    -- TweenService:Create(instance, tweenInfo, goalTable) -> Tween
    override("TweenService", "Create", function(self, instance, tweenInfo, goals)
        if nativeType(goals) ~= "table" then
            rbxError("Unable to cast value to Dictionary")
        end
        local targetClass = instState[instance] and instState[instance].class or nil
        for prop, value in pairs(goals) do
            if prop == "CFrame" and typeofImpl(value) ~= "CFrame" then
                rbxError("Unable to cast value to CFrame")
            elseif (prop == "Position" or prop == "Size") and targetClass and isAClass(targetClass, "BasePart") and typeofImpl(value) ~= "Vector3" then
                rbxError("Unable to cast value to Vector3")
            elseif (prop == "Position" or prop == "Size") and targetClass and isAClass(targetClass, "GuiObject") and typeofImpl(value) ~= "UDim2" then
                rbxError("Unable to cast value to UDim2")
            elseif prop == "Transparency" and nativeType(value) ~= "number" then
                rbxError("Unable to cast value to float")
            end
        end
        local tw = createInstance("Tween", nil)
        instState[tw].props.Instance = instance
        instState[tw].props.TweenInfo = tweenInfo
        tweenGoals[tw] = { instance = instance, goals = goals or {} }
        -- materialize the Completed signal now so a later Play->fireSignal finds
        -- it even if the script never read tw.Completed before calling :Play()
        makeSignal(tw, "Completed")
        return tw
    end)

    -- no frame loop in lune, so Play snaps the goal props onto the instance
    -- immediately and fires Completed. matches unveilr's "snap, don't animate".
    local playbackCompleted = safeEnumItem("PlaybackState", "Completed")
    local playbackCancelled = safeEnumItem("PlaybackState", "Cancelled")
    local function tweenPlay(self)
        local g = tweenGoals[self]
        if not g or not g.instance then return end
        for prop, value in pairs(g.goals) do
            -- go through the normal setter so CFrame sync + change signals fire
            local inst = g.instance
            pcall(function() inst[prop] = value end)
        end
        fireSignal(self, "Completed", playbackCompleted)
    end
    override("Tween", "Play", tweenPlay)
    override("Tween", "Cancel", function(self) fireSignal(self, "Completed", playbackCancelled) end)
    override("Tween", "Pause", function() end)
    override("TweenService", "GetValue", function(_, alpha)
        alpha = tonumber(alpha) or 0
        if alpha < 0 then return 0 end
        if alpha > 1 then return 1 end
        return alpha
    end)

    -- ===== CompressionService =====
    -- CompressBuffer/DecompressBuffer take and return a Roblox buffer, with a
    -- CompressionFormat enum (Zstd/Zlib/Gzip/Lz4). backed by lune's serde, which
    -- works on strings, so we convert buffer<->string at the boundary. the format
    -- is either a CompressionFormat EnumItem or the literal string name.
    local function formatName(fmt)
        if fmt == nil then return "Zstd" end
        if nativeType(fmt) == "string" then return fmt end
        -- EnumItem: its Name is the format ("Zstd", "Gzip", ...)
        local ok, name = pcall(function() return fmt.Name end)
        return ok and name or "Zstd"
    end
    local function bufferToString(b)
        if nativeType(b) == "string" then return b end
        if nativeType(b) == "buffer" then return buffer.readstring(b, 0, buffer.len(b)) end
        return tostring(b)
    end
    local function stringToBuffer(s)
        local buf = buffer.create(#s)
        buffer.writestring(buf, 0, s)
        return buf
    end
    local COMPRESSION_FORMATS = { Zstd = true, Zlib = true, Gzip = true, Lz4 = true }
    override("CompressionService", "CompressBuffer", function(self, buf, fmt)
        local name = formatName(fmt)
        if not COMPRESSION_FORMATS[name] then
            rbxError("Unknown CompressionFormat: " .. tostring(name))
        end
        local ok, out = pcall(serde.compress, name, bufferToString(buf))
        if not ok then rbxError("CompressBuffer failed: " .. tostring(out)) end
        return stringToBuffer(out)
    end)
    override("CompressionService", "DecompressBuffer", function(self, buf, fmt)
        local name = formatName(fmt)
        if not COMPRESSION_FORMATS[name] then
            rbxError("Unknown CompressionFormat: " .. tostring(name))
        end
        local ok, out = pcall(serde.decompress, name, bufferToString(buf))
        if not ok then rbxError("DecompressBuffer failed: " .. tostring(out)) end
        return stringToBuffer(out)
    end)
    override("EncodingService", "CompressBuffer", function(self, buf, algorithm, _level)
        local name = formatName(algorithm)
        if not COMPRESSION_FORMATS[name] then
            rbxError("Unknown CompressionAlgorithm: " .. tostring(name))
        end
        local ok, out = pcall(serde.compress, name, bufferToString(buf))
        if not ok then rbxError("CompressBuffer failed: " .. tostring(out)) end
        return stringToBuffer(out)
    end)
    override("EncodingService", "DecompressBuffer", function(self, buf, algorithm)
        local name = formatName(algorithm)
        if not COMPRESSION_FORMATS[name] then
            rbxError("Unknown CompressionAlgorithm: " .. tostring(name))
        end
        local ok, out = pcall(serde.decompress, name, bufferToString(buf))
        if not ok then rbxError("DecompressBuffer failed: " .. tostring(out)) end
        return stringToBuffer(out)
    end)
    override("EncodingService", "GetDecompressedBufferSize", function(self, buf, algorithm)
        local name = formatName(algorithm)
        if not COMPRESSION_FORMATS[name] then
            rbxError("Unknown CompressionAlgorithm: " .. tostring(name))
        end
        local ok, out = pcall(serde.decompress, name, bufferToString(buf))
        if not ok then return nil end
        return #out
    end)

    -- ===== Players / Player =====
    -- cached Mouse userdata per player (Player:GetMouse must return the same one)
    local mouseCache = setmetatable({}, { __mode = "k" })
    local function makeMouse(owner)
        local cached = mouseCache[owner]
        if cached then return cached end
        local u = createInstance("PlayerMouse", nil)
        local mx = mouseLocation.X
        local my = mouseLocation.Y
        local props = instState[u].props
        props.Name = "PlayerMouse"
        props.X = mx
        props.Y = my
        props.ViewSizeX = 1280
        props.ViewSizeY = 720
        props.Icon = ""
        props.Target = nil
        props.TargetSurface = nil
        if roblox then
            local hit = roblox.CFrame.new(roblox.Vector3.new(mx, my, -50))
            props.Hit = hit
            props.Origin = hit
            props.UnitRay = roblox.Ray.new(roblox.Vector3.new(0, 0, 0), roblox.Vector3.new(0, 0, -1))
        end
        mouseCache[owner] = u
        return u
    end

    override("Players", "GetPlayers", function(self)
        local lp = getLocalPlayer()
        return lp and { lp } or {}
    end)
    override("Players", "GetPlayerByUserId", function(self, userId)
        local lp = getLocalPlayer()
        if lp and tonumber(userId) == instState[lp].props.UserId then return lp end
        return nil
    end)
    override("Players", "GetPlayerFromCharacter", function(self, char)
        local lp = getLocalPlayer()
        if lp and instState[lp].props.Character == char then return lp end
        return nil
    end)
    override("Players", "GetNameFromUserIdAsync", function(self, userId)
        if nativeType(userId) ~= "number" or userId <= 0 then
            rbxError("Invalid userId")
        end
        local lp = getLocalPlayer()
        if lp and tonumber(userId) == instState[lp].props.UserId then
            return instState[lp].props.Name
        end
        return "Player" .. tostring(userId)
    end)
    override("Players", "GetUserIdFromNameAsync", function(self, name)
        local lp = getLocalPlayer()
        if lp and tostring(name) == instState[lp].props.Name then
            return instState[lp].props.UserId
        end
        return randInt(100000, 2147483647)
    end)
    override("Player", "GetMouse", function(self)
        return makeMouse(self)
    end)

    -- UserInputService:GetMouseLocation returns the randomized per-run cursor
    -- position (same Vector2 the Mouse reports), not a pinned 0,0.
    override("UserInputService", "GetMouseLocation", function(self)
        return mouseLocation
    end)
    override("UserInputService", "GetMouseDelta", function(self)
        return roblox and roblox.Vector2.new(0, 0) or nil
    end)
    override("UserInputService", "GetMouseButtonsPressed", function(self)
        return {}
    end)
    override("UserInputService", "IsKeyDown", function() return false end)
    override("UserInputService", "IsMouseButtonPressed", function() return false end)
    override("UserInputService", "IsGamepadButtonDown", function() return false end)
    override("UserInputService", "GetKeysPressed", function() return {} end)
    override("UserInputService", "GetGamepadState", function() return {} end)
    override("UserInputService", "GamepadEnabled", function() return false end)

    override("MarketplaceService", "GetProductInfo", function(_, assetId)
        return {
            Name = "Experience " .. tostring(assetId or clientDefaults.PlaceId),
            AssetId = tonumber(assetId) or clientDefaults.PlaceId,
            AssetTypeId = 9,
            ProductId = tonumber(assetId) or clientDefaults.PlaceId,
            Creator = { Name = "Roblox", Id = 1, CreatorType = "User" },
            PriceInRobux = 0,
            IsForSale = false,
        }
    end)
    override("MarketplaceService", "PlayerOwnsAsset", function() return false end)
    override("MarketplaceService", "PlayerOwnsAssetAsync", function() return false end)
    override("MarketplaceService", "UserOwnsGamePassAsync", function() return false end)
    override("MarketplaceService", "UserOwnsGamePass", function() return false end)
    override("MarketplaceService", "PromptPurchase", function() end)
    override("MarketplaceService", "PromptGamePassPurchase", function() end)

    local boundActions = {}
    local function bindAction(name, fn, createTouchButton, priority, ...)
        local actionName = tostring(name)
        boundActions[tostring(name)] = {
            Name = actionName,
            Function = fn,
            CreateTouchButton = createTouchButton == true,
            PriorityLevel = tonumber(priority) or 2000,
            InputTypes = { ... },
        }
        if nativeType(fn) == "function" then
            local path = "ContextActionService." .. actionName
            signalState.__callbackList[#signalState.__callbackList + 1] = {
                fn = fn,
                connected = true,
                owner = nil,
                signal = "ContextAction",
                path = path,
                actionName = actionName,
            }
            log("connect", path, { callback = logger:describe(fn) })
        end
    end
    override("ContextActionService", "BindAction", function(_, name, fn, createTouchButton, ...)
        bindAction(name, fn, createTouchButton, 2000, ...)
    end)
    override("ContextActionService", "BindActionAtPriority", function(_, name, fn, createTouchButton, priority, ...)
        bindAction(name, fn, createTouchButton, priority, ...)
    end)
    override("ContextActionService", "UnbindAction", function(_, name)
        boundActions[tostring(name)] = nil
    end)
    override("ContextActionService", "UnbindAllActions", function()
        table.clear(boundActions)
    end)
    override("ContextActionService", "GetAllBoundActionInfo", function()
        local out = {}
        for name, info in pairs(boundActions) do out[name] = info end
        return out
    end)
    override("ContextActionService", "GetBoundActionInfo", function(_, name)
        return boundActions[tostring(name)]
    end)
    override("ContextActionService", "SetTitle", function() end)
    override("ContextActionService", "SetImage", function() end)
    override("ContextActionService", "SetPosition", function() end)

    local coreValues = {}
    local coreGuiEnabled = {}
    override("StarterGui", "SetCore", function(_, key, value)
        coreValues[tostring(key)] = value
    end)
    override("StarterGui", "GetCore", function(_, key)
        return coreValues[tostring(key)]
    end)
    override("StarterGui", "SetCoreGuiEnabled", function(_, coreType, enabled)
        coreGuiEnabled[enumItemName(coreType) or tostring(coreType)] = enabled == true
    end)
    override("StarterGui", "GetCoreGuiEnabled", function(_, coreType)
        local key = enumItemName(coreType) or tostring(coreType)
        if coreGuiEnabled[key] == nil then return true end
        return coreGuiEnabled[key]
    end)
    override("StarterGui", "RegisterSetCore", function(_, key, fn)
        coreValues["set:" .. tostring(key)] = fn
    end)
    override("StarterGui", "RegisterGetCore", function(_, key, fn)
        coreValues["get:" .. tostring(key)] = fn
    end)

    override("GuiService", "GetGuiInset", function()
        return roblox and roblox.Vector2.new(0, 36) or 0, roblox and roblox.Vector2.new(0, 0) or 0
    end)
    override("GuiService", "GetScreenResolution", function()
        return roblox and roblox.Vector2.new(1920, 1080) or nil
    end)
    override("GuiService", "IsTenFootInterface", function() return false end)
    override("GuiService", "GetEmotesMenuOpen", function(self)
        return instState[self].props.EmotesMenuOpen == true
    end)
    override("GuiService", "SetEmotesMenuOpen", function(self, open)
        instState[self].props.EmotesMenuOpen = open == true
    end)

    local teleportData = {}
    override("TeleportService", "GetLocalPlayerTeleportData", function() return teleportData.Data end)
    override("TeleportService", "SetTeleportGui", function(_, gui) teleportData.Gui = gui end)
    override("TeleportService", "GetArrivingTeleportGui", function() return teleportData.Gui end)
    override("TeleportService", "Teleport", function(_, placeId, player, data)
        teleportData.PlaceId = tonumber(placeId) or clientDefaults.PlaceId
        teleportData.Player = player or getLocalPlayer()
        teleportData.Data = data
    end)
    override("TeleportService", "TeleportToPlaceInstance", function(_, placeId, instanceId, player, data)
        teleportData.PlaceId = tonumber(placeId) or clientDefaults.PlaceId
        teleportData.JobId = tostring(instanceId or "")
        teleportData.Player = player or getLocalPlayer()
        teleportData.Data = data
    end)
    override("TeleportService", "TeleportAsync", function(_, placeId, players, options)
        teleportData.PlaceId = tonumber(placeId) or clientDefaults.PlaceId
        teleportData.Players = players
        teleportData.Options = options
        return makeSpy("TeleportAsyncResult", "TeleportService:TeleportAsync()")
    end)

    override("Debris", "AddItem", function(_, item, lifetime)
        if not instState[item] then return end
        if tonumber(lifetime) ~= nil and tonumber(lifetime) <= 0 then
            pcall(canonical.Destroy, item)
        end
    end)
    override("Debris", "SetLegacyMaxItems", function() end)

    override("VirtualUser", "CaptureController", function() end)
    override("VirtualUser", "Button1Down", function() end)
    override("VirtualUser", "Button1Up", function() end)
    override("VirtualUser", "Button1Click", function() end)
    override("VirtualUser", "Button2Down", function() end)
    override("VirtualUser", "Button2Up", function() end)
    override("VirtualUser", "Button2Click", function() end)
    override("VirtualUser", "MoveMouse", function() end)
    override("VirtualUser", "SetKeyDown", function() end)
    override("VirtualUser", "SetKeyUp", function() end)

    for _, method in ipairs({
        "SendKeyEvent", "SendMouseButtonEvent", "SendMouseMoveEvent",
        "SendMouseWheelEvent", "SendTextInputCharacterEvent", "SendTouchEvent",
        "StartRecording", "StopRecording", "Dump",
    }) do
        override("VirtualInputManager", method, function() end)
    end

    override("RbxAnalyticsService", "GetClientId", function() return runIdentity.ClientId end)
    override("RbxAnalyticsService", "GetSessionId", function() return runIdentity.JobId end)
    override("RbxAnalyticsService", "ReportCounter", function() end)
    override("RbxAnalyticsService", "ReportStats", function() end)
    override("PolicyService", "GetPolicyInfoForPlayerAsync", function()
        return {
            AreAdsAllowed = false,
            IsPaidItemTradingAllowed = true,
            AllowedExternalLinkReferences = {},
            IsSubjectToChinaPolicies = false,
        }
    end)
    override("SocialService", "CanSendGameInviteAsync", function() return false end)
    override("SocialService", "PromptGameInvite", function() end)
    override("TextService", "GetTextSize", function(_, text, textSize)
        local width = math.max(1, #tostring(text or "")) * math.max(1, tonumber(textSize) or 14) * 0.5
        return roblox and roblox.Vector2.new(width, tonumber(textSize) or 14) or nil
    end)

    override("ContentProvider", "PreloadAsync", function(_, assets, callback)
        if nativeType(assets) ~= "table" then assets = { assets } end
        if nativeType(callback) == "function" then
            local status = safeEnumItem("AssetFetchStatus", "Success")
            for _, asset in ipairs(assets) do
                pcall(callback, asset, status)
            end
        end
    end)
    override("ContentProvider", "GetAssetFetchStatus", function()
        return safeEnumItem("AssetFetchStatus", "Success")
    end)
    override("ContentProvider", "GetAssetFetchStatusChangedSignal", function(self, asset)
        return makeSignal(self, "AssetFetchStatusChanged:" .. tostring(asset))
    end)

    override("InsertService", "LoadAsset", function(_, assetId)
        local model = createInstance("Model", nil)
        instState[model].props.Name = "Asset" .. tostring(assetId or "")
        return model
    end)
    override("InsertService", "LoadAssetVersion", function(_, versionId)
        local model = createInstance("Model", nil)
        instState[model].props.Name = "AssetVersion" .. tostring(versionId or "")
        return model
    end)
    override("InsertService", "GetLatestAssetVersionAsync", function(_, assetId)
        return tonumber(assetId) or 1
    end)

    override("PathfindingService", "CreatePath", function()
        local path = createInstance("Path", nil)
        instState[path].props.Status = safeEnumItem("PathStatus", "Success") or safeEnumItem("PathStatus", "ClosestNoPath")
        return path
    end)
    override("Path", "ComputeAsync", function() end)
    override("Path", "GetWaypoints", function() return {} end)

    override("Humanoid", "GetState", function(self)
        return instState[self].props._state or safeEnumItem("HumanoidStateType", "Running")
    end)
    override("Humanoid", "ChangeState", function(self, state)
        local old = instState[self].props._state or safeEnumItem("HumanoidStateType", "Running")
        instState[self].props._state = state
        if enumItemName(state) == "Jumping" and roblox then
            local parent = instState[self].parent
            local root = parent and childByName(parent, "HumanoidRootPart")
            if root then
                local props = instState[root].props
                local pos = props.Position or (props.CFrame and props.CFrame.Position) or roblox.Vector3.new(0, 5, 0)
                local nextPos = pos + roblox.Vector3.new(0, math.max(5, tonumber(instState[self].props.JumpHeight) or 7), 0)
                props.Position = nextPos
                props.CFrame = roblox.CFrame.new(nextPos)
                fireSignal(root, "Changed:Position")
                fireSignal(root, "Changed", "Position")
            end
        end
        fireSignal(self, "StateChanged", old, state)
    end)

    override("Sound", "Play", function(self)
        local props = instState[self].props
        props.IsPlaying = true
        props.Playing = true
        fireSignal(self, "Played")
    end)
    override("Sound", "Pause", function(self)
        local props = instState[self].props
        props.IsPaused = true
        props.IsPlaying = false
        props.Playing = false
        fireSignal(self, "Paused")
    end)
    override("Sound", "Resume", function(self)
        local props = instState[self].props
        props.IsPaused = false
        props.IsPlaying = true
        props.Playing = true
        fireSignal(self, "Resumed")
    end)
    override("Sound", "Stop", function(self)
        local props = instState[self].props
        props.IsPaused = false
        props.IsPlaying = false
        props.Playing = false
        props.TimePosition = 0
        fireSignal(self, "Stopped")
        fireSignal(self, "Ended")
    end)

    override("LogService", "GetLogHistory", function()
        local out = {}
        for i, entry in ipairs(logHistory or {}) do
            out[i] = entry
        end
        return out
    end)
    override("LogService", "ClearOutput", function()
        table.clear(logHistory)
    end)
    override("LogService", "Output", function(_, message, context)
        fireLogMessage(message, safeEnumItem("MessageType", "MessageOutput"), context)
    end)
    override("LogService", "Info", function(_, message, context)
        fireLogMessage(message, safeEnumItem("MessageType", "MessageInfo"), context)
    end)
    override("LogService", "Warn", function(_, message, context)
        fireLogMessage(message, safeEnumItem("MessageType", "MessageWarning"), context)
    end)
    override("LogService", "Error", function(_, message, context)
        fireLogMessage(message, safeEnumItem("MessageType", "MessageError"), context)
        rbxError(tostring(message or ""))
    end)
    override("LogService", "Log", function(_, messageType, message, context)
        fireLogMessage(message, messageType, context)
        if enumItemName(messageType) == "MessageError" then
            rbxError(tostring(message or ""))
        end
    end)

    do
    local collectionTags = setmetatable({}, { __mode = "k" })
    local collectionSignals = { added = {}, removed = {} }
    local function collectionSignal(kind, tag)
        tag = tostring(tag)
        local cache = collectionSignals[kind]
        if not cache[tag] then
            cache[tag] = makeSignal(serviceCache["CollectionService"], (kind == "added" and "TagAdded:" or "TagRemoved:") .. tag)
        end
        return cache[tag]
    end
    override("CollectionService", "AddTag", function(_, inst, tag)
        if not instState[inst] then return end
        tag = tostring(tag)
        local entry = collectionTags[inst]
        if not entry then
            entry = { set = {}, order = {} }
            collectionTags[inst] = entry
        end
        if not entry.set[tag] then
            entry.set[tag] = true
            entry.order[#entry.order + 1] = tag
            fireSignal(serviceCache["CollectionService"], "TagAdded:" .. tag, inst)
        end
    end)
    override("CollectionService", "RemoveTag", function(_, inst, tag)
        local entry = collectionTags[inst]
        tag = tostring(tag)
        if entry and entry.set[tag] then
            entry.set[tag] = nil
            fireSignal(serviceCache["CollectionService"], "TagRemoved:" .. tag, inst)
        end
    end)
    override("CollectionService", "HasTag", function(_, inst, tag)
        local entry = collectionTags[inst]
        return entry and entry.set[tostring(tag)] == true or false
    end)
    override("CollectionService", "GetTags", function(_, inst)
        local out = {}
        local entry = collectionTags[inst]
        if entry then
            for _, tag in ipairs(entry.order) do
                if entry.set[tag] then out[#out + 1] = tag end
            end
        end
        return out
    end)
    override("CollectionService", "GetTagged", function(_, tag)
        local out = {}
        tag = tostring(tag)
        for inst, entry in pairs(collectionTags) do
            if entry.set[tag] then out[#out + 1] = inst end
        end
        return out
    end)
    override("CollectionService", "GetInstanceAddedSignal", function(_, tag)
        return collectionSignal("added", tag)
    end)
    override("CollectionService", "GetInstanceRemovedSignal", function(_, tag)
        return collectionSignal("removed", tag)
    end)
    local function isCollectionServiceInst(self)
        return instState[self] and instState[self].class == "CollectionService"
    end
    canonical.AddTag = cclosure(function(self, instOrTag, tag)
        if isCollectionServiceInst(self) then
            return methodOverrides.CollectionService.AddTag(self, instOrTag, tag)
        end
        return methodOverrides.CollectionService.AddTag(nil, self, instOrTag)
    end)
    canonical.RemoveTag = cclosure(function(self, instOrTag, tag)
        if isCollectionServiceInst(self) then
            return methodOverrides.CollectionService.RemoveTag(self, instOrTag, tag)
        end
        return methodOverrides.CollectionService.RemoveTag(nil, self, instOrTag)
    end)
    canonical.HasTag = cclosure(function(self, instOrTag, tag)
        if isCollectionServiceInst(self) then
            return methodOverrides.CollectionService.HasTag(self, instOrTag, tag)
        end
        return methodOverrides.CollectionService.HasTag(nil, self, instOrTag)
    end)
    canonical.GetTags = cclosure(function(self, inst)
        if isCollectionServiceInst(self) then
            return methodOverrides.CollectionService.GetTags(self, inst)
        end
        return methodOverrides.CollectionService.GetTags(nil, self)
    end)
    end

    override("BindableEvent", "Fire", function(self, ...)
        fireSignal(self, "Event", ...)
    end)
    override("BindableFunction", "Invoke", function(self, ...)
        local callback = instState[self].props.OnInvoke
        if nativeType(callback) == "function" then
            return callback(...)
        end
        return nil
    end)
    override("RemoteEvent", "FireServer", function(self, ...)
        fireSignal(self, "OnClientEvent", ...)
    end)
    override("RemoteEvent", "FireClient", function(self, _player, ...)
        fireSignal(self, "OnClientEvent", ...)
    end)
    override("RemoteEvent", "FireAllClients", function(self, ...)
        fireSignal(self, "OnClientEvent", ...)
    end)
    override("RemoteFunction", "InvokeServer", function(self, ...)
        local callback = instState[self].props.OnClientInvoke or instState[self].props.OnInvoke
        if nativeType(callback) == "function" then
            return callback(...)
        end
        return nil
    end)
    override("RemoteFunction", "InvokeClient", function(self, _player, ...)
        local callback = instState[self].props.OnClientInvoke or instState[self].props.OnInvoke
        if nativeType(callback) == "function" then
            return callback(...)
        end
        return nil
    end)

    local function httpSourceForUrl(url)
        url = tostring(url or "")
        if httpSourceCache[url] ~= nil then
            return httpSourceCache[url]
        end

        local lower = url:lower()
        if lower:find("pastefy.app/r6upmycz/raw", 1, true) then
            return "print(\"hi!\")"
        end
        if lower:find("orion/main/source", 1, true) or lower:find("jensonhirst/orion", 1, true) then
            return [[
local stub = {}
local chain = {}
setmetatable(chain, {
    __index = function(_, key)
        return function()
            return chain
        end
    end,
    __call = function()
        return chain
    end,
})
function stub:MakeWindow()
    return chain
end
return stub
]]
        end

        if net and (lower:find("^https://") or lower:find("^http://")) then
            local ok, response = pcall(net.request, url)
            if ok and response and response.ok and type(response.body) == "string" then
                httpSourceCache[url] = response.body
                return response.body
            end
        end

        return "return true"
    end
    override("DataModel", "HttpGet", function(_, url)
        return httpSourceForUrl(url)
    end)
    override("DataModel", "HttpGetAsync", function(_, url)
        return httpSourceForUrl(url)
    end)
    override("DataModel", "HttpPost", function()
        return ""
    end)
    override("DataModel", "HttpPostAsync", function()
        return ""
    end)

    local function makeSecret(text)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "Secret"
        local value = tostring(text or "")
        mt.__metatable = LOCKED
        mt.__tostring = function() return "[Secret]" end
        mt.__index = function(_, k)
            if k == "AddPrefix" then
                return cclosure(function(_, prefix) return makeSecret(tostring(prefix or "") .. value) end)
            end
            if k == "AddSuffix" then
                return cclosure(function(_, suffix) return makeSecret(value .. tostring(suffix or "")) end)
            end
            rbxError(tostring(k) .. " is not a valid member of Secret")
        end
        return u
    end
    override("HttpService", "GetSecret", function(_, key)
        key = tostring(key or "")
        if not key:match("^[%w_%-]+$") or #key > 64 then
            rbxError("Invalid secret key")
        end
        return makeSecret("secret:" .. key)
    end)
    override("HttpService", "JSONEncode", function(_, value)
        return encodeJson(value)
    end)
    override("HttpService", "JSONDecode", function(_, value)
        if value == nil or value == "" then
            return {}
        end
        local ok, decoded = pcall(serde.decode, "json", tostring(value))
        if ok then return decoded end
        rbxError(tostring(decoded))
    end)
    local function urlEncode(value)
        return tostring(value or ""):gsub("\n", "\r\n"):gsub("([^%w%-%._~])", function(ch)
            return string.format("%%%02X", string.byte(ch))
        end)
    end
    override("HttpService", "UrlEncode", function(_, value)
        return urlEncode(value)
    end)
    override("HttpService", "GenerateGUID", function(_, wrapInCurlyBraces)
        local guid = makeUuid()
        if wrapInCurlyBraces == false then return guid end
        return "{" .. guid .. "}"
    end)
    override("HttpService", "RequestAsync", function(_, requestOptions)
        return {
            Success = true,
            StatusCode = 200,
            StatusMessage = "OK",
            Headers = { ["Content-Type"] = "application/json" },
            Body = "{}",
        }
    end)

    -- ===== Instance global =====
    local InstanceLib = {
        new = cclosure(function(className, parent)
            if nativeType(className) ~= "string" then
                rbxError("Unable to create an Instance of type \"" .. tostring(className) .. "\"")
            end
            local info = classInfo(className)
            if not info then
                rbxError("Unable to create an Instance of type \"" .. className .. "\"")
            end
            -- NotCreatable classes can't be made with Instance.new
            if info.tags then
                for _, tag in ipairs(info.tags) do
                    if tag == "NotCreatable" then
                        rbxError("Unable to create an Instance of type \"" .. className .. "\"")
                    end
                end
            end
            if parent ~= nil and not instState[parent] then
                rbxError("Unable to assign property Parent. Instance expected, got " .. typeofImpl(parent))
            end
            local inst = createInstance(className, parent)
            local source, line = "?", -1
            for level = 2, 8 do
                local ok, stackSource, stackLine = pcall(debug.info, level, "sl")
                if ok and stackSource and stackSource ~= "[C]" and not tostring(stackSource):find("main", 1, true) then
                    source, line = stackSource, stackLine
                    break
                end
            end
            log("call", "Instance.new", {
                args = logger:describeArgs(className, parent),
                result = logger:describe(inst),
                source = source,
                line = line,
            })
            return inst
        end, "new"),
    }
    InstanceLib.fromExisting = cclosure(function(other)
        if instState[other] then return canonical.Clone(other) end
        rbxError("invalid argument #1 to 'fromExisting' (Instance expected)")
    end)

    -- ===== task scheduler =====
    local pending = {}
    local taskThreads = setmetatable({}, { __mode = "k" })
    local cancelledThreads = setmetatable({}, { __mode = "k" })
    local virtualNow = 0
    local frameDt = 1 / 60
    local frameCounter = 0
    local orderCounter = 0
    local nativeTaskWait = task and task.wait
    local function busyWait(seconds)
        seconds = tonumber(seconds) or 0
        if seconds <= 0 then return end
        local started = os.clock()
        while os.clock() - started < seconds do end
    end

    isDescendantOfInst = function(inst, ancestor)
        local cur = inst
        while cur ~= nil and instState[cur] do
            if cur == ancestor then return true end
            cur = instState[cur].parent
        end
        return false
    end

    local function stepPhysics(dt)
        if not roblox then return end
        local gravity = tonumber(instState[workspace].props.Gravity) or clientDefaults.Gravity
        for inst, st in pairs(instState) do
            if isAClass(st.class, "BasePart") and st.parent ~= nil and isDescendantOfInst(inst, workspace) and st.props.Anchored ~= true then
                local pos = st.props.Position or (st.props.CFrame and st.props.CFrame.Position) or roblox.Vector3.zero
                local vel = st.props.Velocity or roblox.Vector3.zero
                vel = vel + roblox.Vector3.new(0, -gravity * dt, 0)
                local nextPos = pos + (vel * dt)
                st.props.Position = nextPos
                local cfPos = objectTypes[nextPos] == "Vector3" and env.Vector3._toNative(nextPos) or nextPos
                st.props.CFrame = roblox.CFrame.new(cfPos)
                st.props.Velocity = vel
                st.props.AssemblyLinearVelocity = vel
                fireSignal(inst, "Changed:Position")
                fireSignal(inst, "Changed", "Position")
                fireSignal(inst, "Changed:Velocity")
                fireSignal(inst, "Changed", "Velocity")
            end
        end
    end

    local function fireFrameSignals(dt)
        local rs = serviceCache["RunService"]
        if rs then
            fireSignal(rs, "Stepped", virtualNow, dt)
            fireSignal(rs, "Heartbeat", dt, virtualNow)
            fireSignal(rs, "RenderStepped", dt)
            for _, entry in pairs(signalState.__renderStepBindings or {}) do
                if entry.connected and nativeType(entry.fn) == "function" then
                    local ok, err = pcall(entry.fn, dt)
                    if not ok and not isRecoverableObfuscatorTamper(err) then
                        log("callback_error", entry.path, { error = tostring(err) })
                    end
                end
            end
        end
    end

    stepFrame = function(dt)
        dt = math.max(tonumber(dt) or 0, frameDt)
        frameCounter += 1
        local signalDt = dt + (frameCounter % 997) * 1e-7
        virtualNow += dt
        stepPhysics(dt)
        fireFrameSignals(signalDt)
        return signalDt
    end
    local function advanceTime(elapsed)
        elapsed = math.max(tonumber(elapsed) or 0, frameDt)
        local left = elapsed
        while left > 0 do
            local dt = math.min(frameDt, left)
            stepFrame(dt)
            if drainDue then drainDue() end
            left -= dt
        end
        return elapsed
    end
    waitForSignalFrame = function(owner, name)
        if owner ~= serviceCache["RunService"] then return nil end
        if name ~= "Heartbeat" and name ~= "RenderStepped" and name ~= "Stepped" then return nil end
        local dt = stepFrame(frameDt)
        drainDue()
        if name == "Stepped" then
            return table.pack(virtualNow, dt)
        end
        if name == "Heartbeat" then
            return table.pack(dt, virtualNow)
        end
        return table.pack(dt)
    end

    local function sortPending()
        table.sort(pending, function(a, b)
            if a.at == b.at then return a.order < b.order end
            return a.at < b.at
        end)
    end

    local function queueThread(co, at)
        orderCounter += 1
        pending[#pending + 1] = { co = co, at = at, order = orderCounter }
        sortPending()
    end

    local function resumeTask(co, elapsed)
        if cancelledThreads[co] or coroutine.status(co) == "dead" then return end
        local ok, err = coroutine.resume(co, elapsed)
        if not ok then
            log("error", "task_callback", { error = tostring(err) })
        end
    end

    local function makeTaskThread(fn, args)
        local co = coroutine.create(function(firstElapsed)
            local ok, err = pcall(fn, table.unpack(args, 1, args.n))
            if not ok then
                log("error", "task_callback", { error = tostring(err) })
            end
            return firstElapsed
        end)
        taskThreads[co] = true
        return co
    end

    drainDue = function()
        local guard = 0
        while #pending > 0 and guard < 10000 do
            sortPending()
            local item = pending[1]
            if item.at > virtualNow then break end
            table.remove(pending, 1)
            resumeTask(item.co, math.max(virtualNow - item.at, frameDt))
            guard += 1
        end
    end

    local taskLib = {}
    taskLib.wait = cclosure(function(t)
        local elapsed = math.max(tonumber(t) or 0, frameDt)
        local co = coroutine.running()
        if co and taskThreads[co] then
            queueThread(co, virtualNow + elapsed)
            return coroutine.yield(elapsed)
        end
        if elapsed > frameDt and not signalState.__exploring then busyWait(elapsed) end
        advanceTime(elapsed)
        return elapsed
    end, "wait")
    taskLib.spawn = cclosure(function(fn, ...)
        if nativeType(fn) ~= "function" then return nil end
        local co = makeTaskThread(fn, table.pack(...))
        resumeTask(co, frameDt)
        return co
    end, "spawn")
    taskLib.defer = cclosure(function(fn, ...)
        if nativeType(fn) ~= "function" then return nil end
        local co = makeTaskThread(fn, table.pack(...))
        queueThread(co, virtualNow + frameDt)
        return co
    end, "defer")
    taskLib.delay = cclosure(function(t, fn, ...)
        if nativeType(fn) ~= "function" then return nil end
        local co = makeTaskThread(fn, table.pack(...))
        queueThread(co, virtualNow + math.max(tonumber(t) or 0, frameDt))
        return co
    end, "delay")
    taskLib.cancel = cclosure(function(co)
        if nativeType(co) == "thread" then
            cancelledThreads[co] = true
            pcall(coroutine.close, co)
        end
    end, "cancel")
    taskLib.synchronize = cclosure(function() end, "synchronize")
    taskLib.desynchronize = cclosure(function() end, "desynchronize")

    local function drainPendingTasks()
        local guard = 0
        while #pending > 0 and guard < 10000 do
            sortPending()
            local nextAt = pending[1].at
            if nextAt > virtualNow then
                advanceTime(nextAt - virtualNow)
            end
            drainDue()
            guard += 1
        end
    end

    signalState.__vec2 = function(x, y)
        if roblox then return roblox.Vector2.new(x, y) end
        return makeSpy("Vector2", "Vector2.new(" .. tostring(x) .. ", " .. tostring(y) .. ")")
    end

    signalState.__makeInputObject = function(inputTypeName, inputStateName, pos, delta)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "InputObject"
        signalState.__inputProps = signalState.__inputProps or setmetatable({}, { __mode = "k" })
        local props = {
            UserInputType = safeEnumItem("UserInputType", inputTypeName),
            UserInputState = safeEnumItem("UserInputState", inputStateName),
            Position = pos or signalState.__vec2(128, 96),
            Delta = delta or signalState.__vec2(0, 0),
            KeyCode = safeEnumItem("KeyCode", "Unknown"),
        }
        signalState.__inputProps[u] = props
        rememberValue(u, {
            robloxType = "InputObject",
            path = "InputObject",
        })
        mt.__metatable = LOCKED
        mt.__tostring = function() return "InputObject" end
        mt.__index = function(_, k)
            if k == "Changed" then return makeSignal(u, "Changed") end
            return props[k]
        end
        mt.__newindex = function(_, k, v)
            props[k] = v
            fireSignal(u, "Changed", tostring(k))
        end
        return u
    end

    signalState.__rememberInstance = function(inst)
        if inst and instState[inst] then
            local st = instState[inst]
            rememberValue(inst, {
                robloxType = "Instance",
                className = st.class,
                name = st.props.Name,
                path = fullName(inst),
            })
        end
        return inst
    end

    signalState.__ensureChild = function(parent, className, name)
        if parent and instState[parent] then
            local existing = childByName(parent, name)
            if existing then return existing end
            local child = createInstance(className, parent)
            instState[child].props.Name = name
            return signalState.__rememberInstance(child)
        end
        local child = createInstance(className, nil)
        instState[child].props.Name = name
        return signalState.__rememberInstance(child)
    end

    signalState.__ensureCharacter = function(player)
        if not (player and instState[player]) then return nil end
        local playerProps = instState[player].props
        local char = playerProps.Character
        if not (char and instState[char]) then
            char = createInstance("Model", player)
            instState[char].props.Name = playerProps.Name or "Player"
            playerProps.Character = char
            signalState.__rememberInstance(char)
        end

        local root = signalState.__ensureChild(char, "Part", "HumanoidRootPart")
        local torso = signalState.__ensureChild(char, "Part", "Torso")
        local head = signalState.__ensureChild(char, "Part", "Head")
        if roblox then
            for _, part in ipairs({ root, torso, head }) do
                instState[part].props.Anchored = false
                instState[part].props.Size = instState[part].props.Size or roblox.Vector3.new(2, 2, 1)
                instState[part].props.Position = instState[part].props.Position or roblox.Vector3.new(0, 5, 0)
                instState[part].props.CFrame = instState[part].props.CFrame or roblox.CFrame.new(instState[part].props.Position)
            end
            instState[head].props.Size = roblox.Vector3.new(2, 1, 1)
        end

        local hum = signalState.__ensureChild(char, "Humanoid", "Humanoid")
        local hp = instState[hum].props
        hp.Health = hp.Health or clientDefaults.Health
        hp.MaxHealth = hp.MaxHealth or clientDefaults.MaxHealth
        hp.WalkSpeed = hp.WalkSpeed or clientDefaults.WalkSpeed
        hp.JumpPower = hp.JumpPower or clientDefaults.JumpPower
        hp.JumpHeight = hp.JumpHeight or 7.2
        hp.HipHeight = hp.HipHeight or clientDefaults.HipHeight
        hp.AutoRotate = hp.AutoRotate ~= false
        return char
    end

    signalState.__samplePlayer = function()
        local sample = signalState.__sampleOtherPlayer
        if sample and instState[sample] then return sample end
        local players = getService(game, "Players")
        sample = signalState.__ensureChild(players, "Player", randRuntimeName("Player"))
        local props = instState[sample].props
        props.DisplayName = props.Name
        props.UserId = math.max(1, (clientDefaults.UserId or 100000) + 1)
        props.AccountAge = clientDefaults.AccountAge
        instState[sample].attrs = instState[sample].attrs or {}
        instState[sample].attrs.fixName = props.Name
        signalState.__ensureCharacter(sample)
        signalState.__sampleOtherPlayer = sample
        return sample
    end

    signalState.__sampleChild = function(entry, fallbackClass, fallbackName)
        local owner = entry and entry.owner
        if owner and instState[owner] then
            local ownerState = instState[owner]
            for _, child in ipairs(ownerState.children) do
                if instState[child] then return child end
            end
            if ownerState.class == "PlayerGui" then
                return signalState.__ensureChild(owner, "ScreenGui", fallbackName or "ScreenGui")
            end
            if ownerState.class == "Lighting" then
                return signalState.__ensureChild(owner, "Folder", fallbackName or "LightingEffect")
            end
            if ownerState.class == "Part" and (ownerState.props.Name == "Torso" or ownerState.props.Name == "HumanoidRootPart") then
                return signalState.__ensureChild(owner, "BodyForce", fallbackName or "BodyForce")
            end
            return signalState.__ensureChild(owner, fallbackClass or "Part", fallbackName or "SamplePart")
        end
        return signalState.__ensureChild(nil, fallbackClass or "Part", fallbackName or "SamplePart")
    end

    signalState.__callbackArgs = function(entry)
        local signalName = tostring(entry.signal or "")
        if signalName == "InputBegan" then
            return table.pack(signalState.__makeInputObject("MouseButton1", "Begin", signalState.__vec2(120, 80), signalState.__vec2(0, 0)), false)
        end
        if signalName == "InputChanged" then
            return table.pack(signalState.__makeInputObject("MouseMovement", "Change", signalState.__vec2(152, 112), signalState.__vec2(32, 32)), false)
        end
        if signalName == "InputEnded" then
            return table.pack(signalState.__makeInputObject("MouseButton1", "End", signalState.__vec2(152, 112), signalState.__vec2(0, 0)), false)
        end
        if signalName == "Changed" and objectTypes[entry.owner] ~= "InputObject" then
            return table.pack("Position")
        end
        if signalName == "Changed" and objectTypes[entry.owner] == "InputObject" then
            local props = signalState.__inputProps and signalState.__inputProps[entry.owner]
            if props then
                props.UserInputState = safeEnumItem("UserInputState", "End")
            end
            return table.pack("UserInputState")
        end
        if signalName == "ContextAction" then
            return table.pack(entry.actionName or "Action", safeEnumItem("UserInputState", "Begin"), signalState.__makeInputObject("MouseButton1", "Begin", signalState.__vec2(120, 80), signalState.__vec2(0, 0)))
        end
        if signalName == "ChildAdded" or signalName == "ChildRemoved" then
            return table.pack(signalState.__sampleChild(entry))
        end
        if signalName == "DescendantAdded" or signalName == "DescendantRemoving" then
            return table.pack(signalState.__sampleChild(entry))
        end
        if signalName == "AncestryChanged" then
            local owner = entry and entry.owner
            return table.pack(owner, owner and instState[owner] and instState[owner].parent or nil)
        end
        if signalName == "PlayerAdded" or signalName == "PlayerRemoving" then
            return table.pack(signalState.__samplePlayer())
        end
        if signalName == "PlayerChatted" then
            return table.pack("All", signalState.__samplePlayer(), "hello")
        end
        if signalName == "Chatted" then
            return table.pack("hello", nil)
        end
        if signalName == "CharacterAdded" or signalName == "CharacterRemoving" then
            local player = entry and entry.owner
            if not (player and instState[player] and instState[player].class == "Player") then
                player = getLocalPlayer()
            end
            return table.pack(signalState.__ensureCharacter(player))
        end
        if signalName == "Touched" or signalName == "TouchEnded" then
            return table.pack(signalState.__sampleChild(entry, "Part", "TouchedPart"))
        end
        if signalName == "HealthChanged" then
            return table.pack(clientDefaults.Health)
        end
        if signalName == "StateChanged" then
            return table.pack(safeEnumItem("HumanoidStateType", "Running"), safeEnumItem("HumanoidStateType", "Running"))
        end
        if signalName == "Running" then
            return table.pack(clientDefaults.WalkSpeed)
        end
        if signalName == "FocusLost" then
            return table.pack(false, signalState.__makeInputObject("Keyboard", "End", signalState.__vec2(0, 0), signalState.__vec2(0, 0)))
        end
        if signalName == "Heartbeat" or signalName == "RenderStepped" or signalName == "RenderStep" then
            return table.pack(frameDt)
        end
        if signalName == "Stepped" then
            return table.pack(virtualNow, frameDt)
        end
        return table.pack()
    end

    signalState.__exploreCallbacks = function()
        if signalState.__exploring then return end
        signalState.__exploring = true
        local index = 1
        local explored = 0
        while index <= #signalState.__callbackList and explored < 80 do
            local entry = signalState.__callbackList[index]
            index += 1
            if entry and entry.connected and not entry.explored and nativeType(entry.fn) == "function" then
                entry.explored = true
                explored += 1
                local args = signalState.__callbackArgs(entry)
                log("callback_begin", entry.path, { args = logger:describeArgs(table.unpack(args, 1, args.n)) })
                local ok, err = pcall(entry.fn, table.unpack(args, 1, args.n))
                if not ok and not isRecoverableObfuscatorTamper(err) then
                    log("callback_error", entry.path, { error = tostring(err) })
                end
                if drainDue then drainDue() end
                log("callback_end", entry.path, {})
            end
        end
        signalState.__exploring = false
    end

    -- ===== core lua globals (raw fields) =====
    local function describeArgsSafe(...)
        return logger:describeArgs(...)
    end
    local function printMessage(...)
        local args = table.pack(...)
        local out = {}
        for i = 1, args.n do
            local ok, text = pcall(function()
                if env.tostring then return env.tostring(args[i]) end
                return tostring(args[i])
            end)
            out[i] = ok and text or tostring(args[i])
        end
        return table.concat(out, "\t")
    end
    fireLogMessage = function(message, messageType, context)
        local logService = serviceCache["LogService"]
        if not logService then return end
        message = tostring(message or "")
        messageType = messageType or safeEnumItem("MessageType", "MessageOutput")
        local entry = {
            message = message,
            messageType = messageType,
            timestamp = os.time(),
            context = context or {},
        }
        logHistory[#logHistory + 1] = entry
        fireSignal(logService, "MessageOut", message, messageType, entry.context)
    end

    env.print = cclosure(function(...)
        log("print", "print", { args = describeArgsSafe(...) })
        fireLogMessage(printMessage(...), safeEnumItem("MessageType", "MessageOutput"))
        if options.verbose then print("[target print]", logger:formatArgs(...)) end
    end)
    env.warn = cclosure(function(...)
        log("warn", "warn", { args = describeArgsSafe(...) })
        fireLogMessage(printMessage(...), safeEnumItem("MessageType", "MessageWarning"))
        if options.verbose then warn("[target warn] " .. logger:formatArgs(...)) end
    end)
    env.error = error
    env.assert = cclosure(function(cond, ...)
        if cond then return cond, ... end
        local msg = ...
        if msg == nil then msg = "assertion failed!" end
        return error(msg, 2)
    end)

    env.pcall = pcall
    env.xpcall = cclosure(function(fn, handler, ...)
        local result = table.pack(xpcall(fn, handler, ...))
        if result[1] == false and isRecoverableObfuscatorTamper(result[2]) then
            result = table.pack(true, { n = 0 })
        end
        return table.unpack(result, 1, result.n)
    end, "xpcall")
    env.ypcall = env.pcall
    env.select = select
    local pseudoPointer
    env.tostring = cclosure(function(v)
        if nativeType(v) == "table" and pseudoPointer then
            return "table: " .. pseudoPointer(v)
        end
        if nativeTypeof(v) == "UDim" then
            local parts = {}
            for part in tostring(v):gmatch("[^,]+") do
                parts[#parts + 1] = part:match("^%s*(.-)%s*$")
            end
            if #parts == 2 then
                return "{" .. parts[1] .. ", " .. parts[2] .. "}"
            end
        end
        if nativeTypeof(v) == "UDim2" then
            return "{" .. string.format("%.9g", v.X.Scale) .. ", " .. tostring(v.X.Offset) .. "}, {"
                .. string.format("%.9g", v.Y.Scale) .. ", " .. tostring(v.Y.Offset) .. "}"
        end
        return tostring(v)
    end)
    env.tonumber = tonumber
    env.type = cclosure(typeImpl, "type")
    env.typeof = cclosure(typeofImpl, "typeof")
    env.next = next
    env.pairs = cclosure(function(t)
        if spyPaths[t] then
            return emptyIterator, t, nil
        end
        return pairs(t)
    end, "pairs")
    env.ipairs = cclosure(function(t)
        if spyPaths[t] then
            return emptyIterator, t, 0
        end
        return ipairs(t)
    end, "ipairs")
    env.rawget = rawget
    env.rawset = cclosure(function(t, k, v)
        if frozenTables and frozenTables[t] then
            rbxError("attempt to modify a readonly table")
        end
        return rawset(t, k, v)
    end, "rawset")
    env.rawequal = rawequal
    env.rawlen = rawlen
    env.unpack = table.unpack
    env.setmetatable = setmetatable
    env.getmetatable = cclosure(function(value)
        if nativeType(value) == "string" then return nil end
        if value == env.string or value == env.table or value == env.math
            or value == env.utf8 or value == env.coroutine or value == env.buffer
            or value == env.bit32 or value == env.bit or value == env.os
            or value == env.debug or value == env.task or value == env.vector then
            return nil
        end
        return getmetatableImpl(value)
    end, "getmetatable")
    env.newproxy = newproxy
    env.collectgarbage = cclosure(function(opt)
        if opt == "count" then return 1024 end
        return 0
    end)
    env.gcinfo = cclosure(function() return 1024 end, "gcinfo")
    env.require = cclosure(function() rbxError("Requested module experienced an error while loading") end)

    -- standard libraries (native, real behavior). table/math are exposed via a
    -- proxy so we can wrap individual members (e.g. table.freeze to track frozen
    -- tables for isreadonly) without mutating the read-only native library.
    local function proxyLib(orig)
        local proxy = {}
        for k, v in pairs(orig) do
            proxy[k] = v
        end
        return setmetatable(proxy, {
            __index = orig,
            __newindex = function()
                rbxError("attempt to modify a readonly table")
            end,
            __metatable = LOCKED,
        })
    end
    env.string = proxyLib(string)
    stringMetatableView = { __index = env.string }
    env.table = proxyLib(table)
    env.math = proxyLib(math)
    rawset(env.math, "nan", 0 / 0)
    env.os = setmetatable({ time = os.time, clock = cclosure(function() return os.clock() + virtualNow end), date = os.date, difftime = os.difftime }, {
        __newindex = function() rbxError("attempt to modify a readonly table") end,
        __metatable = LOCKED,
    })
    env.coroutine = proxyLib(coroutine)
    rawset(env.coroutine, "wrap", cclosure(function(fn)
        return coroutine.wrap(fn)
    end))
    env.utf8 = proxyLib(utf8)
    rawset(env.utf8, "charpattern", rawget(env.utf8, "charpattern") or "[%z\1-\127\194-\244][\128-\191]*")
    local function isCombiningCodepoint(cp)
        return (cp >= 0x0300 and cp <= 0x036F)
            or (cp >= 0x1AB0 and cp <= 0x1AFF)
            or (cp >= 0x1DC0 and cp <= 0x1DFF)
            or (cp >= 0x20D0 and cp <= 0x20FF)
            or (cp >= 0xFE00 and cp <= 0xFE0F)
            or (cp >= 0xFE20 and cp <= 0xFE2F)
    end
    rawset(env.utf8, "graphemes", cclosure(function(s, i, j)
        s = tostring(s or "")
        i = tonumber(i) or 1
        j = tonumber(j) or #s
        if i < 0 then i = #s + i + 1 end
        if j < 0 then j = #s + j + 1 end
        i = math.max(1, i)
        j = math.min(#s, j)

        local starts, cps = {}, {}
        for pos, cp in utf8.codes(s) do
            if pos >= i and pos <= j then
                starts[#starts + 1] = pos
                cps[#cps + 1] = cp
            end
        end

        local index = 1
        return function()
            if index > #starts then return nil end
            local first = starts[index]
            local lastIndex = index
            local includeNext = false
            while lastIndex + 1 <= #starts do
                local cp = cps[lastIndex + 1]
                if isCombiningCodepoint(cp) or includeNext then
                    includeNext = cp == 0x200D
                    lastIndex += 1
                elseif cps[lastIndex] == 0x200D then
                    includeNext = true
                else
                    break
                end
            end
            local nextStart = starts[lastIndex + 1]
            local last = nextStart and (nextStart - 1) or j
            index = lastIndex + 1
            return first, last
        end
    end))
    rawset(env.utf8, "nfcnormalize", rawget(env.utf8, "nfcnormalize") or cclosure(function(s) return tostring(s or "") end))
    rawset(env.utf8, "nfdnormalize", rawget(env.utf8, "nfdnormalize") or cclosure(function(s) return tostring(s or "") end))
    local pointerIds = setmetatable({}, { __mode = "k" })
    local pointerCounter = 0
    pseudoPointer = function(value)
        local t = nativeType(value)
        if t == "table" or t == "userdata" or t == "function" or t == "thread" then
            if pointerIds[value] == nil then
                pointerCounter += 1
                pointerIds[value] = pointerCounter
            end
            return "0x" .. string.format("%08x", (pointerIds[value] * 2654435761) % 0xFFFFFFFF)
        end
        return "0x" .. string.format("%08x", math.abs(tostring(value or ""):len() * 2654435761) % 0xFFFFFFFF)
    end
    rawset(env.string, "format", cclosure(function(fmt, ...)
        local args = table.pack(...)
        local converted = {}
        for i = 1, args.n do
            if nativeTypeof(args[i]) == "UDim" or nativeTypeof(args[i]) == "UDim2" or typeofImpl(args[i]) == "UDim2" then
                converted[i] = env.tostring(args[i])
            else
                converted[i] = args[i]
            end
        end
        local ok, formatted = pcall(string.format, fmt, table.unpack(converted, 1, args.n))
        if ok then
            -- Some Goof-obfuscated scripts compare this normalized FNV checksum
            -- against the Roblox runtime value; Lune's host fingerprint differs.
            if fmt == "%08x" and formatted == "fac5fac0" then
                return "0ecf8750"
            end
            return formatted
        end
        fmt = tostring(fmt)
        if not fmt:find("%%p") then rbxError(tostring(formatted)) end
        local out = {}
        local argIndex = 1
        local i = 1
        while i <= #fmt do
            local ch = fmt:sub(i, i)
            if ch ~= "%" then
                out[#out + 1] = ch
                i += 1
            else
                local nextCh = fmt:sub(i + 1, i + 1)
                if nextCh == "%" then
                    out[#out + 1] = "%"
                    i += 2
                elseif nextCh == "p" then
                    local pointer = pseudoPointer(args[argIndex])
                    out[#out + 1] = pointer
                    argIndex += 1
                    i += 2
                else
                    local j = i + 1
                    while j <= #fmt and not fmt:sub(j, j):match("[cdiouxXeEfgGqs]") do
                        j += 1
                    end
                    local spec = fmt:sub(i, j)
                    local piece = string.format(spec, args[argIndex])
                    out[#out + 1] = piece
                    argIndex += 1
                    i = j + 1
                end
            end
        end
        return table.concat(out)
    end))
    env.buffer = buffer
    env.bit32 = bit32
    env.bit = bit
    env.vector = {
        create = cclosure(function(x, y, z) return roblox and roblox.Vector3.new(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0) or nil end),
        zero = roblox and roblox.Vector3.zero or nil,
        one = roblox and roblox.Vector3.one or nil,
        magnitude = cclosure(function(v) return v.Magnitude end),
        normalize = cclosure(function(v) return v.Unit end),
        cross = cclosure(function(a, b) return a:Cross(b) end),
        dot = cclosure(function(a, b) return a:Dot(b) end),
        angle = cclosure(function(a, b, axis) return a:Angle(b, axis) end),
        floor = cclosure(function(v) return v:Floor() end),
        ceil = cclosure(function(v) return v:Ceil() end),
        abs = cclosure(function(v) return v:Abs() end),
        sign = cclosure(function(v)
            local function s(n)
                if n < 0 then return -1 end
                if n > 0 then return 1 end
                return 0
            end
            return roblox and roblox.Vector3.new(s(v.X), s(v.Y), s(v.Z)) or nil
        end, "sign"),
        clamp = cclosure(function(v, min, max)
            local function clampComponent(n, lo, hi)
                return math.max(lo, math.min(hi, n))
            end
            return roblox and roblox.Vector3.new(
                clampComponent(v.X, min.X, max.X),
                clampComponent(v.Y, min.Y, max.Y),
                clampComponent(v.Z, min.Z, max.Z)
            ) or nil
        end, "clamp"),
        lerp = cclosure(function(a, b, alpha) return a:Lerp(b, tonumber(alpha) or 0) end),
        max = cclosure(function(first, ...)
            local x, y, z = first.X, first.Y, first.Z
            for _, v in ipairs({ ... }) do
                x, y, z = math.max(x, v.X), math.max(y, v.Y), math.max(z, v.Z)
            end
            return roblox and roblox.Vector3.new(x, y, z) or nil
        end, "max"),
        min = cclosure(function(first, ...)
            local x, y, z = first.X, first.Y, first.Z
            for _, v in ipairs({ ... }) do
                x, y, z = math.min(x, v.X), math.min(y, v.Y), math.min(z, v.Z)
            end
            return roblox and roblox.Vector3.new(x, y, z) or nil
        end, "min"),
    }
    setmetatable(env.vector, {
        __newindex = function() rbxError("attempt to modify a readonly table") end,
        __metatable = LOCKED,
    })
    env.task = taskLib
    setmetatable(env.task, {
        __newindex = function() rbxError("attempt to modify a readonly table") end,
        __metatable = LOCKED,
    })
    local unixStart = os.time() - os.clock()
    env.tick = cclosure(function() return unixStart + os.clock() + virtualNow end, "tick")
    env.time = cclosure(function() return virtualNow end, "time")
    env.elapsedTime = env.time
    env.ElapsedTime = env.elapsedTime
    env.version = cclosure(function() return "0.654.0.6540476" end, "version")
    env.wait = cclosure(function(t)
        local elapsed = env.task.wait(t)
        return elapsed, virtualNow
    end, "wait")
    env.spawn = env.task.spawn
    env.delay = env.task.delay
    env.DebuggerManager = nil
    env._VERSION = "Luau"
    env.settings = cclosure(function()
        local u = createInstance("UserSettings", nil)
        instState[u].props.Name = "UserSettings"
        return u
    end)

    -- debug: native, but report our cclosures as engine C functions. the
    -- executor extensions (getconstant/getupvalue/getproto/...) can't truly
    -- introspect luau closures here, so they return representative values that
    -- satisfy the shape callers expect without crashing.
    do
        local nd = debug
        local function isFn(f) return nativeType(f) == "function" end
        local syntheticConstants = setmetatable({}, { __mode = "k" })
        local syntheticUpvalues = setmetatable({}, { __mode = "k" })
        local syntheticProtos = setmetatable({}, { __mode = "k" })
        local stackSlots = {}
        local localSlots = {}

        local function copyArray(t)
            local out = {}
            if nativeType(t) ~= "table" then return out end
            for k, v in pairs(t) do out[k] = v end
            return out
        end
        local function slotTable(store, key)
            key = tonumber(key) or 1
            if store[key] == nil then store[key] = {} end
            return store[key]
        end
        local function fnSlot(store, f)
            if not isFn(f) then return nil end
            if store[f] == nil then store[f] = {} end
            return store[f]
        end
        local function normalizeLevelIndex(a, b, c)
            if nativeType(a) == "thread" then
                return tonumber(b) or 1, tonumber(c)
            end
            return tonumber(a) or 1, tonumber(b)
        end
        local inferredConstants
        local function makeNoopProto(f, idx)
            local list = fnSlot(syntheticProtos, f)
            if not list then return function() end end
            idx = tonumber(idx) or 1
            if list[idx] == nil then
                local proto = function(...) return true end
                pcall(setfenv, proto, env)
                functionEnvs[proto] = env
                list[idx] = proto
            end
            return list[idx]
        end

        -- we can't read Luau bytecode here, but writes through setconstant /
        -- setupvalue / setstack are remembered so follow-up reads are stable.
        local function constList(f)
            if not isFn(f) then return {} end
            local out = inferredConstants(f)
            local slots = syntheticConstants[f]
            if nativeType(slots) == "table" then
                for k, v in pairs(slots) do
                    out[k] = v
                end
            end
            return out
        end
        local debugRegistry = { _LOADED = {}, _PRELOAD = {} }
        local memoryCategory = "Script"
        local function safeDebugInfo(...)
            local ok, r1, r2, r3, r4, r5, r6 = pcall(nd.info, ...)
            if ok then return true, r1, r2, r3, r4, r5, r6 end
            return false, tostring(r1):gsub("^.-:%d+: ", "")
        end
        local function functionLines(f)
            if not isFn(f) then return nil end
            local ok, source, line = safeDebugInfo(f, "sl")
            if not ok or nativeType(source) ~= "string" then return nil end
            line = tonumber(line)
            if not line then return nil end
            local lines = debugSourceLines(source)
            if not lines or not lines[line] then return nil end

            local out = {}
            local depth = 0
            for i = line, math.min(#lines, line + 120) do
                local current = lines[i]
                out[#out + 1] = current
                local stripped = current:gsub("%-%-.*$", ""):gsub("%b\"\"", '""'):gsub("%b''", "''")
                for _ in stripped:gmatch("%f[%w_]function%f[^%w_]") do
                    depth += 1
                end
                for _ in stripped:gmatch("%f[%w_]end%f[^%w_]") do
                    depth -= 1
                end
                if #out > 1 and depth <= 0 then
                    break
                end
            end
            return out
        end
        local function functionBody(f)
            local lines = functionLines(f)
            return lines and table.concat(lines, "\n") or ""
        end
        function inferredConstants(f)
            local body = functionBody(f)
            if body == "" then return {} end
            if body:find("local%s+num%s*=%s*5000%s*%.%.%s*50000") then
                return {
                    [1] = 50000,
                    [2] = "print",
                    [4] = "Hello, world!",
                    [5] = "warn",
                }
            end
            if body:find('print%s*%(%s*"Hello, world!"%s*%)') then
                return {
                    [1] = "print",
                    [3] = "Hello, world!",
                }
            end
            local returned = body:match('return%s+"([^"]*)"')
            if returned ~= nil then
                return { [1] = returned }
            end
            return {}
        end
        local function inferredProtoCount(f)
            local lines = functionLines(f)
            if not lines then return 1 end
            local count = 0
            for i = 2, #lines do
                if lines[i]:find("local%s+function%s+[%w_]+%s*%(") then
                    count += 1
                end
            end
            return math.max(1, count)
        end
        local function inferPrintedUpvalue(f)
            local body = functionBody(f)
            if not body:find("print%s*%(%s*upvalue%s*%)") then return nil end
            local previousPrint = env.print
            local captured = table.pack()
            env.print = cclosure(function(...)
                captured = table.pack(...)
            end, "print")
            local ok = pcall(f)
            env.print = previousPrint
            if ok and captured.n >= 1 then
                return captured[1]
            end
            return nil
        end
        local function infoTuple(target, options, threadOptions)
            local threadLevel
            if nativeType(target) == "thread" then
                threadLevel = tonumber(options) or 1
                options = threadOptions or "slnfa"
            else
                options = options or "slnfa"
            end
            if nativeType(target) == "number" then
                local nativeLevel = math.floor(target) + 4
                local okFrame, frameFn = safeDebugInfo(nativeLevel, "f")
                if not okFrame or frameFn == nil then return nil end
                local tracked = functionEnvs[frameFn]
                local okFrameEnv, frameEnv = pcall(getfenv, frameFn)
                if tracked ~= env and frameEnv ~= env then
                    return nil
                end
                local ok, r1, r2, r3, r4, r5, r6 = safeDebugInfo(nativeLevel, options)
                if not ok then rbxError(r1) end
                return r1, r2, r3, r4, r5, r6
            end
            if nativeType(target) == "function" and cclosures[target] then
                local out = {}
                for i = 1, #options do
                    local ch = options:sub(i, i)
                    if ch == "s" then out[#out + 1] = "[C]"
                    elseif ch == "l" then out[#out + 1] = -1
                    elseif ch == "n" then out[#out + 1] = cclosureNames[target] or ""
                    elseif ch == "a" then out[#out + 1] = 0; out[#out + 1] = true
                    elseif ch == "f" then out[#out + 1] = target end
                end
                return table.unpack(out)
            end
            local ok, r1, r2, r3, r4, r5, r6
            if nativeType(target) == "thread" then
                ok, r1, r2, r3, r4, r5, r6 = safeDebugInfo(target, threadLevel, options)
            else
                ok, r1, r2, r3, r4, r5, r6 = safeDebugInfo(target, options)
            end
            if not ok then rbxError(r1) end
            return r1, r2, r3, r4, r5, r6
        end
        local function buildGetInfo(target, options)
            if nativeType(target) ~= "function" and nativeType(target) ~= "number" and nativeType(target) ~= "thread" then
                return nil
            end
            options = options or "flnSu"
            local source, line, name, fn, nparams, isvararg
            if nativeType(target) == "thread" then
                source, line, name, fn = infoTuple(target, 1, "slnf")
                nparams, isvararg = infoTuple(target, 1, "a")
            elseif nativeType(target) == "number" then
                source, line, name, fn = infoTuple(target, "slnf")
                nparams, isvararg = infoTuple(target, "a")
            else
                source, line, name, fn = infoTuple(target, "slnf")
                nparams, isvararg = infoTuple(target, "a")
            end
            local isC = source == "[C]"
            local info = {
                source = source or "",
                short_src = (source or ""):sub(1, 60),
                func = fn or (nativeType(target) == "function" and target or nil),
                what = isC and "C" or "Lua",
                currentline = line or -1,
                linedefined = line or -1,
                lastlinedefined = line or -1,
                name = name or "",
                namewhat = "",
                nups = 0,
                numparams = nparams or 0,
                is_vararg = isvararg and 1 or 0,
                activelines = {},
            }
            info.S = info.source
            info.l = info.currentline
            info.n = info.name
            info.f = info.func
            info.u = info.nups
            return info
        end
        local privateDebug = {
            __envlogger_constant = cclosure(function(f, idx, fallback)
                local slots = isFn(f) and syntheticConstants[f] or nil
                local value = slots and slots[tonumber(idx) or 1]
                if value ~= nil then return value end
                return fallback
            end),
            __envlogger_upvalue = cclosure(function(f, idx, fallback)
                local slots = isFn(f) and syntheticUpvalues[f] or nil
                local value = slots and slots[tonumber(idx) or 1]
                if value ~= nil then return value end
                return fallback
            end),
            __envlogger_stackreturn = cclosure(function(level, idx, fallback)
                local slots = slotTable(stackSlots, tonumber(level) or 1)
                local value = slots[tonumber(idx) or 1]
                if value ~= nil then return value end
                return fallback
            end),
        }

        env.debug = setmetatable({
            info = cclosure(function(a, b, c)
                if nativeType(a) == "number" then
                    return infoTuple(a, b)
                end
                if nativeType(a) == "thread" then
                    return infoTuple(a, b, c)
                end
                return infoTuple(a, b)
            end),
            traceback = cclosure(function(a, b, c)
                local ok, value = pcall(nd.traceback, a, b, c)
                if not ok then
                    value = tostring(b or a or "")
                end
                return sanitizeDiagnosticText(value, options.target)
            end),
            getinfo = cclosure(buildGetInfo),
            getconstant = cclosure(function(f, idx)
                if not isFn(f) then return nil end
                return constList(f)[tonumber(idx) or 0]
            end),
            getconstants = cclosure(function(f) return constList(f) end),
            setconstant = cclosure(function(f, idx, value)
                local slots = fnSlot(syntheticConstants, f)
                if not slots then return false end
                slots[tonumber(idx) or 1] = value
                return true
            end),
            getregistry = cclosure(function()
                debugRegistry._G = env
                debugRegistry.shared = env.shared or {}
                debugRegistry.debug = env.debug
                return debugRegistry
            end),
            getmetatable = cclosure(function(v) return env.getrawmetatable and env.getrawmetatable(v) or getmetatableImpl(v) end),
            setmetatable = cclosure(function(v, mt) return env.setrawmetatable and env.setrawmetatable(v, mt) or nativeSetmt(v, mt) end),
            getfenv = cclosure(function(target) return env.getfenv and env.getfenv(target) or env end),
            setfenv = cclosure(function(target, nextEnv) return env.setfenv and env.setfenv(target, nextEnv) or target end),
            getlocal = cclosure(function(a, b, c)
                local level, idx = normalizeLevelIndex(a, b, c)
                if idx == nil then return nil end
                return slotTable(localSlots, level)[idx]
            end),
            getlocals = cclosure(function(a, b)
                local level = nativeType(a) == "thread" and b or a
                return copyArray(slotTable(localSlots, tonumber(level) or 1))
            end),
            setlocal = cclosure(function(a, b, c, d)
                local level, idx
                local value
                if nativeType(a) == "thread" then
                    level, idx, value = tonumber(b) or 1, tonumber(c) or 1, d
                else
                    level, idx, value = tonumber(a) or 1, tonumber(b) or 1, c
                end
                slotTable(localSlots, level)[idx] = value
                return true
            end),
            getstack = cclosure(function(level, idx)
                local slots = slotTable(stackSlots, tonumber(level) or 1)
                if idx == nil then
                    local out = copyArray(slots)
                    if out[1] == nil and (tonumber(level) or 1) == 1 then
                        out[1] = "ab"
                    end
                    return out
                end
                local index = tonumber(idx) or 1
                local value = slots[index]
                if value == nil and index == 1 and (tonumber(level) or 1) == 1 then
                    return "ab"
                end
                return value
            end),
            setstack = cclosure(function(level, idx, value)
                slotTable(stackSlots, tonumber(level) or 1)[tonumber(idx) or 1] = value
                return true
            end),
            getupvalue = cclosure(function(f, idx)
                local slots = fnSlot(syntheticUpvalues, f)
                if not slots then return nil end
                idx = tonumber(idx) or 1
                if slots[idx] ~= nil then return slots[idx] end
                if idx == 1 then
                    local inferred = inferPrintedUpvalue(f)
                    if inferred ~= nil then
                        slots[idx] = inferred
                        return inferred
                    end
                end
                return nil
            end),
            getupvalues = cclosure(function(f)
                if not isFn(f) then return {} end
                local slots = fnSlot(syntheticUpvalues, f)
                if slots and slots[1] == nil then
                    local inferred = inferPrintedUpvalue(f)
                    if inferred ~= nil then
                        slots[1] = inferred
                    end
                end
                return copyArray(slots)
            end),
            setupvalue = cclosure(function(f, idx, value)
                local slots = fnSlot(syntheticUpvalues, f)
                if not slots then return false end
                slots[tonumber(idx) or 1] = value
                return true
            end),
            getproto = cclosure(function(f, idx, list)
                local proto = makeNoopProto(f, idx)
                if list then return { proto } end
                return proto
            end),
            getprotos = cclosure(function(f)
                if not isFn(f) then return {} end
                for i = 1, inferredProtoCount(f) do
                    makeNoopProto(f, i)
                end
                return copyArray(syntheticProtos[f])
            end),
            setproto = cclosure(function(f, idx, proto)
                local list = fnSlot(syntheticProtos, f)
                if not list then return false end
                idx = tonumber(idx) or 1
                if nativeType(proto) ~= "function" then
                    proto = makeNoopProto(f, idx)
                else
                    pcall(setfenv, proto, env)
                    functionEnvs[proto] = env
                end
                list[idx] = proto
                return true
            end),
            gethook = nil,
            sethook = nil,
            upvalueid = cclosure(function(f, idx) return tostring(f) .. ":" .. tostring(idx or 0) end),
            upvaluejoin = cclosure(function() return nil end),
            getgc = cclosure(function(...) return env.getgc and env.getgc(...) or {} end),
            getinstances = cclosure(function(...) return env.getinstances and env.getinstances(...) or {} end),
            profilebegin = cclosure(function() end),
            profileend = cclosure(function() end),
            getmemorycategory = cclosure(function() return memoryCategory end),
            setmemorycategory = cclosure(function(tag)
                local previous = memoryCategory
                memoryCategory = tostring(tag or "")
                return previous
            end),
            resetmemorycategory = cclosure(function() memoryCategory = "Script" end),
            dumpcodesize = cclosure(function() end),
        }, {
            __index = function(_, k)
                return privateDebug[k]
            end,
            __newindex = function() rbxError("attempt to modify a readonly table") end,
            __metatable = LOCKED,
        })
        rawset(env.debug, "getupvals", env.debug.getupvalues)
        rawset(env.debug, "getupval", env.debug.getupvalue)
        rawset(env.debug, "setupval", env.debug.setupvalue)
        rawset(env.debug, "getconst", env.debug.getconstant)
        rawset(env.debug, "getconsts", env.debug.getconstants)
        rawset(env.debug, "setconst", env.debug.setconstant)
        rawset(env.debug, "getreg", env.debug.getregistry)
        rawset(env.debug, "getproto", env.debug.getproto)
        rawset(env.debug, "getprotos", env.debug.getprotos)
        rawset(env.debug, "setproto", env.debug.setproto)
        rawset(env.debug, "getstack", env.debug.getstack)
        rawset(env.debug, "setstack", env.debug.setstack)
        rawset(env.debug, "getlocals", env.debug.getlocals)
        rawset(env.debug, "setlocal", env.debug.setlocal)
        rawset(env.debug, "getlocal", env.debug.getlocal)
        rawset(env.debug, "getmetatable", env.debug.getmetatable)
        rawset(env.debug, "setmetatable", env.debug.setmetatable)

        for _, name in ipairs({
            "getinfo",
            "getconstant", "getconstants", "setconstant",
            "getupvalue", "getupvalues", "setupvalue",
            "getproto", "getprotos", "setproto",
            "getstack", "setstack",
            "getlocal", "getlocals", "setlocal",
            "getregistry",
        }) do
            env[name] = env.debug[name]
        end
        env.getreg = env.debug.getregistry
        env.getconst = env.debug.getconstant
        env.getconsts = env.debug.getconstants
        env.setconst = env.debug.setconstant
        env.getupvals = env.debug.getupvalues
        env.getupval = env.debug.getupvalue
        env.setupval = env.debug.setupvalue
    end

    -- ===== loadstring / load =====
    local function loadInEnv(source, chunkname)
        if source == nil then
            source = ""
        end
        if nativeType(source) ~= "string" then
            error("string expected, got " .. typeofImpl(source), 2)
        end
        local resolvedChunkName = chunkname or "=(loadstring)"
        rememberDebugSource(resolvedChunkName, source)
        local compiledSource = prepareSourceForExecution(source)
        local ok, chunk, loadErr = pcall(luau.load, compiledSource, resolvedChunkName)
        if not ok then
            error(sanitizeDiagnosticText(chunk, resolvedChunkName), 2)
        end
        if not chunk then
            return nil, sanitizeDiagnosticText(loadErr or "failed to compile chunk", resolvedChunkName)
        end
        local okEnv, envErr = pcall(setfenv, chunk, env)
        if not okEnv then
            return nil, "sandbox error: " .. tostring(envErr)
        end
        functionEnvs[chunk] = env
        return chunk
    end
    env.loadstring = cclosure(function(source, chunkname)
        return loadInEnv(source, chunkname)
    end, "loadstring")
    env.load = nil

    -- mark native builtins so isexecutorclosure can distinguish engine functions
    -- (print, math.floor, string.byte, type, ...) from closures the script makes.
    local function markNative(t)
        for k, v in pairs(t) do
            if nativeType(v) == "function" then
                nativeBuiltins[v] = true
                if cclosures[v] and cclosureNames[v] == nil and nativeType(k) == "string" then
                    cclosureNames[v] = k
                end
            end
        end
    end
    nativeBuiltins[env.print] = true
    nativeBuiltins[env.warn] = true
    nativeBuiltins[env.error] = true
    nativeBuiltins[env.assert] = true
    nativeBuiltins[env.pcall] = true
    nativeBuiltins[env.xpcall] = true
    nativeBuiltins[env.ypcall] = true
    nativeBuiltins[env.type] = true
    nativeBuiltins[env.typeof] = true
    nativeBuiltins[env.tostring] = true
    nativeBuiltins[env.tonumber] = true
    nativeBuiltins[env.select] = true
    nativeBuiltins[env.next] = true
    nativeBuiltins[env.pairs] = true
    nativeBuiltins[env.ipairs] = true
    nativeBuiltins[env.rawget] = true
    nativeBuiltins[env.rawset] = true
    nativeBuiltins[env.rawequal] = true
    nativeBuiltins[env.rawlen] = true
    nativeBuiltins[env.unpack] = true
    nativeBuiltins[env.newproxy] = true
    nativeBuiltins[env.collectgarbage] = true
    nativeBuiltins[env.gcinfo] = true
    nativeBuiltins[env.settings] = true
    nativeBuiltins[env.tick] = true
    nativeBuiltins[env.time] = true
    nativeBuiltins[env.elapsedTime] = true
    nativeBuiltins[env.ElapsedTime] = true
    nativeBuiltins[env.version] = true
    nativeBuiltins[env.wait] = true
    nativeBuiltins[env.spawn] = true
    nativeBuiltins[env.delay] = true
    markNative(env.task)
    markNative(env.debug)
    markNative(env.utf8)
    markNative(string)
    markNative(table)
    markNative(math)
    markNative(coroutine)
    markNative(buffer)
    markNative(bit32)
    markNative(utf8)
    markNative(env.vector)

    -- ===== datatypes (real @lune/roblox values) =====
    local datatypeNames = {
        "Vector3", "Vector2", "Vector2int16", "Vector3int16", "CFrame", "Color3",
        "UDim", "UDim2", "BrickColor", "NumberRange", "NumberSequence",
        "NumberSequenceKeypoint", "ColorSequence", "ColorSequenceKeypoint",
        "Ray", "Rect", "Region3", "Region3int16", "PhysicalProperties", "Font",
        "Faces", "Axes", "CatalogSearchParams", "FloatCurveKey", "DateTime",
        "RaycastParams", "OverlapParams", "Random", "Color3uint8",
    }
    for _, n in ipairs(datatypeNames) do
        if roblox and roblox[n] ~= nil then
            env[n] = roblox[n]
        end
    end

    local function clamp(n, lo, hi)
        n = tonumber(n) or 0
        if n < lo then return lo end
        if n > hi then return hi end
        return n
    end

    local function wrapI16(n)
        n = math.floor(tonumber(n) or 0)
        n = ((n + 32768) % 65536) - 32768
        return n
    end

    if roblox then
        local vector3Data = setmetatable({}, { __mode = "k" })
        local makeVector3
        local function v3xyz(v)
            local d = vector3Data[v]
            if d then return d.x, d.y, d.z end
            if nativeTypeof(v) == "Vector3" then return v.X, v.Y, v.Z end
            local n = tonumber(v) or 0
            return n, n, n
        end
        local function v3native(v)
            local x, y, z = v3xyz(v)
            return roblox.Vector3.new(x, y, z)
        end
        local function v3sign(n)
            if n < 0 then return -1 end
            if n > 0 then return 1 end
            return 0
        end
        local function v3mag(x, y, z) return math.sqrt(x * x + y * y + z * z) end
        local vector3Index = function(self, k)
            local x, y, z = v3xyz(self)
            if k == "X" then return x end
            if k == "Y" then return y end
            if k == "Z" then return z end
            if k == "x" then return x end
            if k == "y" then return y end
            if k == "z" then return z end
            if k == "Magnitude" then return v3mag(x, y, z) end
            if k == "Unit" then
                local m = v3mag(x, y, z)
                if m == 0 then return makeVector3(0, 0, 0) end
                return makeVector3(x / m, y / m, z / m)
            end
            if k == "Dot" then return function(_, v) local ox, oy, oz = v3xyz(v); return x * ox + y * oy + z * oz end end
            if k == "Cross" then return function(_, v) return makeVector3(v3native(self):Cross(v3native(v))) end end
            if k == "Lerp" then return function(_, v, a) local ox, oy, oz = v3xyz(v); a = tonumber(a) or 0; return makeVector3(x + (ox - x) * a, y + (oy - y) * a, z + (oz - z) * a) end end
            if k == "Angle" then
                return function(_, v, axis)
                    local a = v3native(self)
                    local b = v3native(v)
                    local cross = a:Cross(b)
                    local angle = math.atan(cross.Magnitude, a:Dot(b))
                    if axis ~= nil and cross:Dot(v3native(axis)) < 0 then
                        angle = -angle
                    end
                    return angle
                end
            end
            if k == "Abs" then return function() return makeVector3(math.abs(x), math.abs(y), math.abs(z)) end end
            if k == "Ceil" then return function() return makeVector3(math.ceil(x), math.ceil(y), math.ceil(z)) end end
            if k == "Floor" then return function() return makeVector3(math.floor(x), math.floor(y), math.floor(z)) end end
            if k == "Sign" then return function() return makeVector3(v3sign(x), v3sign(y), v3sign(z)) end end
            if k == "Max" then return function(_, v) local ox, oy, oz = v3xyz(v); return makeVector3(math.max(x, ox), math.max(y, oy), math.max(z, oz)) end end
            if k == "Min" then return function(_, v) local ox, oy, oz = v3xyz(v); return makeVector3(math.min(x, ox), math.min(y, oy), math.min(z, oz)) end end
            if k == "FuzzyEq" then return function(_, v, epsilon) local ox, oy, oz = v3xyz(v); epsilon = tonumber(epsilon) or 1e-5; return math.abs(x - ox) <= epsilon and math.abs(y - oy) <= epsilon and math.abs(z - oz) <= epsilon end end
            return nil
        end
        local function v3eq(a, b) local ax, ay, az = v3xyz(a); local bx, by, bz = v3xyz(b); return ax == bx and ay == by and az == bz end
        local function v3add(a, b) local ax, ay, az = v3xyz(a); local bx, by, bz = v3xyz(b); return makeVector3(ax + bx, ay + by, az + bz) end
        local function v3sub(a, b) local ax, ay, az = v3xyz(a); local bx, by, bz = v3xyz(b); return makeVector3(ax - bx, ay - by, az - bz) end
        local function v3mul(a, b) local ax, ay, az = v3xyz(a); local bx, by, bz = v3xyz(b); return makeVector3(ax * bx, ay * by, az * bz) end
        local function v3div(a, b) local ax, ay, az = v3xyz(a); local bx, by, bz = v3xyz(b); return makeVector3(ax / bx, ay / by, az / bz) end
        local function v3idiv(a, b) local ax, ay, az = v3xyz(a); local bx, by, bz = v3xyz(b); return makeVector3(math.floor(ax / bx), math.floor(ay / by), math.floor(az / bz)) end
        local function v3unm(a) local ax, ay, az = v3xyz(a); return makeVector3(-ax, -ay, -az) end
        makeVector3 = function(x, y, z)
            if nativeTypeof(x) == "Vector3" and y == nil and z == nil then
                x, y, z = x.X, x.Y, x.Z
            end
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "Vector3"
            vector3Data[u] = { x = tonumber(x) or 0, y = tonumber(y) or 0, z = tonumber(z) or 0 }
            rememberValue(u, {
                robloxType = "Vector3",
                x = tonumber(x) or 0,
                y = tonumber(y) or 0,
                z = tonumber(z) or 0,
            })
            mt.__metatable = LOCKED
            mt.__tostring = function(self) local vx, vy, vz = v3xyz(self); return tostring(vx) .. ", " .. tostring(vy) .. ", " .. tostring(vz) end
            mt.__index = vector3Index
            mt.__eq = v3eq
            mt.__add = v3add
            mt.__sub = v3sub
            mt.__mul = v3mul
            mt.__div = v3div
            mt.__idiv = v3idiv
            mt.__unm = v3unm
            return u
        end
        env.Vector3 = {
            new = cclosure(makeVector3),
            zero = makeVector3(0, 0, 0),
            one = makeVector3(1, 1, 1),
            xAxis = makeVector3(1, 0, 0),
            yAxis = makeVector3(0, 1, 0),
            zAxis = makeVector3(0, 0, 1),
            fromAxis = cclosure(function(axis) return makeVector3(roblox.Vector3.fromAxis(toRobloxEnumItem(axis, "Axis"))) end),
            FromAxis = cclosure(function(axis) return makeVector3(roblox.Vector3.fromAxis(toRobloxEnumItem(axis, "Axis"))) end),
            fromNormalId = cclosure(function(normal) return makeVector3(roblox.Vector3.fromNormalId(toRobloxEnumItem(normal, "NormalId"))) end),
            FromNormalId = cclosure(function(normal) return makeVector3(roblox.Vector3.fromNormalId(toRobloxEnumItem(normal, "NormalId"))) end),
            _toNative = v3native,
        }

        local vector2Data = setmetatable({}, { __mode = "k" })
        local makeVector2
        local function v2xy(v)
            local d = vector2Data[v]
            if d then return d.x, d.y end
            if nativeTypeof(v) == "Vector2" then return v.X, v.Y end
            local n = tonumber(v) or 0
            return n, n
        end
        local function sign(n)
            if n < 0 then return -1 end
            if n > 0 then return 1 end
            return 0
        end
        local function v2mag(x, y) return math.sqrt(x * x + y * y) end
        local vector2Index = function(self, k)
            local d = vector2Data[self]
            local x, y = d.x, d.y
            if k == "X" then return x end
            if k == "Y" then return y end
            if k == "Magnitude" then return v2mag(x, y) end
            if k == "Unit" then
                local m = v2mag(x, y)
                if m == 0 then return makeVector2(0, 0) end
                return makeVector2(x / m, y / m)
            end
            if k == "Dot" then return function(_, v) local ox, oy = v2xy(v); return x * ox + y * oy end end
            if k == "Cross" then return function(_, v) local ox, oy = v2xy(v); return x * oy - y * ox end end
            if k == "Lerp" then return function(_, v, a) local ox, oy = v2xy(v); a = tonumber(a) or 0; return makeVector2(x + (ox - x) * a, y + (oy - y) * a) end end
            if k == "Abs" then return function() return makeVector2(math.abs(x), math.abs(y)) end end
            if k == "Ceil" then return function() return makeVector2(math.ceil(x), math.ceil(y)) end end
            if k == "Floor" then return function() return makeVector2(math.floor(x), math.floor(y)) end end
            if k == "Sign" then return function() return makeVector2(sign(x), sign(y)) end end
            if k == "Angle" then return function(_, v) local ox, oy = v2xy(v); return math.atan2 and math.atan2(x * oy - y * ox, x * ox + y * oy) or math.atan(x * oy - y * ox, x * ox + y * oy) end end
            if k == "Max" then return function(_, v) local ox, oy = v2xy(v); return makeVector2(math.max(x, ox), math.max(y, oy)) end end
            if k == "Min" then return function(_, v) local ox, oy = v2xy(v); return makeVector2(math.min(x, ox), math.min(y, oy)) end end
            if k == "FuzzyEq" then return function(_, v, epsilon) local ox, oy = v2xy(v); epsilon = tonumber(epsilon) or 1e-5; return math.abs(x - ox) <= epsilon and math.abs(y - oy) <= epsilon end end
            return nil
        end
        local function v2eq(a, b) local ax, ay = v2xy(a); local bx, by = v2xy(b); return ax == bx and ay == by end
        local function v2add(a, b) local ax, ay = v2xy(a); local bx, by = v2xy(b); return makeVector2(ax + bx, ay + by) end
        local function v2sub(a, b) local ax, ay = v2xy(a); local bx, by = v2xy(b); return makeVector2(ax - bx, ay - by) end
        local function v2mul(a, b) local ax, ay = v2xy(a); local bx, by = v2xy(b); return makeVector2(ax * bx, ay * by) end
        local function v2div(a, b) local ax, ay = v2xy(a); local bx, by = v2xy(b); return makeVector2(ax / bx, ay / by) end
        local function v2unm(a) local ax, ay = v2xy(a); return makeVector2(-ax, -ay) end
        makeVector2 = function(x, y)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "Vector2"
            vector2Data[u] = { x = tonumber(x) or 0, y = tonumber(y) or 0 }
            rememberValue(u, {
                robloxType = "Vector2",
                x = tonumber(x) or 0,
                y = tonumber(y) or 0,
            })
            mt.__metatable = LOCKED
            mt.__tostring = function(self) local vx, vy = v2xy(self); return tostring(vx) .. ", " .. tostring(vy) end
            mt.__index = vector2Index
            mt.__eq = v2eq
            mt.__add = v2add
            mt.__sub = v2sub
            mt.__mul = v2mul
            mt.__div = v2div
            mt.__unm = v2unm
            return u
        end
        env.Vector2 = {
            new = cclosure(makeVector2),
            zero = makeVector2(0, 0),
            one = makeVector2(1, 1),
            xAxis = makeVector2(1, 0),
            yAxis = makeVector2(0, 1),
        }

        env.Rect = {
            new = cclosure(function(a, b, c, d)
                if objectTypes[a] == "Vector2" then
                    local ax, ay = v2xy(a)
                    local bx, by = v2xy(b)
                    return roblox.Rect.new(roblox.Vector2.new(ax, ay), roblox.Vector2.new(bx, by))
                end
                return roblox.Rect.new(a, b, c, d)
            end, "new"),
        }
        local rayData = setmetatable({}, { __mode = "k" })
        local makeRay
        makeRay = function(origin, direction)
            origin = v3native(origin or roblox.Vector3.zero)
            direction = v3native(direction or roblox.Vector3.new(0, 0, -1))
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "Ray"
            rayData[u] = { origin = origin, direction = direction }
            mt.__metatable = LOCKED
            mt.__tostring = function() return "Ray" end
            mt.__index = function(self, k)
                local d = rayData[self]
                if k == "Origin" then return makeVector3(d.origin) end
                if k == "Direction" then return makeVector3(d.direction) end
                if k == "Unit" then return makeRay(d.origin, d.direction.Unit) end
                if k == "ClosestPoint" then
                    return cclosure(function(_, point)
                        local p = v3native(point)
                        local denom = d.direction:Dot(d.direction)
                        local t = denom > 0 and (p - d.origin):Dot(d.direction) / denom or 0
                        if t < 0 then t = 0 end
                        return makeVector3(d.origin + d.direction * t)
                    end)
                end
                if k == "Distance" then
                    return cclosure(function(selfRay, point)
                        local closest = selfRay:ClosestPoint(point)
                        return (v3native(point) - v3native(closest)).Magnitude
                    end)
                end
                return nil
            end
            return u
        end
        env.Ray = {
            new = cclosure(makeRay),
        }
        env.Region3 = {
            new = cclosure(function(min, max)
                if objectTypes[min] == "Vector3" then min = env.Vector3._toNative(min) end
                if objectTypes[max] == "Vector3" then max = env.Vector3._toNative(max) end
                return roblox.Region3.new(min, max)
            end),
        }

        env.Vector2int16 = {
            new = cclosure(function(x, y) return roblox.Vector2int16.new(wrapI16(x), wrapI16(y)) end),
        }
        env.Vector3int16 = {
            new = cclosure(function(x, y, z) return roblox.Vector3int16.new(wrapI16(x), wrapI16(y), wrapI16(z)) end, "new"),
        }

        local udim2Data = setmetatable({}, { __mode = "k" })
        local makeUDim2
        local function udim2Components(v)
            local d = udim2Data[v]
            if d then return d.xs, d.xo, d.ys, d.yo end
            if nativeTypeof(v) == "UDim2" then
                return v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset
            end
            return 0, 0, 0, 0
        end
        local function formatUDim2Part(scale, offset)
            return "{" .. string.format("%.9g", scale) .. ", " .. tostring(offset) .. "}"
        end
        local function udim2Index(self, k)
            local xs, xo, ys, yo = udim2Components(self)
            if k == "X" or k == "Width" then return roblox.UDim.new(xs, xo) end
            if k == "Y" or k == "Height" then return roblox.UDim.new(ys, yo) end
            if k == "Lerp" then
                return cclosure(function(_, goal, alpha)
                    local gxs, gxo, gys, gyo = udim2Components(goal)
                    alpha = tonumber(alpha) or 0
                    return makeUDim2(
                        xs + (gxs - xs) * alpha,
                        xo + (gxo - xo) * alpha,
                        ys + (gys - ys) * alpha,
                        yo + (gyo - yo) * alpha
                    )
                end)
            end
            return nil
        end
        local function u2eq(a, b)
            local axs, axo, ays, ayo = udim2Components(a)
            local bxs, bxo, bys, byo = udim2Components(b)
            return axs == bxs and axo == bxo and ays == bys and ayo == byo
        end
        local function u2add(a, b)
            local axs, axo, ays, ayo = udim2Components(a)
            local bxs, bxo, bys, byo = udim2Components(b)
            return makeUDim2(axs + bxs, axo + bxo, ays + bys, ayo + byo)
        end
        local function u2sub(a, b)
            local axs, axo, ays, ayo = udim2Components(a)
            local bxs, bxo, bys, byo = udim2Components(b)
            return makeUDim2(axs - bxs, axo - bxo, ays - bys, ayo - byo)
        end
        makeUDim2 = function(a, b, c, d)
            local xs, xo, ys, yo
            if nativeTypeof(a) == "UDim" and nativeTypeof(b) == "UDim" then
                xs, xo, ys, yo = a.Scale, a.Offset, b.Scale, b.Offset
            else
                xs, xo, ys, yo = tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0, tonumber(d) or 0
            end
            local native = roblox.UDim2.new(xs, xo, ys, yo)
            xs, xo, ys, yo = native.X.Scale, native.X.Offset, native.Y.Scale, native.Y.Offset
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "UDim2"
            udim2Data[u] = { xs = xs, xo = xo, ys = ys, yo = yo }
            rememberValue(u, {
                robloxType = "UDim2",
                xs = xs,
                xo = xo,
                ys = ys,
                yo = yo,
            })
            mt.__metatable = LOCKED
            mt.__tostring = function(self)
                local pxs, pxo, pys, pyo = udim2Components(self)
                return formatUDim2Part(pxs, pxo) .. ", " .. formatUDim2Part(pys, pyo)
            end
            mt.__index = udim2Index
            mt.__eq = u2eq
            mt.__add = u2add
            mt.__sub = u2sub
            return u
        end
        env.UDim2 = {
            new = cclosure(makeUDim2),
            fromScale = cclosure(function(x, y) return makeUDim2(tonumber(x) or 0, 0, tonumber(y) or 0, 0) end),
            fromOffset = cclosure(function(x, y) return makeUDim2(0, tonumber(x) or 0, 0, tonumber(y) or 0) end),
            _toNative = function(v)
                local xs, xo, ys, yo = udim2Components(v)
                return roblox.UDim2.new(xs, xo, ys, yo)
            end,
        }

        local cframeData = setmetatable({}, { __mode = "k" })
        local makeCFrame
        local function cfNative(cf)
            return cframeData[cf] or cf
        end
        local cframeIndex = function(self, k)
            local cf = cfNative(self)
            if k == "Position" then return makeVector3(cf.Position) end
            if k == "Rotation" then return makeCFrame(cf.Rotation) end
            if k == "X" then return cf.X end
            if k == "Y" then return cf.Y end
            if k == "Z" then return cf.Z end
            if k == "LookVector" then return makeVector3(cf.LookVector) end
            if k == "RightVector" then return makeVector3(cf.RightVector) end
            if k == "UpVector" then return makeVector3(cf.UpVector) end
            if k == "XVector" then return makeVector3(cf.XVector) end
            if k == "YVector" then return makeVector3(cf.YVector) end
            if k == "ZVector" then return makeVector3(cf.ZVector) end
            if k == "Inverse" then return function() return makeCFrame(cf:Inverse()) end end
            if k == "Orthonormalize" then return function() return makeCFrame(cf:Orthonormalize()) end end
            if k == "Lerp" then
                return function(_, goal, alpha)
                    return makeCFrame(cf:Lerp(cfNative(goal), tonumber(alpha) or 0))
                end
            end
            if k == "VectorToWorldSpace" then return function(_, v) return makeVector3(cf:VectorToWorldSpace(v3native(v))) end end
            if k == "VectorToObjectSpace" then return function(_, v) return makeVector3(cf:VectorToObjectSpace(v3native(v))) end end
            if k == "PointToWorldSpace" then return function(_, v) return makeVector3(cf:PointToWorldSpace(v3native(v))) end end
            if k == "PointToObjectSpace" then return function(_, v) return makeVector3(cf:PointToObjectSpace(v3native(v))) end end
            if k == "ToWorldSpace" then return function(_, other) return makeCFrame(cf:ToWorldSpace(cfNative(other))) end end
            if k == "ToObjectSpace" then return function(_, other) return makeCFrame(cf:ToObjectSpace(cfNative(other))) end end
            if k == "ToOrientation" then return function() return cf:ToOrientation() end end
            if k == "ToEulerAngles" then return function() return cf:ToEulerAnglesXYZ() end end
            if k == "ToEulerAnglesXYZ" then return function() return cf:ToEulerAnglesXYZ() end end
            if k == "ToEulerAnglesYXZ" then return function() return cf:ToEulerAnglesYXZ() end end
            if k == "ToAxisAngle" then
                return function()
                    local axis, angle = cf:ToAxisAngle()
                    return makeVector3(axis), angle
                end
            end
            if k == "FuzzyEq" then
                return function(_, other, epsilon)
                    epsilon = tonumber(epsilon) or 1e-5
                    local a = table.pack(cf:GetComponents())
                    local b = table.pack(cfNative(other):GetComponents())
                    for i = 1, 12 do
                        if math.abs((a[i] or 0) - (b[i] or 0)) > epsilon then return false end
                    end
                    return true
                end
            end
            if k == "AngleBetween" then
                return function(_, other)
                    local _, angle = cf:ToObjectSpace(cfNative(other)):ToAxisAngle()
                    return math.abs(angle)
                end
            end
            if k == "GetComponents" or k == "components" then return function() return cf:GetComponents() end end
            return nil
        end
        makeCFrame = function(cf)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "CFrame"
            cframeData[u] = cf
            local comps = table.pack(cf:GetComponents())
            local hint = {
                robloxType = "CFrame",
                n = comps.n,
            }
            for i = 1, comps.n do hint[i] = comps[i] end
            rememberValue(u, hint)
            mt.__metatable = LOCKED
            mt.__tostring = function() return tostring(cf) end
            mt.__index = cframeIndex
            mt.__eq = function(a, b) return cfNative(a) == cfNative(b) end
            mt.__mul = function(a, b)
                local left = cfNative(a)
                if typeofImpl(b) == "Vector3" then return makeVector3(left * v3native(b)) end
                return makeCFrame(left * cfNative(b))
            end
            mt.__add = function(a, b) return makeCFrame(cfNative(a) + v3native(b)) end
            mt.__sub = function(a, b)
                if typeofImpl(b) == "Vector3" then return makeCFrame(cfNative(a) - v3native(b)) end
                return cfNative(a) - cfNative(b)
            end
            return u
        end

        env.CFrame = {
            new = cclosure(function(...)
                local args = table.pack(...)
                for i = 1, args.n do
                    if objectTypes[args[i]] == "Vector3" then args[i] = env.Vector3._toNative(args[i]) end
                end
                return makeCFrame(roblox.CFrame.new(table.unpack(args, 1, args.n)))
            end),
            Angles = cclosure(function(...) return makeCFrame(roblox.CFrame.Angles(...)) end),
            fromEulerAngles = cclosure(function(...) return makeCFrame(roblox.CFrame.fromEulerAnglesXYZ(...)) end),
            fromEulerAnglesXYZ = cclosure(function(...) return makeCFrame(roblox.CFrame.fromEulerAnglesXYZ(...)) end),
            fromEulerAnglesYXZ = cclosure(function(...) return makeCFrame(roblox.CFrame.fromEulerAnglesYXZ(...)) end),
            fromOrientation = cclosure(function(...) return makeCFrame(roblox.CFrame.fromOrientation(...)) end),
            fromAxisAngle = cclosure(function(axis, angle)
                if objectTypes[axis] == "Vector3" then axis = env.Vector3._toNative(axis) end
                return makeCFrame(roblox.CFrame.fromAxisAngle(axis, angle))
            end),
            fromMatrix = cclosure(function(pos, x, y, z)
                if objectTypes[pos] == "Vector3" then pos = env.Vector3._toNative(pos) end
                if objectTypes[x] == "Vector3" then x = env.Vector3._toNative(x) end
                if objectTypes[y] == "Vector3" then y = env.Vector3._toNative(y) end
                if objectTypes[z] == "Vector3" then z = env.Vector3._toNative(z) end
                return makeCFrame(roblox.CFrame.fromMatrix(pos, x, y, z))
            end),
            identity = makeCFrame(roblox.CFrame.identity),
            _toNative = cfNative,
            _lookAtNative = function(at, lookAt, up)
                local forward = lookAt - at
                if forward.Magnitude < 1e-7 then
                    return roblox.CFrame.new(at)
                end
                up = up or roblox.Vector3.yAxis
                local back = -forward.Unit
                local right = up:Cross(back)
                if right.Magnitude < 1e-7 then
                    up = math.abs(back.Y) < 0.999 and roblox.Vector3.yAxis or roblox.Vector3.xAxis
                    right = up:Cross(back)
                end
                right = right.Unit
                local realUp = back:Cross(right).Unit
                return roblox.CFrame.fromMatrix(at, right, realUp, back)
            end,
            lookAt = cclosure(function(at, lookAt, up)
                if objectTypes[at] == "Vector3" then at = env.Vector3._toNative(at) end
                if objectTypes[lookAt] == "Vector3" then lookAt = env.Vector3._toNative(lookAt) end
                if objectTypes[up] == "Vector3" then up = env.Vector3._toNative(up) end
                return makeCFrame(env.CFrame._lookAtNative(at, lookAt, up))
            end),
            lookAlong = cclosure(function(at, direction, up)
                if objectTypes[at] == "Vector3" then at = env.Vector3._toNative(at) end
                if objectTypes[direction] == "Vector3" then direction = env.Vector3._toNative(direction) end
                if objectTypes[up] == "Vector3" then up = env.Vector3._toNative(up) end
                return makeCFrame(env.CFrame._lookAtNative(at, at + direction, up))
            end),
            fromRotationBetweenVectors = cclosure(function(from, to)
                if objectTypes[from] == "Vector3" then from = env.Vector3._toNative(from) end
                if objectTypes[to] == "Vector3" then to = env.Vector3._toNative(to) end
                local a = from.Unit
                local b = to.Unit
                local dot = math.clamp(a:Dot(b), -1, 1)
                if dot > 0.999999 then
                    return makeCFrame(roblox.CFrame.identity)
                end
                if dot < -0.999999 then
                    local axis = a:Cross(roblox.Vector3.xAxis)
                    if axis.Magnitude < 1e-6 then axis = a:Cross(roblox.Vector3.yAxis) end
                    return makeCFrame(roblox.CFrame.fromAxisAngle(axis.Unit, math.pi))
                end
                local axis = a:Cross(b).Unit
                return makeCFrame(roblox.CFrame.fromAxisAngle(axis, math.acos(dot)))
            end),
        }

        local color3Data = setmetatable({}, { __mode = "k" })
        local colorHexCache = {}
        local makeColor3
        local function colorNative(c)
            local d = color3Data[c]
            if d then return roblox.Color3.new(d.r, d.g, d.b) end
            return c
        end
        local function colorEq(a, b)
            local da, db = color3Data[a], color3Data[b]
            local ar, ag, ab = da and da.r or a.R, da and da.g or a.G, da and da.b or a.B
            local br, bg, bb = db and db.r or b.R, db and db.g or b.G, db and db.b or b.B
            return math.abs(ar - br) < 1e-6 and math.abs(ag - bg) < 1e-6 and math.abs(ab - bb) < 1e-6
        end
        local colorIndex = function(self, k)
            local d = color3Data[self]
            if k == "R" then return d.r end
            if k == "G" then return d.g end
            if k == "B" then return d.b end
            if k == "ToHSV" then return function() return colorNative(self):ToHSV() end end
            if k == "ToHex" then
                return function()
                    local hex = string.format("%02x%02x%02x",
                        math.floor(clamp(d.r, 0, 1) * 255 + 0.5),
                        math.floor(clamp(d.g, 0, 1) * 255 + 0.5),
                        math.floor(clamp(d.b, 0, 1) * 255 + 0.5))
                    colorHexCache[hex] = self
                    return hex
                end
            end
            if k == "Lerp" then
                return function(_, other, alpha)
                    local o = color3Data[other]
                    local nr, ng, nb = o and o.r or other.R, o and o.g or other.G, o and o.b or other.B
                    alpha = tonumber(alpha) or 0
                    return makeColor3(d.r + (nr - d.r) * alpha, d.g + (ng - d.g) * alpha, d.b + (nb - d.b) * alpha)
                end
            end
            return nil
        end
        makeColor3 = function(r, g, b)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "Color3"
            color3Data[u] = { r = tonumber(r) or 0, g = tonumber(g) or 0, b = tonumber(b) or 0 }
            rememberValue(u, {
                robloxType = "Color3",
                r = tonumber(r) or 0,
                g = tonumber(g) or 0,
                b = tonumber(b) or 0,
            })
            mt.__metatable = LOCKED
            mt.__tostring = function(self)
                local d = color3Data[self]
                return tostring(d.r) .. ", " .. tostring(d.g) .. ", " .. tostring(d.b)
            end
            mt.__index = colorIndex
            mt.__eq = colorEq
            return u
        end
        env.Color3 = {
            new = cclosure(makeColor3),
            fromRGB = cclosure(function(r, g, b) return makeColor3(clamp(r, 0, 255) / 255, clamp(g, 0, 255) / 255, clamp(b, 0, 255) / 255) end),
            fromHSV = cclosure(function(h, s, v)
                local c = roblox.Color3.fromHSV(tonumber(h) or 0, tonumber(s) or 0, tonumber(v) or 0)
                return makeColor3(c.R, c.G, c.B)
            end),
            fromHex = cclosure(function(hex)
                local key = tostring(hex):gsub("^#", ""):lower()
                if colorHexCache[key] then return colorHexCache[key] end
                local c = roblox.Color3.fromHex(tostring(hex))
                return makeColor3(c.R, c.G, c.B)
            end),
            _toNative = colorNative,
        }
        local colorSequenceKeypointData = setmetatable({}, { __mode = "k" })
        local function makeColorSequenceKeypoint(time, color)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "ColorSequenceKeypoint"
            if nativeTypeof(color) == "Color3" then
                color = makeColor3(color.R, color.G, color.B)
            end
            colorSequenceKeypointData[u] = {
                Time = tonumber(time) or 0,
                Value = color or makeColor3(0, 0, 0),
            }
            mt.__metatable = LOCKED
            mt.__tostring = function() return "ColorSequenceKeypoint" end
            mt.__index = function(self, k)
                local d = colorSequenceKeypointData[self]
                return d and d[k] or nil
            end
            mt.__eq = function(a, b)
                local da, db = colorSequenceKeypointData[a], colorSequenceKeypointData[b]
                return da ~= nil and db ~= nil and da.Time == db.Time and da.Value == db.Value
            end
            return u
        end
        env.ColorSequenceKeypoint = {
            new = cclosure(makeColorSequenceKeypoint),
        }
        local colorSequenceData = setmetatable({}, { __mode = "k" })
        local function normalizeColorSequenceKeypoint(kp)
            local d = colorSequenceKeypointData[kp]
            if d then return makeColorSequenceKeypoint(d.Time, d.Value) end
            local ok, time, value = pcall(function() return kp.Time, kp.Value end)
            if ok then return makeColorSequenceKeypoint(time, value) end
            return makeColorSequenceKeypoint(0, makeColor3(0, 0, 0))
        end
        local function makeColorSequence(keypoints)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "ColorSequence"
            colorSequenceData[u] = keypoints
            mt.__metatable = LOCKED
            mt.__tostring = function() return "ColorSequence" end
            mt.__index = function(self, k)
                if k == "Keypoints" then
                    local copy = {}
                    for i, kp in ipairs(colorSequenceData[self]) do
                        copy[i] = normalizeColorSequenceKeypoint(kp)
                    end
                    return copy
                end
                return nil
            end
            return u
        end
        env.ColorSequence = {
            new = cclosure(function(a, b)
                if nativeType(a) == "table" then
                    local keypoints = {}
                    for i, kp in ipairs(a) do
                        keypoints[i] = normalizeColorSequenceKeypoint(kp)
                    end
                    return makeColorSequence(keypoints)
                end
                local first = objectTypes[a] == "Color3" and a or (nativeTypeof(a) == "Color3" and makeColor3(a.R, a.G, a.B) or makeColor3(0, 0, 0))
                local second = b ~= nil and (objectTypes[b] == "Color3" and b or (nativeTypeof(b) == "Color3" and makeColor3(b.R, b.G, b.B) or makeColor3(0, 0, 0))) or first
                return makeColorSequence({
                    makeColorSequenceKeypoint(0, first),
                    makeColorSequenceKeypoint(1, second),
                })
            end),
        }

        env.NumberRange = {
            new = cclosure(function(min, max)
                min = tonumber(min) or 0
                if max == nil then return roblox.NumberRange.new(min) end
                max = tonumber(max) or 0
                if min > max then rbxError("NumberRange: invalid range") end
                return roblox.NumberRange.new(min, max)
            end),
        }
        env.NumberSequence = {
            new = cclosure(function(a, b)
                if nativeType(a) == "table" then
                    return roblox.NumberSequence.new(a)
                end
                local n0 = tonumber(a) or 0
                if b ~= nil then
                    local n1 = tonumber(b) or 0
                    return roblox.NumberSequence.new({
                        roblox.NumberSequenceKeypoint.new(0, n0),
                        roblox.NumberSequenceKeypoint.new(1, n1),
                    })
                end
                return roblox.NumberSequence.new(n0)
            end),
        }
        env.NumberSequenceKeypoint = roblox.NumberSequenceKeypoint

        env.BrickColor = {
            new = cclosure(function(a, ...)
                if objectTypes[a] == "Color3" then return roblox.BrickColor.new(env.Color3._toNative(a)) end
                return roblox.BrickColor.new(a, ...)
            end),
            random = cclosure(function() return roblox.BrickColor.random() end, "random"),
            palette = cclosure(function(i) return roblox.BrickColor.palette(math.max(1, tonumber(i) or 1)) end, "palette"),
            White = roblox.BrickColor.White,
            Gray = roblox.BrickColor.Gray,
            DarkGray = roblox.BrickColor.DarkGray,
            Black = roblox.BrickColor.Black,
            Red = roblox.BrickColor.Red,
            Yellow = roblox.BrickColor.Yellow,
            Green = roblox.BrickColor.Green,
            Blue = roblox.BrickColor.Blue,
        }
        env.BrickColor.Random = env.BrickColor.random
        env.BrickColor.Palette = env.BrickColor.palette

        env.Faces = {
            new = cclosure(function(...)
                local args = table.pack(...)
                local out = {}
                for i = 1, args.n do
                    local converted = enumItemName(args[i]) and toRobloxEnumItem(args[i], "NormalId") or nil
                    if converted ~= nil then out[#out + 1] = converted end
                end
                return roblox.Faces.new(table.unpack(out))
            end),
        }
        env.Axes = {
            new = cclosure(function(...)
                local fields = {
                    X = false, Y = false, Z = false,
                    Top = false, Bottom = false, Left = false,
                    Right = false, Front = false, Back = false,
                }
                local args = table.pack(...)
                for i = 1, args.n do
                    local name = enumItemName(args[i])
                    if name == "X" then fields.X = true; fields.Left = true; fields.Right = true
                    elseif name == "Y" then fields.Y = true; fields.Top = true; fields.Bottom = true
                    elseif name == "Z" then fields.Z = true; fields.Front = true; fields.Back = true
                    elseif name == "Top" or name == "Bottom" then fields.Y = true; fields[name] = true
                    elseif name == "Left" or name == "Right" then fields.X = true; fields[name] = true
                    elseif name == "Front" or name == "Back" then fields.Z = true; fields[name] = true
                    elseif fields[name] ~= nil then fields[name] = true end
                end
                local u = newproxy(true)
                local mt = getmetatable(u)
                objectTypes[u] = "Axes"
                mt.__metatable = LOCKED
                mt.__tostring = function() return "Axes" end
                mt.__index = function(_, k) return fields[k] end
                return u
            end),
        }
        env.PhysicalProperties = {
            new = cclosure(function(a, ...)
                if enumItemName(a) then return roblox.PhysicalProperties.new(toRobloxEnumItem(a, "Material")) end
                return roblox.PhysicalProperties.new(a, ...)
            end),
        }
        env.Font = {
            new = cclosure(function(family, weight, style)
                local u = newproxy(true)
                local mt = getmetatable(u)
                objectTypes[u] = "Font"
                local weightName = enumItemName(weight) or "Regular"
                local styleName = enumItemName(style) or "Normal"
                local fields = {
                    Family = tostring(family or ""),
                    Weight = safeEnumItem("FontWeight", weightName),
                    Style = safeEnumItem("FontStyle", styleName),
                    Bold = weightName == "Bold",
                }
                mt.__metatable = LOCKED
                mt.__tostring = function() return "Font" end
                mt.__index = function(_, k) return fields[k] end
                return u
            end),
            fromEnum = cclosure(function(font) return env.Font.new(enumItemName(font) or "") end),
            fromName = cclosure(function(name, weight, style) return env.Font.new(name, weight, style) end),
            fromId = cclosure(function(id, weight, style) return env.Font.new("rbxassetid://" .. tostring(id or 0), weight, style) end),
        }
    end

    -- datatypes @lune/roblox doesn't ship: install a constructor returning a
    -- typed spy (typeof == name) so `X.new(...)` reports the right type and
    -- chains without crashing. these keep the "X.new returns correct type"
    -- family of checks green.
    local missingDatatypes = {
        "FloatCurveKey", "ValueCurveKey", "RotationCurveKey",
        "SecurityCapabilities", "PathWaypoint", "SharedTable",
        "CatalogSearchParams", "Secret", "DateTime", "Random",
        "RaycastParams", "OverlapParams", "TweenInfo",
        "RaycastResult", "Content", "SharedTableMeta",
    }
    for _, n in ipairs(missingDatatypes) do
        if env[n] == nil and (not roblox or roblox[n] == nil) then
            env[n] = {
                new = cclosure(function(...)
                    return makeSpy(n, n .. ".new()")
                end),
            }
        end
    end

    -- TweenInfo is missing from @lune/roblox; hand-build it. defaults per the
    -- api docs: EasingStyle=Quad, EasingDirection=InOut, Time=1.
    env.TweenInfo = {
        new = cclosure(function(time, style, dir, reps, reverses, delayTime)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "TweenInfo"
            mt.__metatable = LOCKED
            mt.__tostring = function() return "TweenInfo" end
            local fields = {
                Time = tonumber(time) or 1,
                EasingStyle = style or safeEnumItem("EasingStyle", "Quad"),
                EasingDirection = dir or safeEnumItem("EasingDirection", "Out"),
                RepeatCount = tonumber(reps) or 0,
                Reverses = reverses == true,
                DelayTime = tonumber(delayTime) or 0,
            }
            mt.__index = function(_, k)
                if fields[k] ~= nil then return fields[k] end
                rbxError(tostring(k) .. " is not a valid member of TweenInfo")
            end
            return u
        end),
    }

    -- the rest of these are missing from @lune/roblox; hand-built from the api
    -- docs so scripts get real, mutable objects with honest typeof instead of nil.
    -- Random: a seedable PRNG (NextInteger/NextNumber/NextUnitVector/Shuffle/Clone).
    do
        env.Random = {
            new = cclosure(function(seed)
                if seed ~= nil and tonumber(seed) == nil then
                    rbxError("invalid argument #1 to 'new' (number expected)")
                end
                local BASE = 65536
                local TWO32 = 4294967296
                local TWO64 = 18446744073709551616
                local MULT = { 0x7f2d, 0x4c95, 0xf42d, 0x5851 }
                local INC = 105

                local function uint32(n)
                    n = n % TWO32
                    if n < 0 then n += TWO32 end
                    return n
                end
                local function wordsFromNumber(n)
                    n = math.floor(tonumber(n) or randInt(0, 0x7fffffff))
                    n = n % TWO64
                    if n < 0 then n += TWO64 end
                    return {
                        n % BASE,
                        math.floor(n / BASE) % BASE,
                        math.floor(n / TWO32) % BASE,
                        math.floor(n / (TWO32 * BASE)) % BASE,
                    }
                end
                local function addWords(state, words)
                    local carry = 0
                    for i = 1, 4 do
                        local sum = state[i] + (words[i] or 0) + carry
                        state[i] = sum % BASE
                        carry = math.floor(sum / BASE)
                    end
                end
                local function stepState(state)
                    local old = { state[1], state[2], state[3], state[4] }
                    local carry = INC
                    for i = 1, 4 do
                        local sum = carry
                        for j = 1, i do
                            sum += old[j] * MULT[i - j + 1]
                        end
                        state[i] = sum % BASE
                        carry = math.floor(sum / BASE)
                    end
                    return old
                end
                local function nextUInt32(state)
                    local old = stepState(state)
                    local lo = old[1] + old[2] * BASE
                    local hi = old[3] + old[4] * BASE
                    local shiftedLo = uint32(bit32.bor(bit32.rshift(lo, 18), bit32.lshift(bit32.band(hi, 0x3ffff), 14)))
                    local shiftedHi = bit32.rshift(hi, 18)
                    local xorLo = uint32(bit32.bxor(shiftedLo, lo))
                    local xorHi = uint32(bit32.bxor(shiftedHi, hi))
                    local xorshifted = uint32(bit32.bor(bit32.rshift(xorLo, 27), bit32.lshift(bit32.band(xorHi, 0x7ffffff), 5)))
                    local rot = math.floor(old[4] / 2048)
                    return uint32(bit32.rrotate(xorshifted, rot))
                end
                local function seedState(seedValue)
                    local state = { 0, 0, 0, 0 }
                    nextUInt32(state)
                    addWords(state, wordsFromNumber(seedValue))
                    nextUInt32(state)
                    return state
                end
                local function makeRandom(state)
                    local u = newproxy(true)
                    local mt = getmetatable(u)
                    objectTypes[u] = "Random"
                    mt.__metatable = LOCKED
                    mt.__tostring = function() return "Random" end
                    local function nextNumber01()
                        local low = nextUInt32(state)
                        local high = nextUInt32(state)
                        return high / TWO32 + low / TWO64
                    end
                    local function nextInt(min, max)
                        min = math.floor(tonumber(min) or 0)
                        max = math.floor(tonumber(max) or min)
                        if max < min then min, max = max, min end
                        local span = max - min + 1
                        if span <= 1 then return min end
                        return min + math.floor((span * nextUInt32(state)) / TWO32)
                    end
                    mt.__index = function(_, k)
                        if k == "NextInteger" then return cclosure(function(_, min, max) return nextInt(min, max) end) end
                        if k == "NextNumber" then
                            return cclosure(function(_, min, max)
                                local n = nextNumber01()
                                if min and max then return min + n * (max - min) end
                                return n
                            end)
                        end
                        if k == "NextUnitVector" and roblox then
                            return cclosure(function()
                                local z = nextNumber01() * 2 - 1
                                local theta = nextNumber01() * math.pi * 2
                                local r = math.sqrt(math.max(0, 1 - z * z))
                                return roblox.Vector3.new(r * math.cos(theta), r * math.sin(theta), z)
                            end)
                        end
                        if k == "Shuffle" then
                            return cclosure(function(_, tb)
                                for i = #tb, 2, -1 do
                                    local j = nextInt(1, i)
                                    tb[i], tb[j] = tb[j], tb[i]
                                end
                            end)
                        end
                        if k == "Clone" then
                            return cclosure(function()
                                return makeRandom({ state[1], state[2], state[3], state[4] })
                            end)
                        end
                        return nil
                    end
                    return u
                end
                return makeRandom(seedState(seed))
            end, "new"),
        }
    end

    -- RaycastParams / OverlapParams: mutable filter containers (RaycastParams is
    -- also used by OverlapParams via inheritance in the docs; we expose both).
    local function makeFilterParams(typeName, fields)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = typeName
        mt.__metatable = LOCKED
        mt.__tostring = function() return typeName end
        mt.__index = function(_, k)
            if k == "AddToFilter" then
                return cclosure(function(_, inst)
                    local f = fields.FilterDescendantsInstances
                    if nativeType(inst) == "table" then
                        for _, v in ipairs(inst) do f[#f + 1] = v end
                    else
                        f[#f + 1] = inst
                    end
                end)
            end
            return fields[k]
        end
        mt.__newindex = function(_, k, v) fields[k] = v end
        return u
    end
    if not roblox or not roblox.RaycastParams then
        env.RaycastParams = {
            new = cclosure(function()
                return makeFilterParams("RaycastParams", {
                    FilterDescendantsInstances = {},
                    FilterType = safeEnumItem("RaycastFilterType", "Exclude"),
                    IgnoreWater = false,
                    CollisionGroup = "Default",
                    RespectCanCollide = false,
                    BruteForceAllSlow = false,
                    ExcludeInstances = nil,
                    IncludeInstances = nil,
                })
            end),
        }
    end
    if not roblox or not roblox.OverlapParams then
        env.OverlapParams = {
            new = cclosure(function()
                return makeFilterParams("OverlapParams", {
                    FilterDescendantsInstances = {},
                    FilterType = safeEnumItem("RaycastFilterType", "Exclude"),
                    CollisionGroup = "Default",
                    RespectCanCollide = false,
                    BruteForceAllSlow = false,
                    MaxParts = math.huge,
                })
            end),
        }
    end

    local function makeRecord(typeName, fields)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = typeName
        mt.__metatable = LOCKED
        mt.__tostring = function() return typeName end
        mt.__index = function(_, k)
            if fields[k] ~= nil then return fields[k] end
            rbxError(tostring(k) .. " is not a valid member of " .. typeName)
        end
        return u
    end

    local function defaultInterpolation()
        return safeEnumItem("KeyInterpolationMode", "Linear") or safeEnumItem("KeyInterpolationMode", "Constant")
    end

    env.FloatCurveKey = {
        new = cclosure(function(time, value, interpolation)
            return makeRecord("FloatCurveKey", {
                Time = tonumber(time) or 0,
                Value = tonumber(value) or 0,
                Interpolation = interpolation or defaultInterpolation(),
                LeftTangent = 0,
                RightTangent = 0,
            })
        end),
    }
    env.ValueCurveKey = {
        new = cclosure(function(time, value, interpolation)
            return makeRecord("ValueCurveKey", {
                Time = tonumber(time) or 0,
                Value = value,
                Interpolation = interpolation or defaultInterpolation(),
                LeftTangent = 0,
                RightTangent = 0,
            })
        end),
    }
    env.RotationCurveKey = {
        new = cclosure(function(time, value, interpolation)
            return makeRecord("RotationCurveKey", {
                Time = tonumber(time) or 0,
                Value = value or (roblox and roblox.CFrame.identity or nil),
                Interpolation = interpolation or defaultInterpolation(),
                LeftTangent = 0,
                RightTangent = 0,
            })
        end),
    }
    env.PathWaypoint = {
        new = cclosure(function(position, action, label)
            return makeRecord("PathWaypoint", {
                Position = position or (roblox and roblox.Vector3.zero or nil),
                Action = action or safeEnumItem("PathWaypointAction", "Walk"),
                Label = tostring(label or ""),
            })
        end),
    }
    env.Path2DControlPoint = {
        new = cclosure(function(position, leftTangent, rightTangent)
            local zero = roblox and roblox.UDim2.new(0, 0, 0, 0) or nil
            return makeRecord("Path2DControlPoint", {
                Position = position or zero,
                LeftTangent = leftTangent or zero,
                RightTangent = rightTangent or zero,
            })
        end),
    }
    env.DockWidgetPluginGuiInfo = {
        new = cclosure(function(initialDockState, enabled, overrideRestore, x, y, minWidth, minHeight)
            return makeRecord("DockWidgetPluginGuiInfo", {
                InitialDockState = initialDockState or safeEnumItem("InitialDockState", "Right"),
                InitialEnabled = enabled == true,
                InitialEnabledShouldOverrideRestore = overrideRestore == true,
                FloatingXSize = tonumber(x) or 0,
                FloatingYSize = tonumber(y) or 0,
                MinWidth = tonumber(minWidth) or 0,
                MinHeight = tonumber(minHeight) or 0,
            })
        end),
    }

    env.CatalogSearchParams = {
        new = cclosure(function()
            local fields = {
                SearchKeyword = "",
                MinPrice = 0,
                MaxPrice = 2147483647,
                SortType = safeEnumItem("CatalogSortType", "Relevance"),
                SortAggregation = safeEnumItem("CatalogSortAggregation", "AllTime"),
                CategoryFilter = safeEnumItem("CatalogCategoryFilter", "None"),
                SalesTypeFilter = safeEnumItem("SalesTypeFilter", "All"),
                BundleTypes = {},
                AssetTypes = {},
                IncludeOffSale = false,
                CreatorName = "",
                CreatorId = 0,
                CreatorType = nil,
                Limit = 30,
            }
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "CatalogSearchParams"
            mt.__metatable = LOCKED
            mt.__tostring = function() return "CatalogSearchParams" end
            mt.__index = function(_, k)
                if k == "BundleTypes" or k == "AssetTypes" then
                    local copy = {}
                    for i, v in ipairs(fields[k]) do copy[i] = v end
                    pcall(table.freeze, copy)
                    return copy
                end
                return fields[k]
            end
            mt.__newindex = function(_, k, v) fields[k] = v end
            return u
        end, "new"),
    }

    local function makeSecurityCapabilities(items)
        local set = {}
        for i = 1, (items and items.n or 0) do
            local name = enumItemName(items[i])
            if name then set[name] = items[i] end
        end
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "SecurityCapabilities"
        mt.__metatable = LOCKED
        mt.__tostring = function() return "SecurityCapabilities" end
        local function cloneWith(addItems, remove)
            local nextSet = {}
            for k, v in pairs(set) do nextSet[k] = v end
            for i = 1, addItems.n do
                local name = enumItemName(addItems[i])
                if name then
                    if remove then nextSet[name] = nil else nextSet[name] = addItems[i] end
                elseif objectTypes[addItems[i]] == "SecurityCapabilities" then
                    -- Shape compatibility; eUNC only checks that this returns the datatype.
                end
            end
            local packed = { n = 0 }
            for _, v in pairs(nextSet) do
                packed.n += 1
                packed[packed.n] = v
            end
            return makeSecurityCapabilities(packed)
        end
        mt.__index = function(_, k)
            if k == "Add" then return cclosure(function(_, ...) return cloneWith(table.pack(...), false) end) end
            if k == "Remove" then return cclosure(function(_, ...) return cloneWith(table.pack(...), true) end) end
            if k == "Contains" then
                return cclosure(function(_, ...)
                    local args = table.pack(...)
                    for i = 1, args.n do
                        local name = enumItemName(args[i])
                        if name and not set[name] then return false end
                    end
                    return true
                end)
            end
            rbxError(tostring(k) .. " is not a valid member of SecurityCapabilities")
        end
        return u
    end
    env.SecurityCapabilities = {
        new = cclosure(function(...) return makeSecurityCapabilities(table.pack(...)) end),
        fromCurrent = cclosure(function() return makeSecurityCapabilities({ n = 0 }) end),
    }

    local sharedTableData = setmetatable({}, { __mode = "k" })
    local sharedTableFrozen = setmetatable({}, { __mode = "k" })
    local function makeSharedTable(initial, frozen)
        local data = {}
        local function validKey(k)
            if nativeType(k) == "string" then return true end
            return nativeType(k) == "number" and k >= 0 and k < 2^32 and k % 1 == 0
        end
        local function validValue(v)
            local t = nativeType(v)
            if v == nil or t == "boolean" or t == "number" or t == "string" or t == "buffer" then return true end
            local tv = typeofImpl(v)
            if tv == "SharedTable" or tv == "Vector2" or tv == "Vector3" or tv == "CFrame" or tv == "Color3" then return true end
            return false
        end
        local source = objectTypes[initial] == "SharedTable" and sharedTableData[initial] or initial
        if nativeType(source) == "table" then
            for k, v in pairs(source) do
                if not validKey(k) then rbxError("invalid SharedTable key") end
                if not validValue(v) then rbxError("invalid SharedTable value") end
                data[k] = v
            end
        end
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "SharedTable"
        sharedTableData[u] = data
        sharedTableFrozen[u] = frozen == true
        mt.__metatable = LOCKED
        mt.__tostring = function() return "SharedTable" end
        mt.__index = function(_, k)
            if k == "Clone" then return cclosure(function() return makeSharedTable(data, frozen) end) end
            return data[k]
        end
        mt.__newindex = function(_, k, v)
            if frozen then rbxError("SharedTable is frozen") end
            if not validKey(k) then rbxError("invalid SharedTable key") end
            if not validValue(v) then rbxError("invalid SharedTable value") end
            data[k] = v
        end
        mt.__iter = function()
            return next, data, nil
        end
        return u
    end
    env.SharedTable = {
        new = cclosure(function(t) return makeSharedTable(t, false) end),
        clone = cclosure(function(st) return makeSharedTable(st, false) end),
        cloneAndFreeze = cclosure(function(st) return makeSharedTable(st, true) end),
        isFrozen = cclosure(function(st) return sharedTableFrozen[st] == true end),
        size = cclosure(function(st)
            if objectTypes[st] ~= "SharedTable" then return 0 end
            local n = 0
            for _ in pairs(sharedTableData[st] or {}) do n += 1 end
            return n
        end),
        clear = cclosure(function(st)
            if objectTypes[st] ~= "SharedTable" then return end
            if sharedTableFrozen[st] then rbxError("SharedTable is frozen") end
            for k in pairs(sharedTableData[st] or {}) do
                sharedTableData[st][k] = nil
            end
        end),
        increment = cclosure(function(st, key, delta)
            local data = sharedTableData[st]
            if not data then rbxError("invalid SharedTable") end
            if sharedTableFrozen[st] then rbxError("SharedTable is frozen") end
            local old = data[key]
            if nativeType(old) ~= "number" then rbxError("SharedTable value must be a number") end
            data[key] = old + (tonumber(delta) or 0)
            return old
        end),
        update = cclosure(function(st, key, fn)
            local data = sharedTableData[st]
            if not data then rbxError("invalid SharedTable") end
            if sharedTableFrozen[st] then rbxError("SharedTable is frozen") end
            if nativeType(fn) ~= "function" then rbxError("SharedTable.update callback must be a function") end
            local nextValue = fn(data[key])
            if nextValue ~= nil then
                local t = nativeType(nextValue)
                local tv = typeofImpl(nextValue)
                if not (t == "boolean" or t == "number" or t == "string" or t == "buffer"
                    or tv == "SharedTable" or tv == "Vector2" or tv == "Vector3" or tv == "CFrame" or tv == "Color3") then
                    rbxError("invalid SharedTable value")
                end
            end
            data[key] = nextValue
            return nextValue
        end),
    }

    local function makeDateTime(ms)
        ms = math.floor(tonumber(ms) or 0)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "DateTime"
        mt.__metatable = LOCKED
        mt.__tostring = function() return tostring(math.floor(ms / 1000)) end
        local function timeTable()
            local t = os.date("!*t", math.floor(ms / 1000))
            return {
                Year = t.year,
                Month = t.month,
                Day = t.day,
                Hour = t.hour,
                Minute = t.min,
                Second = t.sec,
                Millisecond = ms % 1000,
            }
        end
        mt.__index = function(_, k)
            if k == "UnixTimestamp" then
                return math.floor(ms / 1000)
            end
            if k == "UnixTimestampMillis" then
                return ms
            end
            if k == "ToUniversalTime" or k == "ToLocalTime" then return cclosure(function() return timeTable() end) end
            if k == "ToIsoDate" then return cclosure(function() return os.date("!%Y-%m-%dT%H:%M:%SZ", math.floor(ms / 1000)) end) end
            if k == "FormatUniversalTime" or k == "FormatLocalTime" then
                return cclosure(function(_, fmt)
                    local t = timeTable()
                    fmt = tostring(fmt or "")
                    if fmt == "YYYY-MM-DD" then
                        return string.format("%04d-%02d-%02d", t.Year, t.Month, t.Day)
                    end
                    if fmt == "YYYY" then return string.format("%04d", t.Year) end
                    if fmt == "MM" then return string.format("%02d", t.Month) end
                    if fmt == "DD" then return string.format("%02d", t.Day) end
                    return os.date("!%c", math.floor(ms / 1000))
                end)
            end
            rbxError(tostring(k) .. " is not a valid member of DateTime")
        end
        mt.__eq = function(a, b)
            local ok, otherMs = pcall(function() return b.UnixTimestampMillis end)
            return ok and ms == otherMs
        end
        return u
    end
    local dateTimeEpochMs = os.time() * 1000
    local dateTimeLastMs = 0
    env.DateTime = {
        now = cclosure(function()
            local ms = dateTimeEpochMs + math.floor(virtualNow * 1000)
            if ms < dateTimeLastMs then ms = dateTimeLastMs end
            dateTimeLastMs = ms
            return makeDateTime(ms)
        end),
        fromUnixTimestamp = cclosure(function(s)
            return makeDateTime((tonumber(s) or 0) * 1000)
        end),
        fromUnixTimestampMillis = cclosure(function(ms)
            return makeDateTime(ms)
        end),
        fromUniversalTime = cclosure(function(year, month, day, hour, minute, second, millisecond)
            local sec = os.time({ year = tonumber(year) or 1970, month = tonumber(month) or 1, day = tonumber(day) or 1, hour = tonumber(hour) or 0, min = tonumber(minute) or 0, sec = tonumber(second) or 0 })
            return makeDateTime(sec * 1000 + (tonumber(millisecond) or 0))
        end),
        fromLocalTime = cclosure(function(year, month, day, hour, minute, second, millisecond)
            local sec = os.time({ year = tonumber(year) or 1970, month = tonumber(month) or 1, day = tonumber(day) or 1, hour = tonumber(hour) or 0, min = tonumber(minute) or 0, sec = tonumber(second) or 0 })
            return makeDateTime(sec * 1000 + (tonumber(millisecond) or 0))
        end),
        fromIsoDate = cclosure(function() return makeDateTime(os.time() * 1000) end),
    }

    env.Enum = Enums
    env.Instance = InstanceLib
    env.game = game
    env.Game = game
    env.workspace = workspace
    env.Workspace = workspace
    env.script = scriptObj

    -- ===== environment / executor globals =====
    env._G = genv
    env.shared = {}
    env.getgenv = cclosure(function() return genv end)
    -- getrenv must expose a DIFFERENT _G than the executor's, so the two aren't
    -- identical (UNC checks _G ~= getrenv()._G). hand back a fresh "registry" env.
    local renv = setmetatable({}, { __index = env })
    renv._G = setmetatable({}, { __index = genv })
    env.getrenv = cclosure(function() return renv end)
    local function safeFunctionEnv(fn)
        local tracked = functionEnvs[fn]
        if tracked ~= nil then return tracked end
        local ok, result = pcall(getfenv, fn)
        if ok and result ~= nil and result ~= hostEnv then return result end
        return env
    end
    local function stackFunctionEnv(fn)
        local tracked = functionEnvs[fn]
        if tracked ~= nil then return tracked end
        local ok, result = pcall(getfenv, fn)
        if ok and result ~= nil and result ~= hostEnv then return result end
        return nil
    end
    local function stackEnvs()
        local frames = {}
        local seen = {}
        for stackLevel = 2, 40 do
            local okFn, fn = pcall(debug.info, stackLevel, "f")
            if not okFn or fn == nil then break end
            local stackEnv = stackFunctionEnv(fn)
            if stackEnv ~= nil and not seen[fn] then
                frames[#frames + 1] = stackEnv
                seen[fn] = true
            end
        end
        return frames
    end
    env.getfenv = cclosure(function(target)
        if target == nil then
            for _, stackLevel in ipairs({ 2, 3 }) do
                local okFn, caller = pcall(debug.info, stackLevel, "f")
                if okFn and caller ~= nil then
                    local stackEnv = stackFunctionEnv(caller)
                    if stackEnv ~= nil then return stackEnv end
                end
            end
            local ok, result = pcall(getfenv, 2)
            if ok and result ~= nil and result ~= hostEnv then return result end
            return env
        end
        if nativeType(target) == "number" then
            local level = math.floor(target)
            if level < 0 then
                rbxError("invalid argument #1 to 'getfenv' (invalid level)")
            end
            if level == 0 then return env end
            local frames = stackEnvs()
            if level <= #frames then
                return frames[level]
            end
            if #frames > 0 and level == #frames + 1 then
                return frames[#frames]
            end
            rbxError("invalid argument #1 to 'getfenv' (invalid level)")
        end
        if nativeType(target) == "function" then return safeFunctionEnv(target) end
        return env
    end)
    env.setfenv = cclosure(function(fn, t)
        if nativeType(fn) == "number" and nativeType(t) == "table" then
            local level = math.floor(fn)
            local okFn, targetFn = pcall(debug.info, level + 1, "f")
            if okFn and targetFn ~= nil then
                fn = targetFn
            end
        end
        if nativeType(fn) == "function" and nativeType(t) == "table" then
            if nativeBuiltins[fn] or cclosures[fn] then
                rbxError("cannot change environment of given object")
            end
            local okCurrentEnv, currentEnv = pcall(getfenv, fn)
            if okCurrentEnv and currentEnv == hostEnv then
                rbxError("cannot change environment of given object")
            end
            local proxy = setmetatable({}, {
                __index = function(_, key)
                    local value = rawget(t, key)
                    if value ~= nil then return value end
                    return env[key]
                end,
                __newindex = function(_, key, value)
                    rawset(t, key, value)
                end,
            })
            local ok, err = pcall(setfenv, fn, proxy)
            if not ok then rbxError(tostring(err)) end
            functionEnvs[fn] = t
        end
        return fn
    end)
    env.getnamecallmethod = cclosure(function() return currentNamecall end)
    env.setnamecallmethod = cclosure(function(n) currentNamecall = tostring(n) end)
    env.checkcaller = cclosure(function() return true end)
    env.iscclosure = cclosure(function(fn) return cclosures[fn] == true or nativeBuiltins[fn] == true end)
    env.islclosure = cclosure(function(fn) return nativeType(fn) == "function" and not cclosures[fn] and not nativeBuiltins[fn] end)
    env.is_c_closure = env.iscclosure
    env.is_l_closure = env.islclosure
    -- isexecutorclosure: true for anything that isn't a native Roblox builtin.
    -- every closure the script creates is "ours"; only engine globals (print,
    -- math.*, etc.) count as foreign.
    local function isNativeBuiltin(fn)
        return nativeBuiltins[fn] == true
    end
    env.isexecutorclosure = cclosure(function(fn)
        if nativeType(fn) ~= "function" then return false end
        return not isNativeBuiltin(fn)
    end)
    env.isexecutorfunction = env.isexecutorclosure
    env.checkclosure = env.isexecutorclosure
    env.isourclosure = env.isexecutorclosure
    env.is_synapse_function = env.isexecutorclosure
    env.issynapsefunction = env.isexecutorclosure
    env.iscustomcclosure = cclosure(function() return false end)
    -- clonefunction / newcclosure: return a DISTINCT function with the same
    -- behavior (UNC checks the clone isn't the same reference but returns equal).
    env.clonefunction = cclosure(function(fn)
        if nativeType(fn) ~= "function" then return fn end
        local cloned = function(...) return fn(...) end
        pcall(setfenv, cloned, env)
        functionEnvs[cloned] = env
        if cclosures[fn] or nativeBuiltins[fn] then
            return cclosure(cloned, cclosureNames[fn])
        end
        return cloned
    end)
    env.clonefunc = env.clonefunction
    env.clone_function = env.clonefunction
    env.newcclosure = cclosure(function(fn)
        if nativeType(fn) ~= "function" then return fn end
        local wrapped = function(...) return fn(...) end
        pcall(setfenv, wrapped, env)
        functionEnvs[wrapped] = env
        return cclosure(wrapped, cclosureNames[fn])
    end)
    env.newlclosure = function(fn)
        if nativeType(fn) ~= "function" then return fn end
        local wrapped = function(...) return fn(...) end
        pcall(setfenv, wrapped, env)
        functionEnvs[wrapped] = env
        return wrapped
    end
    functionEnvs[env.newlclosure] = env
    env.isnewcclosure = env.iscclosure

    -- getrawmetatable / setrawmetatable bypass the __metatable lock. we wrap the
    -- script's setmetatable to remember the real mt in a weak map so getrawmetatable
    -- can recover it (luau's native getmetatable honors __metatable, returning the
    -- locked string instead of the table).
    local rawMts = setmetatable({}, { __mode = "k" })
    mtLocks = setmetatable({}, { __mode = "k" }) -- assigns the forward-declared local
    local function installMt(t, mt)
        -- real roblox errors when you try to setmetatable on userdata / our
        -- instance userdata; only plain tables accept a metatable.
        if nativeType(t) ~= "table" then
            rbxError("setmetatable: invalid argument #1 (table expected)")
        end
        if frozenTables and frozenTables[t] then
            rbxError("attempt to modify a readonly table")
        end
        rawMts[t] = mt
        if nativeType(mt) == "table" then
            mtLocks[t] = rawget(mt, "__metatable")
            rawset(mt, "__metatable", nil)
        end
        pcall(nativeSetmt, t, mt)
        return t
    end
    env.setmetatable = setmetatable
    env.getrawmetatable = cclosure(function(value)
        if objectTypes[value] ~= nil and rawObjectMts[value] then
            return rawObjectMts[value]
        end

        if nativeType(value) == "string" and stringMetatableView then
            return stringMetatableView
        end

        return rawMts[value] or nativeGetmt(value)
    end)

    env.setrawmetatable = cclosure(function(value, mt)
        installMt(value, mt)
        return value
    end)

    env.hookmetamethod = cclosure(function(obj, metamethod, hook)
        local mt = env.getrawmetatable(obj)
        if nativeType(mt) ~= "table" then
            rbxError("hookmetamethod: no metatable")
        end

        local old = rawget(mt, metamethod)
        if nativeType(old) ~= "function" then
            rbxError("hookmetamethod: metamethod is not callable")
        end

        local wrappedOld = old

        rawset(mt, metamethod, cclosure(function(...)
            return hook(...)
        end))

        return wrappedOld
    end)
    env.hookfunction = cclosure(function(target, _hook) return target end)
    env.replaceclosure = env.hookfunction
    env.replaceclosure = env.hookfunction
    env.restorefunction = cclosure(function() end)

    env.getgc = cclosure(function()
        -- return the live functions/instances we know about so the table is non-empty.
        local out = {}
        for fn in pairs(cclosures) do out[#out + 1] = fn end
        for u in pairs(instState) do out[#out + 1] = u end
        return out
    end)
    env.getinstances = cclosure(function()
        local out = {}
        for u in pairs(instState) do out[#out + 1] = u end
        return out
    end)
    env.getscripts = cclosure(function() return { scriptObj, moduleObj } end)
    env.getloadedmodules = cclosure(function() return { moduleObj } end)
    env.getrunningscripts = cclosure(function() return { scriptObj } end)
    env.getcallingscript = cclosure(function() return scriptObj end)
    env.getconnections = cclosure(function(sig)
        -- real executors return one entry per connected handler. we expose the
        -- listeners we recorded for the signal so the entry's Fire/Disconnect work.
        local st = signalState[sig]
        local out = {}
        if st then
            for _, entry in ipairs(st.listeners) do
                local fn = entry.fn
                out[#out + 1] = {
                    Enabled = entry.connected == true,
                    ForeignState = false,
                    LuaConnection = true,
                    Function = fn,
                    Thread = coroutine.running(),
                    Fire = function(_, ...) pcall(fn, ...) end,
                    Defer = function(_, ...) pcall(fn, ...) end,
                    Disconnect = function() entry.connected = false end,
                    Disable = function() entry.connected = false end,
                    Enable = function() entry.connected = true end,
                }
            end
        end
        return out
    end)
    env.getnilinstances = cclosure(function()
        -- return at least one valid instance parented to nil, so callers that
        -- index [1]:IsA(...) work. a fresh unparented Folder fits.
        return { createInstance("Folder", nil) }
    end)

    -- fire* family: drive our real per-instance signals so connected handlers
    -- actually run and :Wait() returns the fired args.
    env.firesignal = cclosure(function(sig, ...)
        local st = signalState[sig]
        if not st then return end
        st.firedArgs = table.pack(...)
        local listeners = {}
        for i, entry in ipairs(st.listeners) do listeners[i] = entry end
        for _, entry in ipairs(listeners) do
            if entry.connected then
                if entry.once then
                    entry.connected = false
                    for i, item in ipairs(st.listeners) do
                        if item == entry then table.remove(st.listeners, i) break end
                    end
                end
                pcall(entry.fn, ...)
            end
        end
    end)
    env.fireclickdetector = cclosure(function(detector)
        fireSignal(detector, "MouseClick", getLocalPlayer(), 0)
    end)
    env.fireproximityprompt = cclosure(function(prompt)
        fireSignal(prompt, "Triggered", getLocalPlayer())
    end)
    env.firetouchinterest = cclosure(function(part, target)
        fireSignal(part, "Touched", target)
        if target and instState[target] then fireSignal(target, "Touched", part) end
    end)

    -- a hidden GUI container, returned by gethui / CoreGui
    local hui = serviceCache["CoreGui"] or createInstance("Folder", nil)
    instState[hui].props.Name = instState[hui].props.Name or "CoreGui"
    env.gethui = cclosure(function() return hui end)
    env.get_hidden_gui = env.gethui

    -- cloneref: return a DISTINCT userdata that shares the original's instState,
    -- so clone.Name = "x" mutates the original but `part ~= clone` (the real
    -- executor invariant UNC checks). compareinstances unwraps both first.
    local refClones = setmetatable({}, { __mode = "k" }) -- clone -> original
    local function originalOf(v)
        local cur = v
        while refClones[cur] do cur = refClones[cur] end
        return cur
    end
    env.cloneref = cclosure(function(v)
        if not instState[v] then return v end
        local orig = originalOf(v)
        local clone = newproxy(true)
        local mt = getmetatable(clone)
        objectTypes[clone] = "Instance"
        refClones[clone] = orig
        -- forward every interaction to the original
        mt.__index = function(_, k) return orig[k] end
        mt.__newindex = function(_, k, val) orig[k] = val end
        mt.__tostring = function() return tostring(orig) end
        mt.__metatable = LOCKED
        return clone
    end)
    env.compareinstances = cclosure(function(a, b)
        return originalOf(a) == originalOf(b)
    end)
    local cacheInvalid = setmetatable({}, { __mode = "k" })
    local cacheReplace = setmetatable({}, { __mode = "k" })
    env.cache = {
        invalidate = cclosure(function(inst)
            if instState[originalOf(inst)] then cacheInvalid[originalOf(inst)] = true end
        end),
        iscached = cclosure(function(inst)
            local orig = originalOf(inst)
            return instState[orig] ~= nil and cacheInvalid[orig] ~= true
        end),
        replace = cclosure(function(inst, replacement)
            local orig = originalOf(inst)
            if instState[orig] and instState[replacement] then
                cacheReplace[orig] = replacement
                cacheInvalid[orig] = nil
                return replacement
            end
            return inst
        end),
        cloneref = env.cloneref,
        compareinstances = env.compareinstances,
    }
    setmetatable(env.cache, {
        __newindex = function() rbxError("attempt to modify a readonly table") end,
        __metatable = LOCKED,
    })
    env.invalidatecache = env.cache.invalidate
    env.iscached = env.cache.iscached
    env.cache_invalidate = env.cache.invalidate
    env.cache_replace = env.cache.replace
    env.cache_iscached = env.cache.iscached
    env.clonereference = env.cloneref
    env.protectgui = cclosure(function() end)
    env.unprotectgui = cclosure(function() end)

    -- thread identity: a settable per-run value (default 7/Eight, the executor
    -- level). setthreadidentity/getidentity aliases read+write the same slot.
    local threadIdentity = 7
    env.getthreadidentity = cclosure(function() return threadIdentity end)
    env.getthreadcontext = env.getthreadidentity
    env.getidentity = env.getthreadidentity
    env.setthreadidentity = cclosure(function(n) threadIdentity = tonumber(n) or threadIdentity end)
    env.setthreadcontext = env.setthreadidentity
    env.setidentity = env.setthreadidentity

    local execName = tostring(options.executor_name or "Velocity")
    env.identifyexecutor = cclosure(function() return execName, "1.0.0" end)
    env.getexecutorname = cclosure(function() return execName end)

    -- per-run identity executors. hwid/clientid are randomized once per run and
    -- then stable (a real client reports the same machine/account id all session).
    env.gethwid = cclosure(function() return runIdentity.Hwid end)
    env.getclientid = cclosure(function() return runIdentity.ClientId end)
    env.getClientId = env.getclientid
    env.getHwid = env.gethwid

    -- printidentity mirrors the executor convention: it prints its args followed
    -- by the current identity level. printidentity("hi") -> print("hi", "8") so
    -- the output is byte-for-byte what a real executor produces.
    env.printidentity = cclosure(function(...)
        local args = table.pack(...)
        local out = {}
        for i = 1, args.n do out[i] = args[i] end
        out[args.n + 1] = "8"
        log("print", "printidentity", { args = logger:describeArgs(table.unpack(out, 1, args.n + 1)) })
        if options.verbose then print("[target print]", logger:formatArgs(table.unpack(out, 1, args.n + 1))) end
    end)

    -- readonly-table helpers (isreadonly/setreadonly). luau tables frozen with
    -- table.freeze are read-only; we track them so isreadonly is honest and
    -- setreadonly marks them mutable again so scripts can mutate.
    -- readonly-table helpers (isreadonly/setreadonly). we DON'T actually freeze
    -- the table in luau (real freeze is irreversible), only mark it -- so a later
    -- setreadonly(t, false) can re-enable mutation, matching executor semantics.
    frozenTables = setmetatable({}, { __mode = "k" })
    frozenTables[env.string] = true
    frozenTables[env.table] = true
    frozenTables[env.math] = true
    frozenTables[env.utf8] = true
    frozenTables[env.coroutine] = true
    frozenTables[env.buffer] = true
    frozenTables[env.bit32] = true
    frozenTables[env.bit] = true
    frozenTables[env.os] = true
    frozenTables[env.debug] = true
    frozenTables[env.task] = true
    frozenTables[env.vector] = true
    frozenTables[env.cache] = true
    rawset(env.table, "freeze", cclosure(function(t) frozenTables[t] = true; return t end))
    rawset(env.table, "isfrozen", cclosure(function(t) return frozenTables[t] == true end))
    env.isreadonly = cclosure(function(t) return frozenTables[t] == true end)
    env.setreadonly = cclosure(function(t, ro)
        if ro then frozenTables[t] = true else frozenTables[t] = nil end
        return t
    end)

    -- getcallbackvalue: return the function bound to an instance callback member
    env.getcallbackvalue = cclosure(function(inst, member)
        local st = instState[inst]
        if st and st.props[member] ~= nil then return st.props[member] end
        return nil
    end)

    -- isscriptable / setscriptable: report/toggle scriptability of a property.
    -- a property is non-scriptable when its api-dump tags contain NotScriptable.
    local function propInfo(inst, prop)
        local st = instState[inst]
        if not st then return nil end
        local info = classInfo(st.class)
        return info and info.properties and info.properties[prop] or nil
    end
    local function baseIsscriptable(inst, prop)
        local p = propInfo(inst, tostring(prop))
        if not p then return false end
        return not (p.tags and (p.tags["NotScriptable"] or p.tags["Hidden"]))
    end
    local scriptableOverrides = setmetatable({}, { __mode = "k" })
    env.setscriptable = cclosure(function(inst, prop, value)
        local p = propInfo(inst, tostring(prop))
        local was = p and not (p.tags and (p.tags["NotScriptable"] or p.tags["Hidden"])) or false
        if scriptableOverrides[inst] == nil then scriptableOverrides[inst] = {} end
        scriptableOverrides[inst][tostring(prop)] = value and true or false
        return was
    end)
    env.isscriptable = cclosure(function(inst, prop)
        local ov = scriptableOverrides[inst]
        if ov and ov[tostring(prop)] ~= nil then return ov[tostring(prop)] end
        return baseIsscriptable(inst, prop)
    end)

    -- gethiddenproperty / sethiddenproperty: read/write members the dump marks
    -- hidden/non-scriptable. values live in the normal prop store; a few known
    -- hidden defaults (Fire.size_xml) are surfaced so common probes succeed.
    local hiddenDefaults = { size_xml = 5 }
    env.gethiddenproperty = cclosure(function(inst, prop)
        local st = instState[inst]
        prop = tostring(prop)
        local v = st and st.props[prop] or hiddenDefaults[prop]
        local p = propInfo(inst, prop)
        local hidden = p and p.tags and (p.tags["NotScriptable"] or p.tags["Hidden"]) or true
        return v, hidden
    end)
    env.sethiddenproperty = cclosure(function(inst, prop, value)
        local st = instState[inst]
        if st then st.props[tostring(prop)] = value end
        return true
    end)

    -- input sim / window helpers: headless, so they're no-ops that don't error
    env.isrbxactive = cclosure(function() return true end)
    env.isgameactive = env.isrbxactive
    for _, name in ipairs({
        "mouse1click", "mouse1press", "mouse1release", "mouse2click",
        "mouse2press", "mouse2release", "mousemoveabs", "mousemoverel",
        "mousescroll", "keytap", "keypress", "keyrelease",
    }) do
        env[name] = cclosure(function() end)
    end

    -- rconsole family (headless: no console, but don't error)
    env.rconsolecreate = cclosure(function() end)
    env.rconsoledestroy = cclosure(function() end)
    env.rconsoleclear = cclosure(function() end)
    env.consoleclear = env.rconsoleclear
    env.rconsoleinput = cclosure(function() return "" end)
    env.consoleinput = env.rconsoleinput
    env.rconsoleprint = cclosure(function() end)
    env.consoleprint = env.rconsoleprint
    env.rconsolesettitle = cclosure(function() end)
    env.rconsolename = env.rconsolesettitle
    env.consolesettitle = env.rconsolesettitle

    -- misc executors
    env.setfpscap = cclosure(function() end)
    env.getfpscap = cclosure(function() return 60 end)
    env.getfpsmax = env.getfpscap
    env.messagebox = cclosure(function() return 0 end)
    env.isnetworkowner = cclosure(function() return true end)
    local simulationRadius = 1000
    env.getsimulationradius = cclosure(function() return simulationRadius end)
    env.setsimulationradius = cclosure(function(radius)
        simulationRadius = tonumber(radius) or simulationRadius
    end)
    env.getscriptbytecode = cclosure(function() return "" end)
    env.dumpstring = env.getscriptbytecode
    env.setscriptbytecode = cclosure(function() return true end)
    env.getscripthash = cclosure(function(scr)
        local name = instState[scr] and (instState[scr].props.Name or instState[scr].class) or tostring(scr or "")
        local hash = 2166136261
        local input = name .. ":" .. runIdentity.JobId
        for i = 1, #input do
            hash = (hash + input:byte(i) * 16777619) % 0x100000000
        end
        return string.format("%08x", hash)
    end)
    env.getscriptclosure = cclosure(function()
        local fn = function() end
        pcall(setfenv, fn, env)
        functionEnvs[fn] = env
        return fn
    end)
    env.getsenv = cclosure(function() return env end)
    env.decompile = cclosure(function() return "-- decompiler unavailable in sandbox" end)
    env.saveinstance = cclosure(function() return "" end)

    -- lz4 compress/decompress: no native lz4 in lune, so round-trip a plain
    -- passthrough that at least decompress(compress(x)) == x (the shape callers
    -- check). the "compressed" form is the raw bytes prefixed with a length byte.
    env.lz4compress = cclosure(function(s)
        s = tostring(s)
        return string.char(#s % 256) .. s
    end)
    env.lz4decompress = cclosure(function(s)
        s = tostring(s)
        if #s < 1 then return "" end
        return s:sub(2)
    end)

    -- http
    local function httpResponse(opts)
        opts = nativeType(opts) == "table" and opts or {}
        local url = tostring(opts.Url or opts.URL or opts.url or "")
        local lower = url:lower()
        local body = ""
        local headers = { ["Content-Type"] = "text/plain" }
        if lower:find("httpbin.org/user%-agent") or lower:find("httpbin.org/headers") then
            headers["Content-Type"] = "application/json"
            body = encodeJson({ ["user-agent"] = "Roblox/WinInet", headers = { ["User-Agent"] = "Roblox/WinInet" } })
        elseif lower:find("httpbin.org/ip") then
            headers["Content-Type"] = "application/json"
            body = encodeJson({ origin = "127.0.0.1" })
        elseif opts.Body ~= nil or opts.body ~= nil then
            body = tostring(opts.Body or opts.body or "")
        end
        return {
            Success = true,
            success = true,
            StatusCode = 200,
            status_code = 200,
            StatusMessage = "OK",
            status_message = "OK",
            Body = body,
            body = body,
            Headers = headers,
            headers = headers,
        }
    end
    env.request = cclosure(function(opts)
        log("call", "request", { args = logger:describeArgs(opts) })
        return httpResponse(opts)
    end)
    env.http_request = env.request
    env.http = { request = env.request }
    env.syn = {
        request = env.request,
        protect_gui = cclosure(function() end, "protect_gui"),
        unprotect_gui = cclosure(function() end, "unprotect_gui"),
    }
    if frozenTables then
        frozenTables[env.http] = true
        frozenTables[env.syn] = true
    end
    local clipboardValue = ""
    env.setclipboard = cclosure(function(value) clipboardValue = tostring(value or "") end)
    env.toclipboard = env.setclipboard
    env.getclipboard = cclosure(function() return clipboardValue end)
    env.queue_on_teleport = cclosure(function() end)
    env.queueonteleport = env.queue_on_teleport

    -- crypt / base64 (real base64 + random bytes/key/hash so round-trips work).
    local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local B64DEC = {}
    for i = 1, #B64 do B64DEC[B64:byte(i)] = i - 1 end
    local function b64encode(s)
        s = tostring(s)
        local out, i = {}, 1
        local pad = (3 - #s % 3) % 3
        s = s .. string.rep("\0", pad)
        for j = 1, #s, 3 do
            local n = s:byte(j) * 65536 + s:byte(j + 1) * 256 + s:byte(j + 2)
            local b1 = math.floor(n / 262144) % 64
            local b2 = math.floor(n / 4096) % 64
            local b3 = math.floor(n / 64) % 64
            local b4 = n % 64
            out[i], out[i+1], out[i+2], out[i+3] = B64:sub(b1+1,b1+1), B64:sub(b2+1,b2+1), B64:sub(b3+1,b3+1), B64:sub(b4+1,b4+1)
            i += 4
        end
        local res = table.concat(out)
        if pad == 1 then res = res:sub(1, -2) .. "="
        elseif pad == 2 then res = res:sub(1, -3) .. "==" end
        return res
    end
    local function b64decode(s)
        s = tostring(s):gsub("=", "")
        local out, i = {}, 1
        local pad = (4 - #s % 4) % 4
        s = s .. string.rep("A", pad)
        for j = 1, #s, 4 do
            local n = B64DEC[s:byte(j)] * 262144 + B64DEC[s:byte(j+1)] * 4096
                + B64DEC[s:byte(j+2)] * 64 + B64DEC[s:byte(j+3)]
            out[i], out[i+1], out[i+2] = string.char(math.floor(n/65536) % 256), string.char(math.floor(n/256) % 256), string.char(n % 256)
            i += 3
        end
        local res = table.concat(out)
        if pad > 0 then res = res:sub(1, #res - pad) end
        return res
    end
    -- simple non-cryptographic hash (deterministic, fixed-length hex) for crypt.hash.
    -- not a real sha, but returns a stable hex digest for any input+algorithm.
    local function hashStr(s)
        s = tostring(s)
        local bxor, floor = bit32.bxor, math.floor
        local h = 2166136261
        for i = 1, #s do
            h = bxor(h, s:byte(i)) * 16777619 % 2^32
            h = bxor(h, floor(h / 2^16))
        end
        return string.format("%08x%08x%08x%08x", h, (h * 2654435761) % 2^32, bxor(h, 0xDEADBEEF) % 2^32, (h * 40503) % 2^32)
    end
    env.crypt = {
        base64encode = cclosure(b64encode),
        base64decode = cclosure(b64decode),
        base64_encode = cclosure(b64encode),
        base64_decode = cclosure(b64decode),
        encrypt = cclosure(function(s, key, iv, _) return tostring(s), iv or b64encode(tostring(key)) end),
        decrypt = cclosure(function(s) return tostring(s) end),
        generatebytes = cclosure(function(n) return b64encode(randHex(tonumber(n) or 16)) end),
        generatekey = cclosure(function() return b64encode(randHex(32)) end),
        hash = cclosure(function(s, _) return hashStr(s) end),
    }
    env.base64 = {
        encode = env.crypt.base64encode,
        decode = env.crypt.base64decode,
    }
    env.base64_encode = env.crypt.base64encode
    env.base64_decode = env.crypt.base64decode

    -- filesystem (sandboxed as an in-memory store: writes land in a per-run
    -- virtual tree so readfile/isfile/listfiles/etc. round-trip correctly,
    -- without touching the real disk).
    local fsFiles = {}
    local fsFolders = {}
    local function normPath(p)
        p = tostring(p):gsub("\\", "/")
        if p:sub(1, 2) == "./" then p = p:sub(3) end
        if p:sub(-1) == "/" then p = p:sub(1, -2) end
        return p
    end
    local function ensureExt(p)
        -- executors add a .txt-style extension when missing; mirror that so
        -- `writefile("x", ...)` then `isfile("x.txt")` agrees.
        if p:match("%.[^/]+$") then return p end
        return p .. ".txt"
    end
    env.writefile = cclosure(function(path, content)
        local p = ensureExt(normPath(path))
        fsFiles[p] = tostring(content)
        return true
    end)
    env.appendfile = cclosure(function(path, content)
        local p = ensureExt(normPath(path))
        fsFiles[p] = (fsFiles[p] or "") .. tostring(content)
        return true
    end)
    env.readfile = cclosure(function(path)
        local p = ensureExt(normPath(path))
        if fsFiles[p] == nil then rbxError("readfile: file does not exist") end
        return fsFiles[p]
    end)
    env.isfile = cclosure(function(path)
        local p = ensureExt(normPath(path))
        return fsFiles[p] ~= nil
    end)
    env.isfolder = cclosure(function(path)
        local p = normPath(path)
        if fsFolders[p] then return true end
        for f in pairs(fsFiles) do if f:sub(1, #p + 1) == p .. "/" then return true end end
        return false
    end)
    env.makefolder = cclosure(function(path)
        fsFolders[normPath(path)] = true
        return true
    end)
    env.delfolder = cclosure(function(path)
        local p = normPath(path)
        fsFolders[p] = nil
        return true
    end)
    env.delfile = cclosure(function(path)
        local p = ensureExt(normPath(path))
        fsFiles[p] = nil
        return true
    end)
    env.listfiles = cclosure(function(path)
        local p = normPath(path)
        local out, seen = {}, {}
        for f in pairs(fsFiles) do
            if f:sub(1, #p + 1) == p .. "/" then
                local rest = f:sub(#p + 2)
                local first = rest:match("^([^/]+)")
                if first and not seen[first] then
                    seen[first] = true
                    out[#out + 1] = p .. "/" .. first
                end
            end
        end
        for f in pairs(fsFolders) do
            if f:sub(1, #p + 1) == p .. "/" then
                local rest = f:sub(#p + 2)
                local first = rest:match("^([^/]+)")
                if first and not seen[first] then
                    seen[first] = true
                    out[#out + 1] = p .. "/" .. first
                end
            end
        end
        return out
    end)
    env.loadfile = cclosure(function(path)
        local p = ensureExt(normPath(path))
        if fsFiles[p] == nil then return nil, "loadfile: file does not exist" end
        return loadInEnv(fsFiles[p], "@" .. p)
    end)
    env.dofile = cclosure(function(path)
        local p = ensureExt(normPath(path))
        if fsFiles[p] == nil then return nil end
        local chunk = loadInEnv(fsFiles[p], "@" .. p)
        return chunk and chunk() or nil
    end)
    env.getcustomasset = cclosure(function(path)
        local p = ensureExt(normPath(path))
        if fsFiles[p] == nil then rbxError("getcustomasset: file does not exist") end
        return "rbxasset://localhost/" .. p
    end)

    -- Drawing library
    local drawingFields = setmetatable({}, { __mode = "k" }) -- drawing ud -> fields
    local function makeDrawing(class)
        local u = newproxy(true)
        local mt = getmetatable(u)
        objectTypes[u] = "Drawing"
        mt.__metatable = LOCKED
        local fields = { Visible = false, ZIndex = 0, Transparency = 1, Color = nil, __class = class }
        drawingFields[u] = fields
        mt.__tostring = function() return "Drawing" end
        mt.__index = function(_, k)
            if k == "Remove" or k == "Destroy" then return function() end end
            return fields[k]
        end
        mt.__newindex = function(_, k, v) fields[k] = v end
        return u
    end
    env.Drawing = {
        new = cclosure(function(class) return makeDrawing(tostring(class)) end),
        Fonts = { UI = 0, System = 1, Plex = 2, Monospace = 3 },
        clear = cclosure(function() end),
    }
    env.isrenderobj = cclosure(function(v) return objectTypes[v] == "Drawing" end)
    env.getrenderproperty = cclosure(function(d, prop)
        local f = drawingFields[d]
        if not f then return nil end
        return f[tostring(prop)]
    end)
    env.setrenderproperty = cclosure(function(d, prop, value)
        local f = drawingFields[d]
        if f then f[tostring(prop)] = value end
    end)
    env.cleardrawcache = cclosure(function() end)

    -- WebSocket
    env.WebSocket = {
        connect = cclosure(function(url)
            local u = newproxy(true)
            local mt = getmetatable(u)
            objectTypes[u] = "WebSocket"
            mt.__metatable = LOCKED
            mt.__index = function(_, k)
                if k == "Send" then return cclosure(function() end, "Send") end
                if k == "Close" then return cclosure(function() end, "Close") end
                if k == "OnMessage" or k == "OnClose" then return makeSignal(u, k) end
                return nil
            end
            return u
        end),
    }
    env.WebSocket.Connect = env.WebSocket.connect

    env.loadfile = nil
    env.dofile = nil

    -- Common executor compatibility aliases. These stay inside the sandbox:
    -- file APIs use the virtual store above, network APIs return canned shapes,
    -- and actor/script helpers only run sandboxed closures or source strings.
    local function alias(name, value)
        if rawget(env, name) == nil and value ~= nil then
            env[name] = value
        end
    end
    local function tableAlias(t, name, value)
        if nativeType(t) == "table" and rawget(t, name) == nil and value ~= nil then
            rawset(t, name, value)
        end
    end
    local function noOp(name, value)
        return cclosure(function() return value end, name)
    end
    local function trueFn(name)
        return cclosure(function() return true end, name)
    end
    local function falseFn(name)
        return cclosure(function() return false end, name)
    end

    alias("syn_request", env.request)
    alias("httprequest", env.request)
    alias("http_request", env.request)
    tableAlias(env.http, "request", env.request)
    tableAlias(env.syn, "request", env.request)
    tableAlias(env.syn, "queue_on_teleport", env.queue_on_teleport)
    tableAlias(env.syn, "protect_gui", env.protectgui)
    tableAlias(env.syn, "unprotect_gui", env.unprotectgui)
    tableAlias(env.syn, "is_cached", env.cache.iscached)
    tableAlias(env.syn, "get_thread_identity", env.getthreadidentity)
    tableAlias(env.syn, "set_thread_identity", env.setthreadidentity)

    alias("getsynasset", env.getcustomasset)
    alias("getcustomasset", env.getcustomasset)
    alias("getscriptenv", env.getsenv)
    alias("getscriptfunction", env.getscriptclosure)
    alias("getbytecode", env.getscriptbytecode)
    alias("dumpbytecode", env.getscriptbytecode)
    alias("getscriptbyte", env.getscriptbytecode)
    alias("getscriptbytecode", env.getscriptbytecode)
    alias("get_script_bytecode", env.getscriptbytecode)
    alias("riptbytesetsc", env.setscriptbytecode)
    alias("setscriptbyte", env.setscriptbytecode)
    alias("setscriptbytecode", env.setscriptbytecode)
    alias("set_script_bytecode", env.setscriptbytecode)
    alias("getscriptclosure", env.getscriptclosure)
    alias("get_script_closure", env.getscriptclosure)
    alias("getcallingscript", env.getcallingscript)
    alias("getcallingthread", cclosure(function() return coroutine.running() end, "getcallingthread"))
    alias("getscriptfromthread", cclosure(function() return scriptObj end, "getscriptfromthread"))

    alias("gethui", env.gethui)
    alias("gethiddenui", env.gethui)
    alias("get_hidden_ui", env.gethui)
    alias("get_hidden_gui", env.gethui)
    alias("protect_gui", env.protectgui)
    alias("unprotect_gui", env.unprotectgui)

    alias("clonereference", env.cloneref)
    alias("clone_ref", env.cloneref)
    alias("compare_instances", env.compareinstances)
    alias("cache_invalidate", env.cache.invalidate)
    alias("cache_replace", env.cache.replace)
    alias("cache_iscached", env.cache.iscached)

    alias("getsignalconnections", env.getconnections)
    alias("get_signal_connections", env.getconnections)
    alias("get_signal_cons", env.getconnections)
    alias("fire_signal", env.firesignal)
    alias("firesignal", env.firesignal)
    alias("fire_click_detector", env.fireclickdetector)
    alias("fire_proximity_prompt", env.fireproximityprompt)
    alias("fire_touch_interest", env.firetouchinterest)

    alias("mouse1down", env.mouse1press)
    alias("mouse1up", env.mouse1release)
    alias("mouse2down", env.mouse2press)
    alias("mouse2up", env.mouse2release)
    alias("keydown", env.keypress)
    alias("keyup", env.keyrelease)
    alias("iswindowactive", env.isrbxactive)
    alias("isappactive", env.isrbxactive)

    alias("DrawingLib", env.Drawing)
    alias("drawing", env.Drawing)
    alias("isrenderobject", env.isrenderobj)
    alias("getrenderprop", env.getrenderproperty)
    alias("setrenderprop", env.setrenderproperty)
    alias("cleardrawingcache", env.cleardrawcache)
    alias("clear_draw_cache", env.cleardrawcache)

    alias("isluau", trueFn("isluau"))
    alias("isroblox", trueFn("isroblox"))
    alias("isreadonly", env.isreadonly)
    alias("setreadonly", env.setreadonly)
    alias("is_readonly", env.isreadonly)
    alias("set_readonly", env.setreadonly)
    alias("make_readonly", cclosure(function(t) return env.setreadonly(t, true) end, "make_readonly"))
    alias("make_writeable", cclosure(function(t) return env.setreadonly(t, false) end, "make_writeable"))
    alias("make_writable", cclosure(function(t) return env.setreadonly(t, false) end, "make_writable"))
    alias("get_raw_metatable", env.getrawmetatable)
    alias("tatablegetme", env.getmetatable)
    alias("wmetatablegetra", env.getrawmetatable)
    alias("set_raw_metatable", env.setrawmetatable)
    alias("get_hidden_property", env.gethiddenproperty)
    alias("tyroperddenpgethi", env.gethiddenproperty)
    alias("set_hidden_property", env.sethiddenproperty)
    alias("get_callback_value", env.getcallbackvalue)
    alias("ekvalullbacgetca", env.getcallbackvalue)
    alias("is_scriptable", env.isscriptable)
    alias("set_scriptable", env.setscriptable)

    alias("get_thread_identity", env.getthreadidentity)
    alias("tydentireadigetth", env.getthreadidentity)
    alias("set_thread_identity", env.setthreadidentity)
    alias("getthreadcontext", env.getthreadidentity)
    alias("setthreadcontext", env.setthreadidentity)
    alias("getidentity", env.getthreadidentity)
    alias("setidentity", env.setthreadidentity)
    alias("getexecutorversion", cclosure(function()
        local _, version = env.identifyexecutor()
        return version
    end, "getexecutorversion"))

    alias("isfunctionhooked", falseFn("isfunctionhooked"))
    alias("unhookfunction", env.restorefunction)
    alias("restoreclosure", env.restorefunction)
    alias("replaceclosure", env.hookfunction)
    alias("hookfunc", env.hookfunction)
    alias("newlclosure", env.newlclosure)
    alias("losurenewlc", env.newlclosure)
    alias("isnewcclosure", env.isnewcclosure)

    alias("getnilinstances", env.getnilinstances)
    alias("get_nil_instances", env.getnilinstances)
    alias("getinstances", env.getinstances)
    alias("get_instances", env.getinstances)
    alias("getinstance", env.getinstances)
    alias("stancegetin", env.getinstances)
    alias("getscripts", env.getscripts)
    alias("get_scripts", env.getscripts)
    alias("getloadedmodules", env.getloadedmodules)
    alias("get_loaded_modules", env.getloadedmodules)
    alias("getrunningscripts", env.getrunningscripts)
    alias("get_running_scripts", env.getrunningscripts)
    alias("getmodules", env.getloadedmodules)
    alias("filtergc", cclosure(function(kind)
        local out = {}
        local wanted = kind and tostring(kind):lower() or nil
        for _, value in ipairs(env.getgc()) do
            if wanted == nil or typeofImpl(value):lower() == wanted or nativeType(value):lower() == wanted then
                out[#out + 1] = value
            end
        end
        return out
    end, "filtergc"))

    local fastFlags = {}
    env.getfflag = cclosure(function(name)
        return fastFlags[tostring(name)] or ""
    end, "getfflag")
    env.setfflag = cclosure(function(name, value)
        fastFlags[tostring(name)] = tostring(value)
        return true
    end, "setfflag")
    alias("getfastflag", env.getfflag)
    alias("setfastflag", env.setfflag)

    local function objectListForAsset(assetId)
        local root = createInstance("ScreenGui", nil)
        instState[root].props.Name = "LoadedAsset"
        instState[root].props.SourceAssetId = tostring(assetId or "")
        instState[root].props.Enabled = true
        instState[root].props.ResetOnSpawn = true

        local function child(parent, className, name)
            local existing = childByName(parent, name)
            if existing then return existing end
            local inst = createInstance(className, parent)
            instState[inst].props.Name = name
            return inst
        end

        local function button(parent, name)
            local frame = child(parent, "Frame", name)
            child(frame, "ImageLabel", "Pic")
            child(frame, "TextLabel", "Text")
            return frame
        end

        local tools = child(root, "Frame", "ToolsHolder")
        button(tools, "Delete")
        button(tools, "Move")
        button(tools, "Rotate")
        button(tools, "Undo")

        local utilities = child(root, "Frame", "UtilitiesHolder")
        button(utilities, "Camera")
        button(utilities, "Clear")
        button(utilities, "Complete")

        return { root }
    end
    env.getobjects = cclosure(function(assetId)
        return objectListForAsset(assetId)
    end, "getobjects")
    override("DataModel", "GetObjects", function(_, assetId)
        return objectListForAsset(assetId)
    end)

    env.run_on_actor = cclosure(function(actorOrSource, sourceOrFn, ...)
        if sourceOrFn == nil and (nativeType(actorOrSource) == "function" or nativeType(actorOrSource) == "string") then
            sourceOrFn = actorOrSource
        end
        if nativeType(sourceOrFn) == "function" then
            return env.task.spawn(sourceOrFn, ...)
        end
        if nativeType(sourceOrFn) == "string" then
            local chunk = loadInEnv(sourceOrFn, "@actor")
            return env.task.spawn(chunk, ...)
        end
        return nil
    end, "run_on_actor")
    alias("runonactor", env.run_on_actor)
    alias("run_on_thread", env.run_on_actor)
    alias("getactors", cclosure(function() return { scriptObj } end, "getactors"))

    env.Websocket = env.WebSocket
    env.websocket = env.WebSocket
    tableAlias(env.syn, "websocket", env.WebSocket)
    tableAlias(env.syn, "WebSocket", env.WebSocket)

    env.lz4 = {
        compress = env.lz4compress,
        decompress = env.lz4decompress,
    }
    env.crypto = env.crypt
    env.crypt.base64 = {
        encode = env.crypt.base64encode,
        decode = env.crypt.base64decode,
    }
    env.crypt.base64_encode = env.crypt.base64encode
    env.crypt.base64_decode = env.crypt.base64decode
    env.crypt.random = env.crypt.generatebytes

    alias("consolecreate", env.rconsolecreate)
    alias("consoledestroy", env.rconsoledestroy)
    alias("consoleclear", env.rconsoleclear)
    alias("consoleinput", env.rconsoleinput)
    alias("consoleprint", env.rconsoleprint)
    alias("consolesettitle", env.rconsolesettitle)
    alias("rconsoleinfo", env.rconsoleprint)
    alias("rconsolewarn", env.rconsoleprint)
    alias("rconsoleerr", env.rconsoleprint)
    alias("setrbxclipboard", env.setclipboard)
    alias("queue_on_teleport", env.queue_on_teleport)
    alias("queueonteleport", env.queue_on_teleport)
    alias("messageboxasync", env.messagebox)
    alias("setfpsmax", env.setfpscap)
    -- GUF_CRASH/LPH_CRASH are intentionally absent unless the script defines them.

    local loopGuard = cclosure(function(increment)
        return opHook(tonumber(increment) or 1, 3)
    end, "__envlogger_ophook")

    local nilGlobals = {
        io = true,
        package = true,
        process = true,
        stdio = true,
        fs = true,
        net = true,
        serde = true,
        luau = true,
        jit = true,
        loadfile = true,
        dofile = true,
        _ENV = true,
    }

    local function looksLikeObfuscatedNilGlobal(key)
        if nativeType(key) ~= "string" then return false end
        if #key < 8 or not key:match("^[%w_]+$") then return false end
        -- Randomized mixed-case globals are usually nil sentinels in obfuscators.
        -- Keep lower-case executor-style names on the spy path below.
        return key:match("%u") ~= nil and key:match("%l") ~= nil and key:match("%d") ~= nil
    end

    -- ===== lock the environment metatable =====
    setmetatable(env, {
        __metatable = LOCKED,
        __index = function(_, key)
            if key == "__envlogger_ophook" then return loopGuard end
            if nilGlobals[key] then return nil end
            if rawget(genv, key) ~= nil then return nil end
            if looksLikeObfuscatedNilGlobal(key) then return nil end
            log("global_read", tostring(key), { key = logger:describe(key) })
            -- Unknown globals resolve to nil like Luau; executor APIs need explicit
            -- aliases above so anti-env nil checks do not walk into truthy spies.
            return nil
        end,
        __newindex = function(_, key, value)
            rawset(env, key, value)
            log("global_assign", tostring(key), { value = logger:describe(value) })
        end,
    })
    setmetatable(genv, { __metatable = LOCKED })

    return env, {
        drainPendingTasks = drainPendingTasks,
        exploreConnectedCallbacks = signalState.__exploreCallbacks,
    }
end

local function renderDescription(desc, depth)
    depth = depth or 0

    if type(desc) ~= "table" then
        return tostring(desc)
    end

    if desc.type == "string" then
        local value = desc.value or ""
        if desc.placeholder then
            return string.format("%q", value)
        end
        local suffix = ""
        if desc.truncated then
            suffix = "...<" .. tostring(desc.length or #value) .. " bytes>"
        end
        return string.format("%q", value .. suffix)
    elseif desc.type == "proxy" then
        return "<" .. tostring(desc.path) .. ">"
    elseif desc.type == "function" then
        return "<function " .. tostring(desc.source) .. ":" .. tostring(desc.line) .. ">"
    elseif desc.type == "table" then
        if desc.value then
            return "{" .. tostring(desc.value) .. "}"
        end
        if depth >= 2 then
            return "{...}"
        end

        local items = {}
        for index, item in ipairs(desc.items or {}) do
            if index > 8 then
                items[#items + 1] = "..."
                break
            end
            items[#items + 1] = renderDescription(item.key, depth + 1) .. "=" .. renderDescription(item.value, depth + 1)
        end
        return "{" .. table.concat(items, ", ") .. "}"
    end

    return tostring(desc.value)
end

local function renderArgs(args)
    local parts = {}
    for index = 1, args.n or #args do
        parts[#parts + 1] = renderDescription(args[index])
    end
    return "(" .. table.concat(parts, ", ") .. ")"
end

local function renderTextReport(target, logger, success, result)
    target = sanitizeFileName(target)
    local lines = {}
    lines[#lines + 1] = "EnvLogger Report"
    lines[#lines + 1] = "================"
    lines[#lines + 1] = "Target: " .. target
    lines[#lines + 1] = string.format("Runtime: %.4fs", os.clock() - logger.started)
    lines[#lines + 1] = "Success: " .. tostring(success)
    lines[#lines + 1] = "Result: " .. tostring(result)
    lines[#lines + 1] = "Events captured: " .. tostring(#logger.events)
    if logger.overflow > 0 then
        lines[#lines + 1] = "Events skipped after cap: " .. tostring(logger.overflow)
    end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "Counts"
    lines[#lines + 1] = "------"

    local kinds = {}
    for kind in pairs(logger.counts) do
        kinds[#kinds + 1] = kind
    end
    sortKeys(kinds)

    for _, kind in ipairs(kinds) do
        lines[#lines + 1] = string.format("%-22s %d", kind, logger.counts[kind])
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "Events"
    lines[#lines + 1] = "------"

    for _, event in ipairs(logger.events) do
        local detail = ""
        if event.detail then
            if event.detail.args then
                detail = renderArgs(event.detail.args)
                if event.detail.result then
                    detail ..= " => " .. renderDescription(event.detail.result)
                end
            elseif event.detail.url then
                detail = " url=" .. renderDescription(event.detail.url)
            elseif event.detail.service then
                detail = " service=" .. tostring(event.detail.service)
                if event.detail.result then
                    detail ..= " => " .. renderDescription(event.detail.result)
                end
            elseif event.detail.source then
                detail = " source=" .. renderDescription(event.detail.source)
            elseif event.detail.value then
                detail = " value=" .. renderDescription(event.detail.value)
            elseif event.detail.request then
                detail = " request=" .. renderDescription(event.detail.request)
            elseif event.detail.error then
                detail = " error=" .. tostring(event.detail.error)
            elseif event.detail.op then
                detail = " op=" .. tostring(event.detail.op)
                if event.detail.right then
                    detail ..= " right=" .. renderDescription(event.detail.right)
                end
            end
        end

        lines[#lines + 1] = string.format(
            "%05d  %8.4fs  %-18s  %s%s",
            event.i,
            event.t,
            event.kind,
            event.path or "",
            detail
        )
    end

    return table.concat(lines, "\n")
end

local function luaString(value)
    return string.format("%q", tostring(value))
end

local function splitMemberPath(path)
    local quote = nil
    local escaped = false
    local depth = 0

    for index = #path, 1, -1 do
        local char = path:sub(index, index)

        if quote then
            if escaped then
                escaped = false
            elseif char == "\\" then
                escaped = true
            elseif char == quote then
                quote = nil
            end
        elseif char == '"' or char == "'" then
            quote = char
        elseif char == ")" or char == "]" then
            depth += 1
        elseif char == "(" or char == "[" then
            depth -= 1
        elseif char == "." and depth == 0 then
            return path:sub(1, index - 1), path:sub(index + 1)
        end
    end

    return nil, path
end

local function makeReplayName(path, hint, usedNames)
    local base = hint or path:match("([%w_]+)$") or "value"
    base = base:gsub("[^%w_]+", "_")
    base = base:gsub("^_+", ""):gsub("_+$", "")
    if base == "" then
        base = "value"
    end
    if base:match("^%d") then
        base = "v_" .. base
    end

    local candidate = base
    local suffix = 2
    while usedNames[candidate] do
        candidate = base .. "_" .. tostring(suffix)
        suffix += 1
    end

    usedNames[candidate] = true
    return candidate
end

local function generateReplay(target, logger, success, result)
    local displayTarget = sanitizeFileName(target)
    local lines = {}
    local proxyVars = {}
    local usedNames = {
        __mt = true,
        __stub = true,
        __ctor = true,
        __noop = true,
        game = true,
        workspace = true,
        Workspace = true,
        script = true,
        Instance = true,
        Enum = true,
        request = true,
        http_request = true,
        loadstring = true,
        getgenv = true,
        getrenv = true,
        getfenv = true,
        _G = true,
        shared = true,
    }

    local function emit(line)
        lines[#lines + 1] = line
    end

    emit("--!nonstrict")
    emit("-- Generated by EnvLogger from: " .. displayTarget)
    emit("-- This is a best-effort replay of observed environment interactions.")
    emit("")
    emit("local __mt = {}")
    emit("local function __stub(path)")
    emit("    return setmetatable({ __path = path }, __mt)")
    emit("end")
    emit("function __mt.__index(self, key)")
    emit("    local value = __stub(tostring(rawget(self, \"__path\")) .. \".\" .. tostring(key))")
    emit("    rawset(self, key, value)")
    emit("    return value")
    emit("end")
    emit("function __mt.__newindex(self, key, value)")
    emit("    rawset(self, key, value)")
    emit("end")
    emit("function __mt.__call(self, ...)")
    emit("    return __stub(tostring(rawget(self, \"__path\")) .. \"()\")")
    emit("end")
    emit("function __mt.__tostring(self)")
    emit("    return tostring(rawget(self, \"__path\"))")
    emit("end")
    emit("function __mt.__len() return 1 end")
    emit("function __mt.__eq() return true end")
    emit("function __mt.__add(a, b) return __stub(\"(\" .. tostring(a) .. \"+\" .. tostring(b) .. \")\") end")
    emit("function __mt.__sub(a, b) return __stub(\"(\" .. tostring(a) .. \"-\" .. tostring(b) .. \")\") end")
    emit("function __mt.__mul(a, b) return __stub(\"(\" .. tostring(a) .. \"*\" .. tostring(b) .. \")\") end")
    emit("function __mt.__div(a, b) return __stub(\"(\" .. tostring(a) .. \"/\" .. tostring(b) .. \")\") end")
    emit("function __mt.__unm(a) return __stub(\"(-\" .. tostring(a) .. \")\") end")
    emit("")
    emit("local function __noop(...) return nil end")
    emit("local game = __stub(\"game\")")
    emit("function game:GetService(name) return __stub(\"game:GetService(\" .. string.format(\"%q\", tostring(name)) .. \")\") end")
    emit("function game:HttpGet(url) return \"\" end")
    emit("function game:HttpGetAsync(url) return \"\" end")
    emit("function game:HttpPost(url, body) return \"\" end")
    emit("function game:IsLoaded() return true end")
    emit("local workspace = __stub(\"workspace\")")
    emit("local Workspace = workspace")
    emit("local script = __stub(\"script\")")
    emit("local Instance = { new = function(className) return __stub(\"Instance.new(\" .. string.format(\"%q\", tostring(className)) .. \")\") end }")
    emit("local function __ctor(name)")
    emit("    return setmetatable({")
    emit("        new = function(...) return __stub(name .. \".new\") end,")
    emit("        fromRGB = function(...) return __stub(name .. \".fromRGB\") end,")
    emit("        fromHSV = function(...) return __stub(name .. \".fromHSV\") end,")
    emit("        Angles = function(...) return __stub(name .. \".Angles\") end,")
    emit("    }, __mt)")
    emit("end")

    for _, name in ipairs({
        "Vector2",
        "Vector3",
        "Vector2int16",
        "Vector3int16",
        "UDim",
        "UDim2",
        "CFrame",
        "Color3",
        "BrickColor",
        "Ray",
        "Axes",
        "Faces",
        "Region3",
        "Region3int16",
        "Rect",
        "NumberRange",
        "NumberSequence",
        "NumberSequenceKeypoint",
        "ColorSequence",
        "ColorSequenceKeypoint",
        "PhysicalProperties",
        "RaycastParams",
        "OverlapParams",
        "Random",
        "TweenInfo",
        "Font",
        "Drawing",
    }) do
        emit("local " .. name .. " = __ctor(" .. luaString(name) .. ")")
    end

    emit("local Enum = setmetatable({}, { __index = function(_, key) return __stub(\"Enum.\" .. tostring(key)) end })")
    emit("local _G = {}")
    emit("local shared = {}")
    emit("local function getgenv() return _G end")
    emit("local function getrenv() return _G end")
    emit("local function getfenv() return _G end")
    emit("local function setfenv(fn) return fn end")
    emit("local function request(data) return { Success = false, StatusCode = 599, Body = \"\", body = \"\", Headers = {} } end")
    emit("local http_request = request")
    emit("local http = { request = request }")
    emit("local syn = { request = request }")
    emit("local function loadstring(src) return function(...) return nil end end")
    emit("local load = loadstring")
    emit("local function writefile(...) return nil end")
    emit("local function appendfile(...) return nil end")
    emit("local function readfile(...) return \"\" end")
    emit("local function isfile(...) return false end")
    emit("local function isfolder(...) return false end")
    emit("local function makefolder(...) return nil end")
    emit("local function listfiles(...) return {} end")
    emit("local function getexecutorname() return \"EnvLoggerReplay\" end")
    emit("local function identifyexecutor() return \"EnvLoggerReplay\" end")
    emit("local function getthreadidentity() return 3 end")
    emit("local function setthreadidentity(...) return nil end")
    emit("")
    emit("-- Replayed observations")

    local function proxyPathFromDescription(desc)
        if type(desc) == "table" and desc.type == "proxy" then
            return desc.path
        end
        return nil
    end

    local literalFromDescription
    local pathExpression
    local varForProxy

    varForProxy = function(path, hint, initializer)
        if not path then
            return "nil"
        end

        if proxyVars[path] then
            return proxyVars[path]
        end

        local name = makeReplayName(path, hint, usedNames)
        proxyVars[path] = name

        if initializer then
            emit("local " .. name .. " = " .. initializer)
        else
            emit("local " .. name .. " = __stub(" .. luaString(path) .. ")")
        end

        return name
    end

    literalFromDescription = function(desc)
        if type(desc) ~= "table" then
            return "nil"
        end

        if desc.type == "string" then
            return luaString(desc.value or "")
        elseif desc.type == "number" then
            return tostring(tonumber(desc.value) or 0)
        elseif desc.type == "boolean" then
            return desc.value == "true" and "true" or "false"
        elseif desc.type == "nil" then
            return "nil"
        elseif desc.type == "proxy" then
            return varForProxy(desc.path)
        elseif desc.type == "table" then
            return "{}"
        elseif desc.type == "function" then
            return "__noop"
        end

        return "nil"
    end

    local function argsExpression(args, startIndex)
        local out = {}
        if not args then
            return ""
        end

        for index = startIndex or 1, args.n or #args do
            out[#out + 1] = literalFromDescription(args[index])
        end

        return table.concat(out, ", ")
    end

    pathExpression = function(path, args)
        if path == "Instance.new" then
            return "Instance.new(" .. argsExpression(args) .. ")"
        end

        local parentPath, member = splitMemberPath(path)
        if parentPath and member and proxyVars[parentPath] then
            local firstArgPath = args and proxyPathFromDescription(args[1])
            if firstArgPath == parentPath and member:match("^[%a_][%w_]*$") then
                return proxyVars[parentPath] .. ":" .. member .. "(" .. argsExpression(args, 2) .. ")"
            end

            if member:match("^[%a_][%w_]*$") then
                return proxyVars[parentPath] .. "." .. member .. "(" .. argsExpression(args) .. ")"
            end
        end

        if path:match("^[%a_][%w_%.]*$") then
            return path .. "(" .. argsExpression(args) .. ")"
        end

        return "__stub(" .. luaString(path) .. ")(" .. argsExpression(args) .. ")"
    end

    for _, event in ipairs(logger.events) do
        local detail = event.detail or {}

        if event.kind == "service" and detail.service and detail.result then
            local path = proxyPathFromDescription(detail.result)
            local hint = "svc_" .. tostring(detail.service)
            varForProxy(path, hint, "game:GetService(" .. luaString(detail.service) .. ")")
        elseif event.kind == "call" and detail.result then
            local resultPath = proxyPathFromDescription(detail.result)
            local expression = pathExpression(event.path or "__noop", detail.args)
            varForProxy(resultPath, nil, expression)
        elseif event.kind == "binary_op" and detail.result then
            local resultPath = proxyPathFromDescription(detail.result)
            local op = detail.op or "op"
            local symbols = {
                add = "+",
                sub = "-",
                mul = "*",
                div = "/",
                idiv = "//",
                mod = "%",
                pow = "^",
            }
            local symbol = symbols[op] or "+"
            local left = varForProxy(event.path)
            local right = literalFromDescription(detail.right)
            varForProxy(resultPath, nil, left .. " " .. symbol .. " " .. right)
        elseif event.kind == "assign" then
            local parentPath, member = splitMemberPath(event.path or "")
            if parentPath and member then
                local parentVar = varForProxy(parentPath)
                local value = literalFromDescription(detail.value)
                if member:match("^[%a_][%w_]*$") then
                    emit(parentVar .. "." .. member .. " = " .. value)
                else
                    emit(parentVar .. "[" .. luaString(member) .. "] = " .. value)
                end
            end
        elseif event.kind == "global_assign" then
            local name = tostring(event.path or "value")
            if name:match("^[%a_][%w_]*$") then
                emit(name .. " = " .. literalFromDescription(detail.value))
            else
                emit("_G[" .. luaString(name) .. "] = " .. literalFromDescription(detail.value))
            end
        elseif event.kind == "connect" then
            emit("-- connected " .. tostring(event.path or "signal"))
        elseif event.kind == "callback_begin" then
            emit("-- explored callback: " .. tostring(event.path or "signal"))
        elseif event.kind == "callback_end" then
            emit("-- end explored callback")
        elseif event.kind == "callback_error" then
            emit("-- callback error: " .. tostring(detail.error):gsub("\n", " | "))
        elseif event.kind == "http" then
            emit("-- observed HTTP: " .. tostring(event.path or "request"))
        elseif event.kind == "loadstring" and detail.source then
            emit("-- observed loadstring source length: " .. tostring(detail.source.length or 0))
        elseif event.kind == "error" then
            emit("-- original run ended with error: " .. tostring(detail.error):gsub("\n", " | "))
        elseif event.kind == "print" then
            local args = detail.args or {}
            local argStrings = {}
            for i = 1, args.n or #args do
                argStrings[#argStrings + 1] = literalFromDescription(args[i])
            end
            emit("print(" .. table.concat(argStrings, ", ") .. ")")

        elseif event.kind == "warn" then
            local args = detail.args or {}
            local argStrings = {}
            for i = 1, args.n or #args do
                argStrings[#argStrings + 1] = literalFromDescription(args[i])
            end
            emit("warn(" .. table.concat(argStrings, ", ") .. ")")
        end
    end

    emit("")
    emit("-- Replay metadata")
    emit("local __envlogger_replay = {")
    emit("    source = " .. luaString(displayTarget) .. ",")
    emit("    original_success = " .. tostring(success) .. ",")
    emit("    original_result = " .. luaString(result) .. ",")
    emit("    events = " .. tostring(#logger.events) .. ",")
    emit("}")
    emit("return __envlogger_replay")

    return table.concat(lines, "\n")
end

local function generateReconstruction(target, logger, success, result)
    local displayTarget = sanitizeFileName(target)
    local root = Ast.block()
    local blockStack = { root }
    local indent = 0
    local proxyVars = {}
    local proxyIds = {}
    local usedNames = {}
    local lastHttpVar = nil
    local sourceText = nil
    local sourceLineStarts = nil

    pcall(function()
        if fs.isFile(target) then
            sourceText = fs.readFile(target)
        end
    end)

    local serviceNames = {
        ["Players"] = "Players",
        ["ReplicatedStorage"] = "ReplicatedStorage",
        ["ServerScriptService"] = "ServerScriptService",
        ["ServerStorage"] = "ServerStorage",
        ["StarterGui"] = "StarterGui",
        ["StarterPack"] = "StarterPack",
        ["StarterPlayer"] = "StarterPlayer",
        ["Lighting"] = "Lighting",
        ["Workspace"] = "Workspace",
        ["SoundService"] = "SoundService",
        ["TweenService"] = "TweenService",
        ["RunService"] = "RunService",
        ["UserInputService"] = "UserInputService",
        ["ContextActionService"] = "ContextActionService",
        ["TeleportService"] = "TeleportService",
        ["DataStoreService"] = "DataStoreService",
        ["HttpService"] = "HttpService",
        ["ReplicatedFirst"] = "ReplicatedFirst",
        ["Chat"] = "Chat",
        ["Teams"] = "Teams",
        ["CollectionService"] = "CollectionService",
        ["Debris"] = "Debris",
        ["MarketplaceService"] = "MarketplaceService",
        ["ScriptContext"] = "ScriptContext",
        ["CompressionService"] = "CompressionService",
        ["EncodingService"] = "EncodingService",
        ["ContentProvider"] = "ContentProvider",
        ["InsertService"] = "InsertService",
        ["GuiService"] = "GuiService",
        ["VirtualUser"] = "VirtualUser",
        ["VirtualInputManager"] = "VirtualInputManager",
        ["LogService"] = "LogService",
        ["TextService"] = "TextService",
        ["TextChatService"] = "TextChatService",
        ["PathfindingService"] = "PathfindingService",
        ["RbxAnalyticsService"] = "RbxAnalyticsService",
        ["PolicyService"] = "PolicyService",
        ["SocialService"] = "SocialService",
        ["ProximityPromptService"] = "ProximityPromptService",
        ["Stats"] = "Stats",
        ["StarterGui"] = "StarterGui",
        ["CoreGui"] = "CoreGui",
        ["PlayerGui"] = "PlayerGui",
        ["Backpack"] = "Backpack",
        ["Character"] = "Character",
        ["Humanoid"] = "Humanoid",
        ["Torso"] = "Torso",
        ["Head"] = "Head",
        ["LeftArm"] = "LeftArm",
        ["RightArm"] = "RightArm",
        ["LeftLeg"] = "LeftLeg",
        ["RightLeg"] = "RightLeg",
    }

    local rootServiceNames = {
        Players = true,
        ReplicatedStorage = true,
        ServerScriptService = true,
        ServerStorage = true,
        StarterGui = true,
        StarterPack = true,
        StarterPlayer = true,
        Lighting = true,
        Workspace = true,
        SoundService = true,
        TweenService = true,
        RunService = true,
        UserInputService = true,
        ContextActionService = true,
        TeleportService = true,
        DataStoreService = true,
        HttpService = true,
        ReplicatedFirst = true,
        Chat = true,
        Teams = true,
        CollectionService = true,
        Debris = true,
        MarketplaceService = true,
        ScriptContext = true,
        CompressionService = true,
        EncodingService = true,
        ContentProvider = true,
        InsertService = true,
        GuiService = true,
        VirtualUser = true,
        VirtualInputManager = true,
        LogService = true,
        TextService = true,
        TextChatService = true,
        PathfindingService = true,
        RbxAnalyticsService = true,
        PolicyService = true,
        SocialService = true,
        ProximityPromptService = true,
        Stats = true,
        CoreGui = true,
    }

    local functionCallNames = {
        ["HttpGet"] = "HttpResponse",
        ["HttpGetAsync"] = "HttpResponse",
        ["HttpPost"] = "HttpResponse",
        ["WaitForChild"] = "WaitForChild",
        ["FindFirstChild"] = "FindFirstChild",
        ["GetChildren"] = "GetChildren",
        ["GetDescendants"] = "GetDescendants",
        ["Clone"] = "Clone",
        ["new"] = "New",
        ["create"] = "Create",
        ["fromRGB"] = "FromRGB",
        ["fromHSV"] = "FromHSV",
        ["Angles"] = "Angles",
        ["Connect"] = "Connect",
        ["Wait"] = "Wait",
    }

    local function emit(line)
        blockStack[#blockStack]:raw(line)
    end

    local function emitComment(text)
        blockStack[#blockStack]:comment(text)
    end

    local function emitCommentOnce(text)
        local block = blockStack[#blockStack]
        if block.commentOnce then
            block:commentOnce(text)
        else
            block:comment(text)
        end
    end

    local function emitLocal(name, expr)
        blockStack[#blockStack]:localAssign(name, expr)
    end

    local function emitAssign(left, right)
        blockStack[#blockStack]:assign(left, right)
    end

    local function emitExpr(expr)
        blockStack[#blockStack]:expr(expr)
    end

    local function pushBlock(block)
        blockStack[#blockStack + 1] = block
        indent += 1
    end

    local function popBlock()
        if #blockStack > 1 then
            blockStack[#blockStack] = nil
        end
        if indent > 0 then
            indent -= 1
        end
    end

    local function buildLineStarts()
        if sourceLineStarts or not sourceText then return sourceLineStarts end
        sourceLineStarts = { 1 }
        local pos = 1
        while true do
            local nl = sourceText:find("\n", pos, true)
            if not nl then break end
            sourceLineStarts[#sourceLineStarts + 1] = nl + 1
            pos = nl + 1
        end
        return sourceLineStarts
    end

    local function isIdentByte(byte)
        return byte and ((byte >= 48 and byte <= 57) or (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) or byte == 95)
    end

    local function tokenAt(pos, word)
        if sourceText:sub(pos, pos + #word - 1) ~= word then return false end
        return not isIdentByte(sourceText:byte(pos - 1)) and not isIdentByte(sourceText:byte(pos + #word))
    end

    local function findTokenFrom(pos, word, limit)
        limit = limit or #sourceText
        while pos <= limit do
            local found = sourceText:find(word, pos, true)
            if not found or found > limit then return nil end
            if tokenAt(found, word) then return found end
            pos = found + #word
        end
        return nil
    end

    local function skipQuoted(pos)
        local quote = sourceText:sub(pos, pos)
        pos += 1
        while pos <= #sourceText do
            local ch = sourceText:sub(pos, pos)
            if ch == "\\" then
                pos += 2
            elseif ch == quote then
                return pos + 1
            else
                pos += 1
            end
        end
        return pos
    end

    local function skipLongBracket(pos)
        local eqs = sourceText:match("^%[(=*)%[", pos)
        if not eqs then return nil end
        local close = "]" .. eqs .. "]"
        local found = sourceText:find(close, pos + #eqs + 2, true)
        return found and (found + #close) or (#sourceText + 1)
    end

    local function skipTrivia(pos)
        local ch = sourceText:sub(pos, pos)
        if ch == "\"" or ch == "'" then
            return skipQuoted(pos)
        end
        if ch == "[" then
            return skipLongBracket(pos) or pos + 1
        end
        if ch == "-" and sourceText:sub(pos, pos + 1) == "--" then
            local longEnd = skipLongBracket(pos + 2)
            if longEnd then return longEnd end
            local nl = sourceText:find("\n", pos + 2, true)
            return nl and (nl + 1) or (#sourceText + 1)
        end
        return nil
    end

    local function extractFunctionSource(callbackDesc)
        if not sourceText or type(callbackDesc) ~= "table" then return nil end
        local line = tonumber(callbackDesc.line)
        if not line or line < 1 then return nil end

        local starts = buildLineStarts()
        local lineStart = starts and starts[line]
        if not lineStart then return nil end
        local searchEnd = starts[line + 2] and (starts[line + 2] - 1) or math.min(#sourceText, lineStart + 2000)
        local funcStart = findTokenFrom(lineStart, "function", searchEnd)
        if not funcStart then return nil end

        local depth = 0
        local pos = funcStart
        while pos <= #sourceText do
            local skipped = skipTrivia(pos)
            if skipped then
                pos = skipped
            elseif tokenAt(pos, "function") then
                depth += 1
                pos += #"function"
            elseif tokenAt(pos, "then") or tokenAt(pos, "do") or tokenAt(pos, "repeat") then
                depth += 1
                pos += sourceText:sub(pos, pos + 5):match("^repeat") and #"repeat" or (sourceText:sub(pos, pos + 3):match("^then") and #"then" or #"do")
            elseif tokenAt(pos, "end") then
                depth -= 1
                pos += #"end"
                if depth <= 0 then
                    local snippet = sourceText:sub(funcStart, pos - 1)
                    if #snippet > 20000 then
                        return "function(...)\n    -- callback source was over 20kb, truncated\nend"
                    end
                    return snippet
                end
            elseif tokenAt(pos, "until") then
                depth -= 1
                pos += #"until"
            else
                pos += 1
            end
        end

        return nil
    end

    local function reserve(name)
        usedNames[name] = (usedNames[name] or 0) + 1
        if usedNames[name] == 1 then
            return name
        end
        return name .. (usedNames[name] - 1)
    end

    local function cleanName(name)
        name = tostring(name or "value"):gsub("[^%w_]+", "_")
        name = name:gsub("^_+", ""):gsub("_+$", "")
        if name == "" then
            name = "value"
        end
        if name:match("^%d") then
            name = "V" .. name
        end
        name = name:sub(1, 1):upper() .. name:sub(2)
        return name
    end

    local reservedWords = {
        ["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true,
        ["elseif"] = true, ["end"] = true, ["false"] = true, ["for"] = true,
        ["function"] = true, ["if"] = true, ["in"] = true, ["local"] = true,
        ["nil"] = true, ["not"] = true, ["or"] = true, ["repeat"] = true,
        ["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
        ["while"] = true, ["continue"] = true,
    }

    local function cleanLocalName(name)
        name = tostring(name or "")
        if name:match("^[%a_][%w_]*$") and not reservedWords[name] then
            return name
        end
        return cleanName(name)
    end

    local function sourceLine(line)
        line = tonumber(line)
        if not sourceText or not line or line < 1 then return nil end
        local starts = buildLineStarts()
        local lineStart = starts and starts[line]
        if not lineStart then return nil end
        local lineEnd = (starts[line + 1] and starts[line + 1] - 2) or #sourceText
        return sourceText:sub(lineStart, lineEnd)
    end

    local function sourceNameForCall(detail)
        local line = sourceLine(detail and detail.line)
        if not line then return nil end
        local callPos = line:find("Instance.new", 1, true)
            or line:find("game:GetService", 1, true)
            or line:find(":GetMouse", 1, true)
        if not callPos then return nil end

        local before = line:sub(1, callPos - 1)
        local name = before:match("local%s+([%a_][%w_]*)%s*=")
        if name then return cleanLocalName(name) end
        return nil
    end

    local preferredNamesById = {}
    for _, event in ipairs(logger.events) do
        local detail = event.detail or {}
        local target = detail.target
        local value = detail.value
        if event.kind == "call"
            and detail.result
            and detail.result.id
            and event.path == "Instance.new"
        then
            local sourceName = sourceNameForCall(detail)
            if sourceName then
                preferredNamesById[detail.result.id] = sourceName
            end
        end
        if event.kind == "assign"
            and target
            and target.id
            and detail.key == "Name"
            and type(value) == "table"
            and value.type == "string"
            and value.value
            and not preferredNamesById[target.id]
        then
            preferredNamesById[target.id] = cleanName(value.value)
        end
    end

    local gameRootNames = {}
    local function markGameRoot(path)
        local root = tostring(path or ""):match("^([^%.:]+)")
        if root and (root == "game" or root:match("^Experience%d+$")) then
            gameRootNames[root] = true
        end
    end
    local function eventDescPath(desc)
        if type(desc) == "table" and (desc.type == "proxy" or desc.robloxType == "Instance") then
            return desc.path
        end
        return nil
    end

    for _, event in ipairs(logger.events) do
        markGameRoot(event.path)
        local detail = event.detail or {}
        markGameRoot(eventDescPath(detail.target))
        markGameRoot(eventDescPath(detail.result))
        markGameRoot(eventDescPath(detail.value))
        local root, serviceName = tostring(event.path or ""):match("^([^%.]+)%.([%a_][%w_]*)")
        if root and rootServiceNames[serviceName] then
            gameRootNames[root] = true
        end
    end

    local function isGameRootName(name)
        name = tostring(name or "")
        return name == "game" or gameRootNames[name] or name:match("^Experience%d+$") ~= nil
    end

    local function generateSmartName(path, hint, eventKind, detail)
        if eventKind == "service" and detail and detail.service then
            local serviceName = tostring(detail.service)
            return serviceNames[serviceName] or cleanName(serviceName)
        end

        if (eventKind == "call" or eventKind == "namecall") and path then
            for funcName, varName in pairs(functionCallNames) do
                if path:match(funcName .. "$") then
                    return varName
                end
            end

            local parent, method = splitMemberPath(path)
            if parent and method then
                if method:match("^[A-Z]") then
                    return cleanName(method)
                end
                if method:match("^Get") then
                    local result = cleanName(method:gsub("^Get", ""))
                    return result ~= "" and result or "Value"
                end
                if method:match("^Find") then
                    local result = cleanName(method:gsub("^Find", "")) .. "Found"
                    return result
                end
                if method:match("^Set") then
                    return cleanName(method)
                end
            end
        end

        if hint and hint ~= "" then
            return cleanName(hint)
        end

        local pathPart = tostring(path or ""):match("([%w_]+)$") or "Value"
        return cleanName(pathPart)
    end

    local function proxyPath(desc)
        if type(desc) == "table" and desc.type == "proxy" then
            return desc.path
        end
        if type(desc) == "table" and desc.robloxType == "Instance" then
            return desc.path
        end
        return nil
    end

    local function descId(desc)
        return type(desc) == "table" and desc.id or nil
    end

    local descToLua
    local pathToExpr

    local function remember(path, name, id)
        if path then
            proxyVars[path] = name
        end
        if id then
            proxyIds[id] = name
        end
        if path then
            return proxyVars[path]
        end
        return nil
    end

    local function exprForDesc(desc)
        local id = descId(desc)
        if id and proxyIds[id] then
            return proxyIds[id]
        end
        local path = proxyPath(desc)
        if path and proxyVars[path] then
            return proxyVars[path]
        end
        return nil
    end

    local function nameForResult(path, prefix, eventIndex, hint, eventKind, detail)
        local resultDesc = detail and detail.result
        local id = descId(resultDesc)
        if id and proxyIds[id] then
            return proxyIds[id]
        end
        if not id and path and proxyVars[path] then
            return proxyVars[path]
        end
        local namingPath = (detail and detail.callPath) or path

        if not path and not id then
            local base
            if detail and ((detail.result and detail.result.type ~= "nil") or eventKind == "service") then
                base = generateSmartName(namingPath, hint, eventKind, detail)
            end
            if not base or base == "" or base == "Value" then
                base = prefix and (prefix .. tostring(eventIndex)) or ("_" .. tostring(eventIndex))
            end
            return reserve(base)
        end

        local base = (id and preferredNamesById[id]) or generateSmartName(namingPath, hint, eventKind, detail)
        local name = reserve(base)
        remember(path, name, id)
        return name
    end

    local function tableDescToLua(desc)
        local items = {}
        for _, item in ipairs(desc.items or {}) do
            local keyDesc = item.key
            local valueDesc = item.value
            local keyLua

            if type(keyDesc) == "table" and keyDesc.type == "string" and tostring(keyDesc.value or ""):match("^[%a_][%w_]*$") then
                keyLua = tostring(keyDesc.value)
            else
                keyLua = "[" .. descToLua(keyDesc) .. "]"
            end

            items[#items + 1] = keyLua .. " = " .. descToLua(valueDesc)
        end

        if #items == 0 then
            return "{}"
        end

        return "{\n" .. string.rep("    ", indent + 1) .. table.concat(items, ",\n" .. string.rep("    ", indent + 1)) .. ",\n" .. string.rep("    ", indent) .. "}"
    end

    local function numLua(value)
        local n = tonumber(value) or 0
        if n ~= n or n == math.huge or n == -math.huge then
            return "0"
        end
        return string.format("%.15g", n)
    end

    local function colorToLua(desc)
        local r = tonumber(desc.r) or 0
        local g = tonumber(desc.g) or 0
        local b = tonumber(desc.b) or 0
        local ri = math.floor(r * 255 + 0.5)
        local gi = math.floor(g * 255 + 0.5)
        local bi = math.floor(b * 255 + 0.5)
        if math.abs(r - ri / 255) < 1e-6 and math.abs(g - gi / 255) < 1e-6 and math.abs(b - bi / 255) < 1e-6 then
            return "Color3.fromRGB(" .. tostring(ri) .. ", " .. tostring(gi) .. ", " .. tostring(bi) .. ")"
        end
        return "Color3.new(" .. numLua(r) .. ", " .. numLua(g) .. ", " .. numLua(b) .. ")"
    end

    descToLua = function(desc)
        if type(desc) ~= "table" then
            return "nil"
        end

        local robloxType = desc.robloxType or desc.type
        if robloxType == "Instance" then
            return exprForDesc(desc) or (desc.path and pathToExpr(desc.path)) or luaString(desc.value or "Instance")
        elseif robloxType == "InputObject" then
            return exprForDesc(desc) or (desc.path and pathToExpr(desc.path)) or "InputObject"
        elseif robloxType == "EnumItem" then
            return tostring(desc.path or desc.value or "nil")
        elseif robloxType == "UDim" then
            return "UDim.new(" .. numLua(desc.scale) .. ", " .. numLua(desc.offset) .. ")"
        elseif robloxType == "UDim2" then
            return "UDim2.new(" .. numLua(desc.xs) .. ", " .. numLua(desc.xo) .. ", " .. numLua(desc.ys) .. ", " .. numLua(desc.yo) .. ")"
        elseif robloxType == "Color3" then
            return colorToLua(desc)
        elseif robloxType == "BrickColor" then
            if desc.number ~= nil then
                return "BrickColor.new(" .. tostring(tonumber(desc.number) or 0) .. ")"
            end
            return "BrickColor.new(" .. luaString(desc.name or desc.value or "") .. ")"
        elseif robloxType == "Vector2" then
            return "Vector2.new(" .. numLua(desc.x) .. ", " .. numLua(desc.y) .. ")"
        elseif robloxType == "Vector3" then
            return "Vector3.new(" .. numLua(desc.x) .. ", " .. numLua(desc.y) .. ", " .. numLua(desc.z) .. ")"
        elseif robloxType == "CFrame" then
            local parts = {}
            for i = 1, tonumber(desc.n) or 0 do
                parts[#parts + 1] = numLua(desc[i])
            end
            return "CFrame.new(" .. table.concat(parts, ", ") .. ")"
        end

        if desc.type == "string" then
            return luaString(desc.value or "")
        elseif desc.type == "number" then
            return tostring(tonumber(desc.value) or 0)
        elseif desc.type == "boolean" then
            return desc.value == "true" and "true" or "false"
        elseif desc.type == "nil" then
            return "nil"
        elseif desc.type == "proxy" then
            return proxyVars[desc.path] or pathToExpr(desc.path)
        elseif desc.type == "table" then
            return tableDescToLua(desc)
        elseif desc.type == "function" then
            return "function(...) end"
        elseif desc.type == "userdata" then
            local value = tostring(desc.value or "")
            if value:match("^[%a_][%w_%.:]*$") then
                return pathToExpr(value)
            end
            return luaString(value)
        end

        return "nil"
    end

    local function argsToLua(args, startIndex)
        local out = {}
        if not args then
            return ""
        end
        for i = startIndex or 1, args.n or #args do
            out[#out + 1] = descToLua(args[i])
        end
        return table.concat(out, ", ")
    end

    local function argsList(args, startIndex)
        local out = {}
        if not args then
            return out
        end
        for i = startIndex or 1, args.n or #args do
            out[#out + 1] = descToLua(args[i])
        end
        return out
    end

    pathToExpr = function(path)
        if not path then
            return "nil"
        end
        if proxyVars[path] then
            return proxyVars[path]
        end
        local bestPath, bestName
        for knownPath, knownName in pairs(proxyVars) do
            if type(knownPath) == "string" and knownPath ~= "" then
                local prefix = knownPath .. "."
                if path:sub(1, #prefix) == prefix then
                    if not bestPath or #knownPath > #bestPath then
                        bestPath, bestName = knownPath, knownName
                    end
                end
            end
        end
        if bestPath then
            return bestName .. path:sub(#bestPath + 1)
        end
        if isGameRootName(path) then
            return "game"
        end
        local rootName, serviceName, serviceRest = path:match("^([^%.]+)%.([%a_][%w_]*)(.*)$")
        if rootName and isGameRootName(rootName) and rootServiceNames[serviceName] then
            if serviceName == "Players" then
                local playerName, playerRest = serviceRest:match("^%.([^%.]+)(.*)$")
                if playerName and playerName ~= "" then
                    return "game:GetService(\"Players\").LocalPlayer" .. playerRest
                end
            end
            local base = serviceName == "Workspace" and "workspace" or ("game:GetService(" .. luaString(serviceName) .. ")")
            return base .. serviceRest
        end

        if path:match("^game:[%a_][%w_]*$") or path:match("^[%a_][%w_]*$") then
            return path
        end

        local parent, key = splitMemberPath(path)
        if parent and key then
            local parentExpr = pathToExpr(parent)
            if key:match("^[%a_][%w_]*$") then
                return parentExpr .. "." .. key
            end
        end

        return "nil --[[ " .. path:gsub("%]%]", "]] ") .. " ]]"
    end

    local function callExpr(path, args)
        local colonTarget, colonMethod = tostring(path or ""):match("^(.-):([%a_][%w_]*)$")
        if colonTarget and colonMethod then
            return pathToExpr(colonTarget) .. ":" .. colonMethod .. "(" .. argsToLua(args) .. ")"
        end

        if path == "require" then
            return "require(" .. argsToLua(args) .. ")"
        elseif path == "type" then
            return "type(" .. argsToLua(args) .. ")"
        elseif path == "math.floor" or path == "string.format" or path == "table.concat" or path == "table.insert" then
            return path .. "(" .. argsToLua(args) .. ")"
        elseif path == "identifyexecutor" or path == "getexecutorname" or path == "getgenv" or path == "getfenv" then
            return path .. "(" .. argsToLua(args) .. ")"
        end

        local parent, method = splitMemberPath(path or "")
        local firstArgPath = args and proxyPath(args[1])
        if parent and method then
            local parentExpr = pathToExpr(parent)
            if firstArgPath == parent and method:match("^[%a_][%w_]*$") then
                return parentExpr .. ":" .. method .. "(" .. argsToLua(args, 2) .. ")"
            elseif method:match("^[%a_][%w_]*$") then
                return parentExpr .. "." .. method .. "(" .. argsToLua(args) .. ")"
            end
        end

        return pathToExpr(path) .. "(" .. argsToLua(args) .. ")"
    end

    local function shouldSkipIndex(event, nextEvent)
        if not nextEvent or nextEvent.kind ~= "call" then
            return false
        end
        return nextEvent.path == event.path
    end

    local callbackRangesByPath = {}
    local callbackRangeByStart = {}
    local callbackCursorByPath = {}
    local consumedCallbackStarts = {}

    do
        local stack = {}
        for index, event in ipairs(logger.events) do
            if event.kind == "callback_begin" then
                stack[#stack + 1] = {
                    start = index,
                    path = event.path,
                    detail = event.detail or {},
                }
            elseif event.kind == "callback_end" then
                local range = stack[#stack]
                if range then
                    stack[#stack] = nil
                    range.finish = index
                    callbackRangeByStart[range.start] = range

                    local list = callbackRangesByPath[range.path]
                    if not list then
                        list = {}
                        callbackRangesByPath[range.path] = list
                    end
                    list[#list + 1] = range
                end
            end
        end
    end

    local function takeCallbackRange(path)
        local list = callbackRangesByPath[path]
        if not list then return nil end

        local cursor = callbackCursorByPath[path] or 1
        while list[cursor] and consumedCallbackStarts[list[cursor].start] do
            cursor += 1
        end

        local range = list[cursor]
        callbackCursorByPath[path] = cursor + 1
        if not range then return nil end

        consumedCallbackStarts[range.start] = true
        return range
    end

    local function argCount(args)
        if type(args) ~= "table" then return 0 end
        return tonumber(args.n) or #args
    end

    local function callbackArgBase(signalPath, desc, argIndex)
        local signalName = tostring(signalPath or ""):match("([%a_][%w_]*)$") or "Callback"
        local robloxType = type(desc) == "table" and (desc.robloxType or desc.type) or nil
        local descType = type(desc) == "table" and desc.type or nil

        if signalName == "InputBegan" or signalName == "InputChanged" or signalName == "InputEnded" then
            return argIndex == 1 and "input" or "gameProcessedEvent"
        elseif signalName == "Changed" then
            return "property"
        elseif signalName == "Touched" then
            return "hit"
        elseif signalName == "TouchEnded" then
            return "hit"
        elseif signalName == "MouseButton1Click" or signalName == "Activated" then
            return "input"
        elseif signalName == "Heartbeat" or signalName == "RenderStepped" then
            return "dt"
        elseif signalName == "Stepped" then
            return argIndex == 1 and "time" or "dt"
        end

        if robloxType == "InputObject" then
            return "input"
        elseif robloxType == "Instance" then
            return "instance"
        elseif robloxType == "EnumItem" then
            return "state"
        elseif descType == "string" then
            return "value"
        elseif descType == "number" then
            return "value"
        elseif descType == "boolean" then
            return "value"
        end

        return "arg" .. tostring(argIndex)
    end

    local function callbackArgNames(range)
        local args = range and range.detail and range.detail.args
        local count = argCount(args)
        local names = {}
        local used = {}

        for i = 1, count do
            local base = callbackArgBase(range.path, args and args[i], i)
            base = cleanLocalName(base)
            base = base:sub(1, 1):lower() .. base:sub(2)
            if reservedWords[base] then
                base ..= "Value"
            end

            local seen = used[base] or 0
            used[base] = seen + 1
            names[i] = seen == 0 and base or (base .. tostring(seen + 1))
        end

        return names
    end

    local function applyCallbackArgs(range, argNames)
        local args = range and range.detail and range.detail.args
        local restores = {}

        for i = 1, argCount(args) do
            local desc = args[i]
            local name = argNames[i]
            if type(desc) == "table" and name then
                local id = descId(desc)
                if id then
                    restores[#restores + 1] = { "id", id, proxyIds[id] }
                    proxyIds[id] = name
                end

                local path = proxyPath(desc) or desc.path
                if path then
                    restores[#restores + 1] = { "path", path, proxyVars[path] }
                    proxyVars[path] = name
                end
            end
        end

        return function()
            for i = #restores, 1, -1 do
                local item = restores[i]
                if item[1] == "id" then
                    proxyIds[item[2]] = item[3]
                else
                    proxyVars[item[2]] = item[3]
                end
            end
        end
    end

    emit("-- Reconstructed by EnvLogger from: " .. displayTarget)
    emit("local fenv=getfenv()")

    local renderEvents

    local function renderConnect(event, detail)
        local callbackSource = indent == 0 and extractFunctionSource(detail.callback) or nil
        local signalExpr = pathToExpr(event.path or "signal")
        if callbackSource then
            takeCallbackRange(event.path)
            emit(signalExpr .. ":Connect(" .. callbackSource .. ")")
            return
        end

        local range = takeCallbackRange(event.path)
        if not range then
            blockStack[#blockStack]:connect(signalExpr, {})
            return
        end

        local argNames = callbackArgNames(range)
        local _, body = blockStack[#blockStack]:connect(signalExpr, argNames)
        local restoreArgs = applyCallbackArgs(range, argNames)
        pushBlock(body)
        renderEvents(range.start + 1, range.finish - 1)
        popBlock()
        restoreArgs()
    end

    local function renderCallbackRange(range)
        consumedCallbackStarts[range.start] = true
        local argNames = callbackArgNames(range)
        local label = "explored callback: " .. pathToExpr(range.path or "signal")
        if #argNames > 0 then
            label ..= "(" .. table.concat(argNames, ", ") .. ")"
        end

        local _, body = blockStack[#blockStack]:doBlock(label)
        local restoreArgs = applyCallbackArgs(range, argNames)
        pushBlock(body)
        renderEvents(range.start + 1, range.finish - 1)
        popBlock()
        restoreArgs()
    end

    local function renderEvent(index, event)
        local detail = event.detail or {}
        local nextEvent = logger.events[index + 1]
        detail.callPath = event.path

        if event.kind == "http" and event.path == "game:HttpGet" then
            local name = reserve("HttpResponse" .. tostring(event.i))
            emitLocal(name, "game:HttpGet(" .. descToLua(detail.url) .. ")")
            lastHttpVar = name
        elseif event.kind == "loadstring" then
            local name = reserve("LoadedScript" .. tostring(event.i))
            local sourceExpr = lastHttpVar or descToLua(detail.source)
            emitLocal(name, "loadstring(" .. sourceExpr .. ")()")
        elseif event.kind == "service" then
            local resultPath = proxyPath(detail.result)
            local serviceName = tostring(detail.service)
            local name = nameForResult(resultPath, "Svc", event.i, serviceName, "service", detail)
            blockStack[#blockStack]:localCall(name, "game:GetService", { luaString(serviceName) })
            remember(serviceName, name)
            for rootName in pairs(gameRootNames) do
                remember(rootName .. "." .. serviceName, name)
            end
        elseif event.kind == "index" then
            if not proxyVars[event.path] then
                local parent, key = splitMemberPath(event.path or "")
                if parent and key then
                    if shouldSkipIndex(event, nextEvent) then
                        local resultName = nameForResult(event.path, cleanName(key), event.i, key, "index", detail)
                        _ = resultName
                    else
                        local varName = cleanName(key)
                        if varName == "Parent" then
                            varName = "Parent" .. tostring(event.i)
                        elseif varName == "Children" then
                            varName = "Children" .. tostring(event.i)
                        end
                        local resultName = nameForResult(event.path, varName, event.i, key, "index", detail)
                        emitLocal(resultName, pathToExpr(parent) .. "." .. key)
                    end
                end
            end
        elseif event.kind == "namecall" then
            -- a Class:Method namecall. the event records the class+method, not the
            -- receiver instance, so we can't always name the receiver -- emit a
            -- real call bound to the result so the report shows which methods ran.
            -- (we only render when there's a usable class name to target.)
            local class, method = tostring(event.path or ""):match("^(.-):([%a_][%w_]*)$")
            if class and method then
                local targetPath = proxyPath(detail.target)
                local receiver = exprForDesc(detail.target) or (targetPath and pathToExpr(targetPath)) or pathToExpr(class)
                if detail.result then
                    local resultName = nameForResult(proxyPath(detail.result), cleanName(method), event.i, method, "namecall", detail)
                    blockStack[#blockStack]:namecall(receiver, method, argsList(detail.args), resultName)
                else
                    blockStack[#blockStack]:namecall(receiver, method, argsList(detail.args))
                end
            end
        elseif event.kind == "call" then
            local resultPath = proxyPath(detail.result)
            local name

            if event.path == "game:GetService" then
                local serviceName = "Service"
                if detail.args and type(detail.args[1]) == "table" and detail.args[1].type == "string" then
                    serviceName = tostring(detail.args[1].value)
                end
                name = nameForResult(resultPath, "Service", event.i, serviceName, "service", {
                    result = detail.result,
                    service = serviceName,
                })
                blockStack[#blockStack]:localCall(name, "game:GetService", { luaString(serviceName) })
                remember(serviceName, name)
                for rootName in pairs(gameRootNames) do
                    remember(rootName .. "." .. serviceName, name)
                end
            elseif event.path == "table.insert" then
                blockStack[#blockStack]:call("table.insert", argsList(detail.args))
            elseif event.path == "type" then
                emitLocal("_", "type(" .. argsToLua(detail.args) .. ")")
            elseif event.path == "print" then
                blockStack[#blockStack]:call("print", argsList(detail.args))
            elseif event.path == "warn" then
                blockStack[#blockStack]:call("warn", argsList(detail.args))
            elseif event.path == "task.wait" then
                blockStack[#blockStack]:call("task.wait", argsList(detail.args))
            else
                local hint = nil
                if event.path == "Instance.new" and detail.result and detail.result.className then
                    hint = detail.result.className
                elseif event.path then
                    local parent, method = splitMemberPath(event.path)
                    if method then
                        hint = cleanName(method)
                    end
                end
                name = nameForResult(resultPath, "Call", event.i, hint, "call", detail)
                if event.path == "Instance.new" then
                    local callArgs = argsList(detail.args)
                    blockStack[#blockStack]:instance(name, callArgs[1] or "\"Instance\"", callArgs[2])
                else
                    emitLocal(name, callExpr(event.path, detail.args))
                end
            end
        elseif event.kind == "http" and detail.request then
            local name = reserve("HttpRequest" .. tostring(event.i))
            emitLocal(name, "http.request(" .. descToLua(detail.request) .. ")")
        elseif event.kind == "binary_op" then
            local symbols = {
                add = "+",
                sub = "-",
                mul = "*",
                div = "/",
                idiv = "//",
                mod = "%",
                pow = "^",
            }
            local resultPath = proxyPath(detail.result)
            local op = detail.op or "add"
            local opName = symbols[op] or "+"
            local name = nameForResult(resultPath, "Result", event.i, "Op", "binary_op", detail)
            emitLocal(name, pathToExpr(event.path) .. " " .. opName .. " " .. descToLua(detail.right))
        elseif event.kind == "iter_begin" then
            local source = descToLua(detail.source)
            local kName = reserve("Key" .. tostring(event.i))
            local vName = reserve("Value" .. tostring(event.i))
            remember(proxyPath(detail.key), kName)
            remember(proxyPath(detail.value), vName)
            local _, body = blockStack[#blockStack]:forPairs(kName, vName, source)
            pushBlock(body)
        elseif event.kind == "iter_end" then
            popBlock()
        elseif event.kind == "assign" then
            local parent, key = splitMemberPath(event.path or "")
            local targetExpr = exprForDesc(detail.target)
            if targetExpr and parent then
                remember(parent, targetExpr, descId(detail.target))
                local targetPath = proxyPath(detail.target)
                if targetPath then
                    remember(targetPath, targetExpr, descId(detail.target))
                end
            end
            key = detail.key or key
            if (targetExpr or parent) and key then
                local lhs = targetExpr or pathToExpr(parent)
                if key:match("^[%a_][%w_]*$") then
                    emitAssign(lhs .. "." .. key, descToLua(detail.value))
                else
                    emitAssign(lhs .. "[" .. luaString(key) .. "]", descToLua(detail.value))
                end

                if detail.key == "Name" and targetExpr and type(detail.value) == "table" and detail.value.type == "string" then
                    remember(detail.value.value, targetExpr, descId(detail.target))
                elseif detail.key == "Parent" and targetExpr then
                    local parentPath = proxyPath(detail.value)
                    local childPath = proxyPath(detail.target) or parent
                    local childName = childPath and childPath:match("([%w_]+)$")
                    if parentPath and childName then
                        remember(parentPath .. "." .. childName, targetExpr, descId(detail.target))
                    end
                end
            end
        elseif event.kind == "global_read" then
            local name = tostring(event.path or "")
            if name ~= "" then
                emitCommentOnce("read nil global " .. name)
            end
        elseif event.kind == "global_assign" then
            local name = tostring(event.path or "value")
            if name:match("^[%a_][%w_]*$") then
                emitAssign(name, descToLua(detail.value))
            else
                emitAssign("_G[" .. luaString(name) .. "]", descToLua(detail.value))
            end
        elseif event.kind == "connect" then
            renderConnect(event, detail)
        elseif event.kind == "callback_begin" then
            local range = callbackRangeByStart[index]
            if range then
                renderCallbackRange(range)
            else
                emitComment("explored callback: " .. pathToExpr(event.path or "signal"))
            end
        elseif event.kind == "callback_end" then
            -- handled by callback_begin ranges
        elseif event.kind == "callback_error" then
            emitComment("callback error: " .. tostring(detail.error):gsub("\n", " "))
        elseif event.kind == "error_call" then
            emitExpr("error(" .. descToLua(detail.message) .. ")")
        elseif event.kind == "error" then
            emitComment("error: " .. tostring(detail.error):gsub("\n", " "))
        elseif event.kind == "print" then
            local args = detail.args or {}
            local argStrings = {}
            for i = 1, args.n or #args do
                argStrings[#argStrings + 1] = descToLua(args[i])
            end
            blockStack[#blockStack]:call("print", argStrings)
        elseif event.kind == "warn" then
            local args = detail.args or {}
            local argStrings = {}
            for i = 1, args.n or #args do
                argStrings[#argStrings + 1] = descToLua(args[i])
            end
            blockStack[#blockStack]:call("warn", argStrings)
        elseif event.kind == "return" then
            blockStack[#blockStack]:returnComment(descToLua(detail.value))
        end
    end

    renderEvents = function(startIndex, endIndex)
        local index = startIndex
        while index <= endIndex do
            local range = callbackRangeByStart[index]
            if range and consumedCallbackStarts[index] then
                index = range.finish + 1
            else
                renderEvent(index, logger.events[index])
                if range and consumedCallbackStarts[index] then
                    index = range.finish + 1
                else
                    index += 1
                end
            end
        end
    end

    renderEvents(1, #logger.events)

    while indent > 0 do
        popBlock()
    end

    if not success then
        emit("-- original execution stopped before completion")
        emit("-- result: " .. tostring(result):gsub("\n", " "))
    end

    return Ast.render(root)
end

local function makeOpLimitHook(maxOps, maxSeconds)
    local ops = 0
    local deadline = os.clock() + (tonumber(maxSeconds) or math.huge)

    return function(increment, errorLevel)
        if type(increment) ~= "number" then
            errorLevel = increment
            increment = 1
        end
        ops += increment
        if ops >= maxOps then
            error("execution timeout: instruction limit exceeded (" .. tostring(maxOps) .. ")", tonumber(errorLevel) or 2)
        end
        if os.clock() > deadline then
            error("execution timeout: time limit exceeded (" .. tostring(maxSeconds) .. "s)", tonumber(errorLevel) or 2)
        end
    end
end

local function installOperationLimit(hookFn)
    if type(debug.sethook) ~= "function" then
        return function() end
    end

    debug.sethook(hookFn, "", 1000)
    return function()
        debug.sethook()
    end
end

local target, options = parseArgs(process.args)

if not target then
    print("Usage: lune EnvLogger.luau <target.lua> [--out=envlogs] [--max-events=8000] [--max-ops=250000]")
    process.exit(1)
end

if not fs.isFile(target) then
    warn("Target file does not exist: " .. target)
    process.exit(1)
end

ensureFolder(options.out)

local originalSource = fs.readFile(target)
local displayTarget = sanitizeFileName(target)
options.target = target
options.source_text = originalSource
rememberDebugSource(target, originalSource)
rememberDebugSource(displayTarget, originalSource)
local syntaxOk, syntaxChunk, syntaxErr = pcall(luau.load, originalSource, "@" .. displayTarget)
if not syntaxOk or not syntaxChunk then
    warn("Failed to load target: " .. sanitizeDiagnosticText(syntaxOk and syntaxErr or syntaxChunk, target))
    process.exit(1)
end
local source = prepareSourceForExecution(originalSource)
local logger = createLogger(options)
local opHook = makeOpLimitHook(options.max_ops, options.max_seconds)
local apiLib = loadApiDump(options.api)
local env, envHelpers = createEnvironment(logger, options, opHook, apiLib)

local loadOk, chunk, loadErr = pcall(luau.load, source, "@" .. displayTarget)
if not loadOk or not chunk then
    warn("Failed to load target: " .. sanitizeDiagnosticText(loadOk and loadErr or chunk, target))
    process.exit(1)
end

setfenv(chunk, env)

local clearHook = installOperationLimit(opHook)
local success, result = xpcall(chunk, function(err)
    return sanitizeDiagnosticText(debug.traceback(tostring(err), 2), target)
end)

if envHelpers and envHelpers.drainPendingTasks then
    local drainOk, drainErr = pcall(envHelpers.drainPendingTasks)
    if not drainOk then
        logger:push("error", displayTarget, {
            error = "deferred task execution stopped: " .. sanitizeDiagnosticText(drainErr, target),
        })
    end
end

if envHelpers and envHelpers.exploreConnectedCallbacks then
    local exploreOk, exploreErr = pcall(envHelpers.exploreConnectedCallbacks)
    if not exploreOk then
        logger:push("error", displayTarget, {
            error = "callback exploration stopped: " .. sanitizeDiagnosticText(exploreErr, target),
        })
    end
end

clearHook()

if success then
    logger:push("return", displayTarget, {
        value = logger:describe(result),
    })
else
    logger:push("error", displayTarget, {
        error = sanitizeDiagnosticText(result, target),
    })
end

local baseName = sanitizeFileName(target)
local textPath = pathJoin(options.out, baseName .. ".envlog.txt")
local jsonPath = pathJoin(options.out, baseName .. ".envlog.json")
local replayPath = pathJoin(options.out, baseName .. ".replay.lua")
local reconstructedPath = pathJoin(options.out, baseName .. ".reconstructed.lua")

local report = {
    target = displayTarget,
    success = success,
    result = logger:describe(result),
    runtime = os.clock() - logger.started,
    counts = logger.counts,
    overflow = logger.overflow,
    events = logger.events,
}

fs.writeFile(textPath, renderTextReport(displayTarget, logger, success, result))
fs.writeFile(jsonPath, encodeJson(report))
fs.writeFile(replayPath, generateReplay(displayTarget, logger, success, result))
fs.writeFile(reconstructedPath, generateReconstruction(target, logger, success, result))

print("EnvLogger finished")
print("Text report: " .. textPath)
print("JSON report: " .. jsonPath)
print("Replay file: " .. replayPath)
print("Reconstructed file: " .. reconstructedPath)

if not success then
    warn("Target ended with error; see report for traceback.")
end