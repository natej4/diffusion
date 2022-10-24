with Ada.Text_IO;  use Ada.Text_IO;

Procedure diffusion is
    MaxSize : Constant Integer := 10;
    Cube : array (1..MaxSize, 1..MaxSize, 1..MaxSize) of Float;

    begin
        for I in 0..MaxSize loop
            for J in 0..MaxSize loop
                for K in 0..MaxSize loop
                    Cube(I, J, K) := 0.0;
                    --  Put(Cube(I, J, K));
                end loop;
            end loop;
        end loop;


end diffusion;