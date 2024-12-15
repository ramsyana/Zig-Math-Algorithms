//! Fibonacci Calculator Using Matrix Exponentiation
//!
//! This module provides an efficient implementation of Fibonacci number calculation using
//! the matrix exponentiation method, which reduces computational complexity from O(2^n)
//! to O(log n).
//!
//! - **Input Range**: Supports integers from 0 to 92 due to `i64` limitations.
//! - **Algorithm**: Utilizes fast doubling to compute Fibonacci numbers:
//!   - For even `n` where `k = n/2`: `F(n) = F(k) * (2*F(k+1) - F(k))`
//!   - For odd `n`: `F(n) = F(k+1)^2 + F(k)^2`
//! - **Time Complexity**: O(log n)
//! - **Space Complexity**: O(log n) due to the recursion depth in the stack
//!
//! **Examples**:
//! - Input: 5  -> Output: 5
//! - Input: 50 -> Output: 12586269025
//! - Input: 91 -> Output: 4660046610375530309
//!
//! **Usage**:
//! - Run the program: `zig run src/algorithm/math/fibonacci_fast.zig`
//! - Run tests: `zig test src/algorithm/math/fibonacci_fast.zig`
//!
//! Note: The maximum calculable Fibonacci number is limited by the `i64` type, hence the
//! upper bound of 92 for input `n`.

const std = @import("std");

fn fib(n: i32) !i64 {
    if (n < 0) return error.NegativeInput;
    if (n > 92) return error.FibNumberTooLarge;

    var fib_a: i64 = undefined;
    var fib_b: i64 = undefined;
    try fibMatrixExponentiation(@intCast(n), &fib_a, &fib_b);
    return fib_a;
}

fn fibMatrixExponentiation(n: u32, fib_a: *i64, fib_b: *i64) !void {
    if (n == 0) {
        fib_a.* = 0;
        fib_b.* = 1;
        return;
    }

    var temp_a: i64 = undefined;
    var temp_b: i64 = undefined;
    try fibMatrixExponentiation(n >> 1, &temp_a, &temp_b);

    const doubled_b = try std.math.mul(i64, temp_b, 2);
    const b_minus_a = try std.math.sub(i64, doubled_b, temp_a);
    const new_a = try std.math.mul(i64, temp_a, b_minus_a);
    
    const a_squared = try std.math.mul(i64, temp_a, temp_a);
    const b_squared = try std.math.mul(i64, temp_b, temp_b);
    const new_b = try std.math.add(i64, a_squared, b_squared);

    if (n % 2 == 0) {
        fib_a.* = new_a;
        fib_b.* = new_b;
    } else {
        fib_a.* = new_b;
        fib_b.* = try std.math.add(i64, new_a, new_b);
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
            error.FibNumberTooLarge => {
                try stdout.print("Error: Fibonacci number too large for i64 (max n=92)\n", .{});
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