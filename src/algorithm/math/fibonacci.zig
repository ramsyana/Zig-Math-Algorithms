//! Fibonacci Number Calculator Implementation
//!
//! This module implements an **iterative** Fibonacci calculator that computes
//! the nth number in the Fibonacci sequence. Due to integer size limitations,
//! it can calculate up to the 93rd Fibonacci number accurately using `u64`.
//!
//! The Fibonacci sequence is defined as follows:
//! - F(1) = 0
//! - F(2) = 1
//! - F(n) = F(n-1) + F(n-2) for n > 2
//!
//! Examples:
//! - Input: 5  -> Output: 3
//! - Input: 9  -> Output: 21
//! - Input: 47 -> Output: 1836311903 (Note: 25th number would be 46368 within u32 limit)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/fibonacci.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/fibonacci.zig

const std = @import("std");

fn fib(n: i32) !u64 {
    if (n <= 0) return error.InvalidInput;
    if (n > 93) return error.NumberTooLarge; // Adjust upper bound for u64
    
    if (n == 1) return 0;
    if (n == 2) return 1;
    
    var a: u64 = 0;
    var b: u64 = 1;
    var i: i32 = 3;
    
    while (i <= n) : (i += 1) {
        const temp = b;
        b = a + b;
        a = temp;
    }
    
    return b;
}


pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var stdin_buffer = std.io.bufferedReader(std.io.getStdIn().reader());
    var stdin = stdin_buffer.reader();
    
    try stdout.writeAll("Enter n (1-48): ");
    
    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const n = try std.fmt.parseInt(i32, trimmed, 10);
        
        const start = std.time.milliTimestamp();
        const result = try fib(n);
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
        
        try stdout.print("Fib({d}) = {d} ({d:.3}s)\n", .{n, result, duration});
    }
}

test "fibonacci sequence" {
    try std.testing.expectEqual(try fib(1), 0);
    try std.testing.expectEqual(try fib(2), 1);
    try std.testing.expectEqual(try fib(3), 1);
    try std.testing.expectEqual(try fib(4), 2);
    try std.testing.expectEqual(try fib(5), 3);
    try std.testing.expectEqual(try fib(9), 21);
    try std.testing.expectEqual(try fib(47), 1836311903);
    try std.testing.expectError(error.InvalidInput, fib(0));
    try std.testing.expectError(error.InvalidInput, fib(-1));
    try std.testing.expectError(error.NumberTooLarge, fib(94)); // Test for new upper limit
}