SELECT * FROM golfclub.event;

-- result:[totalCount, data:[{title, videoImgSeq, dmImageSeq, videoUrl, videoTitle, videoSeq}, ad:[{adSeq, interval}]]

-- 廢棄：各類活動總表
-- SELECT eventSeq, title, dmImageSeq, videoImgSeq, videoUrl
-- FROM (
-- 	SELECT CAST(@row_num := IF(@prev_value=Event.category,@row_num+1,1) AS UNSIGNED) AS eventSeq,
--           IF(state = '2', concat('[＊]', Event.name), Event.name) AS title, 
--           IF(Event.type = 1, IF(@resolution = 'sd', Event.dm_sd_img_seq, Event.dm_hd_img_seq), '') AS dmImageSeq,
--           IF(Event.type = 2, IF(@resolution = 'sd', Event.video_sd_img_seq, Event.video_hd_img_seq), '') AS videoImgSeq, 
-- 		   IF(Event.type = 2, concat(SYS.play_uri_1N, Event.play_asset_1N), '') AS videoUrl, 
-- 			@prev_value := Event.category category
-- 	  FROM golfclub.event Event,
--           (SELECT * FROM golfclub.system_conf) SYS,
-- 		   (SELECT @row_num := 1) x,
-- 		   (SELECT @prev_value := '') y,
--           (SELECT @resolution := 'sd') r,
-- 		   (SELECT @state := '2') userState
-- 	 WHERE category in (0601,0602)
-- 	   AND state between @state and 3
-- 	   AND IF(@state = 2, TRUE, now() between service_start_date and service_stop_date)
--   ORDER BY Event.category, Event.state DESC, Event.service_start_date desc
-- 	 ) subquery;


-- 求各類活動數量等資料
SELECT count(*) totalCount, category
  FROM golfclub.event,
       (SELECT @state := '2') userState 
 WHERE category in (0601,0602)
   AND state between @state and 3
   AND IF(@state = 2, TRUE, now() between service_start_date and service_stop_date)
 Group by category
ORDER BY category;

-- step 1. Group [X][Y] digest image 

SELECT GROUP_CONCAT(Digest2.rows ORDER BY Digest2.column SEPARATOR '#' ) pages
FROM
(
    SELECT Digest1.column,
           GROUP_CONCAT(IF('sd' = 'sd',Digest1.sd_img_seq, Digest1.hd_img_seq) ORDER BY Digest1.row SEPARATOR ',' ) rows,
           Digest1.event_seq eventNum
      FROM golfclub.digest_img Digest1
     WHERE Digest1.event_seq = '34'
  GROUP BY Digest1.column
  ORDER BY Digest1.column
) Digest2
GROUP BY Digest2.eventNum;



--                  SELECT *
--                    FROM golfclub.event Event1
--                         LEFT JOIN golfclub.digest_img Digest1 ON Digest1.event_seq = Event1.seq
--                   WHERE Event1.category IN (0602)
--                     AND Event1.type = '1'
-- 					  AND Event1.state between 3 and 3 -- @state
--                     AND IF(3 = 2, now() < Event1.service_stop_date, now() between Event1.service_start_date and Event1.service_stop_date) -- @state
--                GROUP BY Digest1.column


                 SELECT Event1.seq AS eventID,
                        IF(Event1.state = '2', concat('[＊]', Event1.name), Event1.name) AS title, 
                        
                        Digest1.column AS 'column',
                        GROUP_CONCAT(IF(@resolution = 'sd',Digest1.sd_img_seq, Digest1.hd_img_seq) ORDER BY Digest1.row SEPARATOR ',' ) AS dmImageSeq,
                        '' AS videoImgSeq,
                        '' AS videoUrl,
                        Event1.category category
                   FROM golfclub.event Event1
                        LEFT JOIN golfclub.digest_img Digest1 ON Digest1.event_seq = Event1.seq
                  WHERE Event1.category IN (0602)
                    AND Event1.type = '1'
					  AND Event1.state between 3 and 3 -- @state
                    AND IF(3 = 2, now() < Event1.service_stop_date, now() between Event1.service_start_date and Event1.service_stop_date) -- @state
               GROUP BY Digest1.column, ;












-- step 2. 

                 SELECT Event1.seq AS eventID,
                        IF(Event1.state = '2', concat('[＊]', Event1.name), Event1.name) AS title, 
                        
                        Digest1.column AS 'column',
                        GROUP_CONCAT(IF(@resolution = 'sd',Digest1.sd_img_seq, Digest1.hd_img_seq) ORDER BY Digest1.row SEPARATOR ',' ) AS dmImageSeq,
                        '' AS videoImgSeq,
                        '' AS videoUrl,
                        Event1.category category
                   FROM golfclub.event Event1
                        LEFT JOIN golfclub.digest_img Digest1 ON Digest1.event_seq = Event1.seq
                  WHERE Event1.category IN (0602)
                    AND Event1.type = '1'
					  AND Event1.state between 3 and 3 -- @state
                    AND IF(3 = 2, now() < Event1.service_stop_date, now() between Event1.service_start_date and Event1.service_stop_date) -- @state
               GROUP BY Digest1.column

				UNION ALL
              (
                 SELECT Event2.seq AS eventID,
                        IF(Event2.state = '2', concat('[＊]', Event2.name), Event2.name) AS title, 
                        '' AS dmImageSeq,
                        IF(Event2.type = 2, IF(@resolution = 'sd', Event2.video_sd_img_seq, Event2.video_hd_img_seq), '') AS videoImgSeq,
                        IF(Event2.type = 2, concat(SYS.play_uri_1N, Event2.play_asset_1N), '') AS videoUrl,
                        Event2.category category
                   FROM golfclub.event Event2,
                        (SELECT * FROM golfclub.system_conf) SYS,
                        (SELECT @resolution := 'sd') r,
                        (SELECT @state := '3') userState
                  WHERE Event2.category IN (0602)
                    AND Event2.type = '2'
					  AND Event2.state between @state and 3
                    AND IF(@state = 2, now() < Event2.service_stop_date, now() between Event2.service_start_date and Event2.service_stop_date)
              );







				


















           SELECT eventSeq, eventID, title, dmImageSeq, videoImgSeq, videoUrl
             FROM (
                 SELECT CAST(@row_num := IF(@prev_value=Event.category,@row_num+1,1) AS UNSIGNED) AS eventSeq,
                        Event.seq AS eventID,
                        IF(state = '2', concat('[＊]', Event.name), Event.name) AS title,
                        IF(Event.type = 1, (
                              SELECT GROUP_CONCAT(Digest2.rows ORDER BY Digest2.column SEPARATOR '#' )
                                FROM (
                                         SELECT Digest1.column,
                                                GROUP_CONCAT(IF('sd' = 'sd',Digest1.sd_img_seq, Digest1.hd_img_seq) ORDER BY Digest1.row SEPARATOR ',' ) rows,
                                                Event.seq AS eventNum
                                           FROM golfclub.digest_img Digest1
                                          WHERE Digest1.event_seq = Event.seq
                                       GROUP BY Digest1.column
                                     ) Digest2
                            GROUP BY Digest2.eventNum
						   ), '') AS dmImageSeq,
                        IF(Event.type = 2, IF(@resolution = 'sd', Event.video_sd_img_seq, Event.video_hd_img_seq), '') AS videoImgSeq,
                        IF(Event.type = 2, concat(SYS.play_uri_1N, Event.play_asset_1N), '') AS videoUrl,
                        @prev_value := Event.category category
                   FROM golfclub.event Event,
                        (SELECT * FROM golfclub.system_conf) SYS,
                        (SELECT @row_num := 1) x,
                        (SELECT @prev_value := '') y,
                        (SELECT @resolution := 'sd') r,
                        (SELECT @state := '3') userState
                  WHERE category in (0602)
                    AND state between @state and 3
                    AND IF(@state = 2, now() < service_stop_date, now() between service_start_date and service_stop_date)
               ORDER BY Event.category, Event.state DESC, Event.service_start_date desc
             ) subquery;