//! Knapsack Problem Solver
//! ----------------------
//! A program to solve the 0/1 Knapsack problem using dynamic programming.
//!
//! The 0/1 Knapsack problem:
//! Given a set of items, each with a weight and a value, determine which items to include
//! in a collection so that the total weight is less than or equal to a given limit (capacity)
//! and the total value is as large as possible.
//!
//! Mathematical Formulation:
//! - Maximize sum(v[i] * x[i]) where x[i] is 0 or 1 (include item or not)
//! - Subject to sum(w[i] * x[i]) <= W (total weight constraint)
//!
//! Algorithm Properties:
//! - Uses dynamic programming to build an optimal solution from optimal subproblems
//! - Avoids the exponential complexity of brute force approaches
//! - Handles the constraint that each item can only be used once (0/1)
//!
//! Example:
//! Items: [(weight=2, value=3), (weight=3, value=4), (weight=4, value=5), (weight=5, value=6)]
//! Capacity: 8
//! Solution: Select items 1, 2, and 4 for a total value of 13
//!
//! Functions:
//! knapsack(values: []const i32, weights: []const i32, capacity: i32) i32
//!     Solves the 0/1 Knapsack problem
//!     Time complexity: O(n * capacity) where n is the number of items
//!     Space complexity: O(n * capacity)
//!
//! Usage:
//! ```zig
//! const values = [_]i32{ 3, 4, 5, 6 };
//! const weights = [_]i32{ 2, 3, 4, 5 };
//! const capacity: i32 = 8;
//! const max_value = knapsack(&values, &weights, capacity); // returns 13
//! ```
//! To run the code, use the following command: 
//! zig run src/algorithm/math/knapsack.zig
//! 
//! To test the code, use the following command:
//! zig test src/algorithm/math/knapsack.zig
//! 
//! Note: Currently supports 32-bit signed integers.
//! Assumes all weights, values, and capacity are non-negative.

const std = @import("std");

/// Solves the 0/1 Knapsack problem using dynamic programming
/// Returns the maximum value that can be obtained with the given capacity
fn knapsack(values: []const i32, weights: []const i32, capacity: i32) i32 {
    const n = @as(i32, @intCast(values.len));
    
    // Create a 2D array for storing solutions to subproblems
    var dp = std.ArrayList([]i32).init(std.heap.page_allocator);
    defer dp.deinit();
    
    // Initialize the dp table
    var i: usize = 0;
    while (i <= @as(usize, @intCast(n))) : (i += 1) {
        const row = std.heap.page_allocator.alloc(i32, @as(usize, @intCast(capacity + 1))) catch unreachable;
        @memset(row, 0);
        dp.append(row) catch unreachable;
    }
    defer {
        for (dp.items) |row| {
            std.heap.page_allocator.free(row);
        }
    }
    
    // Fill the dp table
    i = 1;
    while (i <= @as(usize, @intCast(n))) : (i += 1) {
        var w: usize = 0;
        while (w <= @as(usize, @intCast(capacity))) : (w += 1) {
            if (weights[i - 1] <= @as(i32, @intCast(w))) {
                dp.items[i][w] = @max(
                    values[i - 1] + dp.items[i - 1][w - @as(usize, @intCast(weights[i - 1]))],
                    dp.items[i - 1][w]
                );
            } else {
                dp.items[i][w] = dp.items[i - 1][w];
            }
        }
    }
    
    return dp.items[@as(usize, @intCast(n))][@as(usize, @intCast(capacity))];
}

