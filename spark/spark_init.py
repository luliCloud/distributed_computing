# you may need to install pyspark 
# in bash run: pip install pyspark
# pyspark is dependent on Java. you may need to install jdk
# sudo apt update
# sudo apt install default-jdk

import pyspark
# validate whether pyspark installed succesfully
print(pyspark.__version__) # 3.5.3

# starting run pyspark to execute simple calculation
from pyspark import SparkContext

# initialize SparkContext
sc = SparkContext("local", "Word Count")

# read file and split it into line
text_file = sc.textFile("file/spark1.txt") # here is HDFS file path or local path

# seperate work in each line, count them
word_counts = (
    text_file
    .flatMap(lambda line: line.split(" ")) # split each line in words
    .map(lambda word: (word, 1)) # create kv as (word, 1)
    .reduceByKey(lambda a, b: a + b) # count the same word as 2
)
# lambda arg: operation on arg
# reduceByKey 是 PySpark 的一个转换操作，用于对 相同键 的值进行聚合。
# 它将具有相同键的所有元素合并为一个键值对，并根据指定的函数执行聚合操作。

# print result
for word, count in word_counts.collect():
    print(f"{word}, {count}")
    
# stop SparkCountext
sc.stop()

