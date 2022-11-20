with ada.text_io, ada.integer_text_io, ada.float_text_io;
use ada.text_io, ada.integer_text_io, ada.float_text_io;
--  Nate Jackson
--  Modeling the diffusion of a gas within a room
--  For CSC 330
--  11/18/2022

Procedure diffusion is
--  the room
    type Three_Dimensional_Float_Array is array (Integer range <>, Integer range <>, Integer range <>) of Float;
    MaxSize : Integer;-- Number of cells that make up the room
    diffusion_coefficient : Float := 0.175;
    room_dimension : Float := 5.0;
    speed_of_gas_molecules : Float := 250.0;
    
    pass : Integer := 0;
    time : Float := 0.0;
    ratio : Float := 0.0;
    change : Float;
    partition : Boolean := false;
    temp : Character;
    partitionsize : Float := 1.0-0.75;

    begin
--  user input
        put("What is the Maxsize: ");
        get(MaxSize);
        put("75% partition y/n? ");
        get(temp);
        
        if (temp = 'y') then
            partition:= true;
        end if;
        declare
            timestep : Float := (room_dimension / speed_of_gas_molecules) / Float(MaxSize);
            distance_between_blocks : Float := room_dimension / FLoat(MaxSize);
            DTerm : Float := diffusion_coefficient * timestep / (distance_between_blocks*distance_between_blocks);
            cube : Three_Dimensional_Float_Array (1..MaxSize+2, 1..MaxSize+2, 1..MaxSize+2) := (others => (others => (others => 0.0)));
            partX : Float := Float'Ceiling(Float (MaxSize+2)/2.0);
            partY : Float := Float'Ceiling(Float (MaxSize+1)*0.25)+1.0;
        begin
--  creating partition     
        if (partition) then
			if (maxsize mod  2 = 0) then
				partY := partY-1.0;
			end if;
            for i in 2..MaxSize+1 loop
                for j in 2..MaxSize+1 loop
                    for k in 2..MaxSize+1 loop
                        if (i = Integer (partX) and j >= Integer (partY)) then
                            cube(i,j,k) := 2.0;
                        end if;
                    end loop;
                end loop;
            end loop;
        end if;
        cube(2,2,2) := 1.0e21;--filling first cell
        while ratio < 0.99 loop
        -- diffusion
            for i in 2..MaxSize+1 loop
                for j in 2..MaxSize+1 loop
                    for k in 2..MaxSize+1 loop
                        for l in 2..MaxSize+1 loop
                            for m in 2..MaxSize+1 loop
                                for n in 2..MaxSize+1 loop
                                --check if cells are next to each other
                                    if  (i=l and j=m and k=n+1) or 
                                        (i=l and j=m and k=n-1) or 
                                        (i=l and j=m+1 and k=n) or
                                        (i=l and j=m-1 and k=n) or
                                        (i=l+1 and j=m and k=n) or
                                        (i=l-1 and j=m and k=n) then
                                        if partition then
                                            if cube(i,j,k) /= 2.0 and cube(l,m,n) /= 2.0 then
                                                change := (cube(i,j,k) - cube(l,m,n)) * DTerm;
                                                cube(i,j,k) := cube(i,j,k) - change;
                                                cube(l,m,n) := cube(l,m,n) + change;
                                            end if;
                                        end if;
                                        if not partition then
                                            change := (cube(i,j,k) - cube(l,m,n)) * DTerm;
                                            cube(i,j,k) := cube(i,j,k) - change;
                                            cube(l,m,n) := cube(l,m,n) + change;
                                        end if;
                                    end if;  
                                end loop;
                            end loop;
                        end loop;
                    end loop;
                end loop;
            end loop;
        
        time := time + timestep;
        -- check to see if room is fully diffused
        declare
            sumval : Float := 0.0;
            maxval : Float := cube(2,2,2);
            minval : Float := cube(2,2,2);
            begin
                for i in 2..MaxSize+1 loop
                    for j in 2..MaxSize+1 loop
                        for k in 2..MaxSize+1 loop
                            if cube(i,j,k) /= 2.0 then
                            maxval := Float'Max(cube(i,j,k),maxval);
                            minval := Float'Min(cube(i,j,k),minval);
                            sumval := sumval + cube(i,j,k);
                            end if;
                        end loop;
                    end loop;
                end loop;
                ratio := minval / maxval;
           
        --  Output
        put(time,3,2,0);put(" ");put(Float'Image(cube(2,2,2)));
        put(" ");put(Float'Image(cube(MaxSize+1,2,2)));
        put(" ");put(Float'Image(cube(MaxSize+1,MaxSize+1,2)));
        put(" ");put(Float'Image(cube(MaxSize+1,MaxSize+1,MaxSize+1)));
        put(" ");put_line(Float'Image(sumval));--conservation of mass
        end;
        end loop;
        put("Box equilibrated in ");put(time, 3, 2, 0);put_line(" seconds of simulated time.");
        end;
end diffusion;
