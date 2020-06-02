# * Load packages

using JLD
using DataFrames
using StatsPlots; gr()
using TimeSeries

# * Load our data frame

datlong = load("../../data/covid.jld", "confirmed")

# * World plot

world = combine(groupby(datlong, :date), :confirmed => sum => :confsum)

plot(TimeArray(world, timestamp = :date))

unicodeplots()

plot(TimeArray(world, timestamp = :date))

plot(TimeArray(world, timestamp = :date),
     title = "Total confirmed Covid-19 cases in the world",
     legend = :outertopright,
     widen = :false)

savefig(plot(TimeArray(world, timestamp = :date), dpi = :300),
        "../../plot/school/covid/world1.png")

savefig(plot(TimeArray(world, timestamp = :date),
             title = "Total confirmed Covid-19 cases in the world",
             legend = :outertopright,
             widen = :false,
             dpi = :300),
        "../../plot/school/covid/world1.png")
