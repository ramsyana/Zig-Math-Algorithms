//! abundant_deficient_checker
//!
//! This code checks if a given number is abundant, deficient, or perfect.
//! - An abundant number is one where the sum of its proper divisors is greater than the number itself.
//! - A deficient number is one where the sum of its proper divisors is less than the number itself.
//! - A perfect number is one where the sum of its proper divisors equals the number itself.
//!
//! Usage:
//! Run the code using `zig run src/algorithm/math/abundant_deficient_checker.zig`.
//! The code will prompt the user to input a number, and it will output whether the number
//! is abundant, deficient, or perfect.
//!
//! Tests:
//! The code includes unit tests to verify the correctness of the implementation.

const std = @import("std");

/// Calculates the sum of proper divisors of a number.
/// A proper divisor of `n` is a divisor of `n` that is less than `n`.
fn sumOfProperDivisors(n: u32) u32 {
    if (n == 0 or n == 1) return 0; // 0 and 1 have no proper divisors
    var sum: u32 = 0;
    for (1..n) |i| {
        if (n % i == 0) {
            sum += @as(u32, @intCast(i)); // Explicitly cast `i` to `u32`
        }
    }
    return sum;
}

/// Checks if a number is abundant.
/// A number is abundant if the sum of its proper divisors is greater than the number itself.
fn isAbundant(n: u32) bool {
    return sumOfProperDivisors(n) > n;
}

/// Checks if a number is deficient.
/// A number is deficient if the sum of its proper divisors is less than the number itself.
fn isDeficient(n: u32) bool {
    return sumOfProperDivisors(n) < n;
}

/// Checks if a number is perfect.
/// A number is perfect if the sum of its proper divisors equals the number itself.
fn isPerfect(n: u32) bool {
    return sumOfProperDivisors(n) == n;
}

/// Main function: Prompts the user for input and checks if the number is abundant, deficient, or perfect.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a number to check if it is abundant, deficient, or perfect: ", .{});
    var input: [32]u8 = undefined; // Buffer to store user input
    const input_len = try stdin.read(&input);
    const number_str = std.mem.trimRight(u8, input[0..input_len], "\r\n"); // Trim both \r and \n

    const number = std.fmt.parseInt(u32, number_str, 10) catch |err| {
        try stdout.print("Invalid input. Please enter a valid positive integer.\n", .{});
        return err;
    };

    const sum = sumOfProperDivisors(number);

    if (isAbundant(number)) {
        try stdout.print("{} is an abundant number (sum of proper divisors: {})\n", .{ number, sum });
    } else if (isDeficient(number)) {
        try stdout.print("{} is a deficient number (sum of proper divisors: {})\n", .{ number, sum });
    } else {
        try stdout.print("{} is a perfect number (sum of proper divisors: {})\n", .{ number, sum });
    }
}

test "sumOfProperDivisors" {
    try std.testing.expectEqual(sumOfProperDivisors(0), 0);
    try std.testing.expectEqual(sumOfProperDivisors(1), 0);
    try std.testing.expectEqual(sumOfProperDivisors(6), 6); // 1 + 2 + 3
    try std.testing.expectEqual(sumOfProperDivisors(12), 16); // 1 + 2 + 3 + 4 + 6
    try std.testing.expectEqual(sumOfProperDivisors(15), 9); // 1 + 3 + 5
}

test "isAbundant" {
    try std.testing.expect(isAbundant(12)); // 1 + 2 + 3 + 4 + 6 = 16 > 12
    try std.testing.expect(!isAbundant(6)); // 1 + 2 + 3 = 6 (not abundant)
    try std.testing.expect(!isAbundant(15)); // 1 + 3 + 5 = 9 < 15 (not abundant)
}

test "isDeficient" {
    try std.testing.expect(isDeficient(15)); // 1 + 3 + 5 = 9 < 15
    try std.testing.expect(!isDeficient(12)); // 1 + 2 + 3 + 4 + 6 = 16 > 12 (not deficient)
    try std.testing.expect(!isDeficient(6)); // 1 + 2 + 3 = 6 (not deficient)
}

test "isPerfect" {
    try std.testing.expect(isPerfect(6)); // 1 + 2 + 3 = 6
    try std.testing.expect(isPerfect(28)); // 1 + 2 + 4 + 7 + 14 = 28
    try std.testing.expect(!isPerfect(12)); // 1 + 2 + 3 + 4 + 6 = 16 ≠ 12 (not perfect)
}
