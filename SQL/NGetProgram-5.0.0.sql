-- SQL_SELECT_N_CONTENT_BY_CATEGORY
           SELECT serialNo, videoSeq, title, stopDate, imageSeq, videoUrl, updateDate
             FROM (
                 SELECT CAST(@row_num := IF(@prev_value = content.category, @row_num + 1, 1) AS UNSIGNED) AS serialNo,
                        video.seq AS videoSeq,
                        IF(content.state = '2', concat('＊', video.name), video.name) AS title,
                        video.service_stop_date AS stopDate,
                        IF('hd' = 'sd', video.sd_img_seq, video.hd_img_seq) AS imageSeq,
                        CASE 'N'
                            WHEN 'N' then (CONCAT(system.nScreen_server_N, video.play_asset_nScreen_N))
                            WHEN 'S' then (CONCAT(system.nScreen_server_S, video.play_asset_nScreen_S))
                        END AS videoUrl,
                        content.update_date AS updateDate,
                        @prev_value := content.category category
                   FROM (SELECT * FROM golfclub.system_conf) system,
                        (SELECT @row_num := 1) x,
                        (SELECT @prev_value := '') y,
                        (SELECT @state := '3') userState, --
                        golfclub.content content
                        LEFT JOIN golfclub.video video ON content.video_seq = video.seq
                  WHERE content.category in (0204,0205)
                    AND content.type = 1
                    AND video.is_nScreen = TRUE
                    AND content.state >= @state
                    AND IF(@state = 3, now() between content.service_start_date and content.service_stop_date, now() < content.service_stop_date)
               ORDER BY content.category, content.state DESC, content.service_start_date DESC, content.order
             ) subquery;

-- SQL_SELECT_N_CONTENT_CATEGORY_COUNT

               SELECT count(*) totalCount, content.category
                 FROM (SELECT @state := '2') userState,
                      golfclub.content
                      LEFT JOIN golfclub.video video ON content.video_seq = video.seq
                WHERE content.category in (0204,0205)
                  AND content.type = 1
                  AND video.is_nScreen = TRUE
                  AND content.state >= @state
                  AND IF(@state = 3, now() between content.service_start_date and content.service_stop_date, now() < content.service_stop_date)
             GROUP BY content.category
             ORDER BY content.category;