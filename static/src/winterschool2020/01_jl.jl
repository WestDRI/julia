using Plots

# * Initial conditions

const G = 6.67e-11

n = 5

dt = 0.1

step = 100

bodies = [[i, rand(Float64, 1), rand(Float64, 3),
           rand(Float64, 3), rand(Float64, 3)] for i in 1:n]

history = deepcopy(bodies)

history = [history[i][[1, 3]] for i in 1:n]

# mutable struct Body
#     id::Int
#     m::Float64
#     r::Array{Float64,1}
#     v::Array{Float64,1}
#     a::Array{Float64,1}
# end

# * Acceleration

function a!(bodies::Array{Array{Any,1},1}, id::Int)
    for i in 1:n
        if bodies[i][1] != id
            d1 = bodies[i][3][1] - bodies[id][3][1]
            d2 = bodies[i][3][2] - bodies[id][3][2]
            d3 = bodies[i][3][3] - bodies[id][3][3]
            f = (-G * bodies[i][2][1] * bodies[id][2][1]) /
                (sqrt(d1^2 + d2^2 + d3^2))^3
            bodies[id][5][1] += f * d1
            bodies[id][5][2] += f * d2
            bodies[id][5][3] += f * d3
        end
    end
end

# * Velocity

function v!(bodies, dt)
    for i in 1:n
        a!(bodies, i)
        bodies[i][4][1] += bodies[i][5][1] * dt
        bodies[i][4][2] += bodies[i][5][2] * dt
        bodies[i][4][3] += bodies[i][5][3] * dt
    end
end

# * Position

function r!(bodies, dt)
    for i in 1:n
        bodies[i][3][1] += bodies[i][4][1] * dt
        bodies[i][3][2] += bodies[i][4][2] * dt
        bodies[i][3][3] += bodies[i][4][3] * dt
    end
end

# * Reset acceleration



# * Simulation

# function sim!(bodies, dt, step)
#     history_coord = Array{Float64}(undef, 3)
#     history_body = fill(history_coord, n)
#     history = fill(history_body, step)
#     for i in 1:step
#         v!(bodies, dt)
#         r!(bodies, dt)
#         for j in 1:n
#             history[i][j] = [bodies[j][3][1], bodies[j][3][2], bodies[j][3][3]]
#          end
#     end
#     return history
# end

# function sim!(bodies, dt, step)
#     for i in 1:step
#         v!(bodies, dt)
#         r!(bodies, dt)
#         for j in 1:n
#             push!(bodies, [bodies[j][3][1], bodies[j][3][2], bodies[j][3][3]])
#         end
#     end
#     bodies
# end

# function sim!(bodies, dt, step)
#     history_coord = Array{Float64}(undef, 3)
#     history_body = fill(history_coord, n)
#     history = fill(history_body, step)
#     for i in 1:step
#         v!(bodies, dt)
#         r!(bodies, dt)
#         push!(bodies)
#     end
# end

# function sim!(bodies, dt, step)
#     for i in 1:step
#         v!(bodies, dt)
#         r!(bodies, dt)
#         push!(history, [bodies[3][1], bodies[3][2], bodies[3][3]])
#     end
# end

function sim!(bodies, dt, step)
    for i in 1:step
        v!(bodies, dt)
        r!(bodies, dt)
        for j in 1:n
            append!(history, [bodies[j][[1, 3]]])
        end
    end
end

sim!(bodies, dt, step)

# function sim!(bodies, dt)
#     history_coord = Array{Float64}(undef, 3)
#     history = fill(history_coord, n)
#     v!(bodies, dt)
#     r!(bodies, dt)
#     for i in 1:n
#         history[i] = [bodies[i][3][1], bodies[i][3][2], bodies[i][3][3]]
#     end
#     history
# end

# sim!(bodies, dt)

function sim!(bodies, dt)
    v!(bodies, dt)
    r!(bodies, dt)
    for i in 1:n
        append!(history, [bodies[i][[1, 3]]])
    end
end

function sim!(bodies, dt)
    v!(bodies, dt)
    r!(bodies, dt)
end

# sim!(bodies, dt)

# * Plot

plt = plot3d(
    n,
    xlim = (0, 5000),
    ylim = (0, 5000),
    zlim = (0, 5000),
    marker = 2,
    legend = false
)

plt = plot3d(
    n,
    xlim = (0, 100),
    ylim = (0, 100),
    zlim = (0, 100),
    marker = 2,
    legend = false
)

plt = plot3d(
    n,
    xlim = (0, 1),
    ylim = (0, 1),
    zlim = (0, 1),
    # marker = 2, 
    legend = false
)

# history[[history[i][1] == 1 for i=1:length(history)]]

for j in 1:n
    @eval $(Symbol("hist_$j")) = history[[history[i][1] == $j for i=1:length(history)]]
end

@gif for i=1:step+1
    push!(plt, hist_1[i][2][1], hist_1[i][2][2], hist_1[i][2][3])
    push!(plt, hist_2[i][2][1], hist_2[i][2][2], hist_2[i][2][3])
    push!(plt, hist_3[i][2][1], hist_3[i][2][2], hist_3[i][2][3])
    push!(plt, hist_4[i][2][1], hist_4[i][2][2], hist_4[i][2][3])
    push!(plt, hist_5[i][2][1], hist_5[i][2][2], hist_5[i][2][3])
end every 10

@gif for i=1:step+1
    push!(plt, hist_1[i][2][1], hist_1[i][2][2], hist_1[i][2][3])
end every 10




@gif for i=1:500
    sim!(bodies, dt)
    for j in 1:n
        push!(plt, bodies[j][3][1], bodies[j][3][2], bodies[j][3][3])
    end
end every 10






@gif for i=1:1500
    sim!(bodies, dt)
    push!(plt, bodies[1][1], bodies[1][2], bodies[1][3])
end every 10





@gif for i=1:1500
    sim!(bodies, dt)
    push!(plt, bodies[1][1], bodies[1][2], bodies[1][3])
end every 10


for i in 1:step
    push!(plt, bodies[i][1][1], bodies[i][1][2], bodies[i][1][3])
end
