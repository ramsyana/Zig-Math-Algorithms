//! Large Factorial Calculator Implementation
//!
//! This module provides functionality to calculate factorials of large numbers
//! using dynamic array-based arithmetic to handle numbers beyond the capacity of 
//! built-in integer types.
//!
//! The factorial of a non-negative integer n (denoted as n!) is the product
//! of all positive integers less than or equal to n:
//! n! = n × (n-1) × (n-2) × ... × 2 × 1
//!
//! Examples:
//! - 5! = 5 × 4 × 3 × 2 × 1 = 120
//! - 10! = 10 × 9 × 8 × 7 × 6 × 5 × 4 × 3 × 2 × 1 = 3,628,800
//!
//! The implementation uses a `std.ArrayList(u8)` to store individual digits, allowing
//! for the calculation of factorials that would overflow standard integer types.
//! Each digit is stored as a u8 since each digit can only range from 0 to 9.
//!
//! Computational Complexity:
//! - Time Complexity: O(N * M), where N is the input number and M is the number of digits in the result
//! - Space Complexity: O(M), where M is the number of digits in the result
//!
//! To run the program:
//! zig run src/algorithm/math/large_factorials.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/large_factorials.zig

const std = @import("std");
const print = std.debug.print;

// Function to calculate factorial with dynamic array size
pub fn calculateFactorial(allocator: std.mem.Allocator, N: u32) !std.ArrayList(u8) {
    // Start with result = 1
    var result = try std.ArrayList(u8).initCapacity(allocator, 1);
    errdefer result.deinit();
    try result.append(1);

    // Calculate factorial for each number from 2 to N
    var i: u32 = 2;
    while (i <= N) : (i += 1) {
        var carry: u32 = 0;
        var j: usize = 0;

        // Multiply each existing digit by i, accumulate carry
        while (j < result.items.len) : (j += 1) {
            const prod = @as(u64, result.items[j]) * i + carry;
            result.items[j] = @intCast(prod % 10);
            carry = @intCast(prod / 10);
        }

        // Append any remaining carry digits
        while (carry > 0) {
            try result.append(@intCast(carry % 10));
            carry /= 10;
        }
    }

    // Reverse the digits to get the correct order
    std.mem.reverse(u8, result.items);

    return result;
}

// Function to print factorial
pub fn printFactorial(stdout: std.fs.File.Writer, factorial_array: std.ArrayList(u8)) !void {
    // Print each digit from most significant to least significant
    for (factorial_array.items) |digit| {
        try stdout.print("{d}", .{digit});
    }
    try stdout.print("\n", .{});
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    try stdout.writeAll("Enter a number: ");

    var buf: [100]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |num_line| {
        const N = blk: {
            const trimmed = std.mem.trimRight(u8, num_line, " \t\r\n");
            break :blk std.fmt.parseInt(u32, trimmed, 10) catch |err| {
                try stdout.print("Error parsing number: {s}\n", .{@errorName(err)});
                return err;
            };
        };

        const start = std.time.milliTimestamp();
        var factorial_array = try calculateFactorial(allocator, N);
        defer factorial_array.deinit();

        try printFactorial(stdout, factorial_array);

        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
        try stdout.print("Factorial calculation completed in {d:.3}s\n", .{duration});
    }
}

test "Factorial Calculations" {
    const allocator = std.testing.allocator;

    // Test small factorials
    {
        var factorial_5 = try calculateFactorial(allocator, 5);
        defer factorial_5.deinit();

        // 5! = 120
        try std.testing.expectEqualSlices(u8, &[_]u8{1, 2, 0}, factorial_5.items);
    }

    // Test larger factorial
    {
        var factorial_10 = try calculateFactorial(allocator, 10);
        defer factorial_10.deinit();
        
        try std.testing.expect(factorial_10.items.len >= 7); // 10! has 7 digits
    }
}