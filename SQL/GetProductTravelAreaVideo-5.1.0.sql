    SELECT travelVideo.seq,
           IF(travelVideo.state = '2', concat('＊', travelVideo.name), travelVideo.name) AS name,
           '' AS subName,
           IF(@resolution = 'sd', travelVideo.video_sd_img_seq, travelVideo.video_hd_img_seq) AS previewSeq,
           '2' AS dataType,
           IF(datediff(now(), travelVideo.service_start_date) between 0 and 7, 1, 0) AS hasDeco,
           travelVideo.order,
           '0' AS categoryType,
           CASE @platformArea 
               WHEN '1chtn' then (CONCAT(system.play_uri_1N, travelVideo.play_asset_1N))
               WHEN '1chtc' then (CONCAT(system.play_uri_1C, travelVideo.play_asset_1C))
               WHEN '1chts' then (CONCAT(system.play_uri_1S, travelVideo.play_asset_1S))
               WHEN '2chtn' then (CONCAT(system.play_uri_2N, travelVideo.play_asset_2N))
               WHEN '2chts' then (CONCAT(system.play_uri_2S, travelVideo.play_asset_2S))
           END AS previewUrl,
           CASE @platformArea 
               WHEN '1chtn' then (CONCAT(system.play_uri_1N, travelVideo.play_asset_1N))
               WHEN '1chtc' then (CONCAT(system.play_uri_1C, travelVideo.play_asset_1C))
               WHEN '1chts' then (CONCAT(system.play_uri_1S, travelVideo.play_asset_1S))
               WHEN '2chtn' then (CONCAT(system.play_uri_2N, travelVideo.play_asset_2N))
               WHEN '2chts' then (CONCAT(system.play_uri_2S, travelVideo.play_asset_2S))
           END AS videoUrl,
           '2' AS contentType,
           travelVideo.service_stop_date AS lastDay
      FROM (SELECT * FROM golfclub.system_conf) system,
           (SELECT @platformArea := '1chtn') platformArea,
           (SELECT @resolution := 'sd') resolution,
           (SELECT @state := '2') userState,
           golfclub.travel_video travelVideo
     WHERE travelVideo.travel_area_seq = 8
       AND travelVideo.state >= @state
  ORDER BY travelVideo.state DESC, travelVideo.service_start_date DESC, travelVideo.order;