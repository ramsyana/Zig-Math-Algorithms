//! Palindrome Number Checker
//!
//! This module provides functionality to check if a given number is a palindrome.
//! A palindrome number reads the same backwards as forwards.
//!
//! The main function:
//! isPalindrome(number: u32) -> bool
//!
//! Algorithm:
//! 1. Reverse the given number
//! 2. Compare the reversed number with the original number
//! 3. If they are equal, the number is a palindrome
//!
//! Examples:
//! - isPalindrome(12321) = true
//! - isPalindrome(12345) = false
//!
//! Computational Complexity:
//! - Time Complexity: O(log n), where n is the input number
//! - Space Complexity: O(1)
//!
//! The program also includes a simple command-line interface to input a number
//! and check if it's a palindrome, displaying the result and computation time.
//!
//! To run the program:
//! zig run src/algorithm/math/palindrome_number.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/palindrome_number.zig

const std = @import("std");
const expect = std.testing.expect;

fn isPalindrome(number: u32) bool {
    var num = number;
    var reversedNumber: u32 = 0;

    while (num != 0) {
        const remainder = num % 10;
        reversedNumber = reversedNumber * 10 + remainder;
        num /= 10;
    }

    return number == reversedNumber;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number: ");

    var buf: [100]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const num = blk: {
            const trimmed = std.mem.trimRight(u8, line, " \t\r\n");
            break :blk try std.fmt.parseInt(u32, trimmed, 10);
        };

        const start = std.time.milliTimestamp();
        const result = isPalindrome(num);
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;

        if (result) {
            try stdout.print("{d} is a palindrome number (Computed in {d:.3}s)\n", .{num, duration});
        } else {
            try stdout.print("{d} is not a palindrome number (Computed in {d:.3}s)\n", .{num, duration});
        }
    }
}

test "palindrome number tests" {
    try std.testing.expect(isPalindrome(0) == true);
    try std.testing.expect(isPalindrome(1) == true);
    try std.testing.expect(isPalindrome(12321) == true);
    try std.testing.expect(isPalindrome(123321) == true);
    try std.testing.expect(isPalindrome(1234) == false);
    try std.testing.expect(isPalindrome(12345) == false);
}