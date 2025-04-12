//! Matrix Multiplication
//! --------------------
//! A program to perform matrix multiplication.
//!
//! Matrix multiplication is a binary operation that produces a matrix from two input matrices.
//! Given matrices A (m×n) and B (n×p), their product C = A×B is an m×p matrix.
//!
//! Mathematical Properties:
//! - Matrix multiplication is associative: (AB)C = A(BC)
//! - Matrix multiplication is distributive: A(B+C) = AB+AC
//! - Matrix multiplication is NOT commutative: AB ≠ BA in general
//!
//! Algorithm:
//! - For each element C[i][j] in the result matrix:
//!   C[i][j] = sum(A[i][k] * B[k][j]) for k = 0 to n-1
//!
//! Time Complexity: O(m*n*p) where:
//!   - m = rows in first matrix
//!   - n = columns in first matrix / rows in second matrix
//!   - p = columns in second matrix
//!
//! Usage:
//! ```zig
//! const a = [_][3]f64{
//!     [_]f64{ 1, 2, 3 },
//!     [_]f64{ 4, 5, 6 },
//! };
//! const b = [_][2]f64{
//!     [_]f64{ 7, 8 },
//!     [_]f64{ 9, 10 },
//!     [_]f64{ 11, 12 },
//! };
//! var result: [2][2]f64 = undefined;
//! multiplyMatrices(a, b, &result);
//! ```
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/matrix_multiplication.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/matrix_multiplication.zig

const std = @import("std");

/// Multiplies two matrices a and b, storing the result in the pre-allocated result matrix.
/// a: m×n matrix
/// b: n×p matrix
/// result: m×p matrix (pre-allocated)
pub fn multiplyMatrices(a: anytype, b: anytype, result: anytype) void {
    const m = a.len; // Rows in matrix a
    const n = a[0].len; // Columns in matrix a / Rows in matrix b
    const p = b[0].len; // Columns in matrix b

    // Iterate through each element of the result matrix
    for (0..m) |i| {
        for (0..p) |j| {
            result[i][j] = 0;
            // Calculate the dot product for this position
            for (0..n) |k| {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

/// Prints a matrix to stdout
pub fn printMatrix(matrix: anytype) !void {
    const stdout = std.io.getStdOut().writer();

    for (matrix) |row| {
        try stdout.writeAll("[ ");
        for (row, 0..) |value, j| {
            try stdout.print("{d}", .{value});
            if (j < row.len - 1) {
                try stdout.writeAll(", ");
            }
        }
        try stdout.writeAll(" ]\n");
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Example matrices
    const a = [_][3]f64{
        [_]f64{ 1, 2, 3 },
        [_]f64{ 4, 5, 6 },
    };

    const b = [_][2]f64{
        [_]f64{ 7, 8 },
        [_]f64{ 9, 10 },
        [_]f64{ 11, 12 },
    };

    // Result matrix will be 2×2
    var result: [2][2]f64 = undefined;

    // Perform matrix multiplication
    multiplyMatrices(a, b, &result);

    // Display the matrices and result
    try stdout.writeAll("Matrix A:\n");
    try printMatrix(a);

    try stdout.writeAll("\nMatrix B:\n");
    try printMatrix(b);

    try stdout.writeAll("\nResult (A × B):\n");
    try printMatrix(result);
}

test "matrix multiplication" {
    const testing = std.testing;

    // Test case 1: 2×3 * 3×2
    const a1 = [_][3]f64{
        [_]f64{ 1, 2, 3 },
        [_]f64{ 4, 5, 6 },
    };

    const b1 = [_][2]f64{
        [_]f64{ 7, 8 },
        [_]f64{ 9, 10 },
        [_]f64{ 11, 12 },
    };

    var result1: [2][2]f64 = undefined;
    multiplyMatrices(a1, b1, &result1);

    const expected1 = [_][2]f64{
        [_]f64{ 58, 64 },
        [_]f64{ 139, 154 },
    };

    for (0..result1.len) |i| {
        for (0..result1[0].len) |j| {
            try testing.expectEqual(expected1[i][j], result1[i][j]);
        }
    }

    // Test case 2: 3×2 * 2×3
    const a2 = [_][2]f64{
        [_]f64{ 1, 2 },
        [_]f64{ 3, 4 },
        [_]f64{ 5, 6 },
    };

    const b2 = [_][3]f64{
        [_]f64{ 7, 8, 9 },
        [_]f64{ 10, 11, 12 },
    };

    var result2: [3][3]f64 = undefined;
    multiplyMatrices(a2, b2, &result2);

    const expected2 = [_][3]f64{
        [_]f64{ 27, 30, 33 },
        [_]f64{ 61, 68, 75 },
        [_]f64{ 95, 106, 117 },
    };

    for (0..result2.len) |i| {
        for (0..result2[0].len) |j| {
            try testing.expectEqual(expected2[i][j], result2[i][j]);
        }
    }
}
