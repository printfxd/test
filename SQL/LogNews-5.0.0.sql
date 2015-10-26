INSERT INTO golfclub.view_news_log (subscriber_id, news_seq, title, area, date)
SELECT '11111111', '22', (SELECT news.title FROM golfclub.news news WHERE news.seq = 22), '1', now()
  FROM dual
 WHERE exists (SELECT * FROM golfclub.news news WHERE news.seq = 22);


SELECT * FROM golfclub.view_news_log;