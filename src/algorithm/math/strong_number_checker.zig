//! Strong Number Checker
//!
//! This module provides functionality to determine whether a given number is a "strong number."
//! A strong number is defined as a number where the sum of the factorials of its digits equals the number itself.
//!
//! The main functions:
//! - isStrong(number: i32) -> bool
//!   Determines if the given number is a strong number.
//! - main() -> !void
//!   Interacts with the user to input a number and checks if it is a strong number.
//!
//! Algorithm for `isStrong`:
//! 1. Return false if the number is negative.
//! 2. Extract each digit of the number by repeatedly dividing by 10.
//! 3. Calculate the factorial of each digit and add to a running sum.
//! 4. Compare the sum of the factorials to the original number.
//!
//! Examples:
//! - isStrong(145) = true  // 145 = 1! + 4! + 5!
//! - isStrong(543) = false // 543 != 5! + 4! + 3!
//!
//! To run the program:
//! zig run src/algorithm/math/strong_number_checker.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/strong_number_checker.zig

onst std = @import("std");
const expect = std.testing.expect;

fn isStrong(number: i32) bool {
    // Negative numbers are not strong numbers
    if (number < 0) return false;

    var sum: i32 = 0;
    var originalNumber = number;

    while (originalNumber != 0) {
        const remainder = @rem(originalNumber, 10);
        
        var factorial: i32 = 1;
        var i: i32 = 1;
        while (i <= remainder) : (i += 1) {
            factorial *= i;
        }

        sum += factorial;
        originalNumber = @divTrunc(originalNumber, 10);
    }

    return number == sum;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("\nStrong Number Checker\n\n", .{});
    try stdout.print("Enter a positive integer: ", .{});

    var buf: [100]u8 = undefined;
    const user_input = (try stdin.readUntilDelimiter(&buf, '\n'));
    const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);
    const n = try std.fmt.parseInt(i32, trimmed_input, 10);
    
    if (isStrong(n)) {
        try stdout.print("{} is a strong number!\n", .{n});
    } else {
        try stdout.print("{} is not a strong number.\n", .{n});
    }
}

test "strong number identification" {
    try expect(isStrong(145) == true);   // 145 = 1! + 4! + 5!
    try expect(isStrong(543) == false);  // 543 != 5! + 4! + 3!
}