local vars = {}

local print, error = print, error
local line_count = 1

local function wait(s) 
    local sec = tonumber(os.clock() + s); 
    while (os.clock() < sec) do 
    end 
end


function main()
    for line in io.lines(arg[1]) do

        line_count = line_count + 1

        for printw, word in line:gmatch("(.-) ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+)") do
            if printw == "p" then
                print(word.."\n")
            elseif printw == "pwn" then
                print(word)
            elseif printw == "pv" then
                if vars[word] then
                    print(vars[word])
                end
            end
        end

        for vartype, key, value in line:gmatch("(.-) ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+) = ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+)") do
            if vartype == "int" then
                vars[key] = tonumber(value) or error("NOT AN NUMBER")
            end
            if vartype == "string" then
                vars[key] = tostring(value)
            end
        end


        for func, param in line:gmatch("(.-) ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+)") do
            if func == "r" then
                local r = io.read()
                vars[param] = r
            elseif func == "w" then
                wait(param/2+param/2)
            elseif func == "exec" then
                os.execute(param)
            end
        end

        for filename_r, var in line:gmatch('or ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+) = ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+)') do
            local f = io.open(filename_r, "r")
            local data = f:read("*all")
            f:close()

            vars[var] = data
        end

        for filename_w, towrite in line:gmatch('ow ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+) = ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%d%p%s%z]+)') do
            local f = io.open(filename_w, "w")
            f:write(towrite)
            f:close()
        end
    end
end

local ok,err = pcall(main)
if not ok then
    print("1DC ERROR "..err)
end
