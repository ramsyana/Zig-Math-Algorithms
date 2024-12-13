//! Large Factorial Calculator Implementation
//!
//! This module provides functionality to calculate factorials of large numbers
//! using array-based arithmetic to handle numbers beyond the capacity of 
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
//! The implementation uses an array to store individual digits, enabling
//! calculation of factorials that would overflow standard integer types.
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

pub fn calculateFactorial(allocator: std.mem.Allocator, N: u32) ![]u32 {
    
    var a = try allocator.alloc(u32, 16500);
    @memset(a, 0);
    a[0] = 1;
    
    for (2..N+1) |i| {
        var carry: u32 = 0;
        for (0..16500) |j| {
            const product = a[j] * @as(u32, @intCast(i)) + carry;
            a[j] = product % 10;
            carry = product / 10;
        }
    }

    return a;
}

pub fn printFactorial(stdout: std.fs.File.Writer, factorial_array: []u32) !void {
    
    var count: usize = 16499;
    while (count > 0 and factorial_array[count] == 0) : (count -= 1) {}

    if (count == 0 and factorial_array[0] == 0) {
        try stdout.print("0\n", .{});
        return;
    }

    var i = count;
    while (true) {
        try stdout.print("{d}", .{factorial_array[i]});
        if (i == 0) break;
        i -= 1;
    }
    try stdout.print("\n", .{});
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    try stdout.writeAll("Enter number of test cases : ");

    var buf: [100]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const T = blk: {
            const trimmed = std.mem.trimRight(u8, line, " \t\r\n");
            break :blk try std.fmt.parseInt(u32, trimmed, 10);
        };

        var test_case: u32 = 0;
        while (test_case < T) : (test_case += 1) {
            try stdout.writeAll("Enter a number : ");

            if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |num_line| {
                const N = blk: {
                    const trimmed = std.mem.trimRight(u8, num_line, " \t\r\n");
                    break :blk try std.fmt.parseInt(u32, trimmed, 10);
                };

                const start = std.time.milliTimestamp();
                const factorial_array = try calculateFactorial(allocator, N);
                defer allocator.free(factorial_array);

                try printFactorial(stdout, factorial_array);
                
                const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;
                try stdout.print("Factorial calculation completed in {d:.3}s\n", .{duration});
            }
        }
    }
}

test "Factorial Calculations" {

    const allocator = std.testing.allocator;

    // Test small factorials
    {
        const factorial_5 = try calculateFactorial(allocator, 5);
        defer allocator.free(factorial_5);
        
        // 5! = 120
        try std.testing.expectEqual(@as(u32, 0), factorial_5[0]);
        try std.testing.expectEqual(@as(u32, 2), factorial_5[1]);
        try std.testing.expectEqual(@as(u32, 1), factorial_5[2]);
        try std.testing.expectEqual(@as(u32, 0), factorial_5[3]);
    }

    // Test larger factorial
    {
        const factorial_10 = try calculateFactorial(allocator, 10);
        defer allocator.free(factorial_10);
        
        var count: usize = 16499;
        while (count > 0 and factorial_10[count] == 0) : (count -= 1) {}
        
        try std.testing.expect(count >= 6);
    }
}