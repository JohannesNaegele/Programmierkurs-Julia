###:------ Übungsblatt 2 ------:###

## Aufgabe 1 (Funktionen und Strings)

# (a)
function personal_info(surname, lastname, age)
    println("Vorname: $surname")
    println("Nachname: $lastname")
    println("Alter: $age")
end

# (b)
function welcome_message(names...) # splatting
    println.(names..., " has joined the server!") # weil wir bisher keine Loops kennen, hier eine Lösung mit broadcasting
    print("") # das ist dafür da, die nervigen nothing-Ausgaben zu unterdrücken
    # würde ich alles aber so normalerweise auch nicht schreiben...
end

## Aufgabe 2

# (a) 
x = 5
y = 3

(x > y) | (x == y) # true
(x < y) | (x != y) & (x == x) # true
(y == y) & (x == y) | (y == x) # false
(x == x) & ((y == y) | (y == x)) # true
# tja  ¯\_(ツ)_/¯

# (b)
function iscomplex(x)
    return x isa Complex
end

# typeof geht auch, aber ist tricky (denn = funktioniert nicht – werden wir später verstehen)
function iscomplex(x)
    return typeof(x) <: Complex
end

iscomplex(2im)

# (c)
function indikator(x, a, b)
    (a <= x <= b) ? 1 : 0
end

a, b = [0, 1]
indikator(0.5, a, b)
indikator(1.5, a, b)

# (d) bei diesen Aufgaben gibt es viele Wege nach Rom...
retransform(x) = x == 1 ? true : false
x = [0.5, 2, 0.7, 0]
retransform.(indikator.(x, a, b)) # indikator spuckt 0 und 1 aus -> mache wieder zu Bools

# (e)
count(x, a, b) = sum(indikator.(x, a, b))

a, b = [0, 0.5]
x = rand(1000)
count(x, a, b)

## Aufgabe 3

function compare(x, y, index)
    if (index[1] > length(x)) || (index[1] < 1) || (index[2] > length(y)) || (index[2] < 1)
        println("die gewählten Indizes müssen den Längen der Vektoren entsprechen")
    elseif (x[index[1]] > y[index[2]])
        println(
            "x is an der Stelle " *
            string(index[1]) *
            " größer als y an der Stelle" *
            string(index[2])
        )
    else
        println(
            "y is an der Stelle " *
            string(index[2]) *
            " größer als x an der Stelle " *
            string(index[1])
        )
    end
end

x = [3, 6, 10]
y = [2, 8, 5, 17]
index1 = [1, 3]
index2 = [3, -1]

compare(x, y, index1)
compare(x, y, index2)