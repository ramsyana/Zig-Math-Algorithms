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

| Algorithm | Description | Command | Complexity |
|-----------|-------------|---------|------------|
| Prime Number Checker | Checks if a number is prime | `zig run src/algorithm/math/prime_checker.zig -- {number}` | O(sqrt(n)) |
| Armstrong Number Checker | Verifies Armstrong numbers | `zig run src/algorithm/math/is_armstrong.zig -- {number}` | O(log(n)) |
| Strong Number Checker | Checks if sum of digit factorials equals the number | `zig run src/algorithm/math/strong_number_checker.zig -- {number}` | O(log(n)) |
| Fibonacci Number Calculator | Calculates nth Fibonacci number | `zig run src/algorithm/math/fibonacci.zig -- {n}` | O(n) |
| Factorial Calculator | Calculates factorial of a number | `zig run src/algorithm/math/factorial.zig -- {number}` | O(n) |
| GCD and LCM Calculator | Finds Greatest Common Divisor and Least Common Multiple | `zig run src/algorithm/math/gcd_lcm_calculator.zig -- {a} {b}` | O(log(min(a, b))) |
| Prime Factorization | Computes prime factors of a number | `zig run src/algorithm/math/prime_factorization.zig -- {number}` | O(sqrt(n)) |
| Collatz Conjecture | Determines steps to reach 1 in Collatz sequence | `zig run src/algorithm/math/collatz_conjecture.zig -- {number}` | O(log(n)) |
| Cantor Set Generator | Generates Cantor set levels | `zig run src/algorithm/math/cantor_set.zig -- {start} {end} {levels}` | O(levels * (end - start)) |
| Catalan Number Calculator | Calculates nth Catalan number | `zig run src/algorithm/math/catalan.zig -- {n}` | O(n^2) |
| Euclidean Algorithm | Finds GCD and coefficients | `zig run src/algorithm/math/euclidean_algorithm_extended.zig -- {a} {b}` | O(log(min(a, b))) |
| Linear Interpolation | Performs linear interpolation | `zig run src/algorithm/math/linear_interpolation.zig -- {x1} {y1} {x2} {y2} {x}` | O(1) |
| Palindrome Number Checker | Checks if a number is a palindrome | `zig run src/algorithm/math/palindrome_number.zig -- {number}` | O(log(n)) |
| Trailing Zeros in Factorial | Counts trailing zeros in factorial | `zig run src/algorithm/math/factorial_trailing_zeroes.zig -- {number}` | O(log(n)) |
| Prime Counter | Counts primes less than a given number | `zig run src/algorithm/math/prime_counter.zig -- {number}` | O(n * log(log(n))) |

**Note:** Complexity is an approximation and can vary based on implementation details.

## 🚀 Prerequisites
- **Zig Compiler**: 
  - Latest version recommended. Install via:

    ```shell
    sh -c "$(curl -fsSL https://ziglang.org/download/index.json | jq -r '.master.url')"
    ```

## 🔧 Running the Algorithms

To run any algorithm, use the Zig run command followed by the specific algorithm file path and any required arguments. For example:

```shell
zig run src/algorithm/math/prime_checker.zig -- 17
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

## 🤝 Contributing
Contributions are welcome! Here's how to contribute:
- Fork the repository
- Create your feature branch (git checkout -b feature/AmazingFeature)
- Commit your changes (git commit -m 'Add some AmazingFeature')
- Push to the branch (git push origin feature/AmazingFeature)
- Open a pull request

## 📧 Contact

Ramsyana - ramsyana[at]mac[dot]com

I'm a full-time full-stack developer and system engineering enthusiast. Feel free to fork, clone, open issues, or contribute to this project. Don’t hesitate to reach out with any questions, suggestions, or collaboration ideas!


