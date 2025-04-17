//! Sum of Arithmetic/Geometric Series Calculator
//! -----------------------------------------
//! A program to calculate the sum of arithmetic or geometric series.
//!
//! Mathematical Properties:
//! - Arithmetic Series: Each term differs from the previous by a constant value (common difference)
//!   Sum = n/2 * [2a + (n-1)d], where:
//!     a = first term
//!     d = common difference
//!     n = number of terms
//!
//! - Geometric Series: Each term is a constant multiple of the previous term (common ratio)
//!   Sum = a * (1 - r^n) / (1 - r), where:
//!     a = first term
//!     r = common ratio
//!     n = number of terms
//!     (For r ≠ 1; if r = 1, sum = a * n)
//!
//! Functions:
//! arithmeticSeriesSum(first_term: f64, common_difference: f64, n_terms: u32) f64
//!     Calculates the sum of an arithmetic series
//!     Time complexity: O(1)
//!
//! geometricSeriesSum(first_term: f64, common_ratio: f64, n_terms: u32) f64
//!     Calculates the sum of a geometric series
//!     Time complexity: O(1)
//!
//! Usage:
//! ```zig
//! const sum = arithmeticSeriesSum(2, 3, 10); // Sum of 2, 5, 8, 11, ..., 29
//! const sum = geometricSeriesSum(2, 3, 5);   // Sum of 2, 6, 18, 54, 162
//! ```
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/series_sum.zig -- --type arithmetic --start 2 --common_difference 3 --terms 10
//! zig run src/algorithm/math/series_sum.zig -- --type geometric --start 2 --common_ratio 3 --terms 5
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/series_sum.zig

const std = @import("std");

/// Calculates the sum of an arithmetic series
/// Formula: n/2 * [2a + (n-1)d]
/// where a = first term, d = common difference, n = number of terms
pub fn arithmeticSeriesSum(first_term: f64, common_difference: f64, n_terms: u32) f64 {
    const n = @as(f64, @floatFromInt(n_terms));
    return (n / 2.0) * (2.0 * first_term + (n - 1.0) * common_difference);
}

/// Calculates the sum of a geometric series
/// Formula: a * (1 - r^n) / (1 - r) for r ≠ 1
/// Formula: a * n for r = 1
/// where a = first term, r = common ratio, n = number of terms
pub fn geometricSeriesSum(first_term: f64, common_ratio: f64, n_terms: u32) f64 {
    const n = @as(f64, @floatFromInt(n_terms));
    
    // Special case: common ratio = 1
    if (common_ratio == 1.0) {
        return first_term * n;
    }
    
    // General case
    const r_pow_n = std.math.pow(f64, common_ratio, n);
    return first_term * (1.0 - r_pow_n) / (1.0 - common_ratio);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Parse command line arguments
    var args = try std.process.argsWithAllocator(allocator);
    // Skip the program name
    _ = args.next();

    var series_type: []const u8 = "arithmetic";
    var first_term: f64 = 1.0;
    var common_difference: f64 = 1.0;
    var common_ratio: f64 = 2.0;
    var n_terms: u32 = 10;

    // Parse command line options
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--type") or std.mem.eql(u8, arg, "-t")) {
            if (args.next()) |value| {
                series_type = value;
            }
        } else if (std.mem.eql(u8, arg, "--start") or std.mem.eql(u8, arg, "-s")) {
            if (args.next()) |value| {
                first_term = try std.fmt.parseFloat(f64, value);
            }
        } else if (std.mem.eql(u8, arg, "--common_difference") or std.mem.eql(u8, arg, "-d")) {
            if (args.next()) |value| {
                common_difference = try std.fmt.parseFloat(f64, value);
            }
        } else if (std.mem.eql(u8, arg, "--common_ratio") or std.mem.eql(u8, arg, "-r")) {
            if (args.next()) |value| {
                common_ratio = try std.fmt.parseFloat(f64, value);
            }
        } else if (std.mem.eql(u8, arg, "--terms") or std.mem.eql(u8, arg, "-n")) {
            if (args.next()) |value| {
                n_terms = try std.fmt.parseInt(u32, value, 10);
            }
        } else if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            try stdout.writeAll(
                \\Usage: zig run series_sum.zig -- [OPTIONS]
                \\
                \\Options:
                \\  --type, -t              Type of series: 'arithmetic' or 'geometric' (default: arithmetic)
                \\  --start, -s             First term of the series (default: 1.0)
                \\  --common_difference, -d Common difference for arithmetic series (default: 1.0)
                \\  --common_ratio, -r      Common ratio for geometric series (default: 2.0)
                \\  --terms, -n             Number of terms in the series (default: 10)
                \\  --help, -h              Display this help message
                \\
                \\Examples:
                \\  zig run series_sum.zig -- --type arithmetic --start 2 --common_difference 3 --terms 10
                \\  zig run series_sum.zig -- --type geometric --start 2 --common_ratio 3 --terms 5
                \\
            );
            return;
        }
    }

    // Calculate and display the sum
    if (std.mem.eql(u8, series_type, "arithmetic")) {
        const sum = arithmeticSeriesSum(first_term, common_difference, n_terms);
        try stdout.print("Sum of arithmetic series with:\n", .{});
        try stdout.print("  First term: {d}\n", .{first_term});
        try stdout.print("  Common difference: {d}\n", .{common_difference});
        try stdout.print("  Number of terms: {d}\n", .{n_terms});
        try stdout.print("= {d}\n", .{sum});
        
        // Display the terms for clarity
        try stdout.writeAll("Terms: ");
        var i: u32 = 0;
        while (i < n_terms) : (i += 1) {
            const term = first_term + @as(f64, @floatFromInt(i)) * common_difference;
            try stdout.print("{d}", .{term});
            if (i < n_terms - 1) try stdout.writeAll(", ");
        }
        try stdout.writeAll("\n");
    } else if (std.mem.eql(u8, series_type, "geometric")) {
        const sum = geometricSeriesSum(first_term, common_ratio, n_terms);
        try stdout.print("Sum of geometric series with:\n", .{});
        try stdout.print("  First term: {d}\n", .{first_term});
        try stdout.print("  Common ratio: {d}\n", .{common_ratio});
        try stdout.print("  Number of terms: {d}\n", .{n_terms});
        try stdout.print("= {d}\n", .{sum});
        
        // Display the terms for clarity
        try stdout.writeAll("Terms: ");
        var i: u32 = 0;
        while (i < n_terms) : (i += 1) {
            const term = first_term * std.math.pow(f64, common_ratio, @floatFromInt(i));
            try stdout.print("{d}", .{term});
            if (i < n_terms - 1) try stdout.writeAll(", ");
        }
        try stdout.writeAll("\n");
    } else {
        try stdout.print("Unknown series type: {s}. Use 'arithmetic' or 'geometric'.\n", .{series_type});
        return;
    }
}

