//! Linear Interpolation (LERP) Module
//!
//! This module implements linear interpolation between two values, offering:
//! - **Standard LERP**: `lerp(k0: f32, k1: f32, t: f32)` for floating-point inputs.
//! - **Precise LERP**: `lerp_precise(k0: i32, k1: i32, t: f32)` for integer inputs with float precision.
//!
//! **Linear Interpolation** is used to estimate values between two known points using the formula:
//!   - `lerp(k0, k1, t) = k0 + t * (k1 - k0)`
//! Where:
//!   - `k0` is the starting value
//!   - `k1` is the ending value
//!   - `t` is the interpolation factor in the range [0.0, 1.0]
//!
//! **Examples**:
//!   - `lerp(0.0, 10.0, 0.5)` yields `5.0`
//!   - `lerp(-5.0, 5.0, 0.5)` results in `0.0`
//!
//! **Performance**:
//!   - **Time Complexity**: O(1) for each interpolation operation
//!   - **Space Complexity**: O(1) as no additional memory scales with input
//!
//! **Usage**:
//! - To run the program: `zig run src/algorithm/math/linear_interpolation.zig`
//! - To test the implementation: `zig test src/algorithm/math/linear_interpolation.zig`

const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const math = std.math;

const BUFFER_SIZE: usize = 100;
const START_VALUE: f32 = 0.0;

// Linear interpolation between two floating-point values with clamping.
fn lerp(k0: f32, k1: f32, t: f32) f32 {
    // Clamp t to [0,1] range
    const t_clamped = math.clamp(t, 0.0, 1.0);
    return k0 + t_clamped * (k1 - k0);
}

/// Performs linear interpolation between two integer values with float precision.
fn lerp_precise(k0: i32, k1: i32, t: f32) f32 {
    // Clamp t to [0,1] range
    const t_clamped = math.clamp(t, 0.0, 1.0);
    return @as(f32, @floatFromInt(k0)) * (1 - t_clamped) + @as(f32, @floatFromInt(k1)) * t_clamped;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var buf: [BUFFER_SIZE]u8 = undefined;

    try stdout.writeAll("Enter finish value and steps (space-separated): ");

    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |num_line| {
        var it = std.mem.splitScalar(u8, std.mem.trimRight(u8, num_line, " \t\r\n"), ' ');
        
        const finish = try std.fmt.parseFloat(f32, it.next() orelse return error.InvalidInput);
        const steps = try std.fmt.parseFloat(f32, it.next() orelse return error.InvalidInput);

        if (steps < 0) {
            try stdout.writeAll("Steps must be non-negative.\n");
            return;
        }

        const timestamp_start = std.time.milliTimestamp();
        
        var i: usize = 0;
        const steps_int = @as(usize, @intFromFloat(steps));
        while (i <= steps_int) : (i += 1) {
            const t = if (steps_int == 0) 0.0 else @as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(steps_int));
            try stdout.print("{d}\n", .{lerp(START_VALUE, finish, t)});
        }
        
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - timestamp_start)) / 1000.0;
        try stdout.print("Lerp calculation completed in {d:.6}s\n", .{duration});
    }
}

test "Basic Lerp Calculations" {
    {
        try std.testing.expectApproxEqAbs(@as(f32, 0.0), lerp(0.0, 10.0, 0.0), 0.0001);
        try std.testing.expectApproxEqAbs(@as(f32, 5.0), lerp(0.0, 10.0, 0.5), 0.0001);
        try std.testing.expectApproxEqAbs(@as(f32, 10.0), lerp(0.0, 10.0, 1.0), 0.0001);
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

test "Out of Range T Values" {
    // Test values below 0
    try expectEqual(@as(f32, 0.0), lerp(0.0, 10.0, -0.5));
    try expectEqual(@as(f32, 0.0), lerp_precise(0, 10, -0.5));

    // Test values above 1
    try expectEqual(@as(f32, 10.0), lerp(0.0, 10.0, 1.5));
    try expectEqual(@as(f32, 10.0), lerp_precise(0, 10, 1.5));
}