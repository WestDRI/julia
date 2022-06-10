---
title: Documentation
description: Reading
colordes: "#2d5986"
slug: 04_jl_doc
weight: 4
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



## Documentation from within Julia

To get documentation on an object in Julia, simply type in [the julia REPL](https://westgrid-julia.netlify.app/2022_modules/05_jl_repl):

``` julia
?<object>
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
?sum
```

    search: sum sum! summary cumsum cumsum! isnumeric VersionNumber issubnormal get_zero_subnormals set_zero_subnormals

      sum(f, itr; [init])

      Sum the results of calling function f on each element of itr.

      The return type is Int for signed integers of less than system word size, and UInt for unsigned integers of less than system word size. For all other arguments, a
      common return type is found to which all arguments are promoted.

      The value returned for empty itr can be specified by init. It must be the additive identity (i.e. zero) as it is unspecified whether init is used for non-empty
      collections.

      Examples
      ≡≡≡≡≡≡≡≡≡≡

      julia> sum(abs2, [2; 3; 4])
      29

      Note the important difference between sum(A) and reduce(+, A) for arrays with small integer eltype:

      julia> sum(Int8[100, 28])
      128

      julia> reduce(+, Int8[100, 28])
      -128

## Find function from within Julia

To print the list of functions containing a certain expression in their description, you can use:

``` julia
apropos("<expression>")
```

{{<ex>}}
Example:
{{</ex>}}

``` julia
apropos("truncate")
```

    Base.IOBuffer
    Base.truncate
    Base.open_flags
    Base.IOContext
    Base.open
    Base.dump
    Core.String
    Base.Broadcast.newindex
    ArgTools
    NetworkOptions
    LinearAlgebra.eigen
    Tar
    Base.trunc
    Dates.format
    Dates.Date
    IJulia.watch_stream
    IJulia.set_max_stdio

## Get version

If you need to find your Julia version, you can use either of:

``` julia
VERSION          # outputs Julia version only
```

    v"1.7.2"

``` julia
versioninfo()    # outputs more info, including OS info
```

    Julia Version 1.7.2
    Commit bf53498635 (2022-02-06 15:21 UTC)
    Platform Info:
      OS: Linux (x86_64-pc-linux-gnu)
      CPU: Intel(R) Core(TM) i7-10875H CPU @ 2.30GHz
      WORD_SIZE: 64
      LIBM: libopenlibm
      LLVM: libLLVM-12.0.1 (ORCJIT, skylake)

## Online documentation

{{<a "https://julialang.org/" "Julia website">}}  
{{<a "https://docs.julialang.org/en/v1/" "Julia documentation">}}  
{{<a "https://julialang.org/learning/" "Online training material">}}  
{{<a "https://www.youtube.com/user/JuliaLanguage" "Julia YouTube channel">}}  
{{<a "https://en.wikibooks.org/wiki/Introducing_Julia" "Julia Wikibook">}}  
{{<a "https://www.juliabloggers.com/" "Blog aggregator for Julia">}}

## Getting help

{{<a "https://discourse.julialang.org/" "Julia Discourse forum">}}  
<a href="https://stackoverflow.com/tags/julia" target="_blank">\[julia\] tag on Stack Overflow</a>  
{{<a "https://julialang.org/slack/" "The Julia Language Slack">}}  
{{<a "https://julialang.zulipchat.com/register/" "Zulip">}}  
<a href="https://twitter.com/search?q=%23julialang" target="_blank">\#julialang hashtag on Twitter</a>
{{<a "https://www.reddit.com/r/Julia/" "Julia subreddit">}}  
{{<a "https://gitter.im/JuliaLang/julia" "Julia Gitter channel">}}  
<a href="https://webchat.freenode.net/#julia" target="_blank">\#julia IRC channel on Freenode</a>

## Comments & questions
