# Copyright (c) 2019, Leonardo Werneck

# Set animation parameters
set term gif animate enhanced delay 10 size 900,900 transparent
set output 'bdrycond_general_algorithm.gif'
set font "Helvetica"
unset key

# Set Nx, Ny, Nxgz, Nygz
Nx   = 10
Ny   = 10
Nxgz = 3
Nygz = 3

# Set x and y labels
set xl "Gridpoints along {/Italic x}-direction" font "Helvetica,12"
set yl "Gridpoints along {/Italic y}-direction" font "Helvetica,12"

# Set x and y ranges
set xr [-Nxgz-1:Nx+Nxgz+1]
set yr [-Nxgz-1:Ny+Nxgz+1]
set xtics -Nxgz,1,Nx+Nxgz
set ytics -Nygz,1,Ny+Nygz
set grid

# Set loop limits for interior grid along x-direction
imin = 0
imax = Nx

# Set loop limits for interior grid along y-direction
jmin = 0
jmax = Ny

# Set the interior grid object counter
count = 300

# Plot the interior grid
do for [j=jmin:jmax] {
  do for [i=imin:imax] {
    # Set circles as objects at grid points
    set object count circle at i,j fc rgb "blue" size 0.1 fs solid
    # Increment the object counter
    count = count + 1
  }
}

# Set loop limits for right/up exterior grid (ghostzones) along x-direction
imin = -1
imax = Nx + 1

# Set loop limits for right/up exterior grid (ghostzones) along y-direction
jmin = -1
jmax = Ny + 1

count = 1

do for [gz=0:Nxgz-1] {

  do for [j=jmin+1:jmax-1] {
    do for [i=imin:imin] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "red" size 0.1 fs solid
      # Increment the object counter
      count = count + 1
    }
  }
  imin = imin - 1
  do for [j=jmin+1:jmax-1] {
    do for [i=imax:imax] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "red" size 0.1 fs solid
      # Increment the object counter
      count = count + 1
    }
  }
  imax = imax + 1
  do for [j=jmin:jmin] {
    do for [i=imin+1:imax-1] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "red" size 0.1 fs solid
      # Increment the object counter
      count = count + 1
    }
  }
  jmin = jmin - 1
  do for [j=jmax:jmax] {
    do for [i=imin+1:imax-1] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "red" size 0.1 fs solid
      # Increment the object counter
      count = count + 1
    }
  }
  jmax = jmax + 1

}

plot 1/0

# Set loop limits for right/up exterior grid (ghostzones) along x-direction
imin = -1
imax = Nx + 1

# Set loop limits for right/up exterior grid (ghostzones) along y-direction
jmin = -1
jmax = Ny + 1

count = 1

do for [gz=0:Nxgz-1] {

  do for [j=jmin+1:jmax-1] {
    do for [i=imin:imin] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "#1c8525" size 0.15 fs solid
      # Increment the object counter
      count = count + 1
      plot 1/0
    }
  }
  imin = imin - 1
  do for [j=jmin+1:jmax-1] {
    do for [i=imax:imax] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "#1c8525" size 0.15 fs solid
      # Increment the object counter
      count = count + 1
      plot 1/0
    }
  }
  imax = imax + 1
  do for [j=jmin:jmin] {
    do for [i=imin+1:imax-1] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "#1c8525" size 0.15 fs solid
      # Increment the object counter
      count = count + 1
      plot 1/0
    }
  }
  jmin = jmin - 1
  do for [j=jmax:jmax] {
    do for [i=imin+1:imax-1] {
      # Set right ghostzones
      set object count circle at i,j fc rgb "#1c8525" size 0.15 fs solid
      # Increment the object counter
      count = count + 1
      plot 1/0
    }
  }
  jmax = jmax + 1

}

plot 1/0
plot 1/0
plot 1/0
plot 1/0
plot 1/0
plot 1/0
plot 1/0
plot 1/0
