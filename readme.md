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

| Algorithm | Description | Command | Difficulty |
|-----------|-------------|---------|------------|
| Prime Number Checker | Checks if a number is prime | `zig run src/algorithm/math/prime_checker.zig` | Easy |
| Armstrong Number Checker | Verifies Armstrong numbers | `zig run src/algorithm/math/is_armstrong.zig` | Easy |
| Strong Number Checker | Checks if sum of digit factorials equals the number | `zig run src/algorithm/math/strong_number_checker.zig` | Easy |
| Fibonacci Number Calculator | Calculates nth Fibonacci number | `zig run src/algorithm/math/fibonacci.zig` | Easy |
| Factorial Calculator | Calculates factorial of a number | `zig run src/algorithm/math/factorial.zig` | Easy |
| Palindrome Number Checker | Checks if a number is a palindrome | `zig run src/algorithm/math/palindrome_number.zig` | Easy |
| Perfect Number Checker | Checks if a number is perfect (equal to the sum of its proper divisors) | `zig run src/algorithm/math/perfect_number_checker.zig` | Easy |
| Abundant/Deficient Number Checker | Checks if a number is abundant (sum of proper divisors > number) or deficient (sum < number) | `zig run src/algorithm/math/abundant_deficient_checker.zig` | Easy |
| GCD and LCM Calculator | Finds Greatest Common Divisor and Least Common Multiple | `zig run src/algorithm/math/gcd_lcm_calculator.zig` | Medium |
| Prime Factorization | Computes prime factors of a number | `zig run src/algorithm/math/prime_factorization.zig` | Medium |
| Collatz Conjecture | Determines steps to reach 1 in Collatz sequence | `zig run src/algorithm/math/collatz_conjecture.zig` | Medium |
| Trailing Zeros in Factorial | Counts trailing zeros in factorial | `zig run src/algorithm/math/factorial_trailing_zeroes.zig` | Medium |
| Prime Counter | Counts primes less than a given number | `zig run src/algorithm/math/prime_counter.zig` | Medium |
| Binomial Coefficient Calculator | Calculates binomial coefficients using Pascal's triangle | `zig run src/algorithm/math/binomial_coefficient.zig` | Medium |
| Cantor Set Generator | Generates Cantor set levels | `zig run src/algorithm/math/cantor_set.zig -- 0 1 3` | Hard |
| Catalan Number Calculator | Calculates nth Catalan number | `zig run src/algorithm/math/catalan.zig` | Hard |
| Euclidean Algorithm | Finds GCD and coefficients | `zig run src/algorithm/math/euclidean_algorithm_extended.zig` | Hard |
| Linear Interpolation | Performs linear interpolation | `zig run src/algorithm/math/linear_interpolation.zig` | Hard |
| Euler's Totient Function | Counts numbers less than n that are coprime to n | `zig run src/algorithm/math/euler_totient.zig` | Hard |
| Chinese Remainder Theorem | Solves system of linear congruences | `zig run src/algorithm/math/chinese_remainder.zig` | Hard |

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


