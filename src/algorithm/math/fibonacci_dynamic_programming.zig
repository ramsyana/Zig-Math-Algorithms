//! Fibonacci Number Calculator using Dynamic Programming
//!
//! This module implements a Fibonacci calculator using dynamic programming approach
//! to compute the nth number in the Fibonacci sequence efficiently. Due to integer
//! size limitations, it can calculate up to the 48th Fibonacci number accurately.
//!
//! The Fibonacci sequence is defined as follows:
//! - F(0) = 0
//! - F(1) = 1
//! - F(n) = F(n-1) + F(n-2) for n > 1
//!
//! Implementation details:
//! - Uses bottom-up dynamic programming approach
//! - Time complexity: O(n)
//! - Space complexity: O(n)
//!
//! Examples:
//! - Input: 0  -> Output: 0
//! - Input: 5  -> Output: 5
//! - Input: 9  -> Output: 34
//!
//! To run the code:
//! zig run src/algorithm/math/fibonacci_dynamic_programming.zig
//!
//! To test the code:
//! zig test src/algorithm/math/fibonacci_dynamic_programming.zig

const std = @import("std");

fn fib(n: i32) !i32 {
    if (n < 0) return error.InvalidInput;

    var allocator = std.heap.page_allocator;
    const size = @as(usize, @intCast(@max(0, n + 1)));
    const f = try allocator.alloc(i32, size + 1);
    defer allocator.free(f);

    f[0] = 0;
    if (size > 0) f[1] = 1;

    var i: usize = 2;
    while (i <= @as(usize, @intCast(n))) : (i += 1) {
        f[i] = f[i - 1] + f[i - 2];
    }

    return f[@as(usize, @intCast(n))];
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var stdin_buffer = std.io.bufferedReader(std.io.getStdIn().reader());
    var stdin = stdin_buffer.reader();
    
    try stdout.writeAll("Enter n (0-48): ");
    
    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const n = try std.fmt.parseInt(i32, trimmed, 10);
        if (n > 48) return error.NumberTooLarge;
        
        const start = std.time.milliTimestamp();
        const result = try fib(n);
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
    try std.testing.expectError(error.InvalidInput, fib(-1));
}