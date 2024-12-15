//! Trailing zeros in factorial calculator implementation in Zig.
//!
//! Calculates the number of trailing zeros in factorial of a given number.
//! Efficiently computes this without calculating the actual factorial by
//! counting factors of 5, since trailing zeros come from 2*5 pairs in 
//! prime factorization (and there are always more 2s than 5s).
//!
//! The program accepts input via stdin and outputs:
//! - The number of trailing zeros in n!
//!
//! Time Complexity: O(log n) where n is input number
//! Space Complexity: O(1) constant space
//!
//! Example:
//! Input: 25
//! Output: Number of trailing zeros in 25! is: 6
//!
//! To run the code:
//! zig run src/algorithm/math/factorial_trailing_zeroes.zig
//!
//! To test the code:
//! zig test src/algorithm/math/factorial_trailing_zeroes.zig

const std = @import("std");

fn countTrailingZerosInFactorial(n: u64) u64 {
    var count: u64 = 0;
    var power: u32 = 1;
    
    while (std.math.pow(u64, 5, power) <= n) {
        // Count multiples of 5^power in n
        count += @divFloor(n, std.math.pow(u64, 5, power));
        power += 1;
    }
    return count;
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    
    try stdout.print("Enter a number (1-1000): ", .{});
    
    var buf: [16]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
        const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        if (std.fmt.parseInt(u64, trimmed_input, 10)) |n| {
            if (n < 1 or n > 1000) {
                try stdout.print("Error: Number must be between 1 and 1000\n", .{});
                return;
            }
            const result = countTrailingZerosInFactorial(n);
            try stdout.print("Number of trailing zeros in {d}! is: {d}\n", .{n, result});
        } else |err| {
            try stdout.print("Error parsing input: {s}\n", .{@errorName(err)});
        }
    }
}

test "countTrailingZerosInFactorial" {
    try std.testing.expectEqual(@as(u64, 0), countTrailingZerosInFactorial(3));
    try std.testing.expectEqual(@as(u64, 1), countTrailingZerosInFactorial(5));
    try std.testing.expectEqual(@as(u64, 2), countTrailingZerosInFactorial(10));
    try std.testing.expectEqual(@as(u64, 6), countTrailingZerosInFactorial(25));
    try std.testing.expectEqual(@as(u64, 24), countTrailingZerosInFactorial(100));
    try std.testing.expectEqual(@as(u64, 249), countTrailingZerosInFactorial(1000));
}