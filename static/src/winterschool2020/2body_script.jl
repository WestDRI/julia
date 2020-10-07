using Plots

n = 2
x, v = zeros(n, 3), zeros(n, 3)
vel = 0.5

x[1, :], v[1, :] = [-1, 0, 0], [0, vel, 0]
x[2, :], v[2, :] = [1, 0, 0], [0, -vel, 0]

xnew, vnew = zeros(n, 3), zeros(n, 3)

dt = 0.001
step = Int(1e4)

history = zeros(n, 3, step+1)
history[:, :, 1] = x

for t in 1:step
    for i in 1:n
        force = zeros(3)
        for j in 1:n
            if i != j
                distSquared = sum((x[i, :] .- x[j, :]).^2)
                force .-= (x[i, :] .- x[j, :]) ./ distSquared.^1.5
            end
        end
        xnew[i, :] .= x[i, :] .+ v[i, :].*dt
        vnew[i, :] .= v[i, :] .+ force.*dt
    end
    global x = xnew
    global v = vnew
    history[:, :, t+1] = x
end

# # * 3D static plot

# plt = plot(
#     n,
#     xlim = (-2, 2),
#     ylim = (-2, 2),
#     zlim = (-2, 2),
#     markersize = 2,
#     seriestype = :scatter3d,
#     legend = false,
#     dpi = :300
# );

# plot!(history[1, 1, :], history[1, 2, :], history[1, 3, :], seriescolor = :blue);
# plot!(history[2, 1, :], history[2, 2, :], history[2, 3, :], seriescolor = :red);

# savefig("2body.png")

# * 2D static plot

plt = plot(
    n,
    xlim = (-2, 2),
    ylim = (-2, 2),
    zlim = (-2, 2),
    markersize = 2,
    legend = false,
    dpi = :300
);

plot!(history[1, 1, :], history[1, 2, :], seriescolor = :blue);
plot!(history[2, 1, :], history[2, 2, :], seriescolor = :red);

savefig("2body.png")

# # * 3D animated plot

# for i in range(1, step=50, stop=step)
#     plt = plot(
#         n,
#         xlim = (-2, 2),
#         ylim = (-2, 2),
#         zlim = (-2, 2),
#         seriestype = :scatter3d,
#         legend = false,
#         dpi = :300
#     );
#     scatter3d!(history[1, 1, i:i], history[1, 2, i:i], history[1, 3, i:i], markersize = 2);
#     scatter3d!(history[2, 1, i:i], history[2, 2, i:i], history[2, 3, i:i], markersize = 2);
#     png("nbody_plot/nbody" * lpad(i, length(string(step)), '0'))
# end

# create video with:
# ffmpeg -r 30 -pattern_type glob -i '/home/marie/parvus/pwg/wtm/tjl/static/src/winterschool2020/nbody_plot/*.png' -c:v libx264 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" '/home/marie/parvus/pwg/wtm/tjl/static/src/winterschool2020/nbody_plot/nbody.mp4'
