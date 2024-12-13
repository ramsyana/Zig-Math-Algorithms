//! Fast Fibonacci Number Calculator Implementation
//!
//! This module implements a fast, recursive Fibonacci calculator using the matrix
//! exponentiation method. Due to i64 size limitations, it can calculate up to the
//! 92nd Fibonacci number accurately.
//!
//! The implementation uses the following formula for efficient calculation:
//! If k = n/2, then:
//! F(n) = F(k) * [2*F(k+1) - F(k)] for even n
//! F(n) = F(k+1)^2 + F(k)^2 for odd n
//!
//! Time Complexity: O(log n)
//! Space Complexity: O(log n) due to recursion stack
//!
//! Examples:
//! - Input: 5  -> Output: 5
//! - Input: 50 -> Output: 12586269025
//! - Input: 91 -> Output: 4660046610375530309
//!
//! To run the code:
//! zig run src/algorithm/math/fibonacci_fast.zig
//!
//! To test the code:
//! zig test src/algorithm/math/fibonacci_fast.zig

const std = @import("std");

fn fib(n: i32) !i64 {
    if (n < 0) return error.NegativeInput;
    if (n > 92) return error.Overflow;

    var c: i64 = undefined;
    var d: i64 = undefined;
    fibHelper(@intCast(n), &c, &d) catch |err| {
        return err;
    };
    return c;
}

fn fibHelper(n: u32, c: *i64, d: *i64) !void {
    if (n == 0) {
        c.* = 0;
        d.* = 1;
        return;
    }

    var t1: i64 = undefined;
    var t2: i64 = undefined;
    try fibHelper(n >> 1, &t1, &t2);

    const t2_doubled = std.math.mul(i64, t2, 2) catch return error.Overflow;
    const t2d_minus_t1 = std.math.sub(i64, t2_doubled, t1) catch return error.Overflow;
    const a = std.math.mul(i64, t1, t2d_minus_t1) catch return error.Overflow;
    
    const t1_squared = std.math.mul(i64, t1, t1) catch return error.Overflow;
    const t2_squared = std.math.mul(i64, t2, t2) catch return error.Overflow;
    const b = std.math.add(i64, t1_squared, t2_squared) catch return error.Overflow;

    if (n % 2 == 0) {
        c.* = a;
        d.* = b;
    } else {
        c.* = b;
        d.* = std.math.add(i64, a, b) catch return error.Overflow;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var stdin_buffer = std.io.bufferedReader(std.io.getStdIn().reader());
    var stdin = stdin_buffer.reader();
    
    try stdout.writeAll("Enter n (0-92): ");
    
    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const n = try std.fmt.parseInt(i32, trimmed, 10);
        
        const start = std.time.milliTimestamp();
        const result = fib(n) catch |err| switch (err) {
            error.Overflow => {
                try stdout.print("Error: Input too large (max n=92)\n", .{});
                return;
            },
            error.NegativeInput => {
                try stdout.print("Error: Input must be non-negative\n", .{});
                return;
            },
            else => return err,
        };
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
        
        try stdout.print("Fib({d}) = {d} ({d:.3}s)\n", .{n, result, duration});
    }
}

test "fibonacci sequence" {
    try std.testing.expectEqual(try fib(0), 0);
    try std.testing.expectEqual(try fib(1), 1);
    try std.testing.expectEqual(try fib(2), 1);
    try std.testing.expectEqual(try fib(3), 2);
    try std.testing.expectEqual(try fib(4), 3);
    try std.testing.expectEqual(try fib(5), 5);
    try std.testing.expectEqual(try fib(9), 34);
}