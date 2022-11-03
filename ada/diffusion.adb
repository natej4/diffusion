with ada.text_io, ada.integer_text_io, ada.float_text_io;
use ada.text_io, ada.integer_text_io, ada.float_text_io;

Procedure diffusion is
    type Three_Dimensional_Float_Array is array (Integer range <>, Integer range <>, Integer range <>) of Float;
    MaxSize : Integer := 10;
    diffusion_coefficient : Float := 0.175;
    room_dimension : Float := 5.0;
    speed_of_gas_molecules : Float := 250.0;
    timestep : Float := (room_dimension / speed_of_gas_molecules) / Float(MaxSize);
    distance_between_blocks : Float := room_dimension / FLoat(MaxSize);
    DTerm : Float := diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);
    pass : Integer := 0;
    time : Float := 0.0;
    ratio : Float := 0.0;
    change : Float := 0.0;

    begin
        put("What is the Maxsize: ");
        get(MaxSize);

        declare
            cube : Three_Dimensional_Float_Array (1..MaxSize, 1..MaxSize, 1..MaxSize) := (others => (others => (others => 0.0)));
        begin
        cube(1,1,1) := 1.0e21;
        while ratio < 0.99 loop
            for i in 1..MaxSize loop
                for j in 1..MaxSize loop
                    for k in 1..MaxSize loop
                        for l in 1..MaxSize loop
                            for m in 1..MaxSize loop
                                for n in 1..MaxSize loop
                                    if  (i=l and j=m and k=n+1) or 
                                        (i=l and j=m and k=n-1) or 
                                        (i=l and j=m+1 and k=n) or
                                        (i=l and j=m-1 and k=n) or
                                        (i=l+1 and j=m and k=n) or
                                        (i=l-1 and j=m and k=n) then
                                            change := (cube(i,j,k) - cube(l,m,n)) * DTerm;
                                            cube(i,j,k) := cube(i,j,k) - change;
                                            cube(l,m,n) := cube(l,m,n) + change;
                                    end if;
                                    
                                end loop;
                            end loop;
                        end loop;
                    end loop;
                end loop;
            end loop;
        
        time := time + timestep;
        declare
            sumval : Float := 0.0;
            maxval : Float := cube(1,1,1);
            minval : Float := cube(1,1,1);
            begin

                for i in 1..MaxSize loop
                    for j in 1..MaxSize loop
                        for k in 1..MaxSize loop
                            maxval := Float'Max(cube(i,j,k),maxval);
                            minval := Float'Min(cube(i,j,k),minval);
                            sumval := sumval + cube(i,j,k);
                        end loop;
                    end loop;
                end loop;
                ratio := minval / maxval;
           
        put(Float'Image (time));put(" ");put(Float'Image(cube(1,1,1)));
        put(" ");put(Float'Image(cube(MaxSize,1,1)));
        put(" ");put(Float'Image(cube(MaxSize,Maxsize,1)));
        put(" ");put(Float'Image(cube(MaxSize,MaxSize,1)));
        put(" ");put_line(Float'Image(sumval));
        end;
        end loop;
        put("Box equilibrated in ");put(Float'Image(time));put_line(" seconds of simulated time.");
        end;
         


end diffusion;