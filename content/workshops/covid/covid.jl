# * setup

# ** load packages

using CSV
using DataFrames
using Plots
using Dates
using TimeSeries
gr()

# ** read data

list = joinpath.(relpath("covid_db/csse_covid_19_data/csse_covid_19_time_series"),
                 readdir("covid_db/csse_covid_19_data/csse_covid_19_time_series"))

name = lowercase.(replace.(list, r".*-(.*).csv" => s"\1"))

dat = DataFrame.(CSV.File.(list))

# ** clean data and put in long format

DataFrames.rename!.(dat, Dict.(1 => Symbol("province"),
                               2 => Symbol("country")))

total = stack(dat[1], Not(collect(1:4)),
              variable_name = Symbol("date"),
              value_name = Symbol("total"))

dead = stack(dat[2], Not(collect(1:4)),
             variable_name = Symbol("date"),
             value_name = Symbol("dead"))

recovered = stack(dat[3], Not(collect(1:4)),
                  variable_name = Symbol("date"),
              value_name = Symbol("recovered"))

all = join(total, dead, recovered, on = [:date, :country, :province, :Lat, :Long])

select!(all, [4, 3, 1, 2, 7, 8])

all.date = Date.(replace.(string.(all[:, 3]),
                          r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy");

replace!(all.province, missing => "NA")

# * currently ill

all.current = all.total .- all.dead .- all.recovered

# * plots

# ** all countries on one graph

# *** world totals

world = by(all, :date, total = :total => sum, dead = :dead => sum,
           recovered = :recovered => sum, current = :current => sum)

savefig(plot(TimeArray(world, timestamp = :date),
             title = "World total", legend = :outertopright,
             widen = :false, dpi = :300),
        "world_totals.png")

savefig(plot(TimeArray(world, timestamp = :date),
             title = "World total", legend = :outertopright, widen = :false),
        "world_totals.pdf")



# *** one line per country


Sweden

Netherlands

france = total[total[:, :province] .== "France", :]

fr = select(france, Not([:country, :province]))

fr = TimeArray(fr, timestamp = :date)

plot(fr)

# * all regions on one graph

# transform to wide format keeping date as variable

# total.region = string.(total.country, " ", total.province)
total.region = total.country .* " " .* total.province

total.region = replace.(total.region, r" NA" => "")

total_rg = select(total, [8, 3, 4, 5, 6, 7])

conf_wide = select(total_rg, [1, 2, 3])

conf_wide = unstack(conf_wide, :region, :conf)

conf_wide = TimeArray(conf_wide, timestamp = :date);

plot(conf_wide)









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
