#include <iostream>
#include <algorithm>
#include <string>
#include <cmath>
//Nate Jackson
//Modeling the diffusion of a gas within a cube
//For CSC 330
//11-18-2022

using namespace std;

int main(){
    int maxsize; //dimensions of the room i.e. maxsize x maxsize x maxsize cubes
    float partX, partZ;
    string temp;
    //user input
    cout << "Enter maxsize: ";
    cin >> temp;
    maxsize = stoi(temp);
    cout << "75\% partition y/n? ";
    string pinput;
    bool p = false;
    cin >> pinput;
    if(pinput == "y"){
        p = true;
    }
    //setting location of partition
    if (p){
        partX = floor((maxsize+1)/2);
        partZ = floor((maxsize+1)*.75);
    }
    
    //array memory allocation
    double*** cube =  new double** [maxsize+2];
    for (int i = 0; i <= maxsize+1; ++i) {
        cube[i] = new double* [maxsize+2];
        for (int j = 0; j <= maxsize+1; j++) {
          cube[i][j] = new double [maxsize+2];
        }
    }
    //variable declaration
    double diffusion_coefficient = 0.175;
    double room_dimension = 5;
    double speed_of_gas_molecules = 250.0;
    double timestep = (room_dimension / speed_of_gas_molecules) / maxsize;
    double distance_between_blocks = room_dimension / maxsize;
    double DTerm = diffusion_coefficient * timestep 
                    / (distance_between_blocks * distance_between_blocks);

    double time = 0.0;
    double ratio = 0.0; 

    double sumval, maxval, minval;
    int count = 0;

    //zeroing out the room
    for (int i = 0; i <= maxsize+1; i++) {
        for (int j = 0; j <= maxsize+1; j++) {
            for (int k = 0; k <= maxsize+1; k++) {
                if (i == partX && j >= partZ){
                    cube[i][j][k] = 2.0;
                }
                else{
                    cube[i][j][k] = 0.0;

                }

            }
        }
    }
    
    cube[1][1][1] = 1.0e21;//placing gas in first cell of room
    
    do {
        //diffusion process
        for (int i = 1; i <= maxsize; i++) {
            for (int j = 1; j <= maxsize; j++) {
                for (int k = 1; k <= maxsize; k++) {
                    for (int l = 1; l <= maxsize; l++) {
                        for (int m = 1; m <= maxsize; m++) {
                            for (int n = 1; n <= maxsize; n++) {
                                //if the cubes are next to each other, diffuse
                                if (( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                                    ( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
                                    ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                                    ( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
                                    ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                                    ( ( i == l-1 ) && ( j == m )   && ( k == n)   )) {

                                    if(p){
                                        if (cube[l][m][n] != 2 && cube[i][j][k] != 2){
                                            double change = (cube[i][j][k] - cube [l][m][n]) * DTerm;
                                            cube[i][j][k] -= change;
                                            cube[l][m][n] += change;
                                        }
                                    }
                                    else {
                                        double change = (cube[i][j][k] - cube [l][m][n]) * DTerm;
                                        cube[i][j][k] -= change;
                                        cube[l][m][n] += change;
                                    }                                                                            
                                }
                            }
                        }
                    }
                }
            }
        }
        time += timestep;
        //now checking to see if fully diffused
        sumval = 0.0;
        maxval = cube[1][1][1];
        minval = cube[1][1][1];
        for (int i = 1; i <= maxsize; i++) {
            for (int j = 1; j <= maxsize; j++) {
                for (int k = 1; k <= maxsize; k++) {
                    if (cube[i][j][k] != 2){
                        maxval = max(cube[i][j][k], maxval);
                        minval = min(cube[i][j][k], minval);
                        sumval += cube[i][j][k];
                    }
                }
            }
        }
        ratio = minval / maxval;
        //output current status of diffusion
        cout << time << " " << cube[1][1][1];
        cout << " " << cube[maxsize][1][1];
        cout << " " << cube[maxsize][maxsize][1];
        cout << " " << cube[maxsize][maxsize][maxsize];
        cout << " " << sumval << endl; //monitors conservation of mass
    }   while (ratio < 0.99);
    cout << "Box equilibrated in " << time << " seconds of simulated time." << endl;

    //deallocation of memory
    for (int i=0; i<=maxsize+1; i++ ) {
        for (int j=0; j<=maxsize+1; j++ ) {
            delete[] cube[i][j];
        }
        delete[] cube[i];
    }
    delete[] cube;
}