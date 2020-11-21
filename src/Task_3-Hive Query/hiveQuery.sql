SET hive.cli.print.header=true;

-- Database and table creation
CREATE DATABASE postsDB;

CREATE TABLE postsDB.posts 
(Body string, Score int, Id int, ViewCount int, OwnerUserId int, OwnerDisplayName string, Title string, Tags string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- Loading transformed data into Hive
LOAD DATA INPATH 'hdfs://cluster-9f4d-m/part-m-00000' INTO TABLE postsDB.posts;
LOAD DATA INPATH 'hdfs://cluster-9f4d-m/part-m-00001' INTO TABLE postsDB.posts;
LOAD DATA INPATH 'hdfs://cluster-9f4d-m/part-m-00002' INTO TABLE postsDB.posts;
LOAD DATA INPATH 'hdfs://cluster-9f4d-m/part-m-00003' INTO TABLE postsDB.posts;

-- Task 3: Hive Queries

-- The top 10 posts by score
SELECT Id, Title, Score 
FROM postsDB.posts
ORDER BY Score DESC LIMIT 10;

--The top 10 users by post score
SELECT OwnerUserId, SUM(Score) AS Total_Score
FROM postsDB.posts
GROUP BY OwnerUserId
ORDER BY Total_Score DESC LIMIT 10;

--The number of distinct users, who used the word “Hadoop” in one of their posts
SELECT COUNT(DISTINCT OwnerUserId) AS User_Count
FROM postsDB.posts
WHERE (LOWER(Body) LIKE '%hadoop%' OR LOWER(Title) LIKE '%hadoop%' OR LOWER(Tags) LIKE '%hadoop%');