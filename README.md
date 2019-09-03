# RGateway
R Gateway via RServe for InterSystems IRIS Data Platform. Author Shiao-Bin Soong: [email](mailto:Shiao-Bin.Soong@intersystems.com),  [github profile](https://github.com/ssoong88).

# Webinar - AI Robotization

Machine Learning (ML) Toolkit - a set of extensions to implement machine learning and artificial intelligence on the InterSystems IRIS Data Platform. As part of our webinar, we plan to present an approach to the robotization of these tasks, i.e. to ensure their autonomous adaptive execution proceeds within the parameters and rules you specify. Self-learning neural networks, self-monitoring analytical processes, agency of analytical processes are the main subjects of this webinar.

Webinar is aimed at both experts in Data Science, Data Engineering, Robotic Process Automation - and those who just discover the world of artificial intelligence and machine learning.

We are waiting for you at our event!

The language of the webinar is Russian. 

Date: 18 September, 10:00 – 11:00 (GMT+3).

[Register](https://www.intersystems.com/ru/news-events/events/intersystems-ml-toolkit-webinar/).

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
