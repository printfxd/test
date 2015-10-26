		    SELECT serialNo, eventSeq, title, videoImgSeq, videoUrl
             FROM (
                 SELECT CAST(@row_num := IF(@prev_value = event.category,@row_num + 1, 1) AS UNSIGNED) AS serialNo,
                        event.seq AS eventSeq,
                        IF(event.state = '2', concat('＊', event.name), event.name) AS title,
                        IF(event.type = 2, IF(@resolution = 'sd', event.video_sd_img_seq, event.video_hd_img_seq), '') AS videoImgSeq,
                        IF(event.type = 2, 
                            CASE '1chtn' 
                                 WHEN '1chtn' then (CONCAT(system.play_uri_1N, event.play_asset_1N))
                                 WHEN '1chtc' then (CONCAT(system.play_uri_1C, event.play_asset_1C))
                                 WHEN '1chts' then (CONCAT(system.play_uri_1S, event.play_asset_1S))
                                 WHEN '2chtn' then (CONCAT(system.play_uri_2N, event.play_asset_2N))
                                 WHEN '2chts' then (CONCAT(system.play_uri_2S, event.play_asset_2S))
                             END
                        , '') AS videoUrl,
                        @prev_value := event.category category
                   FROM golfclub.event event,
                        (SELECT * FROM golfclub.system_conf) system,
                        (SELECT @row_num := 1) x,
                        (SELECT @prev_value := '') y,
                        (SELECT @resolution := 'sd') r, --
                        (SELECT @state := '3') userState -- 
                  WHERE event.category in (0601,0602,0603)
                    AND event.state >= @state
                    AND IF(@state = 2, now() < event.service_stop_date, now() between event.service_start_date and event.service_stop_date)
               ORDER BY event.category, event.state DESC, event.service_start_date desc
             ) subquery;