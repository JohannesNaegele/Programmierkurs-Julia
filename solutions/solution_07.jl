###:------ Übungsblatt 7 ------:###

# Tipp: Um auch bei der Ausführung des ganzen Skripts die Plots angezeigt zu bekommen,
# kann man analog zu println auf jeden Plot den Command display anwenden. Das könnte für
# die Klausur ganz nützlich sein um zu checken, ob das Skript wie gedacht läuft.


## Aufgabe 1

# (a)
using DataFrames, CSV, Pipe, CategoricalArrays
df = CSV.File("./../data/hflights.csv", missingstring = "NA") |> DataFrame
describe(df)
println(names(df))
@pipe df |>
    transform!(_, :Month => x -> categorical(x, ordered=true), renamecols=true)

# (b)
using Plots

# diskrete Werte (bzw. Kategorien) -> Barplot
@pipe df |>
    groupby(_, :Month) |>
    combine(_, nrow) |>
    bar(
        _.Month,
        _.nrow,
        xlabel="Month",
        ylabel="Number of flights",
        title="Monthly flights",
        color="dark blue",
        legend=false
    )

# (c)
@pipe df |>
    subset(_, :UniqueCarrier => ByRow(x -> (x == "DL") | (x == "EV"))) |>
    groupby(_, [:Month, :UniqueCarrier]) |>
    combine(_, nrow) |>
    bar(
        _.Month,
        _.nrow,
        group=_.UniqueCarrier,
        xlabel="Month",
        ylabel="Number of flights",
        title="Monthly flights with DL and EV"
    )

# (d)
describe(df.ArrDelay)
df_filtered = @pipe df |>
    subset(_, :ArrDelay => ByRow(<=(2 * 60)), skipmissing=true)

# (e)
# stetiger Wertebereich -> Histogramm
@pipe df_filtered |>
    histogram(
        _.ArrDelay,
        xlabel="ArrDelay",
        ylabel="count",
        title="Arrival delays < 2h",
        legend=false
    )

# (f)
@pipe df_filtered |>
    histogram(
        _.ArrDelay,
        group=_.Origin,
        xlabel="ArrDelay",
        ylabel="count",
        title="Arrival delays < 2h for HOU and IAH",
        normalize=true,
        alpha=0.7
    )

# (g)
@pipe df_filtered |>
    scatter(
        _.Distance,
        _.AirTime,
        marker_z = _.ArrDelay,
        markersize = 2,
        markerstrokewidth = 0,
        colorbar = true,
        colorbar_title = "ArrDelay",
        title = "Distance ~ Airtime",
        xlabel = "Distance",
        ylabel = "AirTime",
        label = ""
    )

# (h)
using GLM
fm = @formula(AirTime ~ Distance)
regr = lm(fm, df_filtered)
@pipe df_filtered |> plot!(
    _.Distance,
    predict(regr, _),
    label="linear model",
    color = "red"
)

# (i)
grps = groupby(df_filtered, :Origin)
npanels = length(grps)

@pipe grps |>
    for g in _
        regr = lm(fm, g)
        g[!, :Prediction] = predict(regr, g)
    end

@pipe df_filtered |>
    scatter(
        _.Distance,
        _.AirTime,
        group = _.Origin,
        marker_z = _.ArrDelay,
        markersize = 3,
        markerstrokewidth = 0,
        layout = npanels,
        xlabel = "Distance",
        ylabel = "AirTime",
    )

@pipe df_filtered |>
    plot!(
        _.Distance,
        _.Prediction,
        group = _.Origin,
        layout = npanels,
        color = "red",
        label = "linear model"
    )

## Aufgabe 2

# (a)
a = sum(12:10:152)

# (b)
function sum_multiples_of_6(n)
    sum = 0
    for i in 1:n
        if (i % 6 == 0)
            sum += i
        end
    end
    return sum
end

sum_multiples_of_6(199)

# (c)
function rev(text)
    result = ""
    for i in text
        result = i * result
    end
    return result
end

rev("Grüß Gott")
# Kleine Anmerkung: Sowas wie "Grüß Gott"[4] scheitert,
# weil das ü mehrere Indizes braucht.


## Aufgabe 3

# Copy-Paste von letztem Blatt:
mutable struct LinkedList{T}
    value::T
    next::Union{Nothing, LinkedList{T}}
end

LinkedList(value) = LinkedList{typeof(value)}(value, nothing)

function insert!(list::LinkedList, value)
    next_list = LinkedList(value)
    list.next = next_list
end

function get(list, i)
    for i in 1:(i-1)
        list = list.next
    end
    return list.value
end

list = LinkedList(1.0)
insert!(list, 2.0)
# diese Funktionen haben wir noch nicht:
# length(list)
# list[1]

# definiere wrapper struct
struct ListArray{T} <: AbstractArray{T,1}
    data::LinkedList{T}
end

function Base.size(ar::ListArray)
    n = ar.data
    count = 1
    while n.next !== nothing # != tut's eigentlich auch
        n = n.next
        count += 1
    end
    return (count, 1)
end

function Base.getindex(ar::ListArray, i::Int)
    n = ar.data
    for j in 1:(i-1)
        next_list = n.next
        # next_list === nothing && throw(BoundsError(n
        n = next_list
    end
    return n.value
end

ar = ListArray(list)
length(ar)
ar[1]
ar[2]

foo = [0.0, 0.0]
list = LinkedList(1.0)
insert!(list, 2.0)
foo .= 2 .* list