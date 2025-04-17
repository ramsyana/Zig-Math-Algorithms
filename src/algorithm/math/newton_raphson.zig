//! Newton-Raphson Method
//! ---------------------
//! Finds the roots of a real-valued function using the Newton-Raphson iterative method.
//!
//! The Newton-Raphson method is an efficient technique for finding successively better approximations
//! to the roots (zeroes) of a real-valued function f(x).
//!
//! Mathematical Properties:
//! - Given a function f(x) and its derivative f'(x), the root is approximated by:
//!     x_{n+1} = x_n - f(x_n) / f'(x_n)
//! - Converges quadratically if the initial guess is close to the root and f'(x) ≠ 0
//!
//! Usage Example:
//! To find the square root of 2 (root of f(x) = x^2 - 2):
//! ```zig
//! const root = newtonRaphsonSquare(1.0, 1e-6, 100);
//! ```
//! To run the code: zig run src/algorithm/math/newton_raphson.zig
//! To test: zig test src/algorithm/math/newton_raphson.zig
//!
//! Note: The method requires the derivative of the function. Convergence is not guaranteed for all functions/guesses.

const std = @import("std");
const math = std.math;

// Instead of using function pointers, we'll create specific implementations
// for each function we want to find roots for

/// Newton-Raphson for finding square root of 2
pub fn newtonRaphsonSquare(
    initial_guess: f64,
    tol: f64,
    max_iter: usize,
) !f64 {
    var x = initial_guess;
    var i: usize = 0;
    while (i < max_iter) : (i += 1) {
        const fx = x * x - 2.0;  // f(x) = x^2 - 2
        const dfx = 2.0 * x;     // f'(x) = 2x
        if (math.approxEqAbs(f64, fx, 0.0, tol)) return x;
        if (math.approxEqAbs(f64, dfx, 0.0, 1e-12)) return error.DerivativeZero;
        const x_next = x - fx / dfx;
        if (math.approxEqAbs(f64, x, x_next, tol)) return x_next;
        x = x_next;
    }
    return error.NoConvergence;
}

/// Newton-Raphson for finding root of x^3 - x - 2
pub fn newtonRaphsonCubic(
    initial_guess: f64,
    tol: f64,
    max_iter: usize,
) !f64 {
    var x = initial_guess;
    var i: usize = 0;
    while (i < max_iter) : (i += 1) {
        const fx = x * x * x - x - 2.0;  // f(x) = x^3 - x - 2
        const dfx = 3.0 * x * x - 1.0;   // f'(x) = 3x^2 - 1
        if (math.approxEqAbs(f64, fx, 0.0, tol)) return x;
        if (math.approxEqAbs(f64, dfx, 0.0, 1e-12)) return error.DerivativeZero;
        const x_next = x - fx / dfx;
        if (math.approxEqAbs(f64, x, x_next, tol)) return x_next;
        x = x_next;
    }
    return error.NoConvergence;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    try stdout.writeAll("Newton-Raphson Root Finder\n");
    try stdout.writeAll("--------------------------\n");
    try stdout.writeAll("Choose function to solve:\n");
    try stdout.writeAll("1. f(x) = x^2 - 2 (sqrt(2))\n");
    try stdout.writeAll("2. f(x) = x^3 - x - 2\n");
    try stdout.writeAll("Enter 1 or 2: ");

    var buf: [16]u8 = undefined;
    var choice: u8 = 0;
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        const trimmed = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        if (trimmed.len == 1 and trimmed[0] == '1') {
            choice = 1;
        } else if (trimmed.len == 1 and trimmed[0] == '2') {
            choice = 2;
        } else {
            try stdout.writeAll("Invalid selection.\n");
            return;
        }
    } else {
        try stdout.writeAll("Input error.\n");
        return;
    }

    try stdout.writeAll("Enter initial guess (e.g. 1.0): ");
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        const trimmed = std.mem.trim(u8, user_input, &std.ascii.whitespace);
        if (std.fmt.parseFloat(f64, trimmed)) |guess| {
            try stdout.writeAll("Enter tolerance (e.g. 1e-6): ");
            if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |tol_input| {
                const tol_trimmed = std.mem.trim(u8, tol_input, &std.ascii.whitespace);
                if (std.fmt.parseFloat(f64, tol_trimmed)) |tol| {
                    const max_iter: usize = 100;
                    
                    // Call the appropriate function based on user choice
                    if (choice == 1) {
                        const result = newtonRaphsonSquare(guess, tol, max_iter) catch |err| {
                            switch (err) {
                                error.DerivativeZero => try stdout.writeAll("Derivative was zero. Cannot continue.\n"),
                                error.NoConvergence => try stdout.writeAll("Did not converge within max iterations.\n"),
                                else => return err,
                            }
                            return;
                        };
                        try stdout.print("Estimated root: {d:.8}\n", .{result});
                    } else if (choice == 2) {
                        const result = newtonRaphsonCubic(guess, tol, max_iter) catch |err| {
                            switch (err) {
                                error.DerivativeZero => try stdout.writeAll("Derivative was zero. Cannot continue.\n"),
                                error.NoConvergence => try stdout.writeAll("Did not converge within max iterations.\n"),
                                else => return err,
                            }
                            return;
                        };
                        try stdout.print("Estimated root: {d:.8}\n", .{result});
                    }
                } else |_| {
                    try stdout.writeAll("Invalid tolerance.\n");
                }
            }
        } else |_| {
            try stdout.writeAll("Invalid guess.\n");
        }
    }
}

test "sqrt(2) root" {
    const root = try newtonRaphsonSquare(1.0, 1e-8, 100);
    try std.testing.expectApproxEqAbs(root, math.sqrt(2.0), 1e-7);
}

test "cubic root" {
    const root = try newtonRaphsonCubic(1.5, 1e-8, 100);
    // The real root is about 1.52138
    try std.testing.expectApproxEqAbs(root, 1.521379707, 1e-7);
}

/// Special function for testing derivative zero case
/// f(x) = x^2 + 1 (has no real roots)
/// f'(x) = 2x (equals zero at x=0)
pub fn newtonRaphsonZeroDerivTest(
    initial_guess: f64,
    tol: f64,
    max_iter: usize,
) !f64 {
    var x = initial_guess;
    var i: usize = 0;
    while (i < max_iter) : (i += 1) {
        const fx = x * x + 1.0;  // f(x) = x^2 + 1
        const dfx = 2.0 * x;     // f'(x) = 2x
        if (math.approxEqAbs(f64, fx, 0.0, tol)) return x;
        if (math.approxEqAbs(f64, dfx, 0.0, 1e-12)) return error.DerivativeZero;
        const x_next = x - fx / dfx;
        if (math.approxEqAbs(f64, x, x_next, tol)) return x_next;
        x = x_next;
    }
    return error.NoConvergence;
}

test "no convergence" {
    // Use a function with derivative=0 at x=0
    const result = newtonRaphsonZeroDerivTest(0.0, 1e-12, 10);
    try std.testing.expectError(error.DerivativeZero, result);
}
