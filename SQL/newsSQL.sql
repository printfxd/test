SELECT * FROM golfclub.news;
SELECT * FROM golfclub.system_conf;

-- 新聞列表

SELECT @NUM:=@NUM+1 AS newsSeq,
       News.seq AS newsID, 
       News.news_date AS newsDate, 
       IF(News.state = 1, concat('[＊]', News.title), News.title) AS title
  FROM golfclub.news News,
       (SELECT @NUM := 0) X,
       (SELECT @userState := '%') STATE
 WHERE News.state like @userState
   AND IF(@userState = '2', datediff(now(), news_date) >= 0,TRUE) 
ORDER BY News.state DESC, News.news_date DESC;

-- 新聞內文(1) -> 取用此版
SELECT News.title AS title,
       News.source AS source,
       News.context AS article,
       IF('hd'='sd', 
           IF(News.sd_img_seq is NULL, -1, News.sd_img_seq), 
           IF(News.hd_img_seq is NULL, -1, News.hd_img_seq)
       ) AS imageSeq
  FROM golfclub.news News
 WHERE News.seq ='52'
   AND News.state like '%';