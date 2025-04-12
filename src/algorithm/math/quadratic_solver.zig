//! Quadratic Equation Solver
//! ----------------------
//! A program to solve quadratic equations in the form ax² + bx + c = 0.
//!
//! Mathematical Background:
//! - A quadratic equation is a polynomial equation of degree 2
//! - The standard form is ax² + bx + c = 0, where a ≠ 0
//! - Solutions are called roots or zeros of the equation
//!
//! Solution Formula (Quadratic Formula):
//! x = (-b ± √(b² - 4ac)) / (2a)
//!
//! Types of Solutions:
//! 1. Two distinct real roots: when b² - 4ac > 0
//! 2. One repeated real root: when b² - 4ac = 0
//! 3. Two complex roots: when b² - 4ac < 0
//!
//! Usage:
//! ```zig
//! const a: f64 = 1;
//! const b: f64 = -5;
//! const c: f64 = 6;
//! var roots = try solveQuadratic(a, b, c);
//! // For equation x² - 5x + 6 = 0
//! // roots will be {2, 3}
//! ```
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/quadratic_solver.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/quadratic_solver.zig

const std = @import("std");

/// Error type for quadratic equation solver
pub const QuadraticError = error{
    NotQuadratic, // When a = 0, making it a linear equation
    ComplexRoots, // When discriminant < 0, roots are complex
};

/// Result structure to hold the roots of the quadratic equation
pub const QuadraticRoots = struct {
    x1: f64,
    x2: f64,
};

/// Solves a quadratic equation ax² + bx + c = 0
/// Returns the roots in ascending order
/// Throws QuadraticError if a = 0 or if roots are complex
pub fn solveQuadratic(a: f64, b: f64, c: f64) QuadraticError!QuadraticRoots {
    // Check if equation is actually quadratic
    if (a == 0) {
        return QuadraticError.NotQuadratic;
    }

    // Calculate discriminant
    const discriminant = b * b - 4 * a * c;

    // Check for complex roots
    if (discriminant < 0) {
        return QuadraticError.ComplexRoots;
    }

    // Calculate roots using quadratic formula
    const sqrtDiscriminant = std.math.sqrt(discriminant);
    const x1 = (-b - sqrtDiscriminant) / (2 * a);
    const x2 = (-b + sqrtDiscriminant) / (2 * a);

    // Return roots in ascending order
    return QuadraticRoots{
        .x1 = @min(x1, x2),
        .x2 = @max(x1, x2),
    };
}

/// Prints the roots of a quadratic equation
pub fn printRoots(roots: QuadraticRoots) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("x₁ = {d:.6}\n", .{roots.x1});
    try stdout.print("x₂ = {d:.6}\n", .{roots.x2});
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Example: Solve x² - 5x + 6 = 0
    try stdout.writeAll("\nSolving quadratic equation: x² - 5x + 6 = 0\n");
    const roots = try solveQuadratic(1, -5, 6);
    try printRoots(roots);
}

test "quadratic equation solver" {
    const testing = std.testing;

    // Test case 1: Two distinct real roots
    // x² - 5x + 6 = 0 (roots: 2, 3)
    {
        const roots = try solveQuadratic(1, -5, 6);
        try testing.expectApproxEqAbs(roots.x1, 2, 1e-6);
        try testing.expectApproxEqAbs(roots.x2, 3, 1e-6);
    }

    // Test case 2: Repeated root
    // x² - 4x + 4 = 0 (root: 2, 2)
    {
        const roots = try solveQuadratic(1, -4, 4);
        try testing.expectApproxEqAbs(roots.x1, 2, 1e-6);
        try testing.expectApproxEqAbs(roots.x2, 2, 1e-6);
    }

    // Test case 3: Complex roots should return error
    // x² + x + 1 = 0
    {
        const result = solveQuadratic(1, 1, 1);
        try testing.expectError(QuadraticError.ComplexRoots, result);
    }

    // Test case 4: Not a quadratic equation (a = 0)
    {
        const result = solveQuadratic(0, 2, 1);
        try testing.expectError(QuadraticError.NotQuadratic, result);
    }
}
