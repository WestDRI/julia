# * setup

# ** load packages

using CSV
using DataFrames
using Plots
using Dates
using TimeSeries
using NamedArrays
gr()

# ** read data

dir = "covid_db/csse_covid_19_data/csse_covid_19_time_series"

list = joinpath.(relpath(dir), readdir(dir))

dat = DataFrame.(CSV.File.(list[collect(1:3)]))

# ** clean data and put in long format

DataFrames.rename!.(dat, Dict.(1 => Symbol("province"),
                               2 => Symbol("country")))

var = ["total", "dead", "recovered"]

datlong = map((x, y) -> stack(x, Not(collect(1:4)),
                              variable_name = Symbol("date"),
                    value_name = Symbol("$y")),
     dat, var)

all = join(datlong[1], datlong[2], datlong[3],
           on = [:date, :country, :province, :Lat, :Long])

select!(all, [4, 3, 1, 2, 7, 8])

all.date = Date.(replace.(string.(all[:, 3]),
                          r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy");

replace!(all.province, missing => "NA");

# * currently ill

all.current = all.total .- all.dead .- all.recovered;

# * plots

# ** world summary

world = by(all, :date, total = :total => sum, dead = :dead => sum,
           recovered = :recovered => sum, current = :current => sum)

savefig(plot(TimeArray(world, timestamp = :date),
             title = "World", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/covid/world.png")

# ** single country summary

countries = groupby(all, :country)

countries[findall(x -> "France" in x, keys(countries))]
countries[findall(x -> "India" in x, keys(countries))]
countries[findall(x -> "Canada" in x, keys(countries))]
countries[findall(x -> "Sweden" in x, keys(countries))]
countries[findall(x -> "Netherlands" in x, keys(countries))]
countries[findall(x -> "US" in x, keys(countries))]
countries[findall(x -> "China" in x, keys(countries))]
countries[findall(x -> "Taiwan*" in x, keys(countries))]
countries[findall(x -> "Singapore" in x, keys(countries))]

france = all[all[:, :province] .== "France", :]
india = all[all[:, :country] .== "India", :]
canada = all[all[:, :country] .== "Canada", :]
bc = all[all[:, :province] .== "British Columbia", :]
us = all[all[:, :country] .== "US", :]
wa = all[all[:, :province] .== "Washington", :]
ny = all[all[:, :province] .== "New York", :]
ca = all[all[:, :province] .== "California", :]
fl = all[all[:, :province] .== "Florida", :]
sweden = all[all[:, :country] .== "Sweden", :]
netherlands = all[all[:, :province] .== "Netherlands", :]
china = all[all[:, :country] .== "China", :]
hubei = all[all[:, :province] .== "Hubei", :]
taiwan = all[all[:, :country] .== "Taiwan*", :]
skorea = all[all[:, :country] .== "Korea, South", :]
singapore = all[all[:, :country] .== "Singapore", :]
hongkong = all[all[:, :province] .== "Hong Kong", :]

# *** totals for US, Canada, and China

canada = by(canada, :date, total = :total => sum, dead = :dead => sum,
            recovered = :recovered => sum, current = :current => sum)

us = by(us, :date, total = :total => sum, dead = :dead => sum,
        recovered = :recovered => sum, current = :current => sum)

china = by(china, :date, total = :total => sum, dead = :dead => sum,
           recovered = :recovered => sum, current = :current => sum)

# *** plots

savefig(plot(TimeArray(canada, timestamp = :date),
             title = "Canada", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/canada.png")

savefig(plot(TimeArray(select(bc, Not([:country, :province])),
                       timestamp = :date),
             title = "BC", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/bc.png")

savefig(plot(TimeArray(us, timestamp = :date),
             title = "US", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/us.png")

savefig(plot(TimeArray(china, timestamp = :date),
             title = "China", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/china.png")

savefig(plot(TimeArray(select(hubei, Not([:country, :province])),
                       timestamp = :date),
             title = "Hubei", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/hubei.png")

savefig(plot(TimeArray(select(france, Not([:country, :province])),
                       timestamp = :date),
             title = "France", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/france.png")

savefig(plot(TimeArray(select(taiwan, Not([:country, :province])),
                       timestamp = :date),
             title = "Taiwan", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/taiwan.png")

savefig(plot(TimeArray(select(skorea, Not([:country, :province])),
                       timestamp = :date),
             title = "South Korea", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/skorea.png")

savefig(plot(TimeArray(select(singapore, Not([:country, :province])),
                       timestamp = :date),
             title = "Singapore", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/singapore.png")

savefig(plot(TimeArray(select(hongkong, Not([:country, :province])),
                       timestamp = :date),
             title = "Hong Kong", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/hongkong.png")

loclist = [france, india, bc, wa, ny, ca, fl, sweden, netherlands]

locnames = ["France", "India", "BC", "WA",
            "NY", "CA", "FL", "Sweden", "Netherlands"]

savefig.(plot.(TimeArray(select(loclist, Not([:country, :province])),
                         timestamp = :date),
               title = "$locnames", legend = :outertopright,
               widen = :false, dpi = :300),
         "../../../plot/workshop/$locnames.png")

plot.(TimeArray.(select.(loclist, Not([:country, :province])),
                 timestamp = :date),
      title = "$locnames", legend = :outertopright,
      widen = :false, dpi = :300)



for i in 
    savefig(plot(TimeArray(select(i, Not([:country, :province])),
                           timestamp = :date),
                 title = "$locnames[j]", legend = :outertopright,
                 widen = :false, dpi = :300),
            "../../../plot/workshop/$locnames[j].png")
end

for i in 1:3, j in 4:6
    println(i + j)
end



# ** countries comparison

unstack(all[:, [1, 3, 4]], :date, :total)

all.region = all.country .* " " .* all.province

all.region = replace.(all.region, r" NA" => "")

unstack(all[:, [3, 4, 8]], :date, :total)

# plot(unstack(all[:, [3, 4, 8]], :date, :total)[147, :])

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
