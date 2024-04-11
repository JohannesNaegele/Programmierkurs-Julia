###:------ Übungsblatt 4 ------:###


# Gegen mögliche Frustration beim Programmieren
# wird im Folgenden ein Safety Pig bereitgestellt:
#
#                              _
#      _._ _..._ .-',     _.._(`))
#      '-. `     '  /-._.-'    ',/
#        )         \            '.
#       / _    _    |             \
#      |  a    a    /              |
#      \   .-.                     ;  
#       '-('' ).-'       ,'       ;
#          '-;           |      .'
#             \           \    /
#             | 7  .__  _.-\   \
#             | |  |  ``/  /`  /
#            /,_|  |   /,_/   /
#               /,_/      '`-'


## Aufgabe 1

# (a)
using DataFrames, Pipe, Dates, RDatasets, Statistics
airquality = dataset("datasets", "airquality")
describe(airquality) # oder rigoros:
da = describe(airquality)
da.variable[argmax(da.nmissing)]

# (b)
airquality[:, 1:end-2]
# oder:
select(airquality, Not([:Month, :Day]))
# oder 
select(airquality, names(airquality)[1:end-2])

# (c)
sort(airquality, :Wind)
sort(airquality, :Wind, rev=true)

# (d)
@pipe airquality |>
    transform!(_, :Temp => ByRow(x -> (x - 32) * 5 / 9) => :Temp)

# (e)
@pipe airquality |>
dropmissing(_, :Ozone) |>
      describe(_, length => :n_obs, mean ∘ skipmissing => :mean) |> # es ginge auch (x -> mean(skipmissing(x)))
      subset(_, :variable => ByRow(==(:Ozone)))

# (f)
@pipe airquality |>
      transform(_, :Temp => (ByRow(x -> x > 25 ? :hot : :cold)) => :TempCat) |>
      groupby(_, :TempCat) |>
      combine(_, nrow => :count)

# (g)
@pipe airquality |>
transform(_, :Ozone => (x -> abs.(x .- mean(skipmissing(x)))) => "Ozone deviation") |>
      transform(_, ["Ozone", "Solar.R"] => (.*) => :OS)

# (h)
using Plots
plot(airquality.Temp,
    xlabel="Zeit",
    ylabel="Temperatur",
    legend=false,
)

histogram(airquality.Temp,
    ylabel="Temperatur",
    legend=false,
)

# (i)
august_or_no_wind(month, wind) = month == 8 || wind < 7
@pipe airquality |>
      filter([:Month, :Wind] => august_or_no_wind, _) |>
      filter(:Ozone => !ismissing, _) |>
      histogram!(_.Temp)

# (j)
@pipe airquality |>
      transform!(_, [:Month, :Day] => ByRow((m, d) -> Date("1973-$m-$d")) => :Date)

# (k)
tick_years = @pipe airquality.Date |> minimum(_):Month(1):maximum(_)
date_tick = Dates.format.(tick_years, "mm")
@pipe airquality |>
    plot(_.Date, _.Temp,
        xlabel="Monat in 1973",
        ylabel="Temperatur",
        legend=false,
        xticks=(tick_years, date_tick)
    )
# noch schöner ist:
date_tick = monthname.(Dates.month.(tick_years))

## Aufgabe 2

# Betrachten wir zum Beispiel den Fall aus Aufgabe 1 (e):
airquality |> x -> dropmissing(x, :Ozone)