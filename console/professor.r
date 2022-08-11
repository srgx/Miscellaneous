#!/usr/bin/Rscript

# Professor & Rain

# Program inspired by example from book "Teach Yourself Scheme in Fixnum Days"

# Professor walks between work and home
# Initially, he has 1 umbrella in each location
# When it rains he takes his umbrella to other location
# After how many walks will he find himself in location without umbrella when it rains?

# -----------------------------------
rain_probability <- 0.4
max_walks <- 500
loud <- FALSE

# Location is vector with number of umbrellas and professor position
home <- c(1,1)
work <- c(1,0)
# -----------------------------------

random <- function() {
  return(runif(1))
}

atHome <- function() {
  return(1 == home[2])
}

goHome <- function(umb=FALSE) {
  if(loud) { print("Go home") }
  mu(umb,1,-1) ; pos(1,0)
}

goToWork <- function(umb=FALSE) {
  if(loud) { print("Go to work") }
  mu(umb,-1,1) ; pos(0,1)
}

# Set professor position
pos <- function (h,w) {
  home[2] <<- h ; work[2] <<- w
}

# Move umbrella
mu <- function(u,h,w) {
  if (u) {
    home[1] <<- home[1] + h
    work[1] <<- work[1] + w
  }
}

goHomeWithUmbrella <- function() {
  goHome(TRUE)
}

goToWorkWithUmbrella <- function() {
  goToWork(TRUE)
}

goWithoutUmbrella <- function() {
  if (atHome()) goToWork() else goHome()
}

goWithUmbrella <- function() {

  if (atHome()) {

    if (umbrellaAt(home)) {
      goToWorkWithUmbrella()
      return(TRUE)
    }

  } else {

    if (umbrellaAt(work)) {
      goHomeWithUmbrella()
      return(TRUE)
    }

  }

  return(FALSE)

}

umbrellaAt <- function(location) {
  return(1 <= location[1])
}

raining <- function() {
  return(random() < rain_probability)
}

go <- function() {

  for (walks in 0:max_walks) {

    if (raining()) {

      if(loud) { print("Raining") }
      if(!goWithUmbrella()){ return(walks) }

    } else {

      if(loud) { print("Not raining") }
      goWithoutUmbrella()

    }

    if(loud) { print(home) ; print(work) }

  }

  return(walks)

}

resetLocations <- function() {
  home <<- c(1,1) ; work <<- c(1,0)
}


display <- function (t,n) {
  print(sprintf("%s%0.3f", t, n))
}

# -----------------------------------

main <- function() {

  trials <- 2000
  results <- vector(mode = "integer",length = trials)

  for (i in 1:trials) {
    resetLocations()
    results[i] <- go()
  }

  display("Mean: ", mean(results))
  display("Median: ", median (results))
  display("Standard deviation: ", sd(results))

  hist(results)
  boxplot(results)

}

# -----------------------------------

main()

# -----------------------------------

