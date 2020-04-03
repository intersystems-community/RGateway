# RGateway
R Gateway via RServe for InterSystems IRIS Data Platform. Author Shiao-Bin Soong: [email](mailto:Shiao-Bin.Soong@intersystems.com),  [github profile](https://github.com/ssoong88).

# Webinar

[![Foo](https://i.imgur.com/tZQtMD3.png)](https://zoom.us/meeting/register/v5wlf-ygrjkou6V16_zhwxLlO9A1Xy1D9g)

We invite you to the "Best practices of in-platform AI/ML" webinar by InterSystems on April 28th at 11 :00 Boston time.

Productive use of machine learning and artificial intelligence technologies is impossible without a platform that allows autonomous functioning of AI/ML mechanisms. In-platform AI/ML has a number of advantages that can be obtained via best practices by InterSystems.

On our webinar, we will present:
- MLOps as the natural paradigm for in-platform AI/ML - Aleksandar Kovacevic
- Full cycle of AI/ML content development and in-platform deployment (including bidirectional integration of Jupyter with InterSystems IRIS) - Eduard Lebedyuk
- New toolset added to ML Toolkit: integration and orchestration for Julia mathematical modeling environment - Eduard Lebedyuk
- Automated AI/ML model selection and parameter determination via an SQL query – Sergey Lukyanchikov
- Cloud-enhanced ML - Anton Umnikov
- Featured use case demo: hospital readmission prediction (addresses running in InterSystems IRIS of the models trained outside the platform's control) - David Lepzelter

The webinar will be useful for anyone interested in productive AI/ML implementation.

We will be happy to talk to you at our webinar!

[Register!](https://zoom.us/meeting/register/v5wlf-ygrjkou6V16_zhwxLlO9A1Xy1D9g)


# ML Toolkit user group

ML Toolkit user group is a private GitHub repository set up as part of InterSystems corporate GitHub organization. It is addressed to the external users that are installing, learning or are already using ML Toolkit components. To join ML Toolkit user group, please send a short e-mail at the following address: [MLToolkit@intersystems.com](mailto:MLToolkit@intersystems.com?subject=MLToolkit%20user%20group&body=Hello.%0A%0APlease%20add%20me%20to%20ML%20Toolkit%20user%20group%3A%0A%0A-%20GitHub%20username%3A%20%0A%0A-%20Name%3A%20%0A%0A-%20Company%3A%20%0A%0A-%20Position%3A%0A-%20Country%3A%20%0A%0A) and indicate in your e-mail the following details (needed for the group members to get to know and identify you during discussions):

- GitHub username
- Full Name (your first name followed by your last name in Latin script)
- Organization (you are working for, or you study at, or your home office)
- Position (your actual position in your organization, or “Student”, or “Independent”)
- Country (you are based in)

# Installation 

1. Install and start Rserve:
  - Install a recent version of R.
  - Install Rserve package from a R terminal: `install.packages("Rserve",,"http://rforge.net")`
  - Launch Rserve from a R terminal:
  ```
		library(Rserve)
		Rserve()
  ```
		
2. Load and Compile IRIS R package (i.e. `do $system.OBJ.ImportDir("C:\InterSystems\Repos\R\","*.cls","c",,1)`).

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
- Import data from csv file `pima-diabetes.csv` to class `R.Demo.Pima`.
- Run `Do ##class(R.Demo.Pima).LogReg()`. This will use pima dataset to train and save a logistic regression model.
- Run `Do ##class(R.Demo.Pima).ScoreDataset()`. This will score the pima dataset using the previously saved model and save the results to the table. 

5. Check test production for InterOperability examples.
