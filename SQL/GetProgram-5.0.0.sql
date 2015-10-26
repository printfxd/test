-- SQL_SELECT_VIDEO_BY_CATEGORY
		    SELECT CAST(@row_num := IF(@prev_value = subquery.category, @row_num + 1, 1) AS UNSIGNED) AS serialNo,
                  subquery.videoSeq, 
                  subquery.newsID, 
                  subquery.title, 
                  subquery.stopDate, 
                  subquery.imageSeq, 
                  subquery.previewUrl, 
                  subquery.videoUrl, 
                  subquery.isNew,
                  @prev_value := subquery.category AS category
             FROM (SELECT @row_num := 1) x,
                  (SELECT @prev_value := '') y,
                  (
                      SELECT '' AS videoSeq,
                             news.seq AS newsID,
                             IF(content.state = '2', concat('＊', news.title), news.title) AS title,
                             content.service_stop_date AS stopDate,
                             IFNULL(IF(@resolution = 'sd', news.pre_sd_img_seq, news.pre_hd_img_seq), '') AS imageSeq,
                             '' AS previewUrl,
                             '' AS videoUrl,
                             IF(datediff(now(), content.service_start_date) between 0 and 29, 1, 0) AS isNew,
                             content.category,
                             content.service_start_date AS startDate,
                             content.order,
                             content.state
                        FROM golfclub.content AS content
                             LEFT JOIN golfclub.news AS news ON content.news_seq = news.seq
                       WHERE content.category in (0104)
                         AND content.type = 2
                         AND content.state >= @state
                         AND IF(@state = 3, now() between content.service_start_date and content.service_stop_date, now() < content.service_stop_date)
                      UNION ALL
                      SELECT video.seq AS videoSeq,
                             '' AS newsID,
                             IF(@state = '2', concat('＊', video.name), video.name) AS title,
                             content.service_stop_date AS stopDate,
                             IF(@resolution = 'sd', video.sd_img_seq, video.hd_img_seq) AS imageSeq,
                             CASE @platformArea 
                                 WHEN '1chtn' then (CONCAT(system.play_uri_1N, video.play_asset_1N))
                                 WHEN '1chtc' then (CONCAT(system.play_uri_1C, video.play_asset_1C))
                                 WHEN '1chts' then (CONCAT(system.play_uri_1S, video.play_asset_1S))
                                 WHEN '2chtn' then (CONCAT(system.play_uri_2N, video.play_asset_2N))
                                 WHEN '2chts' then (CONCAT(system.play_uri_2S, video.play_asset_2S))
                             END AS previewUrl,
                             CASE @platformArea 
                                 WHEN '1chtn' then (CONCAT(system.play_uri_1N, video.play_asset_1N))
                                 WHEN '1chtc' then (CONCAT(system.play_uri_1C, video.play_asset_1C))
                                 WHEN '1chts' then (CONCAT(system.play_uri_1S, video.play_asset_1S))
                                 WHEN '2chtn' then (CONCAT(system.play_uri_2N, video.play_asset_2N))
                                 WHEN '2chts' then (CONCAT(system.play_uri_2S, video.play_asset_2S))
                             END AS videoUrl,
                             IF(datediff(now(), content.service_start_date) between 0 and 29, 1, 0) AS isNew,
                             content.category,
                             content.service_start_date AS startDate,
                             content.order,
                             content.state
                        FROM (SELECT * FROM golfclub.system_conf) system,
                             (SELECT @platformArea := '1chtn') platformArea, -- ?
                             (SELECT @resolution := 'sd') resolution, -- ?
                             (SELECT @state := '2') userState, -- ?
                             golfclub.content AS content
                             LEFT JOIN golfclub.video AS video ON content.video_seq = video.seq
                       WHERE content.category in (0104)
                         AND content.type = 1
                         AND content.state >= @state
                         AND IF(@state = 3, now() between content.service_start_date and content.service_stop_date, now() < content.service_stop_date)
                  ) subquery
         ORDER BY subquery.category, subquery.state DESC, subquery.startDate DESC, subquery.order;

-- SQL_SELECT_VIDEO_CATEGORY_COUNT
               SELECT count(*) totalCount, category
                 FROM golfclub.content,
                      (SELECT @state := 2) state
                WHERE category in (0104)
                  AND state >= @state
                  AND IF(@state = 3, now() between service_start_date and service_stop_date, now() < service_stop_date)
             GROUP BY category
             ORDER BY category;