# * Load packages

using JLD
using DataFrames
using Plots; gr()
using TimeSeries
# using NamedArrays

# * Load our data frame




list = joinpath.(relpath(dir), readdir(dir))

dat = DataFrame.(CSV.File.(list[collect(5:6)]))

# ** long format

DataFrames.rename!.(dat, Dict.(1 => Symbol("province"),
                               2 => Symbol("country")))

var = ["total", "dead"]

datlong = map((x, y) -> stack(x, Not(collect(1:4)),
                              variable_name = Symbol("date"),
                              value_name = Symbol("$y")),
               dat, var)

all = join(datlong[1], datlong[2],
           on = [:date, :country, :province, :Lat, :Long])

replace!(all.province, missing => "");

all.loc = rstrip.(all.country .* " " .* all.province);

replace!(all.loc, "Korea, South" => "South Korea");
replace!(all.loc, "Taiwan*" => "Taiwan");

select!(all, [4, 3, 8, 1, 2, 7])

all.date = Date.(replace.(string.(all[:, 4]),
                          r"(.*)(..)$" => s"\g<1>20\2"), "m/dd/yy");

# ** world summary

world = by(all, :date,
           total = :total => sum,
           dead = :dead => sum)

savefig(plot(TimeArray(world, timestamp = :date),
             title = "World", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/covid/world.png")

# ** countries summaries

countries = groupby(all, :country)

canada = all[all[:, :country] .== "Canada", :]
china = all[all[:, :country] .== "China", :]

us = all[all[:, :country] .== "US", :]
skorea = all[all[:, :country] .== "Korea, South", :]
taiwan = all[all[:, :country] .== "Taiwan*", :]
singapore = all[all[:, :country] .== "Singapore", :]
italy = all[all[:, :country] .== "Italy", :]
spain = all[all[:, :country] .== "Spain", :]

france = all[all[:, :loc] .== "France", :]
uk = all[all[:, :loc] .== "United Kingdom", :]

india = all[all[:, :country] .== "India", :]
sweden = all[all[:, :country] .== "Sweden", :]
netherlands = all[all[:, :loc] .== "Netherlands", :]
bc = all[all[:, :province] .== "British Columbia", :]
hubei = all[all[:, :province] .== "Hubei", :]
hongkong = all[all[:, :province] .== "Hong Kong", :]

# *** country totals for Canada and China

canada, china = by.([canada, china], :date,
                    total = :total => sum,
                    dead = :dead => sum)

# canada = by.(canada, :date,
#              total = :total => sum,
#              dead = :dead => sum)

# loclist1 = [canada, china]
# loctitles1 = ["Canada", "China"]
# locfiles1 = ["canada", "china"]

# map((x, y, z) -> savefig(plot(TimeArray(x, timestamp = :date),
#                               title = "$y", legend = :outertopright,
#                               widen = :false, dpi = :300),
#                          "../../../plot/workshop/covid/$z.png"),
#     loclist1, loctitles1, locfiles1);

# loclist2 = [us, france, taiwan, skorea, singapore, spain, italy,
#             uk, india, sweden, netherlands, bc, hubei, hongkong]
# loctitles2 = ["US", "France", "Taiwan", "South Korea",
#               "Singapore", "Spain", "Italy", "UK", "India", "Sweden",
#               "Netherlands", "BC", "Hubei", "Hong Kong"]
# locfiles2 = ["us", "france", "taiwan", "skorea", "singapore",
#              "spain", "italy", "uk", "india", "sweden", "netherlands",
#              "bc", "hubei", "hongkong"]

loclist2 = [italy, spain, us]
loctitles2 = ["Italy", "Spain", "US"]
locfiles2 = ["italy", "spain", "us"]

# map((x, y, z) ->
#     savefig(plot(TimeArray(select(x, Not([:country, :province, :loc])),
#                            timestamp = :date),
#                               title = "$y", legend = :outertopright,
#                               widen = :false, dpi = :300),
#                          "../../../plot/workshop/covid/$z.png"),
#     loclist2, loctitles2, locfiles2);

# pcanada, pus, pchina = map((x, y) -> plot(TimeArray(x, timestamp = :date),
#                                           title = "$y", legend = :outertopright,
#                                           widen = :false, dpi = :300),
#                            loclist1, loctitles1)

pcanada = plot(TimeArray(canada, timestamp = :date),
               title = "Canada", legend = :outertopright,
               widen = :false, dpi = :300);

pitaly, pspain, pus =
    map((x, y) -> plot(TimeArray(select(x, Not([:country, :province, :loc])),
                                 timestamp = :date),
                       title = "$y", legend = :outertopright,
                       widen = :false, dpi = :300),
        loclist2, loctitles2);

savefig(plot(pitaly, pspain, pus, pcanada,
             legend = false, titlefontsize = 7,
             tickfontsize = 6, dpi = :300),
        "../../../plot/workshop/covid/4countries.png")

# ** countries comparison

canada[!, :loc] .= "Canada";
china[!, :loc] .= "China";

all = join(all, canada, china, on = [:date, :total, :dead, :loc],
           kind = :outer)

confirmed = unstack(all[:, collect(3:5)], :loc, :total)

dead = unstack(all[:, [3, 4, 6]], :loc, :dead)

# plot(TimeArray(confirmed, timestamp = :date),
#      title = "Confirmed cases across countries", legend = :outertopright,
#      widen = :false, dpi = :300)

# plot(TimeArray(dead, timestamp = :date),
#      title = "Deaths across countries", legend = :outertopright,
#      widen = :false, dpi = :300)

conf_sel = select(confirmed,
                  [:date, :Italy, :Spain, :China, :Iran,
                   :France, :US, Symbol("South Korea"), :Canada])

dead_sel = select(dead,
                  [:date, :Italy, :Spain, :China, :Iran,
                   :France, :US, Symbol("South Korea"), :Canada])

# pconf = plot(TimeArray(conf_sel, timestamp = :date),
#              title = "Confirmed across a few countries",
#              legend = :outertopright, widen = :false)

savefig(plot(TimeArray(conf_sel, timestamp = :date),
             title = "Confirmed across a few countries",
             legend = :outertopright, widen = :false, dpi = :300),
        "../../../plot/workshop/covid/confirmed.png")

# pdead = plot(TimeArray(dead_sel, timestamp = :date),
#              title = "Dead across a few countries",
#              legend = :outertopright, widen = :false)

savefig(plot(TimeArray(dead_sel, timestamp = :date),
             title = "Dead across a few countries",
             legend = :outertopright, widen = :false, dpi = :300),
        "../../../plot/workshop/covid/dead.png")

# savefig(plot(pconf, pdead, titlefontsize = 7,
#              tickfontsize = 6, legend = :false, dpi = :300),
#         "../../../plot/workshop/covid/conf_dead.png")


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

# * Load packages

using CSV
using DataFrames
using Dates
using TimeSeries

# * World summary

world = by(all, :date,
           total = :total => sum,
           dead = :dead => sum)

savefig(plot(TimeArray(world, timestamp = :date),
             title = "World", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/covid/world.png")

# ** countries summaries

replace!(all.province, missing => "");

all.loc = rstrip.(all.country .* " " .* all.province);

replace!(all.loc, "Korea, South" => "South Korea");
replace!(all.loc, "Taiwan*" => "Taiwan");




countries = groupby(all, :country)

canada = all[all[:, :country] .== "Canada", :]
china = all[all[:, :country] .== "China", :]

us = all[all[:, :country] .== "US", :]
skorea = all[all[:, :country] .== "Korea, South", :]
taiwan = all[all[:, :country] .== "Taiwan*", :]
singapore = all[all[:, :country] .== "Singapore", :]
italy = all[all[:, :country] .== "Italy", :]
spain = all[all[:, :country] .== "Spain", :]

france = all[all[:, :loc] .== "France", :]
uk = all[all[:, :loc] .== "United Kingdom", :]

india = all[all[:, :country] .== "India", :]
sweden = all[all[:, :country] .== "Sweden", :]
netherlands = all[all[:, :loc] .== "Netherlands", :]
bc = all[all[:, :province] .== "British Columbia", :]
hubei = all[all[:, :province] .== "Hubei", :]
hongkong = all[all[:, :province] .== "Hong Kong", :]

# *** country totals for Canada and China

canada, china = by.([canada, china], :date,
                    total = :total => sum,
                    dead = :dead => sum)

# canada = by.(canada, :date,
#              total = :total => sum,
#              dead = :dead => sum)

# loclist1 = [canada, china]
# loctitles1 = ["Canada", "China"]
# locfiles1 = ["canada", "china"]

# map((x, y, z) -> savefig(plot(TimeArray(x, timestamp = :date),
#                               title = "$y", legend = :outertopright,
#                               widen = :false, dpi = :300),
#                          "../../../plot/workshop/covid/$z.png"),
#     loclist1, loctitles1, locfiles1);

# loclist2 = [us, france, taiwan, skorea, singapore, spain, italy,
#             uk, india, sweden, netherlands, bc, hubei, hongkong]
# loctitles2 = ["US", "France", "Taiwan", "South Korea",
#               "Singapore", "Spain", "Italy", "UK", "India", "Sweden",
#               "Netherlands", "BC", "Hubei", "Hong Kong"]
# locfiles2 = ["us", "france", "taiwan", "skorea", "singapore",
#              "spain", "italy", "uk", "india", "sweden", "netherlands",
#              "bc", "hubei", "hongkong"]

loclist2 = [italy, spain, us]
loctitles2 = ["Italy", "Spain", "US"]
locfiles2 = ["italy", "spain", "us"]

# map((x, y, z) ->
#     savefig(plot(TimeArray(select(x, Not([:country, :province, :loc])),
#                            timestamp = :date),
#                               title = "$y", legend = :outertopright,
#                               widen = :false, dpi = :300),
#                          "../../../plot/workshop/covid/$z.png"),
#     loclist2, loctitles2, locfiles2);

# pcanada, pus, pchina = map((x, y) -> plot(TimeArray(x, timestamp = :date),
#                                           title = "$y", legend = :outertopright,
#                                           widen = :false, dpi = :300),
#                            loclist1, loctitles1)

pcanada = plot(TimeArray(canada, timestamp = :date),
               title = "Canada", legend = :outertopright,
               widen = :false, dpi = :300);

pitaly, pspain, pus =
    map((x, y) -> plot(TimeArray(select(x, Not([:country, :province, :loc])),
                                 timestamp = :date),
                       title = "$y", legend = :outertopright,
                       widen = :false, dpi = :300),
        loclist2, loctitles2);

savefig(plot(pitaly, pspain, pus, pcanada,
             legend = false, titlefontsize = 7,
             tickfontsize = 6, dpi = :300),
        "../../../plot/workshop/covid/4countries.png")

# ** countries comparison

canada[!, :loc] .= "Canada";
china[!, :loc] .= "China";

all = join(all, canada, china, on = [:date, :total, :dead, :loc],
           kind = :outer)

confirmed = unstack(all[:, collect(3:5)], :loc, :total)

dead = unstack(all[:, [3, 4, 6]], :loc, :dead)

# plot(TimeArray(confirmed, timestamp = :date),
#      title = "Confirmed cases across countries", legend = :outertopright,
#      widen = :false, dpi = :300)

# plot(TimeArray(dead, timestamp = :date),
#      title = "Deaths across countries", legend = :outertopright,
#      widen = :false, dpi = :300)

conf_sel = select(confirmed,
                  [:date, :Italy, :Spain, :China, :Iran,
                   :France, :US, Symbol("South Korea"), :Canada])

dead_sel = select(dead,
                  [:date, :Italy, :Spain, :China, :Iran,
                   :France, :US, Symbol("South Korea"), :Canada])

# pconf = plot(TimeArray(conf_sel, timestamp = :date),
#              title = "Confirmed across a few countries",
#              legend = :outertopright, widen = :false)

savefig(plot(TimeArray(conf_sel, timestamp = :date),
             title = "Confirmed across a few countries",
             legend = :outertopright, widen = :false, dpi = :300),
        "../../../plot/workshop/covid/confirmed.png")

# pdead = plot(TimeArray(dead_sel, timestamp = :date),
#              title = "Dead across a few countries",
#              legend = :outertopright, widen = :false)

savefig(plot(TimeArray(dead_sel, timestamp = :date),
             title = "Dead across a few countries",
             legend = :outertopright, widen = :false, dpi = :300),
        "../../../plot/workshop/covid/dead.png")

# savefig(plot(pconf, pdead, titlefontsize = 7,
#              tickfontsize = 6, legend = :false, dpi = :300),
#         "../../../plot/workshop/covid/conf_dead.png")


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
