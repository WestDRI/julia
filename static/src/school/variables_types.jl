# * Load packages

using CSV
using DataFrames
using Dates
using JLD

# * Load data

file = "../../data/covid/csse_covid_19_data/csse_covid_19_time_series/" *
    "time_series_covid19_confirmed_global.csv"

dat = DataFrame(CSV.File(file))

# * Explore data

typeof(dat)

names(dat)

size(dat)
nrow(dat)
ncol(dat)

dat[!, 1]
dat[!, "Province/State"]
dat[!, :"Province/State"]
dat."Province/State"

typeof(dat."Province/State")

# * Convert WeakRefStrings.StringArray to String

string([1, 2, 3])
string.([1, 2, 3])

dat[!, 1] = string.(dat[!, 1])
dat[!, 2] = string.(dat[!, 2])

# * Select and order columns

select!(dat, vcat(2, 1, collect(5:ncol(dat))))

# * Rename

:province == Symbol("province")
typeof(:province)

rename!(dat, Dict(1 => :country, 2 => :province))

rename!(dat, Dict([(1, :country), (2, :province)]))

# * Long format

datlong = stack(dat, Not([:country, :province]),
                variable_name = :date,
                value_name = :confirmed)

# * Convert date

datlong.date

datlong.date = Date.(replace.(string.(datlong.date),
                              r"(.*)(..)$" => s"\g<1>20\2"),
                     "m/dd/yy")

datlong

# * Save the datlong object in a file

save("../../data/covid.jld", "confirmed", datlong)
