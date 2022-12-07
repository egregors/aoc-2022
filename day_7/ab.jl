# read input from file
lines = readlines("input.txt")

# FS Node
mutable struct Node
    name::String
    size::Int
    parent::Union{Node,Nothing}
    children::Union{Dict{String,Node},Nothing}
end

function getFullPath(node::Node)
    if node.parent === nothing
        return node.name
    else
        return "$(getFullPath(node.parent))/$(node.name)"
    end
end

function printNode(node::Node, level::Int)
    if node.children !== nothing
        for child in values(node.children)
            printNode(child, level + 1)
        end
    end
end

function countSize(node::Node)
    if node.children === nothing
        return node.size
    else
        size = 0
        for child in values(node.children)
            size += countSize(child)
        end
        node.size = size
        return size
    end
end

function sum_at_most_100000(node::Node)
    sum = 0

    if node.children !== nothing
        if node.size <= 100000
            sum += node.size
        end
        for child in values(node.children)
            sum += sum_at_most_100000(child)
        end
    end

    return sum
end

function get_all_dir_sizes(node::Node)
    sizes = []
    if node.children !== nothing
        push!(sizes, node.size)
        for child in values(node.children)
            sizes = [sizes; get_all_dir_sizes(child)]
        end
    end
    sort!(sizes)
    return sizes
end

# ----------------MAIN

root = Node("/", 0, nothing, Dict{String,Node}())
curr = root

i = 1 # skeep first line with "cd /"
while i < length(lines)
    cmd = lines[i+1]
    if occursin("\$", cmd)
        cmd = cmd[3:end]

        # ls - add children to current Node
        if cmd[1:2] == "ls"
            global i += 1
            cmd = lines[i+1]
            while i < length(lines) && !occursin("\$", cmd)
                # dir | $size
                if occursin("dir ", cmd)
                    cmd = cmd[5:end]
                    curr.children[cmd] = Node(cmd, 0, curr, Dict{String,Node}())
                else
                    size, name = eachsplit(cmd, " ")
                    curr.children[name] = Node(name, parse(Int, size), curr, nothing)
                end
                i += 1

                if i >= length(lines)
                    i += 1
                    break
                end
                cmd = lines[i+1]
            end
            continue
        end

        # cd - change current Node
        if cmd[1:2] == "cd"
            cmd = cmd[4:end]
            if cmd == ".."
                global curr = curr.parent
            else
                global curr = curr.children[cmd]
            end
        end

    else
        throw("ERROR: anexpected input: $cmd")
    end
    global i += 1
end

# a
countSize(root)
println("a: $(sum_at_most_100000(root))")

# b
for s in get_all_dir_sizes(root)
    if 70000000 - root.size + s >= 30000000
        println("b: $s")
        break
    end
end