//! Prime Number Checker
//!
//! This module provides functionality to check if a given number is a prime number.
//! A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself.
//!
//! The main function:
//! isPrime(x: i32) -> bool
//!
//! Algorithm:
//! 1. If the number is 2, it is prime.
//! 2. If the number is less than 2 or divisible by 2, it is not prime.
//! 3. Calculate the square root of the number.
//! 4. Check divisors from 3 up to the square root of the number, skipping even numbers.
//! 5. If any divisor evenly divides the number, it is not prime; otherwise, it is prime.
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
//! The program also includes a simple command-line interface to input a number
//! and check if it's prime, displaying the result.
//!
//! To run the program:
//! zig run src/algorithm/math/prime_checker.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/prime_checker.zig

const std = @import("std");
const math = std.math;

/// Check if a given number is prime number or not
fn isPrime(x: i32) bool {
    if (x == 2) {
        return true;
    }
    if (x < 2 or @rem(x, 2) == 0) {
        return false;
    }

    const squareRoot = math.floor(@sqrt(@as(f64, @floatFromInt(x))));

    var i: i32 = 3;
    while (i <= @as(i32, @intFromFloat(squareRoot))) : (i += 2) {
        if (@rem(x, i) == 0) {
            return false;
        }
    }
    return true;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a number to check if it's prime: ", .{});

    var buf: [10]u8 = undefined;
    @memset(&buf, 0);
    
    const user_input = try stdin.readUntilDelimiter(&buf, '\n');
    const input_trimmed = std.mem.trim(u8, user_input, &[_]u8{' ', '\r', '\n'});
    
    const num = try std.fmt.parseInt(i32, input_trimmed, 10);
    const result = isPrime(num);
    try stdout.print("{} is {s}.\n", .{ num, if (result) "prime" else "not prime" });
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
}