test "arithmetic series sum" {
    const testing = std.testing;
    
    // Test case 1: Sum of first 10 natural numbers (1, 2, 3, ..., 10)
    // Formula: n(n+1)/2 = 10*11/2 = 55
    try testing.expectEqual(arithmeticSeriesSum(1, 1, 10), 55);
    
    // Test case 2: Sum of 2, 5, 8, 11, ..., 29 (10 terms)
    // a = 2, d = 3, n = 10
    try testing.expectEqual(arithmeticSeriesSum(2, 3, 10), 155);
    
    // Test case 3: Sum of 5, 10, 15, ..., 50 (10 terms)
    // a = 5, d = 5, n = 10
    try testing.expectEqual(arithmeticSeriesSum(5, 5, 10), 275);
    
    // Test case 4: Single term
    try testing.expectEqual(arithmeticSeriesSum(7, 3, 1), 7);
    
    // Test case 5: Zero terms
    try testing.expectEqual(arithmeticSeriesSum(7, 3, 0), 0);
}

test "geometric series sum" {
    const testing = std.testing;
    
    // Test case 1: Sum of 1, 2, 4, 8, 16 (5 terms)
    // a = 1, r = 2, n = 5
    // Sum = 1 * (1 - 2^5) / (1 - 2) = 1 * (1 - 32) / (-1) = 31
    try testing.expectEqual(geometricSeriesSum(1, 2, 5), 31);
    
    // Test case 2: Sum of 2, 6, 18, 54, 162 (5 terms)
    // a = 2, r = 3, n = 5
    try testing.expectEqual(geometricSeriesSum(2, 3, 5), 242);
    
    // Test case 3: Sum with common ratio = 1 (constant sequence)
    // a = 5, r = 1, n = 10
    // Sum = 5 * 10 = 50
    try testing.expectEqual(geometricSeriesSum(5, 1, 10), 50);
    
    // Test case 4: Single term
    try testing.expectEqual(geometricSeriesSum(7, 3, 1), 7);
    
    // Test case 5: Zero terms
    try testing.expectEqual(geometricSeriesSum(7, 3, 0), 0);
    
    // Test case 6: Common ratio < 1
    // a = 10, r = 0.5, n = 4
    // Sum = 10 * (1 - 0.5^4) / (1 - 0.5) = 10 * (1 - 0.0625) / 0.5 = 18.75
    try testing.expectApproxEqAbs(geometricSeriesSum(10, 0.5, 4), 18.75, 0.0001);
}
