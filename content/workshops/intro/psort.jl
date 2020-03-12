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

a = rand(20000000);

b = copy(a); @time psort!(b);

b = copy(a); @time psort!(b);
