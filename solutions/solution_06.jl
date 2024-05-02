###:------ Übungsblatt 6 ------:###


## Aufgabe 1

# (a)
abstract type AbstractIdentification end

# (b)
# struct Perso
#     surname
#     name
#     age
#     Perso(surname, name) = new(surname, name, 0)
# end

# (c)
function personal_info(p::Perso)
    println("Vorname: $(p.surname)")
    println("Name: $(p.name)")
    println("Alter: $(p.age)")
end

# (d), (e) und (f)
struct Perso{S<:AbstractString} <: AbstractIdentification
    surname::S
    name::S
    age::Int
    # inner constructor
    Perso(surname, name, age) = begin
        @assert ((age >= 0) && (age % 1 == 0)) "this is not a valid age"
        new{typeof(surname)}(
            surname,
            name,
            Int(age)
        )
    end
end

# outer constructor
Perso(surname, name) = Perso(surname, name, 0)

perso = Perso("Pater", "Pen")
personal_info(perso)


# (f)
struct StudiID <: AbstractIdentification
    surname
    name
    matrikelnummer::Int
end

# (g)
name(id::AbstractIdentification) = id.name

# (h)
struct SpyID <: AbstractIdentification
    country
end

# (i)
name(id::SpyID) = "Mr. X"


## Aufgabe 2

# (a)
mutable struct LinkedList{T}
    value::T
    next::Union{Nothing, LinkedList{T}}
end

LinkedList(value) = LinkedList{typeof(value)}(value, nothing)

list = LinkedList(1.0)

function insert!(list::LinkedList, value)
    next_list = LinkedList(value)
    list.next = next_list
end

insert!(list, 2.0)

function get(list, i)
    for i in 1:(i-1)
        list = list.next
    end
    return list.value
end

get(list, 1)


## Aufgabe 3

# (a)
using DataFrames, CSV, Pipe
df =
    CSV.File("./../data/weatherAUS.csv", missingstring = "NA") |> DataFrame

# (b)
describe(df)
sum(describe(df)[!, :nmissing])

# (c)
df = df[!, vcat(1:5, 22)]
sum(describe(df)[!, :nmissing])

# (d)
transform!(df, [:MaxTemp, :MinTemp] => ByRow(-) => :Variation)
# Eine andere Möglichkeits wäre:
# diff(x, y) = x - y
# transform!(df, [:MaxTemp, :MinTemp] => ByRow(diff) => :variation)
df[argmax(skipmissing(df.Variation)), :]

# (e)
using Statistics
@pipe df |>
    subset(_, :Location => ByRow(==("Wollongong"))) |>
    combine(_, :MinTemp => mean ∘ skipmissing)

# (f)
describe(df) # Niederschlag geht bis zu 371 mm

@pipe df |> # Bei "No" haben wir maximal 1mm -> passt
    subset(_, :RainToday => ByRow(==("No")), skipmissing=true) |>
    describe(_)

# (g)
@pipe df |>
    groupby(_, :RainToday, skipmissing=true) |>
    combine(_, :MinTemp => mean ∘ skipmissing)


## Aufgabe 4
function subtypetree(roottype, level = 1, indent = 4)
    level == 1 && println(roottype) # das ist eine netter Trick für ein implizites if-else
    for s in subtypes(roottype)
        println(join(fill(" ", level * indent)) * string(s))
        subtypetree(s, level + 1, indent)
    end
end

subtypetree(Real)