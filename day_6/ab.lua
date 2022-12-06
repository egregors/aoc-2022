function findPkg(msg, n)
    local l, r, set = 1, 2, {}
    set[string.sub(msg, 1, 1)] = true

    while l < r do
        local c = string.sub(msg, r, r)
        while set[c] do
            set[string.sub(msg, l, l)] = nil
            l = l + 1
        end

        set[string.sub(msg, r, r)] = true
        r = r + 1

        if r - l >= n then
            return r - 1
        end
    end
end

local input
for line in io.lines("input.txt") do
    input = line
end
print("a:", findPkg(input, 4))
print("b:", findPkg(input, 14))
