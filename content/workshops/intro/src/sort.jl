a = rand(20000000);

b = copy(a); @time sort!(b, alg = MergeSort);

b = copy(a); @time sort!(b, alg = MergeSort);
