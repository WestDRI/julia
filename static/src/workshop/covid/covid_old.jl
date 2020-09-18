# * setup

# ** load packages

using CSV
using DataFrames
using Plots
using Dates
using TimeSeries
using NamedArrays
gr()

# * data until March 22, 2020

dir = "covid_db/csse_covid_19_data/csse_covid_19_time_series"

list = joinpath.(relpath(dir), readdir(dir))

dat = DataFrame.(CSV.File.(list[collect(2:4)]))

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

# ** currently ill

all.current = all.total .- all.dead .- all.recovered;

# ** world summary

world = by(all, :date,
           total = :total => sum,
           dead = :dead => sum,
           recovered = :recovered => sum,
           current = :current => sum)

savefig(plot(TimeArray(world, timestamp = :date),
             title = "World", legend = :outertopright,
             widen = :false, dpi = :300),
        "../../../plot/workshop/covid/world1.png")

# ** single country summary

countries = groupby(all, :country)

# countries[findall(x -> "France" in x, keys(countries))]
# countries[findall(x -> "Canada" in x, keys(countries))]
# countries[findall(x -> "India" in x, keys(countries))]

canada = all[all[:, :country] .== "Canada", :]
us = all[all[:, :country] .== "US", :]
china = all[all[:, :country] .== "China", :]

skorea = all[all[:, :country] .== "Korea, South", :]
taiwan = all[all[:, :country] .== "Taiwan*", :]
singapore = all[all[:, :country] .== "Singapore", :]
italy = all[all[:, :country] .== "Italy", :]
spain = all[all[:, :country] .== "Spain", :]
# india = all[all[:, :country] .== "India", :]
# sweden = all[all[:, :country] .== "Sweden", :]

france = all[all[:, :province] .== "France", :]
uk = all[all[:, :province] .== "United Kingdom", :]
# netherlands = all[all[:, :province] .== "Netherlands", :]

bc = all[all[:, :province] .== "British Columbia", :]
# wa = all[all[:, :province] .== "Washington", :]
ny = all[all[:, :province] .== "New York", :]
# ca = all[all[:, :province] .== "California", :]
# fl = all[all[:, :province] .== "Florida", :]
# hubei = all[all[:, :province] .== "Hubei", :]
# hongkong = all[all[:, :province] .== "Hong Kong", :]

# **** country totals for Canada, US, and China

canada, us, china = by.([canada, us, china], :date,
                        total = :total => sum,
                        dead = :dead => sum,
                        recovered = :recovered => sum,
                        current = :current => sum)

loclist1 = [canada, us, china]
loctitles1 = ["Canada", "US", "China"]
locfiles1 = ["canada", "us", "china"]

map((x, y, z) -> savefig(plot(TimeArray(x, timestamp = :date),
                              title = "$y", legend = :outertopright,
                              widen = :false, dpi = :300),
                         "../../../plot/workshop/covid/$z1.png"),
    loclist1, loctitles1, locfiles1);

# loclist2 = [france, india, bc, wa, ny, ca, fl, sweden, netherlands,
#             hubei, taiwan, skorea, singapore, hongkong, italy]
# loctitles2 = ["France", "India", "BC", "WA", "NY", "CA", "FL",
#               "Sweden", "Netherlands", "Hubei", "Taiwan",
#               "South Korea", "Singapore", "Hong Kong", "Italy"]
# locfiles2 = ["france", "india", "bc", "wa", "ny", "ca", "fl",
#              "sweden", "netherlands", "hubei", "taiwan",
#              "skorea", "singapore", "hongkong", "italy"]

loclist2 = [france, bc, ny, taiwan, skorea, singapore, spain, italy, uk]
loctitles2 = ["France", "BC", "NY", "Taiwan", "South Korea",
              "Singapore", "Spain", "Italy", "UK"]
locfiles2 = ["france", "bc", "ny", "taiwan", "skorea",
             "singapore", "spain", "italy", "uk"]

map((x, y, z) -> savefig(plot(TimeArray(select(x, Not([:country, :province])),
                                        timestamp = :date),
                              title = "$y", legend = :outertopright,
                              widen = :false, dpi = :300),
                         "../../../plot/workshop/covid/$z1.png"),
    loclist2, loctitles2, locfiles2);

