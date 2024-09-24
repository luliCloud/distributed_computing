#install dask
# pip install dask[complete]

#check whether install
import dask
print(dask.__version__) # 2024.9.0

import dask.dataframe as dd

# read csv file
df = dd.read_csv("file/dask1.csv")

# calculate avg of salary
mean_salary = df['salary'].mean().compute()

print(f"The mean of salary is: {mean_salary}")