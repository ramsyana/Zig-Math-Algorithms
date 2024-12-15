//! Collatz Conjecture Implementation
//!
//! This module implements the Collatz conjecture, also known as the 3n + 1 problem.
//! For any positive integer n, the sequence is defined as follows:
//! - If n is even, divide it by 2 (n/2)
//! - If n is odd, multiply by 3 and add 1 (3n + 1)
//! The conjecture states that this sequence always reaches 1.
//!
//! Examples:
//! - Input: n=10 -> Sequence: 10->5->16->8->4->2->1
//! - Input: n=27 -> Sequence reaches 9232 before eventually descending to 1
//!
//! **Usage:**
//! - To run the code, use: `zig run src/algorithm/math/collatz_conjecture.zig`
//! - To test the code, use: `zig test src/algorithm/math/collatz_conjecture.zig`
//!
//! Reference: https://en.wikipedia.org/wiki/Collatz_conjecture

const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var n: u64 = undefined;
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip();

    if (args.next()) |arg| {
        n = parseNumber(arg) catch |err| {
            try stdout.print("Error parsing argument: {s}\n", .{@errorName(err)});
            return;
        };
    } else {
        try stdout.writeAll("Enter starting number: ");
        var buf: [20]u8 = undefined;
        const user_input = try stdin.readUntilDelimiter(&buf, '\n');
        const trimmed = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        n = parseNumber(trimmed) catch |err| {
            try stdout.print("Error parsing input: {s}\n", .{@errorName(err)});
            return;
        };
    }

    var curr_no: u64 = n;
    var num_steps: u64 = 0;

    while (curr_no != 1) {
        num_steps += 1;
        try stdout.print("{d}->", .{curr_no});
        
        if (curr_no % 2 == 0) {
            curr_no = curr_no / 2;
        } else {
            curr_no = (curr_no * 3) + 1;
        }
    }

    try stdout.print("1\nNumber of steps: {d}\n", .{num_steps});
}

// Helper function to calculate Collatz sequence length
fn calculateCollatzSteps(n: u64) u64 {
    var curr_no: u64 = n;
    var num_steps: u64 = 0;

    while (curr_no != 1) {
        num_steps += 1;
        if (curr_no % 2 == 0) {
            curr_no = curr_no / 2;
        } else {
            curr_no = (curr_no * 3) + 1;
        }
    }
    return num_steps;
}

// Helper function to parse a string to a u64 number, with better error handling
fn parseNumber(str: []const u8) !u64 {
    return std.fmt.parseInt(u64, str, 10) catch |err| {
        return switch (err) {
            error.Overflow => error.NumberTooLarge,
            else => err,
        };
    };
}

test "Collatz sequence for known values" {
    const testing = std.testing;
    
    // Test cases with known results
    try testing.expectEqual(@as(u64, 0), calculateCollatzSteps(1));
    try testing.expectEqual(@as(u64, 1), calculateCollatzSteps(2));
    try testing.expectEqual(@as(u64, 7), calculateCollatzSteps(3));
    try testing.expectEqual(@as(u64, 2), calculateCollatzSteps(4));
    try testing.expectEqual(@as(u64, 5), calculateCollatzSteps(5));
    try testing.expectEqual(@as(u64, 8), calculateCollatzSteps(6));
    try testing.expectEqual(@as(u64, 16), calculateCollatzSteps(7));
}

test "Collatz sequence for powers of 2" {
    const testing = std.testing;
    
    // Powers of 2 should take log2(n) steps
    try testing.expectEqual(@as(u64, 4), calculateCollatzSteps(16));
    try testing.expectEqual(@as(u64, 5), calculateCollatzSteps(32));
    try testing.expectEqual(@as(u64, 6), calculateCollatzSteps(64));
}

test "Collatz sequence for larger numbers" {
    const testing = std.testing;
    
    // Some larger numbers with known sequence lengths
    try testing.expectEqual(@as(u64, 19), calculateCollatzSteps(9));
    try testing.expectEqual(@as(u64, 118), calculateCollatzSteps(97));
    try testing.expectEqual(@as(u64, 23), calculateCollatzSteps(25));
}
