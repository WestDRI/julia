using LabelledArrays
using Plots

# mutable struct Body
#     id::Int
#     m::Float64
#     r::Array{Float64,1}
#     v::Array{Float64,1}
#     a::Array{Float64,1}
# end

# * Initial conditions

const G = 6.67e-11
n = 5
dt = 0.1
step = 100

# bodies = [[i, rand(), rand(Float64, 3),
#            rand(Float64, 3), rand(Float64, 3)] for i in 1:n]

# bodies = [SLVector(id=i,
#                    m=rand(),
#                    rx=rand(), ry=rand(), rz=rand(),
#                    vx=rand(), vy=rand(), vz=rand(),
#                    ax=rand(), ay=rand(), az=rand()) for i in 1:n]

# test = [SLVector(body=i::Int) for i in 1:n]

# test = [SLVector(@eval $(Symbol("body$j"))=history[[history[i][1] == $j for i=1:length(history)]]
# body=i::Int) for i in 1:n]

# bodies = [SLArray{Tuple{5}}(@eval $(Symbol("$i"))=LArray(1{Any,1}(undef, 5)) for i in 1:n]

# label = @SLVector (:b1, :b2, :b3, :b4, :b5)

# label = @SLVector (Symbol(1), Symbol(2), Symbol(3), Symbol(4), Symbol(5))

bodies = [SLArray{Tuple{5}}(id=i::Int,
                            m=rand(Float64),
                            r=rand(Float64, 3),
                            v=rand(Float64, 3),
                            a=rand(Float64, 3)) for i in 1:n]

# bodies_step1 = [SLArray{Tuple{5}}(id=i::Int,
#                                   m=rand(Float64),
#                                   r=rand(Float64, 3),
#                                   v=rand(Float64, 3),
#                                   a=rand(Float64, 3)) for i in 1:n]

# bodies = label(bodies_step1)

# bodies = [SLVector(id=i::Int,
#                    m=rand(Float64),
#                    r=rand(Float64, 3),
#                    v=rand(Float64, 3),
#                    a=rand(Float64, 3)) for i in 1:n]

# testx = []
# for i in 1:n
#     tmpx = []
#     for j in filter(!=(i), 1:n)
#         push!(tmpx, (G * bodies[j].m * (bodies[i].r[1] - bodies[j].r[1]) /
#                      abs(sqrt((bodies[i].r[1] - bodies[j].r[1])^2 +
#                              (bodies[i].r[2] - bodies[j].r[2])^2 +
#                              (bodies[i].r[3] - bodies[j].r[3])^2))^3))
#     end
#     push!(testx, sum(tmpx, dims=1)[1])
# end

# testy = []
# for i in 1:n
#     tmpy = []
#     for j in filter(!=(i), 1:n)
#         push!(tmpy, (G * bodies[j].m * (bodies[i].r[2] - bodies[j].r[2]) /
#                      abs(sqrt((bodies[i].r[1] - bodies[j].r[1])^2 +
#                               (bodies[i].r[2] - bodies[j].r[2])^2 +
#                               (bodies[i].r[3] - bodies[j].r[3])^2))^3))
#     end
#     push!(testy, sum(tmpy, dims=1)[1])
# end

# testz = []
# for i in 1:n
#         tmpz = []
#         for j in filter(!=(i), 1:n)
#             push!(tmpz, (G * bodies[j].m * (bodies[i].r[3] - bodies[j].r[3]) /
#                          abs(sqrt((bodies[i].r[1] - bodies[j].r[1])^2 +
#                               (bodies[i].r[2] - bodies[j].r[2])^2 +
#                               (bodies[i].r[3] - bodies[j].r[3])^2))^3))
#     end
#     push!(testz, sum(tmpz, dims=1)[1])
# end

# test0 = hcat(testx, testy, testz)


# * Acceleration

acc = []
for k in 1:3
    tmp0 = []
    for i in 1:n
        tmp1 = []
        for j in filter(!=(i), 1:n)
            push!(tmp1, (G * bodies[j].m * (bodies[i].r[k] - bodies[j].r[k]) /
                         abs(sqrt((bodies[i].r[1] - bodies[j].r[1])^2 +
                                  (bodies[i].r[2] - bodies[j].r[2])^2 +
                                 (bodies[i].r[3] - bodies[j].r[3])^2))^3))
        end
        push!(tmp0, sum(tmp1, dims=1)[1])
    end
    push!(acc, tmp0)
end

acc = reshape(collect(Iterators.flatten(acc)), n, 3)

# * Velocity

# v = v + a dt

for k in 1:3
    for i in 1:n
        bodies[i].v[k] += acc[i, k] * dt
    end
end

# * Position

# r = r + v dt

for k in 1:3
    for i in 1:n
        bodies[i].r[k] += bodies[i].v[k] * dt
    end
end





history = deepcopy(bodies)

history = [history[i][[1, 3]] for i in 1:n]

function a!(bodies::Array{Array{Any,1},1}, id::Int)
        for i in 1:n
        if bodies[i][1] != id
            d1 = bodies[i][3][1] - bodies[id][3][1]
            d2 = bodies[i][3][2] - bodies[id][3][2]
            d3 = bodies[i][3][3] - bodies[id][3][3]
            f = (G * bodies[i][2][1] * bodies[id][2][1]) /
                (sqrt(d1^2 + d2^2 + d3^2))^3
            bodies[id][5][1] += f * d1
            bodies[id][5][2] += f * d2
            bodies[id][5][3] += f * d3
        end
    end
end

function v!(bodies, dt)
    for i in 1:n
        a!(bodies, i)
        bodies[i][4][1] += bodies[i][5][1] * dt
        bodies[i][4][2] += bodies[i][5][2] * dt
        bodies[i][4][3] += bodies[i][5][3] * dt
    end
end

function r!(bodies, dt)
    for i in 1:n
        bodies[i][3][1] += bodies[i][4][1] * dt
        bodies[i][3][2] += bodies[i][4][2] * dt
        bodies[i][3][3] += bodies[i][4][3] * dt
    end
end



function step!(bodies, dt)
    v!(bodies, dt)
    r!(bodies, dt)
end

step!(bodies, dt)




function step!(bodies, dt, step)
    for i in 1:step
        v!(bodies, dt)
        r!(bodies, dt)
        for j in 1:n
            append!(history, [bodies[j][[1, 3]]])
        end
    end
end

step!(bodies, dt, step)

for j in 1:n
    @eval $(Symbol("hist$j")) = history[[history[i][1] == $j for i=1:length(history)]]
end

hist1 = [hist1[i][2] for i=1:length(hist1)]

plt = plot(
    n,
    xlim = (0, 1),
    ylim = (0, 1),
    zlim = (0, 1),
    markersize = 2,
    seriescolor = :green,
    seriestype = :scatter3d,
    legend = false
)

@gif for i in 1:step+1
    push!(plt, hist1[i][1], hist1[i][2], hist1[i][3])
end

anim = Animation()

for i in 1:step+1
    push!(plt, hist1[i][1], hist1[i][2], hist1[i][3])
end

p = plot([sin, cos], zeros(0), leg = false, xlims = (0, 2π), ylims = (-1, 1))

anim = Animation()

for x = range(0, stop = 2π, length = 20)
    push!(p, x, Float64[sin(x), cos(x)])
    frame(anim)
end
