fun main() {
    println(
        read("input.txt").count { (f, s) -> f.start <= s.end && f.end >= s.start }
    )
}