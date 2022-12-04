import java.io.File

class Range(val start: Int, val end: Int)

fun read(fileName: String): List<Pair<Range, Range>> {
    return File(fileName).readLines().map { line ->
        val ranges = line.split(",")
            .map { it ->
                it.split("-")
                    .map { it.toInt() }.let { Range(it[0], it[1]) }
            }
        Pair(ranges[0], ranges[1])
    }
}