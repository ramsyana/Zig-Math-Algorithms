//! Extended Euclidean Algorithm Implementation
//!
//! This module implements the Extended Euclidean Algorithm, which finds both:
//! - The greatest common divisor (GCD) of two integers a and b
//! - The coefficients x and y such that: ax + by = gcd(a,b)
//!
//! The algorithm extends the standard Euclidean algorithm by keeping track of
//! the coefficients throughout the division steps.
//!
//! Examples:
//! - Input: a=40, b=27 -> GCD=1, x=-2, y=3 (40*(-2) + 27*3 = 1)
//! - Input: a=48, b=18 -> GCD=6, x=-1, y=3 (48*(-1) + 18*3 = 6)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/euclidean_algorithm_extended.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/euclidean_algorithm_extended.zig
//!
//! Reference: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm

const std = @import("std");
const testing = std.testing;

const EuclideanResult = struct {
    gcd: i32,
    x: i32,
    y: i32,
};

fn xyPush(arr: *[2]i32, new_val: i32) void {
    arr[1] = arr[0];
    arr[0] = new_val;
}

fn calculateNextXy(quotient: i32, prev: *[2]i32) void {
    const next = prev[1] - (prev[0] * quotient);
    xyPush(prev, next);
}

pub fn extendedEuclideanAlgorithm(a: i32, b: i32) EuclideanResult {
    // Handle zero cases first
    if (b == 0) {
        return EuclideanResult{
            .gcd = if (a < 0) -a else a,
            .x = if (a < 0) -1 else 1,
            .y = 0,
        };
    }
    if (a == 0) {
        return EuclideanResult{
            .gcd = if (b < 0) -b else b,
            .x = 0,
            .y = if (b < 0) -1 else 1,
        };
    }

    // Convert to positive values while keeping track of signs
    const sign_a: i32 = if (a < 0) -1 else 1;
    const sign_b: i32 = if (b < 0) -1 else 1;
    var current_a = if (a < 0) -a else a;
    var current_b = if (b < 0) -b else b;
    
    // Keep track if we swapped the inputs
    var swapped = false;
    if (current_a < current_b) {
        const temp = current_a;
        current_a = current_b;
        current_b = temp;
        swapped = true;
    }
    
    var previous_remainder: i32 = 1;
    var previous_x_values = [2]i32{ 0, 1 };
    var previous_y_values = [2]i32{ 1, 0 };
    
    while (current_b > 0) {
        const quotient = @divTrunc(current_a, current_b);
        const remainder = @mod(current_a, current_b);
        
        previous_remainder = current_b;
        
        current_a = current_b;
        current_b = remainder;
        
        calculateNextXy(quotient, &previous_x_values);
        calculateNextXy(quotient, &previous_y_values);
    }
    
    if (swapped) {
        // If we swapped the inputs, swap x and y in the result
        return EuclideanResult{
            .gcd = previous_remainder,
            .x = previous_y_values[1] * sign_a,
            .y = previous_x_values[1] * sign_b,
        };
    } else {
        return EuclideanResult{
            .gcd = previous_remainder,
            .x = previous_x_values[1] * sign_a,
            .y = previous_y_values[1] * sign_b,
        };
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const test_cases = [_]struct {
        a: i32,
        b: i32,
    }{
        .{ .a = 40, .b = 27 },
        .{ .a = 71, .b = 41 },
        .{ .a = 48, .b = 18 },
        .{ .a = 99, .b = 303 },
        .{ .a = 14005, .b = 3507 },
    };

    try stdout.print("Extended Euclidean Algorithm Results:\n\n", .{});

    for (test_cases) |tc| {
        const result = extendedEuclideanAlgorithm(tc.a, tc.b);
        try stdout.print("For a={} and b={}:\n", .{ tc.a, tc.b });
        try stdout.print("GCD: {}\n", .{result.gcd});
        try stdout.print("x: {}\n", .{result.x});
        try stdout.print("y: {}\n", .{result.y});
        try stdout.print("Verification: {}*({}) + {}*({}) = {}\n\n", 
            .{ tc.a, result.x, tc.b, result.y, result.gcd });
    }
}

test "Extended Euclidean Algorithm - Basic Cases" {
    const TestCase = struct {
        a: i32,
        b: i32,
        expected_gcd: i32,
    };

    const test_cases = [_]TestCase{
        .{ .a = 40, .b = 27, .expected_gcd = 1 },
        .{ .a = 48, .b = 18, .expected_gcd = 6 },
        .{ .a = 14005, .b = 3507, .expected_gcd = 1 },
    };

    for (test_cases) |tc| {
        const result = extendedEuclideanAlgorithm(tc.a, tc.b);
        // Verify GCD
        try testing.expectEqual(tc.expected_gcd, result.gcd);
        // Verify Bézout's identity: ax + by = gcd(a,b)
        try testing.expectEqual(result.gcd, tc.a * result.x + tc.b * result.y);
    }
}

test "Extended Euclidean Algorithm - Edge Cases" {
    // Test with negative numbers
    {
        const result = extendedEuclideanAlgorithm(-48, 18);
        try testing.expectEqual(@as(i32, 6), result.gcd);
        try testing.expectEqual(result.gcd, -48 * result.x + 18 * result.y);
    }
    
    // Test with both negative numbers
    {
        const result = extendedEuclideanAlgorithm(-48, -18);
        try testing.expectEqual(@as(i32, 6), result.gcd);
        try testing.expectEqual(result.gcd, -48 * result.x + -18 * result.y);
    }
    
    // Test with zero
    {
        const result = extendedEuclideanAlgorithm(18, 0);
        try testing.expectEqual(@as(i32, 18), result.gcd);
        try testing.expectEqual(result.gcd, 18 * result.x + 0 * result.y);
    }
    
    // Test with b > a
    {
        const result = extendedEuclideanAlgorithm(18, 48);
        try testing.expectEqual(@as(i32, 6), result.gcd);
        try testing.expectEqual(result.gcd, 18 * result.x + 48 * result.y);
    }
}

test "Extended Euclidean Algorithm - Coprime Numbers" {
    const result = extendedEuclideanAlgorithm(71, 41);
    try testing.expectEqual(@as(i32, 1), result.gcd);
    try testing.expectEqual(result.gcd, 71 * result.x + 41 * result.y);
}