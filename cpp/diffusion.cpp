#include <iostream>
#include <algorithm>
#include <string>
#include <cmath>

using namespace std;

int main(){
    int maxsize;
    float partX, partZ;
    string temp;
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
    if (p){
        partX = floor((maxsize+1)/2);
        partZ = floor((maxsize+1)*.5);
    }
    
    
    double*** cube =  new double** [maxsize+2];
    for (int i = 0; i <= maxsize+1; ++i) {
        cube[i] = new double* [maxsize+2];
        for (int j = 0; j <= maxsize+1; j++) {
          cube[i][j] = new double [maxsize+2];
        }
    }
    double diffusion_coefficient = 0.175;
    double room_dimension = 5;
    double speed_of_gas_molecules = 250.0;
    double timestep = (room_dimension / speed_of_gas_molecules) / maxsize;
    double distance_between_blocks = room_dimension / maxsize;
    double DTerm = diffusion_coefficient * timestep 
                    / (distance_between_blocks * distance_between_blocks);

    int pass = 0;
    double time = 0.0;
    double ratio = 0.0; 

    double sumval, maxval, minval;
    int count = 0;
    //zeroing out the room
    for (int i = 0; i <= maxsize+1; i++) {
        for (int j = 0; j <= maxsize+1; j++) {
            for (int k = 0; k <= maxsize+1; k++) {
                if (i == 0 || j == 0 || k == 0 || i ==maxsize+1 || j == maxsize+1 || k == maxsize+1){
                    cube[i][j][k] = 1;
                }
                else if (i == partX && j >= partZ){
                    cube[i][j][k] = 2;
                }
                else{
                    cube[i][j][k] = 0.0;

                }

            }
        }
    }
    
    
    cube[1][1][1] = 1.0e21;
    do {
        for (int i = 1; i <= maxsize; i++) {
            for (int j = 1; j <= maxsize; j++) {
                for (int k = 1; k <= maxsize; k++) {
                    for (int l = 1; l <= maxsize; l++) {
                        for (int m = 1; m <= maxsize; m++) {
                            for (int n = 1; n <= maxsize; n++) {
                                if (( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                                    ( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
                                    ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                                    ( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
                                    ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                                    ( ( i == l-1 ) && ( j == m )   && ( k == n)   )) {
                                        
                                                if(p){
                                                    // if ((l != int(partX) && j < int(partZ))){
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
                                            
                                        
                                        
                                        // else{
                                        //     cout << "no" << endl;
                                        // }
                                    }
                            }
                        }
                    }
                }
            }
        }
        time += timestep;

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

        cout << time << " " << cube[1][1][1];
        cout << " " << cube[maxsize][1][1];
        cout << " " << cube[maxsize][maxsize][1];
        cout << " " << cube[maxsize][maxsize][maxsize];
        cout << " " << sumval << endl;
    }   while (ratio < 0.99);
    cout << "Box equilibrated in " << time << " seconds of simulated time." << endl;

    for (int i=0; i<=maxsize+1; i++ ) {
        for (int j=0; j<=maxsize+1; j++ ) {
            delete[] cube[i][j];
        }
        delete[] cube[i];
    }
    delete[] cube;
    
}