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

We will need a number of external packages for this. Remember that external packages {{<a "https://westgrid-julia.netlify.app/2022_modules/06_jl_pkg/" "first need to be installed,">}} but you don't have to do anything here as the packages we need are pre-installed on our training cluster. You still have to load them though to make them accessible in the current session:

``` julia
using CSV
using DataFrames
using Dates          # from the standard Julia library
using TimeSeries
using JLD
```

### Load the data

We will use the file `time_series_covid19_deaths_global.csv` from the JHU repository.

I uploaded it to our training cluster, so you can find it at:  
`~/projects/def-sponsor00/shared/data/time_series_covid19_deaths_global.csv`.

``` julia
deaths_global = CSV.read("~/projects/def-sponsor00/shared/data/time_series_covid19_deaths_global.csv", DataFrame)
```

<div class="data-frame"><p>285 rows × 865 columns (omitted printing of 860 columns)</p><table class="data-frame"><thead><tr><th></th><th>Province/State</th><th>Country/Region</th><th>Lat</th><th>Long</th><th>1/22/20</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td><em>missing</em></td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>0</td></tr><tr><th>2</th><td><em>missing</em></td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>0</td></tr><tr><th>3</th><td><em>missing</em></td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>0</td></tr><tr><th>4</th><td><em>missing</em></td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>0</td></tr><tr><th>5</th><td><em>missing</em></td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>0</td></tr><tr><th>6</th><td><em>missing</em></td><td>Antarctica</td><td>-71.9499</td><td>23.347</td><td>0</td></tr><tr><th>7</th><td><em>missing</em></td><td>Antigua and Barbuda</td><td>17.0608</td><td>-61.7964</td><td>0</td></tr><tr><th>8</th><td><em>missing</em></td><td>Argentina</td><td>-38.4161</td><td>-63.6167</td><td>0</td></tr><tr><th>9</th><td><em>missing</em></td><td>Armenia</td><td>40.0691</td><td>45.0382</td><td>0</td></tr><tr><th>10</th><td>Australian Capital Territory</td><td>Australia</td><td>-35.4735</td><td>149.012</td><td>0</td></tr><tr><th>11</th><td>New South Wales</td><td>Australia</td><td>-33.8688</td><td>151.209</td><td>0</td></tr><tr><th>12</th><td>Northern Territory</td><td>Australia</td><td>-12.4634</td><td>130.846</td><td>0</td></tr><tr><th>13</th><td>Queensland</td><td>Australia</td><td>-27.4698</td><td>153.025</td><td>0</td></tr><tr><th>14</th><td>South Australia</td><td>Australia</td><td>-34.9285</td><td>138.601</td><td>0</td></tr><tr><th>15</th><td>Tasmania</td><td>Australia</td><td>-42.8821</td><td>147.327</td><td>0</td></tr><tr><th>16</th><td>Victoria</td><td>Australia</td><td>-37.8136</td><td>144.963</td><td>0</td></tr><tr><th>17</th><td>Western Australia</td><td>Australia</td><td>-31.9505</td><td>115.861</td><td>0</td></tr><tr><th>18</th><td><em>missing</em></td><td>Austria</td><td>47.5162</td><td>14.5501</td><td>0</td></tr><tr><th>19</th><td><em>missing</em></td><td>Azerbaijan</td><td>40.1431</td><td>47.5769</td><td>0</td></tr><tr><th>20</th><td><em>missing</em></td><td>Bahamas</td><td>25.0259</td><td>-78.0359</td><td>0</td></tr><tr><th>21</th><td><em>missing</em></td><td>Bahrain</td><td>26.0275</td><td>50.55</td><td>0</td></tr><tr><th>22</th><td><em>missing</em></td><td>Bangladesh</td><td>23.685</td><td>90.3563</td><td>0</td></tr><tr><th>23</th><td><em>missing</em></td><td>Barbados</td><td>13.1939</td><td>-59.5432</td><td>0</td></tr><tr><th>24</th><td><em>missing</em></td><td>Belarus</td><td>53.7098</td><td>27.9534</td><td>0</td></tr><tr><th>25</th><td><em>missing</em></td><td>Belgium</td><td>50.8333</td><td>4.46994</td><td>0</td></tr><tr><th>26</th><td><em>missing</em></td><td>Belize</td><td>17.1899</td><td>-88.4976</td><td>0</td></tr><tr><th>27</th><td><em>missing</em></td><td>Benin</td><td>9.3077</td><td>2.3158</td><td>0</td></tr><tr><th>28</th><td><em>missing</em></td><td>Bhutan</td><td>27.5142</td><td>90.4336</td><td>0</td></tr><tr><th>29</th><td><em>missing</em></td><td>Bolivia</td><td>-16.2902</td><td>-63.5887</td><td>0</td></tr><tr><th>30</th><td><em>missing</em></td><td>Bosnia and Herzegovina</td><td>43.9159</td><td>17.6791</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Explore the data

