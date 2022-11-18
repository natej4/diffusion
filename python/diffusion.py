#!/usr/bin/python3
import numpy as np
import math


maxsize = int(input("Enter value for maxsize: "))
temp = input("75% partition y/n?")
cube = np.zeros((maxsize+2, maxsize+2, maxsize+2))
diffusion_coefficient = 0.175
room_dimension = 5
speed_of_gas_molecules = 250.0
timestep = (room_dimension / speed_of_gas_molecules) / maxsize
distance_between_blocks = room_dimension / maxsize
DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)
partition = False

mypass = 0
time = 0.0
ratio = 0.0
if temp == "y":
	partition = True
if partition:
	partX = int(math.floor((maxsize+1)/2))
	partY = int(math.floor((maxsize+1)*0.5))
for i in range(1,maxsize+1):
	for j in range(1,maxsize+1):
		for k in range(1,maxsize+1):
			if (i == partX and j >= partY):
				cube[i][j][k] = 2.0

#first cell
cube[1][1][1] = 1.0e21

def changing(i, j, k, l, m, n):
	if (( i == l ) and ( j == m ) and ( k == n+1)) or (( i == l ) and ( j == m ) and ( k == n-1) ) or ( ( i == l ) and ( j == m+1 ) and ( k == n)) or ( ( i == l ) and ( j == m-1 ) and ( k == n)) or ( ( i == l+1 ) and ( j == m )and ( k == n)) or ( ( i == l-1 ) and ( j == m ) and ( k == n)):
		if partition:
			if (cube[i][j][k] != 2.0) and (cube[l][m][n] != 2.0):
				change = (cube[i][j][k] - cube[l][m][n]) * DTerm
				cube[i][j][k] -= change
				cube[l][m][n] += change
		else:	
			change = (cube[i][j][k] - cube[l][m][n]) * DTerm
			cube[i][j][k] -= change
			cube[l][m][n] += change


while ratio < 0.99:

	[[[[[[changing(i,j,k,l,m,n) for n in range(1,maxsize+1) ] 
	for m in range(1, maxsize+1)]
	for l in range(1, maxsize+1)]
	for k in range(1, maxsize+1)]
	for j in range(1, maxsize+1)]
	for i in range(1, maxsize+1)]

	time += timestep

	sumval = 0.0
	maxval = cube[1][1][1]
	minval = cube[1][1][1]
	for i in range(1,maxsize+1):
		for j in range(1,maxsize+1):
			for k in range(1,maxsize+1):
				if cube[i][j][k] != 2.0:
					maxval = max(cube[i][j][k], maxval)
					minval = min(cube[i][j][k], minval)
					sumval += cube[i][j][k]

	ratio = minval / maxval

	print(time, " ", cube[1][1][1], " ", cube[maxsize][1][1], " ", cube[maxsize][maxsize][1], " ", cube[maxsize][maxsize][maxsize], " ", sumval)
   

print("Box equilibrated in ", time, " seconds of simulated time.")
