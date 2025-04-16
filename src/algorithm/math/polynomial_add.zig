//! Polynomial Operations Implementation
//!
//! This module implements basic polynomial operations: addition, subtraction,
//! and multiplication. Polynomials are represented as arrays of coefficients,
//! where the index corresponds to the power of x. For example, [3, 2, 1]
//! represents 3 + 2x + 1x^2.
//!
//! Examples:
//! - Addition: [1, 2, 3] + [3, 4] = [4, 6, 3]
//! - Subtraction: [5, 0, 2] - [1, 2, 3] = [4, -2, -1]
//! - Multiplication: [1, 2] * [1, 1] = [1, 3, 2]
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/polynomial_add.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/polynomial_add.zig

const std = @import("std");
const expectEqual = std.testing.expectEqual;

/// Adds two polynomials and returns the result as a new ArrayList.
/// Each polynomial is represented as an array of coefficients.
fn addPoly(
    allocator: std.mem.Allocator,
    a: []const i64,
    b: []const i64,
) !std.ArrayList(i64) {
    const max_len = if (a.len > b.len) a.len else b.len;
    var result = try std.ArrayList(i64).initCapacity(allocator, max_len);
    for (0..max_len) |i| {
        const coeff_a = if (i < a.len) a[i] else 0;
        const coeff_b = if (i < b.len) b[i] else 0;
        try result.append(coeff_a + coeff_b);
    }
    return result;
}

/// Subtracts polynomial b from a and returns the result as a new ArrayList.
fn subPoly(
    allocator: std.mem.Allocator,
    a: []const i64,
    b: []const i64,
) !std.ArrayList(i64) {
    const max_len = if (a.len > b.len) a.len else b.len;
    var result = try std.ArrayList(i64).initCapacity(allocator, max_len);
    for (0..max_len) |i| {
        const coeff_a = if (i < a.len) a[i] else 0;
        const coeff_b = if (i < b.len) b[i] else 0;
        try result.append(coeff_a - coeff_b);
    }
    return result;
}

/// Multiplies two polynomials and returns the result as a new ArrayList.
fn mulPoly(
    allocator: std.mem.Allocator,
    a: []const i64,
    b: []const i64,
) !std.ArrayList(i64) {
    if (a.len == 0 or b.len == 0) {
        return std.ArrayList(i64).init(allocator);
    }
    const result_len = a.len + b.len - 1;
    var result = try std.ArrayList(i64).initCapacity(allocator, result_len);
    try result.resize(result_len);
    for (result.items) |*item| {
        item.* = 0;
    }
    for (a, 0..) |coeff_a, i| {
        for (b, 0..) |coeff_b, j| {
            result.items[i + j] += coeff_a * coeff_b;
        }
    }
    return result;
}

/// Helper function to print a polynomial in human-readable form.
fn printPoly(writer: anytype, poly: []const i64) !void {
    if (poly.len == 0) {
        try writer.writeAll("0\n");
        return;
    }
    var first = true;
    for (poly, 0..) |coeff, i| {
        if (coeff == 0) continue;
        if (!first) {
            try writer.writeAll(if (coeff > 0) " + " else " - ");
        } else if (coeff < 0) {
            try writer.writeAll("-");
        }
        const abs_coeff = if (coeff < 0) -coeff else coeff;
        if (abs_coeff != 1 or i == 0) {
            try writer.print("{d}", .{abs_coeff});
        }
        if (i > 0) {
            try writer.writeAll("x");
            if (i > 1) {
                try writer.print("^{d}", .{i});
            }
        }
        first = false;
    }
    if (first) {
        try writer.writeAll("0");
    }
    try writer.writeAll("\n");
}

/// Interactive function to get user input and perform polynomial operations.
pub fn interactiveMain() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll(
        \\Enter two polynomials as space-separated coefficients (lowest degree first).
        \\Example: 1 2 3 for 1 + 2x + 3x^2
        \\First polynomial: 
    );
    var buffer1: [128]u8 = undefined;
    const input1 = try stdin.readUntilDelimiterOrEof(&buffer1, '\n');
    if (input1 == null) return;

    try stdout.writeAll("Second polynomial: ");
    var buffer2: [128]u8 = undefined;
    const input2 = try stdin.readUntilDelimiterOrEof(&buffer2, '\n');
    if (input2 == null) return;

    var poly1: [32]i64 = undefined;
    var poly2: [32]i64 = undefined;
    var len1: usize = 0;
    var len2: usize = 0;

    var it1 = std.mem.tokenize(u8, input1.?, " \t\r\n");
    while (it1.next()) |num_str| {
        if (len1 >= poly1.len) break;
        poly1[len1] = std.fmt.parseInt(i64, num_str, 10) catch 0;
        len1 += 1;
    }
    var it2 = std.mem.tokenize(u8, input2.?, " \t\r\n");
    while (it2.next()) |num_str| {
        if (len2 >= poly2.len) break;
        poly2[len2] = std.fmt.parseInt(i64, num_str, 10) catch 0;
        len2 += 1;
    }

    try stdout.writeAll("Operation? (add/sub/mul): ");
    var op_buf: [8]u8 = undefined;
    const op_input = try stdin.readUntilDelimiterOrEof(&op_buf, '\n');
    if (op_input == null) return;
    const op = std.mem.trim(u8, op_input.?, &std.ascii.whitespace);

    var result: std.ArrayList(i64) = undefined;
    if (std.mem.eql(u8, op, "add")) {
        result = try addPoly(gpa.allocator(), poly1[0..len1], poly2[0..len2]);
    } else if (std.mem.eql(u8, op, "sub")) {
        result = try subPoly(gpa.allocator(), poly1[0..len1], poly2[0..len2]);
    } else if (std.mem.eql(u8, op, "mul")) {
        result = try mulPoly(gpa.allocator(), poly1[0..len1], poly2[0..len2]);
    } else {
        try stdout.writeAll("Unknown operation.\n");
        return;
    }
    defer result.deinit();

    try stdout.writeAll("Result: ");
    try printPoly(stdout, result.items);
}

pub fn main() !void {
    try interactiveMain();
}

test "Polynomial addition, subtraction, multiplication" {
    const allocator = std.testing.allocator;

    // Addition
    var add_res = try addPoly(allocator, &[_]i64{1, 2, 3}, &[_]i64{3, 4});
    defer add_res.deinit();
    try expectEqualSlices(i64, &[_]i64{4, 6, 3}, add_res.items);

    // Subtraction
    var sub_res = try subPoly(allocator, &[_]i64{5, 0, 2}, &[_]i64{1, 2, 3});
    defer sub_res.deinit();
    try expectEqualSlices(i64, &[_]i64{4, -2, -1}, sub_res.items);

    // Multiplication
    var mul_res = try mulPoly(allocator, &[_]i64{1, 2}, &[_]i64{1, 1});
    defer mul_res.deinit();
    try expectEqualSlices(i64, &[_]i64{1, 3, 2}, mul_res.items);
}

fn expectEqualSlices(comptime T: type, expected: []const T, actual: []const T) !void {
    try std.testing.expectEqual(expected.len, actual.len);
    for (expected, 0..) |v, i| {
        try std.testing.expectEqual(v, actual[i]);
    }
}