import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.lang.Character;

public class A {
    public static String[] readFromFileStrings(String filename) throws IOException {
        FileInputStream fStream = new FileInputStream(filename);
        BufferedReader br = new BufferedReader(new InputStreamReader(fStream));
        String[] lines = br.lines().toArray(String[]::new);
        br.close();
        return lines;
    }

    public static void main(String[] args) throws IOException {
        Integer sum = 0;
        for (String line : readFromFileStrings("input.txt")) {
            sum += getPriority(line);
        }
        System.out.println(sum);
    }

    private static Integer getPriority(String line) {
        String left = line.substring(0, line.length() / 2);
        String right = line.substring(line.length() / 2);
        Set<Character> leftSet = new HashSet<>();
        leftSet.addAll(left.chars().mapToObj(c -> (char) c).collect(Collectors.toList()));
        for (char c : right.toCharArray()) {
            if (leftSet.contains(c)) {
                return Character.isLowerCase(c) ? c - 'a' + 1 : c - 'A' + 27;
            }
        }
        return -1;
    }
}
