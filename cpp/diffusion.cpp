#include <iostream>
#include <algorithm>

using namespace std;

int main(int argc, char** argv){
    const int maxsize = stoi(argv[1]);
    // double cube[maxsize][maxsize][maxsize];
    double*** cube =  new double** [maxsize];
    for (int i = 0; i < maxsize; ++i) {
      cube[i] = new double* [maxsize];
      for (int j = 0; j < maxsize; j++) {
          cube[i][j] = new double [maxsize];
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

    //zeroing out the room
    for (int i = 0; i < maxsize; i++) {
        for (int j = 0; j < maxsize; j++) {
            for (int k = 0; k < maxsize; k++) {
                cube[i][j][k] = 0.0;
            }
        }
    }

    cube[0][0][0] = 1.0e21;
    do {
        for (int i = 0; i < maxsize; i++) {
            for (int j = 0; j < maxsize; j++) {
                for (int k = 0; k < maxsize; k++) {
                    for (int l = 0; l < maxsize; l++) {
                        for (int m = 0; m < maxsize; m++) {
                            for (int n = 0; n < maxsize; n++) {
                                if (( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                                    ( ( i == l )   && ( j == m )   && ( k == n-1) ) ||  
                                    ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                                    ( ( i == l )   && ( j == m-1 ) && ( k == n)   ) ||  
                                    ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                                    ( ( i == l-1 ) && ( j == m )   && ( k == n)   )) {
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
        time += timestep;

        sumval = 0.0;
        maxval = cube[0][0][0];
        minval = cube[0][0][0];
        for (int i = 0; i < maxsize; i++) {
            for (int j = 0; j < maxsize; j++) {
                for (int k = 0; k < maxsize; k++) {
                    maxval = max(cube[i][j][k], maxval);
                    minval = min(cube[i][j][k], minval);
                    sumval += cube[i][j][k];
                }
            }
        }
        ratio = minval / maxval;

        cout << time << " " << cube[0][0][0];
        cout << " " << cube[maxsize-1][0][0];
        cout << " " << cube[maxsize-1][maxsize-1][0];
        cout << " " << cube[maxsize-1][maxsize-1][maxsize-1];
        cout << " " << sumval << endl;
    }   while (ratio < 0.99);
    cout << "Box equilibrated in " << time << " seconds of simulated time." << endl;

    for (int i=0; i<maxsize; i++ ) {
        for (int j=0; j<maxsize; j++ ) {
            delete[] cube[i][j];
        }
        delete[] cube[i];
    }
    delete[] cube;
    
}