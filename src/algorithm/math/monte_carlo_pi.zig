//! Monte Carlo Pi Estimation
//! This algorithm estimates π using the Monte Carlo method by randomly generating points
//! within a square and determining the ratio of points that fall inside a quarter circle.
//! The ratio of points inside the quarter circle to total points approaches π/4 as the
//! number of points increases.

const std = @import("std");
const math = std.math;
const rand = std.rand;
const DefaultPrng = rand.DefaultPrng;
const time = std.time;

/// Estimates π using Monte Carlo simulation with the specified number of points.
/// The estimation improves with more points but requires more computation time.
pub fn estimatePi(num_points: usize) f64 {
    // Cast the timestamp to u64 first
    const seed: u64 = @intCast(time.milliTimestamp());
    // Initialize the PRNG with the seed
    var prng = DefaultPrng.init(seed);
    var random = prng.random();

    var points_inside: usize = 0;

    // Generate random points and count those inside the quarter circle
    var i: usize = 0;
    while (i < num_points) : (i += 1) {
        const x = random.float(f64);
        const y = random.float(f64);

        // Check if point lies inside quarter circle (x² + y² ≤ 1)
        if (x * x + y * y <= 1.0) {
            points_inside += 1;
        }
    }

    // The ratio points_inside/total_points approaches π/4
    // Therefore π ≈ 4 * (points_inside/total_points)
    return 4.0 * @as(f64, @floatFromInt(points_inside)) / @as(f64, @floatFromInt(num_points));
}

/// Estimates π with increasing precision by using more points.
/// Returns an array of estimates for different point counts.
pub fn estimatePiWithProgress(comptime iterations: usize) [iterations]f64 {
    var results: [iterations]f64 = undefined;
    var points: usize = 1000;

    for (0..iterations) |i| {
        results[i] = estimatePi(points);
        points *= 2; // Double the points for next iteration
    }

    return results;
}

test "Monte Carlo Pi Estimation" {
    const testing = std.testing;
    const epsilon = 0.1; // Acceptable error margin

    // Test with different numbers of points
    const points = [_]usize{ 1000, 10000, 100000 };

    for (points) |n| {
        const estimate = estimatePi(n);
        try testing.expect(@abs(estimate - math.pi) < epsilon);
    }
}

test "Pi Estimation Convergence" {
    const testing = std.testing;
    const epsilon = 0.1;

    // Test that estimates converge as we use more points
    const results = estimatePiWithProgress(5);
    const last_estimate = results[results.len - 1];

    try testing.expect(@abs(last_estimate - math.pi) < epsilon);
}

pub fn main() !void {
    // Get an allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // Create a buffered writer for stdout
    const stdout = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout);
    const writer = bw.writer();

    // Print header
    try writer.writeAll("\nMonte Carlo Pi Estimation\n");
    try writer.writeAll("======================\n\n");

    // Estimate π with increasing precision
    const iterations = 5;
    const results = estimatePiWithProgress(iterations);
    var points: usize = 1000;

    // Print results
    try writer.writeAll("Points\t\tEstimated π\tError\n");
    try writer.writeAll("------\t\t-----------\t-----\n");

    for (results) |estimate| {
        const err = @abs(estimate - math.pi);
        try writer.print("{d}\t\t{d:.6}\t\t{d:.6}\n", .{
            points,
            estimate,
            err,
        });
        points *= 2;
    }

    try writer.writeAll("\nActual π: ");
    try writer.print("{d:.6}\n", .{math.pi});

    // Flush the buffer
    try bw.flush();
}