``` julia
size(deaths_global)
```

    (285, 865)

``` julia
describe(deaths_global)
```

<div class="data-frame"><p>865 rows × 7 columns</p><table class="data-frame"><thead><tr><th></th><th>variable</th><th>mean</th><th>min</th><th>median</th><th>max</th><th>nmissing</th><th>eltype</th></tr><tr><th></th><th title="Symbol">Symbol</th><th title="Union{Nothing, Float64}">Union…</th><th title="Any">Any</th><th title="Union{Nothing, Float64}">Union…</th><th title="Any">Any</th><th title="Int64">Int64</th><th title="Type">Type</th></tr></thead><tbody><tr><th>1</th><td>Province/State</td><td></td><td>Alberta</td><td></td><td>Zhejiang</td><td>196</td><td>Union{Missing, String}</td></tr><tr><th>2</th><td>Country/Region</td><td></td><td>Afghanistan</td><td></td><td>Zimbabwe</td><td>0</td><td>String</td></tr><tr><th>3</th><td>Lat</td><td>20.1779</td><td>-71.9499</td><td>21.694</td><td>71.7069</td><td>2</td><td>Union{Missing, Float64}</td></tr><tr><th>4</th><td>Long</td><td>22.3317</td><td>-178.117</td><td>20.9394</td><td>178.065</td><td>2</td><td>Union{Missing, Float64}</td></tr><tr><th>5</th><td>1/22/20</td><td>0.0596491</td><td>0</td><td>0.0</td><td>17</td><td>0</td><td>Int64</td></tr><tr><th>6</th><td>1/23/20</td><td>0.0631579</td><td>0</td><td>0.0</td><td>17</td><td>0</td><td>Int64</td></tr><tr><th>7</th><td>1/24/20</td><td>0.0912281</td><td>0</td><td>0.0</td><td>24</td><td>0</td><td>Int64</td></tr><tr><th>8</th><td>1/25/20</td><td>0.147368</td><td>0</td><td>0.0</td><td>40</td><td>0</td><td>Int64</td></tr><tr><th>9</th><td>1/26/20</td><td>0.196491</td><td>0</td><td>0.0</td><td>52</td><td>0</td><td>Int64</td></tr><tr><th>10</th><td>1/27/20</td><td>0.287719</td><td>0</td><td>0.0</td><td>76</td><td>0</td><td>Int64</td></tr><tr><th>11</th><td>1/28/20</td><td>0.459649</td><td>0</td><td>0.0</td><td>125</td><td>0</td><td>Int64</td></tr><tr><th>12</th><td>1/29/20</td><td>0.466667</td><td>0</td><td>0.0</td><td>125</td><td>0</td><td>Int64</td></tr><tr><th>13</th><td>1/30/20</td><td>0.6</td><td>0</td><td>0.0</td><td>162</td><td>0</td><td>Int64</td></tr><tr><th>14</th><td>1/31/20</td><td>0.747368</td><td>0</td><td>0.0</td><td>204</td><td>0</td><td>Int64</td></tr><tr><th>15</th><td>2/1/20</td><td>0.908772</td><td>0</td><td>0.0</td><td>249</td><td>0</td><td>Int64</td></tr><tr><th>16</th><td>2/2/20</td><td>1.27018</td><td>0</td><td>0.0</td><td>350</td><td>0</td><td>Int64</td></tr><tr><th>17</th><td>2/3/20</td><td>1.49474</td><td>0</td><td>0.0</td><td>414</td><td>0</td><td>Int64</td></tr><tr><th>18</th><td>2/4/20</td><td>1.72632</td><td>0</td><td>0.0</td><td>479</td><td>0</td><td>Int64</td></tr><tr><th>19</th><td>2/5/20</td><td>1.97895</td><td>0</td><td>0.0</td><td>549</td><td>0</td><td>Int64</td></tr><tr><th>20</th><td>2/6/20</td><td>2.22456</td><td>0</td><td>0.0</td><td>618</td><td>0</td><td>Int64</td></tr><tr><th>21</th><td>2/7/20</td><td>2.52281</td><td>0</td><td>0.0</td><td>699</td><td>0</td><td>Int64</td></tr><tr><th>22</th><td>2/8/20</td><td>2.82807</td><td>0</td><td>0.0</td><td>780</td><td>0</td><td>Int64</td></tr><tr><th>23</th><td>2/9/20</td><td>3.17895</td><td>0</td><td>0.0</td><td>871</td><td>0</td><td>Int64</td></tr><tr><th>24</th><td>2/10/20</td><td>3.55439</td><td>0</td><td>0.0</td><td>974</td><td>0</td><td>Int64</td></tr><tr><th>25</th><td>2/11/20</td><td>3.90526</td><td>0</td><td>0.0</td><td>1068</td><td>0</td><td>Int64</td></tr><tr><th>26</th><td>2/12/20</td><td>3.92281</td><td>0</td><td>0.0</td><td>1068</td><td>0</td><td>Int64</td></tr><tr><th>27</th><td>2/13/20</td><td>4.81053</td><td>0</td><td>0.0</td><td>1310</td><td>0</td><td>Int64</td></tr><tr><th>28</th><td>2/14/20</td><td>5.34386</td><td>0</td><td>0.0</td><td>1457</td><td>0</td><td>Int64</td></tr><tr><th>29</th><td>2/15/20</td><td>5.84561</td><td>0</td><td>0.0</td><td>1596</td><td>0</td><td>Int64</td></tr><tr><th>30</th><td>2/16/20</td><td>6.21053</td><td>0</td><td>0.0</td><td>1696</td><td>0</td><td>Int64</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Replace missing values by the string "NA"

