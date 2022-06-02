---
title: Types
description: Zoom
colordes: "#e86e0a"
slug: 10_jl_types
weight: 10
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



{{<def>}}
{{<br size="2">}}
<em>Date:</em> {{<m>}}{{<s>}} Thursday, June 2 <br>
<em>Time:</em> {{<m>}}{{<s>}} 9:30 am Pacific Time <br>
<em>Access:</em> {{<m>}} You should have received the meeting id and password by email.
{{<br size="2">}}
{{<notes>}}
Please have a look in your spam box if you haven't received the email.
{{</notes>}}
{{<br size="2">}}
{{</def>}}

## Types systems

### Two main type systems in programming languages

#### Static type-checking

Type safety (catching errors of inadequate type) performed at compilation time.

{{<ex>}}
Examples: C, C++, Java, Fortran, Haskell.
{{</ex>}}

#### Dynamic type-checking

Type safety performed at runtime.

{{<ex>}}
Examples: Python, JavaScript, PHP, Ruby, Lisp.
{{</ex>}}

### Julia type system

Julia type system is *dynamic* (types are unknown until runtime), but types *can* be declared, optionally bringing the advantages of static type systems.

This gives users the freedom to choose between an easy and convenient language, or a clearer, faster, and more robust one (or a combination of the two).

## Julia types: a hierarchical tree

At the bottom:  **concrete types** <br>
Above:     **abstract types** (concepts for collections of concrete types) <br>
At the top:     the `Any` type, encompassing all types
{{<br size="4">}}

{{<imgshadow src="/img/type.png" margin="1rem" title="" width="75%" line-height="3rem">}}
From <a href="https://www.oreilly.com/library/view/learning-julia-abstract/9781491999585/ch01.html">O'Reilly</a>       
{{</imgshadow>}}

One common type missing in this diagram is the boolean type.

It is a subtype of the integer type, as can be tested with the subtype operator `<:`

``` julia
Bool <: Integer
```

    true

It can also be made obvious by the following:

``` julia
false == 0
```

    true

``` julia
true == 1
```

    true

``` julia
a = true;
b = false;
3a + 2b
```

    3

## Optional type declaration

Done with `::`

``` julia
<value>::<type>
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
2::Int
```

    2

## Illustration of type safety

This works:

``` julia
2::Int
```

    2

This doesn't work:

``` julia
2.0::Int
```

    LoadError: TypeError: in typeassert, expected Int64, got a value of type Float64

Type declaration is not yet supported on global variables; this is used in local contexts such as inside a function.

{{<ex>}}
Here is an example:
{{</ex>}}

``` julia
function floatsum(a, b)
    (a + b)::Float64
end
```

    floatsum (generic function with 1 method)

This works:

``` julia
floatsum(2.3, 1.0)
```

    3.3

This doesn't work:

``` julia
floatsum(2, 4)
```

    LoadError: TypeError: in typeassert, expected Float64, got a value of type Int64

## Information and conversion

The `typeof` function gives the type of an object:

``` julia
typeof(2)
```

    Int64

``` julia
typeof(2.0)
```

    Float64

``` julia
typeof("Hello, World!")
```

    String

``` julia
typeof(true)
```

    Bool

``` julia
typeof((2, 4, 1.0, "test"))
```

    Tuple{Int64, Int64, Float64, String}

Conversion between types is possible in some cases:

``` julia
Int(2.0)
```

    2

``` julia
typeof(Int(2.0))
```

    Int64

``` julia
Char(2.0)
```

    '\x02': ASCII/Unicode U+0002 (category Cc: Other, control)

``` julia
typeof(Char(2.0))
```

    Char

## Stylistic convention

The names of types start with a capital letter and camel case is used in multiple-word names.

## Comments & questions
