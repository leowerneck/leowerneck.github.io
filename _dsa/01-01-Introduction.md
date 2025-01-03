---
permalink: /dsa/introduction/
title: "Introduction"
---

# What This Collection Is and What It Is Not
In this collection, I will discuss data structures and algorithms from the perspective of a computational scientist. Specifically, my goal is to provide enough information about each data structure so that you could it implement it yourself, if you had to. However, the codes presented here, while tested, are not meant to replace existing, battle-tested implementations, such as the ones available in the standard libraries of many languages.

That being said, the implementations provided in this collection should be clear and easy to follow. This is not something we can usually say about standard library implementations, as their developers prioritize portability and runtime efficiency.

While I will make an effort to explain some programming language peculiarities (sometimes for my own sake), this collection is not intended as a guide that will teach you how to program in any of the languages I will use. Instead, I will focus on explaining the concepts behind the data structures and algorithms discussed. The provided implementations will then provide examples of how to turn those concepts into code.

# Who This Collection Is For

It is fascinating how much can be achieved in solving partial differential equations using a single data structure: arrays. Because of this, many computational scientists will have a thorough understanding of how arrays work, as well as many algorithms related to them. However, many have never had to implement an array list (or dynamic array), in which the size of the array can grow dynamically as you add elements to the array. Similarly, hash tables and stacks are data structures that we might use on occasion, though we rarely have to implement them ourselves. Linked lists, graphs, queues, and priority queues are even less common, and some people never have to implement or even use them in scientific computing (myself included).

If you relate to the previous paragraph and want to learn a little bit about these different data structures and algorithms, then these posts are for you.

# Idiosyncrasies

## Code Presentation

I will do my best to provide four implementations of each data structure or algorithm, one in each of the following languages: Python, C, C++, and Rust. Therefore, every time you see a code block, it should look something like this:

{% tabs hello_world %}

{% tab hello_world <img src="/assets/images/icons/python.svg" width="24" height="24"/> %}
```py
if __name__ == "__main__":
    print("Hello, world!")
```
{% endtab %}

{% tab hello_world <img src="/assets/images/icons/c-source.svg" width="24" height="24"/> %}
```c
#include <stdio.h>

int main() {
    puts("Hello, world!");
    return 0;
}
```
{% endtab %}

{% tab hello_world <img src="/assets/images/icons/cpp-source.svg" width="24" height="24"/> %}
```cpp
#include <iostream>

int main() {
    std::cout << "Hello, world!\n";
    return 0;
}
```
{% endtab %}

{% tab hello_world <img src="/assets/images/icons/rust.svg" width="24" height="24"/> %}
```rs
fn main() {
    println!("Hello, world!");
}
```
{% endtab %}

{% endtabs %}

I will also use {{ site.icons.ch }} and {{ site.icons.cpph }} for C and C++ header files, respectively.

I will be using four spaces for indentation. Although I am used to using two spaces when coding in C/C++, I generally use four when coding in Python. Since Rust's standard is to use four as well, I figured I would make everything uniform and just use four spaces for all of them. I will do my best to keep each line of code under 80 characters, allowing up to 120 characters only when necessary for readability or practical reasons.

My code will be formatted using external tools: Python code will be formatted using [black](https://github.com/psf/black) and [isort](https://pycqa.github.io/isort/); C/C++ code will be formatted using [clang-format](https://clang.llvm.org/docs/ClangFormat.html); and Rust code will be formatted using [rustfmt](https://github.com/rust-lang/rustfmt).

## Naming Conventions

When presenting code, I will adopt a consistent naming convention across all languages. While this choice may not be controversial, it reflects my personal preferences. It should be fairly straightforward to follow, as I adopt either [snake_case](https://en.wikipedia.org/wiki/Snake_case) or [PascalCase](https://en.wikipedia.org/wiki/Pascal_case). The table below provides a summary of the adopted conventions.

| **Quantity**                 | **Naming Convention** | **Example**        |
|:----------------------------:|:---------------------:|:------------------:|
| Variables                    | Snake Case            | `my_variable`      |
| Functions                    | Snake Case            | `my_function`      |
| Namespaces                   | Snake Case            | `my_namespace`     |
| Data Types                   | Pascal Case           | `MyType`           |
| Data Type Functions (C only) | Mixed Case            | `MyType_my_function` |

I will also use descriptive names, as they often serve as self-documentation, reducing the need for comments.

# Final Notes

I have three main goals with these notes. The first is to provide notes on data structures and algorithms in a way that is easy for me to access and understand. The second is to use these posts as a way to learn Rust. The third is to improve my understanding of data structures I have encountered before but have limited experience with. As such, you may see less efficient code when I am programming in Rust or working with unfamiliar data structures. Nevertheless, I will do my best to provide algorithms that scale as expected.
