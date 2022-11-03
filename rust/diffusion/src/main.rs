extern crate ndarray;
//extern crate scinotation
use ndarray::Array3;
use min_max::*;
// use std::env;

const MAXSIZE: usize = 10;
fn main() {
    // env::set_var("RUST_BACKTRACE", "full");
let mut cube = Array3::<f64>::zeros((MAXSIZE,MAXSIZE,MAXSIZE));

let diffusion_coefficient = 0.175;
let room_dimension = 5.0;
let speed_of_gas_molecules = 250.0;
let timestep = (room_dimension / speed_of_gas_molecules) / MAXSIZE as f64;
let distance_between_blocks = room_dimension / MAXSIZE as f64;
let dterm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks);
cube[[0,0,0]] = 1.0e+21_f64;
let _pass = 0;
let mut time = 0.0;
let mut ratio = 0.0;

while ratio < 0.99 {
    for i in 0..MAXSIZE {
        for j in 0..MAXSIZE {
            for k in 0..MAXSIZE {
                for l in 0..MAXSIZE {
                    for m in 0..MAXSIZE {
                        for n in 0..MAXSIZE {
                            if  ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                                ( ( i == l )   && ( j == m )   && ( k as i64 == n as i64-1) ) ||  
                                ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                                ( ( i == l )   && ( j as i64 == m as i64-1 ) && ( k == n)   ) ||  
                                ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                                ( ( i as i64 == l as i64-1 ) && ( j == m )   && ( k == n)   )  {
                                    let change = (cube[[i,j,k]]-cube[[l,m,n]]) * dterm;
                                    cube[[i,j,k]] -= change;
                                    cube[[l,m,n]] += change;
                                    // println!("{}",change);

                                }
                        }
                    }
                }
            }
        }
    }
    time += timestep;
    let mut sumval = 0.0;
    let mut maxval = cube[[0,0,0]];
    let mut minval = cube[[0,0,0]];
    for i in 0..MAXSIZE {
        for j in 0..MAXSIZE {
            for k in 0..MAXSIZE {

                maxval = max_partial!(cube[[i,j,k]], maxval);
                minval = min_partial!(cube[[i,j,k]], minval);
                sumval += cube[[i,j,k]];
            }
        }
    }
    // println!("{}",minval);
    // println!("{} {}",maxval,minval);

    ratio = minval / maxval;
    print!("{} {}",time,cube[[0,0,0]]);
    print!(" {}",cube[[MAXSIZE-1,0,0]]);
    print!(" {}",cube[[MAXSIZE-1,MAXSIZE-1,0]]);
    print!(" {}",cube[[MAXSIZE-1,MAXSIZE-1,MAXSIZE-1]]);
    println!(" {}",sumval);


}
println!("Box equilibrated in {} seconds of simulated time.",time);
}