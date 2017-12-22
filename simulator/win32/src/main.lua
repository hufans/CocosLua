local breakSocketHandle,debugXpCall
local luaIdeDebug = true
if luaIdeDebug == true then
   breakSocketHandle,debugXpCall = require("LuaIdeDebug.LuaDebugjit")("localhost",7003)
   cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.3, false) 
end
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

if ST_MYPROJECT_ISLOG then
    --清除日志记录
    local function clearLog()
        local date = os.date("%Y-%m-%d %H:%M:%S")

        local file = io.open('print_log.txt', "w")
        io.output(file)
        io.write("["..date.."]")
        io.close(file)
    end
    --打印日志
    local function printLog()
        _print = print
        function print( ... )
            -- 写日志文件
            local tableP = { ... }
            local filename = "print_log.txt"
            local file
            file = io.open(filename,"a")
            io.output(file)
            for i, v in pairs(tableP) do
                if type(v) == "boolean" then
                    if v then v = "true" else v = "false" end
                    io.write(v)
                    io.write('\n')
                elseif type(v) == "userdata" then
                elseif type(v) == "table" then
                elseif type(v) == "function" then
                else
                    io.write(v)
                    io.write('\n')
                end
            end
            file:close()
            _print(...)
        end
    end
    clearLog()
    printLog()
end


function __G__TRACKBACK__(errorMessage)
    if luaIdeDebug == true then debugXpCall() end
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    
    local msg = debug.traceback(errorMessage, 2)
    --写入文件
    local file = io.open('errorInfo.txt', "a")
    io.output(file)
    io.write('\n')
    io.write('\n')
    io.write('\n')
    io.write(msg)
    io.write('\n')
    --追加时间
    io.write(os.date('%c') .. '\n')
    io.write('\n')
    io.write('\n')
    io.write('\n')
    io.close(file)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
