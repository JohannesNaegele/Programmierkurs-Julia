###:------ Übungsblatt 3 ------:###


## Aufgabe 1

# (a)
function fibo_for(n)
    if (n == 0) || (n == 1)
        return 1
    else
        sum_old = 1 # alte Teilsumme
        sum_recent = 1 # aktuelle Teilsumme
        for _ in 2:n # gute Konvention: Durch _  ist klar, dass die Laufvariable nicht verwendet wird
            temp = sum_recent # aktuelle Teilsumme wird zwischengespeichert
            sum_recent = sum_old + sum_recent
            sum_old = temp # die aktuelle Teilsumme wird in der nächsten Iteration zur alten Teilsumme
        end
        return sum_recent
    end
end

# (b)
function fibo_while(n)
    if (n == 0) || (n == 1)
        return 1
    else
        i = 1 # bis hierhin haben wir bisher summiert
        sum_old = 1
        sum_recent = 1
        while (i < n) # summiere solange, wie wir n noch nicht erreicht haben
            temp = sum_recent
            sum_recent = sum_old + sum_recent
            sum_old = temp
            i += 1 # erhöhe Iterationszähler
        end
        return sum_recent
    end
end

# (c)
function fibo_rec(n)
    if (n == 0) || (n == 1)
        return 1
    else
        return fibo_rec(n - 1) + fibo_rec(n - 2)
    end
end

# (d)
println(fibo_for(1)) # 1
println(fibo_for(10)) # 89
println(fibo_for(40)) # 165580141

println(fibo_while(1))
println(fibo_while(10))
println(fibo_while(40))

# fibo_rec ist sehr langsam für große n!
println(fibo_rec(1))
println(fibo_rec(10))
println(fibo_rec(40))

# Was ist das Problem? Schauen wir uns die internen Funktionsaufrufe von fibo_rec(4) an:

# fibo_rec(4)               <- initialer Funktionsaufruf
# ├─ fibo_rec(3)
# │  ├─ fibo_rec(2)
# │  │  ├─ fibo_rec(1)
# |  │  ├─ fibo_rec(0)
# |  ├─ fibo_rec(1)
# ├─ fibo_rec(2)            <- wie fibo_rec(3) nur ohne + fibo_rec(1)
# │  ├─ fibo_rec(1)
# |  ├─ fibo_rec(0)

# Wir sehen, dass der Teil ab fibo_rec(2) immer derselbe ist (und quasi unnötig mehrfach ausgerechnet wird);
# im Prinzip wird also insgesamt zweimal fibo_rec(3) aufgerufen, nur dass man sich + fibo_rec(1) spart.
# Wenn wir von Letzterem mal absehen, bekommen wir einen Aufwand von O(2^n) – also exponentiellen Aufwand.
# Eigentlich bräuchte man aber nur O(n).
# Weil's ganz interessant ist: Wenn man die Abschätzung verbessern will,
# landet man in O(z^n), wobei z der Goldene Schnitt (≈1.618) ist.

# (e)
function fibo_sum(n)
    i = 0
    sum = 0
    fibo_number = 0
    while fibo_number < n
        if (fibo_number % 2 == 0) sum += fibo_number end
        i += 1
        fibo_number = fibo_for(i)
    end
    return sum
end

fibo_sum(2000000) # 1089154


## Aufgabe 2

function print_numbers(first_number, last_number)
    if first_number <= last_number
        println(first_number)
        print_numbers(first_number + 1, last_number)
    end
end

print_numbers(1, 9)

## Aufgabe 3

# (a)
function isprime(n)
    prime = true
    if (n == 1) # die Zahl 1 hat nur einen Teiler, nämlich sich selbst
        prime = false
    elseif (n > 2) # 
        i = 2 # erster Teiler, den wir probieren
        # teste solange, wie wir noch nicht teilen konnten und wir
        while (prime && i < n / (i - 1))
            prime = (n % i) != 0 # wir testen, ob n durch i teilbar ist
            i += 1 # probiere neuen Teiler
        end
    end
    return prime
end

# (b)
# dies ist (relativ) ineffizient und nur für pädagogische Zwecke!
function nth_prime(n)
    i = 1 # Zähler, wieviel Primzahlen wir bisher gefunden haben
    number = 2 # erste Primzahl, wir testen sukzessive Integer durch
    while i < n
        number += 1 # fyi: hätten wir i >= 3, so könnten wir i += 2 rechnen
        isprime(number) ? i += 1 : nothing
    end
    return number
end

println(nth_prime(1))
println(nth_prime(3))
println(nth_prime(10001)) # 104743

# (c)
function primesum(n)
    grid_numbers = fill(true, n) # grid_numbers[i] gibt an, ob i Primzahl ist
    grid_numbers[1] = false # 1 ist keine Primzahl
    for i in 2:Int(floor(n/2)) # wir streichen alle Vielfachen einer Primzahl
        number = grid_numbers[i]
        if (number)
            grid_numbers[2i:i:n] .= false
        end
    end
    return sum(filter(i -> grid_numbers[i], 1:n))
end

primesum(1000000) # 37550402023

# (d)
function primefactors(n)
    factors = []
    i = 1
    while n > 1 # wir teilen solange, bis n gerade 1 ist
        if (isprime(i)) && (n % i) == 0
            n /= i
            push!(factors, i)
        end
        i += 1
    end
    sort!(factors, rev = true)
    return factors
end

primefactors(600851475143)

# (e)
function g_seq(n) # das ist gₙ
    old = 7
    new = 0
    for _ in 1:(n - 1)
        new = (old^2) % 231
        old = new
    end
    return old
end

function g_sum(n) # das ist diese g₅ₖ Reihe
    sum = 0
    for i in 1:n
        sum += g_seq(5i)
    end
    return sum
end

println(g_sum(1000)) # 101500