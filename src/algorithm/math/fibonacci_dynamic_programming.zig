//! Fibonacci Number Calculator using Iterative Approach
//!
//! This module implements a Fibonacci calculator using an iterative approach
//! to compute the nth number in the Fibonacci sequence. It handles integer
//! overflow and boundary conditions, calculating up to the 48th Fibonacci number.
//!
//! The Fibonacci sequence is defined as follows:
//! - F(0) = 0
//! - F(1) = 1
//! - F(n) = F(n-1) + F(n-2) for n > 1
//!
//! Implementation details:
//! - Uses an iterative method with two variables for space efficiency
//! - Time complexity: O(n)
//! - Space complexity: O(1)
//!
//! Examples:
//! - Input: 0  -> Output: 0
//! - Input: 5  -> Output: 5
//! - Input: 9  -> Output: 34
//!
//! To run the code:
//! zig run src/algorithm/math/fibonacci_iterative.zig
//!
//! To test the code:
//! zig test src/algorithm/math/fibonacci_iterative.zig

const std = @import("std");

const CustomError = error{
    InvalidInput,
    FibonacciNumberTooLarge,
    IntegerOverflow,
};

fn fib(n: i32) CustomError!i64 {
    if (n < 0) return CustomError.InvalidInput;
    if (n > 48) return CustomError.FibonacciNumberTooLarge;
    
    if (n == 0) return 0;
    if (n == 1) return 1;

    var prev1: i64 = 0;
    var prev2: i64 = 1;

    var i: i32 = 2;
    while (i <= n) : (i += 1) {
        const add_result = @addWithOverflow(prev1, prev2);
        if (add_result[1] != 0) {
            return CustomError.IntegerOverflow;
        }
        prev1 = prev2;
        prev2 = add_result[0];
    }
    return prev2;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var stdin_buffer = std.io.bufferedReader(std.io.getStdIn().reader());
    var stdin = stdin_buffer.reader();
    
    try stdout.writeAll("Enter n (0-48): ");
    
    var buf = std.ArrayList(u8).init(std.heap.page_allocator);
    defer buf.deinit();
    try stdin.readUntilDelimiterArrayList(&buf, '\n', std.math.maxInt(usize));

    const trimmed = std.mem.trim(u8, buf.items, &std.ascii.whitespace);
    const n = try std.fmt.parseInt(i32, trimmed, 10);

    const start = std.time.milliTimestamp();
    const result = fib(n) catch |err| switch (err) {
        CustomError.IntegerOverflow => {
            try stdout.print("Fib({d}) = Overflow\n", .{n});
            return;
        },
        else => |e| return e,
    };
    const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
    
    try stdout.print("Fib({d}) = {d} ({d:.3}s)\n", .{n, result, duration});
}

test "fibonacci sequence" {
    try std.testing.expectEqual(try fib(0), 0);
    try std.testing.expectEqual(try fib(1), 1);
    try std.testing.expectEqual(try fib(2), 1);
    try std.testing.expectEqual(try fib(3), 2);
    try std.testing.expectEqual(try fib(4), 3);
    try std.testing.expectEqual(try fib(5), 5);
    try std.testing.expectEqual(try fib(9), 34);
    try std.testing.expectError(CustomError.IntegerOverflow, fib(48));
    try std.testing.expectError(CustomError.InvalidInput, fib(-1));
    try std.testing.expectError(CustomError.FibonacciNumberTooLarge, fib(49));
}