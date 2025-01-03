---
permalink: /dsa/static-arrays/
title: "Static Arrays"
mathjax: true
tikzjax: true
---

# Overview

A static array is a very simple data structure comprised of a block of contiguous memory. Generally, we define a type with additional information that is useful to us, like the size of the memory block. Although higher-level languages may hide these low-level details, a static array is nothing more than a pointer $p$ to the beginning of the continuous memory block and whatever other variables we may wish to store, as illustrated in the figure below.

<script type="text/tikz">
  \begin{tikzpicture}
    \node at (0, 0) {0};
    \node at (1, 0) {1};
    \node at (2, 0) {2};
    \node at (3, 0) {3};
    \node at (4, 0) {4};
    \node at (5, 0) {5};
    \node at (6, 0) {6};
    \node at (7, 0) {7};
    \node at (8, 0) {8};
    \node at (9, 0) {9};
    \draw[shift={(-0.5,-0.5)}] (0,0) grid (10,1);

    \draw[thick,latex-] (0, -0.5) -- ++(0, -0.75) node [below] {$p$};
    \draw (0, 0.5) -- ++(0, 0.5) -- node [above] {size = 10} ++(9, 0) -- ++(0, -0.5);
  \end{tikzpicture}
</script>

The squares in the figure above represent a fixed size that depends on the type of data we want to store in the array. For example, it could be 16-byte long and store an integer, or it could be 64-byte long and store a double-precision floating-point number. When dealing with languages that offer generics (such as Python, C++, and Rust), we can typically have a single implementation of the data class that can adapt to any data type. On languages that do not offer such functionality, like C, we will have to implement different arrays for different data types.

# Basic Interface

A basic interface for a static array is provided in the table below.

| **Function** | **Description**                                 | 
|:------------:|:-----------------------------------------------:|
| new          | Create an instance of the array.                |
| delete       | Delete/drop/free memory for the array.          |
| get          | Get an element in the array, with bounds check. |
| set          | Set an element in the array, with bounds check. |
| [] operator  | Get/set an element in the array (if supported). |

# Implementation

{% tabs StaticArray %}

{% tab StaticArray <img src="/assets/images/icons/python.svg" width="24" height="24"/> %}
```python
""" Array.py: a simple static array in Python. """

import atexit
from ctypes import c_double, c_int32
from typing import Type, Union


class Array:
    """A class for a simple static array in Python."""

    # Basic interface
    def __init__(
        self, size: int, dtype: Union[Type[c_int32], Type[c_double]] = c_int32
    ):
        """Constructor"""
        self.size = size
        self.data = (dtype * size)()
        if dtype not in (c_int32, c_double):
            raise ValueError(f"Unsupported data type {dtype}")

        atexit.register(self.delete)

    def delete(self) -> None:
        """Destructor"""
        self.data = None

    def get(self, index: int) -> Union[int, float]:
        """Get element at index; raise ValueError if out-of-bounds."""
        return self.data[self.__sanitize_index(index)]

    def set(self, index: int, value: Union[int, float]) -> None:
        """Set element at index to value; raise ValueError if out-of-bounds."""
        self.data[self.__sanitize_index(index)] = value

    def __getitem__(self, index: int) -> Union[int, float]:
        """Same as self.get(), but with [] operator syntax."""
        return self.get(index)

    # Set item with [] operator
    def __setitem__(self, index: int, value: Union[int, float]) -> None:
        """Same as self.set(), but with [] operator syntax."""
        self.set(index, value)

    # Extended interface
    def __len__(self) -> int:
        """Get length of the array with len() built-in function."""
        return self.size

    def __str__(self) -> str:
        """Print array with print() built-in function."""
        if self.size == 0:
            return "[]"

        string = "["
        for i in range(self.size - 1):
            string += f"{self.data[i]}, "

        return string + f"{self.data[self.size-1]}]"

    # Helper functions
    def __sanitize_index(self, index: int) -> int:
        """Sanitize user input index; raise ValueError if out-of-bounds."""
        if index >= self.size:
            raise ValueError(f"Index {index} out-of-bounds (size={self.size})")

        if index < 0:
            return index % self.size

        return index


if __name__ == "__main__":
    test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    arr = Array(10)
    for index, value in enumerate(test):
        arr[index] = value

    assert len(test) == len(arr)
    for index, value in enumerate(test):
        assert value == arr[index], "Array basic test failed"

    print("Array basic test passed")

    assert test[-2] == arr[-2], "Array negative index test failed"

    print("Array negative index test passed")

    try:
        arr[10]
        print("Array out-of-bounds test failed")
    except ValueError:
        print("Array out-of-bounds test passed")
```
{% endtab %}

