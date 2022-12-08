const fs = require("fs");

// utils ----------------------------

const rotate = (mat) =>
    mat[0].map((val, index) => mat.map((row) => row[index]).reverse());

// main ----------------------------

var data = fs
    .readFileSync("input.txt", "utf8")
    .trim()
    .split("\n")
    .map((line) =>
        line
            .split(" ")
            .map(Number)
            .map((el) => {
                return { val: el, vis: false };
            })
    );

const n = data.length,
    m = data[0].length;

// a ----------------------------

// edge trees
for (var i = 0; i < n; i++) {
    for (var j = 0; j < m; j++) {
        if (i == 0 || i == n - 1 || j == 0 || j == m - 1) {
            data[i][j].vis = true;
        }
    }
}

for (let turn = 0; turn < 4; turn++) {
    var mat = structuredClone(data);
    for (let i = 1; i < n - 1; i++) {
        for (let j = 1; j < m - 1; j++) {
            if (mat[i][j].val > mat[i][j - 1].val) {
                data[i][j].vis = true;
            }
            mat[i][j].val = Math.max(mat[i][j].val, mat[i][j - 1].val);
        }
    }
    data = rotate(data);
}

console.log(
    "a:",
    data.reduce((acc, row) => acc + row.filter((el) => el.vis).length, 0)
);

// b ----------------------------
var score = 0;
for (let i = 1; i < n - 1; i++) {
    for (let j = 1; j < m - 1; j++) {
        let up = 0;
        for (let k = i - 1; k >= 0; k--) {
            up++;
            if (data[k][j].val >= data[i][j].val) {
                break;
            }
        }
        let down = 0;
        for (let k = i + 1; k < n; k++) {
            down++;
            if (data[k][j].val >= data[i][j].val) {
                break;
            }
        }
        let left = 0;
        for (let k = j - 1; k >= 0; k--) {
            left++;
            if (data[i][k].val >= data[i][j].val) {
                break;
            }
        }
        let right = 0;
        for (let k = j + 1; k < m; k++) {
            right++;
            if (data[i][k].val >= data[i][j].val) {
                break;
            }
        }
        const s = up * down * left * right;
        if (s > score) {
            score = s;
        }
    }
}

console.log("b:", score);
