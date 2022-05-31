---
title: Control flow
description: Zoom
colordes: "#e86e0a"
slug: 09_jl_control_flow
weight: 9
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



## Conditional statements

Conditional statements allow to run instructions based on predicates.

Different set of instructions will be executed depending on whether the predicates return `true` or `false`.

{{<ex>}}
Here are a few examples of predicates:
{{</ex>}}

``` julia
occursin("that", "this and that")
4 < 3
a == b
a != b
2 in 1:3
3 <= 4 && 4 > 5
3 <= 4 || 4 > 5
```

Note that Julia possesses an inexact equality comparator which is useful to compare floating-point numbers despite computer rounding.

The function `isapprox` or the equivalent binary operator `≈` can be used:

``` julia
0.1 + 0.2 == 0.3
```

    false

``` julia
0.1 + 0.2 ≈ 0.3
```

    true

The negatives are the function `!isapprox` and `≈`.

### If statements

``` julia
if <predicate>
    <some action>
end
```

-   If the predicate evaluates to `true`, the body of the if statement gets evaluated,
-   If the predicate evaluates to `false`, nothing happens.

{{<ex>}}
Example:
{{</ex>}}

``` julia
function testsign1(x)
    if x >= 0
        println("x is positive")
    end
end
```

    testsign1 (generic function with 1 method)

``` julia
testsign1(3)
```

    x is positive

``` julia
testsign1(0)
```

    x is positive

``` julia
testsign1(-2)
```

### If else statements

``` julia
if <predicate>
    <some action>
else
    <some other action>
end
```

-   If the predicate evaluates to `true`, `<some action>` is done,
-   If the predicate evaluates to `false`, `<some other action>` is done.

{{<ex>}}
Example:
{{</ex>}}

``` julia
function testsign2(x)
    if x >= 0
        println("x is positive")
    else
        println("x is negative")
    end
end
```

    testsign2 (generic function with 1 method)

``` julia
testsign2(3)
```

    x is positive

``` julia
testsign2(0)
```

    x is positive

``` julia
testsign2(-2)
```

    x is negative

If else statements can be written in a compact format using the ternary operator:

``` julia
<predicate> ? <some action> : <some other action>
```

{{<ex>}}
In other words:
{{</ex>}}

``` julia
<predicate> ? <action if predicate returns true> : <action if predicate returns false>
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
function testsign2(x)
    x >= 0 ? println("x is positive") : println("x is negative")
end

testsign2(-2)
```

    x is negative

### If elseif else statements

``` julia
if <predicate1>
    <do if predicate1 true>
elseif <predicate2>
    <do if predicate1 false and predicate2 true>
else
    <do if predicate1 and predicate2 false>
end
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
function testsign3(x)
    if x > 0
        println("x is positive")
    elseif x == 0
        println("x is zero")
    else
        println("x is negative")
    end
end
```

    testsign3 (generic function with 1 method)

``` julia
testsign3(3)
```

    x is positive

``` julia
testsign3(0)
```

    x is zero

``` julia
testsign3(-2)
```

    x is negative

## Loops

### For loops

For loops run a set of instructions for each element of an iterator:

``` julia
for name = ["Paul", "Lucie", "Sophie"]
    println("Hello $name")
end
```

    Hello Paul
    Hello Lucie
    Hello Sophie

``` julia
for i = 1:3, j = 3:5
    println(i + j)
end
```

    4
    5
    6
    5
    6
    7
    6
    7
    8

### While loops

While loops run as long as the condition remains true:

``` julia
i = 0

while i <= 10
    println(i)
    i += 1
end
```

    0
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

## Comments & questions
