//! Polar Coordinate Conversion and Testing Module
//! 
//! This module provides functionality to convert Cartesian coordinates (x,y) 
//! to polar coordinates (r,theta). It includes both random and specific test cases 
//! to verify the conversion accuracy. The conversion is tested against standard 
//! library functions with varying tolerances for radius and angle:
//! - Radius comparison uses a relative tolerance due to floating-point arithmetic.
//! - Angle comparison has a strict tolerance but might fail due to inherent 
//!   limitations of floating-point precision in angle calculations.
//!
//! Examples:
//! - Input: (x=3, y=4)  -> Output: (r=5, theta=0.927)
//! - Input: (x=-1, y=1) -> Output: (r=1.414, theta=2.356)
//! 
//! Note: Some tests might fail due to minor discrepancies in floating-point 
//! representation, especially for angles where precision differences are 
//! exaggerated. Adjustments in tolerance might be necessary for practical use.
//!
//! To run the code, use the following command: 
//! zig run src/algorithm/math/cartesian_to_polar.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/cartesian_to_polar.zig

const std = @import("std");
const math = std.math;
const assert = std.debug.assert;
const print = std.debug.print;

/// Converts Cartesian coordinates to polar coordinates.
/// - `x`: The x-coordinate in Cartesian system.
/// - `y`: The y-coordinate in Cartesian system.
/// - `r`: Pointer to where the radius will be stored.
/// - `theta`: Pointer to where the angle (in radians) will be stored.
fn toPolar(x: f64, y: f64, r: *f64, theta: *f64) void {
    r.* = math.hypot(x, y); // Using hypot for potentially better precision
    theta.* = math.atan2(y, x);
}

/// Normalizes an angle to be within the range [-π, π]
fn normalizeAngle(angle: f64) f64 {
    var normalized = angle;
    while (normalized <= -math.pi) normalized += 2 * math.pi;
    while (normalized > math.pi) normalized -= 2 * math.pi;
    return normalized;
}

/// Generates a random float between `lim1` and `lim2` using a seeded PRNG for reproducibility.
var prng = std.rand.DefaultPrng.init(0);
const random = prng.random();
fn getRand(lim1: f64, lim2: f64) f64 {
    const r = random.float(f64);
    return (lim2 - lim1) * r + lim1;
}

/// Runs random tests for the toPolar function.
fn runTests() !void {
    const NUM_TESTS = 5;
    const epsilon = 1e-15; // Manual epsilon defined, since math.epsilon isn't available
    var failures: usize = 0;

    for (0..NUM_TESTS) |i| {
        print("Test {d}.... ", .{i});
        const x = getRand(-5, 5);
        const y = getRand(-5, 5);
        print("({d:.2}, {d:.2}).... ", .{ x, y });
        
        var r: f64 = undefined;
        var theta: f64 = undefined;
        toPolar(x, y, &r, &theta);
        const expected_r = math.hypot(x, y);
        const expected_theta = math.atan2(y, x);

        print("\nCalculated: r={d:.4}, theta={d:.4}\n", .{ r, theta });
        print("Expected:   r={d:.4}, theta={d:.4}\n", .{ expected_r, expected_theta });

        const r_diff = @abs(r - expected_r);
        const theta_diff = @abs(theta - expected_theta);
        print("Differences: r={d:.4}, theta={d:.4}\n", .{ r_diff, theta_diff });
        print("Differences (high precision): r={d:.20}, theta={d:.20}\n", .{ r_diff, theta_diff });

        if (r_diff >= epsilon * 100 * expected_r or theta_diff >= epsilon * 10) {
            failures += 1;
            print("Test failed!\n", .{});
        } else {
            print("passed\n", .{});
        }
    }
    print("Total failures: {d}\n", .{failures});
}

/// Runs specific test cases for the toPolar function.
fn runSpecificTests() !void {
    print("\nRunning specific test cases...\n", .{});

    const test_cases = [_][3]f64{
        // x, y, expected_theta (in radians)
        [_]f64{ 1.0, 0.0, 0.0 },           // Right
        [_]f64{ 0.0, 1.0, math.pi / 2.0 }, // Up
        [_]f64{ -1.0, 0.0, math.pi },      // Left
        [_]f64{ 0.0, -1.0, -math.pi / 2.0 }, // Down
        [_]f64{ 1.0, 1.0, math.pi / 4.0 }, // 45 degrees
        [_]f64{ 0.0, 0.0, 0.0 },           // Origin (special case)
        [_]f64{ 3.0, 4.0, 0.927295218 },   // 3-4-5 triangle
        [_]f64{ -2.0, -2.0, -2.356194490 }, // -135 degrees
        [_]f64{ 1e-10, 1e-10, math.pi / 4.0 }, // Small values
        [_]f64{ 1e9, 1e9, math.pi / 4.0 },     // Large values
    };

    const epsilon = 1e-15; // Manual epsilon defined
    var failures: usize = 0;

    for (test_cases, 0..) |case, i| {
        var r: f64 = undefined;
        var theta: f64 = undefined;
        const x = case[0];
        const y = case[1];
        const expected_theta = case[2];
        
        print("\nSpecific Test {d}: ({d}, {d})\n", .{ i, x, y });
        toPolar(x, y, &r, &theta);
        
        const expected_r = math.hypot(x, y);
        const expected_theta_normalized = normalizeAngle(expected_theta);
        theta = normalizeAngle(theta); // Normalize calculated theta
        
        const r_diff = @abs(r - expected_r);
        const theta_diff = @abs(theta - expected_theta_normalized);
        
        print("Calculated: r={d:.15}, theta={d:.15}\n", .{ r, theta });
        print("Expected:   r={d:.15}, theta={d:.15}\n", .{ expected_r, expected_theta_normalized });
        print("Differences: r={d:.15}, theta={d:.15}\n", .{ r_diff, theta_diff });
        print("Comparison: r_diff < epsilon * 100 * expected_r = {d} < {d}\n", .{ r_diff, epsilon * 100 * expected_r });
        print("Comparison: theta_diff < epsilon = {d} < {d}\n", .{ theta_diff, epsilon });
        
        if (x == 0.0 and y == 0.0) {
            print("Origin case - theta can be any value\n", .{});
        } else {
            if (r_diff < epsilon * 100 * expected_r and theta_diff < epsilon) {
                print("passed\n", .{});
            } else {
                failures += 1;
                print("FAILED!\n", .{});
            }
        }
    }
    print("Total specific test failures: {d}\n", .{failures});
}

pub fn main() !void {
    try runTests();
    try runSpecificTests();
}