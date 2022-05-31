---
title: Basics of the Julia language
description: Zoom
colordes: "#e86e0a"
slug: 07_jl_basics
weight: 7
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



{{<def>}}
{{<br size="2">}}
<em>Date:</em> {{<m>}}{{<s>}} Tuesday, May 31 <br>
<em>Time:</em> {{<m>}}{{<s>}} 10:30 am Pacific Time <br>
<em>Access:</em> {{<m>}} You should have received the meeting id and password by email.
{{<br size="2">}}
{{<notes>}}
Please have a look in your spam box if you haven't received the email.
{{</notes>}}
{{<br size="2">}}
{{</def>}}

## How to run Julia

There are several ways to run Julia interactively:

-   Directly in [the REPL](https://westgrid-julia.netlify.app/2022_modules/05_jl_repl),
-   In interactive notebooks (e.g. [Jupyter](https://jupyter.org/), [Pluto](https://github.com/fonsp/Pluto.jl)),
-   In an editor able to run Julia interactively (e.g. [Emacs](https://github.com/JuliaEditorSupport/julia-emacs), [VS Code](https://www.julia-vscode.org/), [Vim](https://github.com/JuliaEditorSupport/julia-vim)).

Julia can also be run non interactively as we will see [in a further section](https://westgrid-julia.netlify.app/2022_modules/16_jl_non_interactive).

For now, we will run Julia directly in [the REPL](https://westgrid-julia.netlify.app/2022_modules/05_jl_repl).

## Comments

Comments do not get evaluated by Julia and are for humans only.

``` julia
# Comments in Julia are identified by hastags
```

``` julia
#=
Comments can also spread over multiple lines
if you enclose them with this syntax
=#
```

``` julia
x = 2          # Comments can be added at the end of lines
```

    2

## Basic operations

``` julia
# By default, Julia returns the output
2 + 3
```

    5

``` julia
# Trailing semi-colons suppress the output
3 + 7;
```

``` julia
# Alternative syntax that can be used with operators
+(2, 5)
```

    7

``` julia
# Updating operators
a = 3
a += 8    # this is the same as a = a + 8
```

    11

``` julia
# Operator precedence follows standard rules
3 + 2 ^ 3 * 10
```

    83

### More exotic operators

``` julia
# Usual division
6 / 2
```

    3.0

``` julia
# Inverse division
2 \ 6
```

    3.0

``` julia
# Integer division (division truncated to an integer)
7 ÷ 2
```

    3

``` julia
# Remainder
7 % 2        # equivalent to rem(7, 2)
```

    1

``` julia
# Fraction
4//8
```

    1//2

``` julia
# Julia supports fraction operations
1//2 + 3//4
```

    5//4

## Variables

A variable is a name bound to a value:

``` julia
a = 3;
```

It can be called:

``` julia
a
```

    3

Or used in expressions:

``` julia
a + 2
```

    5

### Assignment

You can re-assign new values to variables:

``` julia
a = 3;
a = -8.2;
a
```

    -8.2

Even values of a different type:

``` julia
a = "a is now a string"
```

    "a is now a string"

You can define multiple variables at once:

``` julia
a, b, c = 1, 2, 3
b
```

    2

### Variable names

These names are extremely flexible and {{<a "https://docs.julialang.org/en/v1/manual/unicode-input/" "can use Unicode character:">}}

``` julia
\omega       # press TAB
\sum         # press TAB
\sqrt        # press TAB
\in          # press TAB
\:emoji:     # press TAB
# for the last example, replace the word "emoji" by e.g. "phone" or "snail"
```

``` julia
δ = 8.5;
🐌 = 3;
δ + 🐌
```

    11.5

Admittedly, using emojis doesn't seem very useful, but using Greek letters to write equations really makes Julia a great mathematical language:

``` julia
σ = 3
δ = π
ϕ = 8

(5σ + 3δ) / ϕ
```

    3.0530972450961724

{{<notes>}}
Note how the multiplication operator can be omitted when this does not lead to confusion.<br>
Also note how the mathematical constant π is available in Julia without having to load any module.
{{</notes>}}

If you want to know how to type a symbol, ask Julia: type `?` and paste it in the REPL.

<u>The only hard rules for variable names are:</u>

-   They must begin with a letter or an underscore,

-   They cannot take the names of {{<a "https://docs.julialang.org/en/v1/base/base/#Keywords" "built-in keywords">}} such as `if`, `do`, `try`, `else`,

-   They cannot take the names of built-in constants (e.g. `π`) and keywords in use in a session.

``` julia
false = 3
```

    LoadError: syntax: invalid assignment location "false" around In[216]:1

In addition, the {{<a "https://docs.julialang.org/en/v1/manual/style-guide/#Style-Guide-1" "Julia Style Guide">}} recommends to follow these conventions:

-   Use lower case,

-   Word separation can be indicated by underscores, but better not to use them if the names can be read easily enough without them.

### The ans variable

The keyword `ans` is a variable which, in the REPL, takes the value of the last computation:

``` julia
a = 3 ^ 2;
ans + 1
```

    10

### Printing

To print the value of a variable in an interactive session, you only need to call it:

``` julia
a = 3;
a
```

    3

In non interactive sessions, you have to use the `println` function:

``` julia
println(a)
```

    3

## Collections

Values can also be stored in collections.

### Tuples

Tuples are immutable, indexable, and possibly heterogeneous collections of elements. The order of elements matters.

``` julia
# Possibly heterogeneous (values can be of different types)
typeof((2, 'a', 1.0, "test"))
```

    Tuple{Int64, Char, Float64, String}

``` julia
# Indexable (note that indexing in Julia starts with 1)
x = (2, 'a', 1.0, "test");
x[3]
```

    1.0

``` julia
# Immutable (they cannot be modified)
x[3] = 8
```

    LoadError: MethodError: no method matching setindex!(::Tuple{Int64, Char, Float64, String}, ::Int64, ::Int64)

#### Named tuples

Tuples can have named components:

``` julia
typeof((a=2, b='a', c=1.0, d="test"))
```

    NamedTuple{(:a, :b, :c, :d), Tuple{Int64, Char, Float64, String}}

``` julia
x = (a=2, b='a', c=1.0, d="test");
x.c
```

    1.0

### Dictionaries

Julia also has dictionaries: associative collections of key/value pairs:

``` julia
x = Dict("Name"=>"Roger", "Age"=>52, "Index"=>0.3)
```

    Dict{String, Any} with 3 entries:
      "Index" => 0.3
      "Age"   => 52
      "Name"  => "Roger"

`"Name"`, `"Age"`, and `"Index"` are the keys; `"Roger"`, `52`, and `0.3` are the values.

The `=>` operator is the same as the `Pair` function:

``` julia
p = "foo" => 7
```

    "foo" => 7

``` julia
q = Pair("bar", 8)
```

    "bar" => 8

Dictionaries can be heterogeneous (as in this example) and the order doesn't matter. They are also indexable:

``` julia
x["Name"]
```

    "Roger"

And mutable (they can be modified):

``` julia
x["Name"] = "Alex";
x
```

    Dict{String, Any} with 3 entries:
      "Index" => 0.3
      "Age"   => 52
      "Name"  => "Alex"

### Sets

Sets are collections without duplicates. The order of elements doesn't matter.

``` julia
set1 = Set([9, 4, 8, 2, 7, 8])
```

    Set{Int64} with 5 elements:
      4
      7
      2
      9
      8

{{<notes>}}
Notice how this is a set of 5 (and not 6) elements: the duplicated 8 didn't matter.
{{</notes>}}

``` julia
set2 = Set([10, 2, 3])
```

    Set{Int64} with 3 elements:
      2
      10
      3

You can compare sets:

``` julia
# The union is the set of elements that are in one OR the other set
union(set1, set2)
```

    Set{Int64} with 7 elements:
      4
      7
      2
      10
      9
      8
      3

``` julia
# The intersect is the set of elements that are in one AND the other set
intersect(set1, set2)
```

    Set{Int64} with 1 element:
      2

``` julia
# The setdiff is the set of elements that are in the first set but not in the second
# Note that the order matters here
setdiff(set1, set2)
```

    Set{Int64} with 4 elements:
      4
      7
      9
      8

Sets can be heterogeneous:

``` julia
Set(["test", 9, :a])
```

    Set{Any} with 3 elements:
      :a
      "test"
      9

### Arrays

Arrays are indexable and mutable collections. The order of elements matters and they can be heterogeneous. We will talk about them in [a later section](https://westgrid-julia.netlify.app/2022_modules/13_jl_arrays).

## Quotes

Note the difference between single and double quotes:

``` julia
typeof("a")
```

    String

``` julia
typeof('a')
```

    Char

``` julia
"This is a string"
```

    "This is a string"

``` julia
'This is not a sring'
```

    LoadError: syntax: character literal contains multiple characters

``` julia
'a'
```

    'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)

## Comments & questions
