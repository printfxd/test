SELECT * FROM golfclub.view_video_log;

INSERT INTO golfclub.view_video_log (subscriber_id, video_seq, video_name, area, play_url, date, play_success) 
     VALUES ('72162076', '83', '人物專訪-路易斯05', '1', '0000028702_f', '2012-10-01 11:33:10', TRUE);
SELECT * FROM golfclub.view_video_log;

SELECT seq AS videoSeq 
  FROM golfclub.view_video_log 
 WHERE phone_number='0928800457' 
   AND date = '2012-11-19 15:33:10';

UPDATE golfclub.view_video_log 
   SET date = now(), 
       play_success = false
 WHERE seq='6';

SELECT * FROM golfclub.view_video_log;

-- 我是 portable
INSERT INTO golfclub.view_video_log (phone_number, video_seq, video_name, area, play_url, date, play_success, is_nScreen_user) 
     VALUES ('0928800457', '99', '人物專訪-路易斯05', '0', '0000028702_f', '2012-11-19 15:33:10', TRUE, TRUE);
SELECT * FROM golfclub.view_video_log order by date desc;


SELECT seq AS videoSeq 
  FROM golfclub.view_video_log 
 WHERE phone_number='0928800457' 
   AND date = '2012-11-19 15:33:10';

UPDATE golfclub.view_video_log 
   SET date = now(), 
       play_success = false
 WHERE seq='6';