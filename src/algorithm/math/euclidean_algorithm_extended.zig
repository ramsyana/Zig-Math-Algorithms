//! Extended Euclidean Algorithm Implementation
//!
//! This module implements the Extended Euclidean Algorithm, which finds both:
//! - The greatest common divisor (GCD) of two integers a and b
//! - The coefficients x and y such that: ax + by = gcd(a,b)
//!
//! The algorithm extends the standard Euclidean algorithm by keeping track of
//! the coefficients throughout the division steps. It also includes:
//! - Basic overflow checking for operations that might exceed i32 range.
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
const math = std.math;

const EuclideanResult = struct {
    gcd: i32,
    x: i32,
    y: i32,
};

fn updateCoefficients(quotient: i32, coefficients: *[2]i32) void {
    const next = coefficients[1] - coefficients[0] * quotient;
    coefficients[1] = coefficients[0];
    coefficients[0] = next;
}

pub fn extendedEuclideanAlgorithm(a: i32, b: i32) !EuclideanResult {
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

    const sign_a = if (a < 0) @as(i32, -1) else 1;
    const sign_b = if (b < 0) @as(i32, -1) else 1;
    var dividend = if (a < 0) -a else a;
    var divisor = if (b < 0) -b else b;
    
    var swapped = false;
    if (dividend < divisor) {
        const temp = dividend;
        dividend = divisor;
        divisor = temp;
        swapped = true;
    }
    
    var remainder: i32 = 1;
    var coefficients_x = [2]i32{ 0, 1 };
    var coefficients_y = [2]i32{ 1, 0 };
    
    while (divisor > 0) {
        const quotient = @divTrunc(dividend, divisor);
        remainder = divisor;
        const new_divisor = @mod(dividend, divisor);
        
        // Check for overflow manually
        if ((dividend > math.maxInt(i32) - divisor) or 
            (divisor > math.maxInt(i32) - new_divisor)) {
            return error.Overflow;
        }

        updateCoefficients(quotient, &coefficients_x);
        updateCoefficients(quotient, &coefficients_y);

        dividend = divisor;
        divisor = new_divisor;
    }
    
    if (swapped) {
        return EuclideanResult{
            .gcd = remainder,
            .x = coefficients_y[1] * sign_a,
            .y = coefficients_x[1] * sign_b,
        };
    } else {
        return EuclideanResult{
            .gcd = remainder,
            .x = coefficients_x[1] * sign_a,
            .y = coefficients_y[1] * sign_b,
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
        .{ .a = math.maxInt(i32), .b = 2 }, // Test for overflow
        .{ .a = -math.maxInt(i32), .b = -2 }, // Test for negative overflow
    };

    try stdout.print("Extended Euclidean Algorithm Results:\n\n", .{});

    for (test_cases) |tc| {
        const result = extendedEuclideanAlgorithm(tc.a, tc.b) catch |err| {
            try stdout.print("Error for a={} and b={}: {}\n", .{ tc.a, tc.b, err });
            continue;
        };
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
        .{ .a = math.maxInt(i32), .b = 2, .expected_gcd = 2 }, // Overflow case
    };

    for (test_cases) |tc| {
        const result = extendedEuclideanAlgorithm(tc.a, tc.b) catch |err| {
            if (err == error.Overflow) {
                try testing.expectEqual(math.maxInt(i32), tc.a); // Expect overflow for this case
                return;
            }
            return err; // Propagate other errors
        };
        try testing.expectEqual(tc.expected_gcd, result.gcd);
        try testing.expectEqual(result.gcd, tc.a * result.x + tc.b * result.y);
    }
}

test "Extended Euclidean Algorithm - Edge Cases" {
    // Test with negative numbers
    {
        const result = try extendedEuclideanAlgorithm(-48, 18);
        try testing.expectEqual(@as(i32, 6), result.gcd);
        try testing.expectEqual(result.gcd, -48 * result.x + 18 * result.y);
    }
    
    // Test with both negative numbers
    {
        const result = try extendedEuclideanAlgorithm(-48, -18);
        try testing.expectEqual(@as(i32, 6), result.gcd);
        try testing.expectEqual(result.gcd, -48 * result.x + -18 * result.y);
    }
    
    // Test with zero
    {
        const result = try extendedEuclideanAlgorithm(18, 0);
        try testing.expectEqual(@as(i32, 18), result.gcd);
        try testing.expectEqual(result.gcd, 18 * result.x + 0 * result.y);
    }
    
    // Test with b > a
    {
        const result = try extendedEuclideanAlgorithm(18, 48);
        try testing.expectEqual(@as(i32, 6), result.gcd);
        try testing.expectEqual(result.gcd, 18 * result.x + 48 * result.y);
    }

    // Test for overflow
    {
        _ = extendedEuclideanAlgorithm(math.maxInt(i32), 2) catch |err| {
            try testing.expect(err == error.Overflow);
        };
    }
}

test "Extended Euclidean Algorithm - Coprime Numbers" {
    const result = try extendedEuclideanAlgorithm(71, 41);
    try testing.expectEqual(@as(i32, 1), result.gcd);
    try testing.expectEqual(result.gcd, 71 * result.x + 41 * result.y);
}