import time
from pyspark.sql import SparkSession
t = time.time()

spark = SparkSession.builder.appName('Python Spark example: {}'.format(t)).getOrCreate()

spark.createDataFrame([(1, 'foo'), (2, 'bar')], ['id', 'txt']).write.csv('hdfs://namenode:8020/spark-output_{}'.format(t), mode='overwrite')
