using Distributed

hosts = []
pids = []

for i in workers()
    host, pid = fetch(@spawnat i (gethostname(), getpid()))
    println(host, pid)
    push!(hosts, host)
    push!(pids, pid)
end

addprocs(4)

for i in workers()
    host, pid = fetch(@spawnat i (gethostname(), getpid()))
    println(host, pid)
    push!(hosts, host)
    push!(pids, pid)
end

for i in workers()
    rmprocs(i)
end
