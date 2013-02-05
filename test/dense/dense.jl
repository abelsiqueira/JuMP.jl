# dense.jl
# Make a big dense matrix

using MathProg

function doTest(N,M)

  # Generate data
  srand(10)
  A = rand(1:10,M,N)
  b = N+rand(1:(N*10),M)
  c = rand(1:10,N)

  tic() # Time model construction
  
  # Create a Model, its variables, and set the objective
  m = Model("max")
  #v = [ Variable(m,0,1,0,"x$j") for j=1:N ]
  @addVars(m, 0 <= v[1:N] <= 1)
  @setObjective( m, sum{c[j]*v[j], j=1:N} )
 
  # Create M constraints
  for i = 1:M
    # We have four alternatives to create expressions
    # 1. Simply sum the terms using Julia's sum
    # lhs = sum([A[i,j]*v[j] for j=1:N])
    # 2. Use a smarter sum that avoids temporary objects 
    # lhs = lpSum([A[i,j]*v[j] for j=1:N])
    # 3. Use macros to build the affine expression directly
    @addConstraint(m, sum{A[i,j]*v[j], j = 1:N} <= b[i])
  end
  
  toc() # End model construction time
#  println("Time to build the model in memory.\n")
  
  tic()
  #writeLP(m,"dense.lp")
  writeMPS(m,"dense.mps")
  toc()
 # println("Time to write to file.")
  
end

N = int(ARGS[1])
M = int(ARGS[2])

doTest(N,M)