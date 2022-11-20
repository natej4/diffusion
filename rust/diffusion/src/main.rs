extern crate ndarray;
use ndarray::Array3;
use min_max::*;
use std::{io, convert::TryInto};
// Nate Jackson
// Modeling the diffusion of a gas within a room
// Written for CSC 330 Project 2
// 11-18-2022

fn main() {
    // User input
    println!("Enter value for maxsize: ");
    let mut n = String::new();
    io::stdin()
        .read_line(&mut n)
        .expect("failed to read input.");
    let maxsize = n.trim().parse::<usize>().expect("invalid input");
    let mut cube = Array3::<f64>::zeros((maxsize+2,maxsize+2,maxsize+2));

    println!("75% partition true/false? ");
    let mut t = String::new();
    io::stdin()
        .read_line(&mut t)
        .expect("failed to read input.");
    let partition = t.trim().parse().unwrap(); // Implemented partition input directly as a bool
    // makes it more picky for the user but the simplest way on my end

    //determine location of partition within the room
    let mut partx = 0.0;
    let mut party = 0.0;
    if partition {
        partx = math::round::floor((maxsize+1) as f64/2 as f64, 0);
        party = math::round::ceil((maxsize+1) as f64*0.25 as f64, 0);
    }

    let diffusion_coefficient = 0.175;
    let room_dimension = 5.0;
    let speed_of_gas_molecules = 250.0;
    let timestep = (room_dimension / speed_of_gas_molecules) / maxsize as f64;
    let distance_between_blocks = room_dimension / maxsize as f64;
    let dterm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks);
    cube[[1,1,1]] = 1.0e+21_f64;
    let _pass = 0;
    let mut time = 0.0;
    let mut ratio = 0.0;

    //creation of partition
    for i in 0..maxsize+2 {
        for j in 0..maxsize+2 {
            for k in 0..maxsize+2 {
                // Nasty type conversion stuff
                if i == (partx as i64).try_into().unwrap() && j >= (party as i64).try_into().unwrap(){
                    cube[[i,j,k]] = 2.0;
                }
            }
        }
    }

    while ratio < 0.99 {
        //diffusion
        for i in 1..maxsize+1 {
            for j in 1..maxsize+1 {
                for k in 1..maxsize+1 {
                    for l in 1..maxsize+1 {
                        for m in 1..maxsize+1 {
                            for n in 1..maxsize+1 {
                                //check if cells share a face
                                if  ( ( i == l )   && ( j == m )   && ( k == n+1) ) ||  
                                    ( ( i == l )   && ( j == m )   && ( k as i64 == n as i64-1) ) ||  
                                    ( ( i == l )   && ( j == m+1 ) && ( k == n)   ) ||  
                                    ( ( i == l )   && ( j as i64 == m as i64-1 ) && ( k == n)   ) ||  
                                    ( ( i == l+1 ) && ( j == m )   && ( k == n)   ) ||  
                                    ( ( i as i64 == l as i64-1 ) && ( j == m )   && ( k == n)   )  {
                                        if partition {
                                            if cube[[i,j,k]] != 2.0 && cube[[l,m,n]] != 2.0{
                                                let change = (cube[[i,j,k]]-cube[[l,m,n]]) * dterm;
                                                cube[[i,j,k]] -= change;
                                                cube[[l,m,n]] += change;
                                            }
                                        }
                                        else{
                                            let change = (cube[[i,j,k]]-cube[[l,m,n]]) * dterm;
                                            cube[[i,j,k]] -= change;
                                            cube[[l,m,n]] += change;
                                        }
                                        
                                    }
                            }
                        }
                    }
                }
            }
        }
        time += timestep;
        //Checking to see if room is fully diffused
        let mut sumval = 0.0;
        let mut maxval = cube[[1,1,1]];
        let mut minval = cube[[1,1,1]];
        for i in 1..maxsize+1 {
            for j in 1..maxsize+1 {
                for k in 1..maxsize+1 {
                    if cube[[i,j,k]] != 2.0{
                        maxval = max_partial!(cube[[i,j,k]], maxval);
                        minval = min_partial!(cube[[i,j,k]], minval);
                        sumval += cube[[i,j,k]];
                    }
                }
            }
        }
        ratio = minval / maxval;
        //Output
        print!("{} {}",time,cube[[1,1,1]]);
        print!(" {}",cube[[maxsize,1,1]]);
        print!(" {}",cube[[maxsize,maxsize,1]]);
        print!(" {}",cube[[maxsize,maxsize,maxsize]]);
        println!(" {}",sumval);
    }
println!("Box equilibrated in {} seconds of simulated time.",time);
}
