//! Perfect Number Checker Implementation
//!
//! This module implements a function to check if a given number is a perfect number.
//! A perfect number is a positive integer that is equal to the sum of its proper divisors
//! (excluding itself). For example, 6 is a perfect number because its proper divisors
//! are 1, 2, and 3, and 1 + 2 + 3 = 6.
//!
//! Examples:
//! - Input: 6  -> Output: true
//! - Input: 28 -> Output: true
//! - Input: 12 -> Output: false
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/perfect_number_checker.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/perfect_number_checker.zig

const std = @import("std");

/// Checks if a number is a perfect number.
/// A perfect number is equal to the sum of its proper divisors (excluding itself).
fn isPerfectNumber(n: u32) bool {
    if (n < 2) return false;

    var sum: u32 = 1;
    var i: u32 = 2;

    while (i * i <= n) : (i += 1) {
        if (n % i == 0) {
            sum += i;
            if (i != n / i) {
                sum += n / i;
            }
        }
    }

    return sum == n;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to check if it is a perfect number: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(u32, trimmed, 10);

        if (isPerfectNumber(number)) {
            try stdout.print("{} is a perfect number.\n", .{number});
        } else {
            try stdout.print("{} is not a perfect number.\n", .{number});
        }
    }
}

test "perfect number checker" {
    // Known perfect numbers
    try std.testing.expect(isPerfectNumber(6));
    try std.testing.expect(isPerfectNumber(28));
    try std.testing.expect(isPerfectNumber(496));
    try std.testing.expect(isPerfectNumber(8128));

    // Non-perfect numbers
    try std.testing.expect(!isPerfectNumber(12));
    try std.testing.expect(!isPerfectNumber(100));
    try std.testing.expect(!isPerfectNumber(1));
    try std.testing.expect(!isPerfectNumber(0));

    // Edge cases
    try std.testing.expect(!isPerfectNumber(2));
    try std.testing.expect(!isPerfectNumber(3));
    try std.testing.expect(!isPerfectNumber(5));
}
