//! GCD and LCM Calculator Implementation
//!
//! This module provides functionality to calculate the Greatest Common Divisor (GCD)
//! and Least Common Multiple (LCM) of two numbers using the Euclidean algorithm.
//!
//! GCD (Greatest Common Divisor):
//! The largest positive integer that divides two numbers without a remainder.
//! For example:
//! - GCD(15, 20) = 5
//! - GCD(12, 18) = 6
//!
//! LCM (Least Common Multiple):
//! The smallest positive integer that is divisible by both numbers.
//! For example:
//! - LCM(15, 20) = 60
//! - LCM(12, 18) = 36
//!
//! The implementation uses the Euclidean algorithm for GCD calculation
//! and the formula LCM(a,b) = (a * b) / GCD(a,b) for LCM calculation.
//!
//! Computational Complexity:
//! - Time Complexity: O(log(min(a,b))) for both GCD and LCM
//! - Space Complexity: O(1)
//!
//! To run the program:
//! zig run src/algorithm/math/gcd_lcm_calculator.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/gcd_lcm_calculator.zig

const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

// Recursive function to return GCD of a and b
fn gcd(a: u64, b: u64) u64 {
    if (a == 0) return b;
    return gcd(@mod(b, a), a);
}

fn lcm(a: u64, b: u64) u64 {
    return @divExact(a * b, gcd(a, b));
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter number of test cases : ");

    var buf: [100]u8 = undefined;

    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const T = blk: {
            const trimmed = std.mem.trimRight(u8, line, " \t\r\n");
            break :blk try std.fmt.parseInt(u32, trimmed, 10);
            };

        var test_case: u32 = 0;
        while (test_case < T) : (test_case += 1) {
            try stdout.writeAll("Enter two numbers (space-separated): ");

            if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |num_line| {
                var it = std.mem.splitScalar(u8, std.mem.trimRight(u8, num_line, " \t\r\n"), ' ');
                
                const a = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10);
                const b = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10);

                const start = std.time.milliTimestamp();
                const result = lcm(a, b);
                
                try stdout.print("LCM of {} and {} is {}\n", .{ a, b, result });
                
                const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
                try stdout.print("LCM calculation completed in {d:.6}s\n", .{duration});
            }
        }
    }
}

test "LCM Calculations" {
    {
        try expectEqual(@as(u32, 60), lcm(15, 20));
        try expectEqual(@as(u32, 36), lcm(12, 18));
        try expectEqual(@as(u32, 24), lcm(8, 12));
    }

    {
        try expectEqual(@as(u32, 770), lcm(70, 11));
        try expectEqual(@as(u32, 30), lcm(6, 5));
    }

    {
        try expectEqual(@as(u32, 20), lcm(20, 4));    
        try expectEqual(@as(u32, 105), lcm(15, 7));
        try expectEqual(@as(u32, 7), lcm(7, 1));
    }

    {
        const a = 15;
        const b = 20;
        try expectEqual(lcm(a, b), lcm(b, a));
    }

    {
        const large_a = 1000000;
        const large_b = 999999;
        const large_lcm = lcm(large_a, large_b);
        try expect(large_lcm > large_a);
        try expect(large_lcm > large_b);
    }
}

test "GCD Calculations" {

    {
        try expectEqual(@as(u32, 5), gcd(15, 20));
        try expectEqual(@as(u32, 6), gcd(12, 18));
        try expectEqual(@as(u32, 4), gcd(8, 12));
    }

    {
        try expectEqual(@as(u32, 1), gcd(70, 11));
        try expectEqual(@as(u32, 1), gcd(6, 5));
    }

    {
        try expectEqual(@as(u32, 4), gcd(20, 4));
        try expectEqual(@as(u32, 1), gcd(15, 7));        
        try expectEqual(@as(u32, 1), gcd(7, 1));
    }

    {
        const a = 15;
        const b = 20;
        try expectEqual(gcd(a, b), gcd(b, a));
    }
}