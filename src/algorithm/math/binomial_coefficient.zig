//! Binomial Coefficient Calculator Implementation
//!
//! This module implements a calculator for binomial coefficients using an
//! array-based approach to build Pascal's triangle dynamically. It uses
//! `std.ArrayList(u64)` to manage memory efficiently for each row of the 
//! triangle, which allows calculation of binomial coefficients for large 
//! values of n and k without integer overflow.
//!
//! The algorithm constructs each row of Pascal's triangle row by row, 
//! where each element is the sum of the two elements above it, except for 
//! the edges which are always 1. This method ensures accurate computation 
//! for binomial coefficients up to the limit of u64.
//!
//! Examples:
//! - Input: 5, 2 -> Output: 10
//! - Input: 10, 3 -> Output: 120
//! - Input: 20, 10 -> Output: 184756
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/binomial.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/binomial.zig

const std = @import("std");
const expectEqual = std.testing.expectEqual;

/// Calculates the binomial coefficient C(n, k) using Pascal's triangle.
/// - `n` and `k` must be non-negative integers where `k <= n`.
/// - Returns `0` if `k > n`.
fn binomialCoefficient(n: u32, k: u32) !u64 {
    if (k > n) return 0;

    var triangle = try std.ArrayList(u64).initCapacity(std.heap.page_allocator, (n + 1) * (n + 1) / 2);
    defer triangle.deinit();

    for (0..n+1) |i| {
        for (0..i+1) |j| {
            if (j == 0 or j == i) {
                try triangle.append(1);
            } else {
                const prev_row_start = (i - 1) * i / 2;
                try triangle.append(triangle.items[prev_row_start + j - 1] + triangle.items[prev_row_start + j]);
            }
        }
    }

    return triangle.items[n * (n + 1) / 2 + k];
}

/// Interactive function to get user input for n and k, then compute and display C(n,k).
pub fn interactiveMain() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    
    const stdout = std.io.getStdOut().writer();
    try stdout.writeAll("Enter two numbers n and k for binomial coefficient C(n,k): ");

    var buffer: [20]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const input = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    if (input) |trimmed_input| {
        var iterator = std.mem.split(u8, std.mem.trim(u8, trimmed_input, &std.ascii.whitespace), " ");
        
        const n_str = iterator.next() orelse {
            try stdout.writeAll("Error: Please provide two numbers.\n");
            return;
        };
        
        const k_str = iterator.next() orelse {
            try stdout.writeAll("Error: Please provide two numbers.\n");
            return;
        };

        const n = std.fmt.parseInt(u32, n_str, 10) catch |err| {
            try stdout.print("Invalid input for n: {s}\n", .{@errorName(err)});
            return;
        };

        const k = std.fmt.parseInt(u32, k_str, 10) catch |err| {
            try stdout.print("Invalid input for k: {s}\n", .{@errorName(err)});
            return;
        };

        const result = binomialCoefficient(n, k) catch |err| {
            try stdout.print("Error calculating binomial coefficient: {s}\n", .{@errorName(err)});
            return;
        };

        try stdout.print("C({d},{d}) = {d}\n", .{n, k, result});
    }
}

pub fn main() !void {
    try interactiveMain();
}


test "Binomial Coefficient Calculation" {
    // Edge cases
    try expectEqual(@as(u64, 1), try binomialCoefficient(0, 0));
    try expectEqual(@as(u64, 1), try binomialCoefficient(1, 0));
    try expectEqual(@as(u64, 1), try binomialCoefficient(1, 1));
    try expectEqual(@as(u64, 0), try binomialCoefficient(5, 6)); // k > n

    // Standard test cases
    try expectEqual(@as(u64, 1), try binomialCoefficient(5, 0));
    try expectEqual(@as(u64, 5), try binomialCoefficient(5, 1));
    try expectEqual(@as(u64, 10), try binomialCoefficient(5, 2));
    try expectEqual(@as(u64, 10), try binomialCoefficient(5, 3));
    try expectEqual(@as(u64, 5), try binomialCoefficient(5, 4));
    try expectEqual(@as(u64, 1), try binomialCoefficient(5, 5));

    // Additional test cases to verify symmetry
    try expectEqual(@as(u64, 1), try binomialCoefficient(10, 0));
    try expectEqual(@as(u64, 10), try binomialCoefficient(10, 1));
    try expectEqual(@as(u64, 45), try binomialCoefficient(10, 2));
}
