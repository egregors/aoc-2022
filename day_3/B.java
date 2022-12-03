import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.lang.Character;

public class B {
    public static String[] readFromFileStrings(String filename) throws IOException {
        FileInputStream fStream = new FileInputStream(filename);
        BufferedReader br = new BufferedReader(new InputStreamReader(fStream));
        String[] lines = br.lines().toArray(String[]::new);
        br.close();
        return lines;
    }

    public static void main(String[] args) throws IOException {
        Integer sum = 0;
        List<String> group = new ArrayList<>();
        for (String line : readFromFileStrings("input.txt")) {
            if (group.size() < 3) {
                group.add(line);
            } else {
                sum += getBadge(group);
                group.clear();
                group.add(line);
            }
        }
        sum += getBadge(group);
        System.out.println(sum);
    }

    private static Integer getBadge(List<String> group) {
        Set<Character> set1 = new HashSet<>();
        Set<Character> set2 = new HashSet<>();
        Set<Character> set3 = new HashSet<>();
        set1.addAll(group.get(0).chars().mapToObj(c -> (char) c).collect(Collectors.toList()));
        set2.addAll(group.get(1).chars().mapToObj(c -> (char) c).collect(Collectors.toList()));
        set3.addAll(group.get(2).chars().mapToObj(c -> (char) c).collect(Collectors.toList()));
        for (char c : set1) {
            if (set2.contains(c) && set3.contains(c)) {
                return Character.isLowerCase(c) ? c - 'a' + 1 : c - 'A' + 27;
            }
        }
        return -1;
    }
}