``` julia
replace!(deaths_global[!, 1], missing => "NA");
deaths_global
```

<div class="data-frame"><p>285 rows × 865 columns (omitted printing of 860 columns)</p><table class="data-frame"><thead><tr><th></th><th>Province/State</th><th>Country/Region</th><th>Lat</th><th>Long</th><th>1/22/20</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>NA</td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>0</td></tr><tr><th>2</th><td>NA</td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>0</td></tr><tr><th>3</th><td>NA</td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>0</td></tr><tr><th>4</th><td>NA</td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>0</td></tr><tr><th>5</th><td>NA</td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>0</td></tr><tr><th>6</th><td>NA</td><td>Antarctica</td><td>-71.9499</td><td>23.347</td><td>0</td></tr><tr><th>7</th><td>NA</td><td>Antigua and Barbuda</td><td>17.0608</td><td>-61.7964</td><td>0</td></tr><tr><th>8</th><td>NA</td><td>Argentina</td><td>-38.4161</td><td>-63.6167</td><td>0</td></tr><tr><th>9</th><td>NA</td><td>Armenia</td><td>40.0691</td><td>45.0382</td><td>0</td></tr><tr><th>10</th><td>Australian Capital Territory</td><td>Australia</td><td>-35.4735</td><td>149.012</td><td>0</td></tr><tr><th>11</th><td>New South Wales</td><td>Australia</td><td>-33.8688</td><td>151.209</td><td>0</td></tr><tr><th>12</th><td>Northern Territory</td><td>Australia</td><td>-12.4634</td><td>130.846</td><td>0</td></tr><tr><th>13</th><td>Queensland</td><td>Australia</td><td>-27.4698</td><td>153.025</td><td>0</td></tr><tr><th>14</th><td>South Australia</td><td>Australia</td><td>-34.9285</td><td>138.601</td><td>0</td></tr><tr><th>15</th><td>Tasmania</td><td>Australia</td><td>-42.8821</td><td>147.327</td><td>0</td></tr><tr><th>16</th><td>Victoria</td><td>Australia</td><td>-37.8136</td><td>144.963</td><td>0</td></tr><tr><th>17</th><td>Western Australia</td><td>Australia</td><td>-31.9505</td><td>115.861</td><td>0</td></tr><tr><th>18</th><td>NA</td><td>Austria</td><td>47.5162</td><td>14.5501</td><td>0</td></tr><tr><th>19</th><td>NA</td><td>Azerbaijan</td><td>40.1431</td><td>47.5769</td><td>0</td></tr><tr><th>20</th><td>NA</td><td>Bahamas</td><td>25.0259</td><td>-78.0359</td><td>0</td></tr><tr><th>21</th><td>NA</td><td>Bahrain</td><td>26.0275</td><td>50.55</td><td>0</td></tr><tr><th>22</th><td>NA</td><td>Bangladesh</td><td>23.685</td><td>90.3563</td><td>0</td></tr><tr><th>23</th><td>NA</td><td>Barbados</td><td>13.1939</td><td>-59.5432</td><td>0</td></tr><tr><th>24</th><td>NA</td><td>Belarus</td><td>53.7098</td><td>27.9534</td><td>0</td></tr><tr><th>25</th><td>NA</td><td>Belgium</td><td>50.8333</td><td>4.46994</td><td>0</td></tr><tr><th>26</th><td>NA</td><td>Belize</td><td>17.1899</td><td>-88.4976</td><td>0</td></tr><tr><th>27</th><td>NA</td><td>Benin</td><td>9.3077</td><td>2.3158</td><td>0</td></tr><tr><th>28</th><td>NA</td><td>Bhutan</td><td>27.5142</td><td>90.4336</td><td>0</td></tr><tr><th>29</th><td>NA</td><td>Bolivia</td><td>-16.2902</td><td>-63.5887</td><td>0</td></tr><tr><th>30</th><td>NA</td><td>Bosnia and Herzegovina</td><td>43.9159</td><td>17.6791</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Rename some variables to easier names

