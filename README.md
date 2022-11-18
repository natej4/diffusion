# Diffusion Project
### Written by Nate Jackson
Models the diffusion of a gas through a three dimensional cube
Maxsize refers to the number of cubes that make up the modeled room, higher values result in higher accuracy but exponentially increasing runtimes.
## How to compile and run:
Unless otherwise noted, enter an integer for maxsize and 'y' or 'n' for a 75% partition within the room
### C++
```bash
c++ diffusion.cpp -o diffusion
./diffusion
```

### Rust
Within the 'Diffusion' Project Folder:
```bash
cargo run --release
```
*Note: It will run without the --release option but my timing was done with it enabled*

Enter integer for maxsize, then type 'true' or 'false' (spelled out) for partition
### Julia
```bash
./diffusion.jl
```

### Python
```bash
python3 diffusion.py
```
In a futile attempt to optimize python, I implemented comprehensions for the giant nested for loop, that is why it looks a bit different than other languages
### Fortran
```bash
gfortran diffusion.f95 -o diffusion
./diffusion
```
### Lisp
```bash
./diffusion.lisp
```
### Ada
```bash
gnatmake diffusion.adb -o diffusion
./diffusion
```
