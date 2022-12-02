if __name__ == "__main__":
    rounds = []
    for line in open("./input.txt").readlines():
        if line != "\n":
            rounds.append(line.strip())

    points = {
        "A X": 3,
        "A Y": 4,
        "A Z": 8,
        "B X": 1,
        "B Y": 5,
        "B Z": 9,
        "C X": 2,
        "C Y": 6,
        "C Z": 7,
    }

    print(sum([points[r] for r in rounds]))
