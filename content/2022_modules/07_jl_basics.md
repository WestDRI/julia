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



*Date:* {{<m>}}{{<s>}} Tuesday, May 31  
*Time:* {{<m>}}{{<s>}} 10:30 am Pacific Time  
*Access:* {{<m>}} You should have received the meeting id and password by email.

{{<notes>}}
Please have a look in your spam box if you haven't received the email.
{{</notes>}}

## How to run Julia

There are several ways to run Julia interactively:

-   Directly in [the REPL](https://westgrid-julia.netlify.app/2022_modules/05_jl_repl),
-   In interactive notebooks (e.g. [Jupyter](https://jupyter.org/), [Pluto](https://github.com/fonsp/Pluto.jl)),
-   In an editor able to run Julia interactively (e.g. [Emacs](https://github.com/JuliaEditorSupport/julia-emacs), [VS Code](https://www.julia-vscode.org/), [Vim](https://github.com/JuliaEditorSupport/julia-vim)).

Julia can also be run [non interactively from the command line]().

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
a += 8
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

    LoadError: syntax: invalid assignment location "false" around In[24]:1

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
