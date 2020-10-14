typeof(2)

typeof(2.0)

typeof("hello")

typeof(true)

a = [1 2; 3 4]

a[1, 1]

a[1, :]

for i in 1:10
    println(i)
end

for i in 1:3, j in 1:2
    println(i * j)
end

a = 2

b = 2.0

if a == b
    println("It's true")
else
    println("It's false")
end

if a === b
    println("It's true")
else
    println("It's false")
end

# Terse format
a === b ? println("It's true") : println("It's false")

function addTwo(a)
    a + 2
end

addTwo(3)

# In terse format
addtwo = a -> a + 2

addTwo()

# With default argument
function name(a = "unknown")
    println("My name is $a.")
end

name("Julia")

name()

using UnicodePlots

UnicodePlots.histogram(randn(1000), nbins=40)

using Plots, Distributions, StatsPlots

# Using the GR framework as backend
gr()

x = 1:10; y = rand(10, 2);

p1 = Plots.histogram(randn(1000), nbins=40)

p2 = plot(Normal(0, 1))

p3 = scatter(x, y)

p4 = plot(x, y)

plot(p1, p2, p3, p4)
