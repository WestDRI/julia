a = rand(20000000)

# Use the MergeSort algorithm of the sort function
# (in the standard Julia Base library)
b = copy(a); sort!(b, alg = MergeSort)

b = copy(a); @time sort!(b, alg = MergeSort);

# Let's run the function a second time to remove the effect
# of the initial compilation
b = copy(a); @time sort!(b, alg = MergeSort);
















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


addtwo = a -> a + 2

c = 5

c = addtwo(3)


function addsurprise(a)
    return a + 10
end

addsurprise(7)

function addsurprise(a::Float64)
    #= test doc =#
    return a + 2
end

addsurprise(6.0)



using UnicodePlots

UnicodePlots.histogram(randn(1000), nbins=40)






a = [3, 1, 2]
a[end]
sort(a)
a

sort!(a)

a = sort(a)

a



\omega		  # Press TAB
\sum          # Press TAB
\sqrt		  # Press TAB
\in           # Press TAB
\: phone:	  # (No space after the colon. I added it to prevent parsing) Press TAB

pi
Base.MathConstants.golden

typeof("hello")
typeof(true)


a = [1 2; 3 4]
a[1, 1]
a[1, :]
a[:, 1]






a = [3, 1, 2]

c = copy(a)

a[1, 1] = 8
a
c


a = 2
b = a
a = 3
b

a = 1.0


versioninfo()
VERSION

x = 10
x = 10;


x
x = 2;
x
y = x;
y
ans
ans + 3

a, b, c = 1, 2, 3

b

3 + 2
+(3, 2)

a = 3
2a

a = 1

a + 7
a += 7

a

2\8
8/2





a = [1 2; 3 4]






b = a
a[1, 1] = 0
b

[1, 2, 3, 4]
[1 2; 3 4]
[1 2 3 4]
[1 2 3 4]'
collect(1:4)
collect(1:1:4)
1:4
a = 1:4
collect(a)

[1, 2, 3] .* [1, 2, 3]

4//8
4/8

8//1

1//2 + 3//4

a = true
b = false
a + b






















































a = ["micro" , "macro" , "econometrics"]
for (index, value) in enumerate(a)
    println("$index$value")
end

open("results.txt", "w") do f
    write(f, "I like economics")
    close(f)
end


copy()
deepcopy()









using Random
Random.seed!(123);
a = rand(10000);
@time psort(a);











import Base.Threads.@spawn

function fib1(n::Int)
    if n < 2
        return n
    end
    t = @spawn fib1(n - 2)
    return fib1(n - 1) + fetch(t)
end

function fib2(n::Int)
    if n < 2
        return n
    end
    t = fib2(n - 2)
    return fib2(n - 1) + fetch(t)
end

@time fib1(35)

@time fib2(35)


Threads.@threads for i = 1:10
    println("i = $i on thread $(Threads.threadid())")
end




















import Base.Threads.@spawn

# Sort the elements of `v` in place, from indices `lo` to `hi` inclusive
function psort!(v, lo::Int=1, hi::Int = length(v))
    if lo >= hi                       # 1 or 0 elements: nothing to do
        return v
    end

    if hi - lo < 100000               # Below some cutoff, run in serial
        sort!(view(v, lo:hi), alg = MergeSort)
        return v
    end

    mid = (lo + hi) >>> 1             # Find the midpoint

    half = @spawn psort!(v, lo, mid)  # Task to sort the lower half: will run
    psort!(v, mid + 1, hi)              # in parallel with the current call sorting
    # the upper half
    wait(half)                        # Wait for the lower half to finish

    temp = v[lo:mid]                  # Workspace for merging

    i, k, j = 1, lo, mid + 1          # Merge the two sorted sub-arrays
    @inbounds while k < j <= hi
        if v[j] < temp[i]
            v[k] = v[j]
            j += 1
        else
            v[k] = temp[i]
            i += 1
        end
        k += 1
    end
    @inbounds while k < j
        v[k] = temp[i]
        k += 1
        i += 1
    end

    return v
