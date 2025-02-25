//! Modular Exponentiation Calculator
//! -------------------------------
//! A program to efficiently compute (base^exponent) % modulus.
//!
//! Mathematical Properties:
//! - Uses the property: (a * b) % m = ((a % m) * (b % m)) % m
//! - Implements square-and-multiply algorithm
//! - Reduces intermediate results to prevent integer overflow
//!
//! Example Calculations:
//! 2^10 % 17 = 4  (1024 % 17 = 4)
//! 3^7 % 13 = 3   (2187 % 13 = 3)
//!
//! Functions:
//! modPow(base: i64, exponent: i64, modulus: i64) i64
//!     Computes (base^exponent) % modulus efficiently
//!     Time complexity: O(log n) where n is the exponent
//!
//! Usage:
//! ```zig
//! const result = modPow(2, 10, 17); // returns 4
//! ```
//!
//! Note: Supports signed 64-bit integers.
//! Negative exponents are not supported.

const std = @import("std");

fn modPow(base: i64, exponent: i64, modulus: i64) i64 {
    if (modulus == 1) return 0;
    if (exponent < 0) return 0; // Error case for negative exponents

    var result: i64 = 1;
    var base_temp = @mod(base, modulus);
    var exp_temp = exponent;

    while (exp_temp > 0) {
        if (exp_temp & 1 == 1) {
            result = @mod((result * base_temp), modulus);
        }
        base_temp = @mod((base_temp * base_temp), modulus);
        exp_temp >>= 1;
    }

    return result;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var buf: [100]u8 = undefined;

    // Get base
    try stdout.writeAll("Enter the base number: ");
    const base_input = (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')).?;
    const base = try std.fmt.parseInt(i64, std.mem.trim(u8, base_input, &std.ascii.whitespace), 10);

    // Get exponent
    try stdout.writeAll("Enter the exponent: ");
    const exp_input = (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')).?;
    const exponent = try std.fmt.parseInt(i64, std.mem.trim(u8, exp_input, &std.ascii.whitespace), 10);

    // Get modulus
    try stdout.writeAll("Enter the modulus: ");
    const mod_input = (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')).?;
    const modulus = try std.fmt.parseInt(i64, std.mem.trim(u8, mod_input, &std.ascii.whitespace), 10);

    if (modulus <= 0) {
        try stdout.writeAll("Modulus must be positive.\n");
        return;
    }

    if (exponent < 0) {
        try stdout.writeAll("Negative exponents are not supported.\n");
        return;
    }

    const result = modPow(base, exponent, modulus);
    try stdout.print("\n({d}^{d}) % {d} = {d}\n", .{ base, exponent, modulus, result });
}

test "modPow basic cases" {
    const testing = std.testing;
    try testing.expectEqual(modPow(2, 10, 17), 4);
    try testing.expectEqual(modPow(3, 7, 13), 3);
    try testing.expectEqual(modPow(5, 3, 7), 6);
    try testing.expectEqual(modPow(4, 12, 13), 1);
}

test "modPow edge cases" {
    const testing = std.testing;
    // Base cases
    try testing.expectEqual(modPow(1, 1000, 13), 1);
    try testing.expectEqual(modPow(0, 5, 13), 0);
    try testing.expectEqual(modPow(7, 0, 13), 1);

    // Modulus = 1 case
    try testing.expectEqual(modPow(5, 3, 1), 0);

    // Large numbers
    try testing.expectEqual(modPow(2, 63, 1000000007), 9223372036854775808 % 1000000007);
}

test "modPow error cases" {
    const testing = std.testing;
    // Negative exponent
    try testing.expectEqual(modPow(2, -1, 17), 0);
}
