//! Greatest Common Divisor (GCD) Calculator Implementation
//!
//! This module implements Euclid's algorithm for calculating the 
//! Greatest Common Divisor (GCD) of two integers using a recursive approach.
//!
//! Euclid's algorithm is based on the principle that the greatest common 
//! divisor of two numbers does not change if the smaller number is subtracted 
//! from the larger number. This implementation uses the modulo operator 
//! for an efficient recursive calculation.
//!
//! The algorithm works as follows:
//! - If y is 0, return x (base case)
//! - Otherwise, recursively call GCD with (y, x % y)
//!
//! Examples:
//! - GCD(48, 18) = 6
//! - GCD(54, 24) = 6
//! - GCD(17, 5)  = 1
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/elucid_algorithm.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/elucid_algorithm.zig

const std = @import("std");

// Euclid's algorithm for Greatest Common Divisor
fn gcd(x: i32, y: i32) i32 {
    if (y == 0) return x;
    return gcd(y, @mod(x, y));
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
            break :blk try std.fmt.parseInt(i32, first, 10);
        };
        
        const b = blk: {
            const second = it.next() orelse return error.MissingInput;
            break :blk try std.fmt.parseInt(i32, second, 10);
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
}