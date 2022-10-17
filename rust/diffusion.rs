use ndarray::Array3;

fn 
main() {
    const MAXSIZE:i32 = 10;
    let mut cube = Array3::<f64>::zeroes(MAXSIZE, MAXSIZE, MAXSIZE);
    for i in 0..MAXSIZE {
        for j in 0..MAXSIZE{
            for k in 0..MAXSIZE {
                cube[i][j][k]  = 0.0;
            }
        }
    }
}