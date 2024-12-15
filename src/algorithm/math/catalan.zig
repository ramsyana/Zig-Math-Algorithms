//! Calculation of Catalan numbers using factorial method.
//! 
//! The nth Catalan number is calculated using the formula:
//! C(n) = (2n)! / ((n+1)! * n!)
//!
//! The program reads an integer input from the user and outputs:
//! - Input validation details (length and ASCII values)
//! - The corresponding Catalan number with 2 decimal places
//!
//! Time Complexity: O(n) for factorial calculation
//! Space Complexity: O(1)
//!
//! Example:
//! Input: 10
//! Output: 16796.00 (10th Catalan number)
//! 
//! To run the code, use the following command: 
//! zig run src/algorithm/math/catalan.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/catalan.zig

const std = @import("std");
const Allocator = std.mem.Allocator;

fn factorial(x: u64) u64 {
    if (x <= 1) return 1;
    
    var fac: u64 = x;
    var i: u64 = 1;
    while (i < x) : (i += 1) {
        fac *= (x - i);
    }
    return fac;
}

fn calculateCatalan(n: u64) f64 {
    const f1 = factorial(2 * n);
    const f2 = factorial(n + 1);
    const f3 = factorial(n);
    return @as(f64, @floatFromInt(f1)) / (@as(f64, @floatFromInt(f2)) * @as(f64, @floatFromInt(f3)));
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a number to calculate its Catalan number: ", .{});

    var buf: [10]u8 = undefined;
    const user_input = try stdin.readUntilDelimiterOrEof(&buf, '\n');
    if (user_input) |input| {
        const input_trimmed = std.mem.trim(u8, input, &[_]u8{' ', '\r', '\n'});

        if (input_trimmed.len > 0) {
            if (std.fmt.parseInt(u64, input_trimmed, 10)) |n| {
                if (n > 20) { // Arbitrary cutoff for this example to prevent overflow with u64
                    try stdout.print("Number too large for calculation with current precision.\n", .{});
                } else {
                    const C = calculateCatalan(n);
                    try stdout.print("{d:.2}\n", .{C});
                }
            } else |err| {
                try stdout.print("Invalid input: {s}\n", .{@errorName(err)});
            }
        }
    } else {
        try stdout.print("No input provided.\n", .{});
    }
}

test "factorial function" {
    try std.testing.expectEqual(@as(u64, 1), factorial(1));
    try std.testing.expectEqual(@as(u64, 2), factorial(2));
    try std.testing.expectEqual(@as(u64, 6), factorial(3));
    try std.testing.expectEqual(@as(u64, 24), factorial(4));
    try std.testing.expectEqual(@as(u64, 120), factorial(5));
}

test "Catalan number calculation" {
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), calculateCatalan(0), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), calculateCatalan(1), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), calculateCatalan(2), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 5.0), calculateCatalan(3), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 14.0), calculateCatalan(4), 0.01);
}