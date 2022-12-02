if __name__ == "__main__":
    rounds = []
    for line in open("./input.txt").readlines():
        if line != "\n":
            rounds.append(line.strip())

    shape = {"X": 1, "Y": 2, "Z": 3}
    score = 0

    # A X Rock
    # B Y Paper
    # C Z Scissors
    bind = {"X": "A", "Y": "B", "Z": "C"}

    def outcome(a, b: int) -> int:
        b = bind[b]
        if a == b:
            return 3
        if a == "A":
            if b == "B":
                return 6
            if b == "C":
                return 0
        if a == "B":
            if b == "A":
                return 0
            if b == "C":
                return 6
        if a == "C":
            if b == "A":
                return 6
            if b == "B":
                return 0

    for r in rounds:
        l, r = r[0], r[2]
        score += shape[r]
        score += outcome(l, r)

    print(score)
