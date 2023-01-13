local vars = {}

local print = print
local line_count = 1

local function wait(s) 
    local sec = tonumber(os.clock() + s); 
    while (os.clock() < sec) do 
    end 
end


function main()
    for line in io.lines(arg[1]) do

        line_count = line_count + 1

        for printw, word in line:gmatch("(.-) ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890%p%s%z]+)") do
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

        for key, value in line:gmatch("v ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890%p%s%z]+) = ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890%p%s%z]+)") do
            vars[key] = value
        end


        for func, param in line:gmatch("(.-) ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890%p%s%z]+)") do
            if func == "r" then
                local r = io.read()
                vars[param] = r
            elseif func == "w" then
                wait(param/2)
            elseif func == "exec" then
                os.execute(param)
            end
        end

        for filename, var in line:gmatch("o ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890%p%s%z]+) ([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890%p%s%z]+)") do
            local f = io.open(filename, "r")
            local data = f:read("*all")
            f:close()

            vars[var] = data
        end
    end
end

local ok,err = pcall(main)
if not ok then
    print("ONE-C ERROR "..err)
end
