# * setup

# ** load packages

using CSV
using DataFrames
using Plots
using Dates
using TimeSeries
gr();

# * load data in an array of 2 df

conf_file = "/home/marie/parvus/pwg/wtm/tjl/static/data/covid/" *
    "csse_covid_19_data/csse_covid_19_time_series/" *
    "time_series_covid19_confirmed_global.csv"

dead_file = "/home/marie/parvus/pwg/wtm/tjl/static/data/covid/" *
    "csse_covid_19_data/csse_covid_19_time_series/" *
    "time_series_covid19_deaths_global.csv"

dat = DataFrame.(CSV.File.([conf_file, dead_file]))

# * transform to long format

DataFrames.rename!.(dat, Dict.(1 => Symbol("province"),
                               2 => Symbol("country")))

var = ["conf", "dead"];

datlong = map((x, y) -> stack(x, Not(collect(1:4)),
                              variable_name = Symbol("date"),
                              value_name = Symbol("$y")),
              dat, var)

all = innerjoin(datlong[1], datlong[2],
                on = [:date, :country, :province, :Lat, :Long],
                makeunique = false, validate = (false, false))

select!(all, [5, 2, 1, 6, 7])

all.date = Date.(replace.(string.(all.date),
                          r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy");

# * world summary

world = combine(groupby(all, :date),
                :conf => sum => :conf,
                :dead => sum => :dead)

plot(TimeArray(world, timestamp = :date),
     title = "World", legend = :outertopright)

# savefig(plot(TimeArray(world, timestamp = :date),
#              title = "World", legend = :outertopright,
#              widen = :false, dpi = :300),
#         "../../plot/jupyterdays/world.png")

# * plot for selected countries

canada = all[all.country .== "Canada", :]
canada = combine(groupby(canada, :date),
                 :conf => sum => :canada_conf,
                 :dead => sum => :canada_dead)

us = all[all.country .== "US", :]
select!(us, Not([2, 3]))
DataFrames.rename!(us, :conf => :us_conf, :dead => :us_dead)

mexico = all[all.country .== "Mexico", :]
select!(mexico, Not([2, 3]))
DataFrames.rename!(mexico, :conf => :mexico_conf, :dead => :mexico_dead)

france = all[all.country .== "France", :]
france = combine(groupby(france, :date),
                 :conf => sum => :france_conf,
                 :dead => sum => :france_dead)

countries = innerjoin(canada, us, mexico, france,
                      on = :date, makeunique = false,
                      validate = (false, false))

confirmed = select(countries, [1, 2, 4, 6, 8])
DataFrames.rename!(confirmed, replace.(names(confirmed), r"_conf" => s""))

plot(TimeArray(confirmed, timestamp = :date),
     title = "Confirmed cases", legend = :outertopright)

dead = select(countries, [1, 3, 5, 7, 9])
DataFrames.rename!(dead, replace.(names(dead), r"_dead" => s""))

plot(TimeArray(dead, timestamp = :date),
     title = "Deaths", legend = :outertopright)
