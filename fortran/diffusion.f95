program diffusion
    implicit none

    integer :: i, j, k, l, m, n, pass = 0

    integer, parameter :: maxsize = 10
    real, dimension(maxsize, maxsize, maxsize) :: cube
    real :: diffusion_coefficient = 0.175, room_dimension = 5
    real :: speed_of_gas_molecules = 250.0, timestep, distance_between_blocks, DTerm
    real :: time = 0.0, ratio = 0.0, change, sumval = 0.0, maxval, minval

    timestep = (room_dimension / speed_of_gas_molecules) / maxsize
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

    !zeroing the cube
    do i = 1,maxsize
        do j = 1,maxsize
            do k = 1,maxsize
                cube(i,j,k) = 0.0
            enddo
        enddo
    enddo

    cube(1,1,1) = 1.0e21

    do while (ratio < 0.99)
        do i = 1,maxsize
            do j = 1,maxsize
                do k = 1,maxsize
                    do l = 1,maxsize
                        do m = 1,maxsize
                            do n = 1,maxsize
                                if ((( i == l ) .and. ( j == m ) .and. ( k == n+1)) .or. &
                                &(( i == l ) .and. ( j == m ) .and. ( k == n-1)) .or. &
                                &(( i == l ) .and. ( j == m+1 ) .and. ( k == n)) .or. &
                                &(( i == l ) .and. ( j == m-1 ) .and. ( k == n)) .or. &
                                &(( i == l+1 ) .and. ( j == m ) .and. ( k == n)) .or. &
                                &(( i == l-1 ) .and. ( j == m ) .and. ( k == n))) then
                                            change = (cube(i,j,k) - cube(l,m,n)) * DTerm
                                            cube(i,j,k) = cube(i,j,k) - change
                                            cube(l,m,n) = cube(l,m,n) + change
                                        endif
                            enddo
                        enddo
                    enddo
                enddo
            enddo
        enddo
        time = time + timestep

        maxval = cube(1,1,1)
        minval = cube(1,1,1)
        do i = 1,maxsize
            do j = 1,maxsize
                do k = 1,maxsize
                    maxval = MAX(cube(i,j,k), maxval)
                    minval = MIN(cube(i,j,k), minval)
                    sumval = sumval + cube(i,j,k)
                enddo
            enddo
        enddo
        ratio = minval / maxval

        !output
        ! print '(f11.8, " ",4e20.6, " ",e20.5,/)', time, cube(1,1,1), cube(maxsize,1,1), &
        ! &cube(maxsize,maxsize,1), cube(maxsize,maxsize,maxsize), sumval
        

    enddo
    print '("Box equlibrated in ",f11.8, "seconds of simulated time.")', time

end program diffusion