//! Palindrome Number Checker
//!
//! This module provides functionality to check if a given number is a palindrome.
//! A palindrome number reads the same backwards as forwards.
//!
//! **Main Function**: `isPalindrome(number: u32) -> bool`
//!
//! **Algorithm**:
//! 1. Convert the number to a string for comparison.
//! 2. Use two pointers to compare characters from both ends moving towards the center.
//! 3. If all corresponding characters match, the number is a palindrome.
//!
//! **Examples**:
//! - `isPalindrome(12321)` returns `true`
//! - `isPalindrome(12345)` returns `false`
//!
//! **Computational Complexity**:
//! - Time Complexity: O(n), where n is the number of digits in the number.
//! - Space Complexity: O(1), since we use a fixed-size buffer for conversion.
//!
//! The program includes:
//! - A command-line interface for entering a number to check for palindrome properties.
//! - Outputs whether the number is a palindrome and the computation time.
//!
//! **Usage**:
//! - To run the program:
//!   ```sh
//!   zig run src/algorithm/math/palindrome_number.zig
//!   ```
//! - To test the implementation:
//!   ```sh
//!   zig test src/algorithm/math/palindrome_number.zig
//!   ```

const std = @import("std");
const expect = std.testing.expect;

fn isPalindrome(number: u32) bool {
    if (number < 10) return true; // Numbers less than 10 are palindromes
    
    // Convert to string for safe comparison
    var buf: [20]u8 = undefined; // Large enough for max u32
    const num_str = std.fmt.bufPrint(&buf, "{d}", .{number}) catch return false;
    
    var left: usize = 0;
    var right: usize = num_str.len - 1;
    
    while (left < right) {
        if (num_str[left] != num_str[right]) {
            return false;
        }
        left += 1;
        right -= 1;
    }
    
    return true;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number: ");

    var buf: [100]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const trimmed = std.mem.trimRight(u8, line, " \t\r\n");
        
        if (std.fmt.parseInt(u32, trimmed, 10)) |num| {
            if (num > std.math.maxInt(u32)) {
                try stdout.writeAll("Number too large for u32\n");
                return;
            }

            const start = std.time.milliTimestamp();
            const result = isPalindrome(num);
            const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;

            if (result) {
                try stdout.print("{d} is a palindrome number (Computed in {d:.3}s)\n", .{num, duration});
            } else {
                try stdout.print("{d} is not a palindrome number (Computed in {d:.3}s)\n", .{num, duration});
            }
        } else |err| {
            try stdout.print("Error parsing input: {}\n", .{err});
        }
    }
}

test "palindrome number tests" {
    try expect(isPalindrome(0) == true);
    try expect(isPalindrome(1) == true);
    try expect(isPalindrome(12321) == true);
    try expect(isPalindrome(123321) == true);
    try expect(isPalindrome(4294967295) == false); // Max u32, not a palindrome
    try expect(isPalindrome(1234) == false);
    try expect(isPalindrome(12345) == false);
}