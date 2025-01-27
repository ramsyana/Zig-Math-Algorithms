//! Reverse a Number Implementation
//!
//! This module implements a function to reverse the digits of a given number.
//! The reversed number is obtained by repeatedly extracting the last digit of the number
//! and appending it to the result until the original number is reduced to 0.
//!
//! Examples:
//! - Input: 123  -> Output: 321
//! - Input: 9876 -> Output: 6789
//! - Input: 100  -> Output: 1 (leading zeros are ignored)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/reverse_number.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/reverse_number.zig

const std = @import("std");

/// Reverses the digits of a given number.
fn reverseNumber(n: u32) u32 {
    var reversed: u32 = 0;
    var num = n;

    while (num > 0) {
        const digit = num % 10; // Extract the last digit
        reversed = reversed * 10 + digit; // Append the digit to the reversed number
        num /= 10; // Remove the last digit
    }

    return reversed;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to reverse its digits: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(u32, trimmed, 10);

        const reversed = reverseNumber(number);
        try stdout.print("The reversed number is {}.\n", .{reversed});
    }
}

test "reverse number" {
    // Basic cases
    try std.testing.expect(reverseNumber(123) == 321); // 123 -> 321
    try std.testing.expect(reverseNumber(9876) == 6789); // 9876 -> 6789
    try std.testing.expect(reverseNumber(0) == 0); // 0 -> 0

    // Edge cases
    try std.testing.expect(reverseNumber(1) == 1); // Single-digit number
    try std.testing.expect(reverseNumber(100) == 1); // Leading zeros are ignored
    try std.testing.expect(reverseNumber(123456789) == 987654321); // Large number
}
