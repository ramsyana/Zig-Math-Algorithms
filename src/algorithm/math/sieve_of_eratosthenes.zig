//! Sieve of Eratosthenes Prime Number Generator
//! ------------------------------------------
//! Implementation of the classical Sieve of Eratosthenes algorithm for finding prime numbers.
//!
//! The Sieve of Eratosthenes is an ancient algorithm for finding all prime numbers up to a given limit.
//! It works by iteratively marking the multiples of each prime number as composite (not prime).
//!
//! Mathematical Properties:
//! - A prime number is a natural number greater than 1 that is only divisible by 1 and itself
//! - The algorithm works by marking multiples of each prime number as composite
//! - It efficiently generates all primes up to a given limit
//!
//! Algorithm Steps:
//! 1. Create a boolean array "is_prime[0..n]" and initialize all entries it as true
//! 2. Mark 0 and 1 as non-prime
//! 3. Starting from p=2, mark all its multiples as composite
//! 4. Repeat step 3 for each unmarked number up to √n
//!
//! Functions:
//! sieve(limit: usize) ![]bool
//!     Generates array where index i is true if i is prime
//!     Time complexity: O(n log log n)
//!     Space complexity: O(n)
//!
//! power(x: i32, y: u32) i32
//!     Helper function for computations
//!     Time complexity: O(log y)
//!
//! Usage:
//! ```zig
//! const primes = try sieve(100);
//! // primes[i] is true if i is prime
//! ```
//!
//! To run: zig run src/algorithm/math/sieve_of_eratosthenes.zig
//! To test: zig test src/algorithm/math/sieve_of_eratosthenes.zig
//!
//! Note: Implemented for Zig version 0.13.0
//! Memory is allocated using page_allocator and must be freed after use.
//!
const std = @import("std");

fn power(x: i32, y: u32) i32 {
    var result: i32 = 1;
    var i: u32 = 0;
    while (i < y) : (i += 1) {
        result *= x;
    }
    return result;
}

fn sieve(limit: usize) ![]bool {
    var allocator = std.heap.page_allocator;
    var is_prime = try allocator.alloc(bool, limit + 1);
    @memset(is_prime, true);

    if (limit < 2) return is_prime;

    is_prime[0] = false;
    is_prime[1] = false;

    var n: usize = 2;
    while (n <= limit) : (n += 1) {
        if (is_prime[n]) {
            var multiple = n * n;
            while (multiple <= limit) : (multiple += n) {
                is_prime[multiple] = false;
            }
        }
    }
    return is_prime;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Enter a number: ");

    var buf: [10]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
        const number = try std.fmt.parseInt(usize, std.mem.trim(u8, user_input, &std.ascii.whitespace), 10);

        if (number < 2) {
            try stdout.writeAll("Enter a number greater than 1\n");
            return;
        }

        const primes = try sieve(number);
        defer std.heap.page_allocator.free(primes);

        var count: usize = 0;
        for (primes, 0..) |is_prime, i| {
            if (is_prime) {
                try stdout.print("{} ", .{i});
                count += 1;
            }
        }
        try stdout.print("\nFound {} primes\n", .{count});
    }
}

test "sieve basic" {
    const primes = try sieve(10);
    defer std.heap.page_allocator.free(primes);
    try std.testing.expect(!primes[0]);
    try std.testing.expect(!primes[1]);
    try std.testing.expect(primes[2]);
    try std.testing.expect(primes[3]);
    try std.testing.expect(primes[5]);
    try std.testing.expect(primes[7]);
}
