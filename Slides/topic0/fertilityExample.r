# Fertlity and contraception rates across countries
# (elementary R example using data from Robey & More)
#
# Chris Adolph, cadolph@uw.edu
# March 27, 2012

# Clear memory
rm(list=ls())

# Load data
data <- read.csv("robeymore.csv",header=T,na.strings="")
completedata <- na.omit(data)
attach(completedata)

# Transform variables
contraceptors <- contraceptors/100

# Run linear regression
res.lm <- lm(tfr~contraceptors)
print(summary(res.lm))

# Get predicted values
pred.lm <- predict(res.lm)

# Make a plot of the data
plot(x=contraceptors,
     y=tfr,
     ylab="Fertility Rate",
     xlab="% of women using contraception",
     main="Average fertility rates & contraception; \n
50 developing countries",
     xaxp=c(0,1,5)
     )

# Add predicted values to the plot
points(x=contraceptors,y=pred.lm,pch=16,col="red")

## Add prediction line to plot
# Crude way that only works for bivariate regression
params <- coefficients(res.lm)
abline(params[1], params[2], col="red")

# For future reference:
# Better way to add prediction line that works for multiple regression and more
#
# We will cover these tools later in the course
#
library(simcf)      # download from faculty.washington.edu/cadolph/software
library(MASS)
sims <- 1000
xhyp <- seq(min(contraceptors), max(contraceptors), 0.01)
nscen <- length(xhyp)
xscen <- cfMake(tfr~contraceptors, completedata, nscen)
for (i in 1:nscen) {
  xscen <- cfChange(xscen, "contraceptors", xhyp[i], scen=i)
}
simbetas <- mvrnorm(sims, coefficients(res.lm), vcov(res.lm))
yhyp <- linearsimev(xscen, simbetas, ci=0.95)

lines(xhyp, yhyp$pe, col="blue")

lines(xhyp, yhyp$lower, col="blue", lty="dashed")

lines(xhyp, yhyp$upper, col="blue", lty="dashed")



