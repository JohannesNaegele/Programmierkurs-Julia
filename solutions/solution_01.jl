###:------ Übungsblatt 1 ------:###


## Aufgabe 1 (Arrays)

# (a)
a = 1:100

# (b)
sum_a = sum(a)
fac_20 = prod(1:20)
exp_a = exp.(a)
log_a = log.(a)
log2_a = log.(2, a) # oder log2
squared_a = a .^ 2

# (c)
c = repeat(a, 100)
println(c[95:105])


## Aufgabe 2 (Matrizen und Vektoren)

# (a)
mat = rand(10, 10)

# (b)
colsum = sum(mat, dims=1)
rowsum = sum(mat, dims=2)
println(rowsum[1] == sum(mat[1, :]))  # wir testen, ob unsere Berechnung stimmt

# (c)
b = fill(1, 10) # b = repeat([1], 10)
x = mat \ b

# (d)
println(isapprox(mat * x, b, atol=1e-12))


## Aufgabe 3

# (a)
x = [1.0, 2.0, 3.0]
y = [1.1, 1.9, 3.1]

# (b)
X = ones(3, 2)
X[:, 2] = x

# (c)
β = (X' * X)^-1 * X' * y

## Aufgabe 4

# (a)
d = [1, [2, 3], 4]

# die buzzwords für diese Aufgabe sind copy-by-value vs. copy-by-reference
foo = d # dasselbe Objekt

# Kopie, aber subarrays sind im Prinzip nur Zeiger, die auch in der Kopie auf denselben
# Speicherbereich zeigen!
bar = copy(d)
# Kopie und alle Speicherbereiche der subarrays werden komplett neu angelegt; subarrays 
# zeigen woandershin
baz = deepcopy(d)

foobar = d[1:2] # Ausschnitt als Kopie
foobaz = view(d, 1:2) # Ausschnitt ohne Kopie

d[1] = 0
d[2][1] = 10

println(foo); println(bar); println(baz); println(foobar); println(foobaz)

# (b)
collect(a)