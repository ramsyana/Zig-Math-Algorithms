//! Leap Year Checker Implementation
//!
//! This module implements a function to check if a given year is a leap year.
//! A leap year is a year that is divisible by 4, but not by 100, unless it is also divisible by 400.
//!
//! Rules:
//! - If a year is divisible by 400, it is a leap year.
//! - If a year is divisible by 100 but not by 400, it is NOT a leap year.
//! - If a year is divisible by 4 but not by 100, it is a leap year.
//! - All other years are NOT leap years.
//!
//! Examples:
//! - Input: 2000 -> Output: true  (divisible by 400)
//! - Input: 1900 -> Output: false (divisible by 100 but not by 400)
//! - Input: 2024 -> Output: true  (divisible by 4 but not by 100)
//! - Input: 2023 -> Output: false (not divisible by 4)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/leap_year_checker.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/leap_year_checker.zig

const std = @import("std");

/// Checks if a given year is a leap year.
/// A leap year is divisible by 4, but not by 100, unless it is also divisible by 400.
fn isLeapYear(year: u32) bool {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    if (year % 4 == 0) return true;
    return false;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a year to check if it is a leap year: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const year = try std.fmt.parseInt(u32, trimmed, 10);

        if (isLeapYear(year)) {
            try stdout.print("{} is a leap year.\n", .{year});
        } else {
            try stdout.print("{} is not a leap year.\n", .{year});
        }
    }
}

test "leap year checker" {
    // Leap years
    try std.testing.expect(isLeapYear(2000)); // Divisible by 400
    try std.testing.expect(isLeapYear(2024)); // Divisible by 4 but not by 100
    try std.testing.expect(isLeapYear(1996)); // Divisible by 4 but not by 100

    // Non-leap years
    try std.testing.expect(!isLeapYear(1900)); // Divisible by 100 but not by 400
    try std.testing.expect(!isLeapYear(2023)); // Not divisible by 4
    try std.testing.expect(!isLeapYear(2100)); // Divisible by 100 but not by 400

    // Edge cases
    try std.testing.expect(isLeapYear(0)); // Year 0 is considered a leap year
    try std.testing.expect(!isLeapYear(1)); // Not divisible by 4
    try std.testing.expect(!isLeapYear(100)); // Divisible by 100 but not by 400
}
