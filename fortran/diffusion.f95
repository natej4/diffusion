! Nate Jackson
! Modeling the diffusion of a gas within a room
! For CSC 330 Project 2
! 11-18-2022

program diffusion
    implicit none

    integer :: i, j, k, l, m, n, tempint
    character(len=3) :: temp, temp2 
    integer :: maxsize ! dimensions of the cube in terms of cells
    ! real, dimension(maxsize+2, maxsize+2, maxsize+2) :: cube
    real, dimension(:,:,:), allocatable :: cube
    real :: diffusion_coefficient = 0.175, room_dimension = 5
    real :: speed_of_gas_molecules = 250.0, timestep, distance_between_blocks, DTerm
    real :: time = 0.0, ratio = 0.0, change, sumval = 0.0, maxval, minval
    logical :: partition = .false.
    integer :: partX, partY
    do i=1,command_argument_count()-1
        if (i > 1) then 
            maxsize = maxsize * 10
        endif
        Call get_command_argument(i, temp)
        read(temp,*) tempint
        maxsize = maxsize + tempint
        
    enddo
print *, maxsize
    allocate (cube(maxsize+2,maxsize+2,maxsize+2))
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / &
&(distance_between_blocks * distance_between_blocks)    
    Call get_command_argument(command_argument_count(), temp) 
    if (temp == "y") then
        partition = .true.
    endif
    ! determining location of partition
    if (partition) then
        partX = ceiling((maxsize+2)/2.0)
        partY = ceiling((maxsize+2)*0.25)+1
        if (modulo(maxsize, 2) == 0) then
            partY = partY - 1
        endif
    endif
    !zeroing the cube and placing partition if necessary
    do i = 1,maxsize+2
        do j = 1,maxsize+2
            do k = 1,maxsize+2
                if (partition .and. (i == partX .and. j >= partY)) then
                    cube(i,j,k)=2.0
                else
                    cube(i,j,k) = 0.0
                endif
            enddo
        enddo
    enddo
    cube(2,2,2) = 1.0e21 ! filling first cell
    do while (ratio < 0.99)
        !diffusion
        do i = 2,maxsize+1
            do j = 2,maxsize+1
                do k = 2,maxsize+1
                    do l = 2,maxsize+1
                        do m = 2,maxsize+1
                            do n = 2,maxsize+1
                                ! check to see if cells share a face
                                if ((( i == l ) .and. ( j == m ) .and. ( k == n+1)) .or. &
                                &(( i == l ) .and. ( j == m ) .and. ( k == n-1)) .or. &
                                &(( i == l ) .and. ( j == m+1 ) .and. ( k == n)) .or. &
                                &(( i == l ) .and. ( j == m-1 ) .and. ( k == n)) .or. &
                                &(( i == l+1 ) .and. ( j == m ) .and. ( k == n)) .or. &
                                &(( i == l-1 ) .and. ( j == m ) .and. ( k == n))) then
                                    if (partition) then
 
                                        if (cube(i,j,k) /= 2.0 .and. cube(l,m,n) /= 2.0) then
                                            change = (cube(i,j,k) - cube(l,m,n)) * DTerm
                                            cube(i,j,k) = cube(i,j,k) - change
                                            cube(l,m,n) = cube(l,m,n) + change
                                        endif
                                    else
                                        change = (cube(i,j,k) - cube(l,m,n)) * DTerm
                                        cube(i,j,k) = cube(i,j,k) - change
                                        cube(l,m,n) = cube(l,m,n) + change
                                    endif
                                endif
                            enddo
                        enddo
                    enddo
                enddo
            enddo
        enddo
        time = time + timestep
        ! checking to see if cube is fully diffused
        maxval = cube(2,2,2)
        minval = cube(2,2,2)
        sumval = 0
        do i = 2,maxsize+1
            do j = 2,maxsize+1
                do k = 2,maxsize+1
                    if (cube(i,j,k) /= 2.0) then
                    maxval = MAX(cube(i,j,k), maxval)
                    minval = MIN(cube(i,j,k), minval)
                    sumval = sumval + cube(i,j,k)
                    endif
                enddo
            enddo
        enddo
        ratio = minval / maxval
        ! output
        print '(f6.2, " ",4e11.3, " ",e10.4,/)', time, cube(2,2,2), cube(maxsize+1,2,2), &
        &cube(maxsize+1,maxsize+1,2), cube(maxsize+1,maxsize+1,maxsize+1), sumval
    enddo
    print '("Box equlibrated in ",f12.8, "seconds of simulated time.")', time
end program diffusion
