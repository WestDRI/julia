n = 100000000
h = 1.0 / n
sum = 0.0

@time Threads.@threads for i in 1:n
    x = h * (i + 0.5)
    global sum += 4.0 / (1.0 + x^2)
    global sum *= h
    println(sum)
    println(abs(sum - pi))
end
