#!/usr/bin/python3
import numpy as np

MAXSIZE = 10

cube = np.zeros((MAXSIZE, MAXSIZE, MAXSIZE))
diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / MAXSIZE
distance_between_blocks = room_dimension / MAXSIZE
DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

mypass = 0
time = 0.0
ratio = 0.0

#first cell
cube[0][0][0] = 1.0e21

def changing(i, j, k, l, m, n):
    if (( i == l ) and ( j == m ) and ( k == n+1)) or (( i == l ) and ( j == m ) and ( k == n-1) ) or ( ( i == l ) and ( j == m+1 ) and ( k == n)) or ( ( i == l ) and ( j == m-1 ) and ( k == n)) or ( ( i == l+1 ) and ( j == m )and ( k == n)) or ( ( i == l-1 ) and ( j == m ) and ( k == n)):
        change = (cube[i][j][k] - cube[l][m][n]) * DTerm
        cube[i][j][k] -= change
        cube[l][m][n] += change


while ratio < 0.99:
    # for i in range(0, MAXSIZE):
    #     for j in range(0, MAXSIZE):
    #         for k in range(0, MAXSIZE):
    #             for l in range(0, MAXSIZE):
    #                 for m in range(0, MAXSIZE):
    #                     for n in range(0, MAXSIZE):
    #                         if (( i == l ) and ( j == m ) and ( k == n+1)) or (( i == l ) and ( j == m ) and ( k == n-1) ) or ( ( i == l ) and ( j == m+1 ) and ( k == n)) or ( ( i == l ) and ( j == m-1 ) and ( k == n)) or ( ( i == l+1 ) and ( j == m )and ( k == n)) or ( ( i == l-1 ) and ( j == m ) and ( k == n)):
    #                             changing(i,j,k,l,m,n)

    [[[[[[changing(i,j,k,l,m,n) for n in range(0,MAXSIZE) ] 
    for m in range(0, MAXSIZE)]
    for l in range(0, MAXSIZE)]
    for k in range(0, MAXSIZE)]
    for j in range(0, MAXSIZE)]
    for i in range(0, MAXSIZE)]

    time += timestep

    sumval = 0.0
    maxval = cube[0][0][0]
    minval = cube[0][0][0]

    for i in cube.flat:
        maxval = max(i, maxval)
        minval = min(i, minval)
        sumval += i

    ratio = minval / maxval

    print(time, " ", cube[0][0][0], " ", cube[MAXSIZE-1][0][0], " ", cube[MAXSIZE-1][MAXSIZE-1][0], " ", cube[MAXSIZE-1][MAXSIZE-1][MAXSIZE-1], " ", sumval)
   

print("Box equilibrated in ", time, " seconds of simulated time.")