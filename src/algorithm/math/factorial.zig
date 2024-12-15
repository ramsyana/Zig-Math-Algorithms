//! Large Factorial Number Calculator Implementation
//!
//! This module implements a factorial calculator that can handle large numbers
//! beyond the limits of standard integer types. It uses an array-based approach
//! to store individual digits of the result, allowing for calculation of very
//! large factorials (e.g., 100!).
//!
//! The algorithm multiplies numbers digit by digit and handles carries manually,
//! similar to how we do multiplication by hand. This approach avoids integer
//! overflow issues that would occur with standard integer types.
//!
//! Examples:
//! - Input: 5  -> Output: 120
//! - Input: 10 -> Output: 3628800
//! - Input: 20 -> Output: 2432902008176640000
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/factorial.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/factorial.zig

const std = @import("std");
const testing = std.testing;
const ArrayList = std.ArrayList;

pub fn calculateFactorial(allocator: std.mem.Allocator, n: i32) !ArrayList(u8) {
    if (n < 0) return error.NegativeNumber;
    if (n == 0) {
        var result = try ArrayList(u8).initCapacity(allocator, 1);
        try result.append(1);
        return result;
    }
    
    const digits_float = @ceil(@log10(@as(f64, @floatFromInt(n)) * std.math.sqrt(2 * std.math.pi * @as(f64, @floatFromInt(n))) * std.math.pow(f64, @as(f64, @floatFromInt(n)) / std.math.e, @as(f64, @floatFromInt(n))) + 1/2 * std.math.log10(2 * std.math.pi * @as(f64, @floatFromInt(n)))));
    if (digits_float > @as(f64, @floatFromInt(std.math.maxInt(usize)))) {
        return error.Overflow;
    }
    const digits = @min(@as(usize, @intFromFloat(digits_float)) + 1, std.math.maxInt(usize));
    
    var result = try ArrayList(u8).initCapacity(allocator, digits);
    try result.append(1);
    var counter: usize = 0;
    
    var current = n;
    while (current >= 2) : (current -= 1) {
        var carry: u32 = 0;
        var i: usize = 0;
        while (i <= counter) : (i += 1) {
            const curr_u32 = @as(u32, @intCast(@abs(current)));
            carry += result.items[i] * curr_u32;
            result.items[i] = @intCast(carry % 10);
            carry /= 10;
        }

        while (carry > 0) {
            counter += 1;
            try result.append(@intCast(carry % 10));
            carry /= 10;
        }
    }
    return result;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    
    const stdout = std.io.getStdOut().writer();
    try stdout.writeAll("Enter a whole number to find its factorial: ");

    var buffer: [10]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const input = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    if (input) |trimmed_input| {
        const n = std.fmt.parseInt(i32, std.mem.trim(u8, trimmed_input, &std.ascii.whitespace), 10) catch |err| {
            try stdout.print("Invalid input: {s}\n", .{@errorName(err)});
            return;
        };

        var result = try calculateFactorial(allocator, n);
        defer result.deinit();

        var i: usize = result.items.len;
        while (i > 0) {
            i -= 1;
            try stdout.print("{d}", .{result.items[i]});
        }
        try stdout.print("\n", .{});
    }
}

test "factorial of 0" {
    var result = try calculateFactorial(testing.allocator, 0);
    defer result.deinit();
    try testing.expectEqual(@as(usize, 1), result.items.len);
    try testing.expectEqual(@as(u8, 1), result.items[0]);
}

test "factorial of 5" {
    var result = try calculateFactorial(testing.allocator, 5);
    defer result.deinit();
    const expected = [_]u8{ 0, 2, 1 }; // 120
    try testing.expectEqualSlices(u8, &expected, result.items);
}

test "factorial of 10" {
    var result = try calculateFactorial(testing.allocator, 10);
    defer result.deinit();
    const expected = [_]u8{ 0, 0, 8, 8, 2, 6, 3 }; // 3628800
    try testing.expectEqualSlices(u8, &expected, result.items);
}

test "negative factorial" {
    try testing.expectError(error.NegativeNumber, calculateFactorial(testing.allocator, -1));
}