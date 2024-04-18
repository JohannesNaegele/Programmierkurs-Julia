###:------ Übungsblatt 5 ------:###


## Aufgabe 1

# (a)
using DataFrames, CSV, Pipe
df = CSV.File("./../data/fish.csv") |> DataFrame

# (b)
describe(df)

using Statistics
@pipe df |> groupby(_, :Spezies) |>
    combine(_, :Gewicht => mean)

# (c)
# ...

# (d)
using CategoricalArrays
sorted_species = @pipe df |> groupby(_, :Spezies) |>
    combine(_, nrow) |>
    sort(_, :nrow, rev=true)
df.Spezies = categorical(df.Spezies; levels=Array(sorted_species.Spezies), ordered=true)
fish_df[1, :Spezies] > fish_df[100, :Spezies] # Test: Bream hat mehr Beobachtungen als Smelt

# (e)
using GLM
fm = @formula(Laenge_diag ~ Laenge_vert)
regr = @pipe df |> lm(fm, _)
r2(regr)

# (f)
df[!, end-2:end]
# Hier habe ich die Aufgabe so interpretiert, dass man beide Anfragen in einer Ausgabe zurückgibt
@pipe df |>
    select(_, contains.(names(_), "a")) # easier is: r"a"


## Aufgabe 2

# (a)
@pipe df |> cor(_.Laenge_vert, _.Gewicht)
# Ja, der Zusammenhang erscheint logisch, denn ein längerer Fisch ist in der Regel auch schwerer.

# (b)
using Plots
@pipe df |> scatter(
    _.Laenge_vert,
    _.Gewicht
)

fm = @formula(Gewicht ~ Laenge_vert)
regr = @pipe df |> lm(fm, _)
r2(regr)

@pipe df |> plot!(
    _.Laenge_vert,
    predict(regr, _),
    label="model"
)
# Zusammenhang scheint nicht linear zu sein. Motivation wäre etwa:
# Ein längerer Fisch ist meistens auch breiter/höher. Also ist der Gewichtszuwachs überproportional.

# (c)

fm = @formula(Gewicht ~ Laenge_vert + Laenge_vert^2)
regr = @pipe df |> lm(fm, _)
r2(regr)

# Wir müssen x-Werte sortieren, damit unser Linienplot nicht im Kreis geht
sort!(df, :Laenge_vert)

@pipe df |> plot!(
    _.Laenge_vert,
    predict(regr, _),
    label="model"
)


## Aufgabe 3 (Zusatzaufgabe)

# Ansatz
x = [[0, 1], [0, 1, 2]]
map(y -> exp.(y), x)

# Richtige Lösung
⊕(f, x) = broadcast(y -> f.(y), x) # es geht auch map
exp ⊕ (x)

# Hier noch bisschen entertainment
# geklaut von https://github.com/maxbennedich/code-golf/tree/cea06287689868f2342959f9c12f0b629a1d0cf4/hearts

   0:2e-3:2π    .|>d->(P=
 fill(5<<11,64 ,25);z=8cis(
d)sin(.46d);P[ 64,:].=10;for
r=0:98,c=0 :5^3 x,y=@.mod(2-
$reim((.016c-r/49im-1-im)z),
 4)-2;4-x^2>√2(y+.5-√√x^2)^
  2&&(P[c÷2+1,r÷4+1]|=Int(
    ")*,h08H¨"[4&4c+1+r&
      3])-40)end;print(
       "\e[H\e[1;31m",
         join(Char.(
            P)))
             );