//! Karatsuba Multiplication Algorithm
//! --------------------------------
//! Fast multiplication algorithm for large numbers.
//!
//! Mathematical Properties:
//! - Splits numbers into smaller parts
//! - Uses the formula: xy = (10^n)ac + (10^(n/2))(ad + bc) + bd
//! - Reduces multiplications from 4 to 3 for large numbers
//!
//! Example:
//! 1234 × 5678 = 7,006,652
//! Split into: (12 × 100 + 34) × (56 × 100 + 78)
//!
//! Functions:
//! karatsuba(x: []const u8, y: []const u8, allocator: Allocator) ![]u8
//!     Multiplies two large numbers using Karatsuba algorithm
//!     Time complexity: O(n^log₂3) ≈ O(n^1.585)
//!
//! Usage:
//! ```zig
//! const result = try karatsuba("1234", "5678", allocator);
//! ```
//!
//! Note: Input numbers should be provided as strings to handle arbitrary size.

const std = @import("std");

fn removeLeadingZeros(nums: []u8) []u8 {
    var start: usize = 0;
    while (start < nums.len and nums[start] == '0') {
        start += 1;
    }
    return if (start == nums.len) nums[nums.len - 1 .. nums.len] else nums[start..];
}

fn addStrings(allocator: std.mem.Allocator, num1: []const u8, num2: []const u8) ![]u8 {
    const max_len = @max(num1.len, num2.len);
    var result = try allocator.alloc(u8, max_len + 1);
    errdefer allocator.free(result);

    var carry: u8 = 0;
    var i: usize = 0;

    while (i < max_len) : (i += 1) {
        const d1 = if (i < num1.len) num1[num1.len - 1 - i] - '0' else 0;
        const d2 = if (i < num2.len) num2[num2.len - 1 - i] - '0' else 0;
        const sum = d1 + d2 + carry;
        result[max_len - i] = (sum % 10) + '0';
        carry = sum / 10;
    }
    result[0] = carry + '0';

    const trimmed = removeLeadingZeros(result);
    if (trimmed.ptr != result.ptr or trimmed.len != result.len) {
        const final = try allocator.alloc(u8, trimmed.len);
        @memcpy(final, trimmed);
        allocator.free(result);
        return final;
    }
    return trimmed;
}

fn subtractStrings(allocator: std.mem.Allocator, num1: []const u8, num2: []const u8) ![]u8 {
    // Ensure num1 is not shorter than num2
    if (num1.len < num2.len) {
        return error.NegativeResult;
    }

    var result = try allocator.alloc(u8, num1.len);
    errdefer allocator.free(result);

    var borrow: i8 = 0;
    var i: usize = 0;

    while (i < num1.len) : (i += 1) {
        const d1 = @as(i8, @intCast(num1[num1.len - 1 - i] - '0'));
        const d2 = if (i < num2.len) @as(i8, @intCast(num2[num2.len - 1 - i] - '0')) else 0;
        var diff = d1 - d2 - borrow;

        if (diff < 0) {
            diff += 10;
            borrow = 1;
        } else {
            borrow = 0;
        }
        result[num1.len - 1 - i] = @as(u8, @intCast(diff)) + '0';
    }

    // If there's still a borrow, the result would be negative
    if (borrow > 0) {
        allocator.free(result);
        return error.NegativeResult;
    }

    const trimmed = removeLeadingZeros(result);
    if (trimmed.ptr != result.ptr or trimmed.len != result.len) {
        const final = try allocator.alloc(u8, trimmed.len);
        @memcpy(final, trimmed);
        allocator.free(result);
        return final;
    }
    return result;
}

fn multiplyByPowerOf10(allocator: std.mem.Allocator, num: []const u8, zeros: usize) ![]u8 {
    if (num.len == 1 and num[0] == '0') return try allocator.dupe(u8, "0");
    var result = try allocator.alloc(u8, num.len + zeros);
    @memcpy(result[0..num.len], num);
    @memset(result[num.len..], '0');
    return result;
}

fn normalizeLengths(allocator: std.mem.Allocator, num1: []const u8, num2: []const u8) !struct { []u8, []u8 } {
    const max_len = @max(num1.len, num2.len);
    const padded_num1 = try allocator.alloc(u8, max_len);
    const padded_num2 = try allocator.alloc(u8, max_len);
    errdefer allocator.free(padded_num1);
    errdefer allocator.free(padded_num2);

    // Pad num1 with leading zeros
    @memset(padded_num1, '0');
    @memcpy(padded_num1[max_len - num1.len ..], num1);

    // Pad num2 with leading zeros
    @memset(padded_num2, '0');
    @memcpy(padded_num2[max_len - num2.len ..], num2);

    return .{ padded_num1, padded_num2 };
}

