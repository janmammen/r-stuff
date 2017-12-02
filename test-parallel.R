library(MASS)
data <- MASS::Boston


library(parallel)

# Make cluster
cl<-parallel::makeCluster(2)


# Export library to cluster
parallel::clusterEvalQ(library(data.table))

# Function
sum_test <-function(data, x, y){
  data.frame(mean = mean(data[,x])*y
             , sum = sum(data[,x]))
  
}

# Define items to vary for parallel
items <- c("crim", "age")


# Export function, items and data to cluster
parallel::clusterExport(cl, list("sum_test", "data","items"), envir = .GlobalEnv)

# Run function in parallel
result <- parallel::clusterApply(cl, items, function(z){ sum_test(data, x=z, y=3)})

result[[1]]
result[[2]]


parallel::parLapply(cl, items, function(x){sum_test(data, x=items, y=3)})