//! Pascal's Triangle Generator
//! -------------------------
//! A program to generate Pascal's triangle up to a specified number of rows.
//!
//! Pascal's Triangle Properties:
//! - Each number is the sum of the two numbers directly above it
//! - The edges of the triangle are always 1
//! - The triangle is symmetric
//! - Each row starts and ends with 1
//!
//! Example:
//!           1
//!          1 1
//!         1 2 1
//!        1 3 3 1
//!       1 4 6 4 1
//!
//! Functions:
//! generateRow(allocator: Allocator, prev_row: []const u64) ![]u64
//!     Generates the next row of Pascal's triangle
//!     Time complexity: O(n) where n is row number
//!
//! printTriangle(writer: Writer, rows: []const []const u64) !void
//!     Prints the triangle in a formatted manner
//!     Time complexity: O(n²) where n is number of rows
//!
//! Usage:
//! ```zig
//! const rows = 5;
//! try generatePascalsTriangle(allocator, rows);
//! ```
//!
//! Note: Currently supports up to 20 rows due to u64 limitations.
//! Numbers beyond that would require arbitrary precision integers.

const std = @import("std");

fn generateRow(allocator: std.mem.Allocator, prev_row: []const u64) ![]u64 {
    const new_size = prev_row.len + 1;
    var new_row = try allocator.alloc(u64, new_size);

    // First and last elements are always 1
    new_row[0] = 1;
    new_row[new_size - 1] = 1;

    // Calculate middle elements
    for (1..new_size - 1) |i| {
        new_row[i] = prev_row[i - 1] + prev_row[i];
    }

    return new_row;
}

fn printTriangle(writer: anytype, rows: []const []const u64) !void {
    const max_row_len = rows[rows.len - 1].len;

    for (rows, 0..) |row, i| {
        // Print leading spaces for alignment
        const spaces = max_row_len - i - 1;
        try writer.writeByteNTimes(' ', spaces * 2);

        // Print numbers in the row
        for (row, 0..) |num, j| {
            try writer.print("{d}", .{num});
            if (j < row.len - 1) {
                try writer.writeByteNTimes(' ', 2);
            }
        }
        try writer.writeByte('\n');
    }
}

fn generatePascalsTriangle(allocator: std.mem.Allocator, num_rows: u32) ![]const []const u64 {
    var rows = try allocator.alloc([]u64, num_rows);

    // First row is always [1]
    rows[0] = try allocator.alloc(u64, 1);
    rows[0][0] = 1;

    // Generate subsequent rows
    for (1..num_rows) |i| {
        rows[i] = try generateRow(allocator, rows[i - 1]);
    }

    return rows;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Print prompt
    try stdout.writeAll("Enter the number of rows for Pascal's Triangle (1-20): ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);

        if (std.fmt.parseInt(u32, trimmed_input, 10)) |rows| {
            if (rows == 0 or rows > 20) {
                try stdout.writeAll("Please enter a number between 1 and 20.\n");
                return;
            }

            const triangle = try generatePascalsTriangle(allocator, rows);
            defer {
                for (triangle) |row| {
                    allocator.free(row);
                }
                allocator.free(triangle);
            }

            try stdout.writeAll("\nPascal's Triangle:\n\n");
            try printTriangle(stdout, triangle);
        } else |_| {
            try stdout.writeAll("Invalid input. Please enter a valid number.\n");
        }
    }
}

test "generateRow function" {
    const testing = std.testing;
    const allocator = testing.allocator;

    const row1 = [_]u64{1};
    const row2 = try generateRow(allocator, &row1);
    defer allocator.free(row2);
    try testing.expectEqualSlices(u64, &[_]u64{ 1, 1 }, row2);

    const row3 = try generateRow(allocator, row2);
    defer allocator.free(row3);
    try testing.expectEqualSlices(u64, &[_]u64{ 1, 2, 1 }, row3);
}

test "generatePascalsTriangle function" {
    const testing = std.testing;
    const allocator = testing.allocator;

    const triangle = try generatePascalsTriangle(allocator, 4);
    defer {
        for (triangle) |row| {
            allocator.free(row);
        }
        allocator.free(triangle);
    }

    try testing.expectEqual(@as(usize, 4), triangle.len);
    try testing.expectEqualSlices(u64, &[_]u64{1}, triangle[0]);
    try testing.expectEqualSlices(u64, &[_]u64{ 1, 1 }, triangle[1]);
    try testing.expectEqualSlices(u64, &[_]u64{ 1, 2, 1 }, triangle[2]);
    try testing.expectEqualSlices(u64, &[_]u64{ 1, 3, 3, 1 }, triangle[3]);
}
