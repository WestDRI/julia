---
title: Plotting
description: Zoom
colordes: "#e86e0a"
slug: 15_jl_plotting
weight: 15
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



``` julia
using BSON: @load
using DataFrames
using Dates          # from the standard Julia library
using TimeSeries
using StatsPlots
```

{{<a "https://github.com/JuliaPlots/StatsPlots.jl" "StatsPlots package">}} {{<a "https://github.com/JuliaPlots/Plots.jl" "Plots package">}}

We will use the {{<a "https://gr-framework.org/" "GR framework">}} as a backend for Plots:

``` julia
gr()
```

    Plots.GRBackend()

## Loading a Julia object

``` julia
@load "deaths_canada.bson" deaths_canada
```

``` julia
@load "../../static/data/deaths_canada.bson" deaths_canada
```

## Time series

Our data is a time series, we need to transform it to a TimeArray thanks to the {{<c>}}TimeArray(){{</c>}} function from the TimeSeries package.

``` julia
deaths_canada = TimeArray(deaths_canada, timestamp = :date)
```

    861×1 TimeArray{Int64, 1, Date, Vector{Int64}} 2020-01-22 to 2022-05-31
    │            │ number_deaths_sum │
    ├────────────┼───────────────────┤
    │ 2020-01-22 │ 0                 │
    │ 2020-01-23 │ 0                 │
    │ 2020-01-24 │ 0                 │
    │ 2020-01-25 │ 0                 │
    │ 2020-01-26 │ 0                 │
    │ 2020-01-27 │ 0                 │
    │ 2020-01-28 │ 0                 │
    │ 2020-01-29 │ 0                 │
    │ 2020-01-30 │ 0                 │
    │ 2020-01-31 │ 0                 │
    │ 2020-02-01 │ 0                 │
    │ ⋮          │ ⋮                 │
    │ 2022-05-22 │ 40740             │
    │ 2022-05-23 │ 40740             │
    │ 2022-05-24 │ 40745             │
    │ 2022-05-25 │ 40838             │
    │ 2022-05-26 │ 40952             │
    │ 2022-05-27 │ 41016             │
    │ 2022-05-28 │ 41039             │
    │ 2022-05-29 │ 41042             │
    │ 2022-05-30 │ 41043             │
    │ 2022-05-31 │ 41070             │

## Creating a plot

``` julia
plot(deaths_canada)
```

![](15_jl_plotting_files/figure-gfm/cell-6-output-1.svg)

{{<imgmshadow src="/15_jl_plotting_files/figure-gfm/cell-6-output-1.svg" title="" width="%" line-height="2.5rem">}}
{{</imgmshadow>}}

### Customization

``` julia
plot(deaths_canada, title="Daily number of Covid-19 deaths in Canada", legend=false)
```

![](15_jl_plotting_files/figure-gfm/cell-7-output-1.svg)

{{<imgmshadow src="/15_jl_plotting_files/figure-gfm/cell-7-output-1.svg" title="" width="%" line-height="2.5rem">}}
{{</imgmshadow>}}

## Comments & questions
