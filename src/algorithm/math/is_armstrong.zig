//! Armstrong Number Verification Implementation
//!
//! This module provides functionality to determine whether a given number 
//! is an Armstrong number (narcissistic number). An Armstrong number is a 
//! number that is the sum of its own digits each raised to the power of 
//! the number of digits.
//!
//! An Armstrong number has the following unique property:
//! For a number with n digits (d1, d2, ..., dn), the sum of each digit 
//! raised to the nth power equals the original number.
//!
//! Examples:
//! - 153 is an Armstrong number (1³ + 5³ + 3³ = 153)
//! - 370 is an Armstrong number (3³ + 7³ + 0³ = 370)
//! - 371 is an Armstrong number (3³ + 7³ + 1³ = 371)
//! - 1634 is a 4-digit Armstrong number (1⁴ + 6⁴ + 3⁴ + 4⁴ = 1634)
//!
//! Computational Complexity:
//! - Time Complexity: O(d²), where 'd' is the number of digits in the number (log10(num))
//! - Space Complexity: O(1), as only a fixed amount of additional memory is used
//!
//! To run the program:
//! zig run src/algorithm/math/is_armstrong.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/is_armstrong.zig

const std = @import("std");
const math = std.math;

const BUFFER_SIZE = 100;

/// Checks if a number is an Armstrong number.
/// An Armstrong number is a number that is the sum of its own digits each 
/// raised to the power of the number of digits.
fn isArmstrongNumber(num: u32) bool {
    // Explicitly handle 0 as a special case
    if (num == 0) return false;

    var temp = num;
    var digit_count: u32 = 0;
    while (temp > 0) : (temp /= 10) {
        digit_count += 1;
    }

    temp = num;
    var sum: u64 = 0; // Use u64 to prevent overflow
    
    while (temp > 0) : (temp /= 10) {
        const digit = temp % 10;
        
        // Safe power calculation with overflow check
        var power: u64 = 1;
        for (0..digit_count) |_| {
            const new_power = power * digit;
            if (new_power > std.math.maxInt(u32)) return false; // Prevent overflow
            power = new_power;
        }
        
        // Check for overflow before adding
        if (sum > std.math.maxInt(u32) - power) return false;
        sum += power;
        
        // Early exit if sum exceeds original number
        if (sum > num) return false;
    }

    return sum == num;
}

/// Main function to handle user input and output.
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Enter a number: ");

    var buf: [BUFFER_SIZE]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const trimmed = std.mem.trimRight(u8, line, " \t\r\n");
        const num = std.fmt.parseInt(u32, trimmed, 10) catch |err| {
            try stdout.print("Invalid input: {s}\n", .{@errorName(err)});
            return;
        };

        const start = std.time.milliTimestamp();
        const result = isArmstrongNumber(num);
        const duration = @as(f64, @floatFromInt(std.time.milliTimestamp() - start)) / 1000.0;

        if (result) {
            try stdout.print("{d} is an Armstrong number (Computed in {d:.3}s)\n", .{num, duration});
        } else {
            try stdout.print("{d} is not an Armstrong number (Computed in {d:.3}s)\n", .{num, duration});
        }
    }
}

test "Armstrong number calculations" {
    try std.testing.expect(isArmstrongNumber(153) == true);
    try std.testing.expect(isArmstrongNumber(370) == true);
    try std.testing.expect(isArmstrongNumber(371) == true);
    try std.testing.expect(isArmstrongNumber(407) == true);
    try std.testing.expect(isArmstrongNumber(1634) == true);  

    try std.testing.expect(isArmstrongNumber(123) == false);
    try std.testing.expect(isArmstrongNumber(1233) == false);
    try std.testing.expect(isArmstrongNumber(0) == false); // Edge case
    try std.testing.expect(isArmstrongNumber(std.math.maxInt(u32)) == false); // Practical large number
}