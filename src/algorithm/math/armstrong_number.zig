//! Armstrong Number Checker
//! ----------------------
//! A program to identify Armstrong numbers (also known as Narcissistic numbers).
//!
//! An Armstrong number is a k-digit number n that satisfies:
//! sum(d[i]^k) = n, where d[i] are the digits of n
//!
//! Mathematical Properties:
//! - Each digit is raised to the power of the total number of digits
//! - The sum of these powers equals the original number
//! - Single digits (0-9) are trivially Armstrong numbers
//!
//! Example Calculations:
//! 153 = 1³ + 5³ + 3³ = 1 + 125 + 27 = 153 (Armstrong)
//! 1253 ≠ 1⁴ + 2⁴ + 5⁴ + 3⁴ = 1 + 16 + 625 + 81 = 723 (Not Armstrong)
//!
//! Functions:
//! power(x: i32, y: u32) i32
//!     Computes x^y using efficient binary exponentiation
//!     Time complexity: O(log y)
//!
//! order(x: i32) i32
//!     Counts the number of digits in x using logarithmic method
//!     Time complexity: O(log x)
//!
//! isArmstrong(x: i32) bool
//!     Determines if x is an Armstrong number
//!     Time complexity: O(log x)
//!
//! Usage:
//! ```zig
//! const x: i32 = 153;
//! const result = isArmstrong(x); // returns true
//! ```
//! To run the code, use the following command: 
//! zig run src/algorithm/math/armstrong_number.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/armstrong_number.zig
//! 
//! Note: Currently supports 32-bit signed integers.
//! Negative numbers are not considered Armstrong numbers.

const std = @import("std");

// Function to calculate x raised to the power y
fn power(x: i32, y: u32) i32 {
    if (y == 0) return 1;
    if (y % 2 == 0) {
        const half = power(x, y / 2);
        return half * half;
    }
    const half = power(x, y / 2);
    return x * half * half;
}

// Function to calculate order of the number
fn order(x: i32) i32 {
    var n: i32 = 0;
    var num = x;
    while (num != 0) {
        n += 1;
        num = @divTrunc(num, 10);
    }
    return n;
}

// Function to check whether the given number is Armstrong number or not
fn isArmstrong(x: i32) bool {
    const n = order(x);
    var temp = x;
    var sum: i32 = 0;

    while (temp != 0) {
        const r = @mod(temp, 10);
        sum += power(r, @as(u32, @intCast(n)));
        temp = @divTrunc(temp, 10);
    }

    return sum == x;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    // Print prompt
    try stdout.writeAll("Enter a number to check if it's an Armstrong number: ");
    
    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        // Trim the input to remove whitespace and newline
        const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        
        // Parse the trimmed input string to an integer
        const number = try std.fmt.parseInt(i32, trimmed_input, 10);
        
        if (isArmstrong(number)) {
            try stdout.print("{d} is an Armstrong number\n", .{number});
        } else {
            try stdout.print("{d} is not an Armstrong number\n", .{number});
        }
    }
}

test "power function" {
    const testing = std.testing;
    try testing.expectEqual(power(2, 3), 8);
    try testing.expectEqual(power(3, 4), 81);
    try testing.expectEqual(power(5, 0), 1);
    try testing.expectEqual(power(7, 1), 7);
    try testing.expectEqual(power(-2, 2), 4);
}

test "order function" {
    const testing = std.testing;
    try testing.expectEqual(order(1), 1);
    try testing.expectEqual(order(10), 2);
    try testing.expectEqual(order(100), 3);
    try testing.expectEqual(order(153), 3);
    try testing.expectEqual(order(1253), 4);
}

test "isArmstrong function" {
    const testing = std.testing;
    try testing.expectEqual(isArmstrong(153), true);  // 1^3 + 5^3 + 3^3 = 153
    try testing.expectEqual(isArmstrong(370), true);  // 3^3 + 7^3 + 0^3 = 370
    try testing.expectEqual(isArmstrong(371), true);  // 3^3 + 7^3 + 1^3 = 371
    try testing.expectEqual(isArmstrong(407), true);  // 4^3 + 0^3 + 7^3 = 407
    try testing.expectEqual(isArmstrong(1253), false); // Not an Armstrong number
    try testing.expectEqual(isArmstrong(123), false);  // Not an Armstrong number
}