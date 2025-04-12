# Zig Math Algorithms

A collection of mathematical algorithms implemented in Zig, designed for educational purposes and showcasing Zig's performance.

## 🚀 Table of Contents

- [Zig Math Algorithms](#zig-math-algorithms)
  - [🚀 Table of Contents](#-table-of-contents)
  - [🔢 Available Algorithms](#-available-algorithms)
  - [🚀 Prerequisites](#-prerequisites)
  - [🔧 Running the Algorithms](#-running-the-algorithms)
  - [📚 Purpose](#-purpose)
  - [📝 License](#-license)
  - [🤝 Contributing](#-contributing)
  - [📧 Contact](#-contact)

## 🔢 Available Algorithms

Here is the updated markdown table with the **Time Complexity** column removed:

| Algorithm | Description | Command | Difficulty |
|-----------|-------------|---------|------------|
| **Basic Number Operations** |
| Prime Number Checker | Checks if a number is prime | `zig run src/algorithm/math/prime_checker.zig` | Easy |
| Armstrong Number Checker | Verifies Armstrong numbers | `zig run src/algorithm/math/is_armstrong.zig` | Easy |
| Happy Number Checker | Checks if a number is happy | `zig run src/algorithm/math/happy_number.zig` | Easy |
| Palindrome Number Checker | Checks if a number is a palindrome | `zig run src/algorithm/math/palindrome_number.zig` | Easy |
| Sum of Digits | Calculates digit sum | `zig run src/algorithm/math/sum_of_digits.zig` | Easy |
| Digital Root | Recursive digit sum calculation | `zig run src/algorithm/math/digital_root.zig` | Easy |
| Reverse Number | Reverses digits of a number | `zig run src/algorithm/math/reverse_number.zig` | Easy |
| Power of Two Checker | Checks if number is 2ⁿ | `zig run src/algorithm/math/power_of_two.zig` | Easy |
| Integer Square Root | Finds floor(√n) | `zig run src/algorithm/math/integer_sqrt.zig` | Easy |
| Leap Year Checker | Determines if year is leap | `zig run src/algorithm/math/leap_year_checker.zig` | Easy |
| **Number Theory** |
| Perfect Number Checker | Checks if a number is perfect | `zig run src/algorithm/math/perfect_number_checker.zig` | Easy |
| Abundant/Deficient Checker | Checks if number is abundant/deficient | `zig run src/algorithm/math/abundant_deficient_checker.zig` | Easy |
| Strong Number Checker | Sum of digit factorials check | `zig run src/algorithm/math/strong_number_checker.zig` | Easy |
| GCD and LCM Calculator | Finds GCD and LCM | `zig run src/algorithm/math/gcd_lcm_calculator.zig` | Medium |
| Prime Factorization | Computes prime factors | `zig run src/algorithm/math/prime_factorization.zig` | Medium |
| Prime Counter | Counts primes up to n | `zig run src/algorithm/math/prime_counter.zig` | Medium |
| Euler's Totient Function | Counts coprime numbers | `zig run src/algorithm/math/euler_totient.zig` | Hard |
| **Sequences and Series** |
| Fibonacci Calculator | Calculates nth Fibonacci | `zig run src/algorithm/math/fibonacci.zig` | Easy |
| Lucas Numbers | Generates Lucas numbers | `zig run src/algorithm/math/lucas_numbers.zig` | Easy |
| Factorial Calculator | Calculates n! | `zig run src/algorithm/math/factorial.zig` | Easy |
| Sequence Generator | Arithmetic/Geometric sequences | `zig run src/algorithm/math/sequence_generator.zig` | Easy |
| Trailing Zeros in Factorial | Counts trailing zeros in n! | `zig run src/algorithm/math/factorial_trailing_zeroes.zig` | Medium |
| Collatz Conjecture | Steps to reach 1 | `zig run src/algorithm/math/collatz_conjecture.zig` | Medium |
| Catalan Calculator | Calculates nth Catalan | `zig run src/algorithm/math/catalan.zig` | Hard |
| **Advanced Mathematics** |
| Matrix Multiplication | Performs matrix multiplication | `zig run src/algorithm/math/matrix_multiplication.zig` | Medium |
| Binomial Coefficient | Pascal's triangle coefficients | `zig run src/algorithm/math/binomial_coefficient.zig` | Medium |
| Cantor Set Generator | Generates Cantor set | `zig run src/algorithm/math/cantor_set.zig -- 0 1 3` | Hard |
| Extended Euclidean | GCD and Bézout coefficients | `zig run src/algorithm/math/euclidean_algorithm_extended.zig` | Hard |
| Linear Interpolation | Linear interpolation | `zig run src/algorithm/math/linear_interpolation.zig` | Hard |
| Chinese Remainder | Solves linear congruences | `zig run src/algorithm/math/chinese_remainder.zig` | Hard |
| Quadratic Solver | Solves quadratic equations (ax² + bx + c = 0) | `zig run src/algorithm/math/quadratic_solver.zig` | Medium |

## 🚀 Prerequisites

- **Zig Compiler**: 
  - Latest version recommended. Install via:

    ```shell
    sh -c "$(curl -fsSL https://ziglang.org/download/index.json | jq -r '.master.url')"
    ```

## 🔧 Running the Algorithms

To run any algorithm, use the Zig run command followed by the specific algorithm file path and any required arguments. For example:

```shell
zig run src/algorithm/math/prime_checker.zig
# or
zig test src/algorithm/math/prime_checker.zig
```

More information is available in the respective file comment header.

## 📚 Purpose

This repository provides a collection of mathematical algorithms implemented in Zig, showcasing the language's capabilities and performance. Each module is designed to be easily run and tested, making it a useful resource for learning and experimentation.

## 📝 License

MIT License

Copyright (c) 2025 Ramsyana

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

## 🤝 Contributing
Contributions are welcome! Here's how to contribute:
- Fork the repository
- Create your feature branch (git checkout -b feature/AmazingFeature)
- Commit your changes (git commit -m 'Add some AmazingFeature')
- Push to the branch (git push origin feature/AmazingFeature)
- Open a pull request

## 📧 Contact

Ramsyana - ramsyana[at]mac[dot]com

I'm a system engineering enthusiast. Feel free to fork, clone, open issues, or contribute to this project. Don’t hesitate to reach out with any questions, suggestions, or collaboration ideas!


