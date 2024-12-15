//! Fibonacci Number Calculator using Binet's Formula
//!
//! This module implements the nth Fibonacci number calculation using Binet's formula,
//! a closed-form mathematical expression for directly computing Fibonacci numbers.
//!
//! The implementation uses the mathematical formula:
//! F(n) = (φ^n - ψ^n) / √5
//! Where:
//! - φ (phi) = (1 + √5) / 2 (golden ratio)
//! - ψ (psi) = (1 - √5) / 2
//!
//! Key characteristics:
//! - Uses floating-point arithmetic for calculation
//! - Supports Fibonacci numbers up to index 70 to avoid precision issues
//! - Provides O(1) time complexity (constant time)
//!
//! Limitations:
//! - Returns an error for indices > 70
//! - Floating-point representation may cause slight inaccuracies
//!
//! Examples:
//! - F(0) = 0
//! - F(10) = 55
//!
//! To run the code:
//! zig run src/algorithm/math/fibonacci.zig
//!
//! To test the code:
//! zig test src/algorithm/math/fibonacci.zig
//!
//! Reference: For Binet's formula, see https://en.wikipedia.org/wiki/Fibonacci_number#Binet's_formula, 
//! though it's not used here.

const std = @import("std");
const math = std.math;

fn fibonacciBinet(n: u64) !f64 {
    if (n > 70) return error.NumberTooLarge; // Avoid precision issues for large n
    const phi: f64 = (1.0 + std.math.sqrt(5.0)) / 2.0;
    const psi: f64 = (1.0 - std.math.sqrt(5.0)) / 2.0;
    return (std.math.pow(f64, phi, @floatFromInt(n)) - std.math.pow(f64, psi, @floatFromInt(n))) / std.math.sqrt(5.0);
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
    
    if (n < 0) {
        try stdout.print("Error: Negative numbers are not valid for Fibonacci sequence.\n", .{});
        return;
    }

    const start = std.time.milliTimestamp();
    const result = fibonacciBinet(n) catch |err| switch (err) {
        error.NumberTooLarge => {
            try stdout.print("Error: The Fibonacci number for index {d} exceeds the maximum integer size or is beyond the precision of floating-point calculation.\n", .{n});
            return;
        },
        else => return err,
    };
    const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
    
    try stdout.print("Fib({d}) = {d} ({d:.3}s)\n", .{n, result, duration});
}

test "fibonacci sequence first 11 numbers" {
    try std.testing.expectEqual(@as(u128, 0), try fibonacciBinet(0));
    try std.testing.expectEqual(@as(u128, 1), try fibonacciBinet(1));
    try std.testing.expectEqual(@as(u128, 1), try fibonacciBinet(2));
    try std.testing.expectEqual(@as(u128, 2), try fibonacciBinet(3));
    try std.testing.expectEqual(@as(u128, 3), try fibonacciBinet(4));
    try std.testing.expectEqual(@as(u128, 5), try fibonacciBinet(5));
    try std.testing.expectEqual(@as(u128, 8), try fibonacciBinet(6));
    try std.testing.expectEqual(@as(u128, 13), try fibonacciBinet(7));
    try std.testing.expectEqual(@as(u128, 21), try fibonacciBinet(8));
    try std.testing.expectEqual(@as(u128, 34), try fibonacciBinet(9));
    try std.testing.expectEqual(@as(u128, 55), try fibonacciBinet(10));
}

test "edge cases for fibonacci numbers" {
    // Note: The precision for 92 might not be exact due to floating-point representation
    try std.testing.expectApproxEqAbs(@as(f64, 7540113804746346429), try fibonacciBinet(92), 1e9); // Tolerance for float comparison
    try std.testing.expectError(error.NumberTooLarge, fibonacciBinet(93));
    try std.testing.expectError(error.NumberTooLarge, fibonacciBinet(300));
}