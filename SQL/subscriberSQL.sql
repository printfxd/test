-- 2012/10/04 portable
SELECT subscriber_id AS subscriberId, 
       phone, 
       IF(phone is null,0,IF(LENGTH(phone) = 0,0,1)) AS telStatus,  
       service_start_date AS serviceStartDate, 
       service_stop_date AS serviceStopDate,
       state AS orderStatuscourse_promotion, 
       area, 
       role,
       memo,
       golf_ch_state AS golfChStatus,
	    SYS.golfChMulticastUrl
  FROM golfclub.subscriber,
       (SELECT IF('1' = '1', golf_ch_multicast_ip_omp, golf_ch_multicast_ip_iap) AS golfChMulticastUrl FROM golfclub.system_conf) SYS
 WHERE subscriber_id = '72162076';

INSERT INTO golfclub.subscriber (subscriber_id, service_start_date, service_stop_date, state, golf_ch_state, area, role, memo, update_date) VALUES ('20122099', null, null, '0', '0', '1', '0', 'UserLoginApi', now());

-- 2012/11/13 nscreen

  SELECT phone, role AS testUser, state AS orderStatus, service_stop_date AS golfclubStopTime
    FROM golfclub.subscriber
   WHERE phone = '0928800457'
ORDER BY role;

-- 2012/12/5

INSERT INTO `golfclub`.`channel_order_state`
(`subscriber_id`, `channel_id`, `ch_order_state`, `service_start_date`, `service_stop_date`)
SELECT '72162076', '2', '0', null, null
FROM dual
WHERE not exists (SELECT * FROM `golfclub`.`channel_order_state` WHERE channel_id = '2');




INSERT INTO `golfclub`.`subscriber` 
(subscriber_id, service_start_date, service_stop_date, state, area, role, memo, update_date)
SELECT '00000000', null, null, '0', '1', '0', 'Sekoan', now()
FROM dual
WHERE not exists (SELECT * FROM `golfclub`.`subscriber` WHERE subscriber_id = '00000000');

SELECT * FROM `golfclub`.`subscriber` WHERE subscriber_id = '00000000';
