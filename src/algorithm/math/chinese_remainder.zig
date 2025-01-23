//! Chinese Remainder Theorem Implementation
//!
//! This module implements the Chinese Remainder Theorem (CRT) which finds a solution
//! to a system of linear congruences. Given a set of congruences:
//! x ≡ a₁ (mod n₁)
//! x ≡ a₂ (mod n₂)
//! ...
//! x ≡ aₖ (mod nₖ)
//!
//! Where all nᵢ are pairwise coprime, CRT finds x.
//!
//! Examples:
//! - Input: remainders [2, 3, 2], moduli [3, 5, 7]
//! - Output: 23 (smallest positive solution)
//!
//! To run the code, use the following command:
//! zig run src/algorithm/math/chinese_remainder.zig
//!
//! To test the code, use the following command:
//! zig test src/algorithm/math/chinese_remainder.zig

const std = @import("std");

// Extended Euclidean Algorithm to find GCD and Bezout's identity coefficients
fn extendedGcd(a: i64, b: i64) struct { gcd: i64, x: i64, y: i64 } {
    if (b == 0) {
        return .{ .gcd = a, .x = 1, .y = 0 };
    }
    const result = extendedGcd(b, @mod(a, b));
    const x = result.y;
    const y = result.x - @divTrunc(a, b) * result.y;
    return .{ .gcd = result.gcd, .x = x, .y = y };
}

// Modular multiplicative inverse
fn modInverse(a: i64, m: i64) !i64 {
    const result = extendedGcd(a, m);
    if (result.gcd != 1) return error.NoModularInverse;
    return @mod(result.x, m);
}

// Chinese Remainder Theorem implementation
/// Computes the solution to a system of linear congruences where the moduli are pairwise coprime
///
///  Given a set of congruences:
///  x ≡ a₁ (mod n₁)
///  x ≡ a₂ (mod n₂)
///  ...
///  x ≡ aₖ (mod nₖ)
///
/// The moduli nᵢ must be pairwise coprime.
fn chineseRemainder(remainders: []const i64, moduli: []const i64) !i64 {
    if (remainders.len == 0 or remainders.len != moduli.len) {
        return error.InvalidInput;
    }

    var result: i64 = 0;
    var product: i64 = 1;

    // Calculate product of all moduli
    for (moduli) |m| {
        product *= m;
    }

    // Apply CRT formula
    for (remainders, moduli) |rem, mod| {
        const p = @divExact(product, mod);
        const inv = try modInverse(p, mod);
        result += rem * p * inv;
    }

    return @mod(result, product);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // Example problem
    const remainders = [_]i64{ 2, 3, 2 };
    const moduli = [_]i64{ 3, 5, 7 };

    const result = try chineseRemainder(&remainders, &moduli);
    try stdout.print("Solution for the system:\n", .{});
    for (remainders, moduli) |rem, mod| {
        try stdout.print("x ≡ {d} (mod {d})\n", .{ rem, mod });
    }
    try stdout.print("is x = {d}\n", .{result});
}

test "chinese remainder theorem" {
    const remainders = [_]i64{ 2, 3, 2 };
    const moduli = [_]i64{ 3, 5, 7 };
    try std.testing.expectEqual(try chineseRemainder(&remainders, &moduli), 23);

    const remainders2 = [_]i64{ 1, 4, 6 };
    const moduli2 = [_]i64{ 3, 5, 7 };
    try std.testing.expectEqual(try chineseRemainder(&remainders2, &moduli2), 34);

    // Test error cases
    const invalid_remainders = [_]i64{1};
    const invalid_moduli = [_]i64{ 3, 5 };
    try std.testing.expectError(error.InvalidInput, chineseRemainder(&invalid_remainders, &invalid_moduli));

    //Test for case when NoModularInverse error is thrown.
    const remainders3 = [_]i64{ 1, 2 };
    const moduli3 = [_]i64{ 2, 4 };
    try std.testing.expectError(error.NoModularInverse, chineseRemainder(&remainders3, &moduli3));
}
