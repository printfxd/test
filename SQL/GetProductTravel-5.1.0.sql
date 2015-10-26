    SELECT travel.seq,
           IF(travel.state = '2', concat('＊', travel.name), travel.name) AS name,
           '' AS subName,
           IF(@resolution = 'sd', travel.preview_sd_img_seq, travel.preview_hd_img_seq) AS previewSeq,
           '1' AS dataType,
           '0' AS hasDeco,
           '0' AS 'order',
           '2' AS categoryType
      FROM (SELECT @resolution := 'sd') resolution,
           (SELECT @state := '2') userState,
           golfclub.product_travel travel
     WHERE travel.product_vendor_seq = '3'
       AND travel.state >= @state;