---
title: Functions
description: Zoom
colordes: "#e86e0a"
slug: 08_jl_functions
weight: 8
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



Functions are objects containing a set of instructions.<br>
When you pass a tuple of argument(s) (possibly an empty tuple) to them, you get one or more values as output.

## Operators

Operators are functions and can be written in a way that shows the tuple of arguments more explicitly:

``` julia
3 + 2 == +(3, 2)  # `==` tests for equality
```

    true

``` julia
+(3, 2)
```

    5

## Function definition

There are 2 ways to define a new function:

### Long form

``` julia
function <name>(<arguments>)
    <body>
end
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
function hello1()
    println("Hello")
end
```

    hello1 (generic function with 1 method)

### Assignment form

``` julia
<name>(<arguments>) = <body>
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
hello1() = println("Hello")
```

    hello1 (generic function with 1 method)

The function `hello1` defined with this compact syntax is exactly the same as the one we defined above.

### Stylistic conventions

Julia suggests to use lower case, without underscores, as function names.

## Calling functions

Since you pass a tuple to a function when you run it, you call a function by appending parentheses to its name:

``` julia
hello1()
```

    Hello

{{<notes>}}
Here, our function does not take any argument, so the tuple is empty.
{{</notes>}}

## Arguments

### No argument

Our function `hello` does not accept any argument. If we pass an argument, we get an error message:

``` julia
hello1("Bob")
```

    LoadError: MethodError: no method matching hello1(::String)
    [0mClosest candidates are:
    [0m  hello1() at In[2658]:1

### One argument

To define a function which accepts an argument, we need to add a placeholder for it in the function definition.

{{<ex>}}
So let's try this:
{{</ex>}}

``` julia
function hello2(name)
    println("Hello name")
end
```

    hello2 (generic function with 1 method)

``` julia
hello2("Bob")
```

    Hello name

Mmm ... not quite ... this function works but does not give the result we wanted.

Here, we need to use {{<a "https://en.wikipedia.org/wiki/String_interpolation" "string interpolation:">}}

``` julia
function hello3(name)
    println("Hello $name")
end
```

    hello3 (generic function with 1 method)

`$name` in the body of the function points to `name` in the tuple of argument.

When we run the function, `$name` is replaced by the value we used in lieu of `name` in the function definition:

``` julia
hello3("Bob")
```

    Hello Bob

{{<ex>}}
Note that this dollar sign is only required with strings. Here is an example with integers:
{{</ex>}}

``` julia
function cube(a)
    a ^ 3
end

cube(4)
```

    64

### Multiple arguments

Now, let's write a function which accepts 2 arguments. For this, we put 2 placeholders in the tuple passed to the function in the function definition:

``` julia
function hello4(name1, name2)
    println("Hello $name1 and $name2")
end
```

    hello4 (generic function with 1 method)

This means that this function expects a tuple of 2 values:

``` julia
hello4("Bob", "Pete")
```

    Hello Bob and Pete

{{<exo>}}
See what happens when you pass no argument, a single argument, or three arguments to this function.
{{</exo>}}

### Default arguments

You can set a default value for some or all arguments. In this case, the function will run with or without a value passed for those arguments. If no value is given, the default is used. If a value is given, it will replace the default.

{{<ex>}}
Here is an example:
{{</ex>}}

``` julia
function hello5(name="")
    println("Hello $name")
end
```

    hello5 (generic function with 3 methods)

``` julia
hello5()
```

    Hello 

``` julia
hello5("Bob")
```

    Hello Bob

## Returning the result

In Julia, functions return the value(s) of the last expression automatically.<br>
If you want to return something else instead, you need to use the `return` statement. This causes the function to exit early.

{{<ex>}}
Look at these 5 functions:
{{</ex>}}

``` julia
function test1(x, y)
    x + y
end

function test2(x, y)
    return x + y
end

function test3(x, y)
    x * y
    x + y
end

function test4(x, y)
    return x * y
    x + y
end

function test5(x, y)
    return x * y
    return x + y
end

function test6(x, y)
    x * y, x + y
end
```

{{<exo>}}
Without running the code, try to guess the results of:
{{</exo>}}

``` julia
test1(1, 2)
test2(1, 2)
test3(1, 2)
test4(1, 2)
test5(1, 2)
test6(1, 2)
```

{{<exo>}}
Now, run the code and draw some conclusions on the behaviour of the return statement.
{{</exo>}}

