fun main() {
    println(
        read("input.txt").count { (f, s) ->
            (f.start >= s.start && f.end <= s.end) || (s.start >= f.start && s.end <= f.end)
        }
    )
}
