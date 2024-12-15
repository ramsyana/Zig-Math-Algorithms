//! Prime Number Counter
//! 
//! Reference: https://leetcode.com/problems/count-primes/description/
//!
//! This program provides functionality to count the number of prime numbers less than a given integer `n`.
//! The main function:
//! countPrimes(n: i32) -> i32
//! 
//! Algorithm:
//! 1. Use an optimized Sieve of Eratosthenes to efficiently find all prime numbers less than `n`.
//! 2. Allocate a boolean array to track whether numbers are prime.
//! 3. Mark non-prime numbers by iterating through multiples of each prime, starting from `i * (i + 1)`.
//! 4. Count the numbers marked as prime.
//!
//! Examples:
//! - countPrimes(10) = 4  // Primes: 2, 3, 5, 7 (primes less than 10)
//! - countPrimes(1) = 0
//! - countPrimes(100) = 25
//!
//! To run the program:
//! zig run src/algorithm/math/prime_counter.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/prime_counter.zig

const std = @import("std");

// Use a constant for the threshold for stack allocation
const STACK_THRESHOLD = 1000;

pub fn countPrimes(n: i32) !i32 {
    if (n <= 2) return 0;

    var is_prime: []bool = undefined;
    if (n <= STACK_THRESHOLD) {
        var stack_is_prime: [STACK_THRESHOLD]bool = undefined;
        @memset(&stack_is_prime, true);
        is_prime = stack_is_prime[0..@as(usize, @intCast(n))];
    } else {
        is_prime = try std.heap.page_allocator.alloc(bool, @as(usize, @intCast(n)));
        defer std.heap.page_allocator.free(is_prime);
        @memset(is_prime, true);
    }
    
    is_prime[0] = false;
    is_prime[1] = false;

    // Apply Sieve of Eratosthenes with optimization
    var i: usize = 2;
    while (i * i < @as(usize, @intCast(n))) : (i += 1) {
        if (is_prime[i]) {
            var j: usize = i * (i + 1);
            while (j < @as(usize, @intCast(n))) : (j += i) {
                is_prime[j] = false;
            }
        }
    }

    // Count prime numbers
    var prime_count: i32 = 0;
    for (is_prime[2..]) |is_prime_num| {
        if (is_prime_num) prime_count += 1;
    }

    return prime_count;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a number to count primes less than it: ", .{});

    var buf: [10]u8 = undefined;
    @memset(&buf, 0);
    
    const user_input = try stdin.readUntilDelimiterOrEof(&buf, '\n');
    if (user_input) |input| {
        const input_trimmed = std.mem.trim(u8, input, &[_]u8{' ', '\r', '\n'});
        const n = try std.fmt.parseInt(i32, input_trimmed, 10);
        if (n <= 0) {
            try stdout.print("Please enter a positive number.\n", .{});
            return;
        }
        
        const prime_count = try countPrimes(n);
        try stdout.print("Number of primes less than {}: {}\n", .{n, prime_count});
    } else {
        try stdout.print("No input provided.\n", .{});
    }
}

test "count primes test cases" {
    try std.testing.expectEqual(@as(i32, 4), try countPrimes(10));
    try std.testing.expectEqual(@as(i32, 0), try countPrimes(0));
    try std.testing.expectEqual(@as(i32, 0), try countPrimes(1));
    try std.testing.expectEqual(@as(i32, 0), try countPrimes(2));
    try std.testing.expectEqual(@as(i32, 1), try countPrimes(3));
    try std.testing.expectEqual(@as(i32, 2), try countPrimes(4));
    try std.testing.expectEqual(@as(i32, 2), try countPrimes(5));
    try std.testing.expectEqual(@as(i32, 3), try countPrimes(6));
    try std.testing.expectEqual(@as(i32, 3), try countPrimes(7));
    try std.testing.expectEqual(@as(i32, 4), try countPrimes(11));
    try std.testing.expectEqual(@as(i32, 25), try countPrimes(100));
}