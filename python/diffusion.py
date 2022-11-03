#!/usr/bin/python3
import numpy as np


maxsize = int(input("Enter value for maxsize: "))
cube = np.zeros((maxsize, maxsize, maxsize))
diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / maxsize
distance_between_blocks = room_dimension / maxsize
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

    [[[[[[changing(i,j,k,l,m,n) for n in range(0,maxsize) ] 
    for m in range(0, maxsize)]
    for l in range(0, maxsize)]
    for k in range(0, maxsize)]
    for j in range(0, maxsize)]
    for i in range(0, maxsize)]

    time += timestep

    sumval = 0.0
    maxval = cube[0][0][0]
    minval = cube[0][0][0]

    for i in cube.flat:
        maxval = max(i, maxval)
        minval = min(i, minval)
        sumval += i

    ratio = minval / maxval

    print(time, " ", cube[0][0][0], " ", cube[maxsize-1][0][0], " ", cube[maxsize-1][maxsize-1][0], " ", cube[maxsize-1][maxsize-1][maxsize-1], " ", sumval)
   

print("Box equilibrated in ", time, " seconds of simulated time.")