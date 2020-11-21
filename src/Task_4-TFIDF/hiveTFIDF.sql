add jar /home/rohit_nair2/hivemall-all-0.6.0-incubating.jar;
source /home/rohit_nair2/define-all.hive;

SET hive.cli.print.header=true;

SET hivevar:n_docs=10;

CREATE TEMPORARY MACRO max2(x INT, y INT)
if(x>y,x,y);

CREATE TEMPORARY MACRO tfidf(tf FLOAT, df_t INT, n_docs INT)
tf * (log(10, CAST(n_docs as FLOAT)/max2(1,df_t)) + 1.0);

CREATE TABLE postsDB.tfIdfTable_temp AS SELECT OwnerUserId, Body, Score FROM postsDB.posts ORDER BY Score DESC LIMIT 10;

CREATE TABLE postsDB.tfIdfTable AS SELECT OwnerUserId, Body FROM postsDB.tfIdfTable_temp;

CREATE OR REPLACE VIEW postsDB.explodedView AS SELECT OwnerUserId, word FROM postsDB.tfIdfTable LATERAL VIEW explode(split(Body, ' ')) t AS word WHERE NOT is_stopword(word);

CREATE OR REPLACE VIEW postsDB.termFreq AS SELECT OwnerUserId, word, freq FROM (SELECT OwnerUserId, tf(word) AS word2freq FROM postsDB.explodedView GROUP BY OwnerUserId) t LATERAL VIEW explode(word2freq) t2 AS word, freq;

CREATE OR REPLACE VIEW postsDB.docFreq AS SELECT word, COUNT(DISTINCT OwnerUserId) docs FROM postsDB.explodedView GROUP BY word;

CREATE OR REPLACE VIEW postsDB.tfIdfView AS SELECT tf.OwnerUserId, tf.word, tfidf(tf.freq, df.docs, ${n_docs}) AS tfidf FROM postsDB.termFreq tf JOIN postsDB.docFreq df ON (tf.word = df.word) ORDER BY tfidf DESC;