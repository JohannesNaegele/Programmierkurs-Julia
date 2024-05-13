###:------ Übungsblatt 8 ------:###


## Aufgabe 1

# (a)
next(x) = x % 2 == 0 ? Int(x / 2) : 3x + 1

# (b)
function collatz_length(x::Integer)
    n = 0
    while x != 1
        x = next(x)
        n += 1
    end
    return n
end

# (c)
lengths = [collatz_length(x₀) for x₀ = 1:10^7]

using Plots
histogram(
    lengths,
    normalized = :true,
    fill = (0, 1.0, :red),
    la = 0,
    legend = :none,
    xlabel = "Length",
    ylabel = "Frequency",
)


## Aufgabe 2

# (a)
using Random
Random.seed!(42)

# (b)
using Distributions
v1 = rand(Uniform(10, 20), 1000)
v2 = rand(Normal(15, 2), 1000)
v3 = rand(Gumbel(2.0), 1000)

# (c)
df = DataFrame(
    :Spalte1 => v1,
    :Spalte2 => v2,
    :Spalte3 => v3
)

# (d)
@pipe df |>
    filter(x -> x.Spalte1 > x.Spalte2, _) |>
    describe(_)[1, :min]


## Aufgabe 3

# (a)
using Random, LinearAlgebra, Plots

N = 10^5
data = [[rand(), rand()] for _ in 1:N]

# (b)
indata = filter((x) -> (norm(x) <= 1), data)
outdata = filter((x) -> (norm(x) > 1), data)

# (c)
piApprox = 4 * length(indata)/N
println("Pi Estimate: ", piApprox)

# (d)
scatter(
    first.(indata),
    last.(indata),
    c=:blue,
    ms=1,
    msw=0
)
scatter!(
    first.(outdata),
    last.(outdata),
    c=:red,
    ms=1,
    msw=0,
    xlims=(0, 1),
    ylims=(0, 1),
    legend=:none,
    ratio=:equal
)


## Aufgabe 4

# (a)
mat = randn(1000, 1000)

# (b)
using BenchmarkTools
# zuerst über Spalten zu summieren ist effizienter -> liegt an column major
@benchmark sum(count(x -> x > 1, mat, dims=1))
@benchmark sum(count(x -> x > 1, mat, dims=2))
@benchmark count(x -> x > 1, mat)
@benchmark sum(x -> x > 1, mat)


## Aufgabe 5

# (a)
const fibo_cache = Dict()

# unsere rekursive Fibonacci-Funktion, nur dass wir jetzt 
_fibo_rec(n) = n < 2 ? 1 : fibo_smart(n - 1) + fibo_smart(n - 2)

# eine smartere Variante mit caching
function fibo_smart(n)
    if haskey(fibo_cache, n) # wenn wir den Funktionswert für n schon berechnet haben, dann gib ihn zurück
        return fibo_cache[n]
    else
        value = _fibo_rec(n) # wenn nicht, dann berechne ihn :D
        fibo_cache[n] = value
        return value
    end
end

println(fibo_smart(1000))

# (b)
function memoize(f)
    memo = Dict()
    g = x -> begin
        if haskey(memo, x)
            return memo[x]
        else
            value = f(x)
            memo[x] = value
            return value
        end
    end
    return g # könnte man sich auch sparen; ist so leichter lesbar
end

fibo_rec = n -> begin
    return n < 3 ? 1 : fib(n - 1) + fib(n - 2)
end

fibo_rec = memoize(fibo_rec)

fibo_rec(44)

# (c)
perl = n -> begin
    if n == 0
        return 0
    elseif n == 1
        return 1
    else
        return 2*perl(n-1) + perl(n-2)
    end
end

@btime perl(20)
perl = memoize(perl)
@btime perl(20)