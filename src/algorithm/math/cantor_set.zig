//! Cantor Set Generator
//! ------------------
//! This program generates and prints the levels of a Cantor set.
//!
//! The Cantor set is a mathematical fractal that demonstrates self-similarity
//! and infinite subdivision. Starting with an initial line segment [a,b], 
//! the construction process:
//! 1. Divides each segment into three equal parts
//! 2. Removes the middle third
//! 3. Repeats the process on the remaining segments
//!
//! At each level n, there are 2^n segments, each with length (1/3)^n 
//! of the original interval length.
//!
//! Key Functions:
//! - propagate(): Generates new levels by dividing segments and removing middle thirds
//! - printLevel(): Formats and displays the segments at each level
//!
//! Input Parameters:
//! - start_num: Starting point of the initial interval (integer)
//! - end_num: Endpoint of the initial interval (integer)
//! - levels: Number of iterations to perform (integer > 0)
//!
//! Usage Examples:
//! ```
//! # Command line:
//! zig run src/algorithm/math/cantor_set.zig -- 0 1 3 
//! 
//! To test:
//! zig test src/algorithm/math/cantor_set.zig
//!
//! # Sample output:
//! Level 1    [0.000] -- [0.333] [0.667] -- [1.000]
//! Level 2    [0.000] -- [0.111] [0.222] -- [0.333] [0.667] -- [0.778] [0.889] -- [1.000]
//! Level 3    [0.000] -- [0.037] ... [0.963] -- [1.000]
//! Level 0    [0.000] -- [1.000]
//! ```
//!
//! Memory Management:
//! - Uses GeneralPurposeAllocator for dynamic allocation
//! - All allocations are properly freed using defer statements
//!
//! Note: Input values must be non-negative and the number of levels must be greater than 0.

const std = @import("std");

const CantorSet = struct {
    start: f64,
    end: f64,
};

fn propagate(level: usize, current: []const CantorSet, allocator: std.mem.Allocator) ![][]CantorSet {
    var levels = std.ArrayList([]CantorSet).init(allocator);
    var currentLevel = current;

    for (0..level) |_| {
        var nextLevel = try allocator.alloc(CantorSet, currentLevel.len * 2);
        var idx: usize = 0;
        for (currentLevel) |set| {
            const third = (set.end - set.start) / 3.0;
            // Left segment: first third
            nextLevel[idx] = CantorSet{
                .start = set.start,
                .end = set.start + third,
            };
            idx += 1;
            // Right segment: last third
            nextLevel[idx] = CantorSet{
                .start = set.end - third,
                .end = set.end,
            };
            idx += 1;
        }
        try levels.append(nextLevel);
        currentLevel = nextLevel;
    }

    return try levels.toOwnedSlice();
}

fn printLevel(level: usize, sets: []const CantorSet) void {
    std.debug.print("Level {d}\t", .{level});
    for (sets) |set| {
        std.debug.print("[{d:.3}] -- [{d:.3}] ", .{ set.start, set.end });
    }
    std.debug.print("\n", .{});
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var arg_it = try std.process.argsWithAllocator(allocator);
    defer arg_it.deinit();

    _ = arg_it.skip(); // Skip program name

    var start_num: i32 = 0;
    var end_num: i32 = 0;
    var levels: usize = 0;

    if (arg_it.next()) |arg| {
        start_num = try std.fmt.parseInt(i32, arg, 10);
        if (arg_it.next()) |end_arg| {
            end_num = try std.fmt.parseInt(i32, end_arg, 10);
            if (arg_it.next()) |level_arg| {
                levels = try std.fmt.parseInt(usize, level_arg, 10);
            }
        }
    } else {
        std.debug.print("Enter 3 arguments: start_num end_num levels\n", .{});
        const stdin = std.io.getStdIn().reader();
        var buf: [1024]u8 = undefined;
        
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
            // Trim whitespace and newline
            const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
            var parts = std.mem.tokenize(u8, trimmed, " ");
            
            if (parts.next()) |start| {
                start_num = try std.fmt.parseInt(i32, start, 10);
                if (parts.next()) |end| {
                    end_num = try std.fmt.parseInt(i32, end, 10);
                    if (parts.next()) |level| {
                        levels = try std.fmt.parseInt(usize, level, 10);
                    }
                }
            }
        }
    }

    if (start_num < 0 or end_num < 0 or levels == 0) {
        std.debug.print("All numbers must be positive and levels must be greater than 0\n", .{});
        return;
    }

    var initial = try allocator.alloc(CantorSet, 1);
    initial[0] = CantorSet{
        .start = @as(f64, @floatFromInt(start_num)),
        .end = @as(f64, @floatFromInt(end_num)),
    };
    defer allocator.free(initial);

    const levelsSets = try propagate(levels, initial, allocator);
    defer {
        for (levelsSets) |sets| {
            allocator.free(sets);
        }
        allocator.free(levelsSets);
    }

    for (levelsSets, 0..) |sets, i| {
        printLevel(i + 1, sets);
    }
    printLevel(0, initial);
}

test "CantorSet basic propagation" {
    const testing = std.testing;
    var allocator = testing.allocator;

    // Create initial set [0, 9]
    var initial = try allocator.alloc(CantorSet, 1);
    defer allocator.free(initial);
    initial[0] = CantorSet{ .start = 0, .end = 9 };

    // Test one level of propagation
    const levels = try propagate(1, initial, allocator);
    defer {
        for (levels) |sets| {
            allocator.free(sets);
        }
        allocator.free(levels);
    }

    try testing.expectEqual(levels.len, 1);
    try testing.expectEqual(levels[0].len, 2);

    // First third: [0, 3]
    try testing.expectApproxEqAbs(levels[0][0].start, 0, 0.001);
    try testing.expectApproxEqAbs(levels[0][0].end, 3, 0.001);

    // Last third: [6, 9]
    try testing.expectApproxEqAbs(levels[0][1].start, 6, 0.001);
    try testing.expectApproxEqAbs(levels[0][1].end, 9, 0.001);
}

test "CantorSet multiple levels" {
    const testing = std.testing;
    var allocator = testing.allocator;

    // Create initial set [0, 9]
    var initial = try allocator.alloc(CantorSet, 1);
    defer allocator.free(initial);
    initial[0] = CantorSet{ .start = 0, .end = 9 };

    // Test two levels of propagation
    const levels = try propagate(2, initial, allocator);
    defer {
        for (levels) |sets| {
            allocator.free(sets);
        }
        allocator.free(levels);
    }

    try testing.expectEqual(levels.len, 2);
    try testing.expectEqual(levels[0].len, 2);
    try testing.expectEqual(levels[1].len, 4);

    // Check second level segments
    // First segment: [0, 1]
    try testing.expectApproxEqAbs(levels[1][0].start, 0, 0.001);
    try testing.expectApproxEqAbs(levels[1][0].end, 1, 0.001);

    // Last segment: [8, 9]
    try testing.expectApproxEqAbs(levels[1][3].start, 8, 0.001);
    try testing.expectApproxEqAbs(levels[1][3].end, 9, 0.001);
}

test "CantorSet error cases" {
    const testing = std.testing;
    var allocator = testing.allocator;

    // Test with 0 levels
    var initial = try allocator.alloc(CantorSet, 1);
    defer allocator.free(initial);
    initial[0] = CantorSet{ .start = 0, .end = 9 };

    const levels = try propagate(0, initial, allocator);
    defer allocator.free(levels);

    try testing.expectEqual(levels.len, 0);
}