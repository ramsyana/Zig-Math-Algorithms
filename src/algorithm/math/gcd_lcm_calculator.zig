//! GCD and LCM Calculator Implementation
//!
//! This module provides functions to calculate the Greatest Common Divisor (GCD)
//! and Least Common Multiple (LCM) of two unsigned 64-bit integers using the Euclidean algorithm.
//!
//! **GCD (Greatest Common Divisor):**
//! - Definition: The largest positive integer that divides two numbers without leaving a remainder.
//! - Examples:
//!   - GCD(15, 20) = 5
//!   - GCD(12, 18) = 6
//!
//! **LCM (Least Common Multiple):**
//! - Definition: The smallest positive integer that is divisible by both numbers.
//! - Examples:
//!   - LCM(15, 20) = 60
//!   - LCM(12, 18) = 36
//!
//! **Implementation Details:**
//! - **GCD**: An iterative version of the Euclidean algorithm is used to prevent stack overflow for large inputs.
//! - **LCM**: Utilizes the formula `LCM(a, b) = (a * b) / GCD(a, b)` with an overflow check to avoid incorrect results for large numbers.
//!
//! **Computational Complexity:**
//! - **Time Complexity**: O(log(min(a,b))) for both GCD and LCM due to the Euclidean algorithm.
//! - **Space Complexity**: O(1) as it uses constant additional space regardless of input size.
//!
//! **Usage:**
//! - To run the program:
//!   ```
//!   zig run src/algorithm/math/gcd_lcm_calculator.zig
//!   ```
//! - To test the implementation:
//!   ```
//!   zig test src/algorithm/math/gcd_lcm_calculator.zig
//!   ```
//!
//! **Input/Output:**
//! - Expects user input for the number of test cases and pairs of numbers for calculation.
//! - Provides timing information for each LCM calculation to demonstrate performance.
//! - Handles basic input validation to manage malformed inputs.

const std = @import("std");

// Iterative GCD function to prevent stack overflow for large numbers
fn gcd(a: u64, b: u64) u64 {
    var x = a;
    var y = b;
    while (y != 0) {
        const temp = y;
        y = @mod(x, y);
        x = temp;
    }
    return x;
}

// LCM function with overflow check
fn lcm(a: u64, b: u64) u64 {
    const product = a * b;
    if (product / a != b) { // Check for overflow
        return std.math.maxInt(u64); // Return max value if overflow occurs
    }
    return @divExact(product, gcd(a, b));
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter number of test cases: ");
    var buf: [100]u8 = undefined;
    
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const T = try std.fmt.parseInt(u32, std.mem.trim(u8, line, " \t\r\n"), 10);

        var test_case: u32 = 0;
        while (test_case < T) : (test_case += 1) {
            try stdout.writeAll("Enter two numbers (space-separated): ");
            
            if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |num_line| {
                var it = std.mem.tokenize(u8, std.mem.trim(u8, num_line, " \t\r\n"), " ");
                if (it.next()) |num1_str| {
                    if (it.next()) |num2_str| {
                        const a = try std.fmt.parseInt(u64, num1_str, 10);
                        const b = try std.fmt.parseInt(u64, num2_str, 10);
                        
                        var timer = try std.time.Timer.start();
                        const result = lcm(a, b);
                        const duration = @as(f64, @floatFromInt(timer.read())) / 1_000_000_000.0; // Convert to seconds
                        
                        try stdout.print("LCM of {} and {} is {}\n", .{ a, b, result });
                        try stdout.print("LCM calculation completed in {d:.6}s\n", .{duration});
                    } else {
                        try stdout.writeAll("Error: Second number missing.\n");
                        continue;
                    }
                } else {
                    try stdout.writeAll("Error: First number missing.\n");
                    continue;
                }
            }
        }
    }
}

test "LCM Calculations" {
    {
        try std.testing.expectEqual(@as(u64, 60), lcm(15, 20));
        try std.testing.expectEqual(@as(u64, 36), lcm(12, 18));
        try std.testing.expectEqual(@as(u64, 24), lcm(8, 12));
    }

    {
        try std.testing.expectEqual(@as(u64, 770), lcm(70, 11));
        try std.testing.expectEqual(@as(u64, 30), lcm(6, 5));
    }

    {
        try std.testing.expectEqual(@as(u64, 20), lcm(20, 4));
        try std.testing.expectEqual(@as(u64, 105), lcm(15, 7));
        try std.testing.expectEqual(@as(u64, 7), lcm(7, 1));
    }

    {
        const a = 15;
        const b = 20;
        try std.testing.expectEqual(lcm(a, b), lcm(b, a));
    }

    {
        const large_a = 1000000;
        const large_b = 999999;
        const large_lcm = lcm(large_a, large_b);
        try std.testing.expect(large_lcm > large_a);
        try std.testing.expect(large_lcm > large_b);
    }
}

test "GCD Calculations" {
    {
        try std.testing.expectEqual(@as(u64, 5), gcd(15, 20));
        try std.testing.expectEqual(@as(u64, 6), gcd(12, 18));
        try std.testing.expectEqual(@as(u64, 4), gcd(8, 12));
    }

    {
        try std.testing.expectEqual(@as(u64, 1), gcd(70, 11));
        try std.testing.expectEqual(@as(u64, 1), gcd(6, 5));
    }

    {
        try std.testing.expectEqual(@as(u64, 4), gcd(20, 4));
        try std.testing.expectEqual(@as(u64, 1), gcd(15, 7));
        try std.testing.expectEqual(@as(u64, 1), gcd(7, 1));
    }

    {
        const a = 15;
        const b = 20;
        try std.testing.expectEqual(gcd(a, b), gcd(b, a));
    }
}