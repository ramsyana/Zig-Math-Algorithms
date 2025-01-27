//! Arithmetic/Geometric Sequence Generator Implementation
//!
//! This module implements a function to generate either an arithmetic or geometric sequence
//! up to a given number of terms. The sequence type, start value, common difference/ratio,
//! and number of terms are provided as command-line arguments.
//!
//! Examples:
//! - Arithmetic Sequence:
//!   zig run src/algorithm/math/sequence_generator.zig -- --type arithmetic --start 2 --common_difference 3 --terms 10
//!   Output: 2, 5, 8, 11, 14, 17, 20, 23, 26, 29
//!
//! - Geometric Sequence:
//!   zig run src/algorithm/math/sequence_generator.zig -- --type geometric --start 2 --common_ratio 3 --terms 10
//!   Output: 2, 6, 18, 54, 162, 486, 1458, 4374, 13122, 39366
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/sequence_generator.zig -- --type <arithmetic|geometric> --start <start_value> --common_difference <difference> --terms <number_of_terms>
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/sequence_generator.zig
//!
//! Arithmetic Sequence:
//! zig run src/algorithm/math/sequence_generator.zig -- --type arithmetic --start 2 --common_difference 3 --terms 10
//! output: Generated Sequence: 2, 5, 8, 11, 14, 17, 20, 23, 26, 29
//!
//! Geometric Sequence:
//! zig run src/algorithm/math/sequence_generator.zig -- --type geometric --start 2 --common_ratio 3 --terms 10
//! Output: Generated Sequence: 2, 6, 18, 54, 162, 486, 1458, 4374, 13122, 39366
//!

const std = @import("std");

/// Generates an arithmetic sequence.
fn generateArithmeticSequence(start: i32, common_difference: i32, terms: u32) []i32 {
    var sequence = std.heap.page_allocator.alloc(i32, terms) catch unreachable;
    sequence[0] = start;

    for (sequence[1..], 0..) |*value, i| {
        value.* = sequence[i] + common_difference;
    }

    return sequence;
}

/// Generates a geometric sequence.
fn generateGeometricSequence(start: i32, common_ratio: i32, terms: u32) []i32 {
    var sequence = std.heap.page_allocator.alloc(i32, terms) catch unreachable;
    sequence[0] = start;

    for (sequence[1..], 0..) |*value, i| {
        value.* = sequence[i] * common_ratio;
    }

    return sequence;
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    if (args.len < 8) {
        try stdout.writeAll("Usage: zig run src/algorithm/math/sequence_generator.zig -- --type <arithmetic|geometric> --start <start_value> --common_difference <difference> --terms <number_of_terms>\n");
        return;
    }

    const sequence_type = args[2];
    const start = try std.fmt.parseInt(i32, args[4], 10);
    const common_value = try std.fmt.parseInt(i32, args[6], 10);
    const terms = try std.fmt.parseInt(u32, args[8], 10);

    var sequence: []i32 = undefined;

    if (std.mem.eql(u8, sequence_type, "arithmetic")) {
        sequence = generateArithmeticSequence(start, common_value, terms);
    } else if (std.mem.eql(u8, sequence_type, "geometric")) {
        sequence = generateGeometricSequence(start, common_value, terms);
    } else {
        try stdout.writeAll("Invalid sequence type. Use 'arithmetic' or 'geometric'.\n");
        return;
    }

    // In main()
    try stdout.print("Generated Sequence: ", .{});
    for (sequence, 0..) |value, i| {
        if (i > 0) try stdout.print(", ", .{});
        try stdout.print("{}", .{value});
    }

    try stdout.print("\n", .{});

    std.heap.page_allocator.free(sequence);
}

test "arithmetic sequence generator" {
    const sequence = generateArithmeticSequence(2, 3, 10);
    defer std.heap.page_allocator.free(sequence);

    const expected = [_]i32{ 2, 5, 8, 11, 14, 17, 20, 23, 26, 29 };
    for (sequence, 0..) |value, i| {
        try std.testing.expect(value == expected[i]);
    }
}

test "geometric sequence generator" {
    const sequence = generateGeometricSequence(2, 3, 10);
    defer std.heap.page_allocator.free(sequence);

    const expected = [_]i32{ 2, 6, 18, 54, 162, 486, 1458, 4374, 13122, 39366 };
    for (sequence, 0..) |value, i| {
        try std.testing.expect(value == expected[i]);
    }
}
