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

fn countTrailingZeros(n: i32) i32 {
    var count: i32 = 0;
    var i: i32 = 1;
    
    while (true) {
        const divisor = std.math.pow(i32, 5, i);
        const result = @divFloor(n, divisor);
        if (result == 0) break;
        count += result;
        i += 1;
    }
    return count;
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    
    try stdout.print("Enter a number (1-1000): ", .{});
    
    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
        // Trim whitespace and newline characters
        const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        const n = try std.fmt.parseInt(i32, trimmed_input, 10);
        const result = countTrailingZeros(n);
        try stdout.print("Number of trailing zeros in {d}! is: {d}\n", .{n, result});
    }
}

test "countTrailingZeros" {
    try std.testing.expectEqual(@as(i32, 0), countTrailingZeros(3));
    try std.testing.expectEqual(@as(i32, 1), countTrailingZeros(5));
    try std.testing.expectEqual(@as(i32, 2), countTrailingZeros(10));
    try std.testing.expectEqual(@as(i32, 6), countTrailingZeros(25));
    try std.testing.expectEqual(@as(i32, 24), countTrailingZeros(100));
}