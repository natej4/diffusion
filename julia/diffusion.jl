using Printf

const maxsize = 5
cube = zeros(maxsize, maxsize, maxsize)
diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250
timestep = (room_dimension / speed_of_gas_molecules) /maxsize
distance_between_blocks = room_dimension / maxsize
DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks)

cube[1,1,1] = 1.0e21

pass = 0
time = 0.0
ratio = 0.0

while ratio < 2
    for i in 1:maxsize, j in 1:maxsize, k in 1:maxsize, 
        l in 1:maxsize, m in 1:maxsize, n in 1:maxsize
        if i == l && j == m && k == n+1 ||
            i == l && j == m && k == n-1 ||
            i == l && j == m+1 && k == n ||
            i == l && j == m-1 && k == n ||
            i == l+1 && j == m && k == n ||
            i == l-1 && j == m && k == n
            change = (cube[i,j,k]- cube[l, m, n]) * DTerm
            cube[i, j, k] -= change
            cube[i,j,k] += change
            println(cube[i,j,k], cube[l,m,n])
        end
    end
    println()
    global time += timestep

    global sumval = 0.0
    global maxval = cube[1,1,1]
    global minval = cube[1,1,1]
    for i in 1:maxsize, j in 1:maxsize, k in 1:maxsize
        global maxval = maximum([cube[i,j,k], maxval])
        global minval = minimum([cube[i,j,k], minval])
        global sumval += cube[i,j,k]
    end
    
    global ratio += 1

    # @printf("%f %e",time, cube[1,1,1])
    # @printf(" %e",cube[maxsize,1,1])
    # @printf(" %e",cube[maxsize,maxsize,1])
    # @printf(" %e",cube[maxsize,maxsize,maxsize])
    # @printf(" %e\n",sumval)
    
    # print(time)
    # print(" ")
    # print(cube[1,1,1])
    # print(" ")
    # print(cube[maxsize,1,1])
    # print(" ")
    # print(cube[maxsize,maxsize,1])
    # print(" ")
    # print(cube[maxsize,maxsize,maxsize])
    # print(" ")
    # println(sumval)
end

@printf("Box equilibrated in %f seconds of simulated time.\n")