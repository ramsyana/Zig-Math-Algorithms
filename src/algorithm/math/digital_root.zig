//! Digit Sum and Digital Root Calculator Implementation
//!
//! This module implements functions to calculate the sum of digits of a number
//! and its digital root. The digital root is the recursive sum of all digits
//! until a single-digit number is obtained.
//!
//! Examples:
//! - Input: 12345  -> Sum of Digits: 15, Digital Root: 6 (1 + 2 + 3 + 4 + 5 = 15, 1 + 5 = 6)
//! - Input: 98765  -> Sum of Digits: 35, Digital Root: 8 (9 + 8 + 7 + 6 + 5 = 35, 3 + 5 = 8)
//! - Input: 9      -> Sum of Digits: 9, Digital Root: 9
//! - Input: 0      -> Sum of Digits: 0, Digital Root: 0
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/digital_root.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/digital_root.zig

const std = @import("std");

/// Calculates the sum of digits of a number.
fn sumOfDigits(n: i32) i32 {
    if (n == 0) return 0;
    return @rem(n, 10) + sumOfDigits(@divTrunc(n, 10));
}

/// Calculates the digital root of a number.
fn digitalRoot(n: i32) i32 {
    if (n < 10) return n;
    return digitalRoot(sumOfDigits(n));
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to calculate its sum of digits and digital root: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(i32, trimmed, 10);

        const sum = sumOfDigits(number);
        const root = digitalRoot(number);

        try stdout.print("Sum of Digits: {}\n", .{sum});
        try stdout.print("Digital Root: {}\n", .{root});
    }
}

test "sum of digits" {
    try std.testing.expect(sumOfDigits(12345) == 15); // 1 + 2 + 3 + 4 + 5 = 15
    try std.testing.expect(sumOfDigits(98765) == 35); // 9 + 8 + 7 + 6 + 5 = 35
    try std.testing.expect(sumOfDigits(9) == 9); // Single-digit number
    try std.testing.expect(sumOfDigits(0) == 0); // Edge case
}

test "digital root" {
    try std.testing.expect(digitalRoot(12345) == 6); // 1 + 2 + 3 + 4 + 5 = 15, 1 + 5 = 6
    try std.testing.expect(digitalRoot(98765) == 8); // 9 + 8 + 7 + 6 + 5 = 35, 3 + 5 = 8
    try std.testing.expect(digitalRoot(9) == 9); // Single-digit number
    try std.testing.expect(digitalRoot(0) == 0); // Edge case
}
