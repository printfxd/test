
		    SELECT serialNo, eventSeq, title, videoSeq, videoImgSeq, videoUrl
             FROM (
                 SELECT CAST(@row_num := IF(@prev_value = event.category,@row_num + 1, 1) AS UNSIGNED) AS serialNo,
                        event.seq AS eventSeq,
                        IF(event.state = '2', concat('＊', event.name), event.name) AS title,
                        IF(event.type = 1, video.seq, '') AS videoSeq,
                        IF(event.type = 1, IF(@resolution = 'sd', video.sd_img_seq, video.hd_img_seq), '') AS videoImgSeq,
                        IF(event.type = 1, 
                            CASE '1chtn' 
                                 WHEN '1chtn' then (CONCAT(system.play_uri_1N, video.play_asset_1N))
                                 WHEN '1chtc' then (CONCAT(system.play_uri_1C, video.play_asset_1C))
                                 WHEN '1chts' then (CONCAT(system.play_uri_1S, video.play_asset_1S))
                                 WHEN '2chtn' then (CONCAT(system.play_uri_2N, video.play_asset_2N))
                                 WHEN '2chts' then (CONCAT(system.play_uri_2S, video.play_asset_2S))
                             END
                        , '') AS videoUrl,
                        @prev_value := event.category category
                   FROM golfclub.general_evt event
			  LEFT JOIN golfclub.video video ON event.video_seq = video.seq,
                        (SELECT * FROM golfclub.system_conf) system,
                        (SELECT @row_num := 1) x,
                        (SELECT @prev_value := '') y,
                        (SELECT @resolution := 'sd') r, --
                        (SELECT @state := '3') userState -- 
                  WHERE event.category in (0001)
                    AND event.state >= @state
                    AND IF(@state = 2, now() < event.service_stop_date, now() between event.service_start_date and event.service_stop_date)
               ORDER BY event.category, event.state DESC, event.service_start_date desc
             ) subquery;




                 SELECT GROUP_CONCAT(evtImg2.rows ORDER BY evtImg2.column SEPARATOR '#' ) pages
                 FROM
                 (
                     SELECT evtImg1.column,
                            GROUP_CONCAT(IF('sd' = 'sd', evtImg1.sd_img_seq, evtImg1.hd_img_seq) ORDER BY evtImg1.row SEPARATOR ',' ) rows,
                            evtImg1.general_evt_seq eventNum
                       FROM golfclub.general_evt_img evtImg1
                      WHERE evtImg1.general_evt_seq = 11
                   GROUP BY evtImg1.column
                   ORDER BY evtImg1.column
                 ) evtImg2
             GROUP BY evtImg2.eventNum;