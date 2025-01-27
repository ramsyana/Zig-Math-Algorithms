//! Integer Square Root Calculator Implementation
//!
//! This module implements a function to calculate the integer square root of a given number.
//! The integer square root is the largest integer less than or equal to the square root of the number.
//! This is calculated using the binary search algorithm for efficiency.
//!
//! Examples:
//! - Input: 16  -> Output: 4 (4 * 4 = 16)
//! - Input: 20  -> Output: 4 (4 * 4 = 16, 5 * 5 = 25)
//! - Input: 1   -> Output: 1 (1 * 1 = 1)
//! - Input: 0   -> Output: 0 (0 * 0 = 0)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/integer_sqrt.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/integer_sqrt.zig

const std = @import("std");

/// Calculates the integer square root of a given number.
/// The integer square root is the largest integer less than or equal to the square root of the number.
fn integerSqrt(n: u32) u32 {
    if (n == 0) return 0;

    var low: u32 = 1;
    var high = n;
    var result: u32 = 0;

    while (low <= high) {
        const mid = low + (high - low) / 2;
        const midSquared: u64 = @as(u64, mid) * @as(u64, mid);

        if (midSquared == n) {
            return mid;
        } else if (midSquared < n) {
            low = mid + 1;
            result = mid;
        } else {
            high = mid - 1;
        }
    }

    return result;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to calculate its integer square root: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(u32, trimmed, 10);

        const sqrt = integerSqrt(number);
        try stdout.print("The integer square root of {} is {}.\n", .{ number, sqrt });
    }
}

test "integer square root" {
    // Exact squares
    try std.testing.expect(integerSqrt(16) == 4); // 4 * 4 = 16
    try std.testing.expect(integerSqrt(25) == 5); // 5 * 5 = 25
    try std.testing.expect(integerSqrt(1) == 1); // 1 * 1 = 1
    try std.testing.expect(integerSqrt(0) == 0); // 0 * 0 = 0

    // Non-exact squares
    try std.testing.expect(integerSqrt(20) == 4); // 4 * 4 = 16, 5 * 5 = 25
    try std.testing.expect(integerSqrt(10) == 3); // 3 * 3 = 9, 4 * 4 = 16
    try std.testing.expect(integerSqrt(35) == 5); // 5 * 5 = 25, 6 * 6 = 36

    // Edge cases
    try std.testing.expect(integerSqrt(2) == 1); // 1 * 1 = 1, 2 * 2 = 4
    try std.testing.expect(integerSqrt(3) == 1); // 1 * 1 = 1, 2 * 2 = 4
    try std.testing.expect(integerSqrt(1000000) == 1000); // 1000 * 1000 = 1000000
}
