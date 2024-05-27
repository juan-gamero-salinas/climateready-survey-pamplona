
# **K-means**

## **Loading & Inspecting data**

### Set working directory
setwd("...")



### Set the seed for reproducibility
set.seed(1)  # Replace 123 with your desired seed value 

### Read the csv
df <- read.csv("R_logistic_kmeans.csv", sep=";")
head(df, 3)


## **Pre-processing data**

### Function to convert TRUE/FALSE to 1/0
library(dplyr)

convert_to_binary <- function(x) {
  as.numeric(x)
}

###Apply the function to all columns except the first one (assuming it's the index)
data_transformed <- df %>%
  mutate_all(~ ifelse(. == "True", 1, ifelse(. == "False", 0, .)))


### Print the transformed data
head(data_transformed, 3)
names(data_transformed)
length(data_transformed)
nrow(data_transformed)

n = nrow(data_transformed)
n




### Define the response variables
# Specify the variable to be used as Y response
Y_response <- "cluster_kmeans"

# Extract the Y response
Y <- data_transformed[, Y_response]

# Extract the X response (all other variables)
X <- data_transformed[, setdiff(names(data_transformed), Y_response)]


### Identify variables to exclude from conversion to integer
exclude_variables <- c("Age", "meanTout")


### Convert all other variables to integer
X[, setdiff(names(X), exclude_variables)] <- lapply(X[, setdiff(names(X), exclude_variables)], as.integer)


### Verify the changes
str(X)

X_matrix <- as.matrix(X)
sum(Y)

head(cor(X_matrix),3)


### Columns to be removed (For preventing linear dependencies in the input matrix. We modify x so and remove similar columns.)
columns_to_remove <- c("is_31009", "dwelling_Other")



### Index of columns to keep
columns_to_keep <- !(colnames(X_matrix) %in% columns_to_remove)


### Remove columns
X_matrix <- X_matrix[, columns_to_keep]


### Scale predictors
X_matrix <- scale(X_matrix)


## **Analizing data**


### Penalized logistic regression
library(glmnet) # Install and load glmnet package


# Example using cross-validation to find the best lambda with cv = 5
cv_model <- cv.glmnet(X_matrix, Y, alpha = 1, family = "binomial", nfolds = 10, type.measure = "class")
plot(cv_model)

# Find the alpha and lambda with the minimum mean cross-validated error
best_lambda <- cv_model$lambda.min
best_lambda

best_model <- glmnet(X_matrix, Y, alpha = 1, lambda = best_lambda, family = "binomial")
coef(best_model, s = best_lambda)



### Selective inference
library(selectiveInference)



# extract coef for a given lambda; note the 1/n factor!
# (and here  we DO  include the intercept term)
beta = coef(best_model, x=X_matrix, y=Y, s = best_lambda/n)


# compute fixed lambda p-values and selection intervals
model = fixedLassoInf(X_matrix,Y,beta,best_lambda,family="binomial")
model




# **Hierarchical Clustering**

## **Loading & Inspecting data**

### Set working directory
setwd("...")

### Set the seed for reproducibility
set.seed(1)  # Replace 123 with your desired seed value 


### Read the csv
df <- read.csv("R_logistic_hclust.csv", sep=";")
head(df, 3)



## **Pre-processing data**

### Function to convert TRUE/FALSE to 1/0
library(dplyr)

convert_to_binary <- function(x) {
  as.numeric(x)
}


###Apply the function to all columns except the first one (assuming it's the index)
data_transformed <- df %>%
  mutate_all(~ ifelse(. == "True", 1, ifelse(. == "False", 0, .)))


### Print the transformed data
head(data_transformed,3)
names(data_transformed)
length(data_transformed)
nrow(data_transformed)

n = nrow(data_transformed)
n




### Define the response variables
# Specify the variable to be used as Y response
Y_response <- "cluster_hierarchical"

# Extract the Y response
Y <- data_transformed[, Y_response]

# Extract the X response (all other variables)
X <- data_transformed[, setdiff(names(data_transformed), Y_response)]


### Identify variables to exclude from conversion to integer
exclude_variables <- c("Age", "meanTout")


### Convert all other variables to integer
X[, setdiff(names(X), exclude_variables)] <- lapply(X[, setdiff(names(X), exclude_variables)], as.integer)


### Verify the changes
str(X)

X_matrix <- as.matrix(X)
sum(Y) 

head(cor(X_matrix),3)


### Columns to be removed (For preventing linear dependencies in the input matrix. We modify x so and remove similar columns)
columns_to_remove <- c("is_31009", "dwelling_Other")


### Index of columns to keep
columns_to_keep <- !(colnames(X_matrix) %in% columns_to_remove)


### Remove columns
X_matrix <- X_matrix[, columns_to_keep]


### Scale predictors
X_matrix <- scale(X_matrix)


## **Analizing data**


### Penalized logistic regression
library(glmnet) # Install and load glmnet package


# Example using cross-validation to find the best lambda with cv = 5
cv_model <- cv.glmnet(X_matrix, Y, alpha = 1, family = "binomial", nfolds = 10, type.measure = "class")
plot(cv_model)

# Find the alpha and lambda with the minimum mean cross-validated error
best_lambda <- cv_model$lambda.min
best_lambda

best_model <- glmnet(X_matrix, Y, alpha = 1, lambda = best_lambda, family = "binomial")
coef(best_model, s = best_lambda)



### Selective inference
library(selectiveInference)



# extract coef for a given lambda; note the 1/n factor!
# (and here  we DO  include the intercept term)
beta = coef(best_model, x=X_matrix, y=Y, s = best_lambda/n)


# compute fixed lambda p-values and selection intervals
model = fixedLassoInf(X_matrix,Y,beta,best_lambda,family="binomial")
model











