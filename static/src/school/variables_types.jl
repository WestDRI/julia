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

size(dat)
nrow(dat)
ncol(dat)

dat
typeof(dat)

dat."Province/State"
typeof(dat."Province/State")

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

save("covid.jld", "confirmed", datlong)
