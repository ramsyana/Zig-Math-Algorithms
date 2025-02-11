//! Fermat's Factorization Method
//! --------------------------
//! An implementation of Fermat's integer factorization algorithm.
//!
//! Mathematical Properties:
//! - Based on representing an odd number n as difference of squares: n = a² - b²
//! - Can be written as: n = (a+b)(a-b) where a > b
//! - Works best for numbers that are products of two close factors
//!
//! Example Calculations:
//! 5959 = 101 × 59 (Factored using a = 80, b = 21)
//! 1024 = 2 × 512 (Even number handled directly)
//!
//! Functions:
//! fermatFactors(n: u64) !FactorPair
//!     Finds two factors of n using Fermat's method
//!     Time complexity: O(n^(1/4)) average case
//!
//! Usage:
//! ```zig
//! const n: u64 = 5959;
//! const factors = try fermatFactors(n); // returns {.a = 101, .b = 59}
//! ```
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/fermats_factorization.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/fermats_factorization.zig
//!
//! Note: Currently supports 64-bit unsigned integers.
//! Prime numbers will return 1 and themselves as factors.

const std = @import("std");
const math = std.math;

const FactorPair = struct { a: u64, b: u64 };

/// Finds two factors of n using Fermat's factorization method
pub fn fermatFactors(n: u64) !FactorPair {
    // Handle even numbers directly
    if (n % 2 == 0) return .{ .a = 2, .b = n / 2 };

    const sqrt_n = math.sqrt(@as(f64, @floatFromInt(n)));
    var a = @as(u64, @intFromFloat(@ceil(sqrt_n)));

    if (a * a == n) return .{ .a = a, .b = a };

    var b2: u64 = a * a - n;
    var b = @as(u64, @intFromFloat(@sqrt(@as(f64, @floatFromInt(b2)))));

    while (b * b != b2) : ({
        a += 1;
        b2 = a * a - n;
        b = @as(u64, @intFromFloat(@sqrt(@as(f64, @floatFromInt(b2)))));
    }) {
        if (a > (n + 1) / 2) return error.NoFactorsFound;
    }

    return .{
        .a = a + b,
        .b = a - b,
    };
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    // Print prompt
    try stdout.writeAll("Enter a number to factorize: ");

    var buf: [20]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        // Trim the input to remove whitespace and newline
        const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);

        if (std.fmt.parseInt(u64, trimmed_input, 10)) |number| {
            if (fermatFactors(number)) |factors| {
                try stdout.print("Factors of {d}: {d} and {d}\n", .{ number, factors.a, factors.b });
            } else |_| {
                try stdout.writeAll("Could not find factors.\n");
            }
        } else |_| {
            try stdout.writeAll("Invalid input. Please enter a positive number.\n");
        }
    }
}

test "fermatFactors function - composite numbers" {
    const testing = std.testing;
    const pair1 = try fermatFactors(5959);
    try testing.expectEqual(pair1.a, 101);
    try testing.expectEqual(pair1.b, 59);

    const pair2 = try fermatFactors(1024);
    try testing.expectEqual(pair2.a, 2);
    try testing.expectEqual(pair2.b, 512);
}

test "fermatFactors function - perfect squares" {
    const testing = std.testing;
    const pair = try fermatFactors(144);
    try testing.expectEqual(pair.a, 12);
    try testing.expectEqual(pair.b, 12);
}

test "fermatFactors function - prime numbers" {
    const testing = std.testing;
    const pair = try fermatFactors(7919);
    try testing.expectEqual(pair.a, 7919);
    try testing.expectEqual(pair.b, 1);
}
