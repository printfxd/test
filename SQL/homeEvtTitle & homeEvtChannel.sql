SELECT * FROM golfclub.home_evt;
SELECT * FROM golfclub.home_evt_title;
SELECT * FROM golfclub.home_evt_channel;

-- @@@@@@@@@@@@@@@@  home_evt_title  @@@@@@@@@@@@@@@@

-- step1. get evtSeq from home_evt
   SELECT seq AS evtSeq
     FROM golfclub.home_evt evt 
	WHERE now() BETWEEN service_start_date AND service_stop_date 
      AND state >= 2
 ORDER BY evt.order;



   SELECT seq AS evtSeq
     FROM golfclub.home_evt evt,
          (SELECT @homeEventState := '1') homeEventState
	WHERE IF(@homeEventState = '2',
		      now() BETWEEN service_start_date AND service_stop_date,
			  now() < service_stop_date
            )
      AND evt.state >= @homeEventState
 ORDER BY evt.service_start_date, evt.order;



-- step2. get evtTitle from evtSeq
-- chEventSeq, chEventTitle, imageSeq, preImageSeq, videoUrl, chEventType, duration
SELECT homeEvtSeq, chEventSeq, chEventTitle, imageSeq, preImageSeq, videoUrl, chEventType, duration
FROM (
   SELECT CAST(@row_num := IF(@prev_value=evtTitle.home_evt_seq,@row_num+1,1) AS UNSIGNED) AS chEventSeq,
          evtTitle.home_evt_seq AS homeEvtSeq,
          CONCAT(IF(evtTitle.state = 2, '[＊]', ''),evtTitle.title) AS chEventTitle,
          evtTitle.type AS chEventType,
		   IF('sd' = @resolution, evtTitle.sd_small_img_seq, evtTitle.hd_small_img_seq) AS preImageSeq,
          IF(evtTitle.type = '1', IF('sd' = @resolution, evtTitle.sd_full_img_seq, evtTitle.hd_full_img_seq), '') AS imageSeq,
          IF(evtTitle.type = '2',
          CASE '1N' WHEN '1N' then CONCAT(sys.play_uri_1N, evtTitle.play_asset_1N)
					  WHEN '1C' then CONCAT(sys.play_uri_1C, evtTitle.play_asset_1C)
					  WHEN '1S' then CONCAT(sys.play_uri_1S, evtTitle.play_asset_1S)
					  WHEN '2N' then CONCAT(sys.play_uri_2N, evtTitle.play_asset_2N)
					  WHEN '2S' then CONCAT(sys.play_uri_2S, evtTitle.play_asset_2S)
		   END,
          '') AS videoUrl,
          evtTitle.duration AS duration,
          @prev_value := evtTitle.home_evt_seq
     FROM golfclub.home_evt_title evtTitle,
          (
		       SELECT seq AS evtSeq
                FROM golfclub.home_evt evt,
                     (SELECT @homeEventState := 1) homeEventState
			    WHERE IF(@homeEventState = 2,
					       now() BETWEEN service_start_date AND service_stop_date,
					       now() < service_stop_date
                     )
                 AND state >= @homeEventState
            ORDER BY evt.service_start_date, evt.order
          ) evt,
          (SELECT * FROM golfclub.system_conf) sys,
		   (SELECT @resolution := 'sd') resolution,
          (SELECT @row_num := 1) x,
		   (SELECT @prev_value := '') y
    WHERE evtTitle.home_evt_seq = evt.evtSeq
      AND evtTitle.state >= 2
 ORDER BY evtTitle.home_evt_seq, evtTitle.order
) subquery;



-- @@@@@@@@@@@@@@@@  home_evt_channel  @@@@@@@@@@@@@@@@

-- step1. get evtSeq from home_evt
   SELECT seq AS evtSeq
     FROM golfclub.home_evt evt 
	WHERE now() BETWEEN service_start_date AND service_stop_date 
      AND state >= 2
 ORDER BY evt.order;

-- step2. get evtChannel from evtSeq
      SELECT home_evt_seq, channel_seq
        FROM golfclub.home_evt_channel evtChannel,
             (
		       SELECT seq AS evtSeq
				  FROM golfclub.home_evt evt 
	            WHERE now() BETWEEN service_start_date AND service_stop_date 
				   AND state >= 2
			  ORDER BY evt.order
             ) evt
       WHERE home_evt_seq = evt.evtSeq
     ORDER BY evtChannel.home_evt_seq, evtChannel.order;



-- step3. get CH data from EvtChannel.evtChSeq
-- seq, chNumber, chName, chMulticastUrl, chLogoSeq, isHD, chOrderStatus

SELECT    EvtChannel.evtSeq AS evtSeq,
          CH.seq,
          CH.number AS chNumber,
          CH.name AS chName,
          IF('1' = '1', CH.multicast_ip_omp, CH.multicast_ip_iap) AS chMulticastUrl,
          IF('sd' = 'sd', CH.sd_logo_img_seq, CH.hd_logo_img_seq) AS chLogoSeq,
          CAST(IF(TRUE = CH.is_HD, '1', '0') AS UNSIGNED) AS isHD
     FROM golfclub.channel CH,
          (
              SELECT home_evt_seq AS evtSeq, channel_seq AS evtChSeq, evtChannel.order As evtOrder
                FROM golfclub.home_evt_channel evtChannel,
                    (
		                 SELECT seq AS evtSeq
                          FROM golfclub.home_evt evt,
                               (SELECT @homeEventState := '1') homeEventState
	                      WHERE IF(@homeEventState = 2,
								       now() BETWEEN service_start_date AND service_stop_date,
								       now() < service_stop_date
								   )
                            AND state >= @homeEventState
                       ORDER BY evt.service_start_date, evt.order
                    ) homeEvt
              WHERE home_evt_seq = homeEvt.evtSeq
		    ORDER BY evtChannel.home_evt_seq, evtChannel.order
          ) EvtChannel 
     WHERE CH.disabled = FALSE
       AND CH.seq = EvtChannel.evtChSeq
  ORDER BY EvtChannel.evtSeq, EvtChannel.evtOrder;


-- 