``` julia
DataFrames.rename!(deaths_global, Dict.(1 => Symbol("province"),
                                        2 => Symbol("country")))
```

<div class="data-frame"><p>285 rows × 865 columns (omitted printing of 860 columns)</p><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>1/22/20</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>NA</td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>0</td></tr><tr><th>2</th><td>NA</td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>0</td></tr><tr><th>3</th><td>NA</td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>0</td></tr><tr><th>4</th><td>NA</td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>0</td></tr><tr><th>5</th><td>NA</td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>0</td></tr><tr><th>6</th><td>NA</td><td>Antarctica</td><td>-71.9499</td><td>23.347</td><td>0</td></tr><tr><th>7</th><td>NA</td><td>Antigua and Barbuda</td><td>17.0608</td><td>-61.7964</td><td>0</td></tr><tr><th>8</th><td>NA</td><td>Argentina</td><td>-38.4161</td><td>-63.6167</td><td>0</td></tr><tr><th>9</th><td>NA</td><td>Armenia</td><td>40.0691</td><td>45.0382</td><td>0</td></tr><tr><th>10</th><td>Australian Capital Territory</td><td>Australia</td><td>-35.4735</td><td>149.012</td><td>0</td></tr><tr><th>11</th><td>New South Wales</td><td>Australia</td><td>-33.8688</td><td>151.209</td><td>0</td></tr><tr><th>12</th><td>Northern Territory</td><td>Australia</td><td>-12.4634</td><td>130.846</td><td>0</td></tr><tr><th>13</th><td>Queensland</td><td>Australia</td><td>-27.4698</td><td>153.025</td><td>0</td></tr><tr><th>14</th><td>South Australia</td><td>Australia</td><td>-34.9285</td><td>138.601</td><td>0</td></tr><tr><th>15</th><td>Tasmania</td><td>Australia</td><td>-42.8821</td><td>147.327</td><td>0</td></tr><tr><th>16</th><td>Victoria</td><td>Australia</td><td>-37.8136</td><td>144.963</td><td>0</td></tr><tr><th>17</th><td>Western Australia</td><td>Australia</td><td>-31.9505</td><td>115.861</td><td>0</td></tr><tr><th>18</th><td>NA</td><td>Austria</td><td>47.5162</td><td>14.5501</td><td>0</td></tr><tr><th>19</th><td>NA</td><td>Azerbaijan</td><td>40.1431</td><td>47.5769</td><td>0</td></tr><tr><th>20</th><td>NA</td><td>Bahamas</td><td>25.0259</td><td>-78.0359</td><td>0</td></tr><tr><th>21</th><td>NA</td><td>Bahrain</td><td>26.0275</td><td>50.55</td><td>0</td></tr><tr><th>22</th><td>NA</td><td>Bangladesh</td><td>23.685</td><td>90.3563</td><td>0</td></tr><tr><th>23</th><td>NA</td><td>Barbados</td><td>13.1939</td><td>-59.5432</td><td>0</td></tr><tr><th>24</th><td>NA</td><td>Belarus</td><td>53.7098</td><td>27.9534</td><td>0</td></tr><tr><th>25</th><td>NA</td><td>Belgium</td><td>50.8333</td><td>4.46994</td><td>0</td></tr><tr><th>26</th><td>NA</td><td>Belize</td><td>17.1899</td><td>-88.4976</td><td>0</td></tr><tr><th>27</th><td>NA</td><td>Benin</td><td>9.3077</td><td>2.3158</td><td>0</td></tr><tr><th>28</th><td>NA</td><td>Bhutan</td><td>27.5142</td><td>90.4336</td><td>0</td></tr><tr><th>29</th><td>NA</td><td>Bolivia</td><td>-16.2902</td><td>-63.5887</td><td>0</td></tr><tr><th>30</th><td>NA</td><td>Bosnia and Herzegovina</td><td>43.9159</td><td>17.6791</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Transform the data into long format

