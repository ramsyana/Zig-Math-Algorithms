//! Fast Fourier Transform (FFT) Implementation
//! ----------------------------------------
//! Efficiently computes the Discrete Fourier Transform (DFT) of a sequence.
//!
//! Mathematical Background:
//! - Transforms time/space domain signals into frequency domain
//! - Uses divide-and-conquer strategy (Cooley-Tukey algorithm)
//! - Reduces complexity from O(n²) to O(n log n)
//!
//! Example Applications:
//! - Signal processing
//! - Polynomial multiplication
//! - Data compression
//! - Spectral analysis
//!
//! Functions:
//! fft(allocator: Allocator, input: []const f64) ![]Complex
//!     Computes FFT of real-valued input sequence
//!     Time complexity: O(n log n)
//!
//! ifft(allocator: Allocator, input: []const Complex) ![]Complex
//!     Computes inverse FFT
//!     Time complexity: O(n log n)
//!
//! Usage:
//! ```zig
//! const input = [_]f64{ 1.0, 2.0, 3.0, 4.0 };
//! const result = try fft(allocator, &input);
//! ```
//!
//! Note: Input length must be a power of 2.

const std = @import("std");
const math = std.math;
const pi = math.pi;

pub const Complex = struct {
    re: f64,
    im: f64,

    pub fn init(re: f64, im: f64) Complex {
        return Complex{ .re = re, .im = im };
    }

    pub fn add(self: Complex, other: Complex) Complex {
        return Complex.init(
            self.re + other.re,
            self.im + other.im,
        );
    }

    pub fn sub(self: Complex, other: Complex) Complex {
        return Complex.init(
            self.re - other.re,
            self.im - other.im,
        );
    }

    pub fn mul(self: Complex, other: Complex) Complex {
        return Complex.init(
            self.re * other.re - self.im * other.im,
            self.re * other.im + self.im * other.re,
        );
    }

    pub fn scale(self: Complex, factor: f64) Complex {
        return Complex.init(
            self.re * factor,
            self.im * factor,
        );
    }
};

fn isPowerOfTwo(n: usize) bool {
    return n != 0 and (n & (n - 1)) == 0;
}

fn fftRecursive(allocator: std.mem.Allocator, input: []const Complex) ![]Complex {
    const n = input.len;
    if (n <= 1) {
        var result = try allocator.alloc(Complex, 1);
        result[0] = input[0];
        return result;
    }

    var even = try allocator.alloc(Complex, n / 2);
    var odd = try allocator.alloc(Complex, n / 2);
    defer allocator.free(even);
    defer allocator.free(odd);

    for (0..n / 2) |i| {
        even[i] = input[2 * i];
        odd[i] = input[2 * i + 1];
    }

    var even_fft = try fftRecursive(allocator, even);
    defer allocator.free(even_fft);
    const odd_fft = try fftRecursive(allocator, odd);
    defer allocator.free(odd_fft);

    var result = try allocator.alloc(Complex, n);
    const angle = -2.0 * pi / @as(f64, @floatFromInt(n));

    for (0..n / 2) |k| {
        const t = Complex.init(
            @cos(angle * @as(f64, @floatFromInt(k))),
            @sin(angle * @as(f64, @floatFromInt(k))),
        );
        const tOdd = t.mul(odd_fft[k]);
        result[k] = even_fft[k].add(tOdd);
        result[k + n / 2] = even_fft[k].sub(tOdd);
    }

    return result;
}

pub fn fft(allocator: std.mem.Allocator, input: []const f64) ![]Complex {
    if (!isPowerOfTwo(input.len)) {
        return error.InputLengthNotPowerOfTwo;
    }

    var complex_input = try allocator.alloc(Complex, input.len);
    defer allocator.free(complex_input);

    for (input, 0..) |value, i| {
        complex_input[i] = Complex.init(value, 0);
    }

    return fftRecursive(allocator, complex_input);
}

pub fn ifft(allocator: std.mem.Allocator, input: []const Complex) ![]Complex {
    const n = input.len;
    if (!isPowerOfTwo(n)) {
        return error.InputLengthNotPowerOfTwo;
    }

    var conjugate = try allocator.alloc(Complex, n);
    defer allocator.free(conjugate);

    for (input, 0..) |value, i| {
        conjugate[i] = Complex.init(value.re, -value.im);
    }

    var result = try fftRecursive(allocator, conjugate);
    const scale = 1.0 / @as(f64, @floatFromInt(n));

    for (result, 0..) |*value, i| {
        result[i] = Complex.init(value.re * scale, -value.im * scale);
    }

    return result;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Example input signal
    const input = [_]f64{ 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0 };

    try stdout.writeAll("Input signal: ");
    for (input) |value| {
        try stdout.print("{d:.1} ", .{value});
    }
    try stdout.writeByte('\n');

    const result = try fft(allocator, &input);
    defer allocator.free(result);

    try stdout.writeAll("\nFFT result:\n");
    for (result, 0..) |value, i| {
        try stdout.print("Frequency bin {d}: {d:.3}+{d:.3}i\n", .{ i, value.re, value.im });
    }
}

test "FFT of constant signal" {
    const testing = std.testing;
    const allocator = testing.allocator;

    const input = [_]f64{ 1.0, 1.0, 1.0, 1.0 };
    const result = try fft(allocator, &input);
    defer allocator.free(result);

    try testing.expectApproxEqAbs(result[0].re, 4.0, 1e-10);
    try testing.expectApproxEqAbs(result[0].im, 0.0, 1e-10);
    for (1..4) |i| {
        try testing.expectApproxEqAbs(result[i].re, 0.0, 1e-10);
        try testing.expectApproxEqAbs(result[i].im, 0.0, 1e-10);
    }
}

test "FFT inverse" {
    const testing = std.testing;
    const allocator = testing.allocator;

    const input = [_]f64{ 1.0, 2.0, 3.0, 4.0 };
    const fft_result = try fft(allocator, &input);
    defer allocator.free(fft_result);

    const ifft_result = try ifft(allocator, fft_result);
    defer allocator.free(ifft_result);

    for (input, 0..) |value, i| {
        try testing.expectApproxEqAbs(ifft_result[i].re, value, 1e-10);
        try testing.expectApproxEqAbs(ifft_result[i].im, 0.0, 1e-10);
    }
}
