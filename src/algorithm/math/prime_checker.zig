//! Prime Number Checker
//!
//! This module provides functionality to check if a given number is a prime number.
//! A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself.
//!
//! The main function:
//! isPrime(x: u32) -> bool
//!
//! Algorithm:
//! 1. Numbers less than or equal to 1 are not prime.
//! 2. 2 is prime; all other even numbers are not prime.
//! 3. Calculate the ceiling of the square root of the number.
//! 4. Check for divisibility by odd numbers from 3 up to the square root.
//! 5. If any number divides evenly, the input is not prime; otherwise, it is prime.
//!
//! Examples:
//! - isPrime(1) = false
//! - isPrime(2) = true
//! - isPrime(17) = true
//! - isPrime(18) = false
//!
//! Computational Complexity:
//! - Time Complexity: O(√n), where n is the input number
//! - Space Complexity: O(1)
//!
//! The program includes a command-line interface for users to input a number 
//! and check if it's prime, displaying the result.
//!
//! To run the program:
//! zig run src/algorithm/math/prime_checker.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/prime_checker.zig

const std = @import("std");
const math = std.math;

/// Check if a given number is prime. Uses trial division up to the square root of the number.
/// Time complexity: O(√n)
fn isPrime(x: u32) bool {
    if (x <= 1) return false;
    if (x == 2) return true;
    if (x % 2 == 0) return false;

    // Updated type conversion syntax
    const squareRoot = @as(u32, @intFromFloat(@ceil(math.sqrt(@as(f64, @floatFromInt(x))))));
    
    var i: u32 = 3;
    while (i <= squareRoot) : (i += 2) {
        if (x % i == 0) {
            return false;
        }
    }
    return true;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a number to check if it's prime: ", .{});

    var buf: [100]u8 = undefined;
    const user_input = try stdin.readUntilDelimiterOrEof(&buf, '\n');
    const input_trimmed = std.mem.trim(u8, user_input orelse return error.InvalidInput, &[_]u8{' ', '\r', '\n'});
    
    const num = std.fmt.parseInt(u32, input_trimmed, 10) catch |err| {
        try stdout.print("Error parsing input: {s}\n", .{@errorName(err)});
        return;
    };
    const result = isPrime(num);
    try stdout.print("{d} is {s}.\n", .{ num, if (result) "prime" else "not prime" });
}

test "isPrime function" {
    try std.testing.expect(!isPrime(1));
    try std.testing.expect(isPrime(2));
    try std.testing.expect(isPrime(3));
    try std.testing.expect(!isPrime(4));
    try std.testing.expect(isPrime(5));
    try std.testing.expect(!isPrime(6));
    try std.testing.expect(isPrime(7));
    try std.testing.expect(!isPrime(8));
    try std.testing.expect(!isPrime(9));
    try std.testing.expect(!isPrime(10));
    try std.testing.expect(isPrime(11));
    try std.testing.expect(!isPrime(100));
    try std.testing.expect(isPrime(101));
    try std.testing.expect(isPrime(2147483647)); // max i32 - 1, but we use u32
}