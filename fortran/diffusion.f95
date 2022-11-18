program diffusion
    implicit none

    integer :: i, j, k, l, m, n, pass = 0

    integer, parameter :: maxsize = 5
    real, dimension(maxsize+2, maxsize+2, maxsize+2) :: cube
    real :: diffusion_coefficient = 0.175, room_dimension = 5
    real :: speed_of_gas_molecules = 250.0, timestep, distance_between_blocks, DTerm
    real :: time = 0.0, ratio = 0.0, change, sumval = 0.0, maxval, minval
    logical :: partition = .true.
    integer :: partX, partY
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

    partX = ceiling((maxsize+2)/2.0)
    partY = ceiling((maxsize+2)*0.5)
    !zeroing the cube
    do i = 1,maxsize+2
        do j = 1,maxsize+2
            do k = 1,maxsize+2
    if (i == 0 .or. j == 0 .or. k ==0 .or. k == maxsize+2 .or. j == maxsize+2 .or. i == maxsize+2) then
                    cube(i,j,k)=1.0
                else if (i == partX .and. j >= partY) then
                    cube(i,j,k)=2.0
                else
                    cube(i,j,k) = 0.0
                endif
            enddo
        enddo
    enddo


    cube(2,2,2) = 1.0e21

    do while (ratio < 0.99)
        do i = 2,maxsize+1
            do j = 2,maxsize+1
                do k = 2,maxsize+1
                    do l = 2,maxsize+1
                        do m = 2,maxsize+1
                            do n = 2,maxsize+1
                                if ((( i == l ) .and. ( j == m ) .and. ( k == n+1)) .or. &
                                &(( i == l ) .and. ( j == m ) .and. ( k == n-1)) .or. &
                                &(( i == l ) .and. ( j == m+1 ) .and. ( k == n)) .or. &
                                &(( i == l ) .and. ( j == m-1 ) .and. ( k == n)) .or. &
                                &(( i == l+1 ) .and. ( j == m ) .and. ( k == n)) .or. &
                                &(( i == l-1 ) .and. ( j == m ) .and. ( k == n))) then
                                    if (partition) then
                                if (2.0 /= cube(i,j,k) .and. 2.0 /= cube(l,m,n)) then
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
        print '(f12.8, " ",4e20.6, " ",e21.4,/)', time, cube(2,2,2), cube(maxsize+1,2,2), &
        &cube(maxsize+1,maxsize+1,2), cube(maxsize+1,maxsize+1,maxsize+1), sumval
        

    enddo
    print '("Box equlibrated in ",f12.8, "seconds of simulated time.")', time

end program diffusion
