//! Linear Interpolation (LERP) Implementation
//!
//! This module provides functionality to perform linear interpolation between two values.
//! Linear interpolation is a method of curve fitting using linear polynomials to construct
//! new data points within the range of a discrete set of known data points.
//!
//! Two implementations are provided:
//! 1. lerp(k0: f32, k1: f32, t: f32) - Standard linear interpolation
//! 2. lerp_precise(k0: i32, k1: i32, t: f32) - Precise interpolation for integer endpoints
//!
//! Formula:
//! lerp(k0, k1, t) = k0 + t * (k1 - k0)
//! Where:
//! - k0 is the start value
//! - k1 is the end value
//! - t is the interpolation parameter in range [0.0, 1.0]
//!
//! Examples:
//! - lerp(0.0, 10.0, 0.5) = 5.0
//! - lerp(-5.0, 5.0, 0.5) = 0.0
//!
//! Computational Complexity:
//! - Time Complexity: O(1) for single interpolation
//! - Space Complexity: O(1)
//!
//! To run the program:
//! zig run src/algorithm/math/linear_interpolation.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/linear_interpolation.zig

const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

fn lerp(k0: f32, k1: f32, t: f32) f32 {
    return k0 + t * (k1 - k0);
}

fn lerp_precise(k0: i32, k1: i32, t: f32) f32 {
    return (1 - t) * @as(f32, @floatFromInt(k0)) + t * @as(f32, @floatFromInt(k1));
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter number of test cases: ");

    var buf: [100]u8 = undefined;

    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const T = blk: {
            const trimmed = std.mem.trimRight(u8, line, " \t\r\n");
            break :blk try std.fmt.parseInt(u32, trimmed, 10);
        };

        var test_case: u32 = 0;
        while (test_case < T) : (test_case += 1) {
            try stdout.writeAll("Enter finish value and steps (space-separated): ");

            if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |num_line| {
                var it = std.mem.splitScalar(u8, std.mem.trimRight(u8, num_line, " \t\r\n"), ' ');
                
                const finish = try std.fmt.parseFloat(f32, it.next() orelse return error.InvalidInput);
                const steps = try std.fmt.parseFloat(f32, it.next() orelse return error.InvalidInput);
                const start: f32 = 0.0;

                const timestamp_start = std.time.milliTimestamp();
                
                var i: usize = 0;
                const steps_int = @as(usize, @intFromFloat(steps));
                while (i <= steps_int) : (i += 1) {
                    const t = if (steps_int == 0) 0.0 else @as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(steps_int));
                    try stdout.print("{d}\n", .{lerp(start, finish, t)});
                }
                
                const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - timestamp_start)) / 1000.0;
                try stdout.print("Lerp calculation completed in {d:.6}s\n", .{duration});
            }
        }
    }
}

test "Basic Lerp Calculations" {
    {
        try expectEqual(@as(f32, 0.0), lerp(0.0, 10.0, 0.0));
        try expectEqual(@as(f32, 5.0), lerp(0.0, 10.0, 0.5));
        try expectEqual(@as(f32, 10.0), lerp(0.0, 10.0, 1.0));
    }

    {
        try expectEqual(@as(f32, -5.0), lerp(-5.0, 5.0, 0.0));
        try expectEqual(@as(f32, 0.0), lerp(-5.0, 5.0, 0.5));
        try expectEqual(@as(f32, 5.0), lerp(-5.0, 5.0, 1.0));
    }
}

test "Precise Lerp Calculations" {
    {
        try expectEqual(@as(f32, 0.0), lerp_precise(0, 10, 0.0));
        try expectEqual(@as(f32, 5.0), lerp_precise(0, 10, 0.5));
        try expectEqual(@as(f32, 10.0), lerp_precise(0, 10, 1.0));
    }

    {
        try expectEqual(@as(f32, -5.0), lerp_precise(-5, 5, 0.0));
        try expectEqual(@as(f32, 0.0), lerp_precise(-5, 5, 0.5));
        try expectEqual(@as(f32, 5.0), lerp_precise(-5, 5, 1.0));
    }
}

test "Edge Cases" {
    {
        try expectEqual(@as(f32, 0.0), lerp(0.0, 0.0, 0.5));
        try expectEqual(@as(f32, 0.0), lerp_precise(0, 0, 0.5));
    }

    {
        const large_value: f32 = 1000000.0;
        try expect(lerp(0.0, large_value, 0.5) == large_value * 0.5);
    }
}