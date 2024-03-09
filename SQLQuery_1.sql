EXEC sp_configure 'external scripts enabled', 1;
GO
RECONFIGURE
GO

EXEC sp_execute_external_script @script=N'import sys;print(sys.version)',@language=N'Python';
GO



EXECUTE sp_execute_external_script @language = N'Python'
    , @script = N'
a = 1
b = 2
c = a/b
d = a*b
print(c, d)
'


EXECUTE sp_execute_external_script @language = N'Python'
    , @script = N'OutputDataSet = InputDataSet'
    , @input_data_1 = N'SELECT 1 AS hello'
WITH RESULT SETS(([Hello World] INT));
GO


CREATE TABLE PythonTestData (col1 INT NOT NULL)

INSERT INTO PythonTestData
VALUES (1);

INSERT INTO PythonTestData
VALUES (10);

INSERT INTO PythonTestData
VALUES (100);
GO


EXECUTE sp_execute_external_script @language = N'Python'
    , @script = N'OutputDataSet = InputDataSet;'
    , @input_data_1 = N'SELECT * FROM PythonTestData;'
WITH RESULT SETS(([NewColName] INT NOT NULL));

EXECUTE sp_execute_external_script @language = N'Python'
    , @script = N'SQL_out = SQL_in;'
    , @input_data_1 = N'SELECT 12 as Col;'
    , @input_data_1_name  = N'SQL_in'
    , @output_data_1_name = N'SQL_out'
WITH RESULT SETS(([NewColName] INT NOT NULL));

EXECUTE sp_execute_external_script @language = N'Python'
    , @script = N'
import pandas as pd
mytextvariable = pandas.Series(["hello", " ", "world"]);
OutputDataSet = pd.DataFrame(mytextvariable);
'
    , @input_data_1 = N''
WITH RESULT SETS(([Col1] CHAR(20) NOT NULL));



CREATE DATABASE irissql
GO
USE irissql
GO

--The following code creates the table for the training data.
DROP TABLE IF EXISTS iris_data;
GO
CREATE TABLE iris_data (
  id INT NOT NULL IDENTITY PRIMARY KEY
  , "Sepal.Length" FLOAT NOT NULL, "Sepal.Width" FLOAT NOT NULL
  , "Petal.Length" FLOAT NOT NULL, "Petal.Width" FLOAT NOT NULL
  , "Species" VARCHAR(100) NOT NULL, "SpeciesId" INT NOT NULL
);

--Run the following code to create the table used for storing the trained model. To save Python (or R) models in SQL Server, they must be serialized and stored in a column of type varbinary(max).
DROP TABLE IF EXISTS iris_models;
GO

CREATE TABLE iris_models (
  model_name VARCHAR(50) NOT NULL DEFAULT('default model') PRIMARY KEY,
  model VARBINARY(MAX) NOT NULL
);
GO

--On systems with Python integration, create the following stored procedure that uses Python code to load the data.
CREATE PROCEDURE get_iris_dataset
AS
BEGIN
EXEC sp_execute_external_script @language = N'Python', 
@script = N'
from sklearn import datasets
iris = datasets.load_iris()
iris_data = pandas.DataFrame(iris.data)
iris_data["Species"] = pandas.Categorical.from_codes(iris.target, iris.target_names)
iris_data["SpeciesId"] = iris.target
', 
@input_data_1 = N'', 
@output_data_1_name = N'iris_data'
WITH RESULT SETS (("Sepal.Length" float not null, "Sepal.Width" float not null, "Petal.Length" float not null, "Petal.Width" float not null, "Species" varchar(100) not null, "SpeciesId" int not null));
END;
GO


--To actually populate the table, run the stored procedure and specify the table where the data should be written.
TRUNCATE TABLE iris_data
INSERT INTO iris_data ("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species", "SpeciesId")
EXEC dbo.get_iris_dataset;

SELECT TOP(10) * FROM iris_data;
SELECT COUNT(*) FROM iris_data;



CREATE PROCEDURE generate_iris_model (@trained_model VARBINARY(max) OUTPUT)
AS
BEGIN
    EXECUTE sp_execute_external_script @language = N'Python'
        , @script = N'
import pickle
from sklearn.naive_bayes import GaussianNB
GNB = GaussianNB()
trained_model = pickle.dumps(GNB.fit(iris_data[["Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"]], iris_data[["SpeciesId"]].values.ravel()))
'
        , @input_data_1 = N'select "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "SpeciesId" from iris_data'
        , @input_data_1_name = N'iris_data'
        , @params = N'@trained_model varbinary(max) OUTPUT'
        , @trained_model = @trained_model OUTPUT;
END;
GO

DECLARE @model varbinary(max);
DECLARE @new_model_name varchar(50)
SET @new_model_name = 'Naive Bayes'
EXECUTE generate_iris_model @model OUTPUT;
DELETE iris_models WHERE model_name = @new_model_name;
INSERT INTO iris_models (model_name, model) values(@new_model_name, @model);
GO


SELECT * FROM dbo.iris_models


CREATE PROCEDURE predict_species (@model VARCHAR(100))
AS
BEGIN
    DECLARE @nb_model VARBINARY(max) = (
            SELECT model
            FROM iris_models
            WHERE model_name = @model
            );

    EXECUTE sp_execute_external_script @language = N'Python'
        , @script = N'
import pickle
irismodel = pickle.loads(nb_model)
species_pred = irismodel.predict(iris_data[["Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"]])
iris_data["PredictedSpecies"] = species_pred
OutputDataSet = iris_data[["id","SpeciesId","PredictedSpecies"]] 
print(OutputDataSet)
'
        , @input_data_1 = N'select id, "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "SpeciesId" from iris_data'
        , @input_data_1_name = N'iris_data'
        , @params = N'@nb_model varbinary(max)'
        , @nb_model = @nb_model
    WITH RESULT SETS((
                "id" INT
              , "SpeciesId" INT
              , "SpeciesId.Predicted" INT
                ));
END;
GO



EXECUTE predict_species 'Naive Bayes';
GO