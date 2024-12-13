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

fn factorial(x: i64) i64 {
    if (x <= 1) return 1;
    
    var fac: i64 = x;
    var i: i64 = 1;
    while (i < x) : (i += 1) {
        fac = fac * (x - i);
    }
    return fac;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a number to calculate its Catalan number: ", .{});

    var buf: [10]u8 = undefined;
    @memset(&buf, 0);
    
    const user_input = try stdin.readUntilDelimiter(&buf, '\n');
    const input_trimmed = std.mem.trim(u8, user_input, &[_]u8{' ', '\r', '\n'});
    
    try stdout.print("Actual input length: {d}\n", .{input_trimmed.len});
    try stdout.print("Input characters: ", .{});
    for (input_trimmed) |c| {
        try stdout.print("{d} ", .{c});
    }
    try stdout.print("\n", .{});
    
    const n = try std.fmt.parseInt(i64, input_trimmed, 10);
    const f1 = factorial(2 * n);
    const f2 = factorial(n + 1);
    const f3 = factorial(n);
    
    const C = @as(f64, @floatFromInt(f1)) / (@as(f64, @floatFromInt(f2)) * @as(f64, @floatFromInt(f3)));
    
    try stdout.print("{d:.2}\n", .{C});
}

test "factorial function" {
    try std.testing.expectEqual(@as(i64, 1), factorial(1));
    try std.testing.expectEqual(@as(i64, 2), factorial(2));
    try std.testing.expectEqual(@as(i64, 6), factorial(3));
    try std.testing.expectEqual(@as(i64, 24), factorial(4));
    try std.testing.expectEqual(@as(i64, 120), factorial(5));
}

test "Catalan number calculation" {
    // Helper function to calculate Catalan number without IO
    const calculateCatalan = struct {
        fn calc(n: i64) f64 {
            const f1 = factorial(2 * n);
            const f2 = factorial(n + 1);
            const f3 = factorial(n);
            return @as(f64, @floatFromInt(f1)) / (@as(f64, @floatFromInt(f2)) * @as(f64, @floatFromInt(f3)));
        }
    }.calc;
    
    // First few Catalan numbers are: 1, 1, 2, 5, 14, 42, 132, ...
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), calculateCatalan(0), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 1.0), calculateCatalan(1), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 2.0), calculateCatalan(2), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 5.0), calculateCatalan(3), 0.01);
    try std.testing.expectApproxEqAbs(@as(f64, 14.0), calculateCatalan(4), 0.01);
}