//! Power of Two Checker Implementation
//!
//! This module implements a function to check if a given number is a power of two.
//! A number is a power of two if it is greater than 0 and has exactly one bit set in its binary representation.
//! This can be checked using the property: (n & (n - 1)) == 0.
//!
//! Examples:
//! - Input: 1    -> Output: true  (2^0 = 1)
//! - Input: 2    -> Output: true  (2^1 = 2)
//! - Input: 16   -> Output: true  (2^4 = 16)
//! - Input: 15   -> Output: false (not a power of two)
//! - Input: 0    -> Output: false (0 is not a power of two)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/power_of_two.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/power_of_two.zig

const std = @import("std");

/// Checks if a number is a power of two.
/// A number is a power of two if it is greater than 0 and has exactly one bit set in its binary representation.
fn isPowerOfTwo(n: u32) bool {
    return n > 0 and (n & (n - 1)) == 0;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to check if it is a power of two: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(u32, trimmed, 10);

        if (isPowerOfTwo(number)) {
            try stdout.print("{} is a power of two.\n", .{number});
        } else {
            try stdout.print("{} is not a power of two.\n", .{number});
        }
    }
}

test "power of two checker" {
    // Powers of two
    try std.testing.expect(isPowerOfTwo(1)); // 2^0 = 1
    try std.testing.expect(isPowerOfTwo(2)); // 2^1 = 2
    try std.testing.expect(isPowerOfTwo(16)); // 2^4 = 16
    try std.testing.expect(isPowerOfTwo(1024)); // 2^10 = 1024

    // Not powers of two
    try std.testing.expect(!isPowerOfTwo(0)); // 0 is not a power of two
    try std.testing.expect(!isPowerOfTwo(15)); // 15 is not a power of two
    try std.testing.expect(!isPowerOfTwo(100)); // 100 is not a power of two

    // Edge cases
    try std.testing.expect(!isPowerOfTwo(3)); // 3 is not a power of two
    try std.testing.expect(!isPowerOfTwo(255)); // 255 is not a power of two
}
