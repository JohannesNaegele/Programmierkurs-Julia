
###:------ Übungsblatt 9 ------:###


## Aufgabe 1

# (a)
using Plots
a, c, m = 69069, 1, 2^32
next(z, a, c, m) = (a * z + c) % m

# (b)
N = 10^7
data = Array{Float64,1}(undef, N)
x = 123456789
for i in 1:N
    data[i] = x/m
    global x = next(x, a, c, m)
end

# (c)
p1 = scatter(1:1000, data[1:1000],
c=:blue, m=4, msw=0, xlabel="n", ylabel="x_n")
p2 = histogram(
    data, bins=50, normed=:true,
    ylims=(0,1.1), xlabel="Support", ylabel="Density"
)
plot(p1, p2, size=(800, 400), legend=:none)

# (d)
using Distributions, HypothesisTests

data_normal = quantile.(Normal(), data)
histogram(data_normal)
ExactOneSampleKSTest(data_normal, Normal())

a, c, m = 16807, 1, 2^32-1
N = 10^7
data = Array{Float64,1}(undef, N)

x = 123456789
for i in 1:N
    data[i] = x/m
    global x = next(x, a, c, m)
end

data_normal = quantile.(Normal(), data)
histogram(data_normal)
ExactOneSampleKSTest(data_normal, Normal())


## Aufgabe 2

# (a)
next(r, x) = r * x * (1 - x)

# (b)
using Plots
m = 50
seq = zeros(m + 1)
seq[1] = 0.5
for i in 1:m
    seq[i + 1] = next(3.1, seq[i])
end
plot(collect(0:m), seq)

# (c)
function oscillations(x, r)
    # burn-in (wir vertrauen darauf, dass wir einigermaßen konvergiert sind)
    for _ in 1:1000
        x = next(r, x)
    end
    seq_value = Vector{Float64}(undef, 500)
    # funktioniert, solange wir nicht (mathematisch) >300 verschiedene Werte haben
    for i in 1:500
        x = next(r, x)
        seq_value[i] = x
    end
    return unique(x -> round(x, digits=4), seq_value)
end

# (d)
r_value = Float64[]
seq_value = Float64[]

r = 0:0.001:4
x = 0.5

for j in r
    res = oscillations(x, j)
    append!(r_value, fill(j, length(res)))
    append!(seq_value, res)
end

scatter(
    r_value,
    seq_value,
    markersize = 0.2,
    markercolor = :black
)

# Falls jemand Langeweile hat: Es gibt eine Verwandtschaft zur Mandelbrot-Menge,
# die sich schön plotten lässt.


## Aufgabe 3
macro todolist(items)
    dump(items)
    str = "TODO:\n"
    for (i, item) in enumerate(items.args)
        str *= string(i, ". ", item, "\n")
    end
    println(str)
end

@todolist Schlafen, Essen, Programmieren

@todolist begin 
    Schlafen,
    Essen,
    Programmieren
end


# Aufgabe 4

# Man kann an folgender Beispielimplementierung sehr einfach erkennen,
# dass (obwohl jedes Quadrat auch ein Rechteck ist) Square für sinnvolles Verhalten ein Feld weniger benötigt.
# Vererbung wäre also ineffizient.
struct Rectangle
    width::Float64
    height::Float64
end
width(r::Rectangle) = r.width
height(r::Rectangle) = r.height

struct Square
    length::Float64
end
width(s::Square) = s.length
height(s::Square) = s.length

area(shape) = width(shape) * height(shape)