{% tab StaticArray <img src="/assets/images/icons/c-header.svg" height="24" width="24"/> %}
```c
#ifndef DSA_ARRAY_H_
#define DSA_ARRAY_H_

// For size_t
#include <stddef.h>

/**
 * @brief A static array type.
 */
typedef struct {
  size_t length;
  int *data;
} Array;

/**
 * @brief Create a new array.
 *
 * @param length How many elements are in the array.
 * @return A pointer to the new array object.
 */
Array *Array_new(const size_t length);

/**
 * @brief Delete an array.
 *
 * @param array Input array to be deleted.
 */
void Array_delete(Array **array);

/**
 * @brief Get value of element in array.
 *
 * @param array Pointer to array object.
 * @param index Element index.
 * @return Element value.
 */
int Array_get(Array *array, long index);

/**
 * @brief Set value of element in array.
 *
 * @param array Pointer to array object.
 * @param index Element index.
 * @param value New value for element.
 */
void Array_set(Array *array, long index, const int value);

/**
 * @brief Print array x using the format [x[0], x[1], ..., x[length-1]].
 *
 * @param array Array to be printed.
 */
void Array_print(Array *array);

#endif // DSA_ARRAY_H_
```
{% endtab %}

{% tab StaticArray <img src="/assets/images/icons/c-source.svg" height="24" width="24"/> %}
```c
#include "Array.h"

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

Array *Array_new(const size_t length) {
  Array *array = (Array *)malloc(sizeof(Array));
  if(!array) {
    fputs("Could not allocate memory for array.\n", stderr);
    abort();
  }

  array->data = (int *)malloc(sizeof(int) * length);
  if(!array->data) {
    fputs("Could not allocate memory for elements in array.\n", stderr);
    free(array);
    abort();
  }

  array->length = length;

  return array;
}

void Array_delete(Array **array) {
  if(!array || !*array) {
    return;
  }

  if((*array)->data) {
    free((*array)->data);
    (*array)->data = NULL;
  }

  free(*array);
  *array = NULL;
}

static long sanitize_index(Array *array, long index) {
  if(labs(index) >= array->length) {
    fprintf(stderr,
            "Array_get: out-of-bounds index access: %ld >= %lu.\n",
            index,
            array->length);
    free(array->data);
    free(array);
    abort();
  }

  if(index < 0) {
    return index + array->length;
  }

  return index;
}

int Array_get(Array *array, long index) {
  return array->data[sanitize_index(array, index)];
}

void Array_set(Array *array, long index, const int value) {
  array->data[sanitize_index(array, index)] = value;
}

void Array_print(Array *array) {
  if(array == NULL || array->length == 0) {
    puts("[]");
    return;
  }

  printf("[");
  for(int i = 0; i < array->length - 1; i++) {
    printf("%d, ", Array_get(array, i));
  }
  printf("%d]\n", Array_get(array, -1));
}

#ifdef ARRAY_TEST
#include <assert.h>

int main() {
  size_t array_size = 10;
  int trusted[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
  Array *array = Array_new(array_size);

  assert(array->length == 10);
  puts("Array: length test passed.");

  for(int i = 0; i < array_size; i++) {
    Array_set(array, i, i + 1);
    assert(trusted[i] == Array_get(array, i));
  }
  puts("Array: set/get test passed.");

  Array_delete(&array);
  Array_delete(&array);
  puts("Array: double-free test passed.");
  return 0;
}
#endif
```
{% endtab %}

{% tab StaticArray <img src="/assets/images/icons/cpp-header.svg" height="24" width="24"/> %}

```cpp
#ifndef DSA_ARRAY_HH_
#define DSA_ARRAY_HH_

#include <iostream>
#include <memory>

template <typename T>
class Array {
  long length;
  std::unique_ptr<T[]> data;

  long sanitize_index(long index) {
    if(labs(index) >= length) {
      std::cerr << index << " out of array bounds (size=" << length << ")\n";
      std::abort();
    }

    if(index < 0) {
      return index + length;
    }

    return index;
  }

public:
  // Constructor
  explicit Array(long size)
      : length{ size }, data{ std::make_unique<T[]>(size) } {}

  // Get element in array, with bounds check
  T get(long index) const {
    return data[sanitize_index(index)];
  }

  // Set element in array, with bounds check
  void set(long index, T value) {
    data[sanitize_index(index)] = value;
  }

  // Same as get, but uses operator [] syntax
  T operator[](long index) const {
    return get(index);
  }

  // Same as set, but uses operator [] syntax
  T& operator[](long index) {
    return data[sanitize_index(index)];
  }

  // Get array length (method name follows C++ convention)
  [[nodiscard]] long size() const noexcept {
    return length;
  }
};

// Print array using std::cout << array.
template <typename T>
std::ostream& operator<<(std::ostream& out, Array<T>& array) {
  if(array.size() == 0) {
    out << "[]";
    return out;
  }

  out << "[";
  for(int i = 0; i < array.size() - 1; i++) {
    out << array[i] << ", ";
  }
  out << array[-1] << "]";

  return out;
}

#endif // DSA_ARRAY_HH_
```
{% endtab %}

{% tab StaticArray <img src="/assets/images/icons/rust.svg" height="24" width="24"/> %}
```rust
fn main() {
  println!("Hello, world!");
}
```
{% endtab %}

{% endtabs %}
