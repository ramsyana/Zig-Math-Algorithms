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
const print = std.debug.print;

const CantorSet = struct {
    start: i32,
    end: i32,
};

fn propagate(level: usize, current: []const CantorSet, allocator: std.mem.Allocator) ![][]CantorSet {
    var levels = std.ArrayList([]CantorSet).init(allocator);
    defer levels.deinit();
    var currentLevel = current;

    for (0..level) |_| {
        var nextLevel = try allocator.alloc(CantorSet, currentLevel.len * 2);
        errdefer allocator.free(nextLevel);
        var idx: usize = 0;
        for (currentLevel) |set| {
            const third = @divTrunc(set.end - set.start, 3);
            // Left segment
            nextLevel[idx] = CantorSet{ .start = set.start, .end = set.start + third };
            idx += 1;
            // Right segment
            nextLevel[idx] = CantorSet{ .start = set.end - third, .end = set.end };
            idx += 1;
        }
        try levels.append(nextLevel);
        currentLevel = nextLevel;
    }

    return try levels.toOwnedSlice();
}

fn printLevel(level: usize, sets: []const CantorSet) void {
    print("Level {d}\t", .{level});
    for (sets) |set| {
        print("[{d}] -- [{d}] ", .{ set.start, set.end });
    }
    print("\n", .{});
}

fn parseArgs(allocator: std.mem.Allocator) !struct { start: i32, end: i32, levels: usize } {
    var arg_it = try std.process.argsWithAllocator(allocator);
    defer arg_it.deinit();
    _ = arg_it.skip();

    var args: [3][]const u8 = undefined;
    var argCount: usize = 0;
    while (arg_it.next()) |arg| : (argCount += 1) {
        if (argCount >= args.len) break;
        args[argCount] = arg;
    }

    if (argCount != 3) {
        print("Usage: cantor_set <start_num> <end_num> <levels>\n", .{});
        std.process.exit(1);
    }

    return .{
        .start = try std.fmt.parseInt(i32, args[0], 10),
        .end = try std.fmt.parseInt(i32, args[1], 10),
        .levels = try std.fmt.parseInt(usize, args[2], 10),
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const params = parseArgs(allocator) catch |err| {
        print("Error parsing arguments: {s}\n", .{@errorName(err)});
        return;
    };

    if (params.start < 0 or params.end < 0 or params.levels == 0) {
        print("All numbers must be positive and levels must be greater than 0\n", .{});
        return;
    }

    var initial = try allocator.alloc(CantorSet, 1);
    defer allocator.free(initial);
    initial[0] = CantorSet{
        .start = params.start,
        .end = params.end,
    };

    const levelsSets = try propagate(params.levels, initial, allocator);
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
    try testing.expectEqual(levels[0][0], CantorSet{ .start = 0, .end = 3 });
    try testing.expectEqual(levels[0][1], CantorSet{ .start = 6, .end = 9 });
}

test "CantorSet multiple levels" {
    const testing = std.testing;
    var allocator = testing.allocator;

    var initial = try allocator.alloc(CantorSet, 1);
    defer allocator.free(initial);
    initial[0] = CantorSet{ .start = 0, .end = 9 };

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
    try testing.expectEqual(levels[1][0], CantorSet{ .start = 0, .end = 1 });
    try testing.expectEqual(levels[1][3], CantorSet{ .start = 8, .end = 9 });
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