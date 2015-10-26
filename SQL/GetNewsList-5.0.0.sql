           SELECT news.seq AS newsID,
                  content.service_start_date AS newsDate,
                  IF(content.state = 2, concat('＊', news.title), news.title) AS title
             FROM (SELECT @state := 2) state,
                  golfclub.news news
                  LEFT JOIN golfclub.content content ON news.seq = content.news_seq
            WHERE content.category = '0103'
              AND content.type >= '2'
              AND IF(content.category = 0103, datediff(now(), news_date) BETWEEN 0 AND 30, TRUE)
              AND IF(content.category = 0105, IF(@state = '2', now() BETWEEN content.service_start_date AND content.service_stop_date, now() < content.service_stop_date), TRUE)
              AND content.state >= @state
         ORDER BY content.state DESC, content.service_start_date DESC, content.order;



             SELECT news.title AS title,
                  news.source AS source,
                  news.context AS article,
                  IF('sd'='sd',
                      IFNULL(news.sd_img_seq, -1),
                      IFNULL(news.hd_img_seq, -1)
                  ) AS imageSeq
             FROM golfclub.content content
                  LEFT JOIN golfclub.news news ON content.news_seq = news.seq
            WHERE news.seq ='27'
              AND content.state >= '3';