pub fn karatsuba(allocator: std.mem.Allocator, x: []const u8, y: []const u8) ![]u8 {
    // Normalize lengths to ensure consistent splitting
    const normalized = try normalizeLengths(allocator, x, y);
    defer allocator.free(normalized[0]);
    defer allocator.free(normalized[1]);

    const x_normalized = normalized[0];
    const y_normalized = normalized[1];

    // Base cases
    if (x_normalized.len == 1 and y_normalized.len == 1) {
        const product = (x_normalized[0] - '0') * (y_normalized[0] - '0');
        var result = try allocator.alloc(u8, if (product < 10) 1 else 2);
        if (product < 10) {
            result[0] = product + '0';
        } else {
            result[0] = (product / 10) + '0';
            result[1] = (product % 10) + '0';
        }
        return result;
    }

    const n = x_normalized.len;
    const m = (n + 1) / 2;

    // Split the numbers
    const x_high = x_normalized[0 .. x_normalized.len - m];
    const x_low = x_normalized[x_normalized.len - m ..];
    const y_high = y_normalized[0 .. y_normalized.len - m];
    const y_low = y_normalized[y_normalized.len - m ..];

    // Recursive steps
    const z0 = try karatsuba(allocator, x_low, y_low);
    defer allocator.free(z0);
    const z2 = try karatsuba(allocator, x_high, y_high);
    defer allocator.free(z2);

    // Calculate middle term
    const x_sum = try addStrings(allocator, x_low, x_high);
    defer allocator.free(x_sum);
    const y_sum = try addStrings(allocator, y_low, y_high);
    defer allocator.free(y_sum);
    const z1_full = try karatsuba(allocator, x_sum, y_sum);
    defer allocator.free(z1_full);

    // z1 = z1_full - z2 - z0
    const temp1 = try subtractStrings(allocator, z1_full, z2);
    defer allocator.free(temp1);
    const z1 = try subtractStrings(allocator, temp1, z0);
    defer allocator.free(z1);

    // Combine results
    const z2_shifted = try multiplyByPowerOf10(allocator, z2, 2 * m);
    defer allocator.free(z2_shifted);
    const z1_shifted = try multiplyByPowerOf10(allocator, z1, m);
    defer allocator.free(z1_shifted);
    const temp2 = try addStrings(allocator, z2_shifted, z1_shifted);
    defer allocator.free(temp2);
    return addStrings(allocator, temp2, z0);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var buf: [1024]u8 = undefined;

    // Get first number
    try stdout.writeAll("Enter first number: ");
    const num1_line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse return error.StreamTooShort;
    const x = try allocator.dupe(u8, std.mem.trim(u8, num1_line, &std.ascii.whitespace));
    defer allocator.free(x);

    // Get second number
    try stdout.writeAll("Enter second number: ");
    const num2_line = (try stdin.readUntilDelimiterOrEof(&buf, '\n')) orelse return error.StreamTooShort;
    const y = try allocator.dupe(u8, std.mem.trim(u8, num2_line, &std.ascii.whitespace));
    defer allocator.free(y);

    // Calculate and display result
    const result = try karatsuba(allocator, x, y);
    defer allocator.free(result);

    try stdout.print("\n{s} × {s} = {s}\n", .{ x, y, result });
}

test "karatsuba basic multiplication" {
    const testing = std.testing;
    const allocator = testing.allocator;
    const result1 = try karatsuba(allocator, "12", "34");
    defer allocator.free(result1);
    try testing.expectEqualStrings("408", result1);

    const result2 = try karatsuba(allocator, "1234", "5678");
    defer allocator.free(result2);
    try testing.expectEqualStrings("7006652", result2);
}

test "karatsuba with zeros" {
    const testing = std.testing;
    const allocator = testing.allocator;
    const result1 = try karatsuba(allocator, "100", "200");
    defer allocator.free(result1);
    try testing.expectEqualStrings("20000", result1);

    const result2 = try karatsuba(allocator, "0", "1234");
    defer allocator.free(result2);
    try testing.expectEqualStrings("0", result2);
}

test "karatsuba with different length numbers" {
    const testing = std.testing;
    const allocator = testing.allocator;
    const result1 = try karatsuba(allocator, "10", "20");
    defer allocator.free(result1);
    try testing.expectEqualStrings("200", result1);

    const result2 = try karatsuba(allocator, "999", "2");
    defer allocator.free(result2);
    try testing.expectEqualStrings("1998", result2);
}
