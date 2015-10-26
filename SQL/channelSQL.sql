SELECT * FROM golfclub.channel;
-- ch:[{chNumber, chName, chMulticastUrl, chOrderStatus, chLogoSeq, isHD}]




   SELECT CH.seq,
          CH.number AS chNumber,
          CH.name AS chName,
          IF('1' = '1', CH.multicast_ip_omp, CH.multicast_ip_iap) AS chMulticastUrl,
          IF('sd' = 'sd', CH.sd_logo_img_seq, CH.hd_logo_img_seq) AS chLogoSeq,
          CAST(IF(TRUE = CH.is_HD, '1', '0') AS UNSIGNED) AS isHD
     FROM golfclub.channel CH
     WHERE CH.disabled = TRUE
 ORDER BY CH.order;


SELECT number FROM golfclub.channel ORDER BY number;


INSERT INTO `golfclub`.`channel_order_state`
(`subscriber_id`, `channel_seq`, `ch_order_state`, `service_start_date`, `service_stop_date`)
SELECT '72162076', '2', '0', null, null
FROM dual
WHERE not exists (SELECT * FROM `golfclub`.`channel_order_state` WHERE subscriber_id='' AND channel_seq = '2');

SELECT * FROM `golfclub`.`channel_order_state` WHERE subscriber_id = '72162076' AND channel_id = '2';