pcanada, pus, pchina = map((x, y) -> plot(TimeArray(x, timestamp = :date),
                                          title = "$y", legend = :outertopright,
                                          widen = :false, dpi = :300),
    loclist1, loctitles1)

# pfrance, pindia, pbc, pwa, pny, pca, pfl, psweden, pnetherlands,
# hubei, ptaiwan, pskorea, psingapore, phongkong, pitaly =
#     map((x, y) -> plot(TimeArray(select(x, Not([:country, :province])),
#                                  timestamp = :date),
#                            title = "$y", legend = :outertopright,
#                            widen = :false, dpi = :300),
#             loclist2, loctitles2)

pfrance, pbc, pny, ptaiwan, pskorea,
psingapore, pspain, pitaly, puk =
    map((x, y) -> plot(TimeArray(select(x, Not([:country, :province])),
                                 timestamp = :date),
                       title = "$y", legend = :outertopright,
                       widen = :false, dpi = :300),
        loclist2, loctitles2)

# plot(pcanada, pus, pchina, pfrance, pindia, pbc, pwa,
#      pny, pca, pfl, psweden, pnetherlands, hubei,
#      ptaiwan, pskorea, psingapore, phongkong, pitaly,
#      legend = false, titlefont = font(6), guidefontsize = font(1),
#      layout = @layout([a b c; d e f; g h i; k l m; n o p; q r s]))

# plot(pcanada, pbc, xrotation = 0, legend = false,
#      titlefontsize = 7, tickfontsize = 6,
#      layout = @layout([a{0.5h} b{0.5h}]))

savefig(plot(pcanada, pbc, pus, pny,
             legend = false, titlefontsize = 7,
             tickfontsize = 6, dpi = :300),
        "../../../plot/workshop/covid/northamerica1.png")

savefig(plot(pchina, ptaiwan, pskorea, psingapore,
             legend = false, titlefontsize = 7,
             tickfontsize = 6, dpi = :300),
        "../../../plot/workshop/covid/asia1.png")

savefig(plot(pfrance, pspain, pitaly, puk,
             legend = false, titlefontsize = 7,
             tickfontsize = 6, dpi = :300),
        "../../../plot/workshop/covid/europe1.png")

# * data up to the present

dat = DataFrame.(CSV.File.(list[collect(5:6)]))

# ** long format

DataFrames.rename!.(dat, Dict.(1 => Symbol("province"),
                               2 => Symbol("country")))

var = ["total", "dead"]

datlong = map((x, y) -> stack(x, Not(collect(1:4)),
                              variable_name = Symbol("date"),
                              value_name = Symbol("$y")),
               dat2, var)

all = join(datlong[1], datlong[2],
           on = [:date, :country, :province, :Lat, :Long])

replace!(all.province, missing => "");

all.loc = rstrip.(all.country .* " " .* all.province);

replace!(all.loc, "Korea, South" => "South Korea")
replace!(all.loc, "Taiwan*" => "Taiwan")

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

canada[!, :loc] .= "Canada"
china[!, :loc] .= "China"

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
                  [:date, :Italy, :Spain, :US, :China,
                   :Germany, :Iran, :France, Symbol("United Kingdom"),
                   :Canada, Symbol("South Korea"), Symbol("Taiwan")])

dead_sel = select(dead,
                  [:date, :Italy, :Spain, :US, :China,
                   :Germany, :Iran, :France, Symbol("United Kingdom"),
                   :Canada, Symbol("South Korea"), Symbol("Taiwan")])

plot(TimeArray(conf_sel, timestamp = :date),
     title = "Confirmed across some countries",
     legend = :outertopright, widen = :false)

savefig(plot(TimeArray(conf_sel, timestamp = :date),
             title = "Confirmed across some countries",
             legend = :outertopright, widen = :false, dpi = :300),
        "../../../plot/workshop/covid/dead.png")

plot(TimeArray(dead_sel, timestamp = :date),
     title = "Dead across some countries",
     legend = :outertopright, widen = :false)

savefig(plot(TimeArray(dead_sel, timestamp = :date),
             title = "Dead across some countries",
             legend = :outertopright, widen = :false, dpi = :300),
        "../../../plot/workshop/covid/confirmed.png")

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