``` julia
deaths_global_long = stack(deaths_global, Not(collect(1:4)),
                           variable_name = Symbol("date"),
                           value_name = Symbol("number_deaths"))
```

<div class="data-frame"><p>245,385 rows × 6 columns (omitted printing of 1 columns)</p><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="String">String</th></tr></thead><tbody><tr><th>1</th><td>NA</td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>1/22/20</td></tr><tr><th>2</th><td>NA</td><td>Albania</td><td>41.1533</td><td>20.1683</td><td>1/22/20</td></tr><tr><th>3</th><td>NA</td><td>Algeria</td><td>28.0339</td><td>1.6596</td><td>1/22/20</td></tr><tr><th>4</th><td>NA</td><td>Andorra</td><td>42.5063</td><td>1.5218</td><td>1/22/20</td></tr><tr><th>5</th><td>NA</td><td>Angola</td><td>-11.2027</td><td>17.8739</td><td>1/22/20</td></tr><tr><th>6</th><td>NA</td><td>Antarctica</td><td>-71.9499</td><td>23.347</td><td>1/22/20</td></tr><tr><th>7</th><td>NA</td><td>Antigua and Barbuda</td><td>17.0608</td><td>-61.7964</td><td>1/22/20</td></tr><tr><th>8</th><td>NA</td><td>Argentina</td><td>-38.4161</td><td>-63.6167</td><td>1/22/20</td></tr><tr><th>9</th><td>NA</td><td>Armenia</td><td>40.0691</td><td>45.0382</td><td>1/22/20</td></tr><tr><th>10</th><td>Australian Capital Territory</td><td>Australia</td><td>-35.4735</td><td>149.012</td><td>1/22/20</td></tr><tr><th>11</th><td>New South Wales</td><td>Australia</td><td>-33.8688</td><td>151.209</td><td>1/22/20</td></tr><tr><th>12</th><td>Northern Territory</td><td>Australia</td><td>-12.4634</td><td>130.846</td><td>1/22/20</td></tr><tr><th>13</th><td>Queensland</td><td>Australia</td><td>-27.4698</td><td>153.025</td><td>1/22/20</td></tr><tr><th>14</th><td>South Australia</td><td>Australia</td><td>-34.9285</td><td>138.601</td><td>1/22/20</td></tr><tr><th>15</th><td>Tasmania</td><td>Australia</td><td>-42.8821</td><td>147.327</td><td>1/22/20</td></tr><tr><th>16</th><td>Victoria</td><td>Australia</td><td>-37.8136</td><td>144.963</td><td>1/22/20</td></tr><tr><th>17</th><td>Western Australia</td><td>Australia</td><td>-31.9505</td><td>115.861</td><td>1/22/20</td></tr><tr><th>18</th><td>NA</td><td>Austria</td><td>47.5162</td><td>14.5501</td><td>1/22/20</td></tr><tr><th>19</th><td>NA</td><td>Azerbaijan</td><td>40.1431</td><td>47.5769</td><td>1/22/20</td></tr><tr><th>20</th><td>NA</td><td>Bahamas</td><td>25.0259</td><td>-78.0359</td><td>1/22/20</td></tr><tr><th>21</th><td>NA</td><td>Bahrain</td><td>26.0275</td><td>50.55</td><td>1/22/20</td></tr><tr><th>22</th><td>NA</td><td>Bangladesh</td><td>23.685</td><td>90.3563</td><td>1/22/20</td></tr><tr><th>23</th><td>NA</td><td>Barbados</td><td>13.1939</td><td>-59.5432</td><td>1/22/20</td></tr><tr><th>24</th><td>NA</td><td>Belarus</td><td>53.7098</td><td>27.9534</td><td>1/22/20</td></tr><tr><th>25</th><td>NA</td><td>Belgium</td><td>50.8333</td><td>4.46994</td><td>1/22/20</td></tr><tr><th>26</th><td>NA</td><td>Belize</td><td>17.1899</td><td>-88.4976</td><td>1/22/20</td></tr><tr><th>27</th><td>NA</td><td>Benin</td><td>9.3077</td><td>2.3158</td><td>1/22/20</td></tr><tr><th>28</th><td>NA</td><td>Bhutan</td><td>27.5142</td><td>90.4336</td><td>1/22/20</td></tr><tr><th>29</th><td>NA</td><td>Bolivia</td><td>-16.2902</td><td>-63.5887</td><td>1/22/20</td></tr><tr><th>30</th><td>NA</td><td>Bosnia and Herzegovina</td><td>43.9159</td><td>17.6791</td><td>1/22/20</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Views of the data