/// Solves the 0/1 Knapsack problem and returns both the maximum value
/// and the selected items (1 if selected, 0 if not)
fn knapsackWithItems(
    values: []const i32, 
    weights: []const i32, 
    capacity: i32, 
    selected_items: []i32
) i32 {
    const n = @as(i32, @intCast(values.len));
    
    // Create a 2D array for storing solutions to subproblems
    var dp = std.ArrayList([]i32).init(std.heap.page_allocator);
    defer dp.deinit();
    
    // Initialize the dp table
    var i: usize = 0;
    while (i <= @as(usize, @intCast(n))) : (i += 1) {
        const row = std.heap.page_allocator.alloc(i32, @as(usize, @intCast(capacity + 1))) catch unreachable;
        @memset(row, 0);
        dp.append(row) catch unreachable;
    }
    defer {
        for (dp.items) |row| {
            std.heap.page_allocator.free(row);
        }
    }
    
    // Fill the dp table
    i = 1;
    while (i <= @as(usize, @intCast(n))) : (i += 1) {
        var w: usize = 0;
        while (w <= @as(usize, @intCast(capacity))) : (w += 1) {
            if (weights[i - 1] <= @as(i32, @intCast(w))) {
                dp.items[i][w] = @max(
                    values[i - 1] + dp.items[i - 1][w - @as(usize, @intCast(weights[i - 1]))],
                    dp.items[i - 1][w]
                );
            } else {
                dp.items[i][w] = dp.items[i - 1][w];
            }
        }
    }
    
    // Backtrack to find the selected items
    var res = dp.items[@as(usize, @intCast(n))][@as(usize, @intCast(capacity))];
    var w: usize = @as(usize, @intCast(capacity));
    
    @memset(selected_items, 0);
    
    i = @as(usize, @intCast(n));
    while (i > 0 and res > 0) {
        if (res != dp.items[i - 1][w]) {
            selected_items[i - 1] = 1;
            res -= values[i - 1];
            w = w - @as(usize, @intCast(weights[i - 1]));
        }
        i -= 1;
    }
    
    return dp.items[@as(usize, @intCast(n))][@as(usize, @intCast(capacity))];
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    
    // Example problem
    const values = [_]i32{ 3, 4, 5, 6 };
    const weights = [_]i32{ 2, 3, 4, 5 };
    const capacity: i32 = 8;
    
    try stdout.print("Knapsack Problem Example:\n", .{});
    try stdout.print("Items (weight, value): ", .{});
    
    for (weights, values, 0..) |w, v, i| {
        try stdout.print("({d}, {d})", .{ w, v });
        if (i < weights.len - 1) {
            try stdout.print(", ", .{});
        }
    }
    try stdout.print("\n", .{});
    try stdout.print("Capacity: {d}\n\n", .{capacity});
    
    // Solve the problem
    var selected_items = try std.heap.page_allocator.alloc(i32, values.len);
    defer std.heap.page_allocator.free(selected_items);
    
    const max_value = knapsackWithItems(&values, &weights, capacity, selected_items);
    
    try stdout.print("Maximum value: {d}\n", .{max_value});
    try stdout.print("Selected items: ", .{});
    
    var total_weight: i32 = 0;
    for (selected_items, 0..) |selected, i| {
        if (selected == 1) {
            try stdout.print("Item {d} (weight={d}, value={d})", .{ i + 1, weights[i], values[i] });
            total_weight += weights[i];
            
            // Check if there are more selected items to print
            var more_items = false;
            for (selected_items[i + 1 ..]) |next_selected| {
                if (next_selected == 1) {
                    more_items = true;
                    break;
                }
            }
            
            if (more_items) {
                try stdout.print(", ", .{});
            }
        }
    }
    try stdout.print("\n", .{});
    try stdout.print("Total weight: {d}\n", .{total_weight});
}

test "knapsack function - basic case" {
    const testing = std.testing;
    const values = [_]i32{ 3, 4, 5, 6 };
    const weights = [_]i32{ 2, 3, 4, 5 };
    const capacity: i32 = 8;
    
    try testing.expectEqual(knapsack(&values, &weights, capacity), 10);
}

test "knapsack function - zero capacity" {
    const testing = std.testing;
    const values = [_]i32{ 3, 4, 5, 6 };
    const weights = [_]i32{ 2, 3, 4, 5 };
    const capacity: i32 = 0;
    
    try testing.expectEqual(knapsack(&values, &weights, capacity), 0);
}

test "knapsack function - single item" {
    const testing = std.testing;
    const values = [_]i32{10};
    const weights = [_]i32{5};
    
    try testing.expectEqual(knapsack(&values, &weights, 4), 0);
    try testing.expectEqual(knapsack(&values, &weights, 5), 10);
    try testing.expectEqual(knapsack(&values, &weights, 6), 10);
}

test "knapsack function - multiple items with exact capacity" {
    const testing = std.testing;
    const values = [_]i32{ 10, 40, 30, 50 };
    const weights = [_]i32{ 5, 4, 6, 3 };
    const capacity: i32 = 10;
    
    try testing.expectEqual(knapsack(&values, &weights, capacity), 90);
}

test "knapsackWithItems function" {
    const testing = std.testing;
    const values = [_]i32{ 3, 4, 5, 6 };
    const weights = [_]i32{ 2, 3, 4, 5 };
    const capacity: i32 = 8;
    
    const selected_items = testing.allocator.alloc(i32, values.len) catch unreachable;
    defer testing.allocator.free(selected_items);
    
    const max_value = knapsackWithItems(&values, &weights, capacity, selected_items);
    
    try testing.expectEqual(max_value, 10);
    
    // Check if the correct items were selected
    // For this example, items 1 and 3 should be selected (indices 1, 3)
    try testing.expectEqual(selected_items[0], 0);
    try testing.expectEqual(selected_items[1], 1);
    try testing.expectEqual(selected_items[2], 0);
    try testing.expectEqual(selected_items[3], 1);
}