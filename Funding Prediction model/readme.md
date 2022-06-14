<b>Description:</b>
In this project, me and my colleagues collected data from various truck development projects and utilized python machine learning models to create a funding prediction tool. The background of this project was that there was always a variance between budgeting funding of project and actual use of funding. If we are able to create a accurate funding predictor model,resources could be more efficiently utilized by preventing underallocation/overallocation of funding to projects.


<b>What I learnt:</b>

I learnt the process of data science: Data collection, data cleaning, data analysis, model building, results evaluation.


<b>Details of the project:</b>

The steps of the project is as follows:

1. Data collection and preliminary analysis:

Over 61 possible target variables of each project were collected and stored in in a csv file.
E.g. Starting year of the project,volume of products sold,product category,number of new parts etc..
```
(['SoP Year', 'Months between QG9-QG2', 'NY volume TARGET',
       'Average variable cost per unit T-JPY (Target)',
       'Average CM per unit T-JPY (Target)', 'CM per Year', 'R&D Total LC EA',
       'CapEx EA', 'NRE EA', 'Total funding LC EA', 'Legislation project',
       'Vehicle project', 'Component project', 'Vehicle & Comp. project',
       'LDT', 'MDT', 'HDT', 'LB', 'HB', 'IE', 'TA Classic?', 'Ext. Facelift',
       'Int. Facelift & Telematics', 'New E/E structure',
       'New Safety features/Safety regulation', 'New emission Standard',
       'Optional: other expected, significant funding drivers',
       'Ratio Legislation Funding', 'Scope of New & changed parts',
       'Technological Ambition', 'Variant Complexity', 'Number of Markets',
       'Organisational Complexity', 'Experience of PL'],
      dtype='object')
```

Then, data analysis was carried out to find out the top predictors of the target variable.
![screenshot](https://github.com/joshnsw/Data-Science-Analysis-projects/blob/main/Funding%20Prediction%20model/seaborn%20correlation.png)

2.  Uploading data into Machine learning models

We utilised various machine learning models to predict the target variable(funding). Out of the possible 61 predictor variables,we selected the ones with the most correlation, and filtered data based on certain criteria than may have affected or skewed prediction results.

```
#seperate features x and target y
dataset=dataset[dataset['R&D Total LC EA'].notna()]
dataset=dataset[dataset['Total funding LC EA'] > 3]
dataset=dataset[dataset['Total funding LC EA'] < 150]
y=dataset.iloc[:,9]


#Scale all features of dataset to 0 to 1 range to avoid distortions during PCA and clustering. 
#Convert np array back to a panda DataFrame and add back column header cut off by sklearn preprocessing
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
xs = scaler.fit_transform(x)
x= pd.DataFrame(xs, columns=x.columns)
x=x.fillna(0)

#divide dataset into training set and test set
from sklearn.model_selection import train_test_split

x_train, x_test, y_train, y_test = train_test_split(x,y, test_size=0.2, random_state=0)

#load linear model from Scikit learn
from sklearn.linear_model import LinearRegression
regressor = LinearRegression()
regressor.fit(x_train, y_train)


#predict: y_pred = RD Total funding
y_pred = regressor.predict(x_test)
#prozentuale Abweichung delta (Predicted-Actual)/Actual
delta = (y_pred-y_test)/y_test
df=pd.DataFrame( {'Actual': y_test, 'Predicted': y_pred, 'delta' : delta })
#Merge Dataframe df mit Project_Name aus Basis dataset
df=pd.concat([name, df] , axis=1).reindex(df.index)
df=df.style.format({'Actual': '{:,.1f}', 'Predicted':'{:,.1f}', 'delta' : '{:,.0%}' })
df






3.