Instead of indexing a DataFrame, it is a lot more memory efficient to create a view.

### Get totals by country

``` julia
deaths_countries_grouped = groupby(deaths_global_long, [:country, :date])
```

<p><b>GroupedDataFrame with 171339 groups based on keys: country, date</b></p><p><i>First Group (1 row): country = &quot;Afghanistan&quot;, date = &quot;1/22/20&quot;</i></p><div class="data-frame"><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th><th>number_deaths</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="String">String</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>NA</td><td>Afghanistan</td><td>33.9391</td><td>67.71</td><td>1/22/20</td><td>0</td></tr></tbody></table></div><p>&vellip;</p><p><i>Last Group (1 row): country = &quot;Zimbabwe&quot;, date = &quot;5/31/22&quot;</i></p><div class="data-frame"><table class="data-frame"><thead><tr><th></th><th>province</th><th>country</th><th>Lat</th><th>Long</th><th>date</th><th>number_deaths</th></tr><tr><th></th><th title="Union{Missing, String}">String?</th><th title="String">String</th><th title="Union{Missing, Float64}">Float64?</th><th title="Union{Missing, Float64}">Float64?</th><th title="String">String</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>NA</td><td>Zimbabwe</td><td>-19.0154</td><td>29.1549</td><td>5/31/22</td><td>5503</td></tr></tbody></table></div>

``` julia
deaths_countries_sums = combine(deaths_countries_grouped, :number_deaths => sum)
```

