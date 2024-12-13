//! Armstrong Number Verification Implementation
//!
//! This module provides functionality to determine whether a given number 
//! is an Armstrong number (narcissistic number). An Armstrong number is a 
//! number that is the sum of its own digits each raised to the power of 
//! the number of digits.
//!
//! An Armstrong number has the following unique property:
//! For a number with n digits (d1, d2, ..., dn), the sum of each digit 
//! raised to the nth power equals the original number.
//!
//! Examples:
//! - 153 is an Armstrong number (1³ + 5³ + 3³ = 153)
//! - 370 is an Armstrong number (3³ + 7³ + 0³ = 370)
//! - 371 is an Armstrong number (3³ + 7³ + 1³ = 371)
//! - 1634 is a 4-digit Armstrong number (1⁴ + 6⁴ + 3⁴ + 4⁴ = 1634)
//!
//! Computational Complexity:
//! - Time Complexity: O(log n), where n is the input number
//! - Space Complexity: O(1)
//!
//! To run the program:
//! zig run src/algorithm/math/is_armstrong.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/is_armstrong.zig

const std = @import("std");
const math = std.math;

pub fn isArmstrongNumber(num: u32) bool {

    var temp = num;
    var digit_count: u32 = 0;
    while (temp > 0) : (temp /= 10) {
        digit_count += 1;
    }

    temp = num;
    var sum: u32 = 0;

    while (temp > 0) : (temp /= 10) {
        const digit = temp % 10;
        sum += math.pow(u32, digit, digit_count);
    }

    return sum == num;
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
        const result = isArmstrongNumber(num);
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;

        if (result) {
            try stdout.print("{d} is an Armstrong number (Computed in {d:.3}s)\n", .{num, duration});
        } else {
            try stdout.print("{d} is not an Armstrong number (Computed in {d:.3}s)\n", .{num, duration});
        }
    }
}

test "Armstrong number calculations" {
    try std.testing.expect(isArmstrongNumber(153) == true);
    try std.testing.expect(isArmstrongNumber(370) == true);
    try std.testing.expect(isArmstrongNumber(371) == true);
    try std.testing.expect(isArmstrongNumber(407) == true);
    try std.testing.expect(isArmstrongNumber(1634) == true);  

    try std.testing.expect(isArmstrongNumber(123) == false);
    try std.testing.expect(isArmstrongNumber(1233) == false);
}