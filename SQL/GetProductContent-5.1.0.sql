    SELECT product.seq,
           IF(product.state = '2', concat('＊', product.name), product.name) AS name,
           '' AS subName,
           IF(@resolution = 'sd', product.preview_sd_img_seq, product.preview_hd_img_seq) AS previewSeq,
           '2' AS dataType,
           CASE product.category
               WHEN '1' then (0)               
               WHEN '2' then (1)
               WHEN '3' then (IF(datediff(now(), product.service_start_date) between 0 and @newsLimit, 1, 0))
           END AS hasDeco,
           product.order,
           '0' AS categoryType,
           IF(type = 1,
               CASE @platformArea 
                   WHEN '1chtn' then (CONCAT(system.play_uri_1N, product.play_asset_1N))
                   WHEN '1chtc' then (CONCAT(system.play_uri_1C, product.play_asset_1C))
                   WHEN '1chts' then (CONCAT(system.play_uri_1S, product.play_asset_1S))
                   WHEN '2chtn' then (CONCAT(system.play_uri_2N, product.play_asset_2N))
                   WHEN '2chts' then (CONCAT(system.play_uri_2S, product.play_asset_2S))
               END,
               ''
           ) AS previewUrl,
           IF(type = 1,
               CASE @platformArea 
                   WHEN '1chtn' then (CONCAT(system.play_uri_1N, product.play_asset_1N))
                   WHEN '1chtc' then (CONCAT(system.play_uri_1C, product.play_asset_1C))
                   WHEN '1chts' then (CONCAT(system.play_uri_1S, product.play_asset_1S))
                   WHEN '2chtn' then (CONCAT(system.play_uri_2N, product.play_asset_2N))
                   WHEN '2chts' then (CONCAT(system.play_uri_2S, product.play_asset_2S))
               END,
               ''
           ) AS videoUrl,
           product.type AS contentType,
           product.service_stop_date AS lastDay
      FROM (SELECT * FROM golfclub.system_conf) system,
           (SELECT @platformArea := '1chtn') platformArea,
           (SELECT @resolution := 'sd') resolution,
           (SELECT @state := '2') userState,
           (SELECT @newsLimit := '7') newsLimit,
           golfclub.product_content product
     WHERE product.product_vendor_seq = 8
       AND product.state >= @state
  ORDER BY product.state DESC, product.order;