<div class="data-frame"><p>171,339 rows × 3 columns</p><table class="data-frame"><thead><tr><th></th><th>country</th><th>date</th><th>number_deaths_sum</th></tr><tr><th></th><th title="String">String</th><th title="String">String</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>Afghanistan</td><td>1/22/20</td><td>0</td></tr><tr><th>2</th><td>Albania</td><td>1/22/20</td><td>0</td></tr><tr><th>3</th><td>Algeria</td><td>1/22/20</td><td>0</td></tr><tr><th>4</th><td>Andorra</td><td>1/22/20</td><td>0</td></tr><tr><th>5</th><td>Angola</td><td>1/22/20</td><td>0</td></tr><tr><th>6</th><td>Antarctica</td><td>1/22/20</td><td>0</td></tr><tr><th>7</th><td>Antigua and Barbuda</td><td>1/22/20</td><td>0</td></tr><tr><th>8</th><td>Argentina</td><td>1/22/20</td><td>0</td></tr><tr><th>9</th><td>Armenia</td><td>1/22/20</td><td>0</td></tr><tr><th>10</th><td>Australia</td><td>1/22/20</td><td>0</td></tr><tr><th>11</th><td>Austria</td><td>1/22/20</td><td>0</td></tr><tr><th>12</th><td>Azerbaijan</td><td>1/22/20</td><td>0</td></tr><tr><th>13</th><td>Bahamas</td><td>1/22/20</td><td>0</td></tr><tr><th>14</th><td>Bahrain</td><td>1/22/20</td><td>0</td></tr><tr><th>15</th><td>Bangladesh</td><td>1/22/20</td><td>0</td></tr><tr><th>16</th><td>Barbados</td><td>1/22/20</td><td>0</td></tr><tr><th>17</th><td>Belarus</td><td>1/22/20</td><td>0</td></tr><tr><th>18</th><td>Belgium</td><td>1/22/20</td><td>0</td></tr><tr><th>19</th><td>Belize</td><td>1/22/20</td><td>0</td></tr><tr><th>20</th><td>Benin</td><td>1/22/20</td><td>0</td></tr><tr><th>21</th><td>Bhutan</td><td>1/22/20</td><td>0</td></tr><tr><th>22</th><td>Bolivia</td><td>1/22/20</td><td>0</td></tr><tr><th>23</th><td>Bosnia and Herzegovina</td><td>1/22/20</td><td>0</td></tr><tr><th>24</th><td>Botswana</td><td>1/22/20</td><td>0</td></tr><tr><th>25</th><td>Brazil</td><td>1/22/20</td><td>0</td></tr><tr><th>26</th><td>Brunei</td><td>1/22/20</td><td>0</td></tr><tr><th>27</th><td>Bulgaria</td><td>1/22/20</td><td>0</td></tr><tr><th>28</th><td>Burkina Faso</td><td>1/22/20</td><td>0</td></tr><tr><th>29</th><td>Burma</td><td>1/22/20</td><td>0</td></tr><tr><th>30</th><td>Burundi</td><td>1/22/20</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

## Working with dates

### Turn the date into a proper date format

``` julia
#= Turn the year from 2 digits to 4 digits using regular expression
(in a vectorised fashion by braodcasting with the dot notation);
then turn these values into strings, and finally into dates =#
deaths_countries_sums.date = Date.(replace.(string.(deaths_countries_sums[!, 2]),
                                            r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy")
```

    171339-element Vector{Date}:
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     2020-01-22
     ⋮
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31
     2022-05-31

``` julia
deaths_countries_sums
```