end







# * split every half in 2 again

# # Sort the elements of `v` in place, from indices `lo` to `hi` inclusive
# function psort!(v, lo::Int=1, hi::Int = length(v))
#     if lo >= hi                       # 1 or 0 elements: nothing to do
#         return v
#     end

#     if hi - lo < 100000               # Below some cutoff, run in serial
#         sort!(view(v, lo:hi), alg = MergeSort)
#         return v
#     end

#     mid = (lo + hi) >>> 1             # Find the midpoint
#     firstQuart = (lo + mid) >>> 1
#     thirdQuart = (mid + hi) >>> 1

#     Q1 = @spawn psort!(v, lo, firstQuart)  # Task to sort the lower half: will run
#     Q2 = @spawn psort!(v, firstQuart + 1, mid)  # Task to sort the lower half: will run
#     Q3 = @spawn psort!(v, mid + 1, thirdQuart)  # Task to sort the lower half: will run
#     psort!(v, thirdQuart + 1, hi)              # in parallel with the current call sorting
#     # the upper half

#     wait(Q1)                        # Wait for the lower half to finish
#     temp1 = v[lo:firstQuart]                  # Workspace for merging
#     i, k, j = 1, lo, firstQuart + 1          # Merge the two sorted sub-arrays
#     @inbounds while k < j <= mid
#         if v[j] < temp1[i]
#             v[k] = v[j]
#             j += 1
#         else
#             v[k] = temp1[i]
#             i += 1
#         end
#         k += 1
#     end
#     @inbounds while k < j
#         v[k] = temp1[i]
#         k += 1
#         i += 1
#     end

#     wait(Q2)                        # Wait for the lower half to finish
#     temp2 = v[firstQuart + 1 : mid]                  # Workspace for merging
#     i, k, j = 1, firstQuart + 2, mid + 1          # Merge the two sorted sub-arrays
#     @inbounds while k < j <= hi
#         if v[j] < temp2[i]
#             v[k] = v[j]
#             j += 1
#         else
#             v[k] = temp2[i]
#             i += 1
#         end
#         k += 1
#     end
#     @inbounds while k < j
#         v[k] = temp2[i]
#         k += 1
#         i += 1
#     end

#     wait(Q3)                        # Wait for the lower half to finish
#     temp3 = v[mid + 1 : thirdQuart]                  # Workspace for merging
#     i, k, j = 1, mid + 2, thirdQuart + 1          # Merge the two sorted sub-arrays
#     @inbounds while k < j <= hi
#         if v[j] < temp3[i]
#             v[k] = v[j]
#             j += 1
#         else
#             v[k] = temp3[i]
#             i += 1
#         end
#         k += 1
#     end
#     @inbounds while k < j
#         v[k] = temp3[i]
#         k += 1
#         i += 1
#     end

#     return v
# end






a = rand(20000000);

b = copy(a); @time sort!(b, alg = MergeSort);

b = copy(a); @time psort!(b);









# python

# n = 10000000000
n = 100000000
h = 1.0 / n
sum = 0.0

@time for i in 1:n
    x = h * (i + 0.5)
    global sum += 4.0 / (1.0 + x^2)
    global sum *= h
    println(sum)
    abs(sum - pi)
end

@time Threads.@threads for i in 1:n
    x = h * (i + 0.5)
    global sum += 4.0 / (1.0 + x^2)
    global sum *= h
    println(sum)
    println(abs(sum - pi))
end

# parallel python

n = 1000000
h = 1./n
sum = 0.

# if rank == 0:
#     print 'Calculating PI with', size, 'processes'

# print 'process', rank, 'of', size, 'started'

for i in range(rank, n, size):
    # print rank, i
    x = h * ( i + 0.5 )
    sum += 4. / ( 1. + x**2)

    local = np.zeros(1)
    total = np.zeros(1)
    local[0] = sum*h
    comm.Reduce(local, total, op = MPI.SUM)
    if rank == 0:
        print total[0], abs(total[0]-pi)
    end
    



        
