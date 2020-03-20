# * load

# ** packages

using CSV
using DataFrames
using Plots
using Dates
using TimeSeries

# ** data

confirmed = DataFrame(CSV.File("covid_db/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"))

dead = DataFrame(CSV.File("covid_db/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"))

recovered = DataFrame(CSV.File("covid_db/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"))

# * raw data

# ** confirmed

rename!(confirmed, Dict(1 => Symbol("province"),
                        2 => Symbol("country")))

select!(confirmed, Not([3, 4]))

conf_long = stack(confirmed, Not([1, 2]),
                  variable_name = Symbol("date"),
                  value_name = Symbol("total"))

select!(conf_long, [4, 3, 1, 2])

conf_long.date = Date.(
    replace.(string.(conf_long[:, 3]),
             r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy"
)

conf_long.province = replace(conf_long.province, missing => "NA")

# conf = groupby(conf_long, [:country, :province])

# france = conf_long[conf_long[:, :province] .== "France", :]

# fr = TimeArray(france, timestamp = :date)

# plot(fr.total)

# britcol = conf_long[(conf_long[:, :country] .== "Canada") .& (conf_long[:, :province] .== "British Columbia"), :]

# bc = TimeArray(britcol, timestamp = :date)

# plot(bc.total)

# india = conf_long[conf_long[:, :country] .== "India", :]

# in = TimeArray(india, timestamp = :date)

# plot(in.total)

# ** dead

rename!(dead, Dict(1 => Symbol("province"),
                   2 => Symbol("country")))

select!(dead, Not([3, 4]))

dead_long = stack(dead, Not([1, 2]),
                  variable_name = Symbol("date"),
                  value_name = Symbol("total"))

select!(dead_long, [4, 3, 1, 2])

dead_long.date = Date.(
    replace.(string.(dead_long[:, 3]),
             r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy"
)

dead_long.province = replace(dead_long.province, missing => "NA")

# deaths = groupby(dead_long, [:country, :province])

# france = dead_long[dead_long[:, :province] .== "France", :]

# fr = TimeArray(france, timestamp = :date)

# plot(fr.total)

# britcol = dead_long[(dead_long[:, :country] .== "Canada") .& (dead_long[:, :province] .== "British Columbia"), :]

# bc = TimeArray(britcol, timestamp = :date)

# plot(bc.total)

# india = dead_long[dead_long[:, :country] .== "India", :]

# in = TimeArray(india, timestamp = :date)

# plot(in.total)

# ** recovered

rename!(recovered, Dict(1 => Symbol("province"),
                        2 => Symbol("country")))

select!(recovered, Not([3, 4]))

recov_long = stack(recovered, Not([1, 2]),
                  variable_name = Symbol("date"),
                  value_name = Symbol("total"))

select!(recov_long, [4, 3, 1, 2])

recov_long.date = Date.(
    replace.(string.(recov_long[:, 3]),
             r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy"
)

recov_long.province = replace(recov_long.province, missing => "NA")

# recov = groupby(recov_long, [:country, :province])

# france = recov_long[recov_long[:, :province] .== "France", :]

# fr = TimeArray(france, timestamp = :date)

# plot(fr.total)

# britcol = recov_long[(recov_long[:, :country] .== "Canada") .& (recov_long[:, :province] .== "British Columbia"), :]

# bc = TimeArray(britcol, timestamp = :date)

# plot(bc.total)

# india = recov_long[recov_long[:, :country] .== "India", :]

# in = TimeArray(india, timestamp = :date)

# plot(in.total)

# * ill

conf = conf_long.total
dead = dead_long.total
recov = recov_long.total
ill = conf_long.total .- dead_long.total .- recov_long.total

conf_long.conf = conf
conf_long.dead = dead
conf_long.recov = recov
conf_long.ill = ill

total = conf_long

select!(total, Not(:total))

france = total[total[:, :province] .== "France", :]

fr = select(france, Not([:country, :province]))

fr = TimeArray(fr, timestamp = :date)

plot(fr)