<div class="data-frame"><p>171,339 rows × 3 columns</p><table class="data-frame"><thead><tr><th></th><th>country</th><th>date</th><th>number_deaths_sum</th></tr><tr><th></th><th title="String">String</th><th title="Date">Date</th><th title="Int64">Int64</th></tr></thead><tbody><tr><th>1</th><td>Afghanistan</td><td>2020-01-22</td><td>0</td></tr><tr><th>2</th><td>Albania</td><td>2020-01-22</td><td>0</td></tr><tr><th>3</th><td>Algeria</td><td>2020-01-22</td><td>0</td></tr><tr><th>4</th><td>Andorra</td><td>2020-01-22</td><td>0</td></tr><tr><th>5</th><td>Angola</td><td>2020-01-22</td><td>0</td></tr><tr><th>6</th><td>Antarctica</td><td>2020-01-22</td><td>0</td></tr><tr><th>7</th><td>Antigua and Barbuda</td><td>2020-01-22</td><td>0</td></tr><tr><th>8</th><td>Argentina</td><td>2020-01-22</td><td>0</td></tr><tr><th>9</th><td>Armenia</td><td>2020-01-22</td><td>0</td></tr><tr><th>10</th><td>Australia</td><td>2020-01-22</td><td>0</td></tr><tr><th>11</th><td>Austria</td><td>2020-01-22</td><td>0</td></tr><tr><th>12</th><td>Azerbaijan</td><td>2020-01-22</td><td>0</td></tr><tr><th>13</th><td>Bahamas</td><td>2020-01-22</td><td>0</td></tr><tr><th>14</th><td>Bahrain</td><td>2020-01-22</td><td>0</td></tr><tr><th>15</th><td>Bangladesh</td><td>2020-01-22</td><td>0</td></tr><tr><th>16</th><td>Barbados</td><td>2020-01-22</td><td>0</td></tr><tr><th>17</th><td>Belarus</td><td>2020-01-22</td><td>0</td></tr><tr><th>18</th><td>Belgium</td><td>2020-01-22</td><td>0</td></tr><tr><th>19</th><td>Belize</td><td>2020-01-22</td><td>0</td></tr><tr><th>20</th><td>Benin</td><td>2020-01-22</td><td>0</td></tr><tr><th>21</th><td>Bhutan</td><td>2020-01-22</td><td>0</td></tr><tr><th>22</th><td>Bolivia</td><td>2020-01-22</td><td>0</td></tr><tr><th>23</th><td>Bosnia and Herzegovina</td><td>2020-01-22</td><td>0</td></tr><tr><th>24</th><td>Botswana</td><td>2020-01-22</td><td>0</td></tr><tr><th>25</th><td>Brazil</td><td>2020-01-22</td><td>0</td></tr><tr><th>26</th><td>Brunei</td><td>2020-01-22</td><td>0</td></tr><tr><th>27</th><td>Bulgaria</td><td>2020-01-22</td><td>0</td></tr><tr><th>28</th><td>Burkina Faso</td><td>2020-01-22</td><td>0</td></tr><tr><th>29</th><td>Burma</td><td>2020-01-22</td><td>0</td></tr><tr><th>30</th><td>Burundi</td><td>2020-01-22</td><td>0</td></tr><tr><th>&vellip;</th><td>&vellip;</td><td>&vellip;</td><td>&vellip;</td></tr></tbody></table></div>

### Time series

Our data is a time series, we need to transform it to a TimeArray thanks to the {{<c>}}TimeArray(){{</c>}} function from the TimeSeries package.

``` julia
deaths_countries = TimeArray(deaths_countries_sums, timestamp = :date)
```

    171339×2 TimeArray{Any, 2, Date, Matrix{Any}} 2020-01-22 to 2022-05-31
    │            │ country                │ number_deaths_sum │
    ├────────────┼────────────────────────┼───────────────────┤
    │ 2020-01-22 │ "Afghanistan"          │ 0                 │
    │ 2020-01-22 │ "Albania"              │ 0                 │
    │ 2020-01-22 │ "Algeria"              │ 0                 │
    │ 2020-01-22 │ "Andorra"              │ 0                 │
    │ 2020-01-22 │ "Angola"               │ 0                 │
    │ 2020-01-22 │ "Antarctica"           │ 0                 │
    │ 2020-01-22 │ "Antigua and Barbuda"  │ 0                 │
    │ 2020-01-22 │ "Argentina"            │ 0                 │
    │ 2020-01-22 │ "Armenia"              │ 0                 │
    │ 2020-01-22 │ "Australia"            │ 0                 │
    │ 2020-01-22 │ "Austria"              │ 0                 │
    │ ⋮          │ ⋮                      │ ⋮                 │
    │ 2022-05-31 │ "Uruguay"              │ 7238              │
    │ 2022-05-31 │ "Uzbekistan"           │ 1637              │
    │ 2022-05-31 │ "Vanuatu"              │ 14                │
    │ 2022-05-31 │ "Venezuela"            │ 5721              │
    │ 2022-05-31 │ "Vietnam"              │ 43079             │
    │ 2022-05-31 │ "West Bank and Gaza"   │ 5660              │
    │ 2022-05-31 │ "Winter Olympics 2022" │ 0                 │
    │ 2022-05-31 │ "Yemen"                │ 2149              │
    │ 2022-05-31 │ "Zambia"               │ 3987              │
    │ 2022-05-31 │ "Zimbabwe"             │ 5503              │

## Saving a Julia object

``` julia
save("deaths_countries.jld", "deaths_countries", deaths_countries)
```

## DataFrame cheatsheet

{{<imgmshadow src="/img/dataframes-0.png" title="" width="%" line-height="1.0rem">}}
{{</imgmshadow>}}
{{<imgmshadow src="/img/dataframes-1.png" title="" width="%" line-height="1.0rem">}}
{{</imgmshadow>}}

## Comments & questions
