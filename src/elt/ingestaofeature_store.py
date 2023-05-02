import datetime

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Olist") \
    .config("spark.sql.catalogImplementation", "hive") \
    .getOrCreate()


def import_query(path):
    with open(path, 'r') as file:
        return file.read()


def table_exists(database, table):
    count = (spark.sql(f"SHOW TABLES FROM {database}")
             .filter(f"tableName = '{table}'")
             .count())

    return count > 0


def date_range(dt_start, dt_stop, period='daily'):

    datetime_start = datetime.datetime.strptime(dt_start, '%Y-%m-%d')
    datetime_stop = datetime.datetime.strptime(dt_stop, '%Y-%m-%d')

    dates = []

    while datetime_start <= datetime_stop:
        dates.append(datetime_start.strftime("%Y-%m-%d"))
        datetime_start += datetime.timedelta(days=1)

    if period == 'daily':
        return dates
    elif period == 'monthly':
        return [i for i in dates if i.endswith("01")]


# table = "vendas"
# table_name = f"fs_vendedor_{table}"
# database = "olist.db"

# date_start = '2017-01-01'
# date_stop = '2018-01-01'

# print(table_name, table_exists(database, table_name))
# print(date_start, ' ~ ', date_stop)
