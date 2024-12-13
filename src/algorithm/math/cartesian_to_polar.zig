//! Polar Coordinate Conversion and Testing Module
//! 
//! This module provides functionality to convert Cartesian coordinates (x,y) 
//! to polar coordinates (r,theta). It includes random test generation to verify
//! the conversion accuracy. The conversion is tested against standard library
//! functions with a tolerance of 0.01 for both radius and angle values.
//!
//! Examples:
//! - Input: (x=3, y=4)  -> Output: (r=5, theta=0.927)
//! - Input: (x=-1, y=1) -> Output: (r=1.414, theta=2.356)
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

fn toPolar(x: f64, y: f64, r: *f64, theta: *f64) void {
    r.* = @sqrt(x * x + y * y);
    theta.* = math.atan2(y, x);
}

fn getRand(lim1: f64, lim2: f64) f64 {
    const random = std.crypto.random;
    const r = random.float(f64);
    return (lim2 - lim1) * r + lim1;
}

fn runTests() !void {
    const NUM_TESTS = 5;
    var i: usize = 0;
    while (i < NUM_TESTS) : (i += 1) {
        var r: f64 = undefined;
        var theta: f64 = undefined;
        print("Test {d}.... ", .{i});
        const x = getRand(-5, 5);
        const y = getRand(-5, 5);
        print("({d:.2}, {d:.2}).... ", .{ x, y });
        toPolar(x, y, &r, &theta);
        const expected_r = math.hypot(x, y);
        const expected_theta = math.atan2(y, x);
        
        print("\nCalculated: r={d:.4}, theta={d:.4}\n", .{ r, theta });
        print("Expected:   r={d:.4}, theta={d:.4}\n", .{ expected_r, expected_theta });
        
        const r_diff = @abs(r - expected_r);
        const theta_diff = @abs(theta - expected_theta);
        print("Differences: r={d:.4}, theta={d:.4}\n", .{ r_diff, theta_diff });

        if (r_diff >= 0.01) {
            print("r value mismatch!\n", .{});
        }
        if (theta_diff >= 0.01) {
            print("theta value mismatch!\n", .{});
        }
        
        if (r_diff < 0.01 and theta_diff < 0.01) {
            print("passed\n", .{});
        }
    }
}

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
    };

    for (test_cases, 0..) |case, i| {
        var r: f64 = undefined;
        var theta: f64 = undefined;
        const x = case[0];
        const y = case[1];
        const expected_theta = case[2];
        
        print("\nSpecific Test {d}: ({d}, {d})\n", .{ i, x, y });
        toPolar(x, y, &r, &theta);
        
        const expected_r = math.hypot(x, y);
        print("Calculated: r={d:.6}, theta={d:.6}\n", .{ r, theta });
        print("Expected:   r={d:.6}, theta={d:.6}\n", .{ expected_r, expected_theta });
        
        const r_diff = @abs(r - expected_r);
        const theta_diff = @abs(theta - expected_theta);
        
        if (x == 0.0 and y == 0.0) {
            print("Origin case - theta can be any value\n", .{});
        } else {
            if (r_diff < 0.000001 and theta_diff < 0.000001) {
                print("passed\n", .{});
            } else {
                print("FAILED!\n", .{});
                print("Differences: r={d:.6}, theta={d:.6}\n", .{ r_diff, theta_diff });
            }
        }
    }
}

pub fn main() !void {
    try runTests();
    try runSpecificTests();
}