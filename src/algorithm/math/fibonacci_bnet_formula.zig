//! Fibonacci Number Calculator using Binet's Formula
//!
//! This module implements the Fibonacci sequence calculator using Binet's formula,
//! which provides a direct calculation for the nth Fibonacci number without recursion.
//! The formula is: F(n) = (φⁿ - ψⁿ)/√5, where φ = (1 + √5)/2 and ψ = (1 - √5)/2
//!
//! The implementation includes bounds checking and handles potential overflows.
//! Maximum supported value is 92 due to floating-point precision limits.
//!
//! Examples:
//! - F(0) = 0
//! - F(1) = F(2) = 1
//! - F(10) = 55
//!
//! To run the code:
//! zig run src/algorithm/math/fibonacci.zig
//!
//! To test the code:
//! zig test src/algorithm/math/fibonacci.zig
//!
//! Reference: https://en.wikipedia.org/wiki/Fibonacci_number#Binet's_formula

const std = @import("std");
const math = std.math;

fn fib(n: u64) !i64 {
    if (n == 0) return 0;
    if (n == 1) return 1;
    
    // Add bounds checking
    if (n > 92) return error.NumberTooLarge;
    
    const sqrt5 = math.sqrt(5.0);
    const phi = (1.0 + sqrt5) / 2.0;
    const psi = (1.0 - sqrt5) / 2.0;
    
    const seq = (math.pow(f64, phi, @floatFromInt(n)) - math.pow(f64, psi, @floatFromInt(n))) / sqrt5;
    
    // Check for potential overflow before conversion
    if (seq > @as(f64, @floatFromInt(math.maxInt(i64))) or 
        seq < @as(f64, @floatFromInt(math.minInt(i64)))) {
        return error.NumberTooLarge;
    }
    
    return @intFromFloat(@round(seq));
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter number to calculate the nth Fibonacci number (0-92): ", .{});

    var buf: [10]u8 = undefined;
    @memset(&buf, 0);
    
    const user_input = try stdin.readUntilDelimiter(&buf, '\n');
    const input_trimmed = std.mem.trim(u8, user_input, &[_]u8{' ', '\r', '\n'});
    
    const n = try std.fmt.parseInt(u64, input_trimmed, 10);
    
    const start = std.time.milliTimestamp();
    const result = fib(n) catch |err| switch (err) {
        error.NumberTooLarge => {
            try stdout.print("Error: Number too large. Maximum supported value is 92.\n", .{});
            return;
        },
        else => return err,
    };
    const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
    
    try stdout.print("Fib({d}) = {d} ({d:.3}s)\n", .{n, result, duration});
}

test "fibonacci sequence first 11 numbers" {
    try std.testing.expectEqual(@as(i64, 0), try fib(0));
    try std.testing.expectEqual(@as(i64, 1), try fib(1));
    try std.testing.expectEqual(@as(i64, 1), try fib(2));
    try std.testing.expectEqual(@as(i64, 2), try fib(3));
    try std.testing.expectEqual(@as(i64, 3), try fib(4));
    try std.testing.expectEqual(@as(i64, 5), try fib(5));
    try std.testing.expectEqual(@as(i64, 8), try fib(6));
    try std.testing.expectEqual(@as(i64, 13), try fib(7));
    try std.testing.expectEqual(@as(i64, 21), try fib(8));
    try std.testing.expectEqual(@as(i64, 34), try fib(9));
    try std.testing.expectEqual(@as(i64, 55), try fib(10));
}

test "large fibonacci numbers" {
    try std.testing.expectError(error.NumberTooLarge, fib(93));
    try std.testing.expectError(error.NumberTooLarge, fib(300));
}