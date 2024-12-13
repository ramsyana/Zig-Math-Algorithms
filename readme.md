# Zig Math Algorithms

A collection of mathematical algorithms implemented in Zig, designed to address specific mathematical problems with simple command-line interfaces.

## 🧮 Available Algorithms

| Algorithm | Description | Command | Example Output |
|-----------|-------------|---------|----------------|
| Prime Number Checker | Checks if a number is prime | `zig run src/algorithm/math/prime_checker.zig` | 17 is prime. |
| Armstrong Number Checker | Verifies Armstrong numbers | `zig run src/algorithm/math/is_armstrong.zig` | 153 is an Armstrong number. |
| Strong Number Checker | Checks if sum of digit factorials equals the number | `zig run src/algorithm/math/strong_number_checker.zig` | 145 is a strong number! |
| Fibonacci Number Calculator | Calculates nth Fibonacci number | `zig run src/algorithm/math/fibonacci.zig` | Fib(10) = 55 |
| Factorial Calculator | Calculates factorial of a number | `zig run src/algorithm/math/factorial.zig` | 120 |
| GCD and LCM Calculator | Finds Greatest Common Divisor and Least Common Multiple | `zig run src/algorithm/math/gcd_lcm_calculator.zig` | GCD: 5 |
| Prime Factorization | Computes prime factors of a number | `zig run src/algorithm/math/prime_factorization.zig` | 2-3-5 |
| Collatz Conjecture | Determines steps to reach 1 in Collatz sequence | `zig run src/algorithm/math/collatz_conjecture.zig` | Number of steps: 6 |
| Cantor Set Generator | Generates Cantor set levels | `zig run src/algorithm/math/cantor_set.zig -- 0 1 3` | Levels of Cantor set |
| Catalan Number Calculator | Calculates nth Catalan number | `zig run src/algorithm/math/catalan.zig` | 16796.00 |
| Euclidean Algorithm | Finds GCD and coefficients | `zig run src/algorithm/math/euclidean_algorithm_extended.zig` | GCD: 1, x: -2, y: 3 |
| Linear Interpolation | Performs linear interpolation | `zig run src/algorithm/math/linear_interpolation.zig` | lerp(0.0, 10.0, 0.5) = 5.0 |
| Palindrome Number Checker | Checks if a number is a palindrome | `zig run src/algorithm/math/palindrome_number.zig` | 12321 is a palindrome number. |
| Trailing Zeros in Factorial | Counts trailing zeros in factorial | `zig run src/algorithm/math/factorial_trailing_zeroes.zig` | 6 trailing zeros in 25! |
| Prime Counter | Counts primes less than a given number | `zig run src/algorithm/math/prime_counter.zig` | 4 primes less than 10 |

## 🚀 Prerequisites

- Zig compiler (latest version recommended)

## 🔧 Running the Algorithms

To run any algorithm, use the Zig run command followed by the specific algorithm file path. For example:

```shell
zig run src/algorithm/math/prime_checker.zig
```

More information is available in the respective file comment header.

## 📚 Purpose

This repository provides a collection of mathematical algorithms implemented in Zig, showcasing the language's capabilities and performance. Each module is designed to be easily run and tested, making it a useful resource for learning and experimentation.

## 📝 License

MIT License

Copyright (c) 2024 Ramsyana

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 📧 Contact

Ramsyana - ramsyana[at]mac[dot]com

I'm a full-time full stack developer and system engineering enthusiast.  

Feel free to fork, clone, open issues, or contribute to this project. Don’t hesitate to reach out with any questions, suggestions, or collaboration ideas!
