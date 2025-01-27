//! Happy Number Checker Implementation
//!
//! This module implements a function to check if a given number is a happy number.
//! A happy number is a number that eventually reaches 1 when replaced by the sum of the squares of its digits.
//! If it loops endlessly in a cycle that does not include 1, it is not a happy number.
//!
//! Examples:
//! - Input: 19 -> Output: true (1² + 9² = 82 → 8² + 2² = 68 → 6² + 8² = 100 → 1² + 0² + 0² = 1)
//! - Input: 4  -> Output: false (4 → 16 → 37 → 58 → 89 → 145 → 42 → 20 → 4 → ...)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/happy_number.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/happy_number.zig

const std = @import("std");

/// Checks if a number is a happy number.
/// A happy number eventually reaches 1 when replaced by the sum of the squares of its digits.
fn isHappyNumber(n: u32) !bool {
    var seen = std.AutoHashMap(u32, void).init(std.heap.page_allocator);
    defer seen.deinit();

    var current = n;
    while (current != 1) {
        if (seen.contains(current)) {
            return false; // Detected a cycle, not a happy number
        }
        try seen.put(current, {});

        var sum: u32 = 0;
        var temp = current;
        while (temp > 0) {
            const digit = temp % 10;
            sum += digit * digit;
            temp /= 10;
        }
        current = sum;
    }
    return true; // Reached 1, it's a happy number
}

/// Entry point of the program.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number to check if it is a happy number: ");

    var buf: [10]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        const trimmed = std.mem.trim(u8, input, &std.ascii.whitespace);
        const number = try std.fmt.parseInt(u32, trimmed, 10);

        if (try isHappyNumber(number)) {
            try stdout.print("{} is a happy number.\n", .{number});
        } else {
            try stdout.print("{} is not a happy number.\n", .{number});
        }
    }
}

test "happy number checker" {
    // Known happy numbers
    try std.testing.expect(try isHappyNumber(19));
    try std.testing.expect(try isHappyNumber(7));
    try std.testing.expect(try isHappyNumber(10));

    // Non-happy numbers
    try std.testing.expect(!(try isHappyNumber(4)));
    try std.testing.expect(!(try isHappyNumber(20)));
    try std.testing.expect(!(try isHappyNumber(16)));

    // Edge cases
    try std.testing.expect(try isHappyNumber(1));
    try std.testing.expect(!(try isHappyNumber(0)));
}
