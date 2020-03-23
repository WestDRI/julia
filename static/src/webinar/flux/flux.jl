using Flux

f(x) = 3x^2 + 2x + 1;

df(x) = gradient(f, x)[1]; # df/dx = 6x + 2

df(2)

d2f(x) = gradient(df, x)[1]; # d²f/dx² = 6

d2f(2)

f(x, y) = sum((x .- y).^2);

gradient(f, [2, 1], [2, 0])

x = [2, 1];

y = [2, 0];

gs = gradient(params(x, y)) do
    f(x, y)
end

gs[x]

gs[y]

W = rand(2, 5)
b = rand(2)

predict(x) = W*x .+ b

function loss(x, y)
    ŷ = predict(x)
    sum((y .- ŷ).^2)
end

x, y = rand(5), rand(2) # Dummy data
loss(x, y) # ~ 3

tata = () -> addtwo(3)















using Distributions
using Plots

regX = rand(100)
regY = 100 * regX + rand(Normal(0, 10), 100)

scatter(regX, regY)




















myfavoriteanimals = ("penguins", "cats", "sugargliders")
