---
title: Data frames
description: Zoom
colordes: "#e86e0a"
slug: 14_jl_df
weight: 14
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



<script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.6/require.min.js" integrity="sha512-c3Nl8+7g4LMSTdrm621y7kf9v3SDPnhxLNhcjFJbKECVnmZHTdo+IRO05sNLTH/D3vA6u1X32ehoLC7WFVdheg==" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" integrity="sha512-bLT0Qm9VnAYZDflyKcBaQ2gg0hSYNQrJ8RilYldYQ1FxQYoCLtUjuuRuZo+fjqhx/qtq/1itJ0C2ejDxltZVFg==" crossorigin="anonymous"></script>
<script type="application/javascript">define('jquery', [],function() {return window.jQuery;})</script>


## Working with tabular data in julia

Julia was created with large computations in mind. Its main type for large collections of data is thus [the array](https://westgrid-julia.netlify.app/2022_modules/13_jl_arrays/). The array is Julia's equivalent to NumPy's ndarray (the data collection object used for efficient computations in Python). It is also equivalent to PyTorch's tensors (the data collection object used for deep learning in this Python library).

Julia's equivalent to {{<a "https://pandas.pydata.org/" "pandas'">}} DataFrame (in Python) and data.frames or their variations such as {{<a "https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html" "tibbles">}} and {{<a "https://rdatatable.gitlab.io/data.table/" "data.tables">}} (in R) is provided by {{<a "https://github.com/JuliaData/DataFrames.jl" "the DataFrames package.">}}

## DataFrame through an example

Let's introduce DataFrame through an example typical of tabular data workflows using Covid-19 data from Johns Hopkins University. This data is open source, easy to access from {{<a "https://github.com/CSSEGISandData/COVID-19" "a repository on GitHub,">}} and is the data used in {{<a "https://www.arcgis.com/apps/dashboards/bda7594740fd40299423467b48e9ecf6" "the JHU Covid-19 dashboard.">}}

### Load packages

We will need a number of external packages for this. Remember that external packages {{<a "https://westgrid-julia.netlify.app/2022_modules/06_jl_pkg/" "first need to be installed:">}}

``` julia
] add CSV DataFrames StatsPlots TimeSeries BSON
```

There is a conflict version between the latest CSV package version and the version of Julia running in our JupyterHub. For this reason, we have to downgrade the version to v0.8.5 (for those running Julia on their computer, this is not necessary):

``` julia
] pin CSV@0.8.5
```

Then, you have to load them to make them accessible in the current session:

``` julia
using CSV
using DataFrames
using Dates          # from the standard Julia library
using BSON
```

### Reduce printed output size of DataFrames

By default, the Jupyter Julia kernel prints the first 30 rows of DataFrames. Let's reduce this to 5 by changing the appropriate environment variable:

``` julia
ENV["LINES"] = 5;
```

### Read the data in

We will use the file `time_series_covid19_deaths_global.csv` from the JHU repository. This file contains the daily cumulative number of reported Covid-19 deaths for all countries. Some countries have their data broken down by province/state.

I uploaded it to our training cluster, so you can find it at:  
`~/projects/def-sponsor00/shared/data/time_series_covid19_deaths_global.csv`.

For those running Julia on their computer, you can clone {{<a "https://github.com/CSSEGISandData/COVID-19" "the GitHub repo">}} (or download and unzip it), then find the file `time_series_covid19_deaths_global.csv` in the `csse_covid_19_data/csse_covid_19_time_series/` directory.

``` julia
deaths_global = CSV.read("projects/def-sponsor00/shared/data/time_series_covid19_deaths_global.csv", DataFrame)
```

<div class="data-frame"><p>285 rows × 865 columns (omitted printing of 857 columns)</p><table class="data-frame"><thead><tr><th></th><th>Province/State</th><th>Country/Region</th><th>Lat</th><th>Long</th><th>1/22/20</th><th>1/23/20</th><th>1/24/20</th><th>1/25/20</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Int64">Int64</th><th title="Int64">Int64</th><th title="Int64">Int64</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>2</th><td><em>missing</em></td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>3</th><td><em>missing</em></td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>4</th><td><em>missing</em></td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>5</th><td><em>missing</em></td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Explore the data

``` julia
size(deaths_global)
```

    (285, 865)

``` julia
describe(deaths_global)
```

<div class="data-frame"><p>865 rows × 7 columns</p><table class="data-frame"><thead><tr><th></th><th>variable</th><th>mean</th><th>min</th><th>median</th><th>max</th><th>nmissing</th><th>eltype</th></tr><tr><th></th><th title="Symbol">Symbol</th><th title="Union{Nothing, Float64}">Union…</th><th title="Any">Any</th><th title="Union{Nothing, Float64}">Union…</th><th title="Any">Any</th><th title="Int64">Int64</th><th title="Type">Type</th></tr></thead><tbody><tr><th>1</th><td>Province/State</td><td></td><td>Alberta</td><td></td><td>Zhejiang</td><td>196</td><td>Union{Missing, String}</td></tr><tr><th>2</th><td>Country/Region</td><td></td><td>Afghanistan</td><td></td><td>Zimbabwe</td><td>0</td><td>String</td></tr><tr><th>3</th><td>Lat</td><td>20.1779</td><td>-71.9499</td><td>21.694</td><td>71.7069</td><td>2</td><td>Union{Missing, Float64}</td></tr><tr><th>4</th><td>Long</td><td>22.3317</td><td>-178.117</td><td>20.9394</td><td>178.065</td><td>2</td><td>Union{Missing, Float64}</td></tr><tr><th>5</th><td>1/22/20</td><td>0.0596491</td><td>0</td><td>0.0</td><td>17</td><td>0</td><td>Int64</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Rename some variables to easier names

``` julia
DataFrames.rename!(deaths_global, Dict(1 => Symbol("province"),
                                       2 => Symbol("country")))
```

<div class="data-frame"><p>285 rows × 865 columns (omitted printing of 856 columns)</p><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>1/22/20</th><th>1/23/20</th><th>1/24/20</th><th>1/25/20</th><th>1/26/20</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Int64">Int64</th><th title="Int64">Int64</th><th title="Int64">Int64</th><th title="Int64">Int64</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>2</th><td><em>missing</em></td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>3</th><td><em>missing</em></td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>4</th><td><em>missing</em></td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>5</th><td><em>missing</em></td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Transform the data into long format

``` julia
deaths_global_long = stack(deaths_global, Not(collect(1:4)),
                           variable_name = Symbol("date"),
                           value_name = Symbol("number_deaths"))
```

<div class="data-frame"><p>245,385 rows × 6 columns</p><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th><th>number_deaths</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="String">String</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>1/22/20</td><td>0</td></tr><tr><th>2</th><td><em>missing</em></td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>1/22/20</td><td>0</td></tr><tr><th>3</th><td><em>missing</em></td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>1/22/20</td><td>0</td></tr><tr><th>4</th><td><em>missing</em></td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>1/22/20</td><td>0</td></tr><tr><th>5</th><td><em>missing</em></td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>1/22/20</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Turn the date into the Date type

For this, we need to do multiple things:

 1.  Index the date column <br>
 2.  Add `20` in front of the year through regular expression to make it 4 digits <br>
 3.  Convert into the Date type <br>
 4.  Reassign this to the date column of our DataFrame
{{<br size="3">}}

{{<notes>}}
Step 2. and 3. need to be applied to all elements, so we use broadcasting with the dot notation.
{{</notes>}}
{{<br size="3">}}

``` julia
deaths_global_long.date = Date.(
    replace.(
        deaths_global_long[!, 5],       # (`!` does not make a copy while indexing)
        r"(.*)(..)$" => s"\g<1>20\2"),
    "m/dd/yyyy");
```

This is what our new DataFrame looks like:

``` julia
deaths_global_long
```

<div class="data-frame"><p>245,385 rows × 6 columns</p><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th><th>number_deaths</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>2020-01-22</td><td>0</td></tr><tr><th>2</th><td><em>missing</em></td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>2020-01-22</td><td>0</td></tr><tr><th>3</th><td><em>missing</em></td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>2020-01-22</td><td>0</td></tr><tr><th>4</th><td><em>missing</em></td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>2020-01-22</td><td>0</td></tr><tr><th>5</th><td><em>missing</em></td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>2020-01-22</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Get cumulative totals by country and by date

To do this, we use a classic split-apply-combine workflow:

``` julia
deaths_countries_grouped = groupby(deaths_global_long, [:country, :date])
```

<p><b>GroupedDataFrame with 171339 groups based on keys: country, date</b></p><p><i>First Group (1 row): country = &quot;Afghanistan&quot;, date = Date(&quot;2020-01-22&quot;)</i></p><div class="data-frame"><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th><th>number_deaths</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>2020-01-22</td><td>0</td></tr></tbody></table></div><p>&vellip;</p><p><i>Last Group (1 row): country = &quot;Zimbabwe&quot;, date = Date(&quot;2022-05-31&quot;)</i></p><div class="data-frame"><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th><th>number_deaths</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Zimbabwe</td><td>-19.0154</td><td>29.1549</td><td>2022-05-31</td><td>5503</td></tr></tbody></table></div>

``` julia
deaths_countries = combine(deaths_countries_grouped, :number_deaths => sum)
```

<div class="data-frame"><p>171,339 rows × 3 columns</p><table class="data-frame"><thead><tr><th></th><th>country</th><th>date</th><th>number_deaths_sum</th></tr><tr><th></th><th title="String">String</th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>Afghanistan</td><td>2020-01-22</td><td>0</td></tr><tr><th>2</th><td>Albania</td><td>2020-01-22</td><td>0</td></tr><tr><th>3</th><td>Algeria</td><td>2020-01-22</td><td>0</td></tr><tr><th>4</th><td>Andorra</td><td>2020-01-22</td><td>0</td></tr><tr><th>5</th><td>Angola</td><td>2020-01-22</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Index cumulative totals by date for Canada

``` julia
deaths_canada = filter(:country => isequal("Canada"), deaths_countries)
```

<div class="data-frame"><p>861 rows × 3 columns</p><table class="data-frame"><thead><tr><th></th><th>country</th><th>date</th><th>number_deaths_sum</th></tr><tr><th></th><th title="String">String</th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>Canada</td><td>2020-01-22</td><td>0</td></tr><tr><th>2</th><td>Canada</td><td>2020-01-23</td><td>0</td></tr><tr><th>3</th><td>Canada</td><td>2020-01-24</td><td>0</td></tr><tr><th>4</th><td>Canada</td><td>2020-01-25</td><td>0</td></tr><tr><th>5</th><td>Canada</td><td>2020-01-26</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

We can then drop the country column:

``` julia
select!(deaths_canada, Not(1))
```

<div class="data-frame"><p>861 rows × 2 columns</p><table class="data-frame"><thead><tr><th></th><th>date</th><th>number_deaths_sum</th></tr><tr><th></th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>2020-01-22</td><td>0</td></tr><tr><th>2</th><td>2020-01-23</td><td>0</td></tr><tr><th>3</th><td>2020-01-24</td><td>0</td></tr><tr><th>4</th><td>2020-01-25</td><td>0</td></tr><tr><th>5</th><td>2020-01-26</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

## Saving a Julia object

Let's save our DataFrame `deaths_canada` into a file to plot it in the next chapter.

For this, we will use the {{<a "https://github.com/JuliaIO/BSON.jl" "BSON package">}} which saves a {{<a "https://en.wikipedia.org/wiki/BSON" "BSON">}} file.

``` julia
BSON.@save "deaths_canada.bson" deaths_canada
```

## DataFrame cheatsheet

This example was far from exhaustive. The cheatsheet below will give you an idea of other operations possible on DataFrames:
{{<br size="3">}}

{{<imgmshadow src="/img/dataframes-0.png" title="" width="%" line-height="1.0rem">}}
{{</imgmshadow>}}
{{<imgmshadow src="/img/dataframes-1.png" title="" width="%" line-height="1.0rem">}}
{{</imgmshadow>}}

## Comments & questions
