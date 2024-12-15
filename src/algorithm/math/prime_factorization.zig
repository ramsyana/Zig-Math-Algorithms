//! Prime Factorization
//! This program finds the prime factors of a given positive integer.
//! Algorithm:
//! 1. Start by factoring out 2s from the number since they are the smallest prime.
//! 2. Then, check odd numbers up to the square root of the number, skipping even numbers.
//! 3. If any divisor divides the number evenly, add it to the result array and reduce the number.
//! 4. If a remainder greater than 1 exists after processing all divisors, it is the last prime factor.
//!
//! Usage:
//! - Run the program to compute and display the prime factorization of a user-provided positive integer.
//!
//! Examples:
//! - Input: 30 → Output: 2-3-5
//! - Input: 100 → Output: 2-2-5-5
//! - Input: 17 → Output: 17 (prime number)
//!
//! Computational Complexity:
//! - Time Complexity: O(√n), where n is the input number
//! - Space Complexity: O(k), where k is the number of prime factors
//!
//! Testing:
//! - Includes unit tests to validate the correctness of prime factorization for various cases.
//!
//! To run the program:
//! zig run src/algorithm/math/prime_factorization.zig
//!
//! To test the implementation:
//! zig test src/algorithm/math/prime_factorization.zig

const std = @import("std");

const LEN: usize = 10;
const STEP: usize = 5;

const Range = struct {
    range: []i32,
    length: usize,
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator) !*Range {
        const self = try allocator.create(Range);
        errdefer allocator.destroy(self);
        self.range = try allocator.alloc(i32, LEN);
        self.length = 0;
        self.allocator = allocator;
        return self;
    }

    fn deinit(self: *Range) void {
        self.allocator.free(self.range);
        self.allocator.destroy(self);
    }

    fn increase(self: *Range) !void {
        const new_capacity = self.range.len + STEP;
        self.range = try self.allocator.realloc(self.range, new_capacity);
    }
};

/// Performs prime factorization of the given number.
/// Returns a pointer to a Range struct containing the factors.
fn intFact(allocator: std.mem.Allocator, n: i32) !*Range {
    if (n <= 1) return error.InvalidInput; // Input must be greater than 1

    var result = try Range.init(allocator);
    errdefer result.deinit();
    var num = n;
    var i: usize = 0;

    // Factor out all 2s for efficiency
    while (@mod(num, 2) == 0) {
        if (i >= result.range.len) try result.increase();
        result.range[i] = 2;
        i += 1;
        num = @divTrunc(num, 2);
    }

    // Check for odd factors up to sqrt(num)
    var j: i32 = 3;
    while (j * j <= num) {
        while (@mod(num, j) == 0) {
            if (i >= result.range.len) try result.increase();
            result.range[i] = j;
            i += 1;
            num = @divTrunc(num, j);
        }
        j += 2; // Only check odd numbers after 2
    }

    // If num is greater than 1 at this point, it's prime
    if (num > 1) {
        if (i >= result.range.len) try result.increase();
        result.range[i] = num;
        i += 1;
    }

    result.length = i;
    return result;
}

/// Prints the array of factors in a formatted string.
fn printArr(r: *Range, writer: anytype) !void {
    try writer.print("\n", .{});
    for (0..r.length) |idx| {
        if (idx > 0) try writer.print("-", .{});
        try writer.print("{d}", .{r.range[idx]});
    }
    try writer.print("\n", .{});
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.print("Enter a positive integer greater than 1: ", .{});

    var buf: [100]u8 = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
        const trimmed_input = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        
        const n = std.fmt.parseInt(i32, trimmed_input, 10) catch |err| {
            try stdout.print("Invalid input: {s}. Please enter a positive integer greater than 1.\n", .{@errorName(err)});
            return err;
        };
        
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var r = try intFact(allocator, n);
        defer r.deinit();

        try stdout.print("\nThe factorization of {d} is:", .{n});
        try printArr(r, stdout);
    } else {
        try stdout.print("No input provided.\n", .{});
        return error.EOF;
    }
}

test "prime factorization" {
    const testing = std.testing;
    const allocator = testing.allocator;

    // Test case 1: Prime number
    {
        const r = try intFact(allocator, 5);
        defer r.deinit();
        try testing.expectEqual(@as(usize, 1), r.length);
        try testing.expectEqual(@as(i32, 5), r.range[0]);
    }

    // Test case 2: Composite number
    {
        const r = try intFact(allocator, 100);
        defer r.deinit();
        try testing.expectEqual(@as(usize, 4), r.length);
        try testing.expectEqual(@as(i32, 2), r.range[0]);
        try testing.expectEqual(@as(i32, 2), r.range[1]);
        try testing.expectEqual(@as(i32, 5), r.range[2]);
        try testing.expectEqual(@as(i32, 5), r.range[3]);
    }

    // Test case 3: Power of 2
    {
        const r = try intFact(allocator, 16);
        defer r.deinit();
        try testing.expectEqual(@as(usize, 4), r.length);
        try testing.expectEqualSlices(i32, &.{2, 2, 2, 2}, r.range[0..r.length]);
    }

    // Test case 4: Product of different primes
    {
        const r = try intFact(allocator, 30);
        defer r.deinit();
        try testing.expectEqual(@as(usize, 3), r.length);
        try testing.expectEqualSlices(i32, &.{2, 3, 5}, r.range[0..r.length]);
    }

    // Test case 5: Large number with array resizing
    {
        const r = try intFact(allocator, 2310);
        defer r.deinit();
        try testing.expectEqual(@as(usize, 5), r.length);
        try testing.expectEqualSlices(i32, &.{2, 3, 5, 7, 11}, r.range[0..r.length]);
    }
}