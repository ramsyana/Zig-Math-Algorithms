//! Euler's Totient Function Calculator
//!
//! This module calculates Euler's totient function φ(n), which counts the number of integers
//! between 1 and n that are coprime to n. Two numbers are coprime if their greatest common
//! divisor (GCD) equals 1.
//!
//! The main functions:
//! - totient(n: u32) -> u32
//!   Calculates Euler's totient function φ(n) for the given number.
//! - main() -> !void
//!   Provides an interactive interface to calculate φ(n) for user input.
//!
//! Algorithm for `totient`:
//! 1. Initialize result as n
//! 2. For each prime factor p of n:
//!    - Multiply result by (1 - 1/p)
//! 3. The final result is φ(n)
//!
//! Properties:
//! - For prime p: φ(p) = p - 1
//! - For coprime a,b: φ(ab) = φ(a)φ(b)
//! - For prime power p^k: φ(p^k) = p^k - p^(k-1)
//!
//! Examples:
//! - φ(12) = 4  // 1,5,7,11 are coprime to 12
//! - φ(7) = 6   // 1,2,3,4,5,6 are coprime to 7 (prime)
//!
//! To run the program:
//! zig run src/algorithm/math/euler_totient.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/euler_totient.zig

const std = @import("std");
const expect = std.testing.expect;

/// Calculates Euler's totient function φ(n)
/// Returns the count of numbers less than n that are coprime to n
pub fn totient(n: u32) u32 {
    var result = n;
    var num = n;

    var i: u32 = 2;
    while (i * i <= num) {
        if (num % i == 0) {
            while (num % i == 0) {
                num /= i;
            }
            result -= result / i;
        }
        i += 1;
    }
    if (num > 1) {
        result -= result / num;
    }
    return result;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("\nEuler's Totient Function Calculator\n\n", .{});
    try stdout.print("Enter a positive integer: ", .{});

    var buf: [100]u8 = undefined;
    const user_input = (try stdin.readUntilDelimiter(&buf, '\n'));
    const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);
    const n = try std.fmt.parseInt(u32, trimmed_input, 10);

    const phi = totient(n);
    try stdout.print("\nφ({}) = {}\n", .{ n, phi });
    try stdout.print("\nThis means there are {} numbers less than {} that are coprime to it.\n", .{ phi, n });
}

test "totient function basic cases" {
    try expect(totient(1) == 1); // φ(1) = 1
    try expect(totient(2) == 1); // φ(2) = 1
    try expect(totient(3) == 2); // φ(3) = 2
    try expect(totient(4) == 2); // φ(4) = 2
    try expect(totient(5) == 4); // φ(5) = 4
}

test "totient function prime numbers" {
    try expect(totient(7) == 6); // For prime p, φ(p) = p-1
    try expect(totient(11) == 10);
    try expect(totient(13) == 12);
}

test "totient function composite numbers" {
    try expect(totient(12) == 4); // 12: coprime numbers are 1,5,7,11
    try expect(totient(15) == 8); // 15: coprime numbers are 1,2,4,7,8,11,13,14
    try expect(totient(16) == 8); // 16: coprime numbers are 1,3,5,7,9,11,13,15
}
