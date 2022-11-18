#!/usr2/local/julia-1.8.2/bin/julia
using Printf
# Nate Jackson
# Modeling the diffusion of a gas within a room
# For CSC 330 Project 2
# 11/18/2022

# User input
print("What is maxsize? ")
const maxsize = parse(Int32, readline())
print("75% parttition y/n? ")
temp = readline()

cube = zeros(maxsize+2 ,maxsize+2,maxsize+2) # the room
diffusion_coefficient = 0.175
room_dimension = 5.0
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / maxsize
distance_between_blocks = room_dimension / maxsize
DTerm = diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks)
p = false #partition
if temp == "y"
	p = true
end
#location of partition
partx = ceil((maxsize+2)/2)
party = ceil((maxsize+2)*0.5)
cube[2,2,2] = 1.0e21 # fill first cell

pass = 0
time = 0.0
ratio = 0.0
#creation of partition
if p
    for i in 1:maxsize+2, j in 1:maxsize+2, k in 1:maxsize+2
        if i == partx && j >= party
	        cube[i,j,k] = 2.0
        end
    end
end

while ratio < .99
    #diffusion
    for i in 2:maxsize+1, j in 2:maxsize+1, k in 2:maxsize+1, 
        l in 2:maxsize+1, m in 2:maxsize+1, n in 2:maxsize+1
        # check to see if cells are next to each other
        if i == l && j == m && k == n+1 ||
            i == l && j == m && k == n-1 ||
            i == l && j == m+1 && k == n ||
            i == l && j == m-1 && k == n ||
            i == l+1 && j == m && k == n ||
            i == l-1 && j == m && k == n
		if p
			if cube[i,j,k] != 2.0 && cube[l,m,n] != 2.0
        		change = (cube[i,j,k]- cube[l, m, n]) * DTerm
           		cube[i, j, k] -= change
           		cube[l,m,n] += change
			end
		end   
		if !p   
        	change = (cube[i,j,k]- cube[l, m, n]) * DTerm
           	cube[i, j, k] -= change
           	cube[l,m,n] += change
		end
        end
    end

    global time += timestep
    # check if room is fully diffused
    global sumval = 0.0
    global maxval = cube[2,2,2]
    global minval = cube[2,2,2]
    for i in 2:maxsize+1, j in 2:maxsize+1, k in 2:maxsize+1
	if cube[i,j,k] != 2.0
        global maxval = maximum([cube[i,j,k], maxval])
        global minval = minimum([cube[i,j,k], minval])
        global sumval += cube[i,j,k]
	end
    end
    global ratio = minval / maxval
    # Output
    @printf("%f %e",time, cube[2,2,2])
    @printf(" %e",cube[maxsize+1,2,2])
    @printf(" %e",cube[maxsize+1,maxsize+1,2])
    @printf(" %e",cube[maxsize+1,maxsize+1,maxsize+1])
    @printf(" %e\n",sumval)
end
@printf("Box equilibrated in %f seconds of simulated time.\n", time)
