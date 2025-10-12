local temp = {}

function temp.printTable(tbl, indent)
    indent = indent or 0
    local formatting = string.rep("  ", indent)
    
    if type(tbl) ~= "table" then
        print(formatting .. tostring(tbl))
        return
    end
    
    print(formatting .. "{")
    for k, v in pairs(tbl) do
        local key
        if type(k) == "string" then
            key = k
        else
            key = "[" .. tostring(k) .. "]"
        end

        if type(v) == "table" then
            io.write(formatting .. "  " .. key .. " = ")
            temp.printTable(v, indent + 1)
        else
            print(formatting .. "  " .. key .. " = " .. tostring(v))
        end
    end
    print(formatting .. "}")
end

return temp