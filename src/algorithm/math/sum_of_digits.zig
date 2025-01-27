//! Sum of Digits Implementation
//!
//! This module implements a function to calculate the sum of the digits of a given number.
//! The sum of digits is obtained by repeatedly extracting the last digit of the number
//! and adding it to a running total until the number is reduced to 0.
//!
//! Examples:
//! - Input: 123  -> Output: 6 (1 + 2 + 3 = 6)
//! - Input: 9876 -> Output: 30 (9 + 8 + 7 + 6 = 30)
//! - Input: 0    -> Output: 0
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/sum_of_digits.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/sum_of_digits.zig

const std = @import("std");

/// Calculates the sum of the digits of a given number.
fn sumOfDigits(n: u32) u32 {
    var sum: u32 = 0;
    var num = n;

    while (num > 0) {
        sum += num % 10; // Add the last digit to the sum
        num /= 10; // Remove the last digit
    }

    return sum;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to calculate the sum of its digits: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(u32, trimmed, 10);

        const sum = sumOfDigits(number);
        try stdout.print("The sum of the digits of {} is {}.\n", .{ number, sum });
    }
}

test "sum of digits" {
    // Basic cases
    try std.testing.expect(sumOfDigits(123) == 6); // 1 + 2 + 3 = 6
    try std.testing.expect(sumOfDigits(9876) == 30); // 9 + 8 + 7 + 6 = 30
    try std.testing.expect(sumOfDigits(0) == 0); // 0 has no digits to sum

    // Edge cases
    try std.testing.expect(sumOfDigits(1) == 1); // Single-digit number
    try std.testing.expect(sumOfDigits(999) == 27); // All digits are 9
    try std.testing.expect(sumOfDigits(1000) == 1); // Leading zeros (in terms of digits)
}
