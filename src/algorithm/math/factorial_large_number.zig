//! Large number factorial calculator implementation in Zig.
//! 
//! Calculates factorial of large numbers using arbitrary precision arithmetic.
//! Supports numbers from small (5-20) to very large (1000+).
//!
//! The program accepts input either as command line argument or via stdin and outputs:
//! - The factorial calculation (n!)
//! - Execution time in milliseconds
//!
//! Time Complexity: O(n * m) where n is input number and m is result digit count
//! Space Complexity: O(m) where m is the number of digits in result
//!
//! Example:
//! Input: 5
//! Output: 5! = 120
//! Time taken: 0.0123 ms
//! 
//! To run the code:
//! zig run src/algorithm/math/factorial_large_number.zig
//! or
//! zig run src/algorithm/math/factorial_large_number.zig -- <number>
//! 
//! To test the code:
//! zig test src/algorithm/math/factorial_large_number.zig

const std = @import("std");

fn LargeNum(comptime Writer: type) type {
    return struct {
        digits: std.ArrayList(u8),
        writer: Writer,
        
        pub fn init(allocator: std.mem.Allocator, writer: Writer) !@This() {
            var digits = std.ArrayList(u8).init(allocator);
            try digits.append(1);
            return .{ .digits = digits, .writer = writer };
        }
        
        pub fn deinit(self: *@This()) void {
            self.digits.deinit();
        }
        
        pub fn addDigit(self: *@This(), value: u8) !void {
            if (value > 9) return error.DigitTooLarge;
            try self.digits.append(value);
        }
        
        pub fn multiply(self: *@This(), n: usize) !void {
            var carry: usize = 0;
            for (self.digits.items) |*digit| {
                const current_digit: usize = digit.*;
                const product: usize = current_digit * n + carry;
                digit.* = @intCast(product % 10);
                carry = product / 10;
            }
            
            while (carry != 0) {
                try self.addDigit(@intCast(carry % 10));
                carry /= 10;
            }
        }
        
        pub fn print(self: *const @This()) !void {
            var i = self.digits.items.len;
            while (i > 0) {
                i -= 1;
                try self.writer.print("{d}", .{self.digits.items[i]});
            }
        }
    };
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut();
    var bw = std.io.bufferedWriter(stdout_file.writer());
    const stdout = bw.writer();
    const stdin = std.io.getStdIn().reader();
    defer bw.flush() catch {};

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var arg_it = try std.process.argsWithAllocator(allocator);
    defer arg_it.deinit();
    
    _ = arg_it.next();
    
    var number: usize = undefined;
    if (arg_it.next()) |arg| {
        number = try std.fmt.parseInt(usize, arg, 10);
    } else {
        try stdout.print("Enter a number to calculate its factorial (recommended: 5-20 for testing, 50-100 for medium, 1000+ for large numbers): ", .{});
        try bw.flush(); // Add this line to flush the buffer
        var buf: [100]u8 = undefined;
        if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |user_input| {
            const trimmed = std.mem.trim(u8, user_input, &std.ascii.whitespace);
            number = try std.fmt.parseInt(usize, trimmed, 10);
        } else {
            return error.InvalidInput;
        }
    }

    var result = try LargeNum(@TypeOf(stdout)).init(allocator, stdout);
    defer result.deinit();

    const start_time = std.time.nanoTimestamp();
    
    var i: usize = 2;
    while (i <= number) : (i += 1) {
        try result.multiply(i);
    }
    
    const time_taken = @as(f64, @floatFromInt(std.time.nanoTimestamp() - start_time)) / 1e6;

    try stdout.print("{d}! = ", .{number});
    try result.print();
    try stdout.print("\nTime taken: {d:.4} ms\n", .{time_taken});
    try bw.flush();
}

test "LargeNum basic operations" {
    const allocator = std.testing.allocator;
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const writer = buf.writer();
    
    var num = try LargeNum(@TypeOf(writer)).init(allocator, writer);
    defer num.deinit();
    
    try num.addDigit(1);
    try num.multiply(2);
    try num.print();
    
    try std.testing.expectEqualStrings("22", buf.items);
}

test "factorial calculation" {
    const allocator = std.testing.allocator;
    var buf = std.ArrayList(u8).init(allocator);
    defer buf.deinit();
    const writer = buf.writer();
    
    var num = try LargeNum(@TypeOf(writer)).init(allocator, writer);
    defer num.deinit();
    
    var i: usize = 2;
    while (i <= 5) : (i += 1) {
        try num.multiply(i);
    }
    try num.print();
    
    try std.testing.expectEqualStrings("120", buf.items);
}