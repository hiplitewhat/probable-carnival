--!nonstrict

local Ast = {}

local INDENT_UNIT = "    "
local INDENT_CACHE = {}
for i = 0, 20 do
    INDENT_CACHE[i] = string.rep(INDENT_UNIT, i)
end

local function indentOf(depth)
    return INDENT_CACHE[depth] or string.rep(INDENT_UNIT, depth)
end

local function pushLine(lines, depth, text)
    if text == "" then
        lines[#lines + 1] = ""
    else
        lines[#lines + 1] = indentOf(depth) .. text
    end
end

local function pushRaw(lines, depth, code)
    code = tostring(code or "")
    if code == "" then
        lines[#lines + 1] = ""
        return
    end

    code = code:gsub("\r\n", "\n"):gsub("\r", "\n")
    local pos = 1
    while pos <= #code + 1 do
        local nl = code:find("\n", pos, true)
        local line
        if nl then
            line = code:sub(pos, nl - 1)
            pos = nl + 1
        else
            line = code:sub(pos)
            pos = #code + 2
        end
        pushLine(lines, depth, line)
    end
end

-- ===== Block =====

local Block = {}
Block.__index = Block

function Block:add(node)
    table.insert(self.statements, node)
    return node
end

function Block:raw(code) return self:add({ kind = "raw", code = code }) end
function Block:blank() return self:add({ kind = "blank" }) end
function Block:comment(text) return self:add({ kind = "comment", text = text }) end

function Block:localAssign(names, values)
    return self:add({
        kind = "local_assign",
        names = (type(names) == "table") and names or { names },
        values = (type(values) == "table") and values or { values },
    })
end

function Block:localCall(name, callee, args)
    return self:add({
        kind = "local_call",
        name = name,
        callee = callee,
        args = (type(args) == "table") and args or { args },
    })
end

function Block:call(callee, args)
    return self:add({
        kind = "call",
        callee = callee,
        args = (type(args) == "table") and args or { args },
    })
end

function Block:namecall(receiver, method, args, name)
    return self:add({
        kind = "namecall",
        receiver = receiver,
        method = method,
        args = (type(args) == "table") and args or { args },
        name = name,
    })
end

function Block:instance(name, classExpr, parentExpr)
    return self:add({
        kind = "instance",
        name = name,
        class = classExpr,
        parent = parentExpr,
    })
end

function Block:assign(left, right)
    return self:add({
        kind = "assign",
        left = left,
        right = right,
    })
end

function Block:expr(expr)
    return self:add({
        kind = "expr",
        expr = expr,
    })
end

function Block:forPairs(key, value, source)
    local body = Ast.block()
    local node = self:add({
        kind = "for_pairs",
        key = key,
        value = value,
        source = source,
        body = body,
    })
    return node, body
end

function Block:doBlock(label)
    local body = Ast.block()
    local node = self:add({
        kind = "do",
        label = label,
        body = body,
    })
    return node, body
end

function Block:connect(signal, args)
    local body = Ast.block()
    local node = self:add({
        kind = "connect",
        signal = signal,
        args = (type(args) == "table") and args or {},
        body = body,
    })
    return node, body
end

function Block:returnComment(expr)
    return self:add({
        kind = "return_comment",
        expr = expr,
    })
end

function Ast.block(statements)
    return setmetatable({
        kind = "block",
        statements = statements or {},
    }, Block)
end

-- ===== Render dispatch =====

local renderers = {}

renderers["raw"] = function(node, lines, depth)
    pushRaw(lines, depth, node.code)
end

renderers["blank"] = function(_, lines, _)
    lines[#lines + 1] = ""
end

renderers["comment"] = function(node, lines, depth)
    pushLine(lines, depth, "-- " .. tostring(node.text or ""))
end

renderers["local_assign"] = function(node, lines, depth)
    local names = table.concat(node.names, ", ")
    local values = table.concat(node.values, ", ")
    if values == "" then
        pushLine(lines, depth, "local " .. names)
    else
        pushLine(lines, depth, "local " .. names .. " = " .. values)
    end
end

renderers["local_call"] = function(node, lines, depth)
    pushLine(lines, depth, "local " .. node.name .. " = " .. node.callee .. "(" .. table.concat(node.args, ", ") .. ")")
end

renderers["call"] = function(node, lines, depth)
    pushLine(lines, depth, node.callee .. "(" .. table.concat(node.args, ", ") .. ")")
end

renderers["namecall"] = function(node, lines, depth)
    local expr = node.receiver .. ":" .. node.method .. "(" .. table.concat(node.args, ", ") .. ")"
    if node.name then
        pushLine(lines, depth, "local " .. node.name .. " = " .. expr)
    else
        pushLine(lines, depth, expr)
    end
end

renderers["instance"] = function(node, lines, depth)
    local args = { node.class }
    if node.parent ~= nil then
        table.insert(args, node.parent)
    end
    pushLine(lines, depth, "local " .. node.name .. " = Instance.new(" .. table.concat(args, ", ") .. ")")
end

renderers["assign"] = function(node, lines, depth)
    pushLine(lines, depth, node.left .. " = " .. node.right)
end

renderers["expr"] = function(node, lines, depth)
    pushLine(lines, depth, node.expr)
end

renderers["for_pairs"] = function(node, lines, depth)
    pushLine(lines, depth, "for " .. node.key .. ", " .. node.value .. " in pairs(" .. node.source .. ") do")
    renderBlock(node.body, lines, depth + 1)
    pushLine(lines, depth, "end")
end

renderers["do"] = function(node, lines, depth)
    if node.label then
        pushLine(lines, depth, "-- " .. tostring(node.label))
    end
    pushLine(lines, depth, "do")
    renderBlock(node.body, lines, depth + 1)
    pushLine(lines, depth, "end")
end

renderers["connect"] = function(node, lines, depth)
    local args = table.concat(node.args, ", ")
    pushLine(lines, depth, node.signal .. ":Connect(function(" .. args .. ")")
    renderBlock(node.body, lines, depth + 1)
    pushLine(lines, depth, "end)")
end

renderers["return_comment"] = function(node, lines, depth)
    pushLine(lines, depth, "-- return " .. tostring(node.expr or "nil"))
end

local function renderBlock(block, lines, depth)
    if not block or not block.statements then
        error("Ast.renderBlock: expected a Block with statements")
    end
    for _, node in ipairs(block.statements) do
        local renderer = renderers[node.kind]
        if not renderer then
            error("Ast: no renderer for node kind '" .. tostring(node.kind) .. "'")
        end
        renderer(node, lines, depth)
    end
end

function Ast.render(block)
    assert(type(block) == "table" and block.statements, "Ast.render expects a Block")
    local lines = {}
    renderBlock(block, lines, 0)
    return table.concat(lines, "\n")
end

return Ast