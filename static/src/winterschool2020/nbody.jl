using LabelledArrays
using Plots

# * Initial conditions

const G = 6.67e-11
n = 2
dt = 0.01
# dt = 0.001
step = 200
# step = 10000

# bodies = [SLArray{Tuple{5}}(id=i::Int,
#                             m=rand(Float64),
#                             r=rand(Float64, 3),
#                             v=rand(Float64, 3),
#                             a=rand(Float64, 3)) for i in 1:n]

bodies = [LArray((5, 1);
                 id=i::Int,
                 m=1.0,
                 r=rand(Float64, 3),
                 v=rand(Float64, 3),
                 a=zeros(1,3)) for i in 1:n]

bodies[1].r, bodies[1].v = [-1.0, 0.0, 0.0], [0.0, 0.5, 0.0]
bodies[2].r, bodies[2].v = [1.0, 0.0, 0.0], [0.0, 0.5, 0.0]

# * Step

function sim!()
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
    for k in 1:3
        for i in 1:n
            bodies[i].v[k] += acc[i, k] * dt
        end
    end
    for k in 1:3
        for i in 1:n
            bodies[i].r[k] += bodies[i].v[k] * dt
        end
    end
end

# * Plot

for i in 1:step
    sim!()
    plt = plot(
        n,
        xlim = (-2, 2),
        ylim = (-2, 2),
        zlim = (-2, 2),
        markersize = 2,
        seriescolor = :green,
        seriestype = :scatter3d,
        legend = false,
        dpi = :300
    );
    for j in 1:n
        push!(plt, bodies[j].r[1], bodies[j].r[2], bodies[j].r[3])
    end
    png("nbody_plot/nbody" * lpad(i, length(string(step)), '0'))
end

# create video with:
# ffmpeg -r 30 -pattern_type glob -i '/home/marie/parvus/pwg/wtm/tjl/static/src/winterschool2020/nbody_plot/*.png' -c:v libx264 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '/home/marie/parvus/pwg/wtm/tjl/static/src/winterschool2020/nbody_plot/nbody.mp4'
