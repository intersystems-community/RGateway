# RGateway
R Gateway via RServe for InterSystems IRIS Data Platform.

1. Install and start Rserve:
  - Install a recent version of R.
  - Install Rserve package from a R terminal: `install.packages("Rserve",,"http://rforge.net")`
  - Launch Rserve from a R terminal:
  ```
		library(Rserve)
		Rserve()
  ```
		
2. Load and Compile IRIS R package

3. The following ObjectScript code illustrates the simple integration with Rserve:

```
	R.RConnection c = ##class(R.RConnection).%New() // Create a R client
	Set x = ##class(R.REXPDouble).%New(3.0) // A single double value
	Do c.assign("x", x) // Assign the value to R variable x
	Do c.eval("y<-sqrt(x)") // Evaluate R script
	Set y = c.get("y") // Get the value of R variable y
```

It is advised to wrap all ObjectScript code in a try catch block. More test cases and usages can be found in class `R.Test`.
	
4. A demo case is in `R.Demo` package.
- Import data from csv file `pima-indians-diabetes.csv` to class `R.Demo.Pima`.
- Run `Do ##class(R.Demo.Pima).LogReg()`. This will use pima dataset to train and save a logistic regression model.
- Run `Do ##class(R.Demo.Pima).ScoreDataset()`. This will score the pima dataset using the previously saved model and save the results to the table. 
