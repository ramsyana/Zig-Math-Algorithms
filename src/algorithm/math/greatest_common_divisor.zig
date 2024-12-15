//! Greatest Common Divisor (GCD) Calculator Implementation
//!
//! This module implements Euclid's algorithm for calculating the 
//! Greatest Common Divisor (GCD) of two unsigned integers using a tail-recursive approach.
//!
//! Euclid's algorithm is based on the principle that the greatest common 
//! divisor of two numbers does not change if the smaller number is subtracted 
//! from the larger number. This implementation uses the modulo operator 
//! for an efficient tail-recursive calculation.
//!
//! The algorithm works as follows:
//! - If y is 0, return the accumulator (base case)
//! - Otherwise, recursively call GCD with (y, x % y, y), where the accumulator keeps track of the GCD
//!
//! Examples:
//! - GCD(48, 18) = 6
//! - GCD(54, 24) = 6
//! - GCD(17, 5)  = 1
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/greatest_common_divisor.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/greatest_common_divisor.zig

const std = @import("std");

// Euclid's algorithm for Greatest Common Divisor using tail recursion
fn gcd(x: u32, y: u32) u32 {
    return gcd_tail(x, y, x);
}

fn gcd_tail(x: u32, y: u32, acc: u32) u32 {
    if (y == 0) return acc;
    return gcd_tail(y, x % y, y);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Input two numbers:\n");

    var buf: [100]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.tokenize(u8, line, " \t\r\n");
        
        const a = blk: {
            const first = it.next() orelse return error.MissingInput;
            break :blk try std.fmt.parseInt(u32, first, 10);
        };
        
        const b = blk: {
            const second = it.next() orelse return error.MissingInput;
            break :blk try std.fmt.parseInt(u32, second, 10);
        };

        const start = std.time.milliTimestamp();
        const result = gcd(a, b);
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;

        try stdout.print("Greatest common divisor: {d} (Computed in {d:.3}s)\n", .{result, duration});
    }
}

test "gcd calculations" {
    try std.testing.expectEqual(gcd(48, 18), 6);
    try std.testing.expectEqual(gcd(54, 24), 6);
    try std.testing.expectEqual(gcd(17, 5), 1);
    try std.testing.expectEqual(gcd(0, 5), 5);
    try std.testing.expectEqual(gcd(5, 0), 5);
    try std.testing.expectEqual(gcd(1000000000, 100000000), 100